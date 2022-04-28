Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC6512C7A
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244956AbiD1HSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244936AbiD1HSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:18:31 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E42C972B2;
        Thu, 28 Apr 2022 00:15:15 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Thu, 28 Apr 2022 15:15:02
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.234.41]
Date:   Thu, 28 Apr 2022 15:15:02 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "Duoming Zhou" <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, alexander.deucher@amd.com,
        akpm@linux-foundation.org, broonie@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data
 race-able
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220427174548.2ae53b84@kernel.org>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: en_US
X-CM-TRANSID: by_KCgC3pcX3PmpioM+tAg--.58464W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUOElNG3GhBaQAAsT
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

SGVsbG8gSmFrdWIsCgphbmQgaGVsbG8gdGhlcmUgbWFpbnRhaW5lcnMsIHdoZW4gd2UgdHJpZWQg
dG8gZml4IHRoaXMgcmFjZSBwcm9ibGVtLCB3ZSBmb3VuZCBhbm90aGVyIHZlcnkgd2VpcmQgaXNz
dWUgYXMgYmVsb3cKCj4gCj4gWW91IGNhbid0IHVzZSBhIHNpbmdsZSBnbG9iYWwgdmFyaWFibGUs
IHRoZXJlIGNhbiBiZSBtYW55IGRldmljZXMgCj4gZWFjaCB3aXRoIHRoZWlyIG93biBsb2NrLgo+
IAo+IFBhb2xvIHN1Z2dlc3RlZCBhZGRpbmcgYSBsb2NrLCBpZiBzcGluIGxvY2sgZG9lc24ndCBm
aXQgdGhlIGJpbGwKPiB3aHkgbm90IGFkZCBhIG11dGV4PwoKVGhlIGxvY2sgcGF0Y2ggY2FuIGJl
IGFkZGVkIHRvIG5mY21ydmwgY29kZSBidXQgd2UgcHJlZmVyIHRvIGZpeCB0aGlzIGluIHRoZSBO
RkMgY29yZSBsYXllciBoZW5jZSBldmVyeSBvdGhlciBkcml2ZXIgdGhhdCBzdXBwb3J0cyB0aGUg
ZmlybXdhcmUgZG93bmxvYWRpbmcgdGFzayB3aWxsIGJlIGZyZWUgb2Ygc3VjaCBhIHByb2JsZW0u
CgpCdXQgd2hlbiB3ZSBhbmFseXplIHRoZSByYWNlIGJldHdlZW4gdGhlIG5ldGxpbmsgdGFza3Mg
YW5kIHRoZSBjbGVhbnVwIHJvdXRpbmUsIHdlIGZpbmQgc29tZSAqY29uZGl0aW9uIGNoZWNrcyog
ZmFpbCB0byBmdWxmaWxsIHRoZWlyIHJlc3BvbnNpYmlsaXR5LgoKRm9yIGV4YW1wbGUsIHdlIG9u
Y2UgdGhvdWdoIHRoYXQgdGhlIGRldmljZV9sb2NrICsgZGV2aWNlX2lzX3JlZ2lzdGVyZWQgY2hl
Y2sgY2FuIGhlbHAgdG8gZml4IHRoZSByYWNlIGFzIGJlbG93LgoKICBuZXRsaW5rIHRhc2sgICAg
ICAgICAgICAgIHwgIGNsZWFudXAgcm91dGluZQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
fApuZmNfZ2VubF9md19kb3dubG9hZCAgICAgICAgfCBuZmNfdW5yZWdpc3Rlcl9kZXZpY2UgCiAg
bmZjX2Z3X2Rvd25sb2FkICAgICAgICAgICB8ICAgZGV2aWNlX2RlbCAKICAgIGRldmljZV9sb2Nr
ICAgICAgICAgICAgIHwgICAgIGRldmljZV9sb2NrCiAgICAvLyB3YWl0IGxvY2sgICAgICAgICAg
ICB8ICAgICAgIGtvYmplY3RfZGVsCiAgICAvLyAuLi4gICAgICAgICAgICAgICAgICB8ICAgICAg
ICAgLi4uCiAgICBkZXZpY2VfaXNfcmVnaXN0ZXJlZCAgICB8ICAgICBkZXZpY2VfdW5sb2NrICAg
IAogICAgICByYyA9IC1FTk9ERVYgICAgICAgICAgfAoKSG93ZXZlciwgYnkgZHluYW1pYyBkZWJ1
Z2dpbmcgdGhpcyBpc3N1ZSwgd2UgZmluZCBvdXQgdGhhdCAqKmV2ZW4gYWZ0ZXIgdGhlIGRldmlj
ZV9kZWwqKiwgdGhlIGRldmljZV9pc19yZWdpc3RlcmVkIGNoZWNrIHN0aWxsIHJldHVybnMgVFJV
RSEKClRoaXMgaXMgYnkgbm8gbWVhbnMgbWF0Y2hpbmcgb3VyIGV4cGVjdGF0aW9ucyBhcyBvbmUg
b2Ygb3VyIHByZXZpb3VzIHBhdGNoIHJlbGllcyBvbiB0aGUgZGV2aWNlX2lzX3JlZ2lzdGVyZWQg
Y29kZS4KCi0+IHRoZSBwYXRjaDogM2UzYjVkZmNkMTZhICgiTkZDOiByZW9yZGVyIHRoZSBsb2dp
YyBpbiBuZmNfe3VuLH1yZWdpc3Rlcl9kZXZpY2UiKQoKVG8gZmluZCBvdXQgd2h5LCB3ZSBmaW5k
IG91dCB0aGUgZGV2aWNlX2lzX3JlZ2lzdGVyZWQgaXMgaW1wbGVtZW50ZWQgbGlrZSBiZWxvdzoK
CnN0YXRpYyBpbmxpbmUgaW50IGRldmljZV9pc19yZWdpc3RlcmVkKHN0cnVjdCBkZXZpY2UgKmRl
dikKewoJcmV0dXJuIGRldi0+a29iai5zdGF0ZV9pbl9zeXNmczsKfQoKQnkgZGVidWdnaW5nLCB3
ZSBmaW5kIG91dCBpbiBub3JtYWwgY2FzZSwgdGhpcyBrb2JqLnN0YXRlX2luX3N5c2ZzIHdpbGwg
YmUgY2xlYXIgb3V0IGxpa2UgYmVsb3cKClsjMF0gMHhmZmZmZmZmZjgxZjA3NDNhIOKGkiBfX2tv
YmplY3RfZGVsKGtvYmo9MHhmZmZmODg4MDA5Y2E3MDE4KQpbIzFdIDB4ZmZmZmZmZmY4MWYwNzg4
MiDihpIga29iamVjdF9kZWwoa29iaj0weGZmZmY4ODgwMDljYTcwMTgpClsjMl0gMHhmZmZmZmZm
ZjgxZjA3ODgyIOKGkiBrb2JqZWN0X2RlbChrb2JqPTB4ZmZmZjg4ODAwOWNhNzAxOCkKWyMzXSAw
eGZmZmZmZmZmODI3NzA4ZGIg4oaSIGRldmljZV9kZWwoZGV2PTB4ZmZmZjg4ODAwOWNhNzAxOCkK
WyM0XSAweGZmZmZmZmZmODM5NjQ5NmYg4oaSIG5mY191bnJlZ2lzdGVyX2RldmljZShkZXY9MHhm
ZmZmODg4MDA5Y2E3MDAwKQpbIzVdIDB4ZmZmZmZmZmY4Mzk4NTBhOSDihpIgbmNpX3VucmVnaXN0
ZXJfZGV2aWNlKG5kZXY9MHhmZmZmODg4MDA5Y2EzMDAwKQpbIzZdIDB4ZmZmZmZmZmY4MjgxMTMw
OCDihpIgbmZjbXJ2bF9uY2lfdW5yZWdpc3Rlcl9kZXYocHJpdj0weGZmZmY4ODgwMGM4MDVjMDAp
ClsjN10gMHhmZmZmZmZmZjgzOTkwYzRmIOKGkiBuY2lfdWFydF90dHlfY2xvc2UodHR5PTB4ZmZm
Zjg4ODAwYjQ1MDAwMCkKWyM4XSAweGZmZmZmZmZmODIwZjZiZDMg4oaSIHR0eV9sZGlzY19raWxs
KHR0eT0weGZmZmY4ODgwMGI0NTAwMDApClsjOV0gMHhmZmZmZmZmZjgyMGY3ZmIxIOKGkiB0dHlf
bGRpc2NfaGFuZ3VwKHR0eT0weGZmZmY4ODgwMGI0NTAwMDAsIHJlaW5pdD0weDApCgpUaGUgY2xl
YXIgb3V0IGlzIGluIGZ1bmN0aW9uIF9fa29iamVjdF9kZWwKCnN0YXRpYyB2b2lkIF9fa29iamVj
dF9kZWwoc3RydWN0IGtvYmplY3QgKmtvYmopCnsKICAgLy8gLi4uCgoJa29iai0+c3RhdGVfaW5f
c3lzZnMgPSAwOwoJa29ial9rc2V0X2xlYXZlKGtvYmopOwoJa29iai0+cGFyZW50ID0gTlVMTDsK
fQoKVGhlIHN0cnVjdHVyZSBvZiBkZXZpY2VfZGVsIGlzIGxpa2UgYmVsb3cKCnZvaWQgZGV2aWNl
X2RlbChzdHJ1Y3QgZGV2aWNlICpkZXYpCnsKCXN0cnVjdCBkZXZpY2UgKnBhcmVudCA9IGRldi0+
cGFyZW50OwoJc3RydWN0IGtvYmplY3QgKmdsdWVfZGlyID0gTlVMTDsKCXN0cnVjdCBjbGFzc19p
bnRlcmZhY2UgKmNsYXNzX2ludGY7Cgl1bnNpZ25lZCBpbnQgbm9pb19mbGFnOwoKCWRldmljZV9s
b2NrKGRldik7CglraWxsX2RldmljZShkZXYpOwoJZGV2aWNlX3VubG9jayhkZXYpOwogICAgICAg
IAogICAgICAgIC8vIC4uLgogICAgICAgIGtvYmplY3RfZGVsKCZkZXYtPmtvYmopOwoJY2xlYW51
cF9nbHVlX2RpcihkZXYsIGdsdWVfZGlyKTsKCW1lbWFsbG9jX25vaW9fcmVzdG9yZShub2lvX2Zs
YWcpOwoJcHV0X2RldmljZShwYXJlbnQpOwp9CgpJbiBhbm90aGVyIHdvcmQsIHRoZSBkZXZpY2Vf
ZGVsIC0+IGtvYmplY3RfZGVsIC0+IF9fa29iamVjdF9kZWwgaXMgbm90IHByb3RlY3RlZCBieSB0
aGUgZGV2aWNlX2xvY2suCgpUaGlzIG1lYW5zIHRoZSBkZXZpY2VfbG9jayArIGRldmljZV9pc19y
ZWdpc3RlcmVkIGlzIHN0aWxsIHByb25lIHRvIHRoZSBkYXRhIHJhY2UuIEFuZCB0aGlzIGlzIG5v
dCBqdXN0IHRoZSBwcm9ibGVtIHdpdGggZmlybXdhcmUgZG93bmxvYWRpbmcuIFRoZSBhbGwgcmVs
ZXZhbnQgbmV0bGluayB0YXNrcyB0aGF0IHVzZSB0aGUgZGV2aWNlX2xvY2sgKyBkZXZpY2VfaXNf
cmVnaXN0ZXJlZCBpcyBwb3NzaWJsZSB0byBiZSByYWNlZC4KClRvIHRoaXMgZW5kLCB3ZSB3aWxs
IGNvbWUgb3V0IHdpdGggdHdvIHBhdGNoZXMsIG9uZSBmb3IgZml4aW5nIHRoaXMgZGV2aWNlX2lz
X3JlZ2lzdGVyZWQgYnkgdXNpbmcgYW5vdGhlciBzdGF0dXMgdmFyaWFibGUgaW5zdGVhZC4gVGhl
IG90aGVyIGlzIHRoZSBwYXRjaCB0aGF0IHJlb3JkZXJzIHRoZSBjb2RlIGluIG5jaV91bnJlZ2lz
dGVyX2RldmljZS4KClRoYW5rcwpMaW4gTWEKCg==
