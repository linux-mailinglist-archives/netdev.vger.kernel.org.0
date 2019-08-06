Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5C5C82C26
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbfHFG6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:58:05 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:16876 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731557AbfHFG6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:58:05 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766m6uK011870;
        Tue, 6 Aug 2019 02:57:34 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2056.outbound.protection.outlook.com [104.47.45.56])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6kb22yf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:57:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+RyVnmQrCJddaZBOPk+5lpwVdRt+KmhPpt+uxBTz79FqWh3e5pTqASmIMbzgJl313k/PR/8t3cHsWg1QnCUMI23l6TwbMnx486s7rb6gjvDVCKumx+T/nFY5wkZKLVFzm5ZTMxVxCdo/bSojutKAEnGIsRp9cN9ub6gqtkYUz+PQxtmkeMq9eqWUXmFxiWVsf+NWwHTKTWUCmqMEMYW2d4NbXNoaqkaZG+14idyG2mGyQsH4Vx5ZLD3Q6ncATBpOv4QdUuawWxdxSB2f4anzR4NjQqC6LVFR0fdW23R6T6QIrGA/CtlaPBmXHtnHUwriAdaBcswq0JHPPotFJwhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdcyYnMbJ6NgD5Pe/iuNwdXLSKFvaQ8ed/h8wz9W//M=;
 b=JSAcEGEn30VtJRQQm/ixRGZiR32uVjhafdOObs9wjSyeARGjeKcgSQY3tuodNu8MJMw1kxmQyAREYiVD1clVw12mSbAwOtuTYNl7fS7uwq5Lxa6OCgSJAB/NpHZGkbLQWuwAM+4xHkdZjWz9X0sYORKlfeRqpA/azNURxmbpmqXkHkaJ+VuUt/RIi7rLwc+Fxf6GVJwtagKbycunfAYlcsfcsfQn2sUC+rlTdUQlAvSGrfrLfWtM2Yl5F7yQT1fU/tqak7UUvbxdJsLCvkafj5aL0r7ju2xIrDK7Lf3gNpWpJemOVjEq4FgQEVv4/yZTZKYrqkp11C3dsU/iJKYkMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdcyYnMbJ6NgD5Pe/iuNwdXLSKFvaQ8ed/h8wz9W//M=;
 b=SNIMOXSOXEDmo4NLhJNg/GP0bELlZX8CkvS2Gel4EtFV8vhKXwz8E2Qazy7CqNJ4x3MPLif+uEEcc/bm8PkmjZJPgfjBRNi8CumIogSSC9BiKAC93MGdJ+n/VK3+6zYHyRVm6hPy+Or/qpF06Boiyl2gjK49M/31R8HB3FMdNFo=
