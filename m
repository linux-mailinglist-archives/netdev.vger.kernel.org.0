Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5274B3D2A
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiBMTld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:41:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBMTlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:41:32 -0500
Received: from mxo1.nje.dmz.twosigma.com (mxo1.nje.dmz.twosigma.com [208.77.214.160])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A2156C32
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 11:41:25 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mxo1.nje.dmz.twosigma.com (Postfix) with ESMTP id 4Jxd5J3jGmz8ypn;
        Sun, 13 Feb 2022 19:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=twosigma.com;
        s=202008; t=1644781284;
        bh=CKURuuN0KWx3Gbyc8p1vsYbsTtT6DfIcfBWqUtgy0JM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=O7/RRWkLhbKG2qscsffmUfBW6I5oxpkxYJ1Gwc8u5FxI+4zx69S/u+JrDBXxAPHoi
         8YETIUksPJ64t7Cv5A0Qm7ZgVd8eVQr/87jWeMYy6FLTDMNfrB5lfO62jOUcfNcdCU
         gux3q8lpT18JBJ+rBCXff8xkqWcnq0Nm7En0e4cSf2rxIybZFvD7n22CMMR8bTTNmu
         nc6ko4I0Oi+FB6NoE8UAJUk2Gy3eSQqdC9BxuT88F9tbccnN9mlGuQscYjUbANFT2x
         kbAbUUAfRwpqmGqI9JhILqQxzjmdjqyUV2CurZ3XGrUZzafrpi6fbRYoP1CzayGBzw
         NlsVvunXwwhBA==
X-Virus-Scanned: Debian amavisd-new at twosigma.com
Received: from mxo1.nje.dmz.twosigma.com ([127.0.0.1])
        by localhost (mxo1.nje.dmz.twosigma.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XRLfz1JQ74AM; Sun, 13 Feb 2022 19:41:24 +0000 (UTC)
Received: from exmbdft8.ad.twosigma.com (exmbdft8.ad.twosigma.com [172.22.2.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxo1.nje.dmz.twosigma.com (Postfix) with ESMTPS id 4Jxd5J2J7qz80Sm;
        Sun, 13 Feb 2022 19:41:24 +0000 (UTC)
Received: from exmbdft6.ad.twosigma.com (172.22.1.5) by
 exmbdft8.ad.twosigma.com (172.22.2.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 13 Feb 2022 19:41:23 +0000
Received: from exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c]) by
 exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c%17]) with mapi id
 15.00.1497.012; Sun, 13 Feb 2022 19:41:23 +0000
From:   Tian Lan <Tian.Lan@twosigma.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Tian Lan <tilan7663@gmail.com>, netdev <netdev@vger.kernel.org>,
        "Andrew Chester" <Andrew.Chester@twosigma.com>
Subject: RE: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Topic: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Index: AQHYII8R50vJ9luEckWkqpgQGqAi+KyQ4b2AgADavqCAAAbEgIAAAnNAgAAQawCAAABIMIAACHsAgAADGpA=
Date:   Sun, 13 Feb 2022 19:41:23 +0000
Message-ID: <d8f0e646edc248f29e54115a27c64fcb@exmbdft6.ad.twosigma.com>
References: <20220213040545.365600-1-tilan7663@gmail.com>
 <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
 <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
 <CANn89iKDzgHk_gk9+56xumy9M40br-aEoUXJ13KtFgxZRQJVOw@mail.gmail.com>
 <dd7f3fd1b08a44328d59116cd64f483a@exmbdft6.ad.twosigma.com>
 <CANn89iLdcy4qbUUNSpLKoegh8+Nc=edC3WshQ=OasKyWJQ256A@mail.gmail.com>
 <746fd1ba6d994ecf8d6e9854abb75409@exmbdft6.ad.twosigma.com>
 <CANn89i+1aPNwGCP1Y+-nPxh4A_+t0JdOWorZHvXpRD_2OhjTMQ@mail.gmail.com>
