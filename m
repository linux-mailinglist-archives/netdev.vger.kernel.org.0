Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF86B52E4AD
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345714AbiETGGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345704AbiETGGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:06:44 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2669A2E9E0;
        Thu, 19 May 2022 23:06:40 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 24K666Mq8004182, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 24K666Mq8004182
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 14:06:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 14:06:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 20 May 2022 14:06:05 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Fri, 20 May 2022 14:06:05 +0800
From:   Pkshih <pkshih@realtek.com>
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
Subject: Re: [PATCH 05/10] rtw88: Do not access registers while atomic
Thread-Topic: [PATCH 05/10] rtw88: Do not access registers while atomic
Thread-Index: AQHYapDak3Q7f2qnxkShGFFqb9ia8a0mxBmA
Date:   Fri, 20 May 2022 06:06:05 +0000
Message-ID: <e33aaa2ab60e04d3449273e117ca73acb3895ed3.camel@realtek.com>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
         <20220518082318.3898514-6-s.hauer@pengutronix.de>
In-Reply-To: <20220518082318.3898514-6-s.hauer@pengutronix.de>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.17.21]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzUvMjAg5LiK5Y2IIDAyOjU5OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2511D85AF58FC4BAF2AD10B96859F90@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
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

T24gV2VkLCAyMDIyLTA1LTE4IGF0IDEwOjIzICswMjAwLCBTYXNjaGEgSGF1ZXIgd3JvdGU6DQo+
IFRoZSBkcml2ZXIgdXNlcyBpZWVlODAyMTFfaXRlcmF0ZV9hY3RpdmVfaW50ZXJmYWNlc19hdG9t
aWMoKQ0KPiBhbmQgaWVlZTgwMjExX2l0ZXJhdGVfc3RhdGlvbnNfYXRvbWljKCkgaW4gc2V2ZXJh
bCBwbGFjZXMgYW5kIGRvZXMNCj4gcmVnaXN0ZXIgYWNjZXNzZXMgaW4gdGhlIGl0ZXJhdG9ycy4g
VGhpcyBkb2Vzbid0IGNvcGUgd2l0aCB1cGNvbWluZw0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIF5eXl5eXl4gZG9lcz8NCj4gVVNCIHN1cHBvcnQgYXMgcmVnaXN0
ZXJzIGNhbiBvbmx5IGJlIGFjY2Vzc2VkIG5vbi1hdG9taWNhbGx5Lg0KPiANCj4gU3BsaXQgdGhl
c2UgaW50byBhIHR3byBzdGFnZSBwcm9jZXNzOiBGaXJzdCB1c2UgdGhlIGF0b21pYyBpdGVyYXRv
cg0KPiBmdW5jdGlvbnMgdG8gY29sbGVjdCBhbGwgYWN0aXZlIGludGVyZmFjZXMgb3Igc3RhdGlv
bnMgb24gYSBsaXN0LCB0aGVuDQo+IGl0ZXJhdGUgb3ZlciB0aGUgbGlzdCBub24tYXRvbWljYWxs
eSBhbmQgY2FsbCB0aGUgaXRlcmF0b3Igb24gZWFjaA0KPiBlbnRyeS4NCg0KSSB0aGluayB0aGUg
c3ViamVjdCBjb3VsZCBiZSAiaXRlcmF0ZSBvdmVyIHZpZi9zdGEgbGlzdCBub24tYXRvbWljYWxs
eSINCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJv
bml4LmRlPg0KPiBTdWdnZXN0ZWQtYnk6IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGh5LmMgIHwgIDYgKy0N
Cj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcHMuYyAgIHwgIDIgKy0NCj4g
IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvdXRpbC5jIHwgOTIgKysrKysrKysr
KysrKysrKysrKysrKysNCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvdXRp
bC5oIHwgMTIgKystDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDEwNSBpbnNlcnRpb25zKCspLCA3IGRl
bGV0aW9ucygtKQ0KPiANCj4gDQoNClsuLi5dDQoNCj4gIA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC91dGlsLmMgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9yZWFsdGVrL3J0dzg4L3V0aWwuYw0KPiBpbmRleCAyYzUxNWFmMjE0ZTc2Li5kYjU1ZGJkNWM1
MzNlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3V0
aWwuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3V0aWwuYw0K
PiBAQCAtMTA1LDMgKzEwNSw5NSBAQCB2b2lkIHJ0d19kZXNjX3RvX21jc3JhdGUodTE2IHJhdGUs
IHU4ICptY3MsIHU4ICpuc3MpDQo+ICAJCSptY3MgPSByYXRlIC0gREVTQ19SQVRFTUNTMDsNCj4g
IAl9DQo+ICB9DQo+IA0KDQpbLi4uXQ0KDQo+ICsNCj4gK3ZvaWQgcnR3X2l0ZXJhdGVfc3Rhcyhz
dHJ1Y3QgcnR3X2RldiAqcnR3ZGV2LA0KPiArCQkgICAgICB2b2lkICgqaXRlcmF0b3IpKHZvaWQg
KmRhdGEsDQo+ICsJCQkJICAgICAgIHN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEpLA0KPiArCQkJ
CSAgICAgICB2b2lkICpkYXRhKQ0KPiArew0KPiArCXN0cnVjdCBydHdfaXRlcl9zdGFzX2RhdGEg
aXRlcl9kYXRhOw0KPiArCXN0cnVjdCBydHdfc3Rhc19lbnRyeSAqc3RhX2VudHJ5LCAqdG1wOw0K
DQpsb2NrZGVwX2Fzc2VydF9oZWxkKCZydHdkZXYtPm11dGV4KTsNCg0KPiArDQo+ICsJaXRlcl9k
YXRhLnJ0d2RldiA9IHJ0d2RldjsNCj4gKwlJTklUX0xJU1RfSEVBRCgmaXRlcl9kYXRhLmxpc3Qp
Ow0KPiArDQo+ICsJaWVlZTgwMjExX2l0ZXJhdGVfc3RhdGlvbnNfYXRvbWljKHJ0d2Rldi0+aHcs
IHJ0d19jb2xsZWN0X3N0YV9pdGVyLA0KPiArCQkJCQkgICZpdGVyX2RhdGEpOw0KPiArDQo+ICsJ
bGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKHN0YV9lbnRyeSwgdG1wLCAmaXRlcl9kYXRhLmxpc3Qs
DQo+ICsJCQkJIGxpc3QpIHsNCj4gKwkJbGlzdF9kZWxfaW5pdCgmc3RhX2VudHJ5LT5saXN0KTsN
Cj4gKwkJaXRlcmF0b3IoZGF0YSwgc3RhX2VudHJ5LT5zdGEpOw0KPiArCQlrZnJlZShzdGFfZW50
cnkpOw0KPiArCX0NCj4gK30NCj4gKw0KDQpbLi4uXQ0KDQo+ICt2b2lkIHJ0d19pdGVyYXRlX3Zp
ZnMoc3RydWN0IHJ0d19kZXYgKnJ0d2RldiwNCj4gKwkJICAgICAgdm9pZCAoKml0ZXJhdG9yKSh2
b2lkICpkYXRhLCB1OCAqbWFjLA0KPiArCQkJCSAgICAgICBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAq
dmlmKSwNCj4gKwkJICAgICAgdm9pZCAqZGF0YSkNCj4gK3sNCj4gKwlzdHJ1Y3QgcnR3X2l0ZXJf
dmlmc19kYXRhIGl0ZXJfZGF0YTsNCj4gKwlzdHJ1Y3QgcnR3X3ZpZnNfZW50cnkgKnZpZl9lbnRy
eSwgKnRtcDsNCg0KbG9ja2RlcF9hc3NlcnRfaGVsZCgmcnR3ZGV2LT5tdXRleCk7DQoNCj4gKw0K
PiArCWl0ZXJfZGF0YS5ydHdkZXYgPSBydHdkZXY7DQo+ICsJSU5JVF9MSVNUX0hFQUQoJml0ZXJf
ZGF0YS5saXN0KTsNCj4gKw0KPiArCWllZWU4MDIxMV9pdGVyYXRlX2FjdGl2ZV9pbnRlcmZhY2Vz
X2F0b21pYyhydHdkZXYtPmh3LA0KPiArCQkJSUVFRTgwMjExX0lGQUNFX0lURVJfTk9STUFMLCBy
dHdfY29sbGVjdF92aWZfaXRlciwgJml0ZXJfZGF0YSk7DQo+ICsNCj4gKwlsaXN0X2Zvcl9lYWNo
X2VudHJ5X3NhZmUodmlmX2VudHJ5LCB0bXAsICZpdGVyX2RhdGEubGlzdCwNCj4gKwkJCQkgbGlz
dCkgew0KPiArCQlsaXN0X2RlbF9pbml0KCZ2aWZfZW50cnktPmxpc3QpOw0KPiArCQlpdGVyYXRv
cihkYXRhLCB2aWZfZW50cnktPm1hYywgdmlmX2VudHJ5LT52aWYpOw0KPiArCQlrZnJlZSh2aWZf
ZW50cnkpOw0KPiArCX0NCj4gK30NCj4gDQoNClsuLi5dDQoNCi0tDQpQaW5nLUtlDQoNCg0K
