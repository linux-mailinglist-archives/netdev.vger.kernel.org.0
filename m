Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7D335A77E
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfF1XTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:19:08 -0400
Received: from mail-eopbgr50055.outbound.protection.outlook.com ([40.107.5.55]:38726
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726979AbfF1XTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:19:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=U+GGhCt6FzY3qDRXz3TCQO+lErctvmgv+4BwxsWErpOwjYACCqN3/NK34sOrXk6HNdas28ayVAtN8xmcWhLp06iIHEeH7j8TFkDfuSQUi9lzjFuV7umngyMOqhVEveT1q1sAahFn3FS+7fvOX0a/B03Eo8U/VOGRNtvNhxFZnTo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yG5J3u+xakUf5OKgqkcxvVs8n5lUSXTCMJxDWdhhm/0=;
 b=NnHQ/CwDhJDR1f0ab678GPlx7G+UDQcgBUommY1GfQrN1Vp2C9btDyGYy/DVPEp9xrE3Jy0YOjDav+MQcMzg++F8Wl+1vLnbYNsmrwB9FwdHBGzB5pvXoIL/Pu7bO5H9CTBMZ6LNv7y9Tgc/1sCo70qeT/YGc1Zqw3HwO9XdyW8=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yG5J3u+xakUf5OKgqkcxvVs8n5lUSXTCMJxDWdhhm/0=;
 b=jSDxN+DSAzv400MQ+YSm8L5tUmC8n+LSqznJrPdRxgpLCiu8AzveSD/toLQKeedOaaDObfPlXn/vL6egfoJdz9DRewy8x2rJU69gxMSSsbk9ZnAYIoBdKLjz0jRyKtG1QvzquCVPxEP1QORraoN/pB8InjBMRmC74shn0ChRkPc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:34 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/10] net/mlx5e: Expose same physical switch_id for all
 representors
Thread-Topic: [net-next 09/10] net/mlx5e: Expose same physical switch_id for
 all representors
