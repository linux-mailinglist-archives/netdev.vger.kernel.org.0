Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C44282C0A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731867AbfHFGvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:51:09 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:28574 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731576AbfHFGvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:51:09 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766llvX032458;
        Tue, 6 Aug 2019 02:50:59 -0400
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2057.outbound.protection.outlook.com [104.47.44.57])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6yamrw3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:50:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVqzUZcz6VDuGllbYcOPRyxL0suHfQFnBjTxPO4tai4pb8cOo4NvCDn+Siwp95lUG6WgBxco10Ekjo/a3e76MvDEUUzgWwZmymOU4YmEeE/tvNiGXXE88VZqYdochGO/ZQBW9X8kuFfSDbXaTc4Yy00LO/m7NCvG4MJYK1sDwBdpF6Dlqm8xn+002OkLuk/COsW8Gs5ol8rhpjOugcFWy0Rj0RY/8jxS/TzFmP0Zmku2b7pvEl9prkBopDAHi+UaUO0l2P4jZmmCYKJcYpGDxS5S7+gJhoWdxg/+XOc5S49OlkihVDDxGAMW0O9cYFd/s9LQfufL7NUoFbMk+QMoiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUKMDek9sdlI1iSLL+P07/Cbzz5SSLO/6fWv5/HqoxU=;
 b=JHdIBhJaV78TBuuTFc2G2f1J/DpOKatfcastSLHtoqz+VurhsUsc+etHPVDsZ5XZ4XL4mTmLqh2FtRrvQ5mCRccOKKv8vULsH4mFC5qmEq3MsvJvTIeQ+p3BtoKwL2xQK4L67akpdtckggc0YNCrx2Y+XJxrQuKXd6MYya6UnoJo1yE0iWc1ZN69DbVNv9MTvD81n7rIiQD92tNaYWIsZDe0k0pReeKalnaMgi4+3gULKNEr9HAA54uICDyKRaw+tbu/TH3FYa2H7+nidDyTP7M53MmhR/Fp7sC0kSAa6kvjZzN07PTyX35do57lt+ArwriXTin7hM1ajLgjsM88/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org smtp.mailfrom=analog.com;
 dmarc=bestguesspass action=none header.from=analog.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUKMDek9sdlI1iSLL+P07/Cbzz5SSLO/6fWv5/HqoxU=;
 b=iFwZ9yJlLz4WgRl1ABgAy+Vo6xtUgrvsNLGKvubpeYtCguDfL2EpQQxEM8FrXWbVJGfW0dfOKw3JGpRZE/6XbZ6Sb8/fxR0hWsaISOD4QqwkZ+piC62W6jnoUmAUkuaXnpbjHwZMiTt9L7XJSYxQZuC4zfgb8EWihIfT0Hg/gcA=
