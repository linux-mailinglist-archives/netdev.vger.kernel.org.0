Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA7163EF8F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiLALgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLALgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:36:09 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793998C46E;
        Thu,  1 Dec 2022 03:36:06 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EAFDD5FD07;
        Thu,  1 Dec 2022 14:36:03 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669894564;
        bh=diW2bt1nmVltkaw9FbBARpnyQZELnALJTnHl6DJ6SBI=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=rwOL/AATBNzSjXZn8ZugQtXSV/95r4hNHPwmeCatujJ+9VQQd7WSryGLz3VYrDW08
         oGtN0/o2ZTTcGJatqlzi3bskkGFnWq4pU+GW6/iVyGdp+zFnZSvQ+2h7CHGZSGBnfx
         QTYhH5rkYFLUZrih756Vva33LfJ1Omrjb+xI7frJ91864NI47C7r+BAZ1vP0jKUX+b
         /124k4orhxHm871BORyWpRWbwrLtaqPPeFVYmVj+cuFusIFExt5EK5peqjGi26vj/Q
         fH0f5BI5dTjsTzH4KN0bstDdQ/Dg5yzHhtaFet8spi6s1ghxyfYVmLISKwli/k2dv1
         vvk8FPWngtK4A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  1 Dec 2022 14:36:01 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        "Bobby Eshleman" <bobby.eshleman@bytedance.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 3/6] vsock/vmci: always return ENOMEM in case of
 error
Thread-Topic: [RFC PATCH v2 3/6] vsock/vmci: always return ENOMEM in case of
 error
Thread-Index: AQHZAPB8vpTNk9Cz/UiwVhA3FAXi7a5YmwUAgAAipwA=
Date:   Thu, 1 Dec 2022 11:36:01 +0000
Message-ID: <1d01f9ea-0212-ffe9-1168-47b98e2ede46@sberdevices.ru>
References: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
 <675b1f93-dc07-0a70-0622-c3fc6236c8bb@sberdevices.ru>
 <20221201093048.q2pradrgn5limcfb@sgarzare-redhat>
