Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817F058386A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 08:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbiG1GHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 02:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiG1GHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 02:07:04 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5945C9E7;
        Wed, 27 Jul 2022 23:07:02 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id E265A5FD0D;
        Thu, 28 Jul 2022 09:07:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1658988420;
        bh=Alr7o2wmSsOVNbM/q3uZW6qh8Ao/pVeJYTUnfYZZOug=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=mY//SHPW3o/wyyVQS1x/3MkcqOeFm/KBbYNfgeCxtqbwQWe+0hKVZF5RdFTh6Mds1
         QdsVJnImqaF8Om1fMEqtQwztOD/x/wFHO/k1UC97Y6TQJ+PIv7ggGP0oJbQm9z/Rzo
         m0E8HQyTKYmXfyWp9ItgIM0hQRWtBIUrgRihnmO76t78oKn4PNtPoC/3rfkfk2oJbq
         yKENztwqbngJjMYy/XGQoTDluENnC9p5zcjfxxtJfAnTjbgE6PWgS3a41OsJv7USI9
         Rr3KbT4hW7ChrLPHIDZUZOaDn/b8JKxhEO+rnOBP7rxyonvNxOwMwqjSwBmkfgZy+l
         S1gtyeYU4qRbQ==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 28 Jul 2022 09:07:00 +0300 (MSK)
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
        "Krasnov Arseniy" <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 5/9] vsock: SO_RCVLOWAT transport set callback
Thread-Topic: [RFC PATCH v2 5/9] vsock: SO_RCVLOWAT transport set callback
Thread-Index: AQHYn/1NoPOM/Um+pUC5XxeDqd2x/62R9U+AgAEo6oA=
Date:   Thu, 28 Jul 2022 06:06:41 +0000
Message-ID: <8be16ad6-9758-a0f2-63a9-c9cbd2b3449b@sberdevices.ru>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <8baa2e3a-af6b-c0fe-9bfb-7cf89506474a@sberdevices.ru>
 <20220727122417.jvdfjnuybk3mwxkq@sgarzare-redhat>
In-Reply-To: <20220727122417.jvdfjnuybk3mwxkq@sgarzare-redhat>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <73B7ECEC81AD0748BB248366FC90661D@sberdevices.ru>
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

