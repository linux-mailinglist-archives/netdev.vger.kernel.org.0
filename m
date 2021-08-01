Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656B83DC91C
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 02:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhHAAcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 20:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhHAAcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 20:32:05 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A431C06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:31:57 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id l17so18747733ljn.2
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bCU/R1mmHlbbevDdwtP2FA+V7sb4oKSQDwcW3c0idv4=;
        b=TzPuLKRxFvxmQSYAFT1bj490n+hKbcgZw+6OY8YHwTXVbSNt7xiSIh/qsDwBU7Ka/U
         tsvmARO1AeGNQ0gagJC1rS4xpb/4hE+1H8w+qjpeyLRpiSx0MlD7Vag4cgcMiM0Re7TE
         c15DLZyOw4g6z27TDys8ufBdtDK8ndB5MONsyO8qGUYSLR1QMqGjmY6KzLR8V9c50FKm
         ubFaEVX4nRFd0twztrrPrafQ24Bgx/Nej50XrIem4G2b/cf6GkGAjWLjbb1CVaYGLN7J
         6oRhppEV1LHGh+YqaCIsfnt5Pj6Q++26SuPYnXt9GXfhNovyg/kaWpwJXzLEQGDA6/IU
         +Hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bCU/R1mmHlbbevDdwtP2FA+V7sb4oKSQDwcW3c0idv4=;
        b=bfvuPO4cP7nyGLEfPZwhE7YZALmz0B4+8AJDG+eDlQBrV1aBRz/6r4dSI8Ymb5nQdJ
         QLPiUYApXSEs0y/rANpkphs5bV9etF7JK9r/8ToU+ncCOaxm9pUq22t8RqFKR4HHF90/
         Dh6AZXDVFM4AoXTpOH40A5eNXI+qxUaDwmqeF0lSKVJvBrP76o4E5UfcHn+o8ersRcgo
         BLpkpZKQMfMQYx+HMCl/BhhUAvIro9IiKwwqGkFkl0+RX5g6a3GS2l8ng5rFQG27q9nr
         YgwdbmUY0QdOrev3sBF2j2J2R8vDwqX1UKZB+bUA1d1IPE9cQ1XjyLhdkkWnl2Zv/6Td
         uuYA==
X-Gm-Message-State: AOAM531zEwwIZNASYqvzesWmhSHaRLAjjFEre6LIY8f1tmKu6wBED2Sm
        SyrlWpfunVM9Wh3My8Tn93Mgfc98vr231A==
X-Google-Smtp-Source: ABdhPJyQGnl9HdjZq8P2Q5YpmByAuNEqmOr5GTCCk0U/xpSk7H+vGIYRVtog+XpNquAiWtYn8tMkZA==
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr6663219ljg.214.1627777915705;
        Sat, 31 Jul 2021 17:31:55 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r6sm485255ljk.76.2021.07.31.17.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 17:31:55 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 2/6] ixp4xx_eth: fix compile-testing
Date:   Sun,  1 Aug 2021 02:27:33 +0200
Message-Id: <20210801002737.3038741-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210801002737.3038741-1-linus.walleij@linaro.org>
References: <20210801002737.3038741-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Change the driver to use portable integer types to avoid warnings
during compile testing, including:

drivers/net/ethernet/xscale/ixp4xx_eth.c:721:21: error: cast to 'u32 *' (aka 'unsigned int *') from smaller integer type 'int' [-Werror,-Wint-to-pointer-cast]
        memcpy_swab32(mem, (u32 *)((int)skb->data & ~3), bytes / 4);
                           ^
drivers/net/ethernet/xscale/ixp4xx_eth.c:963:12: error: incompatible pointer types passing 'u32 *' (aka 'unsigned int *') to parameter of type 'dma_addr_t *' (aka 'unsigned long long *') [-Werror,-Wincompatible-pointer-types]
                                              &port->desc_tab_phys)))
                                              ^~~~~~~~~~~~~~~~~~~~
include/linux/dmapool.h:27:20: note: passing argument to parameter 'handle' here
                     dma_addr_t *handle);
                                 ^

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 32dc2c7abb22..253ac8f3cb56 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -37,7 +37,6 @@
 #include <linux/module.h>
 #include <linux/soc/ixp4xx/npe.h>
 #include <linux/soc/ixp4xx/qmgr.h>
-#include <mach/hardware.h>
 #include <linux/soc/ixp4xx/cpu.h>
 
 #include "ixp46x_ts.h"
@@ -177,7 +176,7 @@ struct port {
 	struct eth_plat_info *plat;
 	buffer_t *rx_buff_tab[RX_DESCS], *tx_buff_tab[TX_DESCS];
 	struct desc *desc_tab;	/* coherent */
-	u32 desc_tab_phys;
+	dma_addr_t desc_tab_phys;
 	int id;			/* logical port ID */
 	int speed, duplex;
 	u8 firmware[4];
@@ -857,14 +856,14 @@ static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	bytes = len;
 	mem = skb->data;
 #else
-	offset = (int)skb->data & 3; /* keep 32-bit alignment */
+	offset = (uintptr_t)skb->data & 3; /* keep 32-bit alignment */
 	bytes = ALIGN(offset + len, 4);
 	if (!(mem = kmalloc(bytes, GFP_ATOMIC))) {
 		dev_kfree_skb(skb);
 		dev->stats.tx_dropped++;
 		return NETDEV_TX_OK;
 	}
-	memcpy_swab32(mem, (u32 *)((int)skb->data & ~3), bytes / 4);
+	memcpy_swab32(mem, (u32 *)((uintptr_t)skb->data & ~3), bytes / 4);
 #endif
 
 	phys = dma_map_single(&dev->dev, mem, bytes, DMA_TO_DEVICE);
-- 
2.31.1

