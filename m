Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC4919301B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgCYSMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:12:05 -0400
Received: from mail-ed1-f98.google.com ([209.85.208.98]:38150 "EHLO
        mail-ed1-f98.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbgCYSMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:12:02 -0400
Received: by mail-ed1-f98.google.com with SMTP id e5so3740928edq.5
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 11:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SuDRidi899yKOqtqrOSIVDZrVwIsv8//2ku9t3taYYw=;
        b=bxLcTHqu65jbEfJcmFVf/k5qn5rrnssRpOu7m1fkUwQ+hMbGNP1ieh1DX43BjNs++y
         0WAOHiHl8yvEgLRnKoYOvHhoVr1bItOeD7Sj4Aa/KqqXEltj5XuuGT0HVEQuDUJYuCQY
         8LElCA9N3mtDetiBAzhWVeyoBLTWn7E6IcTCf2CZPv95KivKWS3Degd8VJaN+rtkn0eH
         NpDmDFN1ElSJ+9gpws//7dGBIswIutaYfnz5zTbShfQBaXMrVWNXrzoAyi8UZw8meqJt
         9o9aXDulyDUsEZ/ABe0Tuw4yk0CfMmnp7jn1XOi7jEig72HUmj2NVd+vU63oaJorNUK/
         GjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SuDRidi899yKOqtqrOSIVDZrVwIsv8//2ku9t3taYYw=;
        b=jqh3kocWgCuGga75fAmTeVOEWjvqoHUkUnQyXIZUAE9hLutVMG3eieKbAMEd8LxcID
         Rd/otGK11KahC+OBqJQJjHkW88Grx3MUImmqM3zasLIhZtRRlAuJEw8SkSMafI1iGgkJ
         8Alwh1xOm55McTgcsRrquNqjM67B1QS61gzZe2Nx0n2jOnmRx6EyHKGb7xL0XNVgJpga
         +a4G5WsfXmnhSKsPzgC3gO3M1FbvLVgch7Y//6M51X0CwieVanvnjdbyq/DmF3krlkYU
         zQLcaRIRGht0hnZ0wy63jbD3GOk5wWThk8iCCNN8VJ4msxKlhJ2EQQ9iCMKFSBp1V5Qs
         4Dkw==
X-Gm-Message-State: ANhLgQ0AAd0wpYecjuQ6bapVfgKsQWzxr2MWXMxxv8NEGVyo85Yooild
        5XQlW7cts6ZFB0O6nxJD42tb2MuRvnTgWREFYaLgG8uaK0PM
X-Google-Smtp-Source: ADFU+vsP1VGrqe0bH9yBDhQTiDwm45P/c/NITFyxt4w4soNr9lVu8TUlPlK7dRfw0H6X0rwjrixmvkNsBr9B
X-Received: by 2002:a17:906:33d3:: with SMTP id w19mr4251998eja.134.1585159919820;
        Wed, 25 Mar 2020 11:11:59 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id r12sm12457ejr.8.2020.03.25.11.11.58
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 11:11:59 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.190] (port=39524 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jHAVS-0003Oy-Es; Wed, 25 Mar 2020 19:11:58 +0100
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 1/4] net: fec: set GPR bit on suspend by DT configuration.
Date:   Wed, 25 Mar 2020 19:11:56 +0100
Message-Id: <1585159919-11491-2-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some SoCs, such as the i.MX6, it is necessary to set a bit
in the SoC level GPR register before suspending for wake on lan
to work.

The fec platform callback sleep_mode_enable was intended to allow this
but the platform implementation was NAK'd back in 2015 [1]

This means that, currently, wake on lan is broken on mainline for
the i.MX6 at least.

So implement the required bit setting in the fec driver by itself
by adding a new optional DT property indicating the GPR register
and adding the offset and bit information to the driver.

[1] https://www.spinics.net/lists/netdev/msg310922.html

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |   7 ++
 drivers/net/ethernet/freescale/fec_main.c | 149 ++++++++++++++++++++++++------
 2 files changed, 127 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index f79e57f..d89568f 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -488,6 +488,12 @@ struct fec_enet_priv_rx_q {
 	struct  sk_buff *rx_skbuff[RX_RING_SIZE];
 };
 
