Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D0170BA6
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 23:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbfGVVkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 17:40:46 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40928 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732817AbfGVVkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 17:40:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so17987899pfp.7
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 14:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=aWEaMOpt8gGMcXsrFW0CmnDwMApm4GC1AN6t1GaHqeA=;
        b=lKTEcn3dlxcPqSnBxF7znqPdMD+iEOv+rGpOmzqhkKUiiLMggMs8ECedBcLD12TvIt
         OuTjZaWf4V0nsAlhnLcxTBWSre5PlHiadWpd6zEitJjyvjwo73ofsgH/cijY/dpVcwoQ
         hvbIrSy/yefCsV9yhnLLvMkVK52GIZygH4Qm1igapldYXAUK43swk+yIEKBS4yCuHbH9
         s+P1ed7JRxcgGGosn/qbEnypr+mX/AEkfoZt3BP1GZSXM8r5VluY3qIqxtlkDdsuTGIY
         hzMcIsjjOEEaxtNJIRGOgqTtUIYlSkeCAsC39LiLY6K094FKvESLTENQQ72P5p0EokJE
         zBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=aWEaMOpt8gGMcXsrFW0CmnDwMApm4GC1AN6t1GaHqeA=;
        b=oF55tSEbHGeeUTliaYKJj3tvaTu1hXoLPgyzOhuaLYvDsnxpqEh1Q+dCrhND9Z4LBm
         RcLfZ6n1TJNsh2XX5FDHaMmayMANzCsYCChk2uxGp0RvNdtByBRZcP27DGsjwWGSGYe+
         KJEzcfRuAh++oog1JtG+NnrFIHDCIDNIxD6/+yfhs0ekS9zYRGkf+BcNXGfZkJ1ewUyj
         xXIXC3eMAMxYwplRQOw41AgtZgbVZdNiv2MG9giFw8XjapFm2HtpXaQ3VYoQBKU6Zsm/
         yWMmbRUq71JSrg7iQaR/dZdQoKv48xcDCEnWmGhY546lMLEcbSeaDoKo374ATitjEqn9
         SPew==
X-Gm-Message-State: APjAAAUxu4iXoNo9rwh0UeHQdhUI7rprmuqGdZroDwKn7p4ibyk/crM9
        GkojQPJCJibuY+htCfYyjcdU/w==
X-Google-Smtp-Source: APXvYqwsB8/+q6FdcYc65XWb4gvnJ89cUcSGLLXuNICaze5vPkEe4E23EZyhtbsdo5WAAXl8Rlm5ew==
X-Received: by 2002:a63:5860:: with SMTP id i32mr45694325pgm.124.1563831642382;
        Mon, 22 Jul 2019 14:40:42 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p65sm40593714pfp.58.2019.07.22.14.40.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 14:40:41 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v4 net-next 13/19] ionic: Add initial ethtool support
Date:   Mon, 22 Jul 2019 14:40:17 -0700
Message-Id: <20190722214023.9513-14-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190722214023.9513-1-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the basic ethtool callbacks for device information
and control.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   3 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 495 ++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |   9 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   2 +
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   8 +
 6 files changed, 518 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 7d9cdc5f02a1..9b19bf57a489 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -3,5 +3,5 @@
 
 obj-$(CONFIG_IONIC) := ionic.o
 
-ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o \
+ionic-y := ionic_main.o ionic_bus_pci.o ionic_dev.o ionic_ethtool.o \
 	   ionic_lif.o ionic_rx_filter.o ionic_debugfs.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 523927566925..bacc9c557329 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -12,6 +12,9 @@
 
 #define IONIC_MIN_MTU			ETH_MIN_MTU
 #define IONIC_MAX_MTU			9194
