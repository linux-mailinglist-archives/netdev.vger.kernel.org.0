Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E43F463
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 12:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfD3KnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 06:43:01 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:53618 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726262AbfD3KnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 06:43:01 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-214-fUhUDUw5N06zvUU-bx0x7w-1; Tue, 30 Apr 2019 11:42:59 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b::d117) by AcuMS.aculab.com
 (fd9f:af1c:a25b::d117) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Tue,
 30 Apr 2019 11:42:58 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 30 Apr 2019 11:42:58 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Josh Elsasser' <jelsasser@appneta.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: RE: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
Thread-Topic: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
Thread-Index: AQHU/sZqyivfda7WEUK+lV099PMxUqZUhJ9Q
Date:   Tue, 30 Apr 2019 10:42:58 +0000
Message-ID: <4b9338513f16457ea167da651c8b997b@AcuMS.aculab.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
 <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
 <6C3E4204-AABF-45AD-B32D-62CB50391D89@appneta.com>
In-Reply-To: <6C3E4204-AABF-45AD-B32D-62CB50391D89@appneta.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: fUhUDUw5N06zvUU-bx0x7w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9zaCBFbHNhc3Nlcg0KPiBTZW50OiAyOSBBcHJpbCAyMDE5IDIxOjAyDQo+IE9uIEFw
ciAyOSwgMjAxOSwgYXQgMTI6MTYgUE0sIEplZmYgS2lyc2hlciA8amVmZnJleS50LmtpcnNoZXJA
aW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gRnJvbTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9w
ZWxAaW50ZWwuY29tPg0KPiA+DQo+ID4gR0NDIHdpbGwgZ2VuZXJhdGUganVtcCB0YWJsZXMgZm9y
IHN3aXRjaC1zdGF0ZW1lbnRzIHdpdGggbW9yZSB0aGFuIDUNCj4gPiBjYXNlIHN0YXRlbWVudHMu
IEFuIGVudHJ5IGludG8gdGhlIGp1bXAgdGFibGUgaXMgYW4gaW5kaXJlY3QgY2FsbCwNCj4gPiB3
aGljaCBtZWFucyB0aGF0IGZvciBDT05GSUdfUkVUUE9MSU5FIGJ1aWxkcywgdGhpcyBpcyByYXRo
ZXINCj4gPiBleHBlbnNpdmUuDQo+ID4NCj4gPiBUaGlzIGNvbW1pdCByZXBsYWNlcyB0aGUgc3dp
dGNoLXN0YXRlbWVudCB0aGF0IGFjdHMgb24gdGhlIFhEUCBwcm9ncmFtDQo+ID4gcmVzdWx0IHdp
dGggYW4gaWYtY2xhdXNlLg0KPiANCj4gQXBvbG9naWVzIGZvciB0aGUgbm9pc2UsIGJ1dCBpcyB0
aGlzIHBhdGNoIHN0aWxsIHJlcXVpcmVkIGFmdGVyIHRoZQ0KPiByZWNlbnQgdGhyZXNob2xkIGJ1
bXBbMF0gYW5kIGxhdGVyIHJlbW92YWxbMV0gb2Ygc3dpdGNoLWNhc2UganVtcA0KPiB0YWJsZSBn
ZW5lcmF0aW9uIHdoZW4gYnVpbGRpbmcgd2l0aCBDT05GSUdfUkVUUE9MSU5FPw0KPiANCj4gWzBd
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9wYXRjaHdvcmsvcGF0Y2gvMTA0NDg2My8NCj4gWzFd
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9wYXRjaHdvcmsvcGF0Y2gvMTA1NDQ3Mi8NCj4gDQo+
IElmIG5vdGhpbmcgZWxzZSB0aGUgY29tbWl0IG1lc3NhZ2Ugbm8gbG9uZ2VyIHNlZW1zIGFjY3Vy
YXRlLg0KDQpMb29raW5nIGF0IHRob3NlIHR3byBwYXRjaGVzLCB0aGUgc2Vjb25kIG9uZSBzZWVt
cyB3cm9uZzoNCg0KICAgIyBBZGRpdGlvbmFsbHksIGF2b2lkIGdlbmVyYXRpbmcgZXhwZW5zaXZl
IGluZGlyZWN0IGp1bXBzIHdoaWNoDQogICAjIGFyZSBzdWJqZWN0IHRvIHJldHBvbGluZXMgZm9y
IHNtYWxsIG51bWJlciBvZiBzd2l0Y2ggY2FzZXMuDQogICAjIGNsYW5nIHR1cm5zIG9mZiBqdW1w
IHRhYmxlIGdlbmVyYXRpb24gYnkgZGVmYXVsdCB3aGVuIHVuZGVyDQotICAjIHJldHBvbGluZSBi
dWlsZHMsIGhvd2V2ZXIsIGdjYyBkb2VzIG5vdCBmb3IgeDg2Lg0KLSAgS0JVSUxEX0NGTEFHUyAr
PSAkKGNhbGwgY2Mtb3B0aW9uLC0tcGFyYW09Y2FzZS12YWx1ZXMtdGhyZXNob2xkPTIwKQ0KKyAg
IyByZXRwb2xpbmUgYnVpbGRzLCBob3dldmVyLCBnY2MgZG9lcyBub3QgZm9yIHg4Ni4gVGhpcyBo
YXMNCisgICMgb25seSBiZWVuIGZpeGVkIHN0YXJ0aW5nIGZyb20gZ2NjIHN0YWJsZSB2ZXJzaW9u
IDguNC4wIGFuZA0KKyAgIyBvbndhcmRzLCBidXQgbm90IGZvciBvbGRlciBvbmVzLiBTZWUgZ2Nj
IGJ1ZyAjODY5NTIuDQorICBpZm5kZWYgQ09ORklHX0NDX0lTX0NMQU5HDQorICAgIEtCVUlMRF9D
RkxBR1MgKz0gJChjYWxsIGNjLW9wdGlvbiwtZm5vLWp1bXAtdGFibGVzKQ0KKyAgZW5kaWYNCg0K
SWYgLWZuby1qdW1wLXRhYmxlcyBpc24ndCBzdXBwb3J0ZWQgdGhlbiAtLXBhcmFtPWNhc2UtdmFs
dWVzLXRocmVzaG9sZD0yMA0KbmVlZHMgdG8gYmUgc2V0IChpZiBzdXBwb3J0ZWQpLg0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

