Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051222F5433
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 21:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbhAMUfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 15:35:33 -0500
Received: from m1513.mail.126.com ([220.181.15.13]:30655 "EHLO
        m1513.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728793AbhAMUfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 15:35:33 -0500
X-Greylist: delayed 23675 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2021 15:35:32 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=moYk/
        BZrmThEJn0UfWgepwN1RI/HpxA34cJ5lNg5DZg=; b=EMBIk2Z752YIK2alABQMy
        p8Gpzclb05fLHrsXgYwBY/1AEePkZ76u//jlInskE2Cw/vdPCh5S/DO7RYV9x6sI
        NflUyPP1wzH/9L9S5NYpBVW1q5rF916Ovo7JtBk/2ZSZNGfIvfDWTJPkQ/gUnpe/
        bSrhz83wxqR8HqpyTFjaac=
Received: from wangyingjie55$126.com ( [119.39.248.74] ) by
 ajax-webmail-wmsvr13 (Coremail) ; Wed, 13 Jan 2021 21:27:35 +0800 (CST)
X-Originating-IP: [119.39.248.74]
Date:   Wed, 13 Jan 2021 21:27:35 +0800 (CST)
From:   "Yingjie Wang" <wangyingjie55@126.com>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH v2] af/rvu_cgx: Fix missing check bugs in rvu_cgx.c
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20201118(ab4b390f)
 Copyright (c) 2002-2021 www.mailtech.cn 126com
In-Reply-To: <20210112181328.091f7cfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <1610417389-9051-1-git-send-email-wangyingjie55@126.com>
 <20210112181328.091f7cfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Message-ID: <355954d9.5264.176fbee1ed6.Coremail.wangyingjie55@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: DcqowAAHHy9I9f5fWxgfAQ--.56009W
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiHQ8Zp1pECbZSXQABsD
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHJlcGx5LiAgSSBjb21taXQgdGhpcyBjaGFuZ2Ugb24gbGludXgtbmV4
dC9zdGFibGUgYnJhbmNoLCBhbmQgSSB1c2UgImdpdCBsb2cgLS1wcmV0dHk9Zml4ZXMiIGNvbW1h
bmQgdG8gZ2V0IHRoZSBGaXhlcyB0YWcuIEkgd2FudCB0byBrbm93IGlmIEkgbmVlZCB0byBtYWtl
IGEgY2hhbmdlIG9uIGFueSBvdGhlciBicmFuY2ggYW5kIGNvbW1pdCBpdD8KQXQgMjAyMS0wMS0x
MyAxMDoxMzoyOCwgIkpha3ViIEtpY2luc2tpIiA8a3ViYUBrZXJuZWwub3JnPiB3cm90ZToKPk9u
IE1vbiwgMTEgSmFuIDIwMjEgMTg6MDk6NDkgLTA4MDAgd2FuZ3lpbmdqaWU1NUAxMjYuY29tIHdy
b3RlOg0KPj4gRnJvbTogWWluZ2ppZSBXYW5nIDx3YW5neWluZ2ppZTU1QDEyNi5jb20+DQo+PiAN
Cj4+IEluIHJ2dV9tYm94X2hhbmRsZXJfY2d4X21hY19hZGRyX2dldCgpDQo+PiBhbmQgcnZ1X21i
b3hfaGFuZGxlcl9jZ3hfbWFjX2FkZHJfc2V0KCksDQo+PiB0aGUgbXNnIGlzIGV4cGVjdGVkIG9u
bHkgZnJvbSBQRnMgdGhhdCBhcmUgbWFwcGVkIHRvIENHWCBMTUFDcy4NCj4+IEl0IHNob3VsZCBi
ZSBjaGVja2VkIGJlZm9yZSBtYXBwaW5nLA0KPj4gc28gd2UgYWRkIHRoZSBpc19jZ3hfY29uZmln
X3Blcm1pdHRlZCgpIGluIHRoZSBmdW5jdGlvbnMuDQo+PiANCj4+IEZpeGVzOiAyODllMjBiYzFh
YjUgKCJhZi9ydnVfY2d4OiBGaXggbWlzc2luZyBjaGVjayBidWdzIGluIHJ2dV9jZ3guYyIpDQo+
PiBTaWduZWQtb2ZmLWJ5OiBZaW5namllIFdhbmcgPHdhbmd5aW5namllNTVAMTI2LmNvbT4NCj4N
Cj4NCj5GaXhlcyB0YWc6IEZpeGVzOiAyODllMjBiYzFhYjUgKCJhZi9ydnVfY2d4OiBGaXggbWlz
c2luZyBjaGVjayBidWdzIGluIHJ2dV9jZ3guYyIpDQo+SGFzIHRoZXNlIHByb2JsZW0ocyk6DQo+
CS0gVGFyZ2V0IFNIQTEgZG9lcyBub3QgZXhpc3QNCj4NCj5XaGVyZSBpcyB0aGF0IGNvbW1pdCBm
cm9tPyBZb3UncmUgbm90IHJlZmVycmluZyB0byB0aGlzIGNvbW1pdCBpdHNlbGYNCj5pbiB5b3Vy
IHRyZWU/IFRoZSBzdWJqZWN0IGlzIHN1c3BpY2lvdXNseSBzaW1pbGFyIDpTDQo=
