Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B533666BF
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhDUIIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:08:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3406 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbhDUIIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 04:08:41 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FQClN1VDKz5rk5;
        Wed, 21 Apr 2021 16:05:04 +0800 (CST)
Received: from dggpeml100021.china.huawei.com (7.185.36.148) by
 DGGEML401-HUB.china.huawei.com (10.3.17.32) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 21 Apr 2021 16:08:04 +0800
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 dggpeml100021.china.huawei.com (7.185.36.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 16:08:03 +0800
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.2176.012;
 Wed, 21 Apr 2021 09:08:00 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH V2 net] ice: Re-organizes reqstd/avail
 {R, T}XQ check/code for efficiency+readability
Thread-Topic: [Intel-wired-lan] [PATCH V2 net] ice: Re-organizes reqstd/avail
 {R, T}XQ check/code for efficiency+readability
Thread-Index: AQHXNnA44ik22M7HZEWiZd3JF/ZDoKq+hESggAAFGoCAABKToA==
Date:   Wed, 21 Apr 2021 08:08:00 +0000
Message-ID: <fdd2432301e541baa82ec56427d40cca@huawei.com>
References: <20210413224446.16612-1-salil.mehta@huawei.com>
 <7974e665-73bd-401c-f023-9da568e1dffc@molgen.mpg.de>
 <418702bdb5244eb4811a2a1a536c55c0@huawei.com>
 <9335975a-ef19-863c-005a-d460eac83e03@molgen.mpg.de>
