Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6080C44DA1
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbfFMUj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:39:59 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:2635
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729558AbfFMUj6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 16:39:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvLjMUJvUIjMml3jjHmCfGU39niCWYRu3wqbyzop9jU=;
 b=D16XBwgiczX1G5L13YUW9RYcTSQPAUiYhiwzpVFwmQltVDI18lHQo8LxbIlPIPnGvpeMHhPsZP0o9bNH4+rAz7O4Y6N3uXxtB5Ygak8ka0BkmrHyEZbyv47L6zwWHSKIy5DGmrA1t+VRZO5lsDVMoAMf2jid2XGpTNaQENpUBME=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2629.eurprd05.prod.outlook.com (10.172.225.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Thu, 13 Jun 2019 20:39:32 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 20:39:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 09/15] net/mlx5: Create FW devlink_health_reporter
Thread-Topic: [net-next v2 09/15] net/mlx5: Create FW devlink_health_reporter
Thread-Index: AQHVIigaJ48jFkfh5EySrzYdPc5dqg==
Date:   Thu, 13 Jun 2019 20:39:32 +0000
Message-ID: <20190613203825.31049-10-saeedm@mellanox.com>
References: <20190613203825.31049-1-saeedm@mellanox.com>
In-Reply-To: <20190613203825.31049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a0d1ddc-2054-487d-7664-08d6f03f3d28
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2629;
x-ms-traffictypediagnostic: DB6PR0501MB2629:
x-microsoft-antispam-prvs: <DB6PR0501MB26299193BD339864B95222BDBEEF0@DB6PR0501MB2629.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(8676002)(6916009)(81156014)(81166006)(2616005)(316002)(11346002)(25786009)(4326008)(6512007)(86362001)(476003)(486006)(8936002)(6436002)(446003)(50226002)(6486002)(66066001)(36756003)(26005)(305945005)(7736002)(186003)(73956011)(66946007)(64756008)(66446008)(66556008)(66476007)(53936002)(6116002)(256004)(14444005)(3846002)(1076003)(71190400001)(71200400001)(2906002)(478600001)(99286004)(52116002)(14454004)(102836004)(54906003)(76176011)(5660300002)(6506007)(107886003)(386003)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2629;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 515T+ySenjhlXibzxCIthJ/S1erjgAgrOSYckZ6T1lmBXW9ApS/Y6BO7nU2qftQB9KiG2PbRhlnBz3wvPirhcAHPQvk9k0QFPyE3HpH/G2F3I7ZaJtfC1EqN/XagnIMmqjGhl+GpkbVw649u5nwCHNPTT+Z5LqqvLmO8J3Ok+gaL4GuBBfAIRKVIySbClDJdxJoUebrDJ3gTkYvOH+yBFBp5DwCWE95ZYDjqX5HIqmSWxo0eutgNHIyLCl8s4R5sfxKwPQM3GcEREhGz3zfJ50kA6Z9auHKWG1C5XoYmln20tgIqz7OBx+lsyumn6oiMjxuLmeFfl7e+VlDdnjg5pm0FFB/9QQjpAUBYJTBZXjeo+AfdGE1u6yFgP6mlMc6vtcWzNl0Of0Dsghb6x1vwsnBnKE52nb+lg0Dt2/meEtw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0d1ddc-2054-487d-7664-08d6f03f3d28
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 20:39:32.3114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2629
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpDcmVhdGUgbWx4NV9k
ZXZsaW5rX2hlYWx0aF9yZXBvcnRlciBmb3IgRlcgcmVwb3J0ZXIuIFRoZSBGVyByZXBvcnRlcg0K
aW1wbGVtZW50cyBkZXZsaW5rX2hlYWx0aF9yZXBvcnRlciBkaWFnbm9zZSBjYWxsYmFjay4NCg0K
VGhlIGZ3IHJlcG9ydGVyIGRpYWdub3NlIGNvbW1hbmQgY2FuIGJlIHRyaWdnZXJlZCBhbnkgdGlt
ZSBieSB0aGUgdXNlcg0KdG8gY2hlY2sgY3VycmVudCBmdyBzdGF0dXMuDQpJbiBoZWFsdGh5IHN0
YXR1cywgaXQgd2lsbCByZXR1cm4gY2xlYXIgc3luZHJvbWUuIE90aGVyd2lzZSBpdCB3aWxsDQpy
ZXR1cm4gdGhlIHN5bmRyb21lIGFuZCBkZXNjcmlwdGlvbiBvZiB0aGUgZXJyb3IgdHlwZS4NCg0K
Q29tbWFuZCBleGFtcGxlIGFuZCBvdXRwdXQgb24gaGVhbHRoeSBzdGF0dXM6DQokIGRldmxpbmsg
aGVhbHRoIGRpYWdub3NlIHBjaS8wMDAwOjgyOjAwLjAgcmVwb3J0ZXIgZncNClN5bmRyb21lOiAw
DQoNCkNvbW1hbmQgZXhhbXBsZSBhbmQgb3V0cHV0IG9uIG5vbiBoZWFsdGh5IHN0YXR1czoNCiQg
ZGV2bGluayBoZWFsdGggZGlhZ25vc2UgcGNpLzAwMDA6ODI6MDAuMCByZXBvcnRlciBmdw0KU3lu
ZHJvbWU6IDggRGVzY3JpcHRpb246IHVucmVjb3ZlcmFibGUgaGFyZHdhcmUgZXJyb3INCg0KU2ln
bmVkLW9mZi1ieTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KU2lnbmVkLW9m
Zi1ieTogRXJhbiBCZW4gRWxpc2hhIDxlcmFuYmVAbWVsbGFub3guY29tPg0KU2lnbmVkLW9mZi1i
eTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0NCiAuLi4vbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYyAgfCA0OCArKysrKysrKysrKysrKysr
KysrDQogaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oICAgICAgICAgICAgICAgICAgIHwgIDIg
Kw0KIDIgZmlsZXMgY2hhbmdlZCwgNTAgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2hlYWx0aC5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2hlYWx0aC5jDQppbmRleCBjYWY1NGJkN2Q1
MzguLjk3M2NjMDA1YWU2MCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxh
bm94L21seDUvY29yZS9oZWFsdGguYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2hlYWx0aC5jDQpAQCAtMzg4LDYgKzM4OCw1MSBAQCBzdGF0aWMgdm9pZCBw
cmludF9oZWFsdGhfaW5mbyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAltbHg1X2NvcmVf
ZXJyKGRldiwgInJhdyBmd192ZXIgMHglMDh4XG4iLCBmdyk7DQogfQ0KIA0KK3N0YXRpYyBpbnQN
CittbHg1X2Z3X3JlcG9ydGVyX2RpYWdub3NlKHN0cnVjdCBkZXZsaW5rX2hlYWx0aF9yZXBvcnRl
ciAqcmVwb3J0ZXIsDQorCQkJICBzdHJ1Y3QgZGV2bGlua19mbXNnICpmbXNnKQ0KK3sNCisJc3Ry
dWN0IG1seDVfY29yZV9kZXYgKmRldiA9IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyX3ByaXYocmVw
b3J0ZXIpOw0KKwlzdHJ1Y3QgbWx4NV9jb3JlX2hlYWx0aCAqaGVhbHRoID0gJmRldi0+cHJpdi5o
ZWFsdGg7DQorCXN0cnVjdCBoZWFsdGhfYnVmZmVyIF9faW9tZW0gKmggPSBoZWFsdGgtPmhlYWx0
aDsNCisJdTggc3luZDsNCisJaW50IGVycjsNCisNCisJc3luZCA9IGlvcmVhZDgoJmgtPnN5bmQp
Ow0KKwllcnIgPSBkZXZsaW5rX2Ztc2dfdThfcGFpcl9wdXQoZm1zZywgIlN5bmRyb21lIiwgc3lu
ZCk7DQorCWlmIChlcnIgfHwgIXN5bmQpDQorCQlyZXR1cm4gZXJyOw0KKwlyZXR1cm4gZGV2bGlu
a19mbXNnX3N0cmluZ19wYWlyX3B1dChmbXNnLCAiRGVzY3JpcHRpb24iLCBoc3luZF9zdHIoc3lu
ZCkpOw0KK30NCisNCitzdGF0aWMgY29uc3Qgc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVy
X29wcyBtbHg1X2Z3X3JlcG9ydGVyX29wcyA9IHsNCisJCS5uYW1lID0gImZ3IiwNCisJCS5kaWFn
bm9zZSA9IG1seDVfZndfcmVwb3J0ZXJfZGlhZ25vc2UsDQorfTsNCisNCitzdGF0aWMgdm9pZCBt
bHg1X2Z3X3JlcG9ydGVyX2NyZWF0ZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KK3sNCisJ
c3RydWN0IG1seDVfY29yZV9oZWFsdGggKmhlYWx0aCA9ICZkZXYtPnByaXYuaGVhbHRoOw0KKwlz
dHJ1Y3QgZGV2bGluayAqZGV2bGluayA9IHByaXZfdG9fZGV2bGluayhkZXYpOw0KKw0KKwloZWFs
dGgtPmZ3X3JlcG9ydGVyID0NCisJCWRldmxpbmtfaGVhbHRoX3JlcG9ydGVyX2NyZWF0ZShkZXZs
aW5rLCAmbWx4NV9md19yZXBvcnRlcl9vcHMsDQorCQkJCQkgICAgICAgMCwgZmFsc2UsIGRldik7
DQorCWlmIChJU19FUlIoaGVhbHRoLT5md19yZXBvcnRlcikpDQorCQltbHg1X2NvcmVfd2Fybihk
ZXYsICJGYWlsZWQgdG8gY3JlYXRlIGZ3IHJlcG9ydGVyLCBlcnIgPSAlbGRcbiIsDQorCQkJICAg
ICAgIFBUUl9FUlIoaGVhbHRoLT5md19yZXBvcnRlcikpOw0KK30NCisNCitzdGF0aWMgdm9pZCBt
bHg1X2Z3X3JlcG9ydGVyX2Rlc3Ryb3koc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCit7DQor
CXN0cnVjdCBtbHg1X2NvcmVfaGVhbHRoICpoZWFsdGggPSAmZGV2LT5wcml2LmhlYWx0aDsNCisN
CisJaWYgKElTX0VSUl9PUl9OVUxMKGhlYWx0aC0+ZndfcmVwb3J0ZXIpKQ0KKwkJcmV0dXJuOw0K
Kw0KKwlkZXZsaW5rX2hlYWx0aF9yZXBvcnRlcl9kZXN0cm95KGhlYWx0aC0+ZndfcmVwb3J0ZXIp
Ow0KK30NCisNCiBzdGF0aWMgdW5zaWduZWQgbG9uZyBnZXRfbmV4dF9wb2xsX2ppZmZpZXModm9p
ZCkNCiB7DQogCXVuc2lnbmVkIGxvbmcgbmV4dDsNCkBAIC00OTgsNiArNTQzLDcgQEAgdm9pZCBt
bHg1X2hlYWx0aF9jbGVhbnVwKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogCXN0cnVjdCBt
bHg1X2NvcmVfaGVhbHRoICpoZWFsdGggPSAmZGV2LT5wcml2LmhlYWx0aDsNCiANCiAJZGVzdHJv
eV93b3JrcXVldWUoaGVhbHRoLT53cSk7DQorCW1seDVfZndfcmVwb3J0ZXJfZGVzdHJveShkZXYp
Ow0KIH0NCiANCiBpbnQgbWx4NV9oZWFsdGhfaW5pdChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2
KQ0KQEAgLTUxOSw1ICs1NjUsNyBAQCBpbnQgbWx4NV9oZWFsdGhfaW5pdChzdHJ1Y3QgbWx4NV9j
b3JlX2RldiAqZGV2KQ0KIAlzcGluX2xvY2tfaW5pdCgmaGVhbHRoLT53cV9sb2NrKTsNCiAJSU5J
VF9XT1JLKCZoZWFsdGgtPndvcmssIGhlYWx0aF9jYXJlKTsNCiANCisJbWx4NV9md19yZXBvcnRl
cl9jcmVhdGUoZGV2KTsNCisNCiAJcmV0dXJuIDA7DQogfQ0KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgvbWx4NS9kcml2ZXIuaCBiL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KaW5kZXgg
ODkyMDViNmNjN2VmLi44ZDVkMDY1ZDFhYTYgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21s
eDUvZHJpdmVyLmgNCisrKyBiL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KQEAgLTUzLDYg
KzUzLDcgQEANCiAjaW5jbHVkZSA8bGludXgvbWx4NS9lcS5oPg0KICNpbmNsdWRlIDxsaW51eC90
aW1lY291bnRlci5oPg0KICNpbmNsdWRlIDxsaW51eC9wdHBfY2xvY2tfa2VybmVsLmg+DQorI2lu
Y2x1ZGUgPG5ldC9kZXZsaW5rLmg+DQogDQogZW51bSB7DQogCU1MWDVfQk9BUkRfSURfTEVOID0g
NjQsDQpAQCAtNDQzLDYgKzQ0NCw3IEBAIHN0cnVjdCBtbHg1X2NvcmVfaGVhbHRoIHsNCiAJdW5z
aWduZWQgbG9uZwkJCWZsYWdzOw0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJCXdvcms7DQogCXN0cnVj
dCBkZWxheWVkX3dvcmsJCXJlY292ZXJfd29yazsNCisJc3RydWN0IGRldmxpbmtfaGVhbHRoX3Jl
cG9ydGVyICpmd19yZXBvcnRlcjsNCiB9Ow0KIA0KIHN0cnVjdCBtbHg1X3FwX3RhYmxlIHsNCi0t
IA0KMi4yMS4wDQoNCg==
