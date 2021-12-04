Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5187046872F
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 20:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348086AbhLDTWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 14:22:08 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:52058 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347719AbhLDTWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 14:22:08 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-90-yYUZG11fPOWXTjrZAivVgw-1; Sat, 04 Dec 2021 19:18:40 +0000
X-MC-Unique: yYUZG11fPOWXTjrZAivVgw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sat, 4 Dec 2021 19:18:39 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sat, 4 Dec 2021 19:18:39 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        'Eric Dumazet' <edumazet@google.com>
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
Thread-Index: AQHX6MkmGXqYzp04fka0oQkYu30MhawiV/GQgABReYCAAANfcIAAB9IA
Date:   Sat, 4 Dec 2021 19:18:39 +0000
Message-ID: <2eebed09fb46486298e18d5de72d3afe@AcuMS.aculab.com>
References: <20211203185238.2011081-1-eric.dumazet@gmail.com>
 <202112041104.gPgP3Z6U-lkp@intel.com>
 <CANn89i+m2O9EQCZq5r39ZbnE2dO82pxnj-KshbfWjNH3a5zqWQ@mail.gmail.com>
 <d85835b339f345c2b5acd67b71f4b435@AcuMS.aculab.com>
 <CANn89i+bondpbSEbXp5jF6_keYMGNfwAS8YXQBYMNyKgGb3WEA@mail.gmail.com>
 <693ac4fa50dd4aa2be9faa84861eb91b@AcuMS.aculab.com>
