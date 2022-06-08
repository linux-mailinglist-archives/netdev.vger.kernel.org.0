Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49458543147
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 15:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240166AbiFHN0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 09:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240083AbiFHN0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 09:26:14 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCAD366BD;
        Wed,  8 Jun 2022 06:26:10 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 258DPZRI0001741, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 258DPZRI0001741
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 8 Jun 2022 21:25:35 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 21:25:34 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 21:25:34 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::34e7:ab63:3da4:27c6%5]) with mapi id
 15.01.2308.021; Wed, 8 Jun 2022 21:25:34 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "neojou@gmail.com" <neojou@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@ulli-kroll.de" <linux@ulli-kroll.de>
Subject: Re: [PATCH v2 05/10] rtw88: iterate over vif/sta list non-atomically
Thread-Topic: [PATCH v2 05/10] rtw88: iterate over vif/sta list non-atomically
Thread-Index: AQHYdDPOvAC5P6vVz0elhZc8Fv6eZa1EBxiAgAEAxQA=
Date:   Wed, 8 Jun 2022 13:25:34 +0000
Message-ID: <e0aa1ba4336ab130712e1fcb425e6fd0adca4145.camel@realtek.com>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
         <20220530135457.1104091-6-s.hauer@pengutronix.de>
         <CAFBinCDgErZzFs5NiDT0JAOhziz5WLiy0+yxF9Z-kXPxD1j8Dw@mail.gmail.com>
In-Reply-To: <CAFBinCDgErZzFs5NiDT0JAOhziz5WLiy0+yxF9Z-kXPxD1j8Dw@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [172.16.16.197]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzYvOCDkuIrljYggMTE6NDg6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBBE19CD6A59C140B7AC1D457E96405D@realtek.com>
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

