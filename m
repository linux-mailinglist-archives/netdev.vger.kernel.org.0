Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178102E8B9B
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 11:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbhACKEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 05:04:55 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:26130 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbhACKEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 05:04:54 -0500
Received: by ajax-webmail-mail-app2 (Coremail) ; Sun, 3 Jan 2021 18:03:47
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.85.18]
Date:   Sun, 3 Jan 2021 18:03:47 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Paul Menzel" <pmenzel@molgen.mpg.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kjlu@umn.edu
Subject: Re: Re: [Intel-wired-lan] [PATCH] net: ixgbe: Fix memleak in
 ixgbe_configure_clsu32
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20200917(3e19599d)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <aefe9de0-83b4-81b8-5d5b-674cb8ea97e8@molgen.mpg.de>
References: <20210103080843.25914-1-dinghao.liu@zju.edu.cn>
 <aefe9de0-83b4-81b8-5d5b-674cb8ea97e8@molgen.mpg.de>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6d39129d.17f75.176c7b3f11b.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgCHj+uDlvFfXhRSAA--.13514W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgQOBlZdtRzi2AAAsW
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBEZWFyIERpbmdoYW8sCj4gCj4gCj4gQW0gMDMuMDEuMjEgdW0gMDk6MDggc2NocmllYiBEaW5n
aGFvIExpdToKPiA+IFdoZW4gaXhnYmVfZmRpcl93cml0ZV9wZXJmZWN0X2ZpbHRlcl84MjU5OSgp
IGZhaWxzLAo+ID4gaW5wdXQgYWxsb2NhdGVkIGJ5IGt6YWxsb2MoKSBoYXMgbm90IGJlZW4gZnJl
ZWQsCj4gPiB3aGljaCBsZWFkcyB0byBtZW1sZWFrLgo+IAo+IE5pY2UgZmluZC4gVGhhbmsgeW91
IGZvciB5b3VyIHBhdGNoZXMuIE91dCBvZiBjdXJpb3NpdHksIGRvIHlvdSB1c2UgYW4gCj4gYW5h
bHlzaXMgdG9vbCB0byBmaW5kIHRoZXNlIGlzc3Vlcz8KPiAKClllcywgdGhlc2UgYnVncyBhcmUg
c3VnZ2VzdGVkIGJ5IG15IHN0YXRpYyBhbmFseXNpcyB0b29sLiAKCj4gPiBTaWduZWQtb2ZmLWJ5
OiBEaW5naGFvIExpdSA8ZGluZ2hhby5saXVAemp1LmVkdS5jbj4KPiA+IC0tLQo+ID4gICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9tYWluLmMgfCA2ICsrKystLQo+ID4g
ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+ID4gCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFp
bi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jCj4gPiBp
bmRleCAzOTNkMWMyY2Q4NTMuLmU5YzJkMjhlZmM4MSAxMDA2NDQKPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21haW4uYwo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jCj4gPiBAQCAtOTU4Miw4ICs5NTgy
LDEwIEBAIHN0YXRpYyBpbnQgaXhnYmVfY29uZmlndXJlX2Nsc3UzMihzdHJ1Y3QgaXhnYmVfYWRh
cHRlciAqYWRhcHRlciwKPiA+ICAgCWl4Z2JlX2F0cl9jb21wdXRlX3BlcmZlY3RfaGFzaF84MjU5
OSgmaW5wdXQtPmZpbHRlciwgbWFzayk7Cj4gPiAgIAllcnIgPSBpeGdiZV9mZGlyX3dyaXRlX3Bl
cmZlY3RfZmlsdGVyXzgyNTk5KGh3LCAmaW5wdXQtPmZpbHRlciwKPiA+ICAgCQkJCQkJICAgIGlu
cHV0LT5zd19pZHgsIHF1ZXVlKTsKPiA+IC0JaWYgKCFlcnIpCj4gPiAtCQlpeGdiZV91cGRhdGVf
ZXRodG9vbF9mZGlyX2VudHJ5KGFkYXB0ZXIsIGlucHV0LCBpbnB1dC0+c3dfaWR4KTsKPiA+ICsJ
aWYgKGVycikKPiA+ICsJCWdvdG8gZXJyX291dF93X2xvY2s7Cj4gPiArCj4gPiArCWl4Z2JlX3Vw
ZGF0ZV9ldGh0b29sX2ZkaXJfZW50cnkoYWRhcHRlciwgaW5wdXQsIGlucHV0LT5zd19pZHgpOwo+
ID4gICAJc3Bpbl91bmxvY2soJmFkYXB0ZXItPmZkaXJfcGVyZmVjdF9sb2NrKTsKPiA+ICAgCj4g
PiAgIAlpZiAoKHVodGlkICE9IDB4ODAwKSAmJiAoYWRhcHRlci0+anVtcF90YWJsZXNbdWh0aWRd
KSkKPiAKPiBSZXZpZXdlZC1ieTogUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9sZ2VuLm1wZy5kZT4K
PiAKPiBJIHdvbmRlciwgaW4gdGhlIG5vbi1lcnJvciBjYXNlLCBob3cgYGlucHV0YCBhbmQgYGp1
bXBgIGFyZSBmcmVlZC4KPiAKCkknbSBub3Qgc3VyZSBpZiBrZnJlZShqdW1wKSB3aWxsIGludHJv
ZHVjZSBidWcuIGp1bXAgaXMgYWxsb2NhdGVkIGluIGEgZm9yIApsb29wIGFuZCBoYXMgYmVlbiBw
YXNzZWQgdG8gYWRhcHRlci0+anVtcF90YWJsZXMuIGlucHV0IGFuZCBtYXNrIGhhdmUgbmV3CmRl
ZmluaXRpb25zIChremFsbG9jKSBhZnRlciB0aGlzIGxvb3AsIGl0J3MgcmVhc29uYWJsZSB0byBm
cmVlIHRoZW0gb24gZmFpbHVyZS4KQnV0IGp1bXAgaXMgZGlmZmVyZW50LiBNYXliZSB3ZSBzaG91
bGQgbm90IGZyZWUganVtcCBhZnRlciB0aGUgbG9vcD8KCj4gT2xkIGNvZGU6Cj4gCj4gPiAgICAg
ICAgIGlmICghZXJyKQo+ID4gICAgICAgICAgICAgICAgIGl4Z2JlX3VwZGF0ZV9ldGh0b29sX2Zk
aXJfZW50cnkoYWRhcHRlciwgaW5wdXQsIGlucHV0LT5zd19pZHgpOwo+ID4gICAgICAgICBzcGlu
X3VubG9jaygmYWRhcHRlci0+ZmRpcl9wZXJmZWN0X2xvY2spOwo+ID4gCj4gPiAgICAgICAgIGlm
ICgodWh0aWQgIT0gMHg4MDApICYmIChhZGFwdGVyLT5qdW1wX3RhYmxlc1t1aHRpZF0pKQo+ID4g
ICAgICAgICAgICAgICAgIHNldF9iaXQobG9jIC0gMSwgKGFkYXB0ZXItPmp1bXBfdGFibGVzW3Vo
dGlkXSktPmNoaWxkX2xvY19tYXApOwo+ID4gCj4gPiAgICAgICAgIGtmcmVlKG1hc2spOwo+ID4g
ICAgICAgICByZXR1cm4gZXJyOwo+IAo+IFNob3VsZCB0aGVzZSB0d28gbGluZXMgYmUgcmVwbGFj
ZWQgd2l0aCBgZ290byBlcnJfb3V0YD8gKFRob3VnaCB0aGUgbmFtZSAKPiBpcyBjb25mdXNpbmcg
dGhlbiwgYXMgaXTigJlzIHRoZSBub24tZXJyb3IgY2FzZS4pCj4gCgpUaGlzIGFsc28gbWFrZXMg
bWUgY29uZnVzZWQuIEl0IHNlZW1zIHRoYXQgdGhlIGNoZWNrIGFnYWluc3QgdW50aWVkIGlzIG5v
dCBlcnJvcgpoYW5kbGluZyBjb2RlLCBidXQgdGhlcmUgaXMgYSBrZnJlZShtYXNrKSBhZnRlciBp
dC4gRnJlZWluZyBhbGxvY2F0ZWQgZGF0YSBvbgpzdWNjZXNzIGlzIG5vdCByZWFzb25hYmxlLiAK
ClJlZ2FyZHMsCkRpbmdoYW8KCj4gPiBlcnJfb3V0X3dfbG9jazoKPiA+ICAgICAgICAgc3Bpbl91
bmxvY2soJmFkYXB0ZXItPmZkaXJfcGVyZmVjdF9sb2NrKTsKPiA+IGVycl9vdXQ6Cj4gPiAgICAg
ICAgIGtmcmVlKG1hc2spOwo+ID4gZnJlZV9pbnB1dDoKPiA+ICAgICAgICAga2ZyZWUoaW5wdXQp
Owo+ID4gZnJlZV9qdW1wOgo+ID4gICAgICAgICBrZnJlZShqdW1wKTsKPiA+ICAgICAgICAgcmV0
dXJuIGVycjsKPiA+IH0KPiAKPiBLaW5kIHJlZ2FyZHMsCj4gCj4gUGF1bAo=
