Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70C44F8F2C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiDHHDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiDHHDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:03:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE53E9D078;
        Fri,  8 Apr 2022 00:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649401264; x=1680937264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=51czlh0dwlk2nEU51JbbRM3A1HF2vk3dTXhINtaCj0s=;
  b=nHhhqTH36l8zTRyGnMOr/stox+2iglLKs4cHNdW4ySvzT0UVkivJiSAY
   XAZtu0awWuny5GNblM3CaIGh6e7fYrmh9RirpNfI5OsaXcHNIREWlBRme
   er+vYP4UIQEqUNDubDvPUGzQGupDUuRtX8GG+S4DgSIj6s6xYf3ylEPXQ
   kXHB7MIBuiXmF5qVNPffD1+4wcnVNjixBTfFjBPFuKHj5AWL8obQtPt+8
   FUcLoTYNCVXfNJvpyt9D/uk9iRdM4e8XFXFVcWKvAlxgifR7Fvc2Ch6x9
   YEGLpYCQq7fZu8NC/KrrcDEau6c7PiW/jGNfn3KjQfT/QqeWN2saivvIE
   A==;
X-IronPort-AV: E=Sophos;i="5.90,244,1643698800"; 
   d="scan'208";a="91729011"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Apr 2022 00:01:03 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Apr 2022 00:01:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 8 Apr 2022 00:01:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <michael@walle.cc>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 4/4] net: lan966x: Update FDMA to change MTU.
Date:   Fri, 8 Apr 2022 09:03:57 +0200
Message-ID: <20220408070357.559899-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220408070357.559899-1-horatiu.vultur@microchip.com>
References: <20220408070357.559899-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When changing the MTU, it is required to change also the size of the
DBs. In case those frames will arrive to CPU.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 134 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.c |  14 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |   1 +
 3 files changed, 148 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index f5fdb7455a41..9e2a7323eaf0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -336,6 +336,20 @@ static void lan966x_fdma_wakeup_netdev(struct lan966x *lan966x)
 	}
 }
 
+static void lan966x_fdma_stop_netdev(struct lan966x *lan966x)
+{
+	struct lan966x_port *port;
+	int i;
+
+	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		port = lan966x->ports[i];
+		if (!port)
+			continue;
+
+		netif_stop_queue(port->dev);
+	}
+}
+
 static void lan966x_fdma_tx_clear_buf(struct lan966x *lan966x, int weight)
 {
 	struct lan966x_tx *tx = &lan966x->tx;
@@ -644,6 +658,126 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev)
 	return err;
 }
 
