Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750B633B78
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFCWg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:36:58 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:6068
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726163AbfFCWgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 18:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwX+38+H+tk8sc6X1RXbf/70tWby43NBe4Jprh7iXIc=;
 b=aLmawRKKx3S+RhHFeS8Y0ZNWugGzgduIU5lVKcOuJLVHeXv/viX1/3qajUUyOG2+3XsaTdy7cseuTb0rhx5rBW/W1B3jrCY8JBERqbPV4/IRAd8j3gorGHz+qss4R9hczE7HMcn/KGOzH2zmYYVvzYwbWEGN2Nfuz6Khdlahpr0=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3250.eurprd05.prod.outlook.com (10.170.126.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Mon, 3 Jun 2019 22:36:46 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::55c3:8aaf:20f6:5899]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::55c3:8aaf:20f6:5899%5]) with mapi id 15.20.1922.021; Mon, 3 Jun 2019
 22:36:46 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@mellanox.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net-next 1/2] net: bonding: Inherit MPLS features from slave
 devices
Thread-Topic: [PATCH net-next 1/2] net: bonding: Inherit MPLS features from
 slave devices
Thread-Index: AQHVGlzTb0sVHTqHN0+KjtGPCs6Ttg==
Date:   Mon, 3 Jun 2019 22:36:46 +0000
Message-ID: <1559601394-5363-2-git-send-email-lariel@mellanox.com>
References: <1559601394-5363-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1559601394-5363-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.226.120.58]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: LO2P265CA0106.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::22) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5680ab3c-c77c-49f2-8da0-08d6e873f5c6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3250;
x-ms-traffictypediagnostic: AM4PR05MB3250:
x-microsoft-antispam-prvs: <AM4PR05MB3250B2E1EC6EA15F79966858BA140@AM4PR05MB3250.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(396003)(39860400002)(346002)(376002)(189003)(199004)(14454004)(86362001)(3846002)(256004)(186003)(6116002)(2501003)(4720700003)(99286004)(4326008)(2351001)(25786009)(66476007)(26005)(386003)(6506007)(11346002)(6916009)(52116002)(36756003)(446003)(71200400001)(76176011)(71190400001)(316002)(305945005)(508600001)(66066001)(486006)(5640700003)(14444005)(2616005)(68736007)(476003)(81166006)(73956011)(8676002)(1730700003)(81156014)(6512007)(8936002)(2906002)(7736002)(5660300002)(66446008)(64756008)(66556008)(6436002)(50226002)(66946007)(54906003)(102836004)(53936002)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3250;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DANH4tfA8o/n9xOCFcsP8QwmfPQkvUdFckgOQsrUYyXrbQ0vCItIiP8lWmRY2JVersdLwihkWX12tS0UO2xnrbBqU0K7bEgCgV+Fv/QnuhFVkv7568cRjanr9XszXBYmRqHteMpxVPckmrtfsDlhi/Q0Cnl0FHa+FFPbLN+WUTrEiPmDNtv9I6mIJy/THZd0FMPxjjOL/ZRuwL3oa2Ms6RsNWUqzQo6W5IHpn+Bwv273j9BPnvq1a3lZ9l7tkf4ch4Hw8EnpkbCsbiaCECQvmj6CuddnbNeZbeDjexv9KhsCPrYTYeT+NxkRji50Pn3wYARDEYywk1p5M9u5GzzKl7GZQcYM9QddXAeEHiddmh71UJapNsUf/76bNOvFuEW1JAQxWJhp6zKgap3+fn181odPbFyIGA7uN2c1yWQFlNU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5680ab3c-c77c-49f2-8da0-08d6e873f5c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 22:36:46.4455
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lariel@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3250
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
