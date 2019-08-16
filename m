Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96B68FFB0
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 12:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfHPKFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 06:05:03 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47671 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfHPKFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 06:05:03 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7GA50iC028277, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7GA50iC028277
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 16 Aug 2019 18:05:00 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Fri, 16 Aug
 2019 18:04:59 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Topic: [PATCH net-next] r8152: divide the tx and rx bottom functions
Thread-Index: AQHVUnqNDBLFc1N41kCW+rl5DeKpGqb8z8EAgACQjVD//4tLgIAAj9bQ//+DD4CAAI4VUA==
Date:   Fri, 16 Aug 2019 10:04:58 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D4837@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
 <9749764d-7815-b673-0fc4-22475601efec@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18D470D@RTITMBSVM03.realtek.com.tw>
 <68015004-fb60-f6c6-05b0-610466223cf5@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18D47C8@RTITMBSVM03.realtek.com.tw>
 <a262d73b-0e91-7610-c88f-9670cc6fd18d@gmail.com>
In-Reply-To: <a262d73b-0e91-7610-c88f-9670cc6fd18d@gmail.com>
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
ZGF5LCBBdWd1c3QgMTYsIDIwMTkgNToyNyBQTQ0KWy4uLl0NCj4gTWF5YmUgeW91IHdvdWxkIGF2
b2lkIG1lc3Npbmcgd2l0aCBhIHRhc2tsZXQgKHdlIHJlYWxseSB0cnkgdG8gZ2V0IHJpZA0KPiBv
ZiB0YXNrbGV0cyBpbiBnZW5lcmFsKSB1c2luZyB0d28gTkFQSSwgb25lIGZvciBUWCwgb25lIGZv
ciBSWC4NCj4gDQo+IFNvbWUgZHJpdmVycyBhbHJlYWR5IHVzZSB0d28gTkFQSSwgaXQgaXMgZmlu
ZS4NCj4gDQo+IFRoaXMgbWlnaHQgYXZvaWQgdGhlIHVnbHkgZGFuY2UgaW4gcjgxNTJfcG9sbCgp
LA0KPiBjYWxsaW5nIG5hcGlfc2NoZWR1bGUobmFwaSkgYWZ0ZXIgbmFwaV9jb21wbGV0ZV9kb25l
KCkgIQ0KDQpUaGUgcmVhc29uIGlzIHRoYXQgdGhlIFVTQiBkZXZpY2UgY291bGRuJ3QgY29udHJv
bA0KdGhlIGludGVycnVwdCBvZiBVU0IgY29udHJvbGxlci4gVGhhdCBpcywgSSBjb3VsZG4ndA0K
ZGlzYWJsZSB0aGUgaW50ZXJydXB0IGJlZm9yZSBuYXBpX3NjaGVkdWxlIGFuZA0KZW5hYmxlIGl0
IGFmdGVyIG5hcGlfY29tcGxldGVfZG9uZS4gSWYgdGhlIGNhbGxiYWNrDQpmdW5jdGlvbiBvY2N1
cnMgZHVyaW5nIHRoZSBmb2xsb3dpbmcgdGltaW5nLCBpdCBpcw0KcG9zc2libGUgbm8gb25lIHdv
dWxkIHNjaGVkdWxlIHRoZSBuYXBpIGFnYWluLg0KDQpzdGF0aWMgaW50IHI4MTUyX3BvbGwoc3Ry
dWN0IG5hcGlfc3RydWN0ICpuYXBpLCBpbnQgYnVkZ2V0KQ0Kew0KCXN0cnVjdCByODE1MiAqdHAg
PSBjb250YWluZXJfb2YobmFwaSwgc3RydWN0IHI4MTUyLCBuYXBpKTsNCglpbnQgd29ya19kb25l
Ow0KDQoJd29ya19kb25lID0gcnhfYm90dG9tKHRwLCBidWRnZXQpOw0KCWJvdHRvbV9oYWxmKHRw
KTsNCg0KCS0tPiBjYWxsYmFjayBvY2N1cnMgaGVyZSBhbmQgdHJ5IHRvIGNhbGwgbmFwaV9zY2hl
ZHVsZQ0KDQoJbmFwaV9jb21wbGV0ZV9kb25lKG5hcGksIHdvcmtfZG9uZSkNCg0KVGhhdCBpcywg
bm8gdHggb3IgcnggY291bGQgYmUgaGFuZGxlZCB1bmxlc3MNCnNvbWV0aGluZyB0cmlnZ2VyIG5h
cGlfc2NoZWR1bGUuDQoNCg0KQmVzdCBSZWdhcmRzLA0KSGF5ZXMNCg0KDQoNCg==
