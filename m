Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8217651944
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 04:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbiLTDHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 22:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLTDHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 22:07:51 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14C62DD7
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 19:07:49 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id CEACB2C0610;
        Tue, 20 Dec 2022 16:07:47 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671505667;
        bh=rjCGxM+qGQTNM3x/n8IM131PVY0InLOax6ALqm0TNzg=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=qVnFP8tByxUeQnEVgUaHg/4lZBc9sELet1Y9B+68Svi/D0osnqcoCJWB8uE6nR6ws
         wmu3OYg9FT9TOsHMhrpoqAlczRk4MnQZ54JruSQ1izzAH5cpulfDdowYlxxJNdrYvz
         Skj4zSKZWjWQdoGc8ug0gDsnU9+yNHo9Bk5IpJeuCWU05tV2QNd4ti///hbXY5y9Wh
         2X5ANPtT08x8/ZeomlcKFfL4lkIewVqKLxUPS6DGAMugMt7pYeSShu9b7oiYE46jt0
         rWylitkp+ocGV2uTgxLOIE75rd7Leruk3MBJXe1LszyPcPiPT1eVUAgFoM/hI34GIB
         w7ESVTzQVRpyQ==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63a127030001>; Tue, 20 Dec 2022 16:07:47 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 20 Dec 2022 16:07:47 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.044; Tue, 20 Dec 2022 16:07:47 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "a@unstable.cc" <a@unstable.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Topic: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Index: AQHZFBpSn9BtuUDucEWGwn1kCNMLna51NJkAgAAJUACAAABsAA==
Date:   Tue, 20 Dec 2022 03:07:47 +0000
Message-ID: <fd0a2c4b-9dbd-48da-6fbc-e876d15e8f76@alliedtelesis.co.nz>
References: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
 <8e4ad680-4406-e6df-5335-ffe53a60aa83@alliedtelesis.co.nz>
 <b9e601b5-c220-0c3f-5499-317f9fd706b9@alliedtelesis.co.nz>
 <90c749975ea3940b37cfae95f224da25bee6f577.camel@alliedtelesis.co.nz>
