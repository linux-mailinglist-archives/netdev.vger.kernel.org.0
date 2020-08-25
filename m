Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093932515C8
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgHYJzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:55:46 -0400
Received: from mx20.baidu.com ([111.202.115.85]:50812 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729456AbgHYJzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 05:55:46 -0400
Received: from BC-Mail-Ex32.internal.baidu.com (unknown [172.31.51.26])
        by Forcepoint Email with ESMTPS id 3539B8D34D64D489C8D8;
        Tue, 25 Aug 2020 17:55:44 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BC-Mail-Ex32.internal.baidu.com (172.31.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Tue, 25 Aug 2020 17:55:44 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Tue, 25 Aug 2020 17:55:44 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "piotr.raczynski@intel.com" <piotr.raczynski@intel.com>,
        "maciej.machnikowski@intel.com" <maciej.machnikowski@intel.com>
Subject: RE: [PATCH net 2/3] ixgbe: avoid premature Rx buffer reuse
Thread-Topic: [PATCH net 2/3] ixgbe: avoid premature Rx buffer reuse
Thread-Index: AQHWesB7tnRiiToEI0WTNehm9NY04alIljXw
Date:   Tue, 25 Aug 2020 09:55:44 +0000
Message-ID: <6356c0ddbdbd4f8fb4927f3ee96c4c33@baidu.com>
References: <20200825091629.12949-1-bjorn.topel@gmail.com>
 <20200825091629.12949-3-bjorn.topel@gmail.com>
In-Reply-To: <20200825091629.12949-3-bjorn.topel@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.44]
x-baidu-bdmsfe-datecheck: 1_BC-Mail-Ex32_2020-08-25 17:55:44:333
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQmrDtnJuIFTDtnBlbCBb
bWFpbHRvOmJqb3JuLnRvcGVsQGdtYWlsLmNvbV0NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDI1
LCAyMDIwIDU6MTYgUE0NCj4gVG86IGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbTsgaW50ZWwt
d2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gQ2M6IEJqw7ZybiBUw7ZwZWwgPGJqb3JuLnRv
cGVsQGludGVsLmNvbT47IG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb207DQo+IG1hZ251cy5rYXJs
c3NvbkBnbWFpbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IG1hY2llai5maWphbGtv
d3NraUBpbnRlbC5jb207IHBpb3RyLnJhY3p5bnNraUBpbnRlbC5jb207DQo+IG1hY2llai5tYWNo
bmlrb3dza2lAaW50ZWwuY29tOyBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+
IFN1YmplY3Q6IFtQQVRDSCBuZXQgMi8zXSBpeGdiZTogYXZvaWQgcHJlbWF0dXJlIFJ4IGJ1ZmZl
ciByZXVzZQ0KPiANCj4gRnJvbTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29t
Pg0KPiANCj4gVGhlIHBhZ2UgcmVjeWNsZSBjb2RlLCBpbmNvcnJlY3RseSwgcmVsaWVkIG9uIHRo
YXQgYSBwYWdlIGZyYWdtZW50IGNvdWxkIG5vdCBiZQ0KPiBmcmVlZCBpbnNpZGUgeGRwX2RvX3Jl
ZGlyZWN0KCkuIFRoaXMgYXNzdW1wdGlvbiBsZWFkcyB0byB0aGF0IHBhZ2UgZnJhZ21lbnRzDQo+
IHRoYXQgYXJlIHVzZWQgYnkgdGhlIHN0YWNrL1hEUCByZWRpcmVjdCBjYW4gYmUgcmV1c2VkIGFu
ZCBvdmVyd3JpdHRlbi4NCj4gDQo+IFRvIGF2b2lkIHRoaXMsIHN0b3JlIHRoZSBwYWdlIGNvdW50
IHByaW9yIGludm9raW5nIHhkcF9kb19yZWRpcmVjdCgpLg0KPiANCj4gRml4ZXM6IDY0NTMwNzM5
ODdiYSAoIml4Z2JlOiBhZGQgaW5pdGlhbCBzdXBwb3J0IGZvciB4ZHAgcmVkaXJlY3QiKQ0KPiBT
aWduZWQtb2ZmLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQoNClJl
cG9ydGVkLWFuZC1hbmFseXplZC1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29t
Pg0KDQpUaGFua3MNCg0KLUxpDQoNCg==
