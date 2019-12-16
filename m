Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A16121139
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfLPRJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:09:38 -0500
Received: from mail-dm6nam11on2045.outbound.protection.outlook.com ([40.107.223.45]:6092
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727705AbfLPRGp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OyToRqsvJ0mO1zLNEGJ9YDihHlF/dofJX9mtIXpYaKPPyjSG9/WoS9mRTYlndNE3glPTCL22KB7GaLUx3T2KmifV5mDQAhToOS9DkV18OEcuh+3psnbl3KuxNb34+ep18G/hR17I4R4O1vwbFjuNDKJFliInrdMaDj3cgomfX88DKL62+1poIY6x5tNz1RYLSG23Bm5m4q0hy9mI9aD9w/GrtRzby8IWxCI6TasRe9Hm5kTGhiYSS5O6wtIKqsVGnV9hKk/CKp4beihWGvcRWI71o+zBA6KYg0TeXv1JRY4JPBEBoELra2tE0MAmyNa2XiPqWN3CsFhg7OymOkDPbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOrtuj4VlXMf1xp2QzAouYxSpvBozQBdisreXuMUcD8=;
 b=Hw35Ppm/jm7781j94inryacjcOSO3ltPB1fSYOS5jRzWDR/ihQ7M4Evc3QRmu4XiTE8qWQjsh0u8QmNi7mvUsu771EIqYbItpwsweg3C8BuVsJDT9poEw1HXShrx2HLw68nZv93xK7dn7zt6TXCOv2pbV/G5ffAUQGmsgSyTiY5jI++E0feM88pq90qU2QeJrs4I3HXirRk2r4chyOI+fm/+EFKL/w7mfBtpj60DN+TB8Ffihb6n5Q7ngECXrf4TV7hAi69AxHAGFzbbxJl4uHkrQys0rnXOtHRF8ODuy1wl0HKbdpplEG0ClI/E9ivzKFxjEtE0H6VZbjtcjiCDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOrtuj4VlXMf1xp2QzAouYxSpvBozQBdisreXuMUcD8=;
 b=eSk5GKLZKcjhd+bsaWkeQYpzNBBIbRTDI/xRkIp9y85cyE2BMRe5qsMtE3jFZQ/6KTCqOjJ10mAtedI/3iYQAgE5puaZGkXfFXYkCxNVSJz/MpSjzil0hSZ3jV8m8IMZq+Vq5nyyh+FictM1JfuXnjPBzWrNbu/0FIxhS3B+n9o=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:06:39 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:39 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 34/55] staging: wfx: drop unnecessary wvif->powersave_mode
Thread-Topic: [PATCH 34/55] staging: wfx: drop unnecessary
 wvif->powersave_mode
