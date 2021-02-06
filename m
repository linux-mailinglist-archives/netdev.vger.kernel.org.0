Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B483118F1
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhBFCvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbhBFCk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:40:59 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CF8C08EE0E;
        Fri,  5 Feb 2021 16:02:05 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id o20so5403994pfu.0;
        Fri, 05 Feb 2021 16:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O0vKLYfAmXc0/k0ACT3lqtKu7s9dM9QFfP8g5XRQnj4=;
        b=FZDuDo2+WqlhvtUQ6FDDDGn5OT14iJXX3p6qk78+UhEifqBB1bwWzYqvXkqq/mxuQn
         nBiZd8oTg0NS67pNccJL2jNtIzicVzNGo0oFxQJpfO/PAaidDr1r3aI164Fn+zsKyxga
         /upKftLaLzlNvEyM4xdQSjiSdhaBO0lSLyKqAhRUn85QBxYUhbxlrOBhV0M+BIn/sTUj
         B21nsLc65Jr9OxJ+lOCLe5ObluI8z+K4hMOub6jF3m2zsJONjRRekLUpQJxVxL2nhLQf
         sDorwWbrQM3Nj/+/cUnOCBNNvAnG5/61a5TdJLJWqQtRLNBso4NSfaVQi33NQXLLglEd
         4FFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O0vKLYfAmXc0/k0ACT3lqtKu7s9dM9QFfP8g5XRQnj4=;
        b=cCJN5SsT0jhocT8RF8Z9dC8thfxibcKt5imBO2/Z6TQFkQnmlllT9l77HUbdrREidY
         PcRGvGU/1A6P0ub5xor9BsVap46c/TcV1t9HJFL5ny95sb/Y5VYNSWeBgKP27eDOoaNb
         MlIM5I42BbqYgUHAN3sM69TlzzIWXrYavT/3sYsQzt+va6y9n9f1gY9mI7fCMZOjH5Rm
         6ieCS48ABa4e7/uu7T0RjEnGiih60KJNivbVGQWqqmeuLf/q9hWsnV0DZlKZfos5jVvr
         HyOFp23jhITjgBZEFQ65ph6P119OUQm/ODtbKPPvRVpQgD0gKAEF5nF7JWX8LBQs5TbU
         Ejow==
X-Gm-Message-State: AOAM53330XGwTOM9wNIjuTp8rHmZ4ojgiqrr2F/hNo1Px6Q83A/LtK4I
        3gVwh+blq85NmbiMFb/vTxg=
X-Google-Smtp-Source: ABdhPJyfCJlUhXX9huFfITKMzkEnYela6H+5eB8eIlJAZxrH+kYruQ+IjtHEP+bS8n7fheNJ2gh4/w==
X-Received: by 2002:a63:4f09:: with SMTP id d9mr6993846pgb.70.1612569724851;
        Fri, 05 Feb 2021 16:02:04 -0800 (PST)
Received: from amypc-samantha.home ([47.145.126.51])
        by smtp.gmail.com with ESMTPSA id r189sm11771724pgr.10.2021.02.05.16.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 16:02:04 -0800 (PST)
From:   Amy Parker <enbyamy@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, akpm@linux-foundation.org,
        rppt@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amy Parker <enbyamy@gmail.com>
Subject: [PATCH 2/3] drivers/net/ethernet/amd: Fix bracket matching and line levels
Date:   Fri,  5 Feb 2021 16:01:45 -0800
Message-Id: <20210206000146.616465-3-enbyamy@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206000146.616465-1-enbyamy@gmail.com>
References: <20210206000146.616465-1-enbyamy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some statements - often if statements - do not follow the kernel
style guide regarding what lines brackets and pairs should be on.
This patch fixes those style violations.

Signed-off-by: Amy Parker <enbyamy@gmail.com>
---
 drivers/net/ethernet/amd/atarilance.c | 13 +++++--------
 drivers/net/ethernet/amd/sun3lance.c  |  7 +++----
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/amd/atarilance.c b/drivers/net/ethernet/amd/atarilance.c
index 141244c5ca4e..9ec44cf4ba9c 100644
--- a/drivers/net/ethernet/amd/atarilance.c
+++ b/drivers/net/ethernet/amd/atarilance.c
@@ -543,12 +543,11 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 		/* Switch back to Ram */
 		i = IO->mem;
 		lp->cardtype = PAM_CARD;
-	}
-	else if (*RIEBL_MAGIC_ADDR == RIEBL_MAGIC) {
+	} else if (*RIEBL_MAGIC_ADDR == RIEBL_MAGIC) {
 		lp->cardtype = NEW_RIEBL;
-	}
-	else
+	} else {
 		lp->cardtype = OLD_RIEBL;
+	}
 
 	if (lp->cardtype == PAM_CARD ||
 		memaddr == (unsigned short *)0xffe00000) {
@@ -559,8 +558,7 @@ static unsigned long __init lance_probe1( struct net_device *dev,
 			return 0;
 		}
 		dev->irq = IRQ_AUTO_5;
-	}
-	else {
+	} else {
 		/* For VME-RieblCards, request a free VME int */
 		unsigned int irq = atari_register_vme_int();
 		if (!irq) {
@@ -993,8 +991,7 @@ static int lance_rx( struct net_device *dev )
 			if (pkt_len < 60) {
 				printk( "%s: Runt packet!\n", dev->name );
 				dev->stats.rx_errors++;
-			}
-			else {
+			} else {
 				skb = netdev_alloc_skb(dev, pkt_len + 2);
 				if (skb == NULL) {
 					for (i = 0; i < RX_RING_SIZE; i++)
diff --git a/drivers/net/ethernet/amd/sun3lance.c b/drivers/net/ethernet/amd/sun3lance.c
index ca7b6e483d2a..c7af742f63ad 100644
--- a/drivers/net/ethernet/amd/sun3lance.c
+++ b/drivers/net/ethernet/amd/sun3lance.c
@@ -757,7 +757,7 @@ static irqreturn_t lance_interrupt( int irq, void *dev_id)
 
 	REGA(CSR0) = CSR0_INEA;
 
-	if(DREG & (CSR0_RINT | CSR0_TINT)) {
+	if (DREG & (CSR0_RINT | CSR0_TINT)) {
 	     DPRINTK(2, ("restarting interrupt, csr0=%#04x\n", DREG));
 	     goto still_more;
 	}
@@ -774,7 +774,7 @@ static int lance_rx( struct net_device *dev )
 	int entry = lp->new_rx;
 
 	/* If we own the next entry, it's a new packet. Send it up. */
-	while( (MEM->rx_head[entry].flag & RMD1_OWN) == RMD1_OWN_HOST ) {
+	while ((MEM->rx_head[entry].flag & RMD1_OWN) == RMD1_OWN_HOST) {
 		struct lance_rx_head *head = &(MEM->rx_head[entry]);
 		int status = head->flag;
 
@@ -799,8 +799,7 @@ static int lance_rx( struct net_device *dev )
 			if (pkt_len < 60) {
 				printk( "%s: Runt packet!\n", dev->name );
 				dev->stats.rx_errors++;
-			}
-			else {
+			} else {
 				skb = netdev_alloc_skb(dev, pkt_len + 2);
 				if (skb == NULL) {
 					dev->stats.rx_dropped++;
-- 
2.29.2

