Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88961292139
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 04:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbgJSCpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 22:45:31 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:59299 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730938AbgJSCpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 22:45:30 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id D47DE891B0;
        Mon, 19 Oct 2020 15:45:26 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603075526;
        bh=ePBdie+Xt7jaEuyYljlZ06vUlp+mmbTPp4lm0VF7Q4I=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=IUGK9pJQDIxoxUkekfUrJ9Vl8FZFxCph1S6mCOU4USl/g5g40CmVmsyDM1OIIFxG0
         O8jhZhjHd9OV0RdFEpGg8qb5IabktYpyvbb3vGxJeJkLRE3Lte8OK7bszSPjMNsNhT
         nB4u2s1ikQDTge80jZt6yG1df8Uo+PgDC5St+CW8X00A4TFByahOLdjFBX1F5STVye
         dZHcwwrOR8gqFVHDvSiQvdKscNiSfMK5N2u87ndhLCUnBt1NCACa004yENVJgFWNbv
         6v/rRG2nBhiKvvJDIm3i6RUc/vuEqYkxww97FQ1WxVYifkI/aY7KPRmoiYKsKBJ7Qe
         wFjMFIh678T+Q==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8cfdc60002>; Mon, 19 Oct 2020 15:45:26 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct 2020 15:45:26 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Mon, 19 Oct 2020 15:45:26 +1300
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
Thread-Index: AQHWoQc4/uQqPxKVFEaOBfkb784lwamcuA8AgABBNACAAARwgIAADggAgAAOooCAAAadgIAARtSA
Date:   Mon, 19 Oct 2020 02:45:25 +0000
Message-ID: <7ccfd1d2-cf03-9eca-a3d6-c68267d08f76@alliedtelesis.co.nz>
References: <20201013021858.20530-1-chris.packham@alliedtelesis.co.nz>
 <20201013021858.20530-3-chris.packham@alliedtelesis.co.nz>
 <20201018161624.GD456889@lunn.ch>
 <b3d1d071-3bce-84f4-e9d5-f32a41c432bd@alliedtelesis.co.nz>
 <20201018202539.GJ456889@lunn.ch>
 <2e1f1ca4-b5d5-ebc8-99bf-9ad74f461d26@alliedtelesis.co.nz>
 <20201018220815.GK456889@lunn.ch>
 <862bec00-92d8-2f4a-03e5-93546e6563f6@alliedtelesis.co.nz>
