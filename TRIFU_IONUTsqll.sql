--ACEST PROIECT PRESUPUNE DEZVOLAREA UNEI BAZE DE DATE, NUMITE 'FIRMA' PRIN POPULAREA DE TABELE, 
--APLICAREA UNOR FUNCTII ASUPRA CAMPURILOR POPULATE SI, ASTFEL, ASIGURAREA IN PRIVINTA
--FUNCTIONALITATII ACESTEIA




CREATE DATABASE Firma
GO


USE FIRMA
GO

--Tabela Departamente
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DEPARTAMENTE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[DEPARTAMENTE]
GO

CREATE TABLE DEPARTAMENTE (
 IdDept int PRIMARY KEY IDENTITY,
 Denumire varchar(30) NOT NULL
)
GO


-- Tabela Functii
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FUNCTII]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FUNCTII]
GO

CREATE TABLE FUNCTII (
 IdFunctie int PRIMARY KEY IDENTITY,
 Denumire varchar(30) NOT NULL,
 Salariu int CHECK (Salariu > 0)
)
GO


-- Tabela Angajati
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ANGAJATI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ANGAJATI]
GO

CREATE TABLE ANGAJATI (
 IdAngajat int PRIMARY KEY IDENTITY,
 Nume varchar(20) NOT NULL,
 Prenume varchar(20) NOT NULL,
 Marca int NOT NULL UNIQUE,
 DataNasterii date,
 DataAngajarii date,
 Adresa_jud varchar(20) NOT NULL,
 IdFunctie int NOT NULL,
 IdDept int NOT NULL
)
GO


-- Tabela Clienti
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CLIENTI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CLIENTI]
GO

CREATE TABLE CLIENTI (
 IdClient int PRIMARY KEY IDENTITY,
 Denumire varchar(20) NOT NULL,
 Tip_cl varchar(10) NOT NULL, -- PF, PFA, SRL, SA, RA
 Adresa_jud varchar(20) NOT NULL
)
GO


-- Tabela Categorii_prod
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CATEGORII_PROD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CATEGORII_PROD]
GO

CREATE TABLE CATEGORII_PROD (
 IdCateg int PRIMARY KEY IDENTITY,
 Denumire varchar(20) NOT NULL
)
GO


-- Tabela Produse
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PRODUSE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PRODUSE]
GO

CREATE TABLE PRODUSE (
 IdProdus int PRIMARY KEY IDENTITY,
 Denumire varchar(36) NOT NULL,
 IdCateg int NOT NULL
)
GO


