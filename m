Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902483980B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731497AbfFGVsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:48:11 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731225AbfFGVsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ekD1FrnqJ8vtx8eoLsLRLzmBvEHZjcYhXR2/Qxfm0A=;
 b=s986JOwkjUZ1khK5ybv7VXFWKA+Vq3KxZoUimkXz61VBMTFHQYd0faZHp0f3ih7PE1QtYKj9kathgaaDtSsnF1huERTjZkyGWvp9/Ygms7kIT+qGT3oJiFXB+teyGv9aOi2a6YHC71IAf8l9TEX4LefFgSMx+mJOnQN/3zsk8CY=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:48 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/7] net/mlx5e: Support tagged tunnel over bond
Thread-Topic: [net 7/7] net/mlx5e: Support tagged tunnel over bond
Thread-Index: AQHVHXql+eKGJo3d40+2KfTUUuiLHg==
Date:   Fri, 7 Jun 2019 21:47:48 +0000
Message-ID: <20190607214716.16316-8-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29806cb5-de27-4f79-5168-08d6eb91c834
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB6139A07E845588EB262B1C21BE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(76176011)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(14444005)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(11346002)(6486002)(68736007)(446003)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mUceGqA7HvyMiRDzsg92BVm659KTdSGRhmINbq+KwjHpU1LOT2Je61KzzBePqcBwRBgP3fyXn4396tuHJ/DtNs8vFidcJnf1qWH5JGP/jh4SVl3tXDC1IUty2rrtm8ZLvl0TyQ91vcV0Y4dxJMH3YcVc7+Uuret0hjnfpnT6pEpAhe0rAkXjVAzg+3e+/UwpFdgS1/3ZtPdgvgjHWKHbMbS8tNipf89OvzwHEIKFNZ3FJCQ4HMfGmBiCfHrYECm6v1X9Ya/YyEOgTj2h5e28NxU+X9apQkIphrHoxxhnPm8S9Tc0zs7ADqqSWmZ8G1cODv5XzludYH5V8Pd62JOhgZWOIDsFWoTF3JXjyfMQpgjGl6J8U+JZEFkq0fJvUfz842d7vjYgtthaD/gDB+J3QlFMgPATMZiDe4ZPmyPV0vQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29806cb5-de27-4f79-5168-08d6eb91c834
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:48.3849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KDQpTdGFja2VkIGRldmlj
ZXMgbGlrZSBib25kIGludGVyZmFjZSBtYXkgaGF2ZSBhIFZMQU4gZGV2aWNlIG9uIHRvcCBvZg0K
dGhlbS4gRGV0ZWN0IGxhZyBzdGF0ZSBjb3JyZWN0bHkgdW5kZXIgdGhpcyBjb25kaXRpb24sIGFu
ZCByZXR1cm4gdGhlDQpjb3JyZWN0IHJvdXRlZCBuZXQgZGV2aWNlLCBhY2NvcmRpbmcgdG8gaXQg
dGhlIGVuY2FwIGhlYWRlciBpcyBidWlsdC4NCg0KRml4ZXM6IGUzMmVlNmM3OGVmYSAoIm5ldC9t
bHg1ZTogU3VwcG9ydCB0dW5uZWwgZW5jYXAgb3ZlciB0YWdnZWQgRXRoZXJuZXQiKQ0KU2lnbmVk
LW9mZi1ieTogRWxpIEJyaXRzdGVpbiA8ZWxpYnJAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6
IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhh
bWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbi90Y190dW4uYyB8IDExICsrKysrKy0tLS0tDQogMSBmaWxlIGNo
YW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y190dW4uYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y190dW4uYw0KaW5kZXggZmU1
ZDRkN2YxNWVkLi4yMzFlN2NkZmM2ZjcgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfdHVuLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y190dW4uYw0KQEAgLTExLDI0ICsxMSwyNSBAQCBz
dGF0aWMgaW50IGdldF9yb3V0ZV9hbmRfb3V0X2RldnMoc3RydWN0IG1seDVlX3ByaXYgKnByaXYs
DQogCQkJCSAgc3RydWN0IG5ldF9kZXZpY2UgKipyb3V0ZV9kZXYsDQogCQkJCSAgc3RydWN0IG5l
dF9kZXZpY2UgKipvdXRfZGV2KQ0KIHsNCisJc3RydWN0IG5ldF9kZXZpY2UgKnVwbGlua19kZXYs
ICp1cGxpbmtfdXBwZXIsICpyZWFsX2RldjsNCiAJc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3ID0g
cHJpdi0+bWRldi0+cHJpdi5lc3dpdGNoOw0KLQlzdHJ1Y3QgbmV0X2RldmljZSAqdXBsaW5rX2Rl
diwgKnVwbGlua191cHBlcjsNCiAJYm9vbCBkc3RfaXNfbGFnX2RldjsNCiANCisJcmVhbF9kZXYg
PSBpc192bGFuX2RldihkZXYpID8gdmxhbl9kZXZfcmVhbF9kZXYoZGV2KSA6IGRldjsNCiAJdXBs
aW5rX2RldiA9IG1seDVfZXN3aXRjaF91cGxpbmtfZ2V0X3Byb3RvX2Rldihlc3csIFJFUF9FVEgp
Ow0KIAl1cGxpbmtfdXBwZXIgPSBuZXRkZXZfbWFzdGVyX3VwcGVyX2Rldl9nZXQodXBsaW5rX2Rl
dik7DQogCWRzdF9pc19sYWdfZGV2ID0gKHVwbGlua191cHBlciAmJg0KIAkJCSAgbmV0aWZfaXNf
bGFnX21hc3Rlcih1cGxpbmtfdXBwZXIpICYmDQotCQkJICBkZXYgPT0gdXBsaW5rX3VwcGVyICYm
DQorCQkJICByZWFsX2RldiA9PSB1cGxpbmtfdXBwZXIgJiYNCiAJCQkgIG1seDVfbGFnX2lzX3Ny
aW92KHByaXYtPm1kZXYpKTsNCiANCiAJLyogaWYgdGhlIGVncmVzcyBkZXZpY2UgaXNuJ3Qgb24g
dGhlIHNhbWUgSFcgZS1zd2l0Y2ggb3INCiAJICogaXQncyBhIExBRyBkZXZpY2UsIHVzZSB0aGUg
dXBsaW5rDQogCSAqLw0KLQlpZiAoIW5ldGRldl9wb3J0X3NhbWVfcGFyZW50X2lkKHByaXYtPm5l
dGRldiwgZGV2KSB8fA0KKwlpZiAoIW5ldGRldl9wb3J0X3NhbWVfcGFyZW50X2lkKHByaXYtPm5l
dGRldiwgcmVhbF9kZXYpIHx8DQogCSAgICBkc3RfaXNfbGFnX2Rldikgew0KLQkJKnJvdXRlX2Rl
diA9IHVwbGlua19kZXY7DQotCQkqb3V0X2RldiA9ICpyb3V0ZV9kZXY7DQorCQkqcm91dGVfZGV2
ID0gZGV2Ow0KKwkJKm91dF9kZXYgPSB1cGxpbmtfZGV2Ow0KIAl9IGVsc2Ugew0KIAkJKnJvdXRl
X2RldiA9IGRldjsNCiAJCWlmIChpc192bGFuX2Rldigqcm91dGVfZGV2KSkNCi0tIA0KMi4yMS4w
DQoNCg==
