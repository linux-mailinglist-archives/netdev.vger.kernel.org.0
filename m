Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C4E626937
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 12:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiKLLlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 06:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiKLLlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 06:41:19 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47236634B;
        Sat, 12 Nov 2022 03:41:13 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id D565D5FD8A;
        Sat, 12 Nov 2022 14:41:09 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1668253269;
        bh=tEC8qWPcYzh5C+P7qHhW3cPWbhJ7pLhopk4AV/Opjww=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=bA9sARAhl9oZo6driejGSDil7LBmiT1wZ0FRpoJ52dicXUZGVG5cbj5cKUbCMSo+I
         LPW3Ua96wS5wZ2O2DNyF14LdQdtvfj5DGf2p9A2TK184HH402JsJcSLx/oopM1EHXb
         2nc/0ZB+cTepqejzo3qklvcM1LakFzTsbFwj8SvDAdFt3VMF7U+oQdRXOGRev0iFZM
         YaQSIy/S41cu41Z8oLyLVlOaG9VeuhqmF6R1y1T2F9tfDChQORdcFgQhG4hpolKEcR
         paxHyhYfyS0CHz2HnLL1cQ0NHZSksWV4AL3SsEXrixb4QpjBVgEw4rwgjHv/hcA2vA
         vQ4EaA7MsbpUw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat, 12 Nov 2022 14:41:05 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kernel <kernel@sberdevices.ru>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v3 00/11] virtio/vsock: experimental zerocopy receive
Thread-Topic: [RFC PATCH v3 00/11] virtio/vsock: experimental zerocopy receive
Thread-Index: AQHY8hatKKTuchPoekmnGA3HAR0Si645kb6AgAB0yICAAPn8gA==
Date:   Sat, 12 Nov 2022 11:40:59 +0000
Message-ID: <3de0302f-bd4f-5df1-9de5-cbc3b3dd94f8@sberdevices.ru>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <20221111134715.qxgu7t4c7jse24hp@sgarzare-redhat> <Y260WSJKJXtaJQZi@bullseye>
In-Reply-To: <Y260WSJKJXtaJQZi@bullseye>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C62CF393163484A89D015B7E010F57A@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/12 07:44:00 #20572870
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEuMTEuMjAyMiAyMzo0NSwgQm9iYnkgRXNobGVtYW4gd3JvdGU6DQo+IE9uIEZyaSwgTm92
IDExLCAyMDIyIGF0IDAyOjQ3OjE1UE0gKzAxMDAsIFN0ZWZhbm8gR2FyemFyZWxsYSB3cm90ZToN
Cj4+IEhpIEFyc2VuaXksDQo+PiBtYXliZSB3ZSBzaG91bGQgc3RhcnQgcmViYXNpbmcgdGhpcyBz
ZXJpZXMgb24gdGhlIG5ldyBzdXBwb3J0IGZvciBza2J1ZmY6IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2xrbWwvMjAyMjExMTAxNzE3MjMuMjQyNjMtMS1ib2JieS5lc2hsZW1hbkBieXRlZGFuY2Uu
Y29tLw0KPj4NCj4+IENDaW5nIEJvYmJ5IHRvIHNlZSBpZiBpdCdzIGVhc3kgdG8gaW50ZWdyYXRl
IHNpbmNlIHlvdSdyZSBib3RoIGNoYW5naW5nIHRoZQ0KPj4gcGFja2V0IGFsbG9jYXRpb24uDQo+
Pg0KPiANCj4gVGhpcyBsb29rcyBsaWtlIHRoZSBwYWNrZXQgYWxsb2NhdGlvbiBjYW4gYmUgbWFy
cmllZCBzb21ld2hhdCBuaWNlbHkgaW4NCj4gc2luY2UgU0tCcyBtYXkgYmUgYnVpbHQgZnJvbSBw
YWdlcyB1c2luZyBidWlsZF9za2IoKS4gVGhlcmUgbWF5IGJlIHNvbWUNCj4gdHdlYWtpbmcgbmVj
ZXNzYXJ5IHRob3VnaCwgc2luY2UgaXQgYWxzbyB1c2VzIHRoZSB0YWlsIGNodW5rIG9mIHRoZSBw
YWdlDQo+IHRvIGhvbGQgc3RydWN0IHNrYl9zaGFyZWRfaW5mbyBJSVJDLg0KPiANCj4gSSBsZWZ0
IHNvbWUgY29tbWVudHMgb24gdGhlIHBhdGNoIHdpdGggdGhlIGFsbG9jYXRvciBpbiBpdC4NCkhl
bGxvIEJvYmJ5LA0KDQp0aGFua3MgZm9yIHJldmlldy4gSSdsbCByZWJhc2UgbXkgcGF0Y2hzZXQg
b24gWW91ciBza2J1ZmYgc3VwcG9ydC4NCj4gDQo+Pg0KPj4gTWF5YmUgdG8gYXZvaWQgaGF2aW5n
IHRvIHJlYmFzZSBldmVyeXRoaW5nIGxhdGVyLCBpdCdzIGFscmVhZHkgd29ydGh3aGlsZSB0bw0K
Pj4gc3RhcnQgdXNpbmcgQm9iYnkncyBwYXRjaCB3aXRoIHNrYnVmZi4NCj4+DQo+IA0KPiBJJ2xs
IGJlIHdhaXRpbmcgdW50aWwgTW9uZGF5IHRvIHNlZSBpZiBzb21lIG1vcmUgZmVlZGJhY2sgY29t
ZXMgaW4NCj4gYmVmb3JlIHNlbmRpbmcgb3V0IHY0LCBzbyBJIGV4cGVjdCB2NCBlYXJseSBuZXh0
IHdlZWssIEZXSVcuDQpPbmUgcmVxdWVzdCBmcm9tIG1lLCBjb3VsZCBZb3UgcGxlYXNlIENDIG1l
IGZvciBuZXh0IHZlcnNpb25zIG9mDQpZb3VyIHBhdGNoc2V0LCBiZWNhdXNlOg0KMSkgSSdsbCBh
bHdheXMgaGF2ZSBsYXRlc3QgdmVyc2lvbiBvZiBza2J1ZmYgc3VwcG9ydC4NCjIpIEknbGwgc2Vl
IHJldmlldyBwcm9jZXNzIGFsc28uDQoNCk15IGNvbnRhY3RzOg0Kb3hmZmZmYWFAZ21haWwuY29t
DQpBVktyYXNub3ZAc2JlcmRldmljZXMucnUNCg0KVGhhbmtzLCBBcnNlbml5DQoNCj4gDQo+IEJl
c3QsDQo+IEJvYmJ5DQoNCg==
