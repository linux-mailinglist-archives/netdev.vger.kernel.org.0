Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7705A4241A5
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbhJFPq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239237AbhJFPqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 11:46:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85A99611B0;
        Wed,  6 Oct 2021 15:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535102;
        bh=cXgIUEzHTdPVxBySWHjR5ZwAEv6hfSU0n5E7yaamgjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1y3RRSXtNUv9qCG84vtnfX7I+xdI8tfj5ezT1n2nsYj4Mr0TWZti5y+k2gXFIlbj
         ui17S2AtqIkj/prlew5YXQN60wJC6yRhExYQ0QmXnOAqCCWeaNFmt2zwEed9VT2Ugw
         bIrCF9l69/winKnWk/HPg+hcWO7fYgxXYT/k3Tl0vhPeaYzxTdZhfU8E+uBiiFIs8x
         kFleTKnvtv0xyHv3WY3qLXWo7xbuMYHg3J/CwQjBzUBUIoh8841B6K7SIXeWbpzcsr
         rKF+JQPsb+Xi9b9Q2oEJYbtTPxLn78nntv9FIXU2TxIIDkt/9HPGBXVvjNsBnRrTyf
         ipINqEugx/cdg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, saravanak@google.com, mw@semihalf.com,
        andrew@lunn.ch, jeremy.linton@arm.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/9] ethernet: use of_get_ethdev_address()
Date:   Wed,  6 Oct 2021 08:44:20 -0700
Message-Id: <20211006154426.3222199-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006154426.3222199-1-kuba@kernel.org>
References: <20211006154426.3222199-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new of_get_ethdev_address() helper for the cases
where dev->dev_addr is passed in directly as the destination.

  @@
  expression dev, np;
  @@
  - of_get_mac_address(np, dev->dev_addr)
  + of_get_ethdev_address(np, dev)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c           | 2 +-
 drivers/net/ethernet/altera/altera_tse_main.c         | 2 +-
 drivers/net/ethernet/arc/emac_main.c                  | 2 +-
 drivers/net/ethernet/atheros/ag71xx.c                 | 2 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c          | 2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c            | 2 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c            | 2 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c        | 2 +-
 drivers/net/ethernet/cadence/macb_main.c              | 2 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c      | 2 +-
 drivers/net/ethernet/ethoc.c                          | 2 +-
 drivers/net/ethernet/ezchip/nps_enet.c                | 2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c          | 2 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 2 +-
 drivers/net/ethernet/freescale/gianfar.c              | 2 +-
 drivers/net/ethernet/freescale/ucc_geth.c             | 2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c           | 2 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c         | 2 +-
 drivers/net/ethernet/korina.c                         | 2 +-
 drivers/net/ethernet/lantiq_xrx200.c                  | 2 +-
 drivers/net/ethernet/litex/litex_liteeth.c            | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                 | 2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c             | 2 +-
 drivers/net/ethernet/marvell/sky2.c                   | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c           | 2 +-
 drivers/net/ethernet/micrel/ks8851_common.c           | 2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                    | 2 +-
 drivers/net/ethernet/qualcomm/qca_spi.c               | 2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c              | 2 +-
 drivers/net/ethernet/renesas/ravb_main.c              | 2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c   | 2 +-
 drivers/net/ethernet/socionext/sni_ave.c              | 2 +-
 drivers/net/ethernet/ti/netcp_core.c                  | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c         | 2 +-
 34 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 40b8138349b7..800ee022388f 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -852,7 +852,7 @@ static int emac_probe(struct platform_device *pdev)
 	}
 
 	/* Read MAC-address from DT */
