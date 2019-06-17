Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7109048E53
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfFQTXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:39 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:14178
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728844AbfFQTXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XC+SfCHZqhycMn3ZkFSob8+KIbQ6HbZuv9Eg9FVa22Q=;
 b=c/IH2Py3ASw+qcTNg5aL6x5EcF7uNGA3ArDXBb2mXrkvLZmlUnYwQkG137/MVNo1VVfaZqCbVrjkBqNV2lTqffr4EmAh0TPTtY1ghEmP0IyETi2T65VIymE/9RT83QSoixmBzUvHwcIKtSze6Oc62CgFqfTe0O0vlCRDfWR/Dsk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:24 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 08/15] net/mlx5: E-Switch, Add query and modify esw
 vport context functions
Thread-Topic: [PATCH mlx5-next 08/15] net/mlx5: E-Switch, Add query and modify
 esw vport context functions
Thread-Index: AQHVJUIh062wFXxbvke6DKQ0KqJoLA==
Date:   Mon, 17 Jun 2019 19:23:24 +0000
Message-ID: <20190617192247.25107-9-saeedm@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
In-Reply-To: <20190617192247.25107-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f0b927b-317e-4a69-defd-08d6f35943e8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB2789F37EA2405C2F5ECB65DCBEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YdQVUAVJ66zEOlAsOAo+zmSPWQYuqlGAvfAluxBgK/kwTKjYNJkfde1DMUBbV091f1fLfDrRKPyjwiyiUuLKhcQe79rHpHHjdzka+9hdX/BgxHmjgYN9enIoaWQ/eaxasUZXipjMqXT1AGZHrIHVXFuxw7S8N/JlbwLAg5McQr5FDekTLRuRMhkaBHc46HQY8S3ALqRCyBTtjRXGMIF43kcXrJggZ54KL0wwasktiyBFtV9dj/s1AYCmX9ZMf14f0m7VgrHnOorB05pEmu6UCZjPgtubKCxUNoLGSH79+rdZPdJGjnrKKSvkwXTyqv7zYGm53blVVcst9SgBlZheXJGiOfzukBFY3nFrTS9P9lPutTFToDPOHwE5Mw0RADeeKjHBuMq59a5h8EpArUVJatXWFDLNuJuZnTpeM/nB9Us=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0b927b-317e-4a69-defd-08d6f35943e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:24.1561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNCkFkZCBlc3cgdnBvcnQg
cXVlcnkgYW5kIG1vZGlmeSBmdW5jdGlvbnMsIGFuZCBleHBvc2luZyB0aGVtIGlzIG5lZWRlZCBm
b3INCmVuYWJsaW5nIG9yIGRpc2FibGluZyByZWdpc3RlcnMgcGFzc2VkIGFzIG1ldGF0ZGF0YSB0
byB2cG9ydCBOSUNfUlggdGFibGUNCmluIHNsb3cgcGF0aC4NCg0KU2lnbmVkLW9mZi1ieTogSmlh
bmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogUm9pIERheWFuIDxy
b2lkQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5v
eC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNv
bT4NCi0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guYyB8
IDI0ICsrKysrKysrKysrKysrKysrKysNCiAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lc3dpdGNoLmggfCAgNSArKysrDQogMiBmaWxlcyBjaGFuZ2VkLCAyOSBpbnNlcnRpb25z
KCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZXN3aXRjaC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vz
d2l0Y2guYw0KaW5kZXggMTIzNWZkODRhZTNhLi42NzU5ODI3MmQ0YTkgMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQorKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5jDQpAQCAtMTM0
LDYgKzEzNCwzMCBAQCBzdGF0aWMgaW50IG1vZGlmeV9lc3dfdnBvcnRfY29udGV4dF9jbWQoc3Ry
dWN0IG1seDVfY29yZV9kZXYgKmRldiwgdTE2IHZwb3J0LA0KIAlyZXR1cm4gbWx4NV9jbWRfZXhl
YyhkZXYsIGluLCBpbmxlbiwgb3V0LCBzaXplb2Yob3V0KSk7DQogfQ0KIA0KK2ludCBtbHg1X2Vz
d2l0Y2hfbW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywg
dTE2IHZwb3J0LA0KKwkJCQkJICB2b2lkICppbiwgaW50IGlubGVuKQ0KK3sNCisJcmV0dXJuIG1v
ZGlmeV9lc3dfdnBvcnRfY29udGV4dF9jbWQoZXN3LT5kZXYsIHZwb3J0LCBpbiwgaW5sZW4pOw0K
K30NCisNCitzdGF0aWMgaW50IHF1ZXJ5X2Vzd192cG9ydF9jb250ZXh0X2NtZChzdHJ1Y3QgbWx4
NV9jb3JlX2RldiAqZGV2LCB1MTYgdnBvcnQsDQorCQkJCSAgICAgICB2b2lkICpvdXQsIGludCBv
dXRsZW4pDQorew0KKwl1MzIgaW5bTUxYNV9TVF9TWl9EVyhxdWVyeV9lc3dfdnBvcnRfY29udGV4
dF9pbildID0ge307DQorDQorCU1MWDVfU0VUKHF1ZXJ5X2Vzd192cG9ydF9jb250ZXh0X2luLCBp
biwgb3Bjb2RlLA0KKwkJIE1MWDVfQ01EX09QX1FVRVJZX0VTV19WUE9SVF9DT05URVhUKTsNCisJ
TUxYNV9TRVQobW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0X2luLCBpbiwgdnBvcnRfbnVtYmVyLCB2
cG9ydCk7DQorCU1MWDVfU0VUKG1vZGlmeV9lc3dfdnBvcnRfY29udGV4dF9pbiwgaW4sIG90aGVy
X3Zwb3J0LCAxKTsNCisJcmV0dXJuIG1seDVfY21kX2V4ZWMoZGV2LCBpbiwgc2l6ZW9mKGluKSwg
b3V0LCBvdXRsZW4pOw0KK30NCisNCitpbnQgbWx4NV9lc3dpdGNoX3F1ZXJ5X2Vzd192cG9ydF9j
b250ZXh0KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywgdTE2IHZwb3J0LA0KKwkJCQkJIHZvaWQg
Km91dCwgaW50IG91dGxlbikNCit7DQorCXJldHVybiBxdWVyeV9lc3dfdnBvcnRfY29udGV4dF9j
bWQoZXN3LT5kZXYsIHZwb3J0LCBvdXQsIG91dGxlbik7DQorfQ0KKw0KIHN0YXRpYyBpbnQgbW9k
aWZ5X2Vzd192cG9ydF9jdmxhbihzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB1MTYgdnBvcnQs
DQogCQkJCSAgdTE2IHZsYW4sIHU4IHFvcywgdTggc2V0X2ZsYWdzKQ0KIHsNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2guaA0KaW5kZXggNDQx
N2ExOTU4MzJlLi5hZWJiMWE0YjkwNzAgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oDQpAQCAtMjc2LDYgKzI3NiwxMSBAQCBpbnQg
bWx4NV9lc3dpdGNoX2dldF92cG9ydF9zdGF0cyhzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQog
CQkJCSBzdHJ1Y3QgaWZsYV92Zl9zdGF0cyAqdmZfc3RhdHMpOw0KIHZvaWQgbWx4NV9lc3dpdGNo
X2RlbF9zZW5kX3RvX3Zwb3J0X3J1bGUoc3RydWN0IG1seDVfZmxvd19oYW5kbGUgKnJ1bGUpOw0K
IA0KK2ludCBtbHg1X2Vzd2l0Y2hfbW9kaWZ5X2Vzd192cG9ydF9jb250ZXh0KHN0cnVjdCBtbHg1
X2Vzd2l0Y2ggKmVzdywgdTE2IHZwb3J0LA0KKwkJCQkJICB2b2lkICppbiwgaW50IGlubGVuKTsN
CitpbnQgbWx4NV9lc3dpdGNoX3F1ZXJ5X2Vzd192cG9ydF9jb250ZXh0KHN0cnVjdCBtbHg1X2Vz
d2l0Y2ggKmVzdywgdTE2IHZwb3J0LA0KKwkJCQkJIHZvaWQgKm91dCwgaW50IG91dGxlbik7DQor
DQogc3RydWN0IG1seDVfZmxvd19zcGVjOw0KIHN0cnVjdCBtbHg1X2Vzd19mbG93X2F0dHI7DQog
DQotLSANCjIuMjEuMA0KDQo=
