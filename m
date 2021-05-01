Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4099D3707BE
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 17:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhEAPfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 11:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhEAPfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 11:35:18 -0400
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57E03C06174A;
        Sat,  1 May 2021 08:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=snArhVEJbdtekvHkgQZims1WnjIWzvO1GMDx
        WvvzH+A=; b=i/8Yu8LiGA0Fiz9LSigis7nlZCAk2mrJKlYWW35Ui7pKuELvCXHu
        /vOWX/XQRhEK7uRrJisAaHsIZMV/5Jy62yT0Vd0ceUuGh+GyggWjMPKUEx+Dp7q/
        cU+vztxU5CnwlaisYRUwUuIbgJC9KIjySTo6xoYIB9BpxYdNUnZxcmM=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Sat, 1 May
 2021 23:34:21 +0800 (GMT+08:00)
X-Originating-IP: [202.38.69.14]
Date:   Sat, 1 May 2021 23:34:21 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Govindarajulu Varadarajan" <govind.varadar@gmail.com>
Cc:     benve@cisco.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [BUG] ethernet:enic: A use after free bug in
 enic_hard_start_xmit
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <8e420732d2aabccca8b5e932b589ce90d9f70d6b.camel@gmail.com>
References: <65becad9.62766.17911406ff0.Coremail.lyl2019@mail.ustc.edu.cn>
 <8e420732d2aabccca8b5e932b589ce90d9f70d6b.camel@gmail.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <8601748.6d378.1792890fe2f.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygDHz5v9dI1gVGB1AA--.0W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoIBlQhn6nCpAADsj
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIkdvdmluZGFyYWp1
bHUgVmFyYWRhcmFqYW4iIDxnb3ZpbmQudmFyYWRhckBnbWFpbC5jb20+DQo+IOWPkemAgeaXtumX
tDogMjAyMS0wNS0wMSAwODoxMDowMiAo5pif5pyf5YWtKQ0KPiDmlLbku7bkuro6IGx5bDIwMTlA
bWFpbC51c3RjLmVkdS5jbiwgYmVudmVAY2lzY28uY29tLCBkYXZlbUBkYXZlbWxvZnQubmV0LCBr
dWJhQGtlcm5lbC5vcmcNCj4g5oqE6YCBOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnLCBsaW51eC1r
ZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IOS4u+mimDogUmU6IFtCVUddIGV0aGVybmV0OmVuaWM6
IEEgdXNlIGFmdGVyIGZyZWUgYnVnIGluIGVuaWNfaGFyZF9zdGFydF94bWl0DQo+IA0KPiBPbiBU
dWUsIDIwMjEtMDQtMjcgYXQgMTA6NTUgKzA4MDAsIGx5bDIwMTlAbWFpbC51c3RjLmVkdS5jbiB3
cm90ZToNCj4gPiBIaSwgbWFpbnRhaW5lcnMuDQo+ID4gwqDCoMKgIE91ciBjb2RlIGFuYWx5emVy
IHJlcG9ydGVkIGEgdWFmIGJ1ZywgYnV0IGl0IGlzIGEgbGl0dGxlDQo+ID4gZGlmZmljdWx0IGZv
ciBtZSB0byBmaXggaXQgZGlyZWN0bHkuDQo+ID4gDQo+ID4gRmlsZTogZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2lzY28vZW5pYy9lbmljX21haW4uYw0KPiA+IEluIGVuaWNfaGFyZF9zdGFydF94bWl0
LCBpdCBjYWxscyBlbmljX3F1ZXVlX3dxX3NrYigpLiBJbnNpZGUNCj4gPiBlbmljX3F1ZXVlX3dx
X3NrYiwgaWYgc29tZSBlcnJvciBoYXBwZW5zLCB0aGUgc2tiIHdpbGwgYmUgZnJlZWQNCj4gPiBi
eSBkZXZfa2ZyZWVfc2tiKHNrYikuIEJ1dCB0aGUgZnJlZWQgc2tiIGlzIHN0aWxsIHVzZWQgaW4g
DQo+ID4gc2tiX3R4X3RpbWVzdGFtcChza2IpLg0KPiA+IA0KPiA+IGBgYA0KPiA+IMKgwqDCoMKg
wqDCoMKgwqBlbmljX3F1ZXVlX3dxX3NrYihlbmljLCB3cSwgc2tiKTsvLyBza2IgY291bGQgZnJl
ZWQgaGVyZQ0KPiA+IA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAodm5pY193cV9kZXNjX2F2YWls
KHdxKSA8IE1BWF9TS0JfRlJBR1MgKyBFTklDX0RFU0NfTUFYX1NQTElUUykNCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5ldGlmX3R4X3N0b3BfcXVldWUodHhxKTsNCj4gPiDC
oMKgwqDCoMKgwqDCoMKgc2tiX3R4X3RpbWVzdGFtcChza2IpOyAvLyBmcmVlZCBza2IgaXMgdXNl
ZCBoZXJlLg0KPiA+IGBgYA0KPiA+IEJ1ZyBpbnRyb2R1Y2VkIGJ5IGZiNzUxNmQ0MjQ3OGUgKCJl
bmljOiBhZGQgc3cgdGltZXN0YW1wIHN1cHBvcnQiKS4NCj4gDQo+IFRoYW5rIHlvdSBmb3IgcmVw
b3J0aW5nIHRoaXMuDQo+IA0KPiBPbmUgc29sdXRpb24gaXMgdG8gbWFrZSBlbmljX3F1ZXVlX3dx
X3NrYigpIHJldHVybiBlcnJvciBhbmQgZ290byBzcGluX3VubG9jaygpDQo+IGluY2FzZSBvZiBl
cnJvci4NCj4gDQo+IFdvdWxkIHlvdSBsaWtlIHRvIHNlbmQgdGhlIGZpeCBmb3IgdGhpcz8NCj4g
DQo+IC0tDQo+IEdvdmluZA0KPiANCg0KSXQgaXMgbXkgcGxlYXN1cmUsIGkgaGF2ZSBzdWJtaXR0
ZWQgdGhpcyBmaXguDQpTZWUgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcGF0Y2h3b3JrL3BhdGNo
LzE0MjA2OTIvLg0KDQpUaGFua3MuDQo=
