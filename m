Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21B76365D5
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbiKWQ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbiKWQ3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:29:13 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43EFCDFC1;
        Wed, 23 Nov 2022 08:28:42 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 91B795FD23;
        Wed, 23 Nov 2022 19:28:39 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669220919;
        bh=f5JI1siaEEB1ZcOYtwYHKv3hQLSwTWJy5kMUnsSeKSg=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=nyhnRFM6Tb27Uayxx474YP/jY7GfCGGcNhqfZ5eJ31HcZZOjdE0mOKQ802sbZE4Iq
         dViJV0KwcziTz1g/ozgY/bHGJD/M6bZpjEm4ihDvzvyPj35qHbG6D+8DTpCuPKrjNn
         BAh7clZsJmliwiX30TZEmPojCzvvK16X5CNjCcIocXMNPRsaUfFeqevc2yK0Z6NZEO
         yUhYN5FUOAKZEWvt6OnN1V6wIXPIe/7BtkRUVYG6Ut8z5UaLPOZtWszklRkywwkW6g
         DIqhNS+wwqrNhb09dNhusGnCX3raVspPGRFJ0LV7gop5gxzLUGNtR2hIxXc7w8p4Gh
         6IXhzxQpGzRdg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Wed, 23 Nov 2022 19:28:37 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v1 2/3] test/vsock: add big message test
Thread-Topic: [RFC PATCH v1 2/3] test/vsock: add big message test
Thread-Index: AQHY+TQwn9KcvFr2LUmtZTFuocc05q5JTSQAgAAggoCAAFEsAIACuyOAgAAFSICAAA0LAA==
Date:   Wed, 23 Nov 2022 16:28:36 +0000
Message-ID: <c21f2541-2d81-3259-7a7a-9211c6f7d374@sberdevices.ru>
References: <ba294dff-812a-bfc2-a43c-286f99aee0b8@sberdevices.ru>
 <f0510949-cc97-7a01-5fc8-f7e855b80515@sberdevices.ru>
 <20221121145248.cmscv5vg3fir543x@sgarzare-redhat>
 <ff71c2d3-9f61-d649-7ae5-cd012eada10d@sberdevices.ru>
 <749f147b-6112-2e6f-1ebe-05ba2e8a8727@sberdevices.ru>
 <20221123152159.xbqhsslrhh4ymbnn@sgarzare-redhat>
 <CAKB00G0vcy3EkoouzTsZ8OYZ7hJRFxQ4ThUm4f0ALVs6maFd2g@mail.gmail.com>
