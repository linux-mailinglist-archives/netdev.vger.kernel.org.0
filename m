Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343C719B77D
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 23:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgDAVUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 17:20:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45593 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732357AbgDAVUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 17:20:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id t7so1743535wrw.12;
        Wed, 01 Apr 2020 14:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:from:to:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=wE5IrcFyTU4EBSYuKo8VVt2iDVJGzIH5aU08VbBxBmU=;
        b=G3yh+iglyB0XV8SURb3qngC383swlL9Ex8igoLzL60ZR75plIcwZ0s0iozcWbuPc5z
         WfR5r/zcuMctq/+5bmCdcr3L8qP4Hg/bfI4nrLS3HHzH4Zi8r3uKK+xoUGH4FXeAdGY3
         vJhndFug21av8wI8heN+YSjlrKQJPCzTcDenoqd4OH/CvfbmruSwdC1Ve60GH9FYfJSN
         RgeUwICMF5XInYvrIqEZJV5+UAIfxYC5TK7KpVsLZXo/9CPszyELjqpPAOBTdOCa8+jX
         RTJPaeVL3NsFa1/1ON4Jtm6+AhZdc0BqqPnAZxgQCkp0U0mh9xZEgQefd6XwRnfGaA+W
         qtrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:from:to:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=wE5IrcFyTU4EBSYuKo8VVt2iDVJGzIH5aU08VbBxBmU=;
        b=lNNJORSaaX+Mqc7cme9SmpGV5IkFLAhee+SFpEYQPN/DOGDkqO/7AT3DFZDyl//XSQ
         YCFJk+4acMzWm27ZD0TXX2SQcU12CpylIOr1luS0nNlXrRSuqu7QNsokJ+6BAmB1M0Oi
         CQPQnGMDuC6Ybx9Zia9V+9tzyW0akdE8YqDVo39C8pAz+q0rRGsYlibusoaAcFblc/sd
         ZThSxdAQuIWZv6hVRkpgrp+f0S4hSFDhdPTjiwgXKldpIqyZwIKmk0p27EdgrsYrwYZe
         1TvZXCSmGWhmn2Wp1QnYBEYztjEVPZ5c3lId9Aggmn3c3AWl//btyXbfzLEJ4Onp7mCs
         R5yw==
X-Gm-Message-State: ANhLgQ0BZtyUSd1DLAVfGcDH7dBfpVobtFjjt2CZIh3XsOdOM9B+NJUL
        rYGFOav4/Lik9p8Ny6kbo/s=
X-Google-Smtp-Source: ADFU+vtmzMlG8HPbtuuzra9qEDWJkdSHD6IZ4c/JXjvG04onuzsy333B98RGa0xVBM3i98gThERtZQ==
X-Received: by 2002:a5d:4085:: with SMTP id o5mr26427725wrp.327.1585776029213;
        Wed, 01 Apr 2020 14:20:29 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:3878:c820:d9e6:1e25? (p200300EA8F2960003878C820D9E61E25.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3878:c820:d9e6:1e25])
        by smtp.googlemail.com with ESMTPSA id y15sm4372861wrh.50.2020.04.01.14.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 14:20:28 -0700 (PDT)
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-module@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>,
        Jessica Yu <jeyu@kernel.org>
Subject: RFC: Handle hard module dependencies that are not symbol-based (r8169
 + realtek)
Message-ID: <f8e3f271-82df-165f-63f1-6df73ba3d59c@gmail.com>
Date:   Wed, 1 Apr 2020 23:20:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4E4720F8156463A4A67A6B38"
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------4E4720F8156463A4A67A6B38
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Currently we have no way to express a hard dependency that is not
a symbol-based dependency (symbol defined in module A is used in
module B). Use case:
Network driver ND uses callbacks in the dedicated PHY driver DP
for the integrated PHY (namely read_page() and write_page() in
struct phy_driver). If DP can't be loaded (e.g. because ND is in
initramfs but DP is not), then phylib will use the generic
PHY driver GP. GP doesn't implement certain callbacks that are
needed by ND, therefore ND's probe has to bail out with an error
once it detects that DP is not loaded.
We have this problem with driver r8169 having such a dependency
on PHY driver realtek. Some distributions have tools for
configuring initramfs that consider hard dependencies based on
depmod output. Means so far somebody can add r8169.ko to initramfs,
and neither human being nor machine will have an idea that
realtek.ko needs to be added too.

