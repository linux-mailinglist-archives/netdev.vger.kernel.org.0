Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7F961E5BD
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiKFTvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiKFTuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:50:54 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D544D10FDE;
        Sun,  6 Nov 2022 11:50:52 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 425565FD03;
        Sun,  6 Nov 2022 22:50:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1667764251;
        bh=JLlpkwTSfIBGrLuXfogAgrdiNEl7/2KG3a3rEAt/O1g=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=dG9nmPY0hrwjfsuUxP/e2rXABuYHuQSKZhpi51SK88W3Z6wSNvdo6FoqaxIwXjaHv
         6JMjYPa36C1miwBwJZxIx6JXxh9tPlb0HHkN0DwGYMcy8wDICso8J/4a60hMxRPvBH
         xRUJGZaVo6CB6PMPs8OVrRZ0dhjdpjI64az3dZkveXHu3oTSdGq8qOa2IAjibI0xF+
         Ak47x4AQhYfGN6cCKFefqOCZabzgwDLXQJEp14Wyvtf6V4wiShRKVdI7LS23AhXiGK
         YVY01bGUWfqH0B7VDM1SBKP8WfukPcHIcrBqZ14PduiaPwCLasuHvujfjqNCqSw6yV
         wZoeWmVHS+HKw==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  6 Nov 2022 22:50:51 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 09/11] test/vsock: add big message test
Thread-Topic: [RFC PATCH v3 09/11] test/vsock: add big message test
Thread-Index: AQHY8hkAptW4O6wxGUmfu9tKRKX0oQ==
Date:   Sun, 6 Nov 2022 19:50:19 +0000
Message-ID: <4d2cac96-d829-fcf6-e042-2ed65493c602@sberdevices.ru>
In-Reply-To: <f60d7e94-795d-06fd-0321-6972533700c5@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E19F5D8B8513E64191835F066A558356@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/11/06 18:31:00 #20575158
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
bHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgfCA2MiArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA2MiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1n
aXQgYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYyBiL3Rvb2xzL3Rlc3RpbmcvdnNv
Y2svdnNvY2tfdGVzdC5jDQppbmRleCAxMDdjMTExNjU4ODcuLmJiNGU4NjU3ZjFkNiAxMDA2NDQN
Ci0tLSBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jDQorKysgYi90b29scy90ZXN0
aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KQEAgLTU2MCw2ICs1NjAsNjMgQEAgc3RhdGljIHZvaWQg
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
CX0NCisNCisJY29udHJvbF93cml0ZWxuKCJDTElTRU5UIik7DQorDQorCWZyZWUoZGF0YSk7DQor
CWNsb3NlKGZkKTsNCit9DQorDQorc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfYmlnbXNnX3Nl
cnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJaW50IGZkOw0KKw0KKwlm
ZCA9IHZzb2NrX3NlcXBhY2tldF9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwpOw0K
KwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImFjY2VwdCIpOw0KKwkJZXhpdChFWElUX0ZBSUxV
UkUpOw0KKwl9DQorDQorCWNvbnRyb2xfZXhwZWN0bG4oIkNMSVNFTlQiKTsNCisNCisJY2xvc2Uo
ZmQpOw0KK30NCisNCiAjZGVmaW5lIEJVRl9QQVRURVJOXzEgJ2EnDQogI2RlZmluZSBCVUZfUEFU
VEVSTl8yICdiJw0KIA0KQEAgLTgzMiw2ICs4ODksMTEgQEAgc3RhdGljIHN0cnVjdCB0ZXN0X2Nh
c2UgdGVzdF9jYXNlc1tdID0gew0KIAkJLnJ1bl9jbGllbnQgPSB0ZXN0X3NlcXBhY2tldF90aW1l
b3V0X2NsaWVudCwNCiAJCS5ydW5fc2VydmVyID0gdGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2
ZXIsDQogCX0sDQorCXsNCisJCS5uYW1lID0gIlNPQ0tfU0VRUEFDS0VUIGJpZyBtZXNzYWdlIiwN
CisJCS5ydW5fY2xpZW50ID0gdGVzdF9zZXFwYWNrZXRfYmlnbXNnX2NsaWVudCwNCisJCS5ydW5f
c2VydmVyID0gdGVzdF9zZXFwYWNrZXRfYmlnbXNnX3NlcnZlciwNCisJfSwNCiAJew0KIAkJLm5h
bWUgPSAiU09DS19TRVFQQUNLRVQgaW52YWxpZCByZWNlaXZlIGJ1ZmZlciIsDQogCQkucnVuX2Ns
aWVudCA9IHRlc3Rfc2VxcGFja2V0X2ludmFsaWRfcmVjX2J1ZmZlcl9jbGllbnQsDQotLSANCjIu
MzUuMA0K
