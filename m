Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27F058C352
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 08:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiHHGbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 02:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiHHGbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 02:31:32 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A761BCBA;
        Sun,  7 Aug 2022 23:31:28 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 463005FD04;
        Mon,  8 Aug 2022 09:31:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1659940284;
        bh=IjKJpx3bmBabF6bKC/I/OqMndOebQIAA5aw0VvYd9ZQ=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=AUrQdSs6DQ8UdZb02KAq+95S+2eZlEg9avlZHf18KO3uXS0NoeCE3KPNuw8hM8ekG
         Bnno3pn6vDb31/uHLgusz8wI/2Jw8mM8eH48LOXTMsk3Z2aULSKiRQoa5gkK/pc3kH
         7y6pgIhTK4MCiKMuNqHSOdcSxSnFZHvnXioTf1Q9ph/oebnaf+tHrz5Zt2EzUEOZvA
         1KuGHgcXV2p8Z1KgLQN92xly+0Cq6ti5Z2HmE+vcZ37HYFFRyqh6JU5rtf8JMMIBMs
         K1owIwZgVrI+SpvZ5gOTinQ7FFKxYxFJIPEjce+Quwf0lVFsPkvEKXZXLEbNo4bkq9
         TShpNmr3ylRvw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Mon,  8 Aug 2022 09:31:19 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        "VMware PV-Drivers Reviewers" <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Topic: [RFC PATCH v3 0/9] vsock: updates for SO_RCVLOWAT handling
