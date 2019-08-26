Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09459D884
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfHZVeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:34:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36277 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729216AbfHZVeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:34:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id w2so12641188pfi.3
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=+lor9f4fO/M2Zbtoq/dLI2pDcTosRi3TlEwVxEuDlwk=;
        b=kxVnIV6AAa7fR1ibohO6swtVGua1ZqU4DgQnxr2TbwYY4Swd3vwaqJXWLyyOWPy4ZL
         sCoPeFQaXsMIAbL/DQ+ZvEaDOWoZ/tt0Qppgx3kbYEhVPygU8xflYl0PYyGYrzR7zjV8
         h6cflUkv75rUkkoCr98tXwwsQ+9Uo+vmNNeelIXhgp3aEdR5ZT580C0aQ/kRIuTNRy54
         0eImPXelcWqpJKfEIBEZvHdr2NaLB4Q26hdyQIEBli8eYG7kD6NU6gcJWRSu0T/Am66D
         yBtTv6e7tjEDN4gbxSLzDACRjA65fnFxSXIhnasisNrj50WlPzV7KUZp+QBFhFYTGTiW
         fjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=+lor9f4fO/M2Zbtoq/dLI2pDcTosRi3TlEwVxEuDlwk=;
        b=kLtOgSGnFJ66b0z5wAPVWI7iUpo7rcuLmMPpaTFBCzV12gJpTtieo/icYejEY9SqXX
         gIkkN3eUCFEBUUUx7Drd6/OGjijrMqG9NN1bZbpkTwDVJxJ7VIOqmGSoVLEdZ7z/EJp3
         qrijF9hY30Uc4W2Fsfx3iq575SwvWcHBkwresS5jcgfp8lff1XTEEnANX9CKE4cDvQSI
         i8iLYLiPmc8uG81GIKPuH/dbrfRiGKMIgd0WrcuuvDNRuRe6COJYMGjfdxkQtMfsWUqC
         9FI3ojRKzBNXNNPos0+4ukQI/A/dykzF5xvhRINLZr/h4/gUKFcaYOxqy9qGz27d7TGq
         9XZQ==
X-Gm-Message-State: APjAAAVKcZqN1l8CCbH5YsxqUTN2yg/HpKJETK7hlOLwnwRUw4JEd01Q
        VyuHSmZmIIaFmUDzbsMZD4js9w==
X-Google-Smtp-Source: APXvYqw62D5FhXxU5NzkctCkCj4N+SrezCVxHL9eyOAUwaETftbo920467ZZLNsPu4fuwZXrG9QMkg==
X-Received: by 2002:a17:90a:35e3:: with SMTP id r90mr22431435pjb.34.1566855243880;
        Mon, 26 Aug 2019 14:34:03 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j9sm5876905pfi.128.2019.08.26.14.34.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 14:34:03 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH v5 net-next 13/18] ionic: Add initial ethtool support
Date:   Mon, 26 Aug 2019 14:33:34 -0700
Message-Id: <20190826213339.56909-14-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190826213339.56909-1-snelson@pensando.io>
References: <20190826213339.56909-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add in the basic ethtool callbacks for device information
and control.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   |   7 +
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 498 ++++++++++++++++++
 .../ethernet/pensando/ionic/ionic_ethtool.h   |   9 +
 .../net/ethernet/pensando/ionic/ionic_lif.c   |   2 +
 .../net/ethernet/pensando/ionic/ionic_lif.h   |   3 +
 6 files changed, 520 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_ethtool.h

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 8c31a90830cf..a8b85f11cf3c 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -4,4 +4,4 @@
 obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
-	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o
+	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index f6cce42f0228..1db1e433127a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -12,8 +12,15 @@
 
 #define IONIC_MIN_MTU			ETH_MIN_MTU
 #define IONIC_MAX_MTU			9194
+#define IONIC_MAX_TXRX_DESC		16384
+#define IONIC_MIN_TXRX_DESC		16
+#define IONIC_DEF_TXRX_DESC		4096
 #define IONIC_LIFS_MAX			1024
 
