Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6244030BA9D
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhBBJLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:11:16 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:53516 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232764AbhBBJGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:06:19 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-235-d0sEAq5wO-e4gEXTsz9W_A-1; Tue, 02 Feb 2021 09:04:06 +0000
X-MC-Unique: d0sEAq5wO-e4gEXTsz9W_A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 2 Feb 2021 09:04:08 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 2 Feb 2021 09:04:08 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Xie He' <xie.he.0141@gmail.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin Schiller" <ms@dev.tdt.de>
Subject: RE: [PATCH net] net: lapb: Copy the skb before sending a packet
Thread-Topic: [PATCH net] net: lapb: Copy the skb before sending a packet
Thread-Index: AQHW+LWCuPwcEejJYE+Lkf4DZiBCw6pEkh0g
Date:   Tue, 2 Feb 2021 09:04:07 +0000
Message-ID: <6da2329e69d247daac6c6d7d442f0e38@AcuMS.aculab.com>
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
 <4d1988d9-6439-ae37-697c-d2b970450498@linux.ibm.com>
 <CAJht_EOw4d9h7LqOsXpucADV5=gAGws-fKj5q7BdH2+h0Yv9Vg@mail.gmail.com>
In-Reply-To: <CAJht_EOw4d9h7LqOsXpucADV5=gAGws-fKj5q7BdH2+h0Yv9Vg@mail.gmail.com>
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

RnJvbTogWGllIEhlDQo+IFNlbnQ6IDAxIEZlYnJ1YXJ5IDIwMjEgMTY6MTUNCj4gDQo+IE9uIE1v
biwgRmViIDEsIDIwMjEgYXQgNjoxMCBBTSBKdWxpYW4gV2llZG1hbm4gPGp3aUBsaW51eC5pYm0u
Y29tPiB3cm90ZToNCj4gPg0KPiA+IFRoaXMgc291bmRzIGEgYml0IGxpa2UgeW91IHdhbnQgc2ti
X2Nvd19oZWFkKCkgLi4uID8NCj4gDQo+IENhbGxpbmcgInNrYl9jb3dfaGVhZCIgYmVmb3JlIHdl
IGNhbGwgInNrYl9jbG9uZSIgd291bGQgaW5kZWVkIHNvbHZlDQo+IHRoZSBwcm9ibGVtIG9mIHdy
aXRlcyB0byBvdXIgY2xvbmVzIGFmZmVjdGluZyBjbG9uZXMgaW4gb3RoZXIgcGFydHMgb2YNCj4g
dGhlIHN5c3RlbS4gQnV0IHNpbmNlIHdlIGFyZSBzdGlsbCB3cml0aW5nIHRvIHRoZSBza2IgYWZ0
ZXINCj4gInNrYl9jbG9uZSIsIGl0J2Qgc3RpbGwgYmUgYmV0dGVyIHRvIHJlcGxhY2UgInNrYl9j
bG9uZSIgd2l0aA0KPiAic2tiX2NvcHkiIHRvIGF2b2lkIGludGVyZmVyZW5jZSBiZXR3ZWVuIG91
ciBvd24gY2xvbmVzLg0KDQpXaGF0IGlzIHRoZSBmYXN0ZXN0IGxpbmsgbGFwYiBpcyBhY3R1YWxs
eSB1c2VkIG9uIHRoZXNlIGRheXM/DQo2NGsgdXNlZCB0byBiZSAnZmFzdCcgLSBzbyBjb3B5aW5n
IHRoZSBza2IgaXNuJ3QgZ29pbmcgdG8gaGF2ZQ0KYSBub3RpY2VhYmxlIGVmZmVjdCBvbiBzeXN0
ZW0gcGVyZm9ybWFuY2UuDQoNCldlIGRpZCBvbmNlIGdldCBhICdmcmVlJyB1cGdyYWRlIG9mIG91
ciBYLjI1IGxpbmsgZnJvbSAyNDAwIHRvIDk2MDAuDQpQcm9iYWJseSBkdWUgdG8gdGhlIHBvd2Vy
IGNvbnN1bXB0aW9uIGFuZCByYWNrIHNwYWNlIG5lZWRlZCBmb3INCnRoZSBvbGRlciBtb2RlbS4N
Cg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2Fk
LCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5v
OiAxMzk3Mzg2IChXYWxlcykNCg==

