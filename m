Return-Path: <netdev+bounces-11373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86ACE732D11
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9A791C20FC4
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066461990A;
	Fri, 16 Jun 2023 10:05:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF53D19BAB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:05:43 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2C02D6A;
	Fri, 16 Jun 2023 03:05:41 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686909940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t2Z5u2pdOFyGeWrHTpiauz2Y6DQCmtBj67ZZlH6r9Yw=;
	b=VlB+mmJ2KMVQ8xlzcP3HMRvb5AeWgOC78aVXaAdm09rhishVYbGo+PWKobqI3HDIUmYt2g
	9H26shu1MISdr0Dia4H4wI2xmUuJX6x7PfTBr6o7bwSKeqNcq+SjtLTaIuzTSDGJiV2CTc
	eMZtWGVB03cIOL/+zTHKONDW9IVPnQ2JXqMX7Sh8ngeoZVSBwebjDYE/5hFvPuQ9kypHdO
	Gr0yiCKawtD8wSSvJjkdLmo0WZc6XL1ODdy2i94C7PBAt9Y19PpLySKigSUxM74dGF6eSn
	XWBgVNi/8rf6CjbYOie1iT5GEko7xJWXEPVqJQsGNDkOdydVBmyZKLTNTdEXEg==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 70DAC20014;
	Fri, 16 Jun 2023 10:05:39 +0000 (UTC)
From: alexis.lothore@bootlin.com
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Nicolas Carrier <nicolas.carrier@nav-timing.safrangroup.com>
Subject: [PATCH net-next 8/8] net: stmmac: enable timestamp external trigger for dwmac1000
Date: Fri, 16 Jun 2023 12:04:09 +0200
Message-ID: <20230616100409.164583-9-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230616100409.164583-1-alexis.lothore@bootlin.com>
References: <20230616100409.164583-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

The code is pretty similar to dwmac4 snapshot external trigger code. The
difference is mostly about used registers addresses and/or bits offset in
registers

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  2 +
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   | 12 ++-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  | 83 +++++++++++++++++++
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 6267bcb60206..98f5413cefee 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -17,6 +17,7 @@
 
 #include "stmmac.h"
 #include "stmmac_platform.h"
+#include "dwmac1000.h"
 
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
@@ -428,6 +429,7 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
 	dwmac->ops = ops;
 	plat_dat->bsp_priv = dwmac;
 	plat_dat->fix_mac_speed = socfpga_dwmac_fix_mac_speed;
+	plat_dat->ext_snapshot_num = GMAC_TC_ATSEN0;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 4296ddda8aaa..d17929ea63e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -41,8 +41,7 @@
 #define	GMAC_INT_DISABLE_PCS	(GMAC_INT_DISABLE_RGMII | \
 				 GMAC_INT_DISABLE_PCSLINK | \
 				 GMAC_INT_DISABLE_PCSAN)
-#define	GMAC_INT_DEFAULT_MASK	(GMAC_INT_DISABLE_TIMESTAMP | \
-				 GMAC_INT_DISABLE_PCS)
+#define	GMAC_INT_DEFAULT_MASK	GMAC_INT_DISABLE_PCS
 
 /* PMT Control and Status */
 #define GMAC_PMT		0x0000002c
@@ -329,5 +328,14 @@ enum rtc_control {
 #define GMAC_MMC_RX_CSUM_OFFLOAD   0x208
 #define GMAC_EXTHASH_BASE  0x500
 
+/* Timestamping registers */
+#define GMAC_TIMESTAMP_C0NTROL	0x00000700
+#define GMAC_TC_ATSFC	BIT(24)
+#define GMAC_TC_ATSEN0	BIT(25)
+#define GMAC_TIMESTAMP_STATUS	0x00000728
+#define GMAC_AT_NS	0x00000730
+#define GMAC_AT_NS_MASK	0x7FFFFFFF
+#define GMAC_AT_S	0x00000734
+
 extern const struct stmmac_dma_ops dwmac1000_dma_ops;
 #endif /* __DWMAC1000_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 3927609abc44..97d94b009014 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -19,6 +19,7 @@
 #include "stmmac.h"
 #include "stmmac_pcs.h"
 #include "dwmac1000.h"
+#include "stmmac_ptp.h"
 
 static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
@@ -294,9 +295,58 @@ static void dwmac1000_rgsmii(void __iomem *ioaddr, struct stmmac_extra_stats *x)
 	}
 }
 
