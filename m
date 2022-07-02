Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8234563EE7
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 09:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbiGBHYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 03:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiGBHYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 03:24:11 -0400
Received: from zju.edu.cn (spam.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 87AAF19C19;
        Sat,  2 Jul 2022 00:24:08 -0700 (PDT)
Received: by ajax-webmail-mail-app2 (Coremail) ; Sat, 2 Jul 2022 15:23:57
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.66.153]
Date:   Sat, 2 Jul 2022 15:23:57 +0800 (GMT+08:00)
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
In-Reply-To: <20220701194155.5bd61e58@kernel.org>
References: <20220629104941.26351-1-duoming@zju.edu.cn>
 <20220701194155.5bd61e58@kernel.org>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <1bbd2137.23c51.181bdcb792f.Coremail.duoming@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: by_KCgCHOAiN8r9i2psBAw--.1661W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAg4TAVZdtaf41gAAsp
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

SGVsbG8sCgpPbiBGcmksIDEgSnVsIDIwMjIgMTk6NDE6NTUgLTA3MDAgSmFrdWIgS2ljaW5za2kg
d3JvdGU6Cgo+IE9uIFdlZCwgMjkgSnVuIDIwMjIgMTg6NDk6NDEgKzA4MDAgRHVvbWluZyBaaG91
IHdyb3RlOgo+ID4gV2hlbiB0aGUgbGluayBsYXllciBjb25uZWN0aW9uIGlzIGJyb2tlbiwgdGhl
IHJvc2UtPm5laWdoYm91ciBpcwo+ID4gc2V0IHRvIG51bGwuIEJ1dCByb3NlLT5uZWlnaGJvdXIg
Y291bGQgYmUgdXNlZCBieSByb3NlX2Nvbm5lY3Rpb24oKQo+ID4gYW5kIHJvc2VfcmVsZWFzZSgp
IGxhdGVyLCBiZWNhdXNlIHRoZXJlIGlzIG5vIHN5bmNocm9uaXphdGlvbiBhbW9uZwo+ID4gdGhl
bS4gQXMgYSByZXN1bHQsIHRoZSBudWxsLXB0ci1kZXJlZiBidWdzIHdpbGwgaGFwcGVuLgo+ID4g
Cj4gPiBPbmUgb2YgdGhlIG51bGwtcHRyLWRlcmVmIGJ1Z3MgaXMgc2hvd24gYmVsb3c6Cj4gPiAK
PiA+ICAgICAodGhyZWFkIDEpICAgICAgICAgICAgICAgICAgfCAgICAgICAgKHRocmVhZCAyKQo+
ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICByb3NlX2Nvbm5lY3QKPiA+IHJv
c2Vfa2lsbF9ieV9uZWlnaCAgICAgICAgICAgICAgfCAgICBsb2NrX3NvY2soc2spCj4gPiAgIHNw
aW5fbG9ja19iaCgmcm9zZV9saXN0X2xvY2spIHwgICAgaWYgKCFyb3NlLT5uZWlnaGJvdXIpCj4g
PiAgIHJvc2UtPm5laWdoYm91ciA9IE5VTEw7Ly8oMSkgIHwKPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgICByb3NlLT5uZWlnaGJvdXItPnVzZSsrOy8vKDIpCj4gCj4gPiAg
CQlpZiAocm9zZS0+bmVpZ2hib3VyID09IG5laWdoKSB7Cj4gCj4gV2h5IGlzIGl0IG9rYXkgdG8g
cGVyZm9ybSB0aGlzIGNvbXBhcmlzb24gd2l0aG91dCB0aGUgc29ja2V0IGxvY2ssCj4gaWYgd2Ug
bmVlZCBhIHNvY2tldCBsb2NrIHRvIGNsZWFyIGl0PyBMb29rcyBsaWtlIHJvc2Vfa2lsbF9ieV9u
ZWlnaCgpCj4gaXMgbm90IGd1YXJhbnRlZWQgdG8gY2xlYXIgYWxsIHRoZSB1c2VzIG9mIGEgbmVp
Z2hib3IuCgpJIGFtIHNvcnJ5LCB0aGUgY29tcGFyaXNpb24gc2hvdWxkIGFsc28gYmUgcHJvdGVj
dGVkIHdpdGggc29ja2V0IGxvY2suClRoZSByb3NlX2tpbGxfYnlfbmVpZ2goKSBvbmx5IGNsZWFy
IHRoZSBuZWlnaGJvciB0aGF0IGlzIHBhc3NlZCBhcwpwYXJhbWV0ZXIgb2Ygcm9zZV9raWxsX2J5
X25laWdoKCkuIAoKPiA+ICsJCQlzb2NrX2hvbGQocyk7Cj4gPiArCQkJc3Bpbl91bmxvY2tfYmgo
JnJvc2VfbGlzdF9sb2NrKTsKPiA+ICsJCQlsb2NrX3NvY2socyk7Cj4gPiAgCQkJcm9zZV9kaXNj
b25uZWN0KHMsIEVORVRVTlJFQUNILCBST1NFX09VVF9PRl9PUkRFUiwgMCk7Cj4gPiAgCQkJcm9z
ZS0+bmVpZ2hib3VyLT51c2UtLTsKPiAKPiBXaGF0IHByb3RlY3RzIHRoZSB1c2UgY291bnRlcj8K
ClRoZSB1c2UgY29vdW50ZXIgaXMgcHJvdGVjdGVkIGJ5IHNvY2tldCBsb2NrLgoKPiA+ICAJCQly
b3NlLT5uZWlnaGJvdXIgPSBOVUxMOwo+ID4gKwkJCXJlbGVhc2Vfc29jayhzKTsKPiA+ICsJCQlz
cGluX2xvY2tfYmgoJnJvc2VfbGlzdF9sb2NrKTsKPiAKPiBEb24ndCB0YWtlIHRoZSBsb2NrIGhl
cmUganVzdCBkdW1wIG9uZSBsaW5lIGZ1cnRoZXIgYmFjay4KCk9rLCBJIHdpbGwgZHVtcCBvbmUg
bGluZSBmdXJ0aGVyIGJhY2suCgpCZXN0IHJlZ2FyZHMsCkR1b21pbmcgWmhvdQo=
