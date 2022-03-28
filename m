Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC004E96C0
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbiC1Mgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242528AbiC1Mgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:36:54 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E0964EE
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:35:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id jx9so13885258pjb.5
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gNEGSlS2mPCYLZrFQejehM36cdi8B+KPhgqHYrJkMJk=;
        b=FyU5sCo5mxZ3UFic39LK8jEJ9Bh8PoSUKz7inSAfXOlbow/PjyrNR1+E/LGDNzI3W0
         mt2lzTTJAq9sPrhPexGJP7yh9l58pzZyP3qk7k02p7fYDj8VM7l0bvD47rgHT6Iwlr4q
         C0YtArzCjtpTakKDrGU9wzCZyFdLalw4A7uUgqG69GywMd9WFkE8fWqAmBxexLCEBQl+
         qx602btCgCO4G5pFFK5swvs+oJjhk1jFpi9zgDtQrEntyiEopgUB5UhM1CNq7Nj5m4Zn
         FCHzEDCEhyt7h/BlXZMn7HMFXJq+hYSDQL7vGnDNZz8a6XZs0rruKzCHcfdUA3pt2VFd
         Gu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gNEGSlS2mPCYLZrFQejehM36cdi8B+KPhgqHYrJkMJk=;
        b=oIblBYp4xg1ZjUXCP+D968pWaPC0JE2foxbWReWR0lT6ZNH/WSG9vq+yPrOKuzMhpK
         1tP3Dro3qQOy42en3pFmzGx5coLaCxmTA2AaMIM+u1np7SzIKqqmAj8zVyAXVFEqfAaU
         1AZ+jTaqNO2QyXOv4fIN0JFyB/VSKLbftivi2Rt59H8CK3QdtX8Ppbjo8Akda4t0tmoG
         JKNVh1YQnsqU5sMTaYpWpOv2vqn8KsxDprWptwXEpfQ39Z3PWJA3GN2Payroh5nTTkqy
         A5nqK6Z8xjB+LBX7x+v2QWKwneC3UL5ovtJTNstBJgMQDNH9w0lIhv+v/VLkvGdL+OQ1
         QO/Q==
X-Gm-Message-State: AOAM533psf3VL0qTnxnzabT+C15Fdfyd0Jzc8BQaHtFbHDUZI7bnCuD9
        P1NOO+No035K/7jON0/yWuqVMg==
X-Google-Smtp-Source: ABdhPJwKdPAjQn7L1oiuywiQ6AizFLKfHKnwlV/yjzbHkP4FbjN4RPEvcM3mm95e9GyEVMjDvWi2eA==
X-Received: by 2002:a17:903:32c7:b0:154:4156:f384 with SMTP id i7-20020a17090332c700b001544156f384mr25980340plr.34.1648470912760;
        Mon, 28 Mar 2022 05:35:12 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00170c00b004fab8f3244esm16314597pfc.28.2022.03.28.05.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:35:12 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com, andrew@lunn.ch
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v6 net 2/4] net: axienet: factor out phy_node in struct axienet_local
Date:   Mon, 28 Mar 2022 20:32:36 +0800
Message-Id: <20220328123238.2569322-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328123238.2569322-1-andy.chiu@sifive.com>
References: <20220328123238.2569322-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
index 5b4d153b1492..6a0b7ad958cd 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -428,8 +428,6 @@ struct axienet_local {
 	struct net_device *ndev;
 	struct device *dev;
 
-	struct device_node *phy_node;
-
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 93be1adc303f..a4783f95b979 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2067,18 +2067,20 @@ static int axienet_probe(struct platform_device *pdev)
 
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
 		lp->phylink_config.pcs_poll = true;
+		of_node_put(np);
 	}
 
 	lp->phylink_config.dev = &ndev->dev;
@@ -2120,8 +2122,6 @@ static int axienet_probe(struct platform_device *pdev)
 		put_device(&lp->pcs_phy->dev);
 	if (lp->mii_bus)
 		axienet_mdio_teardown(lp);
-	of_node_put(lp->phy_node);
-
 cleanup_clk:
 	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
 	clk_disable_unprepare(lp->axi_clk);
@@ -2150,9 +2150,6 @@ static int axienet_remove(struct platform_device *pdev)
 	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
 	clk_disable_unprepare(lp->axi_clk);
 
-	of_node_put(lp->phy_node);
-	lp->phy_node = NULL;
-
 	free_netdev(ndev);
 
 	return 0;
-- 
2.34.1

