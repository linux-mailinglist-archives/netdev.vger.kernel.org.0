Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F0A4B3C93
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 18:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbiBMRho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 12:37:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiBMRhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 12:37:43 -0500
Received: from mxo2.dft.dmz.twosigma.com (mxo2.dft.dmz.twosigma.com [208.77.212.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD3E59A6B
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 09:37:37 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mxo2.dft.dmz.twosigma.com (Postfix) with ESMTP id 4JxZLR6xY4z15HG;
        Sun, 13 Feb 2022 17:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=twosigma.com;
        s=202008; t=1644773856;
        bh=tLByhHj8OKVxCrx+wTGjEMCYKdv+OUXDTbmNFyROlCY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=B/P7Ckhype8XkgUx3kG5p4IWWdjMVF1/D+4gbpEOQY74u8VTEK0hhFkfBYtQ3+n2V
         5QzC1NFrkz63w5A1jOWeXO8+CgQAA5z5n4HUfqE0wzk6/T7bbaoXzk2f+IzgAxixcQ
         sjzzjP4/mbdusXYs5U6tVlVWAL/jbFMXpiJDUKezOYQqj5WfNq09AQiQ+UOFnIJYSK
         2NqKWtMJ1PDBRvtuuztvlLqlxZNOqyNlqVpd0uqOPGgv2NvfE/xa8ERi7QMhaPjIYX
         cmBn32UHHhDbHssxTP6aw9gGaYF0JwoqspdMN7BPvl/eVd8SpbEplDHqfGu0hVt7Zy
         jH31SXfWJHFsA==
X-Virus-Scanned: Debian amavisd-new at twosigma.com
Received: from mxo2.dft.dmz.twosigma.com ([127.0.0.1])
        by localhost (mxo2.dft.dmz.twosigma.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id VCNFChGt1gRG; Sun, 13 Feb 2022 17:37:35 +0000 (UTC)
Received: from exmbdft6.ad.twosigma.com (exmbdft6.ad.twosigma.com [172.22.1.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxo2.dft.dmz.twosigma.com (Postfix) with ESMTPS id 4JxZLR4x40z15HF;
        Sun, 13 Feb 2022 17:37:35 +0000 (UTC)
Received: from exmbdft6.ad.twosigma.com (172.22.1.5) by
 exmbdft6.ad.twosigma.com (172.22.1.5) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sun, 13 Feb 2022 17:37:35 +0000
Received: from exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c]) by
 exmbdft6.ad.twosigma.com ([fe80::c47f:175e:9f31:d58c%17]) with mapi id
 15.00.1497.012; Sun, 13 Feb 2022 17:37:35 +0000
From:   Tian Lan <Tian.Lan@twosigma.com>
To:     Eric Dumazet <edumazet@google.com>, Tian Lan <tilan7663@gmail.com>
CC:     netdev <netdev@vger.kernel.org>,
        Andrew Chester <Andrew.Chester@twosigma.com>
Subject: RE: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Topic: [PATCH] tcp: allow the initial receive window to be greater than
 64KiB
Thread-Index: AQHYII8R50vJ9luEckWkqpgQGqAi+KyQ4b2AgADavqA=
Date:   Sun, 13 Feb 2022 17:37:35 +0000
Message-ID: <101663cb4d7d43e9b6bfa946f6b8036b@exmbdft6.ad.twosigma.com>
References: <20220213040545.365600-1-tilan7663@gmail.com>
 <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
In-Reply-To: <CANn89i+=wXy-UFTy1a+1gaVgmynQ9u4LiAutFBf=dsE2fgF3rA@mail.gmail.com>
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

PiBUaGUgb25seSB3YXkgYSBzZW5kZXIgY291bGQgdXNlIHlvdXIgYmlnZ2VyIHdpbmRvdyB3b3Vs
ZCBiZSB0byB2aW9sYXRlIFRDUCBzcGVjcyBhbmQgc2VuZCBtb3JlIHRoYW4gPiA2NEtCIGluIHRo
ZSBmaXJzdCBSVFQsIGFzc3VtaW5nIHRoZSByZWNlaXZlciBoYXMgaW4gZmFjdCBhIFJXSU4gYmln
Z2VyIHRoYW4gNjRLID8/Pz8NCg0KSnVzdCB3YW50IHRvIGNsYXJpZnksIHRoZSBpbnRlbnQgb2Yg
dGhpcyBwYXRjaCBpcyBub3QgdHJ5aW5nIHRvIHZpb2xhdGUgdGhlIFRDUCBwcm90b2NvbC4gVGhl
IGdvYWwgaXMgdG8gYWxsb3cgdGhlIHJlY2VpdmVyIGFkdmVydGlzZSBhIG11Y2ggImxhcmdlciIg
cmN2X3duZCBvbmNlIHRoZSBjb25uZWN0aW9uIGlzIGVzdGFibGlzaGVkLiBTbyBpbnN0ZWFkIG9m
IGhhdmluZyB0aGUgcmVjZWl2ZXIgZ3JvdyB0aGUgcmN2X3duZCBzdGFydGluZyB3aXRoIDY0S2lC
LCB0aGUgcmVjZWl2ZXIgY291bGQgYWR2ZXJ0aXNlIHRoZSBuZXcgcmN2X3duZCBiYXNlZCBvbiBh
IG11Y2ggbGFyZ2VyIGluaXRpYWwgd2luZG93LiANCg0KU29ycnkgZm9yIHRoZSBjb25mdXNpb24s
IGhhcHB5IHRvIGNoYXQgbW9yZSBpZiB5b3UgaGF2ZSBxdWVzdGlvbnMgb3IgY29uY2VybnMuIA0K
DQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogRXJpYyBEdW1hemV0IDxlZHVtYXpl
dEBnb29nbGUuY29tPiANClNlbnQ6IFNhdHVyZGF5LCBGZWJydWFyeSAxMiwgMjAyMiAxMToyMyBQ
TQ0KVG86IFRpYW4gTGFuIDx0aWxhbjc2NjNAZ21haWwuY29tPg0KQ2M6IG5ldGRldiA8bmV0ZGV2
QHZnZXIua2VybmVsLm9yZz47IEFuZHJldyBDaGVzdGVyIDxBbmRyZXcuQ2hlc3RlckB0d29zaWdt
YS5jb20+OyBUaWFuIExhbiA8VGlhbi5MYW5AdHdvc2lnbWEuY29tPg0KU3ViamVjdDogUmU6IFtQ
QVRDSF0gdGNwOiBhbGxvdyB0aGUgaW5pdGlhbCByZWNlaXZlIHdpbmRvdyB0byBiZSBncmVhdGVy
IHRoYW4gNjRLaUINCg0KT24gU2F0LCBGZWIgMTIsIDIwMjIgYXQgODowNiBQTSBUaWFuIExhbiA8
dGlsYW43NjYzQGdtYWlsLmNvbT4gd3JvdGU6DQo+DQo+IEZyb206IFRpYW4gTGFuIDxUaWFuLkxh
bkB0d29zaWdtYS5jb20+DQo+DQo+IENvbW1pdCAxM2QzYjFlYmUyODcgKCJicGY6IFN1cHBvcnQg
Zm9yIHNldHRpbmcgaW5pdGlhbCByZWNlaXZlIA0KPiB3aW5kb3ciKSBpbnRyb2R1Y2VkIGEgQlBG
X1NPQ0tfT1BTIG9wdGlvbiB3aGljaCBhbGxvd3Mgc2V0dGluZyBhIA0KPiBsYXJnZXIgdmFsdWUg
Zm9yIHRoZSBpbml0aWFsIGFkdmVydGlzZWQgcmVjZWl2ZSB3aW5kb3cgdXAgdG8gdGhlIA0KPiBy
ZWNlaXZlIGJ1ZmZlciBzcGFjZSBmb3IgYm90aCBhY3RpdmUgYW5kIHBhc3NpdmUgVENQIGNvbm5l
Y3Rpb25zLg0KPg0KPiBIb3dldmVyLCB0aGUgY29tbWl0IGEzMzc1MzFiOTQyYiAoInRjcDogdXAg
aW5pdGlhbCBybWVtIHRvIDEyOEtCIGFuZCANCj4gU1lOIHJ3aW4gdG8gYXJvdW5kIDY0S0IiKSB3
b3VsZCBsaW1pdCB0aGUgaW5pdGlhbCByZWNlaXZlIHdpbmRvdyB0byBiZSANCj4gYXQgbW9zdCA2
NEtpQiB3aGljaCBwYXJ0aWFsbHkgbmVnYXRlcyB0aGUgY2hhbmdlIG1hZGUgcHJldmlvdXNseS4N
Cj4NCj4gV2l0aCB0aGlzIHBhdGNoLCB0aGUgaW5pdGlhbCByZWNlaXZlIHdpbmRvdyB3aWxsIGJl
IHNldCB0byB0aGUgDQo+IG1pbig2NEtpQiwgc3BhY2UpIGlmIHRoZXJlIGlzIG5vIGluaXRfcmN2
X3duZCBwcm92aWRlZC4gRWxzZSBzZXQgdGhlIA0KPiBpbml0aWFsIHJlY2VpdmUgd2luZG93IHRv
IGJlIHRoZSBtaW4oaW5pdF9yY3Zfd25kICogbXNzLCBzcGFjZSkuDQoNCg0KSSBkbyBub3Qgc2Vl
IGhvdyBwcmV0ZW5kaW5nIHRvIGhhdmUgYSBsYXJnZSByY3Z3aW4gaXMgZ29pbmcgdG8gaGVscCBm
b3IgcGFzc2l2ZSBjb25uZWN0aW9ucywgZ2l2ZW4gdGhlIFdJTiBpbiBTWU4gYW5kIFNZTkFDSyBw
YWNrZXQgaXMgbm90IHNjYWxlZC4NCg0KU28gdGhpcyBwYXRjaCBJIHRoaW5rIGlzIG1pc2xlYWRp
bmcuIEdldCBvdmVyIGl0LCBUQ1AgaGFzIG5vdCBiZWVuIGRlc2lnbmVkIHRvIGFubm91bmNlIG1v
cmUgdGhhbiA2NEtCIGluIHRoZSAzV0hTLg0KDQpUaGUgb25seSB3YXkgYSBzZW5kZXIgY291bGQg
dXNlIHlvdXIgYmlnZ2VyIHdpbmRvdyB3b3VsZCBiZSB0byB2aW9sYXRlIFRDUCBzcGVjcyBhbmQg
c2VuZCBtb3JlIHRoYW4gNjRLQiBpbiB0aGUgZmlyc3QgUlRULCBhc3N1bWluZyB0aGUgcmVjZWl2
ZXIgaGFzIGluIGZhY3QgYSBSV0lOIGJpZ2dlciB0aGFuIDY0SyA/Pz8/DQo=
