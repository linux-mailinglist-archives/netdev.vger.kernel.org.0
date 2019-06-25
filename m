Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71175564A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732649AbfFYRsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:13 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:15870
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732594AbfFYRsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0283v4rh3LNWgXROBwTtwwvAx+yjsTFjbpbLJkACqak=;
 b=FQwjtyuWlOwu/IuLxiZAjcvPSbcm4cMJXiOLwRXcFYXHCH5Yep3ZjEZYPConLYu7nRpr14DCcTr5xllKOW4ciT6+D8EwVIMbD1zJvT28pWw9mz3yLfMZDzFHPSBQ0h4vzQdHd4p9iSffoJk2T7aUgUARXunLHcm6a1JwS7ULn1U=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:48:02 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:48:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 07/13] net/mlx5e: Specifying known origin of
 packets matching the flow
Thread-Topic: [PATCH V2 mlx5-next 07/13] net/mlx5e: Specifying known origin of
 packets matching the flow
Thread-Index: AQHVK34iclB6QsaIWkurryhVjQmBUQ==
Date:   Tue, 25 Jun 2019 17:48:02 +0000
Message-ID: <20190625174727.20309-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: da685513-31e0-4788-7330-08d6f99544bb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB221647E8C94E3DFC4A7089DEBEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OXs0VWBTZ+16sgl5m3vgGJI+JLxqFZ+9gqoyrNNA9V0lyFLoWuQgCHSXSbxOzSVmK3TD8S+CiQmcAcFo9qKKcd069X7aHWQWQQs642NIw1O4UJ5M3Z+EM664pHXV+iidShE/mL5alnXsqVBfbLGkrscTIy4YlPu3tMDS1z9qPkDkVKUWCpH3K/PwBPYdC5xwTm120SisDIBkXjxUcElEKv5YLtBnam9cfD/AqhCcf1FZlTz8zxDSeqK+ecKuuLgRlZXwMq6n3Rf4S0RvSKDC7y/1RNgsTWc168u8jYbRGGuAJK4zlwSMRLycQ9RojQNmelJFe5xWpHtZDZ7pJkBC/5jtmjHh38n8qQePA4FPMjFaRqICgs30LKyGzujggEzlALhfJrzM4afPMZrrCWYA7/OVAQPyffz5/8RCx3GzUJw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da685513-31e0-4788-7330-08d6f99544bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:48:02.2145
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