In-Reply-To: <862bec00-92d8-2f4a-03e5-93546e6563f6@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F4F4A5E622DC2344B3152F3CB7CF98DB@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAxOS8xMC8yMCAxMTozMSBhbSwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4NCj4gT24gMTkv
MTAvMjAgMTE6MDggYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4gT24gU3VuLCBPY3QgMTgsIDIw
MjAgYXQgMDk6MTU6NTJQTSArMDAwMCwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+PiBPbiAxOS8x
MC8yMCA5OjI1IGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+Pj4+IEkgYXNzdW1lIHlvdSdyZSB0
YWxraW5nIGFib3V0IHRoZSBQSFkgQ29udHJvbCBSZWdpc3RlciAwIGJpdCAxMS4gDQo+Pj4+PiBJ
ZiBzbw0KPj4+Pj4gdGhhdCdzIGZvciB0aGUgaW50ZXJuYWwgUEhZcyBvbiBwb3J0cyAwLTcuIFBv
cnRzIDgsIDkgYW5kIDEwIGRvbid0IA0KPj4+Pj4gaGF2ZQ0KPj4+Pj4gUEhZcy4NCj4+Pj4gSGkg
Q2hyaXMNCj4+Pj4NCj4+Pj4gSSBoYXZlIGEgZGF0YXNoZWV0IGZvciB0aGUgNjEyMi82MTIxLCBm
cm9tIHNvbWUgY29ybmVyIG9mIHRoZSB3ZWIsDQo+Pj4+IFBhcnQgMyBvZiAzLCBHaWdhYml0IFBI
WXMgYW5kIFNFUkRFUy4NCj4+Pj4NCj4+Pj4gaHR0cDovL3d3dy5pbWFnZS5taWNyb3MuY29tLnBs
L19kYW5lX3RlY2huaWN6bmVfYXV0by91aTg4ZTYxMjJiMmxrajFpMC5wZGYgDQo+Pj4+DQo+Pj4+
DQo+Pj4+IFNlY3Rpb24gNSBvZiB0aGlzIGRvY3VtZW50IHRhbGtzDQo+Pj4+IGFib3V0IHRoZSBT
RVJERVMgcmVnaXN0ZXJzLiBSZWdpc3RlciAwIGlzIENvbnRyb2wsIHJlZ2lzdGVyIDEgaXMNCj4+
Pj4gU3RhdHVzIC0gRmliZXIsIHJlZ2lzdGVyIDIgYW5kIDMgYXJlIHRoZSB1c3VhbCBJRCwgNCBp
cyBhdXRvLW5ldA0KPj4+PiBhZHZlcnRpc2VtZW50IGV0Yy4NCj4+Pj4NCj4+Pj4gV2hlcmUgdGhl
c2UgcmVnaXN0ZXJzIGFwcGVhciBpbiB0aGUgYWRkcmVzcyBzcGFjZSBpcyBub3QgY2xlYXIgZnJv
bQ0KPj4+PiB0aGlzIGRvY3VtZW50LiBJdCBpcyBub3JtYWxseSBpbiBkb2N1bWVudCBwYXJ0IDIg
b2YgMywgd2hpY2ggbXkNCj4+Pj4gc2VhcmNoaW5nIG9mIHRoZSB3ZWIgZGlkIG5vdCBmaW5kLg0K
Pj4+Pg0KPj4+PiDCoMKgwqDCoMKgIEFuZHJldw0KPj4+IEkgaGF2ZSBnb3QgdGhlIDg4RTYxMjIg
ZGF0YXNoZWV0KHMpIGFuZCBjYW4gc2VlIHRoZSBTRVJERVMgcmVnaXN0ZXJzDQo+Pj4geW91J3Jl
IHRhbGtpbmcgYWJvdXQgKEkgdGhpbmsgdGhleSdyZSBpbiB0aGUgc2FtZSByZWdpc3RlciBzcGFj
ZSBhcyB0aGUNCj4+PiBidWlsdC1pbiBQSFlzKS4gSXQgbG9va3MgbGlrZSB0aGUgODhFNjA5NyBp
cyBkaWZmZXJlbnQgaW4gdGhhdCB0aGVyZSANCj4+PiBhcmUNCj4+PiBubyBTRVJERVMgcmVnaXN0
ZXJzIGV4cG9zZWQgKGF0IGxlYXN0IG5vdCBpbiBhIGRvY3VtZW50ZWQgd2F5KS4gTG9va2luZw0K
Pj4+IGF0IHRoZSA4OEU2MTg1IGl0J3MgdGhlIHNhbWUgYXMgdGhlIDg4RTYwOTcuDQo+PiBIaSBD
aHJpcw0KPj4NCj4+IEkgZmluZCBpdCBvZGQgdGhlcmUgYXJlIG5vIFNFUkRFUyByZWdpc3RlcnMu
wqAgQ2FuIHlvdSBwb2tlIGFyb3VuZCB0aGUNCj4+IHJlZ2lzdGVyIHNwYWNlIGFuZCBsb29rIGZv
ciBJRCByZWdpc3RlcnM/IFNlZSBpZiB0aGVyZSBhcmUgYW55IHdpdGgNCj4+IE1hcnZlbGxzIE9V
SSwgYnV0IGRpZmZlcmVudCB0byB0aGUgY2hpcCBJRCBmb3VuZCBpbiB0aGUgcG9ydA0KPj4gcmVn
aXN0ZXJzPw0KPiBGcm9tIG15IGV4cGVyaWVuY2Ugd2l0aCBNYXJ2ZWxsIEkgZG9uJ3QgdGhpbmsg
aXQncyB0aGF0IG9kZC4gDQo+IFBhcnRpY3VsYXJseSBmb3IgYSAxRyBTRVJERVMgdGhlcmUncyBy
ZWFsbHkgbm90IG11Y2ggdGhhdCBuZWVkcyANCj4gY29uZmlndXJpbmcgKGFsdGhvdWdoIHBvd2Vy
IHVwL2Rvd24gd291bGQgYmUgbmljZSkuIEknbGwgcG9rZSBhcm91bmQgDQo+IHRoYXQgcmVnaXN0
ZXIgc3BhY2UgdG8gc2VlIGlmIGFueXRoaW5nIGlzIHRoZXJlLg0KDQpJIHBva2VkIGFyb3VuZCB3
aGF0IEkgdGhvdWdodCB3b3VsZCBiZSB0aGUgcmVsZXZhbnQgcmVnaXN0ZXIgc3BhY2UgYW5kIA0K
Y291bGRuJ3QgZmluZCBhbnl0aGluZyByZXNwb25kaW5nIHRvIHRoZSByZWFkcy4NCg0KPj4+IFNv
IGhvdyBkbyB5b3Ugd2FudCB0byBtb3ZlIHRoaXMgc2VyaWVzIGZvcndhcmQ/IEkgY2FuIHRlc3Qg
aXQgb24gdGhlDQo+Pj4gODhFNjA5NyAoYW5kIGhhdmUgcmVzdHJpY3RlZCBpdCB0byBqdXN0IHRo
YXQgY2hpcCBmb3Igbm93KSwgSSdtIHByZXR0eQ0KPj4+IHN1cmUgaXQnbGwgd29yayBvbiB0aGUg
ODhFNjE4NS4gSSBkb3VidCBpdCdsbCB3b3JrIG9uIHRoZSA4OEU2MTIyIGJ1dA0KPj4+IG1heWJl
IGl0IHdvdWxkIHdpdGggYSBkaWZmZXJlbnQgc2VyZGVzX3Bvd2VyIGZ1bmN0aW9uIChvciBldmVu
IHRoZQ0KPj4+IG12ODhlNjM1Ml9zZXJkZXNfcG93ZXIoKSBhcyB5b3Ugc3VnZ2VzdGVkKS4NCj4+
IE1ha2UgeW91ciBiZXN0IGd1ZXNzIGZvciB3aGF0IHlvdSBjYW5ub3QgdGVzdC4NCj4gV2lsbCBk
by4gSSdsbCBleHBhbmQgb3V0IGF0IGxlYXN0IHRvIGNvdmVyIHRoZSA4OEU2MTg1IGluIHYyLiBJ
IGNhbiANCj4gcHJvYmFibHkgZ3Vlc3MgYXQgdGhlIDg4RTYxMjIgYXNpZGUgZnJvbSB0aGUgYWJp
bGl0eSB0byBwb3dlciB1cC9kb3duIA0KPiB0aGUgcmVzdCBsb29rcyB0aGUgc2FtZSBmcm9tIGds
YW5jaW5nIHRoZSBkYXRhc2hlZXRzLg==
