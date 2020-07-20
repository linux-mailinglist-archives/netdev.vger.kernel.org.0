Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433972259F6
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgGTIZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:25:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:58646 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726862AbgGTIZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:25:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-164-bY_3e_EDMPW4iKQxeTBP4A-1; Mon, 20 Jul 2020 09:25:20 +0100
X-MC-Unique: bY_3e_EDMPW4iKQxeTBP4A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 20 Jul 2020 09:25:19 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 20 Jul 2020 09:25:19 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Alexei Starovoitov' <alexei.starovoitov@gmail.com>,
        Christoph Hellwig <hch@lst.de>
CC:     Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: RE: how is the bpfilter sockopt processing supposed to work
Thread-Topic: how is the bpfilter sockopt processing supposed to work
Thread-Index: AQHWXF/F35kHqURKlkeKKxLFQfLuxakQImUw
Date:   Mon, 20 Jul 2020 08:25:19 +0000
Message-ID: <2120c0cd6da143619ed54809c768c22e@AcuMS.aculab.com>
References: <20200717055245.GA9577@lst.de>
 <CAADnVQ+rD+7fAsLZT4pG7AN4iO7-dQ+3adw0tBhrf8TGbtLjtA@mail.gmail.com>
 <20200717162526.GA17072@lst.de>
 <CAADnVQJoMC=vfS4yb7gYZF4fmwrHd+gdOf9zmPm2XyK1jfosHg@mail.gmail.com>
