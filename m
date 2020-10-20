Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C745294433
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438647AbgJTVGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438643AbgJTVGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 17:06:37 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E14C0613CE
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 14:06:37 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 169CF806B5;
        Wed, 21 Oct 2020 10:06:33 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603227993;
        bh=xkojWlxmq2LotOa5LY63P3nD8//LldgTlkfieoQ9Ubs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=ZGNPeTB8xMqId9nE9qf1LYbqQ/DFI8qMALi3b5eEzrvo2uZDTUEUSILiZw7gfbgPZ
         Q3W/n4aucC/av1Fr3N+NuMykRFme1O/cIOsw8PQfe5v/rI9F+NXH11k8LEiKMErNfR
         GhznMypuL9zBAbuhNMgB6TuJmPW5zNxv/OUEVWJtLL1RGTrRxO2dwYQlZ4uxhrIGKp
         vmnTPEMow9jS+dXrShnaKnBV6ZkYlA3wZ5qg6sMyNPEJ4RJLFLo9xWTItj7eXZP9+q
         WWTxVwYbM1Sg4PiC0VJD5RpHKvOhR/89tTPixsId7oeIWvq0855m9ieA7c/WoLJJbC
         HisS0xPp1gBnQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8f51590001>; Wed, 21 Oct 2020 10:06:33 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Oct 2020 10:06:32 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Wed, 21 Oct 2020 10:06:32 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
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
Thread-Index: AQHWppOIJNkIrONiWkiVl/EioSht3qmfbOUAgAA7vACAAARygIAAAsCAgAAKA4CAAGjaAA==
Date:   Tue, 20 Oct 2020 21:06:32 +0000
Message-ID: <95c8cbb8-2364-b47b-851d-61a2c2ccf508@alliedtelesis.co.nz>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
 <20201020101552.GB1551@shell.armlinux.org.uk>
 <20201020154940.60357b6c@nic.cz> <20201020140535.GE139700@lunn.ch>
 <20201020141525.GD1551@shell.armlinux.org.uk>
 <20201020165115.3ecfd601@nic.cz>
