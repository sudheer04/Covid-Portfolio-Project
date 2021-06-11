SELECT * FROM coviddeaths;
SELECT * FROM vaccinations;

-- Below is the Covid Death table to start with
SELECT location, date, population, total_cases, total_deaths
FROM coviddeaths
order by 1,2;

-- Total Cases vs Total Deaths
-- It'll showw the percentage of risk of death in India as dated
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From coviddeaths
Where location like 'India'
order by 1,2;

-- Total Cases vs Population
-- Shows what percentage of population is infected with Covid in INDIA
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentageInfected
From coviddeaths
Where location like 'India'
order by 1,2;

-- Countries with Highest Covid Positive Rate to Population
Select Location, Population, MAX(total_cases) as TotalCovidCases,  Max((total_cases/population))*100 as PercentageInfected
From coviddeaths
Group by Location
order by PercentageInfected desc;


-- GLOBAL NUMBERS i.e total counts

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
order by 1,2;


-- Total Population Vs Vaccinations
-- Using CTE to perform Calculation on Partition By Query
WITH PopvsVac (location, date, population, new_vaccinations, populationvaccinated) 
as
(
Select dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as populationvaccinated
From coviddeaths dea 
Join vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
 
)
Select *, (populationvaccinated/population)*100 as PerPopulationVacc
From PopvsVac;


-- Using Temp Table to execute the Total Population Vs Vaccinations Query

DROP temporary table if exists temp;
create temporary table temp 
-- INSERT into temp
Select dea.location, dea.date, dea.population, vac.new_vaccinations
,Sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as populationvaccinated
Fron coviddeaths dea 
Join vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date;
    
Select *, (populationvaccinated/population)*100 as PerPopulationVacc
From temp;






