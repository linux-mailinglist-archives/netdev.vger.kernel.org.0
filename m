Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED00A62E02B
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239758AbiKQPlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiKQPku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:40:50 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41F3697C6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:48 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id k22so2135621pfd.3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=msvCIOK/h6MLc6IW/jU+iRbJ69+mcNCO5Gup0wjtGOY=;
        b=jZLWkTE1AGPA2orwncOl9GK7Rpds55oEnBmV4YrV+lCsr7Qo/Zz7cdzfLXB79J6xJb
         ZwrAmR5aB9NHTyilkU7r75O6wcfqdtn0dqdIlNI6I4KE87Snygviiq7EFhk1tU/LTdJz
         1I+9/+tHgN4D8fcGf+u14CBd3XlY6pTogFdeAQO5HYZ8XTTyO3WfUSSxHeRY5v7xT35g
         jpWxpUGG2bGvNuqI0WynkThgts24d/qIZyd3MJAo/9nJ1T9bryx5ePWsfECnu/MxMhO2
         oiuC9mBMohM9spU5JJ3AIAiEfi4v6hgnCaZ5DLe0/Fz+nlnXwYLBYJwcUR2Wp5QtTOhE
         DM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=msvCIOK/h6MLc6IW/jU+iRbJ69+mcNCO5Gup0wjtGOY=;
        b=PKys522ulXzD4b440GcZRNDQbNQ0w4I1sgMAcCp2x0N9KzzE601W4eKqaFit4M8mMM
         hX/qBifq7VIOt1yUpZgUks1OTUZUpsPKSaIVACAJBnEVyi27+cwsVeeP3FTjQIYuHShD
         aQ7h2b0uoZSRlvGzdG/uzYzywA12fbrrFvFm8S+odSFSu+BbOAscf5728WV8HAHZyO8H
         FKLIHWp8u50Y3DS/tce+BMkaWw0d+W6jdVYRNDFkSoFAafTK1FWavFO7iccI5WFxXveL
         C3xQl0s8zGb2JuhHfeYLi8TxoaXeglI1awjBdPHx+nsQJEoOPrjkT0LCwYPQpTP/E6Tv
         4qGA==
X-Gm-Message-State: ANoB5plvhJVWy7aMG+HCbmxgi//VTuhD67CPRZ3KMBdT4DWjMT+kDvnJ
        HanAmla+8wqVMOpXZuRM15uK5w==
X-Google-Smtp-Source: AA0mqf4BDSeoRMTG+3FTeht9pOvb4qi7OB9u6jSMTYlkYKAh4O23jJFGm9XQ2XiwHvgMa+GxHdgQrg==
X-Received: by 2002:a65:4b8d:0:b0:477:d61:d2b3 with SMTP id t13-20020a654b8d000000b004770d61d2b3mr2088663pgq.624.1668699647729;
        Thu, 17 Nov 2022 07:40:47 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b7-20020aa79507000000b0056bcfe015c9sm1252363pfp.204.2022.11.17.07.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:40:47 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v5 net-next 3/3] net: axienet: set mdio clock according to bus-frequency
Date:   Thu, 17 Nov 2022 23:40:14 +0800
Message-Id: <20221117154014.1418834-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221117154014.1418834-1-andy.chiu@sifive.com>
References: <20221117154014.1418834-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
it. And properly disable the mdio bus clock in error path.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 70 +++++++++++++------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index e1f51a071888..2f07fde361aa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -17,7 +17,7 @@
 
 #include "xilinx_axienet.h"
 
-#define MAX_MDIO_FREQ		2500000 /* 2.5 MHz */
+#define DEFAULT_MDIO_FREQ	2500000 /* 2.5 MHz */
 #define DEFAULT_HOST_CLOCK	150000000 /* 150 MHz */
 
 /* Wait till MDIO interface is ready to accept a new transaction.*/
@@ -147,15 +147,20 @@ static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 /**
  * axienet_mdio_enable - MDIO hardware setup function
  * @lp:		Pointer to axienet local data structure.
+ * @np:		Pointer to mdio device tree node.
  *
- * Return:	0 on success, -ETIMEDOUT on a timeout.
+ * Return:	0 on success, -ETIMEDOUT on a timeout, -EOVERFLOW on a clock
+ *		divisor overflow.
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
+	int ret;
 
 	lp->mii_clk_div = 0;
 
@@ -184,6 +189,12 @@ static int axienet_mdio_enable(struct axienet_local *lp)
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
@@ -209,29 +220,42 @@ static int axienet_mdio_enable(struct axienet_local *lp)
 	 * "clock-frequency" from the CPU
 	 */
 
-	lp->mii_clk_div = (host_clock / (MAX_MDIO_FREQ * 2)) - 1;
+	clk_div = (host_clock / (mdio_freq * 2)) - 1;
 	/* If there is any remainder from the division of
-	 * fHOST / (MAX_MDIO_FREQ * 2), then we need to add
-	 * 1 to the clock divisor or we will surely be above 2.5 MHz
+	 * fHOST / (mdio_freq * 2), then we need to add
+	 * 1 to the clock divisor or we will surely be
+	 * above the requested frequency
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
 		   lp->mii_clk_div, host_clock);
 
-	axienet_iow(lp, XAE_MDIO_MC_OFFSET, lp->mii_clk_div | XAE_MDIO_MC_MDIOEN_MASK);
+	axienet_mdio_mdc_enable(lp);
 
-	return axienet_mdio_wait_until_ready(lp);
+	ret = axienet_mdio_wait_until_ready(lp);
+	if (ret)
+		axienet_mdio_mdc_disable(lp);
+
+	return ret;
 }
 
 /**
  * axienet_mdio_setup - MDIO setup function
  * @lp:		Pointer to axienet local data structure.
  *
- * Return:	0 on success, -ETIMEDOUT on a timeout, -ENOMEM when
- *		mdiobus_alloc (to allocate memory for mii bus structure) fails.
+ * Return:	0 on success, -ETIMEDOUT on a timeout, -EOVERFLOW on a clock
+ *		divisor overflow, -ENOMEM when mdiobus_alloc (to allocate
+ *		memory for mii bus structure) fails.
  *
  * Sets up the MDIO interface by initializing the MDIO clock.
  * Register the MDIO interface.
@@ -242,10 +266,6 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	struct mii_bus *bus;
 	int ret;
 
-	ret = axienet_mdio_enable(lp);
-	if (ret < 0)
-		return ret;
-
 	bus = mdiobus_alloc();
 	if (!bus)
 		return -ENOMEM;
@@ -261,15 +281,23 @@ int axienet_mdio_setup(struct axienet_local *lp)
 	lp->mii_bus = bus;
 
 	mdio_node = of_get_child_by_name(lp->dev->of_node, "mdio");
+	ret = axienet_mdio_enable(lp, mdio_node);
+	if (ret < 0)
+		goto unregister;
 	ret = of_mdiobus_register(bus, mdio_node);
+	if (ret)
+		goto unregister_mdio_enabled;
 	of_node_put(mdio_node);
-	if (ret) {
-		mdiobus_free(bus);
-		lp->mii_bus = NULL;
-		return ret;
-	}
 	axienet_mdio_mdc_disable(lp);
 	return 0;
+
+unregister_mdio_enabled:
+	axienet_mdio_mdc_disable(lp);
+unregister:
+	of_node_put(mdio_node);
+	mdiobus_free(bus);
+	lp->mii_bus = NULL;
+	return ret;
 }
 
 /**
-- 
2.36.0

