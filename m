Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C44A2024E5
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgFTPoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgFTPoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:08 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C007CC0613EE
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:06 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e12so10161497eds.2
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kfrnHScH6lViJWR80PX4TyK7cCKxAMgdNjJNxVWy7j0=;
        b=MOenQBTzHBz1GAJGoMVU7yIix4nzi7ZbY3laX2PN5PTjdC0GtMBVs6S+t4XG105rE7
         gzFVWkR7AXMScGxOmixFjM41ccfJtjd7fWPn/+jKHjJq+hIfM8LP4kidR1qYxODNMQ1+
         maY5j1E5qCeF8w2YQQ3yDB979yxdbcbz3hoi2P7vUC+19FWBFHWw6y47/25L13qik7Dg
         NHUAJVQHV7Zb0aOLZy2Nefo/zKdBrmCtvrl9MgRc6wEErMlamk2DUULJvYAwscnQBVxl
         FdJVHFzgfL/cF9xvPKEl6xaaArzWKLWoSRfJNuokoOMNMVHQmHIJj3tpo0Aa4mnu8CDF
         6xmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kfrnHScH6lViJWR80PX4TyK7cCKxAMgdNjJNxVWy7j0=;
        b=bSz83i5KuVmiXxLT4bkLzNhRRTs/MjfWjEdDjZDkFKgdDHPlji0SQyR5VOu/nvXSjT
         yt20ljCuKepWv3jE4uHgO0V1h5vjVPQjCfUcRU5Nmqlt9Wp7jO84xgUYXTQotSf903hu
         4/hd1jf84pQPLuva90aOpLzRTBNQTNoUi9jom02L3inGaLm7IC1z4S5LvKsnKMNgvmcy
         KG1FbCiiWgq1R/GqYziIZdNS6k6FpNeMqaV0RbbyyIxFPElkqwGyfQv63a9xzBK4cpwp
         TVM3GjE5tCt6Jx1dBONahY5lif4jDPfLHy5zc9jx7fNlxaWXDQoA0ghOifAnPRkAz8rZ
         tnSg==
X-Gm-Message-State: AOAM530RL+vrafoh2RdjntKnTE3Bs9l8tk/VqmkkJ+l2rEuCeGuY0FPg
        yEPeOpcBuCto4V5BZprPuqY=
X-Google-Smtp-Source: ABdhPJwGrMyWPs4MOztQFgKo4wJ4KKBMWSNnr8jTo7lRofMzjbH01PWvLtjVadIV2tiyG4aMUG9jqA==
X-Received: by 2002:aa7:c0c7:: with SMTP id j7mr8364723edp.242.1592667844914;
        Sat, 20 Jun 2020 08:44:04 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:44:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 09/12] net: mscc: ocelot: move net_device related functions to ocelot_net.c
Date:   Sat, 20 Jun 2020 18:43:44 +0300
Message-Id: <20200620154347.3587114-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot hardware library shouldn't contain too much net_device
specific code, since it is shared with DSA which abstracts that
structure away. So much as much of this code as possible into the
mscc_ocelot driver and outside of the common library.

We're making an exception for MDB and LAG code. That is not yet exported
to DSA, but when it will, most of the code that's already in ocelot.c
will remain there. So, there's no point in moving code to ocelot_net.c
just to move it back later.

We could have moved all net_device code to ocelot_vsc7514.c directly,
but let's operate under the assumption that if a new switchdev ocelot
driver gets added, it'll define its SoC-specific stuff in a new
ocelot_vsc*.c file and it'll reuse the rest of the code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile        |    5 +-
 drivers/net/ethernet/mscc/ocelot.c        |  909 +-----------------
 drivers/net/ethernet/mscc/ocelot.h        |   45 +-
 drivers/net/ethernet/mscc/ocelot_ace.c    |   24 +
 drivers/net/ethernet/mscc/ocelot_flower.c |   22 -
 drivers/net/ethernet/mscc/ocelot_net.c    | 1031 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.c |   49 +-
 drivers/net/ethernet/mscc/ocelot_police.h |   24 +
 drivers/net/ethernet/mscc/ocelot_tc.c     |  179 ----
 drivers/net/ethernet/mscc/ocelot_tc.h     |   22 -
 10 files changed, 1151 insertions(+), 1159 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_net.c
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_tc.c
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_tc.h

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 5d0b6c1da3a0..7ab3bc25ed27 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -3,10 +3,11 @@ obj-$(CONFIG_MSCC_OCELOT_SWITCH_LIB) += mscc_ocelot_switch_lib.o
 mscc_ocelot_switch_lib-y := \
 	ocelot.o \
 	ocelot_io.o \
-	ocelot_tc.o \
 	ocelot_police.o \
 	ocelot_ace.o \
 	ocelot_flower.o \
 	ocelot_ptp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
-mscc_ocelot-y := ocelot_vsc7514.o
+mscc_ocelot-y := \
+	ocelot_vsc7514.o \
+	ocelot_net.o
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9cfe1fd98c30..5c2b5a2e8608 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -4,42 +4,13 @@
  *
  * Copyright (c) 2017 Microsemi Corporation
  */
-#include <linux/etherdevice.h>
-#include <linux/ethtool.h>
 #include <linux/if_bridge.h>
-#include <linux/if_ether.h>
-#include <linux/if_vlan.h>
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/phy.h>
-#include <linux/skbuff.h>
-#include <linux/iopoll.h>
-#include <net/arp.h>
-#include <net/netevent.h>
-#include <net/rtnetlink.h>
-#include <net/switchdev.h>
-
 #include "ocelot.h"
 #include "ocelot_ace.h"
 
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
 
-/* MAC table entry types.
- * ENTRYTYPE_NORMAL is subject to aging.
- * ENTRYTYPE_LOCKED is not subject to aging.
- * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
- * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
- */
-enum macaccess_entry_type {
-	ENTRYTYPE_NORMAL = 0,
-	ENTRYTYPE_LOCKED,
-	ENTRYTYPE_MACv4,
-	ENTRYTYPE_MACv6,
-};
-
 struct ocelot_mact_entry {
 	u8 mac[ETH_ALEN];
 	u16 vid;
@@ -84,10 +55,9 @@ static void ocelot_mact_select(struct ocelot *ocelot,
 
 }
 
-static int ocelot_mact_learn(struct ocelot *ocelot, int port,
-			     const unsigned char mac[ETH_ALEN],
-			     unsigned int vid,
-			     enum macaccess_entry_type type)
+int ocelot_mact_learn(struct ocelot *ocelot, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid, enum macaccess_entry_type type)
 {
 	ocelot_mact_select(ocelot, mac, vid);
 
@@ -100,10 +70,10 @@ static int ocelot_mact_learn(struct ocelot *ocelot, int port,
 
 	return ocelot_mact_wait_for_completion(ocelot);
 }
+EXPORT_SYMBOL(ocelot_mact_learn);
 
-static int ocelot_mact_forget(struct ocelot *ocelot,
-			      const unsigned char mac[ETH_ALEN],
-			      unsigned int vid)
+int ocelot_mact_forget(struct ocelot *ocelot,
+		       const unsigned char mac[ETH_ALEN], unsigned int vid)
 {
 	ocelot_mact_select(ocelot, mac, vid);
 
@@ -114,6 +84,7 @@ static int ocelot_mact_forget(struct ocelot *ocelot,
 
 	return ocelot_mact_wait_for_completion(ocelot);
 }
+EXPORT_SYMBOL(ocelot_mact_forget);
 
 static void ocelot_mact_init(struct ocelot *ocelot)
 {
@@ -168,20 +139,6 @@ static int ocelot_vlant_set_mask(struct ocelot *ocelot, u16 vid, u32 mask)
 	return ocelot_vlant_wait_for_completion(ocelot);
 }
 
-static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
-			     netdev_features_t features)
-{
-	u32 val;
-
-	/* Filtering */
-	val = ocelot_read(ocelot, ANA_VLANMASK);
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
-		val |= BIT(port);
-	else
-		val &= ~BIT(port);
-	ocelot_write(ocelot, val, ANA_VLANMASK);
-}
-
 static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 				       u16 vid)
 {
@@ -295,26 +252,6 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 }
 EXPORT_SYMBOL(ocelot_vlan_add);
 
-static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
-			       bool untagged)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
-	int ret;
-
-	ret = ocelot_vlan_add(ocelot, port, vid, pvid, untagged);
-	if (ret)
-		return ret;
-
-	/* Add the port MAC address to with the right VLAN information */
-	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, vid,
-			  ENTRYTYPE_LOCKED);
-
-	return 0;
-}
-
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -338,30 +275,6 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 }
 EXPORT_SYMBOL(ocelot_vlan_del);
 
-static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-	int ret;
-
-	/* 8021q removes VID 0 on module unload for all interfaces
-	 * with VLAN filtering feature. We need to keep it to receive
-	 * untagged traffic.
-	 */
-	if (vid == 0)
-		return 0;
-
-	ret = ocelot_vlan_del(ocelot, port, vid);
-	if (ret)
-		return ret;
-
-	/* Del the port MAC address to with the right VLAN information */
-	ocelot_mact_forget(ocelot, dev->dev_addr, vid);
-
-	return 0;
-}
-
 static void ocelot_vlan_init(struct ocelot *ocelot)
 {
 	u16 port, vid;
@@ -492,15 +405,6 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_adjust_link);
 
