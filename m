Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF652C33B8
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgKXWOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:14:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:20685 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727231AbgKXWOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:14:03 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-24-ARMfIDgYMr6SDVQlc73CZg-1; Tue, 24 Nov 2020 22:12:53 +0000
X-MC-Unique: ARMfIDgYMr6SDVQlc73CZg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 24 Nov 2020 22:12:53 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 24 Nov 2020 22:12:53 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Arnd Bergmann' <arnd@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: RE: [PATCH v4 2/4] net: socket: rework SIOC?IFMAP ioctls
Thread-Topic: [PATCH v4 2/4] net: socket: rework SIOC?IFMAP ioctls
Thread-Index: AQHWwnVjvwCYtog5HkymKKDHI5XK+KnXcZmAgAAzHACAADK4AA==
Date:   Tue, 24 Nov 2020 22:12:52 +0000
Message-ID: <1a3a227b8cb643e99fd79ce15610c4b2@AcuMS.aculab.com>
References: <20201124151828.169152-1-arnd@kernel.org>
 <20201124151828.169152-3-arnd@kernel.org>
 <e86a5d8a3aed44139010dac219dfcf08@AcuMS.aculab.com>
 <CAK8P3a08F1Xk2Vz69CUN=sJcBkqZvcrkd06qrmG3SMR8VhBN4A@mail.gmail.com>
In-Reply-To: <CAK8P3a08F1Xk2Vz69CUN=sJcBkqZvcrkd06qrmG3SMR8VhBN4A@mail.gmail.com>
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

