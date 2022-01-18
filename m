Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AC24914BB
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245415AbiARCXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244399AbiARCWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73905C06176A;
        Mon, 17 Jan 2022 18:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 384EBB8124B;
        Tue, 18 Jan 2022 02:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B04AC36AE3;
        Tue, 18 Jan 2022 02:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472560;
        bh=5jX8eDGS27Wfmkc8/P9LsCE6OkLNSfvuJ5z8AnFEDeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z7cvNur5/5h5fzJy9wAVWFmAURs6yBfJCxiNT0FaQtObyffcUL/utd3pFeK+wMmHV
         J1e1FZZazgY0vmJ0nP04LyA14ZYy79CSasYMYkqm9gowaEmFIEMQiVE7AHRgsrmU5Z
         cik/tEwKVYS+mN085UjhraznX/GDNclvM5xOvSiJb5OCuBEmMi5XaDF65yYQulKHhE
         QD3EpgI2UnnBXcyhQBRvbYo7grQUugiL7oCISf/0Y2JIx53A/S2dN6BED0DnhhExot
         OQGTzp2qiYQ9fPWO4RP4mv+PIBy3/VxuPmBEqgoIszDUoWa+sqxdKC2cvz1IPkSnJG
         XE4HhfwOUss5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, geert@linux-m68k.org,
        linux@roeck-us.net, arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 053/217] 82596: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:56 -0500
Message-Id: <20220118021940.1942199-53-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0f98d7e478430b64d9520a23585e02be5f8b1b2a ]

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/82596.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index b482f6f633bd5..3ee89ae496d0c 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1178,7 +1178,8 @@ static struct net_device * __init i82596_probe(void)
 	DEB(DEB_PROBE,printk(KERN_INFO "%s: 82596 at %#3lx,", dev->name, dev->base_addr));
 
 	for (i = 0; i < 6; i++)
-		DEB(DEB_PROBE,printk(" %2.2X", dev->dev_addr[i] = eth_addr[i]));
+		DEB(DEB_PROBE,printk(" %2.2X", eth_addr[i]));
+	eth_hw_addr_set(dev, eth_addr);
 
 	DEB(DEB_PROBE,printk(" IRQ %d.\n", dev->irq));
 
-- 
2.34.1

