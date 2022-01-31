Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431A04A3CA9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 04:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357455AbiAaDGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 22:06:39 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44541 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiAaDGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jan 2022 22:06:38 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20V36DdA4004765, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20V36DdA4004765
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Jan 2022 11:06:13 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 11:06:13 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 11:06:13 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Mon, 31 Jan 2022 11:06:13 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "eswierk@gh.st" <eswierk@gh.st>
Subject: Re: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Topic: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Index: AQHYBCp/WStseF16x0uJ7VAbWo+1y6xqJTFAgAMM/BCAA1dIAIAA+BTwgAWAeYCAALM9AIAEADQAgABbFwA=
Date:   Mon, 31 Jan 2022 03:06:12 +0000
Message-ID: <8afdfa15dd548019f8808085efe584d216a4ac67.camel@realtek.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
         <423f474e15c948eda4db5bc9a50fd391@realtek.com>
         <CAFBinCBVEndU0t-6d5atE31OFYHzPyk7pOe78v0XrrFWcBec9w@mail.gmail.com>
         <5ef8ab4f78e448df9f823385d0daed88@realtek.com>
         <CAFBinCDjfKK3+WOXP2xbcAK-KToWof+kSzoxYztqRcc=7T1eyg@mail.gmail.com>
         <53bea965043548539b995514d36f48e5@realtek.com>
         <CAFBinCBcgEKB3Zak9oGrZ-azqgot691gFSRGGeOP-hr4e+9C4Q@mail.gmail.com>
In-Reply-To: <CAFBinCBcgEKB3Zak9oGrZ-azqgot691gFSRGGeOP-hr4e+9C4Q@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [111.252.224.243]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMzAg5LiL5Y2IIDEwOjIxOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B53DD61DDFF5D4E9D3B72A1A503E0E8@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCk9uIFN1biwgMjAyMi0wMS0zMCBhdCAyMjo0MCArMDEwMCwgTWFydGluIEJsdW1lbnN0
aW5nbCB3cm90ZToNCj4gDQo+IE9uIEZyaSwgSmFuIDI4LCAyMDIyIGF0IDE6NTEgQU0gUGtzaGlo
IDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiBbLi4uXQ0KPiA+ID4gPiBUbyBhdm9pZCB0
aGlzLCB3ZSBjYW4gYWRkIGEgZmxhZyB0byBzdHJ1Y3QgcnR3X3ZpZiwgYW5kIHNldCB0aGlzIGZs
YWcNCj4gPiA+ID4gd2hlbiA6OnJlbW92ZV9pbnRlcmZhY2UuIFRoZW4sIG9ubHkgY29sbGVjdCB2
aWYgd2l0aG91dCB0aGlzIGZsYWcgaW50byBsaXN0DQo+ID4gPiA+IHdoZW4gd2UgdXNlIGl0ZXJh
dGVfYWN0aW9tKCkuDQo+ID4gPiA+IA0KPiA+ID4gPiBBcyB3ZWxsIGFzIGllZWU4MDIxMV9zdGEg
Y2FuIGRvIHNpbWlsYXIgZml4Lg0KPiA+ID4gPiANCj4gPiANCj4gPiBJIHdvdWxkIHByZWZlciBt
eSBtZXRob2QgdGhhdCBhZGRzIGEgJ2Jvb2wgZGlzYWJsZWQnIGZsYWcgdG8gc3RydWN0IHJ0d192
aWYvcnR3X3N0YQ0KPiA+IGFuZCBzZXQgaXQgd2hlbiA6OnJlbW92ZV9pbnRlcmZhY2UvOjpzdGFf
cmVtb3ZlLiBUaGVuIHJ0d19pdGVyYXRlX3N0YXMoKSBjYW4NCj4gPiBjaGVjayB0aGlzIGZsYWcg
dG8gZGVjaWRlIHdoZXRoZXIgZG9lcyB0aGluZyBvciBub3QuDQo+IFRoYXQgd291bGQgaW5kZWVk
IGJlIGEgdmVyeSBzdHJhaWdodCBmb3J3YXJkIGFwcHJvYWNoIGFuZCBlYXN5IHRvIHJlYWQuDQo+
IEluIG5ldC9tYWM4MDIxMS9pZmFjZS5jIHRoZXJlJ3Mgc29tZSBjYXNlcyB3aGVyZSBhZnRlcg0K
PiBkcnZfcmVtb3ZlX2ludGVyZmFjZSgpICh3aGljaCBpbnRlcm5hbGx5IGNhbGxzIG91ciAucmVt
b3ZlX2ludGVyZmFjZQ0KPiBvcCkgd2lsbCBrZnJlZSB0aGUgdmlmIChzZGF0YSkuIERvZXNuJ3Qg
dGhhdCB0aGVuIHJlc3VsdCBpbiBhDQo+IHVzZS1hZnRlci1mcmVlIGlmIHdlIHJlbHkgb24gYSBi
b29sZWFuIHdpdGhpbiBydHdfdmlmPw0KDQpUaGUgcnR3X3ZpZiBpcyBkcnZfcHJpdiBvZiBpZWVl
ODAyMTFfdmlmLCBhbmQgdGhleSB3aWxsIGJlIGZyZWVkIGF0DQp0aGUgc2FtZSB0aW1lLiBXZSBt
dXN0IHNldCAnYm9vbCBkaXNhYmxlZCcgYWZ0ZXIgaG9sZGluZyBydHdkZXYtPm11dGV4DQpsb2Nr
LCBhbmQgY2hlY2sgdGhpcyBmbGFnIGluIGl0ZXJhdG9yIG9mIGllZWU4MDIxMV9pdGVyYXRlX2Fj
dGl2ZV9pbnRlcmZhY2VzX2F0b21pYygpDQp0byBjb250cnVjdCBhIGxpc3Qgb2YgdmlmLg0KDQpU
aGF0IG1lYW5zIHdlIG5ldmVyIGFjY2VzcyB0aGlzIGZsYWcgb3V0IG9mIHJ0d2Rldi0+bXV0eCBv
ciBpdGVyYXRvci4NCkRvZXMgaXQgbWFrZSBzZW5zZT8NCg0KLS0NClBpbmctS2UNCg0KDQo=
