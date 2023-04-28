Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722856F110B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 06:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345308AbjD1EbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 00:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345179AbjD1EbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 00:31:11 -0400
Received: from m13123.mail.163.com (m13123.mail.163.com [220.181.13.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C66A1BFE;
        Thu, 27 Apr 2023 21:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=orKYBcnCSrfD8lnOQKKIt2WstY3dyNfJ3FD+enhl4lQ=; b=c
        uELsu9PKoxRndZJHDQBuH1ACoN+I5O4PWZvv4kvJr1pbP0Ai884JGLTlzYD/iHbY
        LfGKeCyuFeVM+6yTmBgwkbqSdTVx8iKX9rO4aqbNQRDPlboer2V+sxE8t5EBkc8C
        HVyAKWHHCoZ4C4ardITvls2mSUX6X2Fv0nCZEA49LA=
Received: from luyun_611$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr123 (Coremail) ; Fri, 28 Apr 2023 12:30:47 +0800 (CST)
X-Originating-IP: [116.128.244.169]
Date:   Fri, 28 Apr 2023 12:30:47 +0800 (CST)
From:   "Yun Lu" <luyun_611@163.com>
To:     "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
Cc:     Jes.Sorensen@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
In-Reply-To: <3854af21-822d-75f4-0e74-e1998143d59f@gmail.com>
References: <20230427020512.1221062-1-luyun_611@163.com>
 <3854af21-822d-75f4-0e74-e1998143d59f@gmail.com>
X-NTES-SC: AL_QuyTAPqeuUov4SCaZOkWmEgRjug5UMGxv/0i3oJUPZE0nivL3xEYU3JzF3jM0vOdDzqQvRWrdztr0t1ZYZVke4ErRhlLZLj/mIEwyixmaxI1
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <48b7ad54.2dfc.187c620bcf0.Coremail.luyun_611@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: e8GowADHBT34S0tkfAkPAA--.45289W
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbiWxpfzmI0Z0p1VQACsJ
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXQgMjAyMy0wNC0yOCAwMTowMTowNiwgIkJpdHRlcmJsdWUgU21pdGgiIDxydGw4ODIxY2VyZmUy
QGdtYWlsLmNvbT4gd3JvdGU6Cj5PbiAyNy8wNC8yMDIzIDA1OjA1LCBZdW4gTHUgd3JvdGU6Cj4+
IEZyb206IFl1biBMdSA8bHV5dW5Aa3lsaW5vcy5jbj4KPj4gCj4+IFdoZW4gdXNpbmcgcnRsODE5
MmN1IHdpdGggcnRsOHh4eHUgZHJpdmVyIHRvIGNvbm5lY3Qgd2lmaSwgdGhlcmUgaXMgYQo+PiBw
cm9iYWJpbGl0eSBvZiBmYWlsdXJlLCB3aGljaCBzaG93cyAiYXV0aGVudGljYXRpb24gd2l0aCAu
Li4gdGltZWQgb3V0Ii4KPj4gVGhyb3VnaCBkZWJ1Z2dpbmcsIGl0IHdhcyBmb3VuZCB0aGF0IHRo
ZSBSQ1IgcmVnaXN0ZXIgaGFzIGJlZW4gaW5leHBsaWNhYmx5Cj4+IG1vZGlmaWVkIHRvIGFuIGlu
Y29ycmVjdCB2YWx1ZSwgcmVzdWx0aW5nIGluIHRoZSBuaWMgbm90IGJlaW5nIGFibGUgdG8KPj4g
cmVjZWl2ZSBhdXRoZW50aWNhdGVkIGZyYW1lcy4KPj4gCj4+IFRvIGZpeCB0aGlzIHByb2JsZW0s
IGFkZCByZWdyY3IgaW4gcnRsOHh4eHVfcHJpdiBzdHJ1Y3QsIGFuZCBzdG9yZQo+PiB0aGUgUkNS
IHZhbHVlIGV2ZXJ5IHRpbWUgdGhlIHJlZ2lzdGVyIGlzIHdyaXRlbiwgYW5kIHVzZSBpdCB0aGUg
bmV4dAo+PiB0aW1lIHRoZSByZWdpc3RlciBuZWVkIHRvIGJlIG1vZGlmaWVkLgo+PiAKPgo+Q2Fu
IHRoaXMgYnVnIGJlIHJlcHJvZHVjZWQgZWFzaWx5PyBJcyBpdCBhbHdheXMgdGhlIHNhbWUgYml0
cyB3aGljaAo+YXJlIG15c3RlcmlvdXNseSBjbGVhcmVkIGZyb20gUkVHX1JDUj8KCk9uIHRoZSBk
ZXZpY2UoRURJTUFYIEVXLTc4MjJVQW4pIHdlIHVzZWQsIGl0IGNhbiBiZSByZXByb2R1Y2VkIGVh
c2lseS4KQW5kIHRoZSBjaGFuZ2VkIGJpdHMgaXMgbm90IGFsd2F5cyB0aGUgc2FtZSwgYXMgdGhl
IGxvZyBzaG93cyBpbiBteSByZXBseQp0byBMYXJyeS4KSXQgc2VlbXMgdGhhdCB0aGUgbmljIHdp
bGwgbW9kaWZ5IHRoZSB2YWx1ZSBvZiB0aGlzIHJlZ2lzdGVyIGl0c2VsZj8gSSBndWVzcyBpdC4K
ClRoYW5rcy4K
