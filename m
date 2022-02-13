Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070734B3D1F
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 20:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbiBMT0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 14:26:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiBMT0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 14:26:41 -0500
Received: from mxo1.dft.dmz.twosigma.com (mxo1.dft.dmz.twosigma.com [208.77.212.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C63C22
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 11:26:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mxo1.dft.dmz.twosigma.com (Postfix) with ESMTP id 4Jxcm9278nz2xqD;
        Sun, 13 Feb 2022 19:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=twosigma.com;
        s=202008; t=1644780393;
        bh=X1tqfHVE1iJ3aK3HcZ9q6AEdOupkrCr3e1Mwwj0tEDY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=F5Ull0srWqh1mfTvwgLqut1bJIGseWW/9EQ89tJawpQ/i9osyZri4k0nC0Re2xF6e
         dvJncSeXF/rq1ecAfwMQNqaqGZWRKfi2v3d3bOm4w0wXcF7vXkV7iCQ4oxF2ltoRgN
         jTrHGV4ZeXNHkpqQuYjB0CZb8IwaekdZSsllDUwsj2tLvqdogwoGJOjy5H5pr5M783
         O2UUANrmr1VXuL2FgTWiGpjmRfLJKuLZEiBZGUyIcLPweM0/61dlzbYxXBmJmSFBXk
         SCviKjSDoHit2gHNandVluweVSI9qWjqL+1SRmXmXTS+HgCWl3JK8O3r5TWsska80x
         h3wOOQ39bwDlg==
X-Virus-Scanned: Debian amavisd-new at twosigma.com
Received: from mxo1.dft.dmz.twosigma.com ([127.0.0.1])
        by localhost (mxo1.dft.dmz.twosigma.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tYej0nzBUj1B; Sun, 13 Feb 2022 19:26:33 +0000 (UTC)
Received: from exmbdft7.ad.twosigma.com (exmbdft7.ad.twosigma.com [172.22.2.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxo1.dft.dmz.twosigma.com (Postfix) with ESMTPS id 4Jxcm904Jwz2xY3;
        Sun, 13 Feb 2022 19:26:33 +0000 (UTC)
Received: from exmbdft6.ad.twosigma.com (172.22.1.5) by
 exmbdft7.ad.twosigma.com (172.22.2.43) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 13 Feb 2022 19:26:32 +0000
Received: from exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c]) by
 exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c%17]) with mapi id
 15.00.1497.012; Sun, 13 Feb 2022 19:26:32 +0000
From:   Tian Lan <Tian.Lan@twosigma.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Tian Lan <tilan7663@gmail.com>, netdev <netdev@vger.kernel.org>,
        "Andrew Chester" <Andrew.Chester@twosigma.com>
Subject: RE: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Topic: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Index: AQHYII8R50vJ9luEckWkqpgQGqAi+KyQ4b2AgADavqCAAAbEgIAAAnNAgAAQawCAAABIMA==
Date:   Sun, 13 Feb 2022 19:26:32 +0000
Message-ID: <746fd1ba6d994ecf8d6e9854abb75409@exmbdft6.ad.twosigma.com>
References: <20220213040545.365600-1-tilan7663@gmail.com>
 <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
 <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
 <CANn89iKDzgHk_gk9+56xumy9M40br-aEoUXJ13KtFgxZRQJVOw@mail.gmail.com>
 <dd7f3fd1b08a44328d59116cd64f483a@exmbdft6.ad.twosigma.com>
 <CANn89iLdcy4qbUUNSpLKoegh8+Nc=edC3WshQ=OasKyWJQ256A@mail.gmail.com>
In-Reply-To: <CANn89iLdcy4qbUUNSpLKoegh8+Nc=edC3WshQ=OasKyWJQ256A@mail.gmail.com>
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

PiBJIHN1Z2dlc3QgdGhhdCB5b3UgZG8gbm90IGludGVycHJldCB0aGluZ3MgYXMgIiBCUEZfU09D
S19PUFNfUldORF9JTklUIGNvdWxkIGV4Y2VlZCA2NEtpQiIgIGJlY2F1c2UgaXQgY2FuIG5vdC4N
Cg0KPiBJZiB5b3UgcmVhbGx5IG5lZWQgdG8gc2VuZCBtb3JlIHRoYW4gNjRLQiBpbiB0aGUgZmly
c3QgUlRULCBUQ1AgaXMgbm90IGEgcHJvcGVyIHByb3RvY29sLg0KDQo+IDEzZDNiMWViZTI4NyBj
b21taXQgbWVzc2FnZSBzaG91bGQgaGF2ZSBiZWVuIHZlcnkgY2xlYXIgYWJvdXQgdGhlIDY0SyBs
aW1pdGF0aW9uLg0KDQpJJ20gbm90IHRyeWluZyB0byBtYWtlIHRoZSBzZW5kZXIgdG8gc2VuZCBt
b3JlIHRoYW4gNjRLaWIgaW4gdGhlIGZpcnN0IFJUVC4gVGhlIGNoYW5nZSB3aWxsIG9ubHkgbWFr
ZSB0aGUgc2VuZGVyIHRvIHNlbmQgbW9yZSBzdGFydGluZyBvbiB0aGUgc2Vjb25kIFJUVChhZnRl
ciBmaXJzdCBhY2sgcmVjZWl2ZWQgb24gdGhlIGRhdGEpLiBJbnN0ZWFkIG9mIGhhdmluZyB0aGUg
cmN2X3duZCB0byBncm93IGZyb20gNjRLaWIsIHRoZSByY3Zfd25kIGNhbiBzdGFydCBmcm9tIGEg
bXVjaCBsYXJnZXIgYmFzZSB2YWx1ZS4NCg0KV2l0aG91dCB0aGUgcGF0Y2g6DQogDQpSVFQ6ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAxLCAgICAgICAgICAgICAgICAgICAyLAkgICAg
ICAgICAgICAzLCAgLi4uDQpyY3Zfd25kOiAgICAgICAgICAgICAgICA2NEtpQiwgICAgICAgIDE5
MktpQiwgICAgICAgICA1NzZLaUIsICAuLi4NCg0KV2l0aCB0aGUgcGF0Y2ggKGFzc3VtZSByY3Zf
d25kIGlzIHNldCB0byA1MTJLaUIpOiAgICAgIA0KDQpSVFQ6ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAxLCAgICAgICAgICAgICAgICAgICAgMiwJICAgICAgICAgICAgMywgICAuLi4N
CnJjdl93bmQ6ICAgICAgICAgICAgICAgIDY0S2lCLCAgICAxLjUzNk1pQiwgICAgNC42MDhNaUIs
ICAuLi4NCg0KQWxzbywgaXQgZG9lc24ndCBzZWVtIGxpa2UgdGhlIGNvbW1pdCAxM2QzYjFlYmUy
ODcgc3BlY2lmeSBhbnl0aGluZyBhYm91dCA2NEtpQiBsaW1pdGF0aW9uDQpodHRwczovL2dpdGh1
Yi5jb20vdG9ydmFsZHMvbGludXgvY29tbWl0LzEzZDNiMWViZTI4NzYyYzc5ZTk4MTkzMWE0MTkx
NGZhZTVkMDQzODYNCg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRXJpYyBE
dW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPiANClNlbnQ6IFN1bmRheSwgRmVicnVhcnkgMTMs
IDIwMjIgMTo1OCBQTQ0KVG86IFRpYW4gTGFuIDxUaWFuLkxhbkB0d29zaWdtYS5jb20+DQpDYzog
VGlhbiBMYW4gPHRpbGFuNzY2M0BnbWFpbC5jb20+OyBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc+OyBBbmRyZXcgQ2hlc3RlciA8QW5kcmV3LkNoZXN0ZXJAdHdvc2lnbWEuY29tPg0KU3Vi
amVjdDogUmU6IFtQQVRDSF0gdGNwOiBhbGxvdyB0aGUgaW5pdGlhbCByZWNlaXZlIHdpbmRvdyB0
byBiZSBncmVhdGVyIHRoYW4gNjRLaUINCg0KT24gU3VuLCBGZWIgMTMsIDIwMjIgYXQgMTA6NTIg
QU0gVGlhbiBMYW4gPFRpYW4uTGFuQHR3b3NpZ21hLmNvbT4gd3JvdGU6DQo+DQo+ID4gVG8gYmUg
Y2xlYXIsIGlmIHRoZSBzZW5kZXIgcmVzcGVjdHMgdGhlIGluaXRpYWwgd2luZG93IGluIGZpcnN0
IFJUVCANCj4gPiAsIHRoZW4gZmlyc3QgQUNLIGl0IHdpbGwgcmVjZWl2ZSBhbGxvd3MgYSBtdWNo
IGJpZ2dlciB3aW5kb3cgKGF0IA0KPiA+IGxlYXN0IDJ4KSwgIGFsbG93aW5nIGZvciBzdGFuZGFy
ZCBzbG93IHN0YXJ0IGJlaGF2aW9yLCBkb3VibGluZyBDV05EIA0KPiA+IGF0IGVhY2ggUlRUPg0K
PiA+DQo+ID4gbGludXggVENQIHN0YWNrIGlzIGNvbnNlcnZhdGl2ZSwgYW5kIHdhbnRzIGEgcHJv
b2Ygb2YgcmVtb3RlIHBlZXIgd2VsbCBiZWhhdmluZyBiZWZvcmUgb3BlbmluZyB0aGUgZ2F0ZXMu
DQo+ID4NCj4gPiBUaGUgdGhpbmcgaXMsIHdlIGhhdmUgdGhpcyBpc3N1ZSBiZWluZyBkaXNjdXNz
ZWQgZXZlcnkgMyBtb250aHMgb3Igc28sIGJlY2F1c2Ugc29tZSBwZW9wbGUgdGhpbmsgdGhlIFJX
SU4gaXMgbmV2ZXIgY2hhbmdlZCBvciBzb21ldGhpbmcuDQo+ID4NCj4gPiBMYXN0IHRpbWUsIHdl
IGFza2VkIHRvIG5vdCBjaGFuZ2UgdGhlIHN0YWNrLCBhbmQgaW5zdGVhZCBzdWdnZXN0ZWQgdXNl
cnMgdHVuZSBpdCB1c2luZyBlQlBGIGlmIHRoZXkgcmVhbGx5IG5lZWQgdG8gYnlwYXNzIFRDUCBz
dGFuZGFyZHMuDQo+ID4NCj4gPiBodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMS8xMi8yMi82NTIN
Cj4NCj4gSSB0b3RhbGx5IHVuZGVyc3RhbmQgdGhhdCBMaW51eCB3YW50cyB0byBiZSBjb25zZXJ2
YXRpdmUgYmVmb3JlIG9wZW5pbmcgdXAgdGhlIGdhdGUgYW5kIEknbSBmdWxseSBzdXBwb3J0IG9m
IHRoaXMgaWRlYS4gSSB0aGluayB0aGUgY3VycmVudCBMaW51eCBiZWhhdmlvciBpcyBnb29kIGZv
ciBuZXR3b3JrIHdpdGggbG93IGxhdGVuY3ksIGJ1dCBpbiBhbiBlbnZpcm9ubWVudCB3aXRoIGhp
Z2ggUlRUIChpLmUgMjBtcyksIHRoZSByY3Zfd25kIHJlYWxseSBiZWNvbWVzIHRoZSBib3R0bGVu
ZWNrLiBJdCB0b29rIGFwcHJveGltYXRlbHkgNiAqIFJUVCBvbiBhdmVyYWdlIGZvciA0TWlCIHRy
YW5zZmVyIGV2ZW4gd2l0aCBsYXJnZSBpbml0aWFsIHNuZF9jd25kLiBJIHRoaW5rIGFsbG93aW5n
IGEgbGFyZ2VyIGRlZmF1bHQgcmN2X3duZCB3b3VsZCBncmVhdGx5IHJlZHVjZSB0aGUgbnVtYmVy
IG9mIFJUVCByZXF1aXJlZCBmb3IgdGhlIHRyYW5zZmVyLg0KPg0KPiBGcm9tIG15IHVuZGVyc3Rh
bmRpbmcsIEJQRl9TT0NLX09QU19SV05EX0lOSVQgd2FzIGFkZGVkIHRvIHRoZSBrZXJuZWwgdG8g
YWxsb3cgdGhlIHVzZXJzIHRvIGJ5LXBhc3MgdGhlIGRlZmF1bHQgaWYgdGhleSBjaG9vc2UgdG8u
IFByaW9yIHRvIGtlcm5lbCA0LjE5LCB0aGUgcmN2X3duZCBzZXQgdmlhIEJQRl9TT0NLX09QU19S
V05EX0lOSVQgY291bGQgZXhjZWVkIDY0S2lCIGFuZCB1cCB0byB0aGUgc3BhY2UuIEJ1dCBzaW5j
ZSB0aGVuLCB0aGUgaW5pdGlhbCByd25kIHdvdWxkIGFsd2F5cyBiZSBsaW1pdGVkIHRvIHRoZSA2
NEtpQi4gVGhpcyBwYXRjaCB3b3VsZCBqdXN0IG1ha2UgdGhlIGtlcm5lbCBiZWhhdmUgc2ltaWxh
cmx5IHRvIHRoZSBrZXJuZWwgcHJpb3IgdG8gNC4xOSBpZiByY3Zfd25kIGlzIHNldCBieSBlQlBG
Lg0KPg0KPiBXaGF0IHdvdWxkIHlvdSBzdWdnZXN0IGZvciB0aGUgYXBwbGljYXRpb24gdGhhdCBj
dXJyZW50bHkgcmVsaWVzIG9uIHNldHRpbmcgYSAibGFyZ2VyIiByY3Zfd25kIHZpYSBCUEZfU09D
S19PUFNfUldORF9JTklULCBkbyB5b3UgdGhpbmsgaWYgaXQgaXMgYSBiZXR0ZXIgaWRlYSBpZiB0
aGUgcmN2X3duZCBpcyBzZXQgYWZ0ZXIgdGhlIGNvbm5lY3Rpb24gaXMgZXN0YWJsaXNoZWQuDQoN
Ckkgc3VnZ2VzdCB0aGF0IHlvdSBkbyBub3QgaW50ZXJwcmV0IHRoaW5ncyBhcyAiIEJQRl9TT0NL
X09QU19SV05EX0lOSVQgY291bGQgZXhjZWVkIDY0S2lCIiAgYmVjYXVzZSBpdCBjYW4gbm90Lg0K
DQpJZiB5b3UgcmVhbGx5IG5lZWQgdG8gc2VuZCBtb3JlIHRoYW4gNjRLQiBpbiB0aGUgZmlyc3Qg
UlRULCBUQ1AgaXMgbm90IGEgcHJvcGVyIHByb3RvY29sLg0KDQoxM2QzYjFlYmUyODcgY29tbWl0
IG1lc3NhZ2Ugc2hvdWxkIGhhdmUgYmVlbiB2ZXJ5IGNsZWFyIGFib3V0IHRoZSA2NEsgbGltaXRh
dGlvbi4NCg==
