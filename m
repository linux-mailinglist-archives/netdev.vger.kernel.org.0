Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0597A96D
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbfG3NXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:23:18 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:43055 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730886AbfG3NXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 09:23:18 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-124-aKarBs_DNLKUOTNrat4LJA-1; Tue, 30 Jul 2019 14:23:14 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 30 Jul 2019 14:23:14 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 30 Jul 2019 14:23:14 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Qian Cai' <cai@lca.pw>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "vyasevich@gmail.com" <vyasevich@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Thread-Topic: [PATCH] net/socket: fix GCC8+ Wpacked-not-aligned warnings
Thread-Index: AQHVRkudEsn++uUNgEOzf6EyOSA1VKbi3DOAgAA4+gCAABEycA==
Date:   Tue, 30 Jul 2019 13:23:14 +0000
Message-ID: <a4b03ad38f104bc0b2f9e256a9cade00@AcuMS.aculab.com>
References: <1564431838-23051-1-git-send-email-cai@lca.pw>
         <91237fd501de4ab895305c4d5666d822@AcuMS.aculab.com>
 <1564492704.11067.28.camel@lca.pw>
In-Reply-To: <1564492704.11067.28.camel@lca.pw>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: aKarBs_DNLKUOTNrat4LJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogUWlhbiBDYWkgDQo+IFNlbnQ6IDMwIEp1bHkgMjAxOSAxNDoxOA0KPiBPbiBUdWUsIDIw
MTktMDctMzAgYXQgMDk6MDEgKzAwMDAsIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBGcm9tOiBR
aWFuIENhaQ0KPiA+ID4gU2VudDogMjkgSnVseSAyMDE5IDIxOjI0DQo+ID4NCj4gPiAuLg0KPiA+
ID4gVG8gZml4IHRoaXMsICJzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSIgbmVlZHMgdG8gYmUgYWxp
Z25lZCB0byA0LWJ5dGUgYXMNCj4gPiA+IGl0IGlzIG9ubHkgdXNlZCBpbiB0aG9zZSBwYWNrZWQg
c2N0cCBzdHJ1Y3R1cmUgd2hpY2ggaXMgcGFydCBvZiBVQVBJLA0KPiA+ID4gYW5kICJzdHJ1Y3Qg
X19rZXJuZWxfc29ja2FkZHJfc3RvcmFnZSIgaXMgdXNlZCBpbiBzb21lIG90aGVyDQo+ID4gPiBw
bGFjZXMgb2YgVUFQSSB0aGF0IG5lZWQgbm90IHRvIGNoYW5nZSBhbGlnbm1lbnRzIGluIG9yZGVy
IHRvIG5vdA0KPiA+ID4gYnJlYWtpbmcgdXNlcnNwYWNlLg0KPiA+ID4NCj4gPiA+IE9uZSBvcHRp
b24gaXMgdXNlIHR5cGVkZWYgYmV0d2VlbiAic29ja2FkZHJfc3RvcmFnZSIgYW5kDQo+ID4gPiAi
X19rZXJuZWxfc29ja2FkZHJfc3RvcmFnZSIgYnV0IGl0IG5lZWRzIHRvIGNoYW5nZSAzNSBvciAz
NzAgbGluZXMgb2YNCj4gPiA+IGNvZGVzLiBUaGUgb3RoZXIgb3B0aW9uIGlzIHRvIGR1cGxpY2F0
ZSB0aGlzIHNpbXBsZSAyLWZpZWxkIHN0cnVjdHVyZSB0bw0KPiA+ID4gaGF2ZSBhIHNlcGFyYXRl
ICJzdHJ1Y3Qgc29ja2FkZHJfc3RvcmFnZSIgc28gaXQgY2FuIHVzZSBhIGRpZmZlcmVudA0KPiA+
ID4gYWxpZ25tZW50IHRoYW4gIl9fa2VybmVsX3NvY2thZGRyX3N0b3JhZ2UiLiBBbHNvIHRoZSBz
dHJ1Y3R1cmUgc2VlbXMNCj4gPiA+IHN0YWJsZSBlbm91Z2gsIHNvIGl0IHdpbGwgYmUgbG93LW1h
aW50ZW5hbmNlIHRvIHVwZGF0ZSB0d28gc3RydWN0dXJlcyBpbg0KPiA+ID4gdGhlIGZ1dHVyZSBp
biBjYXNlIG9mIGNoYW5nZXMuDQo+ID4NCj4gPiBEb2VzIGl0IGFsbCB3b3JrIGlmIHRoZSA4IGJ5
dGUgYWxpZ25tZW50IGlzIGltcGxpY2l0LCBub3QgZXhwbGljaXQ/DQo+ID4gRm9yIGluc3RhbmNl
IGlmIHVubmFtZWQgdW5pb24gYW5kIHN0cnVjdCBhcmUgdXNlZCBlZzoNCj4gPg0KPiA+IHN0cnVj
dCBzb2NrYWRkcl9zdG9yYWdlIHsNCj4gPiAJdW5pb24gew0KPiA+IAkJdm9pZCAqIF9fcHRyO8Kg
wqAvKiBGb3JjZSBhbGlnbm1lbnQgKi8NCj4gPiAJCXN0cnVjdCB7DQo+ID4gCQkJX19rZXJuZWxf
c2FfZmFtaWx5X3QJc3NfZmFtaWx5OwkJLyogYWRkcmVzcyBmYW1pbHkgKi8NCj4gPiAJCQkvKiBG
b2xsb3dpbmcgZmllbGQocykgYXJlIGltcGxlbWVudGF0aW9uIHNwZWNpZmljICovDQo+ID4gCQkJ
Y2hhcglfX2RhdGFbX0tfU1NfTUFYU0laRSAtIHNpemVvZih1bnNpZ25lZCBzaG9ydCldOw0KPiA+
IAkJCQkJLyogc3BhY2UgdG8gYWNoaWV2ZSBkZXNpcmVkIHNpemUsICovDQo+ID4gCQkJCQkvKiBf
U1NfTUFYU0laRSB2YWx1ZSBtaW51cyBzaXplIG9mIHNzX2ZhbWlseSAqLw0KPiA+IAkJfTsNCj4g
PiAJfTsNCj4gPiB9Ow0KPiA+DQo+ID4gSSBzdXNwZWN0IHVubmFtZWQgdW5pb25zIGFuZCBzdHJ1
Y3RzIGhhdmUgdG8gYmUgYWxsb3dlZCBieSB0aGUgY29tcGlsZXIuDQo+IA0KPiBJIGJlbGlldmUg
dGhpcyB3aWxsIHN1ZmZlciB0aGUgc2FtZSBwcm9ibGVtIGluIHRoYXQgd2lsbCBicmVhayBVQVBJ
LA0KPiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDE5MDcyNjIxMzA0NS5HTDYy
MDRAbG9jYWxob3N0LmxvY2FsZG9tYWluLw0KDQpZb3UgYXJlIG1pc3NpbmcgdGhlIGJpdCB3aGVy
ZSB0aGUgVUFQSSBzdHJ1Y3R1cmUgaXMgcGFja2VkLg0KSWYgdGhlIGNvbXBpbGVyIHdvbid0IGxl
dCB5b3UgJ3BhY2snIGEgc3RydWN0dXJlIHRoYXQgY29udGFpbnMgc3RydWN0dXJlcw0KKHJhdGhl
ciB0aGFuIGp1c3QgaW50ZWdlcnMpIHRoZW4gdGhlIGNvbXBpbGVyIGlzIGJyb2tlbiENCg0KVGhl
IGhvcGUgaGVyZSB3YXMgdGhhdCBpdCB3b3VsZCBiZSBvayBpcyB0aGUgYWxpZ25tZW50IHdhcyBp
bXBsaWNpdCBub3QgZXhwbGljaXQuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3Mg
TGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQ
VCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

