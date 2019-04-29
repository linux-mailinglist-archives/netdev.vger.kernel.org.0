Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50728E3AF
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfD2NZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:25:57 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:28342 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbfD2NZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 09:25:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-91-XpkMDVr_Mp6PD2FTGuRfFg-1; Mon, 29 Apr 2019 14:25:54 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon,
 29 Apr 2019 14:25:53 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 29 Apr 2019 14:25:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Willem de Bruijn' <willemdebruijn.kernel@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "Willem de Bruijn" <willemb@google.com>
Subject: RE: [PATCH net] packet: validate msg_namelen in send directly
Thread-Topic: [PATCH net] packet: validate msg_namelen in send directly
Thread-Index: AQHU/GYe1snsU+6jJ02GK9D6Ic6IaKZS2rOwgAAwtwCAABkQ8A==
Date:   Mon, 29 Apr 2019 13:25:52 +0000
Message-ID: <9e3e74586bdb4ea3bef2848d4ff60fcf@AcuMS.aculab.com>
References: <20190426192735.145633-1-willemdebruijn.kernel@gmail.com>
 <92f9793efb2a4d9fb7973dcb47192c4b@AcuMS.aculab.com>
 <CAF=yD-KKSt+y5AcMrBDv6NUVeMoBVXy11dRJEZ1mDxf-Z5Rw6w@mail.gmail.com>
