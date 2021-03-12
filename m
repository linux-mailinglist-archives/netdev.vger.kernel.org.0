Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5618B33904A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhCLOs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbhCLOsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:48:21 -0500
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10DDAC061574;
        Fri, 12 Mar 2021 06:48:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Cc:Subject:
        In-Reply-To:References:Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID; bh=eNe3lMdiYSlKSx8VAknAbgTJQAiODgr25WWb
        vEVvKw8=; b=vkd8x3CPwQqjbSXY7DrdPHrJ/u/bevx/DjhcTz2DIjOi/l7PcaiK
        14bsSV96+2nPgBytfc6g0dfksZJyi149ANM4bHe6JFTPq8IYvYAHLEPA46bIm1MZ
        ret2tV0E7+NTrAJOhwcfj4VDtgenVGLpCkIgb7cLqxlWh3ngh2xPjks=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Fri, 12 Mar
 2021 22:47:53 +0800 (GMT+08:00)
X-Originating-IP: [114.214.251.230]
Date:   Fri, 12 Mar 2021 22:47:53 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   lyl2019@mail.ustc.edu.cn
To:     "Tom Parkin" <tparkin@katalix.com>
Cc:     paulus@samba.org, davem@davemloft.net, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [BUG] net/ppp: A use after free in ppp_unregister_channe
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20190610(cb3344cf) Copyright (c) 2002-2021 www.mailtech.cn ustc-xl
In-Reply-To: <20210312101258.GA4951@katalix.com>
References: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
 <20210312101258.GA4951@katalix.com>
