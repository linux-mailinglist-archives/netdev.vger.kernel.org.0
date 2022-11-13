Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5F2626ED9
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 11:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiKMKEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 05:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiKMKEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 05:04:45 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D375F40;
        Sun, 13 Nov 2022 02:04:42 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id DD2D25FD20;
        Sun, 13 Nov 2022 13:04:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1668333878;
        bh=9rOROH2iebzLRkDA8NLvRPT2sy7/Kmmx1bzHXtL+1do=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=CdMPwgCnQ/YOIoUpFWj/vOdlIPUHT83RZeDLR+6+fiWC6UTjrd7O9juBsfMj9e0me
         7VLWg5lVcdm5NUmpSK6Bf6MtskHPskZ+y/WreimzhPEhxWsVq7Dy17NiwXTN2jQ79g
         i2XtYSCyNWt34uM4p98xcryCiP5Qy/jbF1/mCJSOCkUgAT38ZJIaxqOn627PAWDPjR
         22DPApo4qdRpNjhH3qVZEmDU5/fwv7zfL149APKERzBriqmtzYVzlS8Hyj4fLCjzLG
         mB473yJznuFEiJonTvTlrXUeZj1zY8sYLS8Sobysk0v7Tv1rs/OE7u2bOmx2/oLYzZ
         znz1ygF9I43Bw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 13 Nov 2022 13:04:36 +0300 (MSK)
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
Thread-Index: AQHY8hatKKTuchPoekmnGA3HAR0Si645kb6AgAB0yICAAPn8gIABd2GA
Date:   Sun, 13 Nov 2022 10:04:22 +0000
Message-ID: <d4c3afcc-e8f3-d81c-597a-5311280e8e51@sberdevices.ru>
References: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
 <20221111134715.qxgu7t4c7jse24hp@sgarzare-redhat> <Y260WSJKJXtaJQZi@bullseye>
 <3de0302f-bd4f-5df1-9de5-cbc3b3dd94f8@sberdevices.ru>
