Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2C43DF36C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbhHCRBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237531AbhHCQ5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:57:33 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8FFC06179C
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 09:56:01 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id p21so29835109edi.9
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 09:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xQD7Al/xWqy/c7eSkcmEaAiTTWdgKPQlL8d5Y2SFKFc=;
        b=rOUEbCXW2tt8czoc7gvHIXvxU4H+tmBOcNSwpnJ4jyGxu+vbSXUhCsUNyj7M69EA2d
         O1onMpRQ7zNuFgZS7a3i/E6vx1EP96UoskQtSIkZZZ+Yyf1qEIV0Z53z3bT2UcqerAAn
         ThA38o6QAt2zpClJiP1+EeR9mjjf//qHgsAbfJrncl9gTaKsK0UXyZmPHIcJr4oA+W+v
         H1R/Ua/2fTf1YDDkGUP2PtLHXuWPE9wNgvpv/WJn0jKUkAZ7s9/731o000j08VG2Uf8R
         8npXdOcXwG/5A7gA8nCdMu+Cb/CONvYZV8zvU3mFKGsrQvWw+I0eUrh2qWb3wr+emVAo
         rhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xQD7Al/xWqy/c7eSkcmEaAiTTWdgKPQlL8d5Y2SFKFc=;
        b=Pc+XfOE+fcxdJTuq3Hw4oGGvosTsMnE0N2/YgNJTpxlyLRrzaEQvG0ZKEFkkKBq+vE
         o5mkIZ/+ZCaCGHSR1QuXT7r2L8PRaFTxoJJna8GGC8ktqgT+yNvH4HtNfqGZ992LZ/53
         LR/jJRsv5f5gpmWNP176eGQDSIh3tEBcqNIbxZEB76PxISXTvCO5gaQJOq5Lb8z2HiP5
         OWc3SWIYB61rQaN6euYKDY0M+cqP2+VTo3P6vB0DluYnRPkl8xGA2jmGFkc5zfI7Irpp
         2pkqoL2kdjYERYmUyDirbLtgSL0fQpRjgFsHCAbHzB3N9hcACv6+MR9p3wJrn15dazSQ
         XUZA==
X-Gm-Message-State: AOAM530CxORUdTIbZRKW4SEyTEO4/20sN2kdhN6GsTY/+ZUbwTP4Fmo1
        4qFhQGFaz4d2kJGfA5kJSj0=
X-Google-Smtp-Source: ABdhPJypLO8OSOwQq0BCyCfHClvY2YxDsowQstu1p7nkUvxyjsWLzmESYLnXtq6Xy/+6vYVK8zlGMA==
X-Received: by 2002:aa7:c6d3:: with SMTP id b19mr26268314eds.303.1628009759614;
        Tue, 03 Aug 2021 09:55:59 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id e7sm8754630edk.3.2021.08.03.09.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:55:59 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     laurentiu.tudor@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 6/8] dpaa2-switch: integrate the MAC endpoint support
Date:   Tue,  3 Aug 2021 19:57:43 +0300
Message-Id: <20210803165745.138175-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803165745.138175-1-ciorneiioana@gmail.com>
References: <20210803165745.138175-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Integrate the common MAC endpoint management support into the
dpaa2-switch driver as well. Nothing special happens here, just that the
already available dpaa2-mac functions are also called from dpaa2-switch.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../freescale/dpaa2/dpaa2-switch-ethtool.c    |   8 ++
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 104 +++++++++++++++++-
 .../ethernet/freescale/dpaa2/dpaa2-switch.h   |  18 +++
 drivers/net/ethernet/freescale/dpaa2/dpsw.h   |   5 +
 5 files changed, 130 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index c2ef74052ef8..3d9842af7f10 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -11,7 +11,7 @@ fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpa
 fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
-fsl-dpaa2-switch-objs	:= dpaa2-switch.o dpaa2-switch-ethtool.o dpsw.o dpaa2-switch-flower.o
+fsl-dpaa2-switch-objs	:= dpaa2-switch.o dpaa2-switch-ethtool.o dpsw.o dpaa2-switch-flower.o dpaa2-mac.o dpmac.o
 
 # Needed by the tracing framework
 CFLAGS_dpaa2-eth.o := -I$(src)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