+struct fec_stop_mode_gpr {
+	struct regmap *gpr;
+	u8 reg;
+	u8 bit;
+};
+
 /* The FEC buffer descriptors track the ring buffers.  The rx_bd_base and
  * tx_bd_base always point to the base of the buffer descriptors.  The
  * cur_rx and cur_tx point to the currently available buffer.
@@ -562,6 +568,7 @@ struct fec_enet_private {
 	int hwts_tx_en;
 	struct delayed_work time_keep;
 	struct regulator *reg_phy;
+	struct fec_stop_mode_gpr stop_gpr;
 
 	unsigned int tx_align;
 	unsigned int rx_align;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 23c5fef..69cab0b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -62,6 +62,8 @@
 #include <linux/if_vlan.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/prefetch.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 #include <soc/imx/cpuidle.h>
 
 #include <asm/cacheflush.h>
@@ -84,6 +86,56 @@
 #define FEC_ENET_OPD_V	0xFFF0
 #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
 
+struct fec_devinfo {
+	u32 quirks;
+	u8 stop_gpr_reg;
+	u8 stop_gpr_bit;
+};
+
+static const struct fec_devinfo fec_imx25_info = {
+	.quirks = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
+		  FEC_QUIRK_HAS_FRREG,
+};
+
+static const struct fec_devinfo fec_imx27_info = {
+	.quirks = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
+};
+
+static const struct fec_devinfo fec_imx28_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
+		  FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
+		  FEC_QUIRK_HAS_FRREG,
+};
+
+static const struct fec_devinfo fec_imx6q_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
+		  FEC_QUIRK_HAS_RACC,
+	.stop_gpr_reg = 0x34,
+	.stop_gpr_bit = 27,
+};
+
+static const struct fec_devinfo fec_mvf600_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
+};
+
+static const struct fec_devinfo fec_imx6x_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
+		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
+};
+
+static const struct fec_devinfo fec_imx6ul_info = {
+	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
+		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
+		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
+		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
+		  FEC_QUIRK_HAS_COALESCE,
+};
+
 static struct platform_device_id fec_devtype[] = {
 	{
 		/* keep it for coldfire */
@@ -91,39 +143,25 @@
 		.driver_data = 0,
 	}, {
 		.name = "imx25-fec",
-		.driver_data = FEC_QUIRK_USE_GASKET | FEC_QUIRK_MIB_CLEAR |
-			       FEC_QUIRK_HAS_FRREG,
+		.driver_data = (kernel_ulong_t)&fec_imx25_info,
 	}, {
 		.name = "imx27-fec",
-		.driver_data = FEC_QUIRK_MIB_CLEAR | FEC_QUIRK_HAS_FRREG,
+		.driver_data = (kernel_ulong_t)&fec_imx27_info,
 	}, {
 		.name = "imx28-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
-				FEC_QUIRK_SINGLE_MDIO | FEC_QUIRK_HAS_RACC |
-				FEC_QUIRK_HAS_FRREG,
+		.driver_data = (kernel_ulong_t)&fec_imx28_info,
 	}, {
 		.name = "imx6q-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
-				FEC_QUIRK_HAS_RACC,
+		.driver_data = (kernel_ulong_t)&fec_imx6q_info,
 	}, {
 		.name = "mvf600-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_RACC,
+		.driver_data = (kernel_ulong_t)&fec_mvf600_info,
 	}, {
 		.name = "imx6sx-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
-				FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
-				FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
+		.driver_data = (kernel_ulong_t)&fec_imx6x_info,
 	}, {
 		.name = "imx6ul-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
-				FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
-				FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
-				FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
-				FEC_QUIRK_HAS_COALESCE,
+		.driver_data = (kernel_ulong_t)&fec_imx6ul_info,
 	}, {
 		/* sentinel */
 	}
@@ -1092,11 +1130,28 @@ static void fec_enet_reset_skb(struct net_device *ndev)
 
 }
 
