Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5376B13C448
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgAON5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:57:49 -0500
Received: from mail-eopbgr770047.outbound.protection.outlook.com ([40.107.77.47]:48566
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730039AbgAONzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jd4BL53IB/41n0OkIJFsSLto9tEHdvx16sDti6aYS2x3HRYMPF1XL7l6JVEWtWoSS5KDX9Xr2E/uoQF4xDUSgBP3zgVRQi7OzgfrPTZnjE7m33u/R3+1ZPgBgdZF3R4x9E1OyG0copx7zkrKRjf4toklHtc4R4laJzSq7wK6WZTq4SMn+fLMTejeHwpD3h7xvUVX6xQyxZAxRfnWpm8fQwJDXsu2Sb5GJm11JZmGq/DBKmvvkOmBQEJ8xpMQVit5uM1D0zLAjiGxxlvqYx4BOJ3TBEpeQBqHbRC+gzxqVS199b6wQhbe12i03yUEkstjczR4Dr4oDYKdKsELXgeByg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZcasPrMA/8ilPvnsOg/0o+UwLhMEXVcTojckwzEtT8=;
 b=YL9w/lGjCW8wWy/7cRwfzdgCv3N4SrqYtHsqLkwEtI3WC3uP1T+ESwzThXHSUIDAYmdR2kfvtZcI9+Y6k/hKUSHfSWc618I/Iw7YqXPt7Oog8vJVefSp95nGDuUUE7k/+zXPIJU6D+TCx2SKui1zexnygsATcH08E4phnntAWNOzuO/miT7STBXD/71DgjTXb/XRUYicRDN0RASAr9Xb/xQ2NfJIdl38FMFpGCTqOtRWkFu/4o1dCYhVxwdTn+no1e73EwCet8KVvEsIFkcDSzKlt/p6fG/rls+dIVH2BLhm0t3RwnKpfj6t+N0hj5PPWosH5fwJD3Rqfq8fOrMuxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZcasPrMA/8ilPvnsOg/0o+UwLhMEXVcTojckwzEtT8=;
 b=mjn7Hj0eWkUdHhqsEBrt5w1YfNYlsk84wRjsM/lhNwE84CyK38ftbGixssGAtuLj59NcgFZEbtYwqrLjwkQ8JrKJJTPSpjtEKAm6+n5rbMmRVuwS2Fk8Cu46KMFpE3wxGUYF32e1iY2OJFYDhrCKaefnxvpoM8Vge7r2LuBZp4Y=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:31 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:31 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:23 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 56/65] staging: wfx: simplify wfx_suspend_resume_mc()
