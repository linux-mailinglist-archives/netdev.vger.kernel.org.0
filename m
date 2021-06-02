Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D913986BA
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 12:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhFBKns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 06:43:48 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:20692 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229603AbhFBKnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 06:43:24 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-43-zpJFYy08PGmtHOmQlbJROg-1; Wed, 02 Jun 2021 11:41:36 +0100
X-MC-Unique: zpJFYy08PGmtHOmQlbJROg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.18; Wed, 2 Jun 2021 11:41:35 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 2 Jun 2021 11:41:35 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christian Brauner' <christian.brauner@ubuntu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH] nsfs: fix oops when ns->ops is not provided
Thread-Topic: [PATCH] nsfs: fix oops when ns->ops is not provided
Thread-Index: AQHXV5AByooY9TtpI0OnrqOz4Es786sAiDRw
Date:   Wed, 2 Jun 2021 10:41:35 +0000
Message-ID: <42fa84fe3dc148dea63096db24a039ae@AcuMS.aculab.com>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein>
In-Reply-To: <20210602091451.kbdul6nhobilwqvi@wittgenstein>
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

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMDIgSnVuZSAyMDIxIDEwOjE1DQouLi4N
Cj4gSG0sIEkgdGhpbmsgYSBjb21waWxlIHRpbWUgY2hlY2sgaXMgYmV0dGVyIHRoYW4gYSBydW50
aW1lIGNoZWNrDQo+IGluZGVwZW5kZW50IG9mIHBlcmZvcm1hbmNlIGJlbmVmaXRzLg0KPiANCj4g
Pg0KPiA+IDIpIFRoZXJlIGFyZSAzIGRpZmZlcmVudCBwbGFjZXMgKHR1biBoYXMgdHdvIG1vcmUp
IHRoYXQgbmVlZCB0aGUgc2FtZQ0KPiA+IGZpeC4NCj4gDQo+IA0KPiA+DQo+ID4gMykgaW5pdF9u
ZXQgYWx3YXlzIGV4aXRzLCBleGNlcHQgaXQgZG9lcyBub3QgaGF2ZSBhbiBvcHMgd2hlbg0KPiA+
IENPTkZJR19ORVRfTlMgaXMgZGlzYWJsZWQ6DQo+IA0KPiBXaGljaCBpcyB0cnVlIGZvciBldmVy
eSBuYW1lc3BhY2UuDQo+IA0KPiA+DQo+ID4gc3RhdGljIF9fbmV0X2luaXQgaW50IG5ldF9uc19u
ZXRfaW5pdChzdHJ1Y3QgbmV0ICpuZXQpDQo+ID4gew0KPiA+ICNpZmRlZiBDT05GSUdfTkVUX05T
DQo+ID4gICAgICAgICBuZXQtPm5zLm9wcyA9ICZuZXRuc19vcGVyYXRpb25zOw0KPiA+ICNlbmRp
Zg0KPiA+ICAgICAgICAgcmV0dXJuIG5zX2FsbG9jX2ludW0oJm5ldC0+bnMpOw0KPiA+IH0NCj4g
Pg0KPiA+IDQpICpJIHRoaW5rKiBvdGhlciBuYW1lc3BhY2VzIG5lZWQgdGhpcyBmaXggdG9vLCBm
b3IgaW5zdGFuY2UNCj4gPiBpbml0X2lwY19uczoNCj4gDQo+IE5vbmUgb2YgdGhlbSBzaG91bGQg
aGF2ZSBwYXRocyB0byB0cmlnZ2VyIC0+b3BzLg0KPiANCj4gPg0KPiA+IHN0cnVjdCBpcGNfbmFt
ZXNwYWNlIGluaXRfaXBjX25zID0gew0KPiA+ICAgICAgICAgLm5zLmNvdW50ID0gUkVGQ09VTlRf
SU5JVCgxKSwNCj4gPiAgICAgICAgIC51c2VyX25zID0gJmluaXRfdXNlcl9ucywNCj4gPiAgICAg
ICAgIC5ucy5pbnVtID0gUFJPQ19JUENfSU5JVF9JTk8sDQo+ID4gI2lmZGVmIENPTkZJR19JUENf
TlMNCj4gPiAgICAgICAgIC5ucy5vcHMgPSAmaXBjbnNfb3BlcmF0aW9ucywNCj4gPiAjZW5kaWYN
Cj4gPiB9Ow0KPiA+DQo+ID4gd2hvc2UgbnMtPm9wcyBpcyBOVUxMIHRvbyBpZiBkaXNhYmxlZC4N
Cj4gDQo+IEJ1dCB0aGUgcG9pbnQgaXMgdGhhdCBucy0+b3BzIHNob3VsZCBuZXZlciBiZSBhY2Nl
c3NlZCB3aGVuIHRoYXQNCj4gbmFtZXNwYWNlIHR5cGUgaXMgZGlzYWJsZWQuIE9yIGluIG90aGVy
IHdvcmRzLCB0aGUgYnVnIGlzIHRoYXQgc29tZXRoaW5nDQo+IGluIG5ldG5zIG1ha2VzIHVzZSBv
ZiBuYW1lc3BhY2UgZmVhdHVyZXMgd2hlbiB0aGV5IGFyZSBkaXNhYmxlZC4gSWYgd2UNCj4gaGFu
ZGxlIC0+b3BzIGJlaW5nIE5VTEwgd2UgbWlnaHQgYmUgdGFwZXJpbmcgb3ZlciBhIHJlYWwgYnVn
IHNvbWV3aGVyZS4NCj4gDQo+IEpha3ViJ3MgcHJvcG9zYWwgaW4gdGhlIG90aGVyIG1haWwgbWFr
ZXMgc2Vuc2UgYW5kIGZhbGxzIGluIGxpbmUgd2l0aA0KPiBob3cgdGhlIHJlc3Qgb2YgdGhlIG5l
dG5zIGdldHRlcnMgYXJlIGltcGxlbWVudGVkLiBGb3IgZXhhbXBsZQ0KPiBnZXRfbmV0X25zX2Zk
X2ZkKCk6DQo+IA0KPiAjaWZkZWYgQ09ORklHX05FVF9OUw0KPiANCj4gWy4uLl0NCj4gDQo+IHN0
cnVjdCBuZXQgKmdldF9uZXRfbnNfYnlfZmQoaW50IGZkKQ0KPiB7DQo+IAlzdHJ1Y3QgZmlsZSAq
ZmlsZTsNCj4gCXN0cnVjdCBuc19jb21tb24gKm5zOw0KPiAJc3RydWN0IG5ldCAqbmV0Ow0KPiAN
Cj4gCWZpbGUgPSBwcm9jX25zX2ZnZXQoZmQpOw0KPiAJaWYgKElTX0VSUihmaWxlKSkNCj4gCQly
ZXR1cm4gRVJSX0NBU1QoZmlsZSk7DQo+IA0KPiAJbnMgPSBnZXRfcHJvY19ucyhmaWxlX2lub2Rl
KGZpbGUpKTsNCj4gCWlmIChucy0+b3BzID09ICZuZXRuc19vcGVyYXRpb25zKQ0KPiAJCW5ldCA9
IGdldF9uZXQoY29udGFpbmVyX29mKG5zLCBzdHJ1Y3QgbmV0LCBucykpOw0KPiAJZWxzZQ0KPiAJ
CW5ldCA9IEVSUl9QVFIoLUVJTlZBTCk7DQo+IA0KPiAJZnB1dChmaWxlKTsNCj4gCXJldHVybiBu
ZXQ7DQo+IH0NCj4gDQo+ICNlbHNlDQo+IHN0cnVjdCBuZXQgKmdldF9uZXRfbnNfYnlfZmQoaW50
IGZkKQ0KPiB7DQo+IAlyZXR1cm4gRVJSX1BUUigtRUlOVkFMKTsNCj4gfQ0KPiAjZW5kaWYNCj4g
RVhQT1JUX1NZTUJPTF9HUEwoZ2V0X25ldF9uc19ieV9mZCk7DQo+IA0KPiAoSXQgc2VlbXMgdGhh
dCAiZ2V0X25ldF9ucygpIiBjb3VsZCBhbHNvIGJlIG1vdmVkIGludG8gdGhlIHNhbWUgZmlsZSBh
cw0KPiBnZXRfbmV0X25zX2J5X2ZkKCkgYnR3LikNCg0KVGhlIGRlZmF1bHQgaW1wbGVtZW50YXRp
b24gb3VnaHQgdG8gYmUgaW4gdGhlIC5oIGZpbGUuDQpTbyBpdCBnZXRzIGlubGluZWQgYnkgdGhl
IGNvbXBpbGVyLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBC
cmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdp
c3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

