Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6946113C66
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 02:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfEEAe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 20:34:27 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:1287
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727295AbfEEAe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 20:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Chh84IYY/8fOijQ+Ep9s9oHnKjNFYK2VcRLohNAQgXw=;
 b=ZdVl97ov9zFFAuc76JO/Ob0u147YgmBLkyR01PTDnEswY8fuud3zw8WzTzMPkeFog2Pp6XO6Gwek549pDHbGmvstLw2bZOs6oci2Oi9rQFsidvt+Q+hvyQDCTEEerp990EOGVgj0VHbd+66inMYCq5XRMtvTCxcaqCgZV0FFFMQ=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5881.eurprd05.prod.outlook.com (20.179.10.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Sun, 5 May 2019 00:33:25 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 00:33:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/mlx5: Add core dump register access functions
Thread-Topic: [net-next 10/15] net/mlx5: Add core dump register access
 functions
Thread-Index: AQHVAtomBM9ZBzctLU+LfeAHPJZ+RA==
Date:   Sun, 5 May 2019 00:33:25 +0000
Message-ID: <20190505003207.1353-11-saeedm@mellanox.com>
References: <20190505003207.1353-1-saeedm@mellanox.com>
In-Reply-To: <20190505003207.1353-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad482b16-9f22-429e-ce6d-08d6d0f14917
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5881;
x-ms-traffictypediagnostic: DB8PR05MB5881:
x-microsoft-antispam-prvs: <DB8PR05MB5881467E29F0C2AFE5154D0ABE370@DB8PR05MB5881.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39850400004)(136003)(396003)(199004)(189003)(305945005)(52116002)(76176011)(36756003)(316002)(25786009)(6486002)(478600001)(14454004)(446003)(50226002)(476003)(11346002)(2616005)(26005)(7736002)(4326008)(99286004)(86362001)(6916009)(53936002)(66476007)(186003)(68736007)(66446008)(64756008)(66556008)(6436002)(66946007)(73956011)(6512007)(14444005)(1076003)(66066001)(71190400001)(71200400001)(54906003)(256004)(102836004)(81156014)(81166006)(8936002)(3846002)(6506007)(386003)(107886003)(2906002)(8676002)(5660300002)(6116002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5881;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: o4hZ9vWkGctN/PGcSngYiDCpLk0e4WwGcCRTbhYK3cGbhfoK8hXrplg5a8JdpdUD8kCQFP6zKYh9JG9o6wTdO3abdcMPesQWEIOmiyPWDeO9rNUDQDR49Putlm5n6xK04TbT/zmxz16tbqIXw6fsoKnjCseFL3b9UsYe3m1w3LbXjIessoUqup6t2sDuPawGri0hPJKT4h8iQQwqc8Ui50SPHHVI29Hec/a4C6J1gQuqZFIqJVCWhUe9QEjp9uyZD/ahGNqokr1bREKzrih35O1tUTFvxrqwzyhlI32VXLdk0QWYPJ8r1Cm2Ekx8ZdnfvRfV4WwGkIoVbml8sk2hkeAWqZ+ks1svwEyfgrOd296K/HV9uH76IbdB1aPUN2tPvXGAOUk5pnMDQ30CcIE3VReWBtK2h3IvWb5DvrGx0qE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad482b16-9f22-429e-ce6d-08d6d0f14917
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 00:33:25.4538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpBZGQgYWNjZXNzIGZ1
bmN0aW9ucyB0byBjb3JlIGR1bXAgcmVnaXN0ZXIgdG8gZW5hYmxlIHRyaWdnZXIgRlcgY29yZQ0K
ZHVtcC4NCg0KU2lnbmVkLW9mZi1ieTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29t
Pg0KU2lnbmVkLW9mZi1ieTogRXJhbiBCZW4gRWxpc2hhIDxlcmFuYmVAbWVsbGFub3guY29tPg0K
U2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0N
CiAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMgICAgICAgfCAzNCArKysr
KysrKysrKysrKysrKysrDQogaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oICAgICAgICAgICAg
ICAgICAgIHwgIDEgKw0KIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oICAgICAgICAgICAg
ICAgICB8IDE3ICsrKysrKysrKy0NCiAzIGZpbGVzIGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9kaWFnL2Z3X3RyYWNlci5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMNCmluZGV4IDY5OTlmNDQ4NmU5ZS4uNTYw
MjU3OTdjZDFlIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9kaWFnL2Z3X3RyYWNlci5jDQpAQCAtNzg2LDYgKzc4Niw0MCBAQCBzdGF0
aWMgdm9pZCBtbHg1X2Z3X3RyYWNlcl9vd25lcnNoaXBfY2hhbmdlKHN0cnVjdCB3b3JrX3N0cnVj
dCAqd29yaykNCiAJbWx4NV9md190cmFjZXJfc3RhcnQodHJhY2VyKTsNCiB9DQogDQorc3RhdGlj
IGludCBtbHg1X2Z3X3RyYWNlcl9zZXRfY29yZV9kdW1wX3JlZyhzdHJ1Y3QgbWx4NV9jb3JlX2Rl
diAqZGV2LA0KKwkJCQkJICAgIHUzMiAqaW4sIGludCBzaXplX2luKQ0KK3sNCisJdTMyIG91dFtN
TFg1X1NUX1NaX0RXKGNvcmVfZHVtcF9yZWcpXSA9IHt9Ow0KKw0KKwlpZiAoIU1MWDVfQ0FQX0RF
QlVHKGRldiwgY29yZV9kdW1wX2dlbmVyYWwpICYmDQorCSAgICAhTUxYNV9DQVBfREVCVUcoZGV2
LCBjb3JlX2R1bXBfcXApKQ0KKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KKw0KKwlyZXR1cm4gbWx4
NV9jb3JlX2FjY2Vzc19yZWcoZGV2LCBpbiwgc2l6ZV9pbiwgb3V0LCBzaXplb2Yob3V0KSwNCisJ
CQkJICAgIE1MWDVfUkVHX0NPUkVfRFVNUCwgMCwgMSk7DQorfQ0KKw0KK2ludCBtbHg1X2Z3X3Ry
YWNlcl90cmlnZ2VyX2NvcmVfZHVtcF9nZW5lcmFsKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYp
DQorew0KKwlzdHJ1Y3QgbWx4NV9md190cmFjZXIgKnRyYWNlciA9IGRldi0+dHJhY2VyOw0KKwl1
MzIgaW5bTUxYNV9TVF9TWl9EVyhjb3JlX2R1bXBfcmVnKV0gPSB7fTsNCisJaW50IGVycjsNCisN
CisJaWYgKCFNTFg1X0NBUF9ERUJVRyhkZXYsIGNvcmVfZHVtcF9nZW5lcmFsKSB8fCAhdHJhY2Vy
KQ0KKwkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KKwlpZiAoIXRyYWNlci0+b3duZXIpDQorCQlyZXR1
cm4gLUVQRVJNOw0KKw0KKwlNTFg1X1NFVChjb3JlX2R1bXBfcmVnLCBpbiwgY29yZV9kdW1wX3R5
cGUsIDB4MCk7DQorDQorCWVyciA9ICBtbHg1X2Z3X3RyYWNlcl9zZXRfY29yZV9kdW1wX3JlZyhk
ZXYsIGluLCBzaXplb2YoaW4pKTsNCisJaWYgKGVycikNCisJCXJldHVybiBlcnI7DQorCXF1ZXVl
X3dvcmsodHJhY2VyLT53b3JrX3F1ZXVlLCAmdHJhY2VyLT5oYW5kbGVfdHJhY2VzX3dvcmspOw0K
KwlmbHVzaF93b3JrcXVldWUodHJhY2VyLT53b3JrX3F1ZXVlKTsNCisJcmV0dXJuIDA7DQorfQ0K
Kw0KIC8qIENyZWF0ZSBzb2Z0d2FyZSByZXNvdXJjZXMgKEJ1ZmZlcnMsIGV0YyAuLikgKi8NCiBz
dHJ1Y3QgbWx4NV9md190cmFjZXIgKm1seDVfZndfdHJhY2VyX2NyZWF0ZShzdHJ1Y3QgbWx4NV9j
b3JlX2RldiAqZGV2KQ0KIHsNCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVy
LmggYi9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCmluZGV4IGEzNjJhYTZjNzk5Yy4uZWJk
YTcwOTg0NjAxIDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oDQorKysg
Yi9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCkBAIC0xMDgsNiArMTA4LDcgQEAgZW51bSB7
DQogCU1MWDVfUkVHX0ZQR0FfQ0FQCSA9IDB4NDAyMiwNCiAJTUxYNV9SRUdfRlBHQV9DVFJMCSA9
IDB4NDAyMywNCiAJTUxYNV9SRUdfRlBHQV9BQ0NFU1NfUkVHID0gMHg0MDI0LA0KKwlNTFg1X1JF
R19DT1JFX0RVTVAJID0gMHg0MDJlLA0KIAlNTFg1X1JFR19QQ0FQCQkgPSAweDUwMDEsDQogCU1M
WDVfUkVHX1BNVFUJCSA9IDB4NTAwMywNCiAJTUxYNV9SRUdfUFRZUwkJID0gMHg1MDA0LA0KZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oIGIvaW5jbHVkZS9saW51eC9t
bHg1L21seDVfaWZjLmgNCmluZGV4IDgyNjEyNzQxYjI5ZS4uOWJhZWUyOWI3MTI0IDEwMDY0NA0K
LS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCisrKyBiL2luY2x1ZGUvbGludXgv
bWx4NS9tbHg1X2lmYy5oDQpAQCAtNzE1LDcgKzcxNSw5IEBAIHN0cnVjdCBtbHg1X2lmY19xb3Nf
Y2FwX2JpdHMgew0KIH07DQogDQogc3RydWN0IG1seDVfaWZjX2RlYnVnX2NhcF9iaXRzIHsNCi0J
dTggICAgICAgICByZXNlcnZlZF9hdF8wWzB4MjBdOw0KKwl1OCAgICAgICAgIGNvcmVfZHVtcF9n
ZW5lcmFsWzB4MV07DQorCXU4ICAgICAgICAgY29yZV9kdW1wX3FwWzB4MV07DQorCXU4ICAgICAg
ICAgcmVzZXJ2ZWRfYXRfMlsweDFlXTsNCiANCiAJdTggICAgICAgICByZXNlcnZlZF9hdF8yMFsw
eDJdOw0KIAl1OCAgICAgICAgIHN0YWxsX2RldGVjdFsweDFdOw0KQEAgLTI1MzEsNiArMjUzMyw3
IEBAIHVuaW9uIG1seDVfaWZjX2hjYV9jYXBfdW5pb25fYml0cyB7DQogCXN0cnVjdCBtbHg1X2lm
Y19lX3N3aXRjaF9jYXBfYml0cyBlX3N3aXRjaF9jYXA7DQogCXN0cnVjdCBtbHg1X2lmY192ZWN0
b3JfY2FsY19jYXBfYml0cyB2ZWN0b3JfY2FsY19jYXA7DQogCXN0cnVjdCBtbHg1X2lmY19xb3Nf
Y2FwX2JpdHMgcW9zX2NhcDsNCisJc3RydWN0IG1seDVfaWZjX2RlYnVnX2NhcF9iaXRzIGRlYnVn
X2NhcDsNCiAJc3RydWN0IG1seDVfaWZjX2ZwZ2FfY2FwX2JpdHMgZnBnYV9jYXA7DQogCXU4ICAg
ICAgICAgcmVzZXJ2ZWRfYXRfMFsweDgwMDBdOw0KIH07DQpAQCAtODU0Niw2ICs4NTQ5LDE4IEBA
IHN0cnVjdCBtbHg1X2lmY19xY2FtX3JlZ19iaXRzIHsNCiAJdTggICAgICAgICByZXNlcnZlZF9h
dF8xYzBbMHg4MF07DQogfTsNCiANCitzdHJ1Y3QgbWx4NV9pZmNfY29yZV9kdW1wX3JlZ19iaXRz
IHsNCisJdTggICAgICAgICByZXNlcnZlZF9hdF8wWzB4MThdOw0KKwl1OCAgICAgICAgIGNvcmVf
ZHVtcF90eXBlWzB4OF07DQorDQorCXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMjBbMHgzMF07DQor
CXU4ICAgICAgICAgdmhjYV9pZFsweDEwXTsNCisNCisJdTggICAgICAgICByZXNlcnZlZF9hdF82
MFsweDhdOw0KKwl1OCAgICAgICAgIHFwblsweDE4XTsNCisJdTggICAgICAgICByZXNlcnZlZF9h
dF84MFsweDE4MF07DQorfTsNCisNCiBzdHJ1Y3QgbWx4NV9pZmNfcGNhcF9yZWdfYml0cyB7DQog
CXU4ICAgICAgICAgcmVzZXJ2ZWRfYXRfMFsweDhdOw0KIAl1OCAgICAgICAgIGxvY2FsX3BvcnRb
MHg4XTsNCi0tIA0KMi4yMC4xDQoNCg==
