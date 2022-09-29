Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED045EF54A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 14:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiI2MXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 08:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiI2MX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 08:23:26 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F711149D12;
        Thu, 29 Sep 2022 05:23:23 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 29 Sep 2022 20:23:18
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.70.219]
Date:   Thu, 29 Sep 2022 20:23:18 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Leon Romanovsky" <leon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, kuba@kernel.org
Subject: Re: [PATCH V4] mISDN: fix use-after-free bugs in l1oip timer
 handlers
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YzVHn6Gtfog6RyNR@unreal>
References: <20220928133938.86143-1-duoming@zju.edu.cn>
 <YzVHn6Gtfog6RyNR@unreal>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <17ad6913.ff8e0.1838933840d.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgBXXP02jjVj_gyyBg--.21391W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgEIAVZdtbts6AACsJ
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

SGVsbG8sCgpPbiBUaHUsIDI5IFNlcCAyMDIyIDEwOjIyOjA3ICswMzAwIExlb24gUm9tYW5vdnNr
eSB3cm90ZToKCj4gT24gV2VkLCBTZXAgMjgsIDIwMjIgYXQgMDk6Mzk6MzhQTSArMDgwMCwgRHVv
bWluZyBaaG91IHdyb3RlOgo+ID4gVGhlIGwxb2lwX2NsZWFudXAoKSB0cmF2ZXJzZXMgdGhlIGwx
b2lwX2lsaXN0IGFuZCBjYWxscwo+ID4gcmVsZWFzZV9jYXJkKCkgdG8gY2xlYW51cCBtb2R1bGUg
YW5kIHN0YWNrLiBIb3dldmVyLAo+ID4gcmVsZWFzZV9jYXJkKCkgY2FsbHMgZGVsX3RpbWVyKCkg
dG8gZGVsZXRlIHRoZSB0aW1lcnMKPiA+IHN1Y2ggYXMga2VlcF90bCBhbmQgdGltZW91dF90bC4g
SWYgdGhlIHRpbWVyIGhhbmRsZXIgaXMKPiA+IHJ1bm5pbmcsIHRoZSBkZWxfdGltZXIoKSB3aWxs
IG5vdCBzdG9wIGl0IGFuZCByZXN1bHQgaW4KPiA+IFVBRiBidWdzLiBPbmUgb2YgdGhlIHByb2Nl
c3NlcyBpcyBzaG93biBiZWxvdzoKPiA+IAo+ID4gICAgIChjbGVhbnVwIHJvdXRpbmUpICAgICAg
ICAgIHwgICAgICAgICh0aW1lciBoYW5kbGVyKQo+ID4gcmVsZWFzZV9jYXJkKCkgICAgICAgICAg
ICAgICAgIHwgbDFvaXBfdGltZW91dCgpCj4gPiAgLi4uICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfAo+ID4gIGRlbF90aW1lcigpICAgICAgICAgICAgICAgICAgIHwgLi4uCj4gPiAgLi4uICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfAo+ID4gIGtmcmVlKGhjKSAvL0ZSRUUgICAgICAgICAg
ICAgIHwKPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IGhjLT50aW1lb3V0X29u
ID0gMCAvL1VTRQo+ID4gCj4gPiBGaXggYnkgY2FsbGluZyBkZWxfdGltZXJfc3luYygpIGluIHJl
bGVhc2VfY2FyZCgpLCB3aGljaAo+ID4gbWFrZXMgc3VyZSB0aGUgdGltZXIgaGFuZGxlcnMgaGF2
ZSBmaW5pc2hlZCBiZWZvcmUgdGhlCj4gPiByZXNvdXJjZXMsIHN1Y2ggYXMgbDFvaXAgYW5kIHNv
IG9uLCBoYXZlIGJlZW4gZGVhbGxvY2F0ZWQuCj4gPiAKPiA+IFdoYXQncyBtb3JlLCB0aGUgaGMt
PndvcmtxIGFuZCBoYy0+c29ja2V0X3RocmVhZCBjYW4ga2ljawo+ID4gdGhvc2UgdGltZXJzIHJp
Z2h0IGJhY2sgaW4uIFdlIGFkZCBhIGJvb2wgZmxhZyB0byBzaG93Cj4gPiBpZiBjYXJkIGlzIHJl
bGVhc2VkLiBUaGVuLCBjaGVjayB0aGlzIGZsYWcgaW4gaGMtPndvcmtxCj4gPiBhbmQgaGMtPnNv
Y2tldF90aHJlYWQuCj4gPiAKPiA+IEZpeGVzOiAzNzEyYjQyZDRiMWIgKCJBZGQgbGF5ZXIxIG92
ZXIgSVAgc3VwcG9ydCIpCj4gPiBTaWduZWQtb2ZmLWJ5OiBEdW9taW5nIFpob3UgPGR1b21pbmdA
emp1LmVkdS5jbj4KPiA+IC0tLQo+ID4gQ2hhbmdlcyBpbiB2NDoKPiA+ICAgLSBVc2UgYm9vbCBm
bGFnIHRvIGp1ZGdlIHdoZXRoZXIgY2FyZCBpcyByZWxlYXNlZC4KPiA+IAo+ID4gIGRyaXZlcnMv
aXNkbi9tSVNETi9sMW9pcC5oICAgICAgfCAgMSArCj4gPiAgZHJpdmVycy9pc2RuL21JU0ROL2wx
b2lwX2NvcmUuYyB8IDEzICsrKysrKystLS0tLS0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDggaW5z
ZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKPiAKPiBJdCBsb29rcyBsaWtlIGl0IGlzIG9rIG5v
dywgYnV0IHdob2xlIG1JU0ROIGNvZGUgZG9lc24ndCBsb29rIGhlYWx0aHksCj4gc28gaXQgaXMg
aGFyZCB0byBzYXkgZm9yIHN1cmUuCj4gCj4gQXJlIHlvdSBmaXhpbmcgcmVhbCBpc3N1ZSB0aGF0
IHlvdSBzYXcgaW4gZmllbGQ/CgpUaGFuayB5b3UgZm9yIHlvdXIgdGltZSBhbmQgcmVwbHkhIEkg
Zm91bmQgdGhpcyBpc3N1ZSB0aHJvdWdoIGEgCnN0YXRpYyBhbmFseXNpcyB0b29sIHdyb3RlbiBi
eSBteXNlbGYuCgo+IFRoYW5rcywKPiBSZXZpZXdlZC1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9u
cm9AbnZpZGlhLmNvbT4KClRoYW5rIHlvdSEKCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91
