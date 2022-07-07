Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36F95697EA
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 04:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiGGCXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 22:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbiGGCX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 22:23:28 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F40A13F34;
        Wed,  6 Jul 2022 19:23:25 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Jul 2022 10:23:09
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.66.67]
Date:   Thu, 7 Jul 2022 10:23:09 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net v2] net: rose: fix UAF bug caused by
 rose_t0timer_expiry
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220706190237.477f24ee@kernel.org>
References: <20220705125610.77971-1-duoming@zju.edu.cn>
 <20220706190237.477f24ee@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1dd7d69d.2fd66.181d677e20d.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgBnaTyNQ8ZiBJMAAA--.121W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkEAVZdtajsngABsr
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBXZWQsIDYgSnVsIDIwMjIgMTk6MDI6MzcgLTA3MDAgSmFrdWIgS2ljaW5za2k6
Cgo+IE9uIFR1ZSwgIDUgSnVsIDIwMjIgMjA6NTY6MTAgKzA4MDAgRHVvbWluZyBaaG91IHdyb3Rl
Ogo+ID4gKwlkZWxfdGltZXJfc3luYygmcm9zZV9uZWlnaC0+dDB0aW1lcik7Cj4gCj4gLyoqCj4g
ICogZGVsX3RpbWVyX3N5bmMgLSBkZWFjdGl2YXRlIGEgdGltZXIgYW5kIHdhaXQgZm9yIHRoZSBo
YW5kbGVyIHRvIGZpbmlzaC4KPiBbLi4uXQo+ICAqIFN5bmNocm9uaXphdGlvbiBydWxlczogQ2Fs
bGVycyBtdXN0IHByZXZlbnQgcmVzdGFydGluZyBvZiB0aGUgdGltZXIsCj4gICogb3RoZXJ3aXNl
IHRoaXMgZnVuY3Rpb24gaXMgbWVhbmluZ2xlc3MuCj4gCj4gaG93IGlzIHRoZSByZXN0YXJ0aW5n
IHByZXZlbnRlZD8gSWYgSSdtIGxvb2tpbmcgcmlnaHQgCj4gcm9zZV90MHRpbWVyX2V4cGlyeSgp
IHJlYXJtcyB0aGUgdGltZXIuCgpUaGUgZGVsX3RpbWVyX3N5bmMoKSBjb3VsZCBzdG9wIHRoZSB0
aW1lciB0aGF0IHJlc3RhcnQgaXRzZWxmIGluCml0cyB0aW1lciBjYWxsYmFjayBmdW5jdGlvbi4K
ClRoZSByb290IGNhdXNlIGlzIHNob3duIGJlbG93IHdoaWNoIGlzIGEgcGFydCBvZiBjb2RlIGlu
CmRlbF90aW1lcl9zeW5jOgoKCWRvIHsKCQlyZXQgPSB0cnlfdG9fZGVsX3RpbWVyX3N5bmModGlt
ZXIpOwoKCQlpZiAodW5saWtlbHkocmV0IDwgMCkpIHsKCQkJZGVsX3RpbWVyX3dhaXRfcnVubmlu
Zyh0aW1lcik7CgkJCWNwdV9yZWxheCgpOwoJCX0KCX0gd2hpbGUgKHJldCA8IDApOwoKaHR0cHM6
Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvbGF0ZXN0L3NvdXJjZS9rZXJuZWwvdGltZS90aW1l
ci5jI0wxMzgxCgpJZiB0aGUgdGltZXIgY2FsbGJhY2sgZnVuY3Rpb24gaXMgcnVubmluZywgdGhl
IHRyeV90b19kZWxfdGltZXJfc3luYwp3aWxsIHJldHVybiAtMS4gVGhlbiwgaXQgd2lsbCBsb29w
IHVudGlsIHRoZSB0aW1lciBpcyBub3QgcXVldWVkIGFuZAp0aGUgaGFuZGxlciBpcyBub3QgcnVu
bmluZyBvbiBhbnkgQ1BVLgoKQWx0aG91Z2ggdGhlIHRpbWVyIG1heSByZXN0YXJ0IGl0c2VsZiBp
biB0aW1lciBjYWxsYmFjayBmdW5jdGlvbiwgdGhlCmRlbF90aW1lcl9zeW5jIGNvdWxkIGFsc28g
c3RvcCBpdC4KCkluIG9yZGVyIHRvIGZ1cnRoZXIgcHJvdmUgdGhlIGRlbF90aW1lcl9zeW5jKCkg
Y291bGQgc3RvcCB0aGUgdGltZXIgdGhhdApyZXN0YXJ0IGl0c2VsZiBpbiBpdHMgdGltZXIgaGFu
ZGxlciwgSSB3cm90ZSB0aGUgZm9sbG93aW5nIGtlcm5lbCBtb2R1bGUKd2hvZXMgcGFydCBvZiBj
b2RlIGlzIHNob3duIGJlbG93OgoKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KCnN0cnVjdCB0aW1lcl9saXN0IG15X3RpbWVy
OwpzdGF0aWMgdm9pZCBteV90aW1lcl9jYWxsYmFjayhzdHJ1Y3QgdGltZXJfbGlzdCAqdGltZXIp
OwpzdGF0aWMgdm9pZCBzdGFydF90aW1lcih2b2lkKTsKCnN0YXRpYyB2b2lkIHN0YXJ0X3RpbWVy
KHZvaWQpewogICAgZGVsX3RpbWVyKCZteV90aW1lcik7CiAgICBteV90aW1lci5leHBpcmVzID0g
amlmZmllcytIWjsKICAgIG15X3RpbWVyLmZ1bmN0aW9uID0gbXlfdGltZXJfY2FsbGJhY2s7CiAg
ICBhZGRfdGltZXIoJm15X3RpbWVyKTsKfQoKc3RhdGljIHZvaWQgbXlfdGltZXJfY2FsbGJhY2so
c3RydWN0IHRpbWVyX2xpc3QgKnRpbWVyKXsKICAgIHByaW50aygiSW4gbXlfdGltZXJfZnVuY3Rp
b24iKTsKICAgIHByaW50aygidGhlIGppZmZpZXMgaXMgJWxkXG4iLGppZmZpZXMpOwogICAgc3Rh
cnRfdGltZXIoKTsKfQoKc3RhdGljIGludCBfX2luaXQgZGVsX3RpbWVyX3N5bmNfaW5pdCh2b2lk
KQp7CiAgICBpbnQgcmVzdWx0OwogICAgcHJpbnRrKCJteV90aW1lciB3aWxsIGJlIGNyZWF0ZS5c
biIpOwogICAgcHJpbnRrKCJ0aGUgamlmZmllcyBpcyA6JWxkXG4iLCBqaWZmaWVzKTsKICAgIHRp
bWVyX3NldHVwKCZteV90aW1lcixteV90aW1lcl9jYWxsYmFjaywwKTsKICAgIHJlc3VsdCA9IG1v
ZF90aW1lcigmbXlfdGltZXIsamlmZmllcyArIFNJWFBfVFhERUxBWSk7CiAgICBwcmludGsoInRo
ZSBtb2RfdGltZXIgaXMgOiVkXG5cbiIscmVzdWx0KTsKICAgIHJldHVybiAwOwp9CgpzdGF0aWMg
dm9pZCBfX2V4aXQgZGVsX3RpbWVyX3N5bmNfZXhpdCh2b2lkKQp7CiAgICBpbnQgcmVzdWx0PWRl
bF90aW1lcl9zeW5jKCZteV90aW1lcik7CiAgICBwcmludGsoInRoZSBkZWxfdGltZXJfc3luYyBp
cyA6JWRcblxuIiwgcmVzdWx0KTsKfQoKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KClRoZSB0aW1lciBoYW5kbGVyIGlzIHJ1
bm5pbmcgZnJvbSBpbnRlcnJ1cHRzIGFuZCBkZWxfdGltZXJfc3luYygpIGNvdWxkIHN0b3AKdGhl
IHRpbWVyIHRoYXQgcmV3aW5kIGl0c2VsZiBpbiBpdHMgdGltZXIgaGFuZGxlciwgdGhlIHJlc3Vs
dCBpcyBzaG93biBiZWxvdzoKCiMgaW5zbW9kIGRlbF90aW1lcl9zeW5jLmtvIApbICAxMDMuNTA1
ODU3XSBteV90aW1lciB3aWxsIGJlIGNyZWF0ZS4KWyAgMTAzLjUwNTkyMl0gdGhlIGppZmZpZXMg
aXMgOjQyOTQ3NzA4MzIKWyAgMTAzLjUwNjg0NV0gdGhlIG1vZF90aW1lciBpcyA6MApbICAxMDMu
NTA2ODQ1XSAKIyBbICAxMDMuNTMyMzg5XSBJbiBteV90aW1lcl9mdW5jdGlvbgpbICAxMDMuNTMy
NDUyXSB0aGUgamlmZmllcyBpcyA0Mjk0NzcwODU5ClsgIDEwNC41NzY3NjhdIEluIG15X3RpbWVy
X2Z1bmN0aW9uClsgIDEwNC41NzcwOTZdIHRoZSBqaWZmaWVzIGlzIDQyOTQ3NzE5MDQKWyAgMTA1
LjYwMDk0MV0gSW4gbXlfdGltZXJfZnVuY3Rpb24KWyAgMTA1LjYwMTA3Ml0gdGhlIGppZmZpZXMg
aXMgNDI5NDc3MjkyOApbICAxMDYuNjI1Mzk3XSBJbiBteV90aW1lcl9mdW5jdGlvbgpbICAxMDYu
NjI1NTczXSB0aGUgamlmZmllcyBpcyA0Mjk0NzczOTUyClsgIDEwNy42NDg5OTVdIEluIG15X3Rp
bWVyX2Z1bmN0aW9uClsgIDEwNy42NDkyMTJdIHRoZSBqaWZmaWVzIGlzIDQyOTQ3NzQ5NzYKWyAg
MTA4LjY3MzAzN10gSW4gbXlfdGltZXJfZnVuY3Rpb24KWyAgMTA4LjY3Mzc4N10gdGhlIGppZmZp
ZXMgaXMgNDI5NDc3NjAwMQpybW1vZCBkZWxfdGltZXJfc3luYy5rbwpbICAxMDkuNjQ5NDgyXSB0
aGUgZGVsX3RpbWVyX3N5bmMgaXMgOjEKWyAgMTA5LjY0OTQ4Ml0gCiMgCgpJZiB3ZSBjYWxsIGFu
b3RoZXIgdGhyZWFkIHN1Y2ggYXMgYSB3b3JrX3F1ZXVlIG9yIHRoZSBjb2RlIGluIG90aGVyIHBs
YWNlcwp0byByZXN0YXJ0IHRoZSB0aW1lciBpbnN0ZWFkIG9mIGluIGl0cyB0aW1lciBoYW5kbGVy
LCB0aGUgZGVsX3RpbWVyX3N5bmMoKQpjb3VsZCBub3Qgc3RvcCBpdC4KCkJlc3QgcmVnYXJkcywK
RHVvbWluZyBaaG91