RnJvbTogQXJuZCBCZXJnbWFubg0KPiBTZW50OiAyNCBOb3ZlbWJlciAyMDIwIDE5OjA2DQo+IA0K
PiBPbiBUdWUsIE5vdiAyNCwgMjAyMCBhdCA1OjEzIFBNIERhdmlkIExhaWdodCA8RGF2aWQuTGFp
Z2h0QGFjdWxhYi5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogQXJuZCBCZXJnbWFubg0KPiA+
ID4gU2VudDogMjQgTm92ZW1iZXIgMjAyMCAxNToxOA0KPiA+ID4NCj4gPiA+IFNJT0NHSUZNQVAg
YW5kIFNJT0NTSUZNQVAgY3VycmVudGx5IHJlcXVpcmUgY29tcGF0X2FsbG9jX3VzZXJfc3BhY2Uo
KQ0KPiA+ID4gYW5kIGNvcHlfaW5fdXNlcigpIGZvciBjb21wYXQgbW9kZS4NCj4gPiA+DQo+ID4g
PiBNb3ZlIHRoZSBjb21wYXQgaGFuZGxpbmcgaW50byB0aGUgbG9jYXRpb24gd2hlcmUgdGhlIHN0
cnVjdHVyZXMgYXJlDQo+ID4gPiBhY3R1YWxseSB1c2VkLCB0byBhdm9pZCB1c2luZyB0aG9zZSBp
bnRlcmZhY2VzIGFuZCBnZXQgYSBjbGVhcmVyDQo+ID4gPiBpbXBsZW1lbnRhdGlvbi4NCj4gPiA+
DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiA+
ID4gLS0tDQo+ID4gPiBjaGFuZ2VzIGluIHYzOg0KPiA+ID4gIC0gY29tcGxldGUgcmV3cml0ZQ0K
PiA+IC4uLg0KPiA+ID4gIGluY2x1ZGUvbGludXgvY29tcGF0LmggfCAxOCArKysrKystLS0tLS0N
Cj4gPiA+ICBuZXQvY29yZS9kZXZfaW9jdGwuYyAgIHwgNjQgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tDQo+ID4gPiAgbmV0L3NvY2tldC5jICAgICAgICAgICB8IDM5
ICsrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDYyIGlu
c2VydGlvbnMoKyksIDU5IGRlbGV0aW9ucygtKQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2NvbXBhdC5oIGIvaW5jbHVkZS9saW51eC9jb21wYXQuaA0KPiA+ID4gaW5k
ZXggMDhkYmQzNGJiN2E1Li40NzQ5NmM1ZWI1ZWIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRl
L2xpbnV4L2NvbXBhdC5oDQo+ID4gPiArKysgYi9pbmNsdWRlL2xpbnV4L2NvbXBhdC5oDQo+ID4g
PiBAQCAtOTYsNiArOTYsMTUgQEAgc3RydWN0IGNvbXBhdF9pb3ZlYyB7DQo+ID4gPiAgICAgICBj
b21wYXRfc2l6ZV90ICAgaW92X2xlbjsNCj4gPiA+ICB9Ow0KPiA+ID4NCj4gPiA+ICtzdHJ1Y3Qg
Y29tcGF0X2lmbWFwIHsNCj4gPiA+ICsgICAgIGNvbXBhdF91bG9uZ190IG1lbV9zdGFydDsNCj4g
PiA+ICsgICAgIGNvbXBhdF91bG9uZ190IG1lbV9lbmQ7DQo+ID4gPiArICAgICB1bnNpZ25lZCBz
aG9ydCBiYXNlX2FkZHI7DQo+ID4gPiArICAgICB1bnNpZ25lZCBjaGFyIGlycTsNCj4gPiA+ICsg
ICAgIHVuc2lnbmVkIGNoYXIgZG1hOw0KPiA+ID4gKyAgICAgdW5zaWduZWQgY2hhciBwb3J0Ow0K
PiA+ID4gK307DQo+ID4NCj4gPiBJc24ndCB0aGUgb25seSBkaWZmZXJlbmNlIHRoZSBudW1iZXIg
b2YgcGFkIGJ5dGVzIGF0IHRoZSBlbmQ/DQo+IA0KPiBObywgdGhlIG1haW4gZGlmZmVyZW5jZSBp
cyBpbiB0aGUgZmlyc3QgdHdvIGZpZWxkcywgd2hpY2ggYXJlDQo+ICd1bnNpZ25lZCBsb25nJyBh
bmQgdGhlcmVmb3JlIGRpZmZlcmVudC4gVGhlIHRocmVlLWJ5dGUgcGFkZGluZw0KPiBpcyBpbiBm
YWN0IHRoZSBzYW1lIG9uIGFsbCBhcmNoaXRlY3R1cmVzIChpbmNsdWRpbmcgeDg2KSB0aGF0DQo+
IGhhdmUgYSBjb21wYXQgbW9kZSwgdGhvdWdoIGl0IG1pZ2h0IGJlIGRpZmZlcmVudCBvbg0KPiBt
NjhrIGFuZCBhcm0tb2FiaSwgd2hpY2ggaGF2ZSBzbGlnaHRseSBzcGVjaWFsIHN0cnVjdA0KPiBh
bGlnbm1lbnQgcnVsZXMuDQo+IA0KPiBJdCBjb3VsZCBiZSBkb25lIHdpdGggdHdvIGFzc2lnbm1l
bnRzIGFuZCBhIG1lbWNweSwgYnV0DQo+IEkgbGlrZSB0aGUgaW5kaXZpZHVhbCBhc3NpZ25tZW50
cyBiZXR0ZXIgaGVyZS4NCg0KR2FoIG15IGJyYWluIGh1cnRzIHRvZGF5Lg0KSSB3YXMganVzdCB0
aGlua2luZyBvZiB0aGUgYWxpZ25tZW50IGFuZCBwYWRkaW5nLCBub3QgdGhlIHNpemVzLg0KDQpZ
b3UgY291bGQgcmVhZCB0aGUgY29tcGF0IHN0cnVjdHVyZSB0byAnbWVtX2VuZCcgYW5kDQp0aGVu
IG1vdmUgdGhlIGZpcnN0IHR3byBmaWVsZHMgZm9yd2FyZC4NCkJ1dCwgSSBndWVzcywgdGhpcyBz
dHJ1Y3R1cmUgZG9lc24ndCBoYXZlIG1hbnkgZmllbGRzLg0KDQpXaGF0IHlvdSByZWFsbHkgbmVl
ZCBmb3IgdGhlc2UgY29waWVzIGlzIENPQk9MJ3MgJ21vdmUgY29ycmVzcG9uZGluZycuDQooV2hp
Y2ggd2Fzbid0IGltcGxlbWVudGVkIGJ5IHRoZSBvbmx5IENPQk9MIGNvbXBpbGVyIEkndmUgdXNl
ZC4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBS
b2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9u
IE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

