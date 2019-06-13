Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645CF44DA3
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfFMUkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:40:06 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:2635
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729558AbfFMUkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 16:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlXtbsiNYYfMEacNFxslvGydOiCICw2OjRHaT5+y6lc=;
 b=l8D/fk2LhUKbfiY2T0Y098MTI1+DAdUlqzI/LU5b5y1hPXm71ICE853OQpH8wQ9BxoMeB+fRZOGsVlhuy24506UC6jW1cnwOoylmsPTzAPpJtgwxNxk3PHbxPZTmPUKkgN9ivhoZItZCfC7gtDlMStTPQAhiJ9BLG8DjPrdy378=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2629.eurprd05.prod.outlook.com (10.172.225.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Thu, 13 Jun 2019 20:39:36 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 20:39:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 11/15] net/mlx5: Report devlink health on FW issues
Thread-Topic: [net-next v2 11/15] net/mlx5: Report devlink health on FW issues
Thread-Index: AQHVIigdwHWljQXKXE2aXgvM9ZTWVg==
Date:   Thu, 13 Jun 2019 20:39:36 +0000
Message-ID: <20190613203825.31049-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 785d6016-e5f7-4302-f67f-08d6f03f3f5d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2629;
x-ms-traffictypediagnostic: DB6PR0501MB2629:
x-microsoft-antispam-prvs: <DB6PR0501MB262931345C33B1CC98BBBBC5BEEF0@DB6PR0501MB2629.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(8676002)(6916009)(81156014)(81166006)(2616005)(316002)(11346002)(25786009)(4326008)(6512007)(86362001)(476003)(486006)(8936002)(6436002)(446003)(50226002)(6486002)(66066001)(36756003)(26005)(305945005)(7736002)(186003)(73956011)(66946007)(64756008)(66446008)(66556008)(66476007)(53936002)(6116002)(256004)(14444005)(3846002)(1076003)(71190400001)(71200400001)(2906002)(478600001)(99286004)(52116002)(14454004)(102836004)(54906003)(76176011)(5660300002)(6506007)(107886003)(386003)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2629;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 248Sm8iwr3U73FqAzdjBMPDqRA0m9BtVfjV9liRcV1d1HxjSlwWzQh171lypd7B9pmVj6QjTtEEuUtSSGLpiyY5tTYQeT9J2KIcq7sFq37M2/PWSQvpg78HuUB4+Toq4Wip+xZa/gKr0GWhNMNoNXcU8oDWz/uJVJhABOAYx8ZnWXKKTjgZnqRTUIfjfNGmOgUwqzT9xwUThiU7wL82xFc0nuTIa8GqzL+XmUN2/LtMC65jdxsXV6AXezMKsBGThMCmXPCaE0kMCAp5tVmqjXizQJA7nKFP1mSYQYdoAST+6Wf5osCRndMJ2QAsa4ugzj7/os59+8mzIb9q4H4vM6cQp3Ze90GztawnL+kuhbDoWdfgkERSq28yYCei1IikHgxQmGz5sIz1SuRHGZueHHvITDgCUgh5nDKmZCIq307s=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 785d6016-e5f7-4302-f67f-08d6f03f3f5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 20:39:36.2507
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

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpVc2UgZGV2bGlua19o
ZWFsdGhfcmVwb3J0KCkgdG8gcmVwb3J0IGFueSBzeW1wdG9tIG9mIEZXIGlzc3VlIGFzIEZXDQpj
b3VudGVyIG1pc3Mgb3IgbmV3IGhlYWx0aCBzeW5kcm9tZS4NClRoZSBGVyBpc3N1ZXMgZGV0ZWN0
ZWQgaW4gbWx4NSBkdXJpbmcgcG9sbF9oZWFsdGggd2hpY2ggaXMgY2FsbGVkIGluDQp0aW1lciBh
dG9taWMgY29udGV4dCBhbmQgc28gaGVhbHRoIHdvcmsgcXVldWUgaXMgdXNlZCB0byBzY2hlZHVs
ZSB0aGUNCnJlcG9ydHMuDQoNClNpZ25lZC1vZmYtYnk6IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1l
bGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IEVyYW4gQmVuIEVsaXNoYSA8ZXJhbmJlQG1lbGxh
bm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3gu
Y29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMg
IHwgMzMgKysrKysrKysrKysrKysrKysrKw0KIGluY2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaCAg
ICAgICAgICAgICAgICAgICB8ICAzICstDQogMiBmaWxlcyBjaGFuZ2VkLCAzNSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRoLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvaGVhbHRoLmMNCmluZGV4IDFjMjBkM2YxZDIzOC4uNWU4NzZmMWRlMTE0IDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2hlYWx0
aC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvaGVhbHRo
LmMNCkBAIC01MTUsNiArNTE1LDI5IEBAIG1seDVfZndfcmVwb3J0ZXJfZHVtcChzdHJ1Y3QgZGV2
bGlua19oZWFsdGhfcmVwb3J0ZXIgKnJlcG9ydGVyLA0KIAlyZXR1cm4gbWx4NV9md190cmFjZXJf
Z2V0X3NhdmVkX3RyYWNlc19vYmplY3RzKGRldi0+dHJhY2VyLCBmbXNnKTsNCiB9DQogDQorc3Rh
dGljIHZvaWQgbWx4NV9md19yZXBvcnRlcl9lcnJfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndv
cmspDQorew0KKwlzdHJ1Y3QgbWx4NV9md19yZXBvcnRlcl9jdHggZndfcmVwb3J0ZXJfY3R4Ow0K
KwlzdHJ1Y3QgbWx4NV9jb3JlX2hlYWx0aCAqaGVhbHRoOw0KKw0KKwloZWFsdGggPSBjb250YWlu
ZXJfb2Yod29yaywgc3RydWN0IG1seDVfY29yZV9oZWFsdGgsIHJlcG9ydF93b3JrKTsNCisNCisJ
aWYgKElTX0VSUl9PUl9OVUxMKGhlYWx0aC0+ZndfcmVwb3J0ZXIpKQ0KKwkJcmV0dXJuOw0KKw0K
Kwlmd19yZXBvcnRlcl9jdHguZXJyX3N5bmQgPSBoZWFsdGgtPnN5bmQ7DQorCWZ3X3JlcG9ydGVy
X2N0eC5taXNzX2NvdW50ZXIgPSBoZWFsdGgtPm1pc3NfY291bnRlcjsNCisJaWYgKGZ3X3JlcG9y
dGVyX2N0eC5lcnJfc3luZCkgew0KKwkJZGV2bGlua19oZWFsdGhfcmVwb3J0KGhlYWx0aC0+Zndf
cmVwb3J0ZXIsDQorCQkJCSAgICAgICJGVyBzeW5kcm9tIHJlcG9ydGVkIiwgJmZ3X3JlcG9ydGVy
X2N0eCk7DQorCQlyZXR1cm47DQorCX0NCisJaWYgKGZ3X3JlcG9ydGVyX2N0eC5taXNzX2NvdW50
ZXIpDQorCQlkZXZsaW5rX2hlYWx0aF9yZXBvcnQoaGVhbHRoLT5md19yZXBvcnRlciwNCisJCQkJ
ICAgICAgIkZXIG1pc3MgY291bnRlciByZXBvcnRlZCIsDQorCQkJCSAgICAgICZmd19yZXBvcnRl
cl9jdHgpOw0KK30NCisNCiBzdGF0aWMgY29uc3Qgc3RydWN0IGRldmxpbmtfaGVhbHRoX3JlcG9y
dGVyX29wcyBtbHg1X2Z3X3JlcG9ydGVyX29wcyA9IHsNCiAJCS5uYW1lID0gImZ3IiwNCiAJCS5k
aWFnbm9zZSA9IG1seDVfZndfcmVwb3J0ZXJfZGlhZ25vc2UsDQpAQCAtNTcyLDcgKzU5NSw5IEBA
IHN0YXRpYyB2b2lkIHBvbGxfaGVhbHRoKHN0cnVjdCB0aW1lcl9saXN0ICp0KQ0KIHsNCiAJc3Ry
dWN0IG1seDVfY29yZV9kZXYgKmRldiA9IGZyb21fdGltZXIoZGV2LCB0LCBwcml2LmhlYWx0aC50
aW1lcik7DQogCXN0cnVjdCBtbHg1X2NvcmVfaGVhbHRoICpoZWFsdGggPSAmZGV2LT5wcml2Lmhl
YWx0aDsNCisJc3RydWN0IGhlYWx0aF9idWZmZXIgX19pb21lbSAqaCA9IGhlYWx0aC0+aGVhbHRo
Ow0KIAl1MzIgZmF0YWxfZXJyb3I7DQorCXU4IHByZXZfc3luZDsNCiAJdTMyIGNvdW50Ow0KIA0K
IAlpZiAoZGV2LT5zdGF0ZSA9PSBNTFg1X0RFVklDRV9TVEFURV9JTlRFUk5BTF9FUlJPUikNCkBA
IC01ODgsOCArNjEzLDE0IEBAIHN0YXRpYyB2b2lkIHBvbGxfaGVhbHRoKHN0cnVjdCB0aW1lcl9s
aXN0ICp0KQ0KIAlpZiAoaGVhbHRoLT5taXNzX2NvdW50ZXIgPT0gTUFYX01JU1NFUykgew0KIAkJ
bWx4NV9jb3JlX2VycihkZXYsICJkZXZpY2UncyBoZWFsdGggY29tcHJvbWlzZWQgLSByZWFjaGVk
IG1pc3MgY291bnRcbiIpOw0KIAkJcHJpbnRfaGVhbHRoX2luZm8oZGV2KTsNCisJCXF1ZXVlX3dv
cmsoaGVhbHRoLT53cSwgJmhlYWx0aC0+cmVwb3J0X3dvcmspOw0KIAl9DQogDQorCXByZXZfc3lu
ZCA9IGhlYWx0aC0+c3luZDsNCisJaGVhbHRoLT5zeW5kID0gaW9yZWFkOCgmaC0+c3luZCk7DQor
CWlmIChoZWFsdGgtPnN5bmQgJiYgaGVhbHRoLT5zeW5kICE9IHByZXZfc3luZCkNCisJCXF1ZXVl
X3dvcmsoaGVhbHRoLT53cSwgJmhlYWx0aC0+cmVwb3J0X3dvcmspOw0KKw0KIAlmYXRhbF9lcnJv
ciA9IGNoZWNrX2ZhdGFsX3NlbnNvcnMoZGV2KTsNCiANCiAJaWYgKGZhdGFsX2Vycm9yICYmICFo
ZWFsdGgtPmZhdGFsX2Vycm9yKSB7DQpAQCAtNjM5LDYgKzY3MCw3IEBAIHZvaWQgbWx4NV9kcmFp
bl9oZWFsdGhfd3Eoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldikNCiAJc3Bpbl9sb2NrX2lycXNh
dmUoJmhlYWx0aC0+d3FfbG9jaywgZmxhZ3MpOw0KIAlzZXRfYml0KE1MWDVfRFJPUF9ORVdfSEVB
TFRIX1dPUkssICZoZWFsdGgtPmZsYWdzKTsNCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaGVh
bHRoLT53cV9sb2NrLCBmbGFncyk7DQorCWNhbmNlbF93b3JrX3N5bmMoJmhlYWx0aC0+cmVwb3J0
X3dvcmspOw0KIAljYW5jZWxfd29ya19zeW5jKCZoZWFsdGgtPndvcmspOw0KIH0NCiANCkBAIC02
NzUsNiArNzA3LDcgQEAgaW50IG1seDVfaGVhbHRoX2luaXQoc3RydWN0IG1seDVfY29yZV9kZXYg
KmRldikNCiAJCXJldHVybiAtRU5PTUVNOw0KIAlzcGluX2xvY2tfaW5pdCgmaGVhbHRoLT53cV9s
b2NrKTsNCiAJSU5JVF9XT1JLKCZoZWFsdGgtPndvcmssIGhlYWx0aF9jYXJlKTsNCisJSU5JVF9X
T1JLKCZoZWFsdGgtPnJlcG9ydF93b3JrLCBtbHg1X2Z3X3JlcG9ydGVyX2Vycl93b3JrKTsNCiAN
CiAJbWx4NV9md19yZXBvcnRlcl9jcmVhdGUoZGV2KTsNCiANCmRpZmYgLS1naXQgYS9pbmNsdWRl
L2xpbnV4L21seDUvZHJpdmVyLmggYi9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCmluZGV4
IDhkNWQwNjVkMWFhNi4uMTkzMWE0MDgwZDc4IDEwMDY0NA0KLS0tIGEvaW5jbHVkZS9saW51eC9t
bHg1L2RyaXZlci5oDQorKysgYi9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCkBAIC00MzUs
NyArNDM1LDcgQEAgc3RydWN0IG1seDVfY29yZV9oZWFsdGggew0KIAlzdHJ1Y3QgdGltZXJfbGlz
dAkJdGltZXI7DQogCXUzMgkJCQlwcmV2Ow0KIAlpbnQJCQkJbWlzc19jb3VudGVyOw0KLQlib29s
CQkJCXNpY2s7DQorCXU4CQkJCXN5bmQ7DQogCXUzMgkJCQlmYXRhbF9lcnJvcjsNCiAJdTMyCQkJ
CWNyZHVtcF9zaXplOw0KIAkvKiB3cSBzcGlubG9jayB0byBzeW5jaHJvbml6ZSBkcmFpbmluZyAq
Lw0KQEAgLTQ0Myw2ICs0NDMsNyBAQCBzdHJ1Y3QgbWx4NV9jb3JlX2hlYWx0aCB7DQogCXN0cnVj
dCB3b3JrcXVldWVfc3RydWN0CSAgICAgICAqd3E7DQogCXVuc2lnbmVkIGxvbmcJCQlmbGFnczsN
CiAJc3RydWN0IHdvcmtfc3RydWN0CQl3b3JrOw0KKwlzdHJ1Y3Qgd29ya19zdHJ1Y3QJCXJlcG9y
dF93b3JrOw0KIAlzdHJ1Y3QgZGVsYXllZF93b3JrCQlyZWNvdmVyX3dvcms7DQogCXN0cnVjdCBk
ZXZsaW5rX2hlYWx0aF9yZXBvcnRlciAqZndfcmVwb3J0ZXI7DQogfTsNCi0tIA0KMi4yMS4wDQoN
Cg==
