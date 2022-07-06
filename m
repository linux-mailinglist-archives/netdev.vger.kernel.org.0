Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08B5567BDA
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 04:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiGFC2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 22:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiGFC2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 22:28:49 -0400
X-Greylist: delayed 1810 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Jul 2022 19:28:47 PDT
Received: from m151.mail.126.com (m151.mail.126.com [220.181.15.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EED6514D32
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 19:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=O1B4v
        rgAFSDLxpVaIrzvoe0+ZnBX7pPBHPpuErzLDoM=; b=jVsVSzstpCxraN2yMurid
        YHgJN8bM5QYqAsk+MIViqsAfRml8JQfP3tjWVZhdKawCART+sFC83P0/TSdKF+zT
        pVCIUPtm6uZsB0GNRaVdu3al+WUr2yhoNHJxl/YJdkteRsvRWxSUNKkLGZFfIp/b
        /3AGc8X8nmLF1TAx2zCOuk=
Received: from windhl$126.com ( [124.16.139.61] ) by ajax-webmail-wmsvr1
 (Coremail) ; Wed, 6 Jul 2022 09:58:05 +0800 (CST)
X-Originating-IP: [124.16.139.61]
Date:   Wed, 6 Jul 2022 09:58:05 +0800 (CST)
From:   "Liang He" <windhl@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re:Re: [PATCH] ftgmac100: Hold reference returned by
 of_get_child_by_name()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 126com
In-Reply-To: <20220705184805.2619caca@kernel.org>
References: <20220704151819.279513-1-windhl@126.com>
 <20220705184805.2619caca@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <4e08cbb6.b57.181d13a9035.Coremail.windhl@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AcqowACnwLAu7MRijWsfAA--.60171W
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgE2F1-HZchpLwADsK
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKQXQgMjAyMi0wNy0wNiAwOTo0ODowNSwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwu
b3JnPiB3cm90ZToKPk9uIE1vbiwgIDQgSnVsIDIwMjIgMjM6MTg6MTkgKzA4MDAgTGlhbmcgSGUg
d3JvdGU6Cj4+IEluIGZ0Z21hYzEwMF9wcm9iZSgpLCB3ZSBzaG91bGQgaG9sZCB0aGUgcmVmZXJu
ZWNlIHJldHVybmVkIGJ5Cj4+IG9mX2dldF9jaGlsZF9ieV9uYW1lKCkgYW5kIHVzZSBpdCB0byBj
YWxsIG9mX25vZGVfcHV0KCkgZm9yCj4+IHJlZmVyZW5jZSBiYWxhbmNlLgo+PiAKPj4gU2lnbmVk
LW9mZi1ieTogTGlhbmcgSGUgPHdpbmRobEAxMjYuY29tPgo+PiAtLS0KPj4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgfCA2ICsrKystLQo+PiAgMSBmaWxlIGNoYW5n
ZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPj4gCj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYwo+PiBpbmRleCA1MjMxODE4OTQzYzYuLmU1MGJkN2Jl
YjA5YiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMx
MDAuYwo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jCj4+
IEBAIC0xNzcwLDcgKzE3NzAsNyBAQCBzdGF0aWMgaW50IGZ0Z21hYzEwMF9wcm9iZShzdHJ1Y3Qg
cGxhdGZvcm1fZGV2aWNlICpwZGV2KQo+PiAgCWludCBpcnE7Cj4+ICAJc3RydWN0IG5ldF9kZXZp
Y2UgKm5ldGRldjsKPj4gIAlzdHJ1Y3QgZnRnbWFjMTAwICpwcml2Owo+PiAtCXN0cnVjdCBkZXZp
Y2Vfbm9kZSAqbnA7Cj4+ICsJc3RydWN0IGRldmljZV9ub2RlICpucCwgKmNoaWxkX25wOwo+PiAg
CWludCBlcnIgPSAwOwo+PiAgCj4+ICAJcmVzID0gcGxhdGZvcm1fZ2V0X3Jlc291cmNlKHBkZXYs
IElPUkVTT1VSQ0VfTUVNLCAwKTsKPj4gQEAgLTE4ODMsNyArMTg4Myw3IEBAIHN0YXRpYyBpbnQg
ZnRnbWFjMTAwX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCj4+ICAKPj4gIAkJ
LyogRGlzcGxheSB3aGF0IHdlIGZvdW5kICovCj4+ICAJCXBoeV9hdHRhY2hlZF9pbmZvKHBoeSk7
Cj4+IC0JfSBlbHNlIGlmIChucCAmJiAhb2ZfZ2V0X2NoaWxkX2J5X25hbWUobnAsICJtZGlvIikp
IHsKPj4gKwl9IGVsc2UgaWYgKG5wICYmICEoY2hpbGRfbnAgPSBvZl9nZXRfY2hpbGRfYnlfbmFt
ZShucCwgIm1kaW8iKSkpIHsKPj4gIAkJLyogU3VwcG9ydCBsZWdhY3kgQVNQRUVEIGRldmljZXRy
ZWUgZGVzY3JpcHRpb25zIHRoYXQgZGVjcmliZSBhCj4+ICAJCSAqIE1BQyB3aXRoIGFuIGVtYmVk
ZGVkIE1ESU8gY29udHJvbGxlciBidXQgaGF2ZSBubyAibWRpbyIKPj4gIAkJICogY2hpbGQgbm9k
ZS4gQXV0b21hdGljYWxseSBzY2FuIHRoZSBNRElPIGJ1cyBmb3IgYXZhaWxhYmxlCj4+IEBAIC0x
OTAxLDYgKzE5MDEsOCBAQCBzdGF0aWMgaW50IGZ0Z21hYzEwMF9wcm9iZShzdHJ1Y3QgcGxhdGZv
cm1fZGV2aWNlICpwZGV2KQo+PiAgCQl9Cj4+ICAKPj4gIAl9Cj4+ICsJaWYgKGNoaWxkX25wKQo+
PiArCQlvZl9ub2RlX3B1dChjaGlsZF9ucCk7Cj4KPlNpbmNlIHdlIGRvbid0IGNhcmUgYWJvdXQg
dGhlIHZhbHVlIG9mIHRoZSBub2RlIHdlIHNob3VsZCBhZGQgYSBoZWxwZXIKPndoaWNoIGNoZWNr
cyBmb3IgcHJlc2VuY2Ugb2YgdGhlIG5vZGUgYW5kIHJlbGVhc2VzIHRoZSByZWZlcmVuY2UsCj5y
YXRoZXIgdGhhbiBoYXZlIHRvIGRvIHRoYXQgaW4gdGhpcyBsYXJnZSBmdW5jdGlvbi4KPgoKVGhh
bmtzLCBJIHdpbGwgdHJ5IGl0LgoKPlBsZWFzZSBhbHNvIGFkZCBhIEZpeGVzIHRhZy4KClNvcnJ5
LCBJIG1pc3MgdGhlIGZpeCB0YWcuCgoK
