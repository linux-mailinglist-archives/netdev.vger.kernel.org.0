Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC63638EDC
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKYRNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKYRNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:13:10 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB0C3F073;
        Fri, 25 Nov 2022 09:13:09 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id E2CBF5FD0B;
        Fri, 25 Nov 2022 20:13:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1669396387;
        bh=9qv6bo2BORlnQt0hKuzAdwsTbynOYqadbQRmTr/uw78=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=XAN887WPNw/WZTQECWA0tJS6ZC8TreX2FcfssiPfd65oGed1tp5Igaou7ePYJOZUv
         g+Bms8P1KaCIJaX7pzu4r0rlPpTNJzxDPi+djic0BUD7Y1euoCG+Q8KO+meqLVieAS
         kdmlYDi8KO9NgwH7ieqzLJCfm3j7XXY9Hylj5d79dw7zD3cZfX4eCLWVzO9GJR9E1/
         ENzt7Wi3ScAGVRuciHB+vvIighb1Zb9wuajme0xjA6ni4Lmn8BGuT7UgI99EhP2vz7
         seT0VkT1HZkHZ722u2kNNULrx+wUTOfklZ+2uZGej5SY6mgvwfRTb87aSgUDlwQmGt
         iHnL8LhE6CE6g==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Fri, 25 Nov 2022 20:13:06 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "Dexuan Cui" <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "Krasnov Arseniy" <oxffffaa@gmail.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v2 5/6] test/vsock: add big message test
