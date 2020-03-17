Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81582188B19
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbgCQQuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:50:12 -0400
Received: from mail-wm1-f100.google.com ([209.85.128.100]:51091 "EHLO
        mail-wm1-f100.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgCQQuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:50:12 -0400
Received: by mail-wm1-f100.google.com with SMTP id z13so46239wml.0
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 09:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/qLuw9eKcX9ERX0e5EbOyuV/VdB/pnRMXE+XeLVt+RA=;
        b=Vkeii+TsYFOKtKlBrkWuKOyWMEOh5M4Ia9DiFJY/d8mTfO0Fg6cka2LyLO8KG1XbwI
         Edr2CRomRUDRPmY28odQz/yq8/YXjINK3i9Ut+vpHiD0weV4ZPL0SCSWY/hImVFMPMHf
         GKNaPAGhb4tFrFPe9UK+tr6UWSz2lOo2LETVdEpuC1H09zaTQvn6DBlelOkIm3uisFlt
         HctESooxOqv83AOldGlxJXfq8o/mOvy6Sy7px2BsbS1Jc/fN7S7bzG7m9OpiSHTUPW3f
         PBJGss9rFHlZxX1u/hFSc67lqyl/vMavM9Fsw3dWVS3AkvI73La2lpLQzS9SQsgfwdu/
         ci3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/qLuw9eKcX9ERX0e5EbOyuV/VdB/pnRMXE+XeLVt+RA=;
        b=KmirLe/CB4FNlOEmzeVEKbt2L4zXK0Hp8t/WtZj4R+HjKqaadH9Fn3f3R1jfQkgEMy
         iez03TxpkYckuIDeeuVCw5qCRoPdfN0/F8UVup01tGPS1Lxft6NVlnHX8TU0bLD9dxpb
         ASRjhW4gkopPapiiyPKQvdcizBt73QHNHqHkI17AqPFwIdnhaqhd2zkiY2QZ4/nIf439
         kNK5/XAjMlYaNLtHVKJpb3811qEfcd9YasAXkOnAbVSQXyCYJBaa9OpRXEp/NtaFGdq3
         ucg5R504QA7WlVbnu7JViXIZg4CXvw8HlY/L1dDd95dHOvvlg4bLWyxlmRPzQjmvHhGm
         N5Lw==
X-Gm-Message-State: ANhLgQ2Xgv49uwlp8i6iAyTLVymSjeToTTlnKPJFziZQslUWIe6YGJRn
        F3smxZn+08ruwlmWyY7+hH7NcExdnHHp2WIPqyoQXibyLYWS
X-Google-Smtp-Source: ADFU+vuDoHCGd3/qo1wkUNqXABgauZq3sw0Ba2Nx2etnwHKoCA+NhfAit5NN9dwlZwzS9pmx1kILV23Al5PC
X-Received: by 2002:a1c:f008:: with SMTP id a8mr178661wmb.81.1584463808751;
        Tue, 17 Mar 2020 09:50:08 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id i203sm44306wma.51.2020.03.17.09.50.08
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 17 Mar 2020 09:50:08 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.134] (port=56876 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jEFPs-0000dJ-AU; Tue, 17 Mar 2020 17:50:08 +0100
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 1/4] net: fec: set GPR bit on suspend by DT connfiguration.
Date:   Tue, 17 Mar 2020 17:50:03 +0100
Message-Id: <1584463806-15788-2-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
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
by adding a new optional DT property indicating the register and
bit to set.

[1] https://www.spinics.net/lists/netdev/msg310922.html

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
---
 drivers/net/ethernet/freescale/fec.h      |  7 +++
 drivers/net/ethernet/freescale/fec_main.c | 72 ++++++++++++++++++++++++++++---
 2 files changed, 72 insertions(+), 7 deletions(-)

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
index 23c5fef..3c78124 100644
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
@@ -1092,11 +1094,28 @@ static void fec_enet_reset_skb(struct net_device *ndev)
 
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
 
@@ -1125,9 +1144,7 @@ static void fec_enet_reset_skb(struct net_device *ndev)
 		val = readl(fep->hwp + FEC_ECNTRL);
 		val |= (FEC_ECR_MAGICEN | FEC_ECR_SLEEP);
 		writel(val, fep->hwp + FEC_ECNTRL);
-
-		if (pdata && pdata->sleep_mode_enable)
-			pdata->sleep_mode_enable(true);
+		fec_enet_stop_mode(fep, true);
 	}
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
@@ -3397,6 +3414,43 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	return irq_cnt;
 }
 
+static int fec_enet_of_parse_stop_mode(struct fec_enet_private *fep,
+				       struct device_node *np)
+{
+	static const char prop[] = "fsl,stop-mode";
+	struct of_phandle_args args;
+	int ret;
+
+	ret = of_parse_phandle_with_fixed_args(np, prop, 2, 0, &args);
+	if (ret == -ENOENT)
+		return 0;
+	if (ret)
+		return ret;
+
+	if (args.args_count != 2) {
+		dev_err(&fep->pdev->dev,
+			"Bad %s args want gpr offset, bit\n", prop);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	fep->stop_gpr.gpr = syscon_node_to_regmap(args.np);
+	if (IS_ERR(fep->stop_gpr.gpr)) {
+		dev_err(&fep->pdev->dev, "could not find gpr regmap\n");
+		ret = PTR_ERR(fep->stop_gpr.gpr);
+		fep->stop_gpr.gpr = NULL;
+		goto out;
+	}
+
+	fep->stop_gpr.reg = args.args[0];
+	fep->stop_gpr.bit = args.args[1];
+
+out:
+	of_node_put(args.np);
+
+	return ret;
+}
+
 static int
 fec_probe(struct platform_device *pdev)
 {
@@ -3463,6 +3517,10 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	if (of_get_property(np, "fsl,magic-packet", NULL))
 		fep->wol_flag |= FEC_WOL_HAS_MAGIC_PACKET;
 
+	ret = fec_enet_of_parse_stop_mode(fep, np);
+	if (ret)
+		goto failed_stop_mode;
+
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3631,6 +3689,7 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(phy_node);
+failed_stop_mode:
 failed_phy:
 	dev_id--;
 failed_ioremap:
@@ -3708,7 +3767,6 @@ static int __maybe_unused fec_resume(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	struct fec_platform_data *pdata = fep->pdev->dev.platform_data;
 	int ret;
 	int val;
 
@@ -3726,8 +3784,8 @@ static int __maybe_unused fec_resume(struct device *dev)
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

