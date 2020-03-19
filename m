Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C009018ABC2
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 05:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgCSE2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 00:28:02 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:45986 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgCSE2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 00:28:02 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 56BFE891AD
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 17:28:00 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1584592080;
        bh=nd3d4O/3qS2TkvY8AUMIFlE5PFzDtwbV6aQQvFA25+E=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=IsXYMGuEi/rqX/lxUpvG2YeZpS2cmPbmiPZspL91dhz+9HYjaD+bm5mKsYZFB2x9b
         y/xjmVfEKqudlKJa56THfcFtnG8TI5k2wwM4iFo9MPvqbKKkdDnFbGQJFBgyLjjQvu
         kJmrnxN+3sLaS9YTCyDzEoKd1wCCOunEkX9JVDICkSwzl1ZQGlljpbZXlbaPvRPrew
         ky2K1S0h6o1VgoacxPiJLIOQGHb9+POKAdVwPF4RhRO2NK39xNDl5voRNkuxNRzatl
         L33vQBMevVK4PaqiEPebnzjEe7sNpRt6W3pGf/LzDnbROf6Jm9QCXwXuWaycx2AmDn
         s8DEHqo6QdGJg==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e72f4d10000>; Thu, 19 Mar 2020 17:28:01 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 19 Mar 2020 17:27:56 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Thu, 19 Mar 2020 17:27:56 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     "marek.behun@nic.cz" <marek.behun@nic.cz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Thread-Topic: [PATCH net-next] net: mvmdio: fix driver probe on missing irq
Thread-Index: AQHV/Y3jysg2xFhB6kOpvd67sEDP3KhOT2uAgAAnOICAAAHYgA==
Date:   Thu, 19 Mar 2020 04:27:56 +0000
Message-ID: <de28dd392987d666f9ad4a0c94e71fc0a686d8d6.camel@alliedtelesis.co.nz>
References: <20200319012940.14490-1-marek.behun@nic.cz>
         <d7cfec6e2b6952776dfedfbb0ba69a5f060d7cb5.camel@alliedtelesis.co.nz>
         <20200319052119.4e694c8b@nic.cz>
In-Reply-To: <20200319052119.4e694c8b@nic.cz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:df5:b000:22:a97e:337f:8259:7ed4]
Content-Type: text/plain; charset="utf-8"
Content-ID: <67F079C5CB7B5841A76F2A7AA51B428D@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAzLTE5IGF0IDA1OjIxICswMTAwLCBNYXJlayBCZWh1biB3cm90ZToNCj4g
T24gVGh1LCAxOSBNYXIgMjAyMCAwMjowMDo1NyArMDAwMA0KPiBDaHJpcyBQYWNraGFtIDxDaHJp
cy5QYWNraGFtQGFsbGllZHRlbGVzaXMuY28ubno+IHdyb3RlOg0KPiANCj4gPiBIaSBNYXJlaywN
Cj4gPiANCj4gPiBPbiBUaHUsIDIwMjAtMDMtMTkgYXQgMDI6MjkgKzAxMDAsIE1hcmVrIEJlaMO6
biB3cm90ZToNCj4gPiA+IENvbW1pdCBlMWY1NTBkYzQ0YTQgbWFkZSB0aGUgdXNlIG9mIHBsYXRm
b3JtX2dldF9pcnFfb3B0aW9uYWwsIHdoaWNoIGNhbg0KPiA+ID4gcmV0dXJuIC1FTlhJTyB3aGVu
IGludGVycnVwdCBpcyBtaXNzaW5nLiBIYW5kbGUgdGhpcyBhcyBub24tZXJyb3IsDQo+ID4gPiBv
dGhlcndpc2UgdGhlIGRyaXZlciB3b24ndCBwcm9iZS4gIA0KPiA+IA0KPiA+IFRoaXMgaGFzIGFs
cmVhZHkgYmVlbiBmaXhlZCBpbiBuZXQvbWFzdGVyIGJ5IHJldmVydGluZyBlMWY1NTBkYzQ0YTQg
YW5kDQo+ID4gcmVwbGFjaW5nIGl0IHdpdGggZmEyNjMyZjc0ZTU3YmJjODY5YzhhZDM3NzUxYTEx
YjYxNDdhM2FjYy4NCj4gDQo+IDooIEl0IGlzbid0IGluIG5ldC1uZXh0LiBJJ3ZlIHNwZW50IGxp
a2UgYW4gaG91ciBkZWJ1Z2dpbmcgaXQgOi1EDQoNCkkgY2FuIG9ubHkgb2ZmZXIgbXkgaHVtYmxl
IGFwb2xvZ2llcyBhbmQgcHJvbWlzZSB0byBkbyBiZXR0ZXIgbmV4dA0KdGltZS4gSSBkaWQgdGVz
dCB0aGUgZmlyc3QgbWluaW1hbGx5IGNvcnJlY3QgY2hhbmdlLCBidXQgY2xlYXJseQ0Kc3R1ZmZl
ZCB1cCBvbiB2Mi4NCg==