-static void ocelot_port_adjust_link(struct net_device *dev)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	ocelot_adjust_link(ocelot, port, dev->phydev);
-}
-
 void ocelot_port_enable(struct ocelot *ocelot, int port,
 			struct phy_device *phy)
 {
@@ -514,40 +418,6 @@ void ocelot_port_enable(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_port_enable);
 
-static int ocelot_port_open(struct net_device *dev)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
-	int err;
-
-	if (priv->serdes) {
-		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
-				       ocelot_port->phy_mode);
-		if (err) {
-			netdev_err(dev, "Could not set mode of SerDes\n");
-			return err;
-		}
-	}
-
-	err = phy_connect_direct(dev, priv->phy, &ocelot_port_adjust_link,
-				 ocelot_port->phy_mode);
-	if (err) {
-		netdev_err(dev, "Could not attach to PHY\n");
-		return err;
-	}
-
-	dev->phydev = priv->phy;
-
-	phy_attached_info(priv->phy);
-	phy_start(priv->phy);
-
-	ocelot_port_enable(ocelot, port, priv->phy);
-
-	return 0;
-}
-
 void ocelot_port_disable(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -558,41 +428,6 @@ void ocelot_port_disable(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_port_disable);
 
-static int ocelot_port_stop(struct net_device *dev)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	phy_disconnect(priv->phy);
-
-	dev->phydev = NULL;
-
-	ocelot_port_disable(ocelot, port);
-
-	return 0;
-}
-
-/* Generate the IFH for frame injection
- *
- * The IFH is a 128bit-value
- * bit 127: bypass the analyzer processing
- * bit 56-67: destination mask
- * bit 28-29: pop_cnt: 3 disables all rewriting of the frame
- * bit 20-27: cpu extraction queue mask
- * bit 16: tag type 0: C-tag, 1: S-tag
- * bit 0-11: VID
- */
-static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
-{
-	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
-	ifh[1] = (0xf00 & info->port) >> 8;
-	ifh[2] = (0xff & info->port) << 24;
-	ifh[3] = (info->tag_type << 16) | info->vid;
-
-	return 0;
-}
-
 int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 				 struct sk_buff *skb)
 {
@@ -611,77 +446,6 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 }
 EXPORT_SYMBOL(ocelot_port_add_txtstamp_skb);
 
-static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct skb_shared_info *shinfo = skb_shinfo(skb);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	u32 val, ifh[OCELOT_TAG_LEN / 4];
-	struct frame_info info = {};
-	u8 grp = 0; /* Send everything on CPU group 0 */
-	unsigned int i, count, last;
-	int port = priv->chip_port;
-
-	val = ocelot_read(ocelot, QS_INJ_STATUS);
-	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
-	    (val & QS_INJ_STATUS_WMARK_REACHED(BIT(grp))))
-		return NETDEV_TX_BUSY;
-
-	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
-			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
-
-	info.port = BIT(port);
-	info.tag_type = IFH_TAG_TYPE_C;
-	info.vid = skb_vlan_tag_get(skb);
-
-	/* Check if timestamping is needed */
-	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
-		info.rew_op = ocelot_port->ptp_cmd;
-		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
-			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
-	}
-
-	ocelot_gen_ifh(ifh, &info);
-
-	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
-		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
-				 QS_INJ_WR, grp);
-
-	count = (skb->len + 3) / 4;
-	last = skb->len % 4;
-	for (i = 0; i < count; i++) {
-		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
-	}
-
-	/* Add padding */
-	while (i < (OCELOT_BUFFER_CELL_SZ / 4)) {
-		ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
-		i++;
-	}
-
-	/* Indicate EOF and valid bytes in last word */
-	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
-			 QS_INJ_CTRL_VLD_BYTES(skb->len < OCELOT_BUFFER_CELL_SZ ? 0 : last) |
-			 QS_INJ_CTRL_EOF,
-			 QS_INJ_CTRL, grp);
-
-	/* Add dummy CRC */
-	ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
-	skb_tx_timestamp(skb);
-
-	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
-
-	if (!ocelot_port_add_txtstamp_skb(ocelot_port, skb)) {
-		ocelot_port->ts_id++;
-		return NETDEV_TX_OK;
-	}
-
-	dev_kfree_skb_any(skb);
-	return NETDEV_TX_OK;
-}
-
 static void ocelot_get_hwtimestamp(struct ocelot *ocelot,
 				   struct timespec64 *ts)
 {
@@ -767,113 +531,6 @@ void ocelot_get_txtstamp(struct ocelot *ocelot)
 }
 EXPORT_SYMBOL(ocelot_get_txtstamp);
 
-static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-
-	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid);
-}
-
-static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-
-	return ocelot_mact_learn(ocelot, PGID_CPU, addr, ocelot_port->pvid,
-				 ENTRYTYPE_LOCKED);
-}
-
-static void ocelot_set_rx_mode(struct net_device *dev)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	u32 val;
-	int i;
-
-	/* This doesn't handle promiscuous mode because the bridge core is
-	 * setting IFF_PROMISC on all slave interfaces and all frames would be
-	 * forwarded to the CPU port.
-	 */
-	val = GENMASK(ocelot->num_phys_ports - 1, 0);
-	for (i = ocelot->num_phys_ports + 1; i < PGID_CPU; i++)
-		ocelot_write_rix(ocelot, val, ANA_PGID_PGID, i);
-
-	__dev_mc_sync(dev, ocelot_mc_sync, ocelot_mc_unsync);
-}
-
-static int ocelot_port_get_phys_port_name(struct net_device *dev,
-					  char *buf, size_t len)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	int port = priv->chip_port;
-	int ret;
-
-	ret = snprintf(buf, len, "p%d", port);
-	if (ret >= len)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	const struct sockaddr *addr = p;
-
-	/* Learn the new net device MAC address in the mac table. */
-	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data, ocelot_port->pvid,
-			  ENTRYTYPE_LOCKED);
-	/* Then forget the previous one. */
-	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid);
-
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
-	return 0;
-}
-
-static void ocelot_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *stats)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	/* Configure the port to read the stats from */
-	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
-		     SYS_STAT_CFG);
-
-	/* Get Rx stats */
-	stats->rx_bytes = ocelot_read(ocelot, SYS_COUNT_RX_OCTETS);
-	stats->rx_packets = ocelot_read(ocelot, SYS_COUNT_RX_SHORTS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_FRAGMENTS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_JABBERS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_LONGS) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_64) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_128_255) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_256_1023) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_1024_1526) +
-			    ocelot_read(ocelot, SYS_COUNT_RX_1527_MAX);
-	stats->multicast = ocelot_read(ocelot, SYS_COUNT_RX_MULTICAST);
-	stats->rx_dropped = dev->stats.rx_dropped;
-
-	/* Get Tx stats */
-	stats->tx_bytes = ocelot_read(ocelot, SYS_COUNT_TX_OCTETS);
-	stats->tx_packets = ocelot_read(ocelot, SYS_COUNT_TX_64) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_65_127) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_128_511) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_512_1023) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_1024_1526) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_1527_MAX);
-	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
-			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
-	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
-}
-
 int ocelot_fdb_add(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
@@ -897,19 +554,6 @@ int ocelot_fdb_add(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
 
-static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
-			       struct net_device *dev,
-			       const unsigned char *addr,
-			       u16 vid, u16 flags,
-			       struct netlink_ext_ack *extack)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	return ocelot_fdb_add(ocelot, port, addr, vid);
-}
-
 int ocelot_fdb_del(struct ocelot *ocelot, int port,
 		   const unsigned char *addr, u16 vid)
 {
@@ -917,26 +561,8 @@ int ocelot_fdb_del(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_fdb_del);
 
-static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
-			       struct net_device *dev,
-			       const unsigned char *addr, u16 vid)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	return ocelot_fdb_del(ocelot, port, addr, vid);
-}
-
-struct ocelot_dump_ctx {
-	struct net_device *dev;
-	struct sk_buff *skb;
-	struct netlink_callback *cb;
-	int idx;
-};
-
-static int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
-				   bool is_static, void *data)
+int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
+			    bool is_static, void *data)
 {
 	struct ocelot_dump_ctx *dump = data;
 	u32 portid = NETLINK_CB(dump->cb->skb).portid;
@@ -977,6 +603,7 @@ static int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
 	nlmsg_cancel(dump->skb, nlh);
 	return -EMSGSIZE;
 }
+EXPORT_SYMBOL(ocelot_port_fdb_do_dump);
 
 static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 			    struct ocelot_mact_entry *entry)
@@ -1058,74 +685,6 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_fdb_dump);
 
-static int ocelot_port_fdb_dump(struct sk_buff *skb,
-				struct netlink_callback *cb,
-				struct net_device *dev,
-				struct net_device *filter_dev, int *idx)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	struct ocelot_dump_ctx dump = {
-		.dev = dev,
-		.skb = skb,
-		.cb = cb,
-		.idx = *idx,
-	};
-	int port = priv->chip_port;
-	int ret;
-
-	ret = ocelot_fdb_dump(ocelot, port, ocelot_port_fdb_do_dump, &dump);
-
-	*idx = dump.idx;
-
-	return ret;
-}
-
-static int ocelot_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
-				  u16 vid)
-{
-	return ocelot_vlan_vid_add(dev, vid, false, false);
-}
-
-static int ocelot_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
-				   u16 vid)
-{
-	return ocelot_vlan_vid_del(dev, vid);
-}
-
-static int ocelot_set_features(struct net_device *dev,
-			       netdev_features_t features)
-{
-	netdev_features_t changed = dev->features ^ features;
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
-	    priv->tc.offload_cnt) {
-		netdev_err(dev,
-			   "Cannot disable HW TC offload while offloads active\n");
-		return -EBUSY;
-	}
-
-	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
-		ocelot_vlan_mode(ocelot, port, features);
-
-	return 0;
-}
-
-static int ocelot_get_port_parent_id(struct net_device *dev,
-				     struct netdev_phys_item_id *ppid)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-
-	ppid->id_len = sizeof(ocelot->base_mac);
-	memcpy(&ppid->id, &ocelot->base_mac, ppid->id_len);
-
-	return 0;
-}
-
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	return copy_to_user(ifr->ifr_data, &ocelot->hwtstamp_config,
@@ -1198,46 +757,6 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 }
 EXPORT_SYMBOL(ocelot_hwstamp_set);
 
