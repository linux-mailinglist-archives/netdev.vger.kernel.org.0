Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D26262D1DD
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 04:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiKQDsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 22:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiKQDsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 22:48:06 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D549054B0A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:48:05 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id q1so828127pgl.11
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 19:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qe8YO2bYKcCk4mjdRa7k4fBiBoq1F5abtOZtL0+7RAg=;
        b=ZlXqcQ/TBcjMH7qlWaregji379qaz3S+jNP56u2x3vrqT0XmJ6Lc3mIya/6A9Ly7kq
         tx+RTq3WurM26yQrDPjvTpAf/yeG9LY/0lehBQZ18/x1YrU9sgT5SG5qOTxuJsrRkplT
         1d0xwf37vV67kF08KYsBHtpY+qgVOIygwdxtOM61WTMVp29/k0697XwGgKoDAgOAL+Ht
         d+ek8q7fdU0KPbVPZryptWZdYs9JjeVhhXfdw5ymX1K/LBX8SQhgquyL30fB7vcslUjT
         thP6tQCBUPcTOe+t0K06NDTTvW7S6zj5dF2QFqea2B1gxVmnponzvwBQ6P7FutJZruV4
         ctCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qe8YO2bYKcCk4mjdRa7k4fBiBoq1F5abtOZtL0+7RAg=;
        b=SVZF9HZjtRHw+leJvkiNbAhIPhzJYyq6ty63GCyQco7FEB/Ya6hEQ9iB2/yeSC73IQ
         D1K8deiTEH3Khs0TyqTVhj8JlSbF93I8fsrIsbo4k5tz+D+9bvYG+lDmNi/j+AfL5S78
         auiV4x/zr1V9HEFJgbj/NRaYiViCPNBeIoxxNq1lwCRLcqS4TQSNuMOaB8VGre8kO7qo
         n8OmhJRjnhqfJHURyESsjqNZ/kM6CXxx1VdAwkwZdLp1fOFnNc9fd2NNeR8RWIBLfFZX
         f6sn2QZ8IEUCXnKulF+Qd+UJ2oMZiwHizObGujABlT8bADtw360VgGiW0+bdl+mDtBk9
         2Mgw==
X-Gm-Message-State: ANoB5pkP1gTJBIdmKwhVr4Op6a4Cia2vj3m6cad7IefEHtpVvATa/yUb
        cgW0z8AZSOvpXMk9KCzZkN3phg==
X-Google-Smtp-Source: AA0mqf5iz5cLKFk9oFqB7sAINpOlLMWPUNudtyaYnxyF7/W2Lzos3BsbDwOWnvh0z9i4I4oe4PXd7Q==
X-Received: by 2002:a63:d908:0:b0:45f:fc05:270b with SMTP id r8-20020a63d908000000b0045ffc05270bmr470095pgg.14.1668656885320;
        Wed, 16 Nov 2022 19:48:05 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id p22-20020a1709027ed600b00187197c499asm13016723plb.164.2022.11.16.19.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 19:48:04 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v4 net-next 2/3] net: axienet: set mdio clock according to bus-frequency
Date:   Thu, 17 Nov 2022 11:47:50 +0800
Message-Id: <20221117034751.1347105-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221117034751.1347105-1-andy.chiu@sifive.com>
References: <20221117034751.1347105-1-andy.chiu@sifive.com>
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

Also, change MAX_MDIO_FREQ to DEFAULT_MDIO_FREQ because we may actually
set MDIO bus frequency higher than 2.5MHz if undelying devices support
it.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 48 +++++++++++++------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index e1f51a071888..789a90997f4b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -17,7 +17,7 @@
 
 #include "xilinx_axienet.h"
 
-#define MAX_MDIO_FREQ		2500000 /* 2.5 MHz */
+#define DEFAULT_MDIO_FREQ	2500000 /* 2.5 MHz */
 #define DEFAULT_HOST_CLOCK	150000000 /* 150 MHz */
 
 /* Wait till MDIO interface is ready to accept a new transaction.*/
@@ -147,15 +147,18 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
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
+	u32 mdio_freq = DEFAULT_MDIO_FREQ;
 	u32 host_clock;
+	u32 clk_div;
 
 	lp->mii_clk_div = 0;
 
@@ -184,6 +187,12 @@ static int axienet_mdio_enable(struct axienet_local *lp)
 			    host_clock);
 	}
 
+	if (np)
+		of_property_read_u32(np, "clock-frequency", &mdio_freq);
+	if (mdio_freq != DEFAULT_MDIO_FREQ)
+		netdev_info(lp->ndev, "Setting non-standard mdio bus frequency to %u Hz\n",
+			    mdio_freq);
+
 	/* clk_div can be calculated by deriving it from the equation:
 	 * fMDIO = fHOST / ((1 + clk_div) * 2)
 	 *
@@ -209,13 +218,20 @@ static int axienet_mdio_enable(struct axienet_local *lp)
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
+	if (clk_div & ~XAE_MDIO_MC_CLOCK_DIVIDE_MAX) {
+		netdev_warn(lp->ndev, "MDIO clock divisor overflow\n");
+		return -EOVERFLOW;
+	}
+	lp->mii_clk_div = (u8)clk_div;
 
 	netdev_dbg(lp->ndev,
 		   "Setting MDIO clock divisor to %u/%u Hz host clock.\n",
@@ -242,10 +258,6 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	struct mii_bus *bus;
 	int ret;
 
-	ret = axienet_mdio_enable(lp);
-	if (ret < 0)
-		return ret;
-
 	bus = mdiobus_alloc();
 	if (!bus)
 		return -ENOMEM;
@@ -261,15 +273,21 @@ int axienet_mdio_setup(struct axienet_local *lp)
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

