Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01E44F6309
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235613AbiDFPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiDFPMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:12:38 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93DF4530BE5;
        Wed,  6 Apr 2022 05:13:18 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Wed, 6 Apr 2022 20:03:27
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.67.219]
Date:   Wed, 6 Apr 2022 20:03:27 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jiri Slaby" <jirislaby@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] drivers: net: slip: fix NPD bug in sl_tx_timeout()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <631ac05c-6807-11ff-c940-cd27bcc3a925@kernel.org>
References: <20220405132206.55291-1-duoming@zju.edu.cn>
 <631ac05c-6807-11ff-c940-cd27bcc3a925@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <64c159c9.387c5.17ffec218b7.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgAHXxWPgU1iXlo5AQ--.28213W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgYMAVZdtZDnKQAMsl
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

SGVsbG8sCgpPbiBXZWQsIDYgQXByIDIwMjIgMTA6NDU6MDUgKzAyMDAsIEppcmkgU2xhYnkgd3Jv
dGU6Cgo+ID4gV2hlbiBhIHNsaXAgZHJpdmVyIGlzIGRldGFjaGluZywgdGhlIHNsaXBfY2xvc2Uo
KSB3aWxsIGFjdCB0bwo+ID4gY2xlYW51cCBuZWNlc3NhcnkgcmVzb3VyY2VzIGFuZCBzbC0+dHR5
IGlzIHNldCB0byBOVUxMIGluCj4gPiBzbGlwX2Nsb3NlKCkuIE1lYW53aGlsZSwgdGhlIHBhY2tl
dCB3ZSB0cmFuc21pdCBpcyBibG9ja2VkLAo+ID4gc2xfdHhfdGltZW91dCgpIHdpbGwgYmUgY2Fs
bGVkLiBBbHRob3VnaCBzbGlwX2Nsb3NlKCkgYW5kCj4gPiBzbF90eF90aW1lb3V0KCkgdXNlIHNs
LT5sb2NrIHRvIHN5bmNocm9uaXplLCB3ZSBkb25gdCBqdWRnZQo+ID4gd2hldGhlciBzbC0+dHR5
IGVxdWFscyB0byBOVUxMIGluIHNsX3R4X3RpbWVvdXQoKSBhbmQgdGhlCj4gPiBudWxsIHBvaW50
ZXIgZGVyZWZlcmVuY2UgYnVnIHdpbGwgaGFwcGVuLgo+ID4gCj4gPiAgICAgKFRocmVhZCAxKSAg
ICAgICAgICAgICAgICAgfCAgICAgIChUaHJlYWQgMikKPiA+ICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8IHNsaXBfY2xvc2UoKQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgICBzcGluX2xvY2tfYmgoJnNsLT5sb2NrKQo+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHwgICAuLi4KPiA+IC4uLiAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICBz
bC0+dHR5ID0gTlVMTCAvLygxKQo+ID4gc2xfdHhfdGltZW91dCgpICAgICAgICAgICAgICAgfCAg
IHNwaW5fdW5sb2NrX2JoKCZzbC0+bG9jaykKPiA+ICAgIHNwaW5fbG9jaygmc2wtPmxvY2spOyAg
ICAgICB8Cj4gPiAgICAuLi4gICAgICAgICAgICAgICAgICAgICAgICAgfCAgIC4uLgo+ID4gICAg
dHR5X2NoYXJzX2luX2J1ZmZlcihzbC0+dHR5KXwKPiA+ICAgICAgaWYgKHR0eS0+b3BzLT4uLikg
Ly8oMikgICB8Cj4gPiAgICAgIC4uLiAgICAgICAgICAgICAgICAgICAgICAgfCAgIHN5bmNocm9u
aXplX3JjdSgpCj4gPiAKPiA+IFdlIHNldCBOVUxMIHRvIHNsLT50dHkgaW4gcG9zaXRpb24gKDEp
IGFuZCBkZXJlZmVyZW5jZSBzbC0+dHR5Cj4gPiBpbiBwb3NpdGlvbiAoMikuCj4gPiAKPiA+IFRo
aXMgcGF0Y2ggYWRkcyBjaGVjayBpbiBzbF90eF90aW1lb3V0KCkuIElmIHNsLT50dHkgZXF1YWxz
IHRvCj4gPiBOVUxMLCBzbF90eF90aW1lb3V0KCkgd2lsbCBnb3RvIG91dC4KPiAKPiBJdCBtYWtl
cyBzZW5zZS4gdW5yZWdpc3Rlcl9uZXRkZXYoKSAodG8ga2lsbCB0aGUgdGltZXIpIGlzIGNhbGxl
ZCBvbmx5IAo+IGxhdGVyIGluIHNsaXBfY2xvc2UoKS4KPiAKPiBSZXZpZXdlZC1ieTogSmlyaSBT
bGFieSA8amlyaXNsYWJ5QGtlcm5lbC5vcmc+Cj4gCgpUaGFua3MgZm9yIHlvdXIgdGltZSBhbmQg
YXBwcm92ZSBteSBwYXRjaC4KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91
