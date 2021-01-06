Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41C02EBCDC
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbhAFK5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:57:53 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:37672 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbhAFK5x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 05:57:53 -0500
Received: by ajax-webmail-mail-app3 (Coremail) ; Wed, 6 Jan 2021 18:56:23
 +0800 (GMT+08:00)
X-Originating-IP: [10.192.85.18]
Date:   Wed, 6 Jan 2021 18:56:23 +0800 (GMT+08:00)
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
In-Reply-To: <20201230133618.7c242856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <328f073a.222d7.176d7572f29.Coremail.dinghao.liu@zju.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: cC_KCgDnHghXl_VfGccVAA--.5915W
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgoRBlZdtR3nOQAAsi
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBNb24sIDI4IERlYyAyMDIwIDE2OjE0OjE3IC0wNTAwIEtvbnN0YW50aW4gUnlhYml0c2V2
IHdyb3RlOgo+ID4gT24gTW9uLCBEZWMgMjgsIDIwMjAgYXQgMDE6MDU6MjZQTSAtMDgwMCwgRmxv
cmlhbiBGYWluZWxsaSB3cm90ZToKPiA+ID4gT24gMTIvMjgvMjAyMCAxMjoyMyBQTSwgS29uc3Rh
bnRpbiBSeWFiaXRzZXYgd3JvdGU6ICAKPiA+ID4gPiBPbiBUaHUsIERlYyAyNCwgMjAyMCBhdCAw
MTo1Nzo0MFBNIC0wODAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3RlOiAgCj4gPiA+ID4+Pj4gS29u
c3RhbnRpbiwgd291bGQgeW91IGJlIHdpbGxpbmcgdG8gbW9kIHRoZSBrZXJuZWwub3JnIGluc3Rh
bmNlIG9mCj4gPiA+ID4+Pj4gcGF0Y2h3b3JrIHRvIHBvcHVsYXRlIEZpeGVzIHRhZ3MgaW4gdGhl
IGdlbmVyYXRlZCBtYm94ZXM/ICAKPiA+ID4gPj4+Cj4gPiA+ID4+PiBJJ2QgcmVhbGx5IHJhdGhl
ciBub3QgLS0gd2UgdHJ5IG5vdCB0byBkaXZlcmdlIGZyb20gcHJvamVjdCB1cHN0cmVhbSBpZiBh
dCBhbGwKPiA+ID4gPj4+IHBvc3NpYmxlLCBhcyB0aGlzIGRyYW1hdGljYWxseSBjb21wbGljYXRl
cyB1cGdyYWRlcy4gIAo+ID4gPiA+Pgo+ID4gPiA+PiBXZWxsIHRoYXQgaXMgcmVhbGx5IHVuZm9y
dHVuYXRlIHRoZW4gYmVjYXVzZSB0aGUgTGludXggZGV2ZWxvcGVyCj4gPiA+ID4+IGNvbW11bml0
eSBzZXR0bGVkIG9uIHVzaW5nIHRoZSBGaXhlczogdGFnIGZvciB5ZWFycyBub3cgYW5kIGhhdmlu
Zwo+ID4gPiA+PiBwYXRjaHdvcmsgYXV0b21hdGljYWxseSBhcHBlbmQgdGhvc2UgdGFncyB3b3Vs
ZCBncmVhdGx5IGhlbHAgbWFpbnRhaW5lcnMuICAKPiA+ID4gPiAKPiA+ID4gPiBJIGFncmVlIC0t
IGJ1dCB0aGlzIGlzIHNvbWV0aGluZyB0aGF0IG5lZWRzIHRvIGJlIGltcGxlbWVudGVkIHVwc3Ry
ZWFtLgo+ID4gPiA+IFBpY2tpbmcgdXAgYSBvbmUtb2ZmIHBhdGNoIGp1c3QgZm9yIHBhdGNod29y
ay5rZXJuZWwub3JnIGlzIG5vdCB0aGUgcmlnaHQgd2F5Cj4gPiA+ID4gdG8gZ28gYWJvdXQgdGhp
cy4gIAo+ID4gPiAKPiA+ID4gWW91IHNob3VsZCBiZSBhYmxlIHRvIHR1bmUgdGhpcyBmcm9tIHRo
ZSBwYXRjaHdvcmsgYWRtaW5pc3RyYXRpdmUKPiA+ID4gaW50ZXJmYWNlIGFuZCBhZGQgbmV3IHRh
Z3MgdGhlcmUsIHdvdWxkIG5vdCB0aGF0IGJlIGFjY2VwdGFibGU/ICAKPiA+IAo+ID4gT2gsIG9v
cHMsIEkgZ290IGNvbmZ1c2VkIGJ5IHRoZSBtZW50aW9uIG9mIGEgcmVqZWN0ZWQgdXBzdHJlYW0g
cGF0Y2ggLS0gSQo+ID4gZGlkbid0IHJlYWxpemUgdGhhdCB0aGlzIGlzIGFscmVhZHkgcG9zc2li
bGUgd2l0aCBhIGNvbmZpZ3VyYXRpb24gc2V0dGluZy4KPiA+IAo+ID4gU3VyZSwgSSBhZGRlZCBh
IG1hdGNoIGZvciBeRml4ZXM6IC0tIGxldCBtZSBrbm93IGlmIGl0J3Mgbm90IGRvaW5nIHRoZSBy
aWdodAo+ID4gdGhpbmcuCj4gCj4gSSB1c2VkIHRoaXMgb25lIGZvciBhIHRlc3Q6Cj4gCj4gaHR0
cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8xNjA5MzEy
OTk0LTEyMTAzMi0xLWdpdC1zZW5kLWVtYWlsLWFiYWNpLWJ1Z2ZpeEBsaW51eC5hbGliYWJhLmNv
bS8KPiAKPiBJJ20gbm90IGdldHRpbmcgdGhlIEZpeGVzIHRhZyB3aGVuIEkgZG93bmxvYWQgdGhl
IG1ib3guCgpJdCBzZWVtcyB0aGF0IGF1dG9tYXRpY2FsbHkgZ2VuZXJhdGluZyBGaXhlcyB0YWdz
IGlzIGEgaGFyZCB3b3JrLgpCb3RoIHBhdGNoZXMgYW5kIGJ1Z3MgY291bGQgYmUgY29tcGxleC4g
U29tZXRpbWVzIGV2ZW4gaHVtYW4gY2Fubm90CmRldGVybWluZSB3aGljaCBjb21taXQgaW50cm9k
dWNlZCBhIHRhcmdldCBidWcuCgpJcyB0aGlzIGFuIGFscmVhZHkgaW1wbGVtZW50ZWQgZnVuY3Rp
b25hbGl0eT8KClJlZ2FyZHMsCkRpbmdoYW8g