In-Reply-To: <9335975a-ef19-863c-005a-d460eac83e03@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.66.69]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBQYXVsIE1lbnplbCBbbWFpbHRvOnBtZW56ZWxAbW9sZ2VuLm1wZy5kZV0NCj4gU2Vu
dDogV2VkbmVzZGF5LCBBcHJpbCAyMSwgMjAyMSA4OjU0IEFNDQo+IA0KPiBbQ0M6IFJlbW92ZSBK
ZWZmLCBhcyBlbWFpbCBpcyByZWplY3RlZF0NCg0KWWVzLCB0aGFua3MgZm9yIHRoZSByZW1pbmRl
ci4gSSBoYWQgbm90aWNlZCBpdCBlYXJsaWVyLg0KDQpbLi4uXQ0KDQo+ID4+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9saWIuYw0KPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfbGliLmMNCj4gPj4+IGluZGV4IGQxM2M3ZmM4ZmIw
YS4uZDc3MTMzZDZiYWE3IDEwMDY0NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV9saWIuYw0KPiA+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaWNlL2ljZV9saWIuYw0KPiA+Pj4gQEAgLTE2MSwxMiArMTYxLDEzIEBAIHN0YXRpYyB2b2lk
IGljZV92c2lfc2V0X251bV9xcyhzdHJ1Y3QgaWNlX3ZzaSAqdnNpLA0KPiB1MTYgdmZfaWQpDQo+
ID4+Pg0KPiA+Pj4gICAgCXN3aXRjaCAodnNpLT50eXBlKSB7DQo+ID4+PiAgICAJY2FzZSBJQ0Vf
VlNJX1BGOg0KPiA+Pj4gLQkJdnNpLT5hbGxvY190eHEgPSBtaW4zKHBmLT5udW1fbGFuX21zaXgs
DQo+ID4+PiAtCQkJCSAgICAgIGljZV9nZXRfYXZhaWxfdHhxX2NvdW50KHBmKSwNCj4gPj4+IC0J
CQkJICAgICAgKHUxNiludW1fb25saW5lX2NwdXMoKSk7DQo+ID4+PiAgICAJCWlmICh2c2ktPnJl
cV90eHEpIHsNCj4gPj4+ICAgIAkJCXZzaS0+YWxsb2NfdHhxID0gdnNpLT5yZXFfdHhxOw0KPiA+
Pj4gICAgCQkJdnNpLT5udW1fdHhxID0gdnNpLT5yZXFfdHhxOw0KPiA+Pj4gKwkJfSBlbHNlIHsN
Cj4gPj4+ICsJCQl2c2ktPmFsbG9jX3R4cSA9IG1pbjMocGYtPm51bV9sYW5fbXNpeCwNCj4gPj4+
ICsJCQkJCSAgICAgIGljZV9nZXRfYXZhaWxfdHhxX2NvdW50KHBmKSwNCj4gPj4+ICsJCQkJCSAg
ICAgICh1MTYpbnVtX29ubGluZV9jcHVzKCkpOw0KPiA+Pj4gICAgCQl9DQo+ID4+DQo+ID4+IEkg
YW0gY3VyaW91cywgZGlkIHlvdSBjaGVjayB0aGUgY29tcGlsZXIgYWN0dWFsbHkgY3JlYXRlcyBk
aWZmZXJlbnQNCj4gPj4gY29kZSwgb3IgZGlkIGl0IG5vdGljZSB0aGUgaW5lZmZpY2llbmN5IGJ5
IGl0c2VsZiBhbmQgb3B0aW1pemVkIGl0IGFscmVhZHk/DQo+ID4NCj4gPiBJIGhhdmUgbm90IGxv
b2tlZCBpbnRvIHRoYXQgZGV0YWlsIGJ1dCBpcnJlc3BlY3RpdmUgb2Ygd2hhdCBjb21waWxlciBn
ZW5lcmF0ZXMNCj4gPiBJIHdvdWxkIGxpa2UgdG8ga2VlcCB0aGUgY29kZSBpbiBhIHNoYXBlIHdo
aWNoIGlzIG1vcmUgZWZmaWNpZW50IGFuZCBtb3JlIHJlYWRhYmxlLg0KPiA+DQo+ID4gSSBkbyB1
bmRlcnN0YW5kIGluIGNlcnRhaW4gY2FzZXMgd2UgaGF2ZSB0byBkbyB0cmFkZW9mZiBiZXR3ZWVu
IGVmZmljaWVuY3kNCj4gPiBhbmQgcmVhZGFiaWxpdHkgYnV0IEkgZG8gbm90IHNlZSB0aGF0IGhl
cmUuDQo+IA0KPiBJIGFncmVlLCBhcyAqZWZmaWNpZW5jeSogaXMgbWVudGlvbmVkIHNldmVyYWwg
dGltZXMsIEkgYXNzdW1lIGl0IHdhcw0KPiB0ZXN0ZWQuIFRoYW5rIHlvdSBmb3IgdGhlIGNsYXJp
ZmljYXRpb24uDQoNCg0KSSBtZW50aW9uZWQgaW5lZmZpY2llbnQgYmVjYXVzZSBiZWxvdyBjb2Rl
IGdldHMgZXhlY3V0ZWQgdW5uZWNlc3NhcmlseS4NCg0KDQovKioNCiAqIGljZV9nZXRfYXZhaWxf
cV9jb3VudCAtIEdldCBjb3VudCBvZiBxdWV1ZXMgaW4gdXNlDQogKiBAcGZfcW1hcDogYml0bWFw
IHRvIGdldCBxdWV1ZSB1c2UgY291bnQgZnJvbQ0KICogQGxvY2s6IHBvaW50ZXIgdG8gYSBtdXRl
eCB0aGF0IHByb3RlY3RzIGFjY2VzcyB0byBwZl9xbWFwDQogKiBAc2l6ZTogc2l6ZSBvZiB0aGUg
Yml0bWFwDQogKi8NCnN0YXRpYyB1MTYNCmljZV9nZXRfYXZhaWxfcV9jb3VudCh1bnNpZ25lZCBs
b25nICpwZl9xbWFwLCBzdHJ1Y3QgbXV0ZXggKmxvY2ssIHUxNiBzaXplKQ0Kew0KCXVuc2lnbmVk
IGxvbmcgYml0Ow0KCXUxNiBjb3VudCA9IDA7DQoNCgltdXRleF9sb2NrKGxvY2spOw0KCWZvcl9l
YWNoX2NsZWFyX2JpdChiaXQsIHBmX3FtYXAsIHNpemUpDQoJCWNvdW50Kys7DQoJbXV0ZXhfdW5s
b2NrKGxvY2spOw0KDQoJcmV0dXJuIGNvdW50Ow0KfQ0KDQovKioNCiAqIGljZV9nZXRfYXZhaWxf
dHhxX2NvdW50IC0gR2V0IGNvdW50IG9mIFR4IHF1ZXVlcyBpbiB1c2UNCiAqIEBwZjogcG9pbnRl
ciB0byBhbiBpY2VfcGYgaW5zdGFuY2UNCiAqLw0KdTE2IGljZV9nZXRfYXZhaWxfdHhxX2NvdW50
KHN0cnVjdCBpY2VfcGYgKnBmKQ0Kew0KCXJldHVybiBpY2VfZ2V0X2F2YWlsX3FfY291bnQocGYt
PmF2YWlsX3R4cXMsICZwZi0+YXZhaWxfcV9tdXRleCwNCgkJCQkgICAgIHBmLT5tYXhfcGZfdHhx
cyk7DQp9DQoNCg0KDQo+ID4+PiAgICAJCXBmLT5udW1fbGFuX3R4ID0gdnNpLT5hbGxvY190eHE7
DQo+ID4+PiBAQCAtMTc1LDEyICsxNzYsMTMgQEAgc3RhdGljIHZvaWQgaWNlX3ZzaV9zZXRfbnVt
X3FzKHN0cnVjdCBpY2VfdnNpICp2c2ksDQo+IHUxNiB2Zl9pZCkNCj4gPj4+ICAgIAkJaWYgKCF0
ZXN0X2JpdChJQ0VfRkxBR19SU1NfRU5BLCBwZi0+ZmxhZ3MpKSB7DQo+ID4+PiAgICAJCQl2c2kt
PmFsbG9jX3J4cSA9IDE7DQo+ID4+PiAgICAJCX0gZWxzZSB7DQo+ID4+PiAtCQkJdnNpLT5hbGxv
Y19yeHEgPSBtaW4zKHBmLT5udW1fbGFuX21zaXgsDQo+ID4+PiAtCQkJCQkgICAgICBpY2VfZ2V0
X2F2YWlsX3J4cV9jb3VudChwZiksDQo+ID4+PiAtCQkJCQkgICAgICAodTE2KW51bV9vbmxpbmVf
Y3B1cygpKTsNCj4gPj4+ICAgIAkJCWlmICh2c2ktPnJlcV9yeHEpIHsNCj4gPj4+ICAgIAkJCQl2
c2ktPmFsbG9jX3J4cSA9IHZzaS0+cmVxX3J4cTsNCj4gPj4+ICAgIAkJCQl2c2ktPm51bV9yeHEg
PSB2c2ktPnJlcV9yeHE7DQo+ID4+PiArCQkJfSBlbHNlIHsNCj4gPj4+ICsJCQkJdnNpLT5hbGxv
Y19yeHEgPSBtaW4zKHBmLT5udW1fbGFuX21zaXgsDQo+ID4+PiArCQkJCQkJICAgICAgaWNlX2dl
dF9hdmFpbF9yeHFfY291bnQocGYpLA0KPiA+Pj4gKwkJCQkJCSAgICAgICh1MTYpbnVtX29ubGlu
ZV9jcHVzKCkpOw0KPiA+Pj4gICAgCQkJfQ0KPiA+Pj4gICAgCQl9DQo+ID4+Pg0KPiANCj4gDQo+
IEtpbmQgcmVnYXJkcywNCj4gDQo+IFBhdWwNCg==
