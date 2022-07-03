Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF6E564386
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 02:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiGCAnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 20:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiGCAnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 20:43:32 -0400
Received: from azure-sdnproxy-3.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id C1663B1EE;
        Sat,  2 Jul 2022 17:43:29 -0700 (PDT)
Received: by ajax-webmail-mail-app4 (Coremail) ; Sun, 3 Jul 2022 08:43:10
 +0800 (GMT+08:00)
X-Originating-IP: [221.192.179.62]
Date:   Sun, 3 Jul 2022 08:43:10 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   duoming@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH v4] net: rose: fix null-ptr-deref caused by
 rose_kill_by_neigh
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220702120108.32985427@kernel.org>
References: <20220629104941.26351-1-duoming@zju.edu.cn>
 <20220701194155.5bd61e58@kernel.org>
 <1bbd2137.23c51.181bdcb792f.Coremail.duoming@zju.edu.cn>
 <20220702120108.32985427@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <194120ff.22ed2.181c182e706.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgC3COEf5sBi5IkHAw--.64853W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgkAAVZdtagNRwACsU
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sCgpPbiBTYXQsIDIgSnVsIDIwMjIgMTI6MDE6MDggLTA3MDAgSmFrdWIgS2ljaW5za2kg
d3JvdGU6Cgo+IE9uIFNhdCwgMiBKdWwgMjAyMiAxNToyMzo1NyArMDgwMCAoR01UKzA4OjAwKSBk
dW9taW5nQHpqdS5lZHUuY24gd3JvdGU6Cj4gPiA+IE9uIFdlZCwgMjkgSnVuIDIwMjIgMTg6NDk6
NDEgKzA4MDAgRHVvbWluZyBaaG91IHdyb3RlOiAgCj4gPiA+ID4gV2hlbiB0aGUgbGluayBsYXll
ciBjb25uZWN0aW9uIGlzIGJyb2tlbiwgdGhlIHJvc2UtPm5laWdoYm91ciBpcwo+ID4gPiA+IHNl
dCB0byBudWxsLiBCdXQgcm9zZS0+bmVpZ2hib3VyIGNvdWxkIGJlIHVzZWQgYnkgcm9zZV9jb25u
ZWN0aW9uKCkKPiA+ID4gPiBhbmQgcm9zZV9yZWxlYXNlKCkgbGF0ZXIsIGJlY2F1c2UgdGhlcmUg
aXMgbm8gc3luY2hyb25pemF0aW9uIGFtb25nCj4gPiA+ID4gdGhlbS4gQXMgYSByZXN1bHQsIHRo
ZSBudWxsLXB0ci1kZXJlZiBidWdzIHdpbGwgaGFwcGVuLgo+ID4gPiA+IAo+ID4gPiA+IE9uZSBv
ZiB0aGUgbnVsbC1wdHItZGVyZWYgYnVncyBpcyBzaG93biBiZWxvdzoKPiA+ID4gPiAKPiA+ID4g
PiAgICAgKHRocmVhZCAxKSAgICAgICAgICAgICAgICAgIHwgICAgICAgICh0aHJlYWQgMikKPiA+
ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgIHJvc2VfY29ubmVjdAo+ID4g
PiA+IHJvc2Vfa2lsbF9ieV9uZWlnaCAgICAgICAgICAgICAgfCAgICBsb2NrX3NvY2soc2spCj4g
PiA+ID4gICBzcGluX2xvY2tfYmgoJnJvc2VfbGlzdF9sb2NrKSB8ICAgIGlmICghcm9zZS0+bmVp
Z2hib3VyKQo+ID4gPiA+ICAgcm9zZS0+bmVpZ2hib3VyID0gTlVMTDsvLygxKSAgfAo+ID4gPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICByb3NlLT5uZWlnaGJvdXItPnVz
ZSsrOy8vKDIpICAKPiA+ID4gICAKPiA+ID4gPiAgCQlpZiAocm9zZS0+bmVpZ2hib3VyID09IG5l
aWdoKSB7ICAKPiA+ID4gCj4gPiA+IFdoeSBpcyBpdCBva2F5IHRvIHBlcmZvcm0gdGhpcyBjb21w
YXJpc29uIHdpdGhvdXQgdGhlIHNvY2tldCBsb2NrLAo+ID4gPiBpZiB3ZSBuZWVkIGEgc29ja2V0
IGxvY2sgdG8gY2xlYXIgaXQ/IExvb2tzIGxpa2Ugcm9zZV9raWxsX2J5X25laWdoKCkKPiA+ID4g
aXMgbm90IGd1YXJhbnRlZWQgdG8gY2xlYXIgYWxsIHRoZSB1c2VzIG9mIGEgbmVpZ2hib3IuICAK
PiA+IAo+ID4gSSBhbSBzb3JyeSwgdGhlIGNvbXBhcmlzaW9uIHNob3VsZCBhbHNvIGJlIHByb3Rl
Y3RlZCB3aXRoIHNvY2tldCBsb2NrLgo+ID4gVGhlIHJvc2Vfa2lsbF9ieV9uZWlnaCgpIG9ubHkg
Y2xlYXIgdGhlIG5laWdoYm9yIHRoYXQgaXMgcGFzc2VkIGFzCj4gPiBwYXJhbWV0ZXIgb2Ygcm9z
ZV9raWxsX2J5X25laWdoKCkuIAo+IAo+IERvbid0IHRoaW5rIHRoYXQncyBwb3NzaWJsZSwgeW91
J2QgaGF2ZSB0byBkcm9wIHRoZSBuZWlnaCBsb2NrIGV2ZXJ5Cj4gdGltZS4KClRoZSBuZWlnaGJv
dXIgaXMgY2xlYXJlZCBpbiB0d28gc2l0dWF0aW9ucy4KCigxKSBXaGVuIHRoZSByb3NlIGRldmlj
ZSBpcyBkb3duLCB0aGUgcm9zZV9saW5rX2RldmljZV9kb3duKCkgdHJhdmVyc2VzCnRoZSByb3Nl
X25laWdoX2xpc3QgYW5kIHVzZXMgdGhlIHJvc2Vfa2lsbF9ieV9uZWlnaCgpIHRvIGNsZWFyIHRo
ZQpuZWlnaGJvcnMgb2YgdGhlIGRldmljZS4KCnZvaWQgcm9zZV9saW5rX2RldmljZV9kb3duKHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYpCnsKCXN0cnVjdCByb3NlX25laWdoICpyb3NlX25laWdoOwoK
CWZvciAocm9zZV9uZWlnaCA9IHJvc2VfbmVpZ2hfbGlzdDsgcm9zZV9uZWlnaCAhPSBOVUxMOyBy
b3NlX25laWdoID0gcm9zZV9uZWlnaC0+bmV4dCkgewoJCWlmIChyb3NlX25laWdoLT5kZXYgPT0g
ZGV2KSB7CgkJCXJvc2VfZGVsX3JvdXRlX2J5X25laWdoKHJvc2VfbmVpZ2gpOwoJCQlyb3NlX2tp
bGxfYnlfbmVpZ2gocm9zZV9uZWlnaCk7CgkJfQoJfQp9CgpodHRwczovL2VsaXhpci5ib290bGlu
LmNvbS9saW51eC92NS4xOS1yYzQvc291cmNlL25ldC9yb3NlL3Jvc2Vfcm91dGUuYyNMODM5Cgoo
MikgV2hlbiB0aGUgbGV2ZWwgMiBsaW5rIGhhcyB0aW1lZCBvdXQsIHRoZSByb3NlX2xpbmtfZmFp
bGVkKCkgY2FsbHMgcm9zZV9raWxsX2J5X25laWdoKCkKdG8gY2xlYXIgdGhlIHJvc2VfbmVpZ2gu
CgpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92NS4xOS1yYzQvc291cmNlL25ldC9y
b3NlL3Jvc2Vfcm91dGUuYyNMODEzCgo+ID4gPiA+ICsJCQlzb2NrX2hvbGQocyk7Cj4gPiA+ID4g
KwkJCXNwaW5fdW5sb2NrX2JoKCZyb3NlX2xpc3RfbG9jayk7Cj4gPiA+ID4gKwkJCWxvY2tfc29j
ayhzKTsKPiA+ID4gPiAgCQkJcm9zZV9kaXNjb25uZWN0KHMsIEVORVRVTlJFQUNILCBST1NFX09V
VF9PRl9PUkRFUiwgMCk7Cj4gPiA+ID4gIAkJCXJvc2UtPm5laWdoYm91ci0+dXNlLS07ICAKPiA+
ID4gCj4gPiA+IFdoYXQgcHJvdGVjdHMgdGhlIHVzZSBjb3VudGVyPyAgCj4gPiAKPiA+IFRoZSB1
c2UgY291bnRlciBpcyBwcm90ZWN0ZWQgYnkgc29ja2V0IGxvY2suCj4gCj4gV2hpY2ggb25lLCB0
aGUgbmVpZ2ggb2JqZWN0IGNhbiBiZSBzaGFyZWQgYnkgbXVsdGlwbGUgc29ja2V0cywgbm8/CgpU
aGUgc2tfZm9yX2VhY2goKSB0cmF2ZXJzZXMgdGhlIHJvc2VfbGlzdCBhbmQgdXNlcyB0aGUgbG9j
ayBvZiB0aGUgc29ja2V0IHRoYXQgaXMgZXh0cmFjdGVkCmZyb20gdGhlIHJvc2VfbGlzdCB0byBw
cm90ZWN0IHRoZSB1c2UgY291bnRlci4KCmRpZmYgLS1naXQgYS9uZXQvcm9zZS9hZl9yb3NlLmMg
Yi9uZXQvcm9zZS9hZl9yb3NlLmMKaW5kZXggYmYyZDk4NmE2YmMuLjZkNTA4OGIwMzBhIDEwMDY0
NAotLS0gYS9uZXQvcm9zZS9hZl9yb3NlLmMKKysrIGIvbmV0L3Jvc2UvYWZfcm9zZS5jCkBAIC0x
NjUsMTQgKzE2NSwyNiBAQCB2b2lkIHJvc2Vfa2lsbF9ieV9uZWlnaChzdHJ1Y3Qgcm9zZV9uZWln
aCAqbmVpZ2gpCiAgICAgICAgc3RydWN0IHNvY2sgKnM7CiAKICAgICAgICBzcGluX2xvY2tfYmgo
JnJvc2VfbGlzdF9sb2NrKTsKK2FnYWluOgogICAgICAgIHNrX2Zvcl9lYWNoKHMsICZyb3NlX2xp
c3QpIHsKICAgICAgICAgICAgICAgIHN0cnVjdCByb3NlX3NvY2sgKnJvc2UgPSByb3NlX3NrKHMp
OwogCisgICAgICAgICAgICAgICBzb2NrX2hvbGQocyk7CisgICAgICAgICAgICAgICBzcGluX3Vu
bG9ja19iaCgmcm9zZV9saXN0X2xvY2spOworICAgICAgICAgICAgICAgbG9ja19zb2NrKHMpOwog
ICAgICAgICAgICAgICAgaWYgKHJvc2UtPm5laWdoYm91ciA9PSBuZWlnaCkgewogICAgICAgICAg
ICAgICAgICAgICAgICByb3NlX2Rpc2Nvbm5lY3QocywgRU5FVFVOUkVBQ0gsIFJPU0VfT1VUX09G
X09SREVSLCAwKTsKICAgICAgICAgICAgICAgICAgICAgICAgcm9zZS0+bmVpZ2hib3VyLT51c2Ut
LTsKICAgICAgICAgICAgICAgICAgICAgICAgcm9zZS0+bmVpZ2hib3VyID0gTlVMTDsKKyAgICAg
ICAgICAgICAgICAgICAgICAgcmVsZWFzZV9zb2NrKHMpOworICAgICAgICAgICAgICAgICAgICAg
ICBzb2NrX3B1dChzKTsKKyAgICAgICAgICAgICAgICAgICAgICAgc3Bpbl9sb2NrX2JoKCZyb3Nl
X2xpc3RfbG9jayk7CisgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gYWdhaW47CiAgICAgICAg
ICAgICAgICB9CisgICAgICAgICAgICAgICByZWxlYXNlX3NvY2socyk7CisgICAgICAgICAgICAg
ICBzb2NrX3B1dChzKTsKKyAgICAgICAgICAgICAgIHNwaW5fbG9ja19iaCgmcm9zZV9saXN0X2xv
Y2spOworICAgICAgICAgICAgICAgZ290byBhZ2FpbjsKICAgICAgICB9CiAgICAgICAgc3Bpbl91
bmxvY2tfYmgoJnJvc2VfbGlzdF9sb2NrKTsKIH0KCkJlc3QgcmVnYXJkcywKRHVvbWluZyBaaG91

