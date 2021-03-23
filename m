Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5C1F345FD9
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhCWNjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhCWNij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:38:39 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1EA6C061574;
        Tue, 23 Mar 2021 06:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=XJCuu4Snnpqdsj3VqAriEhuGZbjh/SUv8sY/
        HinetRc=; b=P9OuaOhsd2jNpHCwEzjb8GBwu2ncVRPH4+PvMVXvvrSyabVkJTog
        C0c5MWdvsvnOGQgkVgF4KskCfT0MO9OhfnGAI1oeO4N661C69q8eKOEg5DxPe4rA
        x/GACSj24hS/AIz5vhDAIMM45bx21k/pEASVjMdwAmE9CUa2CYxeBh0=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Tue, 23 Mar
 2021 21:38:16 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Tue, 23 Mar 2021 21:38:16 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Maxim Mikityanskiy" <maximmi@nvidia.com>
Cc:     borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, maximmi@mellanox.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] net/mlx5: Fix a potential use after free in
 mlx5e_ktls_del_rx
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <0b9cd54f-cab4-7675-cecf-171d4d45b897@nvidia.com>
References: <20210322142109.6305-1-lyl2019@mail.ustc.edu.cn>
 <0b9cd54f-cab4-7675-cecf-171d4d45b897@nvidia.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <62957134.e4cb.1785f4eb34d.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygB3f0NI71lg6tQkAA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoJBlQhn5V7twAEsz
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW3Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIk1heGltIE1pa2l0
eWFuc2tpeSIgPG1heGltbWlAbnZpZGlhLmNvbT4NCj4g5Y+R6YCB5pe26Ze0OiAyMDIxLTAzLTIz
IDE2OjUyOjA3ICjmmJ/mnJ/kuowpDQo+IOaUtuS7tuS6ujogIkx2IFl1bmxvbmciIDxseWwyMDE5
QG1haWwudXN0Yy5lZHUuY24+LCBib3Jpc3BAbnZpZGlhLmNvbSwgc2FlZWRtQG52aWRpYS5jb20s
IGxlb25Aa2VybmVsLm9yZywgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldCwga3ViYUBrZXJuZWwub3JnLCBt
YXhpbW1pQG1lbGxhbm94LmNvbQ0KPiDmioTpgIE6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcsIGxp
bnV4LXJkbWFAdmdlci5rZXJuZWwub3JnLCBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IOS4u+mimDogUmU6IFtQQVRDSF0gbmV0L21seDU6IEZpeCBhIHBvdGVudGlhbCB1c2UgYWZ0ZXIg
ZnJlZSBpbiBtbHg1ZV9rdGxzX2RlbF9yeA0KPiANCj4gT24gMjAyMS0wMy0yMiAxNjoyMSwgTHYg
WXVubG9uZyB3cm90ZToNCj4gPiBNeSBzdGF0aWMgYW5hbHl6ZXIgdG9vbCByZXBvcnRlZCBhIHBv
dGVudGlhbCB1YWYgaW4NCj4gPiBtbHg1ZV9rdGxzX2RlbF9yeC4gSW4gdGhpcyBmdW5jdGlvbiwg
aWYgdGhlIGNvbmRpdGlvbg0KPiA+IGNhbmNlbF93b3JrX3N5bmMoJnJlc3luYy0+d29yaykgaXMg
dHJ1ZSwgYW5kIHRoZW4NCj4gPiBwcml2X3J4IGNvdWxkIGJlIGZyZWVkLiBCdXQgcHJpdl9yeCBp
cyB1c2VkIGxhdGVyLg0KPiA+IA0KPiA+IEknbSB1bmZhbWlsaWFyIHdpdGggaG93IHRoaXMgZnVu
Y3Rpb24gd29ya3MuIE1heWJlIHRoZQ0KPiA+IG1haW50YWluZXIgZm9yZ290IHRvIGFkZCByZXR1
cm4gYWZ0ZXIgZnJlZWluZyBwcml2X3J4Pw0KPiANCj4gVGhhbmtzIGZvciBydW5uaW5nIGEgc3Rh
dGljIGFuYWx5emVyIG92ZXIgb3VyIGNvZGUhIFNhZGx5LCB0aGUgZml4IGlzIA0KPiBub3QgY29y
cmVjdCBhbmQgYnJlYWtzIHN0dWZmLCBhbmQgdGhlcmUgaXMgbm8gcHJvYmxlbSB3aXRoIHRoaXMg
Y29kZS4NCj4gDQo+IEZpcnN0IG9mIGFsbCwgbWx4NWVfa3Rsc19wcml2X3J4X3B1dCBkb2Vzbid0
IG5lY2Vzc2FyaWx5IGZyZWUgcHJpdl9yeC4gDQo+IEl0IGRlY3JlbWVudHMgdGhlIHJlZmNvdW50
IGFuZCBmcmVlcyB0aGUgb2JqZWN0IG9ubHkgd2hlbiB0aGUgcmVmY291bnQgDQo+IGdvZXMgdG8g
emVyby4gVW5sZXNzIHRoZXJlIGFyZSBvdGhlciBidWdzLCB0aGUgcmVmY291bnQgaW4gdGhpcyBi
cmFuY2ggDQo+IGlzIG5vdCBleHBlY3RlZCB0byBnbyB0byB6ZXJvLCBzbyB0aGVyZSBpcyBubyB1
c2UtYWZ0ZXItZnJlZSBpbiB0aGUgY29kZSANCj4gYmVsb3cuIFRoZSBjb3JyZXNwb25kaW5nIGVs
ZXZhdGlvbiBvZiB0aGUgcmVmY291bnQgaGFwcGVucyBiZWZvcmUgDQo+IHF1ZXVlX3dvcmsgb2Yg
cmVzeW5jLT53b3JrLiBTbywgbm8sIHdlIGhhdmVuJ3QgZm9yZ290IHRvIGFkZCBhIHJldHVybiwg
DQo+IHdlIGp1c3QgZXhwZWN0IHByaXZfcnggdG8gc3RheSBhbGl2ZSBhZnRlciB0aGlzIGNhbGws
IGFuZCB3ZSB3YW50IHRvIHJ1biANCj4gdGhlIGNsZWFudXAgY29kZSBiZWxvdyB0aGlzIGBpZmAs
IHdoaWxlIHlvdXIgZml4IHNraXBzIHRoZSBjbGVhbnVwIGFuZCANCj4gc2tpcHMgdGhlIHNlY29u
ZCBtbHg1ZV9rdGxzX3ByaXZfcnhfcHV0IGluIHRoZSBlbmQgb2YgdGhpcyBmdW5jdGlvbiwgDQo+
IGxlYWRpbmcgdG8gYSBtZW1vcnkgbGVhay4NCj4gDQo+IElmIHlvdSdkIGxpa2UgdG8gY2FsbSBk
b3duIHRoZSBzdGF0aWMgYW5hbHl6ZXIsIHlvdSBjb3VsZCB0cnkgdG8gYWRkIGEgDQo+IFdBUk5f
T04gYXNzZXJ0aW9uIHRvIGNoZWNrIHRoYXQgbWx4NWVfa3Rsc19wcml2X3J4X3B1dCByZXR1cm5z
IGZhbHNlIGluIA0KPiB0aGF0IGBpZmAgKG1lYW5pbmcgdGhhdCB0aGUgb2JqZWN0IGhhc24ndCBi
ZWVuIGZyZWVkKS4gSWYgd291bGQgYmUgbmljZSANCj4gdG8gaGF2ZSB0aGlzIFdBUk5fT04gcmVn
YXJkbGVzcyBvZiBzdGF0aWMgYW5hbHl6ZXJzLg0KPiANCj4gPiBGaXhlczogYjg1MGJiZmY5NjUx
MiAoIm5ldC9tbHg1ZToga1RMUywgVXNlIHJlZmNvdW50cyB0byBmcmVlIGtUTFMgUlggcHJpdiBj
b250ZXh0IikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBMdiBZdW5sb25nIDxseWwyMDE5QG1haWwudXN0
Yy5lZHUuY24+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fYWNjZWwva3Rsc19yeC5jIHwgNCArKystDQo+ID4gICAxIGZpbGUgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3J4
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwva3Rs
c19yeC5jDQo+ID4gaW5kZXggZDA2NTMyZDBiYWE0Li41NGE3N2RmNDIzMTYgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2t0
bHNfcnguYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29y
ZS9lbl9hY2NlbC9rdGxzX3J4LmMNCj4gPiBAQCAtNjYzLDggKzY2MywxMCBAQCB2b2lkIG1seDVl
X2t0bHNfZGVsX3J4KHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsIHN0cnVjdCB0bHNfY29udGV4
dCAqdGxzX2N0eCkNCj4gPiAgIAkJICovDQo+ID4gICAJCXdhaXRfZm9yX2NvbXBsZXRpb24oJnBy
aXZfcngtPmFkZF9jdHgpOw0KPiA+ICAgCXJlc3luYyA9ICZwcml2X3J4LT5yZXN5bmM7DQo+ID4g
LQlpZiAoY2FuY2VsX3dvcmtfc3luYygmcmVzeW5jLT53b3JrKSkNCj4gPiArCWlmIChjYW5jZWxf
d29ya19zeW5jKCZyZXN5bmMtPndvcmspKSB7DQo+ID4gICAJCW1seDVlX2t0bHNfcHJpdl9yeF9w
dXQocHJpdl9yeCk7DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0KPiA+ICAgDQo+ID4gICAJcHJp
dl9yeC0+c3RhdHMtPnRsc19kZWwrKzsNCj4gPiAgIAlpZiAocHJpdl9yeC0+cnVsZS5ydWxlKQ0K
PiA+IA0KPiANCg0KT2ssIGl0IGlzIGEgZ29vZCBpZGVhLiANCg0KVGhhbmsgeW91IGZvciB5b3Vy
IGdlbmVyb3VzIGFkdmljZSAhDQo=
