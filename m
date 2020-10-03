Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94416282361
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725781AbgJCJ5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:57:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:32995 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725681AbgJCJ5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:57:15 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-92-uf75rYOZO5uDD8z_t_NowA-1; Sat, 03 Oct 2020 10:57:10 +0100
X-MC-Unique: uf75rYOZO5uDD8z_t_NowA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 3 Oct 2020 10:57:09 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 3 Oct 2020 10:57:09 +0100
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
Thread-Index: AQHWmQrxY4+GJOdltE+p6T5f2TezYKmFmo0A
Date:   Sat, 3 Oct 2020 09:57:09 +0000
Message-ID: <e37939313fc24658a8a6b860dcea506e@AcuMS.aculab.com>
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
DQoNCldoYXQgZGVmYXVsdCBzY2hlZHVsZXIgcHJpb3JpdHkgYXJlIHlvdSBwbGFubmluZyB0byB1
c2U/DQoNClRoZSBjdXJyZW50ICdzb2Z0aW50JyBpcyAoZWZmZWN0aXZlbHkpIHNsaWdodGx5IGhp
Z2hlciBwcmlvcml0eQ0KdGhhbiB0aGUgaGlnaGVzdCBSVCBwcmlvcml0eS4NCg0KSSB0aGluayB5
b3UgbmVlZCB0byB1c2UgYSAnbWlkZGxlJyBwcmlvcml0eSBSVCBwcm9jZXNzIHNvIHRoYXQNCmFw
cGxpY2F0aW9ucyBjYW4gZGVjaWRlIHdoZXRoZXIgdGhleSBuZWVkIHRvIGJlIGhpZ2hlci9sb3dl
cg0KcHJpb3JpdHkgdGhhbiB0aGUgbmV0d29yayBjb2RlLg0KDQpCdXQgdGhlbiB5b3UgaGl0IHRo
ZSBwcm9ibGVtIHRoYXQgdGhlIHNjaGVkdWxlciBnaXZlcyBSVA0KcHJvY2Vzc2VzIGEgdmVyeSAn
c3RpY2t5JyBjcHUgYWZmaW5pdHkuDQpJSVJDIHRoZXkgZG9uJ3QgZXZlciBnZXQgJ3N0b2xlbicg
YnkgYW4gaWRsZSBjcHUsIHNvIG9ubHkNCm1pZ3JhdGUgd2hlbiB0aGUgc2NoZWR1bGVyIGZvciB0
aGUgY3B1IHRoZXkgbGFzdCByYW4gb24NCmRlY2lkZXMgdG8gcnVuIHNvbWV0aGluZyBvZiBhIGhp
Z2hlciBwcmlvcml0eS4NClRoaXMgaXMgcHJvYmxlbWF0aWMgaWYgYSBsb3cgcHJpb3JpdHkgcHJv
Y2VzcyBpbiBsb29waW5nDQppbiBrZXJuZWwgc3BhY2Ugc29tZXdoZXJlICh3aXRob3V0IGEgY29u
ZF9yZXNjaGVkKCkpLg0KKEkndmUgYmVlbiBydW5uaW5nIGZ0cmFjZS4uLikNCg0KR2l2ZW4gdGhh
dCB0aGUgbmFwaSBjcHUgY3ljbGVzIGhhdmUgdG8gaGFwcGVuIHNvbWV0aW1lLA0KdGhlIGJpZ2dl
c3QgcHJvYmxlbSBJIGZvdW5kIHdpdGggdGhlIGN1cnJlbnQgc29mdGludA0KaW1wbGVtZW50YXRp
b24gaXMgdGhhdCBhIGhhcmR3YXJlIGludGVycnVwdCBjYW4gaGFwcGVuDQp3aGlsZSBhbiBhcHBs
aWNhdGlvbiBpcyBob2xkaW5nIGEgKHVzZXIgc3BhY2UpIG11dGV4Lg0KVGhpcyB3aWxsIGJsb2Nr
IG90aGVyIGFwcGxpY2F0aW9uIHRocmVhZHMgZnJvbSBhY3F1aXJpbmcNCnRoZSBtdXRleCB1bnRp
bCBub3Qgb25seSB0aGUgaGFyZHdhcmUgaW50ZXJydXB0DQpjb21wbGV0ZXMsIGJ1dCBhbHNvIGFs
bCB0aGUgYXNzb2NpYXRlZCBzb2Z0aW50ICh0eXBpY2FsbHkNCm5hcGkgYW5kIHJjdSkgcHJvY2Vz
c2luZyBoYXMgY29tcGxldGVkLg0KVGhpcyBjYW4gdGFrZSBhIHdoaWxlIQ0KTW92aW5nIHRoZSAn
c29mdGludCcgcHJvY2Vzc2luZyB0byBhIHNlcGFyYXRlIHRocmVhZA0Kd2lsbCBhbGxvdyB0aGUg
aW50ZXJydXB0ZWQgcHJvY2VzcyB0byByZWxlYXNlIHRoZSBtdXRleA0KYW5kIGFsbCB0aGUgYXBw
bGljYXRpb24gdGhyZWFkcyBjb250aW51ZS4NCg0KSSBndWVzcyB0aGUgZG93bnNpZGUgb2YgdXNp
bmcgYSB0aHJlYWQgaXMgdGhhdCB0aGUNCmRhdGEgbmVlZGVkIGlzIGxpa2VseSB0byBiZSBpbiB0
aGUgd3JvbmcgY2FjaGUuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNp
ZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsN
ClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

