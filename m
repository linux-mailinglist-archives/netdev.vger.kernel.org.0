Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8334EA585
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 04:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbiC2CxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 22:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiC2CxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 22:53:21 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC5824372C
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:39 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w21so13673864pgm.7
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 19:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nNjhO6BEVVf5H+Lq2VF12bIUVFosCZXx6WDl+lEmwP0=;
        b=ZJXdKbFlcuEZt6eWZymxRstoyL2Smo1Zb7CgKI8b7Rjym/mqhigLwIegoeXPBmzgcZ
         CX4XDqPmULfCBrDGYUCiP4x7B8W8LdXX7CFSpKQuPADIq2f0ljdeniWWB/06Oxfz0JAj
         /8324ubqMW/+N9QKVaPYnkV/Vmd2crn3bFRSQSzqHhRW9LxpuW8sH/iGc/T3MNuA6/ER
         uRQ2UYFetLINyFJwRtHSUF/hzM1H5YwZWMcQbMiamMkw2Li2bCa1/7FEwnpyei0A8VSp
         alKKQPEzTsIx8J4ES0FNaLzyjX7cYvRilMuaejO1keDuFnWfQDHZCHStyIyymCUgC7T0
         ysUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nNjhO6BEVVf5H+Lq2VF12bIUVFosCZXx6WDl+lEmwP0=;
        b=GpAMBQn18uSPnbp6qEf4L7eEiw9Ld+4j2F1vl+Wtkg+f64FvxHs15QYthbD+s6GDze
         RAErcZWs4PPNgCDis+UIFUOnGLGzKZuz5mfWyVIR8hPtZw1Hvi+cCTjb28git3i/pfYR
         BfT5JVv0DsgLAVHPKicGFqsY7tYc9ek/BR8/zI0DZotKikbIPqV8nv40d2Fh7VNUFvsR
         HVwq75oAjWOdocERXIhnPV6LzECWr3De4zaj/rMIvp/IoZxVRGSc41+2yJh7wSyshVlU
         za1LDU85zvdvYz5R1rEH+aoINnHc0vNqE1KccLKIHEZzVnzZsxbngtTI1vLA4S+JAHGp
         /0zQ==
X-Gm-Message-State: AOAM530ENPx53QO+XQJo/IRsPZt9Oqqmf1qTPHRi4EsI/BgKX6Wo/bVf
        7zPEP2JkfPTE39rmhDC25fXZ6A==
X-Google-Smtp-Source: ABdhPJxU1VmpKNtEuphzkcFx5zwYh4SI/Tg6irTKvLhhy5Ka+KZ+IpL/40UUgX0tlQCNesOGzskgzQ==
X-Received: by 2002:a05:6a00:1395:b0:4fa:e546:39c3 with SMTP id t21-20020a056a00139500b004fae54639c3mr26060496pfg.33.1648522299155;
        Mon, 28 Mar 2022 19:51:39 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f14-20020a63380e000000b0038253c4d5casm14136053pga.36.2022.03.28.19.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 19:51:38 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     kuba@kernel.org, radhey.shyam.pandey@xilinx.com,
        robert.hancock@calian.com, michal.simek@xilinx.com, andrew@lunn.ch
Cc:     davem@davemloft.net, pabeni@redhat.com, robh+dt@kernel.org,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH v7 net 2/4] net: axienet: factor out phy_node in struct axienet_local
Date:   Tue, 29 Mar 2022 10:49:19 +0800
Message-Id: <20220329024921.2739338-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329024921.2739338-1-andy.chiu@sifive.com>
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
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

