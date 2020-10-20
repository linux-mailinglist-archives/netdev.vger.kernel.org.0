Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EFF294431
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405157AbgJTVEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:04:15 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:34522 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404960AbgJTVEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:04:14 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 36D41806B7;
        Wed, 21 Oct 2020 10:04:09 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603227849;
        bh=AfPOLFFQqMFX/VyF/b8ffTdtcTYZQ4MHZFbnZxfrwNY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=X0FZmFowxxa67wWevcioew2JrOqeF6gKFF5bKQR8KT3Xu+fvK49hWjY2TbW3oOk2M
         boUzYgNzPSLFcelveSz5R05VTYLxNnni3tqI8XRz5Lr5URh5w/M+lXURGdLBfV9/vd
         GmSBpsf9Zxzeq+Yc7w1uK9KgUUoEI/p8oZrmmAFii00jN0w8yE+hedrJ96iy36Pnas
         7rbhcSyvifo3nl+aVufnHUrxITpJHafOLLRlmFdHIUEOYz3qexPLRqqo3am+qDSeKe
         kj1yzezS+sG4eXDN3mXTAFHbvD9TKBBEISkuCxy1fkFAUq9FUIG1oVjYEosIv7Z1Pk
         W7E3NhXmNrZuQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8f50ca0001>; Wed, 21 Oct 2020 10:04:10 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct 2020 10:04:08 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Wed, 21 Oct 2020 10:04:08 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>, Marek Behun <marek.behun@nic.cz>
CC:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Thread-Topic: [PATCH v3 1/3] net: dsa: mv88e6xxx: Don't force link when using
 in-band-status
Thread-Index: AQHWppOIJNkIrONiWkiVl/EioSht3qmfbOUAgAA7vACAAARygIAAAsCAgAAKA4CAAAIRgIAAZhyA
Date:   Tue, 20 Oct 2020 21:04:07 +0000
Message-ID: <5a59f96e-070b-25d8-7921-64f7dc4516c6@alliedtelesis.co.nz>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
 <20201020101552.GB1551@shell.armlinux.org.uk>
 <20201020154940.60357b6c@nic.cz> <20201020140535.GE139700@lunn.ch>
 <20201020141525.GD1551@shell.armlinux.org.uk>
 <20201020165115.3ecfd601@nic.cz> <20201020145839.GG139700@lunn.ch>
