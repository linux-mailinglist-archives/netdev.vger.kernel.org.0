Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A923C7B29
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 03:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbhGNBvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 21:51:05 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40179 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhGNBvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 21:51:04 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16E1m6gS5012585, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16E1m6gS5012585
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Jul 2021 09:48:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Jul 2021 09:48:05 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Jul 2021 09:48:04 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Wed, 14 Jul 2021 09:48:04 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Tzu-En Huang <tehuang@realtek.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: rtw88: rtw_{read,write}_rf locking questions
Thread-Topic: rtw88: rtw_{read,write}_rf locking questions
Thread-Index: AQHXeAdXGqHSvvyH0USPP4DUS+6k4KtBq4Fg
Date:   Wed, 14 Jul 2021 01:48:04 +0000
Message-ID: <3c61fae611294e5098e6e0044a7a4199@realtek.com>
References: <CAFBinCDMPPJ7qW7xTkep1Trg+zP0B9Jxei6sgjqmF4NDA1JAhQ@mail.gmail.com>
In-Reply-To: <CAFBinCDMPPJ7qW7xTkep1Trg+zP0B9Jxei6sgjqmF4NDA1JAhQ@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMTMg5LiL5Y2IIDEwOjE3OjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/14/2021 01:24:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165027 [Jul 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: github.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/14/2021 01:27:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcnRpbiBCbHVtZW5zdGlu
Z2wgW21haWx0bzptYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tXQ0KPiBTZW50OiBX
ZWRuZXNkYXksIEp1bHkgMTQsIDIwMjEgMTI6NTEgQU0NCj4gVG86IFlhbi1Ic3VhbiBDaHVhbmc7
IFBrc2hpaDsgVHp1LUVuIEh1YW5nDQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5v
cmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
IE5lbyBKb3U7DQo+IEplcm5laiBTa3JhYmVjDQo+IFN1YmplY3Q6IHJ0dzg4OiBydHdfe3JlYWQs
d3JpdGV9X3JmIGxvY2tpbmcgcXVlc3Rpb25zDQo+IA0KPiBIZWxsbyBydHc4OCBtYWludGFpbmVy
cyBhbmQgY29udHJpYnV0b3JzLA0KPiANCj4gdGhlcmUgaXMgYW4gb25nb2luZyBlZmZvcnQgd2hl
cmUgSmVybmVqIGFuZCBJIGFyZSB3b3JraW5nIG9uIGFkZGluZw0KPiBTRElPIHN1cHBvcnQgdG8g
dGhlIHJ0dzg4IGRyaXZlci4NCj4gVGhlIGhhcmR3YXJlIHdlIHVzZSBhdCB0aGUgbW9tZW50IGlz
IFJUTDg4MjJCUyBhbmQgUlRMODgyMkNTLg0KPiBXb3JrLWluLXByb2dyZXNzIGNvZGUgY2FuIGJl
IGZvdW5kIGluIEplcm5laidzIHJlcG8gKG5vdGU6IHRoaXMgbWF5IGJlDQo+IHJlYmFzZWQpOiBb
MF0NCg0KVGhhbmtzIGZvciB5b3VyIG5pY2Ugd29yayENCg0KPiANCj4gV2UgYXJlIGF0IGEgcG9p
bnQgd2hlcmUgd2UgY2FuIGNvbW11bmljYXRlIHdpdGggdGhlIFNESU8gY2FyZCBhbmQNCj4gc3Vj
Y2Vzc2Z1bGx5IHVwbG9hZCB0aGUgZmlybXdhcmUgdG8gaXQuDQo+IFJpZ2h0IG5vdyBJIGhhdmUg
dHdvIHF1ZXN0aW9ucyBhYm91dCB0aGUgbG9ja2luZyBpbg0KPiBydHdfe3JlYWQsd3JpdGV9X3Jm
IGZyb20gaGNpLmg6DQo+IDEpIEEgc3BpbmxvY2sgaXMgdXNlZCB0byBwcm90ZWN0IFJGIHJlZ2lz
dGVyIGFjY2Vzcy4gVGhpcyBpcw0KPiBwcm9ibGVtYXRpYyBmb3IgU0RJTywgbW9yZSBpbmZvcm1h
dGlvbiBiZWxvdy4gV291bGQgeW91IGFjY2VwdCBhIHBhdGNoDQo+IHRvIGNvbnZlcnQgdGhpcyBp
bnRvIGEgbXV0ZXg/IEkgZG9uJ3QgaGF2ZSBhbnkgcnR3ODggUENJZSBjYXJkIGZvcg0KPiB0ZXN0
aW5nIGFueSByZWdyZXNzaW9ucyB0aGVyZSBteXNlbGYuDQoNCkkgdGhpbmsgaXQncyBva2F5Lg0K
DQo+IDIpIEkgd291bGQgbGlrZSB0byB1bmRlcnN0YW5kIHdoeSB0aGUgUkYgcmVnaXN0ZXIgYWNj
ZXNzIG5lZWRzIHRvIGJlDQo+IHByb3RlY3RlZCBieSBhIGxvY2suIEZyb20gd2hhdCBJIGNhbiB0
ZWxsIFJGIHJlZ2lzdGVyIGFjY2VzcyBkb2Vzbid0DQo+IHNlZW0gdG8gYmUgdXNlZCBmcm9tIElS
USBoYW5kbGVycy4NCg0KVGhlIHVzZSBvZiBsb2NrIGlzbid0IGJlY2F1c2Ugd2Ugd2FudCB0byBh
Y2Nlc3MgdGhlIFJGIHJlZ2lzdGVyIGluIElSUQ0KaGFuZGxlcnMuIFRoZSByZWFzb25zIGFyZQ0K
MS4gVGhlIGllZWU4MDIxMSBpdGVyYXRpdmUgdmlmIGZ1bmN0aW9uIHdlIHVzZSBpcyBhdG9taWMg
dHlwZSwgc28gd2UgY2FuJ3QNCiAgIHVzZSBtdXRleC4NCiAgIERvIHlvdSBjaGFuZ2UgdGhlIHR5
cGUgb2YgaXRlcmF0aXZlIGZ1bmN0aW9uPw0KMi4gUkYgcmVnaXN0ZXIgYWNjZXNzIGlzbid0IGFu
IGF0b21pYy4gSWYgbW9yZSB0aGFuIG9uZSB0aHJlYWRzIGFjY2VzcyB0aGUNCiAgIHJlZ2lzdGVy
IGF0IHRoZSBzYW1lIHRpbWUsIHRoZSB2YWx1ZSB3aWxsIGJlIHdyb25nLg0KDQo+IA0KPiBTb21l
IGJhY2tncm91bmQgb24gd2h5IFNESU8gYWNjZXNzIChmb3IgZXhhbXBsZTogc2Rpb193cml0ZWIp
IGNhbm5vdA0KPiBiZSBkb25lIHdpdGggYSBzcGlubG9jayBoZWxkOg0KPiAtIHdoZW4gdXNpbmcg
Zm9yIGV4YW1wbGUgc2Rpb193cml0ZWIgdGhlIE1NQyBzdWJzeXN0ZW0gaW4gTGludXgNCj4gcHJl
cGFyZXMgYSBzby1jYWxsZWQgTU1DIHJlcXVlc3QNCj4gLSB0aGlzIHJlcXVlc3QgaXMgc3VibWl0
dGVkIHRvIHRoZSBNTUMgaG9zdCBjb250cm9sbGVyIGhhcmR3YXJlDQo+IC0gdGhlIGhvc3QgY29u
dHJvbGxlciBoYXJkd2FyZSBmb3J3YXJkcyB0aGUgTU1DIHJlcXVlc3QgdG8gdGhlIGNhcmQNCj4g
LSB0aGUgY2FyZCBzaWduYWxzIHdoZW4gaXQncyBkb25lIHByb2Nlc3NpbmcgdGhlIHJlcXVlc3QN
Cj4gLSB0aGUgTU1DIHN1YnN5c3RlbSBpbiBMaW51eCB3YWl0cyBmb3IgdGhlIGNhcmQgdG8gc2ln
bmFsIHRoYXQgaXQncw0KPiBkb25lIHByb2Nlc3NpbmcgdGhlIHJlcXVlc3QgaW4gbW1jX3dhaXRf
Zm9yX3JlcV9kb25lKCkgLT4gdGhpcyB1c2VzDQo+IHdhaXRfZm9yX2NvbXBsZXRpb24oKSBpbnRl
cm5hbGx5LCB3aGljaCBtaWdodCBzbGVlcCAod2hpY2ggaXMgbm90DQo+IGFsbG93ZWQgd2hpbGUg
YSBzcGlubG9jayBpcyBoZWxkKQ0KPiANCj4gSSBhbSBsb29raW5nIGZvcndhcmQgdG8geW91ciBh
ZHZpY2Ugb24gdGhpcyBydHdfe3JlYWQsd3JpdGV9X3JmIGxvY2tpbmcgdG9waWMuDQo+IA0KPiBb
MF0gaHR0cHM6Ly9naXRodWIuY29tL2plcm5lanNrL2xpbnV4LTEvY29tbWl0cy9ydHc4OC1zZGlv
DQoNClBpbmctS2UNCg0K
