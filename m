Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FAE414B53
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbhIVOFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:05:02 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:37111 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232709AbhIVOFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 10:05:01 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-13-uoiUTMwGNhufnesDAn2asA-1; Wed, 22 Sep 2021 15:03:28 +0100
X-MC-Unique: uoiUTMwGNhufnesDAn2asA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 22 Sep 2021 15:03:25 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 22 Sep 2021 15:03:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J0pvbmFzIERyZcOfbGVyJw==?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Tsuchiya Yuto <kitakar@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Thread-Topic: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Thread-Index: AQHXqV6M5O4Kbg53iUSKSfgcb2dqbquwGdzg
Date:   Wed, 22 Sep 2021 14:03:25 +0000
Message-ID: <8f65f41a807c46d496bf1b45816077e4@AcuMS.aculab.com>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-2-verdre@v0yd.nl>
In-Reply-To: <20210914114813.15404-2-verdre@v0yd.nl>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9uYXMgRHJlw59sZXINCj4gU2VudDogMTQgU2VwdGVtYmVyIDIwMjEgMTI6NDgNCj4g
DQo+IE9uIHRoZSA4OFc4ODk3IGNhcmQgaXQncyB2ZXJ5IGltcG9ydGFudCB0aGUgVFggcmluZyB3
cml0ZSBwb2ludGVyIGlzDQo+IHVwZGF0ZWQgY29ycmVjdGx5IHRvIGl0cyBuZXcgdmFsdWUgYmVm
b3JlIHNldHRpbmcgdGhlIFRYIHJlYWR5DQo+IGludGVycnVwdCwgb3RoZXJ3aXNlIHRoZSBmaXJt
d2FyZSBhcHBlYXJzIHRvIGNyYXNoIChwcm9iYWJseSBiZWNhdXNlDQo+IGl0J3MgdHJ5aW5nIHRv
IERNQS1yZWFkIGZyb20gdGhlIHdyb25nIHBsYWNlKS4gVGhlIGlzc3VlIGlzIHByZXNlbnQgaW4N
Cj4gdGhlIGxhdGVzdCBmaXJtd2FyZSB2ZXJzaW9uIDE1LjY4LjE5LnAyMSBvZiB0aGUgcGNpZSt1
c2IgY2FyZC4NCj4gDQo+IFNpbmNlIFBDSSB1c2VzICJwb3N0ZWQgd3JpdGVzIiB3aGVuIHdyaXRp
bmcgdG8gYSByZWdpc3RlciwgaXQncyBub3QNCj4gZ3VhcmFudGVlZCB0aGF0IGEgd3JpdGUgd2ls
bCBoYXBwZW4gaW1tZWRpYXRlbHkuIFRoYXQgbWVhbnMgdGhlIHBvaW50ZXINCj4gbWlnaHQgYmUg
b3V0ZGF0ZWQgd2hlbiBzZXR0aW5nIHRoZSBUWCByZWFkeSBpbnRlcnJ1cHQsIGxlYWRpbmcgdG8N
Cj4gZmlybXdhcmUgY3Jhc2hlcyBlc3BlY2lhbGx5IHdoZW4gQVNQTSBMMSBhbmQgTDEgc3Vic3Rh
dGVzIGFyZSBlbmFibGVkDQo+IChiZWNhdXNlIG9mIHRoZSBoaWdoZXIgbGluayBsYXRlbmN5LCB0
aGUgd3JpdGUgd2lsbCBwcm9iYWJseSB0YWtlDQo+IGxvbmdlcikuDQo+IA0KPiBTbyBmaXggdGhv
c2UgZmlybXdhcmUgY3Jhc2hlcyBieSBhbHdheXMgdXNpbmcgYSBub24tcG9zdGVkIHdyaXRlIGZv
cg0KPiB0aGlzIHNwZWNpZmljIHJlZ2lzdGVyIHdyaXRlLiBXZSBkbyB0aGF0IGJ5IHNpbXBseSBy
ZWFkaW5nIGJhY2sgdGhlDQo+IHJlZ2lzdGVyIGFmdGVyIHdyaXRpbmcgaXQsIGp1c3QgYXMgYSBm
ZXcgb3RoZXIgUENJIGRyaXZlcnMgZG8uDQo+IA0KPiBUaGlzIGZpeGVzIGEgYnVnIHdoZXJlIGR1
cmluZyByeC90eCB0cmFmZmljIGFuZCB3aXRoIEFTUE0gTDEgc3Vic3RhdGVzDQo+IGVuYWJsZWQg
KHRoZSBlbmFibGVkIHN1YnN0YXRlcyBhcmUgcGxhdGZvcm0gZGVwZW5kZW50KSwgdGhlIGZpcm13
YXJlDQo+IGNyYXNoZXMgYW5kIGV2ZW50dWFsbHkgYSBjb21tYW5kIHRpbWVvdXQgYXBwZWFycyBp
biB0aGUgbG9ncy4NCg0KSSB0aGluayB5b3UgbmVlZCB0byBjaGFuZ2UgeW91ciB0ZXJtaW5vbG9n
eS4NClBDSWUgZG9lcyBoYXZlIHNvbWUgbm9uLXBvc3RlZCB3cml0ZSB0cmFuc2FjdGlvbnMgLSBi
dXQgSSBjYW4ndA0KcmVtZW1iZXIgd2hlbiB0aGV5IGFyZSB1c2VkLg0KDQpXaGF0IHlvdSBuZWVk
IHRvIHNheSBpcyB0aGF0IHlvdSBhcmUgZmx1c2hpbmcgdGhlIFBDSWUgcG9zdGVkDQp3cml0ZXMg
aW4gb3JkZXIgdG8gYXZvaWQgYSB0aW1pbmcgJ2lzc3VlJyBzZXR0aW5nIHRoZSBUWCByaW5nDQp3
cml0ZSBwb2ludGVyLg0KDQpRdWl0ZSB3aGVyZSB0aGUgYnVnIGlzLCBhbmQgd2h5IHRoZSByZWFk
LWJhY2sgYWN0dWFsbHkgZml4ZXMNCml0IGlzIGFub3RoZXIgbWF0dGVyLg0KDQpBIHR5cGljYWwg
ZXRoZXJuZXQgdHJhbnNtaXQgbmVlZHMgdGhyZWUgdGhpbmdzIHdyaXR0ZW4NCmluIHRoZSBjb3Jy
ZWN0IG9yZGVyIChhcyBzZWVuIGJ5IHRoZSBoYXJkd2FyZSk6DQoNCjEpIFRoZSB0cmFuc21pdCBm
cmFtZSBkYXRhLg0KMikgVGhlIGRlc2NyaXB0b3IgcmluZyBlbnRyeSByZWZlcnJpbmcgdG8gdGhl
IGZyYW1lLg0KMykgVGhlICdwcm9kJyBvZiB0aGUgTUFDIGVuZ2luZSB0byBwcm9jZXNzIHRoZSBm
cmFtZS4NCg0KWW91IHNlZW1zIHRvIGFsc28gaGF2ZToNCjIuNSkgV3JpdGUgdGhlIFRYIHJpbmcg
d3JpdGUgcG9pbnRlciB0byB0aGUgTUFDIGVuZ2luZS4NCg0KVGhlIHVwZGF0ZXMgb2YgKDEpIGFu
ZCAoMikgYXJlIG5vcm1hbGx5IGhhbmRsZXMgYnkgRE1BIGNvaGVyZW50DQptZW1vcnkgb3IgY2Fj
aGUgZmx1c2hlcyBkb25lIGJ5IHVzaW5nIHRoZSBETUEgQVBJcy4NCg0KSWYgdGhlIHdyaXRlcyBm
b3IgKDIuNSkgYW5kICgzKSBhcmUgYm90aCB3cml0aW5nIHRvIHRoZQ0KUENJZSBjYXJkICh3aGlj
aCBzZWVtcyBsaWtlbHkpIHRoZW4gdGhlIFBDSWUgc3BlYyB3aWxsDQpndWFyYW50ZWUgdGhhdCB0
aGV5IGhhcHBlbiBpbiB0aGUgY29ycmVjdCBvcmRlci4NCg0KVGhpcyBtZWFucyB0aGF0IHRoZSBQ
Q0llIHJlYWRiYWNrIG9mIHRoZSAoMi41KSB3cml0ZSBkb2Vzbid0DQpoYXZlIGFueSBlZmZlY3Qg
b24gdGhlIG9yZGVyIG9mIHRoZSBidXMgY3ljbGVzIHNlZW4gYnkgdGhlIGNhcmQuDQpTbyBmbHVz
aGluZyB0aGUgUENJZSB3cml0ZSBpc24ndCB3aGF0IGZpeGVzIHlvdXIgcHJvYmxlbS4NCg0KVGhl
IHJlYWRiYWNrIGJldHdlZW4gKDIuNSkgYW5kICgzKSBkb2VzIGhhdmUgdHdvIGVmZmVjdHM6DQph
KSBpdCBhZGRzIGEgc2hvcnQgZGVsYXkgYmV0d2VlbiB0aGUgdHdvIHdyaXRlcy4NCmIpIGl0IChw
cm9iYWJseSkgZm9yY2VzIHRoZSBmaXJzdCB3cml0ZSB0byBieSBmbHVzaGVkIHRocm91Z2gNCiAg
IGFueSBwb3N0ZWQtd3JpdGUgYnVmZmVycyBvbiB0aGUgY2FyZCBpdHNlbGYuDQoNCkl0IG1heSB3
ZWxsIGJlIHRoYXQgdGhlIGNhcmQgaGFzIHNlcGFyYXRlIHBvc3RlZCB3cml0ZSBidWZmZXJzDQpm
b3IgZGlmZmVyZW50IHBhcnRzIG9mIHRoZSBoYXJkd2FyZS4NCkluIHRoYXQgY2FzZSB0aGUgd3Jp
dGUgKDMpIG1pZ2h0IGdldCBhY3Rpb25lZCBiZWZvcmUgdGhlIHdyaXRlICgyLjUpLg0KT1RPSCB5
b3UnZCBleHBlY3QgdGhhdCB0byBvbmx5IGNhdXNlIHBhY2tldCB0cmFuc21pdCB0byBiZSBkZWxh
eWVkLg0KDQpJZiB0aGUgd3JpdGUgKDIuNSkgZW5kcyB1cCBiZWluZyBub24tYXRvbWljIChpZSBh
IDY0Yml0IHdyaXRlDQpjb252ZXJ0ZWQgdG8gbXVsdGlwbGUgOCBiaXQgd3JpdGVzIGludGVybmFs
bHkpIHRoZW4geW91J2xsIGhpdA0KcHJvYmxlbXMgaWYgdGhlIG1hYyBlbmdpbmUgbG9va3MgYXQg
dGhlIHJlZ2lzdGVyIHdoaWxlIGl0IGlzDQpiZWluZyBjaGFuZ2VkIGp1c3QgYWZ0ZXIgdHJhbnNt
aXR0aW5nIHRoZSBwcmV2aW91cyBwYWNrZXQuDQooaWUgd2hlbiB0aGUgdHggc3RhcnRzIGJlZm9y
ZSB3cml0ZSAoMykgYmVjYXVzZSB0aGUgdHggbG9naWMNCmlzIGFjdGl2ZS4pDQoNClRoZSBvdGhl
ciBob3JyaWQgcG9zc2liaWxpdHkgaXMgdGhhdCB5b3UgaGF2ZSBhIHRydWx5IGJyb2tlbg0KUENJ
ZSBzbGF2ZSB0aGF0IGNvcnJ1cHRzIGl0cyBwb3N0ZWQtd3JpdGUgYnVmZmVyIHdoZW4gYSBzZWNv
bmQNCndyaXRlIGFycml2ZXMuDQpJZiB0aGF0IGlzIGFjdHVhbGx5IHRydWUgdGhlbiB5b3UgbWF5
IG5lZWQgdG8gYWxzbyBhZGQgbG9ja3MNCnRvIGVuc3VyZSB0aGF0IG11bHRpcGxlIHRocmVhZHMg
Y2Fubm90IGRvIHdyaXRlcyBhdCB0aGUgc2FtZSB0aW1lLg0KT3IgZG8gYWxsIChhbmQgSSBtZWFu
IGFsbCkgYWNjZXNzZXMgZnJvbSBhIHNpbmdsZSB0aHJlYWQvY29udGV4dC4NCg0KVGhlIGxhdHRl
ciBwcm9ibGVtIHJlbWluZHMgbWUgb2YgYSBQQ0kgY2FyZCB0aGF0IGdvdCB0ZXJyaWJseQ0KY29u
ZnVzZWQgaWYgaXQgc2F3IGEgcmVhZCByZXF1ZXN0IGZyb20gYSAybmQgY3B1IHdoaWxlIGdlbmVy
YXRpbmcNCidjeWNsZSByZXJ1bicgcmVzcG9uc2VzIHRvIGFuIGVhcmxpZXIgcmVhZCByZXF1ZXN0
Lg0KDQpNb3N0IGNvZGUgdGhhdCBmbHVzaGVzIHBvc3RlZCB3cml0ZXMgb25seSBuZWVkcyB0byBk
byBzbyBmb3INCndyaXRlcyB0aGF0IGRyb3AgbGV2ZWwtc2Vuc2l0aXZlIGludGVycnVwdCByZXF1
ZXN0cy4NCkZhaWx1cmUgdG8gZmx1c2ggdGhvc2UgY2FuIGxlYWQgdG8gdW5leHBlY3RlZCBpbnRl
cnJ1cHRzLg0KVGhhdCBwcm9ibGVtIGdvZXMgYmFjayB0byBWTUVidXMgc3Vub3MgKGFtb25nc3Qg
b3RoZXJzKS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

