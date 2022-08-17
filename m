Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA075968A0
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 07:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbiHQF3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 01:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiHQF3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 01:29:00 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB54B4E62A;
        Tue, 16 Aug 2022 22:28:58 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id D1CD55FD08;
        Wed, 17 Aug 2022 08:28:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1660714136;
        bh=E45LUo5dnBIoo1JgEmeJ3I8mH7kcX+2NFKB8RJnjTmI=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=HIiMwRjTZJulm7QTAB2KCUgr/I+QW9JZH371Fv0r3aNy1ADNAa6gGcRH+Szp1SfRO
         I1vspcK2HS40x9nbJDNFdWEQqqrgumGXGesgA8LGtzrKuEgUsYOhkXuMOMhtHflgLG
         swMnBHgOQ+RAck2Hpvj55saliGuVXPJYipxlwyPwX0M3ugol3wqGG9sniPkDnKAfr3
         1NmbVuI2xEvGIy2Ca2uNEdxHGd7J0IbfDdix1D9YnjuMxZfWoki4ARBWrMD8iQBSPT
         PvwLo1ftjqLWtX/nVTGe3xNi79NUIekPLSWjIsOV2p8DUfbSiIVhhJVNeizlJbWgSr
         PXucFNQwP3CRw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 17 Aug 2022 08:28:54 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>
CC:     "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "Bobby Eshleman" <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [virtio-dev] Re: [PATCH 2/6] vsock: return errors other than
 -ENOMEM to socket
Thread-Topic: [virtio-dev] Re: [PATCH 2/6] vsock: return errors other than
 -ENOMEM to socket
Thread-Index: AQHYsY0HA9PuVtzJ6EGz2Q3NauAiZq2yXxWA
Date:   Wed, 17 Aug 2022 05:28:43 +0000
Message-ID: <fa74606c-36d9-a4eb-b62a-54631c7fa41c@sberdevices.ru>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
 <YvsBYyPFnKRhvPfp@bullseye>
