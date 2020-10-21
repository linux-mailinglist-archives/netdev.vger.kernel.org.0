Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB82F294673
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 04:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411190AbgJUCUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 22:20:23 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:35495 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411184AbgJUCUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 22:20:23 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 170D6806B7;
        Wed, 21 Oct 2020 15:20:20 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1603246820;
        bh=xsH+J7FFMEgSg7lIpr79VNuQytV/6H8CyvzrpDWtk7U=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=bKIoUCAts/vIWjbDsaeczKP9HONaQN47K7jqA5GEdvkYDQjZLpJwIwYZU050+ZqNZ
         67LgqNrqzvy2CCbfI+3HnZVApUElYYPrVOwVcy5wjY7vatIQteaWl0WO0hlt/MK5yX
         gNukbvox0WXNtkVnObIH3RrMStKXLlusfUO4IYEn5Z1WReFCgcjCwVnfsisDCddgMD
         YIIOvOyAs0flTcdKsK1QlXPaXOsKgJWiSuNOH4uMO7uxaHQOap+NtLlK5UZbmWeRPr
         jGK6rHU+NrfWA3ddSp2jISKzpTMrbub4ScKJhq3nP1LLkr1ecKr+fv2+aMCmdqoknT
         aAP6MpFL2m4Ug==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f8f9ae40001>; Wed, 21 Oct 2020 15:20:20 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 21 Oct 2020 15:20:19 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Wed, 21 Oct 2020 15:20:19 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Marek Behun <marek.behun@nic.cz>, Andrew Lunn <andrew@lunn.ch>,
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
Thread-Index: AQHWppOIJNkIrONiWkiVl/EioSht3qmfbOUAgAA7vACAAARygIAAAsCAgAAKA4CAAGjaAIAAA0UAgABUZ4A=
Date:   Wed, 21 Oct 2020 02:20:19 +0000
Message-ID: <93761179-236f-c923-4b1f-1f85e531f98f@alliedtelesis.co.nz>
References: <20201020034558.19438-1-chris.packham@alliedtelesis.co.nz>
 <20201020034558.19438-2-chris.packham@alliedtelesis.co.nz>
 <20201020101552.GB1551@shell.armlinux.org.uk>
 <20201020154940.60357b6c@nic.cz> <20201020140535.GE139700@lunn.ch>
 <20201020141525.GD1551@shell.armlinux.org.uk>
 <20201020165115.3ecfd601@nic.cz>
 <95c8cbb8-2364-b47b-851d-61a2c2ccf508@alliedtelesis.co.nz>
 <20201020211814.GG1551@shell.armlinux.org.uk>
