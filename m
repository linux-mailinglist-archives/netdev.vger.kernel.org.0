Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B62F64FC28
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 20:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiLQTrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 14:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiLQTry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 14:47:54 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDE264C3;
        Sat, 17 Dec 2022 11:47:53 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9B5225FD03;
        Sat, 17 Dec 2022 22:47:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1671306471;
        bh=OSv0Ba0Sxi0FhQJ1RPOToNqj3ToGYcwsxV98SeyHUao=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=A15Ne/c0w29kIO6PGVPSjlJG9Nxj8ZcBi+V872RDC0a2AReTHvkA+vl4lS3sHyyXa
         B2OK1WZc7+SZZr7zQA6mUL4ggv+2ElEbBWH26BUafTDN7csTkz8Vw97j4ACmTMLorw
         /N0jtc6WFH7akGMO3LCBIdJU7UjqrOlcTf8jUXndgYtl17MqvRIYcqAjq42wUjD1Ln
         PxU0sxYw4KZdWUPzt+UjEkvfIbfYu8QGSWHMeo9TT95zWcBuOsFdFFb+PvBsqcmTh1
         iLGPypmHsyat+3nQdvpCz2SSuggAX86PktggizoxImDTLCfx92pM8FRyqP8Bwhhv0i
         69/liYj/llDvg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat, 17 Dec 2022 22:47:50 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v1 2/2] vsock_test: mutual hungup reproducer
