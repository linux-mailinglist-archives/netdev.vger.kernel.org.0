Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB2E596A60
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiHQH3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHQH3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:29:43 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D236AA2F
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 00:29:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso1087594pjl.1
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 00:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=aD2cHpJkUAZ+6bzE300kLIZZ9k/tT8ByI9TUykR0D6Y=;
        b=TqfFOpeLf+m9A05oZpaW8OLZYtQVVrnOSpcE8nfsc4ZPNhs9+Mq9yhDMhNy+cR0ASE
         XuuINMTHvYjo7y1aAFDb4XKsQmYf54qieG/BLBQ1csFDd9LveijeXBWSi3mKj8V4tpAF
         s3c8bJJzEtbTHPICweuDHTFgpYoGDTiL9xIVoxMm7kAh7hqbFK/x6np6QW9Dw3sFOtu2
         ASXnfaBDqdk2nF4XKjK12Jc1XnT01jD/Cv8W/gSl0hT6Vdtuh1ADpkPdlTYDVwel9UQY
         RlVO/m9rwcZ5/WqDCHXmVgS+I4gLUn5eCyfPoZmrpf4mVE0baB4J9r1KF2pt3nDxeQ8E
         DcjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=aD2cHpJkUAZ+6bzE300kLIZZ9k/tT8ByI9TUykR0D6Y=;
        b=TjRITroDruH8cPV7Z2UuqiXEV3H+V+uPxGrBT+3Vw0mggAOS16G4rKen4onJgIUEjy
         ehoXJZnZ6WuZDnJ3AI9l/DZqp23UKSIopOZQquW8HoyK5aPQqxh2jAeLnMSHBS9sxp21
         kQOLU6Wd5btymSJa47Klibj9TR0fWHJWqb9sEDlEy+I+LuTH0unT5Xyq6eAVCpWZ4Rmi
         PKczqZtgin6N75fYd4E7WxaOYqKJyYkPHOLsKSvx9uz29yDJxgdZx3ucbQHSvpMJLFib
         /3S/mSPgb98Ct3s/9mcM/JqQ6J9uI0kbc6vHgv+1TbClkxpNRKYohRJ2VX+1l2+IEphY
         BUYQ==
X-Gm-Message-State: ACgBeo1bKXZproVqsf+wKQk5UHwqFHWbFNuB+8QcTh2jHvfQLNte5OJj
        bwCOCOZSODcNew0Z3NDqaqk=
X-Google-Smtp-Source: AA6agR6EAiieeajF88tVhgBSgRISNOWqa0kQ6JXEThU0OwkwmVocxjf3lzaB6BzaWw6b1mVtx3994g==
X-Received: by 2002:a17:902:f54a:b0:16f:16bb:778e with SMTP id h10-20020a170902f54a00b0016f16bb778emr24816231plf.37.1660721381711;
        Wed, 17 Aug 2022 00:29:41 -0700 (PDT)
Received: from localhost.localdomain ([112.20.110.237])
        by smtp.gmail.com with ESMTPSA id l2-20020a17090af8c200b001f3076970besm819327pjd.26.2022.08.17.00.29.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Aug 2022 00:29:41 -0700 (PDT)
From:   chris.chenfeiyang@gmail.com
X-Google-Original-From: chenfeiyang@loongson.cn
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com
Cc:     Feiyang Chen <chenfeiyang@loongson.cn>, zhangqing@loongson.cn,
        chenhuacai@loongson.cn, chris.chenfeiyang@gmail.com,
        netdev@vger.kernel.org, loongarch@lists.linux.dev
Subject: [PATCH v2 1/2] stmmac: Expose module parameters
Date:   Wed, 17 Aug 2022 15:29:18 +0800
Message-Id: <5bf66e7d30d909cdaad46557d800d33118404e4d.1660720671.git.chenfeiyang@loongson.cn>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660720671.git.chenfeiyang@loongson.cn>
References: <cover.1660720671.git.chenfeiyang@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feiyang Chen <chenfeiyang@loongson.cn>

Expose module parameters so that we can use them in specific device
configurations. Add the 'stmmac_' prefix for them to avoid conflicts.

Meanwhile, there was a 'buf_sz' local variable in stmmac_rx() with the
same name as the global variable, and now we can distinguish them.

Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  11 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 117 +++++++++---------
 2 files changed, 70 insertions(+), 58 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index bdbf86cb102a..e5395ed96817 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -332,6 +332,17 @@ enum stmmac_state {
 	STMMAC_SERVICE_SCHED,
 };
 