Received: from BN6PR03CA0013.namprd03.prod.outlook.com (2603:10b6:404:23::23)
 by BN7PR03MB3443.namprd03.prod.outlook.com (2603:10b6:406:c4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.14; Tue, 6 Aug
 2019 06:50:57 +0000
Received: from SN1NAM02FT029.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::209) by BN6PR03CA0013.outlook.office365.com
 (2603:10b6:404:23::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.16 via Frontend
 Transport; Tue, 6 Aug 2019 06:50:57 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 SN1NAM02FT029.mail.protection.outlook.com (10.152.72.110) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:50:56 +0000
Received: from NWD2HUBCAS8.ad.analog.com (nwd2hubcas8.ad.analog.com [10.64.69.108])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x766ouWJ011381
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:50:56 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS8.ad.analog.com ([fe80::90a0:b93e:53c6:afee%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:50:56 -0400
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
Subject: Re: [PATCH 11/16] net: phy: adin: PHY reset mechanisms
Thread-Topic: [PATCH 11/16] net: phy: adin: PHY reset mechanisms
Thread-Index: AQHVS5VwsM/Y+4XfkkaZmn2osBlePabs7PwAgAE3xoA=
Date:   Tue, 6 Aug 2019 06:50:55 +0000
Message-ID: <149db19df9517acf81529c726d74b594f40272b1.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-12-alexandru.ardelean@analog.com>
         <20190805151500.GP24275@lunn.ch>
In-Reply-To: <20190805151500.GP24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A98CC07634F627488585BFB9A3D02152@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(396003)(346002)(2980300002)(199004)(189003)(126002)(70206006)(70586007)(2616005)(36756003)(47776003)(476003)(54906003)(14444005)(305945005)(7636002)(7736002)(50466002)(486006)(6116002)(3846002)(316002)(8676002)(2501003)(336012)(118296001)(186003)(106002)(478600001)(23676004)(6246003)(1730700003)(7696005)(2486003)(356004)(14454004)(5660300002)(446003)(11346002)(436003)(86362001)(246002)(2351001)(5640700003)(76176011)(6916009)(426003)(26005)(4326008)(229853002)(8936002)(2906002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR03MB3443;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26372a79-42ce-4f2d-052b-08d71a3a6f50
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(4709080)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN7PR03MB3443;
X-MS-TrafficTypeDiagnostic: BN7PR03MB3443:
X-Microsoft-Antispam-PRVS: <BN7PR03MB3443C99D8E57AF806A514B47F9D50@BN7PR03MB3443.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: f+zFTrTOpyZOxiChWvORca6VEGpN0SXAR2/pDu2qAjTaTYIsswq38eMcGIbCnOMLUJ2IG5xdqLRYpKvu+F48jYrP9e9z6SyvnhN+cLVam91clZU7zKt/l5jVZFI1+/nh6LbKlQ27IX4sdOJjYzvBJ5hWsmBs6Ou+KAfsb4e/1vVcS3M9MkvbcSvWsFU/GV1dLAxhpg44OSClMot1K2NADqhdy7SjKQ3nW0qmEMWigMdlIIUrBYPNfzEtUAB83Sw9QZR0eZuAgBKKlDmtinMsGe2IvSvbu56Pr+shqyJkMBa4W3oOt9Gov+w2vGUtUW9bFFZjKoNJ7k1yleNu7CqbQcm9z1UsWov3r1K2X918662TNFJpKP689scJaT3bfbI5P7q4NhlHukMDNfFWiRCSviWTyKa1RFJxlk5uBtQv4N8=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:50:56.9761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26372a79-42ce-4f2d-052b-08d71a3a6f50
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR03MB3443
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=766 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE3OjE1ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NDhQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoZSBBRElOIFBIWXMgc3VwcG9ydHMg
NCB0eXBlcyBvZiByZXNldDoNCj4gPiAxLiBUaGUgc3RhbmRhcmQgUEhZIHJlc2V0IHZpYSBCTUNS
X1JFU0VUIGJpdCBpbiBNSUlfQk1DUiByZWcNCj4gPiAyLiBSZXNldCB2aWEgR1BJTw0KPiA+IDMu
IFJlc2V0IHZpYSByZWcgR2VTZnRSc3QgKDB4ZmYwYykgJiByZWxvYWQgcHJldmlvdXMgcGluIGNv
bmZpZ3MNCj4gPiA0LiBSZXNldCB2aWEgcmVnIEdlU2Z0UnN0ICgweGZmMGMpICYgcmVxdWVzdCBu
ZXcgcGluIGNvbmZpZ3MNCj4gPiANCj4gPiBSZXNldHMgMiAmIDQgYXJlIGFsbW9zdCBpZGVudGlj
YWwsIHdpdGggdGhlIGV4Y2VwdGlvbiB0aGF0IHRoZSBjcnlzdGFsDQo+ID4gb3NjaWxsYXRvciBp
cyBhdmFpbGFibGUgZHVyaW5nIHJlc2V0IGZvciAyLg0KPiA+IA0KPiA+IFJlc2V0dGluZyB2aWEg
R2VTZnRSc3Qgb3IgdmlhIEdQSU8gaXMgdXNlZnVsIHdoZW4gZG9pbmcgYSB3YXJtIHJlYm9vdC4g
SWYNCj4gPiBkb2luZyB2YXJpb3VzIHNldHRpbmdzIHZpYSBwaHl0b29sIG9yIGV0aHRvb2wsIHRo
ZSBzdWItc3lzdGVtIHJlZ2lzdGVycw0KPiA+IGRvbid0IHJlc2V0IGp1c3QgdmlhIEJNQ1JfUkVT
RVQuDQo+ID4gDQo+ID4gVGhpcyBjaGFuZ2UgaW1wbGVtZW50cyByZXNldHRpbmcgdGhlIGVudGly
ZSBQSFkgc3Vic3lzdGVtIGR1cmluZyBwcm9iZS4NCj4gPiBEdXJpbmcgUEhZIEhXIGluaXQgKHBo
eV9od19pbml0KCkgbG9naWMpIHRoZSBQSFkgY29yZSByZWdzIHdpbGwgYmUgcmVzZXQNCj4gPiBh
Z2FpbiB2aWEgQk1DUl9SRVNFVC4gVGhpcyB3aWxsIGFsc28gbmVlZCB0byBoYXBwZW4gZHVyaW5n
IGEgUE0gcmVzdW1lLg0KPiANCj4gcGh5bGliIGFscmVhZHkgaGFzIHN1cHBvcnQgZm9yIEdQSU8g
cmVzZXQuIFNvIGlmIHBvc3NpYmxlLCB5b3Ugc2hvdWxkDQo+IG5vdCByZXBlYXQgdGhhdCBjb2Rl
IGhlcmUuDQo+IA0KPiBXaGF0IGlzIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gYSBHUElPIHJlc2V0
LCBhbmQgYSBHUElPIHJlc2V0IGZvbGxvd2VkDQo+IGJ5IGEgc3Vic3lzdGVtIHNvZnQgcmVzZXQ/
DQoNCnRoZXJlIHNob3VsZG4ndCBiZSBhbnkgZGlmZmVyZW5jZTsNCml0J3MganVzdCAyIGNvbnNl
Y3V0aXZlIHJlc2V0czsNCmknbGwgdGFrZSBhIGNsb3NlciBsb29rIGF0IHBoeWxpYidzIEdQSU8g
cmVzZXQgYW5kIHNlZQ0KDQo+IA0KPiAgICBBbmRyZXcNCg==
