Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF043EBE20
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhHMWDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbhHMWDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:03:06 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233EBC061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:39 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id d4so22438595lfk.9
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D7ibt3Lae3RXcE7WOmyu3z09/xMR6Le2PSBAAAdLFdU=;
        b=hVKB29Tdp9LzYodfipQgUNFoTQLBDI66LWsSnsKsthXwH/23aVidLzeYKKHAnhxWfF
         qylJUEcmwpbDttYGuNTxegmFzQLLYhwhi5LnnOQ4BQimumIO6ikoezX7NCLJsSNpPg+I
         j2aFbJUNNU5l4J4JRVeO2D7UOoQ2Zml9NaUZL7EWAIhf7Zo2AEQQK79NK7NN86gjCvPH
         b4Cqj1yzwi3mig3ORx1LqvLVxYX34wFwoQtfknra6wWbESRhUqmapKQvvT8nsvsmKh+L
         NAjb4CNNexYGHqJZ/2WRxS7OFEK78o+QSTKD6VqGz7M7a06guyf10AqFnOlvoG3Lu2W4
         S4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D7ibt3Lae3RXcE7WOmyu3z09/xMR6Le2PSBAAAdLFdU=;
        b=jCPf43IS4CUqDc9vofdWuilqcVKL4dIKlizxpKaLkzBEbk868h4IuKhUjjJK2VxVKd
         yyUX4VtZTr9PW9IkiKBze5PPZcw9j5VgnGDiYGrQxOv04+Qb0TwwC0s0wn1miq3aTdfp
         RtARcBq2gI1ZIJ54t1UdadKHS13QSvksLYKZv4aHzDAmnV2u8LB/EZl6yUXiqtHEpbJ+
         0buhB01haW2U/cLJ+M0vHNtac3puBGLUQV6RdjTF+JAWj9ukVLJLwVLTUq/tmWo/Sj5n
         PPpgQ7vNMVn5/mWlLzLCcj+am4Oy8pfglSpoZwa+jf90JykahC2BdcpJe3DJeZxgjVce
         ieOw==
X-Gm-Message-State: AOAM531gFG25ka6v+PACWpumwmNIYrppclSNzXrxfxt7wt8M76088BzB
        uLz8NimVy4IoLa3R/QLY/JosCFrV861PEg==
X-Google-Smtp-Source: ABdhPJxxjSofAd7c1Ppy3WPuEI6USR+MwE+4op8TxdPcBj9zt/DbCQaYw9UzJXZP4juO34fXYrwdXg==
X-Received: by 2002:a05:6512:1295:: with SMTP id u21mr3259433lfs.384.1628892157401;
        Fri, 13 Aug 2021 15:02:37 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s17sm274912ljp.61.2021.08.13.15.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:02:37 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 2/6 v2] ixp4xx_eth: fix compile-testing
Date:   Sat, 14 Aug 2021 00:00:07 +0200
Message-Id: <20210813220011.921211-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813220011.921211-1-linus.walleij@linaro.org>
References: <20210813220011.921211-1-linus.walleij@linaro.org>
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
index 0bd22beb83ed..931494cc1c39 100644
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

