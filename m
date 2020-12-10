Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59AF2D6723
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404296AbgLJTnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:43:12 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56030 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390140AbgLJTnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:43:00 -0500
Message-Id: <20201210192536.118432146@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607629334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dqmaBUU1aX3t41xhFMZZXhwmlvXhIHW8LZkxAL3qIuw=;
        b=h/TAwStAiTk4XvWiKPBPyDEOx218hZJC1vmF2rxVMRIvmco9q+UXf8EllPz4AjaFdOly7G
        LH+a53gOb/6x23hHUexy7zt6RJrXCLvlfH0RT7UmulMioZYuYNOHYckgeF+NjT2uTUeh+Y
        x4QOtIuHWxwLs6LKhedv+5hufAepZeedXGgORll6jDA+oynwB+JjiqXx/tgkxTCP8dbJ6L
        eWUOoe8IS6Z7h2dgCBQQBehNHm1Tfe56GXWt3TBc5qz2bsl6Xo6wT+1/DTPysSy3XD7/6K
        p0j9T2Hw/f1US+iZCI2FQmyJpu2ijKWYz9OMLgGwEfvXwTDnGAF9V1bHZmS/0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607629334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dqmaBUU1aX3t41xhFMZZXhwmlvXhIHW8LZkxAL3qIuw=;
        b=njYD6xBoyWobXQbQRXgtO58qqL+V8jLaqaWB6hUvHzVko4O9Y0w527+7oT5RC78ucYDSLL
        sPAJGjvbV9zCgIAw==
Date:   Thu, 10 Dec 2020 20:25:36 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        linux-parisc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Wambui Karuga <wambui.karugax@gmail.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jon Mason <jdmason@kudzu.us>,
        Dave Jiang <dave.jiang@intel.com>,
        Allen Hubbe <allenbh@gmail.com>, linux-ntb@googlegroups.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-pci@vger.kernel.org,
        Karthikeyan Mitran <m.karthikeyan@mobiveil.co.in>,
        Hou Zhiqiang <Zhiqiang.Hou@nxp.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org
Subject: [patch 00/30] genirq: Treewide hunt for irq descriptor abuse and
 assorted fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QSByZWNlbnQgcmVxdWVzdCB0byBleHBvcnQga3N0YXRfaXJxcygpIHBvaW50ZWQgdG8gYSBjb3B5