+/* Module parameters */
+extern int stmmac_watchdog;
+extern int stmmac_debug;
+extern int stmmac_phyaddr;
+extern int stmmac_flow_ctrl;
+extern int stmmac_pause;
+extern int stmmac_tc;
+extern int stmmac_buf_sz;
+extern int stmmac_eee_timer;
+extern unsigned int stmmac_chain_mode;
+
 int stmmac_mdio_unregister(struct net_device *ndev);
 int stmmac_mdio_register(struct net_device *ndev);
 int stmmac_mdio_reset(struct mii_bus *mii);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 070b5ef165eb..1a40dc88148e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -62,16 +62,16 @@
 
 /* Module parameters */
 #define TX_TIMEO	5000
-static int watchdog = TX_TIMEO;
-module_param(watchdog, int, 0644);
+int stmmac_watchdog = TX_TIMEO;
+module_param_named(watchdog, stmmac_watchdog, int, 0644);
 MODULE_PARM_DESC(watchdog, "Transmit timeout in milliseconds (default 5s)");
 
-static int debug = -1;
-module_param(debug, int, 0644);
+int stmmac_debug = -1;
+module_param_named(debug, stmmac_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Message Level (-1: default, 0: no output, 16: all)");
 
-static int phyaddr = -1;
-module_param(phyaddr, int, 0444);
+int stmmac_phyaddr = -1;
+module_param_named(phyaddr, stmmac_phyaddr, int, 0444);
 MODULE_PARM_DESC(phyaddr, "Physical device address");
 
 #define STMMAC_TX_THRESH(x)	((x)->dma_conf.dma_tx_size / 4)
@@ -87,22 +87,22 @@ MODULE_PARM_DESC(phyaddr, "Physical device address");
 #define STMMAC_XDP_TX		BIT(1)
 #define STMMAC_XDP_REDIRECT	BIT(2)
 
-static int flow_ctrl = FLOW_AUTO;
-module_param(flow_ctrl, int, 0644);
+int stmmac_flow_ctrl = FLOW_AUTO;
+module_param_named(flow_ctrl, stmmac_flow_ctrl, int, 0644);
 MODULE_PARM_DESC(flow_ctrl, "Flow control ability [on/off]");
 
-static int pause = PAUSE_TIME;
-module_param(pause, int, 0644);
+int stmmac_pause = PAUSE_TIME;
+module_param_named(pause, stmmac_pause, int, 0644);
 MODULE_PARM_DESC(pause, "Flow Control Pause Time");
 
 #define TC_DEFAULT 64
-static int tc = TC_DEFAULT;
-module_param(tc, int, 0644);
+int stmmac_tc = TC_DEFAULT;
+module_param_named(tc, stmmac_tc, int, 0644);
 MODULE_PARM_DESC(tc, "DMA threshold control value");
 
 #define	DEFAULT_BUFSIZE	1536
-static int buf_sz = DEFAULT_BUFSIZE;
-module_param(buf_sz, int, 0644);
+int stmmac_buf_sz = DEFAULT_BUFSIZE;
+module_param_named(buf_sz, stmmac_buf_sz, int, 0644);
 MODULE_PARM_DESC(buf_sz, "DMA buffer size");
 
 #define	STMMAC_RX_COPYBREAK	256
@@ -112,16 +112,16 @@ static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 				      NETIF_MSG_IFDOWN | NETIF_MSG_TIMER);
 
 #define STMMAC_DEFAULT_LPI_TIMER	1000
-static int eee_timer = STMMAC_DEFAULT_LPI_TIMER;
-module_param(eee_timer, int, 0644);
+int stmmac_eee_timer = STMMAC_DEFAULT_LPI_TIMER;
+module_param_named(eee_timer, stmmac_eee_timer, int, 0644);
 MODULE_PARM_DESC(eee_timer, "LPI tx expiration time in msec");
 #define STMMAC_LPI_T(x) (jiffies + usecs_to_jiffies(x))
 
 /* By default the driver will use the ring mode to manage tx and rx descriptors,
  * but allow user to force to use the chain instead of the ring
  */
-static unsigned int chain_mode;
-module_param(chain_mode, int, 0444);
+unsigned int stmmac_chain_mode;
+module_param_named(chain_mode, stmmac_chain_mode, int, 0444);
 MODULE_PARM_DESC(chain_mode, "To use chain instead of ring mode");
 
 static irqreturn_t stmmac_interrupt(int irq, void *dev_id);
