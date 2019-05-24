Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A528F2A126
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404441AbfEXW1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:27:31 -0400
Received: from mail-eopbgr10071.outbound.protection.outlook.com ([40.107.1.71]:32916
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404287AbfEXW12 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 18:27:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwX+38+H+tk8sc6X1RXbf/70tWby43NBe4Jprh7iXIc=;
 b=BNT0yUKc1o8LufBvFS6nM/y37xmW+kF31aa9wPIWLs/0dyolq01Aa926Of7JUkRocO2xVPrmmTR8VNhX9Uy8gpSd9uQURtlBhA/Q1651A7PY+kNtVU3W8FtGGqzAgi83GkeUTEdVzqS4Wx85HK9bh0QhENEKXYAd5wounFrXAwQ=
Received: from VI1PR05MB3328.eurprd05.prod.outlook.com (10.170.238.141) by
 VI1PR05MB5039.eurprd05.prod.outlook.com (20.177.52.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 22:27:24 +0000
Received: from VI1PR05MB3328.eurprd05.prod.outlook.com
 ([fe80::d054:c1d5:5865:9092]) by VI1PR05MB3328.eurprd05.prod.outlook.com
 ([fe80::d054:c1d5:5865:9092%4]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 22:27:24 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@mellanox.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH RFC 1/2] net: bonding: Inherit MPLS features from slave
 devices
Thread-Topic: [PATCH RFC 1/2] net: bonding: Inherit MPLS features from slave
 devices
Thread-Index: AQHVEn/bipscF4q+2Uy7K/LTx0dDaQ==
Date:   Fri, 24 May 2019 22:27:23 +0000
Message-ID: <1558736809-23258-2-git-send-email-lariel@mellanox.com>
References: <1558736809-23258-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1558736809-23258-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.226.120.58]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: LO2P265CA0457.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::13) To VI1PR05MB3328.eurprd05.prod.outlook.com
 (2603:10a6:802:1d::13)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23d33fc9-325a-42fa-0c9c-08d6e096fe07
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600147)(711020)(4605104)(1401326)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5039;
x-ms-traffictypediagnostic: VI1PR05MB5039:
x-microsoft-antispam-prvs: <VI1PR05MB50395C26829D6E41D8E17706BA020@VI1PR05MB5039.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(136003)(366004)(396003)(346002)(199004)(189003)(66556008)(66946007)(66476007)(305945005)(4326008)(76176011)(64756008)(66446008)(2501003)(25786009)(4720700003)(5660300002)(86362001)(81156014)(478600001)(8676002)(81166006)(386003)(102836004)(1730700003)(186003)(2906002)(14444005)(26005)(50226002)(316002)(6506007)(14454004)(8936002)(256004)(6486002)(6436002)(476003)(36756003)(53936002)(7736002)(2616005)(71190400001)(73956011)(5640700003)(71200400001)(99286004)(446003)(11346002)(3846002)(54906003)(68736007)(6512007)(6116002)(6916009)(2351001)(486006)(66066001)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5039;H:VI1PR05MB3328.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hvsXR0f5b44zmMLstKgz6GCnWGYxmsgeA5bS40YDN6xqW2mjxU9RLZqyoZJcpohw9ST0sX+qh6SYInVfYINJJMVSKaEU7w0V+lHu0fdqxd3sO41sWsLbfVsUnxHI+cJKrm0embwE487HlACywduCXjSstWhMm9+of4y2MgJuAyE5t1PO+yENVnbRxJhJ0Tc5NPsILRyzH/jntuOwdENq02VxnCPHykPjzc68RpaLnw0Ftm3RdKtqJ2F93bxW0hkRZ2BNHjQGpLyLcQxzYCgHOeOs6DsvSIIizc+ddiiyDgiaoN5mHobTXX8ZgMV98WgcwccAdBzixbjO7lgvNeJaBSNsFuEzQKvSDbqZjOEBIFTsch6v4BkLE/+TZERbmM6DwMhM9Itry5xDEgMFdi8GGcvkFCxD5tgjBpGdSfoVRV4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d33fc9-325a-42fa-0c9c-08d6e096fe07
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 22:27:23.5112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lariel@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiBzZXR0aW5nIHRoZSBib25kaW5nIGludGVyZmFjZSBuZXQgZGV2aWNlIGZlYXR1cmVzLA0K
dGhlIGtlcm5lbCBjb2RlIGRvZXNuJ3QgYWRkcmVzcyB0aGUgc2xhdmVzJyBNUExTIGZlYXR1cmVz
DQphbmQgZG9lc24ndCBpbmhlcml0IHRoZW0uDQoNClRoZXJlZm9yZSwgSFcgb2ZmbG9hZHMgdGhh
dCBlbmhhbmNlIHBlcmZvcm1hbmNlIHN1Y2ggYXMNCmNoZWNrc3VtbWluZyBhbmQgVFNPIGFyZSBk
aXNhYmxlZCBmb3IgTVBMUyB0YWdnZWQgdHJhZmZpYw0KZmxvd2luZyB2aWEgdGhlIGJvbmRpbmcg
aW50ZXJmYWNlLg0KDQpUaGUgcGF0Y2ggYWRkIHRoZSBpbmhlcml0YW5jZSBvZiB0aGUgTVBMUyBm
ZWF0dXJlcyBmcm9tIHRoZQ0Kc2xhdmUgZGV2aWNlcyB3aXRoIGEgc2ltaWxhciBsb2dpYyB0byBz
ZXR0aW5nIHRoZSBib25kaW5nIGRldmljZSdzDQpWTEFOIGFuZCBlbmNhcHN1bGF0aW9uIGZlYXR1
cmVzLg0KDQpDQzogSmF5IFZvc2J1cmdoIDxqLnZvc2J1cmdoQGdtYWlsLmNvbT4NCkNDOiBWZWFj
ZXNsYXYgRmFsaWNvIDx2ZmFsaWNvQGdtYWlsLmNvbT4NCkNDOiBBbmR5IEdvc3BvZGFyZWsgPGFu
ZHlAZ3JleWhvdXNlLm5ldD4NClNpZ25lZC1vZmYtYnk6IEFyaWVsIExldmtvdmljaCA8bGFyaWVs
QG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgfCAx
MSArKysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jIGIvZHJpdmVycy9uZXQvYm9u
ZGluZy9ib25kX21haW4uYw0KaW5kZXggMDYyZmE3ZS4uNDZiNWY2ZCAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2JvbmRpbmcv
Ym9uZF9tYWluLmMNCkBAIC0xMDc3LDEyICsxMDc3LDE2IEBAIHN0YXRpYyBuZXRkZXZfZmVhdHVy
ZXNfdCBib25kX2ZpeF9mZWF0dXJlcyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KICNkZWZpbmUg
Qk9ORF9FTkNfRkVBVFVSRVMJKE5FVElGX0ZfSFdfQ1NVTSB8IE5FVElGX0ZfU0cgfCBcDQogCQkJ
CSBORVRJRl9GX1JYQ1NVTSB8IE5FVElGX0ZfQUxMX1RTTykNCiANCisjZGVmaW5lIEJPTkRfTVBM
U19GRUFUVVJFUwkoTkVUSUZfRl9IV19DU1VNIHwgTkVUSUZfRl9TRyB8IFwNCisJCQkJIE5FVElG
X0ZfQUxMX1RTTykNCisNCiBzdGF0aWMgdm9pZCBib25kX2NvbXB1dGVfZmVhdHVyZXMoc3RydWN0
IGJvbmRpbmcgKmJvbmQpDQogew0KIAl1bnNpZ25lZCBpbnQgZHN0X3JlbGVhc2VfZmxhZyA9IElG
Rl9YTUlUX0RTVF9SRUxFQVNFIHwNCiAJCQkJCUlGRl9YTUlUX0RTVF9SRUxFQVNFX1BFUk07DQog
CW5ldGRldl9mZWF0dXJlc190IHZsYW5fZmVhdHVyZXMgPSBCT05EX1ZMQU5fRkVBVFVSRVM7DQog
CW5ldGRldl9mZWF0dXJlc190IGVuY19mZWF0dXJlcyAgPSBCT05EX0VOQ19GRUFUVVJFUzsNCisJ
bmV0ZGV2X2ZlYXR1cmVzX3QgbXBsc19mZWF0dXJlcyAgPSBCT05EX01QTFNfRkVBVFVSRVM7DQog
CXN0cnVjdCBuZXRfZGV2aWNlICpib25kX2RldiA9IGJvbmQtPmRldjsNCiAJc3RydWN0IGxpc3Rf
aGVhZCAqaXRlcjsNCiAJc3RydWN0IHNsYXZlICpzbGF2ZTsNCkBAIC0xMDkzLDYgKzEwOTcsNyBA
QCBzdGF0aWMgdm9pZCBib25kX2NvbXB1dGVfZmVhdHVyZXMoc3RydWN0IGJvbmRpbmcgKmJvbmQp
DQogCWlmICghYm9uZF9oYXNfc2xhdmVzKGJvbmQpKQ0KIAkJZ290byBkb25lOw0KIAl2bGFuX2Zl
YXR1cmVzICY9IE5FVElGX0ZfQUxMX0ZPUl9BTEw7DQorCW1wbHNfZmVhdHVyZXMgJj0gTkVUSUZf
Rl9BTExfRk9SX0FMTDsNCiANCiAJYm9uZF9mb3JfZWFjaF9zbGF2ZShib25kLCBzbGF2ZSwgaXRl
cikgew0KIAkJdmxhbl9mZWF0dXJlcyA9IG5ldGRldl9pbmNyZW1lbnRfZmVhdHVyZXModmxhbl9m
ZWF0dXJlcywNCkBAIC0xMTAxLDYgKzExMDYsMTEgQEAgc3RhdGljIHZvaWQgYm9uZF9jb21wdXRl
X2ZlYXR1cmVzKHN0cnVjdCBib25kaW5nICpib25kKQ0KIAkJZW5jX2ZlYXR1cmVzID0gbmV0ZGV2
X2luY3JlbWVudF9mZWF0dXJlcyhlbmNfZmVhdHVyZXMsDQogCQkJCQkJCSBzbGF2ZS0+ZGV2LT5o
d19lbmNfZmVhdHVyZXMsDQogCQkJCQkJCSBCT05EX0VOQ19GRUFUVVJFUyk7DQorDQorCQltcGxz
X2ZlYXR1cmVzID0gbmV0ZGV2X2luY3JlbWVudF9mZWF0dXJlcyhtcGxzX2ZlYXR1cmVzLA0KKwkJ
CQkJCQkgIHNsYXZlLT5kZXYtPm1wbHNfZmVhdHVyZXMsDQorCQkJCQkJCSAgQk9ORF9NUExTX0ZF
QVRVUkVTKTsNCisNCiAJCWRzdF9yZWxlYXNlX2ZsYWcgJj0gc2xhdmUtPmRldi0+cHJpdl9mbGFn
czsNCiAJCWlmIChzbGF2ZS0+ZGV2LT5oYXJkX2hlYWRlcl9sZW4gPiBtYXhfaGFyZF9oZWFkZXJf
bGVuKQ0KIAkJCW1heF9oYXJkX2hlYWRlcl9sZW4gPSBzbGF2ZS0+ZGV2LT5oYXJkX2hlYWRlcl9s
ZW47DQpAQCAtMTExNCw2ICsxMTI0LDcgQEAgc3RhdGljIHZvaWQgYm9uZF9jb21wdXRlX2ZlYXR1
cmVzKHN0cnVjdCBib25kaW5nICpib25kKQ0KIAlib25kX2Rldi0+dmxhbl9mZWF0dXJlcyA9IHZs
YW5fZmVhdHVyZXM7DQogCWJvbmRfZGV2LT5od19lbmNfZmVhdHVyZXMgPSBlbmNfZmVhdHVyZXMg
fCBORVRJRl9GX0dTT19FTkNBUF9BTEwgfA0KIAkJCQkgICAgTkVUSUZfRl9HU09fVURQX0w0Ow0K
Kwlib25kX2Rldi0+bXBsc19mZWF0dXJlcyA9IG1wbHNfZmVhdHVyZXM7DQogCWJvbmRfZGV2LT5n
c29fbWF4X3NlZ3MgPSBnc29fbWF4X3NlZ3M7DQogCW5ldGlmX3NldF9nc29fbWF4X3NpemUoYm9u
ZF9kZXYsIGdzb19tYXhfc2l6ZSk7DQogDQotLSANCjEuOC4zLjENCg0K
