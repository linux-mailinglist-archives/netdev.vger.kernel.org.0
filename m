Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175C457B080
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 07:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiGTFqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 01:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiGTFqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 01:46:16 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3FD40BF9;
        Tue, 19 Jul 2022 22:46:14 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 0E2CA5FD2F;
        Wed, 20 Jul 2022 08:46:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658295973;
        bh=MXTkxU5zLs68wITmVOICMzd+5xVWw2kckv0TAiwX3xM=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=oQxzEa5OEyOF8o6f/sSkwTWWOSOR/iYGvjWkvWDGKKQwkQaP2jcrEWtUUcq2Le/bL
         P8hfPYrVOl5kD1+Y/kTsWJRrm1h3kVVxir8zbVGFN8r7qtXWFAXGGihvoJZ5AC32OE
         0D5LPggY1TuhB3d+OUbTYGoFqf8TK6dLm5CdurqmMtLyzzxqQ/+oQeBMY8VonSNrJe
         b/yn34RhPp7hxiReLVhYhWxKIs3EVqn5lF3KILCbUi7h7q7MTGXUTPMNrmMSbgu7a5
         UA3XsoDMvx9/+Yt51Q/X1cDKgeaosxjBVSu7JTBmFEPXXAh2qbIBpK1GEHdGh9yrPo
         255m/G8S2OOwA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 20 Jul 2022 08:46:12 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 3/3] vsock_test: POLLIN + SO_RCVLOWAT test.
Thread-Topic: [RFC PATCH v1 3/3] vsock_test: POLLIN + SO_RCVLOWAT test.
Thread-Index: AQHYmn8L0QxAqOPQQUWV5xnNPUkeX62FdYOAgAEbPQA=
Date:   Wed, 20 Jul 2022 05:46:01 +0000
Message-ID: <ea414c31-741f-6994-651a-a686cba3d25e@sberdevices.ru>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <df70a274-4e69-ca1f-acba-126eb517e532@sberdevices.ru>
 <20220719125227.bktosg3yboeaeoo5@sgarzare-redhat>
In-Reply-To: <20220719125227.bktosg3yboeaeoo5@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA772DDF9BFCF94F898809C86D08C755@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/19 23:44:00 #19926989
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTkuMDcuMjAyMiAxNTo1MiwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEp1bCAxOCwgMjAyMiBhdCAwODoxOTowNkFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBUaGlzIGFkZHMgdGVzdCB0byBjaGVjaywgdGhhdCB3aGVuIHBvbGwoKSByZXR1cm5zIFBP
TExJTiBhbmQNCj4+IFBPTExSRE5PUk0gYml0cywgbmV4dCByZWFkIGNhbGwgd29uJ3QgYmxvY2su
DQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRl
dmljZXMucnU+DQo+PiAtLS0NCj4+IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwg
OTAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+IDEgZmlsZSBjaGFuZ2VkLCA5
MCBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2sv
dnNvY2tfdGVzdC5jIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCj4+IGluZGV4
IGRjNTc3NDYxYWZjMi4uOGUzOTQ0NDNlYWY2IDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvdGVzdGlu
Zy92c29jay92c29ja190ZXN0LmMNCj4+ICsrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tf
dGVzdC5jDQo+PiBAQCAtMTgsNiArMTgsNyBAQA0KPj4gI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4N
Cj4+ICNpbmNsdWRlIDx0aW1lLmg+DQo+PiAjaW5jbHVkZSA8c3lzL21tYW4uaD4NCj4+ICsjaW5j
bHVkZSA8cG9sbC5oPg0KPj4NCj4+ICNpbmNsdWRlICJ0aW1lb3V0LmgiDQo+PiAjaW5jbHVkZSAi
Y29udHJvbC5oIg0KPj4gQEAgLTU5Niw2ICs1OTcsOTAgQEAgc3RhdGljIHZvaWQgdGVzdF9zZXFw
YWNrZXRfaW52YWxpZF9yZWNfYnVmZmVyX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpv
cHQNCj4+IMKgwqDCoMKgY2xvc2UoZmQpOw0KPj4gfQ0KPj4NCj4+ICtzdGF0aWMgdm9pZCB0ZXN0
X3N0cmVhbV9wb2xsX3Jjdmxvd2F0X3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRz
KQ0KPj4gK3sNCj4+ICsjZGVmaW5lIFJDVkxPV0FUX0JVRl9TSVpFIDEyOA0KPj4gK8KgwqDCoCBp
bnQgZmQ7DQo+PiArwqDCoMKgIGludCBpOw0KPj4gKw0KPj4gK8KgwqDCoCBmZCA9IHZzb2NrX3N0
cmVhbV9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwpOw0KPj4gK8KgwqDCoCBpZiAo
ZmQgPCAwKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgcGVycm9yKCJhY2NlcHQiKTsNCj4+ICvCoMKg
wqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiArwqDCoMKgIH0NCj4+ICsNCj4+ICvC
oMKgwqAgLyogU2VuZCAxIGJ5dGUuICovDQo+PiArwqDCoMKgIHNlbmRfYnl0ZShmZCwgMSwgMCk7
DQo+PiArDQo+PiArwqDCoMKgIGNvbnRyb2xfd3JpdGVsbigiU1JWU0VOVCIpOw0KPj4gKw0KPj4g
K8KgwqDCoCAvKiBKdXN0IGVtcGlyaWNhbGx5IGRlbGF5IHZhbHVlLiAqLw0KPj4gK8KgwqDCoCBz
bGVlcCg0KTsNCj4gDQo+IFdoeSB3ZSBuZWVkIHRoaXMgc2xlZXAoKT8NClB1cnBvc2Ugb2Ygc2xl
ZXAoKSBpcyB0byBtb3ZlIGNsaWVudCBpbiBzdGF0ZSwgd2hlbiBpdCBoYXMgMSBieXRlIG9mIHJ4
IGRhdGENCmFuZCBwb2xsKCkgd29uJ3Qgd2FrZS4gRm9yIGV4YW1wbGU6DQpjbGllbnQ6ICAgICAg
ICAgICAgICAgICAgICAgICAgc2VydmVyOg0Kd2FpdHMgZm9yICJTUlZTRU5UIg0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHNlbmQgMSBieXRlDQogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc2VuZCAiU1JWU0VOVCINCnBvbGwoKQ0KICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHNsZWVwDQouLi4NCnBvbGwgc2xlZXBzDQouLi4NCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzZW5kIHJlc3Qgb2YgZGF0YQ0KcG9sbCB3YWtlIHVwDQoNCkkgdGhpbmssIHdp
dGhvdXQgc2xlZXAgdGhlcmUgaXMgY2hhbmNlLCB0aGF0IGNsaWVudCBlbnRlcnMgcG9sbCgpIHdo
ZW4gd2hvbGUNCmRhdGEgZnJvbSBzZXJ2ZXIgaXMgYWxyZWFkeSByZWNlaXZlZCwgdGh1cyB0ZXN0
IHdpbGwgYmUgdXNlbGVzcyhpdCBqdXN0IHRlc3RzDQpwb2xsKCkpLiBNYXkgYmUgaSBjYW4gcmVt
b3ZlICJTUlZTRU5UIiBhcyBzbGVlcCBpcyBlbm91Z2guDQoNCj4gDQoNCg==
