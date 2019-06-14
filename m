Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4745CF4
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 14:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfFNMh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 08:37:56 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:29344 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727544AbfFNMh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 08:37:56 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-213-0gn1Q4tvNMyM3Cl0DIQUng-1; Fri, 14 Jun 2019 13:37:53 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri,
 14 Jun 2019 13:37:53 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 14 Jun 2019 13:37:53 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ard Biesheuvel' <ard.biesheuvel@linaro.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
CC:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: RE: [RFC PATCH] net: ipv4: move tcp_fastopen server side code to
 SipHash library
Thread-Topic: [RFC PATCH] net: ipv4: move tcp_fastopen server side code to
 SipHash library
Thread-Index: AQHVIqJ4o+VgbHBQRkWOOrrkh1L6uaabFnAA
Date:   Fri, 14 Jun 2019 12:37:53 +0000
Message-ID: <6c21f1d9b4f54f1a82a98c9a4971e493@AcuMS.aculab.com>
References: <20190614111407.26725-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu8SoEbsLyP5GWV+qX_F=z-yT67xdQJEeo2Vuaf2tt2+Qw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8SoEbsLyP5GWV+qX_F=z-yT67xdQJEeo2Vuaf2tt2+Qw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: 0gn1Q4tvNMyM3Cl0DIQUng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQXJkIEJpZXNoZXV2ZWwNCj4gU2VudDogMTQgSnVuZSAyMDE5IDEyOjE1DQo+IChmaXgg
RXJpYydzIGVtYWlsIGFkZHJlc3MpDQo+IA0KPiBPbiBGcmksIDE0IEp1biAyMDE5IGF0IDEzOjE0
LCBBcmQgQmllc2hldXZlbCA8YXJkLmJpZXNoZXV2ZWxAbGluYXJvLm9yZz4gd3JvdGU6DQo+ID4N
Cj4gPiBVc2luZyBhIGJhcmUgYmxvY2sgY2lwaGVyIGluIG5vbi1jcnlwdG8gY29kZSBpcyBhbG1v
c3QgYWx3YXlzIGEgYmFkIGlkZWEsDQo+ID4gbm90IG9ubHkgZm9yIHNlY3VyaXR5IHJlYXNvbnMg
KGFuZCB3ZSd2ZSBzZWVuIHNvbWUgZXhhbXBsZXMgb2YgdGhpcyBpbg0KPiA+IHRoZSBrZXJuZWwg
aW4gdGhlIHBhc3QpLCBidXQgYWxzbyBmb3IgcGVyZm9ybWFuY2UgcmVhc29ucy4NCj4gPg0KPiA+
IEluIHRoZSBUQ1AgZmFzdG9wZW4gY2FzZSwgd2UgY2FsbCBpbnRvIHRoZSBiYXJlIEFFUyBibG9j
ayBjaXBoZXIgb25lIG9yDQo+ID4gdHdvIHRpbWVzIChkZXBlbmRpbmcgb24gd2hldGhlciB0aGUg
Y29ubmVjdGlvbiBpcyBJUHY0IG9yIElQdjYpLiBPbiBtb3N0DQo+ID4gc3lzdGVtcywgdGhpcyBy
ZXN1bHRzIGluIGEgY2FsbCBjaGFpbiBzdWNoIGFzDQo+ID4NCj4gPiAgIGNyeXB0b19jaXBoZXJf
ZW5jcnlwdF9vbmUoY3R4LCBkc3QsIHNyYykNCj4gPiAgICAgY3J5cHRvX2NpcGhlcl9jcnQodGZt
KS0+Y2l0X2VuY3J5cHRfb25lKGNyeXB0b19jaXBoZXJfdGZtKHRmbSksIC4uLik7DQo+ID4gICAg
ICAgYWVzbmlfZW5jcnlwdA0KPiA+ICAgICAgICAga2VybmVsX2ZwdV9iZWdpbigpOw0KPiA+ICAg
ICAgICAgYWVzbmlfZW5jKGN0eCwgZHN0LCBzcmMpOyAvLyBhc20gcm91dGluZQ0KPiA+ICAgICAg
ICAga2VybmVsX2ZwdV9lbmQoKTsNCj4gPg0KPiA+IEl0IGlzIGhpZ2hseSB1bmxpa2VseSB0aGF0
IHRoZSB1c2Ugb2Ygc3BlY2lhbCBBRVMgaW5zdHJ1Y3Rpb25zIGhhcyBhDQo+ID4gYmVuZWZpdCBp
biB0aGlzIGNhc2UsIGVzcGVjaWFsbHkgc2luY2Ugd2UgYXJlIGRvaW5nIHRoZSBhYm92ZSB0d2lj
ZQ0KPiA+IGZvciBJUHY2IGNvbm5lY3Rpb25zLCBpbnN0ZWFkIG9mIHVzaW5nIGEgdHJhbnNmb3Jt
IHdoaWNoIGNhbiBwcm9jZXNzDQo+ID4gdGhlIGVudGlyZSBpbnB1dCBpbiBvbmUgZ28uDQo+ID4N
Cj4gPiBXZSBjb3VsZCBzd2l0Y2ggdG8gdGhlIGNiY21hYyhhZXMpIHNoYXNoLCB3aGljaCB3b3Vs
ZCBhdCBsZWFzdCBnZXQNCj4gPiByaWQgb2YgdGhlIGR1cGxpY2F0ZWQgb3ZlcmhlYWQgaW4gKnNv
bWUqIGNhc2VzIChpLmUuLCB0b2RheSwgb25seQ0KPiA+IGFybTY0IGhhcyBhbiBhY2NlbGVyYXRl
ZCBpbXBsZW1lbnRhdGlvbiBvZiBjYmNtYWMoYWVzKSwgd2hpbGUgeDg2IHdpbGwNCj4gPiBlbmQg
dXAgdXNpbmcgdGhlIGdlbmVyaWMgY2JjbWFjIHRlbXBsYXRlIHdyYXBwaW5nIHRoZSBBRVMtTkkg
Y2lwaGVyLA0KPiA+IHdoaWNoIGJhc2ljYWxseSBlbmRzIHVwIGRvaW5nIGV4YWN0bHkgdGhlIGFi
b3ZlKS4gSG93ZXZlciwgaW4gdGhlIGdpdmVuDQo+ID4gY29udGV4dCwgaXQgbWFrZXMgbW9yZSBz
ZW5zZSB0byB1c2UgYSBsaWdodC13ZWlnaHQgTUFDIGFsZ29yaXRobSB0aGF0DQo+ID4gaXMgbW9y
ZSBzdWl0YWJsZSBmb3IgdGhlIHB1cnBvc2UgYXQgaGFuZCwgc3VjaCBhcyBTaXBIYXNoLg0KPiA+
DQo+ID4gU2luY2UgdGhlIG91dHB1dCBzaXplIG9mIFNpcEhhc2ggYWxyZWFkeSBtYXRjaGVzIG91
ciBjaG9zZW4gdmFsdWUgZm9yDQo+ID4gVENQX0ZBU1RPUEVOX0NPT0tJRV9TSVpFLCBhbmQgZ2l2
ZW4gdGhhdCBpdCBhY2NlcHRzIGFyYml0cmFyeSBpbnB1dA0KPiA+IHNpemVzLCB0aGlzIGdyZWF0
bHkgc2ltcGxpZmllcyB0aGUgY29kZSBhcyB3ZWxsLg0KLi4uDQo+ID4gKyAgICAgICBCVUlMRF9C
VUdfT04oc2l6ZW9mKHNpcGhhc2hfa2V5X3QpICE9IFRDUF9GQVNUT1BFTl9LRVlfTEVOR1RIKTsN
Cj4gPiArICAgICAgIEJVSUxEX0JVR19PTihzaXplb2YodTY0KSAhPSBUQ1BfRkFTVE9QRU5fQ09P
S0lFX1NJWkUpOw0KDQpUaG9zZSBjb21wYXJpc29ucyBhcmUgYmFja3dhcmRzLg0KDQoJRGF2aWQN
Cg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZh
cm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYg
KFdhbGVzKQ0K

