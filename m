Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03A33FA6F6
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhH1RS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbhH1RS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 13:18:58 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F006C061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:07 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b4so21395107lfo.13
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D7ibt3Lae3RXcE7WOmyu3z09/xMR6Le2PSBAAAdLFdU=;
        b=Xy3dcuzbdiBOLN5ietr0FsbbNMLw2Qtg/Fck+UX9W4lNQ/TiYz4ttJCIvYuOBgRmxc
         45i953isJt7pjmCJssrOQNeEpyTqI/5Y8VcYT32nGrUiVmKRwXdNxor7k2LQvKRlUK8m
         4En5oqbmt1qDarXvQJ/4JIu8/yoJhA6Vz3DHJmuCLf8wwStgTdTbcci7O/BXKQorgcy2
         ukPdex/7hWM1bmJDuY5M6BBPb63RdRwqTSCjG811LDk+a0mZNLBYBqHXaSQgUgf4pWXw
         R/NAoXwLSxJM6cDnGrReAMfPo25JKzr/KpVrDpDY2Afrxpm+5I8brr/Fuf3YXRDH+AnZ
         JKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D7ibt3Lae3RXcE7WOmyu3z09/xMR6Le2PSBAAAdLFdU=;
        b=UJ0uCK1dbr0jX76uhklXIFFhOTgARqZmVradOBnHz7afNSbNyOx4a/mMwgj1JcCf74
         grTfSkgaETo87ey7K+2Nlz2fXfwenPW1ZG8p5oPI93uEBIV4tjpcOc8WR+0bllGUlKtd
         D6dX2vm3TSLU4AYhfIq1OgjG7WWTMe+q4K6v4lupabagkaRs/FV8ylWyaozumcVrW9Lb
         Cj8OgJhgF0lb8iANosX1+S2C5/K2hsKWdKoX/8spCwg5YwaTGUeXJTvc3GUrcRe46msr
         tIAJ8GxSB0wka4tS8W7qvl01bwGxDnNtKEsn2aN0nxpkcIpSUUVnudxBWCPZyUgui2o8
         NSXQ==
X-Gm-Message-State: AOAM5303OLXCsaW482ZzpNRno/id09s28AI9LeBDV2oZDxo/V1rhl2CH
        n7G+YVv5UMos/N54emko2Zy5ERUpNKY7/A==
X-Google-Smtp-Source: ABdhPJz7DXZYwiONcRzfkHSzxgnCCBYdrG7OdbopeJ+ATykiqBFUB+d5xM55rcLhe4IeGFha91YkTQ==
X-Received: by 2002:ac2:5f99:: with SMTP id r25mr11038202lfe.119.1630171084963;
        Sat, 28 Aug 2021 10:18:04 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p1sm202195lfo.255.2021.08.28.10.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 10:18:04 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 2/5 v3] ixp4xx_eth: fix compile-testing
Date:   Sat, 28 Aug 2021 19:15:45 +0200
Message-Id: <20210828171548.143057-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828171548.143057-1-linus.walleij@linaro.org>
References: <20210828171548.143057-1-linus.walleij@linaro.org>
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

