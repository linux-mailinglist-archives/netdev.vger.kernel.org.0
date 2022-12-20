Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62476518C9
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 03:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiLTCdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 21:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232444AbiLTCdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 21:33:01 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AADE0BA
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 18:32:59 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 35C702C04E6;
        Tue, 20 Dec 2022 15:32:57 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1671503577;
        bh=42PoPhr+KqzSGJiaAQbJrm9tQ+WiT2IdZz0TbTJ9vlc=;
        h=From:To:Subject:Date:References:In-Reply-To:From;
        b=SnfohIHPyg1aGWHFDehV3lEoINbFSebXfAOBmX1iFFeIiQWfL4wCR+448w4b9CpY9
         ohMt7rA2qE4SPADB1s7Ncs9hXc33SAM0l8KbHTsPmNbhWRLJgygagP77P6Czlh+eGi
         k2KBMN5oaU/FCuvVfp+zRMpDK9JWUMzaEyihdHgcDv0bFqoaGfVK1PC6yXZIdvIrKr
         rnHYSckLZYYsAYBu9duO1rl3U7fhgNrFYt405gmCvGdm0kTwK/JysPGZJS4fMYsZgi
         vZq2QlH5trLNnyw+v0kwzXfpbHatSFtl62V8bPSwm5qt2AXA1ZDlLskDlKl5NWEl5/
         eUbEi4xOCBiEA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63a11ed90001>; Tue, 20 Dec 2022 15:32:57 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8)
 by svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8:409d:36f5:8899:92e8) with
 Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 20 Dec 2022 15:32:56 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.044; Tue, 20 Dec 2022 15:32:56 +1300
From:   Chris Packham <Chris.Packham@alliedtelesis.co.nz>
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "a@unstable.cc" <a@unstable.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Topic: [PATCH 0/2] ip/ip6_gre: Fix GRE tunnels not generating IPv6 link
 local addresses
Thread-Index: AQHZFBpSn9BtuUDucEWGwn1kCNMLna51NJkA
Date:   Tue, 20 Dec 2022 02:32:56 +0000
Message-ID: <b9e601b5-c220-0c3f-5499-317f9fd706b9@alliedtelesis.co.nz>
References: <20221219010619.1826599-1-Thomas.Winter@alliedtelesis.co.nz>
 <8e4ad680-4406-e6df-5335-ffe53a60aa83@alliedtelesis.co.nz>
