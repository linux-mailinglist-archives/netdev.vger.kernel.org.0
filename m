Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF33D29207C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 00:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbgJRWcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 18:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgJRWcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 18:32:04 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F64C061755
        for <netdev@vger.kernel.org>; Sun, 18 Oct 2020 15:32:04 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 9C6AB891B0;
        Mon, 19 Oct 2020 11:32:00 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603060320;
        bh=B2eBbWYeQ5ZSqD9dO7Q4y+a+ZblTN5uJmc+ivWQEp1U=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=iFTi+O3s1Z3vpROLdszaHAdO9mnaPQ2h3YB0gevJuZMSg+mZjDYZn5ePHMLlo/YEy
         OSWG95D9HzToxDCfQ8//8GqnCQQFdegVi0egw8e3aT1brxlBJw1Kbcs9cPqz/ijZTO
         5MiikxbVwqSVEd5v6Hyjmv/Um37G1Z4QOhR/6ZCt6gD8KONpxOtJsQENYbSGd38gjj
         WMaWImaReWP500nOGI+qbFnuCGdW1nppQREFgtyUBI0KC+WojC31xHCBuutZ+MeU3h
         D8S8j/6jnuoIzqZn4RW6AAxRBMb/dYO6tzKWa61/nY3WoceszPK7leCFitq14Xqqhe
         z3CUZ29Nb4BDQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8cc25f0000>; Mon, 19 Oct 2020 11:31:59 +1300
Received: from svr-chch-ex1.atlnz.lc (10.32.16.77) by svr-chch-ex1.atlnz.lc
 (10.32.16.77) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 11:31:55 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 19 Oct 2020 11:31:55 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6097
Thread-Topic: [PATCH 2/2] net: dsa: mv88e6xxx: Support serdes ports on
 MV88E6097
Thread-Index: AQHWoQc4/uQqPxKVFEaOBfkb784lwamcuA8AgABBNACAAARwgIAADggAgAAOooCAAAadgA==
Date:   Sun, 18 Oct 2020 22:31:55 +0000
Message-ID: <862bec00-92d8-2f4a-03e5-93546e6563f6@alliedtelesis.co.nz>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
 <20201018161624.GD456889@lunn.ch>
 <b3d1d071-3bce-84f4-e9d5-f32a41c432bd@alliedtelesis.co.nz>
 <20201018202539.GJ456889@lunn.ch>
 <2e1f1ca4-b5d5-ebc8-99bf-9ad74f461d26@alliedtelesis.co.nz>
 <20201018220815.GK456889@lunn.ch>