@@ -185,18 +185,19 @@ EXPORT_SYMBOL_GPL(stmmac_bus_clks_config);
  */
 static void stmmac_verify_args(void)
 {
-	if (unlikely(watchdog < 0))
-		watchdog = TX_TIMEO;
-	if (unlikely((buf_sz < DEFAULT_BUFSIZE) || (buf_sz > BUF_SIZE_16KiB)))
-		buf_sz = DEFAULT_BUFSIZE;
-	if (unlikely(flow_ctrl > 1))
-		flow_ctrl = FLOW_AUTO;
-	else if (likely(flow_ctrl < 0))
-		flow_ctrl = FLOW_OFF;
-	if (unlikely((pause < 0) || (pause > 0xffff)))
-		pause = PAUSE_TIME;
-	if (eee_timer < 0)
-		eee_timer = STMMAC_DEFAULT_LPI_TIMER;
+	if (unlikely(stmmac_watchdog < 0))
+		stmmac_watchdog = TX_TIMEO;
+	if (unlikely((stmmac_buf_sz < DEFAULT_BUFSIZE) ||
+	    (stmmac_buf_sz > BUF_SIZE_16KiB)))
+		stmmac_buf_sz = DEFAULT_BUFSIZE;
+	if (unlikely(stmmac_flow_ctrl > 1))
+		stmmac_flow_ctrl = FLOW_AUTO;
+	else if (likely(stmmac_flow_ctrl < 0))
+		stmmac_flow_ctrl = FLOW_OFF;
+	if (unlikely((stmmac_pause < 0) || (stmmac_pause > 0xffff)))
+		stmmac_pause = PAUSE_TIME;
+	if (stmmac_eee_timer < 0)
+		stmmac_eee_timer = STMMAC_DEFAULT_LPI_TIMER;
 }
 
 static void __stmmac_disable_all_queues(struct stmmac_priv *priv)
