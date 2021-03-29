Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB64D34CDBE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 12:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhC2KLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 06:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232713AbhC2KLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 06:11:17 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75D07C061574;
        Mon, 29 Mar 2021 03:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=Act1HoZZl+zIcAFDQN1jwVGwdefUdm0EiFSF
        kwRMeuc=; b=hm5QoBLF7/MGTLOBZVTI8+LRyHMyle0xKKw9AneNq+p8q2WeceEC
        ueUfECuJHYGaK+aGpzp1d/yhpYDYfZy6Feuo3vVhC0PbPPjqSFR3n37nS9AM/UBW
        MHalqkdo0PsgAxT5fGSfHFCB6m1Kh2dC2naRcGPdrxccJ0Ne8PQlrQY=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Mon, 29 Mar
 2021 18:11:05 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Mon, 29 Mar 2021 18:11:05 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Heiner Kallweit" <hkallweit1@gmail.com>
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] ethernet/realtek/r8169: Fix a double free in
 rtl8169_start_xmit
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <8d40cd7a-c47e-199d-dccb-e242ec93e143@gmail.com>
References: <20210329090248.4209-1-lyl2019@mail.ustc.edu.cn>
 <8d40cd7a-c47e-199d-dccb-e242ec93e143@gmail.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <31f922b3.1c7ca.1787d772dda.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygCXnUm5p2FgNYRmAA--.2W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoPBlQhn5hSTgAFsp
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIkhlaW5lciBLYWxs
d2VpdCIgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjEtMDMtMjkg
MTc6NTE6MzAgKOaYn+acn+S4gCkNCj4g5pS25Lu25Lq6OiAiTHYgWXVubG9uZyIgPGx5bDIwMTlA
bWFpbC51c3RjLmVkdS5jbj4sIG5pY19zd3NkQHJlYWx0ZWsuY29tLCBrdWJhQGtlcm5lbC5vcmcN
Cj4g5oqE6YCBOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnLCBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IOS4u+mimDogUmU6IFtQQVRDSF0gZXRoZXJuZXQvcmVhbHRlay9yODE2OTogRml4
IGEgZG91YmxlIGZyZWUgaW4gcnRsODE2OV9zdGFydF94bWl0DQo+IA0KPiBPbiAyOS4wMy4yMDIx
IDExOjAyLCBMdiBZdW5sb25nIHdyb3RlOg0KPiA+IEluIHJ0bDgxNjlfc3RhcnRfeG1pdCwgaXQg
Y2FsbHMgcnRsODE2OV90c29fY3N1bV92Mih0cCwgc2tiLCBvcHRzKSBhbmQNCj4gPiBydGw4MTY5
X3Rzb19jc3VtX3YyKCkgY2FsbHMgX19za2JfcHV0X3BhZHRvKHNrYiwgcGFkdG8sIGZhbHNlKS4g
SWYNCj4gPiBfX3NrYl9wdXRfcGFkdG8oKSBmYWlsZWQsIGl0IHdpbGwgZnJlZSB0aGUgc2tiIGlu
IHRoZSBmaXJzdCB0aW1lIGFuZA0KPiA+IHJldHVybiBlcnJvci4gVGhlbiBydGw4MTY5X3N0YXJ0
X3htaXQgd2lsbCBnb3RvIGVycl9kbWFfMC4NCj4gPiANCj4gDQo+IE5vLCB0aGUgc2tiIGlzbid0
IGZyZWVkIGhlcmUgaW4gY2FzZSBvZiBlcnJvci4gSGF2ZSBhIGxvb2sgYXQgdGhlDQo+IGltcGxl
bWVudGF0aW9uIG9mIF9fc2tiX3B1dF9wYWR0bygpIGFuZCBzZWUgYWxzbyBjYzY1MjhiYzlhMGMN
Cj4gKCJyODE2OTogZml4IHBvdGVudGlhbCBza2IgZG91YmxlIGZyZWUgaW4gYW4gZXJyb3IgcGF0
aCIpLg0KPiANCj4gDQo+ID4gQnV0IGluIGVycl9kbWFfMCBsYWJlbCwgdGhlIHNrYiBpcyBmcmVl
ZCBieSBkZXZfa2ZyZWVfc2tiX2FueShza2IpIGluDQo+ID4gdGhlIHNlY29uZCB0aW1lLg0KPiA+
IA0KPiA+IE15IHBhdGNoIGFkZHMgYSBuZXcgbGFiZWwgaW5zaWRlIHRoZSBvbGQgZXJyX2RtYV8w
IGxhYmVsIHRvIGF2b2lkIHRoZQ0KPiA+IGRvdWJsZSBmcmVlIGFuZCByZW5hbWVzIHRoZSBlcnJv
ciBsYWJlbHMgdG8ga2VlcCB0aGUgb3JpZ2luIGZ1bmN0aW9uDQo+ID4gdW5jaGFuZ2VkLg0KPiA+
IA0KPiA+IEZpeGVzOiBiODQ0N2FiYzRjOGZiICgicjgxNjk6IGZhY3RvciBvdXQgcnRsODE2OV90
eF9tYXAiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEx2IFl1bmxvbmcgPGx5bDIwMTlAbWFpbC51c3Rj
LmVkdS5jbj4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2
OV9tYWluLmMgfCA5ICsrKysrLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25z
KCspLCA0IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlYWx0
ZWsvcjgxNjlfbWFpbi5jDQo+ID4gaW5kZXggZjcwNGRhM2YyMTRjLi45MWM0MzM5OTcxMmIgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVhbHRlay9yODE2OV9tYWluLmMN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZWFsdGVrL3I4MTY5X21haW4uYw0KPiA+
IEBAIC00MjE3LDEzICs0MjE3LDEzIEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBydGw4MTY5X3N0YXJ0
X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4gPiAgDQo+ID4gIAlpZiAodW5saWtlbHkocnRs
ODE2OV90eF9tYXAodHAsIG9wdHMsIHNrYl9oZWFkbGVuKHNrYiksIHNrYi0+ZGF0YSwNCj4gPiAg
CQkJCSAgICBlbnRyeSwgZmFsc2UpKSkNCj4gPiAtCQlnb3RvIGVycl9kbWFfMDsNCj4gPiArCQln
b3RvIGVycl9kbWFfMTsNCj4gPiAgDQo+ID4gIAl0eGRfZmlyc3QgPSB0cC0+VHhEZXNjQXJyYXkg
KyBlbnRyeTsNCj4gPiAgDQo+ID4gIAlpZiAoZnJhZ3MpIHsNCj4gPiAgCQlpZiAocnRsODE2OV94
bWl0X2ZyYWdzKHRwLCBza2IsIG9wdHMsIGVudHJ5KSkNCj4gPiAtCQkJZ290byBlcnJfZG1hXzE7
DQo+ID4gKwkJCWdvdG8gZXJyX2RtYV8yOw0KPiA+ICAJCWVudHJ5ID0gKGVudHJ5ICsgZnJhZ3Mp
ICUgTlVNX1RYX0RFU0M7DQo+ID4gIAl9DQo+ID4gIA0KPiA+IEBAIC00MjcwLDEwICs0MjcwLDEx
IEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBydGw4MTY5X3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYg
KnNrYiwNCj4gPiAgDQo+ID4gIAlyZXR1cm4gTkVUREVWX1RYX09LOw0KPiA+ICANCj4gPiAtZXJy
X2RtYV8xOg0KPiA+ICtlcnJfZG1hXzI6DQo+ID4gIAlydGw4MTY5X3VubWFwX3R4X3NrYih0cCwg
ZW50cnkpOw0KPiA+IC1lcnJfZG1hXzA6DQo+ID4gK2Vycl9kbWFfMToNCj4gPiAgCWRldl9rZnJl
ZV9za2JfYW55KHNrYik7DQo+ID4gK2Vycl9kbWFfMDoNCj4gPiAgCWRldi0+c3RhdHMudHhfZHJv
cHBlZCsrOw0KPiA+ICAJcmV0dXJuIE5FVERFVl9UWF9PSzsNCj4gPiAgDQo+ID4gDQo+IA0KDQpP
aywgaSBzZWUgdGFodCBfX3NrYl9wdXRfcGFkdG8oc2tiLCBwYWR0bywgZmFsc2UpIGlzbid0IGZy
ZWUgc2tiIG9uIGVycm9yLg0KDQpUaGFua3MuDQo=