In-Reply-To: <20201018220815.GK456889@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8A306865C33984FBAE371E5EEFDFCF3@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxOS8xMC8yMCAxMTowOCBhbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIFN1biwgT2N0
IDE4LCAyMDIwIGF0IDA5OjE1OjUyUE0gKzAwMDAsIENocmlzIFBhY2toYW0gd3JvdGU6DQo+PiBP
biAxOS8xMC8yMCA5OjI1IGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+Pj4gSSBhc3N1bWUgeW91
J3JlIHRhbGtpbmcgYWJvdXQgdGhlIFBIWSBDb250cm9sIFJlZ2lzdGVyIDAgYml0IDExLiBJZiBz
bw0KPj4+PiB0aGF0J3MgZm9yIHRoZSBpbnRlcm5hbCBQSFlzIG9uIHBvcnRzIDAtNy4gUG9ydHMg
OCwgOSBhbmQgMTAgZG9uJ3QgaGF2ZQ0KPj4+PiBQSFlzLg0KPj4+IEhpIENocmlzDQo+Pj4NCj4+
PiBJIGhhdmUgYSBkYXRhc2hlZXQgZm9yIHRoZSA2MTIyLzYxMjEsIGZyb20gc29tZSBjb3JuZXIg
b2YgdGhlIHdlYiwNCj4+PiBQYXJ0IDMgb2YgMywgR2lnYWJpdCBQSFlzIGFuZCBTRVJERVMuDQo+
Pj4NCj4+PiBodHRwOi8vd3d3LmltYWdlLm1pY3Jvcy5jb20ucGwvX2RhbmVfdGVjaG5pY3puZV9h
dXRvL3VpODhlNjEyMmIybGtqMWkwLnBkZg0KPj4+DQo+Pj4gU2VjdGlvbiA1IG9mIHRoaXMgZG9j
dW1lbnQgdGFsa3MNCj4+PiBhYm91dCB0aGUgU0VSREVTIHJlZ2lzdGVycy4gUmVnaXN0ZXIgMCBp
cyBDb250cm9sLCByZWdpc3RlciAxIGlzDQo+Pj4gU3RhdHVzIC0gRmliZXIsIHJlZ2lzdGVyIDIg
YW5kIDMgYXJlIHRoZSB1c3VhbCBJRCwgNCBpcyBhdXRvLW5ldA0KPj4+IGFkdmVydGlzZW1lbnQg
ZXRjLg0KPj4+DQo+Pj4gV2hlcmUgdGhlc2UgcmVnaXN0ZXJzIGFwcGVhciBpbiB0aGUgYWRkcmVz
cyBzcGFjZSBpcyBub3QgY2xlYXIgZnJvbQ0KPj4+IHRoaXMgZG9jdW1lbnQuIEl0IGlzIG5vcm1h
bGx5IGluIGRvY3VtZW50IHBhcnQgMiBvZiAzLCB3aGljaCBteQ0KPj4+IHNlYXJjaGluZyBvZiB0
aGUgd2ViIGRpZCBub3QgZmluZC4NCj4+Pg0KPj4+IAkgIEFuZHJldw0KPj4gSSBoYXZlIGdvdCB0
aGUgODhFNjEyMiBkYXRhc2hlZXQocykgYW5kIGNhbiBzZWUgdGhlIFNFUkRFUyByZWdpc3RlcnMN
Cj4+IHlvdSdyZSB0YWxraW5nIGFib3V0IChJIHRoaW5rIHRoZXkncmUgaW4gdGhlIHNhbWUgcmVn
aXN0ZXIgc3BhY2UgYXMgdGhlDQo+PiBidWlsdC1pbiBQSFlzKS4gSXQgbG9va3MgbGlrZSB0aGUg
ODhFNjA5NyBpcyBkaWZmZXJlbnQgaW4gdGhhdCB0aGVyZSBhcmUNCj4+IG5vIFNFUkRFUyByZWdp
c3RlcnMgZXhwb3NlZCAoYXQgbGVhc3Qgbm90IGluIGEgZG9jdW1lbnRlZCB3YXkpLiBMb29raW5n
DQo+PiBhdCB0aGUgODhFNjE4NSBpdCdzIHRoZSBzYW1lIGFzIHRoZSA4OEU2MDk3Lg0KPiBIaSBD
aHJpcw0KPg0KPiBJIGZpbmQgaXQgb2RkIHRoZXJlIGFyZSBubyBTRVJERVMgcmVnaXN0ZXJzLiAg
Q2FuIHlvdSBwb2tlIGFyb3VuZCB0aGUNCj4gcmVnaXN0ZXIgc3BhY2UgYW5kIGxvb2sgZm9yIElE
IHJlZ2lzdGVycz8gU2VlIGlmIHRoZXJlIGFyZSBhbnkgd2l0aA0KPiBNYXJ2ZWxscyBPVUksIGJ1
dCBkaWZmZXJlbnQgdG8gdGhlIGNoaXAgSUQgZm91bmQgaW4gdGhlIHBvcnQNCj4gcmVnaXN0ZXJz
Pw0KIEZyb20gbXkgZXhwZXJpZW5jZSB3aXRoIE1hcnZlbGwgSSBkb24ndCB0aGluayBpdCdzIHRo
YXQgb2RkLiANClBhcnRpY3VsYXJseSBmb3IgYSAxRyBTRVJERVMgdGhlcmUncyByZWFsbHkgbm90
IG11Y2ggdGhhdCBuZWVkcyANCmNvbmZpZ3VyaW5nIChhbHRob3VnaCBwb3dlciB1cC9kb3duIHdv
dWxkIGJlIG5pY2UpLiBJJ2xsIHBva2UgYXJvdW5kIA0KdGhhdCByZWdpc3RlciBzcGFjZSB0byBz
ZWUgaWYgYW55dGhpbmcgaXMgdGhlcmUuDQo+PiBTbyBob3cgZG8geW91IHdhbnQgdG8gbW92ZSB0
aGlzIHNlcmllcyBmb3J3YXJkPyBJIGNhbiB0ZXN0IGl0IG9uIHRoZQ0KPj4gODhFNjA5NyAoYW5k
IGhhdmUgcmVzdHJpY3RlZCBpdCB0byBqdXN0IHRoYXQgY2hpcCBmb3Igbm93KSwgSSdtIHByZXR0
eQ0KPj4gc3VyZSBpdCdsbCB3b3JrIG9uIHRoZSA4OEU2MTg1LiBJIGRvdWJ0IGl0J2xsIHdvcmsg
b24gdGhlIDg4RTYxMjIgYnV0DQo+PiBtYXliZSBpdCB3b3VsZCB3aXRoIGEgZGlmZmVyZW50IHNl
cmRlc19wb3dlciBmdW5jdGlvbiAob3IgZXZlbiB0aGUNCj4+IG12ODhlNjM1Ml9zZXJkZXNfcG93
ZXIoKSBhcyB5b3Ugc3VnZ2VzdGVkKS4NCj4gTWFrZSB5b3VyIGJlc3QgZ3Vlc3MgZm9yIHdoYXQg
eW91IGNhbm5vdCB0ZXN0Lg0KV2lsbCBkby4gSSdsbCBleHBhbmQgb3V0IGF0IGxlYXN0IHRvIGNv
dmVyIHRoZSA4OEU2MTg1IGluIHYyLiBJIGNhbiANCnByb2JhYmx5IGd1ZXNzIGF0IHRoZSA4OEU2
MTIyIGFzaWRlIGZyb20gdGhlIGFiaWxpdHkgdG8gcG93ZXIgdXAvZG93biANCnRoZSByZXN0IGxv
b2tzIHRoZSBzYW1lIGZyb20gZ2xhbmNpbmcgdGhlIGRhdGFzaGVldHMu
