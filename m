Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 427C282BBC
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731872AbfHFGf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:35:58 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:34858 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731560AbfHFGf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:35:58 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X82m018472;
        Tue, 6 Aug 2019 02:35:50 -0400
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2055.outbound.protection.outlook.com [104.47.45.55])
        by mx0b-00128a01.pphosted.com with ESMTP id 2u6yamruvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:35:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKLttHc1soowSMd3HCgO4tFtw8f2xyGFeLSYeQnaKXD/it/zr04ZvmRb6bh6TWkKU5rsJL8TY8kldzl7nROWoA02obZs9r9JT8ZLYqxlhsC36RN8TQy3kCkRIi2CyyjaLhCvdaXZx3Oy2W7XyqY/cKPpiQ4YqWGLezu5Y0GR+wTkpvZmZ1C7E2lbehbcM344xom3sidtNxCzYUtFR8wD6DHabl6ocAlvRkKZt6SbmzQibJcfkmzv8vpyYBEdV0B/1UDm6GTbnx1UrqENLZfUmhdmjjVH6vXmgOHKhCxujLrIix50unGwGHDSaN7fp8PoXDi3Yf3VyIiHNYD/iITFqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0m2EZxaRqYDTdxbsRRvuP84n+f7zGPmpbXzwrfcQn9Y=;
 b=TrSVA7udxtG17ZYUYf8rEFMudBY5YnqcoyHu3CxwIUYSh7BsIF4+NG1GR+nq6jDw8DDxiiIAdZh4lGoJBUEeTy5/5swJ6F10KUngH3X3xZMQA9/EzfFxKW3LsUQ0dNhTUBmkoUFSTvUGHvjgQB/93bfruhVPFJjmLQL5cuuXKVXiZNeOQXRQAzBae+w8pE1gnxvCSbzmeR9P7zd4owGn11VVFE8h7Uypg6OWVDtOwlLcI9Ql8tLp3KQ04dyvE8VB0gp29bOTYBvuPSzs4YN/6Gk2C3eYty1dHXHXbzS3PBQ2rCVrhmTy0+r/V8oZ4DtGCaWFxm4gq5fJMRTCZKzoPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0m2EZxaRqYDTdxbsRRvuP84n+f7zGPmpbXzwrfcQn9Y=;
 b=xYfm0LpvEMPJtj9yOPGc13zYpiDaqSVfGyTnfjNenVYpIVMg0aOH+0gG5PtIABQtXYuh8IX4lUIfNOnmxG38R6JIjnb3EGRmU5AUuKJIdEApuqrCqfTyfo8kIPjrI1u0KchJ2alSlKkvzQhb4PwOB8btE6dilniIkKYTFeyBQB0=
