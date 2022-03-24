Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2874E5D87
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 04:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347997AbiCXD2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 23:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiCXD2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 23:28:04 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id E2E54954BB;
        Wed, 23 Mar 2022 20:26:27 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 24 Mar 2022 11:26:03
 +0800 (GMT+08:00)
X-Originating-IP: [36.28.203.156]
Date:   Thu, 24 Mar 2022 11:26:03 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Matt Johnston" <matt@codeconstruct.com.au>
Cc:     jk <jk@codeconstruct.com.au>, davem <davem@davemloft.net>,
        kuba <kuba@kernel.org>, pabeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v0] mctp: fix netdev reference bug
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <48d1c4f9.13e3e.17fb9f5bc59.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDnHtTM5DtipNp4AA--.10288W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUEElNG3Fyb7QA1sG
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWF0dCwKCk9vcHMsIHNvcnJ5IGZvciB0aGUgZmFsc2UgYWxhcm0sIEkgZm91bmQgdGhpcyBv
biBtYWlubGluZSBrZXJuZWwgYW5kIEkgc2hvdWxkIGNoZWNrb3V0IG5ldC1uZXh0IGJlZm9yZSBz
ZW5kaW5nIHRoZSBwYXRjaC4KClJlZ2FyZHMKCj5IaSBMaW4gTWEsCj4KPk9uIFRodSwgMjAyMi0w
My0yNCBhdCAxMDozOSArMDgwMCwgTGluIE1hIHdyb3RlOgo+PiBJbiBleHRlbmRlZCBhZGRyZXNz
aW5nIG1vZGUsIGZ1bmN0aW9uIG1jdHBfbG9jYWxfb3V0cHV0KCkgZmV0Y2ggbmV0ZGV2Cj4+IHRo
cm91Z2ggZGV2X2dldF9ieV9pbmRleF9yY3UsIHdoaWNoIHdvbid0IGluY3JlYXNlIG5ldGRldidz
IHJlZmVyZW5jZQo+PiBjb3VudGVyLiBIZW5jZSwgdGhlIHJlZmVyZW5jZSBtYXkgdW5kZXJmbG93
IHdoZW4gbWN0cF9sb2NhbF9vdXRwdXQgY2FsbHMKPj4gZGV2X3B1dCgpLCByZXN1bHRzIGluIHBv
c3NpYmxlIHVzZSBhZnRlciBmcmVlLgo+PiAKPj4gVGhpcyBwYXRjaCBhZGRzIGRldl9ob2xkKCkg
dG8gZml4IHRoZSByZWZlcmVuY2UgYnVnLgo+Cj5UaGlzIHdhcyBhbHJlYWR5IGZpeGVkIGluIG5l
dC1uZXh0IHRvIGluY3JlbWVudCB0aGUgcmVmY291bnQgaW4KPl9fbWN0cF9kZXZfZ2V0KCkgYW5k
IHVzZSBtY3RwX2Rldl9wdXQoKS4KPgo+ZGMxMjFjMDA4NDkxICgibWN0cDogbWFrZSBfX21jdHBf
ZGV2X2dldCgpIHRha2UgYSByZWZjb3VudCBob2xkIikKPmUyOTdkYjNlYWRkNyAoIm1jdHA6IEZp
eCBpbmNvcnJlY3QgbmV0ZGV2IHVucmVmIGZvciBleHRlbmRlZCBhZGRyIikKPgo+VGhhbmtzLAo+
TWF0dAo=