+static void get_ptptime(void __iomem *ioaddr, u64 *ptp_time)
+{
+	u64 ns;
+
+	ns = (readl(ioaddr + GMAC_AT_NS) & GMAC_AT_NS_MASK);
+	*ptp_time = ns;
+	ns = readl(ioaddr + GMAC_AT_S);
+	*ptp_time += ns * NSEC_PER_SEC;
+}
+
+static void dwmac1000_ptp_isr(struct stmmac_priv *priv)
+{
+	struct ptp_clock_event event;
+	u32 status_reg, num_snapshot;
+	unsigned long flags;
+	u64 ptp_time;
+	int i = 0;
+
+	if (priv->plat->int_snapshot_en) {
+		wake_up(&priv->tstamp_busy_wait);
+		return;
+	}
+
+	/* Read timestamp status to clear interrupt from either external
+	 * timestamp or start/end of PPS.
+	 */
+	status_reg = readl(priv->ioaddr + GMAC_TIMESTAMP_STATUS);
+
+	if (!priv->plat->ext_snapshot_en)
+		return;
+
+	num_snapshot = (status_reg & GMAC_TIMESTAMP_ATSNS_MASK) >>
+		       GMAC_TIMESTAMP_ATSNS_SHIFT;
+	if (!num_snapshot)
+		return;
+
+	for (i = 0; i < num_snapshot; i++) {
+		read_lock_irqsave(&priv->ptp_lock, flags);
+		get_ptptime(priv->ioaddr, &ptp_time);
+		read_unlock_irqrestore(&priv->ptp_lock, flags);
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = 0;
+		event.timestamp = ptp_time;
+		ptp_clock_event(priv->ptp_clock, &event);
+	}
+}
+
 static int dwmac1000_irq_status(struct mac_device_info *hw,
 				struct stmmac_extra_stats *x)
 {
+	struct stmmac_priv *priv =
+		container_of(x, struct stmmac_priv, xstats);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 intr_status = readl(ioaddr + GMAC_INT_STATUS);
 	u32 intr_mask = readl(ioaddr + GMAC_INT_MASK);
@@ -318,6 +368,9 @@ static int dwmac1000_irq_status(struct mac_device_info *hw,
 		x->irq_receive_pmt_irq_n++;
 	}
 
+	if (intr_status & GMAC_INT_STATUS_TSTAMP)
+		dwmac1000_ptp_isr(priv);
+
 	/* MAC tx/rx EEE LPI entry/exit interrupts */
 	if (intr_status & GMAC_INT_STATUS_LPIIS) {
 		/* Clean LPI interrupt by reading the Reg 12 */
@@ -502,6 +555,34 @@ static void dwmac1000_set_mac_loopback(void __iomem *ioaddr, bool enable)
 	writel(value, ioaddr + GMAC_CONTROL);
 }
 
+static void dwmac1000_extts_configure(void __iomem *ioaddr, int ext_snapshot_num,
+				      bool on, struct net_device *dev)
+{
+	u32 acr_value;
+
+	/* Since DWMAC1000 has only one external trigger input,
+	 * ext_snapshot_num is not used
+	 */
+	acr_value = readl(ioaddr + GMAC_TIMESTAMP_C0NTROL);
+	acr_value &= ~GMAC_TC_ATSEN0;
+	if (on) {
+		acr_value |= GMAC_TC_ATSEN0;
+		acr_value |= GMAC_TC_ATSFC;
+		netdev_dbg(dev, "Auxiliary Snapshot 0 enabled.\n");
+	} else {
+		netdev_dbg(dev, "Auxiliary Snapshot 0 disabled.\n");
+	}
+	writel(acr_value, ioaddr + GMAC_TIMESTAMP_C0NTROL);
+}
+
+static int dwmac1000_clear_snapshot_fifo(void __iomem *ioaddr)
+{
+	u32 acr_value;
+
+	return readl_poll_timeout(ioaddr + GMAC_TIMESTAMP_C0NTROL, acr_value,
+				  !(acr_value & GMAC_TC_ATSFC), 10, 10000);
+}
+
 const struct stmmac_ops dwmac1000_ops = {
 	.core_init = dwmac1000_core_init,
 	.set_mac = stmmac_set_mac,
@@ -522,6 +603,8 @@ const struct stmmac_ops dwmac1000_ops = {
 	.pcs_rane = dwmac1000_rane,
 	.pcs_get_adv_lp = dwmac1000_get_adv_lp,
 	.set_mac_loopback = dwmac1000_set_mac_loopback,
+	.extts_configure = dwmac1000_extts_configure,
+	.clear_snapshot_fifo = dwmac1000_clear_snapshot_fifo
 };
 
 int dwmac1000_setup(struct stmmac_priv *priv)
-- 
2.41.0


