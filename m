Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288185A095D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbiHYHAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbiHYHAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:00:23 -0400
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id A2A8C2F3A3;
        Thu, 25 Aug 2022 00:00:16 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 25 Aug 2022 14:59:50
 +0800 (GMT+08:00)
X-Originating-IP: [218.12.16.111]
Date:   Thu, 25 Aug 2022 14:59:50 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc:     "Brian Norris" <briannorris@chromium.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Johannes Berg" <johannes@sipsolutions.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "amit karwar" <amitkarwar@gmail.com>,
        "Ganapathi Bhat" <ganapathi017@gmail.com>,
        "Sharvari Harisangam" <sharvari.harisangam@nxp.com>,
        "Xinming Hu" <huxinming820@gmail.com>, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] Add new APIs of devcoredump and fix bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <YwcPxT2JLQHXbdFI@kroah.com>
References: <cover.1661252818.git.duoming@zju.edu.cn>
 <CA+ASDXNf5JV9mj8mbm1OGZ_zd4d8srFc=E++Amg4MoQjqjS_TA@mail.gmail.com>
 <27a2a8a7.99f01.182d2758bc9.Coremail.duoming@zju.edu.cn>
 <YwcPxT2JLQHXbdFI@kroah.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <261bd1c5.9ab83.182d3cccd91.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgCXnP3nHQdjPPfoAw--.51580W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwNAVZdtbKGFwBgs-
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBUaHUsIDI1IEF1ZyAyMDIyIDA3OjU5OjMzICswMjAwIEdyZWcgS3JvYWgtSGFy
dG1hbiB3cm90ZToKIAo+ID4gT24gV2VkLCAyNCBBdWcgMjAyMiAxMzo0MjowOSAtMDcwMCBCcmlh
biBOb3JyaXMgd3JvdGU6Cj4gPiAKPiA+ID4gT24gVHVlLCBBdWcgMjMsIDIwMjIgYXQgNDoyMSBB
TSBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4gd3JvdGU6Cj4gPiA+ID4KPiA+ID4g
PiBUaGUgZmlyc3QgcGF0Y2ggYWRkcyBuZXcgQVBJcyB0byBzdXBwb3J0IG1pZ3JhdGlvbiBvZiB1
c2Vycwo+ID4gPiA+IGZyb20gb2xkIGRldmljZSBjb3JlZHVtcCByZWxhdGVkIEFQSXMuCj4gPiA+
ID4KPiA+ID4gPiBUaGUgc2Vjb25kIHBhdGNoIGZpeCBzbGVlcCBpbiBhdG9taWMgY29udGV4dCBi
dWdzIG9mIG13aWZpZXgKPiA+ID4gPiBjYXVzZWQgYnkgZGV2X2NvcmVkdW1wdigpLgo+ID4gPiA+
Cj4gPiA+ID4gRHVvbWluZyBaaG91ICgyKToKPiA+ID4gPiAgIGRldmNvcmVkdW1wOiBhZGQgbmV3
IEFQSXMgdG8gc3VwcG9ydCBtaWdyYXRpb24gb2YgdXNlcnMgZnJvbSBvbGQKPiA+ID4gPiAgICAg
ZGV2aWNlIGNvcmVkdW1wIHJlbGF0ZWQgQVBJcwo+ID4gPiA+ICAgbXdpZmlleDogZml4IHNsZWVw
IGluIGF0b21pYyBjb250ZXh0IGJ1Z3MgY2F1c2VkIGJ5IGRldl9jb3JlZHVtcHYKPiA+ID4gCj4g
PiA+IEkgd291bGQgaGF2ZSBleHBlY3RlZCBhIHRoaXJkIHBhdGNoIGluIGhlcmUsIHRoYXQgYWN0
dWFsbHkgY29udmVydHMKPiA+ID4gZXhpc3RpbmcgdXNlcnMuIFRoZW4gaW4gdGhlIGZvbGxvd2lu
ZyByZWxlYXNlIGN5Y2xlLCBjbGVhbiB1cCBhbnkgbmV3Cj4gPiA+IHVzZXJzIG9mIHRoZSBvbGQg
QVBJIHRoYXQgcG9wIHVwIGluIHRoZSBtZWFudGltZSBhbmQgZHJvcCB0aGUgb2xkIEFQSS4KPiA+
ID4gCj4gPiA+IEJ1dCBJJ2xsIGRlZmVyIHRvIHRoZSBwZW9wbGUgd2hvIHdvdWxkIGFjdHVhbGx5
IGJlIG1lcmdpbmcgeW91ciBjb2RlLgo+ID4gPiBUZWNobmljYWxseSBpdCBjb3VsZCBhbHNvIHdv
cmsgdG8gc2ltcGx5IHByb3ZpZGUgdGhlIEFQSSB0aGlzIGN5Y2xlLAo+ID4gPiBhbmQgY29udmVy
dCBldmVyeW9uZSBpbiB0aGUgbmV4dC4KPiA+IAo+ID4gVGhhbmsgeW91ciBmb3IgeW91ciB0aW1l
IGFuZCByZXBseS4KPiA+IAo+ID4gSWYgdGhpcyBwYXRjaCBzZXQgaXMgbWVyZ2VkIGludG8gdGhl
IGxpbnV4LW5leHQgdHJlZSwgSSB3aWxsIHNlbmQgdGhlIAo+ID4gdGhpcmQgcGF0Y2ggd2hpY2gg
dGFyZ2V0cyBhdCBsaW51eC1uZXh0IHRyZWUgYW5kIGNvbnZlcnRzIGV4aXN0aW5nIHVzZXJzIAo+
ID4gYXQgbGF0ZXIgdGltZXIgb2YgdGhpcyByZWxlYXNlIGN5Y2xlLiBCZWNhdXNlIHRoZXJlIGFy
ZSBuZXcgdXNlcnMgdGhhdCAKPiA+IG1heSB1c2UgdGhlIG9sZCBBUElzIGNvbWVzIGludG8gbGlu
dXgtbmV4dCB0cmVlIGR1cmluZyB0aGUgcmVtYWluaW5nIHRpbWUKPiA+IG9mIHRoaXMgcmVsZWFz
ZSBjeWNsZS4KPiAKPiBObywgdGhhdCdzIG5vdCBob3cgdGhpcyB3b3Jrcywgd2UgY2FuJ3QgYWRk
IHBhdGNoZXMgd2l0aCBuZXcgZnVuY3Rpb25zCj4gdGhhdCBubyBvbmUgdXNlcy4gIEFuZCBpdCdz
IG5vdCBob3cgSSBhc2tlZCBmb3IgdGhpcyBhcGkgdG8gYmUgbWlncmF0ZWQKPiBvdmVyIHRpbWUg
cHJvcGVybHkuICBJJ2xsIHRyeSB0byByZXNwb25kIHRvIHlvdXIgcGF0Y2ggd2l0aCBtb3JlIGRl
dGFpbHMKPiBpbiBhIHdlZWsgb3Igc28gd2hlbiBJIGNhdGNoIHVwIG9uIHBhdGNoIHJldmlldy4u
LgoKVGhhbmsgeW91IGZvciB5b3VyIHRpbWUgYW5kIEkgbG9vayBmb3J3YXJkIHRvIHlvdXIgcmVw
bHkuCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==