IG9mIHRoZSBzYW1lIGluCnRoZSBpOTE1IGNvZGUsIHdoaWNoIG1hZGUgbWUgbG9vayBmb3IgZnVy
dGhlciB1c2FnZSBvZiBpcnEgZGVzY3JpcHRvcnMgaW4KZHJpdmVycy4KClRoZSB1c2FnZSBpbiBk
cml2ZXJzIHJhbmdlcyBmcm9tIGNyZWF0aXZlIHRvIGJyb2tlbiBpbiBhbGwgY29sb3Vycy4KCmly
cWRlc2MuaCBjbGVhcmx5IHNheXMgdGhhdCB0aGlzIGlzIGNvcmUgZnVuY3Rpb25hbGl0eSBhbmQg
dGhlIGZhY3QgQyBkb2VzCm5vdCBhbGxvdyBmdWxsIGVuY2Fwc3VsYXRpb24gaXMgbm90IGEganVz
dGlmaWNhdGlvbiB0byBmaWRkbGUgd2l0aCBpdCBqdXN0CmJlY2F1c2UuIEl0IHRvb2sgdXMgYSBs
b3Qgb2YgZWZmb3J0IHRvIG1ha2UgdGhlIGNvcmUgZnVuY3Rpb25hbGl0eSBwcm92aWRlCndoYXQg
ZHJpdmVycyBuZWVkLgoKSWYgdGhlcmUgaXMgYSBzaG9ydGNvbWluZywgaXQncyBub3QgYXNrZWQg
dG9vIG11Y2ggdG8gdGFsayB0byB0aGUgcmVsZXZhbnQKbWFpbnRhaW5lcnMgaW5zdGVhZCBvZiBn
b2luZyBvZmYgYW5kIGZpZGRsaW5nIHdpdGggdGhlIGd1dHMgb2YgaW50ZXJydXB0CmRlc2NyaXB0
b3JzIGFuZCBvZnRlbiBlbm91Z2ggd2l0aG91dCB1bmRlcnN0YW5kaW5nIGxpZmV0aW1lIGFuZCBs
b2NraW5nCnJ1bGVzLgoKQXMgcGVvcGxlIGluc2lzdCBvbiBub3QgcmVzcGVjdGluZyBib3VuZGFy
aWVzLCB0aGlzIHNlcmllcyBjbGVhbnMgdXAgdGhlCihhYil1c2UgYW5kIGF0IHRoZSBlbmQgcmVt
b3ZlcyB0aGUgZXhwb3J0IG9mIGlycV90b19kZXNjKCkgdG8gbWFrZSBpdCBhdApsZWFzdCBoYXJk
ZXIuIEFsbCBsZWdpdGltYXRlIHVzZXJzIG9mIHRoaXMgYXJlIGJ1aWx0IGluLgoKV2hpbGUgYXQg
aXQgSSBzdHVtYmxlZCBvdmVyIHNvbWUgb3RoZXIgb2RkaXRpZXMgcmVsYXRlZCB0byBpbnRlcnJ1
cHQKY291bnRpbmcgYW5kIGNsZWFuZWQgdGhlbSB1cCBhcyB3ZWxsLgoKVGhlIHNlcmllcyBhcHBs
aWVzIG9uIHRvcCBvZgoKICAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3RpcC90aXAuZ2l0IGlycS9jb3JlCgphbmQgaXMgYWxzbyBhdmFpbGFibGUgZnJvbSBn
aXQ6CgogIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90Z2x4
L2RldmVsLmdpdCBnZW5pcnEKClRoYW5rcywKCgl0Z2x4Ci0tLQogYXJjaC9hbHBoYS9rZXJuZWwv
c3lzX2plbnNlbi5jICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIgCiBhcmNoL2FybS9rZXJu
ZWwvc21wLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiAKIGFyY2gvcGFy
aXNjL2tlcm5lbC9pcnEuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA3IAogYXJj
aC9zMzkwL2tlcm5lbC9pcnEuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDIg
CiBhcmNoL3g4Ni9rZXJuZWwvdG9wb2xvZ3kuYyAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAgMSAKIGFyY2gvYXJtNjQva2VybmVsL3NtcC5jICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgICAyIAogZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9scGVfYXVkaW8u
YyAgICAgICB8ICAgIDQgCiBkcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2lycS5jICAgICAgICAg
ICAgICAgICAgICAgIHwgICAzNCArKysKIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfcG11LmMg
ICAgICAgICAgICAgICAgICAgICAgfCAgIDE4IC0KIGRyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVf
cG11LmggICAgICAgICAgICAgICAgICAgICAgfCAgICA4IAogZHJpdmVycy9tZmQvYWI4NTAwLWRl
YnVnZnMuYyAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMTYgLQogZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NC9lbl9jcS5jICAgICAgICAgICB8ICAgIDggCiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX3J4LmMgICAgICAgICAgIHwgICAgNiAKIGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvbWx4NF9lbi5oICAgICAgICAgfCAgICAzIAog
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmggICAgICAgICB8ICAg
IDIgCiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jICAg
IHwgICAgMiAKIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90eHJ4
LmMgICAgfCAgICA2IAogZHJpdmVycy9udGIvbXNpLmMgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAgIDQgCiBkcml2ZXJzL3BjaS9jb250cm9sbGVyL21vYml2ZWlsL3BjaWUt
bW9iaXZlaWwtaG9zdC5jIHwgICAgOCAKIGRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvcGNpZS14aWxp
bngtbndsLmMgICAgICAgICAgICAgfCAgICA4IAogZHJpdmVycy9waW5jdHJsL25vbWFkaWsvcGlu
Y3RybC1ub21hZGlrLmMgICAgICAgICAgICB8ICAgIDMgCiBkcml2ZXJzL3hlbi9ldmVudHMvZXZl
bnRzX2Jhc2UuYyAgICAgICAgICAgICAgICAgICAgIHwgIDE3MiArKysrKysrKysrKy0tLS0tLS0t
CiBkcml2ZXJzL3hlbi9ldnRjaG4uYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAzNCAtLS0KIGluY2x1ZGUvbGludXgvaW50ZXJydXB0LmggICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAxIAogaW5jbHVkZS9saW51eC9pcnEuaCAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICAgIDcgCiBpbmNsdWRlL2xpbnV4L2lycWRlc2MuaCAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgICA0MCArLS0tCiBpbmNsdWRlL2xpbnV4L2tlcm5lbF9zdGF0Lmgg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMSAKIGtlcm5lbC9pcnEvaXJxZGVzYy5jICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDQyICsrLS0KIGtlcm5lbC9pcnEvbWFu
YWdlLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDM3ICsrKysKIGtlcm5l
bC9pcnEvcHJvYy5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA1IAog
MzAgZmlsZXMgY2hhbmdlZCwgMjYzIGluc2VydGlvbnMoKyksIDIyMiBkZWxldGlvbnMoLSkKCgo=
