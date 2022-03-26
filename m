Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1727E4E7FBC
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 08:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiCZHQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 03:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiCZHQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 03:16:42 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A1F8BBF;
        Sat, 26 Mar 2022 00:15:03 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Sat, 26 Mar 2022 15:14:55
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.67.77]
Date:   Sat, 26 Mar 2022 15:14:55 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5ZGo5aSa5piO?= <duoming@zju.edu.cn>
To:     netdev@vger.kernel.org
Cc:     linux-x25@vger.kernel.org, linux-kernel@vger.kernel.org,
        ms@dev.tdt.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, tanxin.ctf@gmail.com, linma@zju.edu.cn,
        xiyuyang19@fudan.edu.cn
Subject: Re: [PATCH net] net/x25: Fix null-ptr-deref caused by
 x25_disconnect
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220326065912.41077-1-duoming@zju.edu.cn>
References: <20220326065912.41077-1-duoming@zju.edu.cn>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <4569327b.1ae29.17fc513fb2f.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgB3HwBvvT5iOb2hAA--.13036W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwPAVZdtYygQQAEsX
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkkgYW0gc29ycnksIHRoaXMgcGF0Y2ggaGFzIGEgcHJvYmxlbS4gSSB3aWxsIHNlbmQgdGhlIGNv
cnJlY3QgdmVyc2lvbiBsYXRlci4KCj4gVGhlIHByZXZpb3VzIGNvbW1pdCA0YmVjYjdlZTViM2Qg
KCJuZXQveDI1OiBGaXggeDI1X25laWdoIHJlZmNudCBsZWFrIHdoZW4KPiB4MjUgZGlzY29ubmVj
dCIpIGFkZHMgZGVjcmVtZW50IG9mIHJlZmNvdW50IG9mIHgyNS0+bmVpZ2hib3VyIGFuZCBzZXRz
Cj4geDI1LT5uZWlnaGJvdXIgdG8gTlVMTCBpbiB4MjVfZGlzY29ubmVjdCgpLCBidXQgd2hlbiB0
aGUgbGluayBsYXllciBpcwo+IHRlcm1pbmF0aW5nLCBpdCBjb3VsZCBjYXVzZSBudWxsLXB0ci1k
ZXJlZiBidWdzIGluIHgyNV9zZW5kbXNnKCksCj4geDI1X3JlY3Ztc2coKSBhbmQgeDI1X2Nvbm5l
Y3QoKS4gT25lIG9mIHRoZSBidWdzIGlzIHNob3duIGJlbG93Lgo+IAo+IHgyNV9saW5rX3Rlcm1p
bmF0ZWQoKSAgICAgICAgICB8IHgyNV9yZWN2bXNnKCkKPiAgeDI1X2tpbGxfYnlfbmVpZ2goKSAg
ICAgICAgICAgfCAgLi4uCj4gICB4MjVfZGlzY29ubmVjdCgpICAgICAgICAgICAgIHwgIGxvY2tf
c29jayhzaykKPiAgICAuLi4gICAgICAgICAgICAgICAgICAgICAgICAgfCAgLi4uCj4gICAgeDI1
LT5uZWlnaGJvdXIgPSBOVUxMIC8vKDEpIHwKPiAgICAuLi4gICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgeDI1LT5uZWlnaGJvdXItPmV4dGVuZGVkIC8vKDIpCj4gCj4gV2Ugc2V0IE5VTEwgdG8g
eDI1LT5uZWlnaGJvdXIgaW4gcG9zaXRpb24gKDEpIGFuZCBkZXJlZmVyZW5jZQo+IHgyNS0+bmVp
Z2hib3VyIGluIHBvc2l0aW9uICgyKSwgd2hpY2ggY291bGQgY2F1c2UgbnVsbC1wdHItZGVyZWYg
YnVnLgo+IAo+IFRoaXMgcGF0Y2ggYWRkcyBsb2NrX3NvY2soc2spIGluIHgyNV9kaXNjb25uZWN0
KCkgaW4gb3JkZXIgdG8gc3luY2hyb25pemUKPiB3aXRoIHgyNV9zZW5kbXNnKCksIHgyNV9yZWN2
bXNnKCkgYW5kIHgyNV9jb25uZWN0KCkuIFdoYXRgcyBtb3JlLCB0aGUgc2sKPiBoZWxkIGJ5IGxv
Y2tfc29jaygpIGlzIG5vdCBOVUxMLCBiZWNhdXNlIGl0IGlzIGV4dHJhY3RlZCBmcm9tIHgyNV9s
aXN0Cj4gYW5kIHVzZXMgeDI1X2xpc3RfbG9jayB0byBzeW5jaHJvbml6ZS4KPiAKPiBGaXhlczog
NGJlY2I3ZWU1YjNkICgibmV0L3gyNTogRml4IHgyNV9uZWlnaCByZWZjbnQgbGVhayB3aGVuIHgy
NSBkaXNjb25uZWN0IikKPiBTaWduZWQtb2ZmLWJ5OiBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1
LmVkdS5jbj4KPiAtLS0KPiAgbmV0L3gyNS94MjVfc3Vici5jIHwgMiArKwo+ICAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL25ldC94MjUveDI1X3N1YnIu
YyBiL25ldC94MjUveDI1X3N1YnIuYwo+IGluZGV4IDAyODVhYWExZTkzLi40ZTE5NzUyYmRkMCAx
MDA2NDQKPiAtLS0gYS9uZXQveDI1L3gyNV9zdWJyLmMKPiArKysgYi9uZXQveDI1L3gyNV9zdWJy
LmMKPiBAQCAtMzYwLDcgKzM2MCw5IEBAIHZvaWQgeDI1X2Rpc2Nvbm5lY3Qoc3RydWN0IHNvY2sg
KnNrLCBpbnQgcmVhc29uLCB1bnNpZ25lZCBjaGFyIGNhdXNlLAo+ICAJaWYgKHgyNS0+bmVpZ2hi
b3VyKSB7Cj4gIAkJcmVhZF9sb2NrX2JoKCZ4MjVfbGlzdF9sb2NrKTsKPiAgCQl4MjVfbmVpZ2hf
cHV0KHgyNS0+bmVpZ2hib3VyKTsKPiArCQlsb2NrX3NvY2soc2spOwo+ICAJCXgyNS0+bmVpZ2hi
b3VyID0gTlVMTDsKPiArCQlyZWxlYXNlX3NvY2soc2spOwo+ICAJCXJlYWRfdW5sb2NrX2JoKCZ4
MjVfbGlzdF9sb2NrKTsKPiAgCX0KPiAgfQo+IC0tIAo+IDIuMTcuMQo=
