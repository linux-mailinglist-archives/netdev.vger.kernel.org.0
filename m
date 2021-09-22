Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF4B414D84
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 17:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhIVPz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 11:55:58 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:42053 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235014AbhIVPz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 11:55:57 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-50-67rf-bCINT6N378a70FgGQ-1; Wed, 22 Sep 2021 16:54:25 +0100
X-MC-Unique: 67rf-bCINT6N378a70FgGQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Wed, 22 Sep 2021 16:54:24 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Wed, 22 Sep 2021 16:54:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J1BhbGkgUm9ow6FyJw==?= <pali@kernel.org>
CC:     =?utf-8?B?J0pvbmFzIERyZcOfbGVyJw==?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Tsuchiya Yuto" <kitakar@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Thread-Topic: [PATCH v2 1/2] mwifiex: Use non-posted PCI write when setting TX
 ring write pointer
Thread-Index: AQHXqV6M5O4Kbg53iUSKSfgcb2dqbquwGdzg///+kQCAACPEAA==
Date:   Wed, 22 Sep 2021 15:54:24 +0000
Message-ID: <e0a4e0adc56148039f853ccb083be53a@AcuMS.aculab.com>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-2-verdre@v0yd.nl>
 <8f65f41a807c46d496bf1b45816077e4@AcuMS.aculab.com>
 <20210922142726.guviqler5k7wnm52@pali>
In-Reply-To: <20210922142726.guviqler5k7wnm52@pali>
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