In-Reply-To: <20201020165115.3ecfd601@nic.cz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <476749FD32B3B448BFB8509862BFBDEA@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMS8xMC8yMCAzOjUxIGFtLCBNYXJlayBCZWh1biB3cm90ZToNCj4gT24gVHVlLCAyMCBP
Y3QgMjAyMCAxNToxNToyNSArMDEwMA0KPiBSdXNzZWxsIEtpbmcgLSBBUk0gTGludXggYWRtaW4g
PGxpbnV4QGFybWxpbnV4Lm9yZy51az4gd3JvdGU6DQo+DQo+PiBPbiBUdWUsIE9jdCAyMCwgMjAy
MCBhdCAwNDowNTozNVBNICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+PiBPbiBUdWUsIE9j
dCAyMCwgMjAyMCBhdCAwMzo0OTo0MFBNICswMjAwLCBNYXJlayBCZWh1biB3cm90ZToNCj4+Pj4g
T24gVHVlLCAyMCBPY3QgMjAyMCAxMToxNTo1MiArMDEwMA0KPj4+PiBSdXNzZWxsIEtpbmcgLSBB
Uk0gTGludXggYWRtaW4gPGxpbnV4QGFybWxpbnV4Lm9yZy51az4gd3JvdGU6DQo+Pj4+ICAgIA0K
Pj4+Pj4gT24gVHVlLCBPY3QgMjAsIDIwMjAgYXQgMDQ6NDU6NTZQTSArMTMwMCwgQ2hyaXMgUGFj
a2hhbSB3cm90ZToNCj4+Pj4+PiBXaGVuIGEgcG9ydCBpcyBjb25maWd1cmVkIHdpdGggJ21hbmFn
ZWQgPSAiaW4tYmFuZC1zdGF0dXMiJyBkb24ndCBmb3JjZQ0KPj4+Pj4+IHRoZSBsaW5rIHVwLCB0
aGUgc3dpdGNoIE1BQyB3aWxsIGRldGVjdCB0aGUgbGluayBzdGF0dXMgY29ycmVjdGx5Lg0KPj4+
Pj4+DQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogQ2hyaXMgUGFja2hhbSA8Y2hyaXMucGFja2hhbUBh
bGxpZWR0ZWxlc2lzLmNvLm56Pg0KPj4+Pj4+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5k
cmV3QGx1bm4uY2g+DQo+Pj4+PiBJIHRob3VnaHQgd2UgaGFkIGlzc3VlcyB3aXRoIHRoZSA4OEU2
MzkwIHdoZXJlIHRoZSBQQ1MgZG9lcyBub3QNCj4+Pj4+IHVwZGF0ZSB0aGUgTUFDIHdpdGggaXRz
IHJlc3VsdHMuIElzbid0IHRoaXMgZ29pbmcgdG8gYnJlYWsgdGhlDQo+Pj4+PiA2MzkwPyBBbmRy
ZXc/DQo+Pj4+PiAgICANCj4+Pj4gUnVzc2VsbCwgSSB0ZXN0ZWQgdGhpcyBwYXRjaCBvbiBUdXJy
aXMgTU9YIHdpdGggNjM5MCBvbiBwb3J0IDkgKGNwdQ0KPj4+PiBwb3J0KSB3aGljaCBpcyBjb25m
aWd1cmVkIGluIGRldmljZXRyZWUgYXMgMjUwMGJhc2UteCwgaW4tYmFuZC1zdGF0dXMsDQo+Pj4+
IGFuZCBpdCB3b3Jrcy4uLg0KPj4+Pg0KPj4+PiBPciB3aWxsIHRoaXMgYnJlYWsgb24gdXNlciBw
b3J0cz8NCj4+PiBVc2VyIHBvcnRzIGlzIHdoYXQgbmVlZHMgdGVzdGluZywgaWRlYWxseSB3aXRo
IGFuIFNGUC4NCj4+Pg0KPj4+IFRoZXJlIHVzZWQgdG8gYmUgZXhwbGljaXQgY29kZSB3aGljaCB3
aGVuIHRoZSBTRVJERVMgcmVwb3J0ZWQgbGluayB1cCwNCj4+PiB0aGUgTUFDIHdhcyBjb25maWd1
cmVkIGluIHNvZnR3YXJlIHdpdGggdGhlIGNvcnJlY3Qgc3BlZWQgZXRjLiBXaXRoDQo+Pj4gdGhl
IG1vdmUgdG8gcGNzIEFQSXMsIGl0IGlzIGxlc3Mgb2J2aW91cyBob3cgdGhpcyB3b3JrcyBub3cs
IGRvZXMgaXQNCj4+PiBzdGlsbCBzb2Z0d2FyZSBjb25maWd1cmUgdGhlIE1BQywgb3IgZG8gd2Ug
aGF2ZSB0aGUgcmlnaHQgbWFnaWMgc28NCj4+PiB0aGF0IHRoZSBoYXJkd2FyZSB1cGRhdGVzIGl0
c2VsZi4NCj4+IEl0J3Mgc3RpbGwgdGhlcmUuIFRoZSBzcGVlZC9kdXBsZXggZXRjIGFyZSByZWFk
IGZyb20gdGhlIHNlcmRlcyBQSFkNCj4+IHZpYSBtdjg4ZTYzOTBfc2VyZGVzX3Bjc19nZXRfc3Rh
dGUoKS4gV2hlbiB0aGUgbGluayBjb21lcyB1cCwgd2UNCj4+IHBhc3MgdGhlIG5lZ290aWF0ZWQg
bGluayBwYXJhbWV0ZXJzIHJlYWQgZnJvbSB0aGVyZSB0byB0aGUgbGlua191cCgpDQo+PiBmdW5j
dGlvbnMuIEZvciBwb3J0cyB3aGVyZSBtdjg4ZTZ4eHhfcG9ydF9wcHVfdXBkYXRlcygpIHJldHVy
bnMgZmFsc2UNCj4+IChubyBleHRlcm5hbCBQSFkpIHdlIHVwZGF0ZSB0aGUgcG9ydCdzIHNwZWVk
IGFuZCBkdXBsZXggc2V0dGluZyBhbmQNCj4+IChjdXJyZW50bHksIGJlZm9yZSB0aGlzIHBhdGNo
KSBmb3JjZSB0aGUgbGluayB1cC4NCj4+DQo+PiBUaGF0IHdhcyB0aGUgYmVoYXZpb3VyIGJlZm9y
ZSBJIGNvbnZlcnRlZCB0aGUgY29kZSwgdGhlIG9uZSB0aGF0IHlvdQ0KPj4gcmVmZXJyZWQgdG8u
IEkgaGFkIGFzc3VtZWQgdGhlIGNvZGUgd2FzIGNvcnJlY3QsIGFuZCBfbm9uZV8gb2YgdGhlDQo+
PiBzcGVlZCwgZHVwbGV4LCBub3IgbGluayBzdGF0ZSB3YXMgcHJvcGFnYXRlZCBmcm9tIHRoZSBz
ZXJkZXMgUENTIHRvDQo+PiB0aGUgcG9ydCBvbiB0aGUgODhFNjM5MCAtIGhlbmNlIHdoeSB0aGUg
Y29kZSB5b3UgcmVmZXIgdG8gZXhpc3RlZC4NCj4+DQo+IFJ1c3NlbGwsIHlvdSBhcmUgcmlnaHQu
DQo+IFNGUCBvbiA4OEU2MzkwIGRvZXMgbm90IHdvcmsgd2l0aCB0aGlzIHBhdGNoIGFwcGxpZWQu
DQo+IFNvIHRoaXMgcGF0Y2ggYnJlYWtzIDg4RTYzOTAuDQpUaGFua3MgZm9yIHRlc3RpbmcuIEl0
IHNvdW5kcyBsaWtlIG1heWJlIGlmIEkgbWFrZSANCm12ODhlNnh4eF9wb3J0X3BwdV91cGRhdGVz
KCkgcmV0dXJuIHRydWUgZm9yIHRoZSA2MDk3IGluIHNlcmRlcyBtb2RlIEkgDQpjYW4gYXZvaWQg
dGhlIGZvcmNlZCBsaW5rIHVwIHdpdGhvdXQgYWZmZWN0aW5nIHRoZSA2MzkwLg==
