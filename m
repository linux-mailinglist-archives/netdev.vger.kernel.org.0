Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE6B6BD093
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCPNRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCPNRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:17:14 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40850C2D85;
        Thu, 16 Mar 2023 06:16:59 -0700 (PDT)
Received: from maxwell.localdomain ([213.61.141.186]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MT7ip-1q5m9U3jBf-00UeqB; Thu, 16 Mar 2023 14:15:24 +0100
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     netdev@vger.kernel.org
Cc:     Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net V2] net: stmmac: Fix for mismatched host/device DMA address width
Date:   Thu, 16 Mar 2023 14:15:03 +0100
Message-Id: <20230316131503.738933-1-jh@henneberg-systemdesign.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316095306.721255-1-jh@henneberg-systemdesign.com>
References: <20230316095306.721255-1-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:bfLeLJD9lJ3G3iT5iYg7UEsU81bVboCAdkEgfok56g7FNBxUgCq
 LNgriGZGnkbYpSN3KWkzpEvU7GSOnbMFpLmKOCO0dQlJ6nZ3SEAWl2vPzYr7b1PCKE9xX7A
 aPk4aLnMk+J7XvkK6quh9VuPhDfM7FPOfbpeXDOzde1tKmTBHkEwx7dDHdiTnMCJo5DNtU5
 GvEy4RijTXnk/8jpaUPKw==
UI-OutboundReport: notjunk:1;M01:P0:IsJsY91fw44=;Sez0sKu91tpF1iMfVXGvU+Bl/CE
 swTEhlRDPsrBdyqVk/cIuntzl1S4uGGV7oI3rfn8x3tkSbY2JSa6tDr6AXOBq+V420HYSv0pU
 GGgAVL8cBWSKuEF6IdLPH1+35DvXBzA0uZEukMJX5dwAsrXWchvZEqxSxqiGGr1gcLaYdJBrX
 hU9/wJ0jQ/lGSH9P+IViv0xIIld7dtJcBY51vbEY0v+yf8HePgpYvWnsKaJ1q9198tm4UbG3m
 4WUMgKzmeB4ZuMX+74A3tzn1kqWQFtge/epSAfJhsMhF42IY5F15lVPZ4RDwFTFjurOsUVXW9
 vJbs//H6kVZ1kWEHNXPS61/75VMSKuMDS2c1bpOWrWQ1OusiRwF7mjqYPkjrKWZLIVTlWouIe
 yIH2oGUxvEBA7jat6GxL9aHv5y3Y9hWjWbeh2sgTm7EWWQlmNlt8hJ+FrM66oEGMOCpeagMJc
 587m1GDGXJcubTbM0Z1s/F0BckvEg1VbGwvFlEdkbMzzi/Clgj4SlEFlq781kMMgcpqbMF80r
 eNDNta59fIKIF6e+brSFukkbXUMaaUehIwuPCeWExGX3LrEY6DyS+j1K83KPLVCKx2Y5HKM3o
 7HOxMzY4ADS+kX5FYJj4uNvdfAeleajn07wI2TQCqVo5FyZKXIk5mm+zgGzn8HgewF2LKGwE6
 /NLSDb6cdeuDIciBT4qQB/+n0TgB0Gtcn7EnDKNcgw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DMA address width is either read from a RO device register
or force set from the platform data. This breaks DMA when the host DMA
address width is <=32it but the device is >32bit.

Right now the driver may decide to use a 2nd DMA descriptor for
another buffer (happens in case of TSO xmit) assuming that 32bit
addressing is used due to platform configuration but the device will
still use both descriptor addresses as one address.

This can be observed with the Intel EHL platform driver that sets
32bit for addr64 but the MAC reports 40bit. The TX queue gets stuck in
case of TCP with iptables NAT configuration on TSO packets.

The logic should be like this: Whatever we do on the host side (memory
allocation GFP flags) should happen with the host DMA width, whenever
we decide how to set addresses on the device registers we must use the
device DMA address width.

This patch renames the platform address width field from addr64 (term
used in device datasheet) to host_addr and uses this value exclusively
for host side operations while all chip operations consider the device
DMA width as read from the device register.

Fixes: 7cfc4486e7ea ("stmmac: intel: Configure EHL PSE0 GbE and PSE1 GbE to 32 bits DMA addressing")
Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
---
V2: Fixes from checkpatch.pl for commit message

 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  4 +--
 .../ethernet/stmicro/stmmac/dwmac-mediatek.c  |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 30 ++++++++++---------
 include/linux/stmmac.h                        |  2 +-
 6 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6b5d96bced47..55a728b1b708 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -418,6 +418,7 @@ struct dma_features {
 	unsigned int frpbs;
 	unsigned int frpes;
 	unsigned int addr64;
+	unsigned int host_addr;
 	unsigned int rssen;
 	unsigned int vlhash;
 	unsigned int sphen;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index ac8580f501e2..bc06c517df9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -289,7 +289,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 		goto err_parse_dt;
 	}
 