In-Reply-To: <8e4ad680-4406-e6df-5335-ffe53a60aa83@alliedtelesis.co.nz>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEDB289C7B67D243919E21A7693B94A4@atlnz.lc>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=X/cs11be c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=IkcTkHD0fZMA:10 a=sHyYjHe8cH0A:10 a=VwQbUJbxAAAA:8 a=HDgtHuHPz33fAyNS_PsA:9 a=QEXdDO2ut3YA:10 a=sCYvTA3s4OUA:10 a=5imOhvl-4yYA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyMC8xMi8yMiAxNToyNSwgQ2hyaXMgUGFja2hhbSB3cm90ZToNCj4gSGkgVGhvbWFzLA0K
Pg0KPiBPbiAxOS8xMi8yMiAxNDowNiwgVGhvbWFzIFdpbnRlciB3cm90ZToNCj4+IEZvciBvdXIg
cG9pbnQtdG8tcG9pbnQgR1JFIHR1bm5lbHMsIHRoZXkgaGF2ZSBJTjZfQUREUl9HRU5fTU9ERV9O
T05FDQo+PiB3aGVuIHRoZXkgYXJlIGNyZWF0ZWQgdGhlbiB3ZSBzZXQgSU42X0FERFJfR0VOX01P
REVfRVVJNjQgd2hlbiB0aGV5DQo+PiBjb21lIHVwIHRvIGdlbmVyYXRlIHRoZSBJUHY2IGxpbmsg
bG9jYWwgYWRkcmVzcyBmb3IgdGhlIGludGVyZmFjZS4NCj4+IFJlY2VudGx5IHdlIGZvdW5kIHRo
YXQgdGhleSB3ZXJlIG5vIGxvbmdlciBnZW5lcmF0aW5nIElQdjYgYWRkcmVzc2VzLg0KPj4NCj4+
IEFsc28sIG5vbi1wb2ludC10by1wb2ludCB0dW5uZWxzIHdlcmUgbm90IGdlbmVyYXRpbmcgYW55
IElQdjYgbGluaw0KPj4gbG9jYWwgYWRkcmVzcyBhbmQgaW5zdGVhZCBnZW5lcmF0aW5nIGFuIElQ
djYgY29tcGF0IGFkZHJlc3MsDQo+PiBicmVha2luZyBJUHY2IGNvbW11bmljYXRpb24gb24gdGhl
IHR1bm5lbC4NCj4+DQo+PiBUaGVzZSBmYWlsdXJlcyB3ZXJlIGNhdXNlZCBieSBjb21taXQgZTVk
ZDcyOTQ2MGNhIGFuZCB0aGlzIHBhdGNoIHNldA0KPj4gYWltcyB0byByZXNvbHZlIHRoZXNlIGlz
c3Vlcy4NCj4NCj4gVGhpcyBhcHBlYXJzIHRvIGJlIGEgdjIgb2YgDQo+IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2FsbC8yMDIyMTIxODIxNTcxOC4xNDkxNDQ0LTEtVGhvbWFzLldpbnRlckBhbGxp
ZWR0ZWxlc2lzLmNvLm56LyN0IA0KPiBidXQgeW91IGhhdmVuJ3Qgc2FpZCBzbyBpbiB0aGUgc3Vi
amVjdCBub3IgaGF2ZSB5b3UgaW5jbHVkZWQgYSANCj4gY2hhbmdlbG9nIGluIHRoZSBwYXRjaGVz
IG9yIGluIHRoZSBjb3ZlciBsZXR0ZXIuDQo+DQo+IEFsc28gZm9yIG5ldHdvcmtpbmcgcGF0Y2hl
cyB5b3Ugc2hvdWxkIGluY2x1ZGUgZWl0aGVyICJuZXQiIG9yIA0KPiAibmV0LW5leHQiIGluIHRo
ZSBzdWJqZWN0IHByZWZpeC4gQXMgdGhpcyBhcHBlYXJzIHRvIGJlIGEgYnVnZml4ICJuZXQiIA0K
PiBpcyBhcHByb3ByaWF0ZS4NCj4NClRvb2sgbWUgYSBiaXQgb2YgbG9va2luZyBidXQgbW9zdCBv
ZiB0aGlzIHN0dWZmIGlzIGNvdmVyZWQgYnkgDQpodHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9o
dG1sL2xhdGVzdC9wcm9jZXNzL21haW50YWluZXItbmV0ZGV2Lmh0bWwjbmV0ZGV2LWZhcQ0KPj4N
Cj4+IFRob21hcyBXaW50ZXIgKDIpOg0KPj4gwqDCoCBpcC9pcDZfZ3JlOiBGaXggY2hhbmdpbmcg
YWRkciBnZW4gbW9kZSBub3QgZ2VuZXJhdGluZyBJUHY2IGxpbmsgbG9jYWwNCj4+IMKgwqDCoMKg
IGFkZHJlc3MNCj4+IMKgwqAgaXAvaXA2X2dyZTogRml4IG5vbi1wb2ludC10by1wb2ludCB0dW5u
ZWwgbm90IGdlbmVyYXRpbmcgSVB2NiBsaW5rDQo+PiDCoMKgwqDCoCBsb2NhbCBhZGRyZXNzDQo+
Pg0KPj4gwqAgbmV0L2lwdjYvYWRkcmNvbmYuYyB8IDU3ICsrKysrKysrKysrKysrKysrKysrKysr
Ky0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gwqAgMSBmaWxlIGNoYW5nZWQsIDMxIGluc2VydGlv
bnMoKyksIDI2IGRlbGV0aW9ucygtKQ0KPj4=
