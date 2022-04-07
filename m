Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970CE4F7D82
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 13:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbiDGLIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 07:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiDGLId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 07:08:33 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 320318F9A1;
        Thu,  7 Apr 2022 04:06:24 -0700 (PDT)
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Apr 2022 19:05:54
 +0800 (GMT+08:00)
X-Originating-IP: [10.181.226.201]
Date:   Thu, 7 Apr 2022 19:05:54 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Max Filippov" <jcmvbkbc@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Chris Zankel" <chris@zankel.net>, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, jgg@ziepe.ca, wg@grandegger.com,
        mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, pabeni@redhat.com,
        jes@trained-monkey.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jiri Slaby" <jirislaby@kernel.org>, alexander.deucher@amd.com,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, linux-rdma@vger.kernel.org,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-hippi@sunsite.dk, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org,
        "USB list" <linux-usb@vger.kernel.org>, linma@zju.edu.cn
Subject: Re: Re: [PATCH 11/11] arch: xtensa: platforms: Fix deadlock in
 rs_close()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <CAMo8BfLG_u2z2HwY9Qo6cFgNoSrrz2mS2iD+rtj-uyrKhZYmLw@mail.gmail.com>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <9ca3ab0b40c875b6019f32f031c68a1ae80dd73a.1649310812.git.duoming@zju.edu.cn>
 <CAMo8BfLG_u2z2HwY9Qo6cFgNoSrrz2mS2iD+rtj-uyrKhZYmLw@mail.gmail.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <569b0b8a.3f281.18003b3c5c4.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgB3HwCSxU5iMGyRAQ--.28878W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgYNAVZdtZExiwABsc
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

