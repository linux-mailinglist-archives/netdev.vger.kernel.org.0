Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F4A1184E0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfLJKVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:21:53 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:48936 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbfLJKVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 05:21:53 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-181-dlX51XbcOgGmzaLpZVEObQ-1; Tue, 10 Dec 2019 10:21:50 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 10 Dec 2019 10:21:49 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 10 Dec 2019 10:21:49 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andy Lutomirski' <luto@amacapital.net>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Topic: recvfrom/recvmsg performance and CONFIG_HARDENED_USERCOPY
Thread-Index: AdWsNynavvs+VRwOQ6mSStk+IzVA6AACUqqAAI3fO8AAEiVBgAAgNCaQ
Date:   Tue, 10 Dec 2019 10:21:49 +0000
Message-ID: <5a3cf731da8442909a4b84d975beb5e0@AcuMS.aculab.com>
References: <efffc167eff1475f94f745f733171d59@AcuMS.aculab.com>
 <F6840B11-060A-48F2-9FFE-774E73C50765@amacapital.net>
In-Reply-To: <F6840B11-060A-48F2-9FFE-774E73C50765@amacapital.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: dlX51XbcOgGmzaLpZVEObQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQW5keSBMdXRvbWlyc2tpDQo+IFNlbnQ6IDA5IERlY2VtYmVyIDIwMTkgMTg6NDMNCj4g
DQo+ID4gT24gRGVjIDksIDIwMTksIGF0IDM6MDEgQU0sIERhdmlkIExhaWdodCA8RGF2aWQuTGFp
Z2h0QGFjdWxhYi5jb20+IHdyb3RlOg0KPiA+DQo+ID4g77u/RnJvbTogRXJpYyBEdW1hemV0DQo+
ID4+IFNlbnQ6IDA2IERlY2VtYmVyIDIwMTkgMTQ6MjINCj4gPiAuLi4NCj4gPj4gUmVhbCBxdWVz
dGlvbiBpcyA6IERvIHlvdSBhY3R1YWxseSBuZWVkIHRvIHVzZSByZWN2bXNnKCkgaW5zdGVhZCBv
ZiByZWN2ZnJvbSgpID8NCj4gPj4gSWYgcmVjdm1zZygpIHByb3ZpZGVzIGFkZGl0aW9uYWwgY21z
ZywgdGhpcyBpcyBub3Qgc3VycHJpc2luZyBpdCBpcyBtb3JlIGV4cGVuc2l2ZS4NCj4gPg0KPiA+
IEV4Y2VwdCBJJ20gbm90IHBhc3NpbmcgaW4gYSBidWZmZXIgZm9yIGl0Lg0KPiA+IFRoZSByZWFz
b24gSSdtIGxvb2tpbmcgYXQgcmVjdm1zZyBpcyB0aGF0IEknZCBsaWtlIHRvIHVzZSByZWN2bW1z
ZyBpdCBvcmRlciB0bw0KPiA+IHJlYWQgb3V0IG1vcmUgdGhhbiBvbmUgbWVzc2FnZSBmcm9tIGEg
c29ja2V0IHdpdGhvdXQgZG9pbmcgYW4gZXh0cmEgcG9sbCgpLg0KPiA+IE5vdGUgdGhhdCBJIGRv
bid0IGV4cGVjdCB0aGVyZSB0byBiZSBhIHNlY29uZCBtZXNzYWdlIG1vc3Qgb2YgdGhlIHRpbWUg
YW5kDQo+ID4gYWxtb3N0IG5ldmVyIGEgdGhpcmQgb25lLg0KPiA+DQo+ID4gQWx0aG91Z2ggSSB0
aGluayB0aGF0IHdpbGwgb25seSBldmVyICd3aW4nIGlmIHJlY3ZtbXNnKCkgY2FsbGVkIHZmc19w
b2xsKCkgdG8gZmluZA0KPiA+IGlmIHRoZXJlIHdhcyBtb3JlIGRhdGEgdG8gcmVhZCBiZWZvcmUg
ZG9pbmcgYW55IG9mIHRoZSBjb3B5X2Zyb21fdXNlcigpIGV0Yw0KPiANCj4gSSB3b3VsZCBzdWdn
ZXN0IGEgbW9yZSBnZW5lcmFsIGltcHJvdmVtZW50OiBhZGQgYSAtRUFHQUlOIGZhc3QgcGF0aCB0
byByZWN2bXNnKCkuDQo+IElmIHRoZSBzb2NrZXQgaXMgbm9uYmxvY2tpbmcgYW5kIGhhcyBubyBk
YXRhIHRvDQo+IHJlYWQsIHRoZW4gdGhlcmUgc2hvdWxkbuKAmXQgYmUgYSBuZWVkIHRvIHByb2Nl
c3MgdGhlIGlvdmVjIGF0IGFsbC4NCg0KWW91IGRvbid0IHdhbnQgdG8gZG8gdGhhdCBmb3IgcmVj
dm1zZygpIGl0c2VsZi4NCkl0IHdpbGwgbm9ybWFsbHkgb25seSBiZSBjYWxsZWQgaWYgcG9sbCgp
IHJlcG9ydGVkIGRhdGEgaXMgYXZhaWxhYmxlLg0KQWN0dWFsbHkgdGhlIE1TR19XQUlURk9ST05F
IGZsYWcgY291bGQgYmUgdXNlZCB0byBkbyBhIGNhbGwNCnRvIHZmc19wb2xsKCkgYmVmb3JlIHRo
ZSBzdWJzZXF1ZW50IGNhbGxzIHRvIF9fc3lzX3JlY3Ztc2coKS4NClRoaXMgd2lsbCB3b3JrIGZv
ciBub24tYmxvY2tpbmcgc29ja2V0cyAob3IgZXZlbiBjYWxscyB3aXRoIGJvdGgNCk1TR19ET05U
V0FJVCBhbmQgTVNHX1dBSVRGT1JPTkUgc2V0KS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQg
QWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVz
LCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

