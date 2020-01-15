Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8204913C472
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgAON7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:59:20 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729868AbgAONz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ih1IgTyT0/O475IdayHjRNktQzI9JyaYD+lGw9NDwFRFDTikgQ0DNXq+kk0wgbD4y/7ctWS9U3SE57e7JOzpt/Z4cUCMam19z55WXz+OB5gOz6DLW14DNHTIHRh3E39junX10mtPQ/tYmP4T/vjSk0NWNnU7qU5qSd0BbHZR7a3T8E2pdTSiBAR26LppLWkboT1jBuoMrmmaL6rwJqc1xpXfRkoIa3N3cddxWlWWLiwFfY7diDQYRQamRUwr7rcAb4uTAvNnhFNdo5LlkLdapzuMwxOobAqoanK/nsEekjLnETY3yoKnVdgRcDKal4A6ThUadfDuKNQh4FVPuPgp6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyYErm/+SiSh/FDrosP5g9wl3yLmrIQ5MCjg3/oJYyg=;
 b=VfritAOs5wKrGsmlbqLX4eJM+qVMaT12CFutE9Fbt6b8ZdQq8G4tx6aJIpOb5htKOsL7B43XRooTJFhVAmT0IoAmRchG7ytzXlYUoUNKD/eO5TUHdkfcXKyGNW1fDYngOyX7Fv76gf/Z1V/U45VS+UWKym0kswfTljolFg0Mpkb3k51G0VxsmomPG4c/cx3+ZZloWoulYsrAEVM7GJqaeczpuQVOmxHHPYukFzW3Z/BOPHZcFhMAM/kXhQ2AdZmlcnaRTzNYBTC6Avb+Ow66P7qzIEHApVn0VLUXjM3EyxP/xU7rzFCxgTi/H7pMVnwsErIwaOirBKq7YGxVUNNM/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyYErm/+SiSh/FDrosP5g9wl3yLmrIQ5MCjg3/oJYyg=;
 b=nrunZyVNyJ8dFzkI3xFmpSpEqZ2HV1mPAXyk0mClzH6/gGOBbg6KoqbISA6cpVQpUNupMYpwYfonHoraYLsJoAD9WNWO6dOv3xjIvZe55iOnlt7Se5LSlfZD7euI+kPMpoU7Vfar0ybb38H+4toiqpDMH7l+SU3kS1JCm/CWvjg=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:19 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:19 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:54 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 36/65] staging: wfx: simplify hif_set_config_data_filter()
Thread-Topic: [PATCH v2 36/65] staging: wfx: simplify
 hif_set_config_data_filter()