In-Reply-To: <20221201093048.q2pradrgn5limcfb@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5DB5093729C0541A2F948FB05E0AA6D@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/01 00:48:00 #20630840
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEuMTIuMjAyMiAxMjozMCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBGcmks
IE5vdiAyNSwgMjAyMiBhdCAwNTowODowNlBNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBGcm9tOiBCb2JieSBFc2hsZW1hbiA8Ym9iYnkuZXNobGVtYW5AYnl0ZWRhbmNlLmNvbT4N
Cj4+DQo+PiBUaGlzIHNhdmVzIG9yaWdpbmFsIGJlaGF2aW91ciBmcm9tIGFmX3Zzb2NrLmMgLSBz
d2l0Y2ggYW55IGVycm9yDQo+PiBjb2RlIHJldHVybmVkIGZyb20gdHJhbnNwb3J0IGxheWVyIHRv
IEVOT01FTS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBCb2JieSBFc2hsZW1hbiA8Ym9iYnkuZXNo
bGVtYW5AYnl0ZWRhbmNlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IEFyc2VuaXkgS3Jhc25vdiA8
QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KPj4gLS0tDQo+PiBuZXQvdm13X3Zzb2NrL3ZtY2lf
dHJhbnNwb3J0LmMgfCA5ICsrKysrKysrLQ0KPj4gMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gQEJyeWFuIEBWaXNobnUgd2hhdCBkbyB5b3UgdGhp
bmsgYWJvdXQgdGhpcyBwYXRjaD8NCj4gDQo+IEEgYml0IG9mIGNvbnRleHQ6DQo+IA0KPiBCZWZv
cmUgdGhpcyBzZXJpZXMsIHRoZSBhZl92c29jayBjb3JlIGFsd2F5cyByZXR1cm5lZCBFTk9NRU0g
dG8gdGhlIHVzZXIgaWYgdGhlIHRyYW5zcG9ydCBmYWlsZWQgdG8gcXVldWUgdGhlIHBhY2tldC4N
Cj4gDQo+IE5vdyB3ZSBhcmUgY2hhbmdpbmcgaXQgYnkgcmV0dXJuaW5nIHRoZSB0cmFuc3BvcnQg
ZXJyb3IuIFNvIEkgdGhpbmsgaGVyZSB3ZSB3YW50IHRvIHByZXNlcnZlIHRoZSBwcmV2aW91cyBi
ZWhhdmlvciBmb3Igdm1jaSwgYnV0IEkgZG9uJ3Qga25vdyBpZiB0aGF0J3MgdGhlIHJpZ2h0IHRo
aW5nLg0KPiANCj4gDQo+IA0KPiBAQXJzZW5peSBwbGVhc2UgaW4gdGhlIG5leHQgdmVyc2lvbnMg
ZGVzY3JpYmUgYmV0dGVyIGluIHRoZSBjb21taXQgbWVzc2FnZXMgdGhlIHJlYXNvbnMgZm9yIHRo
ZXNlIGNoYW5nZXMsIHNvIGl0IGlzIGVhc2llciByZXZpZXcgZm9yIG90aGVycyBhbmQgYWxzbyBp
biB0aGUgZnV0dXJlIGJ5IHJlYWRpbmcgdGhlIGNvbW1pdCBtZXNzYWdlIHdlIGNhbiB1bmRlcnN0
YW5kIHRoZSByZWFzb24gZm9yIHRoZSBjaGFuZ2UuDQpIZWxsbywNCg0KU3VyZSEgU29ycnkgZm9y
IHRoYXQhIEFsc28sIEkgY2FuIHNlbmQgYm90aCB2bWNpIGFuZCBoeXBlcnYgcGF0Y2hlcyBpbiB0
aGUgbmV4dCB2ZXJzaW9uKGUuZy4gbm90IHdhaXRpbmcgZm9yDQpyZXZpZXdlcnMgcmVwbHkgYW5k
IHJlb3JkZXIgdGhlbSB3aXRoIDEvNiBhcyBZb3UgYXNrZWQpLCBhcyByZXN1bHQgb2YgcmV2aWV3
IGNvdWxkIGJlIGRyb3BwZWQgcGF0Y2ggb25seS4NCg0KVGhhbmtzLCBBcnNlbml5DQo+IA0KPiBU
aGFua3MsDQo+IFN0ZWZhbm8NCj4gDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2sv
dm1jaV90cmFuc3BvcnQuYyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnQuYw0KPj4gaW5k
ZXggODQyYzk0Mjg2ZDMxLi4yODlhMzZhMjAzYTIgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvdm13X3Zz
b2NrL3ZtY2lfdHJhbnNwb3J0LmMNCj4+ICsrKyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3Bv
cnQuYw0KPj4gQEAgLTE4MzgsNyArMTgzOCwxNCBAQCBzdGF0aWMgc3NpemVfdCB2bWNpX3RyYW5z
cG9ydF9zdHJlYW1fZW5xdWV1ZSgNCj4+IMKgwqDCoMKgc3RydWN0IG1zZ2hkciAqbXNnLA0KPj4g
wqDCoMKgwqBzaXplX3QgbGVuKQ0KPj4gew0KPj4gLcKgwqDCoCByZXR1cm4gdm1jaV9xcGFpcl9l
bnF1ZXYodm1jaV90cmFucyh2c2spLT5xcGFpciwgbXNnLCBsZW4sIDApOw0KPj4gK8KgwqDCoCBp
bnQgZXJyOw0KPj4gKw0KPj4gK8KgwqDCoCBlcnIgPSB2bWNpX3FwYWlyX2VucXVldih2bWNpX3Ry
YW5zKHZzayktPnFwYWlyLCBtc2csIGxlbiwgMCk7DQo+PiArDQo+PiArwqDCoMKgIGlmIChlcnIg
PCAwKQ0KPj4gK8KgwqDCoMKgwqDCoMKgIGVyciA9IC1FTk9NRU07DQo+PiArDQo+PiArwqDCoMKg
IHJldHVybiBlcnI7DQo+PiB9DQo+Pg0KPj4gc3RhdGljIHM2NCB2bWNpX3RyYW5zcG9ydF9zdHJl
YW1faGFzX2RhdGEoc3RydWN0IHZzb2NrX3NvY2sgKnZzaykNCj4+IC0twqANCj4+IDIuMjUuMQ0K
PiANCg0K
