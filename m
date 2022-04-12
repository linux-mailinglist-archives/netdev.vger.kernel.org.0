Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B4E4FDF22
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349627AbiDLMFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352287AbiDLMC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:56 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04C4F7F226;
        Tue, 12 Apr 2022 04:00:02 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Tue, 12 Apr 2022 18:59:49
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.215.200]
Date:   Tue, 12 Apr 2022 18:59:49 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Paolo Abeni" <pabeni@redhat.com>
Cc:     krzk@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org
Subject: Re: Re: [PATCH V2] drivers: nfc: nfcmrvl: fix double free bug in
 nfcmrvl_nci_unregister_dev()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <3daec73abc2f21809a8057b6a9729a70d2877231.camel@redhat.com>
References: <20220410135214.74216-1-duoming@zju.edu.cn>
 <3daec73abc2f21809a8057b6a9729a70d2877231.camel@redhat.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2ce990b6.a886.1801d6dfe04.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgCXDxelW1ViPcGbAQ--.34003W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg4SAVZdtZJw9AABs2
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

SGVsbG8sCk9uIFR1ZSwgMTIgQXByIDIwMjIgMDA6Mjg6MTYgLTA3MDAgUGFvbG8gQWJlbmkgd3Jv
dGU6Cgo+ID4gVGhlcmUgaXMgYSBwb3RlbnRpYWwgZG91YmxlIGJ1ZyBpbiBuZmNtcnZsIHVzYiBk
cml2ZXIgYmV0d2Vlbgo+ID4gdW5yZWdpc3RlciBhbmQgcmVzdW1lIG9wZXJhdGlvbi4KPiA+IAo+
ID4gVGhlIHJhY2UgdGhhdCBjYXVzZSB0aGF0IGRvdWJsZSBmcmVlIGJ1ZyBjYW4gYmUgc2hvd24g
YXMgYmVsb3c6Cj4gPiAKPiA+ICAgIChGUkVFKSAgICAgICAgICAgICAgICAgICB8ICAgICAgKFVT
RSkKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IG5mY21ydmxfcmVzdW1lCj4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgbmZjbXJ2bF9zdWJtaXRfYnVsa191cmIKPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgbmZjbXJ2bF9idWxrX2NvbXBsZXRlCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICBuZmNtcnZsX25jaV9yZWN2X2ZyYW1l
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgbmZjbXJ2bF9md19kbmxkX3Jl
Y3ZfZnJhbWUKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgcXVldWVfd29y
awo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgZndfZG5sZF9yeF93b3Jr
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgZndfZG5sZF9vdmVyCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgIHJlbGVhc2VfZmlybXdhcmUK
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgIGtmcmVlKGZ3KTsgLy8o
MSkKPiA+IG5mY21ydmxfZGlzY29ubmVjdCAgICAgICAgICB8Cj4gPiAgbmZjbXJ2bF9uY2lfdW5y
ZWdpc3Rlcl9kZXYgfAo+ID4gICBuZmNtcnZsX2Z3X2RubGRfYWJvcnQgICAgIHwKPiA+ICAgIGZ3
X2RubGRfb3ZlciAgICAgICAgICAgICB8ICAgICAgICAgLi4uCj4gPiAgICAgaWYgKHByaXYtPmZ3
X2RubGQuZncpICAgfAo+ID4gICAgIHJlbGVhc2VfZmlybXdhcmUgICAgICAgIHwKPiA+ICAgICAg
a2ZyZWUoZncpOyAvLygyKSAgICAgICB8Cj4gPiAgICAgIC4uLiAgICAgICAgICAgICAgICAgICAg
fCAgICAgICAgIHByaXYtPmZ3X2RubGQuZncgPSBOVUxMOwo+ID4gCj4gPiBXaGVuIG5mY21ydmwg
dXNiIGRyaXZlciBpcyByZXN1bWluZywgd2UgZGV0YWNoIHRoZSBkZXZpY2UuCj4gPiBUaGUgcmVs
ZWFzZV9maXJtd2FyZSgpIHdpbGwgZGVhbGxvY2F0ZSBmaXJtd2FyZSBpbiBwb3NpdGlvbiAoMSks
Cj4gPiBidXQgZmlybXdhcmUgd2lsbCBiZSBkZWFsbG9jYXRlZCBhZ2FpbiBpbiBwb3NpdGlvbiAo
MiksIHdoaWNoCj4gPiBsZWFkcyB0byBkb3VibGUgZnJlZS4KPiA+IAo+ID4gVGhpcyBwYXRjaCBy
ZW9yZGVycyBuZmNtcnZsX2Z3X2RubGRfZGVpbml0KCkgYmVmb3JlIG5mY21ydmxfZndfZG5sZF9h
Ym9ydCgpCj4gPiBpbiBvcmRlciB0byBwcmV2ZW50IGRvdWJsZSBmcmVlIGJ1Zy4gQmVjYXVzZSBk
ZXN0cm95X3dvcmtxdWV1ZSgpIHdpbGwKPiA+IG5vdCByZXR1cm4gdW50aWwgYWxsIHdvcmsgaXRl
bXMgYXJlIGZpbmlzaGVkLiBUaGUgcHJpdi0+ZndfZG5sZC5mdyB3aWxsCj4gPiBiZSBzZXQgdG8g
TlVMTCBhZnRlciB3b3JrIGl0ZW1zIGFyZSBmaW5pc2hlZCBhbmQgZndfZG5sZF9vdmVyKCkgY2Fs
bGVkIGJ5Cj4gPiBuZmNtcnZsX25jaV91bnJlZ2lzdGVyX2RldigpIHdpbGwgY2hlY2sgd2hldGhl
ciBwcml2LT5md19kbmxkLmZ3IGlzIE5VTEwuCj4gPiBTbyB0aGUgZG91YmxlIGZyZWUgYnVnIGNv
dWxkIGJlIHByZXZlbnRlZC4KPiA+IAo+ID4gU2lnbmVkLW9mZi1ieTogRHVvbWluZyBaaG91IDxk
dW9taW5nQHpqdS5lZHUuY24+Cj4gCj4gVGhpcyBsb29rcyBsaWtlIGEgLW5ldCBjYW5kaWRhdGVz
LCBjb3VsZCB5b3UgcGxlYXNlIGFkZCBhIHN1aXRhYmxlCj4gZml4ZXMgdGFnPwoKSSBmb3VuZCBt
eSBwYXRjaCBpcyBub3QgYSBjb21wcmVoZW5zaXZlIGZpeCwgYmVjYXVzZSB0aGUgZndfZG5sZF90
aW1lb3V0KCkKY291bGQgYWxzbyByZWFjaCBmd19kbmxkX292ZXIoKSwgd2hpY2ggbGVhZHMgdG8g
ZG91YmxlIGZyZWUgYnVncyBhbW9uZyAKZndfZG5sZF9yeF93b3JrKCksIGZ3X2RubGRfdGltZW91
dCgpIGFuZCBuZmNtcnZsX25jaV91bnJlZ2lzdGVyX2RldigpLgoKSSBzZW50IGEgcGF0Y2ggc2V0
ICJGaXggZG91YmxlIGZyZWUgYnVncyBpbiBuZmNtcnZsIG1vZHVsZSIganVzdCBub3csIGFuZCBh
ZGQKYSBmaXhlcyB0YWcgaW4gaXQuCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==
