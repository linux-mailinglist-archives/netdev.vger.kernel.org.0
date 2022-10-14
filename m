Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808E35FE922
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJNG6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJNG6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:58:33 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B8AF61BB963;
        Thu, 13 Oct 2022 23:58:28 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Fri, 14 Oct 2022 14:58:17
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.136.77]
Date:   Fri, 14 Oct 2022 14:58:17 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Leon Romanovsky" <leon@kernel.org>
Cc:     "Greg KH" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        isdn@linux-pingi.de, kuba@kernel.org, andrii@kernel.org,
        davem@davemloft.net, axboe@kernel.dk
Subject: Re: [PATCH] mISDN: hfcpci: Fix use-after-free bug in hfcpci_Timer
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <Y0j8ixwitdWKuUoM@unreal>
References: <20221013125729.105652-1-duoming@zju.edu.cn>
 <Y0gQhe6EL6nDstlL@kroah.com> <Y0j8ixwitdWKuUoM@unreal>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <24615c1e.123e96.183d5495a77.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgA3jw6JCEljeZ7hBw--.1588W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgQDAVZdtb6wxgAAsy
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

SGVsbG8sCgpPbiBGcmksIDE0IE9jdCAyMDIyIDA5OjA3OjA3ICswMzAwIExlb24gUm9tYW5vdnNr
eSB3cm90ZToKCj4gT24gVGh1LCBPY3QgMTMsIDIwMjIgYXQgMDM6MjA6MDVQTSArMDIwMCwgR3Jl
ZyBLSCB3cm90ZToKPiA+IE9uIFRodSwgT2N0IDEzLCAyMDIyIGF0IDA4OjU3OjI5UE0gKzA4MDAs
IER1b21pbmcgWmhvdSB3cm90ZToKPiA+ID4gSWYgdGhlIHRpbWVyIGhhbmRsZXIgaGZjcGNpX1Rp
bWVyKCkgaXMgcnVubmluZywgdGhlCj4gPiA+IGRlbF90aW1lcigmaGMtPmh3LnRpbWVyKSBpbiBy
ZWxlYXNlX2lvX2hmY3BjaSgpIGNvdWxkCj4gPiA+IG5vdCBzdG9wIGl0LiBBcyBhIHJlc3VsdCwg
dGhlIHVzZS1hZnRlci1mcmVlIGJ1ZyB3aWxsCj4gPiA+IGhhcHBlbi4gVGhlIHByb2Nlc3MgaXMg
c2hvd24gYmVsb3c6Cj4gPiA+IAo+ID4gPiAgICAgKGNsZWFudXAgcm91dGluZSkgICAgICAgICAg
fCAgICAgICAgKHRpbWVyIGhhbmRsZXIpCj4gPiA+IHJlbGVhc2VfY2FyZCgpICAgICAgICAgICAg
ICAgICB8IGhmY3BjaV9UaW1lcigpCj4gPiA+ICAgcmVsZWFzZV9pb19oZmNwY2kgICAgICAgICAg
ICB8Cj4gPiA+ICAgICBkZWxfdGltZXIoJmhjLT5ody50aW1lcikgICB8Cj4gPiA+ICAgLi4uICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAuLi4KPiA+ID4gICBrZnJlZShoYykgLy9bMV1GUkVF
ICAgICAgICAgIHwKPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICBoYy0+
aHcudGltZXIuZXhwaXJlcyAvL1syXVVTRQo+ID4gPiAKPiA+ID4gVGhlIGhmY19wY2kgaXMgZGVh
bGxvY2F0ZWQgaW4gcG9zaXRpb24gWzFdIGFuZCB1c2VkIGluCj4gPiA+IHBvc2l0aW9uIFsyXS4K
PiA+ID4gCj4gPiA+IEZpeCBieSBjaGFuZ2luZyBkZWxfdGltZXIoKSBpbiByZWxlYXNlX2lvX2hm
Y3BjaSgpIHRvCj4gPiA+IGRlbF90aW1lcl9zeW5jKCksIHdoaWNoIG1ha2VzIHN1cmUgdGhlIGhm
Y3BjaV9UaW1lcigpCj4gPiA+IGhhdmUgZmluaXNoZWQgYmVmb3JlIHRoZSBoZmNfcGNpIGlzIGRl
YWxsb2NhdGVkLgo+ID4gPiAKPiA+ID4gRml4ZXM6IDE3MDBmZTFhMTBkYyAoIkFkZCBtSVNETiBI
RkMgUENJIGRyaXZlciIpCj4gPiA+IFNpZ25lZC1vZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWlu
Z0B6anUuZWR1LmNuPgo+ID4gPiAtLS0KPiA+ID4gIGRyaXZlcnMvaXNkbi9oYXJkd2FyZS9tSVNE
Ti9oZmNwY2kuYyB8IDIgKy0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQo+ID4gPiAKPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaXNkbi9oYXJk
d2FyZS9tSVNETi9oZmNwY2kuYyBiL2RyaXZlcnMvaXNkbi9oYXJkd2FyZS9tSVNETi9oZmNwY2ku
Ywo+ID4gPiBpbmRleCBhZjE3NDU5YzFhNS4uNWNmMzdmZTdkZTIgMTAwNjQ0Cj4gPiA+IC0tLSBh
L2RyaXZlcnMvaXNkbi9oYXJkd2FyZS9tSVNETi9oZmNwY2kuYwo+ID4gPiArKysgYi9kcml2ZXJz
L2lzZG4vaGFyZHdhcmUvbUlTRE4vaGZjcGNpLmMKPiA+ID4gQEAgLTE1Nyw3ICsxNTcsNyBAQCBy
ZWxlYXNlX2lvX2hmY3BjaShzdHJ1Y3QgaGZjX3BjaSAqaGMpCj4gPiA+ICB7Cj4gPiA+ICAJLyog
ZGlzYWJsZSBtZW1vcnkgbWFwcGVkIHBvcnRzICsgYnVzbWFzdGVyICovCj4gPiA+ICAJcGNpX3dy
aXRlX2NvbmZpZ193b3JkKGhjLT5wZGV2LCBQQ0lfQ09NTUFORCwgMCk7Cj4gPiA+IC0JZGVsX3Rp
bWVyKCZoYy0+aHcudGltZXIpOwo+ID4gPiArCWRlbF90aW1lcl9zeW5jKCZoYy0+aHcudGltZXIp
Owo+ID4gCj4gPiBOaWNlLCBob3cgZGlkIHlvdSB0ZXN0IHRoYXQgdGhpcyB3aWxsIHdvcmsgcHJv
cGVybHk/ICBEbyB5b3UgaGF2ZSB0aGlzCj4gPiBoYXJkd2FyZSBmb3IgdGVzdGluZz8gIEhvdyB3
YXMgdGhpcyBpc3N1ZSBmb3VuZCBhbmQgdmVyaWZpZWQgdGhhdCB0aGlzCj4gPiBpcyB0aGUgY29y
cmVjdCByZXNvbHV0aW9uPwoKSSBhbSB0cnlpbmcgdG8gc2ltdWxhdGUgdGhlIGhhcmR3YXJlIHRv
IHZlcmlmaWVkIHRoYXQgdGhpcyBpcyB0aGUgY29ycmVjdApyZXNvbHV0aW9uLiBJIHdpbGwgZ2l2
ZSBmZWVkYmFjayBpbiBhIGZldyB3ZWVrcyBsYXRlci4KCj4gQWNjb3JkaW5nIHRvIGhpcyBwcmV2
aW91cyByZXNwb25zZSBbMV0sIHRoZSBhbnN3ZXIgd2lsbCBiZSBuby4gSSdtIG5vdAo+IHN1cGVy
LWV4Y2l0ZWQgdGhhdCB0aGlzIHVubWFpbnRhaW5lZCBhbmQgb2xkIGRyaXZlciBjaG9zZW4gYXMg
cGxheWdyb3VuZAo+IGZvciBuZXcgdG9vbC4KPiAKPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYWxsLzE3YWQ2OTEzLmZmOGUwLjE4Mzg5MzM4NDBkLkNvcmVtYWlsLmR1b21pbmdAemp1LmVk
dS5jbi8jdAoKQmVzdCByZWdhcmRzLApEdW9taW5nIFpob3U=