index 70e04321c420..5a460dcc6f4e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c
@@ -62,6 +62,10 @@ dpaa2_switch_get_link_ksettings(struct net_device *netdev,
 	struct dpsw_link_state state = {0};
 	int err = 0;
 
+	if (dpaa2_switch_port_is_type_phy(port_priv))
+		return phylink_ethtool_ksettings_get(port_priv->mac->phylink,
+						     link_ksettings);
+
 	err = dpsw_if_get_link_state(port_priv->ethsw_data->mc_io, 0,
 				     port_priv->ethsw_data->dpsw_handle,
 				     port_priv->idx,
@@ -95,6 +99,10 @@ dpaa2_switch_set_link_ksettings(struct net_device *netdev,
 	bool if_running;
 	int err = 0, ret;
 
+	if (dpaa2_switch_port_is_type_phy(port_priv))
+		return phylink_ethtool_ksettings_set(port_priv->mac->phylink,
+						     link_ksettings);
+
 	/* Interface needs to be down to change link settings */
 	if_running = netif_running(netdev);
 	if (if_running) {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index aad7f9abfa93..d260993ab2dc 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -600,6 +600,12 @@ static int dpaa2_switch_port_link_state_update(struct net_device *netdev)
 	struct dpsw_link_state state;
 	int err;
 
+	/* When we manage the MAC/PHY using phylink there is no need
+	 * to manually update the netif_carrier.
+	 */
+	if (dpaa2_switch_port_is_type_phy(port_priv))
+		return 0;
+
 	/* Interrupts are received even though no one issued an 'ifconfig up'
 	 * on the switch interface. Ignore these link state update interrupts
 	 */
@@ -677,12 +683,14 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
-	/* Explicitly set carrier off, otherwise
-	 * netif_carrier_ok() will return true and cause 'ip link show'
-	 * to report the LOWER_UP flag, even though the link
-	 * notification wasn't even received.
-	 */
-	netif_carrier_off(netdev);
+	if (!dpaa2_switch_port_is_type_phy(port_priv)) {
+		/* Explicitly set carrier off, otherwise
+		 * netif_carrier_ok() will return true and cause 'ip link show'
+		 * to report the LOWER_UP flag, even though the link
+		 * notification wasn't even received.
+		 */
+		netif_carrier_off(netdev);
+	}
 
 	err = dpsw_if_enable(port_priv->ethsw_data->mc_io, 0,
 			     port_priv->ethsw_data->dpsw_handle,
@@ -694,6 +702,9 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 
 	dpaa2_switch_enable_ctrl_if_napi(ethsw);
 
+	if (dpaa2_switch_port_is_type_phy(port_priv))
+		phylink_start(port_priv->mac->phylink);
+
 	return 0;
 }
 
@@ -703,6 +714,13 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 	struct ethsw_core *ethsw = port_priv->ethsw_data;
 	int err;
 
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+		phylink_stop(port_priv->mac->phylink);
+	} else {
+		netif_tx_stop_all_queues(netdev);
+		netif_carrier_off(netdev);
+	}
+
 	err = dpsw_if_disable(port_priv->ethsw_data->mc_io, 0,
 			      port_priv->ethsw_data->dpsw_handle,
 			      port_priv->idx);
@@ -1405,6 +1423,67 @@ bool dpaa2_switch_port_dev_check(const struct net_device *netdev)
 	return netdev->netdev_ops == &dpaa2_switch_port_ops;
 }
 
+static int dpaa2_switch_port_connect_mac(struct ethsw_port_priv *port_priv)
+{
+	struct fsl_mc_device *dpsw_port_dev, *dpmac_dev;
+	struct dpaa2_mac *mac;
+	int err;
+
+	dpsw_port_dev = to_fsl_mc_device(port_priv->netdev->dev.parent);
+	dpmac_dev = fsl_mc_get_endpoint(dpsw_port_dev, port_priv->idx);
+
+	if (PTR_ERR(dpmac_dev) == -EPROBE_DEFER)
+		return PTR_ERR(dpmac_dev);
+
+	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+		return 0;
+
+	mac = kzalloc(sizeof(*mac), GFP_KERNEL);
+	if (!mac)
+		return -ENOMEM;
+
+	mac->mc_dev = dpmac_dev;
+	mac->mc_io = port_priv->ethsw_data->mc_io;
+	mac->net_dev = port_priv->netdev;
+
+	err = dpaa2_mac_open(mac);
+	if (err)
+		goto err_free_mac;
+	port_priv->mac = mac;
+
+	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+		err = dpaa2_mac_connect(mac);
+		if (err) {
+			netdev_err(port_priv->netdev,
+				   "Error connecting to the MAC endpoint %pe\n",
+				   ERR_PTR(err));
+			goto err_close_mac;
+		}
+	}
+
+	return 0;
+
+err_close_mac:
+	dpaa2_mac_close(mac);
+	port_priv->mac = NULL;
+err_free_mac:
+	kfree(mac);
+	return err;
+}
+
+static void dpaa2_switch_port_disconnect_mac(struct ethsw_port_priv *port_priv)
+{
+	if (dpaa2_switch_port_is_type_phy(port_priv))
+		dpaa2_mac_disconnect(port_priv->mac);
+
+	if (!dpaa2_switch_port_has_mac(port_priv))
+		return;
+
+	dpaa2_mac_close(port_priv->mac);
+	kfree(port_priv->mac);
+	port_priv->mac = NULL;
+}
+
 static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 {
 	struct device *dev = (struct device *)arg;
@@ -1427,6 +1506,14 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 		dpaa2_switch_port_link_state_update(port_priv->netdev);
 		dpaa2_switch_port_set_mac_addr(port_priv);
 	}
+
+	if (status & DPSW_IRQ_EVENT_ENDPOINT_CHANGED) {
+		if (dpaa2_switch_port_has_mac(port_priv))
+			dpaa2_switch_port_disconnect_mac(port_priv);
+		else
+			dpaa2_switch_port_connect_mac(port_priv);
+	}
+
 out:
 	err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    DPSW_IRQ_INDEX_IF, status);