-	ret = of_get_mac_address(np, ndev->dev_addr);
+	ret = of_get_ethdev_address(np, ndev);
 	if (ret) {
 		/* if the MAC address is invalid get a random one */
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 1c00d719e5d7..7b75b0cd7ac9 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1524,7 +1524,7 @@ static int altera_tse_probe(struct platform_device *pdev)
 	priv->rx_dma_buf_sz = ALTERA_RXDMABUFFER_SIZE;
 
 	/* get default MAC address from device tree */
-	ret = of_get_mac_address(pdev->dev.of_node, ndev->dev_addr);
+	ret = of_get_ethdev_address(pdev->dev.of_node, ndev);
 	if (ret)
 		eth_hw_addr_random(ndev);
 
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 215b5144b885..c642c3d3e600 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -941,7 +941,7 @@ int arc_emac_probe(struct net_device *ndev, int interface)
 	}
 
 	/* Get MAC address from device tree */
-	err = of_get_mac_address(dev->of_node, ndev->dev_addr);
+	err = of_get_ethdev_address(dev->of_node, ndev);
 	if (err)
 		eth_hw_addr_random(ndev);
 
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 02ae98aabf91..1aaaf8a4e7c5 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1968,7 +1968,7 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->stop_desc->ctrl = 0;
 	ag->stop_desc->next = (u32)ag->stop_desc_dma;
 
-	err = of_get_mac_address(np, ndev->dev_addr);
+	err = of_get_ethdev_address(np, ndev);
 	if (err) {
 		netif_err(ag, probe, ndev, "invalid MAC address, using random address\n");
 		eth_random_addr(ndev->dev_addr);
diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 02a569500234..aa3b5672eab2 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -715,7 +715,7 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 		return err;
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
-	err = of_get_mac_address(dev->of_node, netdev->dev_addr);
+	err = of_get_ethdev_address(dev->of_node, netdev);
 	if (err)
 		eth_hw_addr_random(netdev);
 	netdev->netdev_ops = &bcm4908_enet_netdev_ops;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 0c34bef1a431..b813745e8de3 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2555,7 +2555,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	}
 
 	/* Initialize netdevice members */
-	ret = of_get_mac_address(dn, dev->dev_addr);
+	ret = of_get_ethdev_address(dn, dev);
 	if (ret) {
 		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
 		eth_hw_addr_random(dev);
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 7190e3f0da91..e6f48786949c 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -140,7 +140,7 @@ static int bgmac_probe(struct bcma_device *core)
 
 	bcma_set_drvdata(core, bgmac);
 
-	err = of_get_mac_address(bgmac->dev->of_node, bgmac->net_dev->dev_addr);
+	err = of_get_ethdev_address(bgmac->dev->of_node, bgmac->net_dev);
 	if (err == -EPROBE_DEFER)
 		return err;
 
diff --git a/drivers/net/ethernet/broadcom/bgmac-platform.c b/drivers/net/ethernet/broadcom/bgmac-platform.c
index df8ff839cc62..c6412c523637 100644
--- a/drivers/net/ethernet/broadcom/bgmac-platform.c
+++ b/drivers/net/ethernet/broadcom/bgmac-platform.c
@@ -191,7 +191,7 @@ static int bgmac_probe(struct platform_device *pdev)
 	bgmac->dev = &pdev->dev;
 	bgmac->dma_dev = &pdev->dev;
 
-	ret = of_get_mac_address(np, bgmac->net_dev->dev_addr);
+	ret = of_get_ethdev_address(np, bgmac->net_dev);
 	if (ret == -EPROBE_DEFER)
 		return ret;
 
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b58297aeb793..683f14665c2c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4774,7 +4774,7 @@ static int macb_probe(struct platform_device *pdev)
 	if (bp->caps & MACB_CAPS_NEEDS_RSTONUBR)
 		bp->rx_intr_mask |= MACB_BIT(RXUBR);
 
-	err = of_get_mac_address(np, bp->dev->dev_addr);
+	err = of_get_ethdev_address(np, bp->dev);
 	if (err == -EPROBE_DEFER)
 		goto err_out_free_netdev;
 	else if (err)
diff --git a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
index 30463a6d1f8c..4e39d712e121 100644
--- a/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
+++ b/drivers/net/ethernet/cavium/octeon/octeon_mgmt.c
@@ -1501,7 +1501,7 @@ static int octeon_mgmt_probe(struct platform_device *pdev)
 	netdev->min_mtu = 64 - OCTEON_MGMT_RX_HEADROOM;
 	netdev->max_mtu = 16383 - OCTEON_MGMT_RX_HEADROOM - VLAN_HLEN;
 
-	result = of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
+	result = of_get_ethdev_address(pdev->dev.of_node, netdev);
 	if (result)
 		eth_hw_addr_random(netdev);
 
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 7eb7d28a489d..cd3a3b8f23b6 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1147,7 +1147,7 @@ static int ethoc_probe(struct platform_device *pdev)
 		eth_hw_addr_set(netdev, pdata->hwaddr);
 		priv->phy_id = pdata->phy_id;
 	} else {
-		of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
+		of_get_ethdev_address(pdev->dev.of_node, netdev);
 		priv->phy_id = -1;
 	}
 
diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index f5935eb5a791..323340826dab 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -601,7 +601,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 	dev_dbg(dev, "Registers base address is 0x%p\n", priv->regs_base);
 
 	/* set kernel MAC address to dev */
-	err = of_get_mac_address(dev->of_node, ndev->dev_addr);
+	err = of_get_ethdev_address(dev->of_node, ndev);
 	if (err)
 		eth_hw_addr_random(ndev);
 
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index 5e418850d32d..bbbde9f701c2 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -890,7 +890,7 @@ static int mpc52xx_fec_probe(struct platform_device *op)
 	 *
 	 * First try to read MAC address from DT
 	 */
-	rv = of_get_mac_address(np, ndev->dev_addr);
+	rv = of_get_ethdev_address(np, ndev);
 	if (rv) {
 		struct mpc52xx_fec __iomem *fec = priv->fec;
 
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 2db6e38a772e..bacf25318f87 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1005,7 +1005,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 	spin_lock_init(&fep->lock);
 	spin_lock_init(&fep->tx_lock);
 
-	of_get_mac_address(ofdev->dev.of_node, ndev->dev_addr);
+	of_get_ethdev_address(ofdev->dev.of_node, ndev);
 
 	ret = fep->ops->allocate_bd(ndev);
 	if (ret)
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index af6ad94bf24a..acab58fd3db3 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -753,7 +753,7 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	if (stash_len || stash_idx)
 		priv->device_flags |= FSL_GIANFAR_DEV_HAS_BUF_STASHING;
 
-	err = of_get_mac_address(np, dev->dev_addr);
+	err = of_get_ethdev_address(np, dev);
 	if (err) {
 		eth_hw_addr_random(dev);
 		dev_info(&ofdev->dev, "Using random MAC address: %pM\n", dev->dev_addr);
diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index e84517a4d245..823221c912ab 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3731,7 +3731,7 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 		goto err_free_netdev;
 	}
 
-	of_get_mac_address(np, dev->dev_addr);
+	of_get_ethdev_address(np, dev);
 
 	ugeth->ug_info = ug_info;
 	ugeth->dev = device;
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index c4057de39523..29190eb890c8 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -841,7 +841,7 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 			   (unsigned long)phy->phy_id,
 			   phy_modes(phy->interface));
 
