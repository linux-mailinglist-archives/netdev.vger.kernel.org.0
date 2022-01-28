Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8567149EFF2
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 01:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344654AbiA1Avh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 19:51:37 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49293 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344612AbiA1Avh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 19:51:37 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20S0pCjT5017875, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20S0pCjT5017875
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Jan 2022 08:51:12 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 28 Jan 2022 08:51:11 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 16:51:11 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Fri, 28 Jan 2022 08:51:11 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ed Swierk <eswierk@gh.st>
Subject: RE: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Topic: [PATCH v3 0/8] rtw88: prepare locking for SDIO support
Thread-Index: AQHYBCp/WStseF16x0uJ7VAbWo+1y6xqJTFAgAMM/BCAA1dIAIAA+BTwgAWAeYCAALM9AA==
Date:   Fri, 28 Jan 2022 00:51:11 +0000
Message-ID: <53bea965043548539b995514d36f48e5@realtek.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
 <423f474e15c948eda4db5bc9a50fd391@realtek.com>
 <CAFBinCBVEndU0t-6d5atE31OFYHzPyk7pOe78v0XrrFWcBec9w@mail.gmail.com>
 <5ef8ab4f78e448df9f823385d0daed88@realtek.com>
 <CAFBinCDjfKK3+WOXP2xbcAK-KToWof+kSzoxYztqRcc=7T1eyg@mail.gmail.com>