@@ -2338,8 +2339,8 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 	txfifosz /= tx_channels_count;
 
 	if (priv->plat->force_thresh_dma_mode) {
-		txmode = tc;
-		rxmode = tc;
+		txmode = stmmac_tc;
+		rxmode = stmmac_tc;
 	} else if (priv->plat->force_sf_dma_mode || priv->plat->tx_coe) {
 		/*
 		 * In case of GMAC, SF mode can be enabled
@@ -2352,7 +2353,7 @@ static void stmmac_dma_operation_mode(struct stmmac_priv *priv)
 		rxmode = SF_DMA_MODE;
 		priv->xstats.threshold = SF_DMA_MODE;
 	} else {
-		txmode = tc;
+		txmode = stmmac_tc;
 		rxmode = SF_DMA_MODE;
 	}
 
@@ -2483,16 +2484,16 @@ static bool stmmac_xdp_xmit_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 
 static void stmmac_bump_dma_threshold(struct stmmac_priv *priv, u32 chan)
 {
-	if (unlikely(priv->xstats.threshold != SF_DMA_MODE) && tc <= 256) {
-		tc += 64;
+	if (unlikely(priv->xstats.threshold != SF_DMA_MODE) && stmmac_tc <= 256) {
+		stmmac_tc += 64;
 
 		if (priv->plat->force_thresh_dma_mode)
-			stmmac_set_dma_operation_mode(priv, tc, tc, chan);
+			stmmac_set_dma_operation_mode(priv, stmmac_tc, stmmac_tc, chan);
 		else
-			stmmac_set_dma_operation_mode(priv, tc, SF_DMA_MODE,
+			stmmac_set_dma_operation_mode(priv, stmmac_tc, SF_DMA_MODE,
 						      chan);
 
-		priv->xstats.threshold = tc;
+		priv->xstats.threshold = stmmac_tc;
 	}
 }
 
@@ -3337,7 +3338,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	/* Convert the timer from msec to usec */
 	if (!priv->tx_lpi_timer)
-		priv->tx_lpi_timer = eee_timer * 1000;
+		priv->tx_lpi_timer = stmmac_eee_timer * 1000;
 
 	if (priv->use_riwt) {
 		u32 queue;
@@ -3791,11 +3792,11 @@ static int __stmmac_open(struct net_device *dev,
 
 	/* Extra statistics */
 	memset(&priv->xstats, 0, sizeof(struct stmmac_extra_stats));
-	priv->xstats.threshold = tc;
+	priv->xstats.threshold = stmmac_tc;
 
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
-	buf_sz = dma_conf->dma_buf_sz;
+	stmmac_buf_sz = dma_conf->dma_buf_sz;
 	memcpy(&priv->dma_conf, dma_conf, sizeof(*dma_conf));
 
 	stmmac_reset_queues_param(priv);
@@ -6785,8 +6786,8 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 
 	/* dwmac-sun8i only work in chain mode */
 	if (priv->plat->has_sun8i)
-		chain_mode = 1;
-	priv->chain_mode = chain_mode;
+		stmmac_chain_mode = 1;
+	priv->chain_mode = stmmac_chain_mode;
 
 	/* Initialize HW Interface */
 	ret = stmmac_hwif_init(priv);
@@ -7057,7 +7058,7 @@ int stmmac_dvr_probe(struct device *device,
 	priv->dev = ndev;
 
 	stmmac_set_ethtool_ops(ndev);
-	priv->pause = pause;
+	priv->pause = stmmac_pause;
 	priv->plat = plat_dat;
 	priv->ioaddr = res->addr;
 	priv->dev->base_addr = (unsigned long)res->addr;
@@ -7100,8 +7101,8 @@ int stmmac_dvr_probe(struct device *device,
 	/* Override with kernel parameters if supplied XXX CRS XXX
 	 * this needs to have multiple instances
 	 */
-	if ((phyaddr >= 0) && (phyaddr <= 31))
-		priv->plat->phy_addr = phyaddr;
+	if ((stmmac_phyaddr >= 0) && (stmmac_phyaddr <= 31))
+		priv->plat->phy_addr = stmmac_phyaddr;
 
 	if (priv->plat->stmmac_rst) {
 		ret = reset_control_assert(priv->plat->stmmac_rst);
@@ -7188,7 +7189,7 @@ int stmmac_dvr_probe(struct device *device,
 	}
 
 	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
-	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
+	ndev->watchdog_timeo = msecs_to_jiffies(stmmac_watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX;
@@ -7202,7 +7203,7 @@ int stmmac_dvr_probe(struct device *device,
 			ndev->features |= NETIF_F_HW_VLAN_STAG_TX;
 	}
 #endif
-	priv->msg_enable = netif_msg_init(debug, default_msg_level);
+	priv->msg_enable = netif_msg_init(stmmac_debug, default_msg_level);
 
 	/* Initialize RSS */
 	rxq = priv->plat->rx_queues_to_use;
@@ -7232,7 +7233,7 @@ int stmmac_dvr_probe(struct device *device,
 			 "%s: warning: maxmtu having invalid value (%d)\n",
 			 __func__, priv->plat->maxmtu);
 
-	if (flow_ctrl)
+	if (stmmac_flow_ctrl)
 		priv->flow_ctrl = FLOW_AUTO;	/* RX/TX pause on */
 
 	/* Setup channels NAPI */
@@ -7574,31 +7575,31 @@ static int __init stmmac_cmdline_opt(char *str)
 		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
 		if (!strncmp(opt, "debug:", 6)) {
-			if (kstrtoint(opt + 6, 0, &debug))
+			if (kstrtoint(opt + 6, 0, &stmmac_debug))
 				goto err;
 		} else if (!strncmp(opt, "phyaddr:", 8)) {
-			if (kstrtoint(opt + 8, 0, &phyaddr))
+			if (kstrtoint(opt + 8, 0, &stmmac_phyaddr))
 				goto err;
 		} else if (!strncmp(opt, "buf_sz:", 7)) {
-			if (kstrtoint(opt + 7, 0, &buf_sz))
+			if (kstrtoint(opt + 7, 0, &stmmac_buf_sz))
 				goto err;
 		} else if (!strncmp(opt, "tc:", 3)) {
-			if (kstrtoint(opt + 3, 0, &tc))
+			if (kstrtoint(opt + 3, 0, &stmmac_tc))
 				goto err;
 		} else if (!strncmp(opt, "watchdog:", 9)) {
-			if (kstrtoint(opt + 9, 0, &watchdog))
+			if (kstrtoint(opt + 9, 0, &stmmac_watchdog))
 				goto err;
 		} else if (!strncmp(opt, "flow_ctrl:", 10)) {
-			if (kstrtoint(opt + 10, 0, &flow_ctrl))
+			if (kstrtoint(opt + 10, 0, &stmmac_flow_ctrl))
 				goto err;
 		} else if (!strncmp(opt, "pause:", 6)) {
-			if (kstrtoint(opt + 6, 0, &pause))
+			if (kstrtoint(opt + 6, 0, &stmmac_pause))
 				goto err;
 		} else if (!strncmp(opt, "eee_timer:", 10)) {
-			if (kstrtoint(opt + 10, 0, &eee_timer))
+			if (kstrtoint(opt + 10, 0, &stmmac_eee_timer))
 				goto err;
 		} else if (!strncmp(opt, "chain_mode:", 11)) {
-			if (kstrtoint(opt + 11, 0, &chain_mode))
+			if (kstrtoint(opt + 11, 0, &stmmac_chain_mode))
 				goto err;
 		}
 	}
-- 
2.31.1

