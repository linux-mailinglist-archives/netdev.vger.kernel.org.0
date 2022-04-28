Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE2C512F04
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbiD1IxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344430AbiD1IxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:53:17 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F25DE165BA;
        Thu, 28 Apr 2022 01:50:01 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 28 Apr 2022 16:49:18
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.13.90]
Date:   Thu, 28 Apr 2022 16:49:18 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        "Duoming Zhou" <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data
 race-able
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YmpNZOaJ1+vWdccK@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
 <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
 <YmpNZOaJ1+vWdccK@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <15d09db2.2f76.1806f5c4187.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgB3HwAOVWpi+aEtAw--.58701W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwIOElNG3GhH9QABsP
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gR3JlZywKCj4gCj4gSXQgc2hvdWxkbid0IGJlLCBpZiB5b3UgYXJlIHVzaW5nIGl0IHBy
b3Blcmx5IDopCj4gCj4gWy4uLl0KPiAKPiBZZXMsIHlvdSBzaG91bGQgYWxtb3N0IG5ldmVyIHVz
ZSB0aGF0IGNhbGwuICBTZWVtcyB0aGUgbmZjIHN1YnN5c3RlbSBpcwo+IHRoZSBtb3N0IGNvbW1v
biB1c2VyIG9mIGl0IGZvciBzb21lIHJlYXNvbiA6KAoKQ29vbCwgYW5kIEkgYmVsaWV2ZSB0aGF0
IHRoZSBjdXJyZW50IG5mYyBjb3JlIGNvZGUgZG9lcyBub3QgdXNlIGl0IHByb3Blcmx5LiA6KAoK
PiAKPiBXaGF0IHN0YXRlIGFyZSB5b3UgdHJ5aW5nIHRvIHRyYWNrIGhlcmUgZXhhY3RseT8KPiAK
CkZvcmdldCBhYm91dCB0aGUgZmlybXdhcmUgZG93bmxvYWRpbmcgcmFjZSB0aGF0IHJhaXNlZCBi
eSBEdW9taW5nIGluIHRoaXMgY2hhbm5lbCwKYWxsIHRoZSBuZXRsaW5rIGhhbmRsZXIgY29kZSBp
biBuZXQvbmZjL2NvcmUuYyBkZXBlbmRzIG9uIHRoZSBkZXZpY2VfaXNfcmVnaXN0ZXJlZAptYWNy
by4KCk15IGlkZWEgaXMgdG8gaW50cm9kdWNlIGEgcGF0Y2ggbGlrZSBiZWxvdzoKCiBpbmNsdWRl
L25ldC9uZmMvbmZjLmggfCAgMSArCiBuZXQvbmZjL2NvcmUuYyAgICAgICAgfCAyNiArKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAx
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9uZmMvbmZjLmggYi9pbmNs
dWRlL25ldC9uZmMvbmZjLmgKaW5kZXggNWRlZTU3NWZiZTg2Li5kODRlNTM4MDJiMDYgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvbmV0L25mYy9uZmMuaAorKysgYi9pbmNsdWRlL25ldC9uZmMvbmZjLmgK
QEAgLTE2OCw2ICsxNjgsNyBAQCBzdHJ1Y3QgbmZjX2RldiB7CiAJaW50IHRhcmdldHNfZ2VuZXJh
dGlvbjsKIAlzdHJ1Y3QgZGV2aWNlIGRldjsKIAlib29sIGRldl91cDsKKwlib29sIGRldl9yZWdp
c3RlcjsKIAlib29sIGZ3X2Rvd25sb2FkX2luX3Byb2dyZXNzOwogCXU4IHJmX21vZGU7CiAJYm9v
bCBwb2xsaW5nOwpkaWZmIC0tZ2l0IGEvbmV0L25mYy9jb3JlLmMgYi9uZXQvbmZjL2NvcmUuYwpp
bmRleCBkYzdhMjQwNGVmZGYuLjIwOGU2YmIwODA0ZSAxMDA2NDQKLS0tIGEvbmV0L25mYy9jb3Jl
LmMKKysrIGIvbmV0L25mYy9jb3JlLmMKQEAgLTM4LDcgKzM4LDcgQEAgaW50IG5mY19md19kb3du
bG9hZChzdHJ1Y3QgbmZjX2RldiAqZGV2LCBjb25zdCBjaGFyICpmaXJtd2FyZV9uYW1lKQogCiAJ
ZGV2aWNlX2xvY2soJmRldi0+ZGV2KTsKIAotCWlmICghZGV2aWNlX2lzX3JlZ2lzdGVyZWQoJmRl
di0+ZGV2KSkgeworCWlmICghZGV2LT5kZXZfcmVnaXN0ZXIpIHsKIAkJcmMgPSAtRU5PREVWOwog
CQlnb3RvIGVycm9yOwogCX0KQEAgLTk0LDcgKzk0LDcgQEAgaW50IG5mY19kZXZfdXAoc3RydWN0
IG5mY19kZXYgKmRldikKIAogCWRldmljZV9sb2NrKCZkZXYtPmRldik7CiAKLQlpZiAoIWRldmlj
ZV9pc19yZWdpc3RlcmVkKCZkZXYtPmRldikpIHsKKwlpZiAoIWRldi0+ZGV2X3JlZ2lzdGVyKSB7
CiAJCXJjID0gLUVOT0RFVjsKIAkJZ290byBlcnJvcjsKIAl9CgpbLi4uXQoKQEAgLTExMzQsNiAr
MTEzNCw3IEBAIGludCBuZmNfcmVnaXN0ZXJfZGV2aWNlKHN0cnVjdCBuZmNfZGV2ICpkZXYpCiAJ
CQlkZXYtPnJma2lsbCA9IE5VTEw7CiAJCX0KIAl9CisJZGV2LT5kZXZfcmVnaXN0ZXIgPSB0cnVl
OwogCWRldmljZV91bmxvY2soJmRldi0+ZGV2KTsKIAogCXJjID0gbmZjX2dlbmxfZGV2aWNlX2Fk
ZGVkKGRldik7CkBAIC0xMTYyLDYgKzExNjMsNyBAQCB2b2lkIG5mY191bnJlZ2lzdGVyX2Rldmlj
ZShzdHJ1Y3QgbmZjX2RldiAqZGV2KQogCQkJICJ3YXMgcmVtb3ZlZFxuIiwgZGV2X25hbWUoJmRl
di0+ZGV2KSk7CiAKIAlkZXZpY2VfbG9jaygmZGV2LT5kZXYpOworCWRldi0+ZGV2X3JlZ2lzdGVy
ID0gZmFsc2U7CiAJaWYgKGRldi0+cmZraWxsKSB7CiAJCXJma2lsbF91bnJlZ2lzdGVyKGRldi0+
cmZraWxsKTsKIAkJcmZraWxsX2Rlc3Ryb3koZGV2LT5yZmtpbGwpOwotLSAKMi4zNS4xCgpUaGUg
YWRkZWQgZGV2X3JlZ2lzdGVyIHZhcmlhYmxlIGNhbiBmdW5jdGlvbiBsaWtlIHRoZSBvcmlnaW5h
bCBkZXZpY2VfaXNfcmVnaXN0ZXJlZCBhbmQgZG9lcyBub3QgcmFjZS1hYmxlCmJlY2F1c2Ugb2Yg
dGhlIHByb3RlY3Rpb24gb2YgZGV2aWNlX2xvY2suCgpJIHRoaW5rIGFmdGVyIHN1Y2ggYSBwYXRj
aCBpcyBhZG9wdGVkLCB0aGUgcmVvcmRlciB2ZXJzaW9uIG9mIHBhdGNoIGZyb20gRHVvbWluZyAK
LT4gaHR0cHM6Ly9saXN0cy5vcGVud2FsbC5uZXQvbmV0ZGV2LzIwMjIvMDQvMjUvMTAKY2FuIGJl
IHVzZWQgdG8gZml4IHRoZSBmaXJtd2FyZSBkb3dubG9hZGluZyBidWcuCgpEbyB5b3UgYWdyZWUg
b24gdGhpcyBvciBzaG91bGQgd2UgdXNlIGFub3RoZXIgbWFjcm8gdGhhdCBpcyBzdWl0YWJsZSB0
aGFuIGRldmljZV9pc19yZWdpc3RlcmVkPwoKPiB0aGFua3MsCj4gCj4gZ3JlZyBrLWgKClRoYW5r
cwpMaW4K
