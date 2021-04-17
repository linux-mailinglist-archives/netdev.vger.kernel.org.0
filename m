Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE09F362F70
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 13:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbhDQLI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 07:08:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:60270 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231387AbhDQLIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 07:08:25 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-132-1PxD-uwUOW6uWGpjQasDMA-1; Sat, 17 Apr 2021 12:07:56 +0100
X-MC-Unique: 1PxD-uwUOW6uWGpjQasDMA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Sat, 17 Apr 2021 12:07:55 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Sat, 17 Apr 2021 12:07:55 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Matteo Croce' <mcroce@linux.microsoft.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Julia Lawall <julia.lawall@inria.fr>
Subject: RE: [PATCH net-next v2 0/3] introduce skb_for_each_frag()
Thread-Topic: [PATCH net-next v2 0/3] introduce skb_for_each_frag()
Thread-Index: AQHXLzQg5WXC8qIcg0CtZzWZRcsCQaqyElmAgAWifgCAAN7iIA==
Date:   Sat, 17 Apr 2021 11:07:55 +0000
Message-ID: <3a3c006cc1c644fd8e2fe791dba5139a@AcuMS.aculab.com>
References: <20210412003802.51613-1-mcroce@linux.microsoft.com>
 <75045c087db24b6e87b7ed14aa5a721c@AcuMS.aculab.com>
 <CAFnufp12=8pDo-GP6BwH72YiH5C9GXOY8Me=xsFo7=+hvfujaQ@mail.gmail.com>
In-Reply-To: <CAFnufp12=8pDo-GP6BwH72YiH5C9GXOY8Me=xsFo7=+hvfujaQ@mail.gmail.com>
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

RnJvbTogTWF0dGVvIENyb2NlDQo+IFNlbnQ6IDE2IEFwcmlsIDIwMjEgMjM6NDQNCi4uLg0KPiA+
IEEgbW9yZSBpbnRlcmVzdGluZyBjaGFuZ2Ugd291bGQgYmUgc29tZXRoaW5nIHRoYXQgZ2VuZXJh
dGVkOg0KPiA+ICAgICAgICAgdW5zaWduZWQgaW50IG5yX2ZyYWdzID0gc2tiX3NoaW5mbyhza2Ip
LT5ucl9mcmFnczsNCj4gPiAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBucl9mcmFnczsgaSsrKSB7
DQo+ID4gc2luY2UgdGhhdCB3aWxsIHJ1biBmYXN0ZXIgZm9yIG1vc3QgbG9vcHMuDQo+ID4gQnV0
IHRoYXQgaXMgfmltcG9zc2libGUgdG8gZG8gc2luY2UgeW91IGNhbid0IGRlY2xhcmUNCj4gPiB2
YXJpYWJsZXMgaW5zaWRlIHRoZSAoLi4uKSB0aGF0IGFyZSBzY29wZWQgdG8gdGhlIGxvb3AuDQo+
ID4NCj4gDQo+IEkgZG9uJ3Qga25vdyBob3cgdG8gZG8gaXQgd2l0aCBDOTAuDQo+IEl0IHdvdWxk
IGJlIG5pY2UgdG8gaGF2ZSBhIHN3aXRjaCB0byBqdXN0IGFsbG93IGRlY2xhcmF0aW9uIG9mDQo+
IHZhcmlhYmxlcyBpbnNpZGUgdGhlICguLi4pIGluc3RlYWQgb2YgZW5hYmxpbmcgdGhlIGZ1bGwg
Qzk5IGxhbmd1YWdlDQo+IHdoaWNoLCBhcyBMaW51cyBzYWlkWzFdLCBhbGxvd3MgdGhlIGluc2Fu
ZSBtaXhpbmcgb2YgdmFyaWFibGVzIGFuZA0KPiBjb2RlLg0KPiANCj4gWzFdIGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL2xrbWwvQ0ErNTVhRnpzPUR1WWliV1lNVUZpVV9SMWFKSEFyLThocFFoV0xl
dzhSNXE0bkNEcmFRQG1haWwuZ21haWwuY29tLw0KDQpRdW90aW5nIExpbnVzOg0KDQo+IEkgKmxp
a2UqIGdldHRpbmcgd2FybmluZ3MgZm9yIGNvbmZ1c2VkIHBlb3BsZSB3aG8gc3RhcnQgaW50cm9k
dWNpbmcNCj4gdmFyaWFibGVzIGluIHRoZSBtaWRkbGUgb2YgYmxvY2tzIG9mIGNvZGUuIFRoYXQn
cyBub3Qgd2VsbC1jb250YWluZWQNCj4gbGlrZSB0aGUgbG9vcCB2YXJpYWJsZS4NCg0KVGhlIHJl
YWxseSBzdHVwaWQgcGFydCBvZiBDOTkgaXMgdGhhdCBzdWNoIHZhcmlhYmxlcyBjYW4gYWxpYXMN
Cm9uZXMgaW4gYW4gb3V0ZXIgYmxvY2suDQpBbGlhc2VkIGRlZmluaXRpb25zIGFyZSBiYWQgZW5v
dWdoIGF0IHRoZSBiZXN0IG9mIHRpbWVzLg0KTWFrZXMgaXQgdmVyeSBlYXN5IHRvIG1pc3MgdGhl
IGNvcnJlY3QgZGVmaW5pdGlvbiB3aGVuIHJlYWRpbmcgY29kZS4NCg0KSSBtdWNoIHByZWZlciBs
b2NhbCB2YXJpYWJsZXMgdG8gZWl0aGVyIGZ1bmN0aW9uIHNjb3BlIG9yIGJlDQpkZWZpbmVkIGZv
ciB2ZXJ5IGxvY2FsIHVzZSBhdCB0aGUgdG9wIG9mIGEgdmVyeSBzbWFsbCBibG9jay4NCg0KCURh
dmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3Vu
dCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg==