In-Reply-To: <90c749975ea3940b37cfae95f224da25bee6f577.camel@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4103A38E38B84E40A5D52A78C50E0EF1@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=sHyYjHe8cH0A:10 a=VwQbUJbxAAAA:8 a=hF11lFcFC9ivTvOCIKIA:9 a=QEXdDO2ut3YA:10 a=sCYvTA3s4OUA:10 a=5imOhvl-4yYA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMC8xMi8yMiAxNjowNiwgVGhvbWFzIFdpbnRlciB3cm90ZToNCj4gT24gVHVlLCAyMDIy
LTEyLTIwIGF0IDE1OjMyICsxMzAwLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0KPj4gT24gMjAvMTIv
MjIgMTU6MjUsIENocmlzIFBhY2toYW0gd3JvdGU6DQo+Pj4gSGkgVGhvbWFzLA0KPj4+DQo+Pj4g
T24gMTkvMTIvMjIgMTQ6MDYsIFRob21hcyBXaW50ZXIgd3JvdGU6DQo+Pj4+IEZvciBvdXIgcG9p
bnQtdG8tcG9pbnQgR1JFIHR1bm5lbHMsIHRoZXkgaGF2ZQ0KPj4+PiBJTjZfQUREUl9HRU5fTU9E
RV9OT05FDQo+Pj4+IHdoZW4gdGhleSBhcmUgY3JlYXRlZCB0aGVuIHdlIHNldCBJTjZfQUREUl9H
RU5fTU9ERV9FVUk2NCB3aGVuDQo+Pj4+IHRoZXkNCj4+Pj4gY29tZSB1cCB0byBnZW5lcmF0ZSB0
aGUgSVB2NiBsaW5rIGxvY2FsIGFkZHJlc3MgZm9yIHRoZQ0KPj4+PiBpbnRlcmZhY2UuDQo+Pj4+
IFJlY2VudGx5IHdlIGZvdW5kIHRoYXQgdGhleSB3ZXJlIG5vIGxvbmdlciBnZW5lcmF0aW5nIElQ
djYNCj4+Pj4gYWRkcmVzc2VzLg0KPj4+Pg0KPj4+PiBBbHNvLCBub24tcG9pbnQtdG8tcG9pbnQg
dHVubmVscyB3ZXJlIG5vdCBnZW5lcmF0aW5nIGFueSBJUHY2DQo+Pj4+IGxpbmsNCj4+Pj4gbG9j
YWwgYWRkcmVzcyBhbmQgaW5zdGVhZCBnZW5lcmF0aW5nIGFuIElQdjYgY29tcGF0IGFkZHJlc3Ms
DQo+Pj4+IGJyZWFraW5nIElQdjYgY29tbXVuaWNhdGlvbiBvbiB0aGUgdHVubmVsLg0KPj4+Pg0K
Pj4+PiBUaGVzZSBmYWlsdXJlcyB3ZXJlIGNhdXNlZCBieSBjb21taXQgZTVkZDcyOTQ2MGNhIGFu
ZCB0aGlzIHBhdGNoDQo+Pj4+IHNldA0KPj4+PiBhaW1zIHRvIHJlc29sdmUgdGhlc2UgaXNzdWVz
Lg0KPj4+IFRoaXMgYXBwZWFycyB0byBiZSBhIHYyIG9mDQo+Pj4gaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsLzIwMjIxMjE4MjE1NzE4LjE0OTE0NDQtMS1UaG9tYXMuV2ludGVyQGFsbGllZHRl
bGVzaXMuY28ubnovI3QNCj4+PiBidXQgeW91IGhhdmVuJ3Qgc2FpZCBzbyBpbiB0aGUgc3ViamVj
dCBub3IgaGF2ZSB5b3UgaW5jbHVkZWQgYQ0KPj4+IGNoYW5nZWxvZyBpbiB0aGUgcGF0Y2hlcyBv
ciBpbiB0aGUgY292ZXIgbGV0dGVyLg0KPj4+DQo+Pj4gQWxzbyBmb3IgbmV0d29ya2luZyBwYXRj
aGVzIHlvdSBzaG91bGQgaW5jbHVkZSBlaXRoZXIgIm5ldCIgb3INCj4+PiAibmV0LW5leHQiIGlu
IHRoZSBzdWJqZWN0IHByZWZpeC4gQXMgdGhpcyBhcHBlYXJzIHRvIGJlIGEgYnVnZml4DQo+Pj4g
Im5ldCINCj4+PiBpcyBhcHByb3ByaWF0ZS4NCj4+Pg0KPj4gVG9vayBtZSBhIGJpdCBvZiBsb29r
aW5nIGJ1dCBtb3N0IG9mIHRoaXMgc3R1ZmYgaXMgY292ZXJlZCBieQ0KPj4gaHR0cHM6Ly93d3cu
a2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3QvcHJvY2Vzcy9tYWludGFpbmVyLW5ldGRldi5odG1s
I25ldGRldi1mYXENCj4gVGhhbmtzLCB0aGUgZ2l0IGNvbW1hbmQgSSB1c2VkIGRpZCBub3QgcHV0
IGluIHRoZSB2MiB0aGF0IEkgZXhwZWN0ZWQNCj4gYW5kIEkgZGlkbid0IGNoZWNrIHRoZSBvdXRw
dXQgcHJvcGVybHkuIEkgd2lsbCBzZW5kIGEgbmV3IHBhdGNoIHNldCBhcw0KPiB2My4NCkkgZG9u
J3QgdGhpbmsgdGhlcmUncyBhbnkgcGFydGljdWxhciBuZWVkIHRvIHJ1c2guIEkgd291bGRuJ3Qg
ZXhwZWN0IA0KbXVjaCBvZiBhIHJlc3BvbnNlIG92ZXIgdGhlIGhvbGlkYXkgcGVyaW9kLg0KPj4+
PiBUaG9tYXMgV2ludGVyICgyKToNCj4+Pj4gICAgIGlwL2lwNl9ncmU6IEZpeCBjaGFuZ2luZyBh
ZGRyIGdlbiBtb2RlIG5vdCBnZW5lcmF0aW5nIElQdjYNCj4+Pj4gbGluayBsb2NhbA0KPj4+PiAg
ICAgICBhZGRyZXNzDQo+Pj4+ICAgICBpcC9pcDZfZ3JlOiBGaXggbm9uLXBvaW50LXRvLXBvaW50
IHR1bm5lbCBub3QgZ2VuZXJhdGluZyBJUHY2DQo+Pj4+IGxpbmsNCj4+Pj4gICAgICAgbG9jYWwg
YWRkcmVzcw0KPj4+Pg0KPj4+PiAgICBuZXQvaXB2Ni9hZGRyY29uZi5jIHwgNTcgKysrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tDQo+Pj4+IC0tLS0tLS0tLQ0KPj4+PiAgICAxIGZp
bGUgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0p