In-Reply-To: <20201020211814.GG1551@shell.armlinux.org.uk>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACBBBBD3EB007D4996B4F2B49063BD94@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMS8xMC8yMCAxMDoxOCBhbSwgUnVzc2VsbCBLaW5nIC0gQVJNIExpbnV4IGFkbWluIHdy
b3RlOg0KPiBPbiBUdWUsIE9jdCAyMCwgMjAyMCBhdCAwOTowNjozMlBNICswMDAwLCBDaHJpcyBQ
YWNraGFtIHdyb3RlOg0KPj4gT24gMjEvMTAvMjAgMzo1MSBhbSwgTWFyZWsgQmVodW4gd3JvdGU6
DQo+Pj4gT24gVHVlLCAyMCBPY3QgMjAyMCAxNToxNToyNSArMDEwMA0KPj4+IFJ1c3NlbGwgS2lu
ZyAtIEFSTSBMaW51eCBhZG1pbiA8bGludXhAYXJtbGludXgub3JnLnVrPiB3cm90ZToNCj4+Pg0K
Pj4+PiBPbiBUdWUsIE9jdCAyMCwgMjAyMCBhdCAwNDowNTozNVBNICswMjAwLCBBbmRyZXcgTHVu
biB3cm90ZToNCj4+Pj4+IE9uIFR1ZSwgT2N0IDIwLCAyMDIwIGF0IDAzOjQ5OjQwUE0gKzAyMDAs
IE1hcmVrIEJlaHVuIHdyb3RlOg0KPj4+Pj4+IE9uIFR1ZSwgMjAgT2N0IDIwMjAgMTE6MTU6NTIg
KzAxMDANCj4+Pj4+PiBSdXNzZWxsIEtpbmcgLSBBUk0gTGludXggYWRtaW4gPGxpbnV4QGFybWxp
bnV4Lm9yZy51az4gd3JvdGU6DQo+Pj4+Pj4gICAgIA0KPj4+Pj4+PiBPbiBUdWUsIE9jdCAyMCwg
MjAyMCBhdCAwNDo0NTo1NlBNICsxMzAwLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0KPj4+Pj4+Pj4g
V2hlbiBhIHBvcnQgaXMgY29uZmlndXJlZCB3aXRoICdtYW5hZ2VkID0gImluLWJhbmQtc3RhdHVz
IicgZG9uJ3QgZm9yY2UNCj4+Pj4+Pj4+IHRoZSBsaW5rIHVwLCB0aGUgc3dpdGNoIE1BQyB3aWxs
IGRldGVjdCB0aGUgbGluayBzdGF0dXMgY29ycmVjdGx5Lg0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IFNp
Z25lZC1vZmYtYnk6IENocmlzIFBhY2toYW0gPGNocmlzLnBhY2toYW1AYWxsaWVkdGVsZXNpcy5j
by5uej4NCj4+Pj4+Pj4+IFJldmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+
DQo+Pj4+Pj4+IEkgdGhvdWdodCB3ZSBoYWQgaXNzdWVzIHdpdGggdGhlIDg4RTYzOTAgd2hlcmUg
dGhlIFBDUyBkb2VzIG5vdA0KPj4+Pj4+PiB1cGRhdGUgdGhlIE1BQyB3aXRoIGl0cyByZXN1bHRz
LiBJc24ndCB0aGlzIGdvaW5nIHRvIGJyZWFrIHRoZQ0KPj4+Pj4+PiA2MzkwPyBBbmRyZXc/DQo+
Pj4+Pj4+ICAgICANCj4+Pj4+PiBSdXNzZWxsLCBJIHRlc3RlZCB0aGlzIHBhdGNoIG9uIFR1cnJp
cyBNT1ggd2l0aCA2MzkwIG9uIHBvcnQgOSAoY3B1DQo+Pj4+Pj4gcG9ydCkgd2hpY2ggaXMgY29u
ZmlndXJlZCBpbiBkZXZpY2V0cmVlIGFzIDI1MDBiYXNlLXgsIGluLWJhbmQtc3RhdHVzLA0KPj4+
Pj4+IGFuZCBpdCB3b3Jrcy4uLg0KPj4+Pj4+DQo+Pj4+Pj4gT3Igd2lsbCB0aGlzIGJyZWFrIG9u
IHVzZXIgcG9ydHM/DQo+Pj4+PiBVc2VyIHBvcnRzIGlzIHdoYXQgbmVlZHMgdGVzdGluZywgaWRl
YWxseSB3aXRoIGFuIFNGUC4NCj4+Pj4+DQo+Pj4+PiBUaGVyZSB1c2VkIHRvIGJlIGV4cGxpY2l0
IGNvZGUgd2hpY2ggd2hlbiB0aGUgU0VSREVTIHJlcG9ydGVkIGxpbmsgdXAsDQo+Pj4+PiB0aGUg
TUFDIHdhcyBjb25maWd1cmVkIGluIHNvZnR3YXJlIHdpdGggdGhlIGNvcnJlY3Qgc3BlZWQgZXRj
LiBXaXRoDQo+Pj4+PiB0aGUgbW92ZSB0byBwY3MgQVBJcywgaXQgaXMgbGVzcyBvYnZpb3VzIGhv
dyB0aGlzIHdvcmtzIG5vdywgZG9lcyBpdA0KPj4+Pj4gc3RpbGwgc29mdHdhcmUgY29uZmlndXJl
IHRoZSBNQUMsIG9yIGRvIHdlIGhhdmUgdGhlIHJpZ2h0IG1hZ2ljIHNvDQo+Pj4+PiB0aGF0IHRo
ZSBoYXJkd2FyZSB1cGRhdGVzIGl0c2VsZi4NCj4+Pj4gSXQncyBzdGlsbCB0aGVyZS4gVGhlIHNw
ZWVkL2R1cGxleCBldGMgYXJlIHJlYWQgZnJvbSB0aGUgc2VyZGVzIFBIWQ0KPj4+PiB2aWEgbXY4
OGU2MzkwX3NlcmRlc19wY3NfZ2V0X3N0YXRlKCkuIFdoZW4gdGhlIGxpbmsgY29tZXMgdXAsIHdl
DQo+Pj4+IHBhc3MgdGhlIG5lZ290aWF0ZWQgbGluayBwYXJhbWV0ZXJzIHJlYWQgZnJvbSB0aGVy
ZSB0byB0aGUgbGlua191cCgpDQo+Pj4+IGZ1bmN0aW9ucy4gRm9yIHBvcnRzIHdoZXJlIG12ODhl
Nnh4eF9wb3J0X3BwdV91cGRhdGVzKCkgcmV0dXJucyBmYWxzZQ0KPj4+PiAobm8gZXh0ZXJuYWwg
UEhZKSB3ZSB1cGRhdGUgdGhlIHBvcnQncyBzcGVlZCBhbmQgZHVwbGV4IHNldHRpbmcgYW5kDQo+
Pj4+IChjdXJyZW50bHksIGJlZm9yZSB0aGlzIHBhdGNoKSBmb3JjZSB0aGUgbGluayB1cC4NCj4+
Pj4NCj4+Pj4gVGhhdCB3YXMgdGhlIGJlaGF2aW91ciBiZWZvcmUgSSBjb252ZXJ0ZWQgdGhlIGNv
ZGUsIHRoZSBvbmUgdGhhdCB5b3UNCj4+Pj4gcmVmZXJyZWQgdG8uIEkgaGFkIGFzc3VtZWQgdGhl
IGNvZGUgd2FzIGNvcnJlY3QsIGFuZCBfbm9uZV8gb2YgdGhlDQo+Pj4+IHNwZWVkLCBkdXBsZXgs
IG5vciBsaW5rIHN0YXRlIHdhcyBwcm9wYWdhdGVkIGZyb20gdGhlIHNlcmRlcyBQQ1MgdG8NCj4+
Pj4gdGhlIHBvcnQgb24gdGhlIDg4RTYzOTAgLSBoZW5jZSB3aHkgdGhlIGNvZGUgeW91IHJlZmVy
IHRvIGV4aXN0ZWQuDQo+Pj4+DQo+Pj4gUnVzc2VsbCwgeW91IGFyZSByaWdodC4NCj4+PiBTRlAg
b24gODhFNjM5MCBkb2VzIG5vdCB3b3JrIHdpdGggdGhpcyBwYXRjaCBhcHBsaWVkLg0KPj4+IFNv
IHRoaXMgcGF0Y2ggYnJlYWtzIDg4RTYzOTAuDQo+PiBUaGFua3MgZm9yIHRlc3RpbmcuIEl0IHNv
dW5kcyBsaWtlIG1heWJlIGlmIEkgbWFrZQ0KPj4gbXY4OGU2eHh4X3BvcnRfcHB1X3VwZGF0ZXMo
KSByZXR1cm4gdHJ1ZSBmb3IgdGhlIDYwOTcgaW4gc2VyZGVzIG1vZGUgSQ0KPj4gY2FuIGF2b2lk
IHRoZSBmb3JjZWQgbGluayB1cCB3aXRob3V0IGFmZmVjdGluZyB0aGUgNjM5MC4NCj4gQW5vdGhl
ciBvcHRpb24gd291bGQgYmUgdG8gbWFrZSBtdjg4ZTZ4eHhfbWFjX2xpbmtfdXAoKSBjYWxsIGEN
Cj4gc3dpdGNoIHNwZWNpZmljIGltcGxlbWVudGF0aW9uIGZ1bmN0aW9uLCB3aGljaCBpcyBwcm9i
YWJseSB3YXkNCj4gY2xlYW5lciB0aGFuIGludHJvZHVjaW5nIGNvbmRpdGlvbmFscyBvbiB0aGUg
c3dpdGNoIHR5cGUgaW4NCj4gZnVuY3Rpb25zLCBhbmQgcmVmbGVjdHMgdGhlIGV4aXN0aW5nIGNv
ZGUgc3RydWN0dXJlLg0KDQpJJ3ZlIHNwZW50IG1vc3Qgb2YgdGhlIGRheSBwbHVtYmluZyBpbiB0
aGUgc2VyZGVzIGludGVycnVwdHMuIEFuZCB3aGlsZSANCkkgaGF2ZSB0aGF0IHdvcmtpbmcgSSB0
aGluayBldmVuIHdpdGggaW50ZXJydXB0cyBJIHN0aWxsIGhhdmUgdGhlIA0KcHJvYmxlbSB0aGF0
IG9uIHRoZSA4OEU2MDk3IGFuZCBzaW1pbGFyIHRoZXJlIGlzIG5vIHNlcGFyYXRpb24gb2YgUENT
IA0KZnJvbSB0aGUgTUFDIHNvIEknZCBoYXZlIHRvIGRvIHNvbWV0aGluZyBsaWtlIHRoaXMgYW55
d2F5Lg0KDQpTbyBJJ2xsIHByb2JhYmx5IGxvb2sgYXQgbWFraW5nIHRoZSBib2R5IG9mIG12ODhl
Nnh4eF9tYWNfbGlua191cCBhIA0Kc3dpdGNoIHNwZWNpZmljIGZ1bmN0aW9uLg0K
