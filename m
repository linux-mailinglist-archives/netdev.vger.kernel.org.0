Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0872CEA70
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 10:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgLDJEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 04:04:22 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:20900 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbgLDJEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 04:04:21 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-272-foInBB0XPqCkeKQcwqosjg-1; Fri, 04 Dec 2020 09:02:41 +0000
X-MC-Unique: foInBB0XPqCkeKQcwqosjg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 4 Dec 2020 09:02:41 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 4 Dec 2020 09:02:41 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "arjunroy@google.com" <arjunroy@google.com>,
        "soheil@google.com" <soheil@google.com>
Subject: RE: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
Thread-Topic: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data
 for TCP Rx. zerocopy.
Thread-Index: AQHWyQnnIy5Nhf4BLE+JcVO2pr+xUKnl/WUAgAAEsACAAKQNIA==
Date:   Fri, 4 Dec 2020 09:02:40 +0000
Message-ID: <1aabb09d81d24480ab2cf99e30138a3e@AcuMS.aculab.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
 <20201202220945.911116-2-arjunroy.kdev@gmail.com>
 <20201202161527.51fcdcd7@hermes.local>
 <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com>
 <CANn89iKfUdRygt_k2Axf1MZ2FzkOQ9R6S2oJAvKuLqRp-wZvsQ@mail.gmail.com>
In-Reply-To: <CANn89iKfUdRygt_k2Axf1MZ2FzkOQ9R6S2oJAvKuLqRp-wZvsQ@mail.gmail.com>
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

RnJvbTogRXJpYw0KPiBTZW50OiAwMyBEZWNlbWJlciAyMDIwIDIzOjE1DQo+IA0KPiBPbiBGcmks
IERlYyA0LCAyMDIwIGF0IDEyOjAxIEFNIERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0QGFjdWxh
Yi5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRnJvbTogU3RlcGhlbiBIZW1taW5nZXINCj4gPiA+IFNl
bnQ6IDAzIERlY2VtYmVyIDIwMjAgMDA6MTUNCj4gPiA+DQo+ID4gPiBPbiBXZWQsICAyIERlYyAy
MDIwIDE0OjA5OjM4IC0wODAwDQo+ID4gPiBBcmp1biBSb3kgPGFyanVucm95LmtkZXZAZ21haWwu
Y29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGlu
dXgvdGNwLmggYi9pbmNsdWRlL3VhcGkvbGludXgvdGNwLmgNCj4gPiA+ID4gaW5kZXggY2ZjYjEw
Yjc1NDgzLi42MmRiNzhiOWMxYTAgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9s
aW51eC90Y3AuaA0KPiA+ID4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvdGNwLmgNCj4gPiA+
ID4gQEAgLTM0OSw1ICszNDksNyBAQCBzdHJ1Y3QgdGNwX3plcm9jb3B5X3JlY2VpdmUgew0KPiA+
ID4gPiAgICAgX191MzIgcmVjdl9za2lwX2hpbnQ7ICAgLyogb3V0OiBhbW91bnQgb2YgYnl0ZXMg
dG8gc2tpcCAqLw0KPiA+ID4gPiAgICAgX191MzIgaW5xOyAvKiBvdXQ6IGFtb3VudCBvZiBieXRl
cyBpbiByZWFkIHF1ZXVlICovDQo+ID4gPiA+ICAgICBfX3MzMiBlcnI7IC8qIG91dDogc29ja2V0
IGVycm9yICovDQo+ID4gPiA+ICsgICBfX3U2NCBjb3B5YnVmX2FkZHJlc3M7ICAvKiBpbjogY29w
eWJ1ZiBhZGRyZXNzIChzbWFsbCByZWFkcykgKi8NCj4gPiA+ID4gKyAgIF9fczMyIGNvcHlidWZf
bGVuOyAvKiBpbi9vdXQ6IGNvcHlidWYgYnl0ZXMgYXZhaWwvdXNlZCBvciBlcnJvciAqLw0KPiA+
DQo+ID4gWW91IG5lZWQgdG8gc3dhcCB0aGUgb3JkZXIgb2YgdGhlIGFib3ZlIGZpZWxkcyB0byBh
dm9pZCBwYWRkaW5nDQo+ID4gYW5kIGRpZmZlcmluZyBhbGlnbm1lbnRzIGZvciAzMmJpdCBhbmQg
NjRiaXQgYXBwcy4NCj4gDQo+IEkgZG8gbm90IHRoaW5rIHNvLiBQbGVhc2UgcmV2aWV3IHRoaXMg
cGF0Y2ggc2VyaWVzIGNhcmVmdWxseS4NCg0KTGF0ZSBhdCBuaWdodC4NClRoZSBhY3R1YWwgcHJv
YmxlbSBpcyAndGFpbCBwYWRkaW5nJy4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVz
cyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEg
MVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