X-SendMailWithSms: false
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2ad7aaa2.fcad.17826e87afb.Coremail.lyl2019@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygBXXDwZf0tg0AcVAA--.2W
X-CM-SenderInfo: ho1ojiyrz6zt1loo32lwfovvfxof0/1tbiAQoSBlQhn5CimQABsf
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tDQo+IOWPkeS7tuS6ujogIlRvbSBQYXJraW4i
IDx0cGFya2luQGthdGFsaXguY29tPg0KPiDlj5HpgIHml7bpl7Q6IDIwMjEtMDMtMTIgMTg6MTI6
NTggKOaYn+acn+S6lCkNCj4g5pS25Lu25Lq6OiBseWwyMDE5QG1haWwudXN0Yy5lZHUuY24NCj4g
5oqE6YCBOiBwYXVsdXNAc2FtYmEub3JnLCBkYXZlbUBkYXZlbWxvZnQubmV0LCBsaW51eC1wcHBA
dmdlci5rZXJuZWwub3JnLCBuZXRkZXZAdmdlci5rZXJuZWwub3JnLCBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnDQo+IOS4u+mimDogUmU6IFtCVUddIG5ldC9wcHA6IEEgdXNlIGFmdGVyIGZy
ZWUgaW4gcHBwX3VucmVnaXN0ZXJfY2hhbm5lDQo+IA0KPiBUaGFua3MgZm9yIHRoZSByZXBvcnQh
DQo+IA0KPiBPbiAgVGh1LCBNYXIgMTEsIDIwMjEgYXQgMjA6MzQ6NDQgKzA4MDAsIGx5bDIwMTlA
bWFpbC51c3RjLmVkdS5jbiB3cm90ZToNCj4gPiBGaWxlOiBkcml2ZXJzL25ldC9wcHAvcHBwX2dl
bmVyaWMuYw0KPiA+IA0KPiA+IEluIHBwcF91bnJlZ2lzdGVyX2NoYW5uZWwsIHBjaCBjb3VsZCBi
ZSBmcmVlZCBpbiBwcHBfdW5icmlkZ2VfY2hhbm5lbHMoKQ0KPiA+IGJ1dCBhZnRlciB0aGF0IHBj
aCBpcyBzdGlsbCBpbiB1c2UuIEluc2lkZSB0aGUgZnVuY3Rpb24gcHBwX3VuYnJpZGdlX2NoYW5u
ZWxzLA0KPiA+IGlmICJwY2hiYiA9PSBwY2giIGlzIHRydWUgYW5kIHRoZW4gcGNoIHdpbGwgYmUg
ZnJlZWQuDQo+IA0KPiBEbyB5b3UgaGF2ZSBhIHdheSB0byByZXByb2R1Y2UgYSB1c2UtYWZ0ZXIt
ZnJlZSBzY2VuYXJpbz8NCj4gDQo+IEZyb20gc3RhdGljIGFuYWx5c2lzIEknbSBub3Qgc3VyZSBo
b3cgcGNoIHdvdWxkIGJlIGZyZWVkIGluDQo+IHBwcF91bmJyaWRnZV9jaGFubmVscyB3aGVuIGNh
bGxlZCB2aWEuIHBwcF91bnJlZ2lzdGVyX2NoYW5uZWwuDQo+IA0KPiBJbiB0aGVvcnkgKGF0IGxl
YXN0ISkgdGhlIGNhbGxlciBvZiBwcHBfcmVnaXN0ZXJfbmV0X2NoYW5uZWwgaG9sZHMgDQo+IGEg
cmVmZXJlbmNlIG9uIHN0cnVjdCBjaGFubmVsIHdoaWNoIHBwcF91bnJlZ2lzdGVyX2NoYW5uZWwg
ZHJvcHMuDQo+IA0KPiBFYWNoIGNoYW5uZWwgaW4gYSBicmlkZ2VkIHBhaXIgaG9sZHMgYSByZWZl
cmVuY2Ugb24gdGhlIG90aGVyLg0KPiANCj4gSGVuY2Ugb24gcmV0dXJuIGZyb20gcHBwX3VuYnJp
ZGdlX2NoYW5uZWxzLCB0aGUgY2hhbm5lbCBzaG91bGQgbm90IGhhdmUNCj4gYmVlbiBmcmVlZCAo
aW4gdGhpcyBjb2RlIHBhdGgpIGJlY2F1c2UgdGhlIHBwcF9yZWdpc3Rlcl9uZXRfY2hhbm5lbA0K
PiByZWZlcmVuY2UgaGFzIG5vdCB5ZXQgYmVlbiBkcm9wcGVkLg0KPiANCj4gTWF5YmUgdGhlcmUg
aXMgYW4gaXNzdWUgd2l0aCB0aGUgcmVmZXJlbmNlIGNvdW50aW5nIG9yIGEgcmFjZSBvZiBzb21l
DQo+IHNvcnQ/DQo+IA0KPiA+IEkgY2hlY2tlZCB0aGUgY29tbWl0IGhpc3RvcnkgYW5kIGZvdW5k
IHRoYXQgdGhpcyBwcm9ibGVtIGlzIGludHJvZHVjZWQgZnJvbQ0KPiA+IDRjZjQ3NmNlZDQ1ZDcg
KCJwcHA6IGFkZCBQUFBJT0NCUklER0VDSEFOIGFuZCBQUFBJT0NVTkJSSURHRUNIQU4gaW9jdGxz
IikuDQo+ID4gDQo+ID4gSSBoYXZlIG5vIGlkZWEgYWJvdXQgaG93IHRvIGdlbmVyYXRlIGEgc3Vp
dGFibGUgcGF0Y2gsIHNvcnJ5Lg0KDQpUaGlzIGlzc3VlIHdhcyByZXBvcnRlZCBieSBhIHBhdGgt
c2Vuc2l0aXZlIHN0YXRpYyBhbmFseXplciBkZXZlbG9wZWQgYnkgb3VyIExhYiwNCnRodXMgaSBo
YXZlIG5vdCBhIGNyYXNoIG9yIGJ1ZyBsb2cuDQoNCkFzIHRoZSByZXR1cm4gdHlwZSBvZiBwcHBf
dW5icmlkZ2VfY2hhbm5lbHMoKSBpcyBhIGludCwgY2FuIHdlIHJldHVybiBhIHZhbHVlIHRvDQpp
bmZvcm0gY2FsbGVyIHRoYXQgdGhlIGNoYW5uZWwgaXMgZnJlZWQ/DQoNCg==