In-Reply-To: <693ac4fa50dd4aa2be9faa84861eb91b@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0IDxEYXZpZC5MYWlnaHRAQUNVTEFCLkNPTT4NCj4gU2VudDogMDQg
RGVjZW1iZXIgMjAyMSAxOTowMw0KPiANCj4gRnJvbTogRXJpYyBEdW1hemV0DQo+ID4gU2VudDog
MDQgRGVjZW1iZXIgMjAyMSAxODozNA0KPiA+DQo+ID4gT24gU2F0LCBEZWMgNCwgMjAyMSBhdCA2
OjAwIEFNIERhdmlkIExhaWdodCA8RGF2aWQuTGFpZ2h0QGFjdWxhYi5jb20+IHdyb3RlOg0KPiA+
ID4NCj4gPiA+IEZyb206IEVyaWMgRHVtYXpldA0KPiA+ID4gPiBTZW50OiAwNCBEZWNlbWJlciAy
MDIxIDA0OjQxDQo+ID4gPiA+DQo+ID4gPiA+IE9uIEZyaSwgRGVjIDMsIDIwMjEgYXQgNzozNCBQ
TSBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiBJIGxvdmUgeW91ciBwYXRjaCEgUGVyaGFwcyBzb21ldGhpbmcgdG8gaW1wcm92ZToN
Cj4gPiA+IC4uLg0KPiA+ID4gPg0KPiA+ID4gPiBZZXMsIGtlZXBpbmcgc3BhcnNlIGhhcHB5IHdp
dGggdGhlc2UgY2hlY2tzdW0gaXMgbm90IGVhc3kuDQo+ID4gPiA+DQo+ID4gPiA+IEkgd2lsbCBh
ZGQgYW5kIHVzZSB0aGlzIGhlbHBlciwgdW5sZXNzIHNvbWVvbmUgaGFzIGEgYmV0dGVyIGlkZWEu
DQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jaGVja3N1bS5oIGIv
aW5jbHVkZS9uZXQvY2hlY2tzdW0uaA0KPiA+ID4gPiBpbmRleCA1Yjk2ZDViZDZlNTQ1MzJhN2E4
MjUxMWZmNWQ3ZDRjNmYxODk4MmQ1Li41MjE4MDQxZTVjOGY5M2NkMzY5YTJhM2E0NmFkZDNlNmE1
ZTQxYWY3DQo+ID4gPiA+IDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9pbmNsdWRlL25ldC9jaGVja3N1
bS5oDQo+ID4gPiA+ICsrKyBiL2luY2x1ZGUvbmV0L2NoZWNrc3VtLmgNCj4gPiA+ID4gQEAgLTE4
MCw0ICsxODAsOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgcmVtY3N1bV91bmFkanVzdChfX3N1bTE2
ICpwc3VtLA0KPiA+ID4gPiBfX3dzdW0gZGVsdGEpDQo+ID4gPiA+ICAgICAgICAgKnBzdW0gPSBj
c3VtX2ZvbGQoY3N1bV9zdWIoZGVsdGEsIChfX2ZvcmNlIF9fd3N1bSkqcHN1bSkpOw0KPiA+ID4g
PiAgfQ0KPiA+ID4gPg0KPiA+ID4gPiArc3RhdGljIGlubGluZSBfX3dzdW0gd3N1bV9uZWdhdGUo
X193c3VtIHZhbCkNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKyAgICAgICByZXR1cm4gKF9fZm9yY2Ug
X193c3VtKS0oKF9fZm9yY2UgdTMyKXZhbCk7DQo+ID4gPiA+ICt9DQo+ID4gPiA+ICAjZW5kaWYN
Cj4gPiA+DQo+ID4gPiBJIHdhcyB0aGlua2luZyB0aGF0IHRoZSBleHByZXNzaW9uIGFsc28gcmVx
dWlyZXMgc29tZSBjb21tZW50cy4NCj4gPiA+IFNvIG1heWJlIHB1dCBhICNkZWZpbmUgLyBzdGF0
aWMgaW5saW5lIGluIGNoZWNrc3VtLmggbGlrZToNCj4gPiA+DQo+ID4gPiAvKiBTdWJyYWN0IHRo
ZSBjaGVja3N1bSBvZiBhIGJ1ZmZlci4NCj4gPiA+ICAqIFRoZSBkb21haW4gaXMgX193c3VtIGlz
IFsxLi5+MHVdIChpZSBleGNsdWRlcyB6ZXJvKQ0KPiA+ID4gICogc28gfmNzdW1fcGFydGlhbCgp
IGNhbm5vdCBiZSB1c2VkLg0KPiA+ID4gICogVGhlIHR3bydzIGNvbXBsaW1lbnQgZ2l2ZXMgdGhl
IHJpZ2h0IGFuc3dlciBwcm92aWRlZCB0aGUgb2xkICdjc3VtJw0KPiA+ID4gICogaXNuJ3QgemVy
byAtIHdoaWNoIGl0IHNob3VsZG4ndCBiZS4gKi8NCj4gPiA+ICNkZWZpbmUgY3N1bV9wYXJ0aWFs
X3N1YihidWYsIGxlbiwgY3N1bSkgKC1jc3VtX3BhcnRpYWwoYnVmLCBsZW4sIC0oY3N1bSkpDQo+
ID4gPg0KPiA+ID4gYW5kIHRoZW4gYWRkIHRoZSBhbm5vdGF0aW9ucyB0aGVyZSB0byBrZWVwIHNw
YXJzZSBoYXBweSB0aGVyZS4NCj4gPiA+DQo+ID4gPiB3aWxsIHNwYXJzZSBhY2NlcHQgJzEgKyB+
Y3N1bScgPyBUaGUgY29tcGlsZXIgc2hvdWxkIHVzZSBuZWdhdGUgZm9yIGl0Lg0KPiA+ID4gSXQg
YWN0dWFsbHkgbWFrZXMgaXQgc2xpZ2h0bHkgbW9yZSBvYnZpb3VzIHdoeSB0aGUgY29kZSBpcyBy
aWdodC4NCj4gPg0KPiA+IFNwYXJzZSBpcyBub3QgaGFwcHkgd2l0aCAgMSArIH5jc3VtLA0KPiA+
DQo+ID4gU28gd2UgdW5mb3J0dW5hdGVseSB3b3VsZCBuZWVkIHNvbWV0aGluZyB1Z2x5IGxpa2UN
Cj4gPg0KPiA+IChfX2ZvcmNlIF9fd3N1bSkoMSArIH4oX19mb3JjZSB1MzIpY3N1bSkNCj4gPg0K
PiA+IFdoaWNoIG1vc3QgcmVhZGVycyBvZiB0aGlzIGNvZGUgd2lsbCBub3QgZmluZCBvYnZpb3Vz
Lg0KPiANCj4gU3BhcnNlIHJlYWxseSBpc24ndCBoZWxwaW5nIGhlcmUgYXQgYWxsLg0KPiBQZXJo
YXBzIHRoZXJlIHNob3VsZCBiZSBhIHdheSBvZiBtYXJraW5nIGEgZnVuY3Rpb24gc28gdGhhdA0K
PiBzcGFyc2UganVzdCBpZ25vcmVzIGl0Lg0KPiANCj4gSSBhbHNvIHJhdGhlciBkaXNsaWtlIHRo
YXQgdGhlIGNvbXBpbGVyIHNlZXMgdGhlICh1MzIpY3N1bSBjYXN0Lg0KPiBUaGUgc3BhcnNlIGFu
bm90YXRpb24gc2hvdWxkIHJlYWxseSBiZSBlaXRoZXIgX19zcGFyc2UodTMyKWNzdW0NCj4gb3Ig
X19zcGFyc2UodTMyLCBjc3VtKSB0byB0aGF0IGNvbXBpbGVyIHR5cGUgY2hlY2tpbmcgc3RpbGwg
YXBwbGllcy4NCj4gDQo+IFBlcmhhcHMgYWRkaW5nOg0KPiAjZGVmaW5lIFdTVU0odmFsKSAoX19m
b3JjZSBfX3dzdW0pKHZhbCkNCj4gI2RlZmluZSBVMzIoY3N1bSkgIChfX2ZvcmNlIHUzMikoY3N1
bSkNCj4gYmVmb3JlIHRoZSAnc3RhdGljIGlubGluZXMnIGluIGNoZWNrc3VtLmggYW5kICN1bmRl
ZmZpbmcgdGhlbSBhdCB0aGUgZW5kLg0KPiBUaGVuIGFsbCB0aGUgZnVuY3Rpb25zIGNvdWxkIGJl
IG1hZGUgYSBsaXR0bGUgZWFzaWVyIHRvIHJlYWQuDQo+IA0KPiAJcmV0dXJuIFdTVU0oMSArIH5V
MzIoY3N1bV9wYXJ0aWFsKGJ1ZiwgbGVuLCBXU1VNKDEgKyB+VTMyKGNzdW0pKSk7DQo+IA0KPiBp
cyBhIGJpdCBiZXR0ZXIgdGhhbiB0aGUgY2FzdHMgLSBzdGlsbCBub3QgbmljZS4NCg0KVGhpbmtp
bmcgYWdhaW4uLi4NCiNpZmRlZiBfX3NwYXJzZQ0KCS8qIFNraXAgb2Zmc2V0dGluZyB0byBzYXZl
IDQgY2FzdHMuICovDQoJcmV0dXJuIH5jc3VtX3BhcnRpYWwoYnVmLCBsZW4sIH5jc3VtKTsNCiNl
bHNlDQoJLyogT2Zmc2V0IGJ5IG9uZSBzbyB0aGF0IHplcm8gaXMgbmV2ZXIgcmV0dXJuZWQuICov
DQoJcmV0dXJuIDEgKyB+Y3N1bV9wYXJ0aWFsKGJ1ZmcsIGxlbiwgMSArIH5jc3VtKTsNCiNlbmRp
Zg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K

