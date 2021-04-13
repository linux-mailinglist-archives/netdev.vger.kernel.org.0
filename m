Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6835E3C1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243617AbhDMQXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbhDMQXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:23:39 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DCA7C061574;
        Tue, 13 Apr 2021 09:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=KLOg2+58cEyUirpERAet10ZJzgxGqQFzLHU2
        9TCEotM=; b=gQvHxlFbgEqz/JOyT6ucU+uW/eQTIDlLuZ2taxh2/UnkXvs1/MrB
        ho27t+BOGGuRlt6JzcpgOqdjwX1reV5n7jNv8dq+6kEzJt7pihF8jwgl5KOUby0h
        sEBNOnItZv2R6nvQycTa6j4bsbNdAOghJ6qbCzXaJK1cTCRzYalzlAE=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Wed, 14 Apr
 2021 00:23:12 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Wed, 14 Apr 2021 00:23:12 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Lv Yunlong" <lyl2019@mail.ustc.edu.cn>
Cc:     buytenh@wantstofly.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, gustavoars@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: marvell: mwl8k: Fix a double Free in
 mwl8k_probe_hw
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <20210402182627.4256-1-lyl2019@mail.ustc.edu.cn>
References: <20210402182627.4256-1-lyl2019@mail.ustc.edu.cn>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <56a96726.42ca6.178cc0b3e40.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygDn7qZwxXVgA53SAA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQsKBlQhn5-zJQACsn
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpEZWFyIG1haW50YWluZXJzLA0KICAgIA0KICAgICBJJ20gc29ycnkgdG8gZGlzdHVyYiB5b3Us
IGJ1dCB0aGlzIHBhdGNoIGhhcyBub3QgYmVlbiByZXZpZXdlZCBmb3IgbW9yZSB0aGFuIGEgd2Vl
ay4NCiAgICAgQ291bGQgeW91IHBsZWFzZSBoZWxwIHRvIHJldmlldyB0aGlzIHBhdGNoPyBJdCB3
aWxsIG5vdCB0YWtlIHlvdSBhIGxvdCB0aW1lLg0KDQpTaW5jZXJlbHkuDQoNCj4gLS0tLS3ljp/l
p4vpgq7ku7YtLS0tLQ0KPiDlj5Hku7bkuro6ICJMdiBZdW5sb25nIiA8bHlsMjAxOUBtYWlsLnVz
dGMuZWR1LmNuPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjEtMDQtMDMgMDI6MjY6MjcgKOaYn+acn+WF
rSkNCj4g5pS25Lu25Lq6OiBidXl0ZW5oQHdhbnRzdG9mbHkub3JnLCBrdmFsb0Bjb2RlYXVyb3Jh
Lm9yZywgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldCwga3ViYUBrZXJuZWwub3JnLCBndXN0YXZvYXJzQGtl
cm5lbC5vcmcNCj4g5oqE6YCBOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcsIG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsICJMdiBZdW5s
b25nIiA8bHlsMjAxOUBtYWlsLnVzdGMuZWR1LmNuPg0KPiDkuLvpopg6IFtQQVRDSF0gd2lyZWxl
c3M6IG1hcnZlbGw6IG13bDhrOiBGaXggYSBkb3VibGUgRnJlZSBpbiBtd2w4a19wcm9iZV9odw0K
PiANCj4gSW4gbXdsOGtfcHJvYmVfaHcsIGh3LT5wcml2LT50eHEgaXMgZnJlZWQgYXQgdGhlIGZp
cnN0IHRpbWUgYnkNCj4gZG1hX2ZyZWVfY29oZXJlbnQoKSBpbiB0aGUgY2FsbCBjaGFpbjoNCj4g
aWYoIXByaXYtPmFwX2Z3KS0+bXdsOGtfaW5pdF90eHFzKGh3KS0+bXdsOGtfdHhxX2luaXQoaHcs
IGkpLg0KPiANCj4gVGhlbiBpbiBlcnJfZnJlZV9xdWV1ZXMgb2YgbXdsOGtfcHJvYmVfaHcsIGh3
LT5wcml2LT50eHEgaXMgZnJlZWQNCj4gYXQgdGhlIHNlY29uZCB0aW1lIGJ5IG13bDhrX3R4cV9k
ZWluaXQoaHcsIGkpLT5kbWFfZnJlZV9jb2hlcmVudCgpLg0KPiANCj4gTXkgcGF0Y2ggc2V0IHR4
cS0+dHhkIHRvIE5VTEwgYWZ0ZXIgdGhlIGZpcnN0IGZyZWUgdG8gYXZvaWQgdGhlDQo+IGRvdWJs
ZSBmcmVlLg0KPiANCj4gRml4ZXM6IGE2NjA5OGRhYWNlZTIgKCJtd2w4azogTWFydmVsbCBUT1BE
T0cgd2lyZWxlc3MgZHJpdmVyIikNCj4gU2lnbmVkLW9mZi1ieTogTHYgWXVubG9uZyA8bHlsMjAx
OUBtYWlsLnVzdGMuZWR1LmNuPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZl
bGwvbXdsOGsuYyB8IDEgKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2w4ay5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2w4ay5jDQo+IGluZGV4IGM5ZjhjMDU2YWE1MS4u
ODRiMzJhNWYwMWVlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxs
L213bDhrLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2w4ay5jDQo+
IEBAIC0xNDczLDYgKzE0NzMsNyBAQCBzdGF0aWMgaW50IG13bDhrX3R4cV9pbml0KHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LCBpbnQgaW5kZXgpDQo+ICAJaWYgKHR4cS0+c2tiID09IE5VTEwpIHsN
Cj4gIAkJZG1hX2ZyZWVfY29oZXJlbnQoJnByaXYtPnBkZXYtPmRldiwgc2l6ZSwgdHhxLT50eGQs
DQo+ICAJCQkJICB0eHEtPnR4ZF9kbWEpOw0KPiArCQl0eHEtPnR4ZCA9IE5VTEw7DQo+ICAJCXJl
dHVybiAtRU5PTUVNOw0KPiAgCX0NCj4gIA0KPiAtLSANCj4gMi4yNS4xDQo+IA0K
