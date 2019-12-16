Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41AF0121154
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfLPRDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:03:46 -0500
Received: from mail-eopbgr750081.outbound.protection.outlook.com ([40.107.75.81]:59109
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbfLPRDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPbcnXTvoGLhFPuW7mD/HP1/JOJ5CTRhU1X/7oYIYb2XZQigjw7DOZH54XQLklo7gep33Dmx27F2w4HsHBbJQ4gxSkpM5zjA50LCgJSX8FtD1vXQ8uQ+eH7ZPixJx2o2PDndHY47OEUxto2xXEc3nxxaKbdOkPn1ubEQ0/gaIRCokrQGKQtvEMWIHpXkFIx4sQOqjBY14RyG0eVibK+aYjSBgSWymm2QU2FMMMBwUwLquLZXI6WoiWIBcZ0bVLU3GXKcHkI3F5V6sKO+ZbCwzgZd9atbluDJPPARuKiF4LJyLTsW7IvmWlaivq5etghj+X6aNPqzEL/Mbkr5TpEluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+FEJwo6BZUafmDUc091MNuDC4vGtWgiYqyT633+fqI=;
 b=mtP4CJcW2gvIdy7G/iviyPhU63aCNwiwQSpkjSUSXEQK9A+u9nUos98eTl8ucnh65rEHB08UDh7cSlFunaIZr0u1m3qF8Mrt8p55safmSFt9/HBZQ9gJPh0fvzygvCWSJ4bj7ti1iIQX2Xf18miyvvT+HhTDo7nSovOY06Ww9IvkwVh7Aqyboq0dlXWp/jE+/cz4GwQhTp8h7p+kuu/l77q0bHcMqoHAvdUuvAVpTg5qNAGBekpIwOEUp6uZc/CpgJWy18qAiXPw3R5dmLWtbhpXf3uqHI7zzqdojZsPdYOZ8G6MDDuLPdKyqjuJf3kAq3IAcOsggrlhENrw7yRSXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+FEJwo6BZUafmDUc091MNuDC4vGtWgiYqyT633+fqI=;
 b=VyEL7GlnnMvqJSzG8mc/hEMnfG9z73Fatg0EoLUM7BMXcpcOhDNFhaJtJhYrmbBTNVyNvtvvaS0J7l0b1mjAvYWLDH1XDbZNgX+C5TrqZum4baxNyvoW6XVB2J1dh3lY1E7mkwq6/uTV6VYDcSsZEvM41XgIeqwkflJaJF28RMc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3838.namprd11.prod.outlook.com (20.178.252.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:34 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:34 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 02/55] staging: wfx: fix case of lack of tx_retry_policies
Thread-Topic: [PATCH 02/55] staging: wfx: fix case of lack of
 tx_retry_policies
Thread-Index: AQHVtDLA7g5vqYmo1ESOFNPko8fBwA==
Date:   Mon, 16 Dec 2019 17:03:34 +0000
Message-ID: <20191216170302.29543-3-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 11892f43-766a-4372-d190-08d78249e2b0
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB383837AD8B4497305F9AFE9993510@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(85202003)(8936002)(81166006)(8676002)(54906003)(110136005)(316002)(85182001)(6506007)(186003)(2906002)(5660300002)(6512007)(26005)(107886003)(81156014)(36756003)(4326008)(2616005)(76116006)(91956017)(64756008)(66556008)(66476007)(66946007)(71200400001)(86362001)(66446008)(6486002)(478600001)(1076003)(66574012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3838;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D+ID1QJoshiP7c+6lpm6BT1yJLeRFzXArN+IXHeSvdLcmUT/4jcko9fHthr+qSAS7DownhlhHybbKZOtZJdJquqB/DltThwkd2tnB++8XQ2UnjeDCqbQHOJCNnf+vl1XyLQtlR8t3/ND1qV+R62vgbjbQbAauxKhiJ+nrGaMeiSZU43gcjMFgV0Y05hwxCLgj6w+btrCbrCjz4/uAO+b5y/BeUfW6P6kw/FTkGU1uxxkUTQfkakdJsjfLar1iEhWmTAwODXnW8bEIHFtd2ANoDuFyIO8J3K27z8cdz+BhHdopYn5eXPIhyETR5y2QrqrKoXRLtODZODVXJv/HUXxCK4K3+r9q4REA+qdrOzykYw+8nnUQfYOy9vlKMTVUlTjCIQlw6U+HJZfgBkc8iFu39BPdeYpfoZdD2tBlU++Gu6KIdLyYkqqJLmZEoRB3/OS
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B3FC5894829254CA871E4F28B918FB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11892f43-766a-4372-d190-08d78249e2b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:34.0928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FYUyYdEDfNaXnh01AGWYH5OBf1VN2dHdXE/ljv2lPuI7rMW70AJuSkTE4JinNIdQxqJdbaKJ9TFX6ww8Fb87zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
biBzb21lIHJhcmUgY2FzZXMsIGRyaXZlciBtYXkgbm90IGhhdmUgYW55IGF2YWlsYWJsZSB0eF9y
ZXRyeV9wb2xpY2llcy4NCkluIHRoaXMgY2FzZSwgdGhlIGRyaXZlciBhc2tzIHRvIG1hYzgwMjEx
IHRvIHN0b3Agc2VuZGluZyBkYXRhLiBIb3dldmVyLA0KaXQgc2VlbXMgdGhhdCBhIHJhY2UgaXMg
cG9zc2libGUgYW5kIGEgZmV3IGZyYW1lcyBjYW4gYmUgc2VudCB0byB0aGUNCmRyaXZlci4gSW4g
dGhpcyBjYXNlLCBkcml2ZXIgY2FuJ3Qgd2FpdCBmb3IgZnJlZSB0eF9yZXRyeV9wb2xpY2llcyBz
aW5jZQ0Kd2Z4X3R4KCkgbXVzdCBiZSBhdG9taWMuIFNvLCB0aGlzIHBhdGNoIGZpeCB0aGlzIGNh
c2UgYnkgc2VuZGluZyB0aGVzZQ0KZnJhbWVzIHdpdGggdGhlIHNwZWNpYWwgcG9saWN5IG51bWJl
ciAxNS4NCg0KVGhlIGZpcm13YXJlIG5vcm1hbGx5IHVzZSBwb2xpY3kgMTUgdG8gc2VuZCBpbnRl
cm5hbCBmcmFtZXMgKFBTLXBvbGwsDQpiZWFjb25zLCBldGMuLi4pLiBTbywgaXQgaXMgbm90IGEg
c28gYmFkIGZhbGxiYWNrLg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguYyB8IDcgKysrKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDIgZGVs
ZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jDQppbmRleCAwMmYwMDFkYWI2MmIuLmRmM2Fj
YTAzYjUwYiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jDQorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYw0KQEAgLTE2LDcgKzE2LDcgQEANCiAjaW5j
bHVkZSAidHJhY2VzLmgiDQogI2luY2x1ZGUgImhpZl90eF9taWIuaCINCiANCi0jZGVmaW5lIFdG
WF9JTlZBTElEX1JBVEVfSUQgKDB4RkYpDQorI2RlZmluZSBXRlhfSU5WQUxJRF9SQVRFX0lEICAg
IDE1DQogI2RlZmluZSBXRlhfTElOS19JRF9OT19BU1NPQyAgIDE1DQogI2RlZmluZSBXRlhfTElO
S19JRF9HQ19USU1FT1VUICgodW5zaWduZWQgbG9uZykoMTAgKiBIWikpDQogDQpAQCAtMjAyLDYg
KzIwMiw4IEBAIHN0YXRpYyB2b2lkIHdmeF90eF9wb2xpY3lfcHV0KHN0cnVjdCB3ZnhfdmlmICp3
dmlmLCBpbnQgaWR4KQ0KIAlpbnQgdXNhZ2UsIGxvY2tlZDsNCiAJc3RydWN0IHR4X3BvbGljeV9j
YWNoZSAqY2FjaGUgPSAmd3ZpZi0+dHhfcG9saWN5X2NhY2hlOw0KIA0KKwlpZiAoaWR4ID09IFdG
WF9JTlZBTElEX1JBVEVfSUQpDQorCQlyZXR1cm47DQogCXNwaW5fbG9ja19iaCgmY2FjaGUtPmxv
Y2spOw0KIAlsb2NrZWQgPSBsaXN0X2VtcHR5KCZjYWNoZS0+ZnJlZSk7DQogCXVzYWdlID0gd2Z4
X3R4X3BvbGljeV9yZWxlYXNlKGNhY2hlLCAmY2FjaGUtPmNhY2hlW2lkeF0pOw0KQEAgLTU0OSw3
ICs1NTEsOCBAQCBzdGF0aWMgdTggd2Z4X3R4X2dldF9yYXRlX2lkKHN0cnVjdCB3ZnhfdmlmICp3
dmlmLA0KIA0KIAlyYXRlX2lkID0gd2Z4X3R4X3BvbGljeV9nZXQod3ZpZiwNCiAJCQkJICAgIHR4
X2luZm8tPmRyaXZlcl9yYXRlcywgJnR4X3BvbGljeV9yZW5ldyk7DQotCVdBUk4ocmF0ZV9pZCA9
PSBXRlhfSU5WQUxJRF9SQVRFX0lELCAidW5hYmxlIHRvIGdldCBhIHZhbGlkIFR4IHBvbGljeSIp
Ow0KKwlpZiAocmF0ZV9pZCA9PSBXRlhfSU5WQUxJRF9SQVRFX0lEKQ0KKwkJZGV2X3dhcm4od3Zp
Zi0+d2Rldi0+ZGV2LCAidW5hYmxlIHRvIGdldCBhIHZhbGlkIFR4IHBvbGljeSIpOw0KIA0KIAlp
ZiAodHhfcG9saWN5X3JlbmV3KSB7DQogCQkvKiBGSVhNRTogSXQncyBub3Qgc28gb3B0aW1hbCB0
byBzdG9wIFRYIHF1ZXVlcyBldmVyeSBub3cgYW5kDQotLSANCjIuMjAuMQ0K