-static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	/* If the attached PHY device isn't capable of timestamping operations,
-	 * use our own (when possible).
-	 */
-	if (!phy_has_hwtstamp(dev->phydev) && ocelot->ptp) {
-		switch (cmd) {
-		case SIOCSHWTSTAMP:
-			return ocelot_hwstamp_set(ocelot, port, ifr);
-		case SIOCGHWTSTAMP:
-			return ocelot_hwstamp_get(ocelot, port, ifr);
-		}
-	}
-
-	return phy_mii_ioctl(dev->phydev, ifr, cmd);
-}
-
-static const struct net_device_ops ocelot_port_netdev_ops = {
-	.ndo_open			= ocelot_port_open,
-	.ndo_stop			= ocelot_port_stop,
-	.ndo_start_xmit			= ocelot_port_xmit,
-	.ndo_set_rx_mode		= ocelot_set_rx_mode,
-	.ndo_get_phys_port_name		= ocelot_port_get_phys_port_name,
-	.ndo_set_mac_address		= ocelot_port_set_mac_address,
-	.ndo_get_stats64		= ocelot_get_stats64,
-	.ndo_fdb_add			= ocelot_port_fdb_add,
-	.ndo_fdb_del			= ocelot_port_fdb_del,
-	.ndo_fdb_dump			= ocelot_port_fdb_dump,
-	.ndo_vlan_rx_add_vid		= ocelot_vlan_rx_add_vid,
-	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
-	.ndo_set_features		= ocelot_set_features,
-	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
-	.ndo_setup_tc			= ocelot_setup_tc,
-	.ndo_do_ioctl			= ocelot_ioctl,
-};
-
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 {
 	int i;
@@ -1251,16 +770,6 @@ void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 }
 EXPORT_SYMBOL(ocelot_get_strings);
 
-static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
-				    u8 *data)
-{
-	struct ocelot_port_private *priv = netdev_priv(netdev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	ocelot_get_strings(ocelot, port, sset, data);
-}
-
 static void ocelot_update_stats(struct ocelot *ocelot)
 {
 	int i, j;
@@ -1314,17 +823,6 @@ void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 }
 EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
-static void ocelot_port_get_ethtool_stats(struct net_device *dev,
-					  struct ethtool_stats *stats,
-					  u64 *data)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	ocelot_get_ethtool_stats(ocelot, port, data);
-}
-
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 {
 	if (sset != ETH_SS_STATS)
@@ -1334,15 +832,6 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 }
 EXPORT_SYMBOL(ocelot_get_sset_count);
 
-static int ocelot_port_get_sset_count(struct net_device *dev, int sset)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	return ocelot_get_sset_count(ocelot, port, sset);
-}
-
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info)
 {
@@ -1368,28 +857,6 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static int ocelot_port_get_ts_info(struct net_device *dev,
-				   struct ethtool_ts_info *info)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	if (!ocelot->ptp)
-		return ethtool_op_get_ts_info(dev, info);
-
-	return ocelot_get_ts_info(ocelot, port, info);
-}
-
-static const struct ethtool_ops ocelot_ethtool_ops = {
-	.get_strings		= ocelot_port_get_strings,
-	.get_ethtool_stats	= ocelot_port_get_ethtool_stats,
-	.get_sset_count		= ocelot_port_get_sset_count,
-	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
-	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
-	.get_ts_info		= ocelot_port_get_ts_info,
-};
-
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	u32 port_cfg;
@@ -1445,16 +912,6 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 }
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
 
-static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
-					   struct switchdev_trans *trans,
-					   u8 state)
-{
-	if (switchdev_trans_ph_prepare(trans))
-		return;
-
-	ocelot_bridge_stp_state_set(ocelot, port, state);
-}
-
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
 {
 	unsigned int age_period = ANA_AUTOAGE_AGE_PERIOD(msecs / 2000);
@@ -1469,95 +926,6 @@ void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
 }
 EXPORT_SYMBOL(ocelot_set_ageing_time);
 
-static void ocelot_port_attr_ageing_set(struct ocelot *ocelot, int port,
-					unsigned long ageing_clock_t)
-{
-	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
-	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
-
-	ocelot_set_ageing_time(ocelot, ageing_time);
-}
-
-static void ocelot_port_attr_mc_set(struct ocelot *ocelot, int port, bool mc)
-{
-	u32 cpu_fwd_mcast = ANA_PORT_CPU_FWD_CFG_CPU_IGMP_REDIR_ENA |
-			    ANA_PORT_CPU_FWD_CFG_CPU_MLD_REDIR_ENA |
-			    ANA_PORT_CPU_FWD_CFG_CPU_IPMC_CTRL_COPY_ENA;
-	u32 val = 0;
-
-	if (mc)
-		val = cpu_fwd_mcast;
-
-	ocelot_rmw_gix(ocelot, val, cpu_fwd_mcast,
-		       ANA_PORT_CPU_FWD_CFG, port);
-}
-
-static int ocelot_port_attr_set(struct net_device *dev,
-				const struct switchdev_attr *attr,
-				struct switchdev_trans *trans)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-	int err = 0;
-
-	switch (attr->id) {
-	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		ocelot_port_attr_stp_state_set(ocelot, port, trans,
-					       attr->u.stp_state);
-		break;
-	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
-		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
-		break;
-	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ocelot_port_vlan_filtering(ocelot, port,
-					   attr->u.vlan_filtering);
-		break;
-	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
-		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
-		break;
-	default:
-		err = -EOPNOTSUPP;
-		break;
-	}
-
-	return err;
-}
-
-static int ocelot_port_obj_add_vlan(struct net_device *dev,
-				    const struct switchdev_obj_port_vlan *vlan,
-				    struct switchdev_trans *trans)
-{
-	int ret;
-	u16 vid;
-
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ret = ocelot_vlan_vid_add(dev, vid,
-					  vlan->flags & BRIDGE_VLAN_INFO_PVID,
-					  vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
-static int ocelot_port_vlan_del_vlan(struct net_device *dev,
-				     const struct switchdev_obj_port_vlan *vlan)
-{
-	int ret;
-	u16 vid;
-
-	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
-		ret = ocelot_vlan_vid_del(dev, vid);
-
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 static struct ocelot_multicast *ocelot_multicast_get(struct ocelot *ocelot,
 						     const unsigned char *addr,
 						     u16 vid)
@@ -1572,9 +940,9 @@ static struct ocelot_multicast *ocelot_multicast_get(struct ocelot *ocelot,
 	return NULL;
 }
 
-static int ocelot_port_obj_add_mdb(struct net_device *dev,
-				   const struct switchdev_obj_port_mdb *mdb,
-				   struct switchdev_trans *trans)
+int ocelot_port_obj_add_mdb(struct net_device *dev,
+			    const struct switchdev_obj_port_mdb *mdb,
+			    struct switchdev_trans *trans)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -1616,9 +984,10 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
+EXPORT_SYMBOL(ocelot_port_obj_add_mdb);
 
-static int ocelot_port_obj_del_mdb(struct net_device *dev,
-				   const struct switchdev_obj_port_mdb *mdb)
+int ocelot_port_obj_del_mdb(struct net_device *dev,
+			    const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -1653,50 +1022,7 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 
 	return ocelot_mact_learn(ocelot, 0, addr, vid, ENTRYTYPE_MACv4);
 }
-
-static int ocelot_port_obj_add(struct net_device *dev,
-			       const struct switchdev_obj *obj,
-			       struct switchdev_trans *trans,
-			       struct netlink_ext_ack *extack)
-{
-	int ret = 0;
-
-	switch (obj->id) {
-	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		ret = ocelot_port_obj_add_vlan(dev,
-					       SWITCHDEV_OBJ_PORT_VLAN(obj),
-					       trans);
-		break;
-	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					      trans);
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return ret;
-}
-
-static int ocelot_port_obj_del(struct net_device *dev,
-			       const struct switchdev_obj *obj)
-{
-	int ret = 0;
-
-	switch (obj->id) {
-	case SWITCHDEV_OBJ_ID_PORT_VLAN:
-		ret = ocelot_port_vlan_del_vlan(dev,
-						SWITCHDEV_OBJ_PORT_VLAN(obj));
-		break;
-	case SWITCHDEV_OBJ_ID_PORT_MDB:
-		ret = ocelot_port_obj_del_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	return ret;
-}
+EXPORT_SYMBOL(ocelot_port_obj_del_mdb);
 
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge)
@@ -1788,8 +1114,8 @@ static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
 	}
 }
 
-static int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-				struct net_device *bond)
+int ocelot_port_lag_join(struct ocelot *ocelot, int port,
+			 struct net_device *bond)
 {
 	struct net_device *ndev;
 	u32 bond_mask = 0;
@@ -1826,9 +1152,10 @@ static int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_port_lag_join);
 
-static void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-				  struct net_device *bond)
+void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			   struct net_device *bond)
 {
 	u32 port_cfg;
 	int i;
@@ -1856,151 +1183,7 @@ static void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 
 	ocelot_set_aggr_pgids(ocelot);
 }
