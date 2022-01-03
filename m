Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA48483613
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiACRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:31:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39322 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbiACRbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:31:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44653B8107A;
        Mon,  3 Jan 2022 17:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F41C36AF9;
        Mon,  3 Jan 2022 17:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231065;
        bh=zmfqkjRv2inCV6030DusFTVgg7tQKcUyuxImduqerds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPnvRMP3Sa8aJbYsu4LBCKwY+ZmQx9sTJpXeo3exR4eFTTkMM76O/XBFoidp630zw
         +x7kuJxrpHTxvl8Z6J+3J9oQ/SuSg0o7+rGTWyBw3xrQKrrotHZA7SGjXEgmSL29kL
         KwD7WrymxJvkEMIyYnSQqPbTaSUbX1uFiUHjgWRarinCtz0Nw01ZGGubPbLKkkBzh7
         +GfxHe5DNEYexJ8QX/huhdkFJ54DS4RzgqAlgRJbSVI7Si4JXUUwAssHXfN2oP3nts
         Uv0qJqyI3rizOLs4KwAUSCqb68dsCoTc7jRT6QFK4DJltZSUwl7XH4dSZthO1xIsDM
         IbHXr22TONIPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wolfgang huang <huangjinhui@kylinos.cn>,
        k2ci <kernel-bot@kylinos.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/4] mISDN: change function names to avoid conflicts
Date:   Mon,  3 Jan 2022 12:30:46 -0500
Message-Id: <20220103173047.1613630-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173047.1613630-1-sashal@kernel.org>
References: <20220103173047.1613630-1-sashal@kernel.org>
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
index faf505462a4f5..f5a06a6fb297f 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -390,7 +390,7 @@ mISDNInit(void)
 	err = mISDN_inittimer(&debug);
 	if (err)
 		goto error2;
-	err = l1_init(&debug);
+	err = Isdnl1_Init(&debug);
 	if (err)
 		goto error3;
 	err = Isdnl2_Init(&debug);
@@ -404,7 +404,7 @@ mISDNInit(void)
 error5:
 	Isdnl2_cleanup();
 error4:
-	l1_cleanup();
+	Isdnl1_cleanup();
 error3:
 	mISDN_timer_cleanup();
 error2:
@@ -417,7 +417,7 @@ static void mISDN_cleanup(void)
 {
 	misdn_sock_cleanup();
 	Isdnl2_cleanup();
-	l1_cleanup();
+	Isdnl1_cleanup();
 	mISDN_timer_cleanup();
 	class_unregister(&mISDN_class);
 
diff --git a/drivers/isdn/mISDN/core.h b/drivers/isdn/mISDN/core.h
index 52695bb81ee7a..3c039b6ade2e1 100644
--- a/drivers/isdn/mISDN/core.h
+++ b/drivers/isdn/mISDN/core.h
@@ -69,8 +69,8 @@ struct Bprotocol	*get_Bprotocol4id(u_int);
 extern int	mISDN_inittimer(u_int *);
 extern void	mISDN_timer_cleanup(void);
 
-extern int	l1_init(u_int *);
-extern void	l1_cleanup(void);
+extern int	Isdnl1_Init(u_int *);
+extern void	Isdnl1_cleanup(void);
 extern int	Isdnl2_Init(u_int *);
 extern void	Isdnl2_cleanup(void);
 
diff --git a/drivers/isdn/mISDN/layer1.c b/drivers/isdn/mISDN/layer1.c
index bebc57b72138e..94d7cc58da648 100644
--- a/drivers/isdn/mISDN/layer1.c
+++ b/drivers/isdn/mISDN/layer1.c
@@ -407,7 +407,7 @@ create_l1(struct dchannel *dch, dchannel_l1callback *dcb) {
 EXPORT_SYMBOL(create_l1);
 
 int
-l1_init(u_int *deb)
+Isdnl1_Init(u_int *deb)
 {
 	debug = deb;
 	l1fsm_s.state_count = L1S_STATE_COUNT;
@@ -419,7 +419,7 @@ l1_init(u_int *deb)
 }
 
 void
-l1_cleanup(void)
+Isdnl1_cleanup(void)
 {
 	mISDN_FsmFree(&l1fsm_s);
 }
-- 
2.34.1

