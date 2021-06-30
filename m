Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4423B86CA
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 18:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhF3QKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 12:10:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47168 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhF3QKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 12:10:41 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-255-tT8cdm8GPZOIs52kgRv1lA-1; Wed, 30 Jun 2021 17:08:06 +0100
X-MC-Unique: tT8cdm8GPZOIs52kgRv1lA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 30 Jun
 2021 17:08:06 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 30 Jun 2021 17:08:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Ulf Hansson' <ulf.hansson@linaro.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
CC:     "pizza@shaftnet.org" <pizza@shaftnet.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
Thread-Topic: [RFC PATCH] cw1200: use kmalloc() allocation instead of stack
Thread-Index: AQHXbZc9wvCgBpnoT0+86NraIUocoqssuE1w
Date:   Wed, 30 Jun 2021 16:08:05 +0000
Message-ID: <cd6360a4247e47cdb819343a05b70d05@AcuMS.aculab.com>
References: <20210622202345.795578-1-jernej.skrabec@gmail.com>
 <CAPDyKFo6AVGq5Q9bRKPjypRMxisLf0nZWLtSeARGO-3kO7=+zQ@mail.gmail.com>
In-Reply-To: <CAPDyKFo6AVGq5Q9bRKPjypRMxisLf0nZWLtSeARGO-3kO7=+zQ@mail.gmail.com>
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

RnJvbTogVWxmIEhhbnNzb24NCj4gU2VudDogMzAgSnVuZSAyMDIxIDExOjAzDQouLi4NCj4gPiBJ
dCB0dXJucyBvdXQgdGhhdCBpZiBDT05GSUdfVk1BUF9TVEFDSyBpcyBlbmFibGVkIGFuZCBzcmMg
b3IgZHN0IGlzDQo+ID4gbWVtb3J5IGFsbG9jYXRlZCBvbiBzdGFjaywgU0RJTyBvcGVyYXRpb25z
IGZhaWwgZHVlIHRvIGludmFsaWQgbWVtb3J5DQo+ID4gYWRkcmVzcyBjb252ZXJzaW9uOg0KLi4u
DQo+ID4gRml4IHRoYXQgYnkgdXNpbmcga21hbGxvYygpIGFsbG9jYXRlZCBtZW1vcnkgZm9yIHJl
YWQvd3JpdGUgMTYvMzINCj4gPiBmdW50aW9ucy4NCg0KQ291bGQgYSBmaWVsZCBiZSBhZGRlZCB0
byAnc3RydWN0IGN3MTIwMF9jb21tb24nDQp0aGF0IHRoZSBmdW5jdGlvbnMgY291bGQgdXNlIGFz
IGEgYm91bmNlIGJ1ZmZlcj8NCg0KSVNUTSB0aGF0IGlzIERNQSBhcmUgYmVpbmcgZG9uZSB0aGVy
ZSBtdXN0IGJlIHNvbWUNCnNlcmlhbGlzYXRpb24gaW4gdGhlcmUgc29tZXdoZXJlIHRoYXQgd2ls
bCBzdG9wDQpjb25jdXJyZW50IGFjY2Vzc2VzLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBB
ZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMs
IE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

