Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46A71505E9
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 13:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBCMML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 07:12:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:41447 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727201AbgBCMMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 07:12:10 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-226-eRO8dGcZORikWomoZelfQA-1; Mon, 03 Feb 2020 12:12:04 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 3 Feb 2020 12:12:04 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 3 Feb 2020 12:12:03 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>
Subject: RE: Freeing 'temporary' IPv4 route table entries.
Thread-Topic: Freeing 'temporary' IPv4 route table entries.
Thread-Index: AdXXj93DZx0FEI6/TbeS56CZssFH8AAvsEAAAI2B1MA=
Date:   Mon, 3 Feb 2020 12:12:03 +0000
Message-ID: <4e0e0eb18036401e942651c86a956a41@AcuMS.aculab.com>
References: <bee231ddc34142d2a96bfdc9a6a2f57c@AcuMS.aculab.com>
 <3cfcd1b7-96e4-a5b6-21e7-8182a367f349@gmail.com>
In-Reply-To: <3cfcd1b7-96e4-a5b6-21e7-8182a367f349@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: eRO8dGcZORikWomoZelfQA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDMxIEphbnVhcnkgMjAyMCAxNTo1NA0KPiBPbiAx
LzMxLzIwIDI6MjYgQU0sIERhdmlkIExhaWdodCB3cm90ZToNCj4gPiBJZiBJIGNhbGwgc2VuZG1z
ZygpIG9uIGEgcmF3IHNvY2tldCAob3IgcHJvYmFibHkNCj4gPiBhbiB1bmNvbm5lY3RlZCBVRFAg
b25lKSBydF9kc3RfYWxsb2MoKSBpcyBjYWxsZWQNCj4gPiBpbiB0aGUgYm93ZWxzIG9mIGlwX3Jv
dXRlX291dHB1dF9mbG93KCkgdG8gaG9sZA0KPiA+IHRoZSByZW1vdGUgYWRkcmVzcy4NCj4gPg0K
PiA+IE11Y2ggbGF0ZXIgX19kZXZfcXVldWVfeG1pdCgpIGNhbGxzIGRzdF9yZWxlYXNlKCkNCj4g
PiB0byBkZWxldGUgdGhlICdkc3QnIHJlZmVyZW5jZWQgZnJvbSB0aGUgc2tiLg0KPiA+DQo+ID4g
UHJpb3IgdG8gZjg4NjQ5NzIgaXQgZGlkIGp1c3QgdGhhdC4NCj4gPiBBZnRlcndhcmRzIHRoZSBh
Y3R1YWwgZGVsZXRlIGlzICdsYXVuZGVyZWQnIHRocm91Z2ggdGhlDQo+ID4gcmN1IGNhbGxiYWNr
cy4NCj4gPiBUaGlzIGlzIHByb2JhYmx5IG9rIGZvciBkc3QgdGhhdCBhcmUgYWN0dWFsbHkgYXR0
YWNoZWQNCj4gPiB0byBzb2NrZXRzIG9yIHR1bm5lbHMgKHdoaWNoIGFyZW4ndCBmcmVlZCB2ZXJ5
IG9mdGVuKS4NCj4gPiBCdXQgaXQgbGVhZHMgdG8gaG9ycmlkIGxvbmcgcmN1IGNhbGxiYWNrIHNl
cXVlbmNlcw0KPiA+IHdoZW4gYSBsb3Qgb2YgbWVzc2FnZXMgYXJlIHNlbnQuDQo+ID4gKEEgc2Ft
cGxlIG9mIDEgZ2F2ZSBuZWFybHkgMTAwIGRlbGV0ZXMgaW4gb25lIGdvLikNCj4gPiBUaGVyZSBp
cyBhbHNvIHRoZSBhZGRpdGlvbmFsIGNvc3Qgb2YgZGVmZXJyaW5nIHRoZSBmcmVlDQo+ID4gKGFu
ZCB0aGUgZXh0cmEgcmV0cG9saW5lIGV0YykuDQo+ID4NCj4gPiBJU1RNIHRoYXQgdGhlIGRzdF9h
bGxvYygpIGRvbmUgZHVyaW5nIGEgc2VuZCBzaG91bGQNCj4gPiBzZXQgYSBmbGFnIHNvIHRoYXQg
dGhlICdkc3QnIGNhbiBiZSBpbW1lZGlhdGVseQ0KPiA+IGZyZWVkIHNpbmNlIGl0IGlzIGtub3du
IHRoYXQgbm8gb25lIGNhbiBiZSBwaWNraW5nIHVwDQo+ID4gYSByZWZlcmVuY2UgYXMgaXQgaXMg
YmVpbmcgZnJlZWQuDQo+ID4NCj4gPiBUaG91Z2h0cz8NCj4gPg0KPiANCj4gSSB0aG91Z2h0IHRo
ZXNlIHJvdXRlcyB3ZXJlIGNhY2hlZCBpbiBwZXItY3B1IGNhY2hlcy4NCj4gDQo+IEF0IGxlYXN0
IGZvciBVRFAgSSBkbyBub3Qgc2VlIHJjdSBjYWxsYmFja3MgYmVpbmcgcXVldWVlZC4NCg0KSSd2
ZSBkb25lIGEgYml0IG1vcmUgaW52ZXN0aWdhdGlvbi4NCg0KRm9yIHJhd19pcCBzb2NrZXRzIHdp
dGggaW5ldC0+aGRyaW5jbCBzZXQgKGllIHRoZSBhcHBsaWNhdGlvbg0KYnVpbGRzIHRoZSBJUHY0
IGhlYWRlcikgZmxvd2k0X2ZsYWdzIGhhcyBGTE9XSV9GTEFHX0tOT1dOX05IIHNldC4NCg0KVGhp
cyBpcyBkZXRlY3RlZCBpbnNpZGUgX19ta3JvdXRlX291dHB1dCgpIChpbiBpcHY0L3JvdXRlLmMp
DQphbmQgZm9yY2VzIHJ0X2RzdF9hbGxvYygpIGJlIGNhbGxlZCBpbnN0ZWFkIG9mIHVzaW5nIHRo
ZQ0KJ2RzdCcgZnJvbSAoSSB0aGluaykgZmliX3NlbGVjdF9wYXRoKCkuDQooSXMgdGhpcyBiYXNp
Y2FsbHkgdGhlIGFycCB0YWJsZSBlbnRyeT8pDQoNCnJ0X3NldF9uZXh0aG9wKCkgdGhlbiBjYWxs
cyBydF9hZGRfdW5jYWNoZWRfbGlzdCgpLg0KDQpJIHN1c3BlY3QgdGhhdCBkc3RfcmVsZWFzZSgp
IGlzIGNhbGxlZCBhZnRlciBldmVyeQ0KdHJhbnNtaXQgLSBidXQgbm9ybWFsbHkganVzdCBkZWNy
ZW1lbnRzIHRoZSByZWYgY291bnQuDQpIb3dldmVyIGZvciByYXcgc2VuZHMgaXQgZnJlZXMgdGhl
IHVuY2FjaGVkIHJvdXRlLg0KDQpJIHRoaW5rIHRoZSAnZmF1bHQnIGlzIGRvd24gdG8gYzI3Yzkz
MjJkIHdoaWNoIGZpeGVkDQphbiBpc3N1ZSB3aGVyZSB0aGUgY29kZSB3YXMgdXNpbmcgdGhlIElQ
IGFkZHJlc3MgZnJvbSB0aGUNCnByZS1idWlsdCBwYWNrZXQgaW5zdGVhZCBvZiB0aGUgb25lIGZy
b20gdGhlIGRlc3RpbmF0aW9uDQphZGRyZXNzLg0KDQpJIHRoaW5rIHRoZXJlIGFyZSB0d28gaXNz
dWVzOg0KMSkgaWYgX19ta3JvdXRlX291dHB1dCgpIGNyZWF0ZXMgYW4gJ3VuY2FjaGVkJyByb3V0
ZQ0KICAgaXQgY2FuIGJlIGZyZWVkIHdpdGhvdXQgd2FpdGluZyBmb3IgcmN1IGdyYWNlLg0KMikg
aWYgYSByYXcgcGFja2V0cyBkZXN0aW5hdGlvbiBhZGRyZXNzIG1hdGNoZXMgdGhlbg0KICAgdGhl
IGNhY2hlZCByb3V0ZSBjYW4gYmUgdXNlZC4NCg0KT2ggLSBub3RoaW5nIHNlZW1zIHRvIGNoZWNr
IERTVF9IT1NUIGFueSBtb3JlDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFr
ZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwg
VUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

