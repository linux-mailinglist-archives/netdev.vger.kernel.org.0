Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741DD48E51
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfFQTXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:23:36 -0400
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:14178
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728834AbfFQTXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0283v4rh3LNWgXROBwTtwwvAx+yjsTFjbpbLJkACqak=;
 b=h69oOq9ZJKJUV+rpVzRvGg9TtMjsFuYCY4iE+crcA80M9A4q4MoBoqNhxISri3tbVNVtEIGJPdhcgSa2jHIa3zBu2TCj1kzjjLNaycR1F6264amDEvyhEPeGp8Up9dj++AhkCgVFChctWuGb+4GZ2y8PNcq/7lJM3vDSlwzglJY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2789.eurprd05.prod.outlook.com (10.172.226.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 19:23:19 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 19:23:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 06/15] net/mlx5e: Specifying known origin of packets
 matching the flow
Thread-Topic: [PATCH mlx5-next 06/15] net/mlx5e: Specifying known origin of
 packets matching the flow
Thread-Index: AQHVJUIfy49gnJrk80iSMgJ3JSKyBg==
Date:   Mon, 17 Jun 2019 19:23:19 +0000
Message-ID: <20190617192247.25107-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 838c9910-5fc8-4d00-a705-08d6f3594165
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2789;
x-ms-traffictypediagnostic: DB6PR0501MB2789:
x-microsoft-antispam-prvs: <DB6PR0501MB2789709541AD433B375DEE7FBEEB0@DB6PR0501MB2789.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(366004)(346002)(376002)(136003)(199004)(189003)(2906002)(50226002)(64756008)(66556008)(66446008)(68736007)(256004)(6636002)(66476007)(2616005)(476003)(446003)(66946007)(73956011)(5660300002)(71200400001)(7736002)(6506007)(386003)(71190400001)(76176011)(102836004)(99286004)(53936002)(305945005)(52116002)(11346002)(1076003)(8676002)(4326008)(450100002)(25786009)(6486002)(3846002)(6116002)(478600001)(186003)(26005)(316002)(110136005)(8936002)(6512007)(81166006)(486006)(81156014)(107886003)(86362001)(14454004)(66066001)(6436002)(36756003)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2789;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jxlLdPeSF0bPcLkVF1Ls+YyvFoFyiG4KdkEmfW05AbiiPnKMdm/KerEHYnJPS1E3vBp1WgNDyaxu4rv4wR34novTjcB+Jajnbq5WdyixQGYD+HqlBff09XFGpfOYE+3AjhrNWj/mJH6DwW/CAglC8CfMi80NCIUHrxbcTND2J9CwYAqHreZG3EknoIFm5o9L1YT6gyBCw9wzOME6XzDPcNzqmfUTXLd4UuDIa6bnkdOSpt7LfL8HUdw+yByQsk760y/9aSX9y0446ONJzW9YJ0W71TIR0iOX8neeoCbGlGUwgd42adRktDALDDBgAuJaPDZKxtvevy2v/xTR0YSartJhOZHLpZgiafPVMGnmi2F5s5v7o1mck+3ImB+TQn1jrkXHR47pOUuUmW89sBM07NFeEyyJNX66HzhGMGq+dWo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 838c9910-5fc8-4d00-a705-08d6f3594165
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 19:23:19.7726
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

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNCkluIHZwb3J0IG1ldGFk
YXRhIG1hdGNoaW5nLCBzb3VyY2UgcG9ydCBudW1iZXIgaXMgcmVwbGFjZWQgYnkgbWV0YWRhdGEu
DQpXaGlsZSBGVyBoYXMgbm8gaWRlYSBhYm91dCB3aGF0IGl0IGlzIGluIHRoZSBtZXRhZGF0YSwg
YSBzeW5kcm9tZSB3aWxsDQpoYXBwZW4uIFNwZWNpZnkgYSBrbm93biBvcmlnaW4gdG8gYXZvaWQg
dGhlIHN5bmRyb21lLg0KSG93ZXZlciwgdGhlcmUgaXMgbm8gZnVuY3Rpb25hbCBjaGFuZ2UgYmVj
YXVzZSBBTllfVlBPUlQgKDApIGlzIGZpbGxlZA0KaW4gZmxvd19zb3VyY2UsIHRoZSBzYW1lIGRl
ZmF1bHQgdmFsdWUgYXMgYmVmb3JlLCBhcyBhIHByZS1zdGVwIHRvd2FyZHMNCm1ldGFkYXRhIG1h
dGNoaW5nIGZvciBmYXN0IHBhdGguDQpUaGVyZSBhcmUgdHdvIG90aGVyIHZhbHVlcyBjYW4gYmUg
ZmlsbGVkIGluIGZsb3dfc291cmNlLiBXaGVuIHNldHRpbmcNCjB4MSwgcGFja2V0IG1hdGNoaW5n
IHRoaXMgcnVsZSBpcyBmcm9tIHVwbGluaywgd2hpbGUgMHgyIGlzIGZvciBwYWNrZXQNCmZyb20g
b3RoZXIgbG9jYWwgdnBvcnRzLg0KDQpTaWduZWQtb2ZmLWJ5OiBKaWFuYm8gTGl1IDxqaWFuYm9s
QG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBNYXJrIEJsb2NoIDxtYXJrYkBtZWxsYW5veC5j
b20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4N
Ci0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kaWFnL2ZzX3Ry
YWNlcG9pbnQuaCB8IDIgKysNCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZnNfY21kLmMgICAgICAgICAgICAgfCAzICsrKw0KIGluY2x1ZGUvbGludXgvbWx4NS9mcy5o
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IDEgKw0KIDMgZmlsZXMgY2hh
bmdlZCwgNiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9mc190cmFjZXBvaW50LmggYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9mc190cmFjZXBvaW50LmgNCmluZGV4IDll
YzQ2ZWRmMjJhNi4uZGRmMWI4N2YxYmMwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZnNfdHJhY2Vwb2ludC5oDQorKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9mc190cmFjZXBvaW50LmgNCkBA
IC0xODcsNiArMTg3LDcgQEAgVFJBQ0VfRVZFTlQobWx4NV9mc19zZXRfZnRlLA0KIAkJX19maWVs
ZCh1MzIsIGluZGV4KQ0KIAkJX19maWVsZCh1MzIsIGFjdGlvbikNCiAJCV9fZmllbGQodTMyLCBm
bG93X3RhZykNCisJCV9fZmllbGQodTMyLCBmbG93X3NvdXJjZSkNCiAJCV9fZmllbGQodTgsICBt
YXNrX2VuYWJsZSkNCiAJCV9fZmllbGQoaW50LCBuZXdfZnRlKQ0KIAkJX19hcnJheSh1MzIsIG1h
c2tfb3V0ZXIsIE1MWDVfU1RfU1pfRFcoZnRlX21hdGNoX3NldF9seXJfMl80KSkNCkBAIC0yMDUs
NiArMjA2LDcgQEAgVFJBQ0VfRVZFTlQobWx4NV9mc19zZXRfZnRlLA0KIAkJCSAgIF9fZW50cnkt
PmFjdGlvbiA9IGZ0ZS0+YWN0aW9uLmFjdGlvbjsNCiAJCQkgICBfX2VudHJ5LT5tYXNrX2VuYWJs
ZSA9IF9fZW50cnktPmZnLT5tYXNrLm1hdGNoX2NyaXRlcmlhX2VuYWJsZTsNCiAJCQkgICBfX2Vu
dHJ5LT5mbG93X3RhZyA9IGZ0ZS0+Zmxvd19jb250ZXh0LmZsb3dfdGFnOw0KKwkJCSAgIF9fZW50
cnktPmZsb3dfc291cmNlID0gZnRlLT5mbG93X2NvbnRleHQuZmxvd19zb3VyY2U7DQogCQkJICAg
bWVtY3B5KF9fZW50cnktPm1hc2tfb3V0ZXIsDQogCQkJCSAgTUxYNV9BRERSX09GKGZ0ZV9tYXRj
aF9wYXJhbSwNCiAJCQkJCSAgICAgICAmX19lbnRyeS0+ZmctPm1hc2subWF0Y2hfY3JpdGVyaWEs
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Zz
X2NtZC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5j
DQppbmRleCBmYjEzMzVhNDMzYWUuLjdhYzEyNDllYWRjMyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jbWQuYw0KKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5jDQpAQCAtMzk4LDYgKzM5OCw5
IEBAIHN0YXRpYyBpbnQgbWx4NV9jbWRfc2V0X2Z0ZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2
LA0KIA0KIAlNTFg1X1NFVChmbG93X2NvbnRleHQsIGluX2Zsb3dfY29udGV4dCwgZmxvd190YWcs
DQogCQkgZnRlLT5mbG93X2NvbnRleHQuZmxvd190YWcpOw0KKwlNTFg1X1NFVChmbG93X2NvbnRl
eHQsIGluX2Zsb3dfY29udGV4dCwgZmxvd19zb3VyY2UsDQorCQkgZnRlLT5mbG93X2NvbnRleHQu
Zmxvd19zb3VyY2UpOw0KKw0KIAlNTFg1X1NFVChmbG93X2NvbnRleHQsIGluX2Zsb3dfY29udGV4
dCwgZXh0ZW5kZWRfZGVzdGluYXRpb24sDQogCQkgZXh0ZW5kZWRfZGVzdCk7DQogCWlmIChleHRl
bmRlZF9kZXN0KSB7DQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbHg1L2ZzLmggYi9pbmNs
dWRlL2xpbnV4L21seDUvZnMuaA0KaW5kZXggOWJmNDljZTIxOGZhLi5kYzdlN2FhNTNhMTMgMTAw
NjQ0DQotLS0gYS9pbmNsdWRlL2xpbnV4L21seDUvZnMuaA0KKysrIGIvaW5jbHVkZS9saW51eC9t
bHg1L2ZzLmgNCkBAIC05NSw2ICs5NSw3IEBAIGVudW0gew0KIHN0cnVjdCBtbHg1X2Zsb3dfY29u
dGV4dCB7DQogCXUzMiBmbGFnczsNCiAJdTMyIGZsb3dfdGFnOw0KKwl1MzIgZmxvd19zb3VyY2U7
DQogfTsNCiANCiBzdHJ1Y3QgbWx4NV9mbG93X3NwZWMgew0KLS0gDQoyLjIxLjANCg0K