T24gMjcuMDcuMjAyMiAxNToyNCwgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBNb24s
IEp1bCAyNSwgMjAyMiBhdCAwODowNToyOEFNICswMDAwLCBBcnNlbml5IEtyYXNub3Ygd3JvdGU6
DQo+PiBUaGlzIGFkZHMgdHJhbnNwb3J0IHNwZWNpZmljIGNhbGxiYWNrIGZvciBTT19SQ1ZMT1dB
VCwgYmVjYXVzZSBpbiBzb21lDQo+PiB0cmFuc3BvcnRzIGl0IG1heSBiZSBkaWZmaWN1bHQgdG8g
a25vdyBjdXJyZW50IGF2YWlsYWJsZSBudW1iZXIgb2YgYnl0ZXMNCj4+IHJlYWR5IHRvIHJlYWQu
IFRodXMsIHdoZW4gU09fUkNWTE9XQVQgaXMgc2V0LCB0cmFuc3BvcnQgbWF5IHJlamVjdCBpdC4N
Cj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBBcnNlbml5IEtyYXNub3YgPEFWS3Jhc25vdkBzYmVyZGV2
aWNlcy5ydT4NCj4+IC0tLQ0KPj4gaW5jbHVkZS9uZXQvYWZfdnNvY2suaMKgwqAgfMKgIDEgKw0K
Pj4gbmV0L3Ztd192c29jay9hZl92c29jay5jIHwgMTkgKysrKysrKysrKysrKysrKysrKw0KPj4g
MiBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2lu
Y2x1ZGUvbmV0L2FmX3Zzb2NrLmggYi9pbmNsdWRlL25ldC9hZl92c29jay5oDQo+PiBpbmRleCBm
NzQyZTUwMjA3ZmIuLmVhZTU4NzRiYWUzNSAxMDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbmV0L2Fm
X3Zzb2NrLmgNCj4+ICsrKyBiL2luY2x1ZGUvbmV0L2FmX3Zzb2NrLmgNCj4+IEBAIC0xMzQsNiAr
MTM0LDcgQEAgc3RydWN0IHZzb2NrX3RyYW5zcG9ydCB7DQo+PiDCoMKgwqDCoHU2NCAoKnN0cmVh
bV9yY3ZoaXdhdCkoc3RydWN0IHZzb2NrX3NvY2sgKik7DQo+PiDCoMKgwqDCoGJvb2wgKCpzdHJl
YW1faXNfYWN0aXZlKShzdHJ1Y3QgdnNvY2tfc29jayAqKTsNCj4+IMKgwqDCoMKgYm9vbCAoKnN0
cmVhbV9hbGxvdykodTMyIGNpZCwgdTMyIHBvcnQpOw0KPj4gK8KgwqDCoCBpbnQgKCpzZXRfcmN2
bG93YXQpKHN0cnVjdCB2c29ja19zb2NrICosIGludCk7DQo+Pg0KPj4gwqDCoMKgwqAvKiBTRVFf
UEFDS0VULiAqLw0KPj4gwqDCoMKgwqBzc2l6ZV90ICgqc2VxcGFja2V0X2RlcXVldWUpKHN0cnVj
dCB2c29ja19zb2NrICp2c2ssIHN0cnVjdCBtc2doZHIgKm1zZywNCj4+IGRpZmYgLS1naXQgYS9u
ZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCj4+IGlu
ZGV4IDYzYTEzZmEyNjg2YS4uYjdhMjg2ZGI0YWYxIDEwMDY0NA0KPj4gLS0tIGEvbmV0L3Ztd192
c29jay9hZl92c29jay5jDQo+PiArKysgYi9uZXQvdm13X3Zzb2NrL2FmX3Zzb2NrLmMNCj4+IEBA
IC0yMTMwLDYgKzIxMzAsMjQgQEAgdnNvY2tfY29ubmVjdGlibGVfcmVjdm1zZyhzdHJ1Y3Qgc29j
a2V0ICpzb2NrLCBzdHJ1Y3QgbXNnaGRyICptc2csIHNpemVfdCBsZW4sDQo+PiDCoMKgwqDCoHJl
dHVybiBlcnI7DQo+PiB9DQo+Pg0KPj4gK3N0YXRpYyBpbnQgdnNvY2tfc2V0X3Jjdmxvd2F0KHN0
cnVjdCBzb2NrICpzaywgaW50IHZhbCkNCj4+ICt7DQo+PiArwqDCoMKgIGNvbnN0IHN0cnVjdCB2
c29ja190cmFuc3BvcnQgKnRyYW5zcG9ydDsNCj4+ICvCoMKgwqAgc3RydWN0IHZzb2NrX3NvY2sg
KnZzazsNCj4+ICvCoMKgwqAgaW50IGVyciA9IDA7DQo+PiArDQo+PiArwqDCoMKgIHZzayA9IHZz
b2NrX3NrKHNrKTsNCj4+ICvCoMKgwqAgdHJhbnNwb3J0ID0gdnNrLT50cmFuc3BvcnQ7DQo+IA0K
PiBgdHJhbnNwb3J0YCBjYW4gYmUgTlVMTCBpZiB0aGUgdXNlciBjYWxsIFNPX1JDVkxPV0FUIGJl
Zm9yZSB3ZSBhc3NpZ24gaXQsIHNvIHdlIHNob3VsZCBjaGVjayBpdC4NCkFjaw0KPiANCj4gSSB0
aGluayBpZiB0aGUgdHJhbnNwb3J0IGltcGxlbWVudHMgYHNldF9yY3Zsb3dhdGAsIG1heWJlIHdl
IHNob3VsZCBzZXQgdGhlcmUgc2stPnNrX3Jjdmxvd2F0LCBzbyBJIHdvdWxkIGRvIHNvbWV0aGlu
ZyBsaWtlIHRoYXQ6DQo+IA0KPiDCoMKgwqAgaWYgKHRyYW5zcG9ydCAmJiB0cmFuc3BvcnQtPnNl
dF9yY3Zsb3dhdCkNCj4gwqDCoMKgwqDCoMKgwqAgZXJyID0gdHJhbnNwb3J0LT5zZXRfcmN2bG93
YXQodnNrLCB2YWwpOw0KPiDCoMKgwqAgZWxzZQ0KPiDCoMKgwqDCoMKgwqDCoCBXUklURV9PTkNF
KHNrLT5za19yY3Zsb3dhdCwgdmFsID8gOiAxKTsNCj4gDQo+IMKgwqDCoCByZXR1cm4gZXJyOw0K
PiANCj4gSW4gYWRkaXRpb24gSSB0aGluayB3ZSBzaG91bGQgY2hlY2sgdGhhdCB2YWwgZG9lcyBu
b3QgZXhjZWVkIHZzay0+YnVmZmVyX3NpemUsIHNvbWV0aGluZyBzaW1pbGFyIG9mIHdoYXQgdGNw
X3NldF9yY3Zsb3dhdCgpIGRvZXMuDQo+IA0KQWNrDQo+IFRoYW5rcywNCj4gU3RlZmFubw0KPiAN
Cg0K
