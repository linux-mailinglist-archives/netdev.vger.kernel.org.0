Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431868FEB3
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfHPJIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:08:48 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:44202 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfHPJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:08:47 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7G98i7N007735, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7G98i7N007735
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 16 Aug 2019 17:08:44 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Fri, 16 Aug
 2019 17:08:42 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Topic: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Index: AQHVUnqNDBLFc1N41kCW+rl5DeKpGqb8z8EAgACQjVD//4tLgIAAj9bQ
Date:   Fri, 16 Aug 2019 09:08:41 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D47C8@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
 <9749764d-7815-b673-0fc4-22475601efec@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18D470D@RTITMBSVM03.realtek.com.tw>
 <68015004-fb60-f6c6-05b0-610466223cf5@gmail.com>
In-Reply-To: <68015004-fb60-f6c6-05b0-610466223cf5@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RXJpYyBEdW1hemV0IFttYWlsdG86ZXJpYy5kdW1hemV0QGdtYWlsLmNvbV0NCj4gU2VudDogRnJp
ZGF5LCBBdWd1c3QgMTYsIDIwMTkgNDoyMCBQTQ0KWy4uLl0NCj4gV2hpY2ggY2FsbGJhY2sgPw0K
DQpUaGUgVVNCIGRldmljZSBoYXMgdHdvIGVuZHBvaW50cyBmb3IgVHggYW5kIFJ4Lg0KSWYgSSBz
dWJtaXQgdHggb3IgcnggVVJCIHRvIHRoZSBVU0IgaG9zdCBjb250cm9sbGVyLA0KdGhlIHJlbGF0
aXZlIGNhbGxiYWNrIGZ1bmN0aW9ucyB3b3VsZCBiZSBjYWxsZWQsIHdoZW4NCnRoZXkgYXJlIGZp
bmlzaGVkLiBGb3IgcngsIGl0IGlzIHJlYWRfYnVsa19jYWxsYmFjay4NCkZvciB0eCwgaXQgaXMg
d3JpdGVfYnVsa19jYWxsYmFjay4NCg0KPiBBZnRlciBhbiBpZGxlIHBlcmlvZCAobm8gYWN0aXZp
dHksIG5vIHByaW9yIHBhY2tldHMgYmVpbmcgdHgtY29tcGxldGVkIC4uLiksDQo+IGEgcGFja2V0
IGlzIHNlbnQgYnkgdGhlIHVwcGVyIHN0YWNrLCBlbnRlcnMgdGhlIG5kb19zdGFydF94bWl0KCkg
b2YgYSBuZXR3b3JrDQo+IGRyaXZlci4NCj4gDQo+IFRoaXMgZHJpdmVyIG5kb19zdGFydF94bWl0
KCkgc2ltcGx5IGFkZHMgYW4gc2tiIHRvIGEgbG9jYWwgbGlzdCwgYW5kIHJldHVybnMuDQoNCkJh
c2Ugb24gdGhlIGN1cnJlbnQgbWV0aG9kICh3aXRob3V0IHRhc2tsZXQpLCB3aGVuDQpuZG9fc3Rh
cnRfeG1pdCgpIGlzIGNhbGxlZCwgbmFwaV9zY2hlZHVsZSBpcyBjYWxsZWQgb25seQ0KaWYgdGhl
cmUgaXMgYXQgbGVhc3Qgb25lIGZyZWUgYnVmZmVyICghbGlzdF9lbXB0eSgmdHAtPnR4X2ZyZWUp
KQ0KdG8gdHJhbnNtaXQgdGhlIHBhY2tldC4gVGhlbiwgdGhlIGZsb3cgd291bGQgYmUgYXMgZm9s
bG93aW5nLg0KDQogICAgLSBDYWxsIHI4MTUyX3BvbGwNCiAgICAgLS0gQ2FsbCBib3R0b21faGFs
Zg0KICAgICAgLS0tIENhbGwgdHhfYm90dG9tDQogICAgICAgLS0tLSBDYWxsIHI4MTUyX3R4X2Fn
Z19maWxsDQogICAgICAgIC0tLS0tIHN1Ym1pdCB0eCB1cmINCg0KICAgIC0gQ2FsbCB3cml0ZV9i
dWxrX2NhbGxiYWNrIGlmIHR4IGlzIGNvbXBsZXRlZA0KDQpXaGVuIHRoZSB0eCB0cmFuc2ZlciBp
cyBjb21wbGV0ZWQsIHdyaXRlX2J1bGtfY2FsbGJhY2sgd291bGQNCmJlIGNhbGxlZC4gQW5kIGl0
IHdvdWxkIGNoZWNrIGlmIHRoZXJlIGlzIGFueSB0eCBwYWNrZXQNCmluICZ0cC0+dHhfcXVldWUg
YW5kIGRldGVybWluZSB3aGV0aGVyIGl0IGlzIG5lY2Vzc2FyeSB0bw0Kc2NoZWR1bGUgdGhlIG5h
cGkgYWdhaW4gb3Igbm90Lg0KDQo+IFdoZXJlL2hvdyBpcyBzY2hlZHVsZWQgdGhpcyBjYWxsYmFj
ayA/DQoNCkZvciB0eCwgeW91IGNvdWxkIGZpbmQgdGhlIGZvbGxvd2luZyBjb2RlIGluIHI4MTUy
X3R4X2FnZ19maWxsKCkuDQoNCgl1c2JfZmlsbF9idWxrX3VyYihhZ2ctPnVyYiwgdHAtPnVkZXYs
IHVzYl9zbmRidWxrcGlwZSh0cC0+dWRldiwgMiksDQoJCQkgIGFnZy0+aGVhZCwgKGludCkodHhf
ZGF0YSAtICh1OCAqKWFnZy0+aGVhZCksDQoJCQkgICh1c2JfY29tcGxldGVfdCl3cml0ZV9idWxr
X2NhbGxiYWNrLCBhZ2cpOw0KCXJldCA9IHVzYl9zdWJtaXRfdXJiKGFnZy0+dXJiLCBHRlBfQVRP
TUlDKTsNCg0KRm9yIHJ4IHlvdSBjb3VsZCBmaW5kIHRoZSBmb2xsb3dpbmcgY29kZSBpbiByODE1
Ml9zdWJtaXRfcngoKS4NCg0KCXVzYl9maWxsX2J1bGtfdXJiKGFnZy0+dXJiLCB0cC0+dWRldiwg
dXNiX3JjdmJ1bGtwaXBlKHRwLT51ZGV2LCAxKSwNCgkJCSAgYWdnLT5idWZmZXIsIHRwLT5yeF9i
dWZfc3osDQoJCQkgICh1c2JfY29tcGxldGVfdClyZWFkX2J1bGtfY2FsbGJhY2ssIGFnZyk7DQoN
CglyZXQgPSB1c2Jfc3VibWl0X3VyYihhZ2ctPnVyYiwgbWVtX2ZsYWdzKTsNCg0KPiBTb21lIGtp
bmQgb2YgdGltZXIgPw0KPiBBbiAodW5yZWxhdGVkKSBpbmNvbWluZyBwYWNrZXQgPw0KDQpXaGVu
IHRoZSByeCBvciB0eCBpcyBjb21wbGV0ZWQsIGEgaW50ZXJydXB0IG9mIFVTQg0KaG9zdCBjb250
cm9sbGVyIHdvdWxkIGJlIHRyaWdnZXJlZC4gVGhlbiwgdGhlIGNhbGxiYWNrDQpmdW5jdGlvbnMg
d291bGQgYmUgY2FsbGVkLg0KDQpCZXN0IFJlZ2FyZHMsDQpIYXllcw0KDQoNCg==