Thread-Topic: [PATCH v2 56/65] staging: wfx: simplify wfx_suspend_resume_mc()
Thread-Index: AQHVy6tvqRNbeQHxKEKWIiwJJT8fkw==
Date:   Wed, 15 Jan 2020 13:55:24 +0000
Message-ID: <20200115135338.14374-57-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 509924ea-1e52-43c8-11bc-08d799c2918c
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661EDEF135EF981019A1A0893370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWOonB8r7otVKsHmuU7tPD8f1U1MwAICJsciSd8o6Xt44TTD+v9Qt40PsaU3PTKWVIsbuQiPwOi7F1+JByRmZDCHb8/luTmW0d9gc/aXj0vm2sxarH+gt6mlXe3L0Si6bAQNt2GpWQhTtGA8A/qxZMTdFqSB3hBfAQ7bgVuBHNwG6rYdHwmL5maCxmqPvtDQ1qUDrNnb+4brcmkcJXWzHUvwrL/lfCo94kIEZGACnIlRrxkMVyffg9CQXkjp0tl4rHHHWpFRuFcO+JdVrWvwBFKx+McD8KrfMvHpVdbEiV835Sj05mXbqq2Gp0xR82Brv4oJWOlD7UwwwhxwsrpcqVLA2WNilSXRWxB9FyCvgotVN8S9ChfU6PCBU6UMFPJifZyP5wiQKzO+t4cvmCuKgGHVkCufhWv9DbcJWh/HqhQLV6HqYa0uZtxrQtyj0x8J
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEA0BD7C4D5FF242970080FBB27ED782@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509924ea-1e52-43c8-11bc-08d799c2918c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:24.2694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7cCkiOOc01pzVOvNu5MxPG0f67nSpGJW1ZolngTknhz9YC2k+Qwwq7/qHMPi0HGLc2dUUhEt5OsU9NVnRNmdNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW5k
ZWVkLCBpdCBpcyBub3QgbmVjZXNzYXJ5IHRvIHBhc3Mgd2hvbGUgaGlmX2luZF9zdXNwZW5kX3Jl
c3VtZV90eCB0bwp3Znhfc3VzcGVuZF9yZXN1bWVfbWMoKS4KCkluIGFkZCwgdGhlIHN0cnVjdHVy
ZSBoaWZfaW5kX3N1c3BlbmRfcmVzdW1lX3R4IGNvbWUgZnJvbSBoYXJkd2FyZSBBUEkuCkl0IGlz
IG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXllcnMgb2YgdGhlIGRy
aXZlci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8ICA3ICstLS0t
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgIHwgIDYgKysrKystCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jICAgICB8IDEwICsrLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmggICAgIHwgIDMgKy0tCiA0IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMTcg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCA3OTE0YzA2NTc4YWEuLjg3MTAz
ODNmNjZlNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTYwMCwxMyArNjAwLDggQEAgdm9pZCB3
ZnhfdHhfY29uZmlybV9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGhpZl9j
bmZfdHggKmFyZykKIAkJCXR4X2luZm8tPmZsYWdzIHw9IElFRUU4MDIxMV9UWF9TVEFUX0FDSzsK
IAl9IGVsc2UgaWYgKGFyZy0+c3RhdHVzID09IEhJRl9SRVFVRVVFKSB7CiAJCS8qICJSRVFVRVVF
IiBtZWFucyAiaW1wbGljaXQgc3VzcGVuZCIgKi8KLQkJc3RydWN0IGhpZl9pbmRfc3VzcGVuZF9y
ZXN1bWVfdHggc3VzcGVuZCA9IHsKLQkJCS5zdXNwZW5kX3Jlc3VtZV9mbGFncy5yZXN1bWUgPSAw
LAotCQkJLnN1c3BlbmRfcmVzdW1lX2ZsYWdzLmJjX21jX29ubHkgPSAxLAotCQl9OwotCiAJCVdB
Uk4oIWFyZy0+dHhfcmVzdWx0X2ZsYWdzLnJlcXVldWUsICJpbmNvaGVyZW50IHN0YXR1cyBhbmQg
cmVzdWx0X2ZsYWdzIik7Ci0JCXdmeF9zdXNwZW5kX3Jlc3VtZSh3dmlmLCAmc3VzcGVuZCk7CisJ
CXdmeF9zdXNwZW5kX3Jlc3VtZV9tYyh3dmlmLCBTVEFfTk9USUZZX1NMRUVQKTsKIAkJdHhfaW5m
by0+ZmxhZ3MgfD0gSUVFRTgwMjExX1RYX1NUQVRfVFhfRklMVEVSRUQ7CiAJfSBlbHNlIHsKIAkJ
aWYgKHd2aWYtPmJzc19sb3NzX3N0YXRlICYmCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwppbmRleCBmMDRhZmM2
ZGI5YTUuLmY3OThjZDY5NzNiNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCkBAIC0yMzAsNyArMjMwLDEx
IEBAIHN0YXRpYyBpbnQgaGlmX3N1c3BlbmRfcmVzdW1lX2luZGljYXRpb24oc3RydWN0IHdmeF9k
ZXYgKndkZXYsCiAJY29uc3Qgc3RydWN0IGhpZl9pbmRfc3VzcGVuZF9yZXN1bWVfdHggKmJvZHkg
PSBidWY7CiAKIAlXQVJOX09OKCF3dmlmKTsKLQl3Znhfc3VzcGVuZF9yZXN1bWUod3ZpZiwgYm9k
eSk7CisJV0FSTighYm9keS0+c3VzcGVuZF9yZXN1bWVfZmxhZ3MuYmNfbWNfb25seSwgInVuc3Vw
cG9ydGVkIHN1c3BlbmQvcmVzdW1lIG5vdGlmaWNhdGlvbiIpOworCWlmIChib2R5LT5zdXNwZW5k
X3Jlc3VtZV9mbGFncy5yZXN1bWUpCisJCXdmeF9zdXNwZW5kX3Jlc3VtZV9tYyh3dmlmLCBTVEFf
Tk9USUZZX0FXQUtFKTsKKwllbHNlCisJCXdmeF9zdXNwZW5kX3Jlc3VtZV9tYyh3dmlmLCBTVEFf
Tk9USUZZX1NMRUVQKTsKIAogCXJldHVybiAwOwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggN2M5ZTkzZjUy
OTkzLi5iZGMxNTU1NDk1OGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtOTg1LDE4ICs5ODUsMTIgQEAgaW50
IHdmeF9hbXBkdV9hY3Rpb24oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJcmV0dXJuIC1FTk9U
U1VQUDsKIH0KIAotdm9pZCB3Znhfc3VzcGVuZF9yZXN1bWUoc3RydWN0IHdmeF92aWYgKnd2aWYs
Ci0JCQljb25zdCBzdHJ1Y3QgaGlmX2luZF9zdXNwZW5kX3Jlc3VtZV90eCAqYXJnKQordm9pZCB3
Znhfc3VzcGVuZF9yZXN1bWVfbWMoc3RydWN0IHdmeF92aWYgKnd2aWYsIGVudW0gc3RhX25vdGlm
eV9jbWQgbm90aWZ5X2NtZCkKIHsKIAlib29sIGNhbmNlbF90bW8gPSBmYWxzZTsKIAotCWlmICgh
YXJnLT5zdXNwZW5kX3Jlc3VtZV9mbGFncy5iY19tY19vbmx5KSB7Ci0JCWRldl93YXJuKHd2aWYt
PndkZXYtPmRldiwgInVuc3VwcG9ydGVkIHN1c3BlbmQvcmVzdW1lIG5vdGlmaWNhdGlvblxuIik7
Ci0JCXJldHVybjsKLQl9Ci0KIAlzcGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xvY2spOwot
CWlmICghYXJnLT5zdXNwZW5kX3Jlc3VtZV9mbGFncy5yZXN1bWUpCisJaWYgKG5vdGlmeV9jbWQg
PT0gU1RBX05PVElGWV9TTEVFUCkKIAkJd3ZpZi0+bWNhc3RfdHggPSBmYWxzZTsKIAllbHNlCiAJ
CXd2aWYtPm1jYXN0X3R4ID0gd3ZpZi0+YWlkMF9iaXRfc2V0ICYmCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAppbmRleCBl
ODMyNDA1ZDYwNGUuLmNmOTlhOGE3NGE4MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCkBAIC04Miw4ICs4Miw3IEBA
IHZvaWQgd2Z4X3VuYXNzaWduX3ZpZl9jaGFuY3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAog
CQkJICAgICAgc3RydWN0IGllZWU4MDIxMV9jaGFuY3R4X2NvbmYgKmNvbmYpOwogCiAvLyBXU00g
Q2FsbGJhY2tzCi12b2lkIHdmeF9zdXNwZW5kX3Jlc3VtZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwK
LQkJCWNvbnN0IHN0cnVjdCBoaWZfaW5kX3N1c3BlbmRfcmVzdW1lX3R4ICphcmcpOwordm9pZCB3
Znhfc3VzcGVuZF9yZXN1bWVfbWMoc3RydWN0IHdmeF92aWYgKnd2aWYsIGVudW0gc3RhX25vdGlm
eV9jbWQgY21kKTsKIAogLy8gT3RoZXIgSGVscGVycwogdm9pZCB3ZnhfY3FtX2Jzc2xvc3Nfc20o
c3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBpbml0LCBpbnQgZ29vZCwgaW50IGJhZCk7Ci0tIAoy
LjI1LjAKCg==
