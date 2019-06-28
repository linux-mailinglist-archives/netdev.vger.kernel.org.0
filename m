Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE755A6F2
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfF1WgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:36:03 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726754AbfF1WgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:36:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=cXW3HVjqb3AgaWQVbaO+WWS02qXHS/55HX8Y0sxNwQBuOcVtNjxN3ZmK7Ds2wfVasHnnBkBT+HaOIih1QEjLlh4ujfClvC57JRNQUCx7+vTlxhl2qfQgKUSAB9X89G3RFIpaYJeual7LbUgE1pkqrdFVvvGNEvfE9/7tIQaCfTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcTQuYLVYLCnx4bH4u1zARas+AzANZADCkg4tJ2nuHc=;
 b=Okpe9KTFy6lD6U9kSNhfSvPNx6TepMCTe4V5NbV94oVbJclnQd1EGv0Fo15/PMrBc9UM+SEjwkxO1h4TKg2dwn8Q5aea03Gu5IG5Y+uE6CcwUMSegNE3bApWXOIqB9O2DDKZyDkn6Y1fzpumtKNhH5FHjdEddDmyxFTGl3DxhYE=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcTQuYLVYLCnx4bH4u1zARas+AzANZADCkg4tJ2nuHc=;
 b=hMRdBo6ppLbYVJmpSyiq9nO53lqdAMD8zYrfbD57g6AaWkSPEJgrTPT8beu+GvcMUgsLcLMvy+zR6gje2bwChoZJ1UtEG8hzDfs/xjNH/6jTH0jniLpJ7cHJwlUGyynjIGyBZbVdOZ9Mr6r5DmJTzTl6QmdK45e5qElfGQ5KFsI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:35:52 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:35:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 03/18] net/mlx5: E-Switch, Use vport index when init
 rep
Thread-Topic: [PATCH mlx5-next 03/18] net/mlx5: E-Switch, Use vport index when
 init rep
Thread-Index: AQHVLgHX+qXNpoAsLkiKqwRBqMEFUA==
Date:   Fri, 28 Jun 2019 22:35:51 +0000
Message-ID: <20190628223516.9368-4-saeedm@mellanox.com>
References: <20190628223516.9368-1-saeedm@mellanox.com>
In-Reply-To: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df059c76-c2dd-43d4-7798-08d6fc18f97f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB2357B181E48833601B0791B4BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(107886003)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(26005)(6506007)(305945005)(450100002)(11346002)(446003)(478600001)(76176011)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F5PGH4qMlKcrdaDCM8CQi12L7XBzWZ5F9Klb2qEctwvnSc2gywESIRNsCtQe9UJcIv4Xwh0Naw7+T5rvm+lEfGU2NOhTjauieD3/WOgiV1w8MalG5azepDkUiITSVTn3sQQcUuglCa+6AjRJ2G3FIIlkmlcfJUsrRHXSUfA1vkFIHWpDKEq4huWq2+MQKwSi4WAOfi9/NFeSpDzUm+Jqv8r5Cbq48AV2pa13bx0Rucyqo/rJ9w7Z5F+YJck+RUab68ZgC1zTpF+XC7c85n7ml26nnpp/KJth7XCG9lfJPbe5zR4eAkE1u94lgFRRkpJuWZs9VP4cmZveU6rB8opDQggC21y7g4xo+1JLCJkzwDKPvxlEVOffVq6paCLUCv+6z+j97XutKCilc+4XdrKLQ0GOSSLotPSzrPXbuWf6AB0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df059c76-c2dd-43d4-7798-08d6fc18f97f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:35:51.9753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNCkRyaXZlciBpcyByZWZl
cnJpbmcgdG8gdGhlIGFycmF5IGluZGV4IHdoZW4gZG9pbmcgcmVwIGluaXRpYWxpemF0aW9uLA0K
dXNpbmcgdnBvcnQgaXMgY29uZnVzaW5nIGFzIGl0J3Mgbm9ybWFsbHkgaW50ZXJwcmV0ZWQgYXMg
dnBvcnQgbnVtYmVyLg0KDQpUaGlzIHBhdGNoIGRvZXNuJ3QgY2hhbmdlIGFueSBmdW5jdGlvbmFs
aXR5Lg0KDQpTaWduZWQtb2ZmLWJ5OiBCb2RvbmcgV2FuZyA8Ym9kb25nQG1lbGxhbm94LmNvbT4N
ClJldmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NClJldmlld2Vk
LWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVl
ZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgfCA2ICsrKy0tLQ0KIDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZs
b2Fkcy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hf
b2ZmbG9hZHMuYw0KaW5kZXggMTc0YjBlYzQxNjJmLi5iYzYzOWE4NDY3MTQgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fk
cy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRj
aF9vZmZsb2Fkcy5jDQpAQCAtMTM5OSw3ICsxMzk5LDcgQEAgaW50IGVzd19vZmZsb2Fkc19pbml0
X3JlcHMoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KIAlzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2ID0gZXN3LT5kZXY7DQogCXN0cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICpyZXA7DQogCXU4IGh3
X2lkW0VUSF9BTEVOXSwgcmVwX3R5cGU7DQotCWludCB2cG9ydDsNCisJaW50IHZwb3J0X2luZGV4
Ow0KIA0KIAllc3ctPm9mZmxvYWRzLnZwb3J0X3JlcHMgPSBrY2FsbG9jKHRvdGFsX3Zwb3J0cywN
CiAJCQkJCSAgIHNpemVvZihzdHJ1Y3QgbWx4NV9lc3dpdGNoX3JlcCksDQpAQCAtMTQwOSw4ICsx
NDA5LDggQEAgaW50IGVzd19vZmZsb2Fkc19pbml0X3JlcHMoc3RydWN0IG1seDVfZXN3aXRjaCAq
ZXN3KQ0KIA0KIAltbHg1X3F1ZXJ5X25pY192cG9ydF9tYWNfYWRkcmVzcyhkZXYsIDAsIGh3X2lk
KTsNCiANCi0JbWx4NV9lc3dfZm9yX2FsbF9yZXBzKGVzdywgdnBvcnQsIHJlcCkgew0KLQkJcmVw
LT52cG9ydCA9IG1seDVfZXN3aXRjaF9pbmRleF90b192cG9ydF9udW0oZXN3LCB2cG9ydCk7DQor
CW1seDVfZXN3X2Zvcl9hbGxfcmVwcyhlc3csIHZwb3J0X2luZGV4LCByZXApIHsNCisJCXJlcC0+
dnBvcnQgPSBtbHg1X2Vzd2l0Y2hfaW5kZXhfdG9fdnBvcnRfbnVtKGVzdywgdnBvcnRfaW5kZXgp
Ow0KIAkJZXRoZXJfYWRkcl9jb3B5KHJlcC0+aHdfaWQsIGh3X2lkKTsNCiANCiAJCWZvciAocmVw
X3R5cGUgPSAwOyByZXBfdHlwZSA8IE5VTV9SRVBfVFlQRVM7IHJlcF90eXBlKyspDQotLSANCjIu
MjEuMA0KDQo=
