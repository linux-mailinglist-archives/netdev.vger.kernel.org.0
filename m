Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6459583867
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiG1GF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiG1GFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:05:25 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D296759272;
        Wed, 27 Jul 2022 23:05:22 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 376A25FD0D;
        Thu, 28 Jul 2022 09:05:21 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658988321;
        bh=3TTjB3bsNlGhRedSPnw13cCIUnTJCl5UhhyEcrck8CU=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=QsFrl7pEDa0NxmwXaIIBg7ncy07K7VmGyyeR95kwNbVUHg0dr2i051vUKmjqDn+T+
         pf19qYrPMW+7SIQhNDQh4LX7cQpC/X4IYit4KyBawL0tNGraa+iCJrYxwQwCGLsOuW
         KxeJirRMjz+dJZLIUccx1xz28mJHpvRaREbT03WuBkq+HUL/tQTKBoeNQrtSr7ogFw
         wbewHm5TSaUWyB2+OTZ6bu01gyhh7awNqEQ4S7IXb9lyZqSiy6du1On2iBbbzEJDaI
         GdYuEgozsM0GxRbPA814teyY+FHsYFfh+W1SdwbU7xudLFitkMmEjf2wa8/I9Sym0v
         a/8AYKtq1qbkw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 28 Jul 2022 09:05:20 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
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
        "Krasnov Arseniy" <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 3/9] vmci/vsock: use 'target' in notify_poll_in,
 callback
Thread-Topic: [RFC PATCH v2 3/9] vmci/vsock: use 'target' in notify_poll_in,
 callback
Thread-Index: AQHYn/yuG7nDISN+mkeT5PR9a2L0x62R9N2AgAEo5oA=
Date:   Thu, 28 Jul 2022 06:05:01 +0000
Message-ID: <8564cfdd-800d-7c7d-5993-bd75857258de@sberdevices.ru>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <355f4bb6-82e7-2400-83e9-c704a7ef92f3@sberdevices.ru>
 <20220727122241.mrafnepbelcboo5i@sgarzare-redhat>