Thread-Topic: [RFC PATCH v1 2/2] vsock_test: mutual hungup reproducer
Thread-Index: AQHZElBxEL3j6aqlHkKaLR49F0BTQw==
Date:   Sat, 17 Dec 2022 19:47:50 +0000
Message-ID: <26d57ed5-f2f5-5e1d-b557-67a41c1c573c@sberdevices.ru>
In-Reply-To: <39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <36B3A5240833DB4FAF5244237C8F6E41@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/17 15:49:00 #20678428
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyBub3QgZm9yIG1lcmdlLCBqdXN0IGRlbW8uDQoNClNpZ25lZC1vZmYtYnk6IEFyc2Vu
aXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogdG9vbHMvdGVzdGlu
Zy92c29jay92c29ja190ZXN0LmMgfCA3OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KIDEgZmlsZSBjaGFuZ2VkLCA3OCBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS90b29s
cy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tf
dGVzdC5jDQppbmRleCBiYjZkNjkxY2IzMGQuLjMyMGVjZjRkYjc0YiAxMDA2NDQNCi0tLSBhL3Rv
b2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQorKysgYi90b29scy90ZXN0aW5nL3Zzb2Nr
L3Zzb2NrX3Rlc3QuYw0KQEAgLTY5OSw3ICs2OTksODUgQEAgc3RhdGljIHZvaWQgdGVzdF9zdHJl
YW1fcG9sbF9yY3Zsb3dhdF9jbGllbnQoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0cykNCiAJ
Y2xvc2UoZmQpOw0KIH0NCiANCitzdGF0aWMgdm9pZCB0ZXN0X3N0YWxsX2NsaWVudChjb25zdCBz
dHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJaW50IGZkOw0KKwl1bnNpZ25lZCBsb25nIGxv
d2F0X3ZhbCA9IDEyOCoxMDI0Ow0KKwlzaXplX3QgZGF0YV9zaXplID0gNjQgKiAxMDI0Ow0KKwl2
b2lkICpkYXRhOw0KKw0KKw0KKwlmZCA9IHZzb2NrX3N0cmVhbV9jb25uZWN0KG9wdHMtPnBlZXJf
Y2lkLCAxMjM0KTsNCisJYXNzZXJ0KGZkICE9IC0xKTsNCisNCisJYXNzZXJ0KCFzZXRzb2Nrb3B0
KGZkLCBTT0xfU09DS0VULCBTT19SQ1ZMT1dBVCwNCisJCSAgICAgICAmbG93YXRfdmFsLCBzaXpl
b2YobG93YXRfdmFsKSkpOw0KKw0KKwlkYXRhID0gbWFsbG9jKGRhdGFfc2l6ZSk7DQorCWFzc2Vy
dChkYXRhKTsNCisNCisJLyogV2FpdCBmb3IgdHggdG8gc2VuZCBkYXRhLiAqLw0KKwlzbGVlcCgz
KTsNCisNCisJd2hpbGUgKDEpIHsNCisJCXN0cnVjdCBwb2xsZmQgZmRzID0gezB9Ow0KKw0KKwkJ
ZmRzLmZkID0gZmQ7DQorCQlmZHMuZXZlbnRzID0gUE9MTElOIHwgUE9MTFJETk9STSB8IFBPTExF
UlIgfCBQT0xMUkRIVVAgfCBQT0xMSFVQOw0KKw0KKwkJLyogVHJ5IHRvIHdhaXQgZm9yIDEgc2Vj
LiAqLw0KKwkJcHJpbnRmKCJbUlhdIEVOVEVSIFBPTExcbiIpOw0KKwkJYXNzZXJ0KHBvbGwoJmZk
cywgMSwgLTEpID49IDApOw0KKwkJcHJpbnRmKCJbUlhdIExFQVZFIFBPTExcbiIpOw0KKw0KKwkJ
aWYgKGZkcy5yZXZlbnRzICYgKFBPTExJTiB8IFBPTExSRE5PUk0pKSB7DQorCQkJcmVhZChmZCwg
ZGF0YSwgZGF0YV9zaXplKTsNCisJCX0NCisNCisJCWlmIChmZHMucmV2ZW50cyAmIFBPTExFUlIp
IHsNCisJCQlwcmludGYoIltSWF0gUE9MTCBFUlJcbiIpOw0KKwkJCWJyZWFrOw0KKwkJfQ0KKw0K
KwkJaWYgKGZkcy5yZXZlbnRzICYgKFBPTExSREhVUCB8IFBPTExIVVApKSB7DQorCQkJcHJpbnRm
KCJbUlhdIFBPTEwgRE9ORVxuIik7DQorCQkJYnJlYWs7DQorCQl9DQorCX0NCisNCisJY2xvc2Uo
ZmQpOw0KKwlleGl0KDApOw0KK30NCisNCitzdGF0aWMgdm9pZCB0ZXN0X3N0YWxsX3NlcnZlcihj
b25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJc2l6ZV90IGRhdGFfc2l6ZSA9ICgy
NTYgKiAxMDI0KSArIDE7DQorCXZvaWQgKmRhdGE7DQorCWludCBmZDsNCisNCisJZmQgPSB2c29j
a19zdHJlYW1fYWNjZXB0KFZNQUREUl9DSURfQU5ZLCAxMjM0LCBOVUxMKTsNCisJYXNzZXJ0KGZk
ICE9IC0xKTsNCisNCisJZGF0YSA9IG1hbGxvYyhkYXRhX3NpemUpOw0KKwlhc3NlcnQoZGF0YSk7
DQorDQorCXByaW50ZigiW1RYXSBFTlRFUiBXUklURVxuIik7DQorCWFzc2VydCh3cml0ZShmZCwg
ZGF0YSwgZGF0YV9zaXplKSA9PSBkYXRhX3NpemUpOw0KKw0KKwkvKiBOZXZlciBnZXQgaGVyZSB3
aXRob3V0IGtlcm5lbCBwYXRjaC4gKi8NCisJcHJpbnRmKCJbVFhdIExFQVZFIFdSSVRFXG4iKTsN
CisNCisJY2xvc2UoZmQpOw0KKwlleGl0KDApOw0KK30NCisNCisNCiBzdGF0aWMgc3RydWN0IHRl
c3RfY2FzZSB0ZXN0X2Nhc2VzW10gPSB7DQorCXsNCisJCS5uYW1lID0gIlRlc3Qgc3RhbGwiLA0K
KwkJLnJ1bl9jbGllbnQgPSB0ZXN0X3N0YWxsX2NsaWVudCwNCisJCS5ydW5fc2VydmVyID0gdGVz
dF9zdGFsbF9zZXJ2ZXIsDQorCX0sDQogCXsNCiAJCS5uYW1lID0gIlNPQ0tfU1RSRUFNIGNvbm5l
Y3Rpb24gcmVzZXQiLA0KIAkJLnJ1bl9jbGllbnQgPSB0ZXN0X3N0cmVhbV9jb25uZWN0aW9uX3Jl
c2V0LA0KLS0gDQoyLjI1LjENCg==
