Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33957575192
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbiGNPTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiGNPTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:19:14 -0400
Received: from m1524.mail.126.com (m1524.mail.126.com [220.181.15.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80FF2286FC
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=bNRMq
        AZ+JM5hhhLnX5Q88y+w7jDi5D6crsny0SwDvCY=; b=CojRpur9+A339WbrPvktZ
        eAsyhqiiMnyUFOEFji0RuSYn4YUSM0s5K184zP1OCvR8QlSmtVDxPRT0mPng2+Cv
        vXcbNnEoRo9BOngUtZmfWJCwA+4IPxH0xfr5+6LWmtyCbTzwfHI9tOZiyMafFbvv
        gSgbmEJhWdUf/DXOq/Eitg=
Received: from windhl$126.com ( [123.112.71.157] ) by ajax-webmail-wmsvr24
 (Coremail) ; Thu, 14 Jul 2022 23:18:53 +0800 (CST)
X-Originating-IP: [123.112.71.157]
Date:   Thu, 14 Jul 2022 23:18:53 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re:Re: [PATCH] net: dsa: microchip: ksz_common: Fix refcount leak
 bug
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220714145956.pnq5yulgete4xc2g@skbuf>
References: <20220713115428.367840-1-windhl@126.com>
 <20220714145956.pnq5yulgete4xc2g@skbuf>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <771aac42.76b6.181fd4a97fc.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: GMqowAD3_ibeM9BipXFIAA--.19830W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi2h4+F1uwMZ1zXAAAsF
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKCgoKCgpBdCAyMDIyLTA3LTE0IDIyOjU5OjU2LCAiVmxhZGltaXIgT2x0ZWFuIiA8b2x0ZWFu
dkBnbWFpbC5jb20+IHdyb3RlOgo+T24gV2VkLCBKdWwgMTMsIDIwMjIgYXQgMDc6NTQ6MjhQTSAr
MDgwMCwgTGlhbmcgSGUgd3JvdGU6Cj4+IEluIGtzel9zd2l0Y2hfcmVnaXN0ZXIoKSwgd2Ugc2hv
dWxkIGNhbGwgb2Zfbm9kZV9wdXQoKSBmb3IgdGhlCj4+IHJlZmVyZW5jZSByZXR1cm5lZCBieSBv
Zl9nZXRfY2hpbGRfYnlfbmFtZSgpIHdoaWNoIGhhcyBpbmNyZWFzZWQKPj4gdGhlIHJlZmNvdW50
Lgo+PiAKPj4gRml4ZXM6IDQ0ZTUzYzg4ODI4ZiAoIm5ldDogZHNhOiBtaWNyb2NoaXA6IHN1cHBv
cnQgZm9yICJldGhlcm5ldC1wb3J0cyIgbm9kZSIpCj4KPkkgZGlzYWdyZWUgd2l0aCB0aGUgZ2l0
IGJsYW1lIHJlc29sdXRpb24sIGl0IHNob3VsZCBiZToKPgo+Rml4ZXM6IDkxMmFhZTI3YzZhZiAo
Im5ldDogZHNhOiBtaWNyb2NoaXA6IHJlYWxseSBsb29rIGZvciBwaHktbW9kZSBpbiBwb3J0IG5v
ZGVzIikKPgo+UGxlYXNlIHJlc2VuZCB3aXRoIHRoYXQgbGluZSBjaGFuZ2VkLgoKPgpUaGFua3Ms
IAoKCkkgd2lsbCByZXNlbmQgd2l0aCBjb3JyZWN0IGZpeCB0YWcgc29vbiEKCgpMaWFuZwoKPj4g
U2lnbmVkLW9mZi1ieTogTGlhbmcgSGUgPHdpbmRobEAxMjYuY29tPgo+PiAtLS0KPj4gIAo+PiAg
ZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMgfCA1ICsrKystCj4+ICAxIGZp
bGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4+IAo+PiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMgYi9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYwo+PiBpbmRleCA5Y2E4YzhkNzc0MGYuLjkyYTUw
MGUxY2NkMiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29t
bW9uLmMKPj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMKPj4g
QEAgLTEwMzgsMTggKzEwMzgsMjEgQEAgaW50IGtzel9zd2l0Y2hfcmVnaXN0ZXIoc3RydWN0IGtz
el9kZXZpY2UgKmRldiwKPj4gIAkJcG9ydHMgPSBvZl9nZXRfY2hpbGRfYnlfbmFtZShkZXYtPmRl
di0+b2Zfbm9kZSwgImV0aGVybmV0LXBvcnRzIik7Cj4+ICAJCWlmICghcG9ydHMpCj4+ICAJCQlw
b3J0cyA9IG9mX2dldF9jaGlsZF9ieV9uYW1lKGRldi0+ZGV2LT5vZl9ub2RlLCAicG9ydHMiKTsK
Pj4gLQkJaWYgKHBvcnRzKQo+PiArCQlpZiAocG9ydHMpIHsKPj4gIAkJCWZvcl9lYWNoX2F2YWls
YWJsZV9jaGlsZF9vZl9ub2RlKHBvcnRzLCBwb3J0KSB7Cj4+ICAJCQkJaWYgKG9mX3Byb3BlcnR5
X3JlYWRfdTMyKHBvcnQsICJyZWciLAo+PiAgCQkJCQkJCSAmcG9ydF9udW0pKQo+PiAgCQkJCQlj
b250aW51ZTsKPj4gIAkJCQlpZiAoIShkZXYtPnBvcnRfbWFzayAmIEJJVChwb3J0X251bSkpKSB7
Cj4+ICAJCQkJCW9mX25vZGVfcHV0KHBvcnQpOwo+PiArCQkJCQlvZl9ub2RlX3B1dChwb3J0cyk7
Cj4+ICAJCQkJCXJldHVybiAtRUlOVkFMOwo+PiAgCQkJCX0KPj4gIAkJCQlvZl9nZXRfcGh5X21v
ZGUocG9ydCwKPj4gIAkJCQkJCSZkZXYtPnBvcnRzW3BvcnRfbnVtXS5pbnRlcmZhY2UpOwo+PiAg
CQkJfQo+PiArCQkJb2Zfbm9kZV9wdXQocG9ydHMpOwo+PiArCQl9Cj4+ICAJCWRldi0+c3luY2xr
b18xMjUgPSBvZl9wcm9wZXJ0eV9yZWFkX2Jvb2woZGV2LT5kZXYtPm9mX25vZGUsCj4+ICAJCQkJ
CQkJICJtaWNyb2NoaXAsc3luY2xrby0xMjUiKTsKPj4gIAkJZGV2LT5zeW5jbGtvX2Rpc2FibGUg
PSBvZl9wcm9wZXJ0eV9yZWFkX2Jvb2woZGV2LT5kZXYtPm9mX25vZGUsCj4+IC0tIAo+PiAyLjI1
LjEKPj4gCg==