Received: from CY4PR03CA0106.namprd03.prod.outlook.com (2603:10b6:910:4d::47)
 by BN6PR03MB3186.namprd03.prod.outlook.com (2603:10b6:405:3c::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 06:35:48 +0000
Received: from CY1NAM02FT012.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::207) by CY4PR03CA0106.outlook.office365.com
 (2603:10b6:910:4d::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2157.13 via Frontend
 Transport; Tue, 6 Aug 2019 06:35:48 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT012.mail.protection.outlook.com (10.152.75.158) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:35:47 +0000
Received: from NWD2HUBCAS7.ad.analog.com (nwd2hubcas7.ad.analog.com [10.64.69.107])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766ZiwQ012130
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:35:44 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS7.ad.analog.com ([fe80::595b:ced1:cc03:539d%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:35:46 -0400
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH 01/16] net: phy: adin: add support for Analog Devices
 PHYs
Thread-Topic: [PATCH 01/16] net: phy: adin: add support for Analog Devices
 PHYs
Thread-Index: AQHVS5VjXT25F74l5kCSv2qgimoBNqbtS7SAgADU0YA=
Date:   Tue, 6 Aug 2019 06:35:45 +0000
Message-ID: <18373e90691cc41133a80dbbe25a737711bd4597.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-2-alexandru.ardelean@analog.com>
         <206ec97f-3115-9a2c-91a0-e5f7aec4a39e@gmail.com>
In-Reply-To: <206ec97f-3115-9a2c-91a0-e5f7aec4a39e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FCA4B40E5D1164E8E4C5D3F3643DC72@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(376002)(136003)(2980300002)(51914003)(189003)(199004)(70206006)(5660300002)(3846002)(7736002)(7696005)(23676004)(2486003)(2501003)(6116002)(102836004)(14454004)(50466002)(76176011)(36756003)(305945005)(2906002)(106002)(54906003)(356004)(110136005)(486006)(246002)(70586007)(4326008)(316002)(2201001)(7636002)(53546011)(6246003)(86362001)(8936002)(6306002)(336012)(2616005)(229853002)(47776003)(118296001)(426003)(436003)(186003)(26005)(478600001)(11346002)(966005)(8676002)(126002)(446003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR03MB3186;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a44b9e1-730e-47d4-4162-08d71a385138
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:BN6PR03MB3186;
X-MS-TrafficTypeDiagnostic: BN6PR03MB3186:
X-MS-Exchange-PUrlCount: 3
X-Microsoft-Antispam-PRVS: <BN6PR03MB3186EFB3D09DCBAFDE0EBC98F9D50@BN6PR03MB3186.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: CiK8roSgvKqfkUrzn1P9Dx8vcGPSKbxKyMpeNZz1ff4s43Uh5+28W/67bfI7J6vme9pDyLn23HghhwQg/cAbNI4qSK3Nr2BTgphRmlUd7tqZNx+vNovwGyVDfNJOY32QceK3r/MrEkMwZkX8sRTr2BEQsXuQeX4xk8MB3Rv7Ya9hDELDSlpL0mvf5t52Et7/dqPYu1GWShxtdsVh2dtqQsdJdv/jAnmSP1Auj5oACLJdu6sMvNo1wzpfEF8EEvpU3o0qfr1EH8btlQ1mm71TzcHQ8Vrn3iGXuiTYn1Beql0gisjI2qyRGmsUM1OdwkINHKKyRHG6aNxBAEYOBikA0SknMp9gehnQTZE3uCEFzx3ZnZc25SBxaGXMGvDJSdtqAkig9e0ZYaAKTJIwyhm3TjUqof1u5wb4rTRpPKzdMu0=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:35:47.3744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a44b9e1-730e-47d4-4162-08d71a385138
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR03MB3186
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDIyOjU0ICswMjAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IFtFeHRlcm5hbF0NCj4gDQo+IE9uIDA1LjA4LjIwMTkgMTg6NTQsIEFsZXhhbmRydSBBcmRl
bGVhbiB3cm90ZToNCj4gPiBUaGlzIGNoYW5nZSBhZGRzIHN1cHBvcnQgZm9yIEFuYWxvZyBEZXZp
Y2VzIEluZHVzdHJpYWwgRXRoZXJuZXQgUEhZcy4NCj4gPiBQYXJ0aWN1bGFybHkgdGhlIFBIWXMg
dGhpcyBkcml2ZXIgYWRkcyBzdXBwb3J0IGZvcjoNCj4gPiAgKiBBRElOMTIwMCAtIFJvYnVzdCwg
SW5kdXN0cmlhbCwgTG93IFBvd2VyIDEwLzEwMCBFdGhlcm5ldCBQSFkNCj4gPiAgKiBBRElOMTMw
MCAtIFJvYnVzdCwgSW5kdXN0cmlhbCwgTG93IExhdGVuY3kgMTAvMTAwLzEwMDAgR2lnYWJpdA0K
PiA+ICAgIEV0aGVybmV0IFBIWQ0KPiA+IA0KPiA+IFRoZSAyIGNoaXBzIGFyZSBwaW4gJiByZWdp
c3RlciBjb21wYXRpYmxlIHdpdGggb25lIGFub3RoZXIuIFRoZSBtYWluDQo+ID4gZGlmZmVyZW5j
ZSBiZWluZyB0aGF0IEFESU4xMjAwIGRvZXNuJ3Qgb3BlcmF0ZSBpbiBnaWdhYml0IG1vZGUuDQo+
ID4gDQo+ID4gVGhlIGNoaXBzIGNhbiBiZSBvcGVyYXRlZCBieSB0aGUgR2VuZXJpYyBQSFkgZHJp
dmVyIGFzIHdlbGwgdmlhIHRoZQ0KPiA+IHN0YW5kYXJkIElFRUUgUEhZIHJlZ2lzdGVycyAoMHgw
MDAwIC0gMHgwMDBGKSB3aGljaCBhcmUgc3VwcG9ydGVkIGJ5IHRoZQ0KPiA+IGtlcm5lbCBhcyB3
ZWxsLiBUaGlzIGFzc3VtZXMgdGhhdCBjb25maWd1cmF0aW9uIG9mIHRoZSBQSFkgaGFzIGJlZW4g
ZG9uZQ0KPiA+IHJlcXVpcmVkLg0KPiA+IA0KPiA+IENvbmZpZ3VyYXRpb24gY2FuIGFsc28gYmUg
ZG9uZSB2aWEgcmVnaXN0ZXJzLCB3aGljaCB3aWxsIGJlIGltcGxlbWVudGVkIGJ5DQo+ID4gdGhl
IGRyaXZlciBpbiB0aGUgbmV4dCBjaGFuZ2VzLg0KPiA+IA0KPiA+IERhdGFzaGVldHM6DQo+ID4g
ICBodHRwczovL3d3dy5hbmFsb2cuY29tL21lZGlhL2VuL3RlY2huaWNhbC1kb2N1bWVudGF0aW9u
L2RhdGEtc2hlZXRzL0FESU4xMzAwLnBkZg0KPiA+ICAgaHR0cHM6Ly93d3cuYW5hbG9nLmNvbS9t
ZWRpYS9lbi90ZWNobmljYWwtZG9jdW1lbnRhdGlvbi9kYXRhLXNoZWV0cy9BRElOMTIwMC5wZGYN
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5h
cmRlbGVhbkBhbmFsb2cuY29tPg0KPiA+IC0tLQ0KPiA+ICBNQUlOVEFJTkVSUyAgICAgICAgICAg
ICAgfCAgNyArKysrKw0KPiA+ICBkcml2ZXJzL25ldC9waHkvS2NvbmZpZyAgfCAgOSArKysrKysN
Cj4gPiAgZHJpdmVycy9uZXQvcGh5L01ha2VmaWxlIHwgIDEgKw0KPiA+ICBkcml2ZXJzL25ldC9w
aHkvYWRpbi5jICAgfCA1OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
DQo+ID4gIDQgZmlsZXMgY2hhbmdlZCwgNzYgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9k
ZSAxMDA2NDQgZHJpdmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9N
QUlOVEFJTkVSUyBiL01BSU5UQUlORVJTDQo+ID4gaW5kZXggZWU2NjNlMGUyZjJlLi5mYWY1NzIz
NjEwYzggMTAwNjQ0DQo+ID4gLS0tIGEvTUFJTlRBSU5FUlMNCj4gPiArKysgYi9NQUlOVEFJTkVS
Uw0KPiA+IEBAIC05MzgsNiArOTM4LDEzIEBAIFM6CVN1cHBvcnRlZA0KPiA+ICBGOglkcml2ZXJz
L211eC9hZGdzMTQwOC5jDQo+ID4gIEY6CURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9tdXgvYWRpLGFkZ3MxNDA4LnR4dA0KPiA+ICANCj4gPiArQU5BTE9HIERFVklDRVMgSU5DIEFE
SU4gRFJJVkVSDQo+ID4gK006CUFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGF1bmRydS5hcmRlbGVh
bkBhbmFsb2cuY29tPg0KPiA+ICtMOgluZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4gK1c6CWh0
dHA6Ly9lei5hbmFsb2cuY29tL2NvbW11bml0eS9saW51eC1kZXZpY2UtZHJpdmVycw0KPiA+ICtT
OglTdXBwb3J0ZWQNCj4gPiArRjoJZHJpdmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+ICsNCj4gPiAg
QU5BTE9HIERFVklDRVMgSU5DIEFESVMgRFJJVkVSIExJQlJBUlkNCj4gPiAgTToJQWxleGFuZHJ1
IEFyZGVsZWFuIDxhbGV4YW5kcnUuYXJkZWxlYW5AYW5hbG9nLmNvbT4NCj4gPiAgUzoJU3VwcG9y
dGVkDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9LY29uZmlnIGIvZHJpdmVycy9u
ZXQvcGh5L0tjb25maWcNCj4gPiBpbmRleCAyMDZkODY1MGVlN2YuLjU5NjZkMzQxMzY3NiAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9waHkvS2NvbmZpZw0KPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L3BoeS9LY29uZmlnDQo+ID4gQEAgLTI1Nyw2ICsyNTcsMTUgQEAgY29uZmlnIFNGUA0KPiA+
ICAJZGVwZW5kcyBvbiBIV01PTiB8fCBIV01PTj1uDQo+ID4gIAlzZWxlY3QgTURJT19JMkMNCj4g
PiAgDQo+ID4gK2NvbmZpZyBBRElOX1BIWQ0KPiA+ICsJdHJpc3RhdGUgIkFuYWxvZyBEZXZpY2Vz
IEluZHVzdHJpYWwgRXRoZXJuZXQgUEhZcyINCj4gPiArCWhlbHANCj4gPiArCSAgQWRkcyBzdXBw
b3J0IGZvciB0aGUgQW5hbG9nIERldmljZXMgSW5kdXN0cmlhbCBFdGhlcm5ldCBQSFlzLg0KPiA+
ICsJICBDdXJyZW50bHkgc3VwcG9ydHMgdGhlOg0KPiA+ICsJICAtIEFESU4xMjAwIC0gUm9idXN0
LEluZHVzdHJpYWwsIExvdyBQb3dlciAxMC8xMDAgRXRoZXJuZXQgUEhZDQo+ID4gKwkgIC0gQURJ
TjEzMDAgLSBSb2J1c3QsSW5kdXN0cmlhbCwgTG93IExhdGVuY3kgMTAvMTAwLzEwMDAgR2lnYWJp
dA0KPiA+ICsJICAgIEV0aGVybmV0IFBIWQ0KPiA+ICsNCj4gPiAgY29uZmlnIEFNRF9QSFkNCj4g
PiAgCXRyaXN0YXRlICJBTUQgUEhZcyINCj4gPiAgCS0tLWhlbHAtLS0NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvcGh5L01ha2VmaWxlIGIvZHJpdmVycy9uZXQvcGh5L01ha2VmaWxlDQo+
ID4gaW5kZXggYmEwN2MyN2U0MjA4Li5hMDM0MzdlMDkxZjMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9uZXQvcGh5L01ha2VmaWxlDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5L01ha2VmaWxl
DQo+ID4gQEAgLTQ3LDYgKzQ3LDcgQEAgb2JqLSQoQ09ORklHX1NGUCkJCSs9IHNmcC5vDQo+ID4g
IHNmcC1vYmotJChDT05GSUdfU0ZQKQkJKz0gc2ZwLWJ1cy5vDQo+ID4gIG9iai15CQkJCSs9ICQo
c2ZwLW9iai15KSAkKHNmcC1vYmotbSkNCj4gPiAgDQo+ID4gK29iai0kKENPTkZJR19BRElOX1BI
WSkJCSs9IGFkaW4ubw0KPiA+ICBvYmotJChDT05GSUdfQU1EX1BIWSkJCSs9IGFtZC5vDQo+ID4g
IGFxdWFudGlhLW9ianMJCQkrPSBhcXVhbnRpYV9tYWluLm8NCj4gPiAgaWZkZWYgQ09ORklHX0hX
TU9ODQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMgYi9kcml2ZXJzL25l
dC9waHkvYWRpbi5jDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAw
MDAwMDAuLjZhNjEwZDQ1NjNjMw0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9waHkvYWRpbi5jDQo+ID4gQEAgLTAsMCArMSw1OSBAQA0KPiA+ICsvLyBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogR1BMLTIuMCsNCj4gPiArLyoqDQo+ID4gKyAqICBEcml2ZXIgZm9yIEFu
YWxvZyBEZXZpY2VzIEluZHVzdHJpYWwgRXRoZXJuZXQgUEhZcw0KPiA+ICsgKg0KPiA+ICsgKiBD
b3B5cmlnaHQgMjAxOSBBbmFsb2cgRGV2aWNlcyBJbmMuDQo+ID4gKyAqLw0KPiA+ICsjaW5jbHVk
ZSA8bGludXgva2VybmVsLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9lcnJuby5oPg0KPiA+ICsj
aW5jbHVkZSA8bGludXgvaW5pdC5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQo+
ID4gKyNpbmNsdWRlIDxsaW51eC9taWkuaD4NCj4gPiArI2luY2x1ZGUgPGxpbnV4L3BoeS5oPg0K
PiA+ICsNCj4gPiArI2RlZmluZSBQSFlfSURfQURJTjEyMDAJCQkJMHgwMjgzYmMyMA0KPiA+ICsj
ZGVmaW5lIFBIWV9JRF9BRElOMTMwMAkJCQkweDAyODNiYzMwDQo+ID4gKw0KPiA+ICtzdGF0aWMg
aW50IGFkaW5fY29uZmlnX2luaXQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gPiArew0K
PiA+ICsJaW50IHJjOw0KPiA+ICsNCj4gPiArCXJjID0gZ2VucGh5X2NvbmZpZ19pbml0KHBoeWRl
dik7DQo+ID4gKwlpZiAocmMgPCAwKQ0KPiA+ICsJCXJldHVybiByYzsNCj4gPiArDQo+ID4gKwly
ZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIHN0cnVjdCBwaHlfZHJpdmVyIGFk
aW5fZHJpdmVyW10gPSB7DQo+ID4gKwl7DQo+ID4gKwkJLnBoeV9pZAkJPSBQSFlfSURfQURJTjEy
MDAsDQo+IA0KPiBZb3UgY291bGQgdXNlIFBIWV9JRF9NQVRDSF9NT0RFTCBoZXJlLg0KPiANCj4g
PiArCQkubmFtZQkJPSAiQURJTjEyMDAiLA0KPiA+ICsJCS5waHlfaWRfbWFzawk9IDB4ZmZmZmZm
ZjAsDQo+ID4gKwkJLmZlYXR1cmVzCT0gUEhZX0JBU0lDX0ZFQVRVUkVTLA0KPiANCj4gU2V0dGlu
ZyBmZWF0dXJlcyBpcyBkZXByZWNhdGVkLCBpbnN0ZWFkIHRoZSBnZXRfZmVhdHVyZXMgY2FsbGJh
Y2sNCj4gc2hvdWxkIGJlIGltcGxlbWVudGVkIGlmIHRoZSBkZWZhdWx0IGdlbnBoeV9yZWFkX2Fi
aWxpdGllcyBuZWVkcw0KPiB0byBiZSBleHRlbmRlZCAvIHJlcGxhY2VkLiBZb3Ugc2F5IHRoYXQg
dGhlIFBIWSdzIHdvcmsgd2l0aCB0aGUNCj4gZ2VucGh5IGRyaXZlciwgc28gSSBzdXBwb3NlIHRo
ZSBkZWZhdWx0IGZlYXR1cmUgZGV0ZWN0aW9uIGlzIG9rDQo+IGluIHlvdXIgY2FzZS4gVGhlbiB5
b3UgY291bGQgc2ltcGx5IHJlbW92ZSBzZXR0aW5nICJmZWF0dXJlcyIuDQoNCmFjazsNCnRoYW5r
cyBmb3IgdGhlIGluZm8NCg0KPiANCj4gPiArCQkuY29uZmlnX2luaXQJPSBhZGluX2NvbmZpZ19p
bml0LA0KPiA+ICsJCS5jb25maWdfYW5lZwk9IGdlbnBoeV9jb25maWdfYW5lZywNCj4gPiArCQku
cmVhZF9zdGF0dXMJPSBnZW5waHlfcmVhZF9zdGF0dXMsDQo+ID4gKwl9LA0KPiA+ICsJew0KPiA+
ICsJCS5waHlfaWQJCT0gUEhZX0lEX0FESU4xMzAwLA0KPiA+ICsJCS5uYW1lCQk9ICJBRElOMTMw
MCIsDQo+ID4gKwkJLnBoeV9pZF9tYXNrCT0gMHhmZmZmZmZmMCwNCj4gPiArCQkuZmVhdHVyZXMJ
PSBQSFlfR0JJVF9GRUFUVVJFUywNCj4gPiArCQkuY29uZmlnX2luaXQJPSBhZGluX2NvbmZpZ19p
bml0LA0KPiA+ICsJCS5jb25maWdfYW5lZwk9IGdlbnBoeV9jb25maWdfYW5lZywNCj4gPiArCQku
cmVhZF9zdGF0dXMJPSBnZW5waHlfcmVhZF9zdGF0dXMsDQo+ID4gKwl9LA0KPiA+ICt9Ow0KPiA+
ICsNCj4gPiArbW9kdWxlX3BoeV9kcml2ZXIoYWRpbl9kcml2ZXIpOw0KPiA+ICsNCj4gPiArc3Rh
dGljIHN0cnVjdCBtZGlvX2RldmljZV9pZCBfX21heWJlX3VudXNlZCBhZGluX3RibFtdID0gew0K
PiA+ICsJeyBQSFlfSURfQURJTjEyMDAsIDB4ZmZmZmZmZjAgfSwNCj4gPiArCXsgUEhZX0lEX0FE
SU4xMzAwLCAweGZmZmZmZmYwIH0sDQo+IA0KPiBQSFlfSURfTUFUQ0hfTU9ERUwgY291bGQgYmUg
dXNlZCBoZXJlIHRvby4NCg0KYWNrOw0Kd2lsbCB0YWtlIGEgbG9vaw0KDQo+IA0KPiA+ICsJeyB9
DQo+ID4gK307DQo+ID4gKw0KPiA+ICtNT0RVTEVfREVWSUNFX1RBQkxFKG1kaW8sIGFkaW5fdGJs
KTsNCj4gPiArTU9EVUxFX0RFU0NSSVBUSU9OKCJBbmFsb2cgRGV2aWNlcyBJbmR1c3RyaWFsIEV0
aGVybmV0IFBIWSBkcml2ZXIiKTsNCj4gPiArTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KPiA+IA0K
