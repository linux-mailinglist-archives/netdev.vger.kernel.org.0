Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25C8457081
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbhKSOZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234153AbhKSOZB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:25:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38B3E619E3;
        Fri, 19 Nov 2021 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637331719;
        bh=ObjlzSSc6zXhLBR5qUb4Ep81Fd1cdZXLkAJfMZD9T78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZobsV7EYav47A3NK2NkTAMS8m+2H+qaUFDgEd+cLdJuaXYPORV9BKsctVfsi37GWq
         ieT+jfWFkgVPllJwph7H4+gOmrmQn/8IfeZGDSq5YGFlzMBW7TgwAQEBzY6xMO5uVr
         DvJrMBSFNt5OzCSGhc4pu8x782vJyq2cdxy/DUl+Ttn3p7CC5IXAomHwHhmzyHSg5q
         oJjQa8SKZc9rKh9ghzp8pjXnnxpEeSZOF3g9xDAYGcsnduc77GH2a7JvaTZX8KKB9V
         GLnDlifjw+61mgb9+a3vRdF/sOgUqmY2wxdsYp6tARKTnXYKXrJ6c4AFMHN067fBuP
         V+7dRVZLzi4pw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/7] 82596: use eth_hw_addr_set()
Date:   Fri, 19 Nov 2021 06:21:49 -0800
Message-Id: <20211119142155.3779933-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
References: <20211119142155.3779933-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Byte by byte assignments.

Fixes build on m68k.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/i825xx/82596.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index b482f6f633bd..3ee89ae496d0 100644
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
2.31.1