Thread-Topic: [RFC PATCH v2 5/6] test/vsock: add big message test
Thread-Index: AQHZAPEvcSVoxBim/0CJACwJhEWdyw==
Date:   Fri, 25 Nov 2022 17:13:06 +0000
Message-ID: <2634ad7f-b462-5c69-8aa1-2f200a6beb20@sberdevices.ru>
In-Reply-To: <9d96f6c6-1d4f-8197-b3bc-8957124c8933@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B4C91B9914E1D4FA437F630D9DDFF05@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/25 14:59:00 #20610704
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBhZGRzIHRlc3QgZm9yIHNlbmRpbmcgbWVzc2FnZSwgYmlnZ2VyIHRoYW4gcGVlcidzIGJ1
ZmZlciBzaXplLg0KRm9yIFNPQ0tfU0VRUEFDS0VUIHNvY2tldCBpdCBtdXN0IGZhaWwsIGFzIHRo
aXMgdHlwZSBvZiBzb2NrZXQgaGFzDQptZXNzYWdlIHNpemUgbGltaXQuDQoNClNpZ25lZC1vZmYt
Ynk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KLS0tDQogdG9v
bHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA2OSArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA2OSBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1n
aXQgYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3RpbmcvdnNv
Y2svdnNvY2tfdGVzdC5jDQppbmRleCAxMmVmMGNjYTZmOTMuLmE4ZTQzNDI0ZmIzMiAxMDA2NDQN
Ci0tLSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQorKysgYi90b29scy90ZXN0
aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KQEAgLTU2OSw2ICs1NjksNzAgQEAgc3RhdGljIHZvaWQg
dGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIoY29uc3Qgc3RydWN0IHRlc3Rfb3B0cyAqb3B0
cykNCiAJY2xvc2UoZmQpOw0KIH0NCiANCitzdGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF9iaWdt
c2dfY2xpZW50KGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMpDQorew0KKwl1bnNpZ25lZCBs
b25nIHNvY2tfYnVmX3NpemU7DQorCXNzaXplX3Qgc2VuZF9zaXplOw0KKwlzb2NrbGVuX3QgbGVu
Ow0KKwl2b2lkICpkYXRhOw0KKwlpbnQgZmQ7DQorDQorCWxlbiA9IHNpemVvZihzb2NrX2J1Zl9z
aXplKTsNCisNCisJZmQgPSB2c29ja19zZXFwYWNrZXRfY29ubmVjdChvcHRzLT5wZWVyX2NpZCwg
MTIzNCk7DQorCWlmIChmZCA8IDApIHsNCisJCXBlcnJvcigiY29ubmVjdCIpOw0KKwkJZXhpdChF
WElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWlmIChnZXRzb2Nrb3B0KGZkLCBBRl9WU09DSywgU09f
Vk1fU09DS0VUU19CVUZGRVJfU0laRSwNCisJCSAgICAgICAmc29ja19idWZfc2l6ZSwgJmxlbikp
IHsNCisJCXBlcnJvcigiZ2V0c29ja29wdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9
DQorDQorCXNvY2tfYnVmX3NpemUrKzsNCisNCisJZGF0YSA9IG1hbGxvYyhzb2NrX2J1Zl9zaXpl
KTsNCisJaWYgKCFkYXRhKSB7DQorCQlwZXJyb3IoIm1hbGxvYyIpOw0KKwkJZXhpdChFWElUX0ZB
SUxVUkUpOw0KKwl9DQorDQorCXNlbmRfc2l6ZSA9IHNlbmQoZmQsIGRhdGEsIHNvY2tfYnVmX3Np
emUsIDApOw0KKwlpZiAoc2VuZF9zaXplICE9IC0xKSB7DQorCQlmcHJpbnRmKHN0ZGVyciwgImV4
cGVjdGVkICdzZW5kKDIpJyBmYWlsdXJlLCBnb3QgJXppXG4iLA0KKwkJCXNlbmRfc2l6ZSk7DQor
CQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJaWYgKGVycm5vICE9IEVNU0dTSVpFKSB7
DQorCQlmcHJpbnRmKHN0ZGVyciwgImV4cGVjdGVkIEVNU0dTSVpFIGluICdlcnJubycsIGdvdCAl
aVxuIiwNCisJCQllcnJubyk7DQorCQlleGl0KEVYSVRfRkFJTFVSRSk7DQorCX0NCisNCisJY29u
dHJvbF93cml0ZWxuKCJDTElTRU5UIik7DQorDQorCWZyZWUoZGF0YSk7DQorCWNsb3NlKGZkKTsN
Cit9DQorDQorc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfYmlnbXNnX3NlcnZlcihjb25zdCBz
dHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJaW50IGZkOw0KKw0KKwlmZCA9IHZzb2NrX3Nl
cXBhY2tldF9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwpOw0KKwlpZiAoZmQgPCAw
KSB7DQorCQlwZXJyb3IoImFjY2VwdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQor
DQorCWNvbnRyb2xfZXhwZWN0bG4oIkNMSVNFTlQiKTsNCisNCisJY2xvc2UoZmQpOw0KK30NCisN
CiAjZGVmaW5lIEJVRl9QQVRURVJOXzEgJ2EnDQogI2RlZmluZSBCVUZfUEFUVEVSTl8yICdiJw0K
IA0KQEAgLTg1MSw2ICs5MTUsMTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0X2Nhc2UgdGVzdF9jYXNl
c1tdID0gew0KIAkJLnJ1bl9jbGllbnQgPSB0ZXN0X3N0cmVhbV9wb2xsX3Jjdmxvd2F0X2NsaWVu
dCwNCiAJCS5ydW5fc2VydmVyID0gdGVzdF9zdHJlYW1fcG9sbF9yY3Zsb3dhdF9zZXJ2ZXIsDQog
CX0sDQorCXsNCisJCS5uYW1lID0gIlNPQ0tfU0VRUEFDS0VUIGJpZyBtZXNzYWdlIiwNCisJCS5y
dW5fY2xpZW50ID0gdGVzdF9zZXFwYWNrZXRfYmlnbXNnX2NsaWVudCwNCisJCS5ydW5fc2VydmVy
ID0gdGVzdF9zZXFwYWNrZXRfYmlnbXNnX3NlcnZlciwNCisJfSwNCiAJe30sDQogfTsNCiANCi0t
IA0KMi4yNS4xDQo=
