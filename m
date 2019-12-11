Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42F0D11C189
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 01:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfLLAfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 19:35:42 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34815 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727421AbfLLAfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 19:35:40 -0500
Received: by mail-pl1-f194.google.com with SMTP id x17so273240pln.1
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 16:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D8PC7MgzPtr/ROojces3hhj0R14E0RjGi4avxQ9BFP8=;
        b=PBuktJtnEAZ2MX5UTHD9R9gqeND3EviTTveCAJY8/IIab7WhSxn1lyw8IGPEe1rkvQ
         gvavB5JkVDf9m50dq/w6w+zpxpdZDefC9Q+H2xL4Zp1z/gaaguCrCYM+JofhaqOK1jCs
         UXsApnkuNC0p8kKZkVaNSmj8AlDoZQBIIsxulcUvy8qtoaUdJS7Wd9CzO0vlJQu79WCu
         9Be7YDKCtxRx/AM/HJCGi2596ulwduYtRizEWIg/sm0INymku8syVqqff3P59uEDDbiO
         DHysCh89nCVH6vzJCH6vfng8AodkL4bGl+kod+2WTl4XiZ8hDiUzQNgk+vGY3j3UfW3e
         MzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D8PC7MgzPtr/ROojces3hhj0R14E0RjGi4avxQ9BFP8=;
        b=m1FuOMiEP2aTX2afybbIOt+gUe8CDQgtgo7lqfz275jSnkc1fwQceLbrP+4+6tV68i
         s6S4BjcRq7CrzCG5NyPFGZR4ot5RRyZoHcQfRGEGE+A2MVYX4wPfEpmQbWi/IWZDMbI0
         FWqaokQ1IUWqvVu4NOB204fI/1HGItEtR6z3f1YAZRtRm1qB6VmcrDqyy7oEx3VFzrvB
         FT83mE1xhYr2j4WaN0guSOaGE88MpzQYnsnH91eBIKrQ7uvRaqGZ5Ox7MZSPwxCbIlVV
         3WE+55CE/q8wUiCmXbOcCvMykfx4ZuFXI7JBgC3Q+GKRYNBOOJ2D1TNOaCdAXaZXtNVH
         Qclw==
X-Gm-Message-State: APjAAAVSMpYTr/ijBXEcyJo0CPRm1/PbsOYgMW4WxBHQ/kIfH79ofIf5
        VmY7HU98ab1akJQkbZLGqcQ=
X-Google-Smtp-Source: APXvYqzZgQGfaHEtZ0/Fek9WanFEmTOJ59WNVGV0mhZZCGh5Uh+LRYobfmktvc3rO4jLPyOdOwczzw==
X-Received: by 2002:a17:90b:d85:: with SMTP id bg5mr6441625pjb.99.1576110939610;
        Wed, 11 Dec 2019 16:35:39 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id 11sm3023984pfj.130.2019.12.11.16.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 16:35:39 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH v2 2/2] net: stmmac: dwc-qos: avoid clk and reset for acpi device
Date:   Tue, 10 Dec 2019 23:11:25 -0800
Message-Id: <20191211071125.15610-3-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211071125.15610-1-ajayg@nvidia.com>
References: <20191211071125.15610-1-ajayg@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ajay Gupta <ajayg@nvidia.com>

There are no clocks or resets referenced by Tegra ACPI device
so don't access clocks or resets interface with ACPI device.

Clocks and resets for ACPI devices will be handled via ACPI
interface.

Signed-off-by: Ajay Gupta <ajayg@nvidia.com>
---
Change from v1->v2: Rebased.

 .../stmicro/stmmac/dwmac-dwc-qos-eth.c        | 122 ++++++++++--------
 1 file changed, 67 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
