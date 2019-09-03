Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4AFA61F3
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfICGz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:55:57 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:59391 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfICGz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 02:55:56 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x836trTA023086, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x836trTA023086
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 3 Sep 2019 14:55:54 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Tue, 3 Sep 2019
 14:55:52 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: modify rtl8152_set_speed function
Thread-Topic: [PATCH net-next] r8152: modify rtl8152_set_speed function
Thread-Index: AQHVYYTrRMaVJv63vEGfeZKbVbiDuqcYMZIAgAEQO0D//7KEAIAAiqfA//9+BQCAAIbSYA==
Date:   Tue, 3 Sep 2019 06:55:51 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18DAD2A@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-326-Taiwan-albertk@realtek.com>
 <280e6a3d-c6c3-ef32-a65d-19566190a1d3@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DAB41@RTITMBSVM03.realtek.com.tw>
 <aa9513ff-3cef-4b9f-ecbd-1310660a911c@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18DACE1@RTITMBSVM03.realtek.com.tw>
 <56675c6b-c792-245e-54d0-eacd50e7a139@gmail.com>
In-Reply-To: <56675c6b-c792-245e-54d0-eacd50e7a139@gmail.com>
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

SGVpbmVyIEthbGx3ZWl0IFttYWlsdG86aGthbGx3ZWl0MUBnbWFpbC5jb21dDQo+IFNlbnQ6IFR1
ZXNkYXksIFNlcHRlbWJlciAwMywgMjAxOSAyOjQ1IFBNDQpbLi4uXQ0KPiA+IEJlc2lkZXMsIEkg
aGF2ZSBhIHF1ZXN0aW9uLiBJIHRoaW5rIEkgZG9uJ3QgbmVlZCBydGw4MTUyX3NldF9zcGVlZCgp
DQo+ID4gaWYgSSBpbXBsZW1lbnQgcGh5bGliLiBIb3dldmVyLCBJIG5lZWQgdG8gcmVjb3JkIHNv
bWUgaW5mb3JtYXRpb24NCj4gPiBhY2NvcmRpbmcgdG8gdGhlIHNldHRpbmdzIG9mIHNwZWVkLiBG
b3Igbm93LCBJIGRvIGl0IGluIHJ0bDgxNTJfc2V0X3NwZWVkKCkuDQo+ID4gRG8geW91IGhhdmUg
YW55IGlkZWEgYWJvdXQgaG93IEkgc2hvdWxkIGRvIGl0IHdpdGggcGh5bGliIHdpdGhvdXQNCj4g
PiBydGw4MTUyX3NldF9zcGVlZCgpPw0KPiA+DQo+IFdoZW4gc2F5aW5nICJyZWNvcmQgc29tZSBp
bmZvcm1hdGlvbiIsIHdoYXQga2luZCBvZiBpbmZvcm1hdGlvbj8NCg0KU29tZSBvZiBvdXIgY2hp
cHMgc3VwcG9ydCB0aGUgZmVhdHVyZSBvZiBVUFMuIFdoZW4gc2F0aXNmeWluZyBjZXJ0YWluDQpj
b25kaXRpb24sIHRoZSBodyB3b3VsZCByZWNvdmVyIHRoZSBzZXR0aW5ncyBvZiBzcGVlZC4gVGhl
cmVmb3JlLCBJIGhhdmUNCnRvIHJlY29yZCB0aGUgc2V0dGluZ3Mgb2YgdGhlIHNwZWVkLCBhbmQg
c2V0IHRoZW0gdG8gaHcuDQoNCj4gVGhlIHNwZWVkIGl0c2VsZiBpcyBzdG9yZWQgaW4gc3RydWN0
IHBoeV9kZXZpY2UsIGlmIHlvdSBuZWVkIHRvIGFkanVzdA0KPiBjZXJ0YWluIGNoaXAgc2V0dGlu
Z3MgZGVwZW5kaW5nIG9uIG5lZ290aWF0ZWQgc3BlZWQsIHRoZW4geW91IGNhbiBkbw0KPiB0aGlz
IGluIGEgY2FsbGJhY2sgKHBhcmFtZXRlciBoYW5kbGVyIG9mIHBoeV9jb25uZWN0X2RpcmVjdCku
DQo+IFNlZSBlLmcuIHI4MTY5X3BoeWxpbmtfaGFuZGxlcigpDQoNClRoYW5rcy4gSSB3b3VsZCBz
dHVkeSBpdC4NCg0KQmVzdCBSZWdhcmRzLA0KSGF5ZXMNCg0KDQo=