+#define IONIC_DEV_CMD_REG_VERSION	1
+#define IONIC_DEV_INFO_REG_COUNT	32
+#define IONIC_DEV_CMD_REG_COUNT		32
+
 struct ionic_dev_bar {
 	void __iomem *vaddr;
 	phys_addr_t bus_addr;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
new file mode 100644
index 000000000000..12fc33f9e248
--- /dev/null
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -0,0 +1,498 @@
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
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+
+	strlcpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->version, IONIC_DRV_VERSION, sizeof(drvinfo->version));
+	strlcpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
+		sizeof(drvinfo->fw_version));
+	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
+		sizeof(drvinfo->bus_info));
+}
+
+static int ionic_get_regs_len(struct net_device *netdev)
+{
+	return (IONIC_DEV_INFO_REG_COUNT + IONIC_DEV_CMD_REG_COUNT) * sizeof(u32);
+}
+
+static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
+			   void *p)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	unsigned int size;
+
+	regs->version = IONIC_DEV_CMD_REG_VERSION;
+
+	size = IONIC_DEV_INFO_REG_COUNT * sizeof(u32);
+	memcpy_fromio(p, lif->ionic->idev.dev_info_regs->words, size);
+
+	size = IONIC_DEV_CMD_REG_COUNT * sizeof(u32);
+	memcpy_fromio(p, lif->ionic->idev.dev_cmd_regs->words, size);
+}
+
+static int ionic_get_link_ksettings(struct net_device *netdev,
+				    struct ethtool_link_ksettings *ks)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
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
+	case IONIC_XCVR_PID_QSFP_100G_CR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseCR4_Full);
+		copper_seen++;
+		break;
+	case IONIC_XCVR_PID_QSFP_40GBASE_CR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     40000baseCR4_Full);
+		copper_seen++;
+		break;
+	case IONIC_XCVR_PID_SFP_25GBASE_CR_S:
+	case IONIC_XCVR_PID_SFP_25GBASE_CR_L:
+	case IONIC_XCVR_PID_SFP_25GBASE_CR_N:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     25000baseCR_Full);
+		copper_seen++;
+		break;
+	case IONIC_XCVR_PID_SFP_10GBASE_AOC:
+	case IONIC_XCVR_PID_SFP_10GBASE_CU:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseCR_Full);
+		copper_seen++;
+		break;
+
+		/* Fibre */
+	case IONIC_XCVR_PID_QSFP_100G_SR4:
+	case IONIC_XCVR_PID_QSFP_100G_AOC:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseSR4_Full);
+		break;
+	case IONIC_XCVR_PID_QSFP_100G_LR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseLR4_ER4_Full);
+		break;
+	case IONIC_XCVR_PID_QSFP_100G_ER4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     100000baseLR4_ER4_Full);
+		break;
+	case IONIC_XCVR_PID_QSFP_40GBASE_SR4:
+	case IONIC_XCVR_PID_QSFP_40GBASE_AOC:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     40000baseSR4_Full);
+		break;
+	case IONIC_XCVR_PID_QSFP_40GBASE_LR4:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     40000baseLR4_Full);
+		break;
+	case IONIC_XCVR_PID_SFP_25GBASE_SR:
+	case IONIC_XCVR_PID_SFP_25GBASE_AOC:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     25000baseSR_Full);
+		break;
+	case IONIC_XCVR_PID_SFP_10GBASE_SR:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseSR_Full);
+		break;
+	case IONIC_XCVR_PID_SFP_10GBASE_LR:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseLR_Full);
+		break;
+	case IONIC_XCVR_PID_SFP_10GBASE_LRM:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseLRM_Full);
+		break;
+	case IONIC_XCVR_PID_SFP_10GBASE_ER:
+		ethtool_link_ksettings_add_link_mode(ks, supported,
+						     10000baseER_Full);
+		break;
+	case IONIC_XCVR_PID_UNKNOWN:
+		/* This means there's no module plugged in */
+		break;
+	default:
+		dev_info(lif->ionic->dev, "unknown xcvr type pid=%d / 0x%x\n",
+			 idev->port_info->status.xcvr.pid,
+			 idev->port_info->status.xcvr.pid);
+		break;
+	}
+
+	bitmap_copy(ks->link_modes.advertising, ks->link_modes.supported,
+		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
+	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
+	if (idev->port_info->config.fec_type == IONIC_PORT_FEC_TYPE_FC)
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_BASER);
+	else if (idev->port_info->config.fec_type == IONIC_PORT_FEC_TYPE_RS)
+		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
+
+	ethtool_link_ksettings_add_link_mode(ks, supported, FIBRE);
+	ethtool_link_ksettings_add_link_mode(ks, supported, Pause);
+
+	if (idev->port_info->status.xcvr.phy == IONIC_PHY_TYPE_COPPER ||
+	    copper_seen)
+		ks->base.port = PORT_DA;
+	else if (idev->port_info->status.xcvr.phy == IONIC_PHY_TYPE_FIBER)
+		ks->base.port = PORT_FIBRE;
+	else
+		ks->base.port = PORT_NONE;
+
+	if (ks->base.port != PORT_NONE) {
+		ks->base.speed = le32_to_cpu(lif->info->status.link_speed);
+
+		if (le16_to_cpu(lif->info->status.link_status))
+			ks->base.duplex = DUPLEX_FULL;
+		else
+			ks->base.duplex = DUPLEX_UNKNOWN;
+
+		if (ionic_is_pf(lif->ionic)) {
+			ethtool_link_ksettings_add_link_mode(ks, supported,
+							     Autoneg);
+
+			if (idev->port_info->config.an_enable) {
+				ethtool_link_ksettings_add_link_mode(ks,
+								     advertising,
+								     Autoneg);
+				ks->base.autoneg = AUTONEG_ENABLE;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int ionic_set_link_ksettings(struct net_device *netdev,
+				    const struct ethtool_link_ksettings *ks)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	struct ionic_dev *idev;
+	u32 req_rs, req_fc;
+	u8 fec_type;
+	int err = 0;
+
+	idev = &lif->ionic->idev;
+	fec_type = IONIC_PORT_FEC_TYPE_NONE;
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
+	} else if (req_fc) {
+		fec_type = IONIC_PORT_FEC_TYPE_FC;
+	} else if (req_rs) {
+		fec_type = IONIC_PORT_FEC_TYPE_RS;
+	} else if (!(req_rs | req_fc)) {
+		fec_type = IONIC_PORT_FEC_TYPE_NONE;
+	}
+
+	if (fec_type != idev->port_info->config.fec_type) {
+		mutex_lock(&ionic->dev_cmd_lock);
+		ionic_dev_cmd_port_fec(idev, fec_type);
+		err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+		mutex_unlock(&ionic->dev_cmd_lock);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void ionic_get_pauseparam(struct net_device *netdev,
+				 struct ethtool_pauseparam *pause)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	u8 pause_type;
+
+	pause->autoneg = 0;
+
+	pause_type = lif->ionic->idev.port_info->config.pause_type;
+	if (pause_type) {
+		pause->rx_pause = pause_type & IONIC_PAUSE_F_RX ? 1 : 0;
+		pause->tx_pause = pause_type & IONIC_PAUSE_F_TX ? 1 : 0;
+	}
+}
+
+static int ionic_set_pauseparam(struct net_device *netdev,
+				struct ethtool_pauseparam *pause)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	u32 requested_pause;
+	int err;
+
+	if (pause->autoneg)
+		return -EOPNOTSUPP;
+
+	/* change both at the same time */
+	requested_pause = IONIC_PORT_PAUSE_TYPE_LINK;
+	if (pause->rx_pause)
+		requested_pause |= IONIC_PAUSE_F_RX;
+	if (pause->tx_pause)
+		requested_pause |= IONIC_PAUSE_F_TX;
+
+	if (requested_pause == lif->ionic->idev.port_info->config.pause_type)
+		return 0;
+
+	mutex_lock(&ionic->dev_cmd_lock);
+	ionic_dev_cmd_port_pause(&lif->ionic->idev, requested_pause);
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
+	struct ionic_lif *lif = netdev_priv(netdev);
+
+	/* Tx uses Rx interrupt */
+	coalesce->tx_coalesce_usecs = lif->rx_coalesce_usecs;
+	coalesce->rx_coalesce_usecs = lif->rx_coalesce_usecs;
+
+	return 0;
+}
+
+static void ionic_get_ringparam(struct net_device *netdev,
+				struct ethtool_ringparam *ring)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
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
+	struct ionic_lif *lif = netdev_priv(netdev);
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
+	if (!ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET))
+		return -EBUSY;
+
+	running = test_bit(IONIC_LIF_UP, lif->state);
+	if (running)
+		ionic_stop(netdev);
+
+	lif->ntxq_descs = ring->tx_pending;
+	lif->nrxq_descs = ring->rx_pending;
+
+	if (running)
+		ionic_open(netdev);
+	clear_bit(IONIC_LIF_QUEUE_RESET, lif->state);
+
+	return 0;
+}
+
+static void ionic_get_channels(struct net_device *netdev,
+			       struct ethtool_channels *ch)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
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
+	struct ionic_lif *lif = netdev_priv(netdev);
+	bool running;
+
+	if (!ch->combined_count || ch->other_count ||
+	    ch->rx_count || ch->tx_count)
+		return -EINVAL;
+
+	if (ch->combined_count == lif->nxqs)
+		return 0;
+
+	if (!ionic_wait_for_bit(lif, IONIC_LIF_QUEUE_RESET))
+		return -EBUSY;
+
+	running = test_bit(IONIC_LIF_UP, lif->state);
+	if (running)
+		ionic_stop(netdev);
+
+	lif->nxqs = ch->combined_count;
+
+	if (running)
+		ionic_open(netdev);
+	clear_bit(IONIC_LIF_QUEUE_RESET, lif->state);
+
+	return 0;
+}
+
+static int ionic_get_module_info(struct net_device *netdev,
+				 struct ethtool_modinfo *modinfo)
+
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct ionic_xcvr_status *xcvr;
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
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev = &lif->ionic->idev;
+	struct ionic_xcvr_status *xcvr;
+	char tbuf[sizeof(xcvr->sprom)];
+	int count = 10;
+	u32 len;
+
+	/* The NIC keeps the module prom up-to-date in the DMA space
+	 * so we can simply copy the module bytes into the data buffer.
+	 */
+	xcvr = &idev->port_info->status.xcvr;
+	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
+
+	do {
+		memcpy(data, xcvr->sprom, len);
+		memcpy(tbuf, xcvr->sprom, len);
+
+		/* Let's make sure we got a consistent copy */
+		if (!memcmp(data, tbuf, len))
+			break;
+
+	} while (--count);
+
+	return 0;
+}
+
+static int ionic_nway_reset(struct net_device *netdev)
+{
+	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic *ionic = lif->ionic;
+	int err = 0;
+
+	/* flap the link to force auto-negotiation */
+
+	mutex_lock(&ionic->dev_cmd_lock);
+
+	ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_DOWN);
+	err = ionic_dev_cmd_wait(ionic, devcmd_timeout);
+
+	if (!err) {
+		ionic_dev_cmd_port_state(&ionic->idev, IONIC_PORT_ADMIN_STATE_UP);
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
index 5105ce281983..cb77ffd18708 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -10,6 +10,7 @@
 #include "ionic.h"
 #include "ionic_bus.h"
 #include "ionic_lif.h"
+#include "ionic_ethtool.h"
 #include "ionic_debugfs.h"
 
 static void ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode);
@@ -1161,6 +1162,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	lif->netdev = netdev;
 	ionic->master_lif = lif;
 	netdev->netdev_ops = &ionic_netdev_ops;
+	ionic_ethtool_set_ops(netdev);
 
 	netdev->watchdog_timeo = 2 * HZ;
 	netdev->min_mtu = IONIC_MIN_MTU;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index db6dda42e8bd..f927e1cfd646 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -109,6 +109,8 @@ struct ionic_lif {
 	u64 last_eid;
 	unsigned int neqs;
 	unsigned int nxqs;
+	unsigned int ntxq_descs;
+	unsigned int nrxq_descs;
 	unsigned int rx_mode;
 	u64 hw_features;
 	bool mc_overflow;
@@ -125,6 +127,7 @@ struct ionic_lif {
 	unsigned long *dbid_inuse;
 	unsigned int dbid_count;
 	struct dentry *dentry;
+	u32 rx_coalesce_usecs;
 	u32 flags;
 };
 
-- 
2.17.1

