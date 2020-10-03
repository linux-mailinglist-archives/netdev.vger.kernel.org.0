Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DFB2823B9
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 12:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgJCK6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 06:58:17 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:33249 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725765AbgJCK6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 06:58:16 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-285-a4MfzTCoNdeqWA7R9Sj-AA-1; Sat, 03 Oct 2020 11:56:45 +0100
X-MC-Unique: a4MfzTCoNdeqWA7R9Sj-AA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 3 Oct 2020 11:56:44 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 3 Oct 2020 11:56:44 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Wei Wang' <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: RE: [PATCH net-next v2 0/5] implement kthread based napi poll
Thread-Topic: [PATCH net-next v2 0/5] implement kthread based napi poll
Thread-Index: AQHWmQrxY4+GJOdltE+p6T5f2TezYKmFs91g
Date:   Sat, 3 Oct 2020 10:56:44 +0000
Message-ID: <0af00c5a9ced4a8b8b55e81a65e47990@AcuMS.aculab.com>
References: <20201002222514.1159492-1-weiwan@google.com>
In-Reply-To: <20201002222514.1159492-1-weiwan@google.com>
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

RnJvbTogV2VpIFdhbmcNCj4gU2VudDogMDIgT2N0b2JlciAyMDIwIDIzOjI1DQo+IA0KPiBUaGUg
aWRlYSBvZiBtb3ZpbmcgdGhlIG5hcGkgcG9sbCBwcm9jZXNzIG91dCBvZiBzb2Z0aXJxIGNvbnRl
eHQgdG8gYQ0KPiBrZXJuZWwgdGhyZWFkIGJhc2VkIGNvbnRleHQgaXMgbm90IG5ldy4NCj4gUGFv
bG8gQWJlbmkgYW5kIEhhbm5lcyBGcmVkZXJpYyBTb3dhIGhhdmUgcHJvcG9zZWQgcGF0Y2hlcyB0
byBtb3ZlIG5hcGkNCj4gcG9sbCB0byBrdGhyZWFkIGJhY2sgaW4gMjAxNi4gQW5kIEZlbGl4IEZp
ZXRrYXUgaGFzIGFsc28gcHJvcG9zZWQNCj4gcGF0Y2hlcyBvZiBzaW1pbGFyIGlkZWFzIHRvIHVz
ZSB3b3JrcXVldWUgdG8gcHJvY2VzcyBuYXBpIHBvbGwganVzdCBhDQo+IGZldyB3ZWVrcyBhZ28u
DQoNCkkgZGlkbid0IHNwb3QgYW55dGhpbmcgdGhhdCBtYWtlcyB0aGlzIGNvbnRpbnVlIHRvIHdv
cms/DQoNCnN0YXRpYyBpbmxpbmUgYm9vbCBuZXRkZXZfeG1pdF9tb3JlKHZvaWQpDQp7DQogICAg
ICAgIHJldHVybiBfX3RoaXNfY3B1X3JlYWQoc29mdG5ldF9kYXRhLnhtaXQubW9yZSk7DQp9DQoN
CkkgYXNzdW1lIGl0IG5vcm1hbGx5IHJlbGllcyBvbiB0aGUgc29mdGludCBjb2RlIHJ1bm5pbmcg
d2l0aA0KcHJlLWVtcHRpb24gZGlzYWJsZWQuDQoNCihJdCBhbHNvIG5lZWRzIGEgbGV2ZWwgb2Yg
aW5kaXJlY3Rpb24uDQp4bWl0Lm1vcmUgaXMgb25seSBzZXQgaWYgbW9yZSBwYWNrZXRzIGFyZSBx
dWV1ZWQgd2hlbiB0aGUgdHgNCmNhbGwgaXMgZG9uZS4NCkkndmUgc2VlbiBhIHdvcmtsb2FkIHRo
YXQgbWFuYWdlcyB0byByZXBlYXRlZGx5IGFkZCBhbiBleHRyYQ0KcGFja2V0IHdoaWxlIHRoZSB0
eCBzZXR1cCBpcyBpbiBwcm9ncmVzcy4pDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJl
c3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsx
IDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

