Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D70E3D542F
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 09:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbhGZGmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 02:42:21 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50623 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhGZGmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 02:42:20 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16Q7MVyuC012208, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16Q7MVyuC012208
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 15:22:31 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 15:22:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 15:22:30 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 26 Jul 2021 15:22:30 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH RFC v1 5/7] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Thread-Topic: [PATCH RFC v1 5/7] rtw88: Configure the registers from
 rtw_bf_assoc() outside the RCU lock
Thread-Index: AQHXe0w0JoHHz5CoNkymlQ8rINQ1TKtJyCDggAn1WYCAAOxIAA==
Date:   Mon, 26 Jul 2021 07:22:30 +0000
Message-ID: <c60c9877f491411c915c64d1fc7a797a@realtek.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-6-martin.blumenstingl@googlemail.com>
 <1a299cd8c1be4fba8360780ef6f70f0f@realtek.com>
 <CAFBinCAJNqbpoqSSFYYBJg818KHCKx5nFzsKZdR=D+sTXQj6dg@mail.gmail.com>
In-Reply-To: <CAFBinCAJNqbpoqSSFYYBJg818KHCKx5nFzsKZdR=D+sTXQj6dg@mail.gmail.com>
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
b25kYXksIEp1bHkgMjYsIDIwMjEgNTozNiBBTQ0KPiBUbzogUGtzaGloDQo+IENjOiBsaW51eC13
aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IHRvbnkwNjIwZW1tYUBnbWFpbC5jb207IGt2YWxvQGNv
ZGVhdXJvcmEub3JnOw0KPiBqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBOZW8gSm91OyBKZXJuZWoN
Cj4gU2tyYWJlYw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJGQyB2MSA1LzddIHJ0dzg4OiBDb25m
aWd1cmUgdGhlIHJlZ2lzdGVycyBmcm9tIHJ0d19iZl9hc3NvYygpIG91dHNpZGUgdGhlIFJDVSBs
b2NrDQo+IA0KPiBIaSBQaW5nLUtlLA0KPiANCj4gT24gTW9uLCBKdWwgMTksIDIwMjEgYXQgNzo0
NyBBTSBQa3NoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4gd3JvdGU6DQo+IFsuLi5dDQo+ID4gVGhl
IHJjdV9yZWFkX2xvY2soKSBpbiB0aGlzIGZ1bmN0aW9uIGlzIHVzZWQgdG8gYWNjZXNzIGllZWU4
MDIxMV9maW5kX3N0YSgpIGFuZCBwcm90ZWN0ICdzdGEnLg0KPiA+IEEgc2ltcGxlIHdheSBpcyB0
byBzaHJpbmsgdGhlIGNyaXRpY2FsIHNlY3Rpb24sIGxpa2U6DQo+ID4NCj4gPiAgICAgICAgIHJj
dV9yZWFkX2xvY2soKTsNCj4gPg0KPiA+ICAgICAgICAgc3RhID0gaWVlZTgwMjExX2ZpbmRfc3Rh
KHZpZiwgYnNzaWQpOw0KPiA+ICAgICAgICAgaWYgKCFzdGEpIHsNCj4gPiAgICAgICAgICAgICAg
ICAgcnR3X3dhcm4ocnR3ZGV2LCAiZmFpbGVkIHRvIGZpbmQgc3RhdGlvbiBlbnRyeSBmb3IgYnNz
ICVwTVxuIiwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgYnNzaWQpOw0KPiA+ICAgICAg
ICAgICAgICAgICByY3VfcmVhZF91bmxvY2soKTsNCj4gPiAgICAgICAgIH0NCj4gPg0KPiA+ICAg
ICAgICAgdmh0X2NhcCA9ICZzdGEtPnZodF9jYXA7DQo+ID4NCj4gPiAgICAgICAgIHJjdV9yZWFk
X3VubG9jaygpOw0KPiBJIGFncmVlIHRoYXQgcmVkdWNpbmcgdGhlIGFtb3VudCBvZiBjb2RlIHVu
ZGVyIHRoZSBsb2NrIHdpbGwgaGVscCBteQ0KPiB1c2UtY2FzZSBhcyB3ZWxsDQo+IGluIHlvdXIg
Y29kZS1leGFtcGxlIEkgYW0gd29uZGVyaW5nIGlmIHdlIHNob3VsZCBjaGFuZ2UNCj4gICBzdHJ1
Y3QgaWVlZTgwMjExX3N0YV92aHRfY2FwICp2aHRfY2FwOw0KPiAgIHZodF9jYXAgPSAmc3RhLT52
aHRfY2FwOw0KPiB0bw0KPiAgIHN0cnVjdCBpZWVlODAyMTFfc3RhX3ZodF9jYXAgdmh0X2NhcDsN
Cj4gICB2aHRfY2FwID0gc3RhLT52aHRfY2FwOw0KPiANCj4gTXkgdGhpbmtpbmcgaXMgdGhhdCBp
ZWVlODAyMTFfc3RhIG1heSBiZSBmcmVlZCBpbiBwYXJhbGxlbCB0byB0aGlzIGNvZGUgcnVubmlu
Zy4NCj4gSWYgdGhhdCBjYW5ub3QgaGFwcGVuIHRoZW4geW91ciBjb2RlIHdpbGwgYmUgZmluZS4N
Cj4gDQo+IFNvIEkgYW0gaG9waW5nIHRoYXQgeW91IGNhbiBhbHNvIHNoYXJlIHlvdXIgdGhvdWdo
dHMgb24gdGhpcyBvbmUuDQo+IA0KDQpXaGVuIHdlIGVudGVyIHJ0d19iZl9hc3NvYygpLCB0aGUg
bXV0ZXggcnR3ZGV2LT5tdXRleCBpcyBoZWxkOyBhcyB3ZWxsIGFzDQpydHdfc3RhX2FkZCgpL3J0
d19zdGFfcmVtb3ZlKCkuIFNvLCBJIHRoaW5rIGl0IGNhbm5vdCBoYXBwZW4gdGhhdCBpZWVlODAy
MTFfc3RhDQp3YXMgZnJlZWQgaW4gcGFyYWxsZWwuDQoNCi0tDQpQaW5nLUtlDQoNCg==
