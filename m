Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B472E33DC
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 04:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgL1DPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 22:15:11 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:33232 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726289AbgL1DPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 22:15:11 -0500
Received: by ajax-webmail-mail-app3 (Coremail) ; Mon, 28 Dec 2020 11:14:11
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.85.18]
Date:   Mon, 28 Dec 2020 11:14:11 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Leon Romanovsky" <leon@kernel.org>
Cc:     kjlu@umn.edu, "Saeed Mahameed" <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] net/mlx5e: Fix two double free cases
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20200917(3e19599d)
 Copyright (c) 2002-2020 www.mailtech.cn zju.edu.cn
In-Reply-To: <20201227084001.GF4457@unreal>
References: <20201221085031.6591-1-dinghao.liu@zju.edu.cn>
 <20201227084001.GF4457@unreal>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <79a35d07.7894.176a756c881.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDHPw+DTelfTCEeAA--.5808W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgYEBlZdtRrnPgAash
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBNb24sIERlYyAyMSwgMjAyMCBhdCAwNDo1MDozMVBNICswODAwLCBEaW5naGFvIExpdSB3
cm90ZToKPiA+IG1seDVlX2NyZWF0ZV90dGNfdGFibGVfZ3JvdXBzKCkgZnJlZXMgZnQtPmcgb24g
ZmFpbHVyZSBvZgo+ID4ga3Z6YWxsb2MoKSwgYnV0IHN1Y2ggZmFpbHVyZSB3aWxsIGJlIGNhdWdo
dCBieSBpdHMgY2FsbGVyCj4gPiBpbiBtbHg1ZV9jcmVhdGVfdHRjX3RhYmxlKCkgYW5kIGZ0LT5n
IHdpbGwgYmUgZnJlZWQgYWdhaW4KPiA+IGluIG1seDVlX2Rlc3Ryb3lfZmxvd190YWJsZSgpLiBU
aGUgc2FtZSBpc3N1ZSBhbHNvIG9jY3Vycwo+ID4gaW4gbWx4NWVfY3JlYXRlX3R0Y190YWJsZV9n
cm91cHMoKS4KPiA+Cj4gPiBTaWduZWQtb2ZmLWJ5OiBEaW5naGFvIExpdSA8ZGluZ2hhby5saXVA
emp1LmVkdS5jbj4KPiA+IC0tLQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9mcy5jIHwgOCArKy0tLS0tLQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCj4gCj4gSSdtIG5vdCB0aHJpbGxlZCB0byBzZWUgcmVs
ZWFzZSBpbiB0aGUgZXJyb3IgZmxvdyB0aGF0IHdpbGwgYmUgZG9uZSBpbgo+IHRoZSBkaWZmZXJl
bnQgZnVuY3Rpb24uIFRoZSBtaXNzaW5nIHBpZWNlIGlzICJmdC0+ZyA9IE5VTEwiIGFmdGVyIGtm
cmVlKCkuCj4gCj4gQW5kIGFsc28gZml4ZXMgbGluZXMgYXJlIG1pc3NpbmcgaW4gYWxsIHlvdXIg
cGF0Y2hlcy4KPiAKClRoYW5rIHlvdSBmb3IgeW91ciBhZHZpY2UhIEkgd2lsbCByZXNlbmQgYSBu
ZXcgcGF0Y2ggc29vbi4KClJlZ2FyZHMsCkRpbmdoYW8=