In-Reply-To: <20201020145839.GG139700@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6923F374FCB5C4F97650BDE14799CDB@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMS8xMC8yMCAzOjU4IGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+PiBJdCdzIHN0aWxs
IHRoZXJlLiBUaGUgc3BlZWQvZHVwbGV4IGV0YyBhcmUgcmVhZCBmcm9tIHRoZSBzZXJkZXMgUEhZ
DQo+Pj4gdmlhIG12ODhlNjM5MF9zZXJkZXNfcGNzX2dldF9zdGF0ZSgpLiBXaGVuIHRoZSBsaW5r
IGNvbWVzIHVwLCB3ZQ0KPj4+IHBhc3MgdGhlIG5lZ290aWF0ZWQgbGluayBwYXJhbWV0ZXJzIHJl
YWQgZnJvbSB0aGVyZSB0byB0aGUgbGlua191cCgpDQo+Pj4gZnVuY3Rpb25zLiBGb3IgcG9ydHMg
d2hlcmUgbXY4OGU2eHh4X3BvcnRfcHB1X3VwZGF0ZXMoKSByZXR1cm5zIGZhbHNlDQo+Pj4gKG5v
IGV4dGVybmFsIFBIWSkgd2UgdXBkYXRlIHRoZSBwb3J0J3Mgc3BlZWQgYW5kIGR1cGxleCBzZXR0
aW5nIGFuZA0KPj4+IChjdXJyZW50bHksIGJlZm9yZSB0aGlzIHBhdGNoKSBmb3JjZSB0aGUgbGlu
ayB1cC4NCj4+Pg0KPj4+IFRoYXQgd2FzIHRoZSBiZWhhdmlvdXIgYmVmb3JlIEkgY29udmVydGVk
IHRoZSBjb2RlLCB0aGUgb25lIHRoYXQgeW91DQo+Pj4gcmVmZXJyZWQgdG8uIEkgaGFkIGFzc3Vt
ZWQgdGhlIGNvZGUgd2FzIGNvcnJlY3QsIGFuZCBfbm9uZV8gb2YgdGhlDQo+Pj4gc3BlZWQsIGR1
cGxleCwgbm9yIGxpbmsgc3RhdGUgd2FzIHByb3BhZ2F0ZWQgZnJvbSB0aGUgc2VyZGVzIFBDUyB0
bw0KPj4+IHRoZSBwb3J0IG9uIHRoZSA4OEU2MzkwIC0gaGVuY2Ugd2h5IHRoZSBjb2RlIHlvdSBy
ZWZlciB0byBleGlzdGVkLg0KPj4+DQo+IENocmlzDQo+DQo+IERvIHlvdSBnZXQgYW4gaW50ZXJy
dXB0IHdoZW4gdGhlIGxpbmsgZ29lcyB1cD8gU2luY2UgdGhlcmUgYXJlIG5vDQo+IFNFUkRFUyBy
ZWdpc3RlcnMsIHRoZXJlIGlzIG5vIHNwZWNpZmljIFNFUkRFUyBpbnRlcnJ1cHQuIEJ1dCBtYXli
ZSB0aGUNCj4gUEhZIGludGVycnVwdCBpbiBnbG9iYWwgMiBmaXJlcz8NClNvIGZhciBJJ3ZlIG5v
dCBuZWVkZWQgdG8gdXNlIGludGVycnVwdHMgZnJvbSB0aGUgNjA5Ny4gSXQncyBjb25uZWN0ZWQg
DQpvbiBteSBoYXJkd2FyZSBidXQgbmV2ZXIgYmVlbiB0ZXN0ZWQuIFRoZXJlIGFyZSBhIGNvdXBs
ZSBvZiBTRVJERVMgDQpMaW5rSW50IGJpdHMgaW4gdGhlIEdsb2JhbDIgaW50ZXJydXB0IHNvdXJj
ZS9tYXNrIHJlZ2lzdGVyIHdoaWNoIGxvb2sgYXMgDQp0aG91Z2ggdGhleSBzaG91bGQgZmlyZS4N
Cj4gSWYgeW91IGNhbiB1c2UgdGhhdCwgeW91IGNhbiB0aGVuIGJlDQo+IG1vcmUgaW4gbGluZSB3
aXRoIHRoZSBvdGhlciBpbXBsZW1lbnRhdGlvbnMgYW5kIG5vdCBuZWVkIHRoaXMgY2hhbmdlLg0K
TXkgcGFydGljdWxhciBwcm9ibGVtIHdhcyBhY3R1YWxseSBvbiB0aGUgb3RoZXIgZW5kIG9mIHRo
ZSBsaW5rICh3aGljaCANCmlzIGEgOThkeDE2MCB0aGF0IGRvZXNuJ3QgY3VycmVudGx5IGhhdmUg
YSBkc2EgZHJpdmVyKS4gV2hlbiB0aGUgbGluayANCndhcyBmb3JjZWQgb24gdGhlIDYwOTcgZW5k
IGl0IHdvdWxkIG9ubHkgbGluayB1cCBpZiB0aGUgNjA5NyBjYW1lIHVwIA0KYWZ0ZXIgdGhlIGR4
MTYwLiBBcmUgeW91IHNheWluZyB0aGVyZSBpcyBhIHdheSBvZiBhdm9pZGluZyB0aGUgY2FsbCB0
byANCm12ODhlNnh4eF9tYWNfbGlua191cCgpIGlmIEkgaGF2ZSBpbnRlcnJ1cHRzIGZvciB0aGUg
c2VyZGVzIHBvcnRzPw==
