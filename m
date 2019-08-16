Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E85648FD46
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfHPIKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:10:33 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:40964 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfHPIKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 04:10:33 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7G8AUWP019905, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7G8AUWP019905
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 16 Aug 2019 16:10:30 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Fri, 16 Aug
 2019 16:10:29 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Topic: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Index: AQHVUnqNDBLFc1N41kCW+rl5DeKpGqb8z8EAgACQjVA=
Date:   Fri, 16 Aug 2019 08:10:28 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D470D@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
 <9749764d-7815-b673-0fc4-22475601efec@gmail.com>
In-Reply-To: <9749764d-7815-b673-0fc4-22475601efec@gmail.com>
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
ZGF5LCBBdWd1c3QgMTYsIDIwMTkgMjo0MCBQTQ0KWy4uLl0NCj4gdGFza2xldCBhbmQgTkFQSSBh
cmUgc2NoZWR1bGVkIG9uIHRoZSBzYW1lIGNvcmUgKHRoZSBjdXJyZW50DQo+IGNwdSBjYWxsaW5n
IG5hcGlfc2NoZWR1bGUoKSBvciB0YXNrbGV0X3NjaGVkdWxlKCkpDQo+IA0KPiBJIHdvdWxkIHJh
dGhlciBub3QgYWRkIHRoaXMgZHViaW91cyB0YXNrbGV0LCBhbmQgaW5zdGVhZCB0cnkgdG8gdW5k
ZXJzdGFuZA0KPiB3aGF0IGlzIHdyb25nIGluIHRoaXMgZHJpdmVyIDspDQo+IA0KPiBUaGUgdmFy
aW91cyBuYXBpX3NjaGVkdWxlKCkgY2FsbHMgYXJlIHN1c3BlY3QgSU1PLg0KDQpUaGUgb3JpZ2lu
YWwgbWV0aG9kIGFzIGZvbGxvd2luZy4NCg0Kc3RhdGljIGludCByODE1Ml9wb2xsKHN0cnVjdCBu
YXBpX3N0cnVjdCAqbmFwaSwgaW50IGJ1ZGdldCkNCnsNCglzdHJ1Y3QgcjgxNTIgKnRwID0gY29u
dGFpbmVyX29mKG5hcGksIHN0cnVjdCByODE1MiwgbmFwaSk7DQoJaW50IHdvcmtfZG9uZTsNCg0K
CXdvcmtfZG9uZSA9IHJ4X2JvdHRvbSh0cCwgYnVkZ2V0KTsgPC0tIFJYDQoJYm90dG9tX2hhbGYo
dHApOyA8LS0gVHggKHR4X2JvdHRvbSkNCglbLi4uXQ0KDQpUaGUgcnhfYm90dG9tIGFuZCB0eF9i
b3R0b20gd291bGQgb25seSBiZSBjYWxsZWQgaW4gcjgxNTJfcG9sbC4NClRoYXQgaXMsIHR4X2Jv
dHRvbSB3b3VsZG4ndCBiZSBydW4gdW5sZXNzIHJ4X2JvdHRvbSBpcyBmaW5pc2hlZC4NCkFuZCwg
cnhfYm90dG9tIHdvdWxkIGJlIGNhbGxlZCBpZiB0eF9ib3R0b20gaXMgcnVubmluZy4NCg0KSWYg
dGhlIHRyYWZmaWMgaXMgYnVzeS4gcnhfYm90dG9tIG9yIHR4X2JvdHRvbSBtYXkgdGFrZSBhIGxv
dA0Kb2YgdGltZSB0byBkZWFsIHdpdGggdGhlIHBhY2tldHMuIEFuZCB0aGUgb25lIHdvdWxkIGlu
Y3JlYXNlDQp0aGUgbGF0ZW5jeSB0aW1lIGZvciB0aGUgb3RoZXIgb25lLg0KDQpUaGVyZWZvcmUs
IHdoZW4gSSBzZXBhcmF0ZSB0aGUgdHhfYm90dG9tIGFuZCByeF9ib3R0b20gdG8NCmRpZmZlcmVu
dCB0YXNrbGV0IGFuZCBuYXBpLCB0aGUgY2FsbGJhY2sgZnVuY3Rpb25zIG9mIHR4IGFuZA0Kcngg
bWF5IHNjaGVkdWxlIHRoZSB0YXNrbGV0IGFuZCBuYXBpIHRvIGRpZmZlcmVudCBjcHUuIFRoZW4s
DQp0aGUgcnhfYm90dG9tIGFuZCB0eF9ib3R0b20gbWF5IGJlIHJ1biBhdCB0aGUgc2FtZSB0aW1l
Lg0KDQpUYWtlIG91ciBhcm0gcGxhdGZvcm0gZm9yIGV4YW1wbGUuIFRoZXJlIGFyZSBmaXZlIGNw
dXMgdG8NCmhhbmRsZSB0aGUgaW50ZXJydXB0IG9mIFVTQiBob3N0IGNvbnRyb2xsZXIuIFdoZW4g
dGhlIHJ4IGlzDQpjb21wbGV0ZWQsIGNwdSAjMSBtYXkgaGFuZGxlIHRoZSBpbnRlcnJ1cHQgYW5k
IG5hcGkgd291bGQNCmJlIHNjaGVkdWxlZC4gV2hlbiB0aGUgdHggaXMgZmluaXNoZWQsIGNwdSAj
MiBtYXkgaGFuZGxlDQp0aGUgaW50ZXJydXB0IGFuZCB0aGUgdGFza2xldCBpcyBzY2hlZHVsZWQu
IFRoZW4sIG5hcGkgaXMNCnJ1biBvbiBjcHUgIzEsIGFuZCB0YXNrbGV0IGlzIHJ1biBvbiBjcHUg
IzIuDQoNCj4gQWxzbyBydGw4MTUyX3N0YXJ0X3htaXQoKSB1c2VzIHNrYl9xdWV1ZV90YWlsKCZ0
cC0+dHhfcXVldWUsIHNrYik7DQo+IA0KPiBCdXQgSSBzZWUgbm90aGluZyByZWFsbHkga2lja2lu
ZyB0aGUgdHJhbnNtaXQgaWYgdHhfZnJlZSBpcyBlbXB0eSA/DQoNClR4IGNhbGxiYWNrIGZ1bmN0
aW9uICJ3cml0ZV9idWxrX2NhbGxiYWNrIiB3b3VsZCBkZWFsIHdpdGggaXQuDQpUaGUgY2FsbGJh
Y2sgZnVuY3Rpb24gd291bGQgY2hlY2sgaWYgdGhlcmUgYXJlIHBhY2tldHMgd2FpdGluZw0KdG8g
YmUgc2VudC4NCg0KDQpCZXN0IFJlZ2FyZHMsDQpIYXllcw0KDQoNCg==
