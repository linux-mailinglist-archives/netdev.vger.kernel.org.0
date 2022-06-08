Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D925430AE
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbiFHMpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239409AbiFHMpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:45:43 -0400
Received: from m1391.mail.163.com (m1391.mail.163.com [220.181.13.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 376C61DE2E6;
        Wed,  8 Jun 2022 05:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=Dq0bS
        elIzZ22NuE87EUd0dop6A9eeIPopScc/d7rQTQ=; b=ZspoWU8jR9+7HXQct0QBs
        dptHVznXWEcY9qJbZYp324BRQ/dD799Rl/2qJyJY8I7FTS7/0ow96xSJwviK4U2M
        PCgJCMbRpzAMbzt3Vk7A1lvXHeYATa/qz/bfbTetlQcY9p2hWhTmQmPgopLPccnD
        b1IaupGu9o33Wx0bxDQEMQ=
Received: from chen45464546$163.com ( [171.221.147.121] ) by
 ajax-webmail-wmsvr91 (Coremail) ; Wed, 8 Jun 2022 20:43:31 +0800 (CST)
X-Originating-IP: [171.221.147.121]
Date:   Wed, 8 Jun 2022 20:43:31 +0800 (CST)
From:   "Chen Lin" <chen45464546@163.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com
Subject: Re:Re: [PATCH v4] net: ethernet: mtk_eth_soc: fix misuse of mem
 alloc interface netdev[napi]_alloc_frag
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
In-Reply-To: <20220607161413.655dd63f@kernel.org>
References: <20220606143437.25397f08@kernel.org>
 <1654558751-3702-1-git-send-email-chen45464546@163.com>
 <20220607161413.655dd63f@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <55c80848.c37d.18143576bc9.Coremail.chen45464546@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: W8GowAAXiRZzmaBihyYzAA--.48365W
X-CM-SenderInfo: hfkh0kqvuwkkiuw6il2tof0z/1tbiXQ8ZnlWBn8-3zQABsq
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

QXQgMjAyMi0wNi0wOCAwNzoxNDoxMywgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwub3Jn
PiB3cm90ZToKPk9uIFR1ZSwgIDcgSnVuIDIwMjIgMDc6Mzk6MTEgKzA4MDAgQ2hlbiBMaW4gd3Jv
dGU6Cj4+ICtzdGF0aWMgaW5saW5lIHZvaWQgKm10a19tYXhfbHJvX2J1Zl9hbGxvYyhnZnBfdCBn
ZnBfbWFzaykKPgo+Tm8gbmVlZCBmb3IgaW5saW5lLCBjb21waWxlciB3aWxsIGlubGluZSB0aGlz
IGFueXdheS4KPgo+PiArewo+PiArCXZvaWQgKmRhdGE7Cj4KPnVuc2lnbmVkIGxvbmcgZGF0YTsg
dGhlbiB5b3UgY2FuIG1vdmUgdGhlIGNhc3QgZnJvbSB0aGUgbG9uZyBsaW5lIHRvCj50aGUgcmV0
dXJuIHN0YXRlbWVudCwgc2F2aW5nIHVzIGZyb20gdGhlIHN0cmFuZ2UgaW5kZW50YXRpb24uCj4K
Pj4gKwlkYXRhID0gKHZvaWQgKilfX2dldF9mcmVlX3BhZ2VzKGdmcF9tYXNrIHwKPj4gKwkJCSAg
X19HRlBfQ09NUCB8IF9fR0ZQX05PV0FSTiwKPj4gKwkJCSAgZ2V0X29yZGVyKG10a19tYXhfZnJh
Z19zaXplKE1US19NQVhfTFJPX1JYX0xFTkdUSCkpKTsKPj4gKwo+PiArCXJldHVybiBkYXRhOwo+
PiArfQoKSSdsbCBkbyBpdCBsaWtlIGJlbG93IDoKK3N0YXRpYyB2b2lkICptdGtfbWF4X2xyb19i
dWZfYWxsb2MoZ2ZwX3QgZ2ZwX21hc2spCit7CisgICAgICAgdW5zaWduZWQgbG9uZyBkYXRhOwor
ICAgICAgIHVuc2lnbmVkIGludCBzaXplID0gbXRrX21heF9mcmFnX3NpemUoTVRLX01BWF9MUk9f
UlhfTEVOR1RIKTsKKworICAgICAgIGRhdGEgPSBfX2dldF9mcmVlX3BhZ2VzKGdmcF9tYXNrIHwg
X19HRlBfQ09NUCB8IF9fR0ZQX05PV0FSTiwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBnZXRfb3JkZXIoc2l6ZSkpOworCisgICAgICAgcmV0dXJuICh2b2lkICopZGF0YTsKK30KClRo
cm91Z2ggYW5hbHlzaXMgb2YgdGhlIEFTTSBjb2RlIGZyb20gb2JqZHVtcCwgSSBjb25maXJtZWQg
dGhhdCAKdGhlIGlubGluZSBpcyBub3QgbmVjZXNzYXJ5LiBUaGFua3MgZm9yIHlvdXIgdGlwcy4K
CkFsc28sIEkgY29uZmlybWVkIHRoYXQgY3JlYXRlIGEgbmV3IGxvY2FsIHZhcmlhYmxlICdzaXpl
Jwp3aWxsIG5vdCBhZmZlY3QgdGhlIGdlbmVyYXRpb24gb2YgYSBjb25zdGFudCAnb3JkZXInIHBh
cmFtZXRlciBhdCBjb21waWxlIHRpbWUuCgoKQVNNIGNvZGUgb2YgY2FsbGluZyAnbXRrX21heF9s
cm9fYnVmX2FsbG9jJzoKCidtdGtfbWF4X2xyb19idWZfYWxsb2MnIGlubGluZWQgYW5kICdvcmRl
cicodzEpIGlzIGEgY29uc3RhbnQgMHgyCjAwMDAwMDAwMDAwMDQ1MzAgPG10a19uYXBpX3J4PjoK
Li4uCjRhOTg6ICAgICAgIDUyODU0NDAwICAgICAgICBtb3YgICAgIHcwLCAjMHgyYTIwICAgICAg
ICAgICAgICAgICAgICAgLy8gIzEwNzg0CjRhOWM6ICAgICAgIDUyODAwMDQxICAgICAgICBtb3Yg
ICAgIHcxLCAjMHgyICAgICAgICAgICAgICAgICAgICAgICAgLy8gIzIKNGFhMDogICAgICAgNzJh
MDAwODAgICAgICAgIG1vdmsgICAgdzAsICMweDQsIGxzbCAjMTYKNGFhNDogICAgICAgOTQwMDAw
MDAgICAgICAgIGJsICAgICAgMCA8X19nZXRfZnJlZV9wYWdlcz4KNGFhODogICAgICAgZjkwMDMz
ZTAgICAgICAgIHN0ciAgICAgeDAsIFtzcCwgIzk2XQoKMDAwMDAwMDAwMDAwMDczMCA8bXRrX3J4
X2FsbG9jPjoKLi4uCjdmYzogICAgICAgMmExNzAzZTAgICAgICAgIG1vdiAgICAgdzAsIHcyMwo4
MDA6ICAgICAgIDUyODAwMDQxICAgICAgICBtb3YgICAgIHcxLCAjMHgyICAgICAgICAgICAgICAg
ICAgICAgICAgLy8gIzIKODA0OiAgICAgICA3MTQwMDQ3ZiAgICAgICAgY21wICAgICB3MywgIzB4
MSwgbHNsICMxMgo4MDg6ICAgICAgIDU0ZmZmZTQ5ICAgICAgICBiLmxzICAgIDdkMCA8bXRrX3J4
X2FsbG9jKzB4YTA+ICAvLyBiLnBsYXN0CjgwYzogICAgICAgOTQwMDAwMDAgICAgICAgIGJsICAg
ICAgMCA8X19nZXRfZnJlZV9wYWdlcz4KClRoZSBjb21waWxlciBpcyBzbWFydC4g
