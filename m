Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81A435E37E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhDMQJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbhDMQJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:09:03 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C04FC061574;
        Tue, 13 Apr 2021 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=JA7rQxmSW3OqjubKoN+A5kxK1s/CDUQrUZZi
        dA4u1/8=; b=D0EGobzir2S1p3zSj8h5x5XdFT3w/8xdWYjMC3/PLqdapihL0r5P
        EbPF2Urspdrdh4o8ep0cOI/Kh4mNGDQPz46zywjpC19+fyJYgN+LSpri9XaXVtpd
        BEW6BZUNb29RMl2TkQ/B6+lVwJokuSkeMnha6PM4p9b5FCsoSmGXd3I=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Wed, 14 Apr
 2021 00:08:32 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Wed, 14 Apr 2021 00:08:32 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Lv Yunlong" <lyl2019@mail.ustc.edu.cn>
Cc:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/marvell/mwifiex: Fix a double free in
 mwifiex_send_tdls_action_frame
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <20210329112435.7960-1-lyl2019@mail.ustc.edu.cn>
References: <20210329112435.7960-1-lyl2019@mail.ustc.edu.cn>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4cb8138.42c74.178cbfdd339.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygCnrUkAwnVgYozSAA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoKBlQhn5-yuwABs6
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSwNCiAgbWFpbnRpYW5lcnMuDQoNCiAgU29ycnkgdG8gZGlzdHVyYiB5b3UsIGJ1dCB0aGlz
IHBhdGNoIHNlZW1zIHRvIGJlIG1pc3NlZCBtb3JlIHRoYW4gdHdvIHdlZWtzLg0KICBDb3VsZCB5
b3UgaGVscCB0byByZXZpZXcgdGhpcyBwYXRjaD8gSSBhbSBzdXJlIGl0IHdvbid0IHRha2UgeW91
IG11Y2ggdGltZS4NCg0KVGhhbmtzLg0KDQo+IC0tLS0t5Y6f5aeL6YKu5Lu2LS0tLS0NCj4g5Y+R
5Lu25Lq6OiAiTHYgWXVubG9uZyIgPGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbj4NCj4g5Y+R6YCB
5pe26Ze0OiAyMDIxLTAzLTI5IDE5OjI0OjM1ICjmmJ/mnJ/kuIApDQo+IOaUtuS7tuS6ujogYW1p
dGthcndhckBnbWFpbC5jb20sIGdhbmFwYXRoaS5iaGF0QG54cC5jb20sIGh1eGlubWluZzgyMEBn
bWFpbC5jb20sIGt2YWxvQGNvZGVhdXJvcmEub3JnLCBkYXZlbUBkYXZlbWxvZnQubmV0LCBrdWJh
QGtlcm5lbC5vcmcNCj4g5oqE6YCBOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcsIG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsICJMdiBZ
dW5sb25nIiA8bHlsMjAxOUBtYWlsLnVzdGMuZWR1LmNuPg0KPiDkuLvpopg6IFtQQVRDSF0gd2ly
ZWxlc3MvbWFydmVsbC9td2lmaWV4OiBGaXggYSBkb3VibGUgZnJlZSBpbiBtd2lmaWV4X3NlbmRf
dGRsc19hY3Rpb25fZnJhbWUNCj4gDQo+IEluIG13aWZpZXhfc2VuZF90ZGxzX2FjdGlvbl9mcmFt
ZSwgaXQgY2FsbHMgbXdpZmlleF9jb25zdHJ1Y3RfdGRsc19hY3Rpb25fZnJhbWUNCj4gKC4uLHNr
YikuIFRoZSBza2Igd2lsbCBiZSBmcmVlZCBpbiBtd2lmaWV4X2NvbnN0cnVjdF90ZGxzX2FjdGlv
bl9mcmFtZSgpIHdoZW4NCj4gaXQgaXMgZmFpbGVkLiBCdXQgd2hlbiBtd2lmaWV4X2NvbnN0cnVj
dF90ZGxzX2FjdGlvbl9mcmFtZSgpIHJldHVybnMgZXJyb3IsDQo+IHRoZSBza2Igd2lsbCBiZSBm
cmVlZCBpbiB0aGUgc2Vjb25kIHRpbWUgYnkgZGV2X2tmcmVlX3NrYl9hbnkoc2tiKS4NCj4gDQo+
IE15IHBhdGNoIHJlbW92ZXMgdGhlIHJlZHVuZGFudCBkZXZfa2ZyZWVfc2tiX2FueShza2IpIHdo
ZW4NCj4gbXdpZmlleF9jb25zdHJ1Y3RfdGRsc19hY3Rpb25fZnJhbWUoKSBmYWlsZWQuDQo+IA0K
PiBGaXhlczogYjIzYmNlMjk2NTY4MCAoIm13aWZpZXg6IGFkZCB0ZGxzX21nbXQgaGFuZGxlciBz
dXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogTHYgWXVubG9uZyA8bHlsMjAxOUBtYWlsLnVzdGMu
ZWR1LmNuPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC90
ZGxzLmMgfCAxIC0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3RkbHMuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC90ZGxzLmMNCj4gaW5kZXggOTdiYjg3
YzM2NzZiLi44ZDRkMGE5Y2Y2YWMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L21hcnZlbGwvbXdpZmlleC90ZGxzLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFy
dmVsbC9td2lmaWV4L3RkbHMuYw0KPiBAQCAtODU2LDcgKzg1Niw2IEBAIGludCBtd2lmaWV4X3Nl
bmRfdGRsc19hY3Rpb25fZnJhbWUoc3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiwgY29uc3Qg
dTggKnBlZXIsDQo+ICAJaWYgKG13aWZpZXhfY29uc3RydWN0X3RkbHNfYWN0aW9uX2ZyYW1lKHBy
aXYsIHBlZXIsIGFjdGlvbl9jb2RlLA0KPiAgCQkJCQkJZGlhbG9nX3Rva2VuLCBzdGF0dXNfY29k
ZSwNCj4gIAkJCQkJCXNrYikpIHsNCj4gLQkJZGV2X2tmcmVlX3NrYl9hbnkoc2tiKTsNCj4gIAkJ
cmV0dXJuIC1FSU5WQUw7DQo+ICAJfQ0KPiAgDQo+IC0tIA0KPiAyLjI1LjENCj4gDQo=
