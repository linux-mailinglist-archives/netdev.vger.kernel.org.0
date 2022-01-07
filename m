Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95934487A2D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348185AbiAGQNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiAGQNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:13:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155FFC061574;
        Fri,  7 Jan 2022 08:13:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3472DCE29D0;
        Fri,  7 Jan 2022 16:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56096C36AED;
        Fri,  7 Jan 2022 16:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641571991;
        bh=+yVCifoULZX5nTI+VsSpDliEu/HRE59+3MYqy6A74U4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsG6wMQ6exoEldYNyGXMRtZK8H2BZurH2zLXmW8JRuACV6j7mJvUnVJUlxySukn1B
         IROTMD5r05bJH1OnDXJl5Ts5gd+thidTMKR6bVDhSqtZ1UigOaeC/eF3vM+VfXhRyg
         gIIJ26cB9uVcKmXOBCDxnnP8NQs6oUi7gV1X5oNAtq366LqOCb6bVTqmxJdAqEX/Dt
         a93eW4VkcvK8ODjfFIhS5XAOeavmBc03jYOMiE5qtRkkM9soKTgXAFryW/kBWrrErv
         MZsI2FCx4PRkGOiMUkmLnds8CrZoA+/bTVldMd0VHUPo3tSNJk+Oh/e5/i3gq057f8
         Qd4VtNG6w97BQ==
Received: by pali.im (Postfix)
        id 1F3AF125B; Fri,  7 Jan 2022 17:13:09 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] of: net: Call of_get_ethdev_label() in all DT based net drivers
Date:   Fri,  7 Jan 2022 17:12:22 +0100
Message-Id: <20220107161222.14043-2-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220107161222.14043-1-pali@kernel.org>
References: <20220107161222.14043-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make consistency between DT based netdev and DSA interfaces in eth net
drivers by setting initial netdev name based on DT label. Exactly same
behavior is already implemented and used in DSA drivers.

This change just makes initial consistency between netdev eth devices and
DSA devices.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c           | 2 ++
 drivers/net/ethernet/altera/altera_tse_main.c         | 2 ++
 drivers/net/ethernet/arc/emac_main.c                  | 2 ++
 drivers/net/ethernet/atheros/ag71xx.c                 | 2 ++
 drivers/net/ethernet/broadcom/bcm4908_enet.c          | 1 +
 drivers/net/ethernet/broadcom/bcmsysport.c            | 3 +++
 drivers/net/ethernet/broadcom/bgmac-bcma.c            | 2 ++
 drivers/net/ethernet/broadcom/bgmac-platform.c        | 2 ++
 drivers/net/ethernet/cadence/macb_main.c              | 2 ++
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c      | 2 ++
 drivers/net/ethernet/ethoc.c                          | 1 +
 drivers/net/ethernet/ezchip/nps_enet.c                | 2 ++
 drivers/net/ethernet/freescale/fec_mpc52xx.c          | 2 ++
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 2 ++
 drivers/net/ethernet/freescale/gianfar.c              | 2 ++
 drivers/net/ethernet/freescale/ucc_geth.c             | 1 +
 drivers/net/ethernet/hisilicon/hisi_femac.c           | 2 ++
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c         | 2 ++
 drivers/net/ethernet/ibm/emac/core.c                  | 2 ++
 drivers/net/ethernet/korina.c                         | 2 ++
 drivers/net/ethernet/lantiq_xrx200.c                  | 2 ++
 drivers/net/ethernet/litex/litex_liteeth.c            | 2 ++
 drivers/net/ethernet/marvell/mvneta.c                 | 2 ++
 drivers/net/ethernet/marvell/pxa168_eth.c             | 2 ++
 drivers/net/ethernet/marvell/sky2.c                   | 2 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c           | 2 ++
 drivers/net/ethernet/micrel/ks8851_common.c           | 2 ++
 drivers/net/ethernet/nxp/lpc_eth.c                    | 2 ++
 drivers/net/ethernet/qualcomm/qca_spi.c               | 2 ++
 drivers/net/ethernet/qualcomm/qca_uart.c              | 1 +
 drivers/net/ethernet/renesas/ravb_main.c              | 2 ++
 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c   | 2 ++
 drivers/net/ethernet/socionext/sni_ave.c              | 2 ++
 drivers/net/ethernet/ti/netcp_core.c                  | 2 ++
 drivers/net/ethernet/xilinx/xilinx_emaclite.c         | 2 ++
 drivers/staging/octeon/ethernet.c                     | 2 ++
 36 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 800ee022388f..38f292f27512 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -851,6 +851,8 @@ static int emac_probe(struct platform_device *pdev)
 		goto out_release_sram;
 	}
 
