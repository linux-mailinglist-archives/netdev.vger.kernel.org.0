Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B796B88A8
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 03:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjCNCck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 22:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNCci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 22:32:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2CF4484;
        Mon, 13 Mar 2023 19:32:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32DNsesS003279;
        Tue, 14 Mar 2023 02:32:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wuVnC2sjF497tXiRMNSdOynwx80oTEuoRQlIw548adk=;
 b=O4iOIPS6w5iC7kr3O+PkU6nyAjY6n710uBQYBGwa7DQbkcFkBXXMDqA9/H8du7PgtvMG
 fXwW9N7d2/gaaXtoBS4TQgF9NFLZK3s0ijL0yJAN8xCG0fdC/2BtACiyJx8ImqUM0+TO
 7yahmyO4ZlBimcFq/QTy12MH4WeFGk3I+05TWxHrzKhhiGD0/BWAEcPgHKSl9D/BaJST
 5QZUu0F9gx23uF8nzTB+aKZrc+X0uVqsH7FgtHiPQru+B1qIT+ggxzIqU2J017kIkhIZ
 wnsguTRuWYdyvRE5pXjy3ehtQGDuPq0Hz7CyuyvFQ0BdIBDiMZ+xbxWhw37iOG/M5+oo kA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8h8td8u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 02:32:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32E0Ykfc002501;
        Tue, 14 Mar 2023 02:32:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g3c0urv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 02:32:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2TXMbbf0dronGLxDMOdVCeuduCHeqBIPj/9ah5J+6COcftyS/C2XTADsJY8wcjXJD87nbAZQFKykC0VmdtpLQxiioBxtYvrxwPesXXYYFJ75Y45cjwqb+o5EhYz+OT/AhKyLAG9tCKNiAS7F07VidBmuemq7Ex6YFUrnMFWyT8fbS0x6SpJPIkwS5rzC0x03fYIomEzNLZKCRYzoMYRwA+W9s5IVUlzQxsSo+2bD4mEBxUJIPpD2FX5AojgWPErRXLFfOLiTu0iaZeldUxOxi3/U5HwE7AH4iLKgkpabv1DQPShfEMC3zyW4nK5iBued1Ii5gBhX4yrnr/FA23Efg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuVnC2sjF497tXiRMNSdOynwx80oTEuoRQlIw548adk=;
 b=OHK9r5Y+kPg+WkaVVArBDYPCN+digj7E58pcq8jHRjYXajSmx3IcvvWrqcxJ+SQHPekOTdFKxwB9N9MMLzZbupVyhnAGOgJ8FcHLMpsQZA90aeHIJjho5N22a0WlvEzP59xQvEvafoc/WozGyampIkGMd/n+/NUHAq1tEyjufSIexP8mTJtHZe6p45u08mpv9asOBj1mf/LMtVAX6X9VAXStyt+i0IeDmz0NwAnlLap/iMjKGLHqygQIaX/qRgfrilBglOh9Qwpm61+ILRRcuzMyF9tK80nywXf7DEJ3jmuk0r5P01ISyQokkSN4tQrvH3K21PdFtqrlhEYX5u2YvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wuVnC2sjF497tXiRMNSdOynwx80oTEuoRQlIw548adk=;
 b=mek7jA2h3tPBrKSasAot7imM/Wu5LsApIoL8xG8CStoBcVTw4oPX5vL6xz+9/aCVxxyxphOxPcYJJB8dPPAjMcj/gSeyk4RsrNr5EKU1mHdt5ST45JVpZ1Gk9OJJA26le+hp3bSnwf1l0Vb8S+KlySmPakXfUxdgc6QonNGY/L4=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by PH7PR10MB7034.namprd10.prod.outlook.com (2603:10b6:510:278::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 02:32:14 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%4]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 02:32:13 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Topic: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Index: AQHZU53jvr0f3jRxyk20sGUEtokB+a75b4CAgAAhVuA=
Date:   Tue, 14 Mar 2023 02:32:13 +0000
Message-ID: <BY5PR10MB41295AF42563F023651E109FC4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
        <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
 <20230313172441.480c9ec7@kernel.org>
