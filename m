Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0549D4F81F2
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 16:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240024AbiDGOku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiDGOks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:40:48 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 358B11A7766;
        Thu,  7 Apr 2022 07:38:42 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Apr 2022 22:38:13
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.226.201]
Date:   Thu, 7 Apr 2022 22:38:13 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jason Gunthorpe" <jgg@ziepe.ca>
Cc:     "Dan Carpenter" <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Re: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220407142355.GV64706@ziepe.ca>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
 <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
 <20220407142355.GV64706@ziepe.ca>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <403bbe08.3fc24.18004762739.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgB3HwBV905iIZ2UAQ--.29189W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg4NAVZdtZE9jgAGsa
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

SGVsbG8sCgpPbiBUaHUsIDcgQXByIDIwMjIgMTE6MjM6NTUgLTAzMDAgSmFzb24gR3VudGhvcnBl
IHdyb3RlOgoKPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1h
L2NtLmMgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY20uYwo+ID4gPiA+IGluZGV4IGRl
ZGIzYjdlZGQ4Li4wMTlkZDhiZmUwOCAxMDA2NDQKPiA+ID4gPiArKysgYi9kcml2ZXJzL2luZmlu
aWJhbmQvaHcvaXJkbWEvY20uYwo+ID4gPiA+IEBAIC0zMjUyLDggKzMyNTIsMTEgQEAgdm9pZCBp
cmRtYV9jbGVhbnVwX2NtX2NvcmUoc3RydWN0IGlyZG1hX2NtX2NvcmUgKmNtX2NvcmUpCj4gPiA+
ID4gIAkJcmV0dXJuOwo+ID4gPiA+ICAKPiA+ID4gPiAgCXNwaW5fbG9ja19pcnFzYXZlKCZjbV9j
b3JlLT5odF9sb2NrLCBmbGFncyk7Cj4gPiA+ID4gLQlpZiAodGltZXJfcGVuZGluZygmY21fY29y
ZS0+dGNwX3RpbWVyKSkKPiA+ID4gPiArCWlmICh0aW1lcl9wZW5kaW5nKCZjbV9jb3JlLT50Y3Bf
dGltZXIpKSB7Cj4gPiA+ID4gKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmY21fY29yZS0+aHRf
bG9jaywgZmxhZ3MpOwo+ID4gPiA+ICAJCWRlbF90aW1lcl9zeW5jKCZjbV9jb3JlLT50Y3BfdGlt
ZXIpOwo+ID4gPiA+ICsJCXNwaW5fbG9ja19pcnFzYXZlKCZjbV9jb3JlLT5odF9sb2NrLCBmbGFn
cyk7Cj4gPiA+ID4gKwl9Cj4gPiA+ID4gIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjbV9jb3Jl
LT5odF9sb2NrLCBmbGFncyk7Cj4gPiA+IAo+ID4gPiBUaGlzIGxvY2sgZG9lc24ndCBzZWVtIHRv
IGJlIHByb3RlY3RpbmcgYW55dGhpbmcuICBBbHNvIGRvIHdlIG5lZWQgdG8KPiA+ID4gY2hlY2sg
dGltZXJfcGVuZGluZygpPyAgSSB0aGluayB0aGUgZGVsX3RpbWVyX3N5bmMoKSBmdW5jdGlvbiB3
aWxsIGp1c3QKPiA+ID4gcmV0dXJuIGRpcmVjdGx5IGlmIHRoZXJlIGlzbid0IGEgcGVuZGluZyBs
b2NrPwo+ID4gCj4gPiBUaGFua3MgYSBsb3QgZm9yIHlvdXIgYWR2aWNlLCBJIHdpbGwgcmVtb3Zl
IHRoZSB0aW1lcl9wZW5kaW5nKCkgYW5kIHRoZQo+ID4gcmVkdW5kYW50IGxvY2suCj4gCj4gRG9l
cyBkZWxfdGltZXJfc3luYyB3b3JrIHdpdGggYSBzZWxmLXJlc2NoZWR1bGluZyB0aW1lciBsaWtl
IHRoaXMgaGFzPwoKVGhlIGRlbF90aW1lcl9zeW5jKCkgd2lsbCBraWxsIHRoZSB0aW1lciBhbHRo
b3VnaCBpdCBpcyBzZWxmLXJlc2NoZWR1bGluZy4KV2UgY291bGQgdXNlIG90aGVyIGZ1bmN0aW9u
cyB0byBhcm91c2UgdGltZXIgYWdhaW4gYmVzaWRlcyB0aW1lciBoYW5kbGVyIGl0c2VsZi4KCkJl
c3QgcmVnYXJkcywKRHVvbWluZyBaaG91Cg==
