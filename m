Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C7122B86B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgGWVQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:16:27 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:45994 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGWVQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:16:27 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 4231E891B2;
        Fri, 24 Jul 2020 09:16:24 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595538984;
        bh=eguEpkhykd4TVznsCAaweomuNXn3vwlz0+mIEn2QBIs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=JrB9faxhK1GfGM5vYVJu68BQgecf90TPvxidwLeChIqFQZuRUHarRKakaH31uqytm
         8IA/vOcN1VIYf2eK2AADeniCBrG9X3PfUQKNbe48PDoYMwUgEFtzDhuICMxlcTppI6
         /pD2HBbne629o08shuPjGiEhKntyTYtNJC6WtGJUXNZEUT8kUs/d7AxnS1xbuZskxr
         lZIhL/sXZDBkaQMM6+Vtsl/US+V3CvwovtxqVYeBGdCdupS0eRmA34uPmOmVbglhMC
         D71aOA01UzFLTfARPhqtDdTfrqNfIJJ58WkM0LXwTg7SF4Y5ktVQDm+DuDgsFDsdWl
         cwF1YdxWl/hWw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f19fe260001>; Fri, 24 Jul 2020 09:16:22 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul 2020 09:16:23 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Fri, 24 Jul 2020 09:16:23 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] net: dsa: mv88e6xxx: Implement
 .port_change_mtu/.port_max_mtu
Thread-Topic: [PATCH 3/4] net: dsa: mv88e6xxx: Implement
 .port_change_mtu/.port_max_mtu
Thread-Index: AQHWYKW3b1TNxAifGUKdmWah9S8H2akUYKYAgAB6rYCAAANngIAAA9cA
Date:   Thu, 23 Jul 2020 21:16:22 +0000
Message-ID: <bbd66a44-900c-68cf-244d-4d8e505d05eb@alliedtelesis.co.nz>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
 <20200723035942.23988-4-chris.packham@alliedtelesis.co.nz>
 <20200723133122.GB1553578@lunn.ch>
 <e10da452-c04a-b519-6c30-c94e60101f92@alliedtelesis.co.nz>
 <20200723210237.GJ1553578@lunn.ch>
In-Reply-To: <20200723210237.GJ1553578@lunn.ch>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <075193D067491340833A828706413737@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyNC8wNy8yMCA5OjAyIGFtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gT24gVGh1LCBKdWwg
MjMsIDIwMjAgYXQgMDg6NTA6MjdQTSArMDAwMCwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4+IE9u
IDI0LzA3LzIwIDE6MzEgYW0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPj4+IE9uIFRodSwgSnVsIDIz
LCAyMDIwIGF0IDAzOjU5OjQxUE0gKzEyMDAsIENocmlzIFBhY2toYW0gd3JvdGU6DQo+Pj4+IEFk
ZCBpbXBsZW1lbnRhdGlvbnMgZm9yIHRoZSBtdjg4ZTZ4eHggc3dpdGNoZXMgdG8gY29ubmVjdCB3
aXRoIHRoZQ0KPj4+PiBnZW5lcmljIGRzYSBvcGVyYXRpb25zIGZvciBjb25maWd1cmluZyB0aGUg
cG9ydCBNVFUuDQo+Pj4gSGkgQ2hyaXMNCj4+Pg0KPj4+IFdoYXQgdHJlZSBpcyB0aGlzIGFnYWlu
c3Q/DQo+PiAkIGdpdCBjb25maWcgcmVtb3RlLm9yaWdpbi51cmwNCj4+IGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQNCj4+ICQg
Z2l0IGRlc2NyaWJlIGBnaXQgbWVyZ2UtYmFzZSBIRUFEIG9yaWdpbi9tYXN0ZXJgDQo+IEhpIENo
cmlzDQo+DQo+IE5ldHdvcmtpbmcgcGF0Y2hlcyBhcmUgZXhwZWN0ZWQgdG8gYmUgYWdhaW5zdCBu
ZXQtbmV4dC4gT3IgbmV0IGlmIHRoZXkNCj4gYXJlIGZpeGVzLiBQbGVhc2UgZG9uJ3Qgc3VibWl0
IHBhdGNoZXMgdG8gbmV0ZGV2IGFnYWluc3Qgb3RoZXIgdHJlZXMuDQoNCk9LLiBJJ2xsIHRyeSB0
byByZW1lbWJlciB0aGF0IGZvciBuZXh0IHRpbWUuIEZvciB0aGlzIHNlcmllcyBpbiANCnBhcnRp
Y3VsYXIgaXQncyBhIGxpdHRsZSBoYXJkIGZvciBtZSB0byB0ZXN0IG5ldC1uZXh0IGJlY2F1c2Ug
dGhlIA0KaGFyZHdhcmUgaW4gcXVlc3Rpb24gcmVsaWVzIG9uIGEgYnVuY2ggb2YgY29kZSB0aGF0
IGlzIG5vdCB1cHN0cmVhbS4NCg0KDQo=