In-Reply-To: <CAF=yD-KKSt+y5AcMrBDv6NUVeMoBVXy11dRJEZ1mDxf-Z5Rw6w@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: XpkMDVr_Mp6PD2FTGuRfFg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogV2lsbGVtIGRlIEJydWlqbg0KPiBTZW50OiAyOSBBcHJpbCAyMDE5IDEzOjUzDQo+IE9u
IE1vbiwgQXByIDI5LCAyMDE5IGF0IDU6MDAgQU0gRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRA
YWN1bGFiLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBXaWxsZW0gZGUgQnJ1aWpuDQo+ID4g
PiBTZW50OiAyNiBBcHJpbCAyMDE5IDIwOjI4DQo+ID4gPiBQYWNrZXQgc29ja2V0cyBpbiBkYXRh
Z3JhbSBtb2RlIHRha2UgYSBkZXN0aW5hdGlvbiBhZGRyZXNzLiBWZXJpZnkgaXRzDQo+ID4gPiBs
ZW5ndGggYmVmb3JlIHBhc3NpbmcgdG8gZGV2X2hhcmRfaGVhZGVyLg0KPiA+ID4NCj4gPiA+IFBy
aW9yIHRvIDIuNi4xNC1yYzMsIHRoZSBzZW5kIGNvZGUgaWdub3JlZCBzbGxfaGFsZW4uIFRoaXMg
aXMNCj4gPiA+IGVzdGFibGlzaGVkIGJlaGF2aW9yLiBEaXJlY3RseSBjb21wYXJlIG1zZ19uYW1l
bGVuIHRvIGRldi0+YWRkcl9sZW4uDQo+ID4gPg0KPiA+ID4gRml4ZXM6IDZiOGQ5NWYxNzk1YzQg
KCJwYWNrZXQ6IHZhbGlkYXRlIGFkZHJlc3MgbGVuZ3RoIGlmIG5vbi16ZXJvIikNCj4gPiA+IFN1
Z2dlc3RlZC1ieTogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAYWN1bGFiLmNvbT4NCj4gPiA+
IFNpZ25lZC1vZmYtYnk6IFdpbGxlbSBkZSBCcnVpam4gPHdpbGxlbWJAZ29vZ2xlLmNvbT4NCj4g
PiA+IC0tLQ0KPiA+ID4gIG5ldC9wYWNrZXQvYWZfcGFja2V0LmMgfCAxOCArKysrKysrKysrKyst
LS0tLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlv
bnMoLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvbmV0L3BhY2tldC9hZl9wYWNrZXQuYyBi
L25ldC9wYWNrZXQvYWZfcGFja2V0LmMNCj4gPiA+IGluZGV4IDk0MTljNWNmNGRlNWUuLjEzMzAx
ZTM2YjRhMjggMTAwNjQ0DQo+ID4gPiAtLS0gYS9uZXQvcGFja2V0L2FmX3BhY2tldC5jDQo+ID4g
PiArKysgYi9uZXQvcGFja2V0L2FmX3BhY2tldC5jDQo+ID4gPiBAQCAtMjYyNCwxMCArMjYyNCwx
MyBAQCBzdGF0aWMgaW50IHRwYWNrZXRfc25kKHN0cnVjdCBwYWNrZXRfc29jayAqcG8sIHN0cnVj
dCBtc2doZHIgKm1zZykNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzbGxfYWRkcikpKQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgIGdvdG8g
b3V0Ow0KPiA+ID4gICAgICAgICAgICAgICBwcm90byAgID0gc2FkZHItPnNsbF9wcm90b2NvbDsN
Cj4gPiA+IC0gICAgICAgICAgICAgYWRkciAgICA9IHNhZGRyLT5zbGxfaGFsZW4gPyBzYWRkci0+
c2xsX2FkZHIgOiBOVUxMOw0KPiA+ID4gICAgICAgICAgICAgICBkZXYgPSBkZXZfZ2V0X2J5X2lu
ZGV4KHNvY2tfbmV0KCZwby0+c2spLCBzYWRkci0+c2xsX2lmaW5kZXgpOw0KPiA+ID4gLSAgICAg
ICAgICAgICBpZiAoYWRkciAmJiBkZXYgJiYgc2FkZHItPnNsbF9oYWxlbiA8IGRldi0+YWRkcl9s
ZW4pDQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgZ290byBvdXRfcHV0Ow0KPiA+ID4gKyAg
ICAgICAgICAgICBpZiAocG8tPnNrLnNrX3NvY2tldC0+dHlwZSA9PSBTT0NLX0RHUkFNKSB7DQo+
ID4gPiArICAgICAgICAgICAgICAgICAgICAgYWRkciA9IHNhZGRyLT5zbGxfYWRkcjsNCj4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICBpZiAoZGV2ICYmIG1zZy0+bXNnX25hbWVsZW4gPCBkZXYt
PmFkZHJfbGVuICsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
b2Zmc2V0b2Yoc3RydWN0IHNvY2thZGRyX2xsLCBzbGxfYWRkcikpDQo+ID4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBnb3RvIG91dF9wdXQ7DQo+ID4gPiArICAgICAgICAgICAgIH0N
Cj4gPg0KPiA+IElJUkMgeW91IG5lZWQgdG8gaW5pdGlhbGlzZSAnYWRkciAtIE5VTEwnIGF0IHRo
ZSB0b3Agb2YgdGhlIGZ1bmN0aW9ucy4NCj4gPiBJJ20gc3VycHJpc2VkIHRoZSBjb21waWxlciBk
b2Vzbid0IGNvbXBsYWluLg0KPiANCj4gSXQgZGlkIGNvbXBsYWluIHdoZW4gSSBtb3ZlZCBpdCBi
ZWxvdyB0aGUgaWYgKGRldiAmJiAuLikgYnJhbmNoLiBCdXQNCj4gaW5zaWRlIGEgYnJhbmNoIHdp
dGggZXhhY3RseSB0aGUgc2FtZSBjb25kaXRpb24gYXMgdGhlIG9uZSB3aGVyZSB1c2VkLA0KPiB0
aGUgY29tcGlsZXIgZGlkIGZpZ3VyZSBpdCBvdXQuIEFkbWl0dGVkbHkgdGhhdCBpcyBmcmFnaWxl
Lg0KDQpFdmVuIGEgZnVuY3Rpb24gY2FsbCBzaG91bGQgYmUgZW5vdWdoIHNpbmNlIHRoZSBjYWxs
ZWQgY29kZSBpcyBhbGxvd2VkDQp0byBtb2RpZnkgcG8tPnNrLnNrX3NvY2tldC0+dHlwZSB2aWEg
YSBnbG9iYWwgcG9pbnRlci4NCg0KPiBUaGVuIGl0IG1pZ2h0IGJlIHNpbXBsZXN0IHRvIHJlc3Rv
cmUgdGhlIHVuY29uZGl0aW9uYWwgYXNzaWdubWVudA0KPiANCj4gICAgICAgICAgICAgICAgIHBy
b3RvICAgPSBzYWRkci0+c2xsX3Byb3RvY29sOw0KPiArICAgICAgICAgICAgICAgYWRkciAgICA9
IHNhZGRyLT5zbGxfYWRkcjsNCj4gICAgICAgICAgICAgICAgIGRldiA9IGRldl9nZXRfYnlfaW5k
ZXgoc29ja19uZXQoc2spLCBzYWRkci0+c2xsX2lmaW5kZXgpOw0KDQpUaGVyZSBpcyBhbiAnYWRk
ciA9IE5VTEwnIGluIHRoZSAnYWRkcmVzcyBhYnNlbnQnIGJyYW5jaC4NCk1vdmluZyB0aGF0IGhp
Z2hlciB1cCBtYWtlcyBpdCBldmVuIG1vcmUgY2xlYXIgdGhhdCB0aGUgYWRkcmVzcyBpcyANCm9u
bHkgc2V0IGluIG9uZSBwbGFjZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

