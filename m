Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACF03050FE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbhA0Ee4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:34:56 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2879 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbhA0D6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:58:12 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4DQVBb4zSrz57GG;
        Wed, 27 Jan 2021 11:55:51 +0800 (CST)
Received: from dggema773-chm.china.huawei.com (10.1.198.217) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 27 Jan 2021 11:57:23 +0800
Received: from dggeme752-chm.china.huawei.com (10.3.19.98) by
 dggema773-chm.china.huawei.com (10.1.198.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 27 Jan 2021 11:57:22 +0800
Received: from dggeme752-chm.china.huawei.com ([10.6.80.76]) by
 dggeme752-chm.china.huawei.com ([10.6.80.76]) with mapi id 15.01.2106.002;
 Wed, 27 Jan 2021 11:57:22 +0800
From:   liaichun <liaichun@huawei.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net v2]bonding: fix send_peer_notif data truncation
Thread-Topic: [PATCH net v2]bonding: fix send_peer_notif data truncation
Thread-Index: Adb0YIIEwPR58P71S3iyTFzAj5Bokg==
Date:   Wed, 27 Jan 2021 03:57:22 +0000
Message-ID: <eda05faf1e994f1faddb5b07007f0b93@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.112.224]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

c2VuZF9wZWVyX25vdGlmIGlzIHU4LCB0aGUgdmFsdWUgb2YgdGhpcyBwYXJhbWV0ZXIgaXMgb2J0
YWluZWQgZnJvbQ0KIHU4KmludCwgaXQncyBlYXN5IHRvIGJlIHRydW5jYXRlZC4gQW5kIGluIHBy
YWN0aWNlLCBtb3JlIHRoYW4gdTgoMjU2KQ0KICBjaGFyYWN0ZXJzIGFyZSB1c2VkLg0KDQpGaXhl
czogMDdhNGRkZWMzY2U5ICgiYm9uZGluZzogYWRkIGFuIG9wdGlvbiB0byBzcGVjaWZ5IGEgZGVs
YXkgYmV0d2VlbiBwZWVyIG5vdGlmaWNhdGlvbnMiKQ0KU2lnbmVkLW9mZi1ieTogQWljaHVuIExp
IDxsaWFpY2h1bkBodWF3ZWkuY29tPg0KLS0tDQogaW5jbHVkZS9uZXQvYm9uZGluZy5oIHwgMiAr
LQ0KIGRyaXZlcnMvbmV0L2JvbmRpbmcvYm9uZF9tYWluLmMgfCA0ICsrLS0NCiAyIGZpbGUgY2hh
bmdlZCwgMyBpbnNlcnRpb24oKyksIDMgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbmV0L2JvbmRpbmcuaCBiL2luY2x1ZGUvbmV0L2JvbmRpbmcuaCBpbmRleCAwOTYwZDlhZjdi
OGUuLjY1Mzk0NTY2ZDU1NiAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbmV0L2JvbmRpbmcuaA0KKysr
IGIvaW5jbHVkZS9uZXQvYm9uZGluZy5oDQpAQCAtMjE1LDcgKzIxNSw3IEBAIHN0cnVjdCBib25k
aW5nIHsNCiAJICovDQogCXNwaW5sb2NrX3QgbW9kZV9sb2NrOw0KIAlzcGlubG9ja190IHN0YXRz
X2xvY2s7DQotCXU4CSBzZW5kX3BlZXJfbm90aWY7DQorCXUzMgkgc2VuZF9wZWVyX25vdGlmOw0K
IAl1OCAgICAgICBpZ21wX3JldHJhbnM7DQogI2lmZGVmIENPTkZJR19QUk9DX0ZTDQogCXN0cnVj
dCAgIHByb2NfZGlyX2VudHJ5ICpwcm9jX2VudHJ5Ow0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2JvbmRpbmcvYm9uZF9tYWluLmMgYi9kcml2ZXJzL25ldC9ib25kaW5nL2JvbmRfbWFpbi5jIGlu
ZGV4IGI3ZGI1N2U2Yzk2YS4uMzM2NDYwNTM4MTM1IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQv
Ym9uZGluZy9ib25kX21haW4uYw0KKysrIGIvZHJpdmVycy9uZXQvYm9uZGluZy9ib25kX21haW4u
Yw0KQEAgLTg4MCw4ICs4ODAsOCBAQCB2b2lkIGJvbmRfY2hhbmdlX2FjdGl2ZV9zbGF2ZShzdHJ1
Y3QgYm9uZGluZyAqYm9uZCwgc3RydWN0IHNsYXZlICpuZXdfYWN0aXZlKQ0KIA0KIAkJCWlmIChu
ZXRpZl9ydW5uaW5nKGJvbmQtPmRldikpIHsNCiAJCQkJYm9uZC0+c2VuZF9wZWVyX25vdGlmID0N
Ci0JCQkJCWJvbmQtPnBhcmFtcy5udW1fcGVlcl9ub3RpZiAqDQotCQkJCQltYXgoMSwgYm9uZC0+
cGFyYW1zLnBlZXJfbm90aWZfZGVsYXkpOw0KKwkJCQkJKHUzMikoYm9uZC0+cGFyYW1zLm51bV9w
ZWVyX25vdGlmICoNCisJCQkJCW1heCgxLCBib25kLT5wYXJhbXMucGVlcl9ub3RpZl9kZWxheSkp
Ow0KIAkJCQlzaG91bGRfbm90aWZ5X3BlZXJzID0NCiAJCQkJCWJvbmRfc2hvdWxkX25vdGlmeV9w
ZWVycyhib25kKTsNCiAJCQl9DQotLQ0KMi4xOS4xDQoNCg==