In-Reply-To: <3de0302f-bd4f-5df1-9de5-cbc3b3dd94f8@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAE0D643183BAB419460FB3C6014DF3C@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/13 04:55:00 #20572880
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIuMTEuMjAyMiAxNDo0MCwgQXJzZW5peSBLcmFzbm92IHdyb3RlOg0KDQpIZWxsbyBhZ2Fp
biBCb2JieSwNCg0KaSB3YXNuJ3QgQ0NlZCBpbiBZb3VyIHBhdGNoc2V0LCBidXQgSSByZXZpZXcg
aXQgYW55d2F5IGFuZCB3cml0ZSBjb21tZW50cyBoZXJlIGluIHRoaXMNCm1hbm5lcjopIEkgZm91
bmQgc3RyYW5nZSB0aGluZzoNCg0KSW4gJ3ZpcnRpb190cmFuc3BvcnRfcmVjdl9lbnF1ZXVlKCkn
IG5ldyBwYWNrZXQgY291bGQgYmUgY29waWVkIHRvIHRoZSBsYXN0IHBhY2tldCBpbg0KcnggcXVl
dWUoc2tiIGluIGN1cnJlbnQgdmVyc2lvbikuIER1cmluZyBjb3B5IFlvdSB1cGRhdGUgbGFzdCBz
a2IgbGVuZ3RoIGJ5IGNhbGwNCidza2JfcHV0KGxhc3Rfc2tiLCBza2ItPmxlbiknIGluc2lkZSAn
bWVtY3B5KCknLiBTbyAnbGFzdF9za2InIG5vdyBoYXZlIG5ldyBsZW5ndGgsDQpidXQgaGVhZGVy
IG9mIHBhY2tldCBpcyBub3QgdXBkYXRlZC4NCg0KTm93IGxldCdzIGxvb2sgdG8gJ3ZpcnRpb190
cmFuc3BvcnRfc2VxcGFja2V0X2RvX2RlcXVldWUoKScsIGl0IHVzZXMgdmFsdWUgZnJvbSBwYWNr
ZXQncw0KaGVhZGVyIGFzICdwa3RfbGVuJywgbm90IGZyb20gc2tiOg0KDQpwa3RfbGVuID0gKHNp
emVfdClsZTMyX3RvX2NwdShoZHItPmxlbik7DQoNCkkgdGhpbmsgd2UgbmVlZCB0byB1cGRhdGUg
bGFzdCBwYWNrZXQncyBoZWFkZXIgZHVyaW5nIG1lcmdpbmcgbmV3IHBhY2tldCB0byBsYXN0IHBh
Y2tldA0Kb2YgcnggcXVldWUuDQoNClRoYW5rcywgQXJzZW5peQ0KDQoNCj4gT24gMTEuMTEuMjAy
MiAyMzo0NSwgQm9iYnkgRXNobGVtYW4gd3JvdGU6DQo+PiBPbiBGcmksIE5vdiAxMSwgMjAyMiBh
dCAwMjo0NzoxNVBNICswMTAwLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+Pj4gSGkgQXJz
ZW5peSwNCj4+PiBtYXliZSB3ZSBzaG91bGQgc3RhcnQgcmViYXNpbmcgdGhpcyBzZXJpZXMgb24g
dGhlIG5ldyBzdXBwb3J0IGZvciBza2J1ZmY6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwv
MjAyMjExMTAxNzE3MjMuMjQyNjMtMS1ib2JieS5lc2hsZW1hbkBieXRlZGFuY2UuY29tLw0KPj4+
DQo+Pj4gQ0NpbmcgQm9iYnkgdG8gc2VlIGlmIGl0J3MgZWFzeSB0byBpbnRlZ3JhdGUgc2luY2Ug
eW91J3JlIGJvdGggY2hhbmdpbmcgdGhlDQo+Pj4gcGFja2V0IGFsbG9jYXRpb24uDQo+Pj4NCj4+
DQo+PiBUaGlzIGxvb2tzIGxpa2UgdGhlIHBhY2tldCBhbGxvY2F0aW9uIGNhbiBiZSBtYXJyaWVk
IHNvbWV3aGF0IG5pY2VseSBpbg0KPj4gc2luY2UgU0tCcyBtYXkgYmUgYnVpbHQgZnJvbSBwYWdl
cyB1c2luZyBidWlsZF9za2IoKS4gVGhlcmUgbWF5IGJlIHNvbWUNCj4+IHR3ZWFraW5nIG5lY2Vz
c2FyeSB0aG91Z2gsIHNpbmNlIGl0IGFsc28gdXNlcyB0aGUgdGFpbCBjaHVuayBvZiB0aGUgcGFn
ZQ0KPj4gdG8gaG9sZCBzdHJ1Y3Qgc2tiX3NoYXJlZF9pbmZvIElJUkMuDQo+Pg0KPj4gSSBsZWZ0
IHNvbWUgY29tbWVudHMgb24gdGhlIHBhdGNoIHdpdGggdGhlIGFsbG9jYXRvciBpbiBpdC4NCj4g
SGVsbG8gQm9iYnksDQo+IA0KPiB0aGFua3MgZm9yIHJldmlldy4gSSdsbCByZWJhc2UgbXkgcGF0
Y2hzZXQgb24gWW91ciBza2J1ZmYgc3VwcG9ydC4NCj4+DQo+Pj4NCj4+PiBNYXliZSB0byBhdm9p
ZCBoYXZpbmcgdG8gcmViYXNlIGV2ZXJ5dGhpbmcgbGF0ZXIsIGl0J3MgYWxyZWFkeSB3b3J0aHdo
aWxlIHRvDQo+Pj4gc3RhcnQgdXNpbmcgQm9iYnkncyBwYXRjaCB3aXRoIHNrYnVmZi4NCj4+Pg0K
Pj4NCj4+IEknbGwgYmUgd2FpdGluZyB1bnRpbCBNb25kYXkgdG8gc2VlIGlmIHNvbWUgbW9yZSBm
ZWVkYmFjayBjb21lcyBpbg0KPj4gYmVmb3JlIHNlbmRpbmcgb3V0IHY0LCBzbyBJIGV4cGVjdCB2
NCBlYXJseSBuZXh0IHdlZWssIEZXSVcuDQo+IE9uZSByZXF1ZXN0IGZyb20gbWUsIGNvdWxkIFlv
dSBwbGVhc2UgQ0MgbWUgZm9yIG5leHQgdmVyc2lvbnMgb2YNCj4gWW91ciBwYXRjaHNldCwgYmVj
YXVzZToNCj4gMSkgSSdsbCBhbHdheXMgaGF2ZSBsYXRlc3QgdmVyc2lvbiBvZiBza2J1ZmYgc3Vw
cG9ydC4NCj4gMikgSSdsbCBzZWUgcmV2aWV3IHByb2Nlc3MgYWxzby4NCj4gDQo+IE15IGNvbnRh
Y3RzOg0KPiBveGZmZmZhYUBnbWFpbC5jb20NCj4gQVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1DQo+
IA0KPiBUaGFua3MsIEFyc2VuaXkNCj4gDQo+Pg0KPj4gQmVzdCwNCj4+IEJvYmJ5DQo+IA0KDQo=