Received: from MWHPR03CA0048.namprd03.prod.outlook.com (2603:10b6:301:3b::37)
 by BYAPR03MB3654.namprd03.prod.outlook.com (2603:10b6:a02:ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 06:57:22 +0000
Received: from CY1NAM02FT008.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::200) by MWHPR03CA0048.outlook.office365.com
 (2603:10b6:301:3b::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2136.16 via Frontend
 Transport; Tue, 6 Aug 2019 06:57:22 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT008.mail.protection.outlook.com (10.152.75.59) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:57:21 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766vISF016201
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:57:18 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:57:20 -0400
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
Subject: Re: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY driver
Thread-Topic: [PATCH 16/16] dt-bindings: net: add bindings for ADIN PHY
 driver
Thread-Index: AQHVS5V2ZSE3cdVgKEeipKzrb+Dq2Kbs39MAgAFGuYA=
Date:   Tue, 6 Aug 2019 06:57:19 +0000
Message-ID: <0ad30bdc3afcab962e011af1bd56529a150f08f6.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-17-alexandru.ardelean@analog.com>
         <20190805142754.GL24275@lunn.ch>
In-Reply-To: <20190805142754.GL24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A95A09C0E777DE4C953218E3D6B97AB2@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(39860400002)(376002)(2980300002)(199004)(189003)(3846002)(70586007)(70206006)(2351001)(5660300002)(356004)(86362001)(478600001)(2501003)(126002)(36756003)(476003)(6916009)(426003)(8936002)(2616005)(446003)(6246003)(11346002)(50466002)(336012)(436003)(53376002)(486006)(1730700003)(8676002)(7736002)(102836004)(7636002)(7696005)(47776003)(246002)(229853002)(106002)(54906003)(2906002)(4326008)(186003)(6306002)(316002)(6116002)(5640700003)(966005)(118296001)(26005)(14444005)(14454004)(305945005)(76176011)(23676004)(2486003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB3654;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1125fe0d-0f62-4bc2-b78d-08d71a3b54c3
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB3654;
X-MS-TrafficTypeDiagnostic: BYAPR03MB3654:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <BYAPR03MB3654C74A835399DDCCF5DE55F9D50@BYAPR03MB3654.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: /ZCDpnH1CwHZjmKuNneBZl8+lyFlFJr1cSyQcv5ZqzdhdcotF0wq8iT43vHW0kkbxfwrvaV24qBEOYdFyuQSAFwxApvG8GpQUfSnYY/gDFJMp+0XlyT12nOYZ3yr1UQnRQ4JWNHmlw00AMZhmrAlyoGZX/anrlI43FX6LZ1XBF+83Iy6V5Yn1HNQEcudbvNb3tPbazqyEUZGnCodbHHH5pG3nD4J8SNqiDuhLWLMixU8MbhhwOpYs/oV+nU/8a791cpf/bSwytOM/jYb/0Yu0Way7n1aFJt3HHHz0bvnDjWb0aPJPwWhNUGARW4OPmgXWTsNv7ZG7lZGfokb33fBGBRGRIqjLqTPTJu4BDAueJI8mT1bjYDqjlGERNQa5r7OHZEtmTK5lTTUfFiAHvW6I7Hotmut8s7yftjcOdDdLME=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:57:21.8475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1125fe0d-0f62-4bc2-b78d-08d71a3b54c3
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3654
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060077
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE2OjI3ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NTNQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoaXMgY2hhbmdlIGFkZHMgYmluZGlu
Z3MgZm9yIHRoZSBBbmFsb2cgRGV2aWNlcyBBRElOIFBIWSBkcml2ZXIsIGRldGFpbGluZw0KPiA+
IGFsbCB0aGUgcHJvcGVydGllcyBpbXBsZW1lbnRlZCBieSB0aGUgZHJpdmVyLg0KPiA+IA0KPiA+
IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFuZHJ1LmFyZGVsZWFuQGFu
YWxvZy5jb20+DQo+ID4gLS0tDQo+ID4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9hZGks
YWRpbi55YW1sICAgICB8IDkzICsrKysrKysrKysrKysrKysrKysNCj4gPiAgTUFJTlRBSU5FUlMg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDIgKw0KPiA+ICBpbmNsdWRlL2R0
LWJpbmRpbmdzL25ldC9hZGluLmggICAgICAgICAgICAgICAgfCAyNiArKysrKysNCj4gPiAgMyBm
aWxlcyBjaGFuZ2VkLCAxMjEgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQg
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9hZGksYWRpbi55YW1sDQo+ID4g
IGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2R0LWJpbmRpbmdzL25ldC9hZGluLmgNCj4gPiAN
Cj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9h
ZGksYWRpbi55YW1sDQo+ID4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L2FkaSxhZGluLnlhbWwNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAw
MDAwMDAwMC4uZmNmODg0YmI4NmY3DQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL0RvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvYWRpLGFkaW4ueWFtbA0KPiA+IEBAIC0w
LDAgKzEsOTMgQEANCj4gPiArIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCsNCj4g
PiArJVlBTUwgMS4yDQo+ID4gKy0tLQ0KPiA+ICskaWQ6IGh0dHA6Ly9kZXZpY2V0cmVlLm9yZy9z
Y2hlbWFzL25ldC9hZGksYWRpbi55YW1sIw0KPiA+ICskc2NoZW1hOiBodHRwOi8vZGV2aWNldHJl
ZS5vcmcvbWV0YS1zY2hlbWFzL2NvcmUueWFtbCMNCj4gPiArDQo+ID4gK3RpdGxlOiBBbmFsb2cg
RGV2aWNlcyBBRElOMTIwMC9BRElOMTMwMCBQSFkNCj4gPiArDQo+ID4gK21haW50YWluZXJzOg0K
PiA+ICsgIC0gQWxleGFuZHJ1IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNv
bT4NCj4gPiArDQo+ID4gK2Rlc2NyaXB0aW9uOiB8DQo+ID4gKyAgQmluZGluZ3MgZm9yIEFuYWxv
ZyBEZXZpY2VzIEluZHVzdHJpYWwgRXRoZXJuZXQgUEhZc3BoeQ0KPiA+ICsNCj4gPiArcHJvcGVy
dGllczoNCj4gPiArICBjb21wYXRpYmxlOg0KPiA+ICsgICAgZGVzY3JpcHRpb246IHwNCj4gPiAr
ICAgICAgQ29tcGF0aWJsZSBsaXN0LCBtYXkgY29udGFpbiAiZXRoZXJuZXQtcGh5LWllZWU4MDIu
My1jNDUiIGluIHdoaWNoIGNhc2UNCj4gPiArICAgICAgQ2xhdXNlIDQ1IHdpbGwgYmUgdXNlZCB0
byBhY2Nlc3MgZGV2aWNlIG1hbmFnZW1lbnQgcmVnaXN0ZXJzLiBJZg0KPiA+ICsgICAgICB1bnNw
ZWNpZmllZCwgQ2xhdXNlIDIyIHdpbGwgYmUgdXNlZC4gVXNlIHRoaXMgb25seSB3aGVuIE1ESU8g
c3VwcG9ydHMNCj4gPiArICAgICAgQ2xhdXNlIDQ1IGFjY2VzcywgYnV0IHRoZXJlIGlzIG5vIG90
aGVyIHdheSB0byBkZXRlcm1pbmUgdGhpcy4NCj4gPiArICAgIGVudW06DQo+ID4gKyAgICAgIC0g
ZXRoZXJuZXQtcGh5LWllZWU4MDIuMy1jNDUNCj4gDQo+IEl0IGlzIHZhbGlkIHRvIGxpc3QgZXRo
ZXJuZXQtcGh5LWllZWU4MDIuMy1jMjIsIGl0IGlzIGp1c3Qgbm90DQo+IHJlcXVpcmVkLiBTbyBt
YXliZSB5b3Ugc2hvdWxkIGxpc3QgaXQgaGVyZSB0byBrZWVwIHRoZSBEVCB2YWxpZGF0ZXIgaGFw
cHk/DQoNCmFjaw0KDQo+IA0KPiAJICBBbmRyZXcNCg==
