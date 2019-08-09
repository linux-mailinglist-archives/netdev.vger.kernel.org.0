Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 493A187959
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 14:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406635AbfHIMFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 08:05:22 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:25842 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbfHIMFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 08:05:21 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79C37Ih030094;
        Fri, 9 Aug 2019 08:05:11 -0400
Received: from nam01-sn1-obe.outbound.protection.outlook.com (mail-sn1nam01lp2056.outbound.protection.outlook.com [104.47.32.56])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u7wxfqafq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 08:05:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9CuhzioBMTghXwnKtmsj0ZBci/RqIEbAGtdEd0vbNcqz683h7yNJv8Oghq1X+BI56ScH9oTHVkJWK65WRTaUEYoB78bY5BjhmT6hO6se2cvqc7R7HL/FRsWJ4bCrGOpkbSBsBM0/VqDjPqe9xIx0G6P+j7lK7i7oNVmnFK78XP4BB9OnvKhjFsghe3/km30YykG2JrjoBY3M3oGz/E+0864uMma4ghfx94RdyrLaJYIz6DTE1828To8F9zvNUT/SOEAlwndFIcVEYsb2pZg+DBrHI7V9+7a9ojw7hZFvee14UUAW3fpap9WGAxCW8N5vcSCQIMd0Ki9ErXgIBa5pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxUehEvBlg06gS+hcm9TsuMZ6ektJlvu1LjsBkSuTZs=;
 b=PfwxXTWQ45Ge8BKxb5zg+NZR8i/nAQO4xRjJuZxDDPnGG8oFvDoayiSqXMEQ4i9+7e9KEdHlmGKffG1bPE71Pt9im5V2BQ9lW+ozZhjVD74FmpO3/hLPfmDalQiL7VKcjUpAY3APGf3Fkzb+wh323I3zR8NKoZUoMyu1/52v2yaWpGkJ5lAxBN1/BYCYW9MEAtdkRaEwpXqDpWga1pgMODR1HQ4i98G0+gzZuFrYMPda6VDx/Z8/SzDEmyMhsuIEQkr0Wr8NheEWmekIX3uGVmy9hu6hU/28Ubcw0MrTRrDHUBwJP0Cg/OCLF4/X9wv1Zzm3QwgTUMXQG/B1vhEIHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxUehEvBlg06gS+hcm9TsuMZ6ektJlvu1LjsBkSuTZs=;
 b=f8wzaZBep+LQknl+MUGTU/VPxnS8Ue4gw0aJszXsnkrqYtRxHpTK+IXrApEgwGv/hKQd/rbFswy14ebHUDMG3cNIFaEuRuajxgs8TG9EEZCAyKqseu79VZKz8HYBAK7RicGtIvJsrIrbql1Ftr2uzdhpGwlAIk8GLA6vTI9v6GA=
Received: from DM5PR03CA0036.namprd03.prod.outlook.com (2603:10b6:4:3b::25) by
 CY4PR03MB2999.namprd03.prod.outlook.com (2603:10b6:903:136::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Fri, 9 Aug
 2019 12:05:09 +0000
Received: from SN1NAM02FT031.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::201) by DM5PR03CA0036.outlook.office365.com
 (2603:10b6:4:3b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14 via Frontend
 Transport; Fri, 9 Aug 2019 12:05:09 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 SN1NAM02FT031.mail.protection.outlook.com (10.152.72.116) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2157.15
 via Frontend Transport; Fri, 9 Aug 2019 12:05:08 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x79C55Ig006130
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Fri, 9 Aug 2019 05:05:05 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Fri, 9 Aug 2019 08:05:08 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v2 05/15] net: phy: adin: add {write,read}_mmd hooks
Thread-Topic: [PATCH v2 05/15] net: phy: adin: add {write,read}_mmd hooks
Thread-Index: AQHVTeUX2FrkDLZEiEqdpiMjfAPxUabxpQIAgAFXnoA=
Date:   Fri, 9 Aug 2019 12:05:07 +0000
Message-ID: <abd38b7cd509c6113f95d7a5e9361f5444dfb511.camel@analog.com>
References: <20190808123026.17382-1-alexandru.ardelean@analog.com>
         <20190808123026.17382-6-alexandru.ardelean@analog.com>
         <20190808153514.GE27917@lunn.ch>
