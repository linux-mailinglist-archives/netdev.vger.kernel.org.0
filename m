Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5614F35C2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiDEKys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244566AbiDEJl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:41:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFC0BBE0D
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 02:27:03 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id i10-20020a17090a2aca00b001ca56c9ab16so1499276pjg.1
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 02:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nNjhO6BEVVf5H+Lq2VF12bIUVFosCZXx6WDl+lEmwP0=;
        b=jp2ZgjHluc6E0tmM3PSy/5SBG+yawYE+5GBZRkceuiuuD2EFM98YKfTRPuXHGH5uXh
         u/1bcqt2h4iPaiK8v3GVvn7lJmjhvGTaJwoky5adY87F96y0nWqCmZ4vQuvX382iFK4m
         1vZ8YXfGC/wBuSg83botEOIpZpolKERFjQy16YzUrVc/C8waiy7B+S1N6EOtappGESZn
         V/+Bn1wkxhPs6KNkL9LTYXTYIGcz9nG3CMTbaGlYUzSkZGAVpwMDHv+wbs7KuUK+4lX9
         zhUY5RY1hEV3PhPOyy6R5Co5FQPf1Fs/lRRS5mddbr3Cq2Hcss/jkk/kP+gkRosPoFTi
         4rkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nNjhO6BEVVf5H+Lq2VF12bIUVFosCZXx6WDl+lEmwP0=;
        b=4dZwiN79rSgOqRYb0GtXUgEL+knWHEaWRVKHkC7byKIFwEyMORS34Q8PWEeRtCdbYr
         3wXB1ik4gq3ssS6rjKtcEYimqoj8RD/LbVFsnhPLLjRMhYrJpwiA+VXQHhtYjRf77bhd
         NadFRpi1WCmuFsnWWjD7WJs68LFmI6D5tEEmNx/PYnq72pg551mdwXoJBZI+QzHaqIf1
         s3KB2lM+p7TDRVbnPaWQlLkNBOqzDETncKRfSJ7s66Cgrm8u8M8BBv3JoD67Esa26SNs
         p/9cawWN7dvljZLVWWiUMS9LhFhp0CzBqUN5uRRrBmY23zXmjLBrIZ08Q59iYUkFTbGO
         P9uQ==
X-Gm-Message-State: AOAM532iu2joc3gbjo5vL3naHqgYU6ixCsWWRQcAKmNxsYMISH2fLxUM
        XJn+30W/Th0cIO5C6muAaLeQXw==
X-Google-Smtp-Source: ABdhPJwtmqrFPonhqDLG5I5PyU/CBeS5iNQVpEc+1/Eqa9FmAa4jclE9H+A6P3C+m5m08KQgauoZoQ==
X-Received: by 2002:a17:90a:560a:b0:1bc:72e7:3c13 with SMTP id r10-20020a17090a560a00b001bc72e73c13mr2998489pjf.246.1649150823216;
        Tue, 05 Apr 2022 02:27:03 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b4-20020aa78704000000b004fe0ce6d6e1sm5824291pfo.32.2022.04.05.02.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 02:27:02 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     andrew@lunn.ch, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH v8 net-next 2/4] net: axienet: factor out phy_node in struct axienet_local
Date:   Tue,  5 Apr 2022 17:19:27 +0800
Message-Id: <20220405091929.670951-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220405091929.670951-1-andy.chiu@sifive.com>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the struct member `phy_node` of struct axienet_local is not used by the
driver anymore after initialization. It might be a remnent of old code
and could be removed.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 --
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 13 +++++--------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 0f9c88dd1a4a..d5c1e5c4a508 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -433,8 +433,6 @@ struct axienet_local {
 	struct net_device *ndev;
 	struct device *dev;
 
-	struct device_node *phy_node;
-
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 78a991bbbcf9..3daef64a85bd 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2071,17 +2071,19 @@ static int axienet_probe(struct platform_device *pdev)
 
 	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
 	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
-		lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
-		if (!lp->phy_node) {
+		np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
+		if (!np) {
 			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
 			ret = -EINVAL;
 			goto cleanup_mdio;
 		}
-		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
+		lp->pcs_phy = of_mdio_find_device(np);
 		if (!lp->pcs_phy) {
 			ret = -EPROBE_DEFER;
+			of_node_put(np);
 			goto cleanup_mdio;
 		}
+		of_node_put(np);
 		lp->pcs.ops = &axienet_pcs_ops;
 		lp->pcs.poll = true;
 	}
@@ -2124,8 +2126,6 @@ static int axienet_probe(struct platform_device *pdev)
 		put_device(&lp->pcs_phy->dev);
 	if (lp->mii_bus)
 		axienet_mdio_teardown(lp);
-	of_node_put(lp->phy_node);
-
 cleanup_clk:
 	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
 	clk_disable_unprepare(lp->axi_clk);
@@ -2154,9 +2154,6 @@ static int axienet_remove(struct platform_device *pdev)
 	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
 	clk_disable_unprepare(lp->axi_clk);
 
-	of_node_put(lp->phy_node);
-	lp->phy_node = NULL;
-
 	free_netdev(ndev);
 
 	return 0;
-- 
2.34.1

