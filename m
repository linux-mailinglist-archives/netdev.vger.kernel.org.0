Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F152558D239
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 05:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiHIDFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 23:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiHIDFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 23:05:49 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 76ABE1C13F;
        Mon,  8 Aug 2022 20:05:46 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Tue, 9 Aug 2022 11:05:19
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.1.5]
Date:   Tue, 9 Aug 2022 11:05:19 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v0] idb: Add rtnl_lock to avoid data race
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220808115511.5b574db2@kernel.org>
References: <20220808081050.25229-1-linma@zju.edu.cn>
 <20220808115511.5b574db2@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <35502986.7352e.18280905841.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cC_KCgC3vQzwzvFiBWTEAg--.39254W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwQCElNG3Hi-jgBBsW
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

SGVsbG8gdGhlcmUsCgo+IAo+IFdoYXQgYWJvdXQgdGhlIGRpc2FibGUgcGF0aCBjb21pbmcgZnJv
bSBzeXNmcz8gVGhpcyBsb29rcyBpbmNvbXBsZXRlIHRvCj4gbWUuIFBlcmhhcHMgdGFrZSBhIGxv
b2sgYXQgY29tbWl0IDFlNTM4MzRjZTU0MSAoIml4Z2JlOiBBZGQgbG9ja2luZyB0bwo+IHByZXZl
bnQgcGFuaWMgd2hlbiBzZXR0aW5nIHNyaW92X251bXZmcyB0byB6ZXJvIikgZm9yIHNvbWUgaW5z
cGlyYXRpb24uCgpUaGFua3MgZm9yIHRoZSBhZHZpY2UsIEkgc2VudCB0aGUgbmV3IHZlcnNpb24g
b2YgdGhlIHBhdGNoIHdoaWNoIHVzZXMgYSBuZXcgc3BpbmxvY2sgdG8gYXZvaWQgcmFjZSBjYXNl
cyBzdWNoIGFzIGRlc2NyaWJlZCBpbiBjb21taXQgMWU1MzgzNGNlNTQxLgoKQWRkaXRpb25hbGx5
LCBJIGFsc28ga2VlcCB0aGUgcnRubF9sb2NrIHRvIGVsaW1pbmF0ZSB0aGUgcmFjZXMgdGhhdCBj
b21lIGZyb20gbmV0ZGV2IGNvcmUuIEFsdGhvdWdoIHRoaXMgY2FuIGFsc28gYmUgaGFuZGxlZCB3
aXRoIHRoZSBuZXdseSBhZGRlZCBzcGlubG9jaywgSSBmb3VuZCB0aGF0IGFkZGluZyB0aGUgc3Bp
bmxvY2sgZXZlcnkgdGltZSBhY2Nlc3NpbmcgdGhlIFZGIHJlc291cmNlcyBpcyBub3QgdHJpdmlh
bC4KKElmIHlvdSB0aGluayB0aGF0IGtlZXAgdXNpbmcgdGhlIHNwaW5sb2NrIGlzIGJldHRlciBJ
IHdpbGwgY3JhZnQgYSBuZXcgdmVyc2lvbiBvZiBwYXRjaCkKCkl0IHNlZW1zIHRoYXQgaXhnYmVf
ZGlzYWJsZV9zcmlvdiBhbHNvIHN1ZmZlcnMgZnJvbSB0aGUgbWVudGlvbmVkIHJhY2VzIGZyb20g
bmV0ZGV2IGNvcmUuIElmIHlvdSB0aGluayB0aGUgcnRubF9sb2NrIHNvbHV0aW9uIGlzIGZpbmUs
IEkgd2lsbCBhbHNvIHNlbmQgYSBwYXRjaCBmb3IgdGhhdCBkcml2ZXIgdG9vLgoKVGhhbmtzCkxp
biBNYQ==