-- Tabela Vanzari
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[VANZARI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[VANZARI]
GO

CREATE TABLE VANZARI (
 IdVanzare int PRIMARY KEY IDENTITY,
 IDProdus int NOT NULL,
 IDClient int NOT NULL,
 IDVanzator int NOT NULL,
 DataVanz date DEFAULT GetDate(),
 NrProduse int DEFAULT 1 CHECK (NrProduse > 0),
 PretVanz int CHECK (PretVanz > 0)
)
GO

USE FIRMA
GO

-- Chei straine in tabela Angajati
ALTER TABLE ANGAJATI 
 ADD CONSTRAINT FK_ANGAJATI_DEPARTAMENTE FOREIGN KEY (IdDept) 
REFERENCES DEPARTAMENTE(IdDept);
GO

ALTER TABLE ANGAJATI 
 ADD CONSTRAINT FK_ANGAJATI_FUNCTII FOREIGN KEY (IdFunctie) 
REFERENCES FUNCTII(IdFunctie);
GO


-- Chei straine in tabela Vanzari
ALTER TABLE VANZARI 
 ADD CONSTRAINT FK_VANZARI_ANGAJATI FOREIGN KEY (IdVanzator) 
REFERENCES ANGAJATI(IdAngajat);
GO

ALTER TABLE VANZARI 
 ADD CONSTRAINT FK_VANZARI_CLIENTI FOREIGN KEY (IdClient) 
REFERENCES CLIENTI(IdClient);
GO

ALTER TABLE VANZARI 
 ADD CONSTRAINT FK_VANZARI_PRODUSE FOREIGN KEY (IdProdus) 
REFERENCES PRODUSE(IdProdus);
GO


ALTER TABLE PRODUSE 
 ADD CONSTRAINT FK_PRODUSE_CATEGORII_PROD FOREIGN KEY(IdCateg)
REFERENCES CATEGORII_PROD(IdCateg)
GO


Use Firma
GO

-- Populare tabela Departamente
INSERT INTO Departamente (Denumire) VALUES ('MANAGEMENT');
INSERT INTO Departamente (Denumire) VALUES ('PRODUCTIE');
INSERT INTO Departamente (Denumire) VALUES ('PROIECTARE');
INSERT INTO Departamente (Denumire) VALUES ('VANZARI');
INSERT INTO Departamente (Denumire) VALUES ('FINANCIAR-CONTAB');
INSERT INTO Departamente (Denumire) VALUES ('PERSONAL-SALARIZARE');
GO

-- Populare tabela Functii
INSERT INTO Functii (Denumire, Salariu) VALUES ('MANAGER', 10000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('DIRECTOR', 8000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('INGINER', 5000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ANALIST FINANCIAR', 4000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ECONOMIST', 3500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('TEHNICIAN', 3500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ASISTENT MANAGER', 3500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('ASISTENT DIRECTOR', 3000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('MUNCITOR CALIFICAT', 2000)
INSERT INTO Functii (Denumire, Salariu) VALUES ('MUNCITOR NECALIFICAT', 1500)
INSERT INTO Functii (Denumire, Salariu) VALUES ('JURIST', 3500)
GO


--INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
-- VALUES ('N8', 'P1', 24, '10/15/1955', '10/15/2005', 'Bucuresti', 
-- (SELECT IdFunctie FROM Functii WHERE Denumire = 'Inginer'), 
-- (SELECT IdDept FROM DEpartamente WHERE Denumire = 'Productie'));

-- Populare tabela Angajati
-- Manager
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N1', 'P1', 1, '10/15/1955', '10/15/2005', 'Bucuresti', 1, 1);

-- Director Productie
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N2', 'P2', 2, '10/20/1981', '10/15/2006', 'Bihor', 2, 2);
-- Director Proiectare
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N3', 'P3', 3, '7/25/1980', '7/17/2009', 'Ilfov', 2, 3);
-- Director Vanzari
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N4', 'P4', 4, '01/01/1998', '12/31/2020', 'Cluj', 2, 4);
-- Director Financiar-Contab
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N5', 'P5', 5, '02/15/1962', '12/12/2019', 'Cluj', 2, 5);
-- Director Personal-Salarizare
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N6', 'P6', 6, '05/05/1964', '05/06/2018', 'Arad', 2, 6);
GO

-- Personal Management
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept)
 VALUES ('N7', 'P7', 7, '08/12/1975', '09/16/2010', 'Cluj', 3, 2);
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N8', 'P8', 8, '05/10/1977', '08/26/2011', 'Galati', 6, 2);
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N9', 'P9', 9, '07/17/1975', '12/12/2010', 'Vaslui', 9, 2)
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N10', 'P10', 10, '09/09/1985', '05/30/2012', 'Bucuresti', 9, 2);
GO

-- Personal Proiectare
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N11', 'P9', 11, '07/17/1976', '12/12/2014', 'Cluj', 3, 3)
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N12', 'P2', 12, '09/09/1981', '05/30/2015', 'Cluj', 3, 3);
GO

-- Personal vanzari
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N13', 'P9', 13, '07/17/1979', '12/12/2014', 'Cluj', 5, 4)
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N12', 'P13', 14, '09/09/1980', '05/30/2015', 'Cluj', 5, 4);
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N8', 'P5', 15, '07/17/1983', '12/12/2016', 'Bihor', 5, 4)
GO

-- Personal Financiar-Contab
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N16', 'P1', 16, '03/17/1980', '01/12/2013', 'Cluj', 4, 5)

-- Personal Personal-Salariz
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N12', 'P15', 17, '03/17/1981', '01/12/2014', 'Cluj', 4, 6)

-- Asistent manager
INSERT INTO ANGAJATI(Nume, Prenume, Marca, DataNasterii, DataAngajarii, Adresa_jud, IdFunctie, IdDept) 
 VALUES ('N22', 'P38', 18, '10/15/1995', '10/15/2016', 'Bucuresti', 7, 1);
GO

-- Populare tabela Clienti
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Vitacon', 'Cluj', 'PFA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Mediagalacsy', 'Cluj', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Franco', 'Bucuresti', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Artex', 'Sibiu', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Liodl', 'Cluj', 'SA');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Dedemun', 'Bacau', 'SA');
GO

INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Ion', 'Cluj', 'SRL');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Maria', 'Salaj', 'SRL');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Ana', 'Maramures', 'SRL');
INSERT INTO CLIENTI(Denumire, Adresa_jud, Tip_cl) VALUES ('Brusli', 'Bihor', 'SRL');
GO


-- Populare tabela Categorii_Prod
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Cable');
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Adaptoare');
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Alimentatoare');
INSERT INTO CATEGORII_PROD(Denumire) VALUES ('Modulatoare FM');
GO


-- Populare tabela Produse
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-USB, 0.5m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-USB, 1m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-USB, 2m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-mini USB, 0.5m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-micro USB, 0.5m', 1);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Cablu USB-micro USB-C, 0.5m', 1);
GO
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Adaptor USB-mini USB', 2);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Adaptor USB-micro USB', 2);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Adaptor USB-micro USB-C', 2);
GO
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 220V-5V USB 1o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 220V-5V USB 2o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 220V-5V USB 3o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 12V-5V USB 1o', 3);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Alimentator 12V-5V USB 2o', 3);
GO
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Modulator FM, USB', 4);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Modulator FM, Bluetooth', 4);
INSERT INTO PRODUSE(Denumire, IDCateg) VALUES ('Modulator FM, USB, Bluetooth', 4);
GO


