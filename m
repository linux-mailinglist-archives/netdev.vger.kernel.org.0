Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAB0641F42
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 20:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiLDTWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 14:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiLDTWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 14:22:36 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AD51BE;
        Sun,  4 Dec 2022 11:22:32 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 35DB45FD03;
        Sun,  4 Dec 2022 22:22:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1670181751;
        bh=i+BopE1O8xRzs7H1Kym9nHEpuyNx7DWw32eD69gFqlA=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=cN0oYtWb+qbZTroF54sdKnOQofHxIqqsZ/7tSEGbBXV1A6Re+BcT3MZe2nhAKDas+
         N98ZaAP56be9jioFIJ59n5+Je54dm0Vzw3g8d0j2RST5GYFMihnSdC0vAoHmdwfqPv
         wIGdV2hFTIpujywpptsLEQjnDxLG1UqUp92KLo9D2Oqx+egdu6Gl/sfMyBKbFG8Rod
         hUw3oXhJsxfBLmDiQf8aakhk1PjXA9jU0W3L9TlH9u64STqN6MHmK5FKwo8zIv/J5a
         UBpCcpHGvjAtjCsrXk9PjzpkoK05MS4wEmzxynyspEgCoy+dkkxWOuGsd5jxSmMRBB
         kCqgPaBolRRiw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  4 Dec 2022 22:22:30 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: [RFC PATCH v3 3/4] test/vsock: add big message test