In-Reply-To: <CAKB00G0vcy3EkoouzTsZ8OYZ7hJRFxQ4ThUm4f0ALVs6maFd2g@mail.gmail.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <46401EE83984154AA8BCDD53FD0AB495@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/23 11:33:00 #20600357
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjMuMTEuMjAyMiAxODo0MCwgQm9iYnkgRXNobGVtYW4gd3JvdGU6DQo+IE9uIFdlZCwgTm92
IDIzLCAyMDIyIGF0IDc6MjIgQU0gU3RlZmFubyBHYXJ6YXJlbGxhIDxzZ2FyemFyZUByZWRoYXQu
Y29tPg0KPiB3cm90ZToNCj4gDQo+PiBPbiBNb24sIE5vdiAyMSwgMjAyMiBhdCAwOTo0MDozOVBN
ICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6DQo+Pj4gT24gMjEuMTEuMjAyMiAxOTo1MCwg
QXJzZW5peSBLcmFzbm92IHdyb3RlOg0KPj4+PiBPbiAyMS4xMS4yMDIyIDE3OjUyLCBTdGVmYW5v
IEdhcnphcmVsbGEgd3JvdGU6DQo+Pj4+PiBPbiBUdWUsIE5vdiAxNSwgMjAyMiBhdCAwODo1Mjoz
NVBNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6DQo+Pj4+Pj4gVGhpcyBhZGRzIHRlc3Qg
Zm9yIHNlbmRpbmcgbWVzc2FnZSwgYmlnZ2VyIHRoYW4gcGVlcidzIGJ1ZmZlciBzaXplLg0KPj4+
Pj4+IEZvciBTT0NLX1NFUVBBQ0tFVCBzb2NrZXQgaXQgbXVzdCBmYWlsLCBhcyB0aGlzIHR5cGUg
b2Ygc29ja2V0IGhhcw0KPj4+Pj4+IG1lc3NhZ2Ugc2l6ZSBsaW1pdC4NCj4+Pj4+Pg0KPj4+Pj4+
IFNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1
Pg0KPj4+Pj4+IC0tLQ0KPj4+Pj4+IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwg
NjIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+Pj4+PiAxIGZpbGUgY2hhbmdl
ZCwgNjIgaW5zZXJ0aW9ucygrKQ0KPj4+Pj4+DQo+Pj4+Pj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rl
c3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQo+PiBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tf
dGVzdC5jDQo+Pj4+Pj4gaW5kZXggMTA3YzExMTY1ODg3Li5iYjRlODY1N2YxZDYgMTAwNjQ0DQo+
Pj4+Pj4gLS0tIGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCj4+Pj4+PiArKysg
Yi90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KPj4+Pj4+IEBAIC01NjAsNiArNTYw
LDYzIEBAIHN0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X3RpbWVvdXRfc2VydmVyKGNvbnN0DQo+
PiBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KPj4+Pj4+ICAgICBjbG9zZShmZCk7DQo+Pj4+Pj4g
fQ0KPj4+Pj4+DQo+Pj4+Pj4gK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19jbGll
bnQoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cw0KPj4gKm9wdHMpDQo+Pj4+Pj4gK3sNCj4+Pj4+PiAr
ICAgIHVuc2lnbmVkIGxvbmcgc29ja19idWZfc2l6ZTsNCj4+Pj4+PiArICAgIHNzaXplX3Qgc2Vu
ZF9zaXplOw0KPj4+Pj4+ICsgICAgc29ja2xlbl90IGxlbjsNCj4+Pj4+PiArICAgIHZvaWQgKmRh
dGE7DQo+Pj4+Pj4gKyAgICBpbnQgZmQ7DQo+Pj4+Pj4gKw0KPj4+Pj4+ICsgICAgbGVuID0gc2l6
ZW9mKHNvY2tfYnVmX3NpemUpOw0KPj4+Pj4+ICsNCj4+Pj4+PiArICAgIGZkID0gdnNvY2tfc2Vx
cGFja2V0X2Nvbm5lY3Qob3B0cy0+cGVlcl9jaWQsIDEyMzQpOw0KPj4+Pj4NCj4+Pj4+IE5vdCBm
b3IgdGhpcyBwYXRjaCwgYnV0IHNvbWVkYXkgd2Ugc2hvdWxkIGFkZCBhIG1hY3JvIGZvciB0aGlz
IHBvcnQNCj4+IGFuZCBtYXliZSBldmVuIG1ha2UgaXQgY29uZmlndXJhYmxlIDotKQ0KPj4+Pj4N
Cj4+Pj4+PiArICAgIGlmIChmZCA8IDApIHsNCj4+Pj4+PiArICAgICAgICBwZXJyb3IoImNvbm5l
Y3QiKTsNCj4+Pj4+PiArICAgICAgICBleGl0KEVYSVRfRkFJTFVSRSk7DQo+Pj4+Pj4gKyAgICB9
DQo+Pj4+Pj4gKw0KPj4+Pj4+ICsgICAgaWYgKGdldHNvY2tvcHQoZmQsIEFGX1ZTT0NLLCBTT19W
TV9TT0NLRVRTX0JVRkZFUl9TSVpFLA0KPj4+Pj4+ICsgICAgICAgICAgICAgICAmc29ja19idWZf
c2l6ZSwgJmxlbikpIHsNCj4+Pj4+PiArICAgICAgICBwZXJyb3IoImdldHNvY2tvcHQiKTsNCj4+
Pj4+PiArICAgICAgICBleGl0KEVYSVRfRkFJTFVSRSk7DQo+Pj4+Pj4gKyAgICB9DQo+Pj4+Pj4g
Kw0KPj4+Pj4+ICsgICAgc29ja19idWZfc2l6ZSsrOw0KPj4+Pj4+ICsNCj4+Pj4+PiArICAgIGRh
dGEgPSBtYWxsb2Moc29ja19idWZfc2l6ZSk7DQo+Pj4+Pj4gKyAgICBpZiAoIWRhdGEpIHsNCj4+
Pj4+PiArICAgICAgICBwZXJyb3IoIm1hbGxvYyIpOw0KPj4+Pj4+ICsgICAgICAgIGV4aXQoRVhJ
VF9GQUlMVVJFKTsNCj4+Pj4+PiArICAgIH0NCj4+Pj4+PiArDQo+Pj4+Pj4gKyAgICBzZW5kX3Np
emUgPSBzZW5kKGZkLCBkYXRhLCBzb2NrX2J1Zl9zaXplLCAwKTsNCj4+Pj4+PiArICAgIGlmIChz
ZW5kX3NpemUgIT0gLTEpIHsNCj4+Pj4+DQo+Pj4+PiBDYW4gd2UgY2hlY2sgYWxzbyBgZXJybm9g
Pw0KPj4+Pj4gSUlVQyBpdCBzaG91bGQgY29udGFpbnMgRU1TR1NJWkUuDQo+Pj4gSG0sIHNlZW1z
IGN1cnJlbnQgaW1wbGVtZW50YXRpb24gaXMgYSBsaXR0bGUgYml0IGJyb2tlbiBhbmQgcmV0dXJu
cw0KPj4gRU5PTUVNLCBiZWNhdXNlIGFueSBuZWdhdGl2ZSB2YWx1ZSwgcmV0dXJuZWQgYnkNCj4+
PiB0cmFuc3BvcnQgY2FsbGJhY2sgaXMgYWx3YXlzIHJlcGxhY2VkIHRvIEVOT01FTS4gSSB0aGlu
ayBpIG5lZWQgdGhpcw0KPj4gcGF0Y2ggZnJvbSBCb2JieToNCj4+Pg0KPj4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvbGttbC9kODE4MThiODY4MjE2Yzc3NDYxM2RkMDM2NDFmY2ZlNjNjYzU1YTQ1
LjE2NjAzNjI2NjguZ2l0LmJvYmJ5LmVzaGxlbWFuQGJ5dGVkYW5jZS5jb20vDQo+Pj4gTWF5IGJl
IGkgY2FuIGluY2x1ZGUgaXQgdG8gdGhpcyBwYXRjaHNldCBhbHNvIGZpeGluZyByZXZpZXcgY29t
bWVudHMob2YNCj4+IGNvdXJzZSBrZWVwaW5nIEJvYmJ5IGFzIGF1dGhvcikuIE9yIG1vcmUNCj4+
PiBzaW1wbGUgd2F5IGlzIHRvIGNoZWNrIEVOT01FTSBpbnN0ZWFkIG9mIEVNU0dTSVpFIGluIHRo
aXMgdGVzdChzaW1wbGUsDQo+PiBidXQgYSBsaXR0bGUgYml0IGR1bWIgaSB0aGluaykuDQo+Pg0K
Pj4gTWF5YmUgaW4gdGhpcyBwYXRjaCB5b3UgY2FuIHN0YXJ0IGNoZWNraW5nIEVOT01FTSAod2l0
aCBhIFRPRE8gY29tbWVudCksDQo+PiBhbmQgdGhlbiBCb2JieSBjYW4gY2hhbmdlIGl0IHdoZW4g
c2VuZGluZyBoaXMgcGF0Y2guDQo+Pg0KPj4gT3IgeW91IGNhbiByZXBvc3QgaXQgKEknbSBub3Qg
c3VyZSBpZiB3ZSBzaG91bGQga2VlcCB0aGUgbGVnYWN5IGJlaGF2aW9yDQo+PiBmb3Igb3RoZXIg
dHJhbnNwb3J0cyBvciBpdCB3YXMgYW4gZXJyb3IsIGJ1dCBiZXR0ZXIgdG8gZGlzY3VzcyBpdCBv
bg0KPj4gdGhhdCBwYXRjaCkuIEhvd2V2ZXIsIEkgdGhpbmsgd2Ugc2hvdWxkIG1lcmdlIHRoYXQg
cGF0Y2guDQo+Pg0KPj4gQEJvYmJ5LCB3aGF0IGRvIHlvdSB0aGluaz8NCj4+DQo+PiBUaGFua3Ms
DQo+PiBTdGVmYW5vDQo+Pg0KPj4NCj4gVGhpcyBzb3VuZHMgZ29vZCB0byBtZS4gSSByZW1vdmVk
IGl0IGZyb20gdGhlIGxhc3QgcmV2IGJlY2F1c2UgSSBkZWNpZGVkIG5vdA0KPiB0byBjb21wbGlj
YXRlIHRoZSBwYXRjaCBieSBhbHNvIGluY2x1ZGluZyBTT19TTkRCVUYgc3VwcG9ydCwgc28gaGFk
IG5vDQo+IG5lZWQuIEkgdGhpbmsgaXQgbWFrZXMgc2Vuc2Ugb3ZlcmFsbCB0aG91Z2guDQpPayEg
U28gSSdsbCB1c2UgWW91ciBwYXRjaChib3RoIGFmX3Zzb2NrLmMgYW5kIHRyYW5zcG9ydHMgcmVs
YXRlZCB0aGluZ3MgLSBzZWVtcyBpJ2xsDQpzcGxpdCBpdCB0byBzZXZlcmFsIHBhdGNoZXMsIEkg
dGhpbmsgZm9yIHRyYW5zcG9ydCBwYXRjaGVzLCBpdCBpcyBiZXR0ZXIgdG8gYXNrIFZtd2FyZQ0K
L01pY3Jvc29mdCBndXlzIGFsc28pLiBJJ20gZ29pbmcgdG8gc2VuZCBuZXh0IHZlcnNpb24gb2Yg
bXkgdGVzdHMgb24gdGhpcyB3ZWVrLg0KDQpUaGFuayBZb3UNCj4gDQo+IEFsc28sIHNvcnJ5IGZv
ciB0aGUgZGVsYXkgKEkgcHJvbWlzZWQgbGFzdCB3ZWVrIHRvIHNlbmQgb3V0IG5ldyByZXYpLiBJ
IHdhcw0KPiBwbGFubmluZyBvbiBzZW5kaW5nIG91dCB2NCB3aXRoIGFkZGl0aW9uYWwgZGF0YSBm
b3IgdGhlIG5vbi1uZXN0ZWQgdmlydA0KPiBjYXNlLA0KPiBidXQgSSd2ZSBiZWVuIGhhdmluZyBz
b21lIElUIHRyb3VibGVzIHdpdGggdGhlIG5ldyBwaHlzIGJveC4NCk5vIHByb2JsZW0sIGltIGN1
cnJlbnRseSByZWJhc2luZyBteSBwYXRjaGVzIGZvciB6ZXJvY29weSBvbiB2My4NCj4gDQo+IEJl
c3QsDQo+IEJvYmJ5DQo+IA0KPiBQUy4gc29ycnkgaWYgdGhpcyBlbWFpbCBmb3JtYXQgY29tZXMg
b3V0IHdhY2t5LiBJJ20gbm90IGF0IG15IGRldiBtYWNoaW5lDQo+IHNvIGp1c3QgdXNpbmcgR21h
aWwncyB3ZWIgYXBwIGRpcmVjdGx5Li4uIEhvcGVmdWxseSB0aGVyZSBpcyBubyBIVE1MIG9yDQo+
IGFueXRoaW5nIHdlaXJkLg0KPiANCg0K
