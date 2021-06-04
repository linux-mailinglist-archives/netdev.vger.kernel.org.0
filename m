Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E3E39BB90
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFDPTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:19:50 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54916 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhFDPTs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03qVuV/z5QIT1sBJaboojuxrUS02tPyZze9WNKWgRyc=;
        b=qHDJOl+2DFRnTHLPWmLGtEk9LFtAH95XFfHLCT61pQ6AiX+wRpOOwKvcnKZNV3HMB0si5N
        AVyCny87O4Gju85rR5c7+nr10FMuzZYiso5SY5MnGd/HIsUSPUlmvppUMiSqMDDLCMCe8I
        46F5mVKr4Qq6lciwbZY0q2aWzTTH6gU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9c8a12b9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:18:00 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH net 3/9] wireguard: do not use -O3
Date:   Fri,  4 Jun 2021 17:17:32 +0200
Message-Id: <20210604151738.220232-4-Jason@zx2c4.com>
In-Reply-To: <20210604151738.220232-1-Jason@zx2c4.com>
References: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently, various versions of gcc have O3-related miscompiles. Looking
at the difference between -O2 and -O3 for gcc 11 doesn't indicate
miscompiles, but the difference also doesn't seem so significant for
performance that it's worth risking.

Link: https://lore.kernel.org/lkml/CAHk-=wjuoGyxDhAF8SsrTkN0-YfCx7E6jUN3ikC_tn2AKWTTsA@mail.gmail.com/
Link: https://lore.kernel.org/lkml/CAHmME9otB5Wwxp7H8bR_i2uH2esEMvoBMC8uEXBMH9p0q1s6Bw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/Makefile b/drivers/net/wireguard/Makefile
index fc52b2cb500b..dbe1f8514efc 100644
--- a/drivers/net/wireguard/Makefile
+++ b/drivers/net/wireguard/Makefile
@@ -1,5 +1,4 @@
-ccflags-y := -O3
-ccflags-y += -D'pr_fmt(fmt)=KBUILD_MODNAME ": " fmt'
+ccflags-y := -D'pr_fmt(fmt)=KBUILD_MODNAME ": " fmt'
 ccflags-$(CONFIG_WIREGUARD_DEBUG) += -DDEBUG
 wireguard-y := main.o
 wireguard-y += noise.o
-- 
2.31.1

