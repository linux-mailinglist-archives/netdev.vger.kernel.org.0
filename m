Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC74483622
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235887AbiACRcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbiACRbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:31:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E467BC061A32;
        Mon,  3 Jan 2022 09:30:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A40DAB80B4C;
        Mon,  3 Jan 2022 17:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96300C36AEE;
        Mon,  3 Jan 2022 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231046;
        bh=Ryn0r3NAKNZ9E1Jqj6JP6t4Ph3g8R6NUFHrMJ/x8N4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pToCxJCuw8Gt9iGGnsIHLL5q4VFiNAqgn5JSUmR7P5gZ3XaJnZVeT83Uk26SOrn9w
         ixR6sqVhT5aSK4RaJFDazWcsHVdSVu5xxc3kejzm0v4YlhZ+OXRVYeLlN/J3geeNU0
         zWyuXIuf2cedfMg84RJ+ytc2tqe0J/8lEpPV3Zkzr4IYhngPVBl/reTBKYXpWPhDg+
         +jurnacAa3oxmILxgw2m1n9drxdcUWMkN8pwyVf4s3CeR8zAuo2yyBbuu1oghUJD2f
         mHgwtw/CQWC2P+e7+Z7o9TOhho6zyAC4oBIsw2yTP7C6jZCSzeukYBBJLuBg3d9+Ra
         zVrgirfDWozYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     wolfgang huang <huangjinhui@kylinos.cn>,
        k2ci <kernel-bot@kylinos.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/4] mISDN: change function names to avoid conflicts
Date:   Mon,  3 Jan 2022 12:30:39 -0500
Message-Id: <20220103173039.1613564-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173039.1613564-1-sashal@kernel.org>
References: <20220103173039.1613564-1-sashal@kernel.org>
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
index 3192b0eb39445..284d3a9c7df7d 100644
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
@@ -418,7 +418,7 @@ l1_init(u_int *deb)
 }
 
 void
-l1_cleanup(void)
+Isdnl1_cleanup(void)
 {
 	mISDN_FsmFree(&l1fsm_s);
 }
-- 
2.34.1

