Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73A0121079
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLPRDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:03:38 -0500
Received: from mail-eopbgr750081.outbound.protection.outlook.com ([40.107.75.81]:59109
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726016AbfLPRDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbAarm5TlbOuF7nMFybJBUQAwWyh+m6XVpVD4hPTkcooMiMsG8Pf+8hsqzzj5e+nZOeA6F8gLSqta/zXNSQJgCrDy2+pmdtIbi2SzdH7ZcHPb6szQodeuHwNCMGHHPBy4wWhnwLNvP8FuAanMqIutFZcY9LzIZMwEUWpubeB2TNbtDSXsFIuHVRk10TuQzoEZ3LIGwAUViyCkxbXs4gpk33nM0XqxT3+WFEXXfAJ83wRAf3wD6Atjnxj6JMjjazwb0ktH01z6dhNnYRvdZMxsOzvFUg+B3YKbDaka3BYARTCYQO/WOrxGb6WjU9Rhq5oKLZZBVLL0cydCVLV29I/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Dvr+kvx6Q5qAoNnAw4+GkI8AOBwNA1bAmQT1ux4GTU=;
 b=R1r8MC0lkgZO0iqmzSOoO2C1QVJQyV2gvlSezTs46eAyViP5ghR1D1vhfT8jsm/LOhrKMXEC+5ynYMWceMqc1OhyhNZDUDQpCeH4iF0KvLOnMCV6nxNjLbpXayWL31ap4NZSUJqbQn2cC2WP1rIfgxOphBd6Wt7fx8MCRaGFExVIbE12l9Sd75y6ps2STej8ttnnrNBWnwRhEGfNDTItlp47VPs6m/piRSVdkK0LHS55E4ooNHCPN6Kj1ICClcIAAF33U2KF/duPsLpl/A08iJX/rlKX4xYOmA3ENp4xG9gmiyUITYX33YNf/YuUiJsHXORxn+GIS2GQY7qwtuOVgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Dvr+kvx6Q5qAoNnAw4+GkI8AOBwNA1bAmQT1ux4GTU=;
 b=Xa+WmeXL4wcfju1rt8tBFwgMXf85IG7scsCp6wzBk/7wZvnvoXeZoiJgqsv7Rem+rxdOmIU+2vN2RrGyzvcd9+VoIh4AVFCS73cdfxQHV3gQpwy1n5UcI3aWosw1nkVddrqM72cJu61iOuXqkfMkEexuI1RhicI3omriU7PjmyI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3838.namprd11.prod.outlook.com (20.178.252.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:33 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:33 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 01/55] staging: wfx: fix the cache of rate policies on
 interface reset
Thread-Topic: [PATCH 01/55] staging: wfx: fix the cache of rate policies on
 interface reset
Thread-Index: AQHVtDK/FGlLQ2gb2UOMnSXAR2+Aow==
Date:   Mon, 16 Dec 2019 17:03:33 +0000
Message-ID: <20191216170302.29543-2-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40a18dd3-02c1-4797-9227-08d78249e25b
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB383827797C1DA0A9A8CFF1CD93510@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(85202003)(8936002)(81166006)(8676002)(54906003)(110136005)(316002)(85182001)(6506007)(186003)(2906002)(5660300002)(6512007)(26005)(107886003)(81156014)(36756003)(4326008)(2616005)(76116006)(91956017)(64756008)(66556008)(66476007)(66946007)(71200400001)(86362001)(66446008)(6486002)(478600001)(1076003)(66574012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3838;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7AB4safKcbspFlys09C+bMdj3W3B/mMZSqLqu9d0jFSk5+tTRYdwUPBbfiWnLQapAOQiUYiyRKouV3z5w0irrMFEdve6ro4b+Dr0JrrTXUdxQpKXOyBvR9Z948b1Pc6UjVxryBn4nwRiYC5lc9kWovnK6w3yMMc9XGI5ihS4fvANvGduJojPiKHQ2DYLsjCpLxEu7JTiG4ASLJpn/hhbny4CuulAPlVbo8AVd2NCesQqjzYKQ9GqIA2BlCqXVJ6CYxNVlNc0Jfs8Sbc+TfGm8Jh9nqvdTXrzIplI/m9N953I3as3CEJjtgaGfLV1iF+yv3i5ASLAYB1W8Avn3u8/33zVVo4NJD1chb9H2zTOTjLouASZeH4vhWxpidzKAdsGKkRo2nwAscymmZxMqXPDznOzRnu6SbFZM3fadTIXpUhnhGBwJ8daolvcLgxPFe1k
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE5220FA663DFB409E1258D711B42CB6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a18dd3-02c1-4797-9227-08d78249e25b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:33.5671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jKxfrTUjK+tOuUrNR1Nxab657azfSn+PXlbTHJWhb+dic+9gZhl5E+zctXn8cgA6T9es8IfGluZbQBI+KkaX6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpE
ZXZpY2UgYW5kIGRyaXZlciBtYWludGFpbiBhIGNhY2hlIG9mIHJhdGUgcG9saWNpZXMgKGFrYS4N
CnR4X3JldHJ5X3BvbGljeSBpbiBoYXJkd2FyZSBBUEkpLg0KDQpXaGVuIGhpZl9yZXNldCgpIGlz
IHNlbnQgdG8gaGFyZHdhcmUsIGRldmljZSByZXNldHMgaXRzIGNhY2hlIG9mIHJhdGUNCnBvbGlj
aWVzLiBJbiBvcmRlciB0byBrZWVwIGRyaXZlciBpbiBzeW5jLCBpdCBpcyBuZWNlc3NhcnkgdG8g
ZG8gdGhlDQpzYW1lIG9uIGRyaXZlci4NCg0KTm90ZSwgd2hlbiBkcml2ZXIgdHJpZXMgdG8gdXNl
IGEgcmF0ZSBwb2xpY3kgdGhhdCBoYXMgbm90IGJlZW4gZGVmaW5lZA0Kb24gZGV2aWNlLCBkYXRh
IGlzIHNlbnQgYXQgMU1icHMuIFNvLCB0aGlzIHBhdGNoIHNob3VsZCBmaXggYWJub3JtYWwNCnRo
cm91Z2hwdXQgb2JzZXJ2ZWQgc29tZXRpbWUgYWZ0ZXIgYSByZXNldCBvZiB0aGUgaW50ZXJmYWNl
Lg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8IDMgKy0tDQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmggfCAxICsNCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jICAgICB8IDYgKysrKystDQogMyBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jDQppbmRleCBiNzIyZTk3NzMyMzIu
LjAyZjAwMWRhYjYyYiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
DQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYw0KQEAgLTI0OSw3ICsyNDksNyBA
QCBzdGF0aWMgaW50IHdmeF90eF9wb2xpY3lfdXBsb2FkKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQ0K
IAlyZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIHZvaWQgd2Z4X3R4X3BvbGljeV91cGxvYWRfd29y
ayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQordm9pZCB3ZnhfdHhfcG9saWN5X3VwbG9hZF93
b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiB7DQogCXN0cnVjdCB3ZnhfdmlmICp3dmlm
ID0NCiAJCWNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3Qgd2Z4X3ZpZiwgdHhfcG9saWN5X3VwbG9h
ZF93b3JrKTsNCkBAIC0yNzAsNyArMjcwLDYgQEAgdm9pZCB3ZnhfdHhfcG9saWN5X2luaXQoc3Ry
dWN0IHdmeF92aWYgKnd2aWYpDQogCXNwaW5fbG9ja19pbml0KCZjYWNoZS0+bG9jayk7DQogCUlO
SVRfTElTVF9IRUFEKCZjYWNoZS0+dXNlZCk7DQogCUlOSVRfTElTVF9IRUFEKCZjYWNoZS0+ZnJl
ZSk7DQotCUlOSVRfV09SSygmd3ZpZi0+dHhfcG9saWN5X3VwbG9hZF93b3JrLCB3ZnhfdHhfcG9s
aWN5X3VwbG9hZF93b3JrKTsNCiANCiAJZm9yIChpID0gMDsgaSA8IEhJRl9NSUJfTlVNX1RYX1JB
VEVfUkVUUllfUE9MSUNJRVM7ICsraSkNCiAJCWxpc3RfYWRkKCZjYWNoZS0+Y2FjaGVbaV0ubGlu
aywgJmNhY2hlLT5mcmVlKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oDQppbmRleCAyOWZhYTU2NDA1MTYu
LmEwZjlhZTY5YmFmNSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5o
DQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaA0KQEAgLTYxLDYgKzYxLDcgQEAg
c3RydWN0IHdmeF90eF9wcml2IHsNCiB9IF9fcGFja2VkOw0KIA0KIHZvaWQgd2Z4X3R4X3BvbGlj
eV9pbml0KHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsNCit2b2lkIHdmeF90eF9wb2xpY3lfdXBsb2Fk
X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsNCiANCiB2b2lkIHdmeF90eChzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV90eF9jb250cm9sICpjb250cm9sLA0K
IAkgICAgc3RydWN0IHNrX2J1ZmYgKnNrYik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCmluZGV4IDI5ODQ4YTIwMmFi
NC4uNDcxZGQxNWIyMjdmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0K
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KQEAgLTU5Miw2ICs1OTIsNyBAQCBzdGF0
aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQ0KIAl3ZnhfdHhfZmx1
c2god3ZpZi0+d2Rldik7DQogCWhpZl9rZWVwX2FsaXZlX3BlcmlvZCh3dmlmLCAwKTsNCiAJaGlm
X3Jlc2V0KHd2aWYsIGZhbHNlKTsNCisJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOw0KIAloaWZf
c2V0X291dHB1dF9wb3dlcih3dmlmLCB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIgKiAxMCk7DQog
CXd2aWYtPmR0aW1fcGVyaW9kID0gMDsNCiAJaGlmX3NldF9tYWNhZGRyKHd2aWYsIHd2aWYtPnZp
Zi0+YWRkcik7DQpAQCAtODgwLDggKzg4MSwxMCBAQCBzdGF0aWMgaW50IHdmeF91cGRhdGVfYmVh
Y29uaW5nKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQ0KIAkJaWYgKHd2aWYtPnN0YXRlICE9IFdGWF9T
VEFURV9BUCB8fA0KIAkJICAgIHd2aWYtPmJlYWNvbl9pbnQgIT0gY29uZi0+YmVhY29uX2ludCkg
ew0KIAkJCXdmeF90eF9sb2NrX2ZsdXNoKHd2aWYtPndkZXYpOw0KLQkJCWlmICh3dmlmLT5zdGF0
ZSAhPSBXRlhfU1RBVEVfUEFTU0lWRSkNCisJCQlpZiAod3ZpZi0+c3RhdGUgIT0gV0ZYX1NUQVRF
X1BBU1NJVkUpIHsNCiAJCQkJaGlmX3Jlc2V0KHd2aWYsIGZhbHNlKTsNCisJCQkJd2Z4X3R4X3Bv
bGljeV9pbml0KHd2aWYpOw0KKwkJCX0NCiAJCQl3dmlmLT5zdGF0ZSA9IFdGWF9TVEFURV9QQVNT
SVZFOw0KIAkJCXdmeF9zdGFydF9hcCh3dmlmKTsNCiAJCQl3ZnhfdHhfdW5sb2NrKHd2aWYtPndk
ZXYpOw0KQEAgLTE1NjcsNiArMTU3MCw3IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3Qg
aWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikNCiAJSU5JVF9XT1JL
KCZ3dmlmLT5zZXRfY3RzX3dvcmssIHdmeF9zZXRfY3RzX3dvcmspOw0KIAlJTklUX1dPUksoJnd2
aWYtPnVuam9pbl93b3JrLCB3ZnhfdW5qb2luX3dvcmspOw0KIA0KKwlJTklUX1dPUksoJnd2aWYt
PnR4X3BvbGljeV91cGxvYWRfd29yaywgd2Z4X3R4X3BvbGljeV91cGxvYWRfd29yayk7DQogCW11
dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7DQogDQogCWhpZl9zZXRfbWFjYWRkcih3dmlm
LCB2aWYtPmFkZHIpOw0KLS0gDQoyLjIwLjENCg==