@@ -3112,6 +3199,7 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
 		port_priv = ethsw->ports[i];
 		unregister_netdev(port_priv->netdev);
+		dpaa2_switch_port_disconnect_mac(port_priv);
 		free_netdev(port_priv->netdev);
 	}
 
@@ -3191,6 +3279,10 @@ static int dpaa2_switch_probe_port(struct ethsw_core *ethsw,
 		goto err_port_probe;
 	port_priv->learn_ena = false;
 
+	err = dpaa2_switch_port_connect_mac(port_priv);
+	if (err)
+		goto err_port_probe;
+
 	return 0;
 
 err_port_probe:
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
index f69d940f3c5b..0002dca4d417 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
@@ -21,6 +21,7 @@
 #include <net/pkt_cls.h>
 #include <soc/fsl/dpaa2-io.h>
 
+#include "dpaa2-mac.h"
 #include "dpsw.h"
 
 /* Number of IRQs supported */
@@ -159,6 +160,7 @@ struct ethsw_port_priv {
 	bool			learn_ena;
 
 	struct dpaa2_switch_filter_block *filter_block;
+	struct dpaa2_mac	*mac;
 };
 
 /* Switch data */
@@ -225,6 +227,22 @@ static inline bool dpaa2_switch_supports_cpu_traffic(struct ethsw_core *ethsw)
 	return true;
 }
 
+static inline bool
+dpaa2_switch_port_is_type_phy(struct ethsw_port_priv *port_priv)
+{
+	if (port_priv->mac &&
+	    (port_priv->mac->attr.link_type == DPMAC_LINK_TYPE_PHY ||
+	     port_priv->mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE))
+		return true;
+
+	return false;
+}
+
+static inline bool dpaa2_switch_port_has_mac(struct ethsw_port_priv *port_priv)
+{
+	return port_priv->mac ? true : false;
+}
+
 bool dpaa2_switch_port_dev_check(const struct net_device *netdev);
 
 int dpaa2_switch_port_vlans_add(struct net_device *netdev,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpsw.h b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
index 892df905b876..b90bd363f47a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpsw.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpsw.h
@@ -98,6 +98,11 @@ int dpsw_reset(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token);
  */
 #define DPSW_IRQ_EVENT_LINK_CHANGED	0x0001
 
+/**
+ * DPSW_IRQ_EVENT_ENDPOINT_CHANGED - Indicates a change in endpoint
+ */
+#define DPSW_IRQ_EVENT_ENDPOINT_CHANGED	0x0002
+
 /**
  * struct dpsw_irq_cfg - IRQ configuration
  * @addr:	Address that must be written to signal a message-based interrupt
-- 
2.31.1