+static void fec_enet_stop_mode(struct fec_enet_private *fep, bool enabled)
+{
+	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
+	struct fec_stop_mode_gpr *stop_gpr = &fep->stop_gpr;
+
+	if (stop_gpr->gpr) {
+		if (enabled)
+			regmap_update_bits(stop_gpr->gpr, stop_gpr->reg,
+					   BIT(stop_gpr->bit),
+					   BIT(stop_gpr->bit));
+		else
+			regmap_update_bits(stop_gpr->gpr, stop_gpr->reg,
+					   BIT(stop_gpr->bit), 0);
+	} else if (pdata && pdata->sleep_mode_enable) {
+		pdata->sleep_mode_enable(enabled);
+	}
+}
+
 static void
 fec_stop(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
 	u32 rmii_mode = readl(fep->hwp + FEC_R_CNTRL) & (1 << 8);
 	u32 val;
 
@@ -1125,9 +1180,7 @@ static void fec_enet_reset_skb(struct net_device *ndev)
 		val = readl(fep->hwp + FEC_ECNTRL);
 		val |= (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 		writel(val, fep->hwp + FEC_ECNTRL);
-
-		if (pdata && pdata->sleep_mode_enable)
-			pdata->sleep_mode_enable(true);
+		fec_enet_stop_mode(fep, true);
 	}
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
@@ -3397,6 +3450,37 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	return irq_cnt;
 }
 
+static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
+				   struct fec_devinfo *dev_info,
+				   struct device_node *np)
+{
+	struct device_node *gpr_np;
+	int ret;
+
+	if (!dev_info)
+		return 0;
+
+	gpr_np = of_parse_phandle(np, "gpr", 0);
+	if (!gpr_np)
+		return 0;
+
+	fep->stop_gpr.gpr = syscon_node_to_regmap(gpr_np);
+	if (IS_ERR(fep->stop_gpr.gpr)) {
+		dev_err(&fep->pdev->dev, "could not find gpr regmap\n");
+		ret = PTR_ERR(fep->stop_gpr.gpr);
+		fep->stop_gpr.gpr = NULL;
+		goto out;
+	}
+
+	fep->stop_gpr.reg = dev_info->stop_gpr_reg;
+	fep->stop_gpr.bit = dev_info->stop_gpr_bit;
+
+out:
+	of_node_put(gpr_np);
+
+	return ret;
+}
+
 static int
 fec_probe(struct platform_device *pdev)
 {
@@ -3412,6 +3496,7 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	int num_rx_qs;
 	char irq_name[8];
 	int irq_cnt;
+	struct fec_devinfo *dev_info;
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3429,7 +3514,9 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	of_id = of_match_device(fec_dt_ids, &pdev->dev);
 	if (of_id)
 		pdev->id_entry = of_id->data;
-	fep->quirks = pdev->id_entry->driver_data;
+	dev_info = (struct fec_devinfo *)pdev->id_entry->driver_data;
+	if (dev_info)
+		fep->quirks = dev_info->quirks;
 
 	fep->netdev = ndev;
 	fep->num_rx_queues = num_rx_qs;
@@ -3463,6 +3550,10 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
+	ret = fec_enet_init_stop_mode(fep, dev_info, np);
+	if (ret)
+		goto failed_stop_mode;
+
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3631,6 +3722,7 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
+failed_stop_mode:
 failed_phy:
 	dev_id--;
 failed_ioremap:
@@ -3708,7 +3800,6 @@ static int __maybe_unused fec_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
 	int ret;
 	int val;
 
@@ -3726,8 +3817,8 @@ static int __maybe_unused fec_resume(struct device *dev)
 			goto failed_clk;
 		}
 		if (fep->wol_flag & FEC_WOL_FLAG_ENABLE) {
-			if (pdata && pdata->sleep_mode_enable)
-				pdata->sleep_mode_enable(false);
+			fec_enet_stop_mode(fep, false);
+
 			val = readl(fep->hwp + FEC_ECNTRL);
 			val &= ~(FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 			writel(val, fep->hwp + FEC_ECNTRL);
-- 
1.9.1

