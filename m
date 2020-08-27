Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88448254135
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 10:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgH0Ix1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 04:53:27 -0400
Received: from mx22.baidu.com ([220.181.50.185]:56800 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726851AbgH0Ix0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 04:53:26 -0400
Received: from BJHW-Mail-Ex16.internal.baidu.com (unknown [10.127.64.39])
        by Forcepoint Email with ESMTPS id CD5B07171FE383C98378;
        Thu, 27 Aug 2020 16:53:09 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Thu, 27 Aug 2020 16:53:09 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Thu, 27 Aug 2020 16:53:09 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi buffer
Thread-Topic: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi
 buffer
Thread-Index: AQHWfEuob38P5Px0rUW6ibAXXc3666lLpEvg
Date:   Thu, 27 Aug 2020 08:53:09 +0000
Message-ID: <4557d3ad541b4272bc1286480af5e562@baidu.com>
References: <1598514788-31039-1-git-send-email-lirongqing@baidu.com>
 <6d89955c-78a2-fa00-9f39-78648d3558a0@gmail.com>
In-Reply-To: <6d89955c-78a2-fa00-9f39-78648d3558a0@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.19]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex16_2020-08-27 16:53:09:745
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IFtt
YWlsdG86ZXJpYy5kdW1hemV0QGdtYWlsLmNvbV0NCj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAy
NywgMjAyMCA0OjI2IFBNDQo+IFRvOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3Ns
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBpYXZmOiB1c2Uga3Z6YWxsb2MgaW5zdGVhZCBv
ZiBremFsbG9jIGZvciByeC90eF9iaSBidWZmZXINCj4gDQo+IA0KPiANCj4gT24gOC8yNy8yMCAx
Mjo1MyBBTSwgTGkgUm9uZ1Fpbmcgd3JvdGU6DQo+ID4gd2hlbiBjaGFuZ2VzIHRoZSByeC90eCBy
aW5nIHRvIDQwOTYsIGt6YWxsb2MgbWF5IGZhaWwgZHVlIHRvIGENCj4gPiB0ZW1wb3Jhcnkgc2hv
cnRhZ2Ugb24gc2xhYiBlbnRyaWVzLg0KPiA+DQo+ID4ga3ZtYWxsb2MgaXMgdXNlZCB0byBhbGxv
Y2F0ZSB0aGlzIG1lbW9yeSBhcyB0aGVyZSBpcyBubyBuZWVkIHRvIGhhdmUNCj4gPiB0aGlzIG1l
bW9yeSBhcmVhIHBoeXNpY2FsIGNvbnRpbnVvdXNseS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiAtLS0NCj4gDQo+IA0KPiBX
ZWxsLCBmYWxsYmFjayB0byB2bWFsbG9jKCkgb3ZlcmhlYWQgYmVjYXVzZSBvcmRlci0xIHBhZ2Vz
IGFyZSBub3QgcmVhZGlseQ0KPiBhdmFpbGFibGUgd2hlbiB0aGUgTklDIGlzIHNldHVwICh1c3Vh
bGx5IG9uZSB0aW1lIHBlciBib290KSBpcyBhZGRpbmcgVExCIGNvc3QNCj4gYXQgcnVuIHRpbWUs
IGZvciBiaWxsaW9ucyBvZiBwYWNrZXRzIHRvIGNvbWUsIG1heWJlIGZvciBtb250aHMuDQo+IA0K
PiBTdXJlbHkgdHJ5aW5nIGEgYml0IGhhcmRlciB0byBnZXQgb3JkZXItMSBwYWdlcyBpcyBkZXNp
cmFibGUuDQo+IA0KPiAgX19HRlBfUkVUUllfTUFZRkFJTCBpcyBzdXBwb3NlZCB0byBoZWxwIGhl
cmUuDQoNCkNvdWxkIHdlIGFkZCBfX0dGUF9SRVRSWV9NQVlGQUlMIHRvIGt2bWFsbG9jLCB0byBl
bnN1cmUgdGhlIGFsbG9jYXRpb24gc3VjY2VzcyA/DQoNCj4gDQoNCkkgc2VlIHRoYXQgbG90cyBv
ZiBkcml2ZXJzIGFyZSB1c2luZyB2bWFsbG9jIGZvciB0aGlzIGJ1ZmZlciwgc2hvdWxkIHdlIGNo
YW5nZSBpdCBrbWFsbG9jPyAgDQoNCmdyZXAgImJ1ZmZlcl9pbmZvID0iIGRyaXZlcnMvbmV0L2V0
aGVybmV0L2ludGVsLyAtckl8Z3JlcCBhbGxvYw0KDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9peGdiZXZmL2l4Z2JldmZfbWFpbi5jOiAgICAgIHR4X3JpbmctPnR4X2J1ZmZlcl9pbmZvID0g
dm1hbGxvYyhzaXplKTsNCmRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JldmYvaXhnYmV2
Zl9tYWluLmM6ICAgICAgcnhfcmluZy0+cnhfYnVmZmVyX2luZm8gPSB2bWFsbG9jKHNpemUpOw0K
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jOiAgdHhfcmluZy0+
dHhfYnVmZmVyX2luZm8gPSB2bWFsbG9jX25vZGUoc2l6ZSwgcmluZ19ub2RlKTsNCmRyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21haW4uYzogICAgICAgICAgdHhfcmluZy0+
dHhfYnVmZmVyX2luZm8gPSB2bWFsbG9jKHNpemUpOw0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaXhnYmUvaXhnYmVfbWFpbi5jOiAgcnhfcmluZy0+cnhfYnVmZmVyX2luZm8gPSB2bWFsbG9j
X25vZGUoc2l6ZSwgcmluZ19ub2RlKTsNCmRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2Jl
L2l4Z2JlX21haW4uYzogICAgICAgICAgcnhfcmluZy0+cnhfYnVmZmVyX2luZm8gPSB2bWFsbG9j
KHNpemUpOw0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYi9peGdiX21haW4uYzogICAg
dHhkci0+YnVmZmVyX2luZm8gPSB2emFsbG9jKHNpemUpOw0KZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaXhnYi9peGdiX21haW4uYzogICAgcnhkci0+YnVmZmVyX2luZm8gPSB2emFsbG9jKHNp
emUpOw0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL2V0aHRvb2wuYzogICAgdHhf
cmluZy0+YnVmZmVyX2luZm8gPSBrY2FsbG9jKHR4X3JpbmctPmNvdW50LA0KZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvZTEwMDBlL2V0aHRvb2wuYzogICAgcnhfcmluZy0+YnVmZmVyX2luZm8g
PSBrY2FsbG9jKHJ4X3JpbmctPmNvdW50LA0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEw
MDBlL25ldGRldi5jOiAgICAgdHhfcmluZy0+YnVmZmVyX2luZm8gPSB2emFsbG9jKHNpemUpOw0K
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jOiAgICAgcnhfcmluZy0+
YnVmZmVyX2luZm8gPSB2emFsbG9jKHNpemUpOw0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWdiL2lnYl9tYWluLmM6ICAgICAgdHhfcmluZy0+dHhfYnVmZmVyX2luZm8gPSB2bWFsbG9jKHNp
emUpOw0KZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9tYWluLmM6ICAgICAgcnhf
cmluZy0+cnhfYnVmZmVyX2luZm8gPSB2bWFsbG9jKHNpemUpOw0KZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaW50ZWwvZTEwMDAvZTEwMDBfZXRodG9vbC5jOiAgICAgICB0eGRyLT5idWZmZXJfaW5mbyA9
IGtjYWxsb2ModHhkci0+Y291bnQsIHNpemVvZihzdHJ1Y3QgZTEwMDBfdHhfYnVmZmVyKSwNCmRy
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAwL2UxMDAwX2V0aHRvb2wuYzogICAgICAgcnhk
ci0+YnVmZmVyX2luZm8gPSBrY2FsbG9jKHJ4ZHItPmNvdW50LCBzaXplb2Yoc3RydWN0IGUxMDAw
X3J4X2J1ZmZlciksDQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMC9lMTAwMF9tYWlu
LmM6ICB0eGRyLT5idWZmZXJfaW5mbyA9IHZ6YWxsb2Moc2l6ZSk7DQpkcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9lMTAwMC9lMTAwMF9tYWluLmM6ICByeGRyLT5idWZmZXJfaW5mbyA9IHZ6YWxs
b2Moc2l6ZSk7DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYzogICAg
ICB0eF9yaW5nLT50eF9idWZmZXJfaW5mbyA9IHZ6YWxsb2Moc2l6ZSk7DQpkcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pZ2MvaWdjX21haW4uYzogICAgICByeF9yaW5nLT5yeF9idWZmZXJfaW5m
byA9IHZ6YWxsb2Moc2l6ZSk7DQpkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2J2Zi9uZXRk
ZXYuYzogICAgICB0eF9yaW5nLT5idWZmZXJfaW5mbyA9IHZ6YWxsb2Moc2l6ZSk7DQpkcml2ZXJz
L25ldC9ldGhlcm5ldC9pbnRlbC9pZ2J2Zi9uZXRkZXYuYzogICAgICByeF9yaW5nLT5idWZmZXJf
aW5mbyA9IHZ6YWxsb2Moc2l6ZSk7DQoNCg0KLUxpDQo=
