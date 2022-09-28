Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1619F5EDDC8
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbiI1Nfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiI1Nfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:35:41 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 977888C008;
        Wed, 28 Sep 2022 06:35:39 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Wed, 28 Sep 2022 21:35:36
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.100.195]
Date:   Wed, 28 Sep 2022 21:35:36 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Leon Romanovsky" <leon@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, kuba@kernel.org
Subject: Re: [PATCH V2] mISDN: fix use-after-free bugs in l1oip timer
 handlers
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YzQX4mVT18TT/uoe@unreal>
References: <20220923142514.58838-1-duoming@zju.edu.cn>
 <YzQX4mVT18TT/uoe@unreal>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <548ffa37.fbc8f.183844f5a63.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgA3OMyoTTRjabSsBg--.60407W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggHAVZdtbsnvwAAsR
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

SGVsbG8sCgpPbiBXZWQsIDI4IFNlcCAyMDIyIDEyOjQ2OjEwICswMzAwIExlb24gUm9tYW5vdnNr
eSB3cm90ZToKCj4gT24gRnJpLCBTZXAgMjMsIDIwMjIgYXQgMTA6MjU6MTRQTSArMDgwMCwgRHVv
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
Z2h0IGJhY2sgaW4uIFdlIHVzZSBkZWxfdGltZXJfc3luYygmaGMtPmtlZXBfdGwpCj4gPiBhbmQg
Y2FuY2VsX3dvcmtfc3luYygmaGMtPmtlZXBfdGwpIHR3aWNlIHRvIHN0b3Aga2VlcF90bCB0aW1l
cgo+ID4gYW5kIGhjLT53b3JrcS4gVGhlbiwgd2UgYWRkIGRlbF90aW1lcl9zeW5jKCZoYy0+dGlt
ZW91dF90bCkKPiA+IGJlaGluZCBsMW9pcF9zb2NrZXRfY2xvc2UoKSB0byBzdG9wIHRpbWVvdXRf
dGwgdGltZXIuCj4gPiAKPiA+IEZpeGVzOiAzNzEyYjQyZDRiMWIgKCJBZGQgbGF5ZXIxIG92ZXIg
SVAgc3VwcG9ydCIpCj4gPiBTaWduZWQtb2ZmLWJ5OiBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1
LmVkdS5jbj4KPiA+IC0tLQo+ID4gQ2hhbmdlcyBpbiB2MjoKPiA+ICAgLSBTb2x2ZSB0aGUgcHJv
YmxlbSB0aGF0IHRpbWVycyBjb3VsZCBiZSByZXN0YXJ0ZWQgYnkgb3RoZXIgdGhyZWFkcy4KPiA+
IAo+ID4gIGRyaXZlcnMvaXNkbi9tSVNETi9sMW9pcF9jb3JlLmMgfCAxMSArKysrKy0tLS0tLQo+
ID4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4gPiAK
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lzZG4vbUlTRE4vbDFvaXBfY29yZS5jIGIvZHJpdmVy
cy9pc2RuL21JU0ROL2wxb2lwX2NvcmUuYwo+ID4gaW5kZXggMmM0MDQxMjQ2NmUuLjdiODlkOThh
NzgxIDEwMDY0NAo+ID4gLS0tIGEvZHJpdmVycy9pc2RuL21JU0ROL2wxb2lwX2NvcmUuYwo+ID4g
KysrIGIvZHJpdmVycy9pc2RuL21JU0ROL2wxb2lwX2NvcmUuYwo+ID4gQEAgLTEyMzIsMTcgKzEy
MzIsMTYgQEAgcmVsZWFzZV9jYXJkKHN0cnVjdCBsMW9pcCAqaGMpCj4gPiAgewo+ID4gIAlpbnQJ
Y2g7Cj4gPiAgCj4gPiAtCWlmICh0aW1lcl9wZW5kaW5nKCZoYy0+a2VlcF90bCkpCj4gPiAtCQlk
ZWxfdGltZXIoJmhjLT5rZWVwX3RsKTsKPiA+IC0KPiA+IC0JaWYgKHRpbWVyX3BlbmRpbmcoJmhj
LT50aW1lb3V0X3RsKSkKPiA+IC0JCWRlbF90aW1lcigmaGMtPnRpbWVvdXRfdGwpOwo+ID4gLQo+
ID4gKwlkZWxfdGltZXJfc3luYygmaGMtPmtlZXBfdGwpOwo+ID4gKwljYW5jZWxfd29ya19zeW5j
KCZoYy0+d29ya3EpOwo+ID4gKwlkZWxfdGltZXJfc3luYygmaGMtPmtlZXBfdGwpOwo+ID4gIAlj
YW5jZWxfd29ya19zeW5jKCZoYy0+d29ya3EpOwo+IAo+IEl0IGlzIHJhY3ksIHRoZSBjYWxsIHR3
aWNlIHRvIGRlbF90aW1lcl9zeW5jIGFuZCBjYW5jZWxfd29ya19zeW5jCj4gZG9lc24ndCBzb2x2
ZSAidGhlIHByb2JsZW0gdGhhdCB0aW1lcnMgY291bGQgYmUgcmVzdGFydGVkIGJ5IG90aGVyCj4g
dGhyZWFkcy4iCgpUaGFuayB5b3UgZm9yIHlvdXIgcmVwbHkhIEkgd2lsbCBhZGQgYSBib29sIGZs
YWcgaW4gc3RydWN0IGwxb2lwIHRvIGp1ZGdlCndoZXRoZXIgdGhlIGNhcmQgaXMgcmVsZWFzZWQg
YW5kIGNoZWNrIHRoaXMgZmxhZyBpbiBvdGhlciB0aHJlYWRzLgoKQmVzdCByZWdhcmRzLApEdW9t
aW5nIFpob3UKCg==