-	ret = of_get_mac_address(node, ndev->dev_addr);
+	ret = of_get_ethdev_address(node, ndev);
 	if (ret) {
 		eth_hw_addr_random(ndev);
 		dev_warn(dev, "using random MAC address %pM\n",
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index c1aae0fca5e9..5f7ccdc834b7 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1219,7 +1219,7 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 		goto out_phy_node;
 	}
 
-	ret = of_get_mac_address(node, ndev->dev_addr);
+	ret = of_get_ethdev_address(node, ndev);
 	if (ret) {
 		eth_hw_addr_random(ndev);
 		netdev_warn(ndev, "using random MAC address %pM\n",
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 097516af4325..df9a8eefa007 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -1298,7 +1298,7 @@ static int korina_probe(struct platform_device *pdev)
 
 	if (mac_addr)
 		eth_hw_addr_set(dev, mac_addr);
-	else if (of_get_mac_address(pdev->dev.of_node, dev->dev_addr) < 0)
+	else if (of_get_ethdev_address(pdev->dev.of_node, dev) < 0)
 		eth_hw_addr_random(dev);
 
 	clk = devm_clk_get_optional(&pdev->dev, "mdioclk");
diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
index 9b7307eba97c..ecf1e11d9b91 100644
--- a/drivers/net/ethernet/lantiq_xrx200.c
+++ b/drivers/net/ethernet/lantiq_xrx200.c
@@ -527,7 +527,7 @@ static int xrx200_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->clk);
 	}
 
-	err = of_get_mac_address(np, net_dev->dev_addr);
+	err = of_get_ethdev_address(np, net_dev);
 	if (err)
 		eth_hw_addr_random(net_dev);
 
diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index a9bdbf0dcfe1..3d9385a4989b 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -266,7 +266,7 @@ static int liteeth_probe(struct platform_device *pdev)
 	priv->tx_base = buf_base + priv->num_rx_slots * priv->slot_size;
 	priv->tx_slot = 0;
 
-	err = of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
+	err = of_get_ethdev_address(pdev->dev.of_node, netdev);
 	if (err)
 		eth_hw_addr_random(netdev);
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 1ee9fb8cbc1b..761155af25d8 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5242,7 +5242,7 @@ static int mvneta_probe(struct platform_device *pdev)
 		goto err_free_ports;
 	}
 
-	err = of_get_mac_address(dn, dev->dev_addr);
+	err = of_get_ethdev_address(dn, dev);
 	if (!err) {
 		mac_from = "device tree";
 	} else {
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index eada23217010..898b513f74e0 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1434,7 +1434,7 @@ static int pxa168_eth_probe(struct platform_device *pdev)
 
 	INIT_WORK(&pep->tx_timeout_task, pxa168_eth_tx_timeout_task);
 
-	err = of_get_mac_address(pdev->dev.of_node, dev->dev_addr);
+	err = of_get_ethdev_address(pdev->dev.of_node, dev);
 	if (err) {
 		/* try reading the mac address, if set by the bootloader */
 		pxa168_eth_get_mac_address(dev, dev->dev_addr);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index ce131cfd93ac..0da18b3f1c01 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4720,7 +4720,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	 * 1) from device tree data
 	 * 2) from internal registers set by bootloader
 	 */