-	plat_dat->addr64 = dwmac->ops->addr_width;
+	plat_dat->host_addr = dwmac->ops->addr_width;
 	plat_dat->init = imx_dwmac_init;
 	plat_dat->exit = imx_dwmac_exit;
 	plat_dat->clks_config = imx_dwmac_clks_config;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 7deb1f817dac..193c3a842500 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -684,7 +684,7 @@ static int ehl_pse0_common_data(struct pci_dev *pdev,
 
 	intel_priv->is_pse = true;
 	plat->bus_id = 2;
-	plat->addr64 = 32;
+	plat->host_dma_addr = 32;
 
 	plat->clk_ptp_rate = 200000000;
 
@@ -725,7 +725,7 @@ static int ehl_pse1_common_data(struct pci_dev *pdev,
 
 	intel_priv->is_pse = true;
 	plat->bus_id = 3;
-	plat->addr64 = 32;
+	plat->host_dma_addr = 32;
 
 	plat->clk_ptp_rate = 200000000;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
index 2f7d8e4561d9..968c8172c5bd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
@@ -591,7 +591,7 @@ static int mediatek_dwmac_common_data(struct platform_device *pdev,
 	plat->use_phy_wol = priv_plat->mac_wol ? 0 : 1;
 	plat->riwt_off = 1;
 	plat->maxmtu = ETH_DATA_LEN;
-	plat->addr64 = priv_plat->variant->dma_bit_mask;
+	plat->host_dma_addr = priv_plat->variant->dma_bit_mask;
 	plat->bsp_priv = priv_plat;
 	plat->init = mediatek_dwmac_init;
 	plat->clks_config = mediatek_dwmac_clks_config;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4886668a54c5..9f9cad178360 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1430,7 +1430,7 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv,
 	struct stmmac_rx_buffer *buf = &rx_q->buf_pool[i];
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
-	if (priv->dma_cap.addr64 <= 32)
+	if (priv->dma_cap.host_addr <= 32)
 		gfp |= GFP_DMA32;
 
 	if (!buf->page) {
@@ -4586,7 +4586,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 	unsigned int entry = rx_q->dirty_rx;
 	gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
 
-	if (priv->dma_cap.addr64 <= 32)
+	if (priv->dma_cap.host_addr <= 32)
 		gfp |= GFP_DMA32;
 
 	while (dirty-- > 0) {
@@ -6204,7 +6204,7 @@ static int stmmac_dma_cap_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "\tFlexible RX Parser: %s\n",
 		   priv->dma_cap.frpsel ? "Y" : "N");
 	seq_printf(seq, "\tEnhanced Addressing: %d\n",
-		   priv->dma_cap.addr64);
+		   priv->dma_cap.host_addr);
 	seq_printf(seq, "\tReceive Side Scaling: %s\n",
 		   priv->dma_cap.rssen ? "Y" : "N");
 	seq_printf(seq, "\tVLAN Hash Filtering: %s\n",
@@ -7177,20 +7177,22 @@ int stmmac_dvr_probe(struct device *device,
 		dev_info(priv->device, "SPH feature enabled\n");
 	}
 
-	/* The current IP register MAC_HW_Feature1[ADDR64] only define
-	 * 32/40/64 bit width, but some SOC support others like i.MX8MP
-	 * support 34 bits but it map to 40 bits width in MAC_HW_Feature1[ADDR64].
-	 * So overwrite dma_cap.addr64 according to HW real design.
+	/* Ideally our host DMA address width is the same as for the
+	 * device. However, it may differ and then we have to use our
+	 * host DMA width for allocation and the device DMA width for
+	 * register handling.
 	 */
-	if (priv->plat->addr64)
-		priv->dma_cap.addr64 = priv->plat->addr64;
+	if (priv->plat->host_dma_addr)
+		priv->dma_cap.host_addr = priv->plat->host_dma_addr;
+	else
+		priv->dma_cap.host_addr = priv->dma_cap.addr64;
 
-	if (priv->dma_cap.addr64) {
+	if (priv->dma_cap.host_addr) {
 		ret = dma_set_mask_and_coherent(device,
-				DMA_BIT_MASK(priv->dma_cap.addr64));
+				DMA_BIT_MASK(priv->dma_cap.host_addr));
 		if (!ret) {
-			dev_info(priv->device, "Using %d bits DMA width\n",
-				 priv->dma_cap.addr64);
+			dev_info(priv->device, "Using %d/%d bits DMA host/device width\n",
+				 priv->dma_cap.host_addr, priv->dma_cap.addr64);
 
 			/*
 			 * If more than 32 bits can be addressed, make sure to
@@ -7205,7 +7207,7 @@ int stmmac_dvr_probe(struct device *device,
 				goto error_hw_init;
 			}
 
-			priv->dma_cap.addr64 = 32;
+			priv->dma_cap.host_addr = 32;
 		}
 	}
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a152678b82b7..1cc4d61d6155 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -215,7 +215,7 @@ struct plat_stmmacenet_data {
 	int unicast_filter_entries;
 	int tx_fifo_size;
 	int rx_fifo_size;
-	u32 addr64;
+	u32 host_dma_addr;
 	u32 rx_queues_to_use;
 	u32 tx_queues_to_use;
 	u8 rx_sched_algorithm;
-- 
2.39.2

