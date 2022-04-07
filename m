Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6D54F7F9B
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244304AbiDGM4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbiDGM4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:56:42 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 678FA25A49E;
        Thu,  7 Apr 2022 05:54:39 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Apr 2022 20:54:13
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.226.201]
Date:   Thu, 7 Apr 2022 20:54:13 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     linux-kernel@vger.kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220407112455.GK3293@kadam>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDnXmL13k5iNReTAQ--.17805W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgYNAVZdtZE4DQAFsX
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

SGVsbG8sCgpPbiBUaHUsIDcgQXByIDIwMjIgMTQ6MjQ6NTYgKzAzMDAgRGFuIENhcnBlbnRlciB3
cm90ZToKCj4gPiBUaGVyZSBpcyBhIGRlYWRsb2NrIGluIGlyZG1hX2NsZWFudXBfY21fY29yZSgp
LCB3aGljaCBpcyBzaG93bgo+ID4gYmVsb3c6Cj4gPiAKPiA+ICAgIChUaHJlYWQgMSkgICAgICAg
ICAgICAgIHwgICAgICAoVGhyZWFkIDIpCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IGlyZG1hX3NjaGVkdWxlX2NtX3RpbWVyKCkKPiA+IGlyZG1hX2NsZWFudXBfY21fY29yZSgpICAg
IHwgIGFkZF90aW1lcigpCj4gPiAgc3Bpbl9sb2NrX2lycXNhdmUoKSAvLygxKSB8ICAod2FpdCBh
IHRpbWUpCj4gPiAgLi4uICAgICAgICAgICAgICAgICAgICAgICB8IGlyZG1hX2NtX3RpbWVyX3Rp
Y2soKQo+ID4gIGRlbF90aW1lcl9zeW5jKCkgICAgICAgICAgfCAgc3Bpbl9sb2NrX2lycXNhdmUo
KSAvLygyKQo+ID4gICh3YWl0IHRpbWVyIHRvIHN0b3ApICAgICAgfCAgLi4uCj4gPiAKPiA+IFdl
IGhvbGQgY21fY29yZS0+aHRfbG9jayBpbiBwb3NpdGlvbiAoMSkgb2YgdGhyZWFkIDEgYW5kCj4g
PiB1c2UgZGVsX3RpbWVyX3N5bmMoKSB0byB3YWl0IHRpbWVyIHRvIHN0b3AsIGJ1dCB0aW1lciBo
YW5kbGVyCj4gPiBhbHNvIG5lZWQgY21fY29yZS0+aHRfbG9jayBpbiBwb3NpdGlvbiAoMikgb2Yg
dGhyZWFkIDIuCj4gPiBBcyBhIHJlc3VsdCwgaXJkbWFfY2xlYW51cF9jbV9jb3JlKCkgd2lsbCBi
bG9jayBmb3JldmVyLgo+ID4gCj4gPiBUaGlzIHBhdGNoIGV4dHJhY3RzIGRlbF90aW1lcl9zeW5j
KCkgZnJvbSB0aGUgcHJvdGVjdGlvbiBvZgo+ID4gc3Bpbl9sb2NrX2lycXNhdmUoKSwgd2hpY2gg
Y291bGQgbGV0IHRpbWVyIGhhbmRsZXIgdG8gb2J0YWluCj4gPiB0aGUgbmVlZGVkIGxvY2suCj4g
PiAKPiA+IFNpZ25lZC1vZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPgo+
ID4gLS0tCj4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2NtLmMgfCA1ICsrKystCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+ID4gCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2NtLmMgYi9kcml2ZXJz
L2luZmluaWJhbmQvaHcvaXJkbWEvY20uYwo+ID4gaW5kZXggZGVkYjNiN2VkZDguLjAxOWRkOGJm
ZTA4IDEwMDY0NAo+ID4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2NtLmMKPiA+
ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jbS5jCj4gPiBAQCAtMzI1Miw4ICsz
MjUyLDExIEBAIHZvaWQgaXJkbWFfY2xlYW51cF9jbV9jb3JlKHN0cnVjdCBpcmRtYV9jbV9jb3Jl
ICpjbV9jb3JlKQo+ID4gIAkJcmV0dXJuOwo+ID4gIAo+ID4gIAlzcGluX2xvY2tfaXJxc2F2ZSgm
Y21fY29yZS0+aHRfbG9jaywgZmxhZ3MpOwo+ID4gLQlpZiAodGltZXJfcGVuZGluZygmY21fY29y
ZS0+dGNwX3RpbWVyKSkKPiA+ICsJaWYgKHRpbWVyX3BlbmRpbmcoJmNtX2NvcmUtPnRjcF90aW1l
cikpIHsKPiA+ICsJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNtX2NvcmUtPmh0X2xvY2ssIGZs
YWdzKTsKPiA+ICAJCWRlbF90aW1lcl9zeW5jKCZjbV9jb3JlLT50Y3BfdGltZXIpOwo+ID4gKwkJ
c3Bpbl9sb2NrX2lycXNhdmUoJmNtX2NvcmUtPmh0X2xvY2ssIGZsYWdzKTsKPiA+ICsJfQo+ID4g
IAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjbV9jb3JlLT5odF9sb2NrLCBmbGFncyk7Cj4gCj4g
VGhpcyBsb2NrIGRvZXNuJ3Qgc2VlbSB0byBiZSBwcm90ZWN0aW5nIGFueXRoaW5nLiAgQWxzbyBk
byB3ZSBuZWVkIHRvCj4gY2hlY2sgdGltZXJfcGVuZGluZygpPyAgSSB0aGluayB0aGUgZGVsX3Rp
bWVyX3N5bmMoKSBmdW5jdGlvbiB3aWxsIGp1c3QKPiByZXR1cm4gZGlyZWN0bHkgaWYgdGhlcmUg
aXNuJ3QgYSBwZW5kaW5nIGxvY2s/CgpUaGFua3MgYSBsb3QgZm9yIHlvdXIgYWR2aWNlLCBJIHdp
bGwgcmVtb3ZlIHRoZSB0aW1lcl9wZW5kaW5nKCkgYW5kIHRoZQpyZWR1bmRhbnQgbG9jay4KCkJl
c3QgcmVnYXJkcywKRHVvbWluZyBaaG91