In-Reply-To: <YvsBYyPFnKRhvPfp@bullseye>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B57B3ABE02F19489494D8714B6D1A53@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/08/17 01:22:00 #20132227
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTYuMDguMjAyMiAwNTozMCwgQm9iYnkgRXNobGVtYW4gd3JvdGU6DQo+IENDJ2luZyB2aXJ0
aW8tZGV2QGxpc3RzLm9hc2lzLW9wZW4ub3JnDQo+IA0KPiBPbiBNb24sIEF1ZyAxNSwgMjAyMiBh
dCAxMDo1NjowNUFNIC0wNzAwLCBCb2JieSBFc2hsZW1hbiB3cm90ZToNCj4+IFRoaXMgY29tbWl0
IGFsbG93cyB2c29jayBpbXBsZW1lbnRhdGlvbnMgdG8gcmV0dXJuIGVycm9ycw0KPj4gdG8gdGhl
IHNvY2tldCBsYXllciBvdGhlciB0aGFuIC1FTk9NRU0uIE9uZSBpbW1lZGlhdGUgZWZmZWN0DQo+
PiBvZiB0aGlzIGlzIHRoYXQgdXBvbiB0aGUgc2tfc25kYnVmIHRocmVzaG9sZCBiZWluZyByZWFj
aGVkIC1FQUdBSU4NCj4+IHdpbGwgYmUgcmV0dXJuZWQgYW5kIHVzZXJzcGFjZSBtYXkgdGhyb3R0
bGUgYXBwcm9wcmlhdGVseS4NCj4+DQo+PiBSZXN1bHRpbmdseSwgYSBrbm93biBpc3N1ZSB3aXRo
IHVwZXJmIGlzIHJlc29sdmVkWzFdLg0KPj4NCj4+IEFkZGl0aW9uYWxseSwgdG8gcHJlc2VydmUg
bGVnYWN5IGJlaGF2aW9yIGZvciBub24tdmlydGlvDQo+PiBpbXBsZW1lbnRhdGlvbnMsIGh5cGVy
di92bWNpIGZvcmNlIGVycm9ycyB0byBiZSAtRU5PTUVNIHNvIHRoYXQgYmVoYXZpb3INCj4+IGlz
IHVuY2hhbmdlZC4NCj4+DQo+PiBbMV06IGh0dHBzOi8vZ2l0bGFiLmNvbS92c29jay92c29jay8t
L2lzc3Vlcy8xDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQm9iYnkgRXNobGVtYW4gPGJvYmJ5LmVz
aGxlbWFuQGJ5dGVkYW5jZS5jb20+DQo+PiAtLS0NCj4+ICBpbmNsdWRlL2xpbnV4L3ZpcnRpb192
c29jay5oICAgICAgICAgICAgfCAzICsrKw0KPj4gIG5ldC92bXdfdnNvY2svYWZfdnNvY2suYyAg
ICAgICAgICAgICAgICB8IDMgKystDQo+PiAgbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0
LmMgICAgICAgIHwgMiArLQ0KPj4gIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21t
b24uYyB8IDMgLS0tDQo+PiAgbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydC5jICAgICAgICAg
IHwgOSArKysrKysrKy0NCj4+ICA1IGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDYg
ZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdmlydGlvX3Zz
b2NrLmggYi9pbmNsdWRlL2xpbnV4L3ZpcnRpb192c29jay5oDQo+PiBpbmRleCAxN2VkMDE0NjY4
NzUuLjlhMzdlZGRiYjg3YSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbGludXgvdmlydGlvX3Zz
b2NrLmgNCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvdmlydGlvX3Zzb2NrLmgNCj4+IEBAIC04LDYg
KzgsOSBAQA0KPj4gICNpbmNsdWRlIDxuZXQvc29jay5oPg0KPj4gICNpbmNsdWRlIDxuZXQvYWZf
dnNvY2suaD4NCj4+ICANCj4+ICsvKiBUaHJlc2hvbGQgZm9yIGRldGVjdGluZyBzbWFsbCBwYWNr
ZXRzIHRvIGNvcHkgKi8NCj4+ICsjZGVmaW5lIEdPT0RfQ09QWV9MRU4gIDEyOA0KPj4gKw0KPj4g
IGVudW0gdmlydGlvX3Zzb2NrX21ldGFkYXRhX2ZsYWdzIHsNCj4+ICAJVklSVElPX1ZTT0NLX01F
VEFEQVRBX0ZMQUdTX1JFUExZCQk9IEJJVCgwKSwNCj4+ICAJVklSVElPX1ZTT0NLX01FVEFEQVRB
X0ZMQUdTX1RBUF9ERUxJVkVSRUQJPSBCSVQoMSksDQo+PiBkaWZmIC0tZ2l0IGEvbmV0L3Ztd192
c29jay9hZl92c29jay5jIGIvbmV0L3Ztd192c29jay9hZl92c29jay5jDQo+PiBpbmRleCBlMzQ4
YjJkMDllYWMuLjE4OTNmOGFhZmE0OCAxMDA2NDQNCj4+IC0tLSBhL25ldC92bXdfdnNvY2svYWZf
dnNvY2suYw0KPj4gKysrIGIvbmV0L3Ztd192c29jay9hZl92c29jay5jDQo+PiBAQCAtMTg0NCw4
ICsxODQ0LDkgQEAgc3RhdGljIGludCB2c29ja19jb25uZWN0aWJsZV9zZW5kbXNnKHN0cnVjdCBz
b2NrZXQgKnNvY2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCj4+ICAJCQl3cml0dGVuID0gdHJhbnNw
b3J0LT5zdHJlYW1fZW5xdWV1ZSh2c2ssDQo+PiAgCQkJCQltc2csIGxlbiAtIHRvdGFsX3dyaXR0
ZW4pOw0KPj4gIAkJfQ0KPj4gKw0KPj4gIAkJaWYgKHdyaXR0ZW4gPCAwKSB7DQo+PiAtCQkJZXJy
ID0gLUVOT01FTTsNCj4+ICsJCQllcnIgPSB3cml0dGVuOw0KPj4gIAkJCWdvdG8gb3V0X2VycjsN
Cj4+ICAJCX0NCklJVUMsIGZvciBzdHJlYW0sIHRoaXMgdGhpbmcgd2lsbCBoYXZlIGVmZmVjdCwg
b25seSBvbmUgZmlyc3QgdHJhbnNwb3J0IGFjY2VzcyBmYWlscy4gSW4gdGhpcw0KY2FzZSAndG90
YWxfd3JpdHRlbicgd2lsbCBiZSAwLCBzbyAnZXJyJyA9PSAnd3JpdHRlbicgd2lsbCBiZSByZXR1
cm5lZC4gQnV0IHdoZW4gJ3RvdGFsX3dyaXR0ZW4gPiAwJywNCidlcnInIHdpbGwgYmUgb3Zlcndy
aXR0ZW4gYnkgJ3RvdGFsX3dyaXR0ZW4nIGJlbG93LCBwcmVzZXJ2aW5nIGN1cnJlbnQgYmVoYXZp
b3VyLiBJcyBpdCB3aGF0IFlvdQ0Kc3VwcG9zZWQ/DQoNClRoYW5rcw0KPj4gIA0KPj4gZGlmZiAt
LWdpdCBhL25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jIGIvbmV0L3Ztd192c29jay9o
eXBlcnZfdHJhbnNwb3J0LmMNCj4+IGluZGV4IGZkOTgyMjllM2RiMy4uZTk5YWVhNTcxZjZmIDEw
MDY0NA0KPj4gLS0tIGEvbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmMNCj4+ICsrKyBi
L25ldC92bXdfdnNvY2svaHlwZXJ2X3RyYW5zcG9ydC5jDQo+PiBAQCAtNjg3LDcgKzY4Nyw3IEBA
IHN0YXRpYyBzc2l6ZV90IGh2c19zdHJlYW1fZW5xdWV1ZShzdHJ1Y3QgdnNvY2tfc29jayAqdnNr
LCBzdHJ1Y3QgbXNnaGRyICptc2csDQo+PiAgCWlmIChieXRlc193cml0dGVuKQ0KPj4gIAkJcmV0
ID0gYnl0ZXNfd3JpdHRlbjsNCj4+ICAJa2ZyZWUoc2VuZF9idWYpOw0KPj4gLQlyZXR1cm4gcmV0
Ow0KPj4gKwlyZXR1cm4gcmV0IDwgMCA/IC1FTk9NRU0gOiByZXQ7DQo+PiAgfQ0KPj4gIA0KPj4g
IHN0YXRpYyBzNjQgaHZzX3N0cmVhbV9oYXNfZGF0YShzdHJ1Y3QgdnNvY2tfc29jayAqdnNrKQ0K
Pj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyBi
L25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KPj4gaW5kZXggOTIwNTc4
NTk3YmI5Li5kNTc4MDU5OWZlOTMgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvdm13X3Zzb2NrL3ZpcnRp
b190cmFuc3BvcnRfY29tbW9uLmMNCj4+ICsrKyBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5z
cG9ydF9jb21tb24uYw0KPj4gQEAgLTIzLDkgKzIzLDYgQEANCj4+ICAvKiBIb3cgbG9uZyB0byB3
YWl0IGZvciBncmFjZWZ1bCBzaHV0ZG93biBvZiBhIGNvbm5lY3Rpb24gKi8NCj4+ICAjZGVmaW5l
IFZTT0NLX0NMT1NFX1RJTUVPVVQgKDggKiBIWikNCj4+ICANCj4+IC0vKiBUaHJlc2hvbGQgZm9y
IGRldGVjdGluZyBzbWFsbCBwYWNrZXRzIHRvIGNvcHkgKi8NCj4+IC0jZGVmaW5lIEdPT0RfQ09Q
WV9MRU4gIDEyOA0KPj4gLQ0KPj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgdmlydGlvX3RyYW5zcG9y
dCAqDQo+PiAgdmlydGlvX3RyYW5zcG9ydF9nZXRfb3BzKHN0cnVjdCB2c29ja19zb2NrICp2c2sp
DQo+PiAgew0KPj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnQuYyBi
L25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnQuYw0KPj4gaW5kZXggYjE0ZjBlZDc0MjdiLi5j
OTI3YTkwZGM4NTkgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0
LmMNCj4+ICsrKyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnQuYw0KPj4gQEAgLTE4Mzgs
NyArMTgzOCwxNCBAQCBzdGF0aWMgc3NpemVfdCB2bWNpX3RyYW5zcG9ydF9zdHJlYW1fZW5xdWV1
ZSgNCj4+ICAJc3RydWN0IG1zZ2hkciAqbXNnLA0KPj4gIAlzaXplX3QgbGVuKQ0KPj4gIHsNCj4+
IC0JcmV0dXJuIHZtY2lfcXBhaXJfZW5xdWV2KHZtY2lfdHJhbnModnNrKS0+cXBhaXIsIG1zZywg
bGVuLCAwKTsNCj4+ICsJaW50IGVycjsNCj4+ICsNCj4+ICsJZXJyID0gdm1jaV9xcGFpcl9lbnF1
ZXYodm1jaV90cmFucyh2c2spLT5xcGFpciwgbXNnLCBsZW4sIDApOw0KPj4gKw0KPj4gKwlpZiAo
ZXJyIDwgMCkNCj4+ICsJCWVyciA9IC1FTk9NRU07DQo+PiArDQo+PiArCXJldHVybiBlcnI7DQo+
PiAgfQ0KPj4gIA0KPj4gIHN0YXRpYyBzNjQgdm1jaV90cmFuc3BvcnRfc3RyZWFtX2hhc19kYXRh
KHN0cnVjdCB2c29ja19zb2NrICp2c2spDQo+PiAtLSANCj4+IDIuMzUuMQ0KPj4NCj4gDQo+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPiBUbyB1bnN1YnNjcmliZSwgZS1tYWlsOiB2aXJ0aW8tZGV2LXVuc3Vic2Ny
aWJlQGxpc3RzLm9hc2lzLW9wZW4ub3JnDQo+IEZvciBhZGRpdGlvbmFsIGNvbW1hbmRzLCBlLW1h
aWw6IHZpcnRpby1kZXYtaGVscEBsaXN0cy5vYXNpcy1vcGVuLm9yZw0KPiANCg0K
