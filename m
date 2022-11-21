Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7B5632EF6
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbiKUVkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiKUVkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:40:47 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0070658021;
        Mon, 21 Nov 2022 13:40:42 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9DC2A5FD02;
        Tue, 22 Nov 2022 00:40:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669066840;
        bh=tRryVbQl6KgQGxpEtv6lMkjJS3Jo62eFMLJ3MueAy0Y=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=I4wkvg0pE06SWeKX4FEw/OIltRK784RVjYhwGUVSPwV6dZrkk1O6F0tvS+rHeXWvQ
         y4KQGguKQT6VL7DH3rwl/QDFaeFrww7wsi5krxhHnakh3jzlBrt5YFrnOgXImZxMtN
         aJsXk+co/GC0fWOya2qwseQfnrFmQyKzYSX40m1emkBXqE7hGpRmIaiHfXmDbxDqW6
         dU18MgVk6RyZETLw9hHFcUFZnLsDs33GI/CfjVxVnHUJ6+Kz1+ae5LmMRs+EwONtYq
         1FyAmE9xklrP9usvKY9EMO1+yI19DZMW+gympTgdFFiCSnq9rKnQpQ44Ypv+PAqgW6
         7BjnNuWcafbDg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 22 Nov 2022 00:40:39 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 2/3] test/vsock: add big message test
Thread-Topic: [RFC PATCH v1 2/3] test/vsock: add big message test
Thread-Index: AQHY+TQwn9KcvFr2LUmtZTFuocc05q5JTSQAgAAggoCAAFEsAA==
Date:   Mon, 21 Nov 2022 21:40:39 +0000
Message-ID: <749f147b-6112-2e6f-1ebe-05ba2e8a8727@sberdevices.ru>
References: <ba294dff-812a-bfc2-a43c-286f99aee0b8@sberdevices.ru>
 <f0510949-cc97-7a01-5fc8-f7e855b80515@sberdevices.ru>
 <20221121145248.cmscv5vg3fir543x@sgarzare-redhat>
 <ff71c2d3-9f61-d649-7ae5-cd012eada10d@sberdevices.ru>
