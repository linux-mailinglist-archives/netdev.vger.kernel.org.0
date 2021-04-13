Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F88235E39D
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbhDMQQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhDMQQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:16:02 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8858C061574;
        Tue, 13 Apr 2021 09:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=25jLgPOi6AVJ23kd4QoHmeCJteCastNfRFqW
        HT87oho=; b=p/cuANaoRaCnxa7JAM4E8fgQv7xt/TNh1dcFceU+x15XvkBP1ajY
        ijSXXAzi9oQicTR9mS6igb96HkZTKPm9hRcfdYV0MVfgvBSX7unzfLGTcnZ39aMu
        QGC4ck/Uc21gCx/jus9jHjtYrgBm0Svszu9XZHjspN7gwL0kaThPB2g=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Wed, 14 Apr
 2021 00:15:36 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Wed, 14 Apr 2021 00:15:36 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Lv Yunlong" <lyl2019@mail.ustc.edu.cn>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: ath10k: Fix a use after free in
 ath10k_htc_send_bundle
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <20210329120154.8963-1-lyl2019@mail.ustc.edu.cn>
References: <20210329120154.8963-1-lyl2019@mail.ustc.edu.cn>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <5e01cb1.42c8e.178cc044bed.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygCnsqyow3VgdpPSAA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoKBlQhn5-yvQACs-
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSwgbWFpbnRhaW5lcnMgb2Yga2VyZW5sLg0KDQogICAgSSBzdWJtaXR0ZWQgdGhpcyBwYXRj
aCB0d28gd2Vla3MgYWdvLCBidXQgaXQgc3RpbGwgaGFzbid0IGJlZW4gcmV2aWV3ZWQuDQogICAg
Q291bGQgeW91IGhlbHAgdG8gcmV2aWV3IHRoaXMgcGF0Y2g/IEl0IHdpbGwgbm90IHRha2UgeW91
IG11Y2ggdGltZS4NCg0KVGhhbmsgeW91IHZlcnkgbXVjaC4NCg0KPiAtLS0tLeWOn+Wni+mCruS7
ti0tLS0tDQo+IOWPkeS7tuS6ujogIkx2IFl1bmxvbmciIDxseWwyMDE5QG1haWwudXN0Yy5lZHUu
Y24+DQo+IOWPkemAgeaXtumXtDogMjAyMS0wMy0yOSAyMDowMTo1NCAo5pif5pyf5LiAKQ0KPiDm
lLbku7bkuro6IGt2YWxvQGNvZGVhdXJvcmEub3JnLCBkYXZlbUBkYXZlbWxvZnQubmV0LCBrdWJh
QGtlcm5lbC5vcmcNCj4g5oqE6YCBOiBhdGgxMGtAbGlzdHMuaW5mcmFkZWFkLm9yZywgbGludXgt
d2lyZWxlc3NAdmdlci5rZXJuZWwub3JnLCBuZXRkZXZAdmdlci5rZXJuZWwub3JnLCBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnLCAiTHYgWXVubG9uZyIgPGx5bDIwMTlAbWFpbC51c3RjLmVk
dS5jbj4NCj4g5Li76aKYOiBbUEFUQ0hdIHdpcmVsZXNzOiBhdGgxMGs6IEZpeCBhIHVzZSBhZnRl
ciBmcmVlIGluIGF0aDEwa19odGNfc2VuZF9idW5kbGUNCj4gDQo+IEluIGF0aDEwa19odGNfc2Vu
ZF9idW5kbGUsIHRoZSBidW5kbGVfc2tiIGNvdWxkIGJlIGZyZWVkIGJ5DQo+IGRldl9rZnJlZV9z
a2JfYW55KGJ1bmRsZV9za2IpLiBCdXQgdGhlIGJ1bmRsZV9za2IgaXMgdXNlZCBsYXRlcg0KPiBi
eSBidW5kbGVfc2tiLT5sZW4uDQo+IA0KPiBBcyBza2JfbGVuID0gYnVuZGxlX3NrYi0+bGVuLCBt
eSBwYXRjaCByZXBsYWNlcyBidW5kbGVfc2tiLT5sZW4gdG8NCj4gc2tiX2xlbiBhZnRlciB0aGUg
YnVuZGxlX3NrYiB3YXMgZnJlZWQuDQo+IA0KPiBGaXhlczogYzgzMzQ1MTJmM2RkMSAoImF0aDEw
azogYWRkIGh0dCBUWCBidW5kbGUgZm9yIHNkaW8iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBMdiBZdW5s
b25nIDxseWwyMDE5QG1haWwudXN0Yy5lZHUuY24+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDEway9odGMuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hdGgxMGsvaHRjLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBr
L2h0Yy5jDQo+IGluZGV4IDBhMzdiZTZhN2QzMy4uZmFiMzk4MDQ2YTNmIDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL2h0Yy5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvaHRjLmMNCj4gQEAgLTY2OSw3ICs2NjksNyBAQCBzdGF0
aWMgaW50IGF0aDEwa19odGNfc2VuZF9idW5kbGUoc3RydWN0IGF0aDEwa19odGNfZXAgKmVwLA0K
PiAgDQo+ICAJYXRoMTBrX2RiZyhhciwgQVRIMTBLX0RCR19IVEMsDQo+ICAJCSAgICJidW5kbGUg
dHggc3RhdHVzICVkIGVpZCAlZCByZXEgY291bnQgJWQgY291bnQgJWQgbGVuICVkXG4iLA0KPiAt
CQkgICByZXQsIGVwLT5laWQsIHNrYl9xdWV1ZV9sZW4oJmVwLT50eF9yZXFfaGVhZCksIGNuLCBi
dW5kbGVfc2tiLT5sZW4pOw0KPiArCQkgICByZXQsIGVwLT5laWQsIHNrYl9xdWV1ZV9sZW4oJmVw
LT50eF9yZXFfaGVhZCksIGNuLCBza2JfbGVuKTsNCj4gIAlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiAg
DQo+IC0tIA0KPiAyLjI1LjENCj4gDQo=
