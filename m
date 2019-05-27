Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C950F2AD74
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 05:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfE0DzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 23:55:25 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:30978
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726245AbfE0DzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 May 2019 23:55:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oVzAYGV0thpVJ+86/5qPKv62Ya3YTbvp6+m3oa/pYTg=;
 b=OYFu8TDRx9+cxbfhCOLN1sqBKcsWMTvJx7k+mpTAiYmo4rYJj1sTzbWMdVcrd2hUifCJJwAws3tEgVebXR4Xi1UNQ7Ta59FaF0nbqwYq/vso8cmZFqJdgMqzZf/uI+dig9qlk2E03q+llR9Hsr+DLFoLDUS4XwFVTJO+Y7ZVdAw=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2544.eurprd04.prod.outlook.com (10.168.65.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Mon, 27 May 2019 03:55:20 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::b091:6395:e853:5986%3]) with mapi id 15.20.1922.021; Mon, 27 May 2019
 03:55:20 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: [PATCH] enetc: fix le32/le16 degrading to integer warnings
Thread-Topic: [PATCH] enetc: fix le32/le16 degrading to integer warnings
Thread-Index: AQHVFEAATo7Mi8M7KEuVJ1P9gzvomw==
Date:   Mon, 27 May 2019 03:55:20 +0000
Message-ID: <20190527035653.7552-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HK0PR03CA0097.apcprd03.prod.outlook.com
 (2603:1096:203:b0::13) To VI1PR0401MB2237.eurprd04.prod.outlook.com
 (2603:10a6:800:27::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5ac862a-c8e5-4775-cb09-08d6e2572308
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0401MB2544;
x-ms-traffictypediagnostic: VI1PR0401MB2544:
x-microsoft-antispam-prvs: <VI1PR0401MB25448580FDAED8EFBE1AD9D1F81D0@VI1PR0401MB2544.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:510;
x-forefront-prvs: 0050CEFE70
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39860400002)(346002)(396003)(136003)(199004)(189003)(26005)(186003)(14444005)(71190400001)(71200400001)(256004)(6116002)(316002)(110136005)(486006)(3846002)(476003)(2616005)(102836004)(14454004)(478600001)(99286004)(52116002)(2501003)(36756003)(6506007)(386003)(66066001)(5660300002)(305945005)(53936002)(73956011)(6636002)(1076003)(68736007)(81156014)(6436002)(2906002)(25786009)(50226002)(8936002)(81166006)(8676002)(6486002)(7736002)(66476007)(64756008)(66446008)(86362001)(6512007)(66556008)(66946007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2544;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qLAlWlL5ldK4v+fXtKiue+1LF/SnHGKAeR95Nb90uD8DD8PhNNLFwcisHSNy2J2JWTUGCwAIKTpKOtfLe2N6fO61RiaDnE71gOkD/+O61DmDoGlBfP2reVZCQmUFslAatHqY9gZ3F4m+t/WbKukp6hzsEV2jT+u2qtwGKCkndDOipA9TIyhSy8qJVMStcA9VjxEw7wtC4dAZ3OPSrFwUMR5U9PDFRtXAcFCFWddPWAEghisI+2U1UlWX7K6OlEdyv2u+SlZ9Xj0Re6F3qablN1BxBLV25X2qs67PT9Bu+8tfV/AV/U9Ntm4abc+1FtPi4TdMGjk7LfpS1aVCFSSXlgk++zZKrxQmRy3apPpe9zAlvjtnuULGUYDL/WebytMzhX63mwI+qMztyWJ4B3PIo1V3cK0NF11RrneVMC/d6GQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ac862a-c8e5-4775-cb09-08d6e2572308
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2019 03:55:20.1168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yangbo.lu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rml4IGJsb3cgc3BhcnNlIHdhcm5pbmcgaW50cm9kdWNlZCBieSBhIHByZXZpb3VzIHBhdGNoLg0K
LSByZXN0cmljdGVkIF9fbGUzMiBkZWdyYWRlcyB0byBpbnRlZ2VyDQotIHJlc3RyaWN0ZWQgX19s
ZTE2IGRlZ3JhZGVzIHRvIGludGVnZXINCg0KRml4ZXM6IGQzOTgyMzEyMTkxMSAoImVuZXRjOiBh
ZGQgaGFyZHdhcmUgdGltZXN0YW1waW5nIHN1cHBvcnQiKQ0KU2lnbmVkLW9mZi1ieTogWWFuZ2Jv
IEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9lbmV0Yy9lbmV0Yy5jIHwgMTYgKysrKysrKysrLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2Vk
LCA5IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGMuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5jDQppbmRleCBkMmFjZTI5OWJlZDAuLjc5YmJjODZh
YmU3NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9l
bmV0Yy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGMu
Yw0KQEAgLTMwNywxMyArMzA3LDE0IEBAIHN0YXRpYyBpbnQgZW5ldGNfYmRfcmVhZHlfY291bnQo
c3RydWN0IGVuZXRjX2JkciAqdHhfcmluZywgaW50IGNpKQ0KIHN0YXRpYyB2b2lkIGVuZXRjX2dl
dF90eF90c3RhbXAoc3RydWN0IGVuZXRjX2h3ICpodywgdW5pb24gZW5ldGNfdHhfYmQgKnR4YmQs
DQogCQkJCXU2NCAqdHN0YW1wKQ0KIHsNCi0JdTMyIGxvLCBoaTsNCisJdTMyIGxvLCBoaSwgdHN0
YW1wX2xvOw0KIA0KIAlsbyA9IGVuZXRjX3JkKGh3LCBFTkVUQ19TSUNUUjApOw0KIAloaSA9IGVu
ZXRjX3JkKGh3LCBFTkVUQ19TSUNUUjEpOw0KLQlpZiAobG8gPD0gdHhiZC0+d2IudHN0YW1wKQ0K
Kwl0c3RhbXBfbG8gPSBsZTMyX3RvX2NwdSh0eGJkLT53Yi50c3RhbXApOw0KKwlpZiAobG8gPD0g
dHN0YW1wX2xvKQ0KIAkJaGkgLT0gMTsNCi0JKnRzdGFtcCA9ICh1NjQpaGkgPDwgMzIgfCB0eGJk
LT53Yi50c3RhbXA7DQorCSp0c3RhbXAgPSAodTY0KWhpIDw8IDMyIHwgdHN0YW1wX2xvOw0KIH0N
CiANCiBzdGF0aWMgdm9pZCBlbmV0Y190c3RhbXBfdHgoc3RydWN0IHNrX2J1ZmYgKnNrYiwgdTY0
IHRzdGFtcCkNCkBAIC00ODMsMTYgKzQ4NCwxNyBAQCBzdGF0aWMgdm9pZCBlbmV0Y19nZXRfcnhf
dHN0YW1wKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KIAlzdHJ1Y3Qgc2tiX3NoYXJlZF9od3Rz
dGFtcHMgKnNoaHd0c3RhbXBzID0gc2tiX2h3dHN0YW1wcyhza2IpOw0KIAlzdHJ1Y3QgZW5ldGNf
bmRldl9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQogCXN0cnVjdCBlbmV0Y19odyAq
aHcgPSAmcHJpdi0+c2ktPmh3Ow0KLQl1MzIgbG8sIGhpOw0KKwl1MzIgbG8sIGhpLCB0c3RhbXBf
bG87DQogCXU2NCB0c3RhbXA7DQogDQotCWlmIChyeGJkLT5yLmZsYWdzICYgRU5FVENfUlhCRF9G
TEFHX1RTVE1QKSB7DQorCWlmIChsZTE2X3RvX2NwdShyeGJkLT5yLmZsYWdzKSAmIEVORVRDX1JY
QkRfRkxBR19UU1RNUCkgew0KIAkJbG8gPSBlbmV0Y19yZChodywgRU5FVENfU0lDVFIwKTsNCiAJ
CWhpID0gZW5ldGNfcmQoaHcsIEVORVRDX1NJQ1RSMSk7DQotCQlpZiAobG8gPD0gcnhiZC0+ci50
c3RhbXApDQorCQl0c3RhbXBfbG8gPSBsZTMyX3RvX2NwdShyeGJkLT5yLnRzdGFtcCk7DQorCQlp
ZiAobG8gPD0gdHN0YW1wX2xvKQ0KIAkJCWhpIC09IDE7DQogDQotCQl0c3RhbXAgPSAodTY0KWhp
IDw8IDMyIHwgcnhiZC0+ci50c3RhbXA7DQorCQl0c3RhbXAgPSAodTY0KWhpIDw8IDMyIHwgdHN0
YW1wX2xvOw0KIAkJbWVtc2V0KHNoaHd0c3RhbXBzLCAwLCBzaXplb2YoKnNoaHd0c3RhbXBzKSk7
DQogCQlzaGh3dHN0YW1wcy0+aHd0c3RhbXAgPSBuc190b19rdGltZSh0c3RhbXApOw0KIAl9DQot
LSANCjIuMTcuMQ0KDQo=
