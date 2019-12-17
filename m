Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE301231C9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbfLQQR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:17:29 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:6496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728425AbfLQQQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bE5boxovvErH0ODBlXrQaWRdw8CyfMR+fzVTx6WoGyvSlEh3jrJwnr4rWE26VzKfwFhZk2egVR5oItTa7kiSD66UpiTbOWvPk8AE8JPtcWJGUBtNDX2yLkowHZQHkaJB8tPWY+pfD8TUcqaBOgyIsUK9E7+pVkDY68XTr8r5TeHX4A6Znb7wl+6cshJjYstwoYzYyu8zmSpuVQIDq7/fkJeq2dQep/6L3P1Sg3ZfLRkuv7u6mGchbfouqTOWsULMb8FL5DVBGlahYwaosoyTQMayqkxMunYqbEDAcoMMRbu2O/ecZclL9uAp4kOXTiZGV6V0LvrORbkk8uEl58cAoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVrtL/C7YQ08Pb+7fFb5TFrEB10EjfSCEs5gRYHh874=;
 b=G0WmCX3wE8+pa2/9f9syNjBYwbMpR3GDmkC41LD0jDNPDQb27SGw5WhsQuxTGWY0wsS9W/K26jV18bIad9kzaWep25925XK6619vraqS3dxbyooF2JaE98WIMGwpn/yWNLkFLOvSVIi3SgGKr27q+wpIh51V81p3iI84pdmL12lmw5uJo4gDHBOSpbQqChBlJlfB8m4W7BZcU3Q4GELqiJr+fWzwiuqY/hpEe3HECnQHXquHTcuT8cI/Y1zeYYqOj2G7fSKMPnZj9BX9GQGzBieqWrg/d6VS/rZfkg4ulxLtIDuZJl2bP2yZ1ApjqPxFu8XJy1s5hdsGuerHByoyvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVrtL/C7YQ08Pb+7fFb5TFrEB10EjfSCEs5gRYHh874=;
 b=OESGwvMH4PKRlqLA/+SMtSbrNohc6nawg0+6UYnIiqAZ07rTztX2xnkVhMXQ1SKQKW/ilWxhxUBbuklifUvGbE/Pr4AE8FF2eNAXxlaaXR2yVBKFeytTY+hS7U2m/LNYycTxdRPAGABKywuBwW+jGG9LhZSRFnpdXqV31Mf7t60=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:46 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 42/55] staging: wfx: remove unnecessary EDCA initialisation
Thread-Topic: [PATCH v2 42/55] staging: wfx: remove unnecessary EDCA
 initialisation
