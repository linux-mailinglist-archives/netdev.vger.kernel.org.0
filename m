Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B642512D73
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 09:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbiD1H62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 03:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234669AbiD1H60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 03:58:26 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E776DD;
        Thu, 28 Apr 2022 00:55:11 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 28 Apr 2022 15:55:01
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.13.90]
Date:   Thu, 28 Apr 2022 15:55:01 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "Jakub Kicinski" <kuba@kernel.org>,
        "Duoming Zhou" <duoming@zju.edu.cn>,
        krzysztof.kozlowski@linaro.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        alexander.deucher@amd.com, akpm@linux-foundation.org,
        broonie@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] nfc: ... device_is_registered() is data
 race-able
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YmpEZQ7EnOIWlsy8@kroah.com>
References: <20220427011438.110582-1-duoming@zju.edu.cn>
 <20220427174548.2ae53b84@kernel.org>
 <38929d91.237b.1806f05f467.Coremail.linma@zju.edu.cn>
 <YmpEZQ7EnOIWlsy8@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2d7c9164.2b1f.1806f2a8ed9.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDnXmJVSGpi97osAw--.46956W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwMOElNG3GhD8wABsM
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

SGVsbG8gR3JlZywKCgo+IAo+IFlvdSBzaG91bGQgbm90IGJlIG1ha2luZyB0aGVzZSB0eXBlcyBv
ZiBjaGVja3Mgb3V0c2lkZSBvZiB0aGUgZHJpdmVyCj4gY29yZS4KPiAKPiA+IFRoaXMgaXMgYnkg
bm8gbWVhbnMgbWF0Y2hpbmcgb3VyIGV4cGVjdGF0aW9ucyBhcyBvbmUgb2Ygb3VyIHByZXZpb3Vz
IHBhdGNoIHJlbGllcyBvbiB0aGUgZGV2aWNlX2lzX3JlZ2lzdGVyZWQgY29kZS4KPiAKPiBQbGVh
c2UgZG8gbm90IGRvIHRoYXQuCj4gCj4gPiAKPiA+IC0+IHRoZSBwYXRjaDogM2UzYjVkZmNkMTZh
ICgiTkZDOiByZW9yZGVyIHRoZSBsb2dpYyBpbiBuZmNfe3VuLH1yZWdpc3Rlcl9kZXZpY2UiKQo+
ID4gCj4gPC4uLj4KPiA+IAo+ID4gSW4gYW5vdGhlciB3b3JkLCB0aGUgZGV2aWNlX2RlbCAtPiBr
b2JqZWN0X2RlbCAtPiBfX2tvYmplY3RfZGVsIGlzIG5vdCBwcm90ZWN0ZWQgYnkgdGhlIGRldmlj
ZV9sb2NrLgo+IAo+IE5vciBzaG91bGQgaXQgYmUuCj4gCgpJIG1heSBoYXZlIG1pc3Rha2VubHkg
cHJlc2VudGVkIG15IHBvaW50LiBJbiBmYWN0LCB0aGVyZSBpcyBub3RoaW5nIHdyb25nIHdpdGgg
dGhlIGRldmljZSBjb3JlLCBub3RoaW5nIHRvIGRvIHdpdGggdGhlIGludGVybmFsIG9mIGRldmlj
ZV9kZWwgYW5kIGRldmljZV9pc19yZWdpc3RlcmVkIGltcGxlbWVudGF0aW9uLiBBbmQsIG9mIGNv
dXJzZSwgd2Ugd2lsbCBub3QgYWRkIGFueSBjb2RlIG9yIGRvIGFueSBtb2RpZmljYXRpb24gdG8g
dGhlIGRldmljZS9kcml2ZXIgYmFzZSBjb2RlLgoKVGhlIHBvaW50IGlzIHRoZSBjb21iaW5hdGlv
biBvZiBkZXZpY2VfaXNfcmVnaXN0ZXJlZCArIGRldmljZV9kZWwsIHdoaWNoIGlzIHVzZWQgaW4g
TkZDIGNvcmUsIGlzIG5vdCBzYWZlLgoKVGhhdCBpcyB0byBzYXksIGV2ZW4gdGhlIGRldmljZV9p
c19yZWdpc3RlcmVkIGNhbiByZXR1cm4gVHJ1ZSBldmVuIHRoZSBkZXZpY2VfZGVsIGlzIGV4ZWN1
dGluZyBpbiBhbm90aGVyIHRocmVhZC4KCihCeSBkZWJ1Z2dpbmcgd2UgdGhpbmsgdGhpcyBpcyB0
cnVlLCBjb3JyZWN0IG1lIGlmIGl0IGlzIG5vdCkKCkhlbmNlIHdlIHdhbnQgdG8gYWRkIGFkZGl0
aW9uYWwgc3RhdGUgaW4gbmZjX2RldiBvYmplY3QgdG8gZml4IHRoYXQsIG5vdCBnb2luZyB0byBh
ZGQgYW55IHN0YXRlIGluIGRldmljZS9kcml2ZXIgY29yZS4KCj4gPiBUaGlzIG1lYW5zIHRoZSBk
ZXZpY2VfbG9jayArIGRldmljZV9pc19yZWdpc3RlcmVkIGlzIHN0aWxsIHByb25lIHRvIHRoZSBk
YXRhIHJhY2UuIEFuZCB0aGlzIGlzIG5vdCBqdXN0IHRoZSBwcm9ibGVtIHdpdGggZmlybXdhcmUg
ZG93bmxvYWRpbmcuIFRoZSBhbGwgcmVsZXZhbnQgbmV0bGluayB0YXNrcyB0aGF0IHVzZSB0aGUg
ZGV2aWNlX2xvY2sgKyBkZXZpY2VfaXNfcmVnaXN0ZXJlZCBpcyBwb3NzaWJsZSB0byBiZSByYWNl
ZC4KPiA+IAo+ID4gVG8gdGhpcyBlbmQsIHdlIHdpbGwgY29tZSBvdXQgd2l0aCB0d28gcGF0Y2hl
cywgb25lIGZvciBmaXhpbmcgdGhpcyBkZXZpY2VfaXNfcmVnaXN0ZXJlZCBieSB1c2luZyBhbm90
aGVyIHN0YXR1cyB2YXJpYWJsZSBpbnN0ZWFkLiBUaGUgb3RoZXIgaXMgdGhlIHBhdGNoIHRoYXQg
cmVvcmRlcnMgdGhlIGNvZGUgaW4gbmNpX3VucmVnaXN0ZXJfZGV2aWNlLgo+IAo+IFdoeSBpcyB0
aGlzIHNvbWVob3cgdW5pcXVlIHRvIHRoZXNlIGRldmljZXM/ICBXaHkgZG8gbm8gb3RoZXIgYnVz
ZXMgaGF2ZQo+IHRoaXMgaXNzdWU/ICBBcmUgeW91IHNvbWVob3cgYWxsb3dpbmcgYSBjb2RlIHBh
dGggdGhhdCBzaG91bGQgbm90IGJlCj4gaGFwcGVuaW5nPwo+IAo+IHRoYW5rcywKPiAKPiBncmVn
IGstaAoKSW4gZmFjdCwgYnkgc2VhcmNoaW5nIHRoZSBkZXZpY2VfaXNfcmVnaXN0ZXJlZCgpIHVz
ZSBjYXNlcywgSSBmb3VuZCB0aGF0IG1vc3Qgb2YgdGhlbSBhcmUgdXNlZCBpbiBkcmllciBjb2Rl
IGluc3RlYWQgb2YgaW4gdGhlIG5ldHdvcmsgc3RhY2suIEkgaGF2ZSBubyBpZGVhIHdoZXRoZXIg
b3Igbm90IHRoZXkgc3VmZmVyIGZyb20gc2ltaWxhciBwcm9ibGVtcyBhbmQgSSB3aWxsIGNoZWNr
IHRoYXQgb3V0LgoKVGhhbmtzCkxpbg==
