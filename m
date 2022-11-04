Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3BC6190A2
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 07:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiKDGDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 02:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiKDGDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 02:03:20 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A752181
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 23:03:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so3807598pjk.1
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 23:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IASNZHNwvbWHeDpezdCT15D5MRNvDyxMNfFoWg+ExSg=;
        b=aqcZP+ExcDnuxlJ8XnJBEdobJerBZCyEDR6WgadSMDtxAT5rQDMB7pSrN/SEN7g5gn
         rxCauaz72JTCG0XXuxBLWk8Lma1OtRHbiSFJIWyAItitHSQ0SjasMTod0dUyRtPSCfqh
         J2DQk6/1ApW+OHwZW7CbEVbXZ6yuSdrG29XQ2mCmXp85H9rPN9Yp9umUa65ZsQa3dMRg
         7csvZDxOHLVrb9mzDtliGNFLwHS3qZpwMFtXK1mJiDMhvn1OLUPhYiYf6CGsHWAYwrft
         8BGZsOUF5kbYjlISj9q+Vr1MWcTjrJ1kohGMQbfwGz7Qp+r/ojuMkhtJjINqjc02mZFE
         shqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IASNZHNwvbWHeDpezdCT15D5MRNvDyxMNfFoWg+ExSg=;
        b=RSB3VvMB2DimTdBOaUoI3l2Wr/eT1WwKi8szi0Uisnu0Wqad0Z09fGfF4vVaAH/rTL
         9rh0LL1G35LxQmgf8/rvkmHgzKHOfnh/XFS1Kq/KOks0k49gM49VoI5nYCHPprWSMgb/
         rMVbX9aPwBVLeL4NNUBNklm0RKFYUVJkuLPpkNi3E5ljBenrCc+Rj7kSeRQyyXrVAOU6
         U/bsFQDm5oYBy2lSOns3lacyTDN0DIcwKFWHh2p5lku+vQ75i9xM2nW+ATNrMacKBziD
         bSlMRVMhDpgdBs1MKygI6kTpC4hJD1iNB0BrtAA3eKtP2rZ9rVOOF4VrygOrUQI23SxW
         aRdQ==
X-Gm-Message-State: ACrzQf21pVLrm0tNiPoZTM3flJe1NFm9YHZEqF3uTV1k27jpypF9768s
        avOCOxlasOYI0ULJ2sbNQ41G8A==
X-Google-Smtp-Source: AMsMyM4BZ8e1+Z6CWv7xo7n9Xdqu0AV/B3q7MOVKIKzutmdF3cgTx+c+aeb/bgUOUcHCCggYF0spEQ==
X-Received: by 2002:a17:902:e891:b0:186:c544:8b1e with SMTP id w17-20020a170902e89100b00186c5448b1emr33359635plg.163.1667541797453;
        Thu, 03 Nov 2022 23:03:17 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902684f00b00186bc66d2cbsm1727180pln.73.2022.11.03.23.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:03:17 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH v3 net-next 2/3] net: axienet: set mdio clock according to bus-frequency
Date:   Fri,  4 Nov 2022 14:03:04 +0800
Message-Id: <20221104060305.1025215-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221104060305.1025215-1-andy.chiu@sifive.com>
References: <20221104060305.1025215-1-andy.chiu@sifive.com>
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
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 46 +++++++++++++------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index e1f51a071888..5e1619ce8074 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
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
+	u32 mdio_freq = MAX_MDIO_FREQ;
 	u32 host_clock;
+	u32 clk_div;
 
 	lp->mii_clk_div = 0;
 
@@ -184,6 +187,12 @@ static int axienet_mdio_enable(struct axienet_local *lp)
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