+	of_get_ethdev_label(np, ndev);
+
 	/* Read MAC-address from DT */
 	ret = of_get_ethdev_address(np, ndev);
 	if (ret) {
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index d75d95a97dd9..d322918daaab 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1523,6 +1523,8 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 */
 	priv->rx_dma_buf_sz = ALTERA_RXDMABUFFER_SIZE;
 
+	of_get_ethdev_label(pdev->dev.of_node, ndev);
+
 	/* get default MAC address from device tree */
 	ret = of_get_ethdev_address(pdev->dev.of_node, ndev);
 	if (ret)
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index c642c3d3e600..554f6837382d 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -940,6 +940,8 @@ int arc_emac_probe(struct net_device *ndev, int interface)
 		goto out_clken;
 	}
 
+	of_get_ethdev_label(dev->of_node, ndev);
+
 	/* Get MAC address from device tree */
 	err = of_get_ethdev_address(dev->of_node, ndev);
 	if (err)
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 88d2ab748399..94d9617a9ed1 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1966,6 +1966,8 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->stop_desc->ctrl = 0;
 	ag->stop_desc->next = (u32)ag->stop_desc_dma;
 
+	of_get_ethdev_label(np, ndev);
+
 	err = of_get_ethdev_address(np, ndev);
 	if (err) {
 		netif_err(ag, probe, ndev, "invalid MAC address, using random address\n");
diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 7cc5213c575a..987298caa312 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -715,6 +715,7 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 		return err;
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
+	of_get_ethdev_label(dev->of_node, netdev);
 	err = of_get_ethdev_address(dev->of_node, netdev);
 	if (err)
 		eth_hw_addr_random(netdev);
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 40933bf5a710..45ad21fc8711 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2555,6 +2555,9 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize netdevice members */
+
+	of_get_ethdev_label(dn, dev);
+
 	ret = of_get_ethdev_address(dn, dev);
 	if (ret) {
 		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index e6f48786949c..d657e0fdd0aa 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -140,6 +140,8 @@ static int bgmac_probe(struct bcma_device *core)
 
 	bcma_set_drvdata(core, bgmac);
 
+	of_get_ethdev_label(bgmac->dev->of_node, bgmac->net_dev);
+
 	err = of_get_ethdev_address(bgmac->dev->of_node, bgmac->net_dev);
 	if (err == -EPROBE_DEFER)
 		return err;
diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index c6412c523637..73fcb8bbbb3a 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -191,6 +191,8 @@ static int bgmac_probe(struct platform_device *pdev)
 	bgmac->dev = &pdev->dev;
 	bgmac->dma_dev = &pdev->dev;
 
+	of_get_ethdev_label(np, bgmac->net_dev);
+
 	ret = of_get_ethdev_address(np, bgmac->net_dev);
 	if (ret == -EPROBE_DEFER)
 		return ret;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index ffce528aa00e..ac751a08c2d8 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4784,6 +4784,8 @@ static int macb_probe(struct platform_device *pdev)
 	if (bp->caps & MACB_CAPS_NEEDS_RSTONUBR)
 		bp->rx_intr_mask |= MACB_BIT(RXUBR);
 
+	of_get_ethdev_label(np, bp->dev);
+
 	err = of_get_ethdev_address(np, bp->dev);
 	if (err == -EPROBE_DEFER)
 		goto err_out_free_netdev;
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 4e39d712e121..0f0e45f27e8e 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1501,6 +1501,8 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 	netdev->min_mtu = 64 - OCTEON_MGMT_RX_HEADROOM;
 	netdev->max_mtu = 16383 - OCTEON_MGMT_RX_HEADROOM - VLAN_HLEN;
 
+	of_get_ethdev_label(pdev->dev.of_node, netdev);
+
 	result = of_get_ethdev_address(pdev->dev.of_node, netdev);
 	if (result)
 		eth_hw_addr_random(netdev);
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index b1c8ffea6ad2..46613aefb50c 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1147,6 +1147,7 @@ static int ethoc_probe(struct platform_device *pdev)
 		eth_hw_addr_set(netdev, pdata->hwaddr);
 		priv->phy_id = pdata->phy_id;
 	} else {
+		of_get_ethdev_label(pdev->dev.of_node, netdev);
 		of_get_ethdev_address(pdev->dev.of_node, netdev);
 		priv->phy_id = -1;
 	}
diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index 323340826dab..310997c83bd3 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -600,6 +600,8 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	}
 	dev_dbg(dev, "Registers base address is 0x%p\n", priv->regs_base);
 
