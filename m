Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94866AD9E9
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjCGJKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjCGJK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:10:29 -0500
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB51110EC;
        Tue,  7 Mar 2023 01:10:27 -0800 (PST)
Received: from dzm91$hust.edu.cn ( [172.16.0.254] ) by ajax-webmail-app2
 (Coremail) ; Tue, 7 Mar 2023 17:09:29 +0800 (GMT+08:00)
X-Originating-IP: [172.16.0.254]
Date:   Tue, 7 Mar 2023 17:09:29 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5oWV5Yas5Lqu?= <dzm91@hust.edu.cn>
To:     "denis kirjanov" <dkirjanov@suse.de>
Cc:     "alexander aring" <alex.aring@gmail.com>,
        "stefan schmidt" <stefan@datenfreihafen.org>,
        "miquel raynal" <miquel.raynal@bootlin.com>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "jakub kicinski" <kuba@kernel.org>,
        "paolo abeni" <pabeni@redhat.com>,
        syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] net: ieee802154: fix a null pointer in
 nl802154_trigger_scan
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20220802(cbd923c5)
 Copyright (c) 2002-2023 www.mailtech.cn hust
In-Reply-To: <782a6f2d-84ae-3530-7e3c-07f31a4f303b@suse.de>
References: <20230307073004.74224-1-dzm91@hust.edu.cn>
 <782a6f2d-84ae-3530-7e3c-07f31a4f303b@suse.de>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <697a2a6.23479.186bb5537c5.Coremail.dzm91@hust.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: GQEQrACngepJ_wZkIMdbAQ--.25231W
X-CM-SenderInfo: asqsiiirqrkko6kx23oohg3hdfq/1tbiAQkDD17Em4N7ZAACsb
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CgoKPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tCj4g5Y+R5Lu25Lq6OiAiRGVuaXMgS2lyamFub3Yi
IDxka2lyamFub3ZAc3VzZS5kZT4KPiDlj5HpgIHml7bpl7Q6IDIwMjMtMDMtMDcgMTY6NDM6NDYg
KOaYn+acn+S6jCkKPiDmlLbku7bkuro6ICJEb25nbGlhbmcgTXUiIDxkem05MUBodXN0LmVkdS5j
bj4sICJBbGV4YW5kZXIgQXJpbmciIDxhbGV4LmFyaW5nQGdtYWlsLmNvbT4sICJTdGVmYW4gU2No
bWlkdCIgPHN0ZWZhbkBkYXRlbmZyZWloYWZlbi5vcmc+LCAiTWlxdWVsIFJheW5hbCIgPG1pcXVl
bC5yYXluYWxAYm9vdGxpbi5jb20+LCAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD4sICJFcmljIER1bWF6ZXQiIDxlZHVtYXpldEBnb29nbGUuY29tPiwgIkpha3ViIEtpY2lu
c2tpIiA8a3ViYUBrZXJuZWwub3JnPiwgIlBhb2xvIEFiZW5pIiA8cGFiZW5pQHJlZGhhdC5jb20+
Cj4g5oqE6YCBOiBzeXpib3QrYmQ4NWIzMTgxNjkxM2EzMmU0NzNAc3l6a2FsbGVyLmFwcHNwb3Rt
YWlsLmNvbSwgbGludXgtd3BhbkB2Z2VyLmtlcm5lbC5vcmcsIG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKPiDkuLvpopg6IFJlOiBbUEFUQ0hdIG5l
dDogaWVlZTgwMjE1NDogZml4IGEgbnVsbCBwb2ludGVyIGluIG5sODAyMTU0X3RyaWdnZXJfc2Nh
bgo+IAo+IAo+IAo+IE9uIDMvNy8yMyAxMDozMCwgRG9uZ2xpYW5nIE11IHdyb3RlOgo+ID4gVGhl
cmUgaXMgYSBudWxsIHBvaW50ZXIgZGVyZWZlcmVuY2UgaWYgTkw4MDIxNTRfQVRUUl9TQ0FOX1RZ
UEUgaXMKPiA+IG5vdCBzZXQgYnkgdGhlIHVzZXIuCj4gPiAKPiA+IEZpeCB0aGlzIGJ5IGFkZGlu
ZyBhIG51bGwgcG9pbnRlciBjaGVjay4KPiA+IAo+ID4gUmVwb3J0ZWQtYW5kLXRlc3RlZC1ieTog
c3l6Ym90K2JkODViMzE4MTY5MTNhMzJlNDczQHN5emthbGxlci5hcHBzcG90bWFpbC5jb20KPiA+
IFNpZ25lZC1vZmYtYnk6IERvbmdsaWFuZyBNdSA8ZHptOTFAaHVzdC5lZHUuY24+Cj4gCj4gUGxl
YXNlIGFkZCBhIEZpeGVzOiB0YWcgCgpJJ3ZlIHNlbnQgYSB2MiBwYXRjaC4gVGhhbmtzIGZvciB5
b3VyIHJlbWluZGVyLgoKPiAKPiA+IC0tLQo+ID4gIG5ldC9pZWVlODAyMTU0L25sODAyMTU0LmMg
fCAzICsrLQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKPiA+IAo+ID4gZGlmZiAtLWdpdCBhL25ldC9pZWVlODAyMTU0L25sODAyMTU0LmMgYi9uZXQv
aWVlZTgwMjE1NC9ubDgwMjE1NC5jCj4gPiBpbmRleCAyMjE1ZjU3NmVlMzcuLjFjZjAwY2ZmZDYz
ZiAxMDA2NDQKPiA+IC0tLSBhL25ldC9pZWVlODAyMTU0L25sODAyMTU0LmMKPiA+ICsrKyBiL25l
dC9pZWVlODAyMTU0L25sODAyMTU0LmMKPiA+IEBAIC0xNDEyLDcgKzE0MTIsOCBAQCBzdGF0aWMg
aW50IG5sODAyMTU0X3RyaWdnZXJfc2NhbihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgZ2Vu
bF9pbmZvICppbmZvKQo+ID4gIAkJcmV0dXJuIC1FT1BOT1RTVVBQOwo+ID4gIAl9Cj4gPiAgCj4g
PiAtCWlmICghbmxhX2dldF91OChpbmZvLT5hdHRyc1tOTDgwMjE1NF9BVFRSX1NDQU5fVFlQRV0p
KSB7Cj4gPiArCWlmICghaW5mby0+YXR0cnNbTkw4MDIxNTRfQVRUUl9TQ0FOX1RZUEVdIHx8Cj4g
PiArCSAgICAhbmxhX2dldF91OChpbmZvLT5hdHRyc1tOTDgwMjE1NF9BVFRSX1NDQU5fVFlQRV0p
KSB7Cj4gPiAgCQlOTF9TRVRfRVJSX01TRyhpbmZvLT5leHRhY2ssICJNYWxmb3JtZWQgcmVxdWVz
dCwgbWlzc2luZyBzY2FuIHR5cGUiKTsKPiA+ICAJCXJldHVybiAtRUlOVkFMOwo+ID4gIAl9Cgo=

