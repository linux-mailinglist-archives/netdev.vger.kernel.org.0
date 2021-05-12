Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8E937B810
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 10:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhELIeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 04:34:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:47876 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230405AbhELIeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 04:34:20 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-229-1OwfH8tYMOSalqEKjL4KxA-1; Wed, 12 May 2021 09:33:08 +0100
X-MC-Unique: 1OwfH8tYMOSalqEKjL4KxA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 12 May 2021 09:33:06 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Wed, 12 May 2021 09:33:06 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Chris Snook' <chris.snook@gmail.com>,
        Gatis Peisenieks <gatis@mikrotik.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "tully@mikrotik.com" <tully@mikrotik.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 2/4] atl1c: improve performance by avoiding
 unnecessary pcie writes on xmit
Thread-Topic: [PATCH net-next 2/4] atl1c: improve performance by avoiding
 unnecessary pcie writes on xmit
Thread-Index: AQHXRthGfxwa6Sp/UUaodlxqy8H9MarfgGkA
Date:   Wed, 12 May 2021 08:33:06 +0000
Message-ID: <2a1d219618eb4076ab32c141db698241@AcuMS.aculab.com>
References: <20210511190518.8901-1-gatis@mikrotik.com>
 <20210511190518.8901-3-gatis@mikrotik.com>
 <CAMXMK6tkPYLLQzq65uFVd-aCWaVHSne16MBEo7o6fGDTDA0rpw@mail.gmail.com>
In-Reply-To: <CAMXMK6tkPYLLQzq65uFVd-aCWaVHSne16MBEo7o6fGDTDA0rpw@mail.gmail.com>
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

RnJvbTogQ2hyaXMgU25vb2sgPGNocmlzLnNub29rQGdtYWlsLmNvbT4NCj4gU2VudDogMTIgTWF5
IDIwMjEgMDM6NDANCj4gDQo+IE9uIFR1ZSwgTWF5IDExLCAyMDIxIGF0IDEyOjA1IFBNIEdhdGlz
IFBlaXNlbmlla3MgPGdhdGlzQG1pa3JvdGlrLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBUaGUga2Vy
bmVsIGhhcyB4bWl0X21vcmUgZmFjaWxpdHkgdGhhdCBoaW50cyB0aGUgbmV0d29ya2luZyBkcml2
ZXIgeG1pdA0KPiA+IHBhdGggYWJvdXQgd2hldGhlciBtb3JlIHBhY2tldHMgYXJlIGNvbWluZyBz
b29uLiBUaGlzIGluZm9ybWF0aW9uIGNhbiBiZQ0KPiA+IHVzZWQgdG8gYXZvaWQgdW5uZWNlc3Nh
cnkgZXhwZW5zaXZlIFBDSWUgdHJhbnNhY3Rpb24gcGVyIHR4IHBhY2tldCBhdCBhDQo+ID4gc2xp
Z2h0IGluY3JlYXNlIGluIGxhdGVuY3kuDQo+IA0KPiBJbmNyZWFzZXMgaW4gbGF0ZW5jeSB0ZW5k
IHRvIGh1cnQgbW9yZSBvbiBzaW5nbGUtcXVldWUgZGV2aWNlcy4gSGFzDQo+IHRoaXMgYmVlbiB0
ZXN0ZWQgb24gdGhlIG9yaWdpbmFsIGdpZ2FiaXQgYXRsMWM/DQoNCkl0IHByb2JhYmx5IGRlcGVu
ZHMgYSBsb3Qgb24gaG93IGV4cGVuc2l2ZSBpdCBpcyB0byAna2ljaycgdGhlIG1hYyB1bml0Lg0K
DQpBIHNpbXBsZSAocG9zdGVkKSBQQ0llIHdyaXRlIHdoZW4gdGhlIFBDSWUgaG9zdCBpbnRlcmZh
Y2UgaXMgaWRsZSAoYXMgaXMgbGlrZWx5DQp3aGVuIHlvdSd2ZSBqdXN0IGJlZW4gdXBkYXRpbmcg
ZGVzY3JpcHRvcnMpIGlzIHByb2JhYmx5IG5vaXNlIGNvbXBhcmVkDQp0byB0aGUgcmVzdCBvZiB0
aGUgY29zdCBvZiBzZW5kaW5nIHRoZSBwYWNrZXQuDQooRXJpYyB3aWxsIHByb2JhYmx5IHNheSB0
aGV5IG1lYXN1cmVkIGdhaW5zLikNCg0KT1RPSCBpZiB5b3UgaGF2ZSAoYXMgSSBoYXZlIG9uIG9u
ZSBzeXN0ZW0pIHRoZSBlMTAwMGUgZHJpdmVyIGFuZCBzb21lDQpjb21wbGV0ZWx5IGJyb2tlbiAn
bWFuYWdlbWVudCBpbnRlcmZhY2UnIGhhcmR3YXJlIHdoaWNoIG1lYW5zIGl0IGNhbg0KdGFrZSBh
IGxvdCBvZiBtaWNyb3NlY29uZHMgdG8gd3JpdGUgdG8gYW55IE1BQyByZWdpc3RlciB5b3UgcmVh
bGx5DQpkbyBuZWVkIHRvIGxvb2sgYXQgbmV0ZGV2X3htaXRfbW9yZSgpIFsxXS4NCg0KVW5mb3J0
dW5hdGVseSBpdCBkb2Vzbid0IGhlbHAgdGhhdCBtdWNoLg0KbmV0ZGV2X3htaXRfbW9yZSgpIHJl
cG9ydHMgdGhlIHN0YXRlIG9mIHRoZSB0eCBxdWV1ZSB3aGVuIHRoZSBjdXJyZW50DQpza2IgdHJh
bnNtaXQgd2FzIHBhc3NlZCB0byB0aGUgbWFjIGRyaXZlci4NCkl0IGRvZXNuJ3QgcmVwb3J0IHRo
ZSBzdGF0ZSBvZiB0aGUgcXVldWUgYXQgdGhlIHRpbWUgbmV0ZGV2X3htaXRfbW9yZSgpDQppcyBj
YWxsZWQgLSBzbyBhbnkgcGFja2V0cyBxdWV1ZWQgd2hpbGUgdGhlIHRyYW5zbWl0IHNldHVwIGlz
IGluDQpwcm9ncmVzcyBkb24ndCBjYXVzZSBuZXRkZXZfeG1pdF9tb3JlKCkgdG8gcmV0dXJuIHRy
dWUuDQpJJ3ZlIHRyYWNlZCB0aGlzIGhhcHBlbmluZyByZXBlYXRlZGx5Li4uDQoNClsxXSBJZiB0
aGUgTUkgaXMgYWN0aXZlIE1BQyB3cml0ZXMgYXJlIGJyb2tlbiAobWF5IHdyaXRlIHRvIHRoZQ0K
d3JvbmcgcmVnaXN0ZXIpLCBzbyB0aGVyZSBpcyBob3JyaWQgY29kZSBiZWZvcmUgZWFjaCBhY2Nl
c3MgdGhhdA0KKElJUkMpIGVmZmVjdGl2ZWx5IGRvZXM6DQoJd2hpbGUgKG1pX2FjdGl2ZSgpKQ0K
CQltZGVsYXkoMTApOw0KVGhpcyBpcyBqdXN0IHNvIGJyb2tlbiAoaW50ZXJydXB0cyBhcmUgZXZl
biBlbmFibGVkKS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwg
QnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVn
aXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