Thread-Index: AQHVy6tehSEg3AJzZ0SBCNafabycoA==
Date:   Wed, 15 Jan 2020 13:54:55 +0000
Message-ID: <20200115135338.14374-37-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44851cbe-7b71-4b9c-5955-08d799c2806f
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661D3E994B89674189ECF8993370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +BMOIHE7cd2bKAwG13MbK+eBHAaiyE9P7xCSxe9wv0Hkm+kKV+urpSD7+GnMimgM1xGIZcmr15o/JFlcyGNuNDbYKemjrSyaxTEj4frMH2KvOe32OhT/z6EoGJ6ZKx7jqvi/RnMYJC5VeZtUQzN6DidAPcZ4CtqUrT4A0j4CiibZH0ilNNvCdzyhzbftM+XDdTkoixqQnVZEFYfIJmaK5r1gZiLhJI7X9x9rwMXQyxFuviAy1UXHFgIRk6ZALmOsfdpyRv2KJ7fvyWczCkg80F956k1MOCXF8Q6/uYQzAYxIdJWQXOc5Yk1Efn8zZkvtwgkB1UCWsbcVy01cJBJ/o3vt4ExpwAIPXSic0ZTYdIIOtiLvw+/QwSGlBIGCZd78a3S2uF9NbZrOCct28n2DIGu58JEHlhl34OLvxBSG/VGRtQajXnnFV4E9QEodrNb0
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD9291345A1C8741B673BEB28C609001@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44851cbe-7b71-4b9c-5955-08d799c2806f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:55.5499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pmMFnzxOi5enFLsNiwqdJwdmf6yK6Rvlrs2dIwiMC5A3cpiDfoUWF1tNz9M/JmY26nI3StCvN1QpgufyM+euQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX2NvbmZpZ19kYXRhX2ZpbHRlciBjb21lIGZyb20gaGFyZHdhcmUK
QVBJLiBJdCBpcyBub3QgaW50ZW5kZWQgdG8gYmUgbWFuaXB1bGF0ZWQgaW4gdXBwZXIgbGF5ZXJz
IG9mIHRoZSBkcml2ZXIuCgpJbiBhZGQsIGN1cnJlbnQgY29kZSBmb3IgaGlmX3NldF9jb25maWdf
ZGF0YV9maWx0ZXIoKSBpcyB0b28gZHVtYi4gSXQKc2hvdWxkIHBhY2sgZGF0YSB3aXRoIGhhcmR3
YXJlIHJlcHJlc2VudGF0aW9uIGluc3RlYWQgb2YgbGVhdmluZyBhbGwKd29yayB0byB0aGUgY2Fs
bGVyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIHwgMTQgKysr
KysrKysrKystLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAgIHwgIDggKystLS0t
LS0KIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4X21pYi5oCmluZGV4IDkwNDc0YjFjNWVjMy4uY2NlYTNmMTVhMzRkIDEw
MDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMjY1LDExICsyNjUsMTkgQEAgc3RhdGljIGlu
bGluZSBpbnQgaGlmX3NldF91Y19tY19iY19jb25kaXRpb24oc3RydWN0IHdmeF92aWYgKnd2aWYs
CiAJCQkgICAgICZ2YWwsIHNpemVvZih2YWwpKTsKIH0KIAotc3RhdGljIGlubGluZSBpbnQgaGlm
X3NldF9jb25maWdfZGF0YV9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCQkJCSAgICAg
c3RydWN0IGhpZl9taWJfY29uZmlnX2RhdGFfZmlsdGVyICphcmcpCitzdGF0aWMgaW5saW5lIGlu
dCBoaWZfc2V0X2NvbmZpZ19kYXRhX2ZpbHRlcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBl
bmFibGUsCisJCQkJCSAgICAgaW50IGlkeCwgaW50IG1hY19maWx0ZXJzLAorCQkJCQkgICAgIGlu
dCBmcmFtZXNfdHlwZXNfZmlsdGVycykKIHsKKwlzdHJ1Y3QgaGlmX21pYl9jb25maWdfZGF0YV9m
aWx0ZXIgdmFsID0geworCQkuZW5hYmxlID0gZW5hYmxlLAorCQkuZmlsdGVyX2lkeCA9IGlkeCwK
KwkJLm1hY19jb25kID0gbWFjX2ZpbHRlcnMsCisJCS51Y19tY19iY19jb25kID0gZnJhbWVzX3R5
cGVzX2ZpbHRlcnMsCisJfTsKKwogCXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYsIHd2
aWYtPmlkLAotCQkJICAgICBISUZfTUlCX0lEX0NPTkZJR19EQVRBX0ZJTFRFUiwgYXJnLCBzaXpl
b2YoKmFyZykpOworCQkJICAgICBISUZfTUlCX0lEX0NPTkZJR19EQVRBX0ZJTFRFUiwgJnZhbCwg
c2l6ZW9mKHZhbCkpOwogfQogCiBzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X2RhdGFfZmlsdGVy
aW5nKHN0cnVjdCB3ZnhfdmlmICp3dmlmLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggYjc0ZTBjZTQxMDY5Li5l
NzFiOTlhYTFmNjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMTE3LDcgKzExNyw2IEBAIHN0YXRpYyBpbnQg
d2Z4X3NldF9tY2FzdF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkJICAgIHN0cnVj
dCB3ZnhfZ3JwX2FkZHJfdGFibGUgKmZwKQogewogCWludCBpLCByZXQ7Ci0Jc3RydWN0IGhpZl9t
aWJfY29uZmlnX2RhdGFfZmlsdGVyIGNvbmZpZyA9IHsgfTsKIAogCS8vIFRlbXBvcmFyeSB3b3Jr
YXJvdW5kIGZvciBmaWx0ZXJzCiAJcmV0dXJuIGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwg
ZmFsc2UsIHRydWUpOwpAQCAtMTI5LDcgKzEyOCw2IEBAIHN0YXRpYyBpbnQgd2Z4X3NldF9tY2Fz
dF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCXJldCA9IGhpZl9zZXRfbWFjX2FkZHJf
Y29uZGl0aW9uKHd2aWYsIGksIGZwLT5hZGRyZXNzX2xpc3RbaV0pOwogCQlpZiAocmV0KQogCQkJ
cmV0dXJuIHJldDsKLQkJY29uZmlnLm1hY19jb25kIHw9IDEgPDwgaTsKIAl9CiAKIAlyZXQgPSBo
aWZfc2V0X3VjX21jX2JjX2NvbmRpdGlvbih3dmlmLCAwLCBISUZfRklMVEVSX1VOSUNBU1QgfApA
QCAtMTM3LDEwICsxMzUsOCBAQCBzdGF0aWMgaW50IHdmeF9zZXRfbWNhc3RfZmlsdGVyKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLAogCWlmIChyZXQpCiAJCXJldHVybiByZXQ7CiAKLQljb25maWcudWNf
bWNfYmNfY29uZCA9IDE7Ci0JY29uZmlnLmZpbHRlcl9pZHggPSAwOyAvLyBUT0RPICNkZWZpbmUg
TVVMVElDQVNUX0ZJTFRFUklORyAwCi0JY29uZmlnLmVuYWJsZSA9IDE7Ci0JcmV0ID0gaGlmX3Nl
dF9jb25maWdfZGF0YV9maWx0ZXIod3ZpZiwgJmNvbmZpZyk7CisJcmV0ID0gaGlmX3NldF9jb25m
aWdfZGF0YV9maWx0ZXIod3ZpZiwgdHJ1ZSwgMCwgQklUKDEpLAorCQkJCQkgQklUKGZwLT5udW1f
YWRkcmVzc2VzKSAtIDEpOwogCWlmIChyZXQpCiAJCXJldHVybiByZXQ7CiAKLS0gCjIuMjUuMAoK
