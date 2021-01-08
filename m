Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844B02EFAC7
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbhAHVyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:54:44 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:55914 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbhAHVyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 16:54:44 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-107-KCHJeWJCOGedzO2ULSD1-w-1; Fri, 08 Jan 2021 21:53:05 +0000
X-MC-Unique: KCHJeWJCOGedzO2ULSD1-w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 8 Jan 2021 21:53:04 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 8 Jan 2021 21:53:04 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Marc Kleine-Budde' <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>
Subject: RE: [net-next 15/19] can: tcan4x5x: rework SPI access
Thread-Topic: [net-next 15/19] can: tcan4x5x: rework SPI access
Thread-Index: AQHW5TrYjuofN1D1dkq5+Uq0gmhgrKoeRRkg
Date:   Fri, 8 Jan 2021 21:53:04 +0000
Message-ID: <2aab5f57ffc2485e99cf04dee6441328@AcuMS.aculab.com>
References: <20210107094900.173046-1-mkl@pengutronix.de>
 <20210107094900.173046-16-mkl@pengutronix.de>
 <20210107110035.42a6bb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210107110656.7e49772b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c98003bf-e62a-ab6a-a526-1f3ed0bb1ab7@pengutronix.de>
In-Reply-To: <c98003bf-e62a-ab6a-a526-1f3ed0bb1ab7@pengutronix.de>
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

RnJvbTogTWFyYyBLbGVpbmUtQnVkZGUNCj4gU2VudDogMDcgSmFudWFyeSAyMDIxIDIxOjE3DQo+
IA0KPiBPbiAxLzcvMjEgODowNiBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24gVGh1
LCA3IEphbiAyMDIxIDExOjAwOjM1IC0wODAwIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+PiBP
biBUaHUsICA3IEphbiAyMDIxIDEwOjQ4OjU2ICswMTAwIE1hcmMgS2xlaW5lLUJ1ZGRlIHdyb3Rl
Og0KPiA+Pj4gK3N0cnVjdCBfX3BhY2tlZCB0Y2FuNHg1eF9tYXBfYnVmIHsNCj4gPj4+ICsJc3Ry
dWN0IHRjYW40eDV4X2J1Zl9jbWQgY21kOw0KPiA+Pj4gKwl1OCBkYXRhWzI1NiAqIHNpemVvZih1
MzIpXTsNCj4gPj4+ICt9IF9fX19jYWNoZWxpbmVfYWxpZ25lZDsNCj4gPj4NCj4gPj4gSW50ZXJl
c3RpbmcgYXR0cmlidXRlIGNvbWJvLCBJIG11c3Qgc2F5Lg0KPiA+DQo+ID4gTG9va2luZyBhdCB0
aGUgcmVzdCBvZiB0aGUgcGF0Y2ggSSBkb24ndCByZWFsbHkgc2VlIGEgcmVhc29uIGZvcg0KPiA+
IF9fcGFja2VkLiAgUGVyaGFwcyBpdCBjYW4gYmUgZHJvcHBlZD8NCj4gDQo+IEl0J3MgdGhlIHN0
cmVhbSBvZiBieXRlcyBzZW5kIHZpYSBTUEkgdG8gdGhlIGNoaXAuIEhlcmUgYXJlIGJvdGggc3Ry
dWN0cyBmb3INCj4gcmVmZXJlbmNlOg0KPiANCj4gPiArc3RydWN0IF9fcGFja2VkIHRjYW40eDV4
X2J1Zl9jbWQgew0KPiA+ICsJdTggY21kOw0KPiA+ICsJX19iZTE2IGFkZHI7DQo+ID4gKwl1OCBs
ZW47DQo+ID4gK307DQo+IA0KPiBUaGlzIGhhcyB0byBiZSBwYWNrZWQsIGFzIEkgYXNzdW1lIHRo
ZSBjb21waWxlciB3b3VsZCBhZGQgc29tZSBzcGFjZSBhZnRlciB0aGUNCj4gInU4IGNtZCIgdG8g
YWxpZ24gdGhlIF9fYmUxNiBuYXR1cmFsbHkuDQoNCldoeSBub3QgZ2VuZXJhdGUgYSBzZXJpZXMg
b2YgMzJiaXQgd29yZHMgdG8gYmUgc2VudCBvdmVyIHRoZSBTUEkgYnVzLg0KU2xpZ2h0bHkgbGVz
cyBmYWZmaW5nIGluIHRoZSBjb2RlLg0KVGhlbiBoYXZlIGEgI2RlZmluZSAob3IgaW5saW5lIGZ1
bmN0aW9uKSB0byBtZXJnZSB0aGUgY21kK2FkZHIrbGVuDQppbnRvIGEgc2luZ2xlIDMyYml0IHdv
cmQuDQoNCkFsc28gaWYgdGhlIGxlbmd0aCBpcyBpbiAzMmJpdCB1bml0cywgdGhlbiB0aGUgZGF0
YVtdIGZpZWxkDQpvdWdodCB0byBiZSB1MzJbXS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQg
QWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVz
LCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

