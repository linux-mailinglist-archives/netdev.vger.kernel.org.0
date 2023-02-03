Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9261A6893DF
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbjBCJeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjBCJeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:34:19 -0500
X-Greylist: delayed 1819 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Feb 2023 01:34:16 PST
Received: from m1391.mail.163.com (m1391.mail.163.com [220.181.13.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F834991E9;
        Fri,  3 Feb 2023 01:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=ve+jTZQ9qo5wIWH/yqr3szifk43NT25C1sXkvnLh2/A=; b=N
        YsI9J0iRyATf9uEWBHqx+1E6qbKNcmUOiW3Va3CdFiyz4lCQFzx81xGFXneDc7Sk
        bc0llpz4EGJnWAfmF3N+b5uxjlHBiqnWOmYJrPH12UYnVEyRLzYK1dalSCqakwUg
        gklqbz6Bb/jWUnuyqkDjsHgukkEgXFXPUlVMZBUZBA=
Received: from zyytlz.wz$163.com ( [111.206.145.21] ) by
 ajax-webmail-wmsvr91 (Coremail) ; Fri, 3 Feb 2023 16:48:10 +0800 (CST)
X-Originating-IP: [111.206.145.21]
Date:   Fri, 3 Feb 2023 16:48:10 +0800 (CST)
From:   =?UTF-8?B?546L5b6B?= <zyytlz.wz@163.com>
To:     "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Cc:     srini.raju@purelifi.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH] wifi: plfxlc: fix potential NULL pointer dereference
 in plfxlc_usb_wreq_async()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20220708(c4627114)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
In-Reply-To: <dd1c45ad-7af2-8df1-a3ab-0db99dd25934@wanadoo.fr>
References: <20230203041644.581649-1-zyytlz.wz@163.com>
 <dd1c45ad-7af2-8df1-a3ab-0db99dd25934@wanadoo.fr>
X-NTES-SC: AL_QuycB/iau0gi5iGbYOkXmkYVhOk/Wcu2uPov2IBVO5E0pirS6zwaQ1B9NFfO2+SDLyyznzenfzhv1s91c4pce6Sz9ufqjW8IoHA6Sawx6ppO
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <38492923.aa4d.1861676319b.Coremail.zyytlz.wz@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: W8GowADnwPlKytxj8IAPAA--.2761W
X-CM-SenderInfo: h2113zf2oz6qqrwthudrp/1tbiQgALU1aEEPGkmQADsX
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgoKCgoKCgoKCkF0IDIwMjMtMDItMDMgMTM6MjU6NDUsICJDaHJpc3RvcGhlIEpBSUxM
RVQiIDxjaHJpc3RvcGhlLmphaWxsZXRAd2FuYWRvby5mcj4gd3JvdGU6Cj5MZSAwMy8wMi8yMDIz
IMOgIDA1OjE2LCBaaGVuZyBXYW5nIGEgw6ljcml0wqA6Cj4+IEFsdGhvdWdoIHRoZSB1c2JfYWxs
b2NfdXJiIHVzZXMgR0ZQX0FUT01JQywgdHJpbmcgdG8gbWFrZSBzdXJlIHRoZSBtZW1vcnkKPj4g
ICBhbGxvY2F0ZWQgbm90IHRvIGJlIE5VTEwuIEJ1dCBpbiBzb21lIGxvdy1tZW1vcnkgc2l0dWF0
aW9uLCBpdCdzIHN0aWxsCj4+ICAgcG9zc2libGUgdG8gcmV0dXJuIE5VTEwuIEl0J2xsIHBhc3Mg
dXJiIGFzIGFyZ3VtZW50IGluCj4+ICAgdXNiX2ZpbGxfYnVsa191cmIsIHdoaWNoIHdpbGwgZmlu
YWxseSBsZWFkIHRvIGEgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlLgo+PiAKPj4gRml4IGl0IGJ5
IGFkZGluZyBhZGRpdGlvbmFsIGNoZWNrLgo+PiAKPj4gTm90ZSB0aGF0LCBhcyBhIGJ1ZyBmb3Vu
ZCBieSBzdGF0aWMgYW5hbHlzaXMsIGl0IGNhbiBiZSBhIGZhbHNlCj4+IHBvc2l0aXZlIG9yIGhh
cmQgdG8gdHJpZ2dlci4KPj4gCj4+IEZpeGVzOiA2OGQ1N2EwN2JmZTUgKCJ3aXJlbGVzczogYWRk
IHBsZnhsYyBkcml2ZXIgZm9yIHB1cmVMaUZpIFgsIFhMLCBYQyBkZXZpY2VzIikKPj4gCj4+IFNp
Z25lZC1vZmYtYnk6IFpoZW5nIFdhbmcgPHp5eXRsei53ekAxNjMuY29tPgo+PiAtLS0KPj4gICBk
cml2ZXJzL25ldC93aXJlbGVzcy9wdXJlbGlmaS9wbGZ4bGMvdXNiLmMgfCA3ICsrKysrKysKPj4g
ICAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspCj4+IAo+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvcHVyZWxpZmkvcGxmeGxjL3VzYi5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcHVyZWxpZmkvcGxmeGxjL3VzYi5jCj4+IGluZGV4IDc2ZDBhNzc4NjM2YS4uYWMxNDlh
YTY0OTA4IDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9wdXJlbGlmaS9wbGZ4
bGMvdXNiLmMKPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcHVyZWxpZmkvcGxmeGxjL3Vz
Yi5jCj4+IEBAIC00OTYsMTAgKzQ5NiwxNyBAQCBpbnQgcGxmeGxjX3VzYl93cmVxX2FzeW5jKHN0
cnVjdCBwbGZ4bGNfdXNiICp1c2IsIGNvbnN0IHU4ICpidWZmZXIsCj4+ICAgCXN0cnVjdCB1cmIg
KnVyYiA9IHVzYl9hbGxvY191cmIoMCwgR0ZQX0FUT01JQyk7Cj4+ICAgCWludCByOwo+PiAgIAo+
PiArCWlmICghdXJiKSB7Cj4+ICsJCXIgPSAtRU5PTUVNOwo+PiArCQlrZnJlZSh1cmIpOwo+Cj5I
aSwKPndoeSBrZnJlZSgpIGluIHN1Y2ggYSBjYXNlPwoKCkhlbGxvIENKLAoKClRoYW5rcyBmb3Ig
cG9pbnRpbmcgdGhhdCBvdXQuIEtmcmVlIGlzIHVubmVjZXNzYXJ5IGluIHN1Y2ggY2FzZSwgd2Ug
Y2FuIGp1c3QgcmV0dXJuLgoKClJlZ2FyZHMsClpoZW5nIFdhbmcKCj4KPj4gKwkJZ290byBvdXQ7
Cj4+ICsJfQo+PiAgIAl1c2JfZmlsbF9idWxrX3VyYih1cmIsIHVkZXYsIHVzYl9zbmRidWxrcGlw
ZSh1ZGV2LCBFUF9EQVRBX09VVCksCj4+ICAgCQkJICAodm9pZCAqKWJ1ZmZlciwgYnVmZmVyX2xl
biwgY29tcGxldGVfZm4sIGNvbnRleHQpOwo+PiAgIAo+PiAgIAlyID0gdXNiX3N1Ym1pdF91cmIo
dXJiLCBHRlBfQVRPTUlDKTsKPj4gKwo+PiArb3V0Ogo+PiAgIAlpZiAocikKPj4gICAJCWRldl9l
cnIoJnVkZXYtPmRldiwgIkFzeW5jIHdyaXRlIHN1Ym1pdCBmYWlsZWQgKCVkKVxuIiwgcik7Cj4+
ICAgCg==
