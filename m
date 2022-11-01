Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC6B614289
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiKABCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiKABCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:02:05 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871D21658A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:02:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u6so12207825plq.12
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=znJaAap91p43kF17FoLNdEXLPy9K2O9nkVnQWIz7B2o=;
        b=hh1hg97OdvlfvP3Paw6FWHjz67HyKSheZyUa8itGRHsMebhFfBP4ptmFkDQ2yhjyOw
         vY2NilO6QigYZYd9DJOx1cEHCtcGIQ4o43+JN2q9hPrIQDWsTQZFatNDWSpfuUVg5h3D
         GtZD7r61+HYbu9TqPkjzK+ZBarInbYxD4RpL349qWFPLhIEXmYpovEEBRPS1nktTm4Nl
         +RIqiXQVvh98ZPzM0rD/PkwopdkvY5FvwQ8olgRqv9HggtMV8qW+zDGQMu6/1UF6sAEr
         MEVCe15/ysk7aumGphQPODy8Ch8eKL211tL8rikwIWM+uAeNUEyfwN8JXYDNt5+jtNk6
         FwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=znJaAap91p43kF17FoLNdEXLPy9K2O9nkVnQWIz7B2o=;
        b=S4axeXypLOOLVpc6zky0O8vRQyXPFkP0HPdIy74poqCYUPcxTcMJQnVY8k5X5oGEIS
         RZZrcC+/mDWCT0gOFI9HuExoPcf5CkR+EST/IPZ4pkJEpk54ZrzoQS4rnAF31RdTmRuz
         h5UoM5A0PCU1+ZlsZypTxuRyjh/lnH71fn8xRWXMFiJv274MrBKeWJAMjDm5jDygW/sC
         CvoEv+z3DOIu+DA8uVFU0wDHcavNSCPg50M0hCCqrR7FVv1iylumpuGt7Sm2GvL9+1UR
         NRZNQEwWk0z0S2ec822TVM8bGT+lpUyG4So8ueU7F4CNHkzJWKe3u3CVf8n3QQDfS7/r
         p5kw==
X-Gm-Message-State: ACrzQf0OuMhv5vUwsjHE/j2ic2+pHeQHKH8h2323tNyebfYKYAxC8WWD
        4vzLdeEgq3xv80355s6DAfzqbA==
X-Google-Smtp-Source: AMsMyM6RCa6UfEcZqy52DywsQ4RtK3oUQplhwBWljYRLasxiVNfdPunnrcUsqQytaTXEuTxz06Yc/A==
X-Received: by 2002:a17:90b:b05:b0:212:f402:bd16 with SMTP id bf5-20020a17090b0b0500b00212f402bd16mr35167089pjb.163.1667264519998;
        Mon, 31 Oct 2022 18:01:59 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id a16-20020aa794b0000000b005627d995a36sm5221920pfl.44.2022.10.31.18.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 18:01:59 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v2 net-next 2/3] net: axienet: set mdio clock according to bus-frequency
Date:   Tue,  1 Nov 2022 09:01:46 +0800
Message-Id: <20221101010146.900008-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221101010146.900008-1-andy.chiu@sifive.com>
References: <20221101010146.900008-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some FPGA platforms have 80KHz MDIO bus frequency constraint when
connecting Ethernet to its on-board external Marvell PHY. Thus, we may
have to set MDIO clock according to the DT. Otherwise, use the default
2.5 MHz, as specified by 802.3, if the entry is not present.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 47 +++++++++++++------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index e1f51a071888..666df3713d92 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -18,6 +18,7 @@
 #include "xilinx_axienet.h"
 
 #define MAX_MDIO_FREQ		2500000 /* 2.5 MHz */
+#define MDIO_CLK_DIV_MASK	0x3f /* bits[5:0] */
 #define DEFAULT_HOST_CLOCK	150000000 /* 150 MHz */
 
 /* Wait till MDIO interface is ready to accept a new transaction.*/
@@ -147,15 +148,18 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 /**
  * axienet_mdio_enable - MDIO hardware setup function
  * @lp:		Pointer to axienet local data structure.
+ * @np:		Pointer to mdio device tree node.
  *
  * Return:	0 on success, -ETIMEDOUT on a timeout.
  *
  * Sets up the MDIO interface by initializing the MDIO clock and enabling the
  * MDIO interface in hardware.
  **/
-static int axienet_mdio_enable(struct axienet_local *lp)
+static int axienet_mdio_enable(struct axienet_local *lp, struct device_node *np)
 {
+	u32 clk_div;
 	u32 host_clock;
+	u32 mdio_freq = MAX_MDIO_FREQ;
 
 	lp->mii_clk_div = 0;
 
@@ -184,6 +188,12 @@ static int axienet_mdio_enable(struct axienet_local *lp)
 			    host_clock);
 	}
 
+	if (np)
+		of_property_read_u32(np, "clock-frequency", &mdio_freq);
+	if (mdio_freq != MAX_MDIO_FREQ)
+		netdev_info(lp->ndev, "Setting non-standard mdio bus frequency to %u Hz\n",
+			    mdio_freq);
+
 	/* clk_div can be calculated by deriving it from the equation:
 	 * fMDIO = fHOST / ((1 + clk_div) * 2)
 	 *
@@ -209,13 +219,20 @@ static int axienet_mdio_enable(struct axienet_local *lp)
 	 * "clock-frequency" from the CPU
 	 */
 
-	lp->mii_clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
+	clk_div = (host_clock / (mdio_freq * 2)) - 1;
 	/* If there is any remainder from the division of
-	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
+	 * fHOST / (mdio_freq * 2), then we need to add
 	 * 1 to the clock divisor or we will surely be above 2.5 MHz
 	 */
-	if (host_clock % (MAX_MDIO_FREQ * 2))
-		lp->mii_clk_div++;
+	if (host_clock % (mdio_freq * 2))
+		clk_div++;
+
+	/* Check for overflow of mii_clk_div */
+	if (clk_div & ~MDIO_CLK_DIV_MASK) {
+		netdev_dbg(lp->ndev, "MDIO clock divisor overflow, setting to maximum value\n");
+		clk_div = MDIO_CLK_DIV_MASK;
+	}
+	lp->mii_clk_div = (u8)clk_div;
 
 	netdev_dbg(lp->ndev,
 		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
@@ -242,10 +259,6 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	struct mii_bus *bus;
 	int ret;
 
-	ret = axienet_mdio_enable(lp);
-	if (ret < 0)
-		return ret;
-
 	bus = mdiobus_alloc();
 	if (!bus)
 		return -ENOMEM;
@@ -261,15 +274,21 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	lp->mii_bus = bus;
 
 	mdio_node = of_get_child_by_name(lp->dev->of_node, "mdio");
+	ret = axienet_mdio_enable(lp, mdio_node);
+	if (ret < 0)
+		goto unregister;
 	ret = of_mdiobus_register(bus, mdio_node);
+	if (ret)
+		goto unregister;
 	of_node_put(mdio_node);
-	if (ret) {
-		mdiobus_free(bus);
-		lp->mii_bus = NULL;
-		return ret;
-	}
 	axienet_mdio_mdc_disable(lp);
 	return 0;
+
+unregister:
+	of_node_put(mdio_node);
+	mdiobus_free(bus);
+	lp->mii_bus = NULL;
+	return ret;
 }
 
 /**
-- 
2.36.0

