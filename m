Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0953512A49
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 06:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240042AbiD1EHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 00:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbiD1EH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 00:07:27 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FB8B986C2;
        Wed, 27 Apr 2022 21:04:10 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 28 Apr 2022 12:03:45
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.64.199]
Date:   Thu, 28 Apr 2022 12:03:45 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org, linma@zju.edu.cn
Subject: Re: Re: [PATCH net v4] nfc: nfcmrvl: main: reorder destructive
 operations in nfcmrvl_nci_unregister_dev to avoid bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220427174548.2ae53b84@kernel.org>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <12cdcfe5.1d62.1806e56d31f.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBXX6ciEmpixLT0AQ--.64701W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggOAVZdtZcUkAABsp
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

SGVsbG8sCgpPbiBXZWQsIDI3IEFwciAyMDIyIDE3OjQ1OjQ4IC0wNzAwIEpha3ViIEtpY2luc2tp
IHdyb3RlOgoKPiA+IGRpZmYgLS1naXQgYS9uZXQvbmZjL2NvcmUuYyBiL25ldC9uZmMvY29yZS5j
Cj4gPiBpbmRleCBkYzdhMjQwNGVmZC4uMWQ5MTMzNGVlODYgMTAwNjQ0Cj4gPiAtLS0gYS9uZXQv
bmZjL2NvcmUuYwo+ID4gKysrIGIvbmV0L25mYy9jb3JlLmMKPiA+IEBAIC0yNSw2ICsyNSw4IEBA
Cj4gPiAgI2RlZmluZSBORkNfQ0hFQ0tfUFJFU19GUkVRX01TCTIwMDAKPiA+ICAKPiA+ICBpbnQg
bmZjX2Rldmxpc3RfZ2VuZXJhdGlvbjsKPiA+ICsvKiBuZmNfZG93bmxvYWQ6IHVzZWQgdG8ganVk
Z2Ugd2hldGhlciBuZmMgZmlybXdhcmUgZG93bmxvYWQgY291bGQgc3RhcnQgKi8KPiA+ICtzdGF0
aWMgYm9vbCBuZmNfZG93bmxvYWQ7Cj4gPiAgREVGSU5FX01VVEVYKG5mY19kZXZsaXN0X211dGV4
KTsKPiA+ICAKPiA+ICAvKiBORkMgZGV2aWNlIElEIGJpdG1hcCAqLwo+ID4gQEAgLTM4LDcgKzQw
LDcgQEAgaW50IG5mY19md19kb3dubG9hZChzdHJ1Y3QgbmZjX2RldiAqZGV2LCBjb25zdCBjaGFy
ICpmaXJtd2FyZV9uYW1lKQo+ID4gIAo+ID4gIAlkZXZpY2VfbG9jaygmZGV2LT5kZXYpOwo+ID4g
IAo+ID4gLQlpZiAoIWRldmljZV9pc19yZWdpc3RlcmVkKCZkZXYtPmRldikpIHsKPiA+ICsJaWYg
KCFkZXZpY2VfaXNfcmVnaXN0ZXJlZCgmZGV2LT5kZXYpIHx8ICFuZmNfZG93bmxvYWQpIHsKPiA+
ICAJCXJjID0gLUVOT0RFVjsKPiA+ICAJCWdvdG8gZXJyb3I7Cj4gPiAgCX0KPiA+IEBAIC0xMTM0
LDYgKzExMzYsNyBAQCBpbnQgbmZjX3JlZ2lzdGVyX2RldmljZShzdHJ1Y3QgbmZjX2RldiAqZGV2
KQo+ID4gIAkJCWRldi0+cmZraWxsID0gTlVMTDsKPiA+ICAJCX0KPiA+ICAJfQo+ID4gKwluZmNf
ZG93bmxvYWQgPSB0cnVlOwo+ID4gIAlkZXZpY2VfdW5sb2NrKCZkZXYtPmRldik7Cj4gPiAgCj4g
PiAgCXJjID0gbmZjX2dlbmxfZGV2aWNlX2FkZGVkKGRldik7Cj4gPiBAQCAtMTE2Niw2ICsxMTY5
LDcgQEAgdm9pZCBuZmNfdW5yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IG5mY19kZXYgKmRldikKPiA+
ICAJCXJma2lsbF91bnJlZ2lzdGVyKGRldi0+cmZraWxsKTsKPiA+ICAJCXJma2lsbF9kZXN0cm95
KGRldi0+cmZraWxsKTsKPiA+ICAJfQo+ID4gKwluZmNfZG93bmxvYWQgPSBmYWxzZTsKPiA+ICAJ
ZGV2aWNlX3VubG9jaygmZGV2LT5kZXYpOwo+ID4gIAo+ID4gIAlpZiAoZGV2LT5vcHMtPmNoZWNr
X3ByZXNlbmNlKSB7Cj4gCj4gWW91IGNhbid0IHVzZSBhIHNpbmdsZSBnbG9iYWwgdmFyaWFibGUs
IHRoZXJlIGNhbiBiZSBtYW55IGRldmljZXMgCj4gZWFjaCB3aXRoIHRoZWlyIG93biBsb2NrLgo+
IAo+IFBhb2xvIHN1Z2dlc3RlZCBhZGRpbmcgYSBsb2NrLCBpZiBzcGluIGxvY2sgZG9lc24ndCBm
aXQgdGhlIGJpbGwKPiB3aHkgbm90IGFkZCBhIG11dGV4PwoKV2UgY291bGQgbm90IHVzZSBtdXRl
eCBlaXRoZXIsIGJlY2F1c2UgdGhlIHJlbGVhc2VfZmlybXdhcmUoKSBpcyBhbHNvIGNhbGxlZCBi
eSBmd19kbmxkX3RpbWVvdXQoKQp3aGljaCBpcyBhIHRpbWVyIGhhbmRsZXIuIElmIHdlIHVzZSBt
dXRleCBsb2NrIGluIGEgdGltZXIgaGFuZGxlciwgaXQgd2lsbCBjYXVzZSBzbGVlcCBpbiBhdG9t
aWMgYnVnLgpUaGUgcHJvY2VzcyBpcyBzaG93biBiZWxvdzoKCm5mY21ydmxfZndfZG5sZF9zdGFy
dAogLi4uICAgICAgICAgICAgICAKIG1vZF90aW1lciAKICh3YWl0IGEgdGltZSkgIAogZndfZG5s
ZF90aW1lb3V0CiAgIGZ3X2RubGRfb3ZlciAKICAgIHJlbGVhc2VfZmlybXdhcmUgICAgICAgCgpJ
IHdpbGwgY2hhbmdlIHRoZSBzaW5nbGUgZ2xvYmFsIHZhcmlhYmxlIHRvIGRldi0+ZGV2X3VwIGZs
YWcsIHdoaWNoIGlzIHNob3duIGJlbG93OgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmZjL25mY21y
dmwvbWFpbi5jIGIvZHJpdmVycy9uZmMvbmZjbXJ2bC9tYWluLmMKaW5kZXggMmZjZjU0NTAxMmIu
LjFhNTI4NGRlNDM0IDEwMDY0NAotLS0gYS9kcml2ZXJzL25mYy9uZmNtcnZsL21haW4uYworKysg
Yi9kcml2ZXJzL25mYy9uZmNtcnZsL21haW4uYwpAQCAtMTgzLDYgKzE4Myw3IEBAIHZvaWQgbmZj
bXJ2bF9uY2lfdW5yZWdpc3Rlcl9kZXYoc3RydWN0IG5mY21ydmxfcHJpdmF0ZSAqcHJpdikKIHsK
ICAgICAgICBzdHJ1Y3QgbmNpX2RldiAqbmRldiA9IHByaXYtPm5kZXY7CgorICAgICAgIG5jaV91
bnJlZ2lzdGVyX2RldmljZShuZGV2KTsKICAgICAgICBpZiAocHJpdi0+bmRldi0+bmZjX2Rldi0+
ZndfZG93bmxvYWRfaW5fcHJvZ3Jlc3MpCiAgICAgICAgICAgICAgICBuZmNtcnZsX2Z3X2RubGRf
YWJvcnQocHJpdik7CgpAQCAtMTkxLDcgKzE5Miw2IEBAIHZvaWQgbmZjbXJ2bF9uY2lfdW5yZWdp
c3Rlcl9kZXYoc3RydWN0IG5mY21ydmxfcHJpdmF0ZSAqcHJpdikKICAgICAgICBpZiAoZ3Bpb19p
c192YWxpZChwcml2LT5jb25maWcucmVzZXRfbl9pbykpCiAgICAgICAgICAgICAgICBncGlvX2Zy
ZWUocHJpdi0+Y29uZmlnLnJlc2V0X25faW8pOwoKLSAgICAgICBuY2lfdW5yZWdpc3Rlcl9kZXZp
Y2UobmRldik7CiAgICAgICAgbmNpX2ZyZWVfZGV2aWNlKG5kZXYpOwogICAgICAgIGtmcmVlKHBy
aXYpOwogfQpkaWZmIC0tZ2l0IGEvbmV0L25mYy9jb3JlLmMgYi9uZXQvbmZjL2NvcmUuYwppbmRl
eCBkYzdhMjQwNGVmZC4uMDlmNTRjNTk5ZmUgMTAwNjQ0Ci0tLSBhL25ldC9uZmMvY29yZS5jCisr
KyBiL25ldC9uZmMvY29yZS5jCkBAIC0xMTY2LDYgKzExNjYsNyBAQCB2b2lkIG5mY191bnJlZ2lz
dGVyX2RldmljZShzdHJ1Y3QgbmZjX2RldiAqZGV2KQogICAgICAgICAgICAgICAgcmZraWxsX3Vu
cmVnaXN0ZXIoZGV2LT5yZmtpbGwpOwogICAgICAgICAgICAgICAgcmZraWxsX2Rlc3Ryb3koZGV2
LT5yZmtpbGwpOwogICAgICAgIH0KKyAgICAgICBkZXYtPmRldl91cCA9IGZhbHNlOwogICAgICAg
IGRldmljZV91bmxvY2soJmRldi0+ZGV2KTsKCiAgICAgICAgaWYgKGRldi0+b3BzLT5jaGVja19w
cmVzZW5jZSkgewoKVGhlIGFib3ZlIHNvbHV0aW9uIGhhcyBiZWVuIHRlc3RlZCwgaXQgaXMgd2Vs
bCBzeW5jaHJvbml6ZWQuCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==