-
-/* Checks if the net_device instance given to us originate from our driver. */
-static bool ocelot_netdevice_dev_check(const struct net_device *dev)
-{
-	return dev->netdev_ops == &ocelot_port_netdev_ops;
-}
-
-static int ocelot_netdevice_port_event(struct net_device *dev,
-				       unsigned long event,
-				       struct netdev_notifier_changeupper_info *info)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
-	int err = 0;
-
-	switch (event) {
-	case NETDEV_CHANGEUPPER:
-		if (netif_is_bridge_master(info->upper_dev)) {
-			if (info->linking) {
-				err = ocelot_port_bridge_join(ocelot, port,
-							      info->upper_dev);
-			} else {
-				err = ocelot_port_bridge_leave(ocelot, port,
-							       info->upper_dev);
-			}
-		}
-		if (netif_is_lag_master(info->upper_dev)) {
-			if (info->linking)
-				err = ocelot_port_lag_join(ocelot, port,
-							   info->upper_dev);
-			else
-				ocelot_port_lag_leave(ocelot, port,
-						      info->upper_dev);
-		}
-		break;
-	default:
-		break;
-	}
-
-	return err;
-}
-
-static int ocelot_netdevice_event(struct notifier_block *unused,
-				  unsigned long event, void *ptr)
-{
-	struct netdev_notifier_changeupper_info *info = ptr;
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	int ret = 0;
-
-	if (!ocelot_netdevice_dev_check(dev))
-		return 0;
-
-	if (event == NETDEV_PRECHANGEUPPER &&
-	    netif_is_lag_master(info->upper_dev)) {
-		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
-		struct netlink_ext_ack *extack;
-
-		if (lag_upper_info &&
-		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
-			extack = netdev_notifier_info_to_extack(&info->info);
-			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
-
-			ret = -EINVAL;
-			goto notify;
-		}
-	}
-
-	if (netif_is_lag_master(dev)) {
-		struct net_device *slave;
-		struct list_head *iter;
-
-		netdev_for_each_lower_dev(dev, slave, iter) {
-			ret = ocelot_netdevice_port_event(slave, event, info);
-			if (ret)
-				goto notify;
-		}
-	} else {
-		ret = ocelot_netdevice_port_event(dev, event, info);
-	}
-
-notify:
-	return notifier_from_errno(ret);
-}
-
-struct notifier_block ocelot_netdevice_nb __read_mostly = {
-	.notifier_call = ocelot_netdevice_event,
-};
-EXPORT_SYMBOL(ocelot_netdevice_nb);
-
-static int ocelot_switchdev_event(struct notifier_block *unused,
-				  unsigned long event, void *ptr)
-{
-	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	int err;
-
-	switch (event) {
-	case SWITCHDEV_PORT_ATTR_SET:
-		err = switchdev_handle_port_attr_set(dev, ptr,
-						     ocelot_netdevice_dev_check,
-						     ocelot_port_attr_set);
-		return notifier_from_errno(err);
-	}
-
-	return NOTIFY_DONE;
-}
-
-struct notifier_block ocelot_switchdev_nb __read_mostly = {
-	.notifier_call = ocelot_switchdev_event,
-};
-EXPORT_SYMBOL(ocelot_switchdev_nb);
-
-static int ocelot_switchdev_blocking_event(struct notifier_block *unused,
-					   unsigned long event, void *ptr)
-{
-	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
-	int err;
-
-	switch (event) {
-		/* Blocking events. */
-	case SWITCHDEV_PORT_OBJ_ADD:
-		err = switchdev_handle_port_obj_add(dev, ptr,
-						    ocelot_netdevice_dev_check,
-						    ocelot_port_obj_add);
-		return notifier_from_errno(err);
-	case SWITCHDEV_PORT_OBJ_DEL:
-		err = switchdev_handle_port_obj_del(dev, ptr,
-						    ocelot_netdevice_dev_check,
-						    ocelot_port_obj_del);
-		return notifier_from_errno(err);
-	case SWITCHDEV_PORT_ATTR_SET:
-		err = switchdev_handle_port_attr_set(dev, ptr,
-						     ocelot_netdevice_dev_check,
-						     ocelot_port_attr_set);
-		return notifier_from_errno(err);
-	}
-
-	return NOTIFY_DONE;
-}
-
-struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
-	.notifier_call = ocelot_switchdev_blocking_event,
-};
-EXPORT_SYMBOL(ocelot_switchdev_blocking_nb);
+EXPORT_SYMBOL(ocelot_port_lag_leave);
 
 /* Configure the maximum SDU (L2 payload) on RX to the value specified in @sdu.
  * The length of VLAN tags is accounted for automatically via DEV_MAC_TAGS_CFG.
@@ -2109,52 +1292,6 @@ void ocelot_init_port(struct ocelot *ocelot, int port)
 }
 EXPORT_SYMBOL(ocelot_init_port);
 
-int ocelot_probe_port(struct ocelot *ocelot, u8 port,
-		      void __iomem *regs,
-		      struct phy_device *phy)
-{
-	struct ocelot_port_private *priv;
-	struct ocelot_port *ocelot_port;
-	struct net_device *dev;
-	int err;
-
-	dev = alloc_etherdev(sizeof(struct ocelot_port_private));
-	if (!dev)
-		return -ENOMEM;
-	SET_NETDEV_DEV(dev, ocelot->dev);
-	priv = netdev_priv(dev);
-	priv->dev = dev;
-	priv->phy = phy;
-	priv->chip_port = port;
-	ocelot_port = &priv->port;
-	ocelot_port->ocelot = ocelot;
-	ocelot_port->regs = regs;
-	ocelot->ports[port] = ocelot_port;
-
-	dev->netdev_ops = &ocelot_port_netdev_ops;
-	dev->ethtool_ops = &ocelot_ethtool_ops;
-
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
-		NETIF_F_HW_TC;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
-
-	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
-	dev->dev_addr[ETH_ALEN - 1] += port;
-	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, ocelot_port->pvid,
-			  ENTRYTYPE_LOCKED);
-
-	ocelot_init_port(ocelot, port);
-
-	err = register_netdev(dev);
-	if (err) {
-		dev_err(ocelot->dev, "register_netdev failed\n");
-		free_netdev(dev);
-	}
-
-	return err;
-}
-EXPORT_SYMBOL(ocelot_probe_port);
-
 /* Configure and enable the CPU port module, which is a set of queues.
  * If @npi contains a valid port index, the CPU port module is connected
  * to the Node Processor Interface (NPI). This is the mode through which
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index a834747ec9a3..0c23734a87be 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -25,7 +25,6 @@
 #include <soc/mscc/ocelot.h>
 #include "ocelot_rew.h"
 #include "ocelot_qs.h"
-#include "ocelot_tc.h"
 
 #define OCELOT_BUFFER_CELL_SZ 60
 
@@ -49,6 +48,13 @@ struct ocelot_multicast {
 	u16 ports;
 };
 
+struct ocelot_port_tc {
+	bool block_shared;
+	unsigned long offload_cnt;
+
+	unsigned long police_id;
+};
+
 struct ocelot_port_private {
 	struct ocelot_port port;
 	struct net_device *dev;
@@ -60,6 +66,43 @@ struct ocelot_port_private {
 	struct ocelot_port_tc tc;
 };
 
+struct ocelot_dump_ctx {
+	struct net_device *dev;
+	struct sk_buff *skb;
+	struct netlink_callback *cb;
+	int idx;
+};
+
+/* MAC table entry types.
+ * ENTRYTYPE_NORMAL is subject to aging.
+ * ENTRYTYPE_LOCKED is not subject to aging.
+ * ENTRYTYPE_MACv4 is not subject to aging. For IPv4 multicast.
+ * ENTRYTYPE_MACv6 is not subject to aging. For IPv6 multicast.
+ */
+enum macaccess_entry_type {
+	ENTRYTYPE_NORMAL = 0,
+	ENTRYTYPE_LOCKED,
+	ENTRYTYPE_MACv4,
+	ENTRYTYPE_MACv6,
+};
+
+int ocelot_port_fdb_do_dump(const unsigned char *addr, u16 vid,
+			    bool is_static, void *data);
+int ocelot_mact_learn(struct ocelot *ocelot, int port,
+		      const unsigned char mac[ETH_ALEN],
+		      unsigned int vid, enum macaccess_entry_type type);
+int ocelot_mact_forget(struct ocelot *ocelot,
+		       const unsigned char mac[ETH_ALEN], unsigned int vid);
+int ocelot_port_lag_join(struct ocelot *ocelot, int port,
+			 struct net_device *bond);
+void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			   struct net_device *bond);
+int ocelot_port_obj_del_mdb(struct net_device *dev,
+			    const struct switchdev_obj_port_mdb *mdb);
+int ocelot_port_obj_add_mdb(struct net_device *dev,
+			    const struct switchdev_obj_port_mdb *mdb,
+			    struct switchdev_trans *trans);
+
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 1dd881340067..dbfb2666e211 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -843,6 +843,30 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
 	return 0;
 }
 
+int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			   struct ocelot_policer *pol)
+{
+	struct qos_policer_conf pp = { 0 };
+
+	if (!pol)
+		return -EINVAL;
+
+	pp.mode = MSCC_QOS_RATE_MODE_DATA;
+	pp.pir = pol->rate;
+	pp.pbs = pol->burst;
+
+	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+}
+
+int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix)
+{
+	struct qos_policer_conf pp = { 0 };
+
+	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
+
+	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+}
+
 static void ocelot_ace_police_del(struct ocelot *ocelot,
 				  struct ocelot_acl_block *block,
 				  u32 ix)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 99338d27aec0..ad4e8e0d62a4 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -249,25 +249,3 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_stats);
