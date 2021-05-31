Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CBE3956FE
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhEaIct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:32:49 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:55507 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230070AbhEaIcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:32:48 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-198-CoR4ZBysM4G8M_zYvNcdaQ-1; Mon, 31 May 2021 09:31:01 +0100
X-MC-Unique: CoR4ZBysM4G8M_zYvNcdaQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 31 May 2021 09:30:58 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Mon, 31 May 2021 09:30:58 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Cong Wang' <xiyou.wangcong@gmail.com>,
        Changbin Du <changbin.du@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH] net: fix oops in socket ioctl cmd SIOCGSKNS when NET_NS
 is disabled
Thread-Topic: [PATCH] net: fix oops in socket ioctl cmd SIOCGSKNS when NET_NS
 is disabled
Thread-Index: AQHXVL71XtaXo5XAQUOXarFFVJFJfar9RGXg
Date:   Mon, 31 May 2021 08:30:58 +0000
Message-ID: <55effe20acc54ea4a96ea86015d99a5b@AcuMS.aculab.com>
References: <20210529060526.422987-1-changbin.du@gmail.com>
 <CAM_iQpWwApLVg39rUkyXxnhsiP0SZf=0ft6vsq=VxFtJ2SumAQ@mail.gmail.com>
In-Reply-To: <CAM_iQpWwApLVg39rUkyXxnhsiP0SZf=0ft6vsq=VxFtJ2SumAQ@mail.gmail.com>
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

RnJvbTogQ29uZyBXYW5nDQo+IFNlbnQ6IDI5IE1heSAyMDIxIDIwOjE1DQo+IA0KPiBPbiBGcmks
IE1heSAyOCwgMjAyMSBhdCAxMTowOCBQTSBDaGFuZ2JpbiBEdSA8Y2hhbmdiaW4uZHVAZ21haWwu
Y29tPiB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L3NvY2tldC5jIGIvbmV0L3NvY2tldC5j
DQo+ID4gaW5kZXggMjdlM2U3ZDUzZjhlLi42NDRiNDYxMTJkMzUgMTAwNjQ0DQo+ID4gLS0tIGEv
bmV0L3NvY2tldC5jDQo+ID4gKysrIGIvbmV0L3NvY2tldC5jDQo+ID4gQEAgLTExNDksMTEgKzEx
NDksMTUgQEAgc3RhdGljIGxvbmcgc29ja19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZSwgdW5zaWdu
ZWQgY21kLCB1bnNpZ25lZCBsb25nIGFyZykNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBt
dXRleF91bmxvY2soJnZsYW5faW9jdGxfbXV0ZXgpOw0KPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgICBjYXNlIFNJT0NHU0tOUzoNCj4gPiArI2lm
ZGVmIENPTkZJR19ORVRfTlMNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBlcnIgPSAtRVBF
Uk07DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgKCFuc19jYXBhYmxlKG5ldC0+dXNl
cl9ucywgQ0FQX05FVF9BRE1JTikpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBicmVhazsNCj4gPg0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGVyciA9IG9wZW5fcmVs
YXRlZF9ucygmbmV0LT5ucywgZ2V0X25ldF9ucyk7DQo+ID4gKyNlbHNlDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgZXJyID0gLUVOT1RTVVBQOw0KPiA+ICsjZW5kaWYNCj4gDQo+IEkgd29u
ZGVyIGlmIGl0IGlzIGVhc2llciBpZiB3ZSBqdXN0IHJlamVjdCBucy0+b3BzPT1OVUxMIGNhc2UN
Cj4gaW4gb3Blbl9yZWxhdGVkX25zKCkuIEZvciAxKSB3ZSBjYW4gc2F2ZSBhbiB1Z2x5ICNpZmRl
ZiBoZXJlOw0KPiAyKSBkcml2ZXJzL25ldC90dW4uYyBoYXMgdGhlIHNhbWUgYnVncy4NCg0KSWYg
Q09ORklHX05FVF9OUyBpcyB1bnNldCB0aGVuIHdoeSBub3QgbWFrZSBib3RoIG5zX2NhcGFibGUo
KQ0KYW5kIG9wZW5fcmVsYXRlZF9ucygpIHVuY29uZGl0aW9uYWxseSByZXR1cm4gLUVOT1RTVVBQ
Pw0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K