Thread-Index: AQHVLgfOdD916/qnak6g3cBqrujvMQ==
Date:   Fri, 28 Jun 2019 23:18:33 +0000
Message-ID: <20190628231759.16374-10-saeedm@mellanox.com>
References: <20190628231759.16374-1-saeedm@mellanox.com>
In-Reply-To: <20190628231759.16374-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a59d9f1-c261-4d4e-8e8a-08d6fc1ef0a1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB21980056B9E751E00E62E017BEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6Xz8nc9uA3Br2N1DwRSvXNrhPfrKEPxwXBUycgLMT4p7N7iIX+mpfMMStGOvMiAJOSg2Wvlps4cK/Mz/dp6Zk4//xyULR1K81At21cJIJrqMPeiI1NqidE7lpVIZWWJZAB5PMMmgWWH0BE29HKcUmnKWni4vcrCmKSqenVuryIjQ65vKg73KKJX7ccRMslETz0UV93PfsBRoLQ1T1gg8PMs4qz4E3jf+sd+8REotuGawvoBdQMjp7+FOZrdJBwQ1MJxoutviDDDHg77t8dKkH8a+b7RDRLF1A6dTJSChwmkH3r/kmus3TP9pbJLnJr7Kh+GVl+BEeo8dM7yg1g3JJ/sS/V+4tgmlZehg9riYObLXm00RzSs2MVooTmlxkRKHfwNG7n6Jq0ylNg8ecR+JXRhkvRDZliuYno89hBvW6LI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a59d9f1-c261-4d4e-8e8a-08d6fc1ef0a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:33.9144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4NCg0KUmVwb3J0IHN5c3RlbV9p
bWFnZV9ndWlkIGFzIHRoZSBFLVN3aXRjaCBzd2l0Y2hfaWQsIHRoaXMgZW5zdXJlcw0KdGhhdCB3
aGVuIGEgTklDIGNvbnRhaW5zIG11bHRpcGxlIFBDSSBmdW5jdGlvbnMgYW5kIHdoaWNoDQpoYXMg
bWVyZ2VkIGVzd2l0Y2ggY2FwYWJpbGl0eSwgYWxsIHJlcHJlc2VudG9ycyBmcm9tDQptdWx0aXBs
ZSBQRnMgcHVibGlzaCBzYW1lIHN3aXRjaF9pZC4NCg0KU2lnbmVkLW9mZi1ieTogUGF1bCBCbGFr
ZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2
QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29t
Pg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQot
LS0NCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyAgfCAyOSAr
KysrKystLS0tLS0tLS0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMjAg
ZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fcmVwLmMNCmluZGV4IGZjZTM4MTRiZGIyZi4uMzMwMDM0ZmNkZmM1IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQor
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCkBA
IC0zOTEsMzAgKzM5MSwxOSBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGV0aHRvb2xfb3BzIG1seDVl
X3VwbGlua19yZXBfZXRodG9vbF9vcHMgPSB7DQogc3RhdGljIGludCBtbHg1ZV9yZXBfZ2V0X3Bv
cnRfcGFyZW50X2lkKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQogCQkJCQlzdHJ1Y3QgbmV0ZGV2
X3BoeXNfaXRlbV9pZCAqcHBpZCkNCiB7DQotCXN0cnVjdCBtbHg1ZV9wcml2ICpwcml2ID0gbmV0
ZGV2X3ByaXYoZGV2KTsNCi0Jc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3ID0gcHJpdi0+bWRldi0+
cHJpdi5lc3dpdGNoOw0KLQlzdHJ1Y3QgbmV0X2RldmljZSAqdXBsaW5rX3VwcGVyID0gTlVMTDsN
Ci0Jc3RydWN0IG1seDVlX3ByaXYgKnVwbGlua19wcml2ID0gTlVMTDsNCi0Jc3RydWN0IG5ldF9k
ZXZpY2UgKnVwbGlua19kZXY7DQorCXN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdzsNCisJc3RydWN0
IG1seDVlX3ByaXYgKnByaXY7DQorCXU2NCBwYXJlbnRfaWQ7DQorDQorCXByaXYgPSBuZXRkZXZf
cHJpdihkZXYpOw0KKwllc3cgPSBwcml2LT5tZGV2LT5wcml2LmVzd2l0Y2g7DQogDQogCWlmIChl
c3ctPm1vZGUgPT0gU1JJT1ZfTk9ORSkNCiAJCXJldHVybiAtRU9QTk9UU1VQUDsNCiANCi0JdXBs
aW5rX2RldiA9IG1seDVfZXN3aXRjaF91cGxpbmtfZ2V0X3Byb3RvX2Rldihlc3csIFJFUF9FVEgp
Ow0KLQlpZiAodXBsaW5rX2Rldikgew0KLQkJdXBsaW5rX3VwcGVyID0gbmV0ZGV2X21hc3Rlcl91
cHBlcl9kZXZfZ2V0KHVwbGlua19kZXYpOw0KLQkJdXBsaW5rX3ByaXYgPSBuZXRkZXZfcHJpdih1
cGxpbmtfZGV2KTsNCi0JfQ0KLQ0KLQlwcGlkLT5pZF9sZW4gPSBFVEhfQUxFTjsNCi0JaWYgKHVw
bGlua191cHBlciAmJiBtbHg1X2xhZ19pc19zcmlvdih1cGxpbmtfcHJpdi0+bWRldikpIHsNCi0J
CWV0aGVyX2FkZHJfY29weShwcGlkLT5pZCwgdXBsaW5rX3VwcGVyLT5kZXZfYWRkcik7DQotCX0g
ZWxzZSB7DQotCQlzdHJ1Y3QgbWx4NWVfcmVwX3ByaXYgKnJwcml2ID0gcHJpdi0+cHByaXY7DQot
CQlzdHJ1Y3QgbWx4NV9lc3dpdGNoX3JlcCAqcmVwID0gcnByaXYtPnJlcDsNCi0NCi0JCWV0aGVy
X2FkZHJfY29weShwcGlkLT5pZCwgcmVwLT5od19pZCk7DQotCX0NCisJcGFyZW50X2lkID0gbWx4
NV9xdWVyeV9uaWNfc3lzdGVtX2ltYWdlX2d1aWQocHJpdi0+bWRldik7DQorCXBwaWQtPmlkX2xl
biA9IHNpemVvZihwYXJlbnRfaWQpOw0KKwltZW1jcHkocHBpZC0+aWQsICZwYXJlbnRfaWQsIHNp
emVvZihwYXJlbnRfaWQpKTsNCiANCiAJcmV0dXJuIDA7DQogfQ0KLS0gDQoyLjIxLjANCg0K