Thread-Topic: [RFC PATCH v3 3/4] test/vsock: add big message test
Thread-Index: AQHZCBXAvX2azG4SP0WsjlxzIGJ3Aw==
Date:   Sun, 4 Dec 2022 19:22:30 +0000
Message-ID: <08643a80-d8fd-7f7f-78ec-1962f1dcdd25@sberdevices.ru>
In-Reply-To: <6bd77692-8388-8693-f15f-833df1fa6afd@sberdevices.ru>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6719128948C4E048BDE9C4699E447610@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/12/04 13:44:00 #20647742
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
Ynk6IEFyc2VuaXkgS3Jhc25vdiA8QVZLcmFzbm92QHNiZXJkZXZpY2VzLnJ1Pg0KUmV2aWV3ZWQt
Ynk6IFN0ZWZhbm8gR2FyemFyZWxsYSA8c2dhcnphcmVAcmVkaGF0LmNvbT4NCi0tLQ0KIHRvb2xz
L3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgNjkgKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNjkgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0
IGEvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMgYi90b29scy90ZXN0aW5nL3Zzb2Nr
L3Zzb2NrX3Rlc3QuYw0KaW5kZXggYTU5MDRlZTM5ZTkxLi5jNGRiNmM5ZDIyNzMgMTAwNjQ0DQot
LS0gYS90b29scy90ZXN0aW5nL3Zzb2NrL3Zzb2NrX3Rlc3QuYw0KKysrIGIvdG9vbHMvdGVzdGlu
Zy92c29jay92c29ja190ZXN0LmMNCkBAIC01NjksNiArNTY5LDcwIEBAIHN0YXRpYyB2b2lkIHRl
c3Rfc2VxcGFja2V0X3RpbWVvdXRfc2VydmVyKGNvbnN0IHN0cnVjdCB0ZXN0X29wdHMgKm9wdHMp
DQogCWNsb3NlKGZkKTsNCiB9DQogDQorc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfYmlnbXNn
X2NsaWVudChjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0KK3sNCisJdW5zaWduZWQgbG9u
ZyBzb2NrX2J1Zl9zaXplOw0KKwlzc2l6ZV90IHNlbmRfc2l6ZTsNCisJc29ja2xlbl90IGxlbjsN
CisJdm9pZCAqZGF0YTsNCisJaW50IGZkOw0KKw0KKwlsZW4gPSBzaXplb2Yoc29ja19idWZfc2l6
ZSk7DQorDQorCWZkID0gdnNvY2tfc2VxcGFja2V0X2Nvbm5lY3Qob3B0cy0+cGVlcl9jaWQsIDEy
MzQpOw0KKwlpZiAoZmQgPCAwKSB7DQorCQlwZXJyb3IoImNvbm5lY3QiKTsNCisJCWV4aXQoRVhJ
VF9GQUlMVVJFKTsNCisJfQ0KKw0KKwlpZiAoZ2V0c29ja29wdChmZCwgQUZfVlNPQ0ssIFNPX1ZN
X1NPQ0tFVFNfQlVGRkVSX1NJWkUsDQorCQkgICAgICAgJnNvY2tfYnVmX3NpemUsICZsZW4pKSB7
DQorCQlwZXJyb3IoImdldHNvY2tvcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0K
Kw0KKwlzb2NrX2J1Zl9zaXplKys7DQorDQorCWRhdGEgPSBtYWxsb2Moc29ja19idWZfc2l6ZSk7
DQorCWlmICghZGF0YSkgew0KKwkJcGVycm9yKCJtYWxsb2MiKTsNCisJCWV4aXQoRVhJVF9GQUlM
VVJFKTsNCisJfQ0KKw0KKwlzZW5kX3NpemUgPSBzZW5kKGZkLCBkYXRhLCBzb2NrX2J1Zl9zaXpl
LCAwKTsNCisJaWYgKHNlbmRfc2l6ZSAhPSAtMSkgew0KKwkJZnByaW50ZihzdGRlcnIsICJleHBl
Y3RlZCAnc2VuZCgyKScgZmFpbHVyZSwgZ290ICV6aVxuIiwNCisJCQlzZW5kX3NpemUpOw0KKwkJ
ZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWlmIChlcnJubyAhPSBFTVNHU0laRSkgew0K
KwkJZnByaW50ZihzdGRlcnIsICJleHBlY3RlZCBFTVNHU0laRSBpbiAnZXJybm8nLCBnb3QgJWlc
biIsDQorCQkJZXJybm8pOw0KKwkJZXhpdChFWElUX0ZBSUxVUkUpOw0KKwl9DQorDQorCWNvbnRy
b2xfd3JpdGVsbigiQ0xJU0VOVCIpOw0KKw0KKwlmcmVlKGRhdGEpOw0KKwljbG9zZShmZCk7DQor
fQ0KKw0KK3N0YXRpYyB2b2lkIHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19zZXJ2ZXIoY29uc3Qgc3Ry
dWN0IHRlc3Rfb3B0cyAqb3B0cykNCit7DQorCWludCBmZDsNCisNCisJZmQgPSB2c29ja19zZXFw
YWNrZXRfYWNjZXB0KFZNQUREUl9DSURfQU5ZLCAxMjM0LCBOVUxMKTsNCisJaWYgKGZkIDwgMCkg
ew0KKwkJcGVycm9yKCJhY2NlcHQiKTsNCisJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCisJfQ0KKw0K
Kwljb250cm9sX2V4cGVjdGxuKCJDTElTRU5UIik7DQorDQorCWNsb3NlKGZkKTsNCit9DQorDQog
I2RlZmluZSBCVUZfUEFUVEVSTl8xICdhJw0KICNkZWZpbmUgQlVGX1BBVFRFUk5fMiAnYicNCiAN
CkBAIC04NTEsNiArOTE1LDExIEBAIHN0YXRpYyBzdHJ1Y3QgdGVzdF9jYXNlIHRlc3RfY2FzZXNb
XSA9IHsNCiAJCS5ydW5fY2xpZW50ID0gdGVzdF9zdHJlYW1fcG9sbF9yY3Zsb3dhdF9jbGllbnQs
DQogCQkucnVuX3NlcnZlciA9IHRlc3Rfc3RyZWFtX3BvbGxfcmN2bG93YXRfc2VydmVyLA0KIAl9
LA0KKwl7DQorCQkubmFtZSA9ICJTT0NLX1NFUVBBQ0tFVCBiaWcgbWVzc2FnZSIsDQorCQkucnVu
X2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19jbGllbnQsDQorCQkucnVuX3NlcnZlciA9
IHRlc3Rfc2VxcGFja2V0X2JpZ21zZ19zZXJ2ZXIsDQorCX0sDQogCXt9LA0KIH07DQogDQotLSAN
CjIuMjUuMQ0K
