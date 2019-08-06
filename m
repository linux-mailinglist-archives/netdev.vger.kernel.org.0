Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6884F82BC3
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731860AbfHFGiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:38:46 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:36302 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731560AbfHFGiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:38:46 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X89e019075;
        Tue, 6 Aug 2019 02:38:38 -0400
Received: from nam05-co1-obe.outbound.protection.outlook.com (mail-co1nam05lp2054.outbound.protection.outlook.com [104.47.48.54])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u72vtg6hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:38:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEVpRzy50NKhf8Z+DIGTORngVfBGPAhx6NpYcuQC/1XHwqAaiPPWZ3npf+TKgMkZ6Z7d+Pf71KzPjlQou8cx/NJvepaVUGrqgH6/NCiMfLNZznVmSD+8WGBn2kvOKPYKn94LdA18mbvItB7TMp0Ra9DbgUj/0LNL2Eit4coDL6ViPEi4kevQqBnuZcVA0j5AFEKyNpYtpLUWi2OEliPH9YYfszR9GLbjeiY4ajyiDHDB7Uju7OyIn7VpJcYlOSXsXks2pMQ1q89pfeFdE+55kpu+o5h5Ia/j2zU8y/DES0sWDdu4axJDFHN3gHqyO3r/aRZHxonE7SNp0ORJT+l1yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUxHhYsb3AlSWTbmUFzQrFFqG9f4BXVtriS/AkNVGdw=;
 b=W3kF+Xj8wqI93xi+/9PtzLMVKLW/AsqXMqGXMi+3f8U/lifq3mKKfzdX7Wqv1sCeeHwRlW9h5un1okdOwio5zg43I8RdQ1TRMsQtLoZK2JY6xku908Nb2WyTaeMXk0EXovWW0+WgT+rCnfUfH9a8tzU8pVWrusVB3HFdZ0rVYI+SkY4Qyj3thKrafHbEwssTKoEoPHRmeX0yuCxZV52aDObrUcNNjribP61xtvPvDblbq3OJBCR7NhP6et43AxilopP4A+AeID0eOvcQuEMx46jsEmyOgMc1ZdoVJM0sjHkkBWY076Oz7j0yOug+FF624oUr/7m9HtH+qfaYRV5KGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.55) smtp.rcpttodomain=lunn.ch
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUxHhYsb3AlSWTbmUFzQrFFqG9f4BXVtriS/AkNVGdw=;
 b=aYzI+ffQfkNGzi9mhYuRPzD6pZcu3FmlctPvb6ekj7bDUpiwgqs1UJOsid/WKRQ0YtyfZgdj0ZGkob5fwqN91zGUkZv+Gr/7v7WzIYtbLA46hVtPzwyBDVNliuhGwga0edkV1BTxYTgKpy2O6PJkNjOdTMcGRmgkUeoizY2fxFs=