-- Populare tabela Vanzari
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (1, 1, 13, '05/01/2016', 5, 6);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (2, 2, 14, '05/01/2016', 3, 9);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (4, 3, 14, '06/02/2016', 10, 8);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (5, 5, 15, '06/02/2016', 1, 9);
GO

INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (7, 7, 13, '06/02/2016', 5, 16);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (8, 2, 14, '06/02/2018', 2, 19);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (8, 8, 14, '07/03/2018', 5, 18);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (9, 9, 15, '07/03/2019', 11, 19);
GO

INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (10, 1, 13, '07/04/2019', 5, 26);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (11, 3, 14, '07/04/2016', 2, 29);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (13, 10, 14, '08/05/2020', 5, 28);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (15, 10, 13, '08/05/2019', 11, 39);
GO

INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (16, 1, 14, '08/06/2023', 3, 26);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (17, 8, 13, '08/06/2022', 2, 29);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (16, 8, 13, '09/07/2019', 1, 38);
INSERT INTO VANZARI(IDProdus, IDClient, IDVanzator, DataVanz, NrProduse, PretVanz)
 VALUES (17, 7, 15, '09/07/2020', 1, 39);
GO




--Exercitii cu adăugări de constrângeri--

-- Să se introducă o constrângere ce verifică că în câmpul Tip_cl din tabela Clienti se pot introduce numai valorile: PF, PFA, SRL, SA. Să se verifice funcționarea constrângerii.
alter table Clienti
add constraint nume_bun check (Tip_cl IN ('PF', 'PFA', 'SRL', 'SA'));


-- Să se introducă o constrângere ce verifică că în câmpul Data_vanz din tabela Vanzari nu se pot introduce date din viitor (se folosesc funcțiile GETDATE și DATEDIFF). Să se verifice funcționarea constrângerii
alter table vanzari 
add constraint data_curenta check  (DATEDIFF(DAY,GETDATE(),DataVanz) <=0);