Attached patch set (two patches for kmod, one for the kernel)
allows to express this hard dependency of ND from DP. depmod will
read this dependency information and treat it like a symbol-based
dependency. As a result tools e.g. populating initramfs can
consider the dependency and place DP in initramfs if ND is in
initramfs. On my system the patch set does the trick when
adding following line to r8169_main.c:
MODULE_HARDDEP("realtek");

I'm interested in your opinion on the patches, and whether you
maybe have a better idea how to solve the problem.

Heiner

--------------4E4720F8156463A4A67A6B38
Content-Type: text/plain; charset=UTF-8;
 name="0001-depmod-add-helper-mod_add_dep_unique.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-depmod-add-helper-mod_add_dep_unique.patch"

RnJvbSAyOTBlN2RlZTlmNjA0M2Q2NzdmMDhkYzA2ZTYxMmUxM2VlMGQyZDgzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21h
aWwuY29tPgpEYXRlOiBUdWUsIDMxIE1hciAyMDIwIDIzOjAyOjQ3ICswMjAwClN1YmplY3Q6
IFtQQVRDSCAxLzJdIGRlcG1vZDogYWRkIGhlbHBlciBtb2RfYWRkX2RlcF91bmlxdWUKCkNy
ZWF0ZSBuZXcgaGVscGVyIG1vZF9hZGRfZGVwX3VuaXF1ZSgpLCBuZXh0IHBhdGNoIGluIHRo
aXMgc2VyaWVzIHdpbGwKYWxzbyBtYWtlIHVzZSBvZiBpdC4KClNpZ25lZC1vZmYtYnk6IEhl
aW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+Ci0tLQogdG9vbHMvZGVwbW9k
LmMgfCAyNiArKysrKysrKysrKysrKysrKysrLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE5
IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdG9vbHMvZGVw
bW9kLmMgYi90b29scy9kZXBtb2QuYwppbmRleCA4NzVlMzE0Li41NDE5ZDRkIDEwMDY0NAot
LS0gYS90b29scy9kZXBtb2QuYworKysgYi90b29scy9kZXBtb2QuYwpAQCAtOTA3LDIzICs5
MDcsMzUgQEAgc3RhdGljIHZvaWQgbW9kX2ZyZWUoc3RydWN0IG1vZCAqbW9kKQogCWZyZWUo
bW9kKTsKIH0KIAotc3RhdGljIGludCBtb2RfYWRkX2RlcGVuZGVuY3koc3RydWN0IG1vZCAq
bW9kLCBzdHJ1Y3Qgc3ltYm9sICpzeW0pCitzdGF0aWMgaW50IG1vZF9hZGRfZGVwX3VuaXF1
ZShzdHJ1Y3QgbW9kICptb2QsIHN0cnVjdCBtb2QgKmRlcCkKIHsKIAlpbnQgZXJyOwogCi0J
REJHKCIlcyBkZXBlbmRzIG9uICVzICVzXG4iLCBtb2QtPnBhdGgsIHN5bS0+bmFtZSwKLQkg
ICAgc3ltLT5vd25lciAhPSBOVUxMID8gc3ltLT5vd25lci0+cGF0aCA6ICIodW5rbm93biki
KTsKLQotCWlmIChzeW0tPm93bmVyID09IE5VTEwpCisJaWYgKGRlcCA9PSBOVUxMKQogCQly
ZXR1cm4gMDsKIAotCWVyciA9IGFycmF5X2FwcGVuZF91bmlxdWUoJm1vZC0+ZGVwcywgc3lt
LT5vd25lcik7CisJZXJyID0gYXJyYXlfYXBwZW5kX3VuaXF1ZSgmbW9kLT5kZXBzLCBkZXAp
OwogCWlmIChlcnIgPT0gLUVFWElTVCkKIAkJcmV0dXJuIDA7CiAJaWYgKGVyciA8IDApCiAJ
CXJldHVybiBlcnI7CiAKLQlzeW0tPm93bmVyLT51c2VycysrOworCWRlcC0+dXNlcnMrKzsK
KworCXJldHVybiAxOworfQorCitzdGF0aWMgaW50IG1vZF9hZGRfZGVwZW5kZW5jeShzdHJ1
Y3QgbW9kICptb2QsIHN0cnVjdCBzeW1ib2wgKnN5bSkKK3sKKwlpbnQgZXJyOworCisJREJH
KCIlcyBkZXBlbmRzIG9uICVzICVzXG4iLCBtb2QtPnBhdGgsIHN5bS0+bmFtZSwKKwkgICAg
c3ltLT5vd25lciAhPSBOVUxMID8gc3ltLT5vd25lci0+cGF0aCA6ICIodW5rbm93bikiKTsK
KworCWVyciA9IG1vZF9hZGRfZGVwX3VuaXF1ZShtb2QsIHN5bS0+b3duZXIpOworCWlmIChl
cnIgPD0gMCkKKwkJcmV0dXJuIGVycjsKKwogCVNIT1coIiVzIG5lZWRzIFwiJXNcIjogJXNc
biIsIG1vZC0+cGF0aCwgc3ltLT5uYW1lLCBzeW0tPm93bmVyLT5wYXRoKTsKIAlyZXR1cm4g
MDsKIH0KLS0gCjIuMjYuMAoK
--------------4E4720F8156463A4A67A6B38
Content-Type: text/plain; charset=UTF-8;
 name="0001-module-add-MODULE_HARDDEP.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-module-add-MODULE_HARDDEP.patch"