In-Reply-To: <20220727122241.mrafnepbelcboo5i@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F03ECCD83333D6478BBC352D81AC3A88@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/07/28 02:09:00 #19985101
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjcuMDcuMjAyMiAxNToyMiwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBASm9yZ2Vu
IGNhbiB5b3UgdGFrZSBhIGxvb2sgYXQgdGhpcyBzZXJpZXMsIGVzcGVjaWFsbHkgdGhpcyBwYXRj
aD8NCj4gDQo+IE1heWJlIHdlIG5lZWQgdG8gdXBkYXRlIHRoZSBjb21tZW50cyBpbiB0aGUgZWxz
ZSBicmFuY2gsIHNvbWV0aGluZyBsaWtlDQo+IHMvdGhlcmUgaXMgbm90aGluZy90aGVyZSBpcyBu
b3QgZW5vdWdoIGRhdGENCk9rLCB0aGFua3MhDQo+IA0KPiBUaGFua3MsDQo+IFN0ZWZhbm8NCj4g
DQo+IE9uIE1vbiwgSnVsIDI1LCAyMDIyIGF0IDA4OjAxOjAxQU0gKzAwMDAsIEFyc2VuaXkgS3Jh
c25vdiB3cm90ZToNCj4+IFRoaXMgY2FsbGJhY2sgY29udHJvbHMgc2V0dGluZyBvZiBQT0xMSU4s
UE9MTFJETk9STSBvdXRwdXQgYml0cyBvZiBwb2xsKCkNCj4+IHN5c2NhbGwsYnV0IGluIHNvbWUg
Y2FzZXMsaXQgaXMgaW5jb3JyZWN0bHkgdG8gc2V0IGl0LCB3aGVuIHNvY2tldCBoYXMNCj4+IGF0
IGxlYXN0IDEgYnl0ZXMgb2YgYXZhaWxhYmxlIGRhdGEuIFVzZSAndGFyZ2V0JyB3aGljaCBpcyBh
bHJlYWR5IGV4aXN0cw0KPj4gYW5kIGVxdWFsIHRvIHNrX3Jjdmxvd2F0IGluIHRoaXMgY2FzZS4N
Cj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2
aWNlcy5ydT4NCj4+IC0tLQ0KPj4gbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnku
Y8KgwqDCoMKgwqDCoMKgIHwgMiArLQ0KPj4gbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9u
b3RpZnlfcXN0YXRlLmMgfCAyICstDQo+PiAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay92bWNp
X3RyYW5zcG9ydF9ub3RpZnkuYyBiL25ldC92bXdfdnNvY2svdm1jaV90cmFuc3BvcnRfbm90aWZ5
LmMNCj4+IGluZGV4IGQ2OWZjNGI1OTVhZC4uMTY4NGI4NWIwNjYwIDEwMDY0NA0KPj4gLS0tIGEv
bmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYw0KPj4gKysrIGIvbmV0L3Ztd192
c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnkuYw0KPj4gQEAgLTM0MCw3ICszNDAsNyBAQCB2bWNp
X3RyYW5zcG9ydF9ub3RpZnlfcGt0X3BvbGxfaW4oc3RydWN0IHNvY2sgKnNrLA0KPj4gew0KPj4g
wqDCoMKgwqBzdHJ1Y3QgdnNvY2tfc29jayAqdnNrID0gdnNvY2tfc2soc2spOw0KPj4NCj4+IC3C
oMKgwqAgaWYgKHZzb2NrX3N0cmVhbV9oYXNfZGF0YSh2c2spKSB7DQo+PiArwqDCoMKgIGlmICh2
c29ja19zdHJlYW1faGFzX2RhdGEodnNrKSA+PSB0YXJnZXQpIHsNCj4+IMKgwqDCoMKgwqDCoMKg
ICpkYXRhX3JlYWR5X25vdyA9IHRydWU7DQo+PiDCoMKgwqDCoH0gZWxzZSB7DQo+PiDCoMKgwqDC
oMKgwqDCoCAvKiBXZSBjYW4ndCByZWFkIHJpZ2h0IG5vdyBiZWNhdXNlIHRoZXJlIGlzIG5vdGhp
bmcgaW4gdGhlDQo+PiBkaWZmIC0tZ2l0IGEvbmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9u
b3RpZnlfcXN0YXRlLmMgYi9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeV9xc3Rh
dGUuYw0KPj4gaW5kZXggMGYzNmQ3YzQ1ZGIzLi5hNDA0MDc4NzJiNTMgMTAwNjQ0DQo+PiAtLS0g
YS9uZXQvdm13X3Zzb2NrL3ZtY2lfdHJhbnNwb3J0X25vdGlmeV9xc3RhdGUuYw0KPj4gKysrIGIv
bmV0L3Ztd192c29jay92bWNpX3RyYW5zcG9ydF9ub3RpZnlfcXN0YXRlLmMNCj4+IEBAIC0xNjEs
NyArMTYxLDcgQEAgdm1jaV90cmFuc3BvcnRfbm90aWZ5X3BrdF9wb2xsX2luKHN0cnVjdCBzb2Nr
ICpzaywNCj4+IHsNCj4+IMKgwqDCoMKgc3RydWN0IHZzb2NrX3NvY2sgKnZzayA9IHZzb2NrX3Nr
KHNrKTsNCj4+DQo+PiAtwqDCoMKgIGlmICh2c29ja19zdHJlYW1faGFzX2RhdGEodnNrKSkgew0K
Pj4gK8KgwqDCoCBpZiAodnNvY2tfc3RyZWFtX2hhc19kYXRhKHZzaykgPj0gdGFyZ2V0KSB7DQo+
PiDCoMKgwqDCoMKgwqDCoCAqZGF0YV9yZWFkeV9ub3cgPSB0cnVlOw0KPj4gwqDCoMKgwqB9IGVs
c2Ugew0KPj4gwqDCoMKgwqDCoMKgwqAgLyogV2UgY2FuJ3QgcmVhZCByaWdodCBub3cgYmVjYXVz
ZSB0aGVyZSBpcyBub3RoaW5nIGluIHRoZQ0KPj4gLS3CoA0KPj4gMi4yNS4xDQo+IA0KDQo=
