Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C125404819
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhIIJzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:55:10 -0400
Received: from mout.gmx.net ([212.227.17.22]:34135 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233298AbhIIJzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 05:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631181226;
        bh=s/Hv4I9PogZdkQVbwtwCM/QWYxj2wQTqldNgJavrJoI=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cEIMG72gAiMlxkREfNv0y8646lXORwA0hM4IPDxwf2IziBNYRSoxnEj1uorcgwdj9
         EdYXf/vtlovblfDKYsTE211e8xbdMQF53oqwwYc5BL3lj+IK70oYC+Fh8jmWQuqox3
         wEKzcFaBzFns+cHFD0pwgsXTMrmtnSBMlOz7aVAw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M72sJ-1mJ1Yk3tHz-008cns; Thu, 09
 Sep 2021 11:53:46 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     olteanv@gmail.com
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 2/3] net: dsa: microchip: provide the function ksz_switch_shutdown()
Date:   Thu,  9 Sep 2021 11:53:23 +0200
Message-Id: <20210909095324.12978-3-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:VscG5hDGP1HJbbSfBbJ2MFcsUsJYwimuUKYpw5D0TDrP6oMrB/E
 zn2IGBdFjpgnmXaw5zzuvCsRYjR51zZdTf0ONqBUed8m2TcK8yXWwyXyZ9OJKWPR+aM37m+
 KtEfHPFa0UL4KBM5y0MoIMXwUhYZIwbb060HTH/76DjOyU7NeMbRGdQgU1b60x3jBLD18Ue
 w9vxNXbgK46GkmPJRkUyw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9tf3mufsHwg=:3HVGNeYjp6DvIBt2TUvV5+
 U65PEKjBzSqCgy7psLlqiY7/MP1UQDaVyNXy5wsSWWruK7chENeqY5kzrlLGDma41ESvD0vRm
 e9WgMvWXC+py49gkuL71T8/AjhPfgth0XqYhx2hRJ2fRx/ocZpfs8BuCPINp9LHMgt5IOkulI
 /dL7y6ywNjqB/sR+Qvrskh1j0KSPqhefhZyOrZr5RBuYigT1lY5YyNBu/Z5FArPBYIpZVmbmk
 RelCUyy7K0AwJQ3C3X7MhLTilIc5J0U44l/Rb86pHZaxDokeBxvN7QTOYib7NugGf9ppcI1CN
 GXnyGjKVkS+VuQ4nJFurh2zRJg59oNzqo8y/aJrrxB+4uoAU+ngJmAD6HhvE4maacKq3djYBh
 SF6YCN/0CJP6V+UbN0ROPRW1EqXazBasWcKOVM73hybJ855ufPU6ytJBJj5VXsrbQzm8o6SZn
 a5g2rO9/R2aZxZ1m93NJKVS8kriMUGu/zYrIXw2uEjwoaMvJmaiMGTRqB297WxBjET8nbVhyG
 Nz1M3NC2VE22kg7F9I053ZuALNhx7ZFtoEswcOvhDWwb6g4RyW/W8/MolDrZCcGfoWdAmhvGU
 jwl8mVYDDkC61BKR5Ub+TL9wnb0o/2CeyNuIvM67kOTs0sWq3z+K33YM8iirFXOZeAXZ6eiFb
 sG262GtfGljpMyi7SMKm3Lnw2+/9QqCCmZKnSjMICLM6pvsuLffQRNmQTRdLAUO/ABXyC4cYD
 /wXbsKsWuB01qc6l8Nvlohm/5k9coFccHZ9qU3/Nyk233VAmBeAkrd5L3bJERQ+3yQLeIsR6j
 XOd/c/fqOjL6Ik/DB8Msq/QvkLogO3Oif3IcnvM+UftZfuIBdjjqpt2WSC1pQ1xE0aufxQYOE
 NrF0XMJbaKdFDDc6Atul0yRY0n8L/rP4ogUSTe887eUdOHtPRJ4lRbf4KUyGHOqCPLMb9u/5t
 QP1X5cpx2WwnnEjWMY4tJ+FpefZhJ6XdoWkhcVKKPWC8hKoF0nN64yUC9RXQ0vDkeqcEkyet3
 NaIE1cCWmXC0I3Qa/8Ug/pa4fCMtatln8T9vXIhBk5ZeSCwFsNe6wJsaCs0FCZ5glC1XxRBQu
 FpQiT6H6AUvOvg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UHJvdmlkZSBhIGZ1bmN0aW9uIGtzel9zd2l0Y2hfc2h1dGRvd24oKSB3aGljaCBwcm9wZXJseSBz