--Exercitiu modificări structurale ale tabelului--
alter table PRODUSE

--Să se introducă un câmp nou (Cod_produs CHAR(6)) în tabela Produse ce admite numai  valori unice. Să se introduca produse noi cu date pentru Cod_produs.

add Cod_produs CHAR(6);

update Produse set Cod_produs = IdProdus * 12;

alter table PRODUSE
add constraint only unique(Cod_produs);






--Exercitii cu modificări de date din cadrul tabelelor--


-- Să se șteargă toți clienții dintr-un anumit judet.
delete from CLIENTI where Adresa_jud = 'Bistrita-Nasaud';

-- Să se șteargă toate vânzările mai vechi de 1 an.
delete from VANZARI where DATEDIFF(DAY,DataVanz,GETDATE())>365;


-- Să se șteargă angajații din departamentul PROIECTARE, angajați dupa 01.01.2018 (se folosește funcția DATEDIFF).
delete from ANGAJATI where IdDept = 3 AND  (DATEDIFF(DAY,'01-01-2018',DataAngajarii) <0);


-- Să se transfere toți angajații cu vechime mai mare de 5 ani, din departamentul PRODUCTIE în departamentul VANZARI.
update ANGAJATI set IdDept = 4 where IdDept = 2 AND (DATEDIFF(DAY,DataAngajarii,GETDATE()) > 5*365); 


-- Să se adauge secvența ’-v2’ (se folosește funcția CONCAT) la toate denumirile de produse cu valoarea cheii primare numere impare.
update PRODUSE set Denumire = concat (Denumire,'-v2') where IdProdus % 2 = 1; 


-- Să se modifice prețul de vânzare (creștere cu 10%) la toate produsele din categoria ADAPTOARE vândute în după o anumită dată.
update VANZARI set PretVanz = PretVanz + 0.1*PretVanz where IDProdus = 7 OR IDProdus = 8 OR IDProdus = 9 AND (DATEDIFF(DAY,DataVanz,GETDATE()) > 2*365)

--se creaza un view------------------------------------------------------------------------------------------------------------------------------------

CREATE VIEW vAngajati AS
SELECT A.IdAngajat, A.Nume, A.Prenume,
D.Denumire AS Departament,
F.Denumire AS Functie, F.Salariu, A.
DataNasterii, A.DataAngajarii
FROM Angajati A, Departamente D, Functii F
WHERE A.IdDept=D.IdDept AND A.IdFunctie=F.IdFunctie
GO
SELECT * FROM vAngajati
GO
--1. Care este media salariilor pe un departament specificat prin nume ?

SELECT NUME, PRENUME, AVG (Salariu) medSal
FROM vAngajati
WHERE Departament = 'PROIECTARE'
group by Nume, Prenume

--2. Care sunt mediile salariilor angajaților grupate pe funcții ?

SELECT AVG (Salariu) as  medSalaF
FROM vAngajati
group by Functie

--3. Care este cel mai mic/mare salariu din companie ?

SELECT MIN (Salariu) as MinSal
FROM vAngajati

--4. Care este cel mai mic/mare salariu dintr-un departament specificat ?

SELECT MIN (Salariu) as MinSalD
FROM vAngajati
WHERE Departament = 'PROIECTARE'

--5. Care sunt cele mai mici și cele mai mari salarii pe departamente ?
 SELECT MIN (Salariu) as Salariu_Minim_Dept, MAX (Salariu) as Salariu_Maxim_Dept
 FROM vAngajati
 group by Departament
 

 --6. Câți angajați sunt în fiecare departament ?

 SELECT COUNT (IdAngajat) as  numarare 
 FROM vAngajati 



 --7.Care este suma salariilor angajaților din fiecare departament ?
 SELECT SUM (Salariu) SumaSalariiDept
 FROM vAngajati
 group by Departament

 --8.Listați angajații, grupati pe departamente și vechimi (rotunjite la an) ?
 
 SELECT Nume, Prenume, Departament, datediff(day,DataAngajarii,getdate())/365 as AniAngajare
 FROM vAngajati
 order by Departament, Nume, Prenume, AniAngajare

 --9.Care sunt angajații, grupați pe funcții, ce au o vechime mai mare de 10 ani ?

 SELECT Functie, Nume, Prenume
 FROM vAngajati
 WHERE datediff(day,DataAngajarii,getdate())/365 >10
