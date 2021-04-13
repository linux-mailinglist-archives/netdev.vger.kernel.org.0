Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F04935E3F4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346268AbhDMQ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245746AbhDMQ3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:29:48 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2A8ABC061574;
        Tue, 13 Apr 2021 09:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=Mw+RGqsEZUSTb3FQQbLXK46lGn+VzcVuLTFL
        CzvUBmY=; b=PN8nK4DgCYrifypPZZ5q+bqdkoo/wqpfLKCYdTz4VdAXJ2TnYTr/
        uCQ4QYlRSLskOhqK2XwnRzIDTmIpl1ptLAwvb5v50sb9T4sx7MD2oWyPq3EWQt9M
        7Hc/dHct3wBqaXtXMqJRje/FXqDKbbbNFrMungIsMsSYbXaIB/828fc=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Wed, 14 Apr
 2021 00:29:21 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Wed, 14 Apr 2021 00:29:21 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Lv Yunlong" <lyl2019@mail.ustc.edu.cn>
Cc:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        mordechay.goodstein@intel.com, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: iwlwifi: Fix a double free in
 iwl_txq_dyn_alloc_dma
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <20210403054755.4781-1-lyl2019@mail.ustc.edu.cn>
References: <20210403054755.4781-1-lyl2019@mail.ustc.edu.cn>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <58a46153.42cc9.178cc10e136.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygDX3krhxnVg76LSAA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoKBlQhn5-zhgACsF
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSwgbXkgZGVhciBtYWludGFpbmVycy4NCg0KICAgICBJJ20gdmVyeSBzb3JyeSB0byBkaXN0
dXJiIHlvdSwgdGhhdCBiZWFjdXNlIHRoaXMgcGF0Y2ggaGFzIGJlZW4gbm90IHJldmlld2VkIGZv
ciBvbmUgd2Vla3MuDQogICAgIENvdWxkIHlvdSBoZWxwIHRvIHJldmlldyB0aGlzIHBhdGNoPyBJ
dCB3aWxsIG5vdCBjb3N0IHlvdSBtdWNoIHRpbWUuDQoNClNpbmNlcmVseS4NCiAgDQoNCj4gLS0t
LS3ljp/lp4vpgq7ku7YtLS0tLQ0KPiDlj5Hku7bkuro6ICJMdiBZdW5sb25nIiA8bHlsMjAxOUBt
YWlsLnVzdGMuZWR1LmNuPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjEtMDQtMDMgMTM6NDc6NTUgKOaY
n+acn+WFrSkNCj4g5pS25Lu25Lq6OiBsdWNpYW5vLmNvZWxob0BpbnRlbC5jb20sIGt2YWxvQGNv
ZGVhdXJvcmEub3JnLCBkYXZlbUBkYXZlbWxvZnQubmV0LCBrdWJhQGtlcm5lbC5vcmcsIG1vcmRl
Y2hheS5nb29kc3RlaW5AaW50ZWwuY29tLCBqb2hhbm5lcy5iZXJnQGludGVsLmNvbSwgZW1tYW51
ZWwuZ3J1bWJhY2hAaW50ZWwuY29tDQo+IOaKhOmAgTogbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnLCBuZXRkZXZAdmdlci5rZXJuZWwub3JnLCBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnLCAiTHYgWXVubG9uZyIgPGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbj4NCj4g5Li76aKYOiBb
UEFUQ0hdIHdpcmVsZXNzOiBpd2x3aWZpOiBGaXggYSBkb3VibGUgZnJlZSBpbiBpd2xfdHhxX2R5
bl9hbGxvY19kbWENCj4gDQo+IEluIGl3bF90eHFfZHluX2FsbG9jX2RtYSwgdHhxLT50ZmRzIGlz
IGZyZWVkIGF0IGZpcnN0IHRpbWUgYnk6DQo+IGl3bF90eHFfYWxsb2MoKS0+Z290byBlcnJfZnJl
ZV90ZmRzLT5kbWFfZnJlZV9jb2hlcmVudCgpLiBCdXQNCj4gaXQgZm9yZ290IHRvIHNldCB0eHEt
PnRmZHMgdG8gTlVMTC4NCj4gDQo+IFRoZW4gdGhlIHR4cS0+dGZkcyBpcyBmcmVlZCBhZ2FpbiBp
biBpd2xfdHhxX2R5bl9hbGxvY19kbWEgYnk6DQo+IGdvdG8gZXJyb3ItPml3bF90eHFfZ2VuMl9m
cmVlX21lbW9yeSgpLT5kbWFfZnJlZV9jb2hlcmVudCgpLg0KPiANCj4gTXkgcGF0Y2ggc2V0cyB0
eHEtPnRmZHMgdG8gTlVMTCBhZnRlciB0aGUgZmlyc3QgZnJlZSB0byBhdm9pZCB0aGUNCj4gZG91
YmxlIGZyZWUuDQo+IA0KPiBGaXhlczogMGNkMWFkMmQ3ZmQ0MSAoIml3bHdpZmk6IG1vdmUgYWxs
IGJ1cy1pbmRlcGVuZGVudCBUWCBmdW5jdGlvbnMgdG8gY29tbW9uIGNvZGUiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBMdiBZdW5sb25nIDxseWwyMDE5QG1haWwudXN0Yy5lZHUuY24+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9xdWV1ZS90eC5jIHwgMSArDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3F1ZXVlL3R4LmMgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9pbnRlbC9pd2x3aWZpL3F1ZXVlL3R4LmMNCj4gaW5kZXggODMzZjQzZDFjYTdhLi45OWM4
ZTQ3MzAzMWEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdp
ZmkvcXVldWUvdHguYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZp
L3F1ZXVlL3R4LmMNCj4gQEAgLTExMDEsNiArMTEwMSw3IEBAIGludCBpd2xfdHhxX2FsbG9jKHN0
cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBzdHJ1Y3QgaXdsX3R4cSAqdHhxLCBpbnQgc2xvdHNfbnVt
LA0KPiAgCXJldHVybiAwOw0KPiAgZXJyX2ZyZWVfdGZkczoNCj4gIAlkbWFfZnJlZV9jb2hlcmVu
dCh0cmFucy0+ZGV2LCB0ZmRfc3osIHR4cS0+dGZkcywgdHhxLT5kbWFfYWRkcik7DQo+ICsJdHhx
LT50ZmRzID0gTlVMTDsNCj4gIGVycm9yOg0KPiAgCWlmICh0eHEtPmVudHJpZXMgJiYgY21kX3F1
ZXVlKQ0KPiAgCQlmb3IgKGkgPSAwOyBpIDwgc2xvdHNfbnVtOyBpKyspDQo+IC0tIA0KPiAyLjI1
LjENCj4gDQo=
