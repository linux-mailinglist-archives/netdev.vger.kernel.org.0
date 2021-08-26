Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0718F3F8397
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 10:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhHZINW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 04:13:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:28293 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240156AbhHZINS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 04:13:18 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-81-EKLme1GqN6OZhnD0jFxktg-1; Thu, 26 Aug 2021 09:12:29 +0100
X-MC-Unique: EKLme1GqN6OZhnD0jFxktg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Thu, 26 Aug 2021 09:12:27 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Thu, 26 Aug 2021 09:12:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Peter Collingbourne' <pcc@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
Thread-Topic: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
Thread-Index: AQHXmhmeusqat7DUPUKEZ8XxUHnOHquFbtgQ
Date:   Thu, 26 Aug 2021 08:12:27 +0000
Message-ID: <11f72b27c12f46eb8bef1d1773980c54@AcuMS.aculab.com>
References: <20210826012722.3210359-1-pcc@google.com>
In-Reply-To: <20210826012722.3210359-1-pcc@google.com>
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

RnJvbTogUGV0ZXIgQ29sbGluZ2JvdXJuZQ0KPiBTZW50OiAyNiBBdWd1c3QgMjAyMSAwMjoyNw0K
PiANCj4gQSBjb21tb24gaW1wbGVtZW50YXRpb24gb2YgaXNhdHR5KDMpIGludm9sdmVzIGNhbGxp
bmcgYSBpb2N0bCBwYXNzaW5nDQo+IGEgZHVtbXkgc3RydWN0IGFyZ3VtZW50IGFuZCBjaGVja2lu
ZyB3aGV0aGVyIHRoZSBzeXNjYWxsIGZhaWxlZCAtLQ0KPiBiaW9uaWMgYW5kIGdsaWJjIHVzZSBU
Q0dFVFMgKHBhc3NpbmcgYSBzdHJ1Y3QgdGVybWlvcyksIGFuZCBtdXNsIHVzZXMNCj4gVElPQ0dX
SU5TWiAocGFzc2luZyBhIHN0cnVjdCB3aW5zaXplKS4gSWYgdGhlIEZEIGlzIGEgc29ja2V0LCB3
ZSB3aWxsDQo+IGNvcHkgc2l6ZW9mKHN0cnVjdCBpZnJlcSkgYnl0ZXMgb2YgZGF0YSBmcm9tIHRo
ZSBhcmd1bWVudCBhbmQgcmV0dXJuDQo+IC1FRkFVTFQgaWYgdGhhdCBmYWlscy4gVGhlIHJlc3Vs
dCBpcyB0aGF0IHRoZSBpc2F0dHkgaW1wbGVtZW50YXRpb25zDQo+IG1heSByZXR1cm4gYSBub24t
UE9TSVgtY29tcGxpYW50IHZhbHVlIGluIGVycm5vIGluIHRoZSBjYXNlIHdoZXJlIHBhcnQNCj4g
b2YgdGhlIGR1bW15IHN0cnVjdCBhcmd1bWVudCBpcyBpbmFjY2Vzc2libGUsIGFzIGJvdGggc3Ry
dWN0IHRlcm1pb3MNCj4gYW5kIHN0cnVjdCB3aW5zaXplIGFyZSBzbWFsbGVyIHRoYW4gc3RydWN0
IGlmcmVxIChhdCBsZWFzdCBvbiBhcm02NCkuDQo+IA0KPiBBbHRob3VnaCB0aGVyZSBpcyB1c3Vh
bGx5IGVub3VnaCBzdGFjayBzcGFjZSBmb2xsb3dpbmcgdGhlIGFyZ3VtZW50DQo+IG9uIHRoZSBz
dGFjayB0aGF0IHRoaXMgZGlkIG5vdCBwcmVzZW50IGEgcHJhY3RpY2FsIHByb2JsZW0gdXAgdG8g
bm93LA0KPiB3aXRoIE1URSBzdGFjayBpbnN0cnVtZW50YXRpb24gaXQncyBtb3JlIGxpa2VseSBm
b3IgdGhlIGNvcHkgdG8gZmFpbCwNCj4gYXMgdGhlIG1lbW9yeSBmb2xsb3dpbmcgdGhlIHN0cnVj
dCBtYXkgaGF2ZSBhIGRpZmZlcmVudCB0YWcuDQo+IA0KPiBGaXggdGhlIHByb2JsZW0gYnkgYWRk
aW5nIGFuIGVhcmx5IGNoZWNrIGZvciB3aGV0aGVyIHRoZSBpb2N0bCBpcyBhDQo+IHZhbGlkIHNv
Y2tldCBpb2N0bCwgYW5kIHJldHVybiAtRU5PVFRZIGlmIGl0IGlzbid0Lg0KLi4NCj4gK2Jvb2wg
aXNfZGV2X2lvY3RsX2NtZCh1bnNpZ25lZCBpbnQgY21kKQ0KPiArew0KPiArCXN3aXRjaCAoY21k
KSB7DQo+ICsJY2FzZSBTSU9DR0lGTkFNRToNCj4gKwljYXNlIFNJT0NHSUZIV0FERFI6DQo+ICsJ
Y2FzZSBTSU9DR0lGRkxBR1M6DQo+ICsJY2FzZSBTSU9DR0lGTUVUUklDOg0KPiArCWNhc2UgU0lP
Q0dJRk1UVToNCj4gKwljYXNlIFNJT0NHSUZTTEFWRToNCj4gKwljYXNlIFNJT0NHSUZNQVA6DQo+
ICsJY2FzZSBTSU9DR0lGSU5ERVg6DQo+ICsJY2FzZSBTSU9DR0lGVFhRTEVOOg0KPiArCWNhc2Ug
U0lPQ0VUSFRPT0w6DQo+ICsJY2FzZSBTSU9DR01JSVBIWToNCj4gKwljYXNlIFNJT0NHTUlJUkVH
Og0KPiArCWNhc2UgU0lPQ1NJRk5BTUU6DQo+ICsJY2FzZSBTSU9DU0lGTUFQOg0KPiArCWNhc2Ug
U0lPQ1NJRlRYUUxFTjoNCj4gKwljYXNlIFNJT0NTSUZGTEFHUzoNCj4gKwljYXNlIFNJT0NTSUZN
RVRSSUM6DQo+ICsJY2FzZSBTSU9DU0lGTVRVOg0KPiArCWNhc2UgU0lPQ1NJRkhXQUREUjoNCj4g
KwljYXNlIFNJT0NTSUZTTEFWRToNCj4gKwljYXNlIFNJT0NBRERNVUxUSToNCj4gKwljYXNlIFNJ
T0NERUxNVUxUSToNCj4gKwljYXNlIFNJT0NTSUZIV0JST0FEQ0FTVDoNCj4gKwljYXNlIFNJT0NT
TUlJUkVHOg0KPiArCWNhc2UgU0lPQ0JPTkRFTlNMQVZFOg0KPiArCWNhc2UgU0lPQ0JPTkRSRUxF
QVNFOg0KPiArCWNhc2UgU0lPQ0JPTkRTRVRIV0FERFI6DQo+ICsJY2FzZSBTSU9DQk9ORENIQU5H
RUFDVElWRToNCj4gKwljYXNlIFNJT0NCUkFERElGOg0KPiArCWNhc2UgU0lPQ0JSREVMSUY6DQo+
ICsJY2FzZSBTSU9DU0hXVFNUQU1QOg0KPiArCWNhc2UgU0lPQ0JPTkRTTEFWRUlORk9RVUVSWToN
Cj4gKwljYXNlIFNJT0NCT05ESU5GT1FVRVJZOg0KPiArCWNhc2UgU0lPQ0dJRk1FTToNCj4gKwlj
YXNlIFNJT0NTSUZNRU06DQo+ICsJY2FzZSBTSU9DU0lGTElOSzoNCj4gKwljYXNlIFNJT0NXQU5E
RVY6DQo+ICsJY2FzZSBTSU9DR0hXVFNUQU1QOg0KPiArCQlyZXR1cm4gdHJ1ZTsNCg0KVGhhdCBp
cyBob3JyaWQuDQpDYW4ndCB5b3UgYXQgbGVhc3QgdXNlIF9JT0NfVFlQRSgpIHRvIGNoZWNrIGZv
ciBzb2NrZXQgaW9jdGxzLg0KQ2xlYXJseSBpdCBjYW4gc3VjY2VlZCBmb3IgJ3JhbmRvbScgZHJp
dmVyIGlvY3RscywgYnV0IHdpbGwgZmFpbA0KZm9yIHRoZSB0dHkgb25lcy4NCg0KVGhlIG90aGVy
IHNhbmUgdGhpbmcgaXMgdG8gY2hlY2sgX0lPQ19TSVpFKCkuDQpTaW5jZSBhbGwgdGhlIFNJT0N4
eHh4IGhhdmUgYSBjb3JyZWN0IF9JT0NfU0laRSgpIHRoYXQgY2FuIGJlDQp1c2VkIHRvIGNoZWNr
IHRoZSB1c2VyIGNvcHkgbGVuZ3RoLg0KKFVubGlrZSBzb2NrZXQgb3B0aW9ucyB0aGUgY29ycmVj
dCBsZW5ndGggaXMgYWx3YXlzIHN1cHBsaWVkLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBB
ZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMs
IE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

