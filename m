Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCFC21F05
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfEQUTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:19:55 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28487
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728537AbfEQUTx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8ZPAHvPuuUekfLir3WvDjVdfveXvWzVyHBWMifJSQM=;
 b=V+srD0P1WnFtCkR9xjL+wZFFwci9EHe9zln768qWrpw0GnZC8idB2cE8PHb+KfLyOxqZSvoFZvrnR1E1bqMnCAGGbtqVg8Z8QXDoiZj78VrNEPEIhKwXizJGTaaPeWYy4MmOunBtABDMH3pH9755l/j8Ungxr/5+ZRv6zarYxAc=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6138.eurprd05.prod.outlook.com (20.179.10.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 17 May 2019 20:19:42 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 20:19:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/11] net/mlx5: Fix peer pf disable hca command
Thread-Topic: [net 04/11] net/mlx5: Fix peer pf disable hca command
Thread-Index: AQHVDO3cYXvzVPN6rEGbpAzX0Xr1mw==
Date:   Fri, 17 May 2019 20:19:42 +0000
Message-ID: <20190517201910.32216-5-saeedm@mellanox.com>
References: <20190517201910.32216-1-saeedm@mellanox.com>
In-Reply-To: <20190517201910.32216-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0046.prod.exchangelabs.com (2603:10b6:a03:94::23)
 To DB8PR05MB5898.eurprd05.prod.outlook.com (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4f46fb9-ff33-4c32-45ce-08d6db04fe6e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6138;
x-ms-traffictypediagnostic: DB8PR05MB6138:
x-microsoft-antispam-prvs: <DB8PR05MB6138058EF64AF2E5DE0E0C9CBE0B0@DB8PR05MB6138.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(396003)(136003)(366004)(346002)(189003)(199004)(446003)(305945005)(11346002)(71190400001)(71200400001)(66066001)(476003)(14444005)(486006)(386003)(6506007)(76176011)(256004)(7736002)(2616005)(102836004)(6916009)(64756008)(25786009)(66946007)(66446008)(81156014)(81166006)(66556008)(66476007)(26005)(54906003)(2906002)(99286004)(86362001)(52116002)(6436002)(6512007)(8936002)(316002)(8676002)(73956011)(1076003)(14454004)(6116002)(5660300002)(4326008)(50226002)(53936002)(107886003)(68736007)(6486002)(186003)(478600001)(36756003)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6138;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LfgQCpMtyQNmQckOSKJeIN7N+MOTVP9s3nkQmWaF0g/zNHDZSdu64Auq32yZB0DJq6iyixo7rPIrN7H+g7sn69DnoQiUHbWp5TuLhqbvynuyS0jXTb0J1MeecO5VN6ybseaA07ZPTjhRJ4HDF+CnBUi/KH8eSpJQWm+RqRi1vO797l/6jpfzyk7FRIePbuixUK3ry1tkiS/mdh/sqvDvVw19zXiC8esgbkNU503rBVFvOL5X9IF/FOcsmzg513MWLZynSiOOkY0iQ5jAOZqKs2lNk7WBBZJHYRYAfxiqBthLAR6Rkf+ggvOcDCr+mAkJJvCWObLJqdLfG97zL0Dl0oVPyWIQFRM0x2lCB38klsG2p2SnaNNU7j0g17oIKK9kWrw3kOvRBJzLZ90L4wLM+mqRZFs80C5gPYS/S6kG1es=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f46fb9-ff33-4c32-45ce-08d6db04fe6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 20:19:42.0751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQoNClRoZSBjb21tYW5kIHdh
cyBtaXN0YWtlbmx5IHVzaW5nIGVuYWJsZV9oY2EgaW4gZW1iZWRkZWQgQ1BVIGZpZWxkLg0KDQpG
aXhlczogMjJlOTM5YTkxZGNiIChuZXQvbWx4NTogVXBkYXRlIGVuYWJsZSBIQ0EgZGVwZW5kZW5j
eSkNClNpZ25lZC1vZmYtYnk6IEJvZG9uZyBXYW5nIDxib2RvbmdAbWVsbGFub3guY29tPg0KUmVw
b3J0ZWQtYnk6IEFsZXggUm9zZW5iYXVtIDxhbGV4ckBtZWxsYW5veC5jb20+DQpTaWduZWQtb2Zm
LWJ5OiBBbGV4IFJvc2VuYmF1bSA8YWxleHJAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IERh
bmllbCBKdXJnZW5zIDxkYW5pZWxqQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVk
IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VjcGYuYyB8IDIgKy0NCiAxIGZpbGUgY2hhbmdlZCwgMSBp
bnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lY3BmLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZWNwZi5jDQppbmRleCA0NzQ2ZjJkMjhmYjYuLjBjY2Q2ZDQwYmFm
NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
Y3BmLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lY3Bm
LmMNCkBAIC0yNiw3ICsyNiw3IEBAIHN0YXRpYyBpbnQgbWx4NV9wZWVyX3BmX2Rpc2FibGVfaGNh
KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogDQogCU1MWDVfU0VUKGRpc2FibGVfaGNhX2lu
LCBpbiwgb3Bjb2RlLCBNTFg1X0NNRF9PUF9ESVNBQkxFX0hDQSk7DQogCU1MWDVfU0VUKGRpc2Fi
bGVfaGNhX2luLCBpbiwgZnVuY3Rpb25faWQsIDApOw0KLQlNTFg1X1NFVChlbmFibGVfaGNhX2lu
LCBpbiwgZW1iZWRkZWRfY3B1X2Z1bmN0aW9uLCAwKTsNCisJTUxYNV9TRVQoZGlzYWJsZV9oY2Ff
aW4sIGluLCBlbWJlZGRlZF9jcHVfZnVuY3Rpb24sIDApOw0KIAlyZXR1cm4gbWx4NV9jbWRfZXhl
YyhkZXYsIGluLCBzaXplb2YoaW4pLCBvdXQsIHNpemVvZihvdXQpKTsNCiB9DQogDQotLSANCjIu
MjEuMA0KDQo=