In-Reply-To: <ff71c2d3-9f61-d649-7ae5-cd012eada10d@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F10D2248CCDE284DAB88571133AEC23A@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/21 18:16:00 #20594967
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEuMTEuMjAyMiAxOTo1MCwgQXJzZW5peSBLcmFzbm92IHdyb3RlOg0KPiBPbiAyMS4xMS4y
MDIyIDE3OjUyLCBTdGVmYW5vIEdhcnphcmVsbGEgd3JvdGU6DQo+PiBPbiBUdWUsIE5vdiAxNSwg
MjAyMiBhdCAwODo1MjozNVBNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6DQo+Pj4gVGhp
cyBhZGRzIHRlc3QgZm9yIHNlbmRpbmcgbWVzc2FnZSwgYmlnZ2VyIHRoYW4gcGVlcidzIGJ1ZmZl
ciBzaXplLg0KPj4+IEZvciBTT0NLX1NFUVBBQ0tFVCBzb2NrZXQgaXQgbXVzdCBmYWlsLCBhcyB0
aGlzIHR5cGUgb2Ygc29ja2V0IGhhcw0KPj4+IG1lc3NhZ2Ugc2l6ZSBsaW1pdC4NCj4+Pg0KPj4+
IFNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1
Pg0KPj4+IC0tLQ0KPj4+IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgNjIgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiAxIGZpbGUgY2hhbmdlZCwgNjIgaW5z
ZXJ0aW9ucygrKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNv
Y2tfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCj4+PiBpbmRleCAx
MDdjMTExNjU4ODcuLmJiNGU4NjU3ZjFkNiAxMDA2NDQNCj4+PiAtLS0gYS90b29scy90ZXN0aW5n
L3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KPj4+ICsrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tf
dGVzdC5jDQo+Pj4gQEAgLTU2MCw2ICs1NjAsNjMgQEAgc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNr
ZXRfdGltZW91dF9zZXJ2ZXIoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCj4+PiDCoMKg
wqDCoGNsb3NlKGZkKTsNCj4+PiB9DQo+Pj4NCj4+PiArc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNr
ZXRfYmlnbXNnX2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KPj4+ICt7DQo+
Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIHNvY2tfYnVmX3NpemU7DQo+Pj4gK8KgwqDCoCBzc2l6
ZV90IHNlbmRfc2l6ZTsNCj4+PiArwqDCoMKgIHNvY2tsZW5fdCBsZW47DQo+Pj4gK8KgwqDCoCB2
b2lkICpkYXRhOw0KPj4+ICvCoMKgwqAgaW50IGZkOw0KPj4+ICsNCj4+PiArwqDCoMKgIGxlbiA9
IHNpemVvZihzb2NrX2J1Zl9zaXplKTsNCj4+PiArDQo+Pj4gK8KgwqDCoCBmZCA9IHZzb2NrX3Nl
cXBhY2tldF9jb25uZWN0KG9wdHMtPnBlZXJfY2lkLCAxMjM0KTsNCj4+DQo+PiBOb3QgZm9yIHRo
aXMgcGF0Y2gsIGJ1dCBzb21lZGF5IHdlIHNob3VsZCBhZGQgYSBtYWNybyBmb3IgdGhpcyBwb3J0
IGFuZCBtYXliZSBldmVuIG1ha2UgaXQgY29uZmlndXJhYmxlIDotKQ0KPj4NCj4+PiArwqDCoMKg
IGlmIChmZCA8IDApIHsNCj4+PiArwqDCoMKgwqDCoMKgwqAgcGVycm9yKCJjb25uZWN0Iik7DQo+
Pj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+PiArwqDCoMKgIH0NCj4+
PiArDQo+Pj4gK8KgwqDCoCBpZiAoZ2V0c29ja29wdChmZCwgQUZfVlNPQ0ssIFNPX1ZNX1NPQ0tF
VFNfQlVGRkVSX1NJWkUsDQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgJnNvY2tf
YnVmX3NpemUsICZsZW4pKSB7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIHBlcnJvcigiZ2V0c29ja29w
dCIpOw0KPj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJTFVSRSk7DQo+Pj4gK8KgwqDC
oCB9DQo+Pj4gKw0KPj4+ICvCoMKgwqAgc29ja19idWZfc2l6ZSsrOw0KPj4+ICsNCj4+PiArwqDC
oMKgIGRhdGEgPSBtYWxsb2Moc29ja19idWZfc2l6ZSk7DQo+Pj4gK8KgwqDCoCBpZiAoIWRhdGEp
IHsNCj4+PiArwqDCoMKgwqDCoMKgwqAgcGVycm9yKCJtYWxsb2MiKTsNCj4+PiArwqDCoMKgwqDC
oMKgwqAgZXhpdChFWElUX0ZBSUxVUkUpOw0KPj4+ICvCoMKgwqAgfQ0KPj4+ICsNCj4+PiArwqDC
oMKgIHNlbmRfc2l6ZSA9IHNlbmQoZmQsIGRhdGEsIHNvY2tfYnVmX3NpemUsIDApOw0KPj4+ICvC
oMKgwqAgaWYgKHNlbmRfc2l6ZSAhPSAtMSkgew0KPj4NCj4+IENhbiB3ZSBjaGVjayBhbHNvIGBl
cnJub2A/DQo+PiBJSVVDIGl0IHNob3VsZCBjb250YWlucyBFTVNHU0laRS4NCkhtLCBzZWVtcyBj
dXJyZW50IGltcGxlbWVudGF0aW9uIGlzIGEgbGl0dGxlIGJpdCBicm9rZW4gYW5kIHJldHVybnMg
RU5PTUVNLCBiZWNhdXNlIGFueSBuZWdhdGl2ZSB2YWx1ZSwgcmV0dXJuZWQgYnkNCnRyYW5zcG9y
dCBjYWxsYmFjayBpcyBhbHdheXMgcmVwbGFjZWQgdG8gRU5PTUVNLiBJIHRoaW5rIGkgbmVlZCB0
aGlzIHBhdGNoIGZyb20gQm9iYnk6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2Q4MTgx
OGI4NjgyMTZjNzc0NjEzZGQwMzY0MWZjZmU2M2NjNTVhNDUuMTY2MDM2MjY2OC5naXQuYm9iYnku
ZXNobGVtYW5AYnl0ZWRhbmNlLmNvbS8NCk1heSBiZSBpIGNhbiBpbmNsdWRlIGl0IHRvIHRoaXMg
cGF0Y2hzZXQgYWxzbyBmaXhpbmcgcmV2aWV3IGNvbW1lbnRzKG9mIGNvdXJzZSBrZWVwaW5nIEJv
YmJ5IGFzIGF1dGhvcikuIE9yIG1vcmUNCnNpbXBsZSB3YXkgaXMgdG8gY2hlY2sgRU5PTUVNIGlu
c3RlYWQgb2YgRU1TR1NJWkUgaW4gdGhpcyB0ZXN0KHNpbXBsZSwgYnV0IGEgbGl0dGxlIGJpdCBk
dW1iIGkgdGhpbmspLg0KPj4NCj4+PiArwqDCoMKgwqDCoMKgwqAgZnByaW50ZihzdGRlcnIsICJl
eHBlY3RlZCAnc2VuZCgyKScgZmFpbHVyZSwgZ290ICV6aVxuIiwNCj4+PiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBzZW5kX3NpemUpOw0KPj4+ICvCoMKgwqAgfQ0KPj4+ICsNCj4+PiArwqDCoMKg
IGNvbnRyb2xfd3JpdGVsbigiQ0xJU0VOVCIpOw0KPj4+ICsNCj4+PiArwqDCoMKgIGZyZWUoZGF0
YSk7DQo+Pj4gK8KgwqDCoCBjbG9zZShmZCk7DQo+Pj4gK30NCj4+PiArDQo+Pj4gK3N0YXRpYyB2
b2lkIHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19zZXJ2ZXIoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAq
b3B0cykNCj4+PiArew0KPj4+ICvCoMKgwqAgaW50IGZkOw0KPj4+ICsNCj4+PiArwqDCoMKgIGZk
ID0gdnNvY2tfc2VxcGFja2V0X2FjY2VwdChWTUFERFJfQ0lEX0FOWSwgMTIzNCwgTlVMTCk7DQo+
Pj4gK8KgwqDCoCBpZiAoZmQgPCAwKSB7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIHBlcnJvcigiYWNj
ZXB0Iik7DQo+Pj4gK8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+PiArwqDC
oMKgIH0NCj4+PiArDQo+Pj4gK8KgwqDCoCBjb250cm9sX2V4cGVjdGxuKCJDTElTRU5UIik7DQo+
Pj4gKw0KPj4+ICvCoMKgwqAgY2xvc2UoZmQpOw0KPj4+ICt9DQo+Pj4gKw0KPj4+ICNkZWZpbmUg
QlVGX1BBVFRFUk5fMSAnYScNCj4+PiAjZGVmaW5lIEJVRl9QQVRURVJOXzIgJ2InDQo+Pj4NCj4+
PiBAQCAtODMyLDYgKzg4OSwxMSBAQCBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0X2Nhc2Vz
W10gPSB7DQo+Pj4gwqDCoMKgwqDCoMKgwqAgLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF90
aW1lb3V0X2NsaWVudCwNCj4+PiDCoMKgwqDCoMKgwqDCoCAucnVuX3NlcnZlciA9IHRlc3Rfc2Vx
cGFja2V0X3RpbWVvdXRfc2VydmVyLA0KPj4+IMKgwqDCoMKgfSwNCj4+PiArwqDCoMKgIHsNCj4+
PiArwqDCoMKgwqDCoMKgwqAgLm5hbWUgPSAiU09DS19TRVFQQUNLRVQgYmlnIG1lc3NhZ2UiLA0K
Pj4+ICvCoMKgwqDCoMKgwqDCoCAucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19j
bGllbnQsDQo+Pj4gK8KgwqDCoMKgwqDCoMKgIC5ydW5fc2VydmVyID0gdGVzdF9zZXFwYWNrZXRf
YmlnbXNnX3NlcnZlciwNCj4+PiArwqDCoMKgIH0sDQo+Pg0KPj4gSSB3b3VsZCBhZGQgbmV3IHRl
c3RzIGFsd2F5cyBhdCB0aGUgZW5kLCBzbyBpZiBzb21lIENJIHVzZXMgLS1za2lwLCB3ZSBkb24n
dCBoYXZlIHRvIHVwZGF0ZSB0aGUgc2NyaXB0cyB0byBza2lwIHNvbWUgdGVzdHMuDQo+IEFjayB0
aGlzIGFuZCBhbGwgYWJvdmUNCj4+DQo+Pj4gwqDCoMKgwqB7DQo+Pj4gwqDCoMKgwqDCoMKgwqAg
Lm5hbWUgPSAiU09DS19TRVFQQUNLRVQgaW52YWxpZCByZWNlaXZlIGJ1ZmZlciIsDQo+Pj4gwqDC
oMKgwqDCoMKgwqAgLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF9pbnZhbGlkX3JlY19idWZm
ZXJfY2xpZW50LA0KPj4+IC0twqANCj4+PiAyLjI1LjENCj4+DQo+IA0KDQo=