-	ret = of_get_mac_address(hw->pdev->dev.of_node, dev->dev_addr);
+	ret = of_get_ethdev_address(hw->pdev->dev.of_node, dev);
 	if (ret)
 		memcpy_fromio(dev->dev_addr, hw->regs + B2_MAC_1 + port * 8,
 			      ETH_ALEN);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 398c23cec815..75d67d1b5f6b 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2588,7 +2588,7 @@ static int __init mtk_init(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 	int ret;
 
-	ret = of_get_mac_address(mac->of_node, dev->dev_addr);
+	ret = of_get_ethdev_address(mac->of_node, dev);
 	if (ret) {
 		/* If the mac address is invalid, use random mac address */
 		eth_hw_addr_random(dev);
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 0613528efdae..2c4e5e602be7 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -195,7 +195,7 @@ static void ks8851_init_mac(struct ks8851_net *ks, struct device_node *np)
 	struct net_device *dev = ks->netdev;
 	int ret;
 
-	ret = of_get_mac_address(np, dev->dev_addr);
+	ret = of_get_ethdev_address(np, dev);
 	if (!ret) {
 		ks8851_write_mac_addr(dev);
 		return;
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 11ce9fe435ba..43fd569aa5f1 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1350,7 +1350,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	__lpc_get_mac(pldat, ndev->dev_addr);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
-		of_get_mac_address(np, ndev->dev_addr);
+		of_get_ethdev_address(np, ndev);
 	}
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index 8427fe1b8fd1..955cce644392 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -968,7 +968,7 @@ qca_spi_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, qcaspi_devs);
 
-	ret = of_get_mac_address(spi->dev.of_node, qca->net_dev->dev_addr);
+	ret = of_get_ethdev_address(spi->dev.of_node, qca->net_dev);
 	if (ret) {
 		eth_hw_addr_random(qca->net_dev);
 		dev_info(&spi->dev, "Using random MAC address: %pM\n",
diff --git a/drivers/net/ethernet/qualcomm/qca_uart.c b/drivers/net/ethernet/qualcomm/qca_uart.c
index ce3f7ce31adc..27c4f43176aa 100644
--- a/drivers/net/ethernet/qualcomm/qca_uart.c
+++ b/drivers/net/ethernet/qualcomm/qca_uart.c
@@ -347,7 +347,7 @@ static int qca_uart_probe(struct serdev_device *serdev)
 
 	of_property_read_u32(serdev->dev.of_node, "current-speed", &speed);
 
-	ret = of_get_mac_address(serdev->dev.of_node, qca->net_dev->dev_addr);
+	ret = of_get_ethdev_address(serdev->dev.of_node, qca->net_dev);
 	if (ret) {
 		eth_hw_addr_random(qca->net_dev);
 		dev_info(&serdev->dev, "Using random MAC address: %pM\n",
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 9a4888543384..50038e76c72f 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -132,7 +132,7 @@ static void ravb_read_mac_address(struct device_node *np,
 {
 	int ret;
 
-	ret = of_get_mac_address(np, ndev->dev_addr);
+	ret = of_get_ethdev_address(np, ndev);
 	if (ret) {
 		u32 mahr = ravb_read(ndev, MAHR);
 		u32 malr = ravb_read(ndev, MALR);
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
index 4639ed9438a3..926532466691 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_platform.c
@@ -118,7 +118,7 @@ static int sxgbe_platform_probe(struct platform_device *pdev)
 	}
 
 	/* Get MAC address if available (DT) */
-	of_get_mac_address(node, priv->dev->dev_addr);
+	of_get_ethdev_address(node, priv->dev);
 
 	/* Get the TX/RX IRQ numbers */
 	for (i = 0, chan = 1; i < SXGBE_TX_QUEUES; i++) {
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index ae31ed93aaf0..4b0fe0f58bbf 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1599,7 +1599,7 @@ static int ave_probe(struct platform_device *pdev)
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
-	ret = of_get_mac_address(np, ndev->dev_addr);
+	ret = of_get_ethdev_address(np, ndev);
 	if (ret) {
 		/* if the mac address is invalid, use random mac address */
 		eth_hw_addr_random(ndev);
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index a4cd44a39e3d..b666e1b53c5f 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2035,7 +2035,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		devm_iounmap(dev, efuse);
 		devm_release_mem_region(dev, res.start, size);
 	} else {
-		ret = of_get_mac_address(node_interface, ndev->dev_addr);
+		ret = of_get_ethdev_address(node_interface, ndev);
 		if (ret)
 			eth_random_addr(ndev->dev_addr);
 	}
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0d4394125d51..b95aee8607a4 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1157,7 +1157,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	lp->tx_ping_pong = get_bool(ofdev, "xlnx,tx-ping-pong");
 	lp->rx_ping_pong = get_bool(ofdev, "xlnx,rx-ping-pong");
 
-	rc = of_get_mac_address(ofdev->dev.of_node, ndev->dev_addr);
+	rc = of_get_ethdev_address(ofdev->dev.of_node, ndev);
 	if (rc) {
 		dev_warn(dev, "No MAC address found, using random\n");
 		eth_hw_addr_random(ndev);
-- 
2.31.1

