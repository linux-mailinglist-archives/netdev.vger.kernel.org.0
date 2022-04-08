Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAEE4F8AAC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiDHAil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 20:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiDHAij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 20:38:39 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49B83106136;
        Thu,  7 Apr 2022 17:36:35 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Fri, 8 Apr 2022 08:35:49
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.67.219]
Date:   Fri, 8 Apr 2022 08:35:49 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "Dan Carpenter" <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jes@trained-monkey.org" <jes@trained-monkey.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hippi@sunsite.dk" <linux-hippi@sunsite.dk>,
        "linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: RE: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <MWHPR11MB00293D107510E728769874DFE9E69@MWHPR11MB0029.namprd11.prod.outlook.com>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
 <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
 <20220407142908.GO12805@kadam>
 <MWHPR11MB00293D107510E728769874DFE9E69@MWHPR11MB0029.namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <7775f2d3.3fd15.18006994530.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgCHj6dlg09ist7pAA--.33797W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg0OAVZdtZFLwwACsl
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

SGVsbG8sCgpPbiBUaHUsIDcgQXByIDIwMjIgMTc6MzY6MTIgKzAwMDAgU2FsZWVtLCBTaGlyYXog
d3JvdGU6CiAKPiA+IFN1YmplY3Q6IFJlOiBSZTogW1BBVENIIDA5LzExXSBkcml2ZXJzOiBpbmZp
bmliYW5kOiBodzogRml4IGRlYWRsb2NrIGluCj4gPiBpcmRtYV9jbGVhbnVwX2NtX2NvcmUoKQo+
ID4gCj4gPiBPbiBUaHUsIEFwciAwNywgMjAyMiBhdCAwODo1NDoxM1BNICswODAwLCBkdW9taW5n
QHpqdS5lZHUuY24gd3JvdGU6Cj4gPiA+IEhlbGxvLAo+ID4gPgo+ID4gPiBPbiBUaHUsIDcgQXBy
IDIwMjIgMTQ6MjQ6NTYgKzAzMDAgRGFuIENhcnBlbnRlciB3cm90ZToKPiA+ID4KPiA+ID4gPiA+
IFRoZXJlIGlzIGEgZGVhZGxvY2sgaW4gaXJkbWFfY2xlYW51cF9jbV9jb3JlKCksIHdoaWNoIGlz
IHNob3duCj4gPiA+ID4gPiBiZWxvdzoKPiA+ID4gPiA+Cj4gPiA+ID4gPiAgICAoVGhyZWFkIDEp
ICAgICAgICAgICAgICB8ICAgICAgKFRocmVhZCAyKQo+ID4gPiA+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCBpcmRtYV9zY2hlZHVsZV9jbV90aW1lcigpCj4gPiA+ID4gPiBpcmRtYV9j
bGVhbnVwX2NtX2NvcmUoKSAgICB8ICBhZGRfdGltZXIoKQo+ID4gPiA+ID4gIHNwaW5fbG9ja19p
cnFzYXZlKCkgLy8oMSkgfCAgKHdhaXQgYSB0aW1lKQo+ID4gPiA+ID4gIC4uLiAgICAgICAgICAg
ICAgICAgICAgICAgfCBpcmRtYV9jbV90aW1lcl90aWNrKCkKPiA+ID4gPiA+ICBkZWxfdGltZXJf
c3luYygpICAgICAgICAgIHwgIHNwaW5fbG9ja19pcnFzYXZlKCkgLy8oMikKPiA+ID4gPiA+ICAo
d2FpdCB0aW1lciB0byBzdG9wKSAgICAgIHwgIC4uLgo+ID4gPiA+ID4KPiA+ID4gPiA+IFdlIGhv
bGQgY21fY29yZS0+aHRfbG9jayBpbiBwb3NpdGlvbiAoMSkgb2YgdGhyZWFkIDEgYW5kIHVzZQo+
ID4gPiA+ID4gZGVsX3RpbWVyX3N5bmMoKSB0byB3YWl0IHRpbWVyIHRvIHN0b3AsIGJ1dCB0aW1l
ciBoYW5kbGVyIGFsc28KPiA+ID4gPiA+IG5lZWQgY21fY29yZS0+aHRfbG9jayBpbiBwb3NpdGlv
biAoMikgb2YgdGhyZWFkIDIuCj4gPiA+ID4gPiBBcyBhIHJlc3VsdCwgaXJkbWFfY2xlYW51cF9j
bV9jb3JlKCkgd2lsbCBibG9jayBmb3JldmVyLgo+ID4gPiA+ID4KPiA+ID4gPiA+IFRoaXMgcGF0
Y2ggZXh0cmFjdHMgZGVsX3RpbWVyX3N5bmMoKSBmcm9tIHRoZSBwcm90ZWN0aW9uIG9mCj4gPiA+
ID4gPiBzcGluX2xvY2tfaXJxc2F2ZSgpLCB3aGljaCBjb3VsZCBsZXQgdGltZXIgaGFuZGxlciB0
byBvYnRhaW4gdGhlCj4gPiA+ID4gPiBuZWVkZWQgbG9jay4KPiA+ID4gPiA+Cj4gPiA+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBEdW9taW5nIFpob3UgPGR1b21pbmdAemp1LmVkdS5jbj4KPiA+ID4gPiA+
IC0tLQo+ID4gPiA+ID4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jbS5jIHwgNSArKysr
LQo+ID4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKPiA+ID4gPiA+Cj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5kL2h3
L2lyZG1hL2NtLmMKPiA+ID4gPiA+IGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L2lyZG1hL2NtLmMK
PiA+ID4gPiA+IGluZGV4IGRlZGIzYjdlZGQ4Li4wMTlkZDhiZmUwOCAxMDA2NDQKPiA+ID4gPiA+
IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jbS5jCj4gPiA+ID4gPiArKysgYi9k
cml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY20uYwo+ID4gPiA+ID4gQEAgLTMyNTIsOCArMzI1
MiwxMSBAQCB2b2lkIGlyZG1hX2NsZWFudXBfY21fY29yZShzdHJ1Y3QKPiA+IGlyZG1hX2NtX2Nv
cmUgKmNtX2NvcmUpCj4gPiA+ID4gPiAgCQlyZXR1cm47Cj4gPiA+ID4gPgo+ID4gPiA+ID4gIAlz
cGluX2xvY2tfaXJxc2F2ZSgmY21fY29yZS0+aHRfbG9jaywgZmxhZ3MpOwo+ID4gPiA+ID4gLQlp
ZiAodGltZXJfcGVuZGluZygmY21fY29yZS0+dGNwX3RpbWVyKSkKPiA+ID4gPiA+ICsJaWYgKHRp
bWVyX3BlbmRpbmcoJmNtX2NvcmUtPnRjcF90aW1lcikpIHsKPiA+ID4gPiA+ICsJCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmNtX2NvcmUtPmh0X2xvY2ssIGZsYWdzKTsKPiA+ID4gPiA+ICAJCWRl
bF90aW1lcl9zeW5jKCZjbV9jb3JlLT50Y3BfdGltZXIpOwo+ID4gPiA+ID4gKwkJc3Bpbl9sb2Nr
X2lycXNhdmUoJmNtX2NvcmUtPmh0X2xvY2ssIGZsYWdzKTsKPiA+ID4gPiA+ICsJfQo+ID4gPiA+
ID4gIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZjbV9jb3JlLT5odF9sb2NrLCBmbGFncyk7Cj4g
PiA+ID4KPiA+ID4gPiBUaGlzIGxvY2sgZG9lc24ndCBzZWVtIHRvIGJlIHByb3RlY3RpbmcgYW55
dGhpbmcuICBBbHNvIGRvIHdlIG5lZWQKPiA+ID4gPiB0byBjaGVjayB0aW1lcl9wZW5kaW5nKCk/
ICBJIHRoaW5rIHRoZSBkZWxfdGltZXJfc3luYygpIGZ1bmN0aW9uCj4gPiA+ID4gd2lsbCBqdXN0
IHJldHVybiBkaXJlY3RseSBpZiB0aGVyZSBpc24ndCBhIHBlbmRpbmcgbG9jaz8KPiA+ID4KPiA+
ID4gVGhhbmtzIGEgbG90IGZvciB5b3VyIGFkdmljZSwgSSB3aWxsIHJlbW92ZSB0aGUgdGltZXJf
cGVuZGluZygpIGFuZAo+ID4gPiB0aGUgcmVkdW5kYW50IGxvY2suCj4gPiAKPiA+IEkgZGlkbid0
IGdpdmUgYW55IGFkdmljZS4gOlAgSSBvbmx5IGFzayBxdWVzdGlvbnMgd2hlbiBJIGRvbid0IGtu
b3cgdGhlIGFuc3dlcnMuCj4gPiBTb21lb25lIHByb2JhYmx5IG5lZWRzIHRvIGxvb2sgYXQgJmNt
X2NvcmUtPmh0X2xvY2sgYW5kIGZpZ3VyZSBvdXQgd2hhdCBpdCdzCj4gPiBwcm90ZWN0aW5nLgo+
ID4gCj4gQWdyZWVkIG9uIHRoaXMgZml4Lgo+IAo+IFdlIHNob3VsZCBub3QgbG9jayBhcm91bmQg
ZGVsX3RpbWVyX3N5bmMgb3IgbmVlZCB0byBjaGVjayBvbiB0aW1lcl9wZW5kaW5nLgo+IAo+IEhv
d2V2ZXIsIHdlIGRvIG5lZWQgc2VyaWFsaXplIGFkZGl0aW9uIG9mIGEgdGltZXIgd2hpY2ggY2Fu
IGJlIGNhbGxlZCBmcm9tIG11bHRpcGxlIHBhdGhzLCBpLmUuIHRoZSB0aW1lciBoYW5kbGVyIGFu
ZCBpcmRtYV9zY2hlZHVsZV9jbV90aW1lci4KCkkgdGhpbmsgd2Ugc2hvdWxkIHJlcGxhY2UgdGhl
IGNoZWNrICJpZiAoIXRpbWVyX3BlbmRpbmcoJmNtX2NvcmUtPnRjcF90aW1lcikpIiB0bwoiaWYg
KHRpbWVyX3BlbmRpbmcoJmNtX2NvcmUtPnRjcF90aW1lcikpIiBpbiBpcmRtYV9jbV90aW1lcl90
aWNrKCksIGFuZCByZXBsYWNlCiJpZiAoIXdhc190aW1lcl9zZXQpIiB0byAiaWYgKHdhc190aW1l
cl9zZXQpIiBpbiBpcmRtYV9zY2hlZHVsZV9jbV90aW1lcigpIGluIG9yZGVyCnRvIGd1YXJhbnRl
ZSB0aGUgdGltZXIgY291bGQgYmUgZXhlY3V0ZWQuIEkgd2lsbCBzZW5kIHRoZSBtb2RpZmllZCBw
YXRjaCBhcyBzb29uIGFzIApwb3NzaWJsZS4KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91Cgo=