RnJvbSBiMTJmYTBkODViMjFkODRjZGY0NTA5YzUwNDhjNjdlMTc5MTRlYjI4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21h
aWwuY29tPgpEYXRlOiBNb24sIDMwIE1hciAyMDIwIDE3OjEyOjQ0ICswMjAwClN1YmplY3Q6
IFtQQVRDSF0gbW9kdWxlOiBhZGQgTU9EVUxFX0hBUkRERVAKCkN1cnJlbnRseSB3ZSBoYXZl
IG5vIHdheSB0byBleHByZXNzIGEgaGFyZCBkZXBlbmRlbmN5IHRoYXQgaXMgbm90IGEKc3lt
Ym9sLWJhc2VkIGRlcGVuZGVuY3kgKHN5bWJvbCBkZWZpbmVkIGluIG1vZHVsZSBBIGlzIHVz
ZWQgaW4KbW9kdWxlIEIpLiBVc2UgY2FzZToKTmV0d29yayBkcml2ZXIgTkQgdXNlcyBjYWxs
YmFja3MgaW4gdGhlIGRlZGljYXRlZCBQSFkgZHJpdmVyIERQCmZvciB0aGUgaW50ZWdyYXRl
ZCBQSFkuIElmIERQIGNhbid0IGJlIGxvYWRlZCAoZS5nLiBiZWNhdXNlIE5ECmlzIGluIGlu
aXRyYW1mcyBidXQgRFAgaXMgbm90KSwgdGhlbiBwaHlsaWIgd2lsbCBsb2FkIHRoZSBnZW5l
cmljClBIWSBkcml2ZXIgR1AuIEdQIGRvZXNuJ3QgaW1wbGVtZW50IGNlcnRhaW4gY2FsbGJh
Y2tzIHRoYXQgYXJlCnVzZWQgYnkgTkQsIHRoZXJlZm9yZSBORCdzIHByb2JlIGhhcyB0byBi
YWlsIG91dCB3aXRoIGFuIGVycm9yCm9uY2UgaXQgZGV0ZWN0cyB0aGF0IERQIGlzIG5vdCBs
b2FkZWQuClRoaXMgcGF0Y2ggYWxsb3dzIHRvIGV4cHJlc3MgdGhpcyBoYXJkIGRlcGVuZGVu
Y3kgb2YgTkQgZnJvbSBEUC4KZGVwbW9kIHdpbGwgcmVhZCB0aGlzIGRlcGVuZGVuY3kgaW5m
b3JtYXRpb24gYW5kIHRyZWF0IGl0IGxpa2UKYSBzeW1ib2wtYmFzZWQgZGVwZW5kZW5jeS4g
QXMgYSByZXN1bHQgdG9vbHMgZS5nLiBwb3B1bGF0aW5nCmluaXRyYW1mcyBjYW4gY29uc2lk
ZXIgdGhlIGRlcGVuZGVuY3kgYW5kIHBsYWNlIERQIGluIGluaXRyYW1mcwppZiBORCBpcyBp
biBpbml0cmFtZnMuCgpTaWduZWQtb2ZmLWJ5OiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2Vp
dDFAZ21haWwuY29tPgotLS0KIGluY2x1ZGUvbGludXgvbW9kdWxlLmggfCA1ICsrKysrCiAx
IGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9s
aW51eC9tb2R1bGUuaCBiL2luY2x1ZGUvbGludXgvbW9kdWxlLmgKaW5kZXggMWFkMzkzZTYy
Li5mMzhkNDEwN2YgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbW9kdWxlLmgKKysrIGIv
aW5jbHVkZS9saW51eC9tb2R1bGUuaApAQCAtMTY5LDYgKzE2OSwxMSBAQCBleHRlcm4gdm9p
ZCBjbGVhbnVwX21vZHVsZSh2b2lkKTsKICAqLwogI2RlZmluZSBNT0RVTEVfU09GVERFUChf
c29mdGRlcCkgTU9EVUxFX0lORk8oc29mdGRlcCwgX3NvZnRkZXApCiAKKy8qIEhhcmQgbW9k
dWxlIGRlcGVuZGVuY2llcyB0aGF0IGFyZSBub3QgY29kZSBkZXBlbmRlbmNpZXMKKyAqIEV4
YW1wbGU6IE1PRFVMRV9IQVJEREVQKCJtb2R1bGUtZm9vIG1vZHVsZS1iYXIiKQorICovCisj
ZGVmaW5lIE1PRFVMRV9IQVJEREVQKF9oYXJkZGVwKSBNT0RVTEVfSU5GTyhoYXJkZGVwLCBf
aGFyZGRlcCkKKwogLyoKICAqIE1PRFVMRV9GSUxFIGlzIHVzZWQgZm9yIGdlbmVyYXRpbmcg
bW9kdWxlcy5idWlsdGluCiAgKiBTbywgbWFrZSBpdCBuby1vcCB3aGVuIHRoaXMgaXMgYmVp
bmcgYnVpbHQgYXMgYSBtb2R1bGUKLS0gCjIuMjYuMAoK
--------------4E4720F8156463A4A67A6B38
Content-Type: text/plain; charset=UTF-8;
 name="0002-depmod-add-depmod_load_harddeps.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0002-depmod-add-depmod_load_harddeps.patch"

