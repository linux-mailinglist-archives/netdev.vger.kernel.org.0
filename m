Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299364559AD
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343709AbhKRLME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:12:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:39568 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343623AbhKRLLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:11:25 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-267-yIaQ9ldLMt-dGp5bzBnaGQ-1; Thu, 18 Nov 2021 11:08:20 +0000
X-MC-Unique: yIaQ9ldLMt-dGp5bzBnaGQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Thu, 18 Nov 2021 11:08:19 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Thu, 18 Nov 2021 11:08:19 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sergey Shtylyov' <s.shtylyov@omp.ru>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH -next] ethernet: renesas: Use div64_ul instead of do_div
Thread-Topic: [PATCH -next] ethernet: renesas: Use div64_ul instead of do_div
Thread-Index: AQHX3FvXWbL1hyrH7EOl5fQWEw6276wJH72w
Date:   Thu, 18 Nov 2021 11:08:19 +0000
Message-ID: <ca35a5ba3970462d8eba69ab440da1b3@AcuMS.aculab.com>
References: <1637203805-125780-1-git-send-email-yang.lee@linux.alibaba.com>
 <6851a10a-e7cf-b533-ab9d-0df539bbba00@omp.ru>
In-Reply-To: <6851a10a-e7cf-b533-ab9d-0df539bbba00@omp.ru>
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

RnJvbTogU2VyZ2V5IFNodHlseW92DQo+IFNlbnQ6IDE4IE5vdmVtYmVyIDIwMjEgMDk6MDgNCj4g
T24gMTguMTEuMjAyMSA1OjUwLCBZYW5nIExpIHdyb3RlOg0KPiANCj4gPiBkb19kaXYoKSBkb2Vz
IGEgNjQtYnktMzIgZGl2aXNpb24uIEhlcmUgdGhlIGRpdmlzb3IgaXMgYW4NCj4gPiB1bnNpZ25l
ZCBsb25nIHdoaWNoIG9uIHNvbWUgcGxhdGZvcm1zIGlzIDY0IGJpdCB3aWRlLiBTbyB1c2UNCj4g
PiBkaXY2NF91bCBpbnN0ZWFkIG9mIGRvX2RpdiB0byBhdm9pZCBhIHBvc3NpYmxlIHRydW5jYXRp
b24uDQo+ID4NCj4gPiBFbGltaW5hdGUgdGhlIGZvbGxvd2luZyBjb2NjaWNoZWNrIHdhcm5pbmc6
DQo+ID4gLi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL212cHAyL212cHAyX21haW4uYzoy
NzQyOjEtNzogV0FSTklORzoNCj4gPiBkb19kaXYoKSBkb2VzIGEgNjQtYnktMzIgZGl2aXNpb24s
IHBsZWFzZSBjb25zaWRlciB1c2luZyBkaXY2NF91bA0KPiA+IGluc3RlYWQuDQo+ID4NCj4gPiBS
ZXBvcnRlZC1ieTogQWJhY2kgUm9ib3QgPGFiYWNpQGxpbnV4LmFsaWJhYmEuY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFlhbmcgTGkgPHlhbmcubGVlQGxpbnV4LmFsaWJhYmEuY29tPg0KPiA+IC0t
LQ0KPiA+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDIgKy0N
Cj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+
DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXgg
YjRjNTk3Zi4uMmI4OTcxMCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiX21haW4uYw0KPiA+IEBAIC0yNDg5LDcgKzI0ODksNyBAQCBzdGF0aWMgaW50IHJhdmJf
c2V0X2d0aShzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gPiAgIAkJcmV0dXJuIC1FSU5WQUw7
DQo+ID4NCj4gPiAgIAlpbmMgPSAxMDAwMDAwMDAwVUxMIDw8IDIwOw0KPiA+IC0JZG9fZGl2KGlu
YywgcmF0ZSk7DQo+ID4gKwlpbmMgPSBkaXY2NF91bChpbmMsIHJhdGUpOw0KPiANCj4gICAgIFdo
eSBub3QganVzdDoNCj4gDQo+IAlpbmMgPSBkaXY2NF91bCgxMDAwMDAwMDAwVUxMIDw8IDIwLCBy
YXRlKTsNCj4gDQo+ID4gICAJaWYgKGluYyA8IEdUSV9USVZfTUlOIHx8IGluYyA+IEdUSV9USVZf
TUFYKSB7DQo+ID4gICAJCWRldl9lcnIoZGV2LCAiZ3RpLnRpdiBpbmNyZW1lbnQgMHglbGx4IGlz
IG91dHNpZGUgdGhlIHJhbmdlIDB4JXggLSAweCV4XG4iLA0KDQpFdmVuIHdpdGggaGFyZHdhcmUg
ZGl2aWRlIGEgNjQvMzIgZGl2aWRlIGlzIGxpa2VseSB0byBiZSBmYXN0ZXIgdGhhdCBhIDY0LzY0
IG9uZS4NCg0KTWF5YmUgdGhlIGNvY2NpY2hlY2sgd2FybmluZyBtZXNzYWdlIHNob3VsZCBzdWdn
ZXN0IGNoZWNraW5nIHRoZSBkb21haW4NCm9mIHRoZSBkaXZpc29yIGFuZCB0aGVuIGNoYW5naW5n
IHRoZSB0eXBlPz8NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwg
QnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVn
aXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