-
-int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
-			       struct flow_cls_offload *f,
-			       bool ingress)
-{
-	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
-
-	if (!ingress)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case FLOW_CLS_REPLACE:
-		return ocelot_cls_flower_replace(ocelot, port, f, ingress);
-	case FLOW_CLS_DESTROY:
-		return ocelot_cls_flower_destroy(ocelot, port, f, ingress);
-	case FLOW_CLS_STATS:
-		return ocelot_cls_flower_stats(ocelot, port, f, ingress);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
new file mode 100644
index 000000000000..1ce444dff983
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -0,0 +1,1031 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Microsemi Ocelot Switch driver
+ *
+ * Copyright (c) 2017, 2019 Microsemi Corporation
+ */
+
+#include <linux/if_bridge.h>
+#include "ocelot.h"
+#include "ocelot_ace.h"
+
+int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
+			       struct flow_cls_offload *f,
+			       bool ingress)
+{
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	if (!ingress)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case FLOW_CLS_REPLACE:
+		return ocelot_cls_flower_replace(ocelot, port, f, ingress);
+	case FLOW_CLS_DESTROY:
+		return ocelot_cls_flower_destroy(ocelot, port, f, ingress);
+	case FLOW_CLS_STATS:
+		return ocelot_cls_flower_stats(ocelot, port, f, ingress);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
+					struct tc_cls_matchall_offload *f,
+					bool ingress)
+{
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_policer pol = { 0 };
+	struct flow_action_entry *action;
+	int port = priv->chip_port;
+	int err;
+
+	if (!ingress) {
+		NL_SET_ERR_MSG_MOD(extack, "Only ingress is supported");
+		return -EOPNOTSUPP;
+	}
+
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		if (!flow_offload_has_one_action(&f->rule->action)) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one action is supported");
+			return -EOPNOTSUPP;
+		}
+
+		if (priv->tc.block_shared) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Rate limit is not supported on shared blocks");
+			return -EOPNOTSUPP;
+		}
+
+		action = &f->rule->action.entries[0];
+
+		if (action->id != FLOW_ACTION_POLICE) {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
+			return -EOPNOTSUPP;
+		}
+
+		if (priv->tc.police_id && priv->tc.police_id != f->cookie) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only one policer per port is supported");
+			return -EEXIST;
+		}
+
+		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
+		pol.burst = (u32)div_u64(action->police.rate_bytes_ps *
+					 PSCHED_NS2TICKS(action->police.burst),
+					 PSCHED_TICKS_PER_SEC);
+
+		err = ocelot_port_policer_add(ocelot, port, &pol);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack, "Could not add policer");
+			return err;
+		}
+
+		priv->tc.police_id = f->cookie;
+		priv->tc.offload_cnt++;
+		return 0;
+	case TC_CLSMATCHALL_DESTROY:
+		if (priv->tc.police_id != f->cookie)
+			return -ENOENT;
+
+		err = ocelot_port_policer_del(ocelot, port);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Could not delete policer");
+			return err;
+		}
+		priv->tc.police_id = 0;
+		priv->tc.offload_cnt--;
+		return 0;
+	case TC_CLSMATCHALL_STATS:
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ocelot_setup_tc_block_cb(enum tc_setup_type type,
+				    void *type_data,
+				    void *cb_priv, bool ingress)
+{
+	struct ocelot_port_private *priv = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(priv->dev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		return ocelot_setup_tc_cls_matchall(priv, type_data, ingress);
+	case TC_SETUP_CLSFLOWER:
+		return ocelot_setup_tc_cls_flower(priv, type_data, ingress);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ocelot_setup_tc_block_cb_ig(enum tc_setup_type type,
+				       void *type_data,
+				       void *cb_priv)
+{
+	return ocelot_setup_tc_block_cb(type, type_data,
+					cb_priv, true);
+}
+
+static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
+				       void *type_data,
+				       void *cb_priv)
+{
+	return ocelot_setup_tc_block_cb(type, type_data,
+					cb_priv, false);
+}
+
+static LIST_HEAD(ocelot_block_cb_list);
+
+static int ocelot_setup_tc_block(struct ocelot_port_private *priv,
+				 struct flow_block_offload *f)
+{
+	struct flow_block_cb *block_cb;
+	flow_setup_cb_t *cb;
+
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
+		cb = ocelot_setup_tc_block_cb_ig;
+		priv->tc.block_shared = f->block_shared;
+	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
+		cb = ocelot_setup_tc_block_cb_eg;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	f->driver_block_list = &ocelot_block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		if (flow_block_cb_is_busy(cb, priv, &ocelot_block_cb_list))
+			return -EBUSY;
+
+		block_cb = flow_block_cb_alloc(cb, priv, priv, NULL);
+		if (IS_ERR(block_cb))
+			return PTR_ERR(block_cb);
+
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, f->driver_block_list);
+		return 0;
+	case FLOW_BLOCK_UNBIND:
+		block_cb = flow_block_cb_lookup(f->block, cb, priv);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
+			   void *type_data)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+
+	switch (type) {
+	case TC_SETUP_BLOCK:
+		return ocelot_setup_tc_block(priv, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static void ocelot_port_adjust_link(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_adjust_link(ocelot, port, dev->phydev);
+}
+
+static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
+			       bool untagged)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+	int ret;
+
+	ret = ocelot_vlan_add(ocelot, port, vid, pvid, untagged);
+	if (ret)
+		return ret;
+
+	/* Add the port MAC address to with the right VLAN information */
+	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, vid,
+			  ENTRYTYPE_LOCKED);
+
+	return 0;
+}
+
+static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+	int ret;
+
+	/* 8021q removes VID 0 on module unload for all interfaces
+	 * with VLAN filtering feature. We need to keep it to receive
+	 * untagged traffic.
+	 */
+	if (vid == 0)
+		return 0;
+
+	ret = ocelot_vlan_del(ocelot, port, vid);
+	if (ret)
+		return ret;
+
+	/* Del the port MAC address to with the right VLAN information */
+	ocelot_mact_forget(ocelot, dev->dev_addr, vid);
+
+	return 0;
+}
+
+static int ocelot_port_open(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+	int err;
+
+	if (priv->serdes) {
+		err = phy_set_mode_ext(priv->serdes, PHY_MODE_ETHERNET,
+				       ocelot_port->phy_mode);
+		if (err) {
+			netdev_err(dev, "Could not set mode of SerDes\n");
+			return err;
+		}
+	}
+
+	err = phy_connect_direct(dev, priv->phy, &ocelot_port_adjust_link,
+				 ocelot_port->phy_mode);
+	if (err) {
+		netdev_err(dev, "Could not attach to PHY\n");
+		return err;
+	}
+
+	dev->phydev = priv->phy;
+
+	phy_attached_info(priv->phy);
+	phy_start(priv->phy);
+
+	ocelot_port_enable(ocelot, port, priv->phy);
+
+	return 0;
+}
+
+static int ocelot_port_stop(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	phy_disconnect(priv->phy);
+
+	dev->phydev = NULL;
+
+	ocelot_port_disable(ocelot, port);
+
+	return 0;
+}
+
+/* Generate the IFH for frame injection
+ *
+ * The IFH is a 128bit-value
+ * bit 127: bypass the analyzer processing
+ * bit 56-67: destination mask
+ * bit 28-29: pop_cnt: 3 disables all rewriting of the frame
+ * bit 20-27: cpu extraction queue mask
+ * bit 16: tag type 0: C-tag, 1: S-tag
+ * bit 0-11: VID
+ */
+static int ocelot_gen_ifh(u32 *ifh, struct frame_info *info)
+{
+	ifh[0] = IFH_INJ_BYPASS | ((0x1ff & info->rew_op) << 21);
+	ifh[1] = (0xf00 & info->port) >> 8;
+	ifh[2] = (0xff & info->port) << 24;
+	ifh[3] = (info->tag_type << 16) | info->vid;
+
+	return 0;
+}
+
+static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	u32 val, ifh[OCELOT_TAG_LEN / 4];
+	struct frame_info info = {};
+	u8 grp = 0; /* Send everything on CPU group 0 */
+	unsigned int i, count, last;
+	int port = priv->chip_port;
+
+	val = ocelot_read(ocelot, QS_INJ_STATUS);
+	if (!(val & QS_INJ_STATUS_FIFO_RDY(BIT(grp))) ||
+	    (val & QS_INJ_STATUS_WMARK_REACHED(BIT(grp))))
+		return NETDEV_TX_BUSY;
+
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
+			 QS_INJ_CTRL_SOF, QS_INJ_CTRL, grp);
+
+	info.port = BIT(port);
+	info.tag_type = IFH_TAG_TYPE_C;
+	info.vid = skb_vlan_tag_get(skb);
+
+	/* Check if timestamping is needed */
+	if (ocelot->ptp && shinfo->tx_flags & SKBTX_HW_TSTAMP) {
+		info.rew_op = ocelot_port->ptp_cmd;
+		if (ocelot_port->ptp_cmd == IFH_REW_OP_TWO_STEP_PTP)
+			info.rew_op |= (ocelot_port->ts_id  % 4) << 3;
+	}
+
+	ocelot_gen_ifh(ifh, &info);
+
+	for (i = 0; i < OCELOT_TAG_LEN / 4; i++)
+		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
+				 QS_INJ_WR, grp);
+
+	count = (skb->len + 3) / 4;
+	last = skb->len % 4;
+	for (i = 0; i < count; i++)
+		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
+
+	/* Add padding */
+	while (i < (OCELOT_BUFFER_CELL_SZ / 4)) {
+		ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
+		i++;
+	}
+
+	/* Indicate EOF and valid bytes in last word */
+	ocelot_write_rix(ocelot, QS_INJ_CTRL_GAP_SIZE(1) |
+			 QS_INJ_CTRL_VLD_BYTES(skb->len < OCELOT_BUFFER_CELL_SZ ? 0 : last) |
+			 QS_INJ_CTRL_EOF,
+			 QS_INJ_CTRL, grp);
+
+	/* Add dummy CRC */
+	ocelot_write_rix(ocelot, 0, QS_INJ_WR, grp);
+	skb_tx_timestamp(skb);
+
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+
+	if (!ocelot_port_add_txtstamp_skb(ocelot_port, skb)) {
+		ocelot_port->ts_id++;
+		return NETDEV_TX_OK;
+	}
+
+	dev_kfree_skb_any(skb);
+	return NETDEV_TX_OK;
+}
+
+static int ocelot_mc_unsync(struct net_device *dev, const unsigned char *addr)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	return ocelot_mact_forget(ocelot, addr, ocelot_port->pvid);
+}
+
+static int ocelot_mc_sync(struct net_device *dev, const unsigned char *addr)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+
+	return ocelot_mact_learn(ocelot, PGID_CPU, addr, ocelot_port->pvid,
+				 ENTRYTYPE_LOCKED);
+}
+
+static void ocelot_set_rx_mode(struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	u32 val;
+	int i;
+
+	/* This doesn't handle promiscuous mode because the bridge core is
+	 * setting IFF_PROMISC on all slave interfaces and all frames would be
+	 * forwarded to the CPU port.
+	 */
+	val = GENMASK(ocelot->num_phys_ports - 1, 0);
+	for (i = ocelot->num_phys_ports + 1; i < PGID_CPU; i++)
+		ocelot_write_rix(ocelot, val, ANA_PGID_PGID, i);
+
+	__dev_mc_sync(dev, ocelot_mc_sync, ocelot_mc_unsync);
+}
+
+static int ocelot_port_get_phys_port_name(struct net_device *dev,
+					  char *buf, size_t len)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	int port = priv->chip_port;
+	int ret;
+
+	ret = snprintf(buf, len, "p%d", port);
+	if (ret >= len)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	const struct sockaddr *addr = p;
+
+	/* Learn the new net device MAC address in the mac table. */
+	ocelot_mact_learn(ocelot, PGID_CPU, addr->sa_data, ocelot_port->pvid,
+			  ENTRYTYPE_LOCKED);
+	/* Then forget the previous one. */
+	ocelot_mact_forget(ocelot, dev->dev_addr, ocelot_port->pvid);
+
+	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	return 0;
+}
+
+static void ocelot_get_stats64(struct net_device *dev,
+			       struct rtnl_link_stats64 *stats)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	/* Configure the port to read the stats from */
+	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
+		     SYS_STAT_CFG);
+
+	/* Get Rx stats */
+	stats->rx_bytes = ocelot_read(ocelot, SYS_COUNT_RX_OCTETS);
+	stats->rx_packets = ocelot_read(ocelot, SYS_COUNT_RX_SHORTS) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_FRAGMENTS) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_JABBERS) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_LONGS) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_64) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_65_127) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_128_255) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_256_1023) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_1024_1526) +
+			    ocelot_read(ocelot, SYS_COUNT_RX_1527_MAX);
+	stats->multicast = ocelot_read(ocelot, SYS_COUNT_RX_MULTICAST);
+	stats->rx_dropped = dev->stats.rx_dropped;
+
+	/* Get Tx stats */
+	stats->tx_bytes = ocelot_read(ocelot, SYS_COUNT_TX_OCTETS);
+	stats->tx_packets = ocelot_read(ocelot, SYS_COUNT_TX_64) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_65_127) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_128_511) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_512_1023) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_1024_1526) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_1527_MAX);
+	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
+			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
+	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
+}
+
+static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
+			       struct net_device *dev,
+			       const unsigned char *addr,
+			       u16 vid, u16 flags,
+			       struct netlink_ext_ack *extack)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_fdb_add(ocelot, port, addr, vid);
+}
+
+static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
+			       struct net_device *dev,
+			       const unsigned char *addr, u16 vid)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_fdb_del(ocelot, port, addr, vid);
+}
+
+static int ocelot_port_fdb_dump(struct sk_buff *skb,
+				struct netlink_callback *cb,
+				struct net_device *dev,
+				struct net_device *filter_dev, int *idx)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	struct ocelot_dump_ctx dump = {
+		.dev = dev,
+		.skb = skb,
+		.cb = cb,
+		.idx = *idx,
+	};
+	int port = priv->chip_port;
+	int ret;
+
+	ret = ocelot_fdb_dump(ocelot, port, ocelot_port_fdb_do_dump, &dump);
+
+	*idx = dump.idx;
+
+	return ret;
+}
+
+static int ocelot_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
+				  u16 vid)
+{
+	return ocelot_vlan_vid_add(dev, vid, false, false);
+}
+
+static int ocelot_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
+				   u16 vid)
+{
+	return ocelot_vlan_vid_del(dev, vid);
+}
+
+static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
+			     netdev_features_t features)
+{
+	u32 val;
+
+	/* Filtering */
+	val = ocelot_read(ocelot, ANA_VLANMASK);
+	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
+		val |= BIT(port);
+	else
+		val &= ~BIT(port);
+	ocelot_write(ocelot, val, ANA_VLANMASK);
+}
+
+static int ocelot_set_features(struct net_device *dev,
+			       netdev_features_t features)
+{
+	netdev_features_t changed = dev->features ^ features;
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	    priv->tc.offload_cnt) {
+		netdev_err(dev,
+			   "Cannot disable HW TC offload while offloads active\n");
+		return -EBUSY;
+	}
+
+	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER)
+		ocelot_vlan_mode(ocelot, port, features);
+
+	return 0;
+}
+
+static int ocelot_get_port_parent_id(struct net_device *dev,
+				     struct netdev_phys_item_id *ppid)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+
+	ppid->id_len = sizeof(ocelot->base_mac);
+	memcpy(&ppid->id, &ocelot->base_mac, ppid->id_len);
+
+	return 0;
+}
+
+static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	/* If the attached PHY device isn't capable of timestamping operations,
+	 * use our own (when possible).
+	 */
+	if (!phy_has_hwtstamp(dev->phydev) && ocelot->ptp) {
+		switch (cmd) {
+		case SIOCSHWTSTAMP:
+			return ocelot_hwstamp_set(ocelot, port, ifr);
+		case SIOCGHWTSTAMP:
+			return ocelot_hwstamp_get(ocelot, port, ifr);
+		}
+	}
+
+	return phy_mii_ioctl(dev->phydev, ifr, cmd);
+}
+
+static const struct net_device_ops ocelot_port_netdev_ops = {
+	.ndo_open			= ocelot_port_open,
+	.ndo_stop			= ocelot_port_stop,
+	.ndo_start_xmit			= ocelot_port_xmit,
+	.ndo_set_rx_mode		= ocelot_set_rx_mode,
+	.ndo_get_phys_port_name		= ocelot_port_get_phys_port_name,
+	.ndo_set_mac_address		= ocelot_port_set_mac_address,
+	.ndo_get_stats64		= ocelot_get_stats64,
+	.ndo_fdb_add			= ocelot_port_fdb_add,
+	.ndo_fdb_del			= ocelot_port_fdb_del,
+	.ndo_fdb_dump			= ocelot_port_fdb_dump,
+	.ndo_vlan_rx_add_vid		= ocelot_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid		= ocelot_vlan_rx_kill_vid,
+	.ndo_set_features		= ocelot_set_features,
+	.ndo_get_port_parent_id		= ocelot_get_port_parent_id,
+	.ndo_setup_tc			= ocelot_setup_tc,
+	.ndo_do_ioctl			= ocelot_ioctl,
+};
+
+static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
+				    u8 *data)
+{
+	struct ocelot_port_private *priv = netdev_priv(netdev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_get_strings(ocelot, port, sset, data);
+}
+
+static void ocelot_port_get_ethtool_stats(struct net_device *dev,
+					  struct ethtool_stats *stats,
+					  u64 *data)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	ocelot_get_ethtool_stats(ocelot, port, data);
+}
+
+static int ocelot_port_get_sset_count(struct net_device *dev, int sset)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	return ocelot_get_sset_count(ocelot, port, sset);
+}
+
+static int ocelot_port_get_ts_info(struct net_device *dev,
+				   struct ethtool_ts_info *info)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+
+	if (!ocelot->ptp)
+		return ethtool_op_get_ts_info(dev, info);
+
+	return ocelot_get_ts_info(ocelot, port, info);
+}
+
+static const struct ethtool_ops ocelot_ethtool_ops = {
+	.get_strings		= ocelot_port_get_strings,
+	.get_ethtool_stats	= ocelot_port_get_ethtool_stats,
+	.get_sset_count		= ocelot_port_get_sset_count,
+	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
+	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
+	.get_ts_info		= ocelot_port_get_ts_info,
+};
+
+static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
+					   struct switchdev_trans *trans,
+					   u8 state)
+{
+	if (switchdev_trans_ph_prepare(trans))
+		return;
+
+	ocelot_bridge_stp_state_set(ocelot, port, state);
+}
+
+static void ocelot_port_attr_ageing_set(struct ocelot *ocelot, int port,
+					unsigned long ageing_clock_t)
+{
+	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
+	u32 ageing_time = jiffies_to_msecs(ageing_jiffies);
+
+	ocelot_set_ageing_time(ocelot, ageing_time);
+}
+
+static void ocelot_port_attr_mc_set(struct ocelot *ocelot, int port, bool mc)
+{
+	u32 cpu_fwd_mcast = ANA_PORT_CPU_FWD_CFG_CPU_IGMP_REDIR_ENA |
+			    ANA_PORT_CPU_FWD_CFG_CPU_MLD_REDIR_ENA |
+			    ANA_PORT_CPU_FWD_CFG_CPU_IPMC_CTRL_COPY_ENA;
+	u32 val = 0;
+
+	if (mc)
+		val = cpu_fwd_mcast;
+
+	ocelot_rmw_gix(ocelot, val, cpu_fwd_mcast,
+		       ANA_PORT_CPU_FWD_CFG, port);
+}
+
+static int ocelot_port_attr_set(struct net_device *dev,
+				const struct switchdev_attr *attr,
+				struct switchdev_trans *trans)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot *ocelot = priv->port.ocelot;
+	int port = priv->chip_port;
+	int err = 0;
+
+	switch (attr->id) {
+	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
+		ocelot_port_attr_stp_state_set(ocelot, port, trans,
+					       attr->u.stp_state);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
+		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
+		ocelot_port_vlan_filtering(ocelot, port,
+					   attr->u.vlan_filtering);
+		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int ocelot_port_obj_add_vlan(struct net_device *dev,
+				    const struct switchdev_obj_port_vlan *vlan,
+				    struct switchdev_trans *trans)
+{
+	int ret;
+	u16 vid;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		ret = ocelot_vlan_vid_add(dev, vid,
+					  vlan->flags & BRIDGE_VLAN_INFO_PVID,
+					  vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ocelot_port_vlan_del_vlan(struct net_device *dev,
+				     const struct switchdev_obj_port_vlan *vlan)
+{
+	int ret;
+	u16 vid;
+
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		ret = ocelot_vlan_vid_del(dev, vid);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ocelot_port_obj_add(struct net_device *dev,
+			       const struct switchdev_obj *obj,
+			       struct switchdev_trans *trans,
+			       struct netlink_ext_ack *extack)
+{
+	int ret = 0;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		ret = ocelot_port_obj_add_vlan(dev,
+					       SWITCHDEV_OBJ_PORT_VLAN(obj),
+					       trans);
+		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		ret = ocelot_port_obj_add_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj),
+					      trans);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+static int ocelot_port_obj_del(struct net_device *dev,
+			       const struct switchdev_obj *obj)
+{
+	int ret = 0;
+
+	switch (obj->id) {
+	case SWITCHDEV_OBJ_ID_PORT_VLAN:
+		ret = ocelot_port_vlan_del_vlan(dev,
+						SWITCHDEV_OBJ_PORT_VLAN(obj));
+		break;
+	case SWITCHDEV_OBJ_ID_PORT_MDB:
+		ret = ocelot_port_obj_del_mdb(dev, SWITCHDEV_OBJ_PORT_MDB(obj));
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+/* Checks if the net_device instance given to us originate from our driver. */
+static bool ocelot_netdevice_dev_check(const struct net_device *dev)
+{
+	return dev->netdev_ops == &ocelot_port_netdev_ops;
+}
+
+static int ocelot_netdevice_port_event(struct net_device *dev,
+				       unsigned long event,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->chip_port;
+	int err = 0;
+
+	switch (event) {
+	case NETDEV_CHANGEUPPER:
+		if (netif_is_bridge_master(info->upper_dev)) {
+			if (info->linking) {
+				err = ocelot_port_bridge_join(ocelot, port,
+							      info->upper_dev);
+			} else {
+				err = ocelot_port_bridge_leave(ocelot, port,
+							       info->upper_dev);
+			}
+		}
+		if (netif_is_lag_master(info->upper_dev)) {
+			if (info->linking)
+				err = ocelot_port_lag_join(ocelot, port,
+							   info->upper_dev);
+			else
+				ocelot_port_lag_leave(ocelot, port,
+						      info->upper_dev);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ocelot_netdevice_event(struct notifier_block *unused,
+				  unsigned long event, void *ptr)
+{
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int ret = 0;
+
+	if (!ocelot_netdevice_dev_check(dev))
+		return 0;
+
+	if (event == NETDEV_PRECHANGEUPPER &&
+	    netif_is_lag_master(info->upper_dev)) {
+		struct netdev_lag_upper_info *lag_upper_info = info->upper_info;
+		struct netlink_ext_ack *extack;
+
+		if (lag_upper_info &&
+		    lag_upper_info->tx_type != NETDEV_LAG_TX_TYPE_HASH) {
+			extack = netdev_notifier_info_to_extack(&info->info);
+			NL_SET_ERR_MSG_MOD(extack, "LAG device using unsupported Tx type");
+
+			ret = -EINVAL;
+			goto notify;
+		}
+	}
+
+	if (netif_is_lag_master(dev)) {
+		struct net_device *slave;
+		struct list_head *iter;
+
+		netdev_for_each_lower_dev(dev, slave, iter) {
+			ret = ocelot_netdevice_port_event(slave, event, info);
+			if (ret)
+				goto notify;
+		}
+	} else {
+		ret = ocelot_netdevice_port_event(dev, event, info);
+	}
+
+notify:
+	return notifier_from_errno(ret);
+}
+
+struct notifier_block ocelot_netdevice_nb __read_mostly = {
+	.notifier_call = ocelot_netdevice_event,
+};
+EXPORT_SYMBOL(ocelot_netdevice_nb);
+
+static int ocelot_switchdev_event(struct notifier_block *unused,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     ocelot_netdevice_dev_check,
+						     ocelot_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
+}
+
+struct notifier_block ocelot_switchdev_nb __read_mostly = {
+	.notifier_call = ocelot_switchdev_event,
+};
+EXPORT_SYMBOL(ocelot_switchdev_nb);
+
+static int ocelot_switchdev_blocking_event(struct notifier_block *unused,
+					   unsigned long event, void *ptr)
+{
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	int err;
+
+	switch (event) {
+		/* Blocking events. */
+	case SWITCHDEV_PORT_OBJ_ADD:
+		err = switchdev_handle_port_obj_add(dev, ptr,
+						    ocelot_netdevice_dev_check,
+						    ocelot_port_obj_add);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_OBJ_DEL:
+		err = switchdev_handle_port_obj_del(dev, ptr,
+						    ocelot_netdevice_dev_check,
+						    ocelot_port_obj_del);
+		return notifier_from_errno(err);
+	case SWITCHDEV_PORT_ATTR_SET:
+		err = switchdev_handle_port_attr_set(dev, ptr,
+						     ocelot_netdevice_dev_check,
+						     ocelot_port_attr_set);
+		return notifier_from_errno(err);
+	}
+
+	return NOTIFY_DONE;
+}
+
+struct notifier_block ocelot_switchdev_blocking_nb __read_mostly = {
+	.notifier_call = ocelot_switchdev_blocking_event,
+};
+EXPORT_SYMBOL(ocelot_switchdev_blocking_nb);
+
+int ocelot_probe_port(struct ocelot *ocelot, u8 port,
+		      void __iomem *regs,
+		      struct phy_device *phy)
+{
+	struct ocelot_port_private *priv;
+	struct ocelot_port *ocelot_port;
+	struct net_device *dev;
+	int err;
+
+	dev = alloc_etherdev(sizeof(struct ocelot_port_private));
+	if (!dev)
+		return -ENOMEM;
+	SET_NETDEV_DEV(dev, ocelot->dev);
+	priv = netdev_priv(dev);
+	priv->dev = dev;
+	priv->phy = phy;
+	priv->chip_port = port;
+	ocelot_port = &priv->port;
+	ocelot_port->ocelot = ocelot;
+	ocelot_port->regs = regs;
+	ocelot->ports[port] = ocelot_port;
+
+	dev->netdev_ops = &ocelot_port_netdev_ops;
+	dev->ethtool_ops = &ocelot_ethtool_ops;
+
+	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
+		NETIF_F_HW_TC;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
+
+	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
+	dev->dev_addr[ETH_ALEN - 1] += port;
+	ocelot_mact_learn(ocelot, PGID_CPU, dev->dev_addr, ocelot_port->pvid,
+			  ENTRYTYPE_LOCKED);
+
+	ocelot_init_port(ocelot, port);
+
+	err = register_netdev(dev);
+	if (err) {
+		dev_err(ocelot->dev, "register_netdev failed\n");
+		free_netdev(dev);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(ocelot_probe_port);
diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
index 2e1d8e187332..6f5068c1041a 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.c
+++ b/drivers/net/ethernet/mscc/ocelot_police.c
@@ -7,16 +7,6 @@
 #include <soc/mscc/ocelot.h>
 #include "ocelot_police.h"
 
-enum mscc_qos_rate_mode {
-	MSCC_QOS_RATE_MODE_DISABLED, /* Policer/shaper disabled */
-	MSCC_QOS_RATE_MODE_LINE, /* Measure line rate in kbps incl. IPG */
-	MSCC_QOS_RATE_MODE_DATA, /* Measures data rate in kbps excl. IPG */
-	MSCC_QOS_RATE_MODE_FRAME, /* Measures frame rate in fps */
-	__MSCC_QOS_RATE_MODE_END,
-	NUM_MSCC_QOS_RATE_MODE = __MSCC_QOS_RATE_MODE_END,
-	MSCC_QOS_RATE_MODE_MAX = __MSCC_QOS_RATE_MODE_END - 1,
-};
-
 /* Types for ANA:POL[0-192]:POL_MODE_CFG.FRM_MODE */
 #define POL_MODE_LINERATE   0 /* Incl IPG. Unit: 33 1/3 kbps, 4096 bytes */
 #define POL_MODE_DATARATE   1 /* Excl IPG. Unit: 33 1/3 kbps, 4096 bytes  */
@@ -30,19 +20,8 @@ enum mscc_qos_rate_mode {
 /* Default policer order */
 #define POL_ORDER 0x1d3 /* Ocelot policer order: Serial (QoS -> Port -> VCAP) */
 
-struct qos_policer_conf {
-	enum mscc_qos_rate_mode mode;
-	bool dlb; /* Enable DLB (dual leaky bucket mode */
-	bool cf;  /* Coupling flag (ignored in SLB mode) */
-	u32  cir; /* CIR in kbps/fps (ignored in SLB mode) */
-	u32  cbs; /* CBS in bytes/frames (ignored in SLB mode) */
-	u32  pir; /* PIR in kbps/fps */
-	u32  pbs; /* PBS in bytes/frames */
-	u8   ipg; /* Size of IPG when MSCC_QOS_RATE_MODE_LINE is chosen */
-};
-
-static int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
-				struct qos_policer_conf *conf)
+int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
+			 struct qos_policer_conf *conf)
 {
 	u32 cf = 0, cir_ena = 0, frm_mode = POL_MODE_LINERATE;
 	u32 cir = 0, cbs = 0, pir = 0, pbs = 0;
@@ -228,27 +207,3 @@ int ocelot_port_policer_del(struct ocelot *ocelot, int port)
 	return 0;
 }
 EXPORT_SYMBOL(ocelot_port_policer_del);
-
-int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
-			   struct ocelot_policer *pol)
-{
-	struct qos_policer_conf pp = { 0 };
-
-	if (!pol)
-		return -EINVAL;
-
-	pp.mode = MSCC_QOS_RATE_MODE_DATA;
-	pp.pir = pol->rate;
-	pp.pbs = pol->burst;
-
-	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
-}
-
-int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix)
-{
-	struct qos_policer_conf pp = { 0 };
-
-	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
-
-	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
-}
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index 792abd28010a..79d18442aa9b 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -9,6 +9,30 @@
 
 #include "ocelot.h"
 
+enum mscc_qos_rate_mode {
+	MSCC_QOS_RATE_MODE_DISABLED, /* Policer/shaper disabled */
+	MSCC_QOS_RATE_MODE_LINE, /* Measure line rate in kbps incl. IPG */
+	MSCC_QOS_RATE_MODE_DATA, /* Measures data rate in kbps excl. IPG */
+	MSCC_QOS_RATE_MODE_FRAME, /* Measures frame rate in fps */
+	__MSCC_QOS_RATE_MODE_END,
+	NUM_MSCC_QOS_RATE_MODE = __MSCC_QOS_RATE_MODE_END,
+	MSCC_QOS_RATE_MODE_MAX = __MSCC_QOS_RATE_MODE_END - 1,
+};
+
+struct qos_policer_conf {
+	enum mscc_qos_rate_mode mode;
+	bool dlb; /* Enable DLB (dual leaky bucket mode */
+	bool cf;  /* Coupling flag (ignored in SLB mode) */
+	u32  cir; /* CIR in kbps/fps (ignored in SLB mode) */
+	u32  cbs; /* CBS in bytes/frames (ignored in SLB mode) */
+	u32  pir; /* PIR in kbps/fps */
+	u32  pbs; /* PBS in bytes/frames */
+	u8   ipg; /* Size of IPG when MSCC_QOS_RATE_MODE_LINE is chosen */
+};
+
+int qos_policer_conf_set(struct ocelot *ocelot, int port, u32 pol_ix,
+			 struct qos_policer_conf *conf);
+
 int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
 			   struct ocelot_policer *pol);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
deleted file mode 100644
index b7baf7624e18..000000000000
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ /dev/null
@@ -1,179 +0,0 @@
-// SPDX-License-Identifier: (GPL-2.0 OR MIT)
-/* Microsemi Ocelot Switch TC driver
- *
- * Copyright (c) 2019 Microsemi Corporation
- */
-
-#include <soc/mscc/ocelot.h>
-#include "ocelot_tc.h"
-#include "ocelot_ace.h"
-#include <net/pkt_cls.h>
-
-static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
-					struct tc_cls_matchall_offload *f,
-					bool ingress)
-{
-	struct netlink_ext_ack *extack = f->common.extack;
-	struct ocelot *ocelot = priv->port.ocelot;
-	struct ocelot_policer pol = { 0 };
-	struct flow_action_entry *action;
-	int port = priv->chip_port;
-	int err;
-
-	if (!ingress) {
-		NL_SET_ERR_MSG_MOD(extack, "Only ingress is supported");
-		return -EOPNOTSUPP;
-	}
-
-	switch (f->command) {
-	case TC_CLSMATCHALL_REPLACE:
-		if (!flow_offload_has_one_action(&f->rule->action)) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Only one action is supported");
-			return -EOPNOTSUPP;
-		}
-
-		if (priv->tc.block_shared) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Rate limit is not supported on shared blocks");
-			return -EOPNOTSUPP;
-		}
-
-		action = &f->rule->action.entries[0];
-
-		if (action->id != FLOW_ACTION_POLICE) {
-			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
-			return -EOPNOTSUPP;
-		}
-
-		if (priv->tc.police_id && priv->tc.police_id != f->cookie) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Only one policer per port is supported");
-			return -EEXIST;
-		}
-
-		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
-		pol.burst = (u32)div_u64(action->police.rate_bytes_ps *
-					 PSCHED_NS2TICKS(action->police.burst),
-					 PSCHED_TICKS_PER_SEC);
-
-		err = ocelot_port_policer_add(ocelot, port, &pol);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack, "Could not add policer");
-			return err;
-		}
-
-		priv->tc.police_id = f->cookie;
-		priv->tc.offload_cnt++;
-		return 0;
-	case TC_CLSMATCHALL_DESTROY:
-		if (priv->tc.police_id != f->cookie)
-			return -ENOENT;
-
-		err = ocelot_port_policer_del(ocelot, port);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Could not delete policer");
-			return err;
-		}
-		priv->tc.police_id = 0;
-		priv->tc.offload_cnt--;
-		return 0;
-	case TC_CLSMATCHALL_STATS: /* fall through */
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int ocelot_setup_tc_block_cb(enum tc_setup_type type,
-				    void *type_data,
-				    void *cb_priv, bool ingress)
-{
-	struct ocelot_port_private *priv = cb_priv;
-
-	if (!tc_cls_can_offload_and_chain0(priv->dev, type_data))
-		return -EOPNOTSUPP;
-
-	switch (type) {
-	case TC_SETUP_CLSMATCHALL:
-		return ocelot_setup_tc_cls_matchall(priv, type_data, ingress);
-	case TC_SETUP_CLSFLOWER:
-		return ocelot_setup_tc_cls_flower(priv, type_data, ingress);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-static int ocelot_setup_tc_block_cb_ig(enum tc_setup_type type,
-				       void *type_data,
-				       void *cb_priv)
-{
-	return ocelot_setup_tc_block_cb(type, type_data,
-					cb_priv, true);
-}
-
-static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
-				       void *type_data,
-				       void *cb_priv)
-{
-	return ocelot_setup_tc_block_cb(type, type_data,
-					cb_priv, false);
-}
-
-static LIST_HEAD(ocelot_block_cb_list);
-
-static int ocelot_setup_tc_block(struct ocelot_port_private *priv,
-				 struct flow_block_offload *f)
-{
-	struct flow_block_cb *block_cb;
-	flow_setup_cb_t *cb;
-
-	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
-		cb = ocelot_setup_tc_block_cb_ig;
-		priv->tc.block_shared = f->block_shared;
-	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
-		cb = ocelot_setup_tc_block_cb_eg;
-	} else {
-		return -EOPNOTSUPP;
-	}
-
-	f->driver_block_list = &ocelot_block_cb_list;
-
-	switch (f->command) {
-	case FLOW_BLOCK_BIND:
-		if (flow_block_cb_is_busy(cb, priv, &ocelot_block_cb_list))
-			return -EBUSY;
-
-		block_cb = flow_block_cb_alloc(cb, priv, priv, NULL);
-		if (IS_ERR(block_cb))
-			return PTR_ERR(block_cb);
-
-		flow_block_cb_add(block_cb, f);
-		list_add_tail(&block_cb->driver_list, f->driver_block_list);
-		return 0;
-	case FLOW_BLOCK_UNBIND:
-		block_cb = flow_block_cb_lookup(f->block, cb, priv);
-		if (!block_cb)
-			return -ENOENT;
-
-		flow_block_cb_remove(block_cb, f);
-		list_del(&block_cb->driver_list);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
-		    void *type_data)
-{
-	struct ocelot_port_private *priv = netdev_priv(dev);
-
-	switch (type) {
-	case TC_SETUP_BLOCK:
-		return ocelot_setup_tc_block(priv, type_data);
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.h b/drivers/net/ethernet/mscc/ocelot_tc.h
deleted file mode 100644
index 61757c2250a6..000000000000
--- a/drivers/net/ethernet/mscc/ocelot_tc.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
-/* Microsemi Ocelot Switch driver
- *
- * Copyright (c) 2019 Microsemi Corporation
- */
-
-#ifndef _MSCC_OCELOT_TC_H_
-#define _MSCC_OCELOT_TC_H_
-
-#include <linux/netdevice.h>
-
-struct ocelot_port_tc {
-	bool block_shared;
-	unsigned long offload_cnt;
-
-	unsigned long police_id;
-};
-
-int ocelot_setup_tc(struct net_device *dev, enum tc_setup_type type,
-		    void *type_data);
-
-#endif /* _MSCC_OCELOT_TC_H_ */
-- 
2.25.1

