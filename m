Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C264FADDF
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 14:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbiDJMft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 08:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiDJMfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 08:35:48 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4C4864BF1;
        Sun, 10 Apr 2022 05:33:36 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Sun, 10 Apr 2022 20:33:25
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.67.219]
Date:   Sun, 10 Apr 2022 20:33:25 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        broonie@kernel.org
Subject: Re: Re: [PATCH] drivers: nfc: nfcmrvl: fix double free bug in
 nfcmrvl_nci_unregister_dev()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <6781b193-cd3b-e5ab-ce99-263edd4146bb@linaro.org>
References: <20220410083125.62909-1-duoming@zju.edu.cn>
 <6781b193-cd3b-e5ab-ce99-263edd4146bb@linaro.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <29021fb7.2b99.1801376f858.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgC3pcWVzlJiM+R3AQ--.32890W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkQAVZdtZHYlwABs7
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

SGVsbG8sCgpPbiBTdW4sIDEwIEFwciAyMDIyIDExOjI3OjA5ICswMjAwIEtyenlzenRvZiBLb3ps
b3dza2kgd3JvdGU6Cgo+ID4gVGhlcmUgaXMgYSBwb3RlbnRpYWwgZG91YmxlIGJ1ZyBpbiBuZmNt
cnZsIHVzYiBkcml2ZXIgYmV0d2Vlbgo+ID4gdW5yZWdpc3RlciBhbmQgcmVzdW1lIG9wZXJhdGlv
bi4KPiA+IAo+IAo+IFRoYW5rIHlvdSBmb3IgeW91ciBwYXRjaC4gVGhlcmUgaXMgc29tZXRoaW5n
IHRvIGRpc2N1c3MvaW1wcm92ZS4KPiAKPiA+IFRoZSByYWNlIHRoYXQgY2F1c2UgdGhhdCBkb3Vi
bGUgZnJlZSBidWcgY2FuIGJlIHNob3duIGFzIGJlbG93Ogo+IAo+IFlvdXIgcGF0Y2ggc29sdmVz
IHRoZSBtb3N0IHZpc2libGUgcmFjZSwgYnV0IGJlY2F1c2Ugb2YgbGFjayBvZiBsb2NraW5nLAo+
IEkgYmVsaWV2ZSByYWNlIHN0aWxsIG1pZ2h0IGV4aXN0Ogo+IAo+ICAgIChGUkVFKSAgICAgICAg
ICAgICAgICAgICB8ICAgICAgKFVTRSkKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBu
ZmNtcnZsX3Jlc3VtZQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICBuZmNtcnZsX3N1
Ym1pdF9idWxrX3VyYgo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgbmZjbXJ2bF9i
dWxrX2NvbXBsZXRlCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgbmZjbXJ2bF9u
Y2lfcmVjdl9mcmFtZQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICBuZmNtcnZs
X2Z3X2RubGRfcmVjdl9mcmFtZQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAg
cXVldWVfd29yawo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgIGZ3X2RubGRf
cnhfd29yawo+IG5mY21ydmxfZGlzY29ubmVjdCAgICAgICAgICB8Cj4gIG5mY21ydmxfbmNpX3Vu
cmVnaXN0ZXJfZGV2IHwKPiAgIG5mY21ydmxfZndfZG5sZF9kZWluaXQgICAgfAo+ICAgIHdhaXQg
Zm9yIHRoZSB3b3JrcXVldWUgdG8gZmluaXNoIHwKPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgICAgICAgZndfZG5sZF9vdmVyCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAgICAgICByZWxlYXNlX2Zpcm13YXJlCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAgICAgICAga2ZyZWUoZncpOwo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAg
ICAgIG5vIHN5bmNocm9uaXphdGlvbiAvLygxKQo+ICAgaWYgKGZ3X2Rvd25sb2FkX2luX3Byb2dy
ZXNzKQo+ICAgICAtIG5vIHN5bmNocm9uaXphdGlvbiwgc28gQ1BVIHNlZXMgb2xkIHZhbHVlCj4g
ICBuZmNtcnZsX2Z3X2RubGRfYWJvcnQgICAgIHwKPiAgICBmd19kbmxkX292ZXIgICAgICAgICAg
ICAgfCAgICAgICAgIC4uLgo+ICAgICBpZiAocHJpdi0+ZndfZG5sZC5mdykgICB8Cj4gICAgIHJl
bGVhc2VfZmlybXdhcmUgICAgICAgIHwKPiAgICAgIGtmcmVlKGZ3KTsgLy8oMikgICAgICAgfAo+
ICAgICAgLi4uICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgZncgPSBOVUxMOwo+IAo+IFRo
ZSBrZnJlZSgpIGZyb20gKDIpIHdvdWxkIHN0aWxsIGZyZWUgb2xkIHZhbHVlLiBFdmVuIGlmIGZ3
PU5VTEwgaGFwcGVucwo+IGVhcmxpZXIsIGl0IGlzIG5vdCBwcm9wYWdhdGVkIGJhY2sgdG8gdGhl
IG90aGVyIENQVSwgdW5sZXNzIHRoZXJlIGFyZQo+IHNvbWUgaW1wbGljaXQgYmFycmllcnMgZHVl
IHRvIHdvcmtxdWV1ZT8KPiAKPiBJcyBpdCBzYWZlIHRoZW4gdG8gcmVseSBvbiBzdWNoIGltcGxp
Y2l0IGJhcnJpZXJzIGZyb20gd29ya3F1ZXVlPwoKSSB0aGluayBpdCBpcyBzYWZlIHRvIHJlbHkg
b24gc3VjaCBiYXJyaWVycyBmcm9tIGRlc3Ryb3lfd29ya3F1ZXVlKCkuIApUaGUgZGVzdHJveV93
b3JrcXVldWUgd2lsbCB3YWl0IGFsbCB3b3JrIGl0ZW1zIHRvIGZpbmlzaCwgdGhlIGNvZGUKYmVo
aW5kIGl0IHdpbGwgbm90IGV4ZWN1dGUgdW50aWwgYWxsIHdvcmsgaXRlbXMgYXJlIGZpbmlzaGVk
LgpUaGUgcHJvZ3Jlc3MgaXMgc2hvd24gYmVsb3c6CgpkZXN0cm95X3dvcmtxdWV1ZSgpLS0+ZHJh
aW5fd29ya3F1ZXVlKCktLT5mbHVzaF93b3JrcXVldWUoKS0tPndhaXRfZm9yX2NvbXBsZXRpb24o
KS4KClRoZSBmdW5jdGlvbiBkcmFpbl93b3JrcXVldWUoKSB3aWxsIHdhaXQgdW50aWwgdGhlIHdv
cmtxdWV1ZSBiZWNvbWVzIGVtcHR5LgpJdCBzZXRzIHdxLT5mbGFncyB0byBfX1dRX0RSQUlOSU5H
LCB0aGlzIGNvdWxkIGVuc3VyZSB0aGUgbmV3IGNvbWluZyB3b3JrIGl0ZW1zCndpbGwgbm90IGJl
IHF1ZXVlZCBpbnRvIHRoZSBkcmFpbmluZyB3b3JrcXVldWUuIEJlY2F1c2UgX19xdWV1ZV93b3Jr
IHdpbGwgY2hlY2sKdGhlIF9fV1FfRFJBSU5JTkcgZmxhZy4gCgpUaGVuIGRyYWluX3dvcmtxdWV1
ZSgpIGNhbGxzIGZsdXNoX3dvcmtxdWV1ZSgpIHRvIGVuc3VyZSB0aGF0IGFueSBzY2hlZHVsZWQg
d29yawpoYXMgcnVuIHRvIGNvbXBsZXRpb24uIEJlY2F1c2Ugd2FpdF9mb3JfY29tcGxldGlvbigp
IGlzIGNhbGxlZCBpbiBmbHVzaF93b3JrcXVldWUoKSwKaXQgd2lsbCBibG9jayBjdXJyZW50IHRo
cmVhZCBhbmQgd2FpdCB3b3JrIGl0ZW1zIHRvIGNvbXBsZXRpb24uIAoKQmVzdCByZWdhcmRzLApE
dW9taW5nIFpob3UuCg==