In-Reply-To: <CANn89i+1aPNwGCP1Y+-nPxh4A_+t0JdOWorZHvXpRD_2OhjTMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [172.23.151.37]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzLCB3aWxsIHN0YXJ0IHdpdGggdGhlIElFVEYgYXBwcm92YWwuIA0KDQotLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29t
PiANClNlbnQ6IFN1bmRheSwgRmVicnVhcnkgMTMsIDIwMjIgMjoyOSBQTQ0KVG86IFRpYW4gTGFu
IDxUaWFuLkxhbkB0d29zaWdtYS5jb20+DQpDYzogVGlhbiBMYW4gPHRpbGFuNzY2M0BnbWFpbC5j
b20+OyBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBBbmRyZXcgQ2hlc3RlciA8QW5k
cmV3LkNoZXN0ZXJAdHdvc2lnbWEuY29tPg0KU3ViamVjdDogUmU6IFtQQVRDSF0gdGNwOiBhbGxv
dyB0aGUgaW5pdGlhbCByZWNlaXZlIHdpbmRvdyB0byBiZSBncmVhdGVyIHRoYW4gNjRLaUINCg0K
T24gU3VuLCBGZWIgMTMsIDIwMjIgYXQgMTE6MjYgQU0gVGlhbiBMYW4gPFRpYW4uTGFuQHR3b3Np
Z21hLmNvbT4gd3JvdGU6DQo+DQo+ID4gSSBzdWdnZXN0IHRoYXQgeW91IGRvIG5vdCBpbnRlcnBy
ZXQgdGhpbmdzIGFzICIgQlBGX1NPQ0tfT1BTX1JXTkRfSU5JVCBjb3VsZCBleGNlZWQgNjRLaUIi
ICBiZWNhdXNlIGl0IGNhbiBub3QuDQo+DQo+ID4gSWYgeW91IHJlYWxseSBuZWVkIHRvIHNlbmQg
bW9yZSB0aGFuIDY0S0IgaW4gdGhlIGZpcnN0IFJUVCwgVENQIGlzIG5vdCBhIHByb3BlciBwcm90
b2NvbC4NCj4NCj4gPiAxM2QzYjFlYmUyODcgY29tbWl0IG1lc3NhZ2Ugc2hvdWxkIGhhdmUgYmVl
biB2ZXJ5IGNsZWFyIGFib3V0IHRoZSA2NEsgbGltaXRhdGlvbi4NCj4NCj4gSSdtIG5vdCB0cnlp
bmcgdG8gbWFrZSB0aGUgc2VuZGVyIHRvIHNlbmQgbW9yZSB0aGFuIDY0S2liIGluIHRoZSBmaXJz
dCBSVFQuIFRoZSBjaGFuZ2Ugd2lsbCBvbmx5IG1ha2UgdGhlIHNlbmRlciB0byBzZW5kIG1vcmUg
c3RhcnRpbmcgb24gdGhlIHNlY29uZCBSVFQoYWZ0ZXIgZmlyc3QgYWNrIHJlY2VpdmVkIG9uIHRo
ZSBkYXRhKS4gSW5zdGVhZCBvZiBoYXZpbmcgdGhlIHJjdl93bmQgdG8gZ3JvdyBmcm9tIDY0S2li
LCB0aGUgcmN2X3duZCBjYW4gc3RhcnQgZnJvbSBhIG11Y2ggbGFyZ2VyIGJhc2UgdmFsdWUuDQo+
DQo+IFdpdGhvdXQgdGhlIHBhdGNoOg0KPg0KPiBSVFQ6ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAxLCAgICAgICAgICAgICAgICAgICAyLCAgICAgICAgICAgICAgICAgMywgIC4uLg0K
PiByY3Zfd25kOiAgICAgICAgICAgICAgICA2NEtpQiwgICAgICAgIDE5MktpQiwgICAgICAgICA1
NzZLaUIsICAuLi4NCg0KVGhpcyBpcyBqdXN0IGZpbmUsIGluIGFjY29yZGFuY2Ugd2l0aCB3aGF0
IHdlIGV4cGVjdC4NCg0KPg0KPiBXaXRoIHRoZSBwYXRjaCAoYXNzdW1lIHJjdl93bmQgaXMgc2V0
IHRvIDUxMktpQik6DQo+DQo+IFJUVDogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDEs
ICAgICAgICAgICAgICAgICAgICAyLCAgICAgICAgICAgICAgICAzLCAgIC4uLg0KPiByY3Zfd25k
OiAgICAgICAgICAgICAgICA2NEtpQiwgICAgMS41MzZNaUIsICAgIDQuNjA4TWlCLCAgLi4uDQoN
ClRoaXMgaXMgbm90IG5lZWRlZCwgdW5sZXNzIHlvdSB3YW50IHRvIGJsYXN0IE1CIG9mIGRhdGEg
aW4gdGhlIHNlY29uZCBSVFQuDQoNClBsZWFzZSBnZXQgSUVURiBhcHByb3ZhbCBmaXJzdC4NCg==