group by Functie, DataAngajarii, Nume, Prenume

 --10.. Care sunt angajații, grupați pe departamente, ce au vârsta de minim 30 ani ?
 SELECT Nume, Prenume, Departament
 FROM vAngajati
 WHERE datediff(day, DataNasterii,getdate())/365 >30
 group by Departament, Nume, Prenume

 --11. Care sunt departamentele care au media salariilor mai mare decat 3000 ?
 SELECT Departament, AVG(Salariu) SalMed
 FROM vAngajati
 group by Departament
 Having AVG(Salariu) > 3000






 ---------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------
 ---------------------------------------------------------------------------------------------------------------------------------------------

 --1. Care sunt angajații a căror funcții conține secvența de caractere ‘ngi’ ?

SELECT A.Nume, A.Prenume
FROM ANGAJATI A 
JOIN FUNCTII F ON F.IdFunctie = A.IdFunctie
WHERE( CHARINDEX('ngi', F.Denumire ) > 0)
ORDER BY A.Nume, A.Prenume


--2. Care sunt salariile din departamentul ‘PRODUCTIE’ și câți angajați au aceste salarii ?

SELECT D.Denumire, F.Salariu, COUNT(F.Salariu) as NR_SAL
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
JOIN FUNCTII F ON A.IdFunctie = F.IdFunctie
WHERE D.Denumire = 'PRODUCTIE'
GROUP BY F.Salariu, D.Denumire

--3. Care sunt cele mai mici/mari salarii din departamente ?

SELECT D.Denumire, F.Salariu, MIN(F.Salariu) as sal_min, MAX(F.Salariu) as sal_max
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
JOIN FUNCTII F ON A.IdFunctie = F.IdFunctie
GROUP BY F.Salariu, D.Denumire

--4.Care sunt produsele vândute într-o anumită perioadă de timp ?
SELECT V.DataVanz, P.IdProdus, P.Denumire
FROM VANZARI V
JOIN PRODUSE P ON V.IdProdus = P.IdProdus
WHERE V.DataVanz >'2016-05-01' AND V.DataVanz<'2021-08-06'
ORDER BY V.DataVanz, P.Denumire

--5. Care sunt clienții ce au cumpărat produse prin intermediul unui vânzător anume ?
SELECT V.IDClient, A.IdAngajat
FROM  ANGAJATI A
JOIN VANZARI V ON A.IdAngajat = V.IdVanzator
WHERE V.IDVanzator = 13
ORDER BY V.IDClient, A.IdAngajat

--6. Care sunt clienții ce au cumpărat două produse ?
SELECT V.IDClient, V.NrProduse, C.Denumire
FROM  VANZARI V
JOIN CLIENTI C ON V.IDClient = C.IdClient
WHERE V.NrProduse = 2
ORDER BY V.IDClient, V.NrProduse, C.Denumire

--7. Care sunt clienții ce au cumpărat cel puțin două produse ?
SELECT V.IDClient, V.NrProduse, C.Denumire
FROM  VANZARI V
JOIN CLIENTI C ON V.IDClient = C.IdClient
WHERE V.NrProduse > 2
ORDER BY C.Denumire, V.NrProduse


--8. Câți clienți au cumpărat (la o singură cumpărare) produse în valoare mai mare decât o sumă dată (de ex. 200) ?

SELECT  COUNT (C.IDClient) AS nr_clienti
FROM VANZARI V
JOIN CLIENTI C ON V.IDClient = C.IDClient
WHERE V.NrProduse * V.PretVanz > 200

