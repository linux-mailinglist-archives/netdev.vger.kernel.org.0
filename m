Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C0157B069
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 07:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbiGTFiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 01:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGTFiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 01:38:17 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470626C125;
        Tue, 19 Jul 2022 22:38:16 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 81AD85FD2F;
        Wed, 20 Jul 2022 08:38:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658295494;
        bh=KCVkCqut4hsdxLAojtjI5kiCMSpUwER1t2kU6XITWEE=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=jGaJ04PKSeGFZ9w7CZB6Qb6Zn0A/Cvx2+fAYoMHUyW7RMEsHEFw8GxrGXZdGxcuuW
         6gcji4L02Ca82rwrPsLoPS/m3kmex3E96I3UtmBIzA/2ocl9ScIufTo1R6xoVD1h9m
         942xs5gq7OPRF7+5d3GGDkisqpiM/pB3JMvJ+3z09A406fQxToys+9YGJvDOOusQCI
         +mTFdJhKLxjSATFXs/aSoh/dA/PZRc+rdVZv5Hq/DUfzv9Zl1RZOnvUui+GDqrt3Xu
         9N+IKFNOsSeQAEvfK+BzJVVRie0MVLS2f+gr7BZCrP30A+p7fxyqfAXLYW3mSUrq0G
         nYMXyPT/SbpKA==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Wed, 20 Jul 2022 08:38:14 +0300 (MSK)
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
Subject: Re: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Topic: [RFC PATCH v1 2/3] virtio/vsock: use 'target' in notify_poll_in,
 callback.
Thread-Index: AQHYmn7T+PqKYxwQ8USiiecixCHJYa2FdImAgAEZ/YA=
Date:   Wed, 20 Jul 2022 05:38:03 +0000
Message-ID: <15f38fcf-f1ff-3aad-4c30-4436bb8c4c44@sberdevices.ru>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <358f8d52-fd88-ad2e-87e2-c64bfa516a58@sberdevices.ru>
 <20220719124857.akv25sgp6np3pdaw@sgarzare-redhat>
In-Reply-To: <20220719124857.akv25sgp6np3pdaw@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEEEBFD7BFA690429B5D1E34DBC89E60@sberdevices.ru>
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

T24gMTkuMDcuMjAyMiAxNTo0OCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEp1bCAxOCwgMjAyMiBhdCAwODoxNzozMUFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBUaGlzIGNhbGxiYWNrIGNvbnRyb2xzIHNldHRpbmcgb2YgUE9MTElOLFBPTExSRE5PUk0g
b3V0cHV0IGJpdHMNCj4+IG9mIHBvbGwoKSBzeXNjYWxsLGJ1dCBpbiBzb21lIGNhc2VzLGl0IGlz
IGluY29ycmVjdGx5IHRvIHNldCBpdCwNCj4+IHdoZW4gc29ja2V0IGhhcyBhdCBsZWFzdCAxIGJ5
dGVzIG9mIGF2YWlsYWJsZSBkYXRhLiBVc2UgJ3RhcmdldCcNCj4+IHdoaWNoIGlzIGFscmVhZHkg
ZXhpc3RzIGFuZCBlcXVhbCB0byBza19yY3Zsb3dhdCBpbiB0aGlzIGNhc2UuDQo+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogQXJzZW5peSBLcmFzbm92IDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+
PiAtLS0NCj4+IG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYyB8IDIgKy0N
Cj4+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMgYi9u
ZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3BvcnRfY29tbW9uLmMNCj4+IGluZGV4IGVjMmMyYWZi
ZjBkMC4uNTkxOTA4NzQwOTkyIDEwMDY0NA0KPj4gLS0tIGEvbmV0L3Ztd192c29jay92aXJ0aW9f
dHJhbnNwb3J0X2NvbW1vbi5jDQo+PiArKysgYi9uZXQvdm13X3Zzb2NrL3ZpcnRpb190cmFuc3Bv
cnRfY29tbW9uLmMNCj4+IEBAIC02MzQsNyArNjM0LDcgQEAgdmlydGlvX3RyYW5zcG9ydF9ub3Rp
ZnlfcG9sbF9pbihzdHJ1Y3QgdnNvY2tfc29jayAqdnNrLA0KPj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNpemVfdCB0YXJnZXQsDQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgYm9vbCAqZGF0YV9yZWFkeV9ub3cpDQo+PiB7DQo+PiAtwqDCoMKgIGlmICh2c29ja19z
dHJlYW1faGFzX2RhdGEodnNrKSkNCj4+ICvCoMKgwqAgaWYgKHZzb2NrX3N0cmVhbV9oYXNfZGF0
YSh2c2spID49IHRhcmdldCkNCj4+IMKgwqDCoMKgwqDCoMKgICpkYXRhX3JlYWR5X25vdyA9IHRy
dWU7DQo+PiDCoMKgwqDCoGVsc2UNCj4+IMKgwqDCoMKgwqDCoMKgICpkYXRhX3JlYWR5X25vdyA9
IGZhbHNlOw0KPiANCj4gUGVyaGFwcyB3ZSBjYW4gdGFrZSB0aGUgb3Bwb3J0dW5pdHkgdG8gY2xl
YW4gdXAgdGhlIGNvZGUgaW4gdGhpcyB3YXk6DQo+IA0KPiDCoMKgwqDCoCpkYXRhX3JlYWR5X25v
dyA9IHZzb2NrX3N0cmVhbV9oYXNfZGF0YSh2c2spID49IHRhcmdldDsNCkFjaw0KPiANCj4gQW55
d2F5LCBJIHRoaW5rIHdlIGFsc28gbmVlZCB0byBmaXggdGhlIG90aGVyIHRyYW5zcG9ydHMgKHZt
Y2kgYW5kIGh5cGVydiksIHdoYXQgZG8geW91IHRoaW5rPw0KRm9yIHZtY2kgaXQgaXMgbG9vayBj
bGVhciB0byBmaXggaXQuIEZvciBoeXBlcnYgaSBuZWVkIHRvIGNoZWNrIGl0IG1vcmUsIGJlY2F1
c2UgaXQgYWxyZWFkeQ0KdXNlcyBzb21lIGludGVybmFsIHRhcmdldCB2YWx1ZS4NCj4gDQo+IFRo
YW5rcywNCj4gU3RlZmFubw0KPiANCg0K