+#define IONIC_MAX_TXRX_DESC		16384
+#define IONIC_MIN_TXRX_DESC		16
+#define IONIC_DEF_TXRX_DESC		4096
 #define IONIC_LIFS_MAX			1024
 
 struct ionic_dev_bar {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
new file mode 100644
index 000000000000..f7899be547c3
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -0,0 +1,495 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/netdevice.h>
+
+#include "ionic.h"
+#include "ionic_bus.h"
+#include "ionic_lif.h"
+#include "ionic_ethtool.h"
+
+static void ionic_get_drvinfo(struct net_device *netdev,
+			      struct ethtool_drvinfo *drvinfo)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	struct ionic_dev *idev = &ionic->idev;
+
+	strlcpy(drvinfo->driver, DRV_NAME, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->version, DRV_VERSION, sizeof(drvinfo->version));
+	strlcpy(drvinfo->fw_version, idev->dev_info.fw_version,
+		sizeof(drvinfo->fw_version));
+	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
+		sizeof(drvinfo->bus_info));
+}
+
+#define DEV_CMD_REG_VERSION 1
+#define DEV_INFO_REG_COUNT  32
+#define DEV_CMD_REG_COUNT   32
+static int ionic_get_regs_len(struct net_device *netdev)
+{
+	return (DEV_INFO_REG_COUNT + DEV_CMD_REG_COUNT) * sizeof(u32);
+}
+
+static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
+			   void *p)
+{
+	struct lif *lif = netdev_priv(netdev);
+	unsigned int size;
+
+	regs->version = DEV_CMD_REG_VERSION;
+
+	size = DEV_INFO_REG_COUNT * sizeof(u32);
+	memcpy_fromio(p, lif->ionic->idev.dev_info_regs->words, size);
+
+	size = DEV_CMD_REG_COUNT * sizeof(u32);
+	memcpy_fromio(p, lif->ionic->idev.dev_cmd_regs->words, size);
+}
+
+static int ionic_get_link_ksettings(struct net_device *netdev,
+				    struct ethtool_link_ksettings *ks)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev = &lif->ionic->idev;
+	int copper_seen = 0;
+
+	ethtool_link_ksettings_zero_link_mode(ks, supported);
+
+	/* The port_info data is found in a DMA space that the NIC keeps
+	 * up-to-date, so there's no need to request the data from the
+	 * NIC, we already have it in our memory space.
+	 */
+
+	switch (le16_to_cpu(idev->port_info->status.xcvr.pid)) {
+		/* Copper */
+	case XCVR_PID_QSFP_100G_CR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseCR4_Full);
+		copper_seen++;
+		break;
+	case XCVR_PID_QSFP_40GBASE_CR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     40000baseCR4_Full);
+		copper_seen++;
+		break;
+	case XCVR_PID_SFP_25GBASE_CR_S:
+	case XCVR_PID_SFP_25GBASE_CR_L:
+	case XCVR_PID_SFP_25GBASE_CR_N:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     25000baseCR_Full);
+		copper_seen++;
+		break;
+	case XCVR_PID_SFP_10GBASE_AOC:
+	case XCVR_PID_SFP_10GBASE_CU:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseCR_Full);
+		copper_seen++;
+		break;
+
+		/* Fibre */
+	case XCVR_PID_QSFP_100G_SR4:
+	case XCVR_PID_QSFP_100G_AOC:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseSR4_Full);
+		break;
+	case XCVR_PID_QSFP_100G_LR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseLR4_ER4_Full);
+		break;
+	case XCVR_PID_QSFP_100G_ER4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseLR4_ER4_Full);
+		break;
+	case XCVR_PID_QSFP_40GBASE_SR4:
+	case XCVR_PID_QSFP_40GBASE_AOC:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     40000baseSR4_Full);
+		break;
+	case XCVR_PID_QSFP_40GBASE_LR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     40000baseLR4_Full);
+		break;
+	case XCVR_PID_SFP_25GBASE_SR:
+	case XCVR_PID_SFP_25GBASE_AOC:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     25000baseSR_Full);
+		break;
+	case XCVR_PID_SFP_10GBASE_SR:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseSR_Full);
+		break;
+	case XCVR_PID_SFP_10GBASE_LR:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseLR_Full);
+		break;
+	case XCVR_PID_SFP_10GBASE_LRM:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseLRM_Full);
+		break;
+	case XCVR_PID_SFP_10GBASE_ER:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseER_Full);
+		break;
+	case XCVR_PID_UNKNOWN:
+		break;
+	default:
+		dev_info(lif->ionic->dev, "unknown xcvr type pid=%d / 0x%x\n",
+			 idev->port_info->status.xcvr.pid,
+			 idev->port_info->status.xcvr.pid);
+		break;
+	}
+	ethtool_link_ksettings_add_link_mode(ks, supported, FIBRE);
+
+	if (ionic_is_pf(lif->ionic))
+		ethtool_link_ksettings_add_link_mode(ks, supported, Autoneg);
+
+	bitmap_copy(ks->link_modes.advertising, ks->link_modes.supported,
+		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_NONE);
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
+
+	if (idev->port_info->config.fec_type == PORT_FEC_TYPE_FC)
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_BASER);
+	else if (idev->port_info->config.fec_type == PORT_FEC_TYPE_RS)
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
+	else if (idev->port_info->config.fec_type == PORT_FEC_TYPE_NONE)
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_NONE);
+
+	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
+	if (idev->port_info->config.pause_type)
+		ethtool_link_ksettings_add_link_mode(ks, advertising, Pause);
+
+	if (idev->port_info->status.xcvr.phy == PHY_TYPE_COPPER ||
+	    copper_seen) {
+		ks->base.port = PORT_DA;
+	} else if (idev->port_info->status.xcvr.phy == PHY_TYPE_FIBER) {
+		ks->base.port = PORT_FIBRE;
+	} else {
+		ks->base.port = PORT_OTHER;
+	}
+
+	ks->base.speed = le32_to_cpu(lif->info->status.link_speed);
+
+	if (idev->port_info->config.an_enable)
+		ks->base.autoneg = AUTONEG_ENABLE;
+
+	if (le16_to_cpu(lif->info->status.link_status))
+		ks->base.duplex = DUPLEX_FULL;
+	else
+		ks->base.duplex = DUPLEX_UNKNOWN;
+
+	return 0;
+}
+
+static int ionic_set_link_ksettings(struct net_device *netdev,
+				    const struct ethtool_link_ksettings *ks)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	struct ionic_dev *idev = &lif->ionic->idev;
+	u8 fec_type = PORT_FEC_TYPE_NONE;
+	u32 req_rs, req_fc;
+	int err = 0;
+
+	/* set autoneg */
+	if (ks->base.autoneg != idev->port_info->config.an_enable) {
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_port_autoneg(idev, ks->base.autoneg);
+		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+		mutex_unlock(&ionic->dev_cmd_lock);
+		if (err)
+			return err;
+	}
+
+	/* set speed */
+	if (ks->base.speed != le32_to_cpu(idev->port_info->config.speed)) {
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_port_speed(idev, ks->base.speed);
+		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+		mutex_unlock(&ionic->dev_cmd_lock);
+		if (err)
+			return err;
+	}
+
+	/* set FEC */
+	req_rs = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_RS);
+	req_fc = ethtool_link_ksettings_test_link_mode(ks, advertising, FEC_BASER);
+	if (req_rs && req_fc) {
+		netdev_info(netdev, "Only select one FEC mode at a time\n");
+		return -EINVAL;
+	} else if (req_fc &&
+		   idev->port_info->config.fec_type != PORT_FEC_TYPE_FC) {
+		fec_type = PORT_FEC_TYPE_FC;
+	} else if (req_rs &&
+		   idev->port_info->config.fec_type != PORT_FEC_TYPE_RS) {
+		fec_type = PORT_FEC_TYPE_RS;
+	} else if (!(req_rs | req_fc) &&
+		   idev->port_info->config.fec_type != PORT_FEC_TYPE_NONE) {
+		fec_type = PORT_FEC_TYPE_NONE;
+	}
+
+	if (fec_type != idev->port_info->config.fec_type) {
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_port_fec(idev, fec_type);
+		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+		mutex_unlock(&ionic->dev_cmd_lock);
+		if (err)
+			return err;
+
+		idev->port_info->config.fec_type = fec_type;
+	}
+
+	return 0;
+}
+
+static void ionic_get_pauseparam(struct net_device *netdev,
+				 struct ethtool_pauseparam *pause)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev = &lif->ionic->idev;
+	uint8_t pause_type = idev->port_info->config.pause_type;
+
+	pause->autoneg = 0;
+
+	if (pause_type) {
+		pause->rx_pause = pause_type & IONIC_PAUSE_F_RX ? 1 : 0;
+		pause->tx_pause = pause_type & IONIC_PAUSE_F_TX ? 1 : 0;
+	}
+}
+
+static int ionic_set_pauseparam(struct net_device *netdev,
+				struct ethtool_pauseparam *pause)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	struct ionic_dev *idev = &lif->ionic->idev;
+	u32 requested_pause;
+	int err;
+
+	if (pause->autoneg == AUTONEG_ENABLE) {
+		netdev_info(netdev, "Please use 'ethtool -s ...' to change autoneg\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* change both at the same time */
+	requested_pause = PORT_PAUSE_TYPE_LINK;
+	if (pause->rx_pause)
+		requested_pause |= IONIC_PAUSE_F_RX;
+	if (pause->tx_pause)
+		requested_pause |= IONIC_PAUSE_F_TX;
+
+	if (requested_pause == idev->port_info->config.pause_type)
+		return 0;
+
+	idev->port_info->config.pause_type = requested_pause;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_port_pause(idev, requested_pause);
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+	mutex_unlock(&ionic->dev_cmd_lock);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int ionic_get_coalesce(struct net_device *netdev,
+			      struct ethtool_coalesce *coalesce)
+{
+	struct lif *lif = netdev_priv(netdev);
+
+	coalesce->tx_coalesce_usecs = lif->tx_coalesce_usecs;
+	coalesce->rx_coalesce_usecs = lif->rx_coalesce_usecs;
+
+	return 0;
+}
+
+static void ionic_get_ringparam(struct net_device *netdev,
+				struct ethtool_ringparam *ring)
+{
+	struct lif *lif = netdev_priv(netdev);
+
+	ring->tx_max_pending = IONIC_MAX_TXRX_DESC;
+	ring->tx_pending = lif->ntxq_descs;
+	ring->rx_max_pending = IONIC_MAX_TXRX_DESC;
+	ring->rx_pending = lif->nrxq_descs;
+}
+
+static int ionic_set_ringparam(struct net_device *netdev,
+			       struct ethtool_ringparam *ring)
+{
+	struct lif *lif = netdev_priv(netdev);
+	bool running;
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending) {
+		netdev_info(netdev, "Changing jumbo or mini descriptors not supported\n");
+		return -EINVAL;
+	}
+
+	if (!is_power_of_2(ring->tx_pending) ||
+	    !is_power_of_2(ring->rx_pending)) {
+		netdev_info(netdev, "Descriptor count must be a power of 2\n");
+		return -EINVAL;
+	}
+
+	/* if nothing to do return success */
+	if (ring->tx_pending == lif->ntxq_descs &&
+	    ring->rx_pending == lif->nrxq_descs)
+		return 0;
+
+	while (test_and_set_bit(LIF_QUEUE_RESET, lif->state))
+		usleep_range(200, 400);
+
+	running = test_bit(LIF_UP, lif->state);
+	if (running)
+		ionic_stop(netdev);
+
+	lif->ntxq_descs = ring->tx_pending;
+	lif->nrxq_descs = ring->rx_pending;
+
+	if (running)
+		ionic_open(netdev);
+	clear_bit(LIF_QUEUE_RESET, lif->state);
+
+	return 0;
+}
+
+static void ionic_get_channels(struct net_device *netdev,
+			       struct ethtool_channels *ch)
+{
+	struct lif *lif = netdev_priv(netdev);
+
+	/* report maximum channels */
+	ch->max_combined = lif->ionic->ntxqs_per_lif;
+
+	/* report current channels */
+	ch->combined_count = lif->nxqs;
+}
+
+static int ionic_set_channels(struct net_device *netdev,
+			      struct ethtool_channels *ch)
+{
+	struct lif *lif = netdev_priv(netdev);
+	bool running;
+
+	if (!ch->combined_count || ch->other_count ||
+	    ch->rx_count || ch->tx_count)
+		return -EINVAL;
+
+	if (ch->combined_count == lif->nxqs)
+		return 0;
+
+	while (test_and_set_bit(LIF_QUEUE_RESET, lif->state))
+		usleep_range(200, 400);
+
+	running = test_bit(LIF_UP, lif->state);
+	if (running)
+		ionic_stop(netdev);
+
+	lif->nxqs = ch->combined_count;
+
+	if (running)
+		ionic_open(netdev);
+	clear_bit(LIF_QUEUE_RESET, lif->state);
+
+	return 0;
+}
+
+static int ionic_get_module_info(struct net_device *netdev,
+				 struct ethtool_modinfo *modinfo)
+
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct xcvr_status *xcvr;
+
+	xcvr = &idev->port_info->status.xcvr;
+
+	/* report the module data type and length */
+	switch (xcvr->sprom[0]) {
+	case 0x03: /* SFP */
+		modinfo->type = ETH_MODULE_SFF_8079;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
+		break;
+	case 0x0D: /* QSFP */
+	case 0x11: /* QSFP28 */
+		modinfo->type = ETH_MODULE_SFF_8436;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8436_LEN;
+		break;
+	default:
+		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
+			    xcvr->sprom[0]);
+		break;
+	}
+
+	return 0;
+}
+
+static int ionic_get_module_eeprom(struct net_device *netdev,
+				   struct ethtool_eeprom *ee,
+				   u8 *data)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct xcvr_status *xcvr;
+	u32 len;
+
+	/* The NIC keeps the module prom up-to-date in the DMA space
+	 * so we can simply copy the module bytes into the data buffer.
+	 */
+	xcvr = &idev->port_info->status.xcvr;
+	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
+	memcpy(data, xcvr->sprom, len);
+
+	return 0;
+}
+
+static int ionic_nway_reset(struct net_device *netdev)
+{
+	struct lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	int err = 0;
+
+	/* flap the link to force auto-negotiation */
+
+	mutex_lock(&ionic->dev_cmd_lock);
+
+	ionic_dev_cmd_port_state(&ionic->idev, PORT_ADMIN_STATE_DOWN);
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+
+	if (!err) {
+		ionic_dev_cmd_port_state(&ionic->idev, PORT_ADMIN_STATE_UP);
+		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+	}
+
+	mutex_unlock(&ionic->dev_cmd_lock);
+
+	return err;
+}
+
+static const struct ethtool_ops ionic_ethtool_ops = {
+	.get_drvinfo		= ionic_get_drvinfo,
+	.get_regs_len		= ionic_get_regs_len,
+	.get_regs		= ionic_get_regs,
+	.get_link		= ethtool_op_get_link,
+	.get_link_ksettings	= ionic_get_link_ksettings,
+	.get_coalesce		= ionic_get_coalesce,
+	.get_ringparam		= ionic_get_ringparam,
+	.set_ringparam		= ionic_set_ringparam,
+	.get_channels		= ionic_get_channels,
+	.set_channels		= ionic_set_channels,
+	.get_module_info	= ionic_get_module_info,
+	.get_module_eeprom	= ionic_get_module_eeprom,
+	.get_pauseparam		= ionic_get_pauseparam,
+	.set_pauseparam		= ionic_set_pauseparam,
+	.set_link_ksettings	= ionic_set_link_ksettings,
+	.nway_reset		= ionic_nway_reset,
+};
+
+void ionic_ethtool_set_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &ionic_ethtool_ops;
+}
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.h b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
new file mode 100644
index 000000000000..38b91b1d70ae
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
+
+#ifndef _IONIC_ETHTOOL_H_
+#define _IONIC_ETHTOOL_H_
+
+void ionic_ethtool_set_ops(struct net_device *netdev);
+
+#endif /* _IONIC_ETHTOOL_H_ */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f52af9cb6264..2bd8ce61c4a0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -10,6 +10,7 @@
 #include "ionic.h"
 #include "ionic_bus.h"
 #include "ionic_lif.h"
