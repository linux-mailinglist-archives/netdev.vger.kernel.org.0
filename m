Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6460753F2ED
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 02:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiFGAXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 20:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiFGAXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 20:23:02 -0400
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 9222537A9F;
        Mon,  6 Jun 2022 17:22:57 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 7 Jun 2022 08:22:36
 +0800 (GMT+08:00)
X-Originating-IP: [106.117.78.144]
Date:   Tue, 7 Jun 2022 08:22:36 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Brian Norris" <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        johannes@sipsolutions.net, gregkh@linuxfoundation.org,
        rafael@kernel.org
Subject: Re: [PATCH v5 2/2] mwifiex: fix sleep in atomic context bugs caused
 by dev_coredumpv
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <Yp5D7TRdNJ+bW1ud@google.com>
References: <cover.1654229964.git.duoming@zju.edu.cn>
 <54f886c2fce5948a8743b9de65d36ec3e8adfaf1.1654229964.git.duoming@zju.edu.cn>
 <Yp5D7TRdNJ+bW1ud@google.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <75b1682.54b44.1813b8abc1f.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDXQCBNmp5iXy1fAQ--.32949W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEOAVZdtaEmjAABs4
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBNb24sIDYgSnVuIDIwMjIgMTE6MTQ6MDUgLTA3MDAgQnJpYW4gd3JvdGU6Cgo+
IE9uIEZyaSwgSnVuIDAzLCAyMDIyIGF0IDAxOjA5OjM1UE0gKzA4MDAsIER1b21pbmcgWmhvdSB3
cm90ZToKPiA+IFRoZXJlIGFyZSBzbGVlcCBpbiBhdG9taWMgY29udGV4dCBidWdzIHdoZW4gdXBs
b2FkaW5nIGRldmljZSBkdW1wCj4gPiBkYXRhIGluIG13aWZpZXguIFRoZSByb290IGNhdXNlIGlz
IHRoYXQgZGV2X2NvcmVkdW1wdiBjb3VsZCBub3QKPiA+IGJlIHVzZWQgaW4gYXRvbWljIGNvbnRl
eHRzLCBiZWNhdXNlIGl0IGNhbGxzIGRldl9zZXRfbmFtZSB3aGljaAo+ID4gaW5jbHVkZSBvcGVy
YXRpb25zIHRoYXQgbWF5IHNsZWVwLiBUaGUgY2FsbCB0cmVlIHNob3dzIGV4ZWN1dGlvbgo+ID4g
cGF0aHMgdGhhdCBjb3VsZCBsZWFkIHRvIGJ1Z3M6Cj4gLi4uCj4gPiBGaXhlczogZjVlY2QwMmE4
YjIwICgibXdpZmlleDogZGV2aWNlIGR1bXAgc3VwcG9ydCBmb3IgdXNiIGludGVyZmFjZSIpCj4g
PiBTaWduZWQtb2ZmLWJ5OiBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4KPiA+IC0t
LQo+ID4gQ2hhbmdlcyBpbiB2NToKPiA+ICAgLSBVc2UgZGVsYXllZCB3b3JrIHRvIHJlcGxhY2Ug
dGltZXIuCj4gPiAKPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvaW5p
dC5jICAgICAgfCAxMCArKysrKystLS0tCj4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVs
bC9td2lmaWV4L21haW4uaCAgICAgIHwgIDIgKy0KPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9t
YXJ2ZWxsL213aWZpZXgvc3RhX2V2ZW50LmMgfCAgNiArKystLS0KPiA+ICAzIGZpbGVzIGNoYW5n
ZWQsIDEwIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCj4gCj4gTG9va3MgZ3JlYXQhIFRo
YW5rcyBmb3Igd29ya2luZyBvbiB0aGlzLgo+IAo+IFJldmlld2VkLWJ5OiBCcmlhbiBOb3JyaXMg
PGJyaWFubm9ycmlzQGNocm9taXVtLm9yZz4KPiAKPiBTb21lIHNtYWxsIG5pdHBpY2tzIGJlbG93
LCBidXQgdGhleSdyZSBkZWZpbml0ZWx5IG5vdCBjcml0aWNhbC4KClRoYW5rIHlvdSBmb3IgeW91
ciB0aW1lIGFuZCBhcHByb3ZhbCEKCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvbWFydmVsbC9td2lmaWV4L2luaXQuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwv
bXdpZmlleC9pbml0LmMKPiA+IGluZGV4IDg4YzcyZDE4MjdhLi4zNzEzZjNlMzIzZiAxMDA2NDQK
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9pbml0LmMKPiA+
ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9pbml0LmMKPiA+IEBA
IC02Myw5ICs2MywxMSBAQCBzdGF0aWMgdm9pZCB3YWtldXBfdGltZXJfZm4oc3RydWN0IHRpbWVy
X2xpc3QgKnQpCj4gPiAgCQlhZGFwdGVyLT5pZl9vcHMuY2FyZF9yZXNldChhZGFwdGVyKTsKPiA+
ICB9Cj4gPiAgCj4gPiAtc3RhdGljIHZvaWQgZndfZHVtcF90aW1lcl9mbihzdHJ1Y3QgdGltZXJf
bGlzdCAqdCkKPiA+ICtzdGF0aWMgdm9pZCBmd19kdW1wX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKQo+ID4gIHsKPiA+IC0Jc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlciA9IGZy
b21fdGltZXIoYWRhcHRlciwgdCwgZGV2ZHVtcF90aW1lcik7Cj4gPiArCXN0cnVjdCBtd2lmaWV4
X2FkYXB0ZXIgKmFkYXB0ZXIgPSBjb250YWluZXJfb2Yod29yaywKPiA+ICsJCQkJCXN0cnVjdCBt
d2lmaWV4X2FkYXB0ZXIsCj4gPiArCQkJCQlkZXZkdW1wX3dvcmsud29yayk7Cj4gCj4gU3VwZXIg
bml0cGlja3k6IHRoZSBoYW5naW5nIGluZGVudCBzdHlsZSBzZWVtcyBhIGJpdCBvZmYuIEkgdHlw
aWNhbGx5Cj4gc2VlIHBlb3BsZSB0cnkgdG8gYWxpZ24gdG8gdGhlIGZpcnN0IGNoYXJhY3RlciBh
ZnRlciB0aGUgcGFyZW50aGVzaXMsCj4gbGlrZToKPiAKPiAJc3RydWN0IG13aWZpZXhfYWRhcHRl
ciAqYWRhcHRlciA9IGNvbnRhaW5lcl9vZih3b3JrLAo+IAkJCQkJCSAgICAgICBzdHJ1Y3QgbXdp
ZmlleF9hZGFwdGVyLAo+IAkJCQkJCSAgICAgICBkZXZkdW1wX3dvcmsud29yayk7Cj4gCj4gSXQn
cyBub3QgYSBjbGVhcmx5LXNwZWNpZmllZCBzdHlsZSBydWxlIEkgdGhpbmssIHNvIEkgZGVmaW5p
dGVseQo+IHdvdWxkbid0IGluc2lzdC4KPiAKPiBPbiB0aGUgYnJpZ2h0IHNpZGU6IEkgdGhpbmsg
dGhlIGNsYW5nLWZvcm1hdCBydWxlcyAoaW4gLmNsYW5nLWZvcm1hdCkKPiBhcmUgZ2V0dGluZyBi
ZXR0ZXIsIHNvIG9uZSBjYW4gbWFrZSBzb21lIGZvcm1hdHRpbmcgZGVjaXNpb25zIHZpYSB0b29s
cwo+IGluc3RlYWQgb2Ygb3BpbmlvbiBhbmQgY2xvc2UgcmVhZGluZyEgVW5mb3J0dW5hdGVseSwg
d2UgcHJvYmFibHkgY2FuJ3QKPiBkbyB0aGF0IGV4dGVuc2l2ZWx5IGFuZCBhdXRvbWF0aWNhbGx5
LCBiZWNhdXNlIEkgZG91YnQgcGVvcGxlIHdpbGwgbG92ZQo+IGFsbCB0aGUgcmVmb3JtYXR0aW5n
IGJlY2F1c2Ugb2YgYWxsIHRoZSBleGlzdGluZyBpbmNvbnNpc3RlbnQgc3R5bGUuCj4gCj4gQW55
d2F5LCB0byBjdXQgdG8gdGhlIGNoYXNlOiBjbGFuZy1mb3JtYXQgY2hvb3NlcyBtb3ZpbmcgdG8g
YSBuZXcgbGluZToKPiAKPiAJc3RydWN0IG13aWZpZXhfYWRhcHRlciAqYWRhcHRlciA9Cj4gCQlj
b250YWluZXJfb2Yod29yaywgc3RydWN0IG13aWZpZXhfYWRhcHRlciwgZGV2ZHVtcF93b3JrLndv
cmspOwo+IAo+IE1vcmUgaW5mbyBpZiB5b3UncmUgaW50ZXJlc3RlZDoKPiBodHRwczovL3d3dy5r
ZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9wcm9jZXNzL2NsYW5nLWZvcm1hdC5odG1sCj4gCj4g
PiAgCj4gPiAgCW13aWZpZXhfdXBsb2FkX2RldmljZV9kdW1wKGFkYXB0ZXIpOwo+ID4gIH0KClRo
YW5rcyBmb3IgeW91ciBzdWdnZXN0aW9ucyEgSSB3aWxsIHVzZSBjbGFuZy1mb3JtYXQgdG8gYWRq
dXN0IHRoZSBmb3JtYXQuCgo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21h
cnZlbGwvbXdpZmlleC9tYWluLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZp
ZXgvbWFpbi5oCj4gPiBpbmRleCAzMzJkZDFjOGRiMy4uNjUzMGM2ZWUzMDggMTAwNjQ0Cj4gPiAt
LS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvbWFpbi5oCj4gPiArKysg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvbWFpbi5oCj4gPiBAQCAtMTA1
NSw3ICsxMDU1LDcgQEAgc3RydWN0IG13aWZpZXhfYWRhcHRlciB7Cj4gCj4gTml0cGljazogbWFp
bi5oIGlzIHByb2JhYmx5IG1pc3NpbmcgYSBsb3Qgb2YgI2luY2x1ZGVzLCBidXQgeW91IGNvdWxk
Cj4gcHJvYmFibHkgYWRkIDxsaW51eC93b3JrcXVldWUuaD4gd2hpbGUgeW91J3JlIGF0IGl0LgoK
SSB3aWxsIGFkZCA8bGludXgvd29ya3F1ZXVlLmg+IGluIG1haW4uaC4KCj4gCj4gPiAgCS8qIERl
dmljZSBkdW1wIGRhdGEvbGVuZ3RoICovCj4gPiAgCXZvaWQgKmRldmR1bXBfZGF0YTsKPiA+ICAJ
aW50IGRldmR1bXBfbGVuOwo+ID4gLQlzdHJ1Y3QgdGltZXJfbGlzdCBkZXZkdW1wX3RpbWVyOwo+
ID4gKwlzdHJ1Y3QgZGVsYXllZF93b3JrIGRldmR1bXBfd29yazsKPiA+ICAKPiA+ICAJYm9vbCBp
Z25vcmVfYnRjb2V4X2V2ZW50czsKPiA+ICB9OwoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3U=

