Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3441E6E99
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437005AbgE1WWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:22:21 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:42190 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436893AbgE1WWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:22:08 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49Y2Hf6QRNz1qrMH;
        Fri, 29 May 2020 00:22:06 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49Y2Hf5Xb9z1qsqH;
        Fri, 29 May 2020 00:22:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id d7_Tdh8fT3MB; Fri, 29 May 2020 00:22:05 +0200 (CEST)
X-Auth-Info: ddceB2hE0hBstNQYb8Bx5XyN9t+OS80s/OpttzIHHxQ=
Received: from desktop.lan (ip-86-49-35-8.net.upcbroadband.cz [86.49.35.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 29 May 2020 00:22:05 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH V7 02/19] net: ks8851: Rename ndev to netdev in probe
Date:   Fri, 29 May 2020 00:21:29 +0200
Message-Id: <20200528222146.348805-3-marex@denx.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528222146.348805-1-marex@denx.de>
References: <20200528222146.348805-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename ndev variable to netdev for the sake of consistency.

No functional change.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Petr Stetiar <ynezz@true.cz>
Cc: YueHaibing <yuehaibing@huawei.com>
---
V2: New patch
V3: No change
V4: No change
V5: No change
V6: No change
V7: No change
---
 drivers/net/ethernet/micrel/ks8851.c | 30 ++++++++++++++--------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index e32ef9403803..2b85072993c5 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1414,21 +1414,21 @@ static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
 static int ks8851_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
-	struct net_device *ndev;
+	struct net_device *netdev;
 	struct ks8851_net *ks;
 	int ret;
 	unsigned cider;
 	int gpio;
 
-	ndev = alloc_etherdev(sizeof(struct ks8851_net));
-	if (!ndev)
+	netdev = alloc_etherdev(sizeof(struct ks8851_net));
+	if (!netdev)
 		return -ENOMEM;
 
 	spi->bits_per_word = 8;
 
-	ks = netdev_priv(ndev);
+	ks = netdev_priv(netdev);
 
-	ks->netdev = ndev;
+	ks->netdev = netdev;
 	ks->spidev = spi;
 	ks->tx_space = 6144;
 
@@ -1500,7 +1500,7 @@ static int ks8851_probe(struct spi_device *spi)
 	ks->eeprom.register_write = ks8851_eeprom_regwrite;
 
 	/* setup mii state */
-	ks->mii.dev		= ndev;
+	ks->mii.dev		= netdev;
 	ks->mii.phy_id		= 1,
 	ks->mii.phy_id_mask	= 1;
 	ks->mii.reg_num_mask	= 0xf;
@@ -1516,15 +1516,15 @@ static int ks8851_probe(struct spi_device *spi)
 
 	skb_queue_head_init(&ks->txq);
 
-	ndev->ethtool_ops = &ks8851_ethtool_ops;
-	SET_NETDEV_DEV(ndev, dev);
+	netdev->ethtool_ops = &ks8851_ethtool_ops;
+	SET_NETDEV_DEV(netdev, dev);
 
 	spi_set_drvdata(spi, ks);
 
 	netif_carrier_off(ks->netdev);
-	ndev->if_port = IF_PORT_100BASET;
-	ndev->netdev_ops = &ks8851_netdev_ops;
-	ndev->irq = spi->irq;
+	netdev->if_port = IF_PORT_100BASET;
+	netdev->netdev_ops = &ks8851_netdev_ops;
+	netdev->irq = spi->irq;
 
 	/* issue a global soft reset to reset the device. */
 	ks8851_soft_reset(ks, GRR_GSR);
@@ -1543,14 +1543,14 @@ static int ks8851_probe(struct spi_device *spi)
 	ks8851_read_selftest(ks);
 	ks8851_init_mac(ks);
 
-	ret = register_netdev(ndev);
+	ret = register_netdev(netdev);
 	if (ret) {
 		dev_err(dev, "failed to register network device\n");
 		goto err_netdev;
 	}
 
-	netdev_info(ndev, "revision %d, MAC %pM, IRQ %d, %s EEPROM\n",
-		    CIDER_REV_GET(cider), ndev->dev_addr, ndev->irq,
+	netdev_info(netdev, "revision %d, MAC %pM, IRQ %d, %s EEPROM\n",
+		    CIDER_REV_GET(cider), netdev->dev_addr, netdev->irq,
 		    ks->rc_ccr & CCR_EEPROM ? "has" : "no");
 
 	return 0;
@@ -1564,7 +1564,7 @@ static int ks8851_probe(struct spi_device *spi)
 	regulator_disable(ks->vdd_io);
 err_reg_io:
 err_gpio:
-	free_netdev(ndev);
+	free_netdev(netdev);
 	return ret;
 }
 
-- 
2.25.1

