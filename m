Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F5382BFD
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 08:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbfHFGrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 02:47:22 -0400
Received: from mx0a-00128a01.pphosted.com ([148.163.135.77]:57834 "EHLO
        mx0a-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731773AbfHFGrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 02:47:22 -0400
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x766X97a019080;
        Tue, 6 Aug 2019 02:47:12 -0400
Received: from nam01-bn3-obe.outbound.protection.outlook.com (mail-bn3nam01lp2059.outbound.protection.outlook.com [104.47.33.59])
        by mx0a-00128a01.pphosted.com with ESMTP id 2u72vtg798-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Aug 2019 02:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6ZU16VhbVM7f1Ymlmcitavd9Fe7pYR1+HSdyxMdQhTlVxWTeFZ51895EDJypmZvpdcN7JGX/LVN/TNBvdEr+WFOvL8A7M8MmRk+HVXPym11zF7zZeTtscmPM5dMVBbxFPWt0YKW6MN0ysiO1OE5Rc+C+S276hi2BlUIlOgORoKB4gD7b2KdmttPdDfaKKEqNmEBtfskjjbnWtujaJKVq6hDL2qsJ79aATG1dhp07MTv6WVPRM1qBUZTP4XufDAX32Zkd2bLy8cGFkiobQyytvyl4dVLh86WqBfWQfYHJi4LonJhaMsGZ5vTdxrJQ4LXoUer6skY+MyljKojNhjygA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7BYAMCsFPCqoDiJqcCwVkAksb2AIFldvDAvTN3cnQ4=;
 b=M2t13zN8m3/ydRMY99xFKoMfuTUi6bIUG4zYzYOaRhTe/2r+BBgoZVSi3kIv96knuo4aWYAHp+M7HBuafhUJEge0X6f8Cjpx6b3D5fVrfYoKO4ST5ZT/Zvszfw+eu3MMpQG2oPnuy6mtN0ttv9hsAMs76xLRMeOZnU2uXydfnZkdjW/9yQSK0wG3i+7GFHesltQiEBksdyXfosIJcKManvAouFqzJSJh0RY2lxGqJjU4TwCuAAEygsl02dnc3LM7qOmOPHA5WnUKf5I5jBYyK0jl64n3gUplFcr+i8Z0a18B5C0JHWGhVkq15v6c1kto6cQaZ8oaztxEtz8ATmsUJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass (sender ip is
 137.71.25.57) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=analog.com;dmarc=bestguesspass action=none
 header.from=analog.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7BYAMCsFPCqoDiJqcCwVkAksb2AIFldvDAvTN3cnQ4=;
 b=Yt0tr4+xZrDK1RNsZa1epi0wetvlY3U27fFmtl3R/LZiwjCTIW3ffaVDVe+01PnkiNKLNDYE4+SEARLtKrLOm7YNoHdoOsDjPLsGCJGVGZT2KqL6ftz4yd1DfxRbaGQqru25CcGA2sOG47hUofPvXqHy8WywpxQOwPl+zy6TFKs=
Received: from DM6PR03CA0014.namprd03.prod.outlook.com (2603:10b6:5:40::27) by
 DM6PR03MB4332.namprd03.prod.outlook.com (2603:10b6:5:101::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Tue, 6 Aug 2019 06:47:09 +0000
Received: from BL2NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::208) by DM6PR03CA0014.outlook.office365.com
 (2603:10b6:5:40::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2157.14 via Frontend
 Transport; Tue, 6 Aug 2019 06:47:09 +0000
Received-SPF: Pass (protection.outlook.com: domain of analog.com designates
 137.71.25.57 as permitted sender) receiver=protection.outlook.com;
 client-ip=137.71.25.57; helo=nwd2mta2.analog.com;
Received: from nwd2mta2.analog.com (137.71.25.57) by
 BL2NAM02FT027.mail.protection.outlook.com (10.152.77.160) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2136.14
 via Frontend Transport; Tue, 6 Aug 2019 06:47:09 +0000
Received: from NWD2HUBCAS9.ad.analog.com (nwd2hubcas9.ad.analog.com [10.64.69.109])
        by nwd2mta2.analog.com (8.13.8/8.13.8) with ESMTP id x766l9UI010615
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 5 Aug 2019 23:47:09 -0700
Received: from NWD2MBX7.ad.analog.com ([fe80::190e:f9c1:9a22:9663]) by
 NWD2HUBCAS9.ad.analog.com ([fe80::44a2:871b:49ab:ea47%12]) with mapi id
 14.03.0415.000; Tue, 6 Aug 2019 02:47:09 -0400
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
Subject: Re: [PATCH 06/16] net: phy: adin: support PHY mode converters
Thread-Topic: [PATCH 06/16] net: phy: adin: support PHY mode converters
Thread-Index: AQHVS5Vqk7PSp0S6xUqsUDBYjsprn6bs5k2AgAE9ZgA=
Date:   Tue, 6 Aug 2019 06:47:08 +0000
Message-ID: <15cf5732415c313a7bfe610e7039e7c97b987073.camel@analog.com>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
         <20190805165453.3989-7-alexandru.ardelean@analog.com>
         <20190805145105.GN24275@lunn.ch>
In-Reply-To: <20190805145105.GN24275@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.65.112]
x-adiroutedonprem: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <521E8577F20C4B45B17C688AF00FB504@analog.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:137.71.25.57;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(136003)(346002)(396003)(39860400002)(2980300002)(189003)(199004)(76176011)(50466002)(478600001)(7696005)(118296001)(336012)(305945005)(6246003)(7636002)(11346002)(486006)(6116002)(356004)(426003)(86362001)(7736002)(2616005)(476003)(14454004)(3846002)(8936002)(102836004)(126002)(446003)(70206006)(186003)(2906002)(2501003)(246002)(2486003)(23676004)(436003)(47776003)(4326008)(70586007)(1730700003)(26005)(8676002)(54906003)(36756003)(6916009)(5640700003)(316002)(2351001)(106002)(5660300002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR03MB4332;H:nwd2mta2.analog.com;FPR:;SPF:Pass;LANG:en;PTR:nwd2mail11.analog.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebf5c67b-dda4-46cd-691f-08d71a39e789
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(4709080)(1401327)(2017052603328)(7193020);SRVR:DM6PR03MB4332;
X-MS-TrafficTypeDiagnostic: DM6PR03MB4332:
X-Microsoft-Antispam-PRVS: <DM6PR03MB433293CA1365F207CDDAA3ABF9D50@DM6PR03MB4332.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0121F24F22
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: ulKSqvHKcY44GOSsvTZ9ScLe7jV0ZjyRuroySQ8ZmWHDdWcUwNlnMPQHt8A8QNcYS7OHwHhIVAsLuUNWrM7fSsqsp+B5m+v3XsIh/CmvmuEECNAf/tzUL2hO/HkcFi8UkbLWd/B9qxIRbCo2DzcJnVcIz63RFst9w8wW7aaJIDmrA2dxynZoc9lJoXEqvGy9/M5mz9J3GlRRNtDF0+f0JjTzuFEGF05fopdMLxLImwmxAQjJup/PljKkz4CaHI2dp+fgA4CmHlwO+0GFTC6/QN+FAIgn0Hlc/YwzPLnXFcGTgQ8rwhI+Nl4BA02wUR6S44M7s/ZHmhzOkZnlKz30bBVGZJrh9WMWlA21U/ZEmVGUrNPoOKC/vymxzH5QUfKiRFSfgm6Ac92/yaYaPino40VdQhqiYUVLsPLj4MmO5LA=
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2019 06:47:09.5294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf5c67b-dda4-46cd-691f-08d71a39e789
X-MS-Exchange-CrossTenant-Id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=eaa689b4-8f87-40e0-9c6f-7228de4d754a;Ip=[137.71.25.57];Helo=[nwd2mta2.analog.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB4332
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

T24gTW9uLCAyMDE5LTA4LTA1IGF0IDE2OjUxICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
W0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBBdWcgMDUsIDIwMTkgYXQgMDc6NTQ6NDNQTSArMDMw
MCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFNvbWV0aW1lcywgdGhlIGNvbm5lY3Rp
b24gYmV0d2VlbiBhIE1BQyBhbmQgUEhZIGlzIGRvbmUgdmlhIGENCj4gPiBtb2RlL2ludGVyZmFj
ZSBjb252ZXJ0ZXIuIEFuIGV4YW1wbGUgaXMgYSBHTUlJLXRvLVJHTUlJIGNvbnZlcnRlciwgd2hp
Y2gNCj4gPiB3b3VsZCBtZWFuIHRoYXQgdGhlIE1BQyBvcGVyYXRlcyBpbiBHTUlJIG1vZGUgd2hp
bGUgdGhlIFBIWSBvcGVyYXRlcyBpbg0KPiA+IFJHTUlJLiBJbiB0aGlzIGNhc2UgdGhlcmUgaXMg
YSBkaXNjcmVwYW5jeSBiZXR3ZWVuIHdoYXQgdGhlIE1BQyBleHBlY3RzICYNCj4gPiB3aGF0IHRo
ZSBQSFkgZXhwZWN0cyBhbmQgYm90aCBuZWVkIHRvIGJlIGNvbmZpZ3VyZWQgaW4gdGhlaXIgcmVz
cGVjdGl2ZQ0KPiA+IG1vZGVzLg0KPiA+IA0KPiA+IFNvbWV0aW1lcywgdGhpcyBjb252ZXJ0ZXIg
aXMgc3BlY2lmaWVkIHZpYSBhIGJvYXJkL3N5c3RlbSBjb25maWd1cmF0aW9uIChpbg0KPiA+IHRo
ZSBkZXZpY2UtdHJlZSBmb3IgZXhhbXBsZSkuIEJ1dCwgb3RoZXIgdGltZXMgaXQgY2FuIGJlIGxl
ZnQgdW5zcGVjaWZpZWQuDQo+ID4gVGhlIHVzZSBvZiB0aGVzZSBjb252ZXJ0ZXJzIGlzIGNvbW1v
biBpbiBib2FyZHMgdGhhdCBoYXZlIEZQR0Egb24gdGhlbS4NCj4gPiANCj4gPiBUaGlzIHBhdGNo
IGFsc28gYWRkcyBzdXBwb3J0IGZvciBhIGBhZGkscGh5LW1vZGUtaW50ZXJuYWxgIHByb3BlcnR5
IHRoYXQNCj4gPiBjYW4gYmUgdXNlZCBpbiB0aGVzZSAoaW1wbGljaXQgY29udmVydCkgY2FzZXMu
IFRoZSBpbnRlcm5hbCBQSFkgbW9kZSB3aWxsDQo+ID4gYmUgdXNlZCB0byBzcGVjaWZ5IHRoZSBj
b3JyZWN0IHJlZ2lzdGVyIHNldHRpbmdzIGZvciB0aGUgUEhZLg0KPiA+IA0KPiA+IGBmd25vZGVf
aGFuZGxlYCBpcyB1c2VkLCBzaW5jZSB0aGlzIHByb3BlcnR5IG1heSBiZSBzcGVjaWZpZWQgdmlh
IEFDUEkgYXMNCj4gPiB3ZWxsIGluIG90aGVyIHNldHVwcywgYnV0IHRlc3RpbmcgaGFzIGJlZW4g
ZG9uZSBpbiBEVCBjb250ZXh0Lg0KPiANCj4gTG9va2luZyBhdCB0aGUgcGF0Y2gsIHlvdSBzZWVt
cyB0byBhc3N1bWUgcGh5LW1vZGUgaXMgd2hhdCB0aGUgTUFDIGlzDQo+IHVzaW5nPyBUaGF0IHNl
ZW1zIHJhdGhlciBvZGQsIGdpdmVuIHRoZSBuYW1lLiBJdCBzZWVtcyBsaWtlIGEgYmV0dGVyDQo+
IHNvbHV0aW9uIHdvdWxkIGJlIHRvIGFkZCBhIG1hYy1tb2RlLCB3aGljaCB0aGUgTUFDIHVzZXMg
dG8gY29uZmlndXJlDQo+IGl0cyBzaWRlIG9mIHRoZSBsaW5rLiBUaGUgTUFDIGRyaXZlciB3b3Vs
ZCB0aGVuIGltcGxlbWVudCB0aGlzDQo+IHByb3BlcnR5Lg0KPiANCg0KYWN0dWFsbHksIHRoYXQn
cyBhIHByZXR0eSBnb29kIGlkZWE7DQppIGd1ZXNzIGkgd2FzIG5hcnJvdy1taW5kZWQgd2hlbiB3
cml0aW5nIHRoZSBkcml2ZXIsIGFuZCBnb3Qgc3R1Y2sgb24gcGh5IHNwZWNpZmljcywgYW5kIGZv
cmdvdCBhYm91dCB0aGUgTUFDLXNpZGU7DQpbIGkgYWxzbyBjYXRjaCB0aGVzZSBkZXNpZ24gZWxl
bWVudHMgd2hlbiByZXZpZXdpbmcsIGJ1dCBpIGFsc28gc2VlbSB0byBtaXNzIHRoZW0gd2hlbiB3
cml0aW5nIHN0dWZmIHNvbWV0aW1lcyBdDQoNCnRoYW5rcw0KDQo+IEkgZG9uJ3Qgc2VlIGEgbmVl
ZCBmb3IgdGhpcy4gcGh5LW1vZGUgaW5kaWNhdGVzIHdoYXQgdGhlIFBIWSBzaG91bGQNCj4gdXNl
LiBFbmQgb2Ygc3RvcnkuDQo+IA0KPiAgICAgIEFuZHJldw0K