+	of_get_ethdev_label(dev->of_node, ndev);
+
 	/* set kernel MAC address to dev */
 	err = of_get_ethdev_address(dev->of_node, ndev);
 	if (err)
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index bbbde9f701c2..bf691a305806 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -885,6 +885,8 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 		/* TX */
 	priv->t_irq = bcom_get_task_irq(priv->tx_dmatsk);
 
+	of_get_ethdev_label(np, ndev);
+
 	/*
 	 * MAC address init:
 	 *
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index bacf25318f87..aeb9f3fa1894 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1005,6 +1005,8 @@ static int fs_enet_probe(struct platform_device *ofdev)
 	spin_lock_init(&fep->lock);
 	spin_lock_init(&fep->tx_lock);
 
+	of_get_ethdev_label(ofdev->dev.of_node, ndev);
+
 	of_get_ethdev_address(ofdev->dev.of_node, ndev);
 
 	ret = fep->ops->allocate_bd(ndev);
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index acab58fd3db3..fdb794355e9e 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -753,6 +753,8 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	if (stash_len || stash_idx)
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_BUF_STASHING;
 
+	of_get_ethdev_label(np, dev);
+
 	err = of_get_ethdev_address(np, dev);
 	if (err) {
 		eth_hw_addr_random(dev);
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 823221c912ab..7496d6b4552d 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3731,6 +3731,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 		goto err_free_netdev;
 	}
 
+	of_get_ethdev_label(np, dev);
 	of_get_ethdev_address(np, dev);
 
 	ugeth->ug_info = ug_info;
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index a6c18b6527f9..060da9a0bbea 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -841,6 +841,8 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 			   (unsigned long)phy->phy_id,
 			   phy_modes(phy->interface));
 
+	of_get_ethdev_label(node, ndev);
+
 	ret = of_get_ethdev_address(node, ndev);
 	if (ret) {
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index d7e62eca050f..27ecfbe7993f 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1219,6 +1219,8 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 		goto out_phy_node;
 	}
 
+	of_get_ethdev_label(node, ndev);
+
 	ret = of_get_ethdev_address(node, ndev);
 	if (ret) {
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 6b3fc8823c54..bbeb8867aa4a 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -2974,6 +2974,8 @@ static int emac_init_config(struct emac_instance *dev)
 #endif
 	}
 
+	of_get_ethdev_label(np, dev->ndev);
+
 	/* Read MAC-address */
 	err = of_get_ethdev_address(np, dev->ndev);
 	if (err) {
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index df9a8eefa007..f06eb06489b4 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1296,6 +1296,8 @@ static int korina_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	lp = netdev_priv(dev);
 
+	of_get_ethdev_label(pdev->dev.of_node, dev);
+
 	if (mac_addr)
 		eth_hw_addr_set(dev, mac_addr);
 	else if (of_get_ethdev_address(pdev->dev.of_node, dev) < 0)
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 0da09ea81980..ace9da9674d3 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -526,6 +526,8 @@ static int xrx200_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->clk);
 	}
 
+	of_get_ethdev_label(np, net_dev);
+
 	err = of_get_ethdev_address(np, net_dev);
 	if (err)
 		eth_hw_addr_random(net_dev);
diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index fdd99f0de424..5f3420564f6e 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -264,6 +264,8 @@ static int liteeth_probe(struct platform_device *pdev)
 	priv->tx_base = buf_base + priv->num_rx_slots * priv->slot_size;
 	priv->tx_slot = 0;
 
+	of_get_ethdev_label(pdev->dev.of_node, netdev);
+
 	err = of_get_ethdev_address(pdev->dev.of_node, netdev);
 	if (err)
 		eth_hw_addr_random(netdev);
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5a7bdca22a63..383bbacc59f4 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5251,6 +5251,8 @@ static int mvneta_probe(struct platform_device *pdev)
 		goto err_free_ports;
 	}
 
