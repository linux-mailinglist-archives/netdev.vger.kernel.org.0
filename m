Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417AF22B89C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgGWV2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGWV2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:28:01 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881FFC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 14:28:00 -0700 (PDT)
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 83425891B2
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:27:56 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1595539676;
        bh=JUvoMsem218rI/L0/uzeD6ZPpS4FkYObDAlZzZITEJ4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=HjXABbRQXyYbFXbPT6i0OP8zHC0KEUrgQQI/tKzfAFMCmp8qTDHnXOhmiidyyaIWh
         nCtQqUYnjvdpQ115jtlR5xp3j5NdKwt9WPj+l6L4Qkj97q2H/swR20fPjytHe9Cqtk
         rex99htaXCHzAtLjUSWlGxxTkDlN5eywTjHSSOIWD1P35w8pOzQ9No2Z4qe6Ay8l8I
         ushmH7KteFUV78MES7thhXb/8a241Qy95WCeSaKWyMlI/y8Ec2Ll7YkatQZosNF/kP
         7KjNObiqcXNI+8Tc1CB8bCmpUYNgOINnm3ZnBRR7QNWE6YNaBaP7XOGIkJ3t1lSSTA
         kFxZ5LFtq0kCQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[10.32.16.77]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f1a00db0000>; Fri, 24 Jul 2020 09:27:55 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul 2020 09:27:55 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.006; Fri, 24 Jul 2020 09:27:55 +1200
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: dsa: mv88e6xxx losing DHCPv6 solicit packets / IPv6 multicast
 packets?
Thread-Topic: dsa: mv88e6xxx losing DHCPv6 solicit packets / IPv6 multicast
 packets?
Thread-Index: AQHWYQAGIidp0Toi3ka6skvQc0rqhKkU5RUA
Date:   Thu, 23 Jul 2020 21:27:54 +0000
Message-ID: <1b6ba265-4651-79d2-9b43-f14e7f6ec19b@alliedtelesis.co.nz>
References: <20200723164610.62e70bde@dellmb.labs.office.nic.cz>
In-Reply-To: <20200723164610.62e70bde@dellmb.labs.office.nic.cz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <81E7B203F7787D4388FE4447D06EBBD1@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyZWssDQoNCk9uIDI0LzA3LzIwIDI6NDYgYW0sIE1hcmVrIEJlaMO6biB3cm90ZToNCj4g
SGksDQo+DQo+IGEgY3VzdG9tZXIgb2Ygb3VycyBmaWxlZCBhIHRpY2tldCBzYXlpbmcgdGhhdCB3
aGVuIHVzaW5nIHVwc3RyZWFtIGtlcm5lbA0KPiAoNS44LjAtcmM2IG9uIERlYmlhbiAxMCkgb24g
VHVycmlzIE1PWCAoODhlNjE5MCBzd2l0Y2gpIHdpdGggRFNBIHdpdGgNCj4gZGVmYXVsdCBjb25m
aWd1cmF0aW9uLCB0aGUgc3dpdGNoIGlzIGxvc2luZyBESENQdjYgc29saWNpdCBwYWNrZXRzIC8N
Cj4gSVB2NiBtdWx0aWNhc3QgcGFja2V0cyBzZW50IHRvIGZmMDI6OjE6OjIgYWRkcmVzcy4NCj4N
Cj4+IFNwZWNpZmljYWxseSwgaXQgc2VlbXMgdGhlIDg4RTYxOTAgaGFyZHdhcmUgc3dpdGNoZXMg
aW4gdGhlIFBlcmlkb3QNCj4+IG1vZHVsZSBpcyBzd2FsbG93aW5nIElQdjYgbXVsdGljYXN0IHBh
Y2tldHMgKHNlbnQgdG8gZmYwMjo6MToyICkuDQo+PiBXZSB0ZXN0ZWQgdGhpcyBieSBtaXJyb3Jp
bmcgdGhlIE1veCBMQU4gcG9ydCBvbiB0aGUgc3dpdGNoIGFuZCBzYXcgdGhlDQo+PiBESENQdjYg
c29saWNpdCBwYWNrZXQgYXJyaXZpbmcgb3V0IG9mIHRoZSBzd2l0Y2ggYnV0IHRoZSBNb3gga2Vy
bmVsDQo+PiBkaWRuJ3Qgc2VlIGl0ICh1c2luZyB0Y3BkdW1wKS4NCj4gSXMgdGhpcyBpc3N1ZSBr
bm93bj8NCg0KSSBjYW4ndCBzcGVhayB0byB0aGUgUGVyaWRvdCBzcGVjaWZpY2FsbHkgYnV0IG90
aGVyIE1hcnZlbGwgc2lsaWNvbiBJJ3ZlIA0KZGVhbHQgd2l0aCBkb2VzIHRyeSB0byBhdm9pZCB0
cmFwcGluZyBwYWNrZXRzIHRvIHRoZSBDUFUuIE5vcm1hbGx5IHlvdSANCndvdWxkIHNldCBzcGVj
aWZpYyByZWdpc3RlcnMvdGFibGUgZW50cmllcyB0byBkZWNsYXJlIGludGVyZXN0IGluIA0KcGFy
dGljdWxhciByZXNlcnZlZCBtdWx0aWNhc3QgZ3JvdXBzLg0KDQpJIGhhZCBhIHF1aWNrIHNraW0g
b2YgdGhlIFBlcmlkb3QgZG9jcyBhbmQgdGhlIHJlZmVyZW5jZXMgdG8gcmVzZXJ2ZWQgDQptdWx0
aWNhc3QgSSBzZWUgYXJlIGFsbCBhYm91dCB0aGUgODAyLjFEIEJQRFVzLg0KDQpJdCBtaWdodCBi
ZSBuZWNlc3NhcnkgdG8gY29uZmlndXJlIE1MRCBzbm9vcGluZyBvciBhZGQgYW4gRkRCIGVudHJ5
IHRvIA0KZ2V0IHRoZSBmZjAyOjoxOjoyIHBhY2tldHMgdG8gdGhlIENQVS4NCg0KVGhlcmUgaXMg
YWxzbyB0aGUgcG9zc2liaWxpdHkgdGhhdCB0aGUgQ1BVcyBFdGhlcm5ldCBwb3J0IGlzIGRyb3Bw
aW5nIA0KdGhlIHBhY2tldHMgZm9yIHNpbWlsYXIgcmVhc29ucy4gSSdkIGV4cGVjdCBMaW51eCB0
byBoYW5kbGUgdGhhdCANCmNvcnJlY3RseSBwdXQgcGVyaGFwcyB3aXRoIGEgRFNBIGNvbmZpZ3Vy
YXRpb24gaXQgc2tpcHMgdGhlIG11bHRpY2FzdCANCnJlY2VwdGlvbiBjb25maWcuDQoNCkFzIGFu
b3RoZXIgdGhvdWdodCBkbyB5b3Uga25vdyB3aGF0IERIQ1B2NiBjbGllbnQvc2VydmVyIGlzIGJl
aW5nIHVzZWQuIA0KVGhlcmUgd2FzIGEgZmFpcmx5IHJlY2VudCBidWdmaXggZm9yIGJ1c3lib3gg
dGhhdCB3YXMgbmVlZGVkIGJlY2F1c2UgdGhlIA0KdjYgY29kZSB3YXMgdXNpbmcgdGhlIHdyb25n
IE1BQyBhZGRyZXNzLg0K
