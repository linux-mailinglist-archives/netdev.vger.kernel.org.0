Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878D463CE2C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 05:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiK3ECE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 23:02:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiK3ECB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 23:02:01 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E81486A77D;
        Tue, 29 Nov 2022 20:01:57 -0800 (PST)
Received: by ajax-webmail-mail-app3 (Coremail) ; Wed, 30 Nov 2022 12:01:41
 +0800 (GMT+08:00)
X-Originating-IP: [10.162.98.155]
Date:   Wed, 30 Nov 2022 12:01:41 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "David Ahern" <dsahern@kernel.org>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: Add a gfp_t parameter in ip_fib_metrics_init
 to support atomic context
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <a37f9c82-9f25-c5ba-f941-1cedf8c10187@kernel.org>
References: <20221129055317.53788-1-duoming@zju.edu.cn>
 <a37f9c82-9f25-c5ba-f941-1cedf8c10187@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <27dfa798.18d8b.184c6b28dcc.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgD3_6ul1YZjKXbrCQ--.671W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgQJAVZdtcpP+AAnsq
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

SGVsbG8sCgpPbiBUdWUsIDI5IE5vdiAyMDIyIDA5OjMzOjQ1IC0wNzAwIERhdmlkIEFoZXJuIHdy
b3RlOgoKPiBPbiAxMS8yOC8yMiAxMDo1MyBQTSwgRHVvbWluZyBaaG91IHdyb3RlOgo+ID4gVGhl
IGlwX2ZpYl9tZXRyaWNzX2luaXQoKSBkbyBub3Qgc3VwcG9ydCBhdG9taWMgY29udGV4dCwgYmVj
YXVzZSBpdAo+ID4gY2FsbHMgImt6YWxsb2MoLi4uLCBHRlBfS0VSTkVMKSIuIFdoZW4gaXBfZmli
X21ldHJpY3NfaW5pdCgpIGlzIHVzZWQKPiA+IGluIGF0b21pYyBjb250ZXh0LCB0aGUgc2xlZXAt
aW4tYXRvbWljLWNvbnRleHQgYnVnIHdpbGwgaGFwcGVuLgo+IAo+IERpZCB5b3UgYWN0dWFsbHkg
aGl0IHRoaXMgc2xlZXAtaW4tYXRvbWljLWNvbnRleHQgYnVnIG9yIGlzIGl0IHRoZW9yeQo+IGJh
c2VkIG9uIGNvZGUgYW5hbHlzaXM/CgpUaGFuayB5b3VyIGZvciB5b3VyIHJlcGx5IGFuZCBzdWdn
ZXN0aW9ucy4gVGhpcyBpcyBiYXNlZCBvbiBjb2RlIGFuYWx5c2lzLgoKPiA+IEZvciBleGFtcGxl
LCB0aGUgbmVpZ2hfcHJveHlfcHJvY2VzcygpIGlzIGEgdGltZXIgaGFuZGxlciB0aGF0IGlzCj4g
PiB1c2VkIHRvIHByb2Nlc3MgdGhlIHByb3h5IHJlcXVlc3QgdGhhdCBpcyB0aW1lb3V0LiBCdXQg
aXQgY291bGQgY2FsbAo+ID4gaXBfZmliX21ldHJpY3NfaW5pdCgpLiBBcyBhIHJlc3VsdCwgdGhl
IGNhbl9ibG9jayBmbGFnIGluIGlwdjZfYWRkX2FkZHIoKQo+ID4gYW5kIHRoZSBnZnBfZmxhZ3Mg
aW4gYWRkcmNvbmZfZjZpX2FsbG9jKCkgYW5kIGlwNl9yb3V0ZV9pbmZvX2NyZWF0ZSgpCj4gPiBh
cmUgdXNlbGVzcy4gVGhlIHByb2Nlc3MgaXMgc2hvd24gYmVsb3cuCj4gPiAKPiA+ICAgICAoYXRv
bWljIGNvbnRleHQpCj4gPiBuZWlnaF9wcm94eV9wcm9jZXNzKCkKPiA+ICAgcG5kaXNjX3JlZG8o
KQo+ID4gICAgIG5kaXNjX3JlY3ZfbnMoKQo+ID4gICAgICAgYWRkcmNvbmZfZGFkX2ZhaWx1cmUo
KQo+ID4gICAgICAgICBpcHY2X2FkZF9hZGRyKC4uLiwgYm9vbCBjYW5fYmxvY2spCj4gPiAgICAg
ICAgICAgYWRkcmNvbmZfZjZpX2FsbG9jKC4uLiwgZ2ZwX3QgZ2ZwX2ZsYWdzKQo+IAo+IAljZmcg
aGFzIGZjX214ID09IE5VTEwuCj4gCj4gPiAgICAgICAgICAgICBpcDZfcm91dGVfaW5mb19jcmVh
dGUoLi4uLCBnZnBfdCBnZnBfZmxhZ3MpCj4gCj4gCXJ0LT5maWI2X21ldHJpY3MgPSBpcF9maWJf
bWV0cmljc19pbml0KG5ldCwgY2ZnLT5mY19teCwgY2ZnLT5mY19teF9sZW4sCj4gZXh0YWNrKTsK
PiAKPiA+ICAgICAgICAgICAgICAgaXBfZmliX21ldHJpY3NfaW5pdCgpCj4gCj4gICAgICAgICBp
ZiAoIWZjX214KQo+ICAgICAgICAgICAgICAgICByZXR1cm4gKHN0cnVjdCBkc3RfbWV0cmljcyAq
KSZkc3RfZGVmYXVsdF9tZXRyaWNzOwoKSSB1bmRlcnN0YW5kIGl0LCB0aGFuayB5b3VyIGZvciB5
b3VyIGFkdmljZS4KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91