+#include "ionic_ethtool.h"
 #include "ionic_debugfs.h"
 
 static void ionic_lif_rx_mode(struct lif *lif, unsigned int rx_mode);
@@ -980,6 +981,7 @@ static struct lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 	lif->netdev = netdev;
 	ionic->master_lif = lif;
 	netdev->netdev_ops = &ionic_netdev_ops;
+	ionic_ethtool_set_ops(netdev);
 
 	netdev->watchdog_timeo = 2 * HZ;
 	netdev->min_mtu = IONIC_MIN_MTU;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 9930b9390c8a..d8589a306aa5 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -111,6 +111,8 @@ struct lif {
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
+	unsigned int ntxq_descs;
+	unsigned int nrxq_descs;
 	unsigned int rx_mode;
 	u64 hw_features;
 	bool mc_overflow;
@@ -124,6 +126,8 @@ struct lif {
 
 	struct rx_filters rx_filters;
 	struct ionic_deferred deferred;
+	u32 tx_coalesce_usecs;
+	u32 rx_coalesce_usecs;
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 	struct dentry *dentry;
@@ -165,6 +169,10 @@ int ionic_lif_identify(struct ionic *ionic, u8 lif_type,
 		       union lif_identity *lif_ident);
 int ionic_lifs_size(struct ionic *ionic);
 
+int ionic_open(struct net_device *netdev);
+int ionic_stop(struct net_device *netdev);
+int ionic_reset_queues(struct lif *lif);
+
 static inline void debug_stats_napi_poll(struct qcq *qcq,
 					 unsigned int work_done)
 {
-- 
2.17.1