+	of_get_ethdev_label(dn, dev);
+
 	err = of_get_ethdev_address(dn, dev);
 	if (!err) {
 		mac_from = "device tree";
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 1d607bc6b59e..fbd22ec463e8 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1433,6 +1433,8 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	INIT_WORK(&pep->tx_timeout_task, pxa168_eth_tx_timeout_task);
 
+	of_get_ethdev_label(pdev->dev.of_node, dev);
+
 	err = of_get_ethdev_address(pdev->dev.of_node, dev);
 	if (err) {
 		u8 addr[ETH_ALEN];
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 28b5b9341145..2f62b5b2432f 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4716,6 +4716,8 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	else
 		dev->max_mtu = ETH_JUMBO_MTU;
 
+	of_get_ethdev_label(hw->pdev->dev.of_node, dev);
+
 	/* try to get mac address in the following order:
 	 * 1) from device tree data
 	 * 2) from internal registers set by bootloader
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 75d67d1b5f6b..1cf1f41c3859 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2588,6 +2588,8 @@ static int __init mtk_init(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 	int ret;
 
+	of_get_ethdev_label(mac->of_node, dev);
+
 	ret = of_get_ethdev_address(mac->of_node, dev);
 	if (ret) {
 		/* If the mac address is invalid, use random mac address */
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 691206f19ea7..d125cbdc473b 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -197,6 +197,8 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
 	struct net_device *dev = ks->netdev;
 	int ret;
 
+	of_get_ethdev_label(np, dev);
+
 	ret = of_get_ethdev_address(np, dev);
 	if (!ret) {
 		ks8851_write_mac_addr(dev);
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index bc39558fe82b..4b35e4540fe6 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1346,6 +1346,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 
 	pldat->phy_node = of_parse_phandle(np, "phy-handle", 0);
 
+	of_get_ethdev_label(np, ndev);
+
 	/* Get MAC address from current HW setting (POR state is all zeros) */
 	__lpc_get_mac(pldat, addr);
 	eth_hw_addr_set(ndev, addr);
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 955cce644392..87a7f4b715c1 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -968,6 +968,8 @@ qca_spi_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, qcaspi_devs);
 
+	of_get_ethdev_label(spi->dev.of_node, qca->net_dev);
+
 	ret = of_get_ethdev_address(spi->dev.of_node, qca->net_dev);
 	if (ret) {
 		eth_hw_addr_random(qca->net_dev);
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index 27c4f43176aa..a00d4739b28c 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -346,6 +346,7 @@ static int qca_uart_probe(struct serdev_device *serdev)
 	INIT_WORK(&qca->tx_work, qcauart_transmit);
 
 	of_property_read_u32(serdev->dev.of_node, "current-speed", &speed);
+	of_get_ethdev_label(serdev->dev.of_node, qca->net_dev);
 
 	ret = of_get_ethdev_address(serdev->dev.of_node, qca->net_dev);
 	if (ret) {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b4c597f4040c..596a0cfcbe8a 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2741,6 +2741,8 @@ static int ravb_probe(struct platform_device *pdev)
 	/* Debug message level */
 	priv->msg_enable = RAVB_DEF_MSG_ENABLE;
 
+	of_get_ethdev_label(np, ndev);
+
 	/* Read and set MAC address */
 	ravb_read_mac_address(np, ndev);
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index 926532466691..cdc718c99386 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -117,6 +117,8 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 		goto err_drv_remove;
 	}
 
+	of_get_ethdev_label(node, priv->dev);
+
 	/* Get MAC address if available (DT) */
 	of_get_ethdev_address(node, priv->dev);
 
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 2c48f8b8ab71..cec095c652c7 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1599,6 +1599,8 @@ static int ave_probe(struct platform_device *pdev)
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
+	of_get_ethdev_label(np, ndev);
+
 	ret = of_get_ethdev_address(np, ndev);
 	if (ret) {
 		/* if the mac address is invalid, use random mac address */
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index b818e4579f6f..c274c383601c 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2002,6 +2002,8 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 	netcp->tx_resume_threshold = netcp->tx_pause_threshold;
 	netcp->node_interface = node_interface;
 
+	of_get_ethdev_label(node_interface, ndev);
+
 	ret = of_property_read_u32(node_interface, "efuse-mac", &efuse_mac);
 	if (efuse_mac) {
 		if (of_address_to_resource(node, NETCP_EFUSE_REG_INDEX, &res)) {
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0815de581c7f..02379a5a7471 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1158,6 +1158,8 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	lp->tx_ping_pong = get_bool(ofdev, "xlnx,tx-ping-pong");
 	lp->rx_ping_pong = get_bool(ofdev, "xlnx,rx-ping-pong");
 
+	of_get_ethdev_label(ofdev->dev.of_node, ndev);
+
 	rc = of_get_ethdev_address(ofdev->dev.of_node, ndev);
 	if (rc) {
 		dev_warn(dev, "No MAC address found, using random\n");
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index f662739137b5..80f06fae365e 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -409,6 +409,8 @@ int cvm_oct_common_init(struct net_device *dev)
 	struct octeon_ethernet *priv = netdev_priv(dev);
 	int ret;
 
+	of_get_ethdev_label(priv->of_node, dev);
+
 	ret = of_get_ethdev_address(priv->of_node, dev);
 	if (ret)
 		eth_hw_addr_random(dev);
-- 
2.20.1

