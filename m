Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5FC491CB8
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349612AbiARDRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348330AbiARDI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F681C0617AE;
        Mon, 17 Jan 2022 18:49:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DC4D6131D;
        Tue, 18 Jan 2022 02:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85C4C36AE3;
        Tue, 18 Jan 2022 02:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474193;
        bh=XVsmnyv4Ulff/NO0DZllEzHOmfrnZ5ncioGnDKZqoAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uM+glBQaytPesDZwf9lAyO1paaq0OXOEFJantRB5TqsGm3eTH8Fu0jewPYHgQ5Jkk
         HMIh9HUBxUXrheMMsv75qiLgVuAtk9J8RvRZSE7jM2kv9wW7KvHaEXRAn0eKEG8JUJ
         O9dAiiyOu4oDquEaz4HT0fydEHkkL/0PPfvgMHBtCK6cmJz7oqGf4EoAw+omvHueXE
         PfD+tVJsX9NSTF1iTjmxeNWwpkAVt8+0nodbzrxbsg3NBEw44gC3U2yGV7ksGbdDvf
         ho8N28cf6CQzqdwvs+VUDRAitNJ5q0B0HD5CNZbPMkxWbya2ApqBlTcq4LPUotWJwf
         aQEZJU2Wo7sKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, geert@linux-m68k.org,
        arnd@arndb.de, linux@roeck-us.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/56] 82596: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:48:27 -0500
Message-Id: <20220118024908.1953673-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
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
index 8efcec305fc54..78ba704b2dad7 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1189,7 +1189,8 @@ struct net_device * __init i82596_probe(int unit)
 	DEB(DEB_PROBE,printk(KERN_INFO "%s: 82596 at %#3lx,", dev->name, dev->base_addr));
 
 	for (i = 0; i < 6; i++)
-		DEB(DEB_PROBE,printk(" %2.2X", dev->dev_addr[i] = eth_addr[i]));
+		DEB(DEB_PROBE,printk(" %2.2X", eth_addr[i]));
+	eth_hw_addr_set(dev, eth_addr);
 
 	DEB(DEB_PROBE,printk(" IRQ %d.\n", dev->irq));
 
-- 
2.34.1

