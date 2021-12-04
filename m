Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9D546872C
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 20:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347600AbhLDTGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 14:06:43 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:47503 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347261AbhLDTGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 14:06:42 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-26-iX6utbc2MuqdAtbywoI2iQ-1; Sat, 04 Dec 2021 19:03:11 +0000
X-MC-Unique: iX6utbc2MuqdAtbywoI2iQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sat, 4 Dec 2021 19:03:10 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sat, 4 Dec 2021 19:03:10 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>
CC:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David Lebrun" <dlebrun@google.com>
Subject: RE: [PATCH net-next] net: fix recent csum changes
Thread-Topic: [PATCH net-next] net: fix recent csum changes
Thread-Index: AQHX6MkmGXqYzp04fka0oQkYu30MhawiV/GQgABReYCAAANfcA==
Date:   Sat, 4 Dec 2021 19:03:10 +0000
Message-ID: <693ac4fa50dd4aa2be9faa84861eb91b@AcuMS.aculab.com>
References: <20211203185238.2011081-1-eric.dumazet@gmail.com>
 <202112041104.gPgP3Z6U-lkp@intel.com>
 <CANn89i+m2O9EQCZq5r39ZbnE2dO82pxnj-KshbfWjNH3a5zqWQ@mail.gmail.com>
 <d85835b339f345c2b5acd67b71f4b435@AcuMS.aculab.com>
 <CANn89i+bondpbSEbXp5jF6_keYMGNfwAS8YXQBYMNyKgGb3WEA@mail.gmail.com>