SGkgTWFydGluIGFuZCBTYXNjaGEsDQoNClRoYW5rIHlvdSBib3RoLg0KDQpPbiBXZWQsIDIwMjIt
MDYtMDggYXQgMDA6MDYgKzAyMDAsIE1hcnRpbiBCbHVtZW5zdGluZ2wgd3JvdGU6DQo+IEhpIFNh
c2NoYSwNCj4gDQo+IHRoYW5rcyBmb3IgdGhpcyBwYXRjaCENCj4gDQo+IE9uIE1vbiwgTWF5IDMw
LCAyMDIyIGF0IDM6NTUgUE0gU2FzY2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPiB3
cm90ZToNCj4gWy4uLl0NCj4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9w
aHkuYyAgfCAgIDYgKy0NCj4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9w
cy5jICAgfCAgIDIgKy0NCj4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC91
dGlsLmMgfCAxMDMgKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBkcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0dzg4L3V0aWwuaCB8ICAxMiArKy0NCj4gPiAgNCBmaWxlcyBjaGFuZ2Vk
LCAxMTYgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gSSBjb21wYXJlZCB0aGUgY2hh
bmdlcyBmcm9tIHRoaXMgcGF0Y2ggd2l0aCBteSBlYXJsaWVyIHdvcmsuIEkgd291bGQNCj4gbGlr
ZSB0byBoaWdobGlnaHQgYSBmZXcgZnVuY3Rpb25zIHRvIHVuZGVyc3RhbmQgaWYgdGhleSB3ZXJl
IGxlZnQgb3V0DQo+IG9uIHB1cnBvc2Ugb3IgYnkgYWNjaWRlbnQuDQo+IA0KPiBfX2Z3X3JlY292
ZXJ5X3dvcmsoKSBpbiBtYWluLmMgKHVuZm9ydHVuYXRlbHkgSSBhbSBub3Qgc3VyZSBob3cgdG8N
Cj4gdHJpZ2dlci90ZXN0IHRoaXMgImZpcm13YXJlIHJlY292ZXJ5IiBsb2dpYyk6DQoNClRoaXMg
Y2FuIGJlIHRyaWdnZXJlZCBieSAnZWNobyAxID4gL3N5cy9rZXJuZWwvZGVidWcvaWVlZTgwMjEx
L3J0dzg4L2Z3X2NyYXNoJywNCmJ1dCBvbmx5IHRoZSBsYXRlc3QgZmlybXdhcmUgb2YgODgyMmMg
Y2FuIHN1cHBvcnQgdGhpcy4NCg0KPiAtIHRoaXMgaXMgYWxyZWFkeSBjYWxsZWQgd2l0aCAmcnR3
ZGV2LT5tdXRleCBoZWxkDQo+IC0gaXQgdXNlcyBydHdfaXRlcmF0ZV9rZXlzX3JjdSgpICh3aGlj
aCBpbnRlcm5hbGx5IHVzZXMgcnR3X3dyaXRlMzINCj4gZnJvbSBydHdfc2VjX2NsZWFyX2NhbSku
IGZlZWwgZnJlZSB0byBlaXRoZXIgYWRkIFswXSB0byB5b3VyIHNlcmllcyBvcg0KPiBldmVuIHNx
dWFzaCBpdCBpbnRvIGFuIGV4aXN0aW5nIHBhdGNoDQoNCmllZWU4MDIxMV9pdGVyX2tleXMoKSBj
aGVjayBsb2NrZGVwX2Fzc2VydF93aXBoeShody0+d2lwaHkpLCBidXQgd2UgZG9uJ3QNCmhvbGQg
dGhlIGxvY2sgaW4gdGhpcyB3b3JrOyBpdCBhbHNvIGRvIG11dGV4X2xvY2soJmxvY2FsLT5rZXlf
bXR4KSB0aGF0IA0KSSdtIGFmcmFpZCBpdCBjb3VsZCBjYXVzZSBkZWFkbG9jay4NCiANClNvLCBJ
IHRoaW5rIHdlIGNhbiB1c2UgX3JjdSB2ZXJzaW9uIHRvIGNvbGxlY3Qga2V5IGxpc3QgbGlrZSBz
dGEgYW5kIHZpZi4NCg0KPiAtIGl0IHVzZXMgcnR3X2l0ZXJhdGVfc3Rhc19hdG9taWMoKSAod2hp
Y2ggaW50ZXJuYWxseSB1c2VzDQo+IHJ0d19md19zZW5kX2gyY19jb21tYW5kIGZyb20gcnR3X2Z3
X21lZGlhX3N0YXR1c19yZXBvcnQpDQo+IC0gaXQgdXNlcyBydHdfaXRlcmF0ZV92aWZzX2F0b21p
YygpICh3aGljaCBpbnRlcm5hbGx5IGNhbiByZWFkL3dyaXRlDQo+IHJlZ2lzdGVycyBmcm9tIHJ0
d19jaGlwX2NvbmZpZ19iZmVlKQ0KPiAtIGluIG15IHByZXZpb3VzIHNlcmllcyBJIHNpbXBseSBy
ZXBsYWNlZCB0aGUNCj4gcnR3X2l0ZXJhdGVfc3Rhc19hdG9taWMoKSBhbmQgcnR3X2l0ZXJhdGVf
dmlmc19hdG9taWMoKSBjYWxscyB3aXRoIHRoZQ0KPiBub24tYXRvbWljIHZhcmlhbnRzIChmb3Ig
dGhlIHJ0d19pdGVyYXRlX2tleXNfcmN1KCkgY2FsbCBJIGRpZCBzb21lDQo+IGV4dHJhIGNsZWFu
dXAsIHNlZSBbMF0pDQo+IA0KPiBydHdfd293X2Z3X21lZGlhX3N0YXR1cygpIGluIHdvdy5jICh1
bmZvcnR1bmF0ZWx5IEkgYW0gYWxzbyBub3Qgc3VyZQ0KPiBob3cgdG8gdGVzdCBXb1dMQU4pOg0K
PiAtIEkgYW0gbm90IHN1cmUgaWYgJnJ0d2Rldi0+bXV0ZXggaXMgaGVsZCB3aGVuIHRoaXMgZnVu
Y3Rpb24gaXMgY2FsbGVkDQo+IC0gaXQgdXNlcyBydHdfaXRlcmF0ZV9zdGFzX2F0b21pYygpICh3
aGljaCBpbnRlcm5hbGx5IHVzZXMNCj4gcnR3X2Z3X3NlbmRfaDJjX2NvbW1hbmQgZnJvbSBydHdf
ZndfbWVkaWFfc3RhdHVzX3JlcG9ydCkNCj4gLSBpbiBteSBwcmV2aW91cyBzZXJpZXMgSSBzaW1w
bHkgcmVwbGFjZWQgcnR3X2l0ZXJhdGVfc3Rhc19hdG9taWMoKQ0KPiB3aXRoIGl0J3Mgbm9uLWF0
b21pYyB2YXJpYW50DQo+IA0KPiBBZGRpdGlvbmFsbHkgSSByZWJhc2VkIG15IFNESU8gd29yayBv
biB0b3Agb2YgeW91ciBVU0Igc2VyaWVzLg0KPiBUaGlzIG1ha2VzIFNESU8gc3VwcG9ydCBhIGxv
dCBlYXNpZXIgLSBzbyB0aGFuayB5b3UgZm9yIHlvdXIgd29yayENCj4gSSBmb3VuZCB0aGF0IHRo
cmVlIG9mIG15IHByZXZpb3VzIHBhdGNoZXMgKGluIGFkZGl0aW9uIHRvIFswXSB3aGljaCBJDQo+
IGFscmVhZHkgbWVudGlvbmVkIGVhcmxpZXIpIGFyZSBzdGlsbCBuZWVkZWQgdG8gZ2V0IHJpZCBv
ZiBzb21lDQo+IHdhcm5pbmdzIHdoZW4gdXNpbmcgdGhlIFNESU8gaW50ZXJmYWNlICh0aGUgc2Ft
ZSB3YXJuaW5ncyBtYXkgb3IgbWF5DQo+IG5vdCBiZSB0aGVyZSB3aXRoIHRoZSBVU0IgaW50ZXJm
YWNlIC0gaXQganVzdCBkZXBlbmRzIG9uIHdoZXRoZXIgeW91cg0KPiBBUCBtYWtlcyBydHc4OCBo
aXQgdGhhdCBzcGVjaWZpYyBjb2RlLXBhdGgpOg0KPiAtIFsxXTogcnR3ODg6IENvbmZpZ3VyZSB0
aGUgcmVnaXN0ZXJzIGZyb20gcnR3X2JmX2Fzc29jKCkgb3V0c2lkZSB0aGUgUkNVIGxvY2sNCg0K
SSB0aGluayB3ZSBuZWVkIHRoaXMuDQoNCj4gLSBbMl06IHJ0dzg4OiBNb3ZlIHJ0d19jaGlwX2Nm
Z19jc2lfcmF0ZSgpIG91dCBvZiBydHdfdmlmX3dhdGNoX2RvZ19pdGVyKCkNCg0KSSB0aGluayB3
ZSBkb24ndCBuZWVkIHRoaXMsIGJ1dCBqdXN0IHVzZSBydHdfaXRlcmF0ZV92aWZzKCkgdG8NCml0
ZXJhdGUgcnR3X3ZpZl93YXRjaF9kb2dfaXRlci4NCg0KPiAtIFszXTogcnR3ODg6IE1vdmUgcnR3
X3VwZGF0ZV9zdGFfaW5mbygpIG91dCBvZiBydHdfcmFfbWFza19pbmZvX3VwZGF0ZV9pdGVyKCkN
Cg0KTmVlZCBwYXJ0aWFsIC0tIGhvbGQgcnR3ZGV2LT5tdXRleCBiZWZvcmUgZW50ZXJpbmcgcnR3
X3JhX21hc2tfaW5mb191cGRhdGUoKS4NCg0KVGhlbiwgdXNlIHJ0d19pdGVyYXRlX3N0YXMoKSB0
byBpdGVyYXRlIHJ0d19yYV9tYXNrX2luZm9fdXBkYXRlX2l0ZXIuIA0KTm8gbmVlZCBvdGhlcnMu
DQoNCg0KU2FzY2hhLCBjb3VsZCB5b3Ugc3F1YXNoIE1hcnRpbidzIHBhdGNoZXMgaW50byB5b3Vy
IHBhdGNoc2V0Pw0KQW5kLCB0aGVuIEkgY2FuIGRvIG1vcmUgdGVzdHMgb24gUENJIGNhcmRzLg0K
DQpJIGRvIGxvbmcgcnVuIG9uIDg4MjJDRSB3aXRoIHRoZSBwYXRjaHNldCB2Mi4gSXQgd29ya3Mg
ZmluZS4NCkFmdGVyIGFkZGluZyBtb3JlLCBJIHdpbGwgdmVyaWZ5IGl0IGFnYWluLg0KDQpCeSB0
aGUgd2F5LCBJIHN0aWxsIGRvbid0IGhhdmUgcmVzb3VyY2UgdG8gY2hlY2sgUFMgb2YgODgyMkNV
Lg0KU29ycnkgZm9yIHRoYXQuDQoNClBpbmctS2UNCg0K