Thread-Index: AQHYpz+pcvNrW+Wes06KlvYKyF5H+a2gSZIAgAQWkgA=
Date:   Mon, 8 Aug 2022 06:30:31 +0000
Message-ID: <6f32ea12-f209-d921-ce1b-efa7c74a4f63@sberdevices.ru>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <20220805160528.4jzyrjppdftrvdr5@sgarzare-redhat>
In-Reply-To: <20220805160528.4jzyrjppdftrvdr5@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2120B128FC9C64C8E0D6F3918815143@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/08 03:38:00 #20075575
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDUuMDguMjAyMiAxOTowNSwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBIaSBBcnNl
bml5LA0KPiBzb3JyeSBidXQgSSBkaWRuJ3QgaGF2ZSB0aW1lIHRvIHJldmlldyB0aGlzIHNlcmll
cy4gSSB3aWxsIGRlZmluaXRlbHkgZG8gaXQgbmV4dCBNb25kYXkhDQo+IA0KPiBIYXZlIGEgbmlj
ZSB3ZWVrZW5kLA0KPiBTdGVmYW5vDQpIZWxsbywNCm5vIHByb2JsZW0NCg0KVGhhbmsgWW91DQo+
IA0KPiBPbiBXZWQsIEF1ZyAwMywgMjAyMiBhdCAwMTo0ODowNlBNICswMDAwLCBBcnNlbml5IEty
YXNub3Ygd3JvdGU6DQo+PiBIZWxsbywNCj4+DQo+PiBUaGlzIHBhdGNoc2V0IGluY2x1ZGVzIHNv
bWUgdXBkYXRlcyBmb3IgU09fUkNWTE9XQVQ6DQo+Pg0KPj4gMSkgYWZfdnNvY2s6DQo+PiDCoCBE
dXJpbmcgbXkgZXhwZXJpbWVudHMgd2l0aCB6ZXJvY29weSByZWNlaXZlLCBpIGZvdW5kLCB0aGF0
IGluIHNvbWUNCj4+IMKgIGNhc2VzLCBwb2xsKCkgaW1wbGVtZW50YXRpb24gdmlvbGF0ZXMgUE9T
SVg6IHdoZW4gc29ja2V0IGhhcyBub24tDQo+PiDCoCBkZWZhdWx0IFNPX1JDVkxPV0FUKGUuZy4g
bm90IDEpLCBwb2xsKCkgd2lsbCBhbHdheXMgc2V0IFBPTExJTiBhbmQNCj4+IMKgIFBPTExSRE5P
Uk0gYml0cyBpbiAncmV2ZW50cycgZXZlbiBudW1iZXIgb2YgYnl0ZXMgYXZhaWxhYmxlIHRvIHJl
YWQNCj4+IMKgIG9uIHNvY2tldCBpcyBzbWFsbGVyIHRoYW4gU09fUkNWTE9XQVQgdmFsdWUuIElu
IHRoaXMgY2FzZSx1c2VyIHNlZXMNCj4+IMKgIFBPTExJTiBmbGFnIGFuZCB0aGVuIHRyaWVzIHRv
IHJlYWQgZGF0YShmb3IgZXhhbXBsZSB1c2luZ8KgICdyZWFkKCknDQo+PiDCoCBjYWxsKSwgYnV0
IHJlYWQgY2FsbCB3aWxsIGJlIGJsb2NrZWQsIGJlY2F1c2XCoCBTT19SQ1ZMT1dBVCBsb2dpYyBp
cw0KPj4gwqAgc3VwcG9ydGVkIGluIGRlcXVldWUgbG9vcCBpbiBhZl92c29jay5jLiBCdXQgdGhl
IHNhbWUgdGltZSzCoCBQT1NJWA0KPj4gwqAgcmVxdWlyZXMgdGhhdDoNCj4+DQo+PiDCoCAiUE9M
TElOwqDCoMKgwqAgRGF0YSBvdGhlciB0aGFuIGhpZ2gtcHJpb3JpdHkgZGF0YSBtYXkgYmUgcmVh
ZCB3aXRob3V0DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBibG9ja2luZy4NCj4+IMKg
wqAgUE9MTFJETk9STSBOb3JtYWwgZGF0YSBtYXkgYmUgcmVhZCB3aXRob3V0IGJsb2NraW5nLiIN
Cj4+DQo+PiDCoCBTZWUgaHR0cHM6Ly93d3cub3Blbi1zdGQub3JnL2p0YzEvc2MyMi9vcGVuL240
MjE3LnBkZiwgcGFnZSAyOTMuDQo+Pg0KPj4gwqAgU28sIHdlIGhhdmUsIHRoYXQgcG9sbCgpIHN5
c2NhbGwgcmV0dXJucyBQT0xMSU4sIGJ1dCByZWFkIGNhbGwgd2lsbA0KPj4gwqAgYmUgYmxvY2tl
ZC4NCj4+DQo+PiDCoCBBbHNvIGluIG1hbiBwYWdlIHNvY2tldCg3KSBpIGZvdW5kIHRoYXQ6DQo+
Pg0KPj4gwqAgIlNpbmNlIExpbnV4IDIuNi4yOCwgc2VsZWN0KDIpLCBwb2xsKDIpLCBhbmQgZXBv
bGwoNykgaW5kaWNhdGUgYQ0KPj4gwqAgc29ja2V0IGFzIHJlYWRhYmxlIG9ubHkgaWYgYXQgbGVh
c3QgU09fUkNWTE9XQVQgYnl0ZXMgYXJlIGF2YWlsYWJsZS4iDQo+Pg0KPj4gwqAgSSBjaGVja2Vk
IFRDUCBjYWxsYmFjayBmb3IgcG9sbCgpKG5ldC9pcHY0L3RjcC5jLCB0Y3BfcG9sbCgpKSwgaXQN
Cj4+IMKgIHVzZXMgU09fUkNWTE9XQVQgdmFsdWUgdG8gc2V0IFBPTExJTiBiaXQsIGFsc28gaSd2
ZSB0ZXN0ZWQgVENQIHdpdGgNCj4+IMKgIHRoaXMgY2FzZSBmb3IgVENQIHNvY2tldCwgaXQgd29y
a3MgYXMgUE9TSVggcmVxdWlyZWQuDQo+Pg0KPj4gwqAgSSd2ZSBhZGRlZCBzb21lIGZpeGVzIHRv
IGFmX3Zzb2NrLmMgYW5kIHZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMsDQo+PiDCoCB0ZXN0IGlz
IGFsc28gaW1wbGVtZW50ZWQuDQo+Pg0KPj4gMikgdmlydGlvL3Zzb2NrOg0KPj4gwqAgSXQgYWRk
cyBzb21lIG9wdGltaXphdGlvbiB0byB3YWtlIHVwcywgd2hlbiBuZXcgZGF0YSBhcnJpdmVkLiBO
b3csDQo+PiDCoCBTT19SQ1ZMT1dBVCBpcyBjb25zaWRlcmVkIGJlZm9yZSB3YWtlIHVwIHNsZWVw
ZXJzIHdobyB3YWl0IG5ldyBkYXRhLg0KPj4gwqAgVGhlcmUgaXMgbm8gc2Vuc2UsIHRvIGtpY2sg
d2FpdGVyLCB3aGVuIG51bWJlciBvZiBhdmFpbGFibGUgYnl0ZXMNCj4+IMKgIGluIHNvY2tldCdz
IHF1ZXVlIDwgU09fUkNWTE9XQVQsIGJlY2F1c2UgaWYgd2Ugd2FrZSB1cCByZWFkZXIgaW4NCj4+
IMKgIHRoaXMgY2FzZSwgaXQgd2lsbCB3YWl0IGZvciBTT19SQ1ZMT1dBVCBkYXRhIGFueXdheSBk
dXJpbmcgZGVxdWV1ZSwNCj4+IMKgIG9yIGluIHBvbGwoKSBjYXNlLCBQT0xMSU4vUE9MTFJETk9S
TSBiaXRzIHdvbid0IGJlIHNldCwgc28gc3VjaA0KPj4gwqAgZXhpdCBmcm9tIHBvbGwoKSB3aWxs
IGJlICJzcHVyaW91cyIuIFRoaXMgbG9naWMgaXMgYWxzbyB1c2VkIGluIFRDUA0KPj4gwqAgc29j
a2V0cy4NCj4+DQo+PiAzKSB2bWNpL3Zzb2NrOg0KPj4gwqAgU2FtZSBhcyAyKSwgYnV0IGknbSBu
b3Qgc3VyZSBhYm91dCB0aGlzIGNoYW5nZXMuIFdpbGwgYmUgdmVyeSBnb29kLA0KPj4gwqAgdG8g
Z2V0IGNvbW1lbnRzIGZyb20gc29tZW9uZSB3aG8ga25vd3MgdGhpcyBjb2RlLg0KPj4NCj4+IDQp
IEh5cGVyLVY6DQo+PiDCoCBBcyBEZXh1YW4gQ3VpIG1lbnRpb25lZCwgZm9yIEh5cGVyLVYgdHJh
bnNwb3J0IGl0IGlzIGRpZmZpY3VsdCB0bw0KPj4gwqAgc3VwcG9ydCBTT19SQ1ZMT1dBVCwgc28g
aGUgc3VnZ2VzdGVkIHRvIGRpc2FibGUgdGhpcyBmZWF0dXJlIGZvcg0KPj4gwqAgSHlwZXItVi4N
Cj4+DQo+PiBUaGFuayBZb3UNCj4+DQo+PiBBcnNlbml5IEtyYXNub3YoOSk6DQo+PiB2c29jazog
U09fUkNWTE9XQVQgdHJhbnNwb3J0IHNldCBjYWxsYmFjaw0KPj4gaHZfc29jazogZGlzYWJsZSBT
T19SQ1ZMT1dBVCBzdXBwb3J0DQo+PiB2aXJ0aW8vdnNvY2s6IHVzZSAndGFyZ2V0JyBpbiBub3Rp
ZnlfcG9sbF9pbiBjYWxsYmFjaw0KPj4gdm1jaS92c29jazogdXNlICd0YXJnZXQnIGluIG5vdGlm
eV9wb2xsX2luIGNhbGxiYWNrDQo+PiB2c29jazogcGFzcyBzb2NrX3Jjdmxvd2F0IHRvIG5vdGlm
eV9wb2xsX2luIGFzIHRhcmdldA0KPj4gdnNvY2s6IGFkZCBBUEkgY2FsbCBmb3IgZGF0YSByZWFk
eQ0KPj4gdmlydGlvL3Zzb2NrOiBjaGVjayBTT19SQ1ZMT1dBVCBiZWZvcmUgd2FrZSB1cCByZWFk
ZXINCj4+IHZtY2kvdnNvY2s6IGNoZWNrIFNPX1JDVkxPV0FUIGJlZm9yZSB3YWtlIHVwIHJlYWRl
cg0KPj4gdnNvY2tfdGVzdDogUE9MTElOICsgU09fUkNWTE9XQVQgdGVzdA0KPj4NCj4+IGluY2x1
ZGUvbmV0L2FmX3Zzb2NrLmjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB8wqDCoCAyICsNCj4+IG5ldC92bXdfdnNvY2svYWZfdnNvY2suY8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDM4ICsrKysrKysrKy0NCj4+IG5ldC92bXdf
dnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDcg
KysNCj4+IG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uY8KgwqDCoMKgwqAg
fMKgwqAgNyArLQ0KPj4gbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuY8KgwqDC
oMKgwqDCoMKgIHzCoCAxMCArLS0NCj4+IG5ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90
aWZ5X3FzdGF0ZS5jIHzCoCAxMiArLS0NCj4+IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVz
dC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTA3ICsrKysrKysrKysrKysrKysrKysrKysr
KysrKw0KPj4gNyBmaWxlcyBjaGFuZ2VkLCAxNjYgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25z
KC0pDQo+Pg0KPj4gQ2hhbmdlbG9nOg0KPj4NCj4+IHYxIC0+IHYyOg0KPj4gMSkgUGF0Y2hlcyBm
b3IgVk1DSSB0cmFuc3BvcnQoc2FtZSBhcyBmb3IgdmlydGlvLXZzb2NrKS4NCj4+IDIpIFBhdGNo
ZXMgZm9yIEh5cGVyLVYgdHJhbnNwb3J0KGRpc2FibGluZyBTT19SQ1ZMT1dBVCBzZXR0aW5nKS4N
Cj4+IDMpIFdhaXRpbmcgbG9naWMgaW4gdGVzdCB3YXMgdXBkYXRlZChzbGVlcCgpIC0+IHBvbGwo
KSkuDQo+Pg0KPj4gdjIgLT4gdjM6DQo+PiAxKSBQYXRjaGVzIHdlcmUgcmVvcmRlcmVkLg0KPj4g
MikgQ29tbWl0IG1lc3NhZ2UgdXBkYXRlZCBpbiAwMDA1Lg0KPj4gMykgQ2hlY2sgJ3RyYW5zcG9y
dCcgcG9pbnRlciBpbiAwMDAxIGZvciBOVUxMLg0KPj4gNCkgQ2hlY2sgJ3ZhbHVlJyBpbiAwMDAx
IGZvciA+IGJ1ZmZlcl9zaXplLg0KPj4NCj4+IC0twqANCj4+IDIuMjUuMQ0KPiANCg0K