SGVsbG8sCgpPbiBUaHUsIDcgQXByIDIwMjIgMDA6MjE6NTggLTA3MDAgTWF4IEZpbGlwcG92IHdy
b3RlOgoKPiA+IFRoZXJlIGlzIGEgZGVhZGxvY2sgaW4gcnNfY2xvc2UoKSwgd2hpY2ggaXMgc2hv
d24KPiA+IGJlbG93Ogo+ID4KPiA+ICAgIChUaHJlYWQgMSkgICAgICAgICAgICAgIHwgICAgICAo
VGhyZWFkIDIpCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IHJzX29wZW4oKQo+ID4g
cnNfY2xvc2UoKSAgICAgICAgICAgICAgICAgfCAgbW9kX3RpbWVyKCkKPiA+ICBzcGluX2xvY2tf
YmgoKSAvLygxKSAgICAgIHwgICh3YWl0IGEgdGltZSkKPiA+ICAuLi4gICAgICAgICAgICAgICAg
ICAgICAgIHwgcnNfcG9sbCgpCj4gPiAgZGVsX3RpbWVyX3N5bmMoKSAgICAgICAgICB8ICBzcGlu
X2xvY2soKSAvLygyKQo+ID4gICh3YWl0IHRpbWVyIHRvIHN0b3ApICAgICAgfCAgLi4uCj4gPgo+
ID4gV2UgaG9sZCB0aW1lcl9sb2NrIGluIHBvc2l0aW9uICgxKSBvZiB0aHJlYWQgMSBhbmQKPiA+
IHVzZSBkZWxfdGltZXJfc3luYygpIHRvIHdhaXQgdGltZXIgdG8gc3RvcCwgYnV0IHRpbWVyIGhh
bmRsZXIKPiA+IGFsc28gbmVlZCB0aW1lcl9sb2NrIGluIHBvc2l0aW9uICgyKSBvZiB0aHJlYWQg
Mi4KPiA+IEFzIGEgcmVzdWx0LCByc19jbG9zZSgpIHdpbGwgYmxvY2sgZm9yZXZlci4KPiAKPiBJ
IGFncmVlIHdpdGggdGhpcy4KPiAKPiA+IFRoaXMgcGF0Y2ggZXh0cmFjdHMgZGVsX3RpbWVyX3N5
bmMoKSBmcm9tIHRoZSBwcm90ZWN0aW9uIG9mCj4gPiBzcGluX2xvY2tfYmgoKSwgd2hpY2ggY291
bGQgbGV0IHRpbWVyIGhhbmRsZXIgdG8gb2J0YWluCj4gPiB0aGUgbmVlZGVkIGxvY2suCj4gCj4g
TG9va2luZyBhdCB0aGUgdGltZXJfbG9jayBJIGRvbid0IHJlYWxseSB1bmRlcnN0YW5kIHdoYXQg
aXQgcHJvdGVjdHMuCj4gSXQgbG9va3MgbGlrZSBpdCBpcyBub3QgbmVlZGVkIGF0IGFsbC4KClRo
ZXJlIGlzIG5vIHJhY2UgY29uZGl0aW9uIGJldHdlZW4gcnNfY2xvc2UgYW5kIHJzX3BvbGwodGlt
ZXIgaGFuZGxlciksCkkgdGhpbmsgd2UgY291bGQgcmVtb3ZlIHRoZSB0aW1lcl9sb2NrIGluIHJz
X2Nsb3NlKCksIHJzX29wZW4oKSBhbmQgcnNfcG9sbCgpLgoKPiBBbHNvLCBJIHNlZSB0aGF0IHJz
X3BvbGwgcmV3aW5kcyB0aGUgdGltZXIgcmVnYXJkbGVzcyBvZiB3aGV0aGVyIGRlbF90aW1lcl9z
eW5jCj4gd2FzIGNhbGxlZCBvciBub3QsIHdoaWNoIHZpb2xhdGVzIGRlbF90aW1lcl9zeW5jIHJl
cXVpcmVtZW50cy4KCkkgd3JvdGUgYSBrZXJuZWwgbW9kdWxlIHRvIHRlc3Qgd2hldGhlciBkZWxf
dGltZXJfc3luYygpIGNvdWxkIGZpbmlzaCBhIHRpbWVyIGhhbmRsZXIKdGhhdCB1c2UgbW9kX3Rp
bWVyKCkgdG8gcmV3aW5kIGl0c2VsZi4gVGhlIGZvbGxvd2luZyBpcyB0aGUgcmVzdWx0LgoKIyBp
bnNtb2QgZGVsX3RpbWVyX3N5bmMua28gClsgIDkyOS4zNzQ0MDVdIG15X3RpbWVyIHdpbGwgYmUg
Y3JlYXRlLgpbICA5MjkuMzc0NzM4XSB0aGUgamlmZmllcyBpcyA6NDI5NTU5NTU3MgpbICA5MzAu
NDExNTgxXSBJbiBteV90aW1lcl9mdW5jdGlvbgpbICA5MzAuNDExOTU2XSB0aGUgamlmZmllcyBp
cyA0Mjk1NTk2NjA5ClsgIDkzNS40NjY2NDNdIEluIG15X3RpbWVyX2Z1bmN0aW9uClsgIDkzNS40
Njc1MDVdIHRoZSBqaWZmaWVzIGlzIDQyOTU2MDE2NjUKWyAgOTQwLjU4NjUzOF0gSW4gbXlfdGlt
ZXJfZnVuY3Rpb24KWyAgOTQwLjU4NjkxNl0gdGhlIGppZmZpZXMgaXMgNDI5NTYwNjc4NApbICA5
NDUuNzA2NTc5XSBJbiBteV90aW1lcl9mdW5jdGlvbgpbICA5NDUuNzA2ODg1XSB0aGUgamlmZmll
cyBpcyA0Mjk1NjExOTA0CgojIAojIHJtbW9kIGRlbF90aW1lcl9zeW5jLmtvClsgIDk0OC41MDc2
OTJdIHRoZSBkZWxfdGltZXJfc3luYyBpcyA6MQpbICA5NDguNTA3NjkyXSAKIyAKIyAKClRoZSBy
ZXN1bHQgb2YgdGhlIGV4cGVyaW1lbnQgc2hvd3MgdGhhdCB0aGUgdGltZXIgaGFuZGxlciBjb3Vs
ZApiZSBraWxsZWQgYWZ0ZXIgd2UgZXhlY3V0ZSBkZWxfdGltZXJfc3luYygpLgoKPiA+IFNpZ25l
ZC1vZmYtYnk6IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPgo+ID4gLS0tCj4gPiAg
YXJjaC94dGVuc2EvcGxhdGZvcm1zL2lzcy9jb25zb2xlLmMgfCA0ICsrKy0KPiA+ICAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gPgo+ID4gZGlmZiAtLWdp
dCBhL2FyY2gveHRlbnNhL3BsYXRmb3Jtcy9pc3MvY29uc29sZS5jIGIvYXJjaC94dGVuc2EvcGxh
dGZvcm1zL2lzcy9jb25zb2xlLmMKPiA+IGluZGV4IDgxZDdjN2U4ZjdlLi5kNDMxYjYxYWUzYyAx
MDA2NDQKPiA+IC0tLSBhL2FyY2gveHRlbnNhL3BsYXRmb3Jtcy9pc3MvY29uc29sZS5jCj4gPiAr
KysgYi9hcmNoL3h0ZW5zYS9wbGF0Zm9ybXMvaXNzL2NvbnNvbGUuYwo+ID4gQEAgLTUxLDggKzUx
LDEwIEBAIHN0YXRpYyBpbnQgcnNfb3BlbihzdHJ1Y3QgdHR5X3N0cnVjdCAqdHR5LCBzdHJ1Y3Qg
ZmlsZSAqIGZpbHApCj4gPiAgc3RhdGljIHZvaWQgcnNfY2xvc2Uoc3RydWN0IHR0eV9zdHJ1Y3Qg
KnR0eSwgc3RydWN0IGZpbGUgKiBmaWxwKQo+ID4gIHsKPiA+ICAgICAgICAgc3Bpbl9sb2NrX2Jo
KCZ0aW1lcl9sb2NrKTsKPiA+IC0gICAgICAgaWYgKHR0eS0+Y291bnQgPT0gMSkKPiA+ICsgICAg
ICAgaWYgKHR0eS0+Y291bnQgPT0gMSkgewo+ID4gKyAgICAgICAgICAgICAgIHNwaW5fdW5sb2Nr
X2JoKCZ0aW1lcl9sb2NrKTsKPiA+ICAgICAgICAgICAgICAgICBkZWxfdGltZXJfc3luYygmc2Vy
aWFsX3RpbWVyKTsKPiA+ICsgICAgICAgfQo+ID4gICAgICAgICBzcGluX3VubG9ja19iaCgmdGlt
ZXJfbG9jayk7Cj4gCj4gTm93IGluIGNhc2UgdHR5LT5jb3VudCA9PSAxIHRoZSB0aW1lcl9sb2Nr
IHdvdWxkIGJlIHVubG9ja2VkIHR3aWNlLgoKSSB3aWxsIHJlbW92ZSB0aGUgdGltZXJfbG9jayBp
biByc19jbG9zZSgpLCByc19vcGVuKCkgYW5kIHJzX3BvbGwoKS4KClRoYW5rcyBhIGxvdCBmb3Ig
eW91ciB0aW1lIGFuZCBhZHZpY2UhCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==