In-Reply-To: <20190808153514.GE27917@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.113]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D7967BC458B5F4EA45B9BEA392DD10C@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(346002)(376002)(136003)(396003)(2980300002)(189003)(199004)(305945005)(86362001)(5640700003)(316002)(229853002)(70586007)(8936002)(5660300002)(2501003)(54906003)(70206006)(106002)(6246003)(11346002)(486006)(2616005)(436003)(14444005)(426003)(336012)(47776003)(126002)(476003)(6306002)(446003)(4326008)(76176011)(23676004)(6116002)(2486003)(186003)(966005)(2351001)(50466002)(102836004)(7636002)(7736002)(478600001)(26005)(356004)(118296001)(2906002)(6916009)(1730700003)(561944003)(36756003)(7696005)(246002)(14454004)(3846002)(8676002)(142933001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR03MB2999;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fea2a1b3-426e-41ce-58d4-08d71cc1d315
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR03MB2999;
X-MS-TrafficTypeDiagnostic: CY4PR03MB2999:
X-MS-Exchange-PUrlCount: 1
X-Microsoft-Antispam-PRVS: <CY4PR03MB29993F8934005609B4501CA2F9D60@CY4PR03MB2999.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 01244308DF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4ylXnIPyaWJkIsnGmDwoDiuwQ6CSKy5kbI+KZncGJMCxM+enDr3UjkZXXPsUIGWfL0VBDuHUF0GvgSIWEVfmrzzyoO3dSW9FyRscSNwZbwMsWBfyLnP7sqKNqbMQy/QLBhUetxMAIqbU2ghJ4gAN1pn+HYvwc+za8BZ42TbsQz7aNY3+SuOVW7UIf9ekNse5mKZDfbwsodG6WVX+Wn3YRXoWCvVZ3RlJrySjUhVUsfbLCliDnqKs5+tlnKRAo6UKniMXiCD/iXjVCPz06dIVbbWmV0ejDmSQVJdcr7kCleZ0gzOHkt51Y2HWTtPZLQOJn729iRuE3+m/W09f9DfUeAj5NhhK4HSS+Gr6oR9fVJoOTwsmyF0+gZwJbwAC37qCwQjLp7FHooQP60kwq6L9zhOS1I/nUl4/RyY2eQ6S024=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2019 12:05:08.7506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fea2a1b3-426e-41ce-58d4-08d71cc1d315
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR03MB2999
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=449 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA4LTA4IGF0IDE3OjM1ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gVGh1LCBBdWcgMDgsIDIwMTkgYXQgMDM6MzA6MTZQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IEJvdGggQURJTjEyMDAgJiBBRElOMTMw
MCBzdXBwb3J0IENsYXVzZSA0NSBhY2Nlc3MuDQo+ID4gVGhlIEV4dGVuZGVkIE1hbmFnZW1lbnQg
SW50ZXJmYWNlIChFTUkpIHJlZ2lzdGVycyBhcmUgYWNjZXNzaWJsZSB2aWEgYm90aA0KPiA+IENs
YXVzZSA0NSAoYXQgcmVnaXN0ZXIgTURJT19NTURfVkVORDEpIGFuZCB1c2luZyBDbGF1c2UgMjIu
DQo+ID4gDQo+ID4gSG93ZXZlciwgdGhlIENsYXVzZSAyMiBNTUQgYWNjZXNzIG9wZXJhdGlvbnMg
ZGlmZmVyIGZyb20gdGhlIGltcGxlbWVudGF0aW9uDQo+ID4gaW4gdGhlIGtlcm5lbCwgaW4gdGhl
IHNlbnNlIHRoYXQgaXQgdXNlcyByZWdpc3RlcnMgRXh0UmVnUHRyICgweDEwKSAmDQo+ID4gRXh0
UmVnRGF0YSAoMHgxMSkgdG8gYWNjZXNzIENsYXVzZSA0NSAmIEVNSSByZWdpc3RlcnMuDQo+IA0K
PiBJdCBpcyBub3QgdGhhdCB0aGV5IGRpZmZlciBmcm9tIHdoYXQgdGhlIGtlcm5lbCBzdXBwb3J0
cy4gSXRzIHRoYXQNCj4gdGhleSBkaWZmZXIgZnJvbSB3aGF0IHRoZSBTdGFuZGFyZCBzYXlzIHRo
ZXkgc2hvdWxkIHVzZS4gVGhlc2UNCj4gcmVnaXN0ZXJzIGFyZSBkZWZpbmVkIGluIDgwMi4zLCBw
YXJ0IG9mIEMyMiwgYW5kIHRoaXMgaGFyZHdhcmUNCj4gaW1wbGVtZW50cyB0aGUgc3RhbmRhcmQg
aW5jb3JyZWN0bHkuDQoNCldpbGwgdXBkYXRlIGNvbW1lbnQuDQpJIGRpZCBub3QgZmluZCBhIGRv
Y3VtZW50IGRlc2NyaWJpbmcgdGhpcyBhcyBhIHN0YW5kYXJkLg0KQnV0LCBJIGFkbWl0IEkgYW0g
dGVycmlibGUgd2hlbiBmaW5kaW5nIHNvbWUgZG9jcy4NCg0KSSBvbmx5IGZvdW5kIHRoaXMgcHJl
c2VudGF0aW9uIGZyb20gYSB3aGlsZSBiYWNrOg0KaHR0cDovL3d3dy5pZWVlODAyLm9yZy8zL2Vm
bS9wdWJsaWMvbm92MDIvb2FtL3Bhbm5lbGxfb2FtXzFfMTEwMi5wZGYNCg0KSXQgc2VlbWVkIG1v
cmUgbGlrZSBhIHByb3Bvc2FsLg0KDQpUaGFua3MNCkFsZXgNCg0KPiANCj4gCSAgIEFuZHJldw0K
