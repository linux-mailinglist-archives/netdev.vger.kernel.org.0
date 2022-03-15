Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B54D9D0B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348890AbiCOOMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348850AbiCOOMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:12:48 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 82D49546B5;
        Tue, 15 Mar 2022 07:11:30 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Tue, 15 Mar 2022 22:11:10
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.64.209]
Date:   Tue, 15 Mar 2022 22:11:10 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5ZGo5aSa5piO?= <duoming@zju.edu.cn>
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, jreuter@yaina.de, thomas@osterried.de
Subject: Re: Re: [PATCH net V4 1/2] ax25: Fix refcount leaks caused by
 ax25_cb_del()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220315102657.GX3315@kadam>
References: <20220315015403.79201-1-duoming@zju.edu.cn>
 <20220315102657.GX3315@kadam>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <15e4111b.5339.17f8deb1f24.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDn77N+njBiObIWAA--.2995W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgwKAVZdtYsAUQABsg
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

SGVsbG8sCgpPbiBUdWUsIDE1IE1hciAyMDIyIDEzOjI2OjU3ICswMzAwLCBEYW4gQ2FycGVudGVy
IHdyb3RlOgo+IEknbSBoYXBweSB0aGF0IHRoaXMgaXMgc2ltcGxlci4gIEknbSBub3Qgc3VwZXIg
aGFwcHkgYWJvdXQgdGhlCj4gaWYgKHNrLT5za193cSkgY2hlY2suICBUaGF0IHNlZW1zIGxpa2Ug
YSBmcmFnaWxlIHNpZGUtZWZmZWN0IGNvbmRpdGlvbgo+IGluc3RlYWQgb2Ygc29tZXRoaW5nIGRl
bGliZXJhdGUuICBCdXQgSSBkb24ndCBrbm93IG5ldHdvcmtpbmcgc28gbWF5YmUKPiB0aGlzIGlz
IHNvbWV0aGluZyB3aGljaCB3ZSBjYW4gcmVseSBvbi4KClRoZSB2YXJpYWJsZSBzay0+c2tfd3Eg
aXMgdGhlIGFkZHJlc3Mgb2Ygd2FpdGluZyBxdWV1ZSBvZiBzb2NrLCBpdCBpcyBpbml0aWFsaXpl
ZCB0byB0aGUgCmFkZHJlc3Mgb2Ygc29jay0+d3EgdGhyb3VnaCB0aGUgZm9sbG93aW5nIHBhdGg6
CnNvY2tfY3JlYXRlLT5fX3NvY2tfY3JlYXRlLT5heDI1X2NyZWF0ZSgpLT5zb2NrX2luaXRfZGF0
YSgpLT5SQ1VfSU5JVF9QT0lOVEVSKHNrLT5za193cSwgJnNvY2stPndxKS4KQmVjYXVzZSB3ZSBo
YXZlIHVzZWQgc29ja19hbGxvYygpIHRvIGFsbG9jYXRlIHRoZSBzb2NrZXQgaW4gX19zb2NrX2Ny
ZWF0ZSgpLCBzb2NrIG9yIHRoZSBhZGRyZXNzIG9mCnNvY2stPndxIGlzIG5vdCBudWxsLgpXaGF0
YHMgbW9yZSwgc2stPnNrX3dxIGlzIHNldCB0byBudWxsIG9ubHkgaW4gc29ja19vcnBoYW4oKS4K
CkFub3RoZXIgc29sdXRpb246CldlIGNvdWxkIGFsc28gdXNlIHNrLT5za19zb2NrZXQgdG8gY2hl
Y2suIFdlIHNldCBzay0+c2tfc29ja2V0IHRvIHNvY2sgaW4gdGhlIGZvbGxvd2luZyBwYXRoOgpz
b2NrX2NyZWF0ZSgpLT5fX3NvY2tfY3JlYXRlKCktPmF4MjVfY3JlYXRlKCktPnNvY2tfaW5pdF9k
YXRhKCktPnNrX3NldF9zb2NrZXQoc2ssIHNvY2spLgpCZWNhdXNlIHdlIGhhdmUgdXNlZCBzb2Nr
X2FsbG9jKCkgdG8gYWxsb2NhdGUgdGhlIHNvY2tldCBpbiBfX3NvY2tfY3JlYXRlKCksIHNvY2sg
b3Igc2stPnNrX3NvY2tldAppcyBub3QgbnVsbC4KV2hhdGBzIG1vcmUsIHNrLT5za19zb2NrZXQg
aXMgc2V0IHRvIG51bGwgb25seSBpbiBzb2NrX29ycGhhbigpLgoKSSB3aWxsIGNoYW5nZSB0aGUg
aWYgKHNrLT5za193cSkgY2hlY2sgdG8gaWYoc2stPnNrX3NvY2tldCkgY2hlY2ssIGJlY2F1c2Ug
SSB0aGluayBpdCBpcyAKZWFzaWVyIHRvIHVuZGVyc3RhbmQuCgo+IFdoZW4geW91IHNlbnQgdGhl
IGVhcmxpZXIgcGF0Y2ggdGhlbiBJIGFza2VkIGlmIHRoZSBkZXZpY2VzIGluCj4gYXgyNV9raWxs
X2J5X2RldmljZSgpIHdlcmUgYWx3YXlzIGJvdW5kIGFuZCBpZiB3ZSBjb3VsZCBqdXN0IHVzZSBh
IGxvY2FsCj4gdmFyaWFibGUgaW5zdGVhZCBvZiBzb21ldGhpbmcgdGllZCB0byB0aGUgYXgyNV9k
ZXYgc3RydWN0LiAgSSBzdGlsbAo+IHdvbmRlciBhYm91dCB0aGF0LiAgSW4gb3RoZXIgd29yZHMs
IGNvdWxkIHdlIGp1c3QgZG8gdGhpcz8KPiAKPiBkaWZmIC0tZ2l0IGEvbmV0L2F4MjUvYWZfYXgy
NS5jIGIvbmV0L2F4MjUvYWZfYXgyNS5jCj4gaW5kZXggNmJkMDk3MTgwNzcyLi40YWY5ZDlhOTM5
YzYgMTAwNjQ0Cj4gLS0tIGEvbmV0L2F4MjUvYWZfYXgyNS5jCj4gKysrIGIvbmV0L2F4MjUvYWZf
YXgyNS5jCj4gQEAgLTc4LDYgKzc4LDcgQEAgc3RhdGljIHZvaWQgYXgyNV9raWxsX2J5X2Rldmlj
ZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQo+ICAJYXgyNV9kZXYgKmF4MjVfZGV2Owo+ICAJYXgy
NV9jYiAqczsKPiAgCXN0cnVjdCBzb2NrICpzazsKPiArCWJvb2wgZm91bmQgPSBmYWxzZTsKPiAg
Cj4gIAlpZiAoKGF4MjVfZGV2ID0gYXgyNV9kZXZfYXgyNWRldihkZXYpKSA9PSBOVUxMKQo+ICAJ
CXJldHVybjsKPiBAQCAtODYsNiArODcsNyBAQCBzdGF0aWMgdm9pZCBheDI1X2tpbGxfYnlfZGV2
aWNlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpCj4gIGFnYWluOgo+ICAJYXgyNV9mb3JfZWFjaChz
LCAmYXgyNV9saXN0KSB7Cj4gIAkJaWYgKHMtPmF4MjVfZGV2ID09IGF4MjVfZGV2KSB7Cj4gKwkJ
CWZvdW5kID0gdHJ1ZTsKPiAgCQkJc2sgPSBzLT5zazsKPiAgCQkJaWYgKCFzaykgewo+ICAJCQkJ
c3Bpbl91bmxvY2tfYmgoJmF4MjVfbGlzdF9sb2NrKTsKPiBAQCAtMTE1LDYgKzExNywxMSBAQCBz
dGF0aWMgdm9pZCBheDI1X2tpbGxfYnlfZGV2aWNlKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpCj4g
IAkJfQo+ICAJfQo+ICAJc3Bpbl91bmxvY2tfYmgoJmF4MjVfbGlzdF9sb2NrKTsKPiArCj4gKwlp
ZiAoIWZvdW5kKSB7Cj4gKwkJZGV2X3B1dF90cmFjayhheDI1X2Rldi0+ZGV2LCAmYXgyNV9kZXYt
PmRldl90cmFja2VyKTsKPiArCQlheDI1X2Rldl9wdXQoYXgyNV9kZXYpOwo+ICsJfQo+ICB9CgpJ
ZiB3ZSBqdXN0IHVzZSBheDI1X2Rldl9kZXZpY2VfdXAoKSB0byBicmluZyBkZXZpY2UgdXAgd2l0
aG91dCB1c2luZyBheDI1X2JpbmQoKSwKdGhlICJmb3VuZCIgZmxhZyBjb3VsZCBiZSBmYWxzZSB3
aGVuIHdlIGVudGVyIGF4MjVfa2lsbF9ieV9kZXZpY2UoKSBhbmQgdGhlIHJlZmNvdW50cyAKdW5k
ZXJmbG93IHdpbGwgaGFwcGVuLiBTbyB3ZSBzaG91bGQgdXNlIHR3byBhZGRpdGlvbmFsIHZhcmlh
Ymxlcy4KCklmIHdlIHVzZSBhZGRpdGlvbmFsIHZhcmlhYmxlcyB0byBmaXggdGhlIGJ1ZywgSSB0
aGluayB0aGVyZSBpcyBhIHByb2JsZW0uCkluIHRoZSByZWFsIHdvcmxkLCB0aGUgZGV2aWNlIGNv
dWxkIGJlIGRldGFjaGVkIG9ubHkgb25jZS4gSWYgdGhlIGZvbGxvd2luZwpyYWNlIGNvbmRpdGlv
biBoYXBwZW5zLCB3ZSBjb3VsZCBub3QgZGVhbGxvY2F0ZSBheDI1X2RldiBhbmQgbmV0X2Rldmlj
ZSBhbnltb3JlLApiZWNhdXNlIHdlIGNvdWxkIG5vdCBjYWxsIGF4MjVfa2lsbF9ieV9kZXZpY2Uo
KSBhZ2Fpbi4KCiAgICAgICAoVGhyZWFkIDEpICAgICAgICAgICAgICAgICB8ICAgICAgKFRocmVh
ZCAyKQogICAgYXgyNV9iaW5kKCkgICAgICAgICAgICAgICAgICAgfAogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgYXgyNV9raWxsX2J5X2RldmljZSgpIC8vZGVjcmVhc2UgcmVm
Y291bnRzCiAgICAgICAoVGhyZWFkIDMpICAgICAgICAgICAgICAgICB8CiAgICBheDI1X2JpbmQo
KSAgICAgICAgICAgICAgICAgICB8CiAgICAgLi4uICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgIC4uLgogICAgIGF4MjVfZGV2X2hvbGQoKSAvLygxKSAgICAgICAgfCAgCiAgICAgZGV2X2hv
bGRfdHJhY2soKSAvLygyKSAgICAgICB8ICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgIGF4MjVfZGV2X2RldmljZV9kb3duKCkKCkluIHBhdGNoICJbUEFUQ0ggbmV0IFY0IDEv
Ml0gYXgyNTogRml4IHJlZmNvdW50IGxlYWtzIGNhdXNlZCBieSBheDI1X2NiX2RlbCgpIiwKZXZl
biB0aGUgZGV2aWNlIGhhcyBiZWVuIGRldGFjaGVkLCB3ZSBjb3VsZCBhbHNvIGRlY3JlYXNlIHRo
ZSByZWZjb3VucyBieSB1c2luZwpheDI1X3JlbGVhc2UoKSwgd2hpY2ggY291bGQgZW5zdXJlIGF4
MjVfZGV2IGFuZCBuZXRfZGV2aWNlIGNvdWxkIGJlIGRlYWxsb2NhdGVkLgpTbyBJIHRoaW5rICJb
UEFUQ0ggbmV0IFY0IDEvMl0iIGlzIGJldHRlci4KCkJlc3Qgd2lzaGVzLApEdW9taW5nIFpob3U=

