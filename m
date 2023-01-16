Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD49A66CC9D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbjAPR2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbjAPR1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:27:42 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3544841B5B
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:04:33 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30GH4MiW4029557, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30GH4MiW4029557
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 17 Jan 2023 01:04:22 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Tue, 17 Jan 2023 01:04:22 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 17 Jan 2023 01:04:21 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Tue, 17 Jan 2023 01:04:21 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Topic: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Index: AQHZITAeQEw7+pbiWEKyObvpj0H4U66PsbSAgAAedICAARt84IAASKWAgAayTHD//86LgIABruOg//+8sACAACFVAIADUFuA//9/cYAADErCAACZvlRA
Date:   Mon, 16 Jan 2023 17:04:21 +0000
Message-ID: <5084ca55d66f4e449253e54081e86986@realtek.com>
References: <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
 <Y7dAbxSPeaMnW/ly@lunn.ch> <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
 <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
 <e201750b-f3be-b62d-4dc6-2a00f4834256@gmail.com> <Y78ssmMck/eZTpYz@lunn.ch>
 <d34e9d2f3a0d4ae8988d39b865de987b@realtek.com> <Y8GIgXKCtaYzpFdW@lunn.ch>
 <939fae88-ab42-132a-81d8-bbedfc20344e@gmail.com>
