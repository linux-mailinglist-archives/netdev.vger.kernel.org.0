Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990933B1744
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 11:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhFWJwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 05:52:47 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:21560 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229833AbhFWJwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 05:52:46 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-131-n5qeiCwrNTKvyMAR3gHqsw-1; Wed, 23 Jun 2021 10:50:26 +0100
X-MC-Unique: n5qeiCwrNTKvyMAR3gHqsw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 10:50:25 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 23 Jun 2021 10:50:25 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xin Long' <lucien.xin@gmail.com>
CC:     network dev <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>
Subject: RE: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization
 Layer Path MTU Discovery for SCTP transport
Thread-Topic: [PATCHv2 net-next 00/14] sctp: implement RFC8899: Packetization
 Layer Path MTU Discovery for SCTP transport
Thread-Index: AQHXZ5Gk1m/0BhrSYEC4nBP7A0Tb5KsglL6QgABhdaSAAFqyIA==
Date:   Wed, 23 Jun 2021 09:50:25 +0000
Message-ID: <8328f935ec4f488e8d95486a7564aec0@AcuMS.aculab.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
 <cfaa01992d064520b3a9138983e8ec41@AcuMS.aculab.com>
 <CADvbK_e7D4s81vS0rq=P4mQe47dshJgQzaWnrUyCi-Cis4xyhQ@mail.gmail.com>
 <CADvbK_eeJVoWps8UrygEfNdXL76Q2XMoNOoELWHFqOTq2634cA@mail.gmail.com>
In-Reply-To: <CADvbK_eeJVoWps8UrygEfNdXL76Q2XMoNOoELWHFqOTq2634cA@mail.gmail.com>
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