In-Reply-To: <20230313172441.480c9ec7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|PH7PR10MB7034:EE_
x-ms-office365-filtering-correlation-id: 034c823d-604b-429d-55ef-08db24345236
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bJPbeiNnHbycNWBrK0SCj+PHSvlyHxe+39P0oS1jRGT9zprfNBALRtA4di5cVCUfyKv9zEPBnGI9DgQIrWgczkWb+omJUovC9qeHpm2ujLGr9yXezsJaBpLz1ByhCL/1vyfzrsKwo1C3pAOIWmPcLAf6u2hK6BWAcsvF3wRVdXesWS6kgtmKJtNq1UI3VgvZbFKx7ME54z3O7Z1lXa+o04bYfA61EX5QYYHVu9bfFJ9vgVXR2+KUS71ncTvXQzdq4HPhZ9YmhEQPNhctj+KxIlEllUlxRljpcNTiTdgW1qrXWjmcaFjPXJkMr1rZtD7oCyhD+q1LCJ3Y+vvt5SoR7Op9FIZfJfwR3nsUP8QieiwFc3eXDwmJs1WrMyxTQeX8OdNg1tkB7Q+zu2XD/KElpa0q9qnpDfz4qpIsN+o+hSoHLLArbrCLFpV3jxsK3sqMnsNcx25auqTcOTFi9gHQcRA2V9JnnN4apR5GSTSQa3rtSfjTvq7aA6F31s9crJzZR3ZJBEdI4gLrgCYhUahwMHTLYkUHay1y57U2Fi1rBGbJahhnVbXXO2TTld8XEaCGdO095rWf2Q22vRV/QuwNvNlbo8SIlYeIsPbULaNX5ES16ywpb4fKoSu39ptNnAztk0rmXImbrR1AqJXEc49gcF5eT/JFHpIWpF7c84H3skbnI4U/fSSJ3ZW+BPxGpckVCODLb9GYj2fG2h6TUq2jHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(346002)(376002)(366004)(39860400002)(451199018)(122000001)(2906002)(83380400001)(7416002)(5660300002)(52536014)(66556008)(41300700001)(64756008)(66946007)(6916009)(8936002)(76116006)(33656002)(4326008)(54906003)(8676002)(66476007)(38070700005)(38100700002)(55016003)(86362001)(316002)(478600001)(186003)(66446008)(9686003)(71200400001)(7696005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?8v6ukTRsbg8wVEmYw7FJCjX5Chp9QT2lvWTrv2EOazvKSxC4JC7lDizgKj?=
 =?iso-8859-1?Q?xTd0NUSgz5yGLeYQzXu/1XIMi54lhiK6zvNpeuDuLVSVMAky/g89AGYZyq?=
 =?iso-8859-1?Q?oR2djAoc/1O88j7w3FXfbOZtW72kss1ajwSIdLG68nvnPB4JdFe4wy3HWk?=
 =?iso-8859-1?Q?xqBuCrfVYerMTQpmEVAqh0LQhGLCC4EWqu8m5CxbSTpYraASBOvCmtk559?=
 =?iso-8859-1?Q?DV2SbPh/sUBCKlcDyKPL8C2dxLWbzqbgtuxA8N9ffWDx5Nj/CJYqc2S8aF?=
 =?iso-8859-1?Q?RW1hc2rrqMTCV+q8U9i3ZukFfFqmUc7ojknpNFGp8jJiGyiTVr8pNKRUfP?=
 =?iso-8859-1?Q?7/CkewE04XYBqNXx8t6tgKfWcIJlo2tXgWXSQWTMdZmhTQhLr+mWe3fC92?=
 =?iso-8859-1?Q?zjQOvKo5/I/uf/D9BKCQzr3kQQ7qoR8stDk+/I7qrt9GmYKHNESzLCNR6r?=
 =?iso-8859-1?Q?kbpVjJdly7k235eRwPCwQaatyuiscD2UZWpBQotLmI9QnOvgo5+xsQ1dav?=
 =?iso-8859-1?Q?VAJGATrk3Y+s0HOY4nAD0Er5HZtH/KyN+7hTOzGLVz2/q5hksXRsK5lWw3?=
 =?iso-8859-1?Q?EK1ad6k5l5B1SztDFlTLfAwdaiaM3PzkNzyK0JUhhVfobp6ZNVyiMHI0Tp?=
 =?iso-8859-1?Q?S5JHd6Rb0H7wheqx1puWodqBc94UmzixefspfBAWJu1B2TUPMXNzfIt3Dd?=
 =?iso-8859-1?Q?y79Wt7G4CwldGhWyBp7xZ9211Cy0voLPvZ1OX0OAeCDra5L1pzKHJZLZWM?=
 =?iso-8859-1?Q?HFZbLKwVnYHHoLr7T+6zss0avBJBMZ8pZDnHOgjGT9PSumV9LEvXG7+AF6?=
 =?iso-8859-1?Q?gkAGMxJLb9yH2yFua+PRjaAtPYTHeXBk2pfHuokHlxznkaupREj21XGyd4?=
 =?iso-8859-1?Q?sU2dHaIUtp7OQ1ao6YvayaezWBnnIEFAGO5SvucCSHRI4h5BuC5s1AeZNa?=
 =?iso-8859-1?Q?gXr0y4n/HSoSoZmDloP7imUHasPnvIxdNJhDktlTR8p1qR6vUVLUeNfDKy?=
 =?iso-8859-1?Q?zEBb/PzExzWt6GGM5bYrslL0TsVwhnf0+doJkVp06GDx+5G2MNjDSYw51S?=
 =?iso-8859-1?Q?T5UgkbxtBBf6e4Eq32L8yx9aUZH8Arn+Ejmwz+fEqn8M01ALtuiuN9xPb+?=
 =?iso-8859-1?Q?AKUDGTnl7JaWMvaQW2kIiZKBDkZCRckzqnQJfZhiYO3Mp6hhclR8sduRxn?=
 =?iso-8859-1?Q?UlxTP47/sqmvTEXaye8gBW7QzOIW/qtsI3kc6rQbXhXRglq6xWV4WMEim7?=
 =?iso-8859-1?Q?8c4GJweEzny/ovXB5Pv/TUwhUGhBG8VerK6Aj9Rb5KZj6CWO0DW6rp9WwK?=
 =?iso-8859-1?Q?sRZYptUs66bMn+rFR58R8LBRXUNBq4pOfIJ+qMxFq7lHyWLfYEyDkqBRGK?=
 =?iso-8859-1?Q?cqchQD8Q0/AluPeuTwOkRncgYMqkGbew1XbA+frDctMwPUTO/KfTmDRGSI?=
 =?iso-8859-1?Q?DM9opPP3lnw/Q1H4dOzsngLgI7MuPCrIeyUsZEAEXuTrz6/ecgpKf/drhp?=
 =?iso-8859-1?Q?eHhR0umry4HCbp0u4v6nzJPU4WAMHX6JGx2QAL7bstvknjF/fK5ioNmo+R?=
 =?iso-8859-1?Q?jYY3/Z63eazdBPrg7lLeaPFCEKWpfm+6kjZKDq7vXg5Se8RyobzlZm9eJi?=
 =?iso-8859-1?Q?AjoHVqg2cwjMsqF/I0DHVWE7g420Bbn4tGqxDSiBazDmsDyD9itkVZcRpM?=
 =?iso-8859-1?Q?1e7Q57UOekMoRCEKoek=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?m83XIW7pvxE3VjahJ1Aiju+YQu0I+XZAOQvCO+l8fasB7gHbVP7xmWlRfe?=
 =?iso-8859-1?Q?kBimQQVLWqquuhocO/tUnwUAUhcXq+Pl7EGwGtEeBabiOQ8Qv53DWQJVVa?=
 =?iso-8859-1?Q?P5iipSq2LA1E4JXaQf5YqbXNUv4NQbC+7SNnMGjZg3ZFBPL2e8khpkBpVP?=
 =?iso-8859-1?Q?uRfUNuEdLEne1U6o8tOnqqCcVi47Wh9aJEVXTUbJcS8JjTSlFk2P0FzyKR?=
 =?iso-8859-1?Q?U+t5V5HZO0oKd/HdUz2KgoXtPwiEqf0hDTvILHjMtcaxW2wCAQXogXWXvl?=
 =?iso-8859-1?Q?gDWBxTO+aTrpfkzCwmwl1OesAiQIB97593RKmpiZEi0BKU+GnB6cwd24lt?=
 =?iso-8859-1?Q?F191BMUXX5Ea8Vyza+ijQg17mtI3vMcf4OEe1Zbu3wDO2w0bms3pJ84y0R?=
 =?iso-8859-1?Q?64rtHbhSPINxL7lgyCficxBN/iYo1hL+h4o3gNseHc0I62vTZUGhqLZdAl?=
 =?iso-8859-1?Q?BKTzmOaxSyzo0DVO4RuuyXob5gbDmOW+2hbqOiie7JaVJ3q6qije4jnmm0?=
 =?iso-8859-1?Q?NddId30s4Fok+llmk61VZinDPjmJH53Z4LrADXWmGqiaw/rmacYScicWaL?=
 =?iso-8859-1?Q?nPOzzRe5Vw+jx03AjbsVTQbp2OJwiy6zv5fVzl8/Bo8aLLht4V4HM5jhYY?=
 =?iso-8859-1?Q?q3jsCrtKNzk4uTIAby1hUOPl7jX2+dKsJvtL7Vq8LllXwRvX7YN9Y4pK78?=
 =?iso-8859-1?Q?LiU6OxKRQyXaLZrRqZFeXZpVimJNc+dHTlVTyCc60xqaLIXx6hj/C1okBg?=
 =?iso-8859-1?Q?CZY1jQ+aLlR43LSdsF7OLUq/b1Sg+hOaWBKXDGeBaL+3vbBq0nDwDyT7lr?=
 =?iso-8859-1?Q?xa3X8rdFFeuWQuXQyjudW69PwnK43Mmz2CWTmGbQuPsDGS9D5nwQ0FN2VQ?=
 =?iso-8859-1?Q?gtAwh3V5eLd8y5x67YxxXF8WgubdM5FTX6jXhKPnvHNJlSLNemuFqFofHo?=
 =?iso-8859-1?Q?mq4NjpFESvddjSUcM+BxNPDkXC/VFszhb9tMJpIUvgm56k4eKeSK4l/y9Y?=
 =?iso-8859-1?Q?EkEf2u12NQdO94tPwtqzL/XjJ095fMf4Gf2TlviQE4y6wKgxW2en30hoOg?=
 =?iso-8859-1?Q?6LYbqm/sJwDb651GCyZgUkf5hA6Pq12gnPE2mT0doGm3R+I482BRwzLp2p?=
 =?iso-8859-1?Q?YcQteHxw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034c823d-604b-429d-55ef-08db24345236
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 02:32:13.9092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j39ORd5lS4bBIiTG0pN288D1G8nf/LyMBSHvthVJCPaLWMZrjDS/MmlpvjsdhsboRSWOpQwvyOar150Y+t+eevbyjY6O6bJtYm7MdXGk9iM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-13_13,2023-03-13_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140020
X-Proofpoint-ORIG-GUID: CdWk1uNA4Gbi22HGjgAJSCGrWR57h7pB
X-Proofpoint-GUID: CdWk1uNA4Gbi22HGjgAJSCGrWR57h7pB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> -int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 gr=
oup, gfp_t gfp_mask);=0A=
> +int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 u32 grou=
p, gfp_t gfp_mask,=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int (*fi=
lter)(struct sock *dsk, struct sk_buff *skb,=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 void *data),=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 void *fi=
lter_data);=0A=
=0A=
kdoc needs to be extended=0A=
ANJALI> Thanks, will update in next revision.=0A=
=0A=
> -=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (sk->sk_protocol =3D=3D NETLINK_=
CONNECTOR) {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (test_bi=
t(CN_IDX_PROC - 1, nlk->groups)) {=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 kfree(sk->sk_user_data);=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 sk->sk_user_data =3D NULL;=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 for (i =3D 0; i < nlk->ngrou=
ps; i++)=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (=
test_bit(i, nlk->groups))=0A=
>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 nlk->netlink_unbind(sock_net(sk), i + 1);=0A=
=0A=
This is clearly a layering violation, right?=0A=
Please don't add "if (family_x)" to the core netlink code.=0A=
ANJALI> Yes, it is, but there does not seem a very clean way to do it other=
wise and I saw a check for protocol NETLINK_GENERIC just below it, so used =
it for connector as well. There is no release or free callback in the netli=
nk_sock. Is it ok to add it? There was another bug (for which I have not ye=
t sent a patch) in which, we need to decrement proc_event_num_listeners, wh=
en client exits without calling IGNORE, else that count again gets out of s=
tatus of actual no of listeners. =0A=
The other option is to add a flag in netlink_sock, something like NETLINK_F=
_SK_USER_DATA_FREE, which will free the sk_user_data, if this flag is set. =
But it does not solve the above scenario.=0A=
.=