RnJvbSBhZjNhMjU4MzNhMTYwZTAyOTQ0MWVhZjVhOTNmN2M4NjI1NTQ0Mjk2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21h
aWwuY29tPgpEYXRlOiBXZWQsIDEgQXByIDIwMjAgMjI6NDI6NTUgKzAyMDAKU3ViamVjdDog
W1BBVENIIDIvMl0gZGVwbW9kOiBhZGQgZGVwbW9kX2xvYWRfaGFyZGRlcHMKCkxvYWQgZXhw
bGljaXRseSBkZWNsYXJlZCBoYXJkIGRlcGVuZGVuY3kgaW5mb3JtYXRpb24gZnJvbSBtb2R1
bGVzIGFuZAphZGQgaXQgdG8gdGhlIHN5bWJvbC1kZXJpdmVkIGRlcGVuZGVuY2llcy4gVGhp
cyB3aWxsIGFsbG93CmRlcG1vZC1iYXNlZCB0b29scyB0byBjb25zaWRlciBoYXJkIGRlcGVu
ZGVuY2llcyB0aGF0IGFyZSBub3QgY29kZQpkZXBlbmRlbmNpZXMuCgpTaWduZWQtb2ZmLWJ5
OiBIZWluZXIgS2FsbHdlaXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPgotLS0KIHRvb2xzL2Rl
cG1vZC5jIHwgMzggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIDEg
ZmlsZSBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvdG9vbHMvZGVw
bW9kLmMgYi90b29scy9kZXBtb2QuYwppbmRleCA1NDE5ZDRkLi41NzcxZGM5IDEwMDY0NAot
LS0gYS90b29scy9kZXBtb2QuYworKysgYi90b29scy9kZXBtb2QuYwpAQCAtMTUyMiw2ICsx
NTIyLDQxIEBAIHN0YXRpYyBzdHJ1Y3Qgc3ltYm9sICpkZXBtb2Rfc3ltYm9sX2ZpbmQoY29u
c3Qgc3RydWN0IGRlcG1vZCAqZGVwbW9kLAogCXJldHVybiBoYXNoX2ZpbmQoZGVwbW9kLT5z
eW1ib2xzLCBuYW1lKTsKIH0KIAorc3RhdGljIHZvaWQgZGVwbW9kX2xvYWRfaGFyZGRlcHMo
c3RydWN0IGRlcG1vZCAqZGVwbW9kLCBzdHJ1Y3QgbW9kICptb2QpCit7CisKKwlzdHJ1Y3Qg
a21vZF9saXN0ICpsOworCisJa21vZF9saXN0X2ZvcmVhY2gobCwgbW9kLT5pbmZvX2xpc3Qp
IHsKKwkJY29uc3QgY2hhciAqa2V5ID0ga21vZF9tb2R1bGVfaW5mb19nZXRfa2V5KGwpOwor
CQljb25zdCBjaGFyICpkZXBfbmFtZTsKKwkJc3RydWN0IG1vZCAqZGVwOworCQljaGFyICp2
YWx1ZTsKKworCQlpZiAoIXN0cmVxKGtleSwgImhhcmRkZXAiKSkKKwkJCWNvbnRpbnVlOwor
CisJCXZhbHVlID0gc3RyZHVwKGttb2RfbW9kdWxlX2luZm9fZ2V0X3ZhbHVlKGwpKTsKKwkJ
aWYgKHZhbHVlID09IE5VTEwpCisJCQlyZXR1cm47CisKKwkJZGVwX25hbWUgPSBzdHJ0b2so
dmFsdWUsICIgXHQiKTsKKworCQl3aGlsZSAoZGVwX25hbWUpIHsKKwkJCWRlcCA9IGhhc2hf
ZmluZChkZXBtb2QtPm1vZHVsZXNfYnlfbmFtZSwgZGVwX25hbWUpOworCQkJaWYgKGRlcCkK
KwkJCQltb2RfYWRkX2RlcF91bmlxdWUobW9kLCBkZXApOworCQkJZWxzZQorCQkJCVdSTigi
aGFyZGRlcDogJXM6IHVua25vd24gZGVwZW5kZW5jeSAlc1xuIiwKKwkJCQkgICAgbW9kLT5t
b2RuYW1lLCBkZXBfbmFtZSk7CisKKwkJCWRlcF9uYW1lID0gc3RydG9rKE5VTEwsICIgXHQi
KTsKKwkJfQorCisJCWZyZWUodmFsdWUpOworCX0KK30KKwogc3RhdGljIGludCBkZXBtb2Rf
bG9hZF9tb2R1bGVzKHN0cnVjdCBkZXBtb2QgKmRlcG1vZCkKIHsKIAlzdHJ1Y3QgbW9kICoq
aXRyLCAqKml0cl9lbmQ7CkBAIC0xNTY5LDYgKzE2MDQsOSBAQCBzdGF0aWMgaW50IGRlcG1v
ZF9sb2FkX21vZHVsZV9kZXBlbmRlbmNpZXMoc3RydWN0IGRlcG1vZCAqZGVwbW9kLCBzdHJ1
Y3QgbW9kICptbwogCXN0cnVjdCBrbW9kX2xpc3QgKmw7CiAKIAlEQkcoImRvIGRlcGVuZGVu
Y2llcyBvZiAlc1xuIiwgbW9kLT5wYXRoKTsKKworCWRlcG1vZF9sb2FkX2hhcmRkZXBzKGRl
cG1vZCwgbW9kKTsKKwogCWttb2RfbGlzdF9mb3JlYWNoKGwsIG1vZC0+ZGVwX3N5bV9saXN0
KSB7CiAJCWNvbnN0IGNoYXIgKm5hbWUgPSBrbW9kX21vZHVsZV9kZXBlbmRlbmN5X3N5bWJv
bF9nZXRfc3ltYm9sKGwpOwogCQl1aW50NjRfdCBjcmMgPSBrbW9kX21vZHVsZV9kZXBlbmRl
bmN5X3N5bWJvbF9nZXRfY3JjKGwpOwotLSAKMi4yNi4wCgo=
--------------4E4720F8156463A4A67A6B38--