In-Reply-To: <CANn89i+bondpbSEbXp5jF6_keYMGNfwAS8YXQBYMNyKgGb3WEA@mail.gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA0IERlY2VtYmVyIDIwMjEgMTg6MzQNCj4gDQo+
IE9uIFNhdCwgRGVjIDQsIDIwMjEgYXQgNjowMCBBTSBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdo
dEBhY3VsYWIuY29tPiB3cm90ZToNCj4gPg0KPiA+IEZyb206IEVyaWMgRHVtYXpldA0KPiA+ID4g
U2VudDogMDQgRGVjZW1iZXIgMjAyMSAwNDo0MQ0KPiA+ID4NCj4gPiA+IE9uIEZyaSwgRGVjIDMs
IDIwMjEgYXQgNzozNCBQTSBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4gd3JvdGU6
DQo+ID4gPiA+DQo+ID4gPiA+IEkgbG92ZSB5b3VyIHBhdGNoISBQZXJoYXBzIHNvbWV0aGluZyB0
byBpbXByb3ZlOg0KPiA+IC4uLg0KPiA+ID4NCj4gPiA+IFllcywga2VlcGluZyBzcGFyc2UgaGFw
cHkgd2l0aCB0aGVzZSBjaGVja3N1bSBpcyBub3QgZWFzeS4NCj4gPiA+DQo+ID4gPiBJIHdpbGwg
YWRkIGFuZCB1c2UgdGhpcyBoZWxwZXIsIHVubGVzcyBzb21lb25lIGhhcyBhIGJldHRlciBpZGVh
Lg0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jaGVja3N1bS5oIGIvaW5j
bHVkZS9uZXQvY2hlY2tzdW0uaA0KPiA+ID4gaW5kZXggNWI5NmQ1YmQ2ZTU0NTMyYTdhODI1MTFm
ZjVkN2Q0YzZmMTg5ODJkNS4uNTIxODA0MWU1YzhmOTNjZDM2OWEyYTNhNDZhZGQzZTZhNWU0MWFm
Nw0KPiA+ID4gMTAwNjQ0DQo+ID4gPiAtLS0gYS9pbmNsdWRlL25ldC9jaGVja3N1bS5oDQo+ID4g
PiArKysgYi9pbmNsdWRlL25ldC9jaGVja3N1bS5oDQo+ID4gPiBAQCAtMTgwLDQgKzE4MCw4IEBA
IHN0YXRpYyBpbmxpbmUgdm9pZCByZW1jc3VtX3VuYWRqdXN0KF9fc3VtMTYgKnBzdW0sDQo+ID4g
PiBfX3dzdW0gZGVsdGEpDQo+ID4gPiAgICAgICAgICpwc3VtID0gY3N1bV9mb2xkKGNzdW1fc3Vi
KGRlbHRhLCAoX19mb3JjZSBfX3dzdW0pKnBzdW0pKTsNCj4gPiA+ICB9DQo+ID4gPg0KPiA+ID4g
K3N0YXRpYyBpbmxpbmUgX193c3VtIHdzdW1fbmVnYXRlKF9fd3N1bSB2YWwpDQo+ID4gPiArew0K
PiA+ID4gKyAgICAgICByZXR1cm4gKF9fZm9yY2UgX193c3VtKS0oKF9fZm9yY2UgdTMyKXZhbCk7
DQo+ID4gPiArfQ0KPiA+ID4gICNlbmRpZg0KPiA+DQo+ID4gSSB3YXMgdGhpbmtpbmcgdGhhdCB0
aGUgZXhwcmVzc2lvbiBhbHNvIHJlcXVpcmVzIHNvbWUgY29tbWVudHMuDQo+ID4gU28gbWF5YmUg
cHV0IGEgI2RlZmluZSAvIHN0YXRpYyBpbmxpbmUgaW4gY2hlY2tzdW0uaCBsaWtlOg0KPiA+DQo+
ID4gLyogU3VicmFjdCB0aGUgY2hlY2tzdW0gb2YgYSBidWZmZXIuDQo+ID4gICogVGhlIGRvbWFp
biBpcyBfX3dzdW0gaXMgWzEuLn4wdV0gKGllIGV4Y2x1ZGVzIHplcm8pDQo+ID4gICogc28gfmNz
dW1fcGFydGlhbCgpIGNhbm5vdCBiZSB1c2VkLg0KPiA+ICAqIFRoZSB0d28ncyBjb21wbGltZW50
IGdpdmVzIHRoZSByaWdodCBhbnN3ZXIgcHJvdmlkZWQgdGhlIG9sZCAnY3N1bScNCj4gPiAgKiBp
c24ndCB6ZXJvIC0gd2hpY2ggaXQgc2hvdWxkbid0IGJlLiAqLw0KPiA+ICNkZWZpbmUgY3N1bV9w
YXJ0aWFsX3N1YihidWYsIGxlbiwgY3N1bSkgKC1jc3VtX3BhcnRpYWwoYnVmLCBsZW4sIC0oY3N1
bSkpDQo+ID4NCj4gPiBhbmQgdGhlbiBhZGQgdGhlIGFubm90YXRpb25zIHRoZXJlIHRvIGtlZXAg
c3BhcnNlIGhhcHB5IHRoZXJlLg0KPiA+DQo+ID4gd2lsbCBzcGFyc2UgYWNjZXB0ICcxICsgfmNz
dW0nID8gVGhlIGNvbXBpbGVyIHNob3VsZCB1c2UgbmVnYXRlIGZvciBpdC4NCj4gPiBJdCBhY3R1
YWxseSBtYWtlcyBpdCBzbGlnaHRseSBtb3JlIG9idmlvdXMgd2h5IHRoZSBjb2RlIGlzIHJpZ2h0
Lg0KPiANCj4gU3BhcnNlIGlzIG5vdCBoYXBweSB3aXRoICAxICsgfmNzdW0sDQo+IA0KPiBTbyB3
ZSB1bmZvcnR1bmF0ZWx5IHdvdWxkIG5lZWQgc29tZXRoaW5nIHVnbHkgbGlrZQ0KPiANCj4gKF9f
Zm9yY2UgX193c3VtKSgxICsgfihfX2ZvcmNlIHUzMiljc3VtKQ0KPiANCj4gV2hpY2ggbW9zdCBy
ZWFkZXJzIG9mIHRoaXMgY29kZSB3aWxsIG5vdCBmaW5kIG9idmlvdXMuDQoNClNwYXJzZSByZWFs
bHkgaXNuJ3QgaGVscGluZyBoZXJlIGF0IGFsbC4NClBlcmhhcHMgdGhlcmUgc2hvdWxkIGJlIGEg
d2F5IG9mIG1hcmtpbmcgYSBmdW5jdGlvbiBzbyB0aGF0DQpzcGFyc2UganVzdCBpZ25vcmVzIGl0
Lg0KDQpJIGFsc28gcmF0aGVyIGRpc2xpa2UgdGhhdCB0aGUgY29tcGlsZXIgc2VlcyB0aGUgKHUz
Miljc3VtIGNhc3QuDQpUaGUgc3BhcnNlIGFubm90YXRpb24gc2hvdWxkIHJlYWxseSBiZSBlaXRo
ZXIgX19zcGFyc2UodTMyKWNzdW0NCm9yIF9fc3BhcnNlKHUzMiwgY3N1bSkgdG8gdGhhdCBjb21w
aWxlciB0eXBlIGNoZWNraW5nIHN0aWxsIGFwcGxpZXMuDQoNClBlcmhhcHMgYWRkaW5nOg0KI2Rl
ZmluZSBXU1VNKHZhbCkgKF9fZm9yY2UgX193c3VtKSh2YWwpDQojZGVmaW5lIFUzMihjc3VtKSAg
KF9fZm9yY2UgdTMyKShjc3VtKQ0KYmVmb3JlIHRoZSAnc3RhdGljIGlubGluZXMnIGluIGNoZWNr
c3VtLmggYW5kICN1bmRlZmZpbmcgdGhlbSBhdCB0aGUgZW5kLg0KVGhlbiBhbGwgdGhlIGZ1bmN0
aW9ucyBjb3VsZCBiZSBtYWRlIGEgbGl0dGxlIGVhc2llciB0byByZWFkLg0KDQoJcmV0dXJuIFdT
VU0oMSArIH5VMzIoY3N1bV9wYXJ0aWFsKGJ1ZiwgbGVuLCBXU1VNKDEgKyB+VTMyKGNzdW0pKSk7
DQoNCmlzIGEgYml0IGJldHRlciB0aGFuIHRoZSBjYXN0cyAtIHN0aWxsIG5vdCBuaWNlLg0KDQoJ
RGF2aWQNCg0KDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJy
YW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lz
dHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