In-Reply-To: <939fae88-ab42-132a-81d8-bbedfc20344e@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.56]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMTYg5LiL5Y2IIDAyOjEyOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAxMy4wMS4yMDIzIDE3OjM2LCBBbmRyZXcgTHVubiB3cm90ZToNCj4gPiBPbiBGcmksIEph
biAxMywgMjAyMyBhdCAwNDoyMzo0NVBNICswMDAwLCBIYXUgd3JvdGU6DQo+ID4+Pj4+Pj4gSW4g
dGhpcyBhcHBsaWNhdGlvbihydGw4MTY4aCArIHJ0bDgyMTFmcykgaXQgYWxzbyBzdXBwb3J0cw0K
PiA+Pj4+Pj4+IDEwME1icHMgZmliZXINCj4gPj4+Pj4+IG1vZHVsZS4NCj4gPj4+Pj4+DQo+ID4+
Pj4+PiBEb2VzIFJUTDgyMTFGUyBhZHZlcnRpc2UgMTAwTWJwcyBhbmQgMUdicHMgb24gdGhlIFVU
UC9NREkgc2lkZQ0KPiBpbg0KPiA+Pj4+Pj4gY2FzZSBvZiBhIDEwME1icHMgZmliZXIgbW9kdWxl
Pw0KPiA+Pj4+PiBZZXMuDQo+ID4+Pj4+DQo+ID4+Pj4gSSB0aGluayBpbiB0aGlzIGNhc2UgaW50
ZXJuYWwgUEhZIGFuZCBSVEw4MjExRlMgd291bGQgbmVnb3RpYXRlDQo+ID4+Pj4gMUdicHMsIG5v
dCBtYXRjaGluZyB0aGUgc3BlZWQgb2YgdGhlIDEwME1icHMgZmliZXIgbW9kdWxlLg0KPiA+Pj4+
IEhvdyBkb2VzIHRoaXMgd29yaz8NCj4gPj4NCj4gPj4gTXkgbWlzdGFrZS4gV2l0aCAxMDBNYnBz
IGZpYmVyIG1vZHVsZSBSVEw4MjExRlMgd2lsbCBvbmx5IGFkdmVydGlzZQ0KPiA+PiAxMDBNYnBz
IG9uIHRoZSBVVFAvTURJIHNpZGUuIFdpdGggMUdicHMgZmliZXIgbW9kdWxlIGl0IHdpbGwNCj4g
Pj4gYWR2ZXJ0aXNlIGJvdGggMTAwTWJwcyBhbmQgMUdicHMuIFNvIGlzc3VlIHdpbGwgb25seSBo
YXBwZW4gd2l0aCAxR2Jwcw0KPiBmaWJlciBtb2R1bGUuDQo+ID4+DQo+ID4+PiBGaWJyZSBsaW5l
IHNpZGUgaGFzIG5vIGF1dG9uZWcuIEJvdGggZW5kcyBuZWVkIHRvIGJlIHVzaW5nIHRoZSBzYW1l
DQo+ID4+PiBzcGVlZCwgb3IgdGhlIFNFUkRFUyBkb2VzIG5vdCBzeW5jaHJvbmlzZSBhbmQgZG9l
cyBub3QgZXN0YWJsaXNoIGxpbmsuDQo+ID4+Pg0KPiA+Pj4gWW91IGNhbiBhc2sgdGhlIFNGUCBt
b2R1bGUgd2hhdCBiYXVkIHJhdGUgaXQgc3VwcG9ydHMsIGFuZCB0aGVuIHVzZQ0KPiA+Pj4gYW55
dGhpbmcgdXAgdG8gdGhhdCBiYXVkIHJhdGUuIEkndmUgZ290IHN5c3RlbXMgd2hlcmUgdGhlIFNG
UCBpcw0KPiA+Pj4gZmFzdCBlbm91Z2ggdG8gc3VwcG9ydCBhIDIuNUdicHMgbGluaywgc28gdGhl
IE1BQyBpbmRpY2F0ZXMgYm90aA0KPiA+Pj4gMi41RyBhbmQgMUcsIGRlZmF1bHRzIHRvIDIuNUcs
IGFuZCBmYWlscyB0byBjb25uZWN0IHRvIGEgMUcgbGluaw0KPiA+Pj4gcGVlci4gWW91IG5lZWQg
dG8gdXNlIGV0aHRvb2wgdG8gZm9yY2UgaXQgdG8gdGhlIGxvd2VyIHNwZWVkIGJlZm9yZSB0aGUN
Cj4gbGluayB3b3Jrcy4NCj4gPj4+DQo+ID4+PiBCdXQgZnJvbSB3aGF0IGkgdW5kZXJzdGFuZCwg
eW91IGNhbm5vdCB1c2UgYSAxMDAwQmFzZS1YIFNGUCwgc2V0IHRoZQ0KPiA+Pj4gTUFDIHRvIDEw
ME1icHMsIGFuZCBleHBlY3QgaXQgdG8gY29ubmVjdCB0byBhIDEwMEJhc2UtRlggU0ZQLiBTbyBm
b3INCj4gPj4+IG1lLCB0aGUgUlRMODIxMUZTIHNob3VsZCBub3QgYmUgYWR2ZXJ0aXNlIDEwME1i
cHMgYW5kIDFHYnBzLCBpdA0KPiA+Pj4gbmVlZHMgdG8gdGFsayB0byB0aGUgU0ZQIGZpZ3VyZSBv
dXQgZXhhY3RseSB3aGF0IGl0IGlzLCBhbmQgb25seQ0KPiA+Pj4gYWR2ZXJ0aXNlIHRoZSBvbmUg
bW9kZSB3aGljaCBpcyBzdXBwb3J0ZWQuDQo+ID4+DQo+ID4+IEl0IGlzIHRoZSBSVEw4MjExRlMg
ZmlybXdhcmUgYnVnLiBUaGlzIHBhdGNoIGlzIGZvciB3b3JrYXJvdW5kIHRoaXMgaXNzdWUuDQo+
ID4NCj4gPiBTbyBpZiBpdCBpcyBhZHZlcnRpc2luZyBib3RoIDEwME1icHMgYW5kIDFHYnBzLCB3
ZSBrbm93IHRoZSBTRlAgaXMNCj4gPiBhY3R1YWxseSAxRywgYW5kIHdlIGNhbiByZW1vdmUgdGhl
IDEwME1icHMgYWR2ZXJ0aXNlbWVudD8gVGhhdCBzaG91bGQNCj4gPiB0aGVuIHNvbHZlIGFsbCB0
aGUgcHJvYmxlbXM/DQo+ID4NCj4gUmlnaHQsIHRoYXQncyB3aGF0IEkgcHJvcG9zZWQgdG9vLCBy
ZW1vdmluZyAxR2JwcyBhZHZlcnRpc2VtZW50IG9mIHRoZQ0KPiBSVEw4MTY4SC1pbnRlcm5hbCBQ
SFkgdmlhIHVzZXJzcGFjZSB0b29sLCBlLmcuIGV0aHRvb2wuIEZvciBtZSB0aGlzIGlzIHRoZQ0K
PiBjbGVhbmVzdCBzb2x1dGlvbi4gQWRkaW5nIGEgd29ya2Fyb3VuZCBmb3IgYSBmaXJtd2FyZSBi
dWcgb2YgYSBzcGVjaWZpYw0KPiBleHRlcm5hbCBQSFkgdG8gdGhlIHI4MTY5IE1BQyBkcml2ZXIg
d291bGQgYmUgc29tZXdoYXQgaGFja3kuDQo+IA0KVGhhbmtzIGZvciB5b3VyIHN1Z2dlc3Rpb25z
LiBCdXQgYmVjYXVzZSBpdCBuZWVkcyB1c2VyIHRvIGV4ZWN1dGUgdXNlcnNwYWNlIHRvb2wuDQpU
aGlzIHdvcmthcm91bmQgbWF5IG5vdCBiZSBhY2NlcHRlZCBieSBvdXIgY3VzdG9tZXINCg0KLS0t
LS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBl
LW1haWwuDQo=