DQpGcm9tOiBQYWxpIFJvaMOhcg0KPiBTZW50OiAyMiBTZXB0ZW1iZXIgMjAyMSAxNToyNw0KPiAN
Cj4gT24gV2VkbmVzZGF5IDIyIFNlcHRlbWJlciAyMDIxIDE0OjAzOjI1IERhdmlkIExhaWdodCB3
cm90ZToNCj4gPiBGcm9tOiBKb25hcyBEcmXDn2xlcg0KPiA+ID4gU2VudDogMTQgU2VwdGVtYmVy
IDIwMjEgMTI6NDgNCj4gPiA+DQo+ID4gPiBPbiB0aGUgODhXODg5NyBjYXJkIGl0J3MgdmVyeSBp
bXBvcnRhbnQgdGhlIFRYIHJpbmcgd3JpdGUgcG9pbnRlciBpcw0KPiA+ID4gdXBkYXRlZCBjb3Jy
ZWN0bHkgdG8gaXRzIG5ldyB2YWx1ZSBiZWZvcmUgc2V0dGluZyB0aGUgVFggcmVhZHkNCj4gPiA+
IGludGVycnVwdCwgb3RoZXJ3aXNlIHRoZSBmaXJtd2FyZSBhcHBlYXJzIHRvIGNyYXNoIChwcm9i
YWJseSBiZWNhdXNlDQo+ID4gPiBpdCdzIHRyeWluZyB0byBETUEtcmVhZCBmcm9tIHRoZSB3cm9u
ZyBwbGFjZSkuIFRoZSBpc3N1ZSBpcyBwcmVzZW50IGluDQo+ID4gPiB0aGUgbGF0ZXN0IGZpcm13
YXJlIHZlcnNpb24gMTUuNjguMTkucDIxIG9mIHRoZSBwY2llK3VzYiBjYXJkLg0KPiA+ID4NCj4g
PiA+IFNpbmNlIFBDSSB1c2VzICJwb3N0ZWQgd3JpdGVzIiB3aGVuIHdyaXRpbmcgdG8gYSByZWdp
c3RlciwgaXQncyBub3QNCj4gPiA+IGd1YXJhbnRlZWQgdGhhdCBhIHdyaXRlIHdpbGwgaGFwcGVu
IGltbWVkaWF0ZWx5LiBUaGF0IG1lYW5zIHRoZSBwb2ludGVyDQo+ID4gPiBtaWdodCBiZSBvdXRk
YXRlZCB3aGVuIHNldHRpbmcgdGhlIFRYIHJlYWR5IGludGVycnVwdCwgbGVhZGluZyB0bw0KPiA+
ID4gZmlybXdhcmUgY3Jhc2hlcyBlc3BlY2lhbGx5IHdoZW4gQVNQTSBMMSBhbmQgTDEgc3Vic3Rh
dGVzIGFyZSBlbmFibGVkDQo+ID4gPiAoYmVjYXVzZSBvZiB0aGUgaGlnaGVyIGxpbmsgbGF0ZW5j
eSwgdGhlIHdyaXRlIHdpbGwgcHJvYmFibHkgdGFrZQ0KPiA+ID4gbG9uZ2VyKS4NCj4gPiA+DQo+
ID4gPiBTbyBmaXggdGhvc2UgZmlybXdhcmUgY3Jhc2hlcyBieSBhbHdheXMgdXNpbmcgYSBub24t
cG9zdGVkIHdyaXRlIGZvcg0KPiA+ID4gdGhpcyBzcGVjaWZpYyByZWdpc3RlciB3cml0ZS4gV2Ug
ZG8gdGhhdCBieSBzaW1wbHkgcmVhZGluZyBiYWNrIHRoZQ0KPiA+ID4gcmVnaXN0ZXIgYWZ0ZXIg
d3JpdGluZyBpdCwganVzdCBhcyBhIGZldyBvdGhlciBQQ0kgZHJpdmVycyBkby4NCj4gPiA+DQo+
ID4gPiBUaGlzIGZpeGVzIGEgYnVnIHdoZXJlIGR1cmluZyByeC90eCB0cmFmZmljIGFuZCB3aXRo
IEFTUE0gTDEgc3Vic3RhdGVzDQo+ID4gPiBlbmFibGVkICh0aGUgZW5hYmxlZCBzdWJzdGF0ZXMg
YXJlIHBsYXRmb3JtIGRlcGVuZGVudCksIHRoZSBmaXJtd2FyZQ0KPiA+ID4gY3Jhc2hlcyBhbmQg
ZXZlbnR1YWxseSBhIGNvbW1hbmQgdGltZW91dCBhcHBlYXJzIGluIHRoZSBsb2dzLg0KPiA+DQo+
ID4gSSB0aGluayB5b3UgbmVlZCB0byBjaGFuZ2UgeW91ciB0ZXJtaW5vbG9neS4NCj4gPiBQQ0ll
IGRvZXMgaGF2ZSBzb21lIG5vbi1wb3N0ZWQgd3JpdGUgdHJhbnNhY3Rpb25zIC0gYnV0IEkgY2Fu
J3QNCj4gPiByZW1lbWJlciB3aGVuIHRoZXkgYXJlIHVzZWQuDQo+IA0KPiBJbiBQQ0llIGFyZSBh
bGwgbWVtb3J5IHdyaXRlIHJlcXVlc3RzIGFzIHBvc3RlZC4NCj4gDQo+IE5vbi1wb3N0ZWQgd3Jp
dGVzIGluIFBDSWUgYXJlIHVzZWQgb25seSBmb3IgSU8gYW5kIGNvbmZpZyByZXF1ZXN0cy4gQnV0
DQo+IHRoaXMgaXMgbm90IGNhc2UgZm9yIHByb3Bvc2VkIHBhdGNoIGNoYW5nZSBhcyBpdCBhY2Nl
c3Mgb25seSBjYXJkJ3MNCj4gbWVtb3J5IHNwYWNlLg0KPiANCj4gVGVjaG5pY2FsbHkgdGhpcyBw
YXRjaCBkb2VzIG5vdCB1c2Ugbm9uLXBvc3RlZCBtZW1vcnkgd3JpdGUgKGFzIFBDSWUNCj4gZG9l
cyBub3Qgc3VwcG9ydCAvIHByb3ZpZGUgaXQpLCBqdXN0IGFkZHMgc29tZXRoaW5nIGxpa2UgYSBi
YXJyaWVyIGFuZA0KPiBJJ20gbm90IHN1cmUgaWYgaXQgaXMgcmVhbGx5IGNvcnJlY3QgKHlvdSBh
bHJlYWR5IHdyb3RlIG1vcmUgZGV0YWlscw0KPiBhYm91dCBpdCwgc28gSSB3aWxsIGxldCBpdCBi
ZSkuDQo+IA0KPiBJJ20gbm90IHN1cmUgd2hhdCBpcyB0aGUgY29ycmVjdCB0ZXJtaW5vbG9neSwg
SSBkbyBub3Qga25vdyBob3cgdGhpcw0KPiBraW5kIG9mIHdyaXRlLWZvbGxvd2VkLWJ5LXJlYWQg
InRyaWNrIiBpcyBjb3JyZWN0bHkgY2FsbGVkLg0KDQpJIHRoaW5rIGl0IGlzIHByb2JhYmx5IGJl
c3QgdG8gc2F5Og0KICAgImZsdXNoIHRoZSBwb3N0ZWQgd3JpdGUgd2hlbiBzZXR0aW5nIHRoZSBU
WCByaW5nIHdyaXRlIHBvaW50ZXIiLg0KDQpUaGUgd3JpdGUgY2FuIGdldCBwb3N0ZWQgaW4gYW55
L2FsbCBvZiB0aGUgZm9sbG93aW5nIHBsYWNlczoNCjEpIFRoZSBjcHUgc3RvcmUgYnVmZmVyLg0K
MikgVGhlIFBDSWUgaG9zdCBicmlkZ2UuDQozKSBBbnkgb3RoZXIgUENJZSBicmlkZ2VzLg0KNCkg
VGhlIFBDSWUgc2xhdmUgbG9naWMgaW4gdGhlIHRhcmdldC4NCiAgIFRoZXJlIGNvdWxkIGJlIHNl
cGFyYXRlIGJ1ZmZlcnMgZm9yIGVhY2ggQkFSLA0KNSkgVGhlIGFjdHVhbCB0YXJnZXQgbG9naWMg
Zm9yIHRoYXQgYWRkcmVzcyBibG9jay4NCiAgIFRoZSB0YXJnZXQgKHByb2JhYmx5KSB3aWxsIGxv
b2sgYSBiaXQgbGlrZSBhbiBvbGQgZmFzaGlvbmVkIGNwdQ0KICAgbW90aGVyYm9hcmQgd2l0aCB0
aGUgUENJZSBzbGF2ZSBsb2dpYyBhcyB0aGUgbWFpbiBidXMgbWFzdGVyLg0KDQpUaGUgcmVhZGJh
Y2sgZm9yY2VzIGFsbCB0aGUgcG9zdGVkIHdyaXRlIGJ1ZmZlcnMgYmUgZmx1c2hlZC4NCg0KSW4g
dGhpcyBjYXNlIEkgc3VzcGVjdCBpdCBpcyBlaXRoZXIgZmx1c2hpbmcgKDUpIG9yIHRoZSBleHRy
YQ0KZGVsYXkgb2YgdGhlIHJlYWQgVExQIHByb2Nlc3NpbmcgdGhhdCAnZml4ZXMnIHRoZSBwcm9i
bGVtLg0KDQpOb3RlIHRoYXQgZGVwZW5kaW5nIG9uIHRoZSBleGFjdCBjb2RlIGFuZCBob3N0IGNw
dSB0aGUgc2Vjb25kDQp3cml0ZSBtYXkgbm90IG5lZWQgdG8gd2FpdCBmb3IgdGhlIHJlc3BvbnNl
IHRvIHRoZSByZWFkIFRMUC4NClNvIHRoZSB3cml0ZSwgcmVhZGJhY2ssIHdyaXRlIFRMUCBtYXkg
YmUgYmFjayB0byBiYWNrIG9uIHRoZQ0KYWN0dWFsIFBDSWUgbGluay4NCg0KQWx0aG91Z2ggSSBk
b24ndCBoYXZlIGFjY2VzcyB0byBhbiBhY3R1YWwgUENJZSBtb25pdG9yIHdlDQpkbyBoYXZlIHRo
ZSBhYmlsaXR5IHRvIHRyYWNlICdkYXRhJyBUTFAgaW50byBmcGdhIG1lbW9yeQ0Kb24gb25lIG9m
IG91ciBzeXN0ZW1zLg0KVGhpcyBpcyBuZWFyIHJlYWwtdGltZSBidXQgdGhleSBhcmUgc2xpZ2h0
bHkgbXVuZ2VkLg0KV2F0Y2hpbmcgdGhlIFRMUCBjYW4gYmUgaWxsdW1pbmF0aW5nIQ0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

