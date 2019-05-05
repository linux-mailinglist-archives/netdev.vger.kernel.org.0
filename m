Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F8F13C69
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 02:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfEEAee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 20:34:34 -0400
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:1287
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727434AbfEEAec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 20:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzhWk4Mla3bIZq2XqF+SQzeJcWIUqpotm3sObNQkmBc=;
 b=Dl8BrpkRPEuzIViANBa77jWKW2V/0dLoKOMq7EVI8B9gaNOhQBBaRsiVIGSof8dA4yshttvFEPMZl9yLbStm+4UqbThL6ovDP5vKMNAXlLApMwavoT1l2ymdDBorC17heFGiixi8mSA4PJRiibDoidwGgw2USoGFVLGeMOnZ2AQ=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5881.eurprd05.prod.outlook.com (20.179.10.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Sun, 5 May 2019 00:33:29 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%5]) with mapi id 15.20.1856.012; Sun, 5 May 2019
 00:33:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/15] net/mlx5: Report devlink health on FW issues
Thread-Topic: [net-next 12/15] net/mlx5: Report devlink health on FW issues
Thread-Index: AQHVAtopIO6TRZFjIUqNCGMmW93RRA==
Date:   Sun, 5 May 2019 00:33:29 +0000
Message-ID: <20190505003207.1353-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 64aff3ec-328a-44d7-b06a-08d6d0f14b6c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5881;
x-ms-traffictypediagnostic: DB8PR05MB5881:
x-microsoft-antispam-prvs: <DB8PR05MB58812C5788477B06D3D61C13BE370@DB8PR05MB5881.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00286C0CA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(366004)(39850400004)(136003)(396003)(199004)(189003)(305945005)(52116002)(76176011)(36756003)(316002)(25786009)(6486002)(478600001)(14454004)(446003)(50226002)(476003)(11346002)(2616005)(26005)(7736002)(4326008)(99286004)(86362001)(6916009)(53936002)(66476007)(186003)(68736007)(66446008)(64756008)(66556008)(6436002)(66946007)(73956011)(6512007)(14444005)(1076003)(66066001)(71190400001)(71200400001)(54906003)(256004)(102836004)(81156014)(81166006)(8936002)(3846002)(6506007)(386003)(107886003)(2906002)(8676002)(5660300002)(6116002)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5881;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2sIUn/Ql7M+r1FHduN+i6f69OOnFyEugr/X+9EL//BuNhTKQyMFXKx7UPN8eEbYqwqzKdCsNLnLDR5W+9scRg7Yrf0SBE0YzVqx06TMfVxbX/feNFsv1dKoaW+Iqoq+/sl/npUtD41OYqzfjINQJ9z5ISqYFxsH5II6FvupSNi+PhhdTqWlOhm70fz/dXdqUaCsxYZtL4z9VeE4cqXGYnyTbl0YCAehRdXWaXR9Npxt0gV/P2twl9Y4WkvfsCv6feN7W0UmFrouoC7UaT/4+9LHWI1mjksC2QTsPPCNbZsUpJljHZp0qHzz681kOOCdLFzyJI3fd36AWZoRIUDmPrvKuPKbxdIcslwOcdsUmiIxwzAnKUoKhLxVqffgQNZxJmOIWx2NbRY6zNQsM6fu3LgP4oC3lQPAlAkdD0mQAzoM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64aff3ec-328a-44d7-b06a-08d6d0f14b6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2019 00:33:29.3285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5881
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpVc2UgZGV2bGlua19o
ZWFsdGhfcmVwb3J0KCkgdG8gcmVwb3J0IGFueSBzeW1wdG9tIG9mIEZXIGlzc3VlIGFzIEZXDQpj
b3VudGVyIG1pc3Mgb3IgbmV3IGhlYWx0aCBzeW5kcm9tLg0KVGhlIEZXIGlzc3VlcyBkZXRlY3Rl
ZCBpbiBtbHg1IGR1cmluZyBwb2xsX2hlYWx0aCB3aGljaCBpcyBjYWxsZWQgaW4NCnRpbWVyIGF0
b21pYyBjb250ZXh0IGFuZCBzbyBoZWFsdGggd29yayBxdWV1ZSBpcyB1c2VkIHRvIHNjaGVkdWxl
IHRoZQ0KcmVwb3J0cy4NCg0KU2lnbmVkLW9mZi1ieTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVs
bGFub3guY29tPg0KU2lnbmVkLW9mZi1ieTogRXJhbiBCZW4gRWxpc2hhIDxlcmFuYmVAbWVsbGFu
b3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5j
b20+DQotLS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYyAg
fCAzMyArKysrKysrKysrKysrKysrKysrDQogaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oICAg
ICAgICAgICAgICAgICAgIHwgIDIgKysNCiAyIGZpbGVzIGNoYW5nZWQsIDM1IGluc2VydGlvbnMo
KykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9oZWFsdGguYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFs
dGguYw0KaW5kZXggMzRiODI1MmFmYWQ1Li4wM2I5ZmM5ZWJkNmUgMTAwNjQ0DQotLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMNCisrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9oZWFsdGguYw0KQEAgLTQ5Nyw2ICs0
OTcsMjkgQEAgbWx4NV9md19yZXBvcnRlcl9kdW1wKHN0cnVjdCBkZXZsaW5rX2hlYWx0aF9yZXBv
cnRlciAqcmVwb3J0ZXIsDQogCXJldHVybiBtbHg1X2Z3X3RyYWNlcl9nZXRfc2F2ZWRfdHJhY2Vz
X29iamVjdHMoZGV2LT50cmFjZXIsIGZtc2cpOw0KIH0NCiANCitzdGF0aWMgdm9pZCBtbHg1X2Z3
X3JlcG9ydGVyX2Vycl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCit7DQorCXN0cnVj
dCBtbHg1X2Z3X3JlcG9ydGVyX2N0eCBmd19yZXBvcnRlcl9jdHg7DQorCXN0cnVjdCBtbHg1X2Nv
cmVfaGVhbHRoICpoZWFsdGg7DQorDQorCWhlYWx0aCA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1
Y3QgbWx4NV9jb3JlX2hlYWx0aCwgcmVwb3J0X3dvcmspOw0KKw0KKwlpZiAoSVNfRVJSX09SX05V
TEwoaGVhbHRoLT5md19yZXBvcnRlcikpDQorCQlyZXR1cm47DQorDQorCWZ3X3JlcG9ydGVyX2N0
eC5lcnJfc3luZCA9IGhlYWx0aC0+c3luZDsNCisJZndfcmVwb3J0ZXJfY3R4Lm1pc3NfY291bnRl
ciA9IGhlYWx0aC0+bWlzc19jb3VudGVyOw0KKwlpZiAoZndfcmVwb3J0ZXJfY3R4LmVycl9zeW5k
KSB7DQorCQlkZXZsaW5rX2hlYWx0aF9yZXBvcnQoaGVhbHRoLT5md19yZXBvcnRlciwNCisJCQkJ
ICAgICAgIkZXIHN5bmRyb21lIHJlcG9ydGVkIiwgJmZ3X3JlcG9ydGVyX2N0eCk7DQorCQlyZXR1
cm47DQorCX0NCisJaWYgKGZ3X3JlcG9ydGVyX2N0eC5taXNzX2NvdW50ZXIpDQorCQlkZXZsaW5r
X2hlYWx0aF9yZXBvcnQoaGVhbHRoLT5md19yZXBvcnRlciwNCisJCQkJICAgICAgIkZXIG1pc3Mg
Y291bnRlciByZXBvcnRlZCIsDQorCQkJCSAgICAgICZmd19yZXBvcnRlcl9jdHgpOw0KK30NCisN
CiBzdGF0aWMgY29uc3Qgc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9ydGVyX29wcyBtbHg1X2Z3
X3JlcG9ydGVyX29wcyA9IHsNCiAJCS5uYW1lID0gImZ3IiwNCiAJCS5kaWFnbm9zZSA9IG1seDVf
ZndfcmVwb3J0ZXJfZGlhZ25vc2UsDQpAQCAtNTU0LDggKzU3NywxMCBAQCBzdGF0aWMgdm9pZCBw
b2xsX2hlYWx0aChzdHJ1Y3QgdGltZXJfbGlzdCAqdCkNCiB7DQogCXN0cnVjdCBtbHg1X2NvcmVf
ZGV2ICpkZXYgPSBmcm9tX3RpbWVyKGRldiwgdCwgcHJpdi5oZWFsdGgudGltZXIpOw0KIAlzdHJ1
Y3QgbWx4NV9jb3JlX2hlYWx0aCAqaGVhbHRoID0gJmRldi0+cHJpdi5oZWFsdGg7DQorCXN0cnVj
dCBoZWFsdGhfYnVmZmVyIF9faW9tZW0gKmggPSBoZWFsdGgtPmhlYWx0aDsNCiAJdTMyIGZhdGFs
X2Vycm9yOw0KIAl1MzIgY291bnQ7DQorCXU4IHByZXZfc3luZDsNCiANCiAJaWYgKGRldi0+c3Rh
dGUgPT0gTUxYNV9ERVZJQ0VfU1RBVEVfSU5URVJOQUxfRVJST1IpDQogCQlnb3RvIG91dDsNCkBA
IC01NzAsOCArNTk1LDE0IEBAIHN0YXRpYyB2b2lkIHBvbGxfaGVhbHRoKHN0cnVjdCB0aW1lcl9s
aXN0ICp0KQ0KIAlpZiAoaGVhbHRoLT5taXNzX2NvdW50ZXIgPT0gTUFYX01JU1NFUykgew0KIAkJ
bWx4NV9jb3JlX2VycihkZXYsICJkZXZpY2UncyBoZWFsdGggY29tcHJvbWlzZWQgLSByZWFjaGVk
IG1pc3MgY291bnRcbiIpOw0KIAkJbWx4NV9wcmludF9oZWFsdGhfaW5mbyhkZXYpOw0KKwkJcXVl
dWVfd29yayhoZWFsdGgtPndxLCAmaGVhbHRoLT5yZXBvcnRfd29yayk7DQogCX0NCiANCisJcHJl
dl9zeW5kID0gaGVhbHRoLT5zeW5kOw0KKwloZWFsdGgtPnN5bmQgPSBpb3JlYWQ4KCZoLT5zeW5k
KTsNCisJaWYgKGhlYWx0aC0+c3luZCAmJiBoZWFsdGgtPnN5bmQgIT0gcHJldl9zeW5kKQ0KKwkJ
cXVldWVfd29yayhoZWFsdGgtPndxLCAmaGVhbHRoLT5yZXBvcnRfd29yayk7DQorDQogCWZhdGFs
X2Vycm9yID0gY2hlY2tfZmF0YWxfc2Vuc29ycyhkZXYpOw0KIA0KIAlpZiAoZmF0YWxfZXJyb3Ig
JiYgIWhlYWx0aC0+ZmF0YWxfZXJyb3IpIHsNCkBAIC02MjEsNiArNjUyLDcgQEAgdm9pZCBtbHg1
X2RyYWluX2hlYWx0aF93cShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAlzcGluX2xvY2tf
aXJxc2F2ZSgmaGVhbHRoLT53cV9sb2NrLCBmbGFncyk7DQogCXNldF9iaXQoTUxYNV9EUk9QX05F
V19IRUFMVEhfV09SSywgJmhlYWx0aC0+ZmxhZ3MpOw0KIAlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZoZWFsdGgtPndxX2xvY2ssIGZsYWdzKTsNCisJY2FuY2VsX3dvcmtfc3luYygmaGVhbHRoLT5y
ZXBvcnRfd29yayk7DQogCWNhbmNlbF93b3JrX3N5bmMoJmhlYWx0aC0+d29yayk7DQogfQ0KIA0K
QEAgLTY1OCw2ICs2OTAsNyBAQCBpbnQgbWx4NV9oZWFsdGhfaW5pdChzdHJ1Y3QgbWx4NV9jb3Jl
X2RldiAqZGV2KQ0KIAkJcmV0dXJuIC1FTk9NRU07DQogCXNwaW5fbG9ja19pbml0KCZoZWFsdGgt
PndxX2xvY2spOw0KIAlJTklUX1dPUksoJmhlYWx0aC0+d29yaywgaGVhbHRoX2NhcmUpOw0KKwlJ
TklUX1dPUksoJmhlYWx0aC0+cmVwb3J0X3dvcmssIG1seDVfZndfcmVwb3J0ZXJfZXJyX3dvcmsp
Ow0KIAloZWFsdGgtPmNyZHVtcCA9IE5VTEw7DQogCWhlYWx0aC0+aW5mb19idWYgPSBrbWFsbG9j
KEhFQUxUSF9JTkZPX01BWF9CVUZGLCBHRlBfS0VSTkVMKTsNCiAJaWYgKCFoZWFsdGgtPmluZm9f
YnVmKQ0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaCBiL2luY2x1ZGUv
bGludXgvbWx4NS9kcml2ZXIuaA0KaW5kZXggZWJkYTcwOTg0NjAxLi42MDQwNzliNDcwNmMgMTAw
NjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvbWx4NS9kcml2ZXIuaA0KQEAgLTQzNywxMiArNDM3LDE0IEBAIHN0cnVjdCBtbHg1X2NvcmVf
aGVhbHRoIHsNCiAJc3RydWN0IHRpbWVyX2xpc3QJCXRpbWVyOw0KIAl1MzIJCQkJcHJldjsNCiAJ
aW50CQkJCW1pc3NfY291bnRlcjsNCisJdTgJCQkJc3luZDsNCiAJdTMyCQkJCWZhdGFsX2Vycm9y
Ow0KIAkvKiB3cSBzcGlubG9jayB0byBzeW5jaHJvbml6ZSBkcmFpbmluZyAqLw0KIAlzcGlubG9j
a190CQkJd3FfbG9jazsNCiAJc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QJICAgICAgICp3cTsNCiAJ
dW5zaWduZWQgbG9uZwkJCWZsYWdzOw0KIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJCXdvcms7DQorCXN0
cnVjdCB3b3JrX3N0cnVjdAkJcmVwb3J0X3dvcms7DQogCXN0cnVjdCBkZWxheWVkX3dvcmsJCXJl
Y292ZXJfd29yazsNCiAJc3RydWN0IG1seDVfZndfY3JkdW1wCSAgICAgICAqY3JkdW1wOw0KIAlj
aGFyCQkJICAgICAgICppbmZvX2J1ZjsNCi0tIA0KMi4yMC4xDQoNCg==
