Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B880975C17
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 02:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfGZA0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 20:26:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGZA0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 20:26:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5417212650647;
        Thu, 25 Jul 2019 17:26:23 -0700 (PDT)
Date:   Thu, 25 Jul 2019 17:26:22 -0700 (PDT)
Message-Id: <20190725.172622.69380355082748817.davem@davemloft.net>
To:     himadrispandya@gmail.com
Cc:     mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, himadri18.07@gmail.com
Subject: Re: [PATCH] hv_sock: use HV_HYP_PAGE_SIZE instead of PAGE_SIZE_4K
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190725051125.10605-1-himadri18.07@gmail.com>
References: <20190725051125.10605-1-himadri18.07@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jul 2019 17:26:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSGltYWRyaSBQYW5keWEgPGhpbWFkcmlzcGFuZHlhQGdtYWlsLmNvbT4NCkRhdGU6IFRo
dSwgMjUgSnVsIDIwMTkgMDU6MTE6MjUgKzAwMDANCg0KPiBPbGRlciB3aW5kb3dzIGhvc3RzIHJl
cXVpcmUgdGhlIGh2X3NvY2sgcmluZyBidWZmZXIgdG8gYmUgZGVmaW5lZA0KPiB1c2luZyA0SyBw
YWdlcy4gVGhpcyB3YXMgYWNoaWV2ZWQgYnkgdXNpbmcgdGhlIHN5bWJvbCBQQUdFX1NJWkVfNEsN
Cj4gZGVmaW5lZCBzcGVjaWZpY2FsbHkgZm9yIHRoaXMgcHVycG9zZS4gQnV0IG5vdyB3ZSBoYXZl
IGEgbmV3IHN5bWJvbA0KPiBIVl9IWVBfUEFHRV9TSVpFIGRlZmluZWQgaW4gaHlwZXJ2LXRsZnMg
d2hpY2ggY2FuIGJlIHVzZWQgZm9yIHRoaXMuDQo+IA0KPiBUaGlzIHBhdGNoIHJlbW92ZXMgdGhl
IGRlZmluaXRpb24gb2Ygc3ltYm9sIFBBR0VfU0laRV80SyBhbmQgcmVwbGFjZXMNCj4gaXRzIHVz
YWdlIHdpdGggdGhlIHN5bWJvbCBIVl9IWVBfUEFHRV9TSVpFLiBUaGlzIHBhdGNoIGFsc28gYWxp
Z25zDQo+IHNuZGJ1ZiBhbmQgcmN2YnVmIHRvIGh5cGVyLXYgc3BlY2lmaWMgcGFnZSBzaXplIHVz
aW5nIEhWX0hZUF9QQUdFX1NJWkUNCj4gaW5zdGVhZCBvZiB0aGUgZ3Vlc3QgcGFnZSBzaXplKFBB
R0VfU0laRSkgYXMgaHlwZXItdiBleHBlY3RzIHRoZSBwYWdlDQo+IHNpemUgdG8gYmUgNEsgYW5k
IGl0IG1pZ2h0IG5vdCBiZSB0aGUgY2FzZSBvbiBBUk02NCBhcmNoaXRlY3R1cmUuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBIaW1hZHJpIFBhbmR5YSA8aGltYWRyaTE4LjA3QGdtYWlsLmNvbT4NCg0K
VGhpcyBkb2Vzbid0IGNvbXBpbGU6DQoNCiAgQ0MgW01dICBuZXQvdm13X3Zzb2NrL2h5cGVydl90
cmFuc3BvcnQubw0KbmV0L3Ztd192c29jay9oeXBlcnZfdHJhbnNwb3J0LmM6NTg6Mjg6IGVycm9y
OiChSFZfSFlQX1BBR0VfU0laRaIgdW5kZWNsYXJlZCBoZXJlIChub3QgaW4gYSBmdW5jdGlvbik7
IGRpZCB5b3UgbWVhbiChSFZfTUVTU0FHRV9TSVpFoj8NCiAjZGVmaW5lIEhWU19TRU5EX0JVRl9T
SVpFIChIVl9IWVBfUEFHRV9TSVpFIC0gc2l6ZW9mKHN0cnVjdCB2bXBpcGVfcHJvdG9faGVhZGVy
KSkNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+DQo=
