Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CEF4F8C74
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 05:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbiDHCyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 22:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiDHCyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 22:54:44 -0400
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2F0C1546AD;
        Thu,  7 Apr 2022 19:52:39 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Fri, 8 Apr 2022 10:52:05
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.67.219]
Date:   Fri, 8 Apr 2022 10:52:05 +0800 (GMT+08:00)
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
Subject: Re: RE: RE: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock
 in irdma_cleanup_cm_core()
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.8 build 20200806(7a9be5e8)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <MWHPR11MB00294A328036566B01917A5CE9E99@MWHPR11MB0029.namprd11.prod.outlook.com>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
 <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
 <20220407142908.GO12805@kadam>
 <MWHPR11MB00293D107510E728769874DFE9E69@MWHPR11MB0029.namprd11.prod.outlook.com>
 <7775f2d3.3fd15.18006994530.Coremail.duoming@zju.edu.cn>
 <MWHPR11MB00294A328036566B01917A5CE9E99@MWHPR11MB0029.namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <7898f6c.4051b.180071605cc.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgDnaRBVo09iGNPqAA--.34730W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgYOAVZdtZFWjwAAs9
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBGcmksIDggQXByIDIwMjIgMDI6MjE6NTkgKzAwMDAgU2FsZWVtLCBTaGlyYXog
d3JvdGU6Cgo+ID4gPiA+ID4gPiA+IFRoZXJlIGlzIGEgZGVhZGxvY2sgaW4gaXJkbWFfY2xlYW51
cF9jbV9jb3JlKCksIHdoaWNoIGlzIHNob3duCj4gPiA+ID4gPiA+ID4gYmVsb3c6Cj4gPiA+ID4g
PiA+ID4KPiA+ID4gPiA+ID4gPiAgICAoVGhyZWFkIDEpICAgICAgICAgICAgICB8ICAgICAgKFRo
cmVhZCAyKQo+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgaXJkbWFf
c2NoZWR1bGVfY21fdGltZXIoKQo+ID4gPiA+ID4gPiA+IGlyZG1hX2NsZWFudXBfY21fY29yZSgp
ICAgIHwgIGFkZF90aW1lcigpCj4gPiA+ID4gPiA+ID4gIHNwaW5fbG9ja19pcnFzYXZlKCkgLy8o
MSkgfCAgKHdhaXQgYSB0aW1lKQo+ID4gPiA+ID4gPiA+ICAuLi4gICAgICAgICAgICAgICAgICAg
ICAgIHwgaXJkbWFfY21fdGltZXJfdGljaygpCj4gPiA+ID4gPiA+ID4gIGRlbF90aW1lcl9zeW5j
KCkgICAgICAgICAgfCAgc3Bpbl9sb2NrX2lycXNhdmUoKSAvLygyKQo+ID4gPiA+ID4gPiA+ICAo
d2FpdCB0aW1lciB0byBzdG9wKSAgICAgIHwgIC4uLgo+ID4gPiA+ID4gPiA+Cj4gPiA+ID4gPiA+
ID4gV2UgaG9sZCBjbV9jb3JlLT5odF9sb2NrIGluIHBvc2l0aW9uICgxKSBvZiB0aHJlYWQgMSBh
bmQgdXNlCj4gPiA+ID4gPiA+ID4gZGVsX3RpbWVyX3N5bmMoKSB0byB3YWl0IHRpbWVyIHRvIHN0
b3AsIGJ1dCB0aW1lciBoYW5kbGVyIGFsc28KPiA+ID4gPiA+ID4gPiBuZWVkIGNtX2NvcmUtPmh0
X2xvY2sgaW4gcG9zaXRpb24gKDIpIG9mIHRocmVhZCAyLgo+ID4gPiA+ID4gPiA+IEFzIGEgcmVz
dWx0LCBpcmRtYV9jbGVhbnVwX2NtX2NvcmUoKSB3aWxsIGJsb2NrIGZvcmV2ZXIuCj4gPiA+ID4g
PiA+ID4KPiA+ID4gPiA+ID4gPiBUaGlzIHBhdGNoIGV4dHJhY3RzIGRlbF90aW1lcl9zeW5jKCkg
ZnJvbSB0aGUgcHJvdGVjdGlvbiBvZgo+ID4gPiA+ID4gPiA+IHNwaW5fbG9ja19pcnFzYXZlKCks
IHdoaWNoIGNvdWxkIGxldCB0aW1lciBoYW5kbGVyIHRvIG9idGFpbgo+ID4gPiA+ID4gPiA+IHRo
ZSBuZWVkZWQgbG9jay4KPiA+ID4gPiA+ID4gPgo+ID4gPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6
IER1b21pbmcgWmhvdSA8ZHVvbWluZ0B6anUuZWR1LmNuPgo+ID4gPiA+ID4gPiA+IC0tLQo+ID4g
PiA+ID4gPiA+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY20uYyB8IDUgKysrKy0KPiA+
ID4gPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQo+ID4gPiA+ID4gPiA+Cj4gPiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5maW5p
YmFuZC9ody9pcmRtYS9jbS5jCj4gPiA+ID4gPiA+ID4gYi9kcml2ZXJzL2luZmluaWJhbmQvaHcv
aXJkbWEvY20uYwo+ID4gPiA+ID4gPiA+IGluZGV4IGRlZGIzYjdlZGQ4Li4wMTlkZDhiZmUwOCAx
MDA2NDQKPiA+ID4gPiA+ID4gPiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvaXJkbWEvY20u
Ywo+ID4gPiA+ID4gPiA+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9pcmRtYS9jbS5jCj4g
PiA+ID4gPiA+ID4gQEAgLTMyNTIsOCArMzI1MiwxMSBAQCB2b2lkIGlyZG1hX2NsZWFudXBfY21f
Y29yZShzdHJ1Y3QKPiA+ID4gPiBpcmRtYV9jbV9jb3JlICpjbV9jb3JlKQo+ID4gPiA+ID4gPiA+
ICAJCXJldHVybjsKPiA+ID4gPiA+ID4gPgo+ID4gPiA+ID4gPiA+ICAJc3Bpbl9sb2NrX2lycXNh
dmUoJmNtX2NvcmUtPmh0X2xvY2ssIGZsYWdzKTsKPiA+ID4gPiA+ID4gPiAtCWlmICh0aW1lcl9w
ZW5kaW5nKCZjbV9jb3JlLT50Y3BfdGltZXIpKQo+ID4gPiA+ID4gPiA+ICsJaWYgKHRpbWVyX3Bl
bmRpbmcoJmNtX2NvcmUtPnRjcF90aW1lcikpIHsKPiA+ID4gPiA+ID4gPiArCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZjbV9jb3JlLT5odF9sb2NrLCBmbGFncyk7Cj4gPiA+ID4gPiA+ID4gIAkJ
ZGVsX3RpbWVyX3N5bmMoJmNtX2NvcmUtPnRjcF90aW1lcik7Cj4gPiA+ID4gPiA+ID4gKwkJc3Bp
bl9sb2NrX2lycXNhdmUoJmNtX2NvcmUtPmh0X2xvY2ssIGZsYWdzKTsKPiA+ID4gPiA+ID4gPiAr
CX0KPiA+ID4gPiA+ID4gPiAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmNtX2NvcmUtPmh0X2xv
Y2ssIGZsYWdzKTsKPiA+ID4gPiA+ID4KPiA+ID4gPiA+ID4gVGhpcyBsb2NrIGRvZXNuJ3Qgc2Vl
bSB0byBiZSBwcm90ZWN0aW5nIGFueXRoaW5nLiAgQWxzbyBkbyB3ZQo+ID4gPiA+ID4gPiBuZWVk
IHRvIGNoZWNrIHRpbWVyX3BlbmRpbmcoKT8gIEkgdGhpbmsgdGhlIGRlbF90aW1lcl9zeW5jKCkK
PiA+ID4gPiA+ID4gZnVuY3Rpb24gd2lsbCBqdXN0IHJldHVybiBkaXJlY3RseSBpZiB0aGVyZSBp
c24ndCBhIHBlbmRpbmcgbG9jaz8KPiA+ID4gPiA+Cj4gPiA+ID4gPiBUaGFua3MgYSBsb3QgZm9y
IHlvdXIgYWR2aWNlLCBJIHdpbGwgcmVtb3ZlIHRoZSB0aW1lcl9wZW5kaW5nKCkKPiA+ID4gPiA+
IGFuZCB0aGUgcmVkdW5kYW50IGxvY2suCj4gPiA+ID4KPiA+ID4gPiBJIGRpZG4ndCBnaXZlIGFu
eSBhZHZpY2UuIDpQIEkgb25seSBhc2sgcXVlc3Rpb25zIHdoZW4gSSBkb24ndCBrbm93IHRoZSBh
bnN3ZXJzLgo+ID4gPiA+IFNvbWVvbmUgcHJvYmFibHkgbmVlZHMgdG8gbG9vayBhdCAmY21fY29y
ZS0+aHRfbG9jayBhbmQgZmlndXJlIG91dAo+ID4gPiA+IHdoYXQgaXQncyBwcm90ZWN0aW5nLgo+
ID4gPiA+Cj4gPiA+IEFncmVlZCBvbiB0aGlzIGZpeC4KPiA+ID4KPiA+ID4gV2Ugc2hvdWxkIG5v
dCBsb2NrIGFyb3VuZCBkZWxfdGltZXJfc3luYyBvciBuZWVkIHRvIGNoZWNrIG9uIHRpbWVyX3Bl
bmRpbmcuCj4gPiA+Cj4gPiA+IEhvd2V2ZXIsIHdlIGRvIG5lZWQgc2VyaWFsaXplIGFkZGl0aW9u
IG9mIGEgdGltZXIgd2hpY2ggY2FuIGJlIGNhbGxlZCBmcm9tCj4gPiBtdWx0aXBsZSBwYXRocywg
aS5lLiB0aGUgdGltZXIgaGFuZGxlciBhbmQgaXJkbWFfc2NoZWR1bGVfY21fdGltZXIuCj4gPiAK
PiA+IEkgdGhpbmsgd2Ugc2hvdWxkIHJlcGxhY2UgdGhlIGNoZWNrICJpZiAoIXRpbWVyX3BlbmRp
bmcoJmNtX2NvcmUtPnRjcF90aW1lcikpIiB0bwo+ID4gImlmICh0aW1lcl9wZW5kaW5nKCZjbV9j
b3JlLT50Y3BfdGltZXIpKSIgaW4gaXJkbWFfY21fdGltZXJfdGljaygpLCBhbmQgcmVwbGFjZSAi
aWYKPiA+ICghd2FzX3RpbWVyX3NldCkiIHRvICJpZiAod2FzX3RpbWVyX3NldCkiIGluIGlyZG1h
X3NjaGVkdWxlX2NtX3RpbWVyKCkgaW4gb3JkZXIgdG8KPiA+IGd1YXJhbnRlZSB0aGUgdGltZXIg
Y291bGQgYmUgZXhlY3V0ZWQuIEkgd2lsbCBzZW5kIHRoZSBtb2RpZmllZCBwYXRjaCBhcyBzb29u
IGFzCj4gPiBwb3NzaWJsZS4KPiA+IAo+IAo+IE5vIHdlIGRvbuKAmXQgYXJtIHRoZSB0aW1lciBp
ZiB0aGVyZSdzIGlzIG9uZSBwZW5kaW5nLiBJdHMgYWxzbyBhIGJ1ZyB0byBkbyBzby4gCj4gCj4g
aHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjUuMTgtcmMxL3NvdXJjZS9rZXJuZWwv
dGltZS90aW1lci5jI0wxMTQzCgpZb3UgYXJlIHJpZ2h0LCBJIHRoaW5rIHdlIGNvdWxkIGFkZCAi
bW9kX3RpbWVyIiBpbiBpcmRtYV9zY2hlZHVsZV9jbV90aW1lciBhbmQKaXJkbWFfY21fdGltZXJf
dGljaygpIGluIG9yZGVyIHRvIHN0YXJ0IHRpbWVyLiAKCkkgd2lsbCBzZW5kIFtQQVRDSCBWNCAw
OS8xMV0gZHJpdmVyczogaW5maW5pYmFuZDogaHc6IEZpeCBkZWFkbG9jayBpbiBpcmRtYV9jbGVh
bnVwX2NtX2NvcmUoKS4KCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQ==