Received: from BN3PR03CA0069.namprd03.prod.outlook.com
 (2a01:111:e400:7a4d::29) by DM6PR03MB3466.namprd03.prod.outlook.com
 (2603:10b6:5:aa::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.17; Tue, 6 Aug
 2019 06:38:36 +0000
Received: from CY1NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by BN3PR03CA0069.outlook.office365.com
 (2a01:111:e400:7a4d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2136.14 via Frontend
 Transport; Tue, 6 Aug 2019 06:38:34 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.55 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.55; helo=nwd2mta1.analog.com;
Received: from nwd2mta1.analog.com (137.71.25.55) by
 CY1NAM02FT013.mail.protection.outlook.com (10.152.75.162) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:38:32 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta1.analog.com (8.13.8/8.13.8) with ESMTP id x766cTKI012666
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:38:29 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:38:32 -0400
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
Subject: Re: [PATCH 03/16] net: phy: adin: add support for interrupts
Thread-Topic: [PATCH 03/16] net: phy: adin: add support for interrupts
Thread-Index: AQHVS5Vm+EKbbNZ5cUCCmWe/myRXVqbtTjWAgADTFQA=
Date:   Tue, 6 Aug 2019 06:38:31 +0000
Message-ID: <e73fe0a4fecaf9612ddef701220319fb018c27b7.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-4-alexandru.ardelean@analog.com>
         <4f539572-4c59-0450-fcd4-0bbc3eece9c8@gmail.com>
In-Reply-To: <4f539572-4c59-0450-fcd4-0bbc3eece9c8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C657F99D847D6A4FBA03BB9F908EE0CC@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.55;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(979002)(346002)(376002)(136003)(396003)(39860400002)(2980300002)(189003)(199004)(2906002)(54906003)(110136005)(102836004)(47776003)(106002)(2501003)(8676002)(8936002)(7736002)(7636002)(305945005)(246002)(4326008)(316002)(36756003)(6246003)(50466002)(2201001)(3846002)(6116002)(336012)(229853002)(118296001)(426003)(436003)(476003)(2616005)(126002)(486006)(446003)(11346002)(76176011)(7696005)(2486003)(23676004)(14454004)(53546011)(26005)(478600001)(186003)(14444005)(70206006)(5660300002)(70586007)(356004)(86362001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB3466;H:nwd2mta1.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail10.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74ae958f-1e78-49a4-b985-08d71a38b3b7
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:DM6PR03MB3466;
X-MS-TrafficTypeDiagnostic: DM6PR03MB3466:
X-Microsoft-Antispam-PRVS: <DM6PR03MB34661CF9B074900B95C2FCCCF9D50@DM6PR03MB3466.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 1T/hdJAX7/Lfcpqoq2LAV5dJWI5D0W0Hp8PH+sxxHM6Aj/Qs8NZjMSdYVCkYPXMGP+XEdnSAMTMzig3PyPHXhZlCV9JHxIyc0ZPd5jz6W0bceo+ZzPVViZbrVCwoU+sdCCmrdV2s6LTlaCGFtEGjOVXUHncN8UlaTDpQQcctzSl2TMjWmAI474cq94Tmf/N76UhfGjHJCtBveXFw2XqBsuxvQbYp8XWg+Bu0pYJ6tYk6LXffN7oarVsl7QPv+/uK0Jk9j9clswv2ets5j9bCs6V9BCLFPacpykep1y4owhHKCmyzl2BBpkKDQHgmo4hSQwnQCupGCoasSTXhGS42CQPIp2qzdpEuMDAwGj18Pzl/Ih/idgzQg3tZeQOkLuBDrNej4CmjxQz90zAJ9P0pgPousp9PujDekpoTJKFCmkU=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:38:32.6242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ae958f-1e78-49a4-b985-08d71a38b3b7
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.55];Helo=[nwd2mta1.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB3466
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=960 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDIzOjAyICswMjAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IFtFeHRlcm5hbF0NCj4gDQo+IE9uIDA1LjA4LjIwMTkgMTg6NTQsIEFsZXhhbmRydSBBcmRl
bGVhbiB3cm90ZToNCj4gPiBUaGlzIGNoYW5nZSBhZGRzIHN1cHBvcnQgZm9yIGVuYWJsaW5nIFBI
WSBpbnRlcnJ1cHRzIHRoYXQgY2FuIGJlIHVzZWQgYnkNCj4gPiB0aGUgUEhZIGZyYW1ld29yayB0
byBnZXQgc2lnbmFsIGZvciBsaW5rL3NwZWVkL2F1dG8tbmVnb3RpYXRpb24gY2hhbmdlcy4NCj4g
PiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRydS5hcmRl
bGVhbkBhbmFsb2cuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9waHkvYWRpbi5jIHwg
NDQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmls
ZSBjaGFuZ2VkLCA0NCBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3BoeS9hZGluLmMgYi9kcml2ZXJzL25ldC9waHkvYWRpbi5jDQo+ID4gaW5kZXggYzEw
MGEwZGQ5NWNkLi5iNzVjNzIzYmRhNzkgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvcGh5
L2FkaW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMNCj4gPiBAQCAtMTQsNiAr
MTQsMjIgQEANCj4gPiAgI2RlZmluZSBQSFlfSURfQURJTjEyMDAJCQkJMHgwMjgzYmMyMA0KPiA+
ICAjZGVmaW5lIFBIWV9JRF9BRElOMTMwMAkJCQkweDAyODNiYzMwDQo+ID4gIA0KPiA+ICsjZGVm
aW5lIEFESU4xMzAwX0lOVF9NQVNLX1JFRwkJCTB4MDAxOA0KPiA+ICsjZGVmaW5lICAgQURJTjEz
MDBfSU5UX01ESU9fU1lOQ19FTgkJQklUKDkpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMwMF9JTlRf
QU5FR19TVEFUX0NITkdfRU4JQklUKDgpDQo+ID4gKyNkZWZpbmUgICBBRElOMTMwMF9JTlRfQU5F
R19QQUdFX1JYX0VOCQlCSVQoNikNCj4gPiArI2RlZmluZSAgIEFESU4xMzAwX0lOVF9JRExFX0VS
Ul9DTlRfRU4JCUJJVCg1KQ0KPiA+ICsjZGVmaW5lICAgQURJTjEzMDBfSU5UX01BQ19GSUZPX09V
X0VOCQlCSVQoNCkNCj4gPiArI2RlZmluZSAgIEFESU4xMzAwX0lOVF9SWF9TVEFUX0NITkdfRU4J
CUJJVCgzKQ0KPiA+ICsjZGVmaW5lICAgQURJTjEzMDBfSU5UX0xJTktfU1RBVF9DSE5HX0VOCUJJ
VCgyKQ0KPiA+ICsjZGVmaW5lICAgQURJTjEzMDBfSU5UX1NQRUVEX0NITkdfRU4JCUJJVCgxKQ0K
PiA+ICsjZGVmaW5lICAgQURJTjEzMDBfSU5UX0hXX0lSUV9FTgkJQklUKDApDQo+ID4gKyNkZWZp
bmUgQURJTjEzMDBfSU5UX01BU0tfRU4JXA0KPiA+ICsJKEFESU4xMzAwX0lOVF9BTkVHX1NUQVRf
Q0hOR19FTiB8IEFESU4xMzAwX0lOVF9BTkVHX1BBR0VfUlhfRU4gfCBcDQo+ID4gKwkgQURJTjEz
MDBfSU5UX0xJTktfU1RBVF9DSE5HX0VOIHwgQURJTjEzMDBfSU5UX1NQRUVEX0NITkdfRU4gfCBc
DQo+ID4gKwkgQURJTjEzMDBfSU5UX0hXX0lSUV9FTikNCj4gPiArI2RlZmluZSBBRElOMTMwMF9J
TlRfU1RBVFVTX1JFRwkJCTB4MDAxOQ0KPiA+ICsNCj4gPiAgc3RhdGljIGludCBhZGluX2NvbmZp
Z19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gIHsNCj4gPiAgCWludCByYzsN
Cj4gPiBAQCAtMjUsMTUgKzQxLDQwIEBAIHN0YXRpYyBpbnQgYWRpbl9jb25maWdfaW5pdChzdHJ1
Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+ICAJcmV0dXJuIDA7DQo+ID4gIH0NCj4gPiAgDQo+
ID4gK3N0YXRpYyBpbnQgYWRpbl9waHlfYWNrX2ludHIoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRl
dikNCj4gPiArew0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwkvKiBDbGVhciBwZW5kaW5n
IGludGVycnVwdHMuICAqLw0KPiA+ICsJcmV0ID0gcGh5X3JlYWQocGh5ZGV2LCBBRElOMTMwMF9J
TlRfU1RBVFVTX1JFRyk7DQo+ID4gKwlpZiAocmV0IDwgMCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0K
PiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IGFk
aW5fcGh5X2NvbmZpZ19pbnRyKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ID4gK3sNCj4g
PiArCWlmIChwaHlkZXYtPmludGVycnVwdHMgPT0gUEhZX0lOVEVSUlVQVF9FTkFCTEVEKQ0KPiA+
ICsJCXJldHVybiBwaHlfc2V0X2JpdHMocGh5ZGV2LCBBRElOMTMwMF9JTlRfTUFTS19SRUcsDQo+
ID4gKwkJCQkgICAgQURJTjEzMDBfSU5UX01BU0tfRU4pOw0KPiA+ICsNCj4gPiArCXJldHVybiBw
aHlfY2xlYXJfYml0cyhwaHlkZXYsIEFESU4xMzAwX0lOVF9NQVNLX1JFRywNCj4gPiArCQkJICAg
ICAgQURJTjEzMDBfSU5UX01BU0tfRU4pOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgc3Ry
dWN0IHBoeV9kcml2ZXIgYWRpbl9kcml2ZXJbXSA9IHsNCj4gPiAgCXsNCj4gPiAgCQkucGh5X2lk
CQk9IFBIWV9JRF9BRElOMTIwMCwNCj4gPiAgCQkubmFtZQkJPSAiQURJTjEyMDAiLA0KPiA+ICAJ
CS5waHlfaWRfbWFzawk9IDB4ZmZmZmZmZjAsDQo+ID4gIAkJLmZlYXR1cmVzCT0gUEhZX0JBU0lD
X0ZFQVRVUkVTLA0KPiA+ICsJCS5mbGFncwkJPSBQSFlfSEFTX0lOVEVSUlVQVCwNCj4gDQo+IFRo
aXMgZmxhZyBkb2Vzbid0IGV4aXN0IGFueSBsb25nZXIuIFRoaXMgaW5kaWNhdGVzIHRoYXQgeW91
DQo+IGRldmVsb3AgYWdhaW5zdCBhbiBvbGRlciBrZXJuZWwgdmVyc2lvbi4gUGxlYXNlIGRldmVs
b3ANCj4gYWdhaW5zdCBuZXQtbmV4dC4gQ2hlY2sgdXAtdG8tZGF0ZSBkcml2ZXJzIGxpa2UgdGhl
IG9uZQ0KPiBmb3IgUmVhbHRlayBQSFkncyBmb3IgaGludHMuDQoNCmFjazsNCg0KPiANCj4gPiAg
CQkuY29uZmlnX2luaXQJPSBhZGluX2NvbmZpZ19pbml0LA0KPiA+ICAJCS5jb25maWdfYW5lZwk9
IGdlbnBoeV9jb25maWdfYW5lZywNCj4gPiAgCQkucmVhZF9zdGF0dXMJPSBnZW5waHlfcmVhZF9z
dGF0dXMsDQo+ID4gKwkJLmFja19pbnRlcnJ1cHQJPSBhZGluX3BoeV9hY2tfaW50ciwNCj4gPiAr
CQkuY29uZmlnX2ludHIJPSBhZGluX3BoeV9jb25maWdfaW50ciwNCj4gPiAgCQkucmVzdW1lCQk9
IGdlbnBoeV9yZXN1bWUsDQo+ID4gIAkJLnN1c3BlbmQJPSBnZW5waHlfc3VzcGVuZCwNCj4gPiAg
CX0sDQo+ID4gQEAgLTQyLDkgKzgzLDEyIEBAIHN0YXRpYyBzdHJ1Y3QgcGh5X2RyaXZlciBhZGlu
X2RyaXZlcltdID0gew0KPiA+ICAJCS5uYW1lCQk9ICJBRElOMTMwMCIsDQo+ID4gIAkJLnBoeV9p
ZF9tYXNrCT0gMHhmZmZmZmZmMCwNCj4gPiAgCQkuZmVhdHVyZXMJPSBQSFlfR0JJVF9GRUFUVVJF
UywNCj4gPiArCQkuZmxhZ3MJCT0gUEhZX0hBU19JTlRFUlJVUFQsDQo+ID4gIAkJLmNvbmZpZ19p
bml0CT0gYWRpbl9jb25maWdfaW5pdCwNCj4gPiAgCQkuY29uZmlnX2FuZWcJPSBnZW5waHlfY29u
ZmlnX2FuZWcsDQo+ID4gIAkJLnJlYWRfc3RhdHVzCT0gZ2VucGh5X3JlYWRfc3RhdHVzLA0KPiA+
ICsJCS5hY2tfaW50ZXJydXB0CT0gYWRpbl9waHlfYWNrX2ludHIsDQo+ID4gKwkJLmNvbmZpZ19p
bnRyCT0gYWRpbl9waHlfY29uZmlnX2ludHIsDQo+ID4gIAkJLnJlc3VtZQkJPSBnZW5waHlfcmVz
dW1lLA0KPiA+ICAJCS5zdXNwZW5kCT0gZ2VucGh5X3N1c3BlbmQsDQo+ID4gIAl9LA0KPiA+IA0K
