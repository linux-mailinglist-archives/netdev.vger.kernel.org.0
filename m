Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C4A294942
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 10:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502243AbgJUISu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 04:18:50 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:60247 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408663AbgJUISt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 04:18:49 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-173-bpZft2kJNEm93mAv-g78BA-1; Wed, 21 Oct 2020 09:18:45 +0100
X-MC-Unique: bpZft2kJNEm93mAv-g78BA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 21 Oct 2020 09:18:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 21 Oct 2020 09:18:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Benjamin Herrenschmidt' <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dylan Hung <dylan_hung@aspeedtech.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>
Subject: RE: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
Thread-Topic: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
Thread-Index: AQHWpz03YLmlT7c7UUWIjBAFmkpKA6mhs33A
Date:   Wed, 21 Oct 2020 08:18:44 +0000
Message-ID: <dca2ce4487024eba9398426af86c761d@AcuMS.aculab.com>
References: <20201020220639.130696-1-joel@jms.id.au>
 <86480db3977cfbf6750209c34a28c8f042be55fb.camel@kernel.crashing.org>
In-Reply-To: <86480db3977cfbf6750209c34a28c8f042be55fb.camel@kernel.crashing.org>
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

RnJvbTogQmVuamFtaW4gSGVycmVuc2NobWlkdA0KPiBTZW50OiAyMSBPY3RvYmVyIDIwMjAgMDE6
MDANCj4gDQo+IE9uIFdlZCwgMjAyMC0xMC0yMSBhdCAwODozNiArMTAzMCwgSm9lbCBTdGFubGV5
IHdyb3RlOg0KPiA+IFdlIG11c3QgZW5zdXJlIHRoZSB0eCBkZXNjcmlwdG9yIHVwZGF0ZXMgYXJl
IHZpc2libGUgYmVmb3JlIHVwZGF0aW5nDQo+ID4gdGhlIHR4IHBvaW50ZXIuDQo+ID4NCj4gPiBU
aGlzIHJlc29sdmVzIHRoZSB0eCBoYW5ncyBvYnNlcnZlZCBvbiB0aGUgMjYwMCB3aGVuIHJ1bm5p
bmcgaXBlcmY6DQo+IA0KPiBUbyBjbGFyaWZ5IHRoZSBjb21tZW50IGhlcmUuIFRoaXMgZG9lc24n
dCBlbnN1cmUgdGhleSBhcmUgdmlzaWJsZSB0bw0KPiB0aGUgaGFyZHdhcmUgYnV0IHRvIG90aGVy
IENQVXMuIFRoaXMgaXMgdGhlIG9yZGVyaW5nIHZzIHN0YXJ0X3htaXQgYW5kDQo+IHR4X2NvbXBs
ZXRlLg0KDQpZb3UgbmVlZCB0d28gYmFycmllcnMuDQoxKSBhZnRlciBtYWtpbmcgdGhlIGRhdGEg
YnVmZmVycyBhdmFpbGFibGUgYmVmb3JlIHRyYW5zZmVycmluZw0KdGhlIGRlc2NyaXB0b3Igb3du
ZXJzaGlwIHRvIHRoZSBkZXZpY2UuDQoyKSBhZnRlciB0cmFuc2ZlcnJpbmcgdGhlIG93bmVyc2hp
cCBiZWZvcmUgJ2tpY2tpbmcnIHRoZSBtYWMgZW5naW5lLg0KDQpUaGUgZmlyc3QgaXMgbmVlZGVk
IGJlY2F1c2UgdGhlIG1hYyBlbmdpbmUgY2FuIHBvbGwgdGhlIGRlc2NyaXB0b3JzDQphdCBhbnkg
dGltZSAoZWcgb24gY29tcGxldGluZyB0aGUgcHJldmlvdXMgdHJhbnNtaXQpLg0KVGhpcyBzdG9w
cyBpdCB0cmFuc21pdHRpbmcgZ2FyYmFnZS4NCg0KVGhlIHNlY29uZCBtYWtlcyBzdXJlIGl0IGZp
bmRzIHRoZSBkZXNjcmlwdG9yIHlvdSd2ZSBqdXN0IHNldC4NClRoaXMgc3RvcHMgZGVsYXlzIGJl
Zm9yZSBzZW5kaW5nIHRoZSBwYWNrZXQuDQooQnV0IGl0IHdpbGwgZ2V0IHNlbnQgbGF0ZXIuKQ0K
DQpGb3IgKDIpIGRtYV93bWIoKSBpcyB0aGUgZG9jdW1lbnRlZCBiYXJyaWVyLg0KDQpJJ20gbm90
IHN1cmUgd2hpY2ggYmFycmllciB5b3UgbmVlZCBmb3IgKDEpLg0Kc21wX3dtYigpIHdvdWxkIGJl
IHJpZ2h0IGlmIHRoZSByZWFkZXIgd2VyZSBhbm90aGVyIGNwdSwNCmJ1dCBpdCBpcyAoYXQgbW9z
dCkgYSBjb21waWxlIGJhcnJpZXIgb24gVVAga2VybmVscy4NClNvIHlvdSBuZWVkIHNvbWV0aGlu
ZyBzdHJvbmdlciB0aGFuIHNtcF93bWIoKS4NCk9uIGEgVFNPIHN5c3RlbSAod2hpY2ggeW91cnMg
cHJvYmFibHkgaXMpIGEgY29tcGlsZSBiYXJyaWVyDQppcyBwcm9iYWJseSBzdWZmaWNpZW50LCBi
dXQgaWYgbWVtb3J5IHdyaXRlcyBjYW4gZ2V0IHJlLW9yZGVyZWQNCml0IG5lZWRzIHRvIGJlIGEg
c3Ryb25nZXIgYmFycmllciAtIGJ1dCBub3QgbmVjZXNzYXJpbHkgYXMgc3Ryb25nDQphcyBkbWFf
d21iKCkuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

