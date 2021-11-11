Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817DE44D7C2
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhKKOEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:04:48 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:34078 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233439AbhKKOEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:04:47 -0500
Received: by ajax-webmail-mail-app4 (Coremail) ; Thu, 11 Nov 2021 22:01:50
 +0800 (GMT+08:00)
X-Originating-IP: [10.214.160.77]
Date:   Thu, 11 Nov 2021 22:01:50 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   "Lin Ma" <linma@zju.edu.cn>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v1 2/2] hamradio: defer 6pack kfree after
 unregister_netdev
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20210104(ab8c30b6)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <20211111055021.77186242@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211108103721.30522-1-linma@zju.edu.cn>
 <20211108103759.30541-1-linma@zju.edu.cn>
 <20211110180525.20422f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211110180612.2f2eb760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <724aae55.1863af.17d0cc249ab.Coremail.linma@zju.edu.cn>
 <20211111055021.77186242@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <2384cfdd.188d2b.17d0f4e0474.Coremail.linma@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cS_KCgD3fK1OIo1h5lzlBA--.65141W
X-CM-SenderInfo: qtrwiiyqvtljo62m3hxhgxhubq/1tbiAwUCElNG3ElR6gAbs2
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VW5Jw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgdGhlcmUsCgo+IAo+IE9uIFRodSwgMTEgTm92IDIwMjEgMTA6MDk6NTkgKzA4MDAgKEdNVCsw
ODowMCkgTGluIE1hIHdyb3RlOgo+ID4gPiBMb29rcyBsaWtlIHRoaXMgZ28gYXBwbGllZCBhbHJl
YWR5LCBwbGVhc2Ugc2VuZCBhIGZvbGxvdyB1cCBmaXguICAKPiA+IAo+ID4gT29vb3BzLCB0aGFu
a3MgZm9yIHRoZSByZW1pbmQuIFhECj4gPiAKPiA+IEkganVzdCBmb3VuZCB0aGF0IHRoZSBta2ls
bCBhZGRzIHRoZSBmcmVlX25ldGRldiBhZnRlciB0aGUKPiA+IHVucmVnaXN0ZXJfbmV0ZGV2IHNv
IEkgZGlkIGl0IHRvby4gTm8gaWRlYSBhYm91dCB0aGlzIGF1dG9tYXRpYwo+ID4gY2xlYW51cC4K
PiA+IAo+ID4gU2hvdWxkIEkgc2VuZCB0aGUgZml4IGluIHRoaXMgdGhyZWFkIG9yIG9wZW4gYSBu
ZXcgb25lPwo+IAo+IE5ldyB0aHJlYWQgaXMgYmV0dGVyIGZvciBtZS4KClRoZSBmaXggZm9yIHRo
ZSBlcnJvbmVvdXMgcGF0Y2ggaXMgc2VudCwgaW5mb3JtYXRpb24gaXMgbGlrZSBiZWxvdwoKU3Vi
amVjdDogW1BBVENIIHYwXSBoYW1yYWRpbzogZGVsZXRlIHVubmVjZXNzYXJ5IGZyZWVfbmV0ZGV2
KCkKRGF0ZTogVGh1LCAxMSBOb3YgMjAyMSAyMjowMDowNyArMDgwMApNZXNzYWdlLUlkOiA8MjAy
MTExMTExNDAwMDcuNzI0NC0xLWxpbm1hQHpqdS5lZHUuY24+CgpTb3JyeSBhYm91dCB0aGlzIGRp
c3R1cmJpbmcgOigKCkJlc3QgUmVnYXJkcwpMaW4=