In-Reply-To: <CAFBinCDjfKK3+WOXP2xbcAK-KToWof+kSzoxYztqRcc=7T1eyg@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMjcg5LiL5Y2IIDEwOjU1OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFydGluIEJsdW1l
bnN0aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gU2VudDogRnJp
ZGF5LCBKYW51YXJ5IDI4LCAyMDIyIDU6NTMgQU0NCj4gVG86IFBrc2hpaCA8cGtzaGloQHJlYWx0
ZWsuY29tPg0KPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyB0b255MDYyMGVt
bWFAZ21haWwuY29tOyBrdmFsb0Bjb2RlYXVyb3JhLm9yZzsNCj4gam9oYW5uZXNAc2lwc29sdXRp
b25zLm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsgTmVvIEpvdQ0KPiA8bmVvam91QGdtYWlsLmNvbT47IEplcm5laiBTa3JhYmVjIDxqZXJu
ZWouc2tyYWJlY0BnbWFpbC5jb20+OyBFZCBTd2llcmsgPGVzd2llcmtAZ2guc3Q+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjMgMC84XSBydHc4ODogcHJlcGFyZSBsb2NraW5nIGZvciBTRElPIHN1
cHBvcnQNCj4gDQo+IEhpIFBpbmctS2UsDQo+IA0KPiBPbiBNb24sIEphbiAyNCwgMjAyMiBhdCAz
OjU5IEFNIFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiB3cm90ZToNCg0KWy4uLl0NCg0KPiA+
DQo+ID4gVG8gYXZvaWQgdGhpcywgd2UgY2FuIGFkZCBhIGZsYWcgdG8gc3RydWN0IHJ0d192aWYs
IGFuZCBzZXQgdGhpcyBmbGFnDQo+ID4gd2hlbiA6OnJlbW92ZV9pbnRlcmZhY2UuIFRoZW4sIG9u
bHkgY29sbGVjdCB2aWYgd2l0aG91dCB0aGlzIGZsYWcgaW50byBsaXN0DQo+ID4gd2hlbiB3ZSB1
c2UgaXRlcmF0ZV9hY3Rpb20oKS4NCj4gPg0KPiA+IEFzIHdlbGwgYXMgaWVlZTgwMjExX3N0YSBj
YW4gZG8gc2ltaWxhciBmaXguDQo+ID4NCg0KSSB3b3VsZCBwcmVmZXIgbXkgbWV0aG9kIHRoYXQg
YWRkcyBhICdib29sIGRpc2FibGVkJyBmbGFnIHRvIHN0cnVjdCBydHdfdmlmL3J0d19zdGENCmFu
ZCBzZXQgaXQgd2hlbiA6OnJlbW92ZV9pbnRlcmZhY2UvOjpzdGFfcmVtb3ZlLiBUaGVuIHJ0d19p
dGVyYXRlX3N0YXMoKSBjYW4NCmNoZWNrIHRoaXMgZmxhZyB0byBkZWNpZGUgd2hldGhlciBkb2Vz
IHRoaW5nIG9yIG5vdC4NCg0KWy4uLl0NCg0KPiANCj4gRm9yIHRoZSBzdGEgdXNlLWNhc2UgSSB0
aG91Z2h0IGFib3V0IGFkZGluZyBhIGRlZGljYXRlZCByd2xvY2sNCj4gKGluY2x1ZGUvbGludXgv
cndsb2NrLmgpIGZvciBydHdfZGV2LT5tYWNfaWRfbWFwLg0KPiBydHdfc3RhX3thZGQscmVtb3Zl
fSB3b3VsZCB0YWtlIGEgd3JpdGUtbG9jay4NCj4gcnR3X2l0ZXJhdGVfc3RhcygpIHRha2VzIHRo
ZSByZWFkLWxvY2sgKHRoZSBsb2NrIHdvdWxkIGJlIGFjcXVpcmVkDQo+IGJlZm9yZSBjYWxsaW5n
IGludG8gaWVlZTgwMjExX2l0ZXJhdGVfLi4uKS4gQWRkaXRpb25hbGx5DQo+IHJ0d19pdGVyYXRl
X3N0YXMoKSBuZWVkcyB0byBjaGVjayBpZiB0aGUgc3RhdGlvbiBpcyBzdGlsbCB2YWxpZA0KPiBh
Y2NvcmRpbmcgdG8gbWFjX2lkX21hcCAtIGlmIG5vdDogc2tpcC9pZ25vcmUgaXQgZm9yIHRoYXQg
aXRlcmF0aW9uLg0KPiBUaGlzIGNvdWxkIGJlIGNvbWJpbmVkIHdpdGggeW91cg0KPiAwMDAxLXJ0
dzg4LXVzZS1hdG9taWMtdG8tY29sbGVjdC1zdGFzLWFuZC1kb2VzLWl0ZXJhdG9ycy5wYXRjaC4N
Cg0KVXNpbmcgYSAnZGlzYWJsZWQnIGZsYWcgd2l0aGluIHJ0d192aWYvcnR3X3N0YSB3aWxsIGJl
IGludHVpdGl2ZSBhbmQNCmJldHRlciB0aGFuIGJpdG1hcCBvZiBtYWNfaWRfbWFwLiBQbGVhc2Ug
cmVmZXJlbmNlIG15IG1lbnRpb24gYWJvdmUuDQoNCj4gDQo+IEZvciB0aGUgaW50ZXJmYWNlIHVz
ZS1jYXNlIGl0J3Mgbm90IGNsZWFyIHRvIG1lIGhvdyB0aGlzIHdvcmtzIGF0IGFsbC4NCj4gcnR3
X29wc19hZGRfaW50ZXJmYWNlKCkgaGFzIChpbiBhIHNpbXBsaWZpZWQgdmlldyk6DQo+ICAgICB1
OCBwb3J0ID0gMDsNCj4gICAgIC8vIHRoZSBwb3J0IHZhcmlhYmxlIGlzIG5ldmVyIGNoYW5nZWQN
Cj4gICAgIHJ0d3ZpZi0+cG9ydCA9IHBvcnQ7DQo+ICAgICBydHd2aWYtPmNvbmYgPSAmcnR3X3Zp
Zl9wb3J0W3BvcnRdOw0KPiAgICAgcnR3X2luZm8ocnR3ZGV2LCAic3RhcnQgdmlmICVwTSBvbiBw
b3J0ICVkXG4iLCB2aWYtPmFkZHIsIHJ0d3ZpZi0+cG9ydCk7DQo+IEhvdyBkbyBtdWx0aXBsZSBp
bnRlcmZhY2VzICh2aWZzKSB3b3JrIGluIHJ0dzg4IGlmIHRoZSBwb3J0IGlzIGFsd2F5cw0KPiB6
ZXJvPyBJcyBzb21lIGtpbmQgb2YgdHJhY2tpbmcgb2YgdGhlIHVzZWQgcG9ydHMgbWlzc2luZyAo
c2ltaWxhciB0bw0KPiBob3cgd2UgdHJhY2sgdGhlIHVzZWQgc3RhdGlvbiBJRHMgLSBhbHNvIGNh
bGxlZCBtYWNfaWQgLSBpbg0KPiBydHdfZGV2LT5tYWNfaWRfbWFwKT8NCg0KVGhlIHBvcnQgc2hv
dWxkIGJlIGFsbG9jYXRlZCBkeW5hbWljYWxseSBpZiB3ZSBzdXBwb3J0IHR3byBvciBtb3JlIHZp
ZnMuDQpXZSBoYXZlIGludGVybmFsIHRyZWUgdGhhdCBpcyBnb2luZyB0byBzdXBwb3J0IHAycCBi
eSBzZWNvbmQgdmlmLg0KDQoNClBpbmctS2UNCg0K
