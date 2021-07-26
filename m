Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6C63D5438
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 09:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhGZGmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 02:42:37 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50639 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhGZGmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 02:42:35 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16Q7MrAyA012249, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16Q7MrAyA012249
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 15:22:53 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 15:22:52 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 15:22:52 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 26 Jul 2021 15:22:52 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH RFC v1 3/7] rtw88: Use rtw_iterate_stas where the iterator reads or writes registers
Thread-Topic: [PATCH RFC v1 3/7] rtw88: Use rtw_iterate_stas where the
 iterator reads or writes registers
Thread-Index: AQHXe0w27utvvM4sPUiWb+/Kz/RL76tJU/0AgAptqICAASD5kA==
Date:   Mon, 26 Jul 2021 07:22:52 +0000
Message-ID: <981001e2981346ada4dcc08558b87a18@realtek.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-4-martin.blumenstingl@googlemail.com>
 <27d8246ef3c9755b3e6e908188ca36f7b0fab3fc.camel@sipsolutions.net>
 <CAFBinCAzoPmtvH1Wn9dY4pFsERQ5N+0xXRG=UB1eEGe_qTf+6w@mail.gmail.com>
In-Reply-To: <CAFBinCAzoPmtvH1Wn9dY4pFsERQ5N+0xXRG=UB1eEGe_qTf+6w@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMjYg5LiK5Y2IIDA2OjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 07:01:19
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165231 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 07:04:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcnRpbiBCbHVtZW5zdGlu
Z2wgW21haWx0bzptYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tXQ0KPiBTZW50OiBN
b25kYXksIEp1bHkgMjYsIDIwMjEgNTo1MSBBTQ0KPiBUbzogSm9oYW5uZXMgQmVyZzsgUGtzaGlo
DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IHRvbnkwNjIwZW1tYUBnbWFp
bC5jb207IGt2YWxvQGNvZGVhdXJvcmEub3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBOZW8gSm91OyBKZXJuZWogU2tyYWJlYw0KPiBT
dWJqZWN0OiBSZTogW1BBVENIIFJGQyB2MSAzLzddIHJ0dzg4OiBVc2UgcnR3X2l0ZXJhdGVfc3Rh
cyB3aGVyZSB0aGUgaXRlcmF0b3IgcmVhZHMgb3Igd3JpdGVzIHJlZ2lzdGVycw0KPiANCj4gSGkg
Sm9oYW5uZXMsIEhpIFBpbmctS2UsDQo+IA0KPiBPbiBNb24sIEp1bCAxOSwgMjAyMSBhdCA4OjM2
IEFNIEpvaGFubmVzIEJlcmcgPGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ+IHdyb3RlOg0KPiA+
DQo+ID4gT24gU2F0LCAyMDIxLTA3LTE3IGF0IDIyOjQwICswMjAwLCBNYXJ0aW4gQmx1bWVuc3Rp
bmdsIHdyb3RlOg0KPiA+ID4NCj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0
ZWsvcnR3ODgvbWFjODAyMTEuYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OC9tYWM4MDIxMS5jDQo+ID4gPiBAQCAtNzIxLDcgKzcyMSw3IEBAIHN0YXRpYyB2
b2lkIHJ0d19yYV9tYXNrX2luZm9fdXBkYXRlKHN0cnVjdCBydHdfZGV2ICpydHdkZXYsDQo+ID4g
PiAgICAgICBicl9kYXRhLnJ0d2RldiA9IHJ0d2RldjsNCj4gPiA+ICAgICAgIGJyX2RhdGEudmlm
ID0gdmlmOw0KPiA+ID4gICAgICAgYnJfZGF0YS5tYXNrID0gbWFzazsNCj4gPiA+IC0gICAgIHJ0
d19pdGVyYXRlX3N0YXNfYXRvbWljKHJ0d2RldiwgcnR3X3JhX21hc2tfaW5mb191cGRhdGVfaXRl
ciwgJmJyX2RhdGEpOw0KPiA+ID4gKyAgICAgcnR3X2l0ZXJhdGVfc3RhcyhydHdkZXYsIHJ0d19y
YV9tYXNrX2luZm9fdXBkYXRlX2l0ZXIsICZicl9kYXRhKTsNCj4gPg0KPiA+IEFuZCB0aGVuIHlv
dSBwcmV0dHkgbXVjaCBpbW1lZGlhdGVseSBicmVhayB0aGF0IGludmFyaWFudCBoZXJlLCBuYW1l
bHkNCj4gPiB0aGF0IHlvdSdyZSBjYWxsaW5nIHRoaXMgd2l0aGluIHRoZSBzZXRfYml0cmF0ZV9t
YXNrKCkgbWV0aG9kIGNhbGxlZCBieQ0KPiA+IG1hYzgwMjExLg0KPiB5b3UgYXJlIHJpZ2h0LCBJ
IHdhcyBub3QgYXdhcmUgb2YgdGhpcw0KPiANCj4gPiBUaGF0J3Mgbm90IGFjdHVhbGx5IGZ1bmRh
bWVudGFsbHkgYnJva2VuIHRvZGF5LCBidXQgaXQgZG9lcyAqc2V2ZXJlbHkqDQo+ID4gcmVzdHJp
Y3Qgd2hhdCB3ZSBjYW4gZG8gaW4gbWFjODAyMTEgd3J0LiBsb2NraW5nLCBhbmQgSSByZWFsbHkg
ZG9uJ3QNCj4gPiB3YW50IHRvIGtlZXAgdGhlIGRvemVuIG9yIHNvIGxvY2tzIGZvcmV2ZXIsIHRo
aXMgbmVlZHMgc2ltcGxpZmljYXRpb24NCj4gPiBiZWNhdXNlIGNsZWFybHkgd2UgZG9uJ3QgZXZl
biBrbm93IHdoYXQgc2hvdWxkIGJlIHVuZGVyIHdoYXQgbG9jay4NCj4gVG8gbWUgaXQncyBhbHNv
IG5vdCBjbGVhciB3aGF0IHRoZSBnb2FsIG9mIHRoZSB3aG9sZSBsb2NraW5nIGlzLg0KPiBUaGUg
bG9jayBpbiBpZWVlODAyMTFfaXRlcmF0ZV9zdGF0aW9uc19hdG9taWMgaXMgb2J2aW91c2x5IGZv
ciB0aGUNCj4gbWFjODAyMTEtaW50ZXJuYWwgc3RhdGUtbWFjaGluZQ0KPiBCdXQgSSAqYmVsaWV2
ZSogdGhhdCB0aGVyZSdzIGEgc2Vjb25kIHB1cnBvc2UgKHJ0dzg4IHNwZWNpZmljKSAtDQo+IGhl
cmUncyBteSB1bmRlcnN0YW5kaW5nIG9mIHRoYXQgcGFydDoNCj4gLSBydHdfc3RhX2luZm8gY29u
dGFpbnMgYSAibWFjX2lkIiB3aGljaCBpcyBhbiBpZGVudGlmaWVyIGZvciBhDQo+IHNwZWNpZmlj
IHN0YXRpb24gdXNlZCBieSB0aGUgcnR3ODggZHJpdmVyIGFuZCBpcyBzaGFyZWQgd2l0aCB0aGUN
Cj4gZmlybXdhcmUNCj4gLSBydHdfb3BzX3N0YV97YWRkLHJlbW92ZX0gdXNlcyBydHdkZXYtPm11
dGV4IHRvIHByb3RlY3QgdGhlIHJ0dzg4DQo+IHNpZGUgb2YgdGhpcyAibWFjX2lkIiBpZGVudGlm
aWVyDQo+IC0gKGZvciBzb21lIHJlYXNvbiBydHdfdXBkYXRlX3N0YV9pbmZvIGRvZXNuJ3QgdXNl
IHJ0d2Rldi0+bXV0ZXgpDQoNCkkgYW0gdGhpbmtpbmcgcnR3ODggbmVlZHMgdG8gbWFpbnRhaW4g
c3RhIGFuZCB2aWYgbGlzdHMgaXRzZWxmLCBhbmQNCnRoZXNlIGxpc3RzIGFyZSBhbHNvIHByb3Rl
Y3RlZCBieSBydHdkZXYtPm11dGV4LiBXaGVuIHJ0dzg4IHdhbnRzIHRvDQppdGVyYXRlIGFsbCBz
dGEvdmlmLCBpdCBob2xkcyBydHdkZXYtPm11dGV4IHRvIGRvIGxpc3RfZm9yX2VhY2hfZW50cnku
DQpObyBuZWVkIHRvIGhvbGQgbWFjODAyMTEgbG9ja3MuDQoNCj4gDQo+IFNvIG5vdyBJIGFtIHdv
bmRlcmluZyBpZiB0aGUgaWVlZTgwMjExX2l0ZXJhdGVfc3RhdGlvbnNfYXRvbWljIGxvY2sgaXMN
Cj4gYWxzbyB1c2VkIHRvIHByb3RlY3QgYW55IG1vZGlmaWNhdGlvbnMgdG8gcnR3X3N0YV9pbmZv
Lg0KPiBQaW5nLUtlLCBJIGFtIHdvbmRlcmluZyBpZiB0aGUgYXR0YWNoZWQgcGF0Y2ggKHVudGVz
dGVkIC0gdG8gYmV0dGVyDQo+IGRlbW9uc3RyYXRlIHdoYXQgSSB3YW50IHRvIHNheSkgd291bGQ6
DQo+IC0gYWxsb3cgdXMgdG8gbW92ZSB0aGUgcmVnaXN0ZXIgd3JpdGUgb3V0c2lkZSBvZg0KPiBp
ZWVlODAyMTFfaXRlcmF0ZV9zdGF0aW9uc19hdG9taWMNCj4gLSBtZWFuIHdlIGNhbiBrZWVwIGll
ZWU4MDIxMV9pdGVyYXRlX3N0YXRpb25zX2F0b21pYyAoaW5zdGVhZCBvZiB0aGUNCj4gbm9uLWF0
b21pYyB2YXJpYW50KQ0KPiAtIHByb3RlY3QgdGhlIGNvZGUgbWFuYWdpbmcgdGhlICJtYWNfaWQi
IHdpdGggcnR3ZGV2LT5tdXRleCBjb25zaXN0ZW50bHkNCg0KSSB0aGluayB5b3VyIGF0dGFjaGVk
IHBhdGNoIGNhbiB3b3JrIHdlbGwuDQoNCj4gDQo+ID4gVGhlIG90aGVyIGNhc2VzIGxvb2sgT0ss
IGl0J3MgYmVpbmcgY2FsbGVkIGZyb20gb3V0c2lkZSBjb250ZXh0cw0KPiA+ICh3b3dsYW4sIGV0
Yy4pDQo+IFRoYW5rcyBmb3IgcmV2aWV3aW5nIHRoaXMgSm9oYW5uZXMhDQo+IA0KDQotLQ0KUGlu
Zy1LZQ0KDQoNCg==