Thread-Index: AQHVtDLKkqdqwCIbrEugcQVHs4thZg==
Date:   Mon, 16 Dec 2019 17:03:51 +0000
Message-ID: <20191216170302.29543-35-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: a1155479-e9f5-4d2e-a411-08d7824a50c4
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB44452B0E2E5F1D423300377C93510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66574012)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: orpwBmdBcx56h0OlnKXzvtfyWmuC2PsszjWOC2QgqD4Jw2RvSLWIdNyUX0y51bctiYPsU6Lde/MUtv6NMykKaDEmGsELYY20MwxFcTUajtQy293TVC4xfZg94ttdQEeA8vN6VL5ErEIG2Uk1KYh7Yx4gREfIr6CJkjIVEInYlNVMrLxO4RuIQyaRtuNzo425EeriueEsYqr4/kmiaVhGFy2jJeyGzCHMkXUjpLi6+iBnuro8K6LSTeZetyyu0AtsF4Hf/hNWIP/6sBLnqAzoaWCj7iJsiLNT1IfyUcM/WHpTZDg8E67sDtoM1+psAhCZlLOVGwwr0wt6ZXtlNE8/X+m6khDnskVasq6gLTcSz6N6lY1eFtIrZAVcU7Qb4aBl9zEzoVxqO9SE4fm152omBO5zeNoRmAw3e5L2FveORCwwQszEJiQyAzFvpBrFfJkk
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D1ABF81FE8E2D44AD5E81D6D53A0300@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1155479-e9f5-4d2e-a411-08d7824a50c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:51.2609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HV61oqu1AF1SvTJ0FqVSoj1x11s6Gxn4/7OfkUqrDcAhpNNlkK4VAPrML8XuTmEBKKvgeIDdlFBxpEdfVzPB0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpQ
b3dlciBzYXZlIHN0YXR1cyBpcyBhbHJlYWR5IGF2YWlsYWJsZSBpbiBic3NfY29uZi4gU28gdGhl
cmUgaXMgbm8NCnJlYXNvbiB0byBrZWVwIGluZm9ybWF0aW9uIGR1cGxpY2F0ZWQgaW4gd3ZpZi0+
cG93ZXJzYXZlX21vZGUuDQoNCkluIGFkZCwgdHlwZSBvZiB3dmlmLT5wb3dlcnNhdmVfbW9kZSBp
cyBsb3cgbGV2ZWwgc3RydWN0IG1hZGUgdG8NCmNvbW11bmljYXRlIHdpdGggZGV2aWNlLiBXZSB3
b3VsZCBsaWtlIHRvIGxpbWl0IHVzYWdlIG9mIHRoaXMga2luZCBvZg0Kc3RydWN0IGluIHVwcGVy
IGxheWVycyBvZiB0aGUgZHJpdmVyLg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIHwgMzEgKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc3Rh
Z2luZy93Zngvd2Z4LmggfCAgMSAtDQogMiBmaWxlcyBjaGFuZ2VkLCAxMyBpbnNlcnRpb25zKCsp
LCAxOSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQppbmRleCA5MWZhNGQ4YWEzN2QuLmM1NzEz
NWY3NzU3MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCisrKyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCkBAIC0zMjgsMTIgKzMyOCwyMyBAQCB2b2lkIHdmeF9j
b25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KIA0KIHN0YXRpYyBpbnQg
d2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikNCiB7DQotCXN0cnVjdCBoaWZfcmVx
X3NldF9wbV9tb2RlIHBtID0gd3ZpZi0+cG93ZXJzYXZlX21vZGU7DQorCXN0cnVjdCBpZWVlODAy
MTFfY29uZiAqY29uZiA9ICZ3dmlmLT53ZGV2LT5ody0+Y29uZjsNCisJc3RydWN0IGhpZl9yZXFf
c2V0X3BtX21vZGUgcG07DQogCXUxNiB1YXBzZF9mbGFnczsNCiANCiAJaWYgKHd2aWYtPnN0YXRl
ICE9IFdGWF9TVEFURV9TVEEgfHwgIXd2aWYtPmJzc19wYXJhbXMuYWlkKQ0KIAkJcmV0dXJuIDA7
DQogDQorCW1lbXNldCgmcG0sIDAsIHNpemVvZihwbSkpOw0KKwlpZiAoY29uZi0+ZmxhZ3MgJiBJ
RUVFODAyMTFfQ09ORl9QUykgew0KKwkJcG0ucG1fbW9kZS5lbnRlcl9wc20gPSAxOw0KKwkJLy8g
RmlybXdhcmUgZG9lcyBub3Qgc3VwcG9ydCBtb3JlIHRoYW4gMTI4bXMNCisJCXBtLmZhc3RfcHNt
X2lkbGVfcGVyaW9kID0NCisJCQltaW4oY29uZi0+ZHluYW1pY19wc190aW1lb3V0ICogMiwgMjU1
KTsNCisJCWlmIChwbS5mYXN0X3BzbV9pZGxlX3BlcmlvZCkNCisJCQlwbS5wbV9tb2RlLmZhc3Rf
cHNtID0gMTsNCisJfQ0KKw0KIAltZW1jcHkoJnVhcHNkX2ZsYWdzLCAmd3ZpZi0+dWFwc2RfaW5m
bywgc2l6ZW9mKHVhcHNkX2ZsYWdzKSk7DQogDQogCWlmICh1YXBzZF9mbGFncyAhPSAwKQ0KQEAg
LTE0MzIsMjQgKzE0NDMsOCBAQCBpbnQgd2Z4X2NvbmZpZyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgdTMyIGNoYW5nZWQpDQogDQogCWlmIChjaGFuZ2VkICYgSUVFRTgwMjExX0NPTkZfQ0hBTkdF
X1BTKSB7DQogCQl3dmlmID0gTlVMTDsNCi0JCXdoaWxlICgod3ZpZiA9IHd2aWZfaXRlcmF0ZSh3
ZGV2LCB3dmlmKSkgIT0gTlVMTCkgew0KLQkJCW1lbXNldCgmd3ZpZi0+cG93ZXJzYXZlX21vZGUs
IDAsDQotCQkJICAgICAgIHNpemVvZih3dmlmLT5wb3dlcnNhdmVfbW9kZSkpOw0KLQkJCWlmIChj
b25mLT5mbGFncyAmIElFRUU4MDIxMV9DT05GX1BTKSB7DQotCQkJCXd2aWYtPnBvd2Vyc2F2ZV9t
b2RlLnBtX21vZGUuZW50ZXJfcHNtID0gMTsNCi0JCQkJaWYgKGNvbmYtPmR5bmFtaWNfcHNfdGlt
ZW91dCA+IDApIHsNCi0JCQkJCXd2aWYtPnBvd2Vyc2F2ZV9tb2RlLnBtX21vZGUuZmFzdF9wc20g
PSAxOw0KLQkJCQkJLyoNCi0JCQkJCSAqIEZpcm13YXJlIGRvZXMgbm90IHN1cHBvcnQgbW9yZSB0
aGFuDQotCQkJCQkgKiAxMjhtcw0KLQkJCQkJICovDQotCQkJCQl3dmlmLT5wb3dlcnNhdmVfbW9k
ZS5mYXN0X3BzbV9pZGxlX3BlcmlvZCA9DQotCQkJCQkJbWluKGNvbmYtPmR5bmFtaWNfcHNfdGlt
ZW91dCAqDQotCQkJCQkJICAgIDIsIDI1NSk7DQotCQkJCX0NCi0JCQl9DQorCQl3aGlsZSAoKHd2
aWYgPSB3dmlmX2l0ZXJhdGUod2Rldiwgd3ZpZikpICE9IE5VTEwpDQogCQkJd2Z4X3VwZGF0ZV9w
bSh3dmlmKTsNCi0JCX0NCiAJCXd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgMCk7DQogCX0NCiAN
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC93ZnguaA0KaW5kZXggNzgxYThjOGJhOTgyLi5jODJkMjk3NjRkNjYgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dm
eC5oDQpAQCAtMTI1LDcgKzEyNSw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsNCiANCiAJc3RydWN0IHdm
eF9zY2FuCQlzY2FuOw0KIA0KLQlzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSBwb3dlcnNhdmVf
bW9kZTsNCiAJc3RydWN0IGNvbXBsZXRpb24Jc2V0X3BtX21vZGVfY29tcGxldGU7DQogDQogCXN0
cnVjdCBsaXN0X2hlYWQJZXZlbnRfcXVldWU7DQotLSANCjIuMjAuMQ0K
