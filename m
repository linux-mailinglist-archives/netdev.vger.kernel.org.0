Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499EB4835D9
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbiACRag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbiACRaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F46C0617A0;
        Mon,  3 Jan 2022 09:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 850A96112B;
        Mon,  3 Jan 2022 17:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17581C36AEE;
        Mon,  3 Jan 2022 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231012;
        bh=/gdLnShWLpQP/o/mRaKeBqi4pXaE52yQZMGAJPcUVUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1r0romz/guw4ccxt9TXMCOf7ViUiz3XyG6bHweprsvZbFycCpgJxeDPbj+8BHzIt
         j82W6mjhfkTcOeurwXxUUHihG4049ItRyzMcPga4i1HywQbavVR35aDBZoJ2GNXmZ1
         QZxuuXt8WwmScY6JpOyFb63WVe6qIwdGqX232Mp2bzbLnNPO8kUz/4jfaxtcYOh7EY
         pXnONS+HZTU2r/lKFQ1NCY7KujHPVUslpPvQ3BOAtwiklXj19DfTdUMHagYmxD7iPu
         1cVHS+xG4tekKra8msJtOVgH6rJ6Pe14TH5GUCB2n6CwMTNkzCc5Z9EisTXFXjDFj+
         k98rXPioIj+1g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wolfgang huang <huangjinhui@kylinos.cn>,
        k2ci <kernel-bot@kylinos.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 6/8] mISDN: change function names to avoid conflicts
Date:   Mon,  3 Jan 2022 12:29:59 -0500
Message-Id: <20220103173001.1613277-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173001.1613277-1-sashal@kernel.org>
References: <20220103173001.1613277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wolfgang huang <huangjinhui@kylinos.cn>

[ Upstream commit 8b5fdfc57cc2471179d1c51081424ded833c16c8 ]

As we build for mips, we meet following error. l1_init error with
multiple definition. Some architecture devices usually marked with
l1, l2, lxx as the start-up phase. so we change the mISDN function
names, align with Isdnl2_xxx.

mips-linux-gnu-ld: drivers/isdn/mISDN/layer1.o: in function `l1_init':
(.text+0x890): multiple definition of `l1_init'; \
arch/mips/kernel/bmips_5xxx_init.o:(.text+0xf0): first defined here
make[1]: *** [home/mips/kernel-build/linux/Makefile:1161: vmlinux] Error 1

Signed-off-by: wolfgang huang <huangjinhui@kylinos.cn>
Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/core.c   | 6 +++---
 drivers/isdn/mISDN/core.h   | 4 ++--
 drivers/isdn/mISDN/layer1.c | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 55891e4204460..a41b4b2645941 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -381,7 +381,7 @@ mISDNInit(void)
 	err = mISDN_inittimer(&debug);
 	if (err)
 		goto error2;
-	err = l1_init(&debug);
+	err = Isdnl1_Init(&debug);
 	if (err)
 		goto error3;
 	err = Isdnl2_Init(&debug);
@@ -395,7 +395,7 @@ mISDNInit(void)
 error5:
 	Isdnl2_cleanup();
 error4:
-	l1_cleanup();
+	Isdnl1_cleanup();
 error3:
 	mISDN_timer_cleanup();
 error2:
@@ -408,7 +408,7 @@ static void mISDN_cleanup(void)
 {
 	misdn_sock_cleanup();
 	Isdnl2_cleanup();
-	l1_cleanup();
+	Isdnl1_cleanup();
 	mISDN_timer_cleanup();
 	class_unregister(&mISDN_class);
 
diff --git a/drivers/isdn/mISDN/core.h b/drivers/isdn/mISDN/core.h
index 23b44d3033279..42599f49c189d 100644
--- a/drivers/isdn/mISDN/core.h
+++ b/drivers/isdn/mISDN/core.h
@@ -60,8 +60,8 @@ struct Bprotocol	*get_Bprotocol4id(u_int);
 extern int	mISDN_inittimer(u_int *);
 extern void	mISDN_timer_cleanup(void);
 
-extern int	l1_init(u_int *);
-extern void	l1_cleanup(void);
+extern int	Isdnl1_Init(u_int *);
+extern void	Isdnl1_cleanup(void);
 extern int	Isdnl2_Init(u_int *);
 extern void	Isdnl2_cleanup(void);
 
diff --git a/drivers/isdn/mISDN/layer1.c b/drivers/isdn/mISDN/layer1.c
index 98a3bc6c17009..7b31c25a550e3 100644
--- a/drivers/isdn/mISDN/layer1.c
+++ b/drivers/isdn/mISDN/layer1.c
@@ -398,7 +398,7 @@ create_l1(struct dchannel *dch, dchannel_l1callback *dcb) {
 EXPORT_SYMBOL(create_l1);
 
 int
-l1_init(u_int *deb)
+Isdnl1_Init(u_int *deb)
 {
 	debug = deb;
 	l1fsm_s.state_count = L1S_STATE_COUNT;
@@ -409,7 +409,7 @@ l1_init(u_int *deb)
 }
 
 void
-l1_cleanup(void)
+Isdnl1_cleanup(void)
 {
 	mISDN_FsmFree(&l1fsm_s);
 }
-- 
2.34.1

