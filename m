Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC56B468538
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 15:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385122AbhLDOES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 09:04:18 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:33757 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1385133AbhLDOER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 09:04:17 -0500
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-74-Jq7wfLECMWWKK7IsXwOGnw-1; Sat, 04 Dec 2021 14:00:49 +0000
X-MC-Unique: Jq7wfLECMWWKK7IsXwOGnw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.26; Sat, 4 Dec 2021 14:00:48 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.026; Sat, 4 Dec 2021 14:00:48 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Eric Dumazet' <edumazet@google.com>,
        kernel test robot <lkp@intel.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David Lebrun" <dlebrun@google.com>
Subject: RE: [PATCH net-next] net: fix recent csum changes
Thread-Topic: [PATCH net-next] net: fix recent csum changes
Thread-Index: AQHX6MkmGXqYzp04fka0oQkYu30MhawiV/GQ
Date:   Sat, 4 Dec 2021 14:00:48 +0000
Message-ID: <d85835b339f345c2b5acd67b71f4b435@AcuMS.aculab.com>
References: <20211203185238.2011081-1-eric.dumazet@gmail.com>
 <202112041104.gPgP3Z6U-lkp@intel.com>
 <CANn89i+m2O9EQCZq5r39ZbnE2dO82pxnj-KshbfWjNH3a5zqWQ@mail.gmail.com>
In-Reply-To: <CANn89i+m2O9EQCZq5r39ZbnE2dO82pxnj-KshbfWjNH3a5zqWQ@mail.gmail.com>
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

RnJvbTogRXJpYyBEdW1hemV0DQo+IFNlbnQ6IDA0IERlY2VtYmVyIDIwMjEgMDQ6NDENCj4gDQo+
IE9uIEZyaSwgRGVjIDMsIDIwMjEgYXQgNzozNCBQTSBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGlu
dGVsLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBJIGxvdmUgeW91ciBwYXRjaCEgUGVyaGFwcyBzb21l
dGhpbmcgdG8gaW1wcm92ZToNCi4uLg0KPiANCj4gWWVzLCBrZWVwaW5nIHNwYXJzZSBoYXBweSB3
aXRoIHRoZXNlIGNoZWNrc3VtIGlzIG5vdCBlYXN5Lg0KPiANCj4gSSB3aWxsIGFkZCBhbmQgdXNl
IHRoaXMgaGVscGVyLCB1bmxlc3Mgc29tZW9uZSBoYXMgYSBiZXR0ZXIgaWRlYS4NCj4gDQo+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL25ldC9jaGVja3N1bS5oIGIvaW5jbHVkZS9uZXQvY2hlY2tzdW0u
aA0KPiBpbmRleCA1Yjk2ZDViZDZlNTQ1MzJhN2E4MjUxMWZmNWQ3ZDRjNmYxODk4MmQ1Li41MjE4
MDQxZTVjOGY5M2NkMzY5YTJhM2E0NmFkZDNlNmE1ZTQxYWY3DQo+IDEwMDY0NA0KPiAtLS0gYS9p
bmNsdWRlL25ldC9jaGVja3N1bS5oDQo+ICsrKyBiL2luY2x1ZGUvbmV0L2NoZWNrc3VtLmgNCj4g
QEAgLTE4MCw0ICsxODAsOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgcmVtY3N1bV91bmFkanVzdChf
X3N1bTE2ICpwc3VtLA0KPiBfX3dzdW0gZGVsdGEpDQo+ICAgICAgICAgKnBzdW0gPSBjc3VtX2Zv
bGQoY3N1bV9zdWIoZGVsdGEsIChfX2ZvcmNlIF9fd3N1bSkqcHN1bSkpOw0KPiAgfQ0KPiANCj4g
K3N0YXRpYyBpbmxpbmUgX193c3VtIHdzdW1fbmVnYXRlKF9fd3N1bSB2YWwpDQo+ICt7DQo+ICsg
ICAgICAgcmV0dXJuIChfX2ZvcmNlIF9fd3N1bSktKChfX2ZvcmNlIHUzMil2YWwpOw0KPiArfQ0K
PiAgI2VuZGlmDQoNCkkgd2FzIHRoaW5raW5nIHRoYXQgdGhlIGV4cHJlc3Npb24gYWxzbyByZXF1
aXJlcyBzb21lIGNvbW1lbnRzLg0KU28gbWF5YmUgcHV0IGEgI2RlZmluZSAvIHN0YXRpYyBpbmxp
bmUgaW4gY2hlY2tzdW0uaCBsaWtlOg0KDQovKiBTdWJyYWN0IHRoZSBjaGVja3N1bSBvZiBhIGJ1
ZmZlci4NCiAqIFRoZSBkb21haW4gaXMgX193c3VtIGlzIFsxLi5+MHVdIChpZSBleGNsdWRlcyB6
ZXJvKQ0KICogc28gfmNzdW1fcGFydGlhbCgpIGNhbm5vdCBiZSB1c2VkLg0KICogVGhlIHR3bydz
IGNvbXBsaW1lbnQgZ2l2ZXMgdGhlIHJpZ2h0IGFuc3dlciBwcm92aWRlZCB0aGUgb2xkICdjc3Vt
Jw0KICogaXNuJ3QgemVybyAtIHdoaWNoIGl0IHNob3VsZG4ndCBiZS4gKi8NCiNkZWZpbmUgY3N1
bV9wYXJ0aWFsX3N1YihidWYsIGxlbiwgY3N1bSkgKC1jc3VtX3BhcnRpYWwoYnVmLCBsZW4sIC0o
Y3N1bSkpDQoNCmFuZCB0aGVuIGFkZCB0aGUgYW5ub3RhdGlvbnMgdGhlcmUgdG8ga2VlcCBzcGFy
c2UgaGFwcHkgdGhlcmUuDQoNCndpbGwgc3BhcnNlIGFjY2VwdCAnMSArIH5jc3VtJyA/IFRoZSBj
b21waWxlciBzaG91bGQgdXNlIG5lZ2F0ZSBmb3IgaXQuDQpJdCBhY3R1YWxseSBtYWtlcyBpdCBz
bGlnaHRseSBtb3JlIG9idmlvdXMgd2h5IHRoZSBjb2RlIGlzIHJpZ2h0Lg0KDQoJRGF2aWQNCg0K
LQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0s
IE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdh
bGVzKQ0K