index f87306b3cdae..70e8c41f7761 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c
@@ -272,6 +272,7 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 			      struct stmmac_resources *res)
 {
 	struct tegra_eqos *eqos;
+	struct device *dev = &pdev->dev;
 	int err;
 
 	eqos = devm_kzalloc(&pdev->dev, sizeof(*eqos), GFP_KERNEL);
@@ -283,77 +284,88 @@ static void *tegra_eqos_probe(struct platform_device *pdev,
 	eqos->dev = &pdev->dev;
 	eqos->regs = res->addr;
 
-	eqos->clk_master = devm_clk_get(&pdev->dev, "master_bus");
-	if (IS_ERR(eqos->clk_master)) {
-		err = PTR_ERR(eqos->clk_master);
-		goto error;
-	}
+	if (is_of_node(dev->fwnode)) {
+		eqos->clk_master = devm_clk_get(&pdev->dev, "master_bus");
+		if (IS_ERR(eqos->clk_master)) {
+			err = PTR_ERR(eqos->clk_master);
+			goto error;
+		}
 
-	err = clk_prepare_enable(eqos->clk_master);
-	if (err < 0)
-		goto error;
+		err = clk_prepare_enable(eqos->clk_master);
+		if (err < 0)
+			goto error;
 
-	eqos->clk_slave = devm_clk_get(&pdev->dev, "slave_bus");
-	if (IS_ERR(eqos->clk_slave)) {
-		err = PTR_ERR(eqos->clk_slave);
-		goto disable_master;
-	}
+		eqos->clk_slave = devm_clk_get(&pdev->dev, "slave_bus");
+		if (IS_ERR(eqos->clk_slave)) {
+			err = PTR_ERR(eqos->clk_slave);
+			goto disable_master;
+		}
 
-	data->stmmac_clk = eqos->clk_slave;
+		data->stmmac_clk = eqos->clk_slave;
 
-	err = clk_prepare_enable(eqos->clk_slave);
-	if (err < 0)
-		goto disable_master;
+		err = clk_prepare_enable(eqos->clk_slave);
+		if (err < 0)
+			goto disable_master;
 
-	eqos->clk_rx = devm_clk_get(&pdev->dev, "rx");
-	if (IS_ERR(eqos->clk_rx)) {
-		err = PTR_ERR(eqos->clk_rx);
-		goto disable_slave;
-	}
+		eqos->clk_rx = devm_clk_get(&pdev->dev, "rx");
+		if (IS_ERR(eqos->clk_rx)) {
+			err = PTR_ERR(eqos->clk_rx);
+			goto disable_slave;
+		}
 
-	err = clk_prepare_enable(eqos->clk_rx);
-	if (err < 0)
-		goto disable_slave;
+		err = clk_prepare_enable(eqos->clk_rx);
+		if (err < 0)
+			goto disable_slave;
 
-	eqos->clk_tx = devm_clk_get(&pdev->dev, "tx");
-	if (IS_ERR(eqos->clk_tx)) {
-		err = PTR_ERR(eqos->clk_tx);
-		goto disable_rx;
-	}
+		eqos->clk_tx = devm_clk_get(&pdev->dev, "tx");
+		if (IS_ERR(eqos->clk_tx)) {
+			err = PTR_ERR(eqos->clk_tx);
+			goto disable_rx;
+		}
 
-	err = clk_prepare_enable(eqos->clk_tx);
-	if (err < 0)
-		goto disable_rx;
+		err = clk_prepare_enable(eqos->clk_tx);
+		if (err < 0)
+			goto disable_rx;
 
-	eqos->reset = devm_gpiod_get(&pdev->dev, "phy-reset", GPIOD_OUT_HIGH);
-	if (IS_ERR(eqos->reset)) {
-		err = PTR_ERR(eqos->reset);
-		goto disable_tx;
-	}
+		eqos->reset = devm_gpiod_get(&pdev->dev, "phy-reset",
+					     GPIOD_OUT_HIGH);
+		if (IS_ERR(eqos->reset)) {
+			err = PTR_ERR(eqos->reset);
+			goto disable_tx;
+		}
 
-	usleep_range(2000, 4000);
-	gpiod_set_value(eqos->reset, 0);
+		usleep_range(2000, 4000);
+		gpiod_set_value(eqos->reset, 0);
 
-	/* MDIO bus was already reset just above */
-	data->mdio_bus_data->needs_reset = false;
+		/* MDIO bus was already reset just above */
+		data->mdio_bus_data->needs_reset = false;
 
-	eqos->rst = devm_reset_control_get(&pdev->dev, "eqos");
-	if (IS_ERR(eqos->rst)) {
-		err = PTR_ERR(eqos->rst);
-		goto reset_phy;
-	}
+		eqos->rst = devm_reset_control_get(&pdev->dev, "eqos");
+		if (IS_ERR(eqos->rst)) {
+			err = PTR_ERR(eqos->rst);
+			goto reset_phy;
+		}
 
-	err = reset_control_assert(eqos->rst);
-	if (err < 0)
-		goto reset_phy;
+		err = reset_control_assert(eqos->rst);
+		if (err < 0)
+			goto reset_phy;
 
-	usleep_range(2000, 4000);
+		usleep_range(2000, 4000);
 
-	err = reset_control_deassert(eqos->rst);
-	if (err < 0)
-		goto reset_phy;
+		err = reset_control_deassert(eqos->rst);
+		if (err < 0)
+			goto reset_phy;
 
-	usleep_range(2000, 4000);
+		usleep_range(2000, 4000);
+	} else {
+		/* set clk and reset handle to NULL for non DT device */
+		eqos->clk_master = NULL;
+		eqos->clk_slave = NULL;
+		data->stmmac_clk = NULL;
+		eqos->clk_rx = NULL;
+		eqos->clk_tx = NULL;
+		eqos->reset = NULL;
+	}
 
 	data->fix_mac_speed = tegra_eqos_fix_speed;
 	data->init = tegra_eqos_init;
-- 
2.17.1