--9. Care sunt clienții din CLUJ care au cumpărat produse în valoare mai mare de 200 ?
SELECT  C.Denumire
FROM VANZARI V
JOIN CLIENTI C ON V.IDClient = C.IDClient
WHERE V.NrProduse * V.PretVanz > 200 AND C.Adresa_jud = 'Bihor'
ORDER BY C.Denumire

--10. Care sunt mediile vânzărilor pe o anumită perioadă de timp, grupate pe produse ?
SELECT AVG(V.PretVanz * V.PretVanz) AS MED_PRT, P.Denumire, P.IdCateg
FROM VANZARI V
JOIN PRODUSE P ON V.IDProdus = P.IdProdus
WHERE V.DataVanz >'2016-05-01' AND V.DataVanz<'2021-08-06'
GROUP BY P.Denumire, P.IdCateg

--11. Care este numărul total de produse vândute pe o anumită perioadă de timp ?
SELECT  sum (V.NrProduse) numar_produ
FROM VANZARI V
JOIN PRODUSE P ON V.IdProdus = P.IdProdus
WHERE V.DataVanz >'2016-05-01' AND V.DataVanz<'2021-08-06'

--12. Care este numărul de total de produse vândute de un vânzător precizat prin nume ?

SELECT COUNT (V.NrProduse) as numb_max_vanzi
FROM  ANGAJATI A
JOIN VANZARI V ON A.IdAngajat = V.IdVanzator
WHERE A.Nume = 'N12' 

--13. Care sunt clienții ce au cumpărat produse în valoare mai mare decât media vânzărilor din luna august 2016 ?

SELECT C.Denumire
FROM VANZARI V
JOIN CLIENTI C ON V.IDClient = C.IdClient
GROUP BY C.Denumire
HAVING SUM(V.PretVanz * V.NrProduse) > (SELECT AVG (V.NrProduse * V.PretVanz)  AS PRTZ 
FROM VANZARI V
WHERE V.DataVanz > '2016-08-01' AND V.DataVanz < '2016-08-31')

--14. Care sunt produsele care s-au vândut la mai mult de un client ?

SELECT COUNT (V.IDClient) nmbr, P.Denumire
FROM VANZARI V
JOIN PRODUSE P ON V.IDProdus = P.IdProdus
JOIN CLIENTI C ON V.IDClient = C.IdClient
GROUP BY P.Denumire

--15. Care sunt vânzările valorice realizate de fiecare vânzător, grupate pe produse și clienți, cu subtotaluri ?
SELECT A.Nume, A.Prenume, P.Denumire, C.Denumire, SUM(V.NrProduse * V.PretVanz) as subtotal
FROM VANZARI V 
JOIN PRODUSE P ON V.IDProdus = P.IdProdus
JOIN CLIENTI C ON V.IDClient = C. IdClient
JOIN ANGAJATI A ON V.IDVanzator = A.IdAngajat
GROUP BY A.Nume, A.Prenume, P.Denumire, C.Denumire


----------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------

--1. Scrieți și testați o funcție care returnează angajații a căror funcții conține o secvență de caractere primită ca parametru?
create function dbo.afisareNume(@denFct varchar(30))
returns table
as
return 
select A.Nume, A.Prenume, F.Denumire
from ANGAJATI A
JOIN FUNCTII F on A.IdFunctie = F.IdFunctie
where F.Denumire LIKE '%'+ @denFct + '%'
select Nume, Prenume, Denumire from dbo.afisareNume('TO')

--2. Scrieți și testați o funcție care returnează salariile dintr-un departament primit ca parametru? Câți angajați beneficiază de fiecare salariu?
create function dbo.afisareAngajao(@denAnga varchar(30))
returns table
as
return 

SELECT  F.Salariu, COUNT(F.Salariu) as NR_SAL
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
JOIN FUNCTII F ON A.IdFunctie = F.IdFunctie
WHERE D.Denumire like '%'+ @denAnga + '%'

GROUP BY F.Salariu

