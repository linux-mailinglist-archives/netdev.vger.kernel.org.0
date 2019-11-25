Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D7B10954D
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 22:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKYV4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 16:56:04 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35858 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYV4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 16:56:03 -0500
Received: by mail-pf1-f195.google.com with SMTP id b19so8059176pfd.3
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 13:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UVFdGew1SLJI7BdhWB15Fof6WIoKaA4tyIpNIgu8Sfk=;
        b=dZAdH8aTGqi4VJ93dKd7J1J0hN6oH6VJOv2XELxjMzu38PO3fdAMk5ST4W5IqqA71E
         qzl8/up2FJ0ATNh4JFrQ9p2udKDIMY+muh/aCAOVfBvZsEm1YhjOjJPFaWmsGacorUnw
         IkqoMI9Io+PeGtiKoa3waolgnMsJ/cxMa8Qcn24U3vwkiJtxbkgW3IWhT/lFYhL1WDcM
         mR/YNVikVP8K9/I695yLNmV9wAEqVD/n9AwvlrWe0oMwnh1bZZzYbI2KSMSyf92uA+ZJ
         T3S1tntIcfKz6ugxCHeX0+4qF6hAIJyssUdQ77GPNCAlemcUE+1nm3Txn9yEOzK94l36
         xfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UVFdGew1SLJI7BdhWB15Fof6WIoKaA4tyIpNIgu8Sfk=;
        b=ORO8cuayQyjazHaHlBNbIVfpUCn1XSM5h3rsQgQW+1ywZDSZ9gYjQCZbOOkbO6pb5W
         imAiP1lxw3Zgy8VxSWOXBeFF1NNnbz/imQbH+OZl14C0PVW4z1moKlhhx6VPk7WCzoRw
         K9/+LgHanNrSaxPHc7R2OVgbQ1NfPh+70uor9q8dFz+2SO7Bwbt9LCtKrjdf36Ye+JAU
         MZgy/10FxTAS8UjBVI3oic1c6CIg1qfHlO0KRZ/NmydT0I7Ft02jZQ8oL5MvNokMjj5u
         aOtDzKWC4KhAb7Cs2Knf8Ztk6ZjppdbQUvhILWNe1yxaLf6WaarAadCxMzOPueZG6Cqd
         d3ug==
X-Gm-Message-State: APjAAAVWjVU2TQKDbnl0u7fLWYdQh/s687vtFcoXDdaFzMzEYMeg82LC
        qKGTtnjYubV6kfzjdSdvXo4=
X-Google-Smtp-Source: APXvYqzzriJ1dFL77CI5y/1NUK/ag1YlvqXFVi0HGpjg6f3gPjLnmq3zchVcNy+Wclj00uG6D3fNyA==
X-Received: by 2002:aa7:9f0e:: with SMTP id g14mr38358334pfr.202.1574718962299;
        Mon, 25 Nov 2019 13:56:02 -0800 (PST)
Received: from ajayg.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id y12sm366567pjy.0.2019.11.25.13.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 13:56:01 -0800 (PST)
From:   Ajay Gupta <ajaykuee@gmail.com>
X-Google-Original-From: Ajay Gupta <ajayg@nvidia.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, treding@nvidia.com,
        Ajay Gupta <ajayg@nvidia.com>
Subject: [PATCH 2/2] net: stmmac: dwc-qos: avoid clk and reset for acpi device
Date:   Mon, 25 Nov 2019 13:51:15 -0800
Message-Id: <20191125215115.12981-3-ajayg@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191125215115.12981-1-ajayg@nvidia.com>
References: <20191125215115.12981-1-ajayg@nvidia.com>
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

