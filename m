Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA7D5E766F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiIWJID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIWJIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:08:02 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C4C212873F;
        Fri, 23 Sep 2022 02:07:59 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Fri, 23 Sep 2022 17:07:51
 +0800 (GMT+08:00)
X-Originating-IP: [10.162.98.155]
Date:   Fri, 23 Sep 2022 17:07:51 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de
Subject: Re: [PATCH] mISDN: fix use-after-free bugs in l1oip timer handlers
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220922063510.3d241df4@kernel.org>
References: <20220920115716.125741-1-duoming@zju.edu.cn>
 <20220922063510.3d241df4@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <748522b6.ec147.183699a6dfb.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgCXnP1ndy1jGriGBg--.14911W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAggCAVZdtbnHCAAAsB
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

SGVsbG8sCgpPbiBUaHUsIDIyIFNlcCAyMDIyIDA2OjM1OjEwIC0wNzAwIEpha3ViIEtpY2luc2tp
IHdyb3RlOgoKPiBPbiBUdWUsIDIwIFNlcCAyMDIyIDE5OjU3OjE2ICswODAwIER1b21pbmcgWmhv
dSB3cm90ZToKPiA+IC0JaWYgKHRpbWVyX3BlbmRpbmcoJmhjLT5rZWVwX3RsKSkKPiA+IC0JCWRl
bF90aW1lcigmaGMtPmtlZXBfdGwpOwo+ID4gKwlkZWxfdGltZXJfc3luYygmaGMtPmtlZXBfdGwp
Owo+ID4gIAo+ID4gLQlpZiAodGltZXJfcGVuZGluZygmaGMtPnRpbWVvdXRfdGwpKQo+ID4gLQkJ
ZGVsX3RpbWVyKCZoYy0+dGltZW91dF90bCk7Cj4gPiArCWRlbF90aW1lcl9zeW5jKCZoYy0+dGlt
ZW91dF90bCk7Cj4gPiAgCj4gPiAgCWNhbmNlbF93b3JrX3N5bmMoJmhjLT53b3JrcSk7Cj4gCj4g
VGhlcmUgbmVlZHMgdG8gYmUgc29tZSBtb3JlIGNsZXZlcm5lc3MgaGVyZS4KPiBoYy0+d29ya3Eg
YW5kIGhjLT5zb2NrZXRfdGhyZWFkIGNhbiBraWNrIHRob3NlIHRpbWVycyByaWdodCBiYWNrIGlu
LgoKSW4gb3JkZXIgdG8gc3RvcCBoYy0+a2VlcF90bCB0aW1lciwgSSB0aGluayBhZGRpbmcgZGVs
X3RpbWVyX3N5bmMoJmhjLT5rZWVwX3RsKQphbmQgY2FuY2VsX3dvcmtfc3luYygmaGMtPndvcmtx
KSBhZ2FpbiBiZWhpbmQgY2FuY2VsX3dvcmtfc3luYygmaGMtPndvcmtxKSBhbmQKbW92ZSB0aGUg
ZGVsX3RpbWVyX3N5bmMoJmhjLT50aW1lb3V0X3RsKSBiZWhpbmQgbDFvaXBfc29ja2V0X2Nsb3Nl
KGhjKSBpcyBhCmJldHRlciBzb2x1dGlvbi4gVGhlIGRldGFpbCBpcyBzaG93biBiZWxvdzoKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL2lzZG4vbUlTRE4vbDFvaXBfY29yZS5jIGIvZHJpdmVycy9pc2Ru
L21JU0ROL2wxb2lwX2NvcmUuYwppbmRleCAyYzQwNDEyNDY2ZS4uN2I4OWQ5OGE3ODEgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvaXNkbi9tSVNETi9sMW9pcF9jb3JlLmMKKysrIGIvZHJpdmVycy9pc2Ru
L21JU0ROL2wxb2lwX2NvcmUuYwpAQCAtMTIzMiwxNyArMTIzMiwxNiBAQCByZWxlYXNlX2NhcmQo
c3RydWN0IGwxb2lwICpoYykKIHsKICAgICAgICBpbnQgICAgIGNoOwoKLSAgICAgICBpZiAodGlt
ZXJfcGVuZGluZygmaGMtPmtlZXBfdGwpKQotICAgICAgICAgICAgICAgZGVsX3RpbWVyKCZoYy0+
a2VlcF90bCk7Ci0KLSAgICAgICBpZiAodGltZXJfcGVuZGluZygmaGMtPnRpbWVvdXRfdGwpKQot
ICAgICAgICAgICAgICAgZGVsX3RpbWVyKCZoYy0+dGltZW91dF90bCk7Ci0KKyAgICAgICBkZWxf
dGltZXJfc3luYygmaGMtPmtlZXBfdGwpOworICAgICAgIGNhbmNlbF93b3JrX3N5bmMoJmhjLT53
b3JrcSk7CisgICAgICAgZGVsX3RpbWVyX3N5bmMoJmhjLT5rZWVwX3RsKTsKICAgICAgICBjYW5j
ZWxfd29ya19zeW5jKCZoYy0+d29ya3EpOwoKICAgICAgICBpZiAoaGMtPnNvY2tldF90aHJlYWQp
CiAgICAgICAgICAgICAgICBsMW9pcF9zb2NrZXRfY2xvc2UoaGMpOwoKKyAgICAgICBkZWxfdGlt
ZXJfc3luYygmaGMtPnRpbWVvdXRfdGwpOworCiAgICAgICAgaWYgKGhjLT5yZWdpc3RlcmVkICYm
IGhjLT5jaGFuW2hjLT5kX2lkeF0uZGNoKQogICAgICAgICAgICAgICAgbUlTRE5fdW5yZWdpc3Rl
cl9kZXZpY2UoJmhjLT5jaGFuW2hjLT5kX2lkeF0uZGNoLT5kZXYpOwogICAgICAgIGZvciAoY2gg
PSAwOyBjaCA8IDEyODsgY2grKykgewoKVGhlIGhjLT53b3JrcSBpcyBzY2hlZHVsZWQgaW4ga2Vl
cF90bCB0aW1lcjoKCnN0YXRpYyB2b2lkCmwxb2lwX2tlZXBhbGl2ZShzdHJ1Y3QgdGltZXJfbGlz
dCAqdCkKewoJc3RydWN0IGwxb2lwICpoYyA9IGZyb21fdGltZXIoaGMsIHQsIGtlZXBfdGwpOwoK
CXNjaGVkdWxlX3dvcmsoJmhjLT53b3JrcSk7Cn0KClNvIHdlIHNob3VsZCB1c2UgZGVsX3RpbWVy
X3N5bmMoKSB0byBzdG9wIHRoZSB0aW1lcnMgYW5kIHVzZQpjYW5jZWxfd29ya19zeW5jKCkgdG8g
c3RvcCB0aGUgaGMtPndvcmtxLgoKSWYgdGhlIGhjLT53b3JrcSBoYXMgY29tcGxldGVkLCB0aGUg
aGMtPmtlZXBfdGwuZXhwaXJlcyBpcyBzZXR0ZWQgdG8KamlmZmllcyArIEwxT0lQX0tFRVBBTElW
RSAqIEhaIGFuZCB0aGUga2VlcF90bCB3aWxsIHJlc3RhcnQuIFRoZSBkZXRhaWwKaXMgc2hvd24g
YmVsb3c6CgpzdGF0aWMgaW50Cmwxb2lwX3NvY2tldF9zZW5kKHN0cnVjdCBsMW9pcCAqaGMsIHU4
IGxvY2FsY29kZWMsIHU4IGNoYW5uZWwsIHUzMiBjaGFubWFzaywKCQkgIHUxNiB0aW1lYmFzZSwg
dTggKmJ1ZiwgaW50IGxlbikKewogICAgICAgIC4uLi4KCgkvKiByZXN0YXJ0IHRpbWVyICovCglp
ZiAodGltZV9iZWZvcmUoaGMtPmtlZXBfdGwuZXhwaXJlcywgamlmZmllcyArIDUgKiBIWikpCgkJ
bW9kX3RpbWVyKCZoYy0+a2VlcF90bCwgamlmZmllcyArIEwxT0lQX0tFRVBBTElWRSAqIEhaKTsK
CWVsc2UKCQloYy0+a2VlcF90bC5leHBpcmVzID0gamlmZmllcyArIEwxT0lQX0tFRVBBTElWRSAq
IEhaOwogICAgICAgIC4uLgp9CgpTbyB3ZSBuZWVkIGFkZCBkZWxfdGltZXJfc3luYygmaGMtPmtl
ZXBfdGwpIGFnYWluIGFmdGVyIGNhbmNlbF93b3JrX3N5bmMoJmhjLT53b3JrcSkKdG8gc3RvcCBo
Yy0+a2VlcF90MSB0aW1lci4gVGhlIGhjLT53b3JrcSBjb3VsZCBhbHNvIGJlIHJlc2NoZWR1bGVk
LCBidXQgdGhlIGtlZXBfdGwgCnRpbWVyIHdpbGwgbm90IGJlIHJlc3RhcnRlZCBhZ2Fpbi4gQmVj
YXVzZSB0aGUgaGMtPmtlZXBfdGwuZXhwaXJlcyBlcXVhbHMgdG8gCkwxT0lQX0tFRVBBTElWRSAq
IEhaIHRoYXQgaXMgbGFyZ2VyIHRoYW4gamlmZmllcyArIDUgKiBIWi4gCgpGaW5hbGx5LCB3ZSB1
c2UgY2FuY2VsX3dvcmtfc3luYygpIHRvIGNhbmNlbCB0aGUgaGMtPndvcmtxLiBOb3csIEJvdGgg
dGhlIGhjLT53b3JrcSAKYW5kIGhjLT5rZWVwX3RsIGNvdWxkIGJlIHN0b3BwZWQuCgpJbiBvcmRl
ciB0byBzdG9wIHRpbWVvdXRfdGwgdGltZXIsIHdlIG1vdmUgZGVsX3RpbWVyX3N5bmMoJmhjLT50
aW1lb3V0X3RsKSBiZWhpbmQKbDFvaXBfc29ja2V0X2Nsb3NlKCkuIEJlY2F1c2UgdGhlIGhjLT5z
b2NrZXRfdGhyZWFkIGNvdWxkIHN0YXJ0IHRoZSB0aW1lb3V0X3RsIHRpbWVyLgoKQmVzdCByZWdh
cmRzLApEdW9taW5nIFpob3U=
