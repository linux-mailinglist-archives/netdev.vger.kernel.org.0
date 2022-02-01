Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72AD4A5EA0
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbiBAOyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:54:01 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:32874 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239520AbiBAOyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 09:54:00 -0500
Received: by ajax-webmail-mail-app3 (Coremail) ; Tue, 1 Feb 2022 22:53:45
 +0800 (GMT+08:00)
X-Originating-IP: [10.190.72.55]
Date:   Tue, 1 Feb 2022 22:53:45 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5ZGo5aSa5piO?= <22021233@zju.edu.cn>
To:     "Dan Carpenter" <dan.carpenter@oracle.com>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH 2/2] ax25: add refcount in ax25_dev to avoid UAF
 bugs
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2022 www.mailtech.cn zju.edu.cn
In-Reply-To: <20220131132241.GK1951@kadam>
References: <cover.1643343397.git.duoming@zju.edu.cn>
 <855641b37699b6ff501c4bae8370d26f59da9c81.1643343397.git.duoming@zju.edu.cn>
 <20220131132241.GK1951@kadam>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <387eb6ac.8e2c7.17eb5c703d1.Coremail.22021233@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDnX_N5Sflh41WHDA--.61194W
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgUIAVZdtYB9BgABsK
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW7Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IHZlcnkgbXVjaCBmb3IgeW91ciB0aW1lIGFuZCBwb2ludGluZyBvdXQgcHJvYmxl
bXMgaW4gbXkgcGF0Y2guCkFub3RoZXIgdHdvIHF1ZXN0aW9ucyB5b3UgYXNrZWQgaXMgc2hvd24g
YmVsb3c6Cgo+IEBAIC0xMTIsMjAgKzExNSwyMiBAQCB2b2lkIGF4MjVfZGV2X2RldmljZV9kb3du
KHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpCj4gIAo+ICAJaWYgKChzID0gYXgyNV9kZXZfbGlzdCkg
PT0gYXgyNV9kZXYpIHsKPiAgCQlheDI1X2Rldl9saXN0ID0gcy0+bmV4dDsKPiArCQlheDI1X2Rl
dl9wdXQoYXgyNV9kZXYpOwoKRG8gd2Ugbm90IGhhdmUgdG8gY2FsbCBheDI1X2Rldl9ob2xkKHMt
Pm5leHQpPwoKPiAgCQlzcGluX3VubG9ja19iaCgmYXgyNV9kZXZfbG9jayk7Cj4gIAkJZGV2LT5h
eDI1X3B0ciA9IE5VTEw7Cj4gIAkJZGV2X3B1dF90cmFjayhkZXYsICZheDI1X2Rldi0+ZGV2X3Ry
YWNrZXIpOwo+IC0JCWtmcmVlKGF4MjVfZGV2KTsKPiArCQlheDI1X2Rldl9wdXQoYXgyNV9kZXYp
Owo+ICAJCXJldHVybjsKPiAgCX0KPiAgCj4gIAl3aGlsZSAocyAhPSBOVUxMICYmIHMtPm5leHQg
IT0gTlVMTCkgewo+ICAJCWlmIChzLT5uZXh0ID09IGF4MjVfZGV2KSB7Cj4gIAkJCXMtPm5leHQg
PSBheDI1X2Rldi0+bmV4dDsKPiArCQkJYXgyNV9kZXZfcHV0KGF4MjVfZGV2KTsKCmF4MjVfZGV2
X2hvbGQoYXgyNV9kZXYtPm5leHQpPwoKQW5zd2VyOgpXZSBkb24ndCBoYXZlIHRvIGNhbGwgYXgy
NV9kZXZfaG9sZChzLT5uZXh0KSBvciBheDI1X2Rldl9ob2xkKGF4MjVfZGV2LT5uZXh0KQppbiBh
eDI1X2Rldl9kZXZpY2VfZG93bigpIGJlY2F1c2Ugd2UgaGF2ZSBhbHJlYWR5IGluY3JlYXNlZCB0
aGUgcmVmY291bnQgd2hlbiAKd2UgaW5zZXJ0IGF4MjVfZGV2IGludG8gdGhlIGxpbmtlZCBsaXN0
IGluIGF4MjVfZGV2X2RldmljZV91cCgpLgoKPiBAQCAtODMsNiArODUsNyBAQCB2b2lkIGF4MjVf
ZGV2X2RldmljZV91cChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQo+ICAJc3Bpbl9sb2NrX2JoKCZh
eDI1X2Rldl9sb2NrKTsKPiAgCWF4MjVfZGV2LT5uZXh0ID0gYXgyNV9kZXZfbGlzdDsKPiAgCWF4
MjVfZGV2X2xpc3QgID0gYXgyNV9kZXY7Cj4gKwlheDI1X2Rldl9ob2xkKGF4MjVfZGV2KTsKPiAg
CXNwaW5fdW5sb2NrX2JoKCZheDI1X2Rldl9sb2NrKTsKCkJlc3Qgd2lzaGVzLApEdW9taW5nIFpo
b3UK
