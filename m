Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF95505A7C
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 17:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244501AbiDRPHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 11:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345333AbiDRPHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 11:07:38 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8D102CC8C;
        Mon, 18 Apr 2022 06:59:25 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Mon, 18 Apr 2022 21:59:10
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.9.250]
Date:   Mon, 18 Apr 2022 21:59:10 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Guenter Roeck" <linux@roeck-us.net>
Cc:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com
Subject: Re: [PATCH v0] nfc: nci: add flush_workqueue to prevent uaf
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220418134133.GA872670@roeck-us.net>
References: <20220412160430.11581-1-linma@zju.edu.cn>
 <20220418134133.GA872670@roeck-us.net>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <524c4fb6.6e33.1803cf85ae9.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: cS_KCgAXGfCubl1iY4VnAQ--.51417W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwQEElNG3GZe+AAAsY
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

SGVsbG8gR3VlbnRlciwKCj4gSSBoYXZlIGJlZW4gd29uZGVyaW5nIGFib3V0IHRoaXMgYW5kIHRo
ZSBzYW1lIGNvZGUgZnVydGhlciBiZWxvdy4KPiBXaGF0IHByZXZlbnRzIHRoZSBjb21tYW5kIHRp
bWVyIGZyb20gZmlyaW5nIGFmdGVyIHRoZSBjYWxsIHRvCj4gZmx1c2hfd29ya3F1ZXVlKCkgPwo+
IAo+IFRoYW5rcywKPiBHdWVudGVyCj4gCgpGcm9tIG15IHVuZGVyc3RhbmRpbmcsIG9uY2UgdGhl
IGZsdXNoX3dvcmtxdWV1ZSgpIGlzIGV4ZWN1dGVkLCB0aGUgd29yayB0aGF0IHF1ZXVlZCBpbgpu
ZGV2LT5jbWRfd3Egd2lsbCBiZSB0YWtlbiB0aGUgY2FyZSBvZi4KClRoYXQgaXMsIG9uY2UgdGhl
IGZsdXNoX3dvcmtxdWV1ZSgpIGlzIGZpbmlzaGVkLCBpdCBwcm9taXNlcyB0aGVyZSBpcyBubyBl
eGVjdXRpbmcgb3IgCnBlbmRpbmcgbmNpX2NtZF93b3JrKCkgZXZlci4KCnN0YXRpYyB2b2lkIG5j
aV9jbWRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCnsKICAgIC8vIC4uLgoJCW1vZF90
aW1lcigmbmRldi0+Y21kX3RpbWVyLAoJCQkgIGppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKE5D
SV9DTURfVElNRU9VVCkpOwogICAgLy8gLi4uCn0KClRoZSBjb21tYW5kIHRpbWVyIGlzIHN0aWxs
IGFibGUgYmUgZmlyZWQgYmVjYXVzZSB0aGUgbW9kX3RpbWVyKCkgaGVyZS4gVGhhdCBpcyB3aHkg
dGhlCmRlbF90aW1lcl9zeW5jKCkgaXMgbmVjZXNzYXJ5IGFmdGVyIHRoZSBmbHVzaF93b3JrcXVl
dWUoKS4KCk9uZSB2ZXJ5IHB1enpsaW5nIHBhcnQgaXMgdGhhdCB5b3UgbWF5IGZpbmQgb3V0IHRo
ZSB0aW1lciBxdWV1ZSB0aGUgd29yayBhZ2FpbgoKLyogTkNJIGNvbW1hbmQgdGltZXIgZnVuY3Rp
b24gKi8Kc3RhdGljIHZvaWQgbmNpX2NtZF90aW1lcihzdHJ1Y3QgdGltZXJfbGlzdCAqdCkKewog
ICAgLy8gLi4uCglxdWV1ZV93b3JrKG5kZXYtPmNtZF93cSwgJm5kZXYtPmNtZF93b3JrKTsKfQoK
QnV0IEkgZm91bmQgdGhhdCB0aGlzIGlzIG9rYXkgYmVjYXVzZSB0aGVyZSBpcyBubyBwYWNrZXRz
IGluIG5kZXYtPmNtZF9xIGJ1ZmZlcnMgaGVuY2UgCmV2ZW4gdGhlcmUgaXMgYSBxdWV1ZWQgbmNp
X2NtZF93b3JrKCksIGl0IHNpbXBseSBjaGVja3MgdGhlIHF1ZXVlIGFuZCByZXR1cm5zLgoKVGhh
dCBpcywgdGhlIG9sZCByYWNlIHBpY3R1cmUgYXMgYmVsb3cKCj4gVGhyZWFkLTEgICAgICAgICAg
ICAgICAgICAgICAgICAgICBUaHJlYWQtMgo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgbmNpX2Rldl91cCgpCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
IG5jaV9vcGVuX2RldmljZSgpCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAg
ICAgX19uY2lfcmVxdWVzdChuY2lfcmVzZXRfcmVxKQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAgICAgbmNpX3NlbmRfY21kCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgICAgICAgIHF1ZXVlX3dvcmsoY21kX3dvcmspCj4gbmNpX3VucmVnaXN0ZXJf
ZGV2aWNlKCkgICAgICAgICAgfAo+ICAgbmNpX2Nsb3NlX2RldmljZSgpICAgICAgICAgICAgIHwg
Li4uCj4gICAgIGRlbF90aW1lcl9zeW5jKGNtZF90aW1lcilbMV0gfAo+IC4uLiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgV29ya2VyCj4gbmNpX2ZyZWVfZGV2aWNlKCkgICAgICAgICAg
ICAgICAgfCBuY2lfY21kX3dvcmsoKQo+ICAga2ZyZWUobmRldilbM10gICAgICAgICAgICAgICAg
IHwgICBtb2RfdGltZXIoY21kX3RpbWVyKVsyXQoKaXMgaW1wb3NzaWJsZSBub3cgYmVjYXVzZSB0
aGUgcGF0Y2hlZCBmbHVzaF93b3JrcXVldWUoKSBtYWtlIHRoZSByYWNlIGxpa2UgYmVsb3cKCj4g
VGhyZWFkLTEgICAgICAgICAgICAgICAgICAgICAgICAgICBUaHJlYWQtMgo+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHwgbmNpX2Rldl91cCgpCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgIG5jaV9vcGVuX2RldmljZSgpCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICAgX19uY2lfcmVxdWVzdChuY2lfcmVzZXRfcmVxKQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgbmNpX3NlbmRfY21kCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgIHF1ZXVlX3dvcmsoY21kX3dvcmsp
Cj4gbmNpX3VucmVnaXN0ZXJfZGV2aWNlKCkgICAgICAgICAgfAo+ICAgbmNpX2Nsb3NlX2Rldmlj
ZSgpICAgICAgICAgICAgIHwgLi4uCj4gICAgIGZsdXNoX3dvcmtxdWV1ZSgpW3BhdGNoXSAgICAg
fCBXb3JrZXIKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IG5jaV9jbWRfd29y
aygpCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIG1vZF90aW1lcihjbWRf
dGltZXIpWzJdCj4gICAgIC8vIHdvcmsgb3ZlciB0aGVuIHJldHVybgo+ICAgICBkZWxfdGltZXJf
c3luYyhjbWRfdGltZXIpWzFdIHwKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IFRpbWVyCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCBuY2lfY21kX3RpbWVy
KCkKPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IAo+ICAgICAvLyB0aW1lciBv
dmVyIHRoZW4gcmV0dXJuICAgIHwKPiAuLi4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
Cj4gbmNpX2ZyZWVfZGV2aWNlKCkgICAgICAgICAgICAgICAgfCAKPiAgIGtmcmVlKG5kZXYpWzNd
ICAgICAgICAgICAgICAgICB8IAoKCldpdGggYWJvdmUgdGhpbmtpbmdzIGFuZCB0aGUgZ2l2ZW4g
ZmFjdCB0aGF0IG15IFBPQyBkaWRuJ3QgcmFpc2UgdGhlIFVBRiwgSSB0aGluayB0aGUgCmZsdXNo
X3dvcmtxdWV1ZSgpICsgZGVsX3RpbWVyX3N5bmMoKSBjb21iaW5hdGlvbiBpcyBva2F5IHRvIGhp
bmRlciB0aGlzIHJhY2UuCgpUZWxsIG1lIGlmIHRoZXJlIGlzIGFueXRoaW5nIHdyb25nLgoKUmVn
YXJkcwpMaW4gTWEKCgo=
