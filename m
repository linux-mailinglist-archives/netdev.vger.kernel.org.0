Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662015441B0
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 04:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiFICzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 22:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237271AbiFICzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 22:55:48 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A50F1A29F2;
        Wed,  8 Jun 2022 19:55:43 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 2592t2o05008872, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 2592t2o05008872
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 9 Jun 2022 10:55:02 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 9 Jun 2022 10:55:02 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 9 Jun 2022 10:55:01 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Thu, 9 Jun 2022 10:55:01 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 05/10] rtw88: iterate over vif/sta list non-atomically
Thread-Topic: [PATCH v2 05/10] rtw88: iterate over vif/sta list non-atomically
Thread-Index: AQHYdDPOvAC5P6vVz0elhZc8Fv6eZa1F6gcA
Date:   Thu, 9 Jun 2022 02:55:01 +0000
Message-ID: <523bb16608f48852b180121696d31cf82fb55484.camel@realtek.com>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
         <20220530135457.1104091-6-s.hauer@pengutronix.de>
In-Reply-To: <20220530135457.1104091-6-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzYvOCDkuIvljYggMTA6MTk6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <4922BF3DEA0C7049AC1B7D51BF1A184E@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA1LTMwIGF0IDE1OjU0ICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IFRoZSBkcml2ZXIgdXNlcyBpZWVlODAyMTFfaXRlcmF0ZV9hY3RpdmVfaW50ZXJmYWNlc19hdG9t
aWMoKQ0KPiBhbmQgaWVlZTgwMjExX2l0ZXJhdGVfc3RhdGlvbnNfYXRvbWljKCkgaW4gc2V2ZXJh
bCBwbGFjZXMgYW5kIGRvZXMNCj4gcmVnaXN0ZXIgYWNjZXNzZXMgaW4gdGhlIGl0ZXJhdG9ycy4g
VGhpcyBkb2Vzbid0IGNvcGUgd2l0aCB1cGNvbWluZw0KPiBVU0Igc3VwcG9ydCBhcyByZWdpc3Rl
cnMgY2FuIG9ubHkgYmUgYWNjZXNzZWQgbm9uLWF0b21pY2FsbHkuDQo+IA0KPiBTcGxpdCB0aGVz
ZSBpbnRvIGEgdHdvIHN0YWdlIHByb2Nlc3M6IEZpcnN0IHVzZSB0aGUgYXRvbWljIGl0ZXJhdG9y
DQo+IGZ1bmN0aW9ucyB0byBjb2xsZWN0IGFsbCBhY3RpdmUgaW50ZXJmYWNlcyBvciBzdGF0aW9u
cyBvbiBhIGxpc3QsIHRoZW4NCj4gaXRlcmF0ZSBvdmVyIHRoZSBsaXN0IG5vbi1hdG9taWNhbGx5
IGFuZCBjYWxsIHRoZSBpdGVyYXRvciBvbiBlYWNoDQo+IGVudHJ5Lg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiBTdWdnZXN0ZWQt
Ynk6IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KPiAtLS0NCj4gDQo+IE5vdGVzOg0KPiAg
ICAgQ2hhbmdlcyBzaW5jZSB2MToNCj4gICAgIC0gQ2hhbmdlIHN1YmplY3QNCj4gICAgIC0gQWRk
IHNvbWUgbG9ja2RlcF9hc3NlcnRfaGVsZCgmcnR3ZGV2LT5tdXRleCk7DQo+ICAgICAtIG1ha2Ug
bG9jYWxseSB1c2VkIGZ1bmN0aW9ucyBzdGF0aWMNCj4gICAgIC0gQWRkIGNvbW1lbnQgaG93ICZy
dHdkZXYtPm11dGV4IHByb3RlY3RzIHVzIGZyb20gc3RhdGlvbnMvaW50ZXJmYWNlcw0KPiAgICAg
ICBiZWluZyBkZWxldGVkIGJldHdlZW4gY29sbGVjdGluZyB0aGVtIGFuZCBpdGVyYXRpbmcgb3Zl
ciB0aGVtLg0KPiANCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGh5LmMg
IHwgICA2ICstDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BzLmMgICB8
ICAgMiArLQ0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC91dGlsLmMgfCAx
MDMgKysrKysrKysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydHc4OC91dGlsLmggfCAgMTIgKystDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDExNiBpbnNlcnRp
b25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gDQoNClsuLi5dDQoNCj4gKw0KPiArc3RydWN0
IHJ0d192aWZzX2VudHJ5IHsNCj4gKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+ICsJc3RydWN0
IGllZWU4MDIxMV92aWYgKnZpZjsNCj4gKwl1OCBtYWNbRVRIX0FMRU5dOw0KPiArfTsNCj4gKw0K
PiArc3RydWN0IHJ0d19pdGVyX3ZpZnNfZGF0YSB7DQo+ICsJc3RydWN0IHJ0d19kZXYgKnJ0d2Rl
djsNCj4gKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7DQo+ICt9Ow0KPiArDQo+ICt2b2lkIHJ0d19j
b2xsZWN0X3ZpZl9pdGVyKHZvaWQgKmRhdGEsIHU4ICptYWMsIHN0cnVjdCBpZWVlODAyMTFfdmlm
ICp2aWYpDQoNCllvdSBkbyB0aGlzIGNoYW5nZSBpbiBwYXRjaCAicnR3ODg6IEFkZCBjb21tb24g
VVNCIGNoaXAgc3VwcG9ydCIuDQpQbGVhc2UgbW92ZSB0byBoZXJlLg0KDQotdm9pZCBydHdfY29s
bGVjdF92aWZfaXRlcih2b2lkICpkYXRhLCB1OCAqbWFjLCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAq
dmlmKQ0KK3N0YXRpYyB2b2lkIHJ0d19jb2xsZWN0X3ZpZl9pdGVyKHZvaWQgKmRhdGEsIHU4ICpt
YWMsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYpDQoNCj4gK3sNCj4gKwlzdHJ1Y3QgcnR3X2l0
ZXJfdmlmc19kYXRhICppdGVyX3N0YXMgPSBkYXRhOw0KPiArCXN0cnVjdCBydHdfdmlmc19lbnRy
eSAqdmlmc19lbnRyeTsNCj4gKw0KPiArCXZpZnNfZW50cnkgPSBrbWFsbG9jKHNpemVvZigqdmlm
c19lbnRyeSksIEdGUF9BVE9NSUMpOw0KPiArCWlmICghdmlmc19lbnRyeSkNCj4gKwkJcmV0dXJu
Ow0KPiArDQo+ICsJdmlmc19lbnRyeS0+dmlmID0gdmlmOw0KPiArCWV0aGVyX2FkZHJfY29weSh2
aWZzX2VudHJ5LT5tYWMsIG1hYyk7DQo+ICsJbGlzdF9hZGRfdGFpbCgmdmlmc19lbnRyeS0+bGlz
dCwgJml0ZXJfc3Rhcy0+bGlzdCk7DQo+ICt9DQo+ICsNCj4gK3ZvaWQgcnR3X2l0ZXJhdGVfdmlm
cyhzdHJ1Y3QgcnR3X2RldiAqcnR3ZGV2LA0KPiArCQkgICAgICB2b2lkICgqaXRlcmF0b3IpKHZv
aWQgKmRhdGEsIHU4ICptYWMsDQo+ICsJCQkJICAgICAgIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2
aWYpLA0KPiArCQkgICAgICB2b2lkICpkYXRhKQ0KPiArew0KPiArCXN0cnVjdCBydHdfaXRlcl92
aWZzX2RhdGEgaXRlcl9kYXRhOw0KPiArCXN0cnVjdCBydHdfdmlmc19lbnQNCg0KWy4uLl0NCg0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC91dGlsLmgg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3V0aWwuaA0KPiBpbmRleCAwYzIz
YjUwNjliZTBiLi5kYzg5NjU1MjU0MDAyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0dzg4L3V0aWwuaA0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0dzg4L3V0aWwuaA0KPiBAQCAtNyw5ICs3LDYgQEANCj4gIA0KPiAgc3RydWN0IHJ0
d19kZXY7DQo+ICANCj4gLSNkZWZpbmUgcnR3X2l0ZXJhdGVfdmlmcyhydHdkZXYsIGl0ZXJhdG9y
LCBkYXRhKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+IC0JaWVlZTgwMjExX2l0
ZXJhdGVfYWN0aXZlX2ludGVyZmFjZXMocnR3ZGV2LT5odywgICAgICAgICAgICAgICAgICAgICAg
ICBcDQo+IC0JCQlJRUVFODAyMTFfSUZBQ0VfSVRFUl9OT1JNQUwsIGl0ZXJhdG9yLCBkYXRhKQ0K
PiAgI2RlZmluZSBydHdfaXRlcmF0ZV92aWZzX2F0b21pYyhydHdkZXYsIGl0ZXJhdG9yLCBkYXRh
KSAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gIAlpZWVlODAyMTFfaXRlcmF0ZV9hY3RpdmVf
aW50ZXJmYWNlc19hdG9taWMocnR3ZGV2LT5odywgICAgICAgICAgICAgICAgIFwNCj4gIAkJCUlF
RUU4MDIxMV9JRkFDRV9JVEVSX05PUk1BTCwgaXRlcmF0b3IsIGRhdGEpDQoNCkFmdGVyIHJlYWQg
TWFydGluJ3MgcGF0Y2hlcywgSSB0aGluayB3ZSBjYW4gcmV2aWV3IGFsbCBwbGFjZXMgd2hlcmUg
dXNlDQpfYW90bWljIHZlcnNpb24gb2YgdmlmIGFuZCBzdGEsIGV2ZW4gd2UgZG9uJ3QgcmVhbGx5
IG1lZXQgcHJvYmxlbSBmb3Igbm93Lg0KVGhlbiwgdXNlIG5vbi1hdG9taWMgdmVyc2lvbiBpZiBw
b3NzaWJsZS4NCg0KUGluZy1LZQ0KDQoNCg==