In-Reply-To: <CAADnVQJoMC=vfS4yb7gYZF4fmwrHd+gdOf9zmPm2XyK1jfosHg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxleGVpIFN0YXJvdm9pdG92DQo+IFNlbnQ6IDE3IEp1bHkgMjAyMCAxODoyOQ0KPiBP
biBGcmksIEp1bCAxNywgMjAyMCBhdCA5OjI1IEFNIENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0
LmRlPiB3cm90ZToNCj4gPg0KPiA+IE9uIEZyaSwgSnVsIDE3LCAyMDIwIGF0IDA5OjEzOjA3QU0g
LTA3MDAsIEFsZXhlaSBTdGFyb3ZvaXRvdiB3cm90ZToNCj4gPiA+IE9uIFRodSwgSnVsIDE2LCAy
MDIwIGF0IDEwOjUyIFBNIENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPiB3cm90ZToNCj4g
PiA+ID4NCj4gPiA+ID4gSGkgQWxleGVpLA0KPiA+ID4gPg0KPiA+ID4gPiBJJ3ZlIGp1c3QgYmVl
biBhdWRpdGluZyB0aGUgc29ja29wdCBjb2RlLCBhbmQgYnBmaWx0ZXIgbG9va3MgcmVhbGx5DQo+
ID4gPiA+IG9kZC4gIEJvdGggZ2V0c29ja29wdHMgYW5kIHNldHNvY2tvcHQgZXZlbnR1YWxseSBl
bmQgdXANCj4gPiA+ID4gaW5fX2JwZmlsdGVyX3Byb2Nlc3Nfc29ja29wdCwgd2hpY2ggdGhlbiBw
YXNzZXMgcmVjb3JkIHRvIHRoZQ0KPiA+ID4gPiB1c2Vyc3BhY2UgaGVscGVyIGNvbnRhaW5pbmcg
dGhlIGFkZHJlc3Mgb2YgdGhlIG9wdHZhbCBidWZmZXIuDQo+ID4gPiA+IFdoaWNoIGRlcGVuZGlu
ZyBvbiBicGYtY2dyb3VwIG1pZ2h0IGJlIGluIHVzZXIgb3Iga2VybmVsIHNwYWNlLg0KPiA+ID4g
PiBCdXQgZXZlbiBpZiBpdCBpcyBpbiB1c2Vyc3BhY2UgaXQgd291bGQgYmUgaW4gYSBkaWZmZXJl
bnQgcHJvY2Vzcw0KPiA+ID4gPiB0aGFuIHRoZSBicGZpbGVyIGhlbHBlci4gIFdoYXQgbWFrZXMg
YWxsIHRoaXMgd29yaz8NCj4gPiA+DQo+ID4gPiBIbW0uIEdvb2QgcG9pbnQuIGJwZmlsdGVyIGFz
c3VtZXMgdXNlciBhZGRyZXNzZXMuIEl0IHdpbGwgYnJlYWsNCj4gPiA+IGlmIGJwZiBjZ3JvdXAg
c29ja29wdCBtZXNzZXMgd2l0aCBpdC4NCj4gPiA+IFdlIGhhZCBhIGRpZmZlcmVudCBpc3N1ZSB3
aXRoIGJwZi1jZ3JvdXAtc29ja29wdCBhbmQgaXB0YWJsZXMgaW4gdGhlIHBhc3QuDQo+ID4gPiBQ
cm9iYWJseSB0aGUgZWFzaWVzdCB3YXkgZm9yd2FyZCBpcyB0byBzcGVjaWFsIGNhc2UgdGhpcyBw
YXJ0aWN1bGFyIG9uZS4NCj4gPiA+IFdpdGggeW91ciBuZXcgc2VyaWVzIGlzIHRoZXJlIGEgd2F5
IHRvIHRlbGwgaW4gYnBmaWx0ZXJfaXBfZ2V0X3NvY2tvcHQoKQ0KPiA+ID4gd2hldGhlciBhZGRy
IGlzIGtlcm5lbCBvciB1c2VyPyBBbmQgaWYgaXQncyB0aGUga2VybmVsIGp1c3QgcmV0dXJuIHdp
dGggZXJyb3IuDQo+ID4NCj4gPiBZZXMsIEkgY2FuIHNlbmQgYSBmaXguICBCdXQgaG93IGRvIGV2
ZW4gdGhlIHVzZXIgc3BhY2UgYWRkcmVzc2VkIHdvcms/DQo+ID4gSWYgc29tZSByYW5kb20gcHJv
Y2VzcyBjYWxscyBnZXRzb2Nrb3B0IG9yIHNldHNvY2tvcHQsIGhvdyBkb2VzIHRoZQ0KPiA+IGJw
ZmlsdGVyIHVzZXIgbW9kZSBoZWxwZXIgYXR0YWNoIHRvIGl0cyBhZGRyZXNzIHNwYWNlPw0KPiAN
Cj4gVGhlIGFjdHVhbCBicGZpbHRlciBwcm9jZXNzaW5nIGlzIGluIHR3byBwYXRjaGVzIHRoYXQg
d2UgZGlkbid0IGxhbmQ6DQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3BhdGNod29yay9wYXRj
aC85MDI3ODUvDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3BhdGNod29yay9wYXRjaC85MDI3
ODMvDQo+IFVNRCBpcyB1c2luZyBwcm9jZXNzX3ZtX3JlYWR2KCkuDQo+IFRoZSB0YXJnZXQgcHJv
Y2VzcyBpcyB3YWl0aW5nIGZvciB0aGUgc29ja29wdCBzeXNjYWxsIHRvIHJldHVybiwNCj4gc28g
ZnJvbSB0aGUgdG9jdG91IHBlcnNwZWN0aXZlIGl0J3MgdGhlIHNhbWUgYXMgdGhlIGtlcm5lbCBk
b2luZyBjb3B5X2Zyb21fdXNlci4NCg0KWW91IG5lZWQgdG8gYmUgZG9pbmcgdGhlIHVzZXItc3Bh
Y2VzIGFjY2Vzc2VzIGZyb20gdGhlIHRhcmdldCBwcm9jZXNzJ3MNCmNvbnRleHQuDQpJZiBpdCBp
cyB3YWl0aW5nIGZvciB0aGUgc3lzY2FsbCB0byByZXR1cm4gdGhlbiB5b3UgYXJlbid0IHJ1bm5p
bmcNCml0IGl0cyBjb250ZXh0Lg0KDQpUaGVyZSBpcyBhbHNvIGF0IGxlYXN0IG9uZSBzb2Nrb3B0
IHRoYXQgaGFzIGFuIGVtYmVkZGVkIHBvaW50ZXIuDQpTbyBldmVuIGlmIHlvdSd2ZSBjb3BpZWQg
dGhlIHNvY2tvcHQgYnVmZmVyIGludG8ga2VybmVsIHNwYWNlDQp5b3UgYXJlIGRvb21lZC4NCklm
IHRoZSByZXF1ZXN0IGhhcyBjb21lIGZyb20gYSBrZXJuZWwgdGhyZWFkIHdpdGgga2VybmVsIGJ1
ZmZlcnMNCnRoZW4gdGhlIGVtYmVkZGVkIGJ1ZmZlciB3aWxsIGJlIGtlcm5lbC4NCihUaGlzIGlz
IHByb2JhYmx5IG1vcmUgY29tbW9uIGZvciBpb2N0bCgpIHJlcXVlc3RzLikNCg0KSSdtIG5vdCBz
dXJlIHRoZXJlIGlzIGFueSBzYW5lIHdhcyB0byBoYW5kbGUgdGhpcy4NCg0KCURhdmlkDQoNCi0N
ClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBN
aWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxl
cykNCg==

