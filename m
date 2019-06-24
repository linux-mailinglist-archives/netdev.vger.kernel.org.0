Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8275750FEE
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730489AbfFXPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:10:48 -0400
Received: from mail-eopbgr750041.outbound.protection.outlook.com ([40.107.75.41]:63657
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727922AbfFXPKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 11:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkSRwjSzWXl9BdHG8TDlu+v24JnkPbVRwWigLoVxHeU=;
 b=Z3ZKGoOXoyT9j29pPmKR9ZxRQUGg7Iia85/mp97pb5UK6wEe7e1350hg/O0zpdD/TwuCa1/oeLtjRRTs71d+BrlPl7icQWddomHN7M8/qOnSyysIO42iQxQTyk8wHos1EyxNfcmlmH91LJ1yTuBxbk1B1y9H8bv8QwECfZx/xo8=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1741.namprd11.prod.outlook.com (10.175.52.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 15:10:43 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 15:10:43 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next v2 0/8] net: aquantia: implement vlan offloads
Thread-Topic: [PATCH net-next v2 0/8] net: aquantia: implement vlan offloads
Thread-Index: AQHVKp79Z2Ey4zcQ9EK7iJ7cdgEd9Q==
Date:   Mon, 24 Jun 2019 15:10:43 +0000
Message-ID: <cover.1561388549.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14)
 To MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf6d3f58-8e37-4332-2e17-08d6f8b62034
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1741;
x-ms-traffictypediagnostic: MWHPR11MB1741:
x-microsoft-antispam-prvs: <MWHPR11MB17417ECCCF392614DF0033D198E00@MWHPR11MB1741.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39840400004)(346002)(366004)(396003)(376002)(189003)(199004)(66066001)(66446008)(64756008)(5660300002)(186003)(68736007)(44832011)(486006)(6436002)(72206003)(6486002)(6512007)(14454004)(476003)(86362001)(99286004)(36756003)(14444005)(6916009)(2616005)(3846002)(52116002)(6116002)(8676002)(81156014)(25786009)(81166006)(7736002)(54906003)(305945005)(8936002)(478600001)(26005)(73956011)(66946007)(102836004)(256004)(2906002)(386003)(6506007)(71190400001)(107886003)(71200400001)(66556008)(66476007)(316002)(53936002)(4326008)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1741;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KrydPyhw5Og8lV0UMd0WUczkHG17/8kx98cbbwtCEbQoLIJdF/maai+9AO1qOnguwLuiiVLv5CCvc3nH5zIQIudkYqy1wekqzfgE42/K+7q86OAvYJhWPYP9V3duDNVZHT576hvKRFfp8VckIB1xe0qqB5N1aGV2NXuX1wBBsITlvDMm8CuXO//e+TkqDhNaQEyjX66TNgw4sWw/SPvbcrjSG3slu13UndjXqL2JkU1pP89KdPxK81Tz41Imh/Uw7FxQ2yLQptHOuTqxEXeKVlPN16eWR26kAN+FLTubSa3C5p9A01YNlQ8c+ec80iI3iRY2A57SJ2KRN8Mv9bR0nGTfvKqKT6ZHcZeM95qwkl8Aj0t13MM/VRUtJocQoLsrTAYI+/1Km+cUMRO6CXE9fgheflSd50On3K/IYAIDmd0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6d3f58-8e37-4332-2e17-08d6f8b62034
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:10:43.0343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1741
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaHNldCBpbnRyb2R1Y2VzIGhhcmR3YXJlIFZMQU4gb2ZmbG9hZCBzdXBwb3J0IGFu
ZCBhbHNvIGRvZXMgc29tZQ0KbWFpbnRlbmFuY2U6IHdlIHJlcGxhY2UgZHJpdmVyIHZlcnNpb24g
d2l0aCB1dHMgdmVyc2lvbiBzdHJpbmcsIGFkZA0KZG9jdW1lbnRhdGlvbiBmaWxlIGZvciBhdGxh
bnRpYyBkcml2ZXIsIGFuZCB1cGRhdGUgbWFpbnRhaW5lcnMNCmFkZGluZyBJZ29yIGFzIGEgbWFp
bnRhaW5lci4NCg0KdjI6IHVwZGF0ZXMgaW4gZG9jLCBncGwgc3BkeCB0YWcgY2xlYW51cA0KDQpJ
Z29yIFJ1c3NraWtoICg4KToNCiAgbmV0OiBhcXVhbnRpYTogcmVwbGFjZSBpbnRlcm5hbCBkcml2
ZXIgdmVyc2lvbiBjb2RlIHdpdGggdXRzDQogIG5ldDogYXF1YW50aWE6IGFkZCBkb2N1bWVudGF0
aW9uIGZvciB0aGUgYXRsYW50aWMgZHJpdmVyDQogIG1haW50YWluZXJzOiBkZWNsYXJlIGFxdWFu
dGlhIGF0bGFudGljIGRyaXZlciBtYWludGVuYW5jZQ0KICBuZXQ6IGFxdWFudGlhOiBtYWtlIGFs
bCBmaWxlcyBHUEwtMi4wLW9ubHkNCiAgbmV0OiBhcXVhbnRpYTogYWRkZWQgdmxhbiBvZmZsb2Fk
IHJlbGF0ZWQgbWFjcm9zIGFuZCBmdW5jdGlvbnMNCiAgbmV0OiBhcXVhbnRpYTogYWRkaW5nIGZp
ZWxkcyBhbmQgZGV2aWNlIGZlYXR1cmVzIGZvciB2bGFuIG9mZmxvYWQNCiAgbmV0OiBhcXVhbnRp
YTogdmxhbiBvZmZsb2FkcyBsb2dpYyBpbiBkYXRhcGF0aA0KICBuZXQ6IGFxdWFudGlhOiBpbXBs
ZW1lbnQgdmxhbiBvZmZsb2FkIGNvbmZpZ3VyYXRpb24NCg0KIC4uLi9kZXZpY2VfZHJpdmVycy9h
cXVhbnRpYS9hdGxhbnRpYy50eHQgICAgICB8IDQzNyArKysrKysrKysrKysrKysrKysNCiBNQUlO
VEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDkgKw0KIC4uLi9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfY2ZnLmggICB8ICAgNyArLQ0KIC4uLi9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZpbmZvLmMgICB8ICAgMiArLQ0KIC4uLi9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9kcnZpbmZvLmggICB8ICAgMiArLQ0KIC4uLi9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9maWx0ZXJzLmMgICB8ICAgMiArLQ0KIC4uLi9l
dGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9maWx0ZXJzLmggICB8ICAgMiArLQ0KIC4uLi9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbWFpbi5jICB8ICAzNCArLQ0KIC4uLi9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmMgICB8ICAyOCArLQ0KIC4uLi9u
ZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfbmljLmggICB8ICAgMiArDQogLi4uL25l
dC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9yaW5nLmMgIHwgICA0ICsNCiAuLi4vbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3JpbmcuaCAgfCAgIDkgKy0NCiAuLi4vYXF1
YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9hMC5jICAgICAgfCAgIDIgKy0NCiAuLi4vYXF1
YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9iMC5jICAgICAgfCAgNjIgKystDQogLi4uL2F0
bGFudGljL2h3X2F0bC9od19hdGxfYjBfaW50ZXJuYWwuaCAgICAgIHwgICA3ICsNCiAuLi4vYXF1
YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9sbGguYyAgICAgfCAgMTYgKw0KIC4uLi9hcXVh
bnRpYS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2xsaC5oICAgICB8ICAgNSArDQogLi4uL2F0bGFu
dGljL2h3X2F0bC9od19hdGxfbGxoX2ludGVybmFsLmggICAgIHwgIDE4ICsNCiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy92ZXIuaCAgfCAgIDUgLQ0KIDE5IGZpbGVzIGNo
YW5nZWQsIDYwNiBpbnNlcnRpb25zKCspLCA0NyBkZWxldGlvbnMoLSkNCiBjcmVhdGUgbW9kZSAx
MDA2NDQgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmljZV9kcml2ZXJzL2FxdWFudGlhL2F0
bGFudGljLnR4dA0KDQotLSANCjIuMTcuMQ0KDQo=