Thread-Index: AQHVtPUwofWyj1n0J0CKAfv5Wa1qQg==
Date:   Tue, 17 Dec 2019 16:15:25 +0000
Message-ID: <20191217161318.31402-43-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 894078dc-2f2f-4b01-41df-08d7830c533d
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208E66173132C712787E86093500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0fCiDJgmx5zzbEnBnq2Kvyj8ExDn9Oa1DRk38KLe1uBENizebxcnsm8OhMlV1TFIcb+FqOac/9KffFrsQArNc0drz6tS5Mgpl5FTRH7e22uhA9I1McI+N9nUcX/ToMbm64K269m7X9zsJheO5BHAOrtclrcHA+Zc1Erj5haHHzmMmrlQuDTo1Dx1kK5jYGmSIt2BJW105TR7J+/euri9U2hHm4A3q6oaSeRZ93xzyZoLenm9gfvUsa07yDpQP8knnAwTh4yvNUvPZwpPvBQjcWxOl3yx4jqE8JtxaF89ZUAEmSHGKarOeCQjub7CO8Sv4Xyw4NU5Az3n9bwaGABL5uS6aVa99EE2v3sL8HI527PilNxO+vzazvBxIXrzl1eYxpwPhJqDUcZjwFNJY0Wha/CFFAou3fxpWR6Ui+NHdNsOhkra5C2StzIWj9eUsKhf
Content-Type: text/plain; charset="utf-8"
Content-ID: <3543C5DE4DCAD14E889C8E83B82B40CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894078dc-2f2f-4b01-41df-08d7830c533d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:25.7892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p5Ul3sNca4OBBGhl8L/QWzPIcIkisU+Vr5NaSPVHDtiLfiF5yxDErA07MKOcWgJTpxCCfIGuDkeIxhemWrACJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKbWFj
ODAyMTEgYWxyZWFkeSBjYWxsIHdmeF9jb25mX3R4KCkgb24gZXZlcnkgVklGIGluc3RhbmNpYXRp
b24uIFNvLCB0aGUKZHJpdmVyIGRvZXMgbm90IG5lZWQgdG8gZG8gaXQuCgpOb3RlIHRoYXQgY3Vy
cmVudCBjb2RlIGRpZCBkaXJ0eSB0aGluZ3Mgd2l0aCB3dmlmLT5lZGNhX3BhcmFtcy4gVGhpcwpz
dHJ1Y3Qgd2FzIGluaXRpYWxpemVkLCBidXQgb25seSAncXVldWVfaWQnIHdhcyByZWFsbHkgdXNl
ZC4gVGhlIG90aGVyCm1lbWJlcnMgYXJlIG9ubHkgdXNlZCB0byBzdG9yZSB0ZW1wb3JhcnkgdmFs
dWVzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCA1MSArKysrKy0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDQ1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IGQ1MmY2MTgwNjJhNi4uMzUw
NGI2YjM1MTVlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTMzNCw2ICszMzQsMTIgQEAgaW50IHdmeF9jb25m
X3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAog
CWVkY2EtPmN3X21heCA9IHBhcmFtcy0+Y3dfbWF4OwogCWVkY2EtPnR4X29wX2xpbWl0ID0gcGFy
YW1zLT50eG9wICogVFhPUF9VTklUOwogCWVkY2EtPmFsbG93ZWRfbWVkaXVtX3RpbWUgPSAwOwor
CWVkY2EtPnF1ZXVlX2lkID0gMyAtIHF1ZXVlOworCS8vIEFQSSAyLjAgaGFzIGNoYW5nZWQgcXVl
dWUgSURzIHZhbHVlcworCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4od2RldiwgMiwgMCkgJiYgcXVl
dWUgPT0gSUVFRTgwMjExX0FDX0JFKQorCQllZGNhLT5xdWV1ZV9pZCA9IEhJRl9RVUVVRV9JRF9C
QUNLR1JPVU5EOworCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4od2RldiwgMiwgMCkgJiYgcXVldWUg
PT0gSUVFRTgwMjExX0FDX0JLKQorCQllZGNhLT5xdWV1ZV9pZCA9IEhJRl9RVUVVRV9JRF9CRVNU
RUZGT1JUOwogCWhpZl9zZXRfZWRjYV9xdWV1ZV9wYXJhbXMod3ZpZiwgZWRjYSk7CiAKIAlpZiAo
d3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pIHsKQEAgLTEzOTMsNDQg
KzEzOTksNiBAQCBpbnQgd2Z4X2FkZF9pbnRlcmZhY2Uoc3RydWN0IGllZWU4MDIxMV9odyAqaHcs
IHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpCiAJaW50IGk7CiAJc3RydWN0IHdmeF9kZXYgKndk
ZXYgPSBody0+cHJpdjsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAq
KSB2aWYtPmRydl9wcml2OwotCS8vIEZJWE1FOiBwYXJhbWV0ZXJzIGFyZSBzZXQgYnkga2VybmVs
IGp1c3RlIGFmdGVyIGludGVyZmFjZV9hZGQuCi0JLy8gS2VlcCBzdHJ1Y3QgaGlmX3JlcV9lZGNh
X3F1ZXVlX3BhcmFtcyBibGFuaz8KLQlzdHJ1Y3QgaGlmX3JlcV9lZGNhX3F1ZXVlX3BhcmFtcyBk
ZWZhdWx0X2VkY2FfcGFyYW1zW10gPSB7Ci0JCVtJRUVFODAyMTFfQUNfVk9dID0gewotCQkJLnF1
ZXVlX2lkID0gSElGX1FVRVVFX0lEX1ZPSUNFLAotCQkJLmFpZnNuID0gMiwKLQkJCS5jd19taW4g
PSAzLAotCQkJLmN3X21heCA9IDcsCi0JCQkudHhfb3BfbGltaXQgPSBUWE9QX1VOSVQgKiA0NywK
LQkJfSwKLQkJW0lFRUU4MDIxMV9BQ19WSV0gPSB7Ci0JCQkucXVldWVfaWQgPSBISUZfUVVFVUVf
SURfVklERU8sCi0JCQkuYWlmc24gPSAyLAotCQkJLmN3X21pbiA9IDcsCi0JCQkuY3dfbWF4ID0g
MTUsCi0JCQkudHhfb3BfbGltaXQgPSBUWE9QX1VOSVQgKiA5NCwKLQkJfSwKLQkJW0lFRUU4MDIx
MV9BQ19CRV0gPSB7Ci0JCQkucXVldWVfaWQgPSBISUZfUVVFVUVfSURfQkVTVEVGRk9SVCwKLQkJ
CS5haWZzbiA9IDMsCi0JCQkuY3dfbWluID0gMTUsCi0JCQkuY3dfbWF4ID0gMTAyMywKLQkJCS50
eF9vcF9saW1pdCA9IFRYT1BfVU5JVCAqIDAsCi0JCX0sCi0JCVtJRUVFODAyMTFfQUNfQktdID0g
ewotCQkJLnF1ZXVlX2lkID0gSElGX1FVRVVFX0lEX0JBQ0tHUk9VTkQsCi0JCQkuYWlmc24gPSA3
LAotCQkJLmN3X21pbiA9IDE1LAotCQkJLmN3X21heCA9IDEwMjMsCi0JCQkudHhfb3BfbGltaXQg
PSBUWE9QX1VOSVQgKiAwLAotCQl9LAotCX07Ci0KLQlCVUlMRF9CVUdfT04oQVJSQVlfU0laRShk
ZWZhdWx0X2VkY2FfcGFyYW1zKSAhPSBBUlJBWV9TSVpFKHd2aWYtPmVkY2FfcGFyYW1zKSk7Ci0J
aWYgKHdmeF9hcGlfb2xkZXJfdGhhbih3ZGV2LCAyLCAwKSkgewotCQlkZWZhdWx0X2VkY2FfcGFy
YW1zW0lFRUU4MDIxMV9BQ19CRV0ucXVldWVfaWQgPSBISUZfUVVFVUVfSURfQkFDS0dST1VORDsK
LQkJZGVmYXVsdF9lZGNhX3BhcmFtc1tJRUVFODAyMTFfQUNfQktdLnF1ZXVlX2lkID0gSElGX1FV
RVVFX0lEX0JFU1RFRkZPUlQ7Ci0JfQogCiAJdmlmLT5kcml2ZXJfZmxhZ3MgfD0gSUVFRTgwMjEx
X1ZJRl9CRUFDT05fRklMVEVSIHwKIAkJCSAgICAgSUVFRTgwMjExX1ZJRl9TVVBQT1JUU19VQVBT
RCB8CkBAIC0xNTAxLDEzICsxNDY5LDYgQEAgaW50IHdmeF9hZGRfaW50ZXJmYWNlKHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCW11dGV4X3VubG9j
aygmd2Rldi0+Y29uZl9tdXRleCk7CiAKIAloaWZfc2V0X21hY2FkZHIod3ZpZiwgdmlmLT5hZGRy
KTsKLQlmb3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX05VTV9BQ1M7IGkrKykgewotCQltZW1jcHko
Jnd2aWYtPmVkY2FfcGFyYW1zW2ldLCAmZGVmYXVsdF9lZGNhX3BhcmFtc1tpXSwKLQkJICAgICAg
IHNpemVvZihkZWZhdWx0X2VkY2FfcGFyYW1zW2ldKSk7Ci0JCWhpZl9zZXRfZWRjYV9xdWV1ZV9w
YXJhbXMod3ZpZiwgJnd2aWYtPmVkY2FfcGFyYW1zW2ldKTsKLQl9Ci0Jd3ZpZi0+dWFwc2RfbWFz
ayA9IDA7Ci0JaGlmX3NldF91YXBzZF9pbmZvKHd2aWYsIHd2aWYtPnVhcHNkX21hc2spOwogCiAJ
d2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOwogCXd2aWYgPSBOVUxMOwotLSAKMi4yNC4wCgo=
