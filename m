Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D85B39809
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731483AbfFGVsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:48:05 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731225AbfFGVsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqOtxB9y6KNit/zlYk/WmU6/iZpVdmNq9QOiIJPblGY=;
 b=ZoIrVrklbfAwx2FsRx7ylRASWhSzXi5W3zGteWf31/k32UAb+MSt3RMkDjG3CwJOSQ4erfJ/7P7NwkK6QoaSvmJib7/8XrHh3fnqVmHXMA6DoKMg5z8ZndZVx7+nG4+2H38CM9dnnG3duiDuON9Qzs5ZeMOnjlHUFCw2ETvo6uw=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:44 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/7] net/mlx5e: Fix source port matching in fdb peer flow rule
Thread-Topic: [net 5/7] net/mlx5e: Fix source port matching in fdb peer flow
 rule
Thread-Index: AQHVHXqjxuOvxMVFTUKef5cGUzTJ2A==
Date:   Fri, 7 Jun 2019 21:47:44 +0000
Message-ID: <20190607214716.16316-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 4015fe74-7d7a-4abe-7a4f-08d6eb91c606
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB613946C40F4E489B23B211BFBE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:451;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(76176011)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(11346002)(6486002)(68736007)(446003)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 709bcz92payY9J5+P2nhG3Fu9Y0pOl83o6Y+jeGwl7wjgUMCqhrN0TKrNvedKE4aJ36OTdi4PWoo2VVqS/rJM5Gcr+lQ5fNQ75nUejPX+pAE/FHusm1RbHnGI7o3oTvxG8c6mZcT3ZCO18A3BNvnoYmN0jB3XwCvWuXazFjydBAU0ltvqhnXUzF4QfqzW7oL4CB6jGFZTT1Adz9AeP6Pe2RxqUyUfspX4HRqL1FLaOKJZYBBxpXnUXMb2NclWw/CJ5b2Ck2ZRHIZtcbBCLpmoE1GUNRIHVBbV7DJ62zAlB7ie/IGDKvMKL8xwSCSCKp9+WVj/a9aHd178qUJwBNb4qM/DICNycp0uhxU4KV4n4Pso9kqddJX+Qgte4T0zWqIycPRctHtWd+n9sz5MlNXza4iwcimAKWDVqUL2aX5o0I=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4015fe74-7d7a-4abe-7a4f-08d6eb91c606
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:44.8370
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

RnJvbTogUmFlZCBTYWxlbSA8cmFlZHNAbWVsbGFub3guY29tPg0KDQpUaGUgY2l0ZWQgY29tbWl0
IGNoYW5nZWQgdGhlIGluaXRpYWxpemF0aW9uIHBsYWNlbWVudCBvZiB0aGUgZXN3aXRjaA0KYXR0
cmlidXRlcyBzbyBpdCBpcyBkb25lIHByaW9yIHRvIHBhcnNlIHRjIGFjdGlvbnMgZnVuY3Rpb24g
Y2FsbCwNCmluY2x1ZGluZyBhbW9uZyBvdGhlcnMgdGhlIGluX3JlcCBhbmQgaW5fbWRldiBmaWVs
ZHMgd2hpY2ggYXJlIG1pc3Rha2VubHkNCnJlYXNzaWduZWQgaW5zaWRlIHRoZSBwYXJzZSBhY3Rp
b25zIGZ1bmN0aW9uLg0KDQpUaGlzIGJyZWFrcyB0aGUgc291cmNlIHBvcnQgbWF0Y2hpbmcgY3Jp
dGVyaWEgb2YgdGhlIHBlZXIgcmVkaXJlY3QgcnVsZS4NCg0KRml4IGJ5IHJlbW92aW5nIHRoZSBu
b3cgcmVkdW5kYW50IHJlYXNzaWdubWVudCBvZiB0aGUgYWxyZWFkeSBpbml0aWFsaXplZA0KZmll
bGRzLg0KDQpGaXhlczogOTg4YWI5YzczNjNhICgibmV0L21seDVlOiBJbnRyb2R1Y2UgbWx4NWVf
Zmxvd19lc3dfYXR0cl9pbml0KCkgaGVscGVyIikNClNpZ25lZC1vZmYtYnk6IFJhZWQgU2FsZW0g
PHJhZWRzQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFu
b3guY29tPg0KU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5j
b20+DQotLS0NCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMu
YyB8IDMgLS0tDQogMSBmaWxlIGNoYW5nZWQsIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQppbmRleCAzMWNkMDJm
MTE0OTkuLmU0MGM2MGQxNjMxZiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl90Yy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KQEAgLTI4MTIsOSArMjgxMiw2IEBAIHN0YXRpYyBpbnQg
cGFyc2VfdGNfZmRiX2FjdGlvbnMoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQogCWlmICghZmxv
d19hY3Rpb25faGFzX2VudHJpZXMoZmxvd19hY3Rpb24pKQ0KIAkJcmV0dXJuIC1FSU5WQUw7DQog
DQotCWF0dHItPmluX3JlcCA9IHJwcml2LT5yZXA7DQotCWF0dHItPmluX21kZXYgPSBwcml2LT5t
ZGV2Ow0KLQ0KIAlmbG93X2FjdGlvbl9mb3JfZWFjaChpLCBhY3QsIGZsb3dfYWN0aW9uKSB7DQog
CQlzd2l0Y2ggKGFjdC0+aWQpIHsNCiAJCWNhc2UgRkxPV19BQ1RJT05fRFJPUDoNCi0tIA0KMi4y
MS4wDQoNCg==
