Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E823F7E8
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgHHNyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 09:54:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:27524 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbgHHNyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 09:54:12 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-8-i9qSWaqDO72eG3L16A1dCQ-1;
 Sat, 08 Aug 2020 14:54:08 +0100
X-MC-Unique: i9qSWaqDO72eG3L16A1dCQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 8 Aug 2020 14:54:07 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 8 Aug 2020 14:54:07 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <eric.dumazet@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-decnet-user@lists.sourceforge.net" 
        <linux-decnet-user@lists.sourceforge.net>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mptcp@lists.01.org" <mptcp@lists.01.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: RE: [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
Thread-Topic: [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
Thread-Index: AQHWbD/ze4VO5Mh7NUG6O93LfP2Gq6ksXaowgACKZoCAAVFEkA==
Date:   Sat, 8 Aug 2020 13:54:06 +0000
Message-ID: <ed3741fdf1774cfbbd59d06ecb6994d8@AcuMS.aculab.com>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-26-hch@lst.de>
 <6357942b-0b6e-1901-7dce-e308c9fac347@gmail.com>
 <f21589f1262640b09ca27ed20f8e6790@AcuMS.aculab.com>
 <90f626a4-d9e5-91a5-b71d-498e3b125da1@gmail.com>
In-Reply-To: <90f626a4-d9e5-91a5-b71d-498e3b125da1@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA3IEF1Z3VzdCAyMDIwIDE5OjI5DQo+IA0KPiBP
biA4LzcvMjAgMjoxOCBBTSwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0KPiA+IEZyb206IEVyaWMgRHVt
YXpldA0KPiA+PiBTZW50OiAwNiBBdWd1c3QgMjAyMCAyMzoyMQ0KPiA+Pg0KPiA+PiBPbiA3LzIy
LzIwIDExOjA5IFBNLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gPj4+IFJld29yayB0aGUg
cmVtYWluaW5nIHNldHNvY2tvcHQgY29kZSB0byBwYXNzIGEgc29ja3B0cl90IGluc3RlYWQgb2Yg
YQ0KPiA+Pj4gcGxhaW4gdXNlciBwb2ludGVyLiAgVGhpcyByZW1vdmVzIHRoZSBsYXN0IHJlbWFp
bmluZyBzZXRfZnMoS0VSTkVMX0RTKQ0KPiA+Pj4gb3V0c2lkZSBvZiBhcmNoaXRlY3R1cmUgc3Bl
Y2lmaWMgY29kZS4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBDaHJpc3RvcGggSGVsbHdp
ZyA8aGNoQGxzdC5kZT4NCj4gPj4+IEFja2VkLWJ5OiBTdGVmYW4gU2NobWlkdCA8c3RlZmFuQGRh
dGVuZnJlaWhhZmVuLm9yZz4gW2llZWU4MDIxNTRdDQo+ID4+PiAtLS0NCj4gPj4NCj4gPj4NCj4g
Pj4gLi4uDQo+ID4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvcmF3LmMgYi9uZXQvaXB2
Ni9yYXcuYw0KPiA+Pj4gaW5kZXggNTk0ZTAxYWQ2NzBhYTYuLjg3NGYwMWNkN2FlYzQyIDEwMDY0
NA0KPiA+Pj4gLS0tIGEvbmV0L2lwdjYvcmF3LmMNCj4gPj4+ICsrKyBiL25ldC9pcHY2L3Jhdy5j
DQo+ID4+PiBAQCAtOTcyLDEzICs5NzIsMTMgQEAgc3RhdGljIGludCByYXd2Nl9zZW5kbXNnKHN0
cnVjdCBzb2NrICpzaywgc3RydWN0IG1zZ2hkciAqbXNnLCBzaXplX3QgbGVuKQ0KPiA+Pj4gIH0N
Cj4gPj4+DQo+ID4+DQo+ID4+IC4uLg0KPiA+Pg0KPiA+Pj4gIHN0YXRpYyBpbnQgZG9fcmF3djZf
c2V0c29ja29wdChzdHJ1Y3Qgc29jayAqc2ssIGludCBsZXZlbCwgaW50IG9wdG5hbWUsDQo+ID4+
PiAtCQkJICAgIGNoYXIgX191c2VyICpvcHR2YWwsIHVuc2lnbmVkIGludCBvcHRsZW4pDQo+ID4+
PiArCQkJICAgICAgIHNvY2twdHJfdCBvcHR2YWwsIHVuc2lnbmVkIGludCBvcHRsZW4pDQo+ID4+
PiAgew0KPiA+Pj4gIAlzdHJ1Y3QgcmF3Nl9zb2NrICpycCA9IHJhdzZfc2soc2spOw0KPiA+Pj4g
IAlpbnQgdmFsOw0KPiA+Pj4NCj4gPj4+IC0JaWYgKGdldF91c2VyKHZhbCwgKGludCBfX3VzZXIg
KilvcHR2YWwpKQ0KPiA+Pj4gKwlpZiAoY29weV9mcm9tX3NvY2twdHIoJnZhbCwgb3B0dmFsLCBz
aXplb2YodmFsKSkpDQo+ID4+PiAgCQlyZXR1cm4gLUVGQVVMVDsNCj4gPj4+DQo+ID4+DQo+ID4+
IGNvbnZlcnRpbmcgZ2V0X3VzZXIoLi4uKSAgIHRvICBjb3B5X2Zyb21fc29ja3B0ciguLi4pIHJl
YWxseSBhc3N1bWVkIHRoZSBvcHRsZW4NCj4gPj4gaGFzIGJlZW4gdmFsaWRhdGVkIHRvIGJlID49
IHNpemVvZihpbnQpIGVhcmxpZXIuDQo+ID4+DQo+ID4+IFdoaWNoIGlzIG5vdCBhbHdheXMgdGhl
IGNhc2UsIGZvciBleGFtcGxlIGhlcmUuDQo+ID4+DQo+ID4+IFVzZXIgYXBwbGljYXRpb24gY2Fu
IGZvb2wgdXMgcGFzc2luZyBvcHRsZW49MCwgYW5kIGEgdXNlciBwb2ludGVyIG9mIGV4YWN0bHkg
VEFTS19TSVpFLTENCj4gPg0KPiA+IFdvbid0IHRoZSB1c2VyIHBvaW50ZXIgZm9yY2UgY29weV9m
cm9tX3NvY2twdHIoKSB0byBjYWxsDQo+ID4gY29weV9mcm9tX3VzZXIoKSB3aGljaCB3aWxsIHRo
ZW4gZG8gYWNjZXNzX29rKCkgb24gdGhlIGVudGlyZQ0KPiA+IHJhbmdlIGFuZCBzbyByZXR1cm4g
LUVGQVVMVC4NCj4gPg0KPiA+IFRoZSBvbmx5IHByb2JsZW1zIGFyaXNlIGlmIHRoZSBrZXJuZWwg
Y29kZSBhZGRzIGFuIG9mZnNldCB0byB0aGUNCj4gPiB1c2VyIGFkZHJlc3MuDQo+ID4gQW5kIHRo
ZSBsYXRlciBwYXRjaCBhZGRlZCBhbiBvZmZzZXQgdG8gdGhlIGNvcHkgZnVuY3Rpb25zLg0KPiAN
Cj4gSSBkdW5ubywgSSBkZWZpbml0ZWx5IGdvdCB0aGUgZm9sbG93aW5nIHN5emJvdCBjcmFzaA0K
PiANCj4gTm8gcmVwcm8gZm91bmQgYnkgc3l6Ym90IHlldCwgYnV0IEkgc3VzcGVjdCBhIDMyYml0
IGJpbmFyeSBwcm9ncmFtDQo+IGRpZCA6DQo+IA0KPiBzZXRzb2Nrb3B0KGZkLCAweDI5LCAweDI0
LCAweGZmZmZmZmZmZmZmZmZmZmYsIDB4MCkNCg0KQSBmZXcgdG9vIG1hbnkgZmZzLi4uDQoNCj4g
QlVHOiBLQVNBTjogd2lsZC1tZW1vcnktYWNjZXNzIGluIG1lbWNweSBpbmNsdWRlL2xpbnV4L3N0
cmluZy5oOjQwNiBbaW5saW5lXQ0KPiBCVUc6IEtBU0FOOiB3aWxkLW1lbW9yeS1hY2Nlc3MgaW4g
Y29weV9mcm9tX3NvY2twdHJfb2Zmc2V0IGluY2x1ZGUvbGludXgvc29ja3B0ci5oOjcxIFtpbmxp
bmVdDQo+IEJVRzogS0FTQU46IHdpbGQtbWVtb3J5LWFjY2VzcyBpbiBjb3B5X2Zyb21fc29ja3B0
ciBpbmNsdWRlL2xpbnV4L3NvY2twdHIuaDo3NyBbaW5saW5lXQ0KPiBCVUc6IEtBU0FOOiB3aWxk
LW1lbW9yeS1hY2Nlc3MgaW4gZG9fcmF3djZfc2V0c29ja29wdCBuZXQvaXB2Ni9yYXcuYzoxMDIz
IFtpbmxpbmVdDQo+IEJVRzogS0FTQU46IHdpbGQtbWVtb3J5LWFjY2VzcyBpbiByYXd2Nl9zZXRz
b2Nrb3B0KzB4MWExLzB4NmYwIG5ldC9pcHY2L3Jhdy5jOjEwODQNCj4gUmVhZCBvZiBzaXplIDQg
YXQgYWRkciAwMDAwMDAwMGZmZmZmZmZmIGJ5IHRhc2sgc3l6LWV4ZWN1dG9yLjAvMjgyNTENCg0K
WWVwLCB0aGUgY29kZSBpcyBuZWFybHksIGJ1dCBub3QgcXVpdGUgcmlnaHQuDQpUaGUgcHJvYmxl
bSBpcyBhbG1vc3QgY2VydGFpbmx5IHRoYXQgYWNjZXNzX29rKHgsIDApIGFsd2F5cyByZXR1cm5z
IHN1Y2Nlc3MuDQoNCkluIGFueSBjYXNlIHRoZSBjaGVjayBmb3IgYSB2YWxpZCB1c2VyIGFkZHJl
c3Mgb3VnaHQgdG8gYmUgZXhhY3RseQ0KdGhlIHNhbWUgb25lIHRoYXQgbGF0ZXIgc2VsZWN0cyBi
ZXR3ZWVuIGNvcHlfdG8vZnJvbV91c2VyKCkgYW5kIG1lbWNweSgpLg0KDQpUaGUgbGF0dGVyIGNv
bXBhcmVzIHRoZSBhZGRyZXNzIGFnYWluc3QgJ1RBU0tfU0laRScuDQpIb3dldmVyIHRoYXQgaXNu
J3QgdGhlIHJpZ2h0IHZhbHVlIGVpdGhlciAtIEkgdGhpbmsgaXQgcmVhZHMNCnRoZSB2YWx1ZSBm
cm9tICdjdXJyZW50JyB0aGF0IHNldF9mcygpIHNldHMuDQpXaGF0IHRoaXMgY29kZSBuZWVkcyBp
cyBhbnkgYWRkcmVzcyB0aGF0IGlzIGFib3ZlIHRoZSBoaWdoZXN0DQp1c2VyIGFkZHJlc3MgYW5k
IGJlbG93IChvciBlcXVhbCB0bykgdG8gbG93ZXN0IGtlcm5lbCBvbmUuDQoNCk9uIGkzODYgKGFu
ZCBwcm9iYWJseSBtb3N0IDMyYml0IGxpbnV4KSB0aGlzIGlzIDB4YzAwMDAwMDAuDQpPbiB4ODYt
NjQgdGhpcyBjb3VsZCBiZSBhbnkgYWRkcmVzcyBpbiB0aGUgYWRkcmVzcyAnYmxhY2sgaG9sZScu
DQpQaWNraW5nIDF1bGw8PDYzIG1heSBiZSBiZXN0Lg0KUXVpdGUgd2hhdCB0aGUgY29ycmVjdCAj
ZGVmaW5lIGlzIHJlcXVpcmVzIGZ1cnRoZXIgcmVzZWFyY2guDQoNClRoZXJlIGlzIGFjdHVhbGx5
IHNjb3BlIGZvciBtYWtpbmcgaW5pdF91c2VyX3NvY2twdHIoa2Vybl9hZGRyZXNzKQ0Kc2F2ZSBh
IHZhbHVlIHRoYXQgd2lsbCBjYXVzZSBjb3B5X3RvL2Zyb21fc29ja3B0cigpIGdvIGludG8NCnRo
ZSB1c2VyLWNvcHkgcGF0aCB3aXRoIGFuIGFkZHJlc3MgdGhhdCBhY2Nlc3Nfb2soKSB3aWxsIHJl
amVjdC4NClRoZW4gdGhlIC1FRkFVTFQgd2lsbCBnZXQgZ2VuZXJhdGVkIGluIHRoZSAnZXhwZWN0
ZWQnIHBsYWNlDQphbmQgdGhlcmUgaXMgbm8gc2NvcGUgZm9yIGZhaWxpbmcgdG8gdGVzdCBpdCdz
IHJldHVybiB2YWx1ZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lk
ZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0K
UmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