select * from dbo.afisareAngajao('PRODUCTIE') 

--3.Scrieți și testați o funcție care returnează salariul minim și maxim dintr-un departament primit ca parametru?
create function dbo.afisareSalMm(@denDep varchar(30))
returns table
as
return
SELECT MIN(F.Salariu) as sal_min, MAX(F.Salariu) as sal_max
FROM ANGAJATI A
JOIN DEPARTAMENTE D ON A.IdDept = D.IdDept
JOIN FUNCTII F ON A.IdFunctie = F.IdFunctie
WHERE D.Denumire like'%'+ @denDep + '%'

select * from dbo.afisareSalMm('PROIECTARE')

--4. Scrieți și testați o funcție care returnează produsele vândute într-o anumită perioadă de timp? Limitele perioadei de timp sunt trimise ca parametri către funcție.
create function dbo.afisDat(@period DATE, @period1 DATE)
returns table
as
return
SELECT V.DataVanz, P.IdProdus, P.Denumire
FROM VANZARI V
JOIN PRODUSE P ON V.IdProdus = P.IdProdus
WHERE V.DataVanz > @period AND V.DataVanz < @period1
select * from dbo.afisDat('2015-08-21','2020-11-23')

--5. Scrieți și testați o funcție care returnează suma totală încasată de un vânzător al cărui nume este trimis ca parametru. 
--Scrieți si testați o funcție care se bazează pe prima și care verifică dacă suma depășește un anumit prag minim trimis ca parametru. 
--Afișați angajații care au vândut produse în valoare mai mare decât 100 RON.

create function dbo.afisANGA(@nume_persoana varchar(30), @prenume_persoana varchar (30))
returns int
as 
begin
declare @tot int
SELECT @tot = SUM(V.NrProduse * V.PretVanz) 
FROM VANZARI V
JOIN ANGAJATI A ON A.IdAngajat = V.IDVanzator
return(@tot);
end
print dbo.afisANGA('N12','P13')


CREATE function dbo.afisANGAhundred(@nume_pers varchar(30), @prenume_pers varchar(30), @minimul int)
returns int
as
begin
declare @check int
set @check = 0
if dbo.afisANGA(@nume_pers, @prenume_pers) > @minimul
begin
set @check = 1;
 end 
 return(@check)
 end

 go


SELECT DISTINCT A.Nume, A.Prenume 
FROM VANZARI V
JOIN ANGAJATI A ON A.IdAngajat = v.IDVanzator 
WHERE dbo.afisANGAhundred(A.Nume,A.Prenume,100) = 1




--6. Scrieți și testați o funcție care returnează cele mai vândute N produse, într-o anumită perioadă 
--de timp. Valoarea lui N și limitele perioadei de timp sunt trimise ca parametri către funcție.

CREATE FUNCTION dbo.firstn (@ver int, @period DATE, @period1 DATE)
returns table 
as 
return 
select top (@ver) P.Denumire, sum(V.NrProduse) as numar_vn
FROM Vanzari V 
JOIN Produse P on V.IdProdus = P.IdProdus 
WHERE V.DataVanz > @period AND V.DataVanz < @period1
group by P.Denumire
order by sum(V.NrProduse) desc
select * from dbo.firstn(5, '2015-08-21','2020-11-23')


--7. Scrieți și testați o funcție care returnează clienții ordonați descrescător după sumele cheltuite, 
--într-o anumită perioadă de timp ale cărei limite sunt trimise ca parametri

CREATE FUNCTION dbo.firstnC (@ver int, @period DATE, @period1 DATE)
returns table 
as 
return 
select top (@ver) C.Denumire, sum(V.NrProduse*PretVanz) as numar_vn
FROM Vanzari V 
JOIN CLIENTI c on V.IdProdus = C.IdClient 
WHERE V.DataVanz > @period AND V.DataVanz < @period1
group by C.Denumire
order by sum(V.NrProduse*PretVanz) desc
select * from dbo.firstnC(5, '2015-08-21','2020-11-23')