RnJvbTogWGluIExvbmcNCj4gU2VudDogMjMgSnVuZSAyMDIxIDA0OjQ5DQouLi4NCj4gWzEwM10g
cGxfc2VuZDogUExQTVRVRDogc3RhdGU6IDEsIHNpemU6IDEyMDAsIGhpZ2g6IDAgPC0tW2FdDQo+
IFsxMDNdIHBsX3JlY3Y6IFBMUE1UVUQ6IHN0YXRlOiAxLCBzaXplOiAxMjAwLCBoaWdoOiAwDQou
Li4NCj4gWzEwM10gcGxfc2VuZDogUExQTVRVRDogc3RhdGU6IDIsIHNpemU6IDE0NTYsIGhpZ2g6
IDANCj4gWzEwM10gcGxfcmVjdjogUExQTVRVRDogc3RhdGU6IDIsIHNpemU6IDE0NTYsIGhpZ2g6
IDAgIDwtLVtiXQ0KPiBbMTAzXSBwbF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ4
OCwgaGlnaDogMA0KPiBbMTA4XSBwbF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ4
OCwgaGlnaDogMA0KPiBbMTEzXSBwbF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ4
OCwgaGlnaDogMA0KPiBbMTE4XSBwbF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ4
OCwgaGlnaDogMA0KPiBbMTE4XSBwbF9yZWN2OiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ1
NiwgaGlnaDogMTQ4OCA8LS0tW2NdDQo+IFsxMThdIHBsX3NlbmQ6IFBMUE1UVUQ6IHN0YXRlOiAy
LCBzaXplOiAxNDYwLCBoaWdoOiAxNDg4DQo+IFsxMThdIHBsX3JlY3Y6IFBMUE1UVUQ6IHN0YXRl
OiAyLCBzaXplOiAxNDYwLCBoaWdoOiAxNDg4IDwtLS0gW2RdDQo+IFsxMThdIHBsX3NlbmQ6IFBM
UE1UVUQ6IHN0YXRlOiAyLCBzaXplOiAxNDY0LCBoaWdoOiAxNDg4DQo+IFsxMjRdIHBsX3NlbmQ6
IFBMUE1UVUQ6IHN0YXRlOiAyLCBzaXplOiAxNDY0LCBoaWdoOiAxNDg4DQo+IFsxMjldIHBsX3Nl
bmQ6IFBMUE1UVUQ6IHN0YXRlOiAyLCBzaXplOiAxNDY0LCBoaWdoOiAxNDg4DQo+IFsxMzRdIHBs
X3NlbmQ6IFBMUE1UVUQ6IHN0YXRlOiAyLCBzaXplOiAxNDY0LCBoaWdoOiAxNDg4DQo+IFsxMzRd
IHBsX3JlY3Y6IFBMUE1UVUQ6IHN0YXRlOiAyLCBzaXplOiAxNDYwLCBoaWdoOiAxNDY0IDwtLSBh
cm91bmQNCj4gMzBzICJzZWFyY2ggY29tcGxldGUgZnJvbSAxMjAwIGJ5dGVzIg0KPiBbMjg3XSBw
bF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMywgc2l6ZTogMTQ2MCwgaGlnaDogMA0KPiBbMjg3XSBw
bF9yZWN2OiBQTFBNVFVEOiBzdGF0ZTogMywgc2l6ZTogMTQ2MCwgaGlnaDogMA0KPiBbMjg3XSBw
bF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ2NCwgaGlnaDogMCA8LS0gW2FhXQ0K
PiBbMjkyXSBwbF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ2NCwgaGlnaDogMA0K
PiBbMjk4XSBwbF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ2NCwgaGlnaDogMA0K
PiBbMzAzXSBwbF9zZW5kOiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ2NCwgaGlnaDogMA0K
PiBbMzAzXSBwbF9yZWN2OiBQTFBNVFVEOiBzdGF0ZTogMiwgc2l6ZTogMTQ2MCwgaGlnaDogMTQ2
NCAgPC0tW2JiXSAgPC0tDQo+IGFyb3VuZCAxNXMgInJlLXNlYXJjaCBjb21wbGV0ZSBmcm9tIGN1
cnJlbnQgcG10dSINCj4gDQo+IFNvIHNpbmNlIG5vIGludGVydmFsIHRvIHNlbmQgdGhlIG5leHQg
cHJvYmUgd2hlbiB0aGUgQUNLIGlzIHJlY2VpdmVkDQo+IGZvciB0aGUgbGFzdCBvbmUsDQo+IGl0
IHdvbid0IHRha2UgbXVjaCB0aW1lIGZyb20gW2FdIHRvIFtiXSwgYW5kIFtjXSB0byBbZF0sDQo+
IGFuZCB0aGVyZSBhcmUgYXQgbW9zdCAyIGZhaWx1cmVzIHRvIGZpbmQgdGhlIHJpZ2h0IHBtdHUs
IGVhY2ggZmFpbHVyZQ0KPiB0YWtlcyA1cyAqIDMgPSAxNXMuDQo+IA0KPiB3aGVuIGl0IGdvZXMg
YmFjayB0byBzZWFyY2ggZnJvbSBzZWFyY2ggY29tcGxldGUgYWZ0ZXIgYSBsb25nIHRpbWVvdXQs
DQo+IGl0IHdpbGwgdGFrZSBvbmx5IDEgZmFpbHVyZSB0byBnZXQgdGhlIHJpZ2h0IHBtdHUgZnJv
bSBbYWFdIHRvIFtiYl0uDQoNCldoYXQgbXR1IGlzIGJlaW5nIHVzZWQgZHVyaW5nIHRoZSAnZmFp
bHVyZXMnID8NCkkgaG9wZSBpdCBpcyB0aGUgbGFzdCB3b3JraW5nIG9uZS4NCg0KQWxzbywgd2hh
dCBhY3R1YWxseSBoYXBwZW4gaWYgdGhlIG5ldHdvcmsgcm91dGUgY2hhbmdlcyBmcm9tDQpvbmUg
dGhhdCBzdXBwb3J0cyAxNDYwIGJ5dGVzIHRvIG9uZSB0aGF0IG9ubHkgc3VwcG9ydHMgMTIwMA0K
YW5kIHdoZXJlIElDTVAgZXJyb3JzIGFyZSBub3QgZ2VuZXJhdGVkPw0KDQpUaGUgZmlyc3QgcHJv
dG9jb2wgcmV0cnkgaXMgKHByb2JhYmx5KSBhZnRlciAyIHNlY29uZHMuDQpCdXQgaXQgd2lsbCB1
c2UgdGhlIDE0NjAgYnl0ZSBtdHUgYW5kIGZhaWwgYWdhaW4uDQoNCk5vdHdpdGhzdGFuZGluZyB0
aGUgc3RhbmRhcmRzLCB3aGF0IHBtdHUgYWN0dWFsbHkgZXhpc3QNCidpbiB0aGUgd2lsZCcgZm9y
IG5vcm1hbCBuZXR3b3Jrcz8NCkFyZSB0aGVyZSBhY3R1YWxseSBhbnkgb3RoZXJzIGFwYXJ0IGZy
b20gJ2Z1bGwgc2l6ZWQgZXRoZXJuZXQnDQphbmQgJ1BQUG9FJz8NClNvIHdvdWxkIGl0IGFjdHVh
bGx5IGJldHRlciB0byBzZW5kIHR3byBwcm9iZXMgb25lIGZvcg0KZWFjaCBvZiB0aG9zZSB0d28g
c2l6ZXMgYW5kIHNlZSB3aGljaCBvbmVzIHJlc3BvbmQ/DQoNCihJJ20gbm90IHN1cmUgd2UgZXZl
ciBtYW5hZ2UgdG8gc2VuZCBmdWxsIGxlbmd0aCBwYWNrZXRzLg0KT3VyIGRhdGEgaXMgTTNVQSAo
bW9zdGx5IFNNUykgYW5kIHNlbnQgd2l0aCBOYWdsZSBkaXNhYmxlZC4NClNvIGV2ZW4gdGhlIGN1
c3RvbWVycyBzZW5kaW5nIDEwMDBzIG9mIFNNUy9zZWMgYXJlIHVubGlrZWx5DQp0byBmaWxsIHBh
Y2tldHMuKQ0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFt
bGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3Ry
YXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

