Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF7BE9D7
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfD2SOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:14:23 -0400
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:53125
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728952AbfD2SOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 14:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GfpHVi+PpJnV3g3naMQMDnYifm+AqixtlLvB9xM1hZA=;
 b=NReHnZZCmj78BvZVCCcgOhuUNxYmVY8sgfEI+c8IdO7zGOkKWWHRb3pd9iZu/EIbJNffu2r3M4BGvnWi1q3yvZK9+3H7GKSO1/2bjMMiLB0c4z4DxT8m0ntxdd3SFBfYvxY4SNap9uE8jIX7pvXT4A6CcUyscsOwdEisQWhaEBw=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6026.eurprd05.prod.outlook.com (20.179.10.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.16; Mon, 29 Apr 2019 18:14:09 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 18:14:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>
Subject: [PATCH V2 mlx5-next 05/11] net/mlx5: Enable general events on all
 interfaces
Thread-Topic: [PATCH V2 mlx5-next 05/11] net/mlx5: Enable general events on
 all interfaces
Thread-Index: AQHU/rdWcaD4+/2yvUaHUniRv52hRw==
Date:   Mon, 29 Apr 2019 18:14:09 +0000
Message-ID: <20190429181326.6262-6-saeedm@mellanox.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
In-Reply-To: <20190429181326.6262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:a03:40::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf7f270c-29e7-4d24-29a4-08d6ccce7922
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6026;
x-ms-traffictypediagnostic: DB8PR05MB6026:
x-microsoft-antispam-prvs: <DB8PR05MB60269E4745DE1EFF3A6FBDF0BE390@DB8PR05MB6026.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39860400002)(396003)(189003)(199004)(25786009)(3846002)(66476007)(64756008)(66446008)(66556008)(107886003)(305945005)(76176011)(256004)(14444005)(52116002)(450100002)(4326008)(66066001)(386003)(6506007)(6116002)(14454004)(478600001)(73956011)(6512007)(66946007)(53936002)(8936002)(36756003)(11346002)(2616005)(2906002)(71190400001)(71200400001)(5660300002)(110136005)(186003)(316002)(26005)(486006)(6636002)(54906003)(446003)(6436002)(68736007)(99286004)(7736002)(50226002)(85306007)(102836004)(81166006)(81156014)(8676002)(86362001)(6486002)(97736004)(1076003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6026;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tYSHjYK8T3LXHDPvo9AwZCx7jy4X32TDtXcQ0PVRnzhWgTUC8z773DOOtpMXDVvRpOWJ+ZXcJbLSCZafP+u67WFv/PXxy1UF5a9Nk9tTct8NuiALTpSHQ7iRSrPQINFi7M41BZBsZRQTrszN9KiIyf4bSxnnwLR1TVycQZ2+UjXwBwdyRz+1TwXXcjQvM6X/Lu4Oz9l/CuFm7dDyhoM131LNUO93bGldN9A9vTregcsfrgrLzuFvRtgx+Ab28k2A1LYXxiZ3JXtTkoCQm0XjiA5ebXEl26D8wIAFzWSQUIU5C32LpOlzDgGUkqwNHz7d/94bQmz+khyVRJKzc8cMS5Zc8dPG9f3arV/UZdzKs3XrEcrit74vFICMVc4vmi609v/YIm+AD70bkaTYU0jfI8XsjNf7keoKIyHe3LvKxe8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7f270c-29e7-4d24-29a4-08d6ccce7922
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 18:14:09.1458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6026
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXlhIExldmluIDxheWFsQG1lbGxhbm94LmNvbT4NCg0KT3BlbiBldmVudHMgb2YgdHlw
ZSAnR0VORVJBTCcgdG8gYWxsIHR5cGVzIG9mIGludGVyZmFjZXMuIFByaW9yIHRvIHRoaXMNCnBh
dGNoLCAnR0VORVJBTCcgZXZlbnRzIHdlcmUgY2FwdHVyZWQgb25seSBieSBFdGhlcm5ldCBpbnRl
cmZhY2VzLiBPdGhlcg0KaW50ZXJmYWNlIHR5cGVzIChub24tRXRoZXJuZXQpIHdlcmUgZXhjbHVk
ZWQgYW5kIGNvdWxkbid0IHJlY2VpdmUNCidHRU5FUkFMJyBldmVudHMuDQoNCkZpeGVzOiA1ZDNj
NTM3ZjkwNzAgKCJuZXQvbWx4NTogSGFuZGxlIGV2ZW50IG9mIHBvd2VyIGRldGVjdGlvbiBpbiB0
aGUgUENJRSBzbG90IikNClNpZ25lZC1vZmYtYnk6IEF5YSBMZXZpbiA8YXlhbEBtZWxsYW5veC5j
b20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4N
Ci0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jIHwgMyAr
LS0NCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jDQppbmRleCBiYjZl
NWI1ZDk2ODEuLjNiNjE3YjVlMWQ5ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lcS5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZXEuYw0KQEAgLTUwNCw4ICs1MDQsNyBAQCBzdGF0aWMgdTY0IGdhdGhl
cl9hc3luY19ldmVudHNfbWFzayhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIAlpZiAoTUxY
NV9WUE9SVF9NQU5BR0VSKGRldikpDQogCQlhc3luY19ldmVudF9tYXNrIHw9ICgxdWxsIDw8IE1M
WDVfRVZFTlRfVFlQRV9OSUNfVlBPUlRfQ0hBTkdFKTsNCiANCi0JaWYgKE1MWDVfQ0FQX0dFTihk
ZXYsIHBvcnRfdHlwZSkgPT0gTUxYNV9DQVBfUE9SVF9UWVBFX0VUSCAmJg0KLQkgICAgTUxYNV9D
QVBfR0VOKGRldiwgZ2VuZXJhbF9ub3RpZmljYXRpb25fZXZlbnQpKQ0KKwlpZiAoTUxYNV9DQVBf
R0VOKGRldiwgZ2VuZXJhbF9ub3RpZmljYXRpb25fZXZlbnQpKQ0KIAkJYXN5bmNfZXZlbnRfbWFz
ayB8PSAoMXVsbCA8PCBNTFg1X0VWRU5UX1RZUEVfR0VORVJBTF9FVkVOVCk7DQogDQogCWlmIChN
TFg1X0NBUF9HRU4oZGV2LCBwb3J0X21vZHVsZV9ldmVudCkpDQotLSANCjIuMjAuMQ0KDQo=
