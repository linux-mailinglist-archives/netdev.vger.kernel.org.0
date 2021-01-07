Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13282ECB4F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 08:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbhAGHzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 02:55:31 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:25454 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbhAGHzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 02:55:31 -0500
Received: by ajax-webmail-mail-app3 (Coremail) ; Thu, 7 Jan 2021 15:54:15
 +0800 (GMT+08:00)
X-Originating-IP: [222.205.25.254]
Date:   Thu, 7 Jan 2021 15:54:15 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   dinghao.liu@zju.edu.cn
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "Konstantin Ryabitsev" <konstantin@linuxfoundation.org>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        "Andrew Lunn" <andrew@lunn.ch>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "Arnd Bergmann" <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20200917(3e19599d)
 Copyright (c) 2002-2021 www.mailtech.cn zju.edu.cn
In-Reply-To: <20210106084430.291a90cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201223153304.GD3198262@lunn.ch>
 <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201223210044.GA3253993@lunn.ch>
 <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
 <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224180631.l4zieher54ncqvwl@chatter.i7.local>
 <fc7be127-648c-6b09-6f00-3542e0388197@gmail.com>
 <20201228202302.afkxtco27j4ahh6d@chatter.i7.local>
 <08e2b663-c144-d1bb-3f90-5e4ef240d14b@gmail.com>
 <20201228211417.m5gdnqexjzgt4ix6@chatter.i7.local>
 <20201230133618.7c242856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <328f073a.222d7.176d7572f29.Coremail.dinghao.liu@zju.edu.cn>
 <20210106084430.291a90cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <73439f2d.25481.176dbd6c8ea.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgA343wnvvZfng8dAA--.7749W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoRBlZdtR3nOQADsh
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBXZWQsIDYgSmFuIDIwMjEgMTg6NTY6MjMgKzA4MDAgKEdNVCswODowMCkgZGluZ2hhby5s
aXVAemp1LmVkdS5jbgo+IHdyb3RlOgo+ID4gPiBJIHVzZWQgdGhpcyBvbmUgZm9yIGEgdGVzdDoK
PiA+ID4gCj4gPiA+IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9uZXRkZXZi
cGYvcGF0Y2gvMTYwOTMxMjk5NC0xMjEwMzItMS1naXQtc2VuZC1lbWFpbC1hYmFjaS1idWdmaXhA
bGludXguYWxpYmFiYS5jb20vCj4gPiA+IAo+ID4gPiBJJ20gbm90IGdldHRpbmcgdGhlIEZpeGVz
IHRhZyB3aGVuIEkgZG93bmxvYWQgdGhlIG1ib3guICAKPiA+IAo+ID4gSXQgc2VlbXMgdGhhdCBh
dXRvbWF0aWNhbGx5IGdlbmVyYXRpbmcgRml4ZXMgdGFncyBpcyBhIGhhcmQgd29yay4KPiA+IEJv
dGggcGF0Y2hlcyBhbmQgYnVncyBjb3VsZCBiZSBjb21wbGV4LiBTb21ldGltZXMgZXZlbiBodW1h
biBjYW5ub3QKPiA+IGRldGVybWluZSB3aGljaCBjb21taXQgaW50cm9kdWNlZCBhIHRhcmdldCBi
dWcuCj4gPiAKPiA+IElzIHRoaXMgYW4gYWxyZWFkeSBpbXBsZW1lbnRlZCBmdW5jdGlvbmFsaXR5
Pwo+IAo+IEknbSBub3Qgc3VyZSBJIHVuZGVyc3RhbmQuIEluZGVlZCBmaW5kaW5nIHRoZSByaWdo
dCBjb21taXQgdG8gdXNlIGluIAo+IGEgRml4ZXMgdGFnIGlzIG5vdCBhbHdheXMgZWFzeSwgYW5k
IGRlZmluaXRlbHkgbm90IGVhc3kgdG8gYXV0b21hdGUuCj4gSHVtYW4gdmFsaWRhdGlvbiBpcyBh
bHdheXMgcmVxdWlyZWQuCj4gCj4gSWYgd2UgY291bGQgZWFzaWx5IGF1dG9tYXRlIGZpbmRpbmcg
dGhlIGNvbW1pdCB3aGljaCBpbnRyb2R1Y2VkIGEKPiBwcm9ibGVtIHdlIHdvdWxkbid0IG5lZWQg
dG8gYWRkIHRoZSBleHBsaWNpdCB0YWcsIGJhY2twb3J0ZXJzIGNvdWxkCj4ganVzdCBydW4gc3Vj
aCBzY3JpcHQgbG9jYWxseS4uIFRoYXQncyB3aHkgaXQncyBiZXN0IGlmIHRoZSBhdXRob3IgCj4g
ZG9lcyB0aGUgZGlnZ2luZyBhbmQgcHJvdmlkZXMgdGhlIHJpZ2h0IHRhZy4KPiAKPiBUaGUgY29u
dmVyc2F0aW9uIHdpdGggS29uc3RhbnRpbiBhbmQgRmxvcmlhbiB3YXMgYWJvdXQgYXV0b21hdGlj
YWxseQo+IHBpY2tpbmcgdXAgRml4ZXMgdGFncyBmcm9tIHRoZSBtYWlsaW5nIGxpc3QgYnkgdGhl
IHBhdGNod29yayBzb2Z0d2FyZSwKPiB3aGVuIHN1Y2ggdGFncyBhcmUgcG9zdGVkIGluIHJlcGx5
IHRvIHRoZSBvcmlnaW5hbCBwb3N0aW5nLCBqdXN0IGxpa2UKPiByZXZpZXcgdGFncy4gQnV0IHRo
ZSB0YWdzIGFyZSBzdGlsbCBnZW5lcmF0ZWQgYnkgaHVtYW5zLgoKSXQncyBjbGVhciB0byBtZSwg
dGhhbmtzLgoKUmVnYXJkcywKRGluZ2hhbw==