+static int lan966x_fdma_get_max_mtu(struct lan966x *lan966x)
+{
+	int max_mtu = 0;
+	int i;
+
+	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		int mtu;
+
+		if (!lan966x->ports[i])
+			continue;
+
+		mtu = lan966x->ports[i]->dev->mtu;
+		if (mtu > max_mtu)
+			max_mtu = mtu;
+	}
+
+	return max_mtu;
+}
+
+static int lan966x_qsys_sw_status(struct lan966x *lan966x)
+{
+	return lan_rd(lan966x, QSYS_SW_STATUS(CPU_PORT));
+}
+
+static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
+{
+	void *rx_dcbs, *tx_dcbs, *tx_dcbs_buf;
+	dma_addr_t rx_dma, tx_dma;
+	u32 size;
+	int err;
+
+	/* Store these for later to free them */
+	rx_dma = lan966x->rx.dma;
+	tx_dma = lan966x->tx.dma;
+	rx_dcbs = lan966x->rx.dcbs;
+	tx_dcbs = lan966x->tx.dcbs;
+	tx_dcbs_buf = lan966x->tx.dcbs_buf;
+
+	napi_synchronize(&lan966x->napi);
+	napi_disable(&lan966x->napi);
+	lan966x_fdma_stop_netdev(lan966x);
+
+	lan966x_fdma_rx_disable(&lan966x->rx);
+	lan966x_fdma_rx_free_pages(&lan966x->rx);
+	lan966x->rx.page_order = round_up(new_mtu, PAGE_SIZE) / PAGE_SIZE - 1;
+	err = lan966x_fdma_rx_alloc(&lan966x->rx);
+	if (err)
+		goto restore;
+	lan966x_fdma_rx_start(&lan966x->rx);
+
+	size = sizeof(struct lan966x_rx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+	dma_free_coherent(lan966x->dev, size, rx_dcbs, rx_dma);
+
+	lan966x_fdma_tx_disable(&lan966x->tx);
+	err = lan966x_fdma_tx_alloc(&lan966x->tx);
+	if (err)
+		goto restore_tx;
+
+	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
+	size = ALIGN(size, PAGE_SIZE);
+	dma_free_coherent(lan966x->dev, size, tx_dcbs, tx_dma);
+
+	kfree(tx_dcbs_buf);
+
+	lan966x_fdma_wakeup_netdev(lan966x);
+	napi_enable(&lan966x->napi);
+
+	return err;
+restore:
+	lan966x->rx.dma = rx_dma;
+	lan966x->tx.dma = tx_dma;
+	lan966x_fdma_rx_start(&lan966x->rx);
+
+restore_tx:
+	lan966x->rx.dcbs = rx_dcbs;
+	lan966x->tx.dcbs = tx_dcbs;
+	lan966x->tx.dcbs_buf = tx_dcbs_buf;
+
+	return err;
+}
+
+int lan966x_fdma_change_mtu(struct lan966x *lan966x)
+{
+	int max_mtu;
+	int err;
+	u32 val;
+
+	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
+	max_mtu += IFH_LEN * sizeof(u32);
+
+	if (round_up(max_mtu, PAGE_SIZE) / PAGE_SIZE - 1 ==
+	    lan966x->rx.page_order)
+		return 0;
+
+	/* Disable the CPU port */
+	lan_rmw(QSYS_SW_PORT_MODE_PORT_ENA_SET(0),
+		QSYS_SW_PORT_MODE_PORT_ENA,
+		lan966x, QSYS_SW_PORT_MODE(CPU_PORT));
+
+	/* Flush the CPU queues */
+	readx_poll_timeout(lan966x_qsys_sw_status, lan966x,
+			   val, !(QSYS_SW_STATUS_EQ_AVAIL_GET(val)),
+			   READL_SLEEP_US, READL_TIMEOUT_US);
+
+	/* Add a sleep in case there are frames between the queues and the CPU
+	 * port
+	 */
+	usleep_range(1000, 2000);
+
+	err = lan966x_fdma_reload(lan966x, max_mtu);
+
+	/* Enable back the CPU port */
+	lan_rmw(QSYS_SW_PORT_MODE_PORT_ENA_SET(1),
+		QSYS_SW_PORT_MODE_PORT_ENA,
+		lan966x,  QSYS_SW_PORT_MODE(CPU_PORT));
+
+	return err;
+}
+
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev)
 {
 	if (lan966x->fdma_ndev)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 5424ea869985..8467ffbdafa9 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -354,12 +354,24 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
+	int old_mtu = dev->mtu;
+	int err;
 
 	lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(new_mtu),
 	       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 	dev->mtu = new_mtu;
 
-	return 0;
+	if (!lan966x->fdma)
+		return 0;
+
+	err = lan966x_fdma_change_mtu(lan966x);
+	if (err) {
+		lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(old_mtu),
+		       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
+		dev->mtu = old_mtu;
+	}
+
+	return err;
 }
 
 static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 1ab20b6ec278..5213263c4e87 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -394,6 +394,7 @@ void lan966x_ptp_txtstamp_release(struct lan966x_port *port,
 irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
+int lan966x_fdma_change_mtu(struct lan966x *lan966x);
 void lan966x_fdma_netdev_init(struct lan966x *lan966x, struct net_device *dev);
 void lan966x_fdma_netdev_deinit(struct lan966x *lan966x, struct net_device *dev);
 int lan966x_fdma_init(struct lan966x *lan966x);
-- 
2.33.0

