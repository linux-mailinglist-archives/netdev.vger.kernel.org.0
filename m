Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEA955638
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbfFYRsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:07 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:15870
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729493AbfFYRsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hR92U0+Fsu/pRjsSjcQx4rBpcWHa6F41ezVjga8nmFc=;
 b=iQfbT7P99QqOYPBXNQXPHLHLmpJOhv6LtwpCRjra/jo6DIOKXI/zOfSz6Tzmg+UI0Gvsy2ikyWoc+VVkxddFR7PQqkLYG5kN1A2BvBML28z2jD5Ix3GppDx++A6b6elDNlEAU1Z19nIBZkvnkCw/hidgvscE22Rd5FOTY4carpI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:47:56 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:47:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH V2 mlx5-next 04/13] net/mlx5: Introduce a helper API to check
 VF vport
Thread-Topic: [PATCH V2 mlx5-next 04/13] net/mlx5: Introduce a helper API to
 check VF vport
Thread-Index: AQHVK34fLpknZRkAU023BHKdZiWbSg==
Date:   Tue, 25 Jun 2019 17:47:56 +0000
Message-ID: <20190625174727.20309-5-saeedm@mellanox.com>
References: <20190625174727.20309-1-saeedm@mellanox.com>
In-Reply-To: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 61e7eaeb-bf22-4208-4e2e-08d6f995415c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB22164FBDDDBF2D6C6CDF9AA3BEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XHHt2tDzCXGze4oM01qccAFDqhOyfyoDQhAllxdc+E7zKbZVbviAQt1uEisAlkhqTFke8S/15xcE1b/UoO51tn2xSrhMBjFIY6KSiKnNbLWLnfDQwPpgGOD6git5GinyzrhXBqFrcYNMzxbEGOiW7ElzFMQW3pNnEy1dYVcqYiX8DKE9VPju/IJze0JkASexb9BhiXxI2fDs3JCgtKNhhS4QrOVnKswvzjhzvF/+yTtaQUOPs218gar0yKdqVD5bKFIKuTKt3eUrlYhRNy2f7XC6pXrYqMKzF7HtaS68yiKPYxKNDISFYRJiIE4F49LIEw33+UhYnT0goE+bH7CrDojAg2O0poExMSUKbCyLrcRjcq19pmceMOd/g5uokjSZ42l0embAbtLPl0oarUUlGlTRrYjQcsCteH9tsin9VWw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e7eaeb-bf22-4208-4e2e-08d6f995415c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:47:56.5478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCkludHJvZHVjZSBhIGhl
bHBlciBBUEkgbWx4NV9lc3dpdGNoX2lzX3ZmX3Zwb3J0KCkgdG8gY2hlY2sNCmlmIGEgZ2l2ZW4g
dnBvcnRfbnVtIGJlbG9uZ3MgdG8gVkYgb3Igbm90Lg0KDQpTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQ
YW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBKaWFuYm8gTGl1IDxqaWFu
Ym9sQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2Vzd2l0Y2guaCAgICAgICAgICB8IDIgKysNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jIHwgNiArKysrKysNCiAyIGZpbGVzIGNo
YW5nZWQsIDggaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lc3dpdGNoLmgNCmluZGV4IDhiOWYyY2Y1OGU5MS4uOTlkYzI1NjMw
NjI5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2Vzd2l0Y2guaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2Vzd2l0Y2guaA0KQEAgLTUwOCw2ICs1MDgsOCBAQCB2b2lkIG1seDVlX3RjX2NsZWFuX2ZkYl9w
ZWVyX2Zsb3dzKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdyk7DQogc3RydWN0IG1seDVfdnBvcnQg
Kl9fbXVzdF9jaGVjaw0KIG1seDVfZXN3aXRjaF9nZXRfdnBvcnQoc3RydWN0IG1seDVfZXN3aXRj
aCAqZXN3LCB1MTYgdnBvcnRfbnVtKTsNCiANCitib29sIG1seDVfZXN3aXRjaF9pc192Zl92cG9y
dChjb25zdCBzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIHUxNiB2cG9ydF9udW0pOw0KKw0KICNl
bHNlICAvKiBDT05GSUdfTUxYNV9FU1dJVENIICovDQogLyogZXN3aXRjaCBBUEkgc3R1YnMgKi8N
CiBzdGF0aWMgaW5saW5lIGludCAgbWx4NV9lc3dpdGNoX2luaXQoc3RydWN0IG1seDVfY29yZV9k
ZXYgKmRldikgeyByZXR1cm4gMDsgfQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQppbmRleCAxN2FiYjk4
YjQ4YWYuLmMxYzQyYzEzNzBiOCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCkBAIC0yMjkwLDMg
KzIyOTAsOSBAQCBzdHJ1Y3QgbWx4NV9lc3dpdGNoX3JlcCAqbWx4NV9lc3dpdGNoX3Zwb3J0X3Jl
cChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQogCXJldHVybiBtbHg1X2Vzd2l0Y2hfZ2V0X3Jl
cChlc3csIHZwb3J0KTsNCiB9DQogRVhQT1JUX1NZTUJPTChtbHg1X2Vzd2l0Y2hfdnBvcnRfcmVw
KTsNCisNCitib29sIG1seDVfZXN3aXRjaF9pc192Zl92cG9ydChjb25zdCBzdHJ1Y3QgbWx4NV9l
c3dpdGNoICplc3csIHUxNiB2cG9ydF9udW0pDQorew0KKwlyZXR1cm4gdnBvcnRfbnVtID49IE1M
WDVfVlBPUlRfRklSU1RfVkYgJiYNCisJICAgICAgIHZwb3J0X251bSA8PSBlc3ctPmRldi0+cHJp
di5zcmlvdi5tYXhfdmZzOw0KK30NCi0tIA0KMi4yMS4wDQoNCg==