aHV0cyBkb3duIHRoZSBLU1oKc3dpdGNoIGJ5IHN0b3BwaW5nIHRoZSBtaWJfcmVhZCB3b3JrZXIg
dGhyZWFkIGFuZCB0aGVuIHRlYXJpbmcgZG93biB0aGUgRFNBCnRyZWUuCgpTaWduZWQtb2ZmLWJ5
OiBMaW5vIFNhbmZpbGlwcG8gPExpbm9TYW5maWxpcHBvQGdteC5kZT4KLS0tCiBkcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYyB8IDEzICsrKysrKysrKysrKysKIGRyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oIHwgIDEgKwogMiBmaWxlcyBjaGFuZ2VkLCAx
NCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmMgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYwppbmRl
eCAxNTQyYmZiOGI1ZTUuLmFhYTVjNDVmNDgyMyAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3pfY29tbW9uLmMKKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmMKQEAgLTQ0Niw2ICs0NDYsMTkgQEAgaW50IGtzel9zd2l0Y2hfcmVnaXN0ZXIo
c3RydWN0IGtzel9kZXZpY2UgKmRldiwKIH0KIEVYUE9SVF9TWU1CT0woa3N6X3N3aXRjaF9yZWdp
c3Rlcik7CiAKK3ZvaWQga3N6X3N3aXRjaF9zaHV0ZG93bihzdHJ1Y3Qga3N6X2RldmljZSAqZGV2
KQoreworCXN0cnVjdCBkc2Ffc3dpdGNoICpkcyA9IGRldi0+ZHM7CisKKwkvKiB0aW1lciBzdGFy
dGVkICovCisJaWYgKGRldi0+bWliX3JlYWRfaW50ZXJ2YWwpIHsKKwkJY2FuY2VsX2RlbGF5ZWRf
d29ya19zeW5jKCZkZXYtPm1pYl9yZWFkKTsKKwkJZGV2LT5taWJfcmVhZF9pbnRlcnZhbCA9IDA7
CisJfQorCWRzYV90cmVlX3NodXRkb3duKGRzLT5kc3QpOworfQorRVhQT1JUX1NZTUJPTChrc3pf
c3dpdGNoX3NodXRkb3duKTsKKwogdm9pZCBrc3pfc3dpdGNoX3JlbW92ZShzdHJ1Y3Qga3N6X2Rl
dmljZSAqZGV2KQogewogCS8qIHRpbWVyIHN0YXJ0ZWQgKi8KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3pfY29tbW9uLmgKaW5kZXggMTU5N2M2Mzk4OGI0Li45OTg2ZjZjNGMxZTcgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oCisrKyBiL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oCkBAIC0xNDMsNiArMTQzLDcgQEAgc3RydWN0
IGtzel9kZXZpY2UgKmtzel9zd2l0Y2hfYWxsb2Moc3RydWN0IGRldmljZSAqYmFzZSwgdm9pZCAq
cHJpdik7CiBpbnQga3N6X3N3aXRjaF9yZWdpc3RlcihzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LAog
CQkJY29uc3Qgc3RydWN0IGtzel9kZXZfb3BzICpvcHMpOwogdm9pZCBrc3pfc3dpdGNoX3JlbW92
ZShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KTsKK3ZvaWQga3N6X3N3aXRjaF9zaHV0ZG93bihzdHJ1
Y3Qga3N6X2RldmljZSAqZGV2KTsKIAogaW50IGtzejhfc3dpdGNoX3JlZ2lzdGVyKHN0cnVjdCBr
c3pfZGV2aWNlICpkZXYpOwogaW50IGtzejk0Nzdfc3dpdGNoX3JlZ2lzdGVyKHN0cnVjdCBrc3pf
ZGV2aWNlICpkZXYpOwotLSAKMi4zMy4wCgo=
