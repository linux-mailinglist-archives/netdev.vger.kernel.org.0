Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5FA3B2FCB
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 15:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhFXNLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 09:11:00 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:30870 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230267AbhFXNK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 09:10:59 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-288-a_p6BJwHOr2fagm1ZXVMHg-1; Thu, 24 Jun 2021 14:08:37 +0100
X-MC-Unique: a_p6BJwHOr2fagm1ZXVMHg-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Jun
 2021 14:08:36 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Thu, 24 Jun 2021 14:08:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?utf-8?B?J1Rva2UgSMO4aWxhbmQtSsO4cmdlbnNlbic=?= <toke@redhat.com>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH net-next v3 2/5] bitops: add non-atomic bitops for
 pointers
Thread-Topic: [PATCH net-next v3 2/5] bitops: add non-atomic bitops for
 pointers
Thread-Index: AQHXaCAwV0vR/9EzC02g7KfO67nDyqsjIkFA
Date:   Thu, 24 Jun 2021 13:08:36 +0000
Message-ID: <efba2726208045398f40fab7a9dc35e6@AcuMS.aculab.com>
References: <20210622202835.1151230-1-memxor@gmail.com>
 <20210622202835.1151230-3-memxor@gmail.com> <871r8tpnws.fsf@toke.dk>
 <20210622221023.gklikg5yib4ky35m@apollo> <87y2b1o7h9.fsf@toke.dk>
 <20210622231606.6ak5shta5bknt7lb@apollo> <87bl7won1v.fsf@toke.dk>
In-Reply-To: <87bl7won1v.fsf@toke.dk>
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

RnJvbTogVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuDQo+IFNlbnQ6IDIzIEp1bmUgMjAyMSAxMjow
OQ0KPiBLdW1hciBLYXJ0aWtleWEgRHdpdmVkaSA8bWVteG9yQGdtYWlsLmNvbT4gd3JpdGVzOg0K
PiANCj4gPiBPbiBXZWQsIEp1biAyMywgMjAyMSBhdCAwNDowMzowNkFNIElTVCwgVG9rZSBIw7hp
bGFuZC1Kw7hyZ2Vuc2VuIHdyb3RlOg0KPiA+PiBLdW1hciBLYXJ0aWtleWEgRHdpdmVkaSA8bWVt
eG9yQGdtYWlsLmNvbT4gd3JpdGVzOg0KPiA+Pg0KPiA+PiA+IE9uIFdlZCwgSnVuIDIzLCAyMDIx
IGF0IDAzOjIyOjUxQU0gSVNULCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gd3JvdGU6DQo+ID4+
ID4+IEt1bWFyIEthcnRpa2V5YSBEd2l2ZWRpIDxtZW14b3JAZ21haWwuY29tPiB3cml0ZXM6DQo+
ID4+ID4+DQo+ID4+ID4+ID4gY3B1bWFwIG5lZWRzIHRvIHNldCwgY2xlYXIsIGFuZCB0ZXN0IHRo
ZSBsb3dlc3QgYml0IGluIHNrYiBwb2ludGVyIGluDQo+ID4+ID4+ID4gdmFyaW91cyBwbGFjZXMu
IFRvIG1ha2UgdGhlc2UgY2hlY2tzIGxlc3Mgbm9pc3ksIGFkZCBwb2ludGVyIGZyaWVuZGx5DQo+
ID4+ID4+ID4gYml0b3AgbWFjcm9zIHRoYXQgYWxzbyBkbyBzb21lIHR5cGVjaGVja2luZyB0byBz
YW5pdGl6ZSB0aGUgYXJndW1lbnQuDQo+ID4+ID4+ID4NCj4gPj4gPj4gPiBUaGVzZSB3cmFwIHRo
ZSBub24tYXRvbWljIGJpdG9wcyBfX3NldF9iaXQsIF9fY2xlYXJfYml0LCBhbmQgdGVzdF9iaXQN
Cj4gPj4gPj4gPiBidXQgZm9yIHBvaW50ZXIgYXJndW1lbnRzLiBQb2ludGVyJ3MgYWRkcmVzcyBo
YXMgdG8gYmUgcGFzc2VkIGluIGFuZCBpdA0KPiA+PiA+PiA+IGlzIHRyZWF0ZWQgYXMgYW4gdW5z
aWduZWQgbG9uZyAqLCBzaW5jZSB3aWR0aCBhbmQgcmVwcmVzZW50YXRpb24gb2YNCj4gPj4gPj4g
PiBwb2ludGVyIGFuZCB1bnNpZ25lZCBsb25nIG1hdGNoIG9uIHRhcmdldHMgTGludXggc3VwcG9y
dHMuIFRoZXkgYXJlDQo+ID4+ID4+ID4gcHJlZml4ZWQgd2l0aCBkb3VibGUgdW5kZXJzY29yZSB0
byBpbmRpY2F0ZSBsYWNrIG9mIGF0b21pY2l0eS4NCj4gPj4gPj4gPg0KPiA+PiA+PiA+IFNpZ25l
ZC1vZmYtYnk6IEt1bWFyIEthcnRpa2V5YSBEd2l2ZWRpIDxtZW14b3JAZ21haWwuY29tPg0KPiA+
PiA+PiA+IC0tLQ0KPiA+PiA+PiA+ICBpbmNsdWRlL2xpbnV4L2JpdG9wcy5oICAgIHwgMTkgKysr
KysrKysrKysrKysrKysrKw0KPiA+PiA+PiA+ICBpbmNsdWRlL2xpbnV4L3R5cGVjaGVjay5oIHwg
MTAgKysrKysrKysrKw0KPiA+PiA+PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMo
KykNCj4gPj4gPj4gPg0KPiA+PiA+PiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2JpdG9w
cy5oIGIvaW5jbHVkZS9saW51eC9iaXRvcHMuaA0KPiA+PiA+PiA+IGluZGV4IDI2YmYxNWU2Y2Qz
NS4uYTllMzM2YjlmYTRkIDEwMDY0NA0KPiA+PiA+PiA+IC0tLSBhL2luY2x1ZGUvbGludXgvYml0
b3BzLmgNCj4gPj4gPj4gPiArKysgYi9pbmNsdWRlL2xpbnV4L2JpdG9wcy5oDQo+ID4+ID4+ID4g
QEAgLTQsNiArNCw3IEBADQo+ID4+ID4+ID4NCj4gPj4gPj4gPiAgI2luY2x1ZGUgPGFzbS90eXBl
cy5oPg0KPiA+PiA+PiA+ICAjaW5jbHVkZSA8bGludXgvYml0cy5oPg0KPiA+PiA+PiA+ICsjaW5j
bHVkZSA8bGludXgvdHlwZWNoZWNrLmg+DQo+ID4+ID4+ID4NCj4gPj4gPj4gPiAgI2luY2x1ZGUg
PHVhcGkvbGludXgva2VybmVsLmg+DQo+ID4+ID4+ID4NCj4gPj4gPj4gPiBAQCAtMjUzLDYgKzI1
NCwyNCBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZvaWQgX19hc3NpZ25fYml0KGxvbmcgbnIs
IHZvbGF0aWxlIHVuc2lnbmVkIGxvbmcNCj4gKmFkZHIsDQo+ID4+ID4+ID4gIAkJX19jbGVhcl9i
aXQobnIsIGFkZHIpOw0KPiA+PiA+PiA+ICB9DQo+ID4+ID4+ID4NCj4gPj4gPj4gPiArI2RlZmlu
ZSBfX3B0cl9zZXRfYml0KG5yLCBhZGRyKSAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4+
ID4+ID4gKwkoeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBc
DQo+ID4+ID4+ID4gKwkJdHlwZWNoZWNrX3BvaW50ZXIoKihhZGRyKSk7ICAgICAgICAgICAgIFwN
Cj4gPj4gPj4gPiArCQlfX3NldF9iaXQobnIsICh1bnNpZ25lZCBsb25nICopKGFkZHIpKTsgXA0K
PiA+PiA+PiA+ICsJfSkNCj4gPj4gPj4gPiArDQo+ID4+ID4+ID4gKyNkZWZpbmUgX19wdHJfY2xl
YXJfYml0KG5yLCBhZGRyKSAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4+ID4+ID4gKwko
eyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPj4g
Pj4gPiArCQl0eXBlY2hlY2tfcG9pbnRlcigqKGFkZHIpKTsgICAgICAgICAgICAgICBcDQo+ID4+
ID4+ID4gKwkJX19jbGVhcl9iaXQobnIsICh1bnNpZ25lZCBsb25nICopKGFkZHIpKTsgXA0KPiA+
PiA+PiA+ICsJfSkNCj4gPj4gPj4gPiArDQo+ID4+ID4+ID4gKyNkZWZpbmUgX19wdHJfdGVzdF9i
aXQobnIsIGFkZHIpICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4+ID4+ID4gKwkoeyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPj4gPj4gPiArCQl0
eXBlY2hlY2tfcG9pbnRlcigqKGFkZHIpKTsgICAgICAgICAgICBcDQo+ID4+ID4+ID4gKwkJdGVz
dF9iaXQobnIsICh1bnNpZ25lZCBsb25nICopKGFkZHIpKTsgXA0KPiA+PiA+PiA+ICsJfSkNCj4g
Pj4gPj4gPiArDQo+ID4+ID4+DQo+ID4+ID4+IEJlZm9yZSB0aGVzZSB3ZXJlIGZ1bmN0aW9ucyB0
aGF0IHJldHVybmVkIHRoZSBtb2RpZmllZCB2YWx1ZXMsIG5vdyB0aGV5DQo+ID4+ID4+IGFyZSBt
YWNyb3MgdGhhdCBtb2RpZnkgaW4tcGxhY2UuIFdoeSB0aGUgY2hhbmdlPyA6KQ0KPiA+PiA+Pg0K
PiA+PiA+DQo+ID4+ID4gR2l2ZW4gdGhhdCB3ZSdyZSBleHBvcnRpbmcgdGhpcyB0byBhbGwga2Vy
bmVsIHVzZXJzIG5vdywgaXQgZmVsdCBtb3JlDQo+ID4+ID4gYXBwcm9wcmlhdGUgdG8gZm9sbG93
IHRoZSBleGlzdGluZyBjb252ZW50aW9uL2FyZ3VtZW50IG9yZGVyIGZvciB0aGUNCj4gPj4gPiBm
dW5jdGlvbnMvb3BzIHRoZXkgYXJlIHdyYXBwaW5nLg0KPiA+Pg0KPiA+PiBJIHdhc24ndCB0YWxr
aW5nIGFib3V0IHRoZSBvcmRlciBvZiB0aGUgYXJndW1lbnRzOyBzd2FwcGluZyB0aG9zZSBpcw0K
PiA+PiBmaW5lLiBCdXQgYmVmb3JlLCB5b3UgaGFkOg0KPiA+Pg0KPiA+PiBzdGF0aWMgdm9pZCAq
X19wdHJfc2V0X2JpdCh2b2lkICpwdHIsIGludCBiaXQpDQo+ID4+DQo+ID4+IHdpdGggdXNhZ2Ug
KGZ1bmN0aW9uIHJldHVybiBpcyB0aGUgbW9kaWZpZWQgdmFsdWUpOg0KPiA+PiByZXQgPSBwdHJf
cmluZ19wcm9kdWNlKHJjcHUtPnF1ZXVlLCBfX3B0cl9zZXRfYml0KHNrYiwgMCkpOw0KPiA+Pg0K
PiA+PiBub3cgeW91IGhhdmU6DQo+ID4+ICNkZWZpbmUgX19wdHJfc2V0X2JpdChuciwgYWRkcikN
Cj4gPj4NCj4gPj4gd2l0aCB1c2FnZSAobW9kaWZpZXMgYXJndW1lbnQgaW4tcGxhY2UpOg0KPiA+
PiBfX3B0cl9zZXRfYml0KDAsICZza2IpOw0KPiA+PiByZXQgPSBwdHJfcmluZ19wcm9kdWNlKHJj
cHUtPnF1ZXVlLCBza2IpOw0KPiA+Pg0KPiA+PiB3aHkgY2hhbmdlIGZyb20gZnVuY3Rpb24gdG8g
bWFjcm8/DQo+ID4+DQo+ID4NCj4gPiBFYXJsaWVyIGl0IGp1c3QgdG9vayB0aGUgcG9pbnRlciB2
YWx1ZSBhbmQgcmV0dXJuZWQgb25lIHdpdGggdGhlIGJpdCBzZXQuIEkNCj4gPiBjaGFuZ2VkIGl0
IHRvIHdvcmsgc2ltaWxhciB0byBfX3NldF9iaXQuDQo+IA0KPiBIbW0sIG9rYXksIGZhaXIgZW5v
dWdoIEkgc3VwcG9zZSB0aGVyZSdzIHNvbWV0aGluZyB0byBiZSBzYWlkIGZvcg0KPiBjb25zaXN0
ZW5jeSwgZXZlbiB0aG91Z2ggSSBwZXJzb25hbGx5IHByZWZlciB0aGUgZnVuY3Rpb24gc3R5bGUu
IExldCdzDQo+IGtlZXAgaXQgYXMgbWFjcm9zLCB0aGVuIDopDQoNClBhc3NpbmcgdGhlIGFkZHJl
c3Mgb2YgdGhlIHBvaW50ZXIgd2lsbCB0cmFzaCBhIGxvdCBvZiBvcHRpbWlzYXRpb25zLg0KWW91
IGRvIHJlYWxseSB3YW50IHRvIHVzZSB0aGUgcmV0dXJuIGFkZHJlc3MuDQpPciwgZXZlbiBiZXR0
ZXIsIGdldCB0aGUgd2hvbGUgdGhpbmcgaW5saW5lZC4NCg0KU28gc29tZXRoaW5nIGxpa2U6DQoj
ZGVmaW5lIHB0cl9zZXRfYml0KHB0ciwgdmFsKSAoKHR5cGVvZiAocHRyKSkoKHVuc2lnbmVkIGxv
bmcpKHB0cikgfCAoMSA8PCAodmFsKSkpKQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRy
ZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1L
MSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

