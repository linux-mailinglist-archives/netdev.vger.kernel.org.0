Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892B93C00E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390865AbfFJXiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:38:55 -0400
Received: from mail-eopbgr20066.outbound.protection.outlook.com ([40.107.2.66]:22416
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390832AbfFJXix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 19:38:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gM7dWPXWlfk4ptx2pV7I0SXYHqVQ5bxQFvZ/8i4xJBA=;
 b=Lt3KEgyq6BBW6xulTZT3Aqr2QHpVLYx+1PXC6Eo0zcjvQlgXtkIHGFVer2NZwNNWwzN7lIPGwAnPtqor7tEkoFhVfETTyBTD9H4I3BfVne8ZkR5oXIL8CIr0t65X3dGpLr95DNdKpriUQnLjNj+RjOmfxtTKKQGMiiccaBxySRQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 23:38:35 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:38:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 12/16] net/mlx5: Generalize IRQ interface to work
 with irq_table
Thread-Topic: [PATCH mlx5-next 12/16] net/mlx5: Generalize IRQ interface to
 work with irq_table
Thread-Index: AQHVH+WeITJXbKY3kEaF54OoXBOU5Q==
Date:   Mon, 10 Jun 2019 23:38:34 +0000
Message-ID: <20190610233733.12155-13-saeedm@mellanox.com>
References: <20190610233733.12155-1-saeedm@mellanox.com>
In-Reply-To: <20190610233733.12155-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0015.prod.exchangelabs.com (2603:10b6:a02:80::28)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 662823dc-1669-4464-97e6-08d6edfcc0f6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB2166E03F28C83353B66F8323BE130@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(39860400002)(346002)(396003)(189003)(199004)(450100002)(85306007)(53936002)(6512007)(14454004)(50226002)(2616005)(186003)(256004)(81166006)(486006)(6436002)(11346002)(5024004)(8676002)(8936002)(25786009)(476003)(52116002)(446003)(2906002)(478600001)(99286004)(81156014)(4326008)(6486002)(107886003)(71200400001)(5660300002)(66446008)(64756008)(305945005)(66946007)(386003)(6506007)(7736002)(26005)(76176011)(71190400001)(102836004)(66476007)(86362001)(73956011)(66556008)(110136005)(6636002)(36756003)(54906003)(3846002)(6116002)(316002)(1076003)(66066001)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Bo3BI1iPBQHfijjkj8DEjiwcNHDnpXMGfmnfaDmISa0ZM7wdi6jlFS2EobSlwTxajWni/4oQhQmhltWXOidLch4S7qiXb8PD9pexRZ4aknfNcy9SWRUYh3hGWAwEeqg/0rax+z3L1kMIolaev5pfWUhr6WbMdAXYPLcmedICAa6B64l/gAjC1D7ZuK5gbUZdzI/4CVBxVf8EksnDEXFc3wI/4hdgMiMKDrRCadYJU/KNXWW9c5ZKNu/SVPuwspERAHcGUkW8GKbOnDGBG5eG8tXQprC2lDRwELBS204U1zKtrJ4UpMbIuaPvW8sIndMcSOsr+FpRQ0ZqGC0duIBgBv9gSEz17ChatAlthbDeraLQmk3K7WPbOOM+b5+uYBVWFBBp1/tdWFA6saF5UKbJaUA948nt5apb3zS1clGapSE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662823dc-1669-4464-97e6-08d6edfcc0f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:38:34.9736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXV2YWwgQXZuZXJ5IDx5dXZhbGF2QG1lbGxhbm94LmNvbT4NCg0KSVJRIGludGVyZmFj
ZSBzaG91bGQgb3BlcmF0ZSB3aXRoaW4gdGhlIGlycV90YWJsZSBjb250ZXh0Lg0KSXQgc2hvdWxk
IGJlIGluZGVwZW5kZW50IG9mIGFueSBFUSBkYXRhIHN0cnVjdHVyZS4NCg0KVGhlIGludGVyZmFj
ZSB0aGF0IHdpbGwgYmUgZXhwb3NlZDoNCmluaXQvY2xlbnVwLCBjcmVhdGUvZGVzdHJveSwgYXR0
YWNoL2RldGFjaA0KDQpTaWduZWQtb2ZmLWJ5OiBZdXZhbCBBdm5lcnkgPHl1dmFsYXZAbWVsbGFu
b3guY29tPg0KUmV2aWV3ZWQtYnk6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0K
U2lnbmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQotLS0N
CiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYyB8IDM4ICsrKysr
KysrKysrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDkgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZXEuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
cS5jDQppbmRleCBkYWY5YmMzMTU1Y2MuLjgwYTQzNmI1MDM0YSAxMDA2NDQNCi0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lcS5jDQorKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXEuYw0KQEAgLTE0MywxNiArMTQzLDIyIEBA
IHN0YXRpYyBzdHJ1Y3QgbWx4NV9pcnFfaW5mbyAqbWx4NV9pcnFfZ2V0KHN0cnVjdCBtbHg1X2Nv
cmVfZGV2ICpkZXYsIGludCB2ZWNpZHgpDQogCXJldHVybiAmaXJxX3RhYmxlLT5pcnFfaW5mb1t2
ZWNpZHhdOw0KIH0NCiANCi1zdGF0aWMgaW50IG1seDVfaXJxX2F0dGFjaF9uYihzdHJ1Y3QgbWx4
NV9pcnFfaW5mbyAqaXJxLA0KK3N0YXRpYyBpbnQgbWx4NV9pcnFfYXR0YWNoX25iKHN0cnVjdCBt
bHg1X2lycV90YWJsZSAqaXJxX3RhYmxlLCBpbnQgdmVjaWR4LA0KIAkJCSAgICAgIHN0cnVjdCBu
b3RpZmllcl9ibG9jayAqbmIpDQogew0KLQlyZXR1cm4gYXRvbWljX25vdGlmaWVyX2NoYWluX3Jl
Z2lzdGVyKCZpcnEtPm5oLCBuYik7DQorCXN0cnVjdCBtbHg1X2lycV9pbmZvICppcnFfaW5mbzsN
CisNCisJaXJxX2luZm8gPSAmaXJxX3RhYmxlLT5pcnFfaW5mb1t2ZWNpZHhdOw0KKwlyZXR1cm4g
YXRvbWljX25vdGlmaWVyX2NoYWluX3JlZ2lzdGVyKCZpcnFfaW5mby0+bmgsIG5iKTsNCiB9DQog
DQotc3RhdGljIGludCBtbHg1X2lycV9kZXRhY2hfbmIoc3RydWN0IG1seDVfaXJxX2luZm8gKmly
cSwNCitzdGF0aWMgaW50IG1seDVfaXJxX2RldGFjaF9uYihzdHJ1Y3QgbWx4NV9pcnFfdGFibGUg
KmlycV90YWJsZSwgaW50IHZlY2lkeCwNCiAJCQkgICAgICBzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sg
Km5iKQ0KIHsNCi0JcmV0dXJuIGF0b21pY19ub3RpZmllcl9jaGFpbl91bnJlZ2lzdGVyKCZpcnEt
Pm5oLCBuYik7DQorCXN0cnVjdCBtbHg1X2lycV9pbmZvICppcnFfaW5mbzsNCisNCisJaXJxX2lu
Zm8gPSAmaXJxX3RhYmxlLT5pcnFfaW5mb1t2ZWNpZHhdOw0KKwlyZXR1cm4gYXRvbWljX25vdGlm
aWVyX2NoYWluX3VucmVnaXN0ZXIoJmlycV9pbmZvLT5uaCwgbmIpOw0KIH0NCiANCiBzdGF0aWMg
aXJxcmV0dXJuX3QgbWx4NV9pcnFfaW50X2hhbmRsZXIoaW50IGlycSwgdm9pZCAqbmgpDQpAQCAt
NDY1LDcgKzQ3MSw4IEBAIGNyZWF0ZV9tYXBfZXEoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwg
c3RydWN0IG1seDVfZXEgKmVxLA0KIAllcS0+ZG9vcmJlbGwgPSBwcml2LT51YXItPm1hcCArIE1M
WDVfRVFfRE9PUkJFTF9PRkZTRVQ7DQogCWVxLT5pcnFfbmIgPSBwYXJhbS0+bmI7DQogDQotCWVy
ciA9IG1seDVfaXJxX2F0dGFjaF9uYihtbHg1X2lycV9nZXQoZGV2LCB2ZWNpZHgpLCBwYXJhbS0+
bmIpOw0KKwllcnIgPSBtbHg1X2lycV9hdHRhY2hfbmIoZGV2LT5wcml2LmVxX3RhYmxlLT5pcnFf
dGFibGUsIHZlY2lkeCwNCisJCQkJIHBhcmFtLT5uYik7DQogCWlmIChlcnIpDQogCQlnb3RvIGVy
cl9lcTsNCiANCkBAIC00ODEsNyArNDg4LDcgQEAgY3JlYXRlX21hcF9lcShzdHJ1Y3QgbWx4NV9j
b3JlX2RldiAqZGV2LCBzdHJ1Y3QgbWx4NV9lcSAqZXEsDQogCXJldHVybiAwOw0KIA0KIGVycl9k
ZXRhY2g6DQotCW1seDVfaXJxX2RldGFjaF9uYihtbHg1X2lycV9nZXQoZGV2LCB2ZWNpZHgpLCBl
cS0+aXJxX25iKTsNCisJbWx4NV9pcnFfZGV0YWNoX25iKGRldi0+cHJpdi5lcV90YWJsZS0+aXJx
X3RhYmxlLCB2ZWNpZHgsIGVxLT5pcnFfbmIpOw0KIA0KIGVycl9lcToNCiAJbWx4NV9jbWRfZGVz
dHJveV9lcShkZXYsIGVxLT5lcW4pOw0KQEAgLTUwMCw3ICs1MDcsOCBAQCBzdGF0aWMgaW50IGRl
c3Ryb3lfdW5tYXBfZXEoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgc3RydWN0IG1seDVfZXEg
KmVxKQ0KIA0KIAltbHg1X2RlYnVnX2VxX3JlbW92ZShkZXYsIGVxKTsNCiANCi0JZXJyID0gbWx4
NV9pcnFfZGV0YWNoX25iKG1seDVfaXJxX2dldChkZXYsIGVxLT52ZWNpZHgpLCBlcS0+aXJxX25i
KTsNCisJZXJyID0gbWx4NV9pcnFfZGV0YWNoX25iKGRldi0+cHJpdi5lcV90YWJsZS0+aXJxX3Rh
YmxlLA0KKwkJCQkgZXEtPnZlY2lkeCwgZXEtPmlycV9uYik7DQogCWlmIChlcnIpDQogCQltbHg1
X2NvcmVfd2FybihlcS0+ZGV2LCAiZXEgZmFpbGVkIHRvIGRldGFjaCBmcm9tIGlycS4gZXJyICVk
IiwNCiAJCQkgICAgICAgZXJyKTsNCkBAIC0xMDIzLDE5ICsxMDMxLDMxIEBAIHVuc2lnbmVkIGlu
dCBtbHg1X2NvbXBfdmVjdG9yc19jb3VudChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2KQ0KIH0N
CiBFWFBPUlRfU1lNQk9MKG1seDVfY29tcF92ZWN0b3JzX2NvdW50KTsNCiANCitzdGF0aWMgc3Ry
dWN0IGNwdW1hc2sgKg0KK21seDVfaXJxX2dldF9hZmZpbml0eV9tYXNrKHN0cnVjdCBtbHg1X2ly
cV90YWJsZSAqaXJxX3RhYmxlLCBpbnQgdmVjaWR4KQ0KK3sNCisJcmV0dXJuIGlycV90YWJsZS0+
aXJxX2luZm9bdmVjaWR4XS5tYXNrOw0KK30NCisNCiBzdHJ1Y3QgY3B1bWFzayAqDQogbWx4NV9j
b21wX2lycV9nZXRfYWZmaW5pdHlfbWFzayhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBpbnQg
dmVjdG9yKQ0KIHsNCiAJaW50IHZlY2lkeCA9IHZlY3RvciArIE1MWDVfRVFfVkVDX0NPTVBfQkFT
RTsNCiANCi0JcmV0dXJuIGRldi0+cHJpdi5lcV90YWJsZS0+aXJxX3RhYmxlLT5pcnFfaW5mb1t2
ZWNpZHhdLm1hc2s7DQorCXJldHVybiBtbHg1X2lycV9nZXRfYWZmaW5pdHlfbWFzayhkZXYtPnBy
aXYuZXFfdGFibGUtPmlycV90YWJsZSwNCisJCQkJCSAgdmVjaWR4KTsNCiB9DQogRVhQT1JUX1NZ
TUJPTChtbHg1X2NvbXBfaXJxX2dldF9hZmZpbml0eV9tYXNrKTsNCiANCiAjaWZkZWYgQ09ORklH
X1JGU19BQ0NFTA0KK3N0YXRpYyBzdHJ1Y3QgY3B1X3JtYXAgKm1seDVfaXJxX2dldF9ybWFwKHN0
cnVjdCBtbHg1X2lycV90YWJsZSAqaXJxX3RhYmxlKQ0KK3sNCisJcmV0dXJuIGlycV90YWJsZS0+
cm1hcDsNCit9DQorDQogc3RydWN0IGNwdV9ybWFwICptbHg1X2VxX3RhYmxlX2dldF9ybWFwKHN0
cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpDQogew0KLQlyZXR1cm4gZGV2LT5wcml2LmVxX3RhYmxl
LT5pcnFfdGFibGUtPnJtYXA7DQorCXJldHVybiBtbHg1X2lycV9nZXRfcm1hcChkZXYtPnByaXYu
ZXFfdGFibGUtPmlycV90YWJsZSk7DQogfQ0KICNlbmRpZg0KIA0KLS0gDQoyLjIxLjANCg0K
