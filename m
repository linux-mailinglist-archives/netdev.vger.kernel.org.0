Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBDBFC979
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfKNPE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:29 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38946 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfKNPE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:28 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so6276792wmi.4
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2cx+9YOo7Mlj7egzgVJbwQpYal/KzGWpVC/A/Xr2ncg=;
        b=MgrgT0Jv9te+mcrT4KMpp/ZRyhLRwcD/bXoalJ1mcGR/ULiYHoyLdcLsk979+p9Das
         PXtV6Uevv0VyQljmladx/aaFm7NmRN//9WcZNjOuOblY8wrDgZCMJYmr9FjmCs2ggLxg
         90R+xEB3dLgpkZ+95zOJz70fVmaOvwGuCqBnCo2M+Pb2VS/f3pTcFWuM3k9BhQGc/bPM
         Q1XlNFI8m+HuD+UnydBHzke8Q/+wTi1KsKLuLye8sjfFuvA2q/FyFCrD1HTlpCAm/Ry+
         HqRpfbG4Ke1bSDbqqVK7geWk4q6Gu0j7PrRjof6AZMps6B1A+nlT1HbuJt2E/diq9fFd
         OGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2cx+9YOo7Mlj7egzgVJbwQpYal/KzGWpVC/A/Xr2ncg=;
        b=e2nQ15iBS7iswMO8LcpYk41gGvQN4U14ZDbVFIcB3ZLv2xl3jvNxzlxhuCQW37pduT
         CEdeu+gqN9jhIgqx9g7eglMP97x0zMVRJT6wmnyMGyukeVWO9E2FuornDydx2ht/gqnw
         ll2wZqVXrM54X5zI8wASPSAMObmGh/NFSoaJHsM+BR/N9YD/Q4RCXrJEmcVJ91v/ZpkH
         WrBnYrkLLPeaHyd47P6OvwOMQwrFLJ/1NBOtaQt6Q95Vdm3koZBMnmzhR84g/Cj4dt/q
         BlZgguedhfYRAwcMMot657MlXYs23wl4wWFgGIAta1ECoHGlfjD8RNsKLgSLAebm6scF
         BoYA==
X-Gm-Message-State: APjAAAXvmUq34+ftDIyCzoYcUUoiUVFf2hsZdwhbpk4+SPniEZZtItVw
        fJ1XCkGcnPuJSsbGBnoCabM=
X-Google-Smtp-Source: APXvYqxFxZLsnRHYpbzNTZophowT+q68zgubAnGGztI/n6cG8eJBl8hN0DbSHiAItzPQN13c+Uf2bw==
X-Received: by 2002:a1c:7209:: with SMTP id n9mr8369975wmc.9.1573743862512;
        Thu, 14 Nov 2019 07:04:22 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:21 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 08/11] net: mscc: ocelot: publish structure definitions to include/soc/mscc/ocelot.h
Date:   Thu, 14 Nov 2019 17:03:27 +0200
Message-Id: <20191114150330.25856-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114150330.25856-1-olteanv@gmail.com>
References: <20191114150330.25856-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We will be registering another switch driver based on ocelot, which
lives under drivers/net/dsa.

Make sure the Felix DSA front-end has the necessary abstractions to
implement a new Ocelot driver instantiation. This includes the function
prototypes for implementing DSA callbacks.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
- Fixed an overzealous removal of EXPORT_SYMBOL(ocelot_probe_port) which
  was causing a build failure.
- Removed stubs for the case where MSCC_OCELOT_SWITCH is not enabled.

 drivers/net/ethernet/mscc/ocelot.c |  78 +++--
 drivers/net/ethernet/mscc/ocelot.h | 482 +-------------------------
 include/soc/mscc/ocelot.h          | 539 +++++++++++++++++++++++++++++
 3 files changed, 588 insertions(+), 511 deletions(-)
 create mode 100644 include/soc/mscc/ocelot.h

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 961f9a7c01e3..90c46ba763d7 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -21,7 +21,6 @@
 #include <net/netevent.h>
 #include <net/rtnetlink.h>
 #include <net/switchdev.h>
-#include <net/dsa.h>
 
 #include "ocelot.h"
 #include "ocelot_ace.h"
@@ -184,8 +183,8 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 	ocelot_write(ocelot, val, ANA_VLANMASK);
 }
 
-static void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-				       bool vlan_aware)
+void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
+				bool vlan_aware)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 val;
@@ -230,6 +229,7 @@ static void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 		       REW_TAG_CFG_TAG_CFG_M,
 		       REW_TAG_CFG, port);
 }
+EXPORT_SYMBOL(ocelot_port_vlan_filtering);
 
 static int ocelot_port_set_native_vlan(struct ocelot *ocelot, int port,
 				       u16 vid)
@@ -267,8 +267,8 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port, u16 pvid)
 	ocelot_port->pvid = pvid;
 }
 
-static int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
-			   bool untagged)
+int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
+		    bool untagged)
 {
 	int ret;
 
@@ -291,6 +291,7 @@ static int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_vlan_add);
 
 static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 			       bool untagged)
@@ -312,7 +313,7 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 	return 0;
 }
 
-static int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
+int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int ret;
@@ -333,6 +334,7 @@ static int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_vlan_del);
 
 static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 {
@@ -404,8 +406,8 @@ static u16 ocelot_wm_enc(u16 value)
 	return value;
 }
 
-static void ocelot_adjust_link(struct ocelot *ocelot, int port,
-			       struct phy_device *phydev)
+void ocelot_adjust_link(struct ocelot *ocelot, int port,
+			struct phy_device *phydev)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int speed, mode = 0;
@@ -471,6 +473,7 @@ static void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			 SYS_MAC_FC_CFG, port);
 	ocelot_write_rix(ocelot, 0, ANA_POL_FLOWC, port);
 }
+EXPORT_SYMBOL(ocelot_adjust_link);
 
 static void ocelot_port_adjust_link(struct net_device *dev)
 {
@@ -481,8 +484,8 @@ static void ocelot_port_adjust_link(struct net_device *dev)
 	ocelot_adjust_link(ocelot, port, dev->phydev);
 }
 
-static void ocelot_port_enable(struct ocelot *ocelot, int port,
-			       struct phy_device *phy)
+void ocelot_port_enable(struct ocelot *ocelot, int port,
+			struct phy_device *phy)
 {
 	/* Enable receiving frames on the port, and activate auto-learning of
 	 * MAC addresses.
@@ -492,6 +495,7 @@ static void ocelot_port_enable(struct ocelot *ocelot, int port,
 			 ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 }
+EXPORT_SYMBOL(ocelot_port_enable);
 
 static int ocelot_port_open(struct net_device *dev)
 {
@@ -526,7 +530,7 @@ static int ocelot_port_open(struct net_device *dev)
 	return 0;
 }
 
-static void ocelot_port_disable(struct ocelot *ocelot, int port)
+void ocelot_port_disable(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -534,6 +538,7 @@ static void ocelot_port_disable(struct ocelot *ocelot, int port)
 	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
 		       QSYS_SWITCH_PORT_MODE, port);
 }
+EXPORT_SYMBOL(ocelot_port_disable);
 
 static int ocelot_port_stop(struct net_device *dev)
 {
@@ -790,9 +795,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
 }
 
-static int ocelot_fdb_add(struct ocelot *ocelot, int port,
-			  const unsigned char *addr, u16 vid,
-			  bool vlan_aware)
+int ocelot_fdb_add(struct ocelot *ocelot, int port,
+		   const unsigned char *addr, u16 vid, bool vlan_aware)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -812,6 +816,7 @@ static int ocelot_fdb_add(struct ocelot *ocelot, int port,
 
 	return ocelot_mact_learn(ocelot, port, addr, vid, ENTRYTYPE_LOCKED);
 }
+EXPORT_SYMBOL(ocelot_fdb_add);
 
 static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct net_device *dev,
@@ -826,11 +831,12 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	return ocelot_fdb_add(ocelot, port, addr, vid, priv->vlan_aware);
 }
 
-static int ocelot_fdb_del(struct ocelot *ocelot, int port,
-			  const unsigned char *addr, u16 vid)
+int ocelot_fdb_del(struct ocelot *ocelot, int port,
+		   const unsigned char *addr, u16 vid)
 {
 	return ocelot_mact_forget(ocelot, addr, vid);
 }
+EXPORT_SYMBOL(ocelot_fdb_del);
 
 static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct net_device *dev,
@@ -940,8 +946,8 @@ static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 	return 0;
 }
 
-static int ocelot_fdb_dump(struct ocelot *ocelot, int port,
-			   dsa_fdb_dump_cb_t *cb, void *data)
+int ocelot_fdb_dump(struct ocelot *ocelot, int port,
+		    dsa_fdb_dump_cb_t *cb, void *data)
 {
 	int i, j;
 
@@ -973,6 +979,7 @@ static int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_fdb_dump);
 
 static int ocelot_port_fdb_dump(struct sk_buff *skb,
 				struct netlink_callback *cb,
@@ -1153,8 +1160,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_do_ioctl			= ocelot_ioctl,
 };
 
-static void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset,
-			       u8 *data)
+void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 {
 	int i;
 
@@ -1165,6 +1171,7 @@ static void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset,
 		memcpy(data + i * ETH_GSTRING_LEN, ocelot->stats_layout[i].name,
 		       ETH_GSTRING_LEN);
 }
+EXPORT_SYMBOL(ocelot_get_strings);
 
 static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
 				    u8 *data)
@@ -1216,7 +1223,7 @@ static void ocelot_check_stats_work(struct work_struct *work)
 			   OCELOT_STATS_CHECK_DELAY);
 }
 
-static void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
+void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 {
 	int i;
 
@@ -1227,6 +1234,7 @@ static void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data)
 	for (i = 0; i < ocelot->num_stats; i++)
 		*data++ = ocelot->stats[port * ocelot->num_stats + i];
 }
+EXPORT_SYMBOL(ocelot_get_ethtool_stats);
 
 static void ocelot_port_get_ethtool_stats(struct net_device *dev,
 					  struct ethtool_stats *stats,
@@ -1239,13 +1247,14 @@ static void ocelot_port_get_ethtool_stats(struct net_device *dev,
 	ocelot_get_ethtool_stats(ocelot, port, data);
 }
 
-static int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
+int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 {
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
 
 	return ocelot->num_stats;
 }
+EXPORT_SYMBOL(ocelot_get_sset_count);
 
 static int ocelot_port_get_sset_count(struct net_device *dev, int sset)
 {
@@ -1256,8 +1265,8 @@ static int ocelot_port_get_sset_count(struct net_device *dev, int sset)
 	return ocelot_get_sset_count(ocelot, port, sset);
 }
 
-static int ocelot_get_ts_info(struct ocelot *ocelot, int port,
-			      struct ethtool_ts_info *info)
+int ocelot_get_ts_info(struct ocelot *ocelot, int port,
+		       struct ethtool_ts_info *info)
 {
 	info->phc_index = ocelot->ptp_clock ?
 			  ptp_clock_index(ocelot->ptp_clock) : -1;
@@ -1273,6 +1282,7 @@ static int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_get_ts_info);
 
 static int ocelot_port_get_ts_info(struct net_device *dev,
 				   struct ethtool_ts_info *info)
@@ -1296,8 +1306,7 @@ static const struct ethtool_ops ocelot_ethtool_ops = {
 	.get_ts_info		= ocelot_port_get_ts_info,
 };
 
-static void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port,
-					u8 state)
+void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	u32 port_cfg;
 	int p, i;
@@ -1358,6 +1367,7 @@ static void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port,
 		}
 	}
 }
+EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
 
 static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
 					   struct switchdev_trans *trans,
@@ -1369,11 +1379,12 @@ static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
 	ocelot_bridge_stp_state_set(ocelot, port, state);
 }
 
-static void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
+void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
 {
 	ocelot_write(ocelot, ANA_AUTOAGE_AGE_PERIOD(msecs / 2),
 		     ANA_AUTOAGE);
 }
+EXPORT_SYMBOL(ocelot_set_ageing_time);
 
 static void ocelot_port_attr_ageing_set(struct ocelot *ocelot, int port,
 					unsigned long ageing_clock_t)
@@ -1604,8 +1615,8 @@ static int ocelot_port_obj_del(struct net_device *dev,
 	return ret;
 }
 
-static int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
-				   struct net_device *bridge)
+int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
+			    struct net_device *bridge)
 {
 	if (!ocelot->bridge_mask) {
 		ocelot->hw_bridge_dev = bridge;
@@ -1620,9 +1631,10 @@ static int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_port_bridge_join);
 
-static int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
-				    struct net_device *bridge)
+int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
+			     struct net_device *bridge)
 {
 	ocelot->bridge_mask &= ~BIT(port);
 
@@ -1633,6 +1645,7 @@ static int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 	ocelot_port_set_pvid(ocelot, port, 0);
 	return ocelot_port_set_native_vlan(ocelot, port, 0);
 }
+EXPORT_SYMBOL(ocelot_port_bridge_leave);
 
 static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 {
@@ -2119,7 +2132,7 @@ static void ocelot_port_set_mtu(struct ocelot *ocelot, int port, size_t mtu)
 	ocelot_write(ocelot, ocelot_wm_enc(atop_wm), SYS_ATOP_TOT_CFG);
 }
 
-static void ocelot_init_port(struct ocelot *ocelot, int port)
+void ocelot_init_port(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
@@ -2166,6 +2179,7 @@ static void ocelot_init_port(struct ocelot *ocelot, int port)
 	/* Enable vcap lookups */
 	ocelot_vcap_enable(ocelot, port);
 }
+EXPORT_SYMBOL(ocelot_init_port);
 
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 199ca2d6ea32..325afea3e846 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -18,6 +18,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/regmap.h>
 
+#include <soc/mscc/ocelot.h>
 #include "ocelot_ana.h"
 #include "ocelot_dev.h"
 #include "ocelot_qsys.h"
@@ -52,376 +53,6 @@ struct frame_info {
 	u32 timestamp;	/* rew_val */
 };
 
-#define IFH_INJ_BYPASS	BIT(31)
-#define IFH_INJ_POP_CNT_DISABLE (3 << 28)
-
-#define IFH_TAG_TYPE_C 0
-#define IFH_TAG_TYPE_S 1
-
-#define IFH_REW_OP_NOOP			0x0
-#define IFH_REW_OP_DSCP			0x1
-#define IFH_REW_OP_ONE_STEP_PTP		0x2
-#define IFH_REW_OP_TWO_STEP_PTP		0x3
-#define IFH_REW_OP_ORIGIN_PTP		0x5
-
-#define OCELOT_TAG_LEN			16
-#define OCELOT_SHORT_PREFIX_LEN		4
-#define OCELOT_LONG_PREFIX_LEN		16
-
-#define OCELOT_SPEED_2500 0
-#define OCELOT_SPEED_1000 1
-#define OCELOT_SPEED_100  2
-#define OCELOT_SPEED_10   3
-
-#define TARGET_OFFSET 24
-#define REG_MASK GENMASK(TARGET_OFFSET - 1, 0)
-#define REG(reg, offset) [reg & REG_MASK] = offset
-
-enum ocelot_target {
-	ANA = 1,
-	QS,
-	QSYS,
-	REW,
-	SYS,
-	S2,
-	HSIO,
-	PTP,
-	TARGET_MAX,
-};
-
-enum ocelot_reg {
-	ANA_ADVLEARN = ANA << TARGET_OFFSET,
-	ANA_VLANMASK,
-	ANA_PORT_B_DOMAIN,
-	ANA_ANAGEFIL,
-	ANA_ANEVENTS,
-	ANA_STORMLIMIT_BURST,
-	ANA_STORMLIMIT_CFG,
-	ANA_ISOLATED_PORTS,
-	ANA_COMMUNITY_PORTS,
-	ANA_AUTOAGE,
-	ANA_MACTOPTIONS,
-	ANA_LEARNDISC,
-	ANA_AGENCTRL,
-	ANA_MIRRORPORTS,
-	ANA_EMIRRORPORTS,
-	ANA_FLOODING,
-	ANA_FLOODING_IPMC,
-	ANA_SFLOW_CFG,
-	ANA_PORT_MODE,
-	ANA_CUT_THRU_CFG,
-	ANA_PGID_PGID,
-	ANA_TABLES_ANMOVED,
-	ANA_TABLES_MACHDATA,
-	ANA_TABLES_MACLDATA,
-	ANA_TABLES_STREAMDATA,
-	ANA_TABLES_MACACCESS,
-	ANA_TABLES_MACTINDX,
-	ANA_TABLES_VLANACCESS,
-	ANA_TABLES_VLANTIDX,
-	ANA_TABLES_ISDXACCESS,
-	ANA_TABLES_ISDXTIDX,
-	ANA_TABLES_ENTRYLIM,
-	ANA_TABLES_PTP_ID_HIGH,
-	ANA_TABLES_PTP_ID_LOW,
-	ANA_TABLES_STREAMACCESS,
-	ANA_TABLES_STREAMTIDX,
-	ANA_TABLES_SEQ_HISTORY,
-	ANA_TABLES_SEQ_MASK,
-	ANA_TABLES_SFID_MASK,
-	ANA_TABLES_SFIDACCESS,
-	ANA_TABLES_SFIDTIDX,
-	ANA_MSTI_STATE,
-	ANA_OAM_UPM_LM_CNT,
-	ANA_SG_ACCESS_CTRL,
-	ANA_SG_CONFIG_REG_1,
-	ANA_SG_CONFIG_REG_2,
-	ANA_SG_CONFIG_REG_3,
-	ANA_SG_CONFIG_REG_4,
-	ANA_SG_CONFIG_REG_5,
-	ANA_SG_GCL_GS_CONFIG,
-	ANA_SG_GCL_TI_CONFIG,
-	ANA_SG_STATUS_REG_1,
-	ANA_SG_STATUS_REG_2,
-	ANA_SG_STATUS_REG_3,
-	ANA_PORT_VLAN_CFG,
-	ANA_PORT_DROP_CFG,
-	ANA_PORT_QOS_CFG,
-	ANA_PORT_VCAP_CFG,
-	ANA_PORT_VCAP_S1_KEY_CFG,
-	ANA_PORT_VCAP_S2_CFG,
-	ANA_PORT_PCP_DEI_MAP,
-	ANA_PORT_CPU_FWD_CFG,
-	ANA_PORT_CPU_FWD_BPDU_CFG,
-	ANA_PORT_CPU_FWD_GARP_CFG,
-	ANA_PORT_CPU_FWD_CCM_CFG,
-	ANA_PORT_PORT_CFG,
-	ANA_PORT_POL_CFG,
-	ANA_PORT_PTP_CFG,
-	ANA_PORT_PTP_DLY1_CFG,
-	ANA_PORT_PTP_DLY2_CFG,
-	ANA_PORT_SFID_CFG,
-	ANA_PFC_PFC_CFG,
-	ANA_PFC_PFC_TIMER,
-	ANA_IPT_OAM_MEP_CFG,
-	ANA_IPT_IPT,
-	ANA_PPT_PPT,
-	ANA_FID_MAP_FID_MAP,
-	ANA_AGGR_CFG,
-	ANA_CPUQ_CFG,
-	ANA_CPUQ_CFG2,
-	ANA_CPUQ_8021_CFG,
-	ANA_DSCP_CFG,
-	ANA_DSCP_REWR_CFG,
-	ANA_VCAP_RNG_TYPE_CFG,
-	ANA_VCAP_RNG_VAL_CFG,
-	ANA_VRAP_CFG,
-	ANA_VRAP_HDR_DATA,
-	ANA_VRAP_HDR_MASK,
-	ANA_DISCARD_CFG,
-	ANA_FID_CFG,
-	ANA_POL_PIR_CFG,
-	ANA_POL_CIR_CFG,
-	ANA_POL_MODE_CFG,
-	ANA_POL_PIR_STATE,
-	ANA_POL_CIR_STATE,
-	ANA_POL_STATE,
-	ANA_POL_FLOWC,
-	ANA_POL_HYST,
-	ANA_POL_MISC_CFG,
-	QS_XTR_GRP_CFG = QS << TARGET_OFFSET,
-	QS_XTR_RD,
-	QS_XTR_FRM_PRUNING,
-	QS_XTR_FLUSH,
-	QS_XTR_DATA_PRESENT,
-	QS_XTR_CFG,
-	QS_INJ_GRP_CFG,
-	QS_INJ_WR,
-	QS_INJ_CTRL,
-	QS_INJ_STATUS,
-	QS_INJ_ERR,
-	QS_INH_DBG,
-	QSYS_PORT_MODE = QSYS << TARGET_OFFSET,
-	QSYS_SWITCH_PORT_MODE,
-	QSYS_STAT_CNT_CFG,
-	QSYS_EEE_CFG,
-	QSYS_EEE_THRES,
-	QSYS_IGR_NO_SHARING,
-	QSYS_EGR_NO_SHARING,
-	QSYS_SW_STATUS,
-	QSYS_EXT_CPU_CFG,
-	QSYS_PAD_CFG,
-	QSYS_CPU_GROUP_MAP,
-	QSYS_QMAP,
-	QSYS_ISDX_SGRP,
-	QSYS_TIMED_FRAME_ENTRY,
-	QSYS_TFRM_MISC,
-	QSYS_TFRM_PORT_DLY,
-	QSYS_TFRM_TIMER_CFG_1,
-	QSYS_TFRM_TIMER_CFG_2,
-	QSYS_TFRM_TIMER_CFG_3,
-	QSYS_TFRM_TIMER_CFG_4,
-	QSYS_TFRM_TIMER_CFG_5,
-	QSYS_TFRM_TIMER_CFG_6,
-	QSYS_TFRM_TIMER_CFG_7,
-	QSYS_TFRM_TIMER_CFG_8,
-	QSYS_RED_PROFILE,
-	QSYS_RES_QOS_MODE,
-	QSYS_RES_CFG,
-	QSYS_RES_STAT,
-	QSYS_EGR_DROP_MODE,
-	QSYS_EQ_CTRL,
-	QSYS_EVENTS_CORE,
-	QSYS_QMAXSDU_CFG_0,
-	QSYS_QMAXSDU_CFG_1,
-	QSYS_QMAXSDU_CFG_2,
-	QSYS_QMAXSDU_CFG_3,
-	QSYS_QMAXSDU_CFG_4,
-	QSYS_QMAXSDU_CFG_5,
-	QSYS_QMAXSDU_CFG_6,
-	QSYS_QMAXSDU_CFG_7,
-	QSYS_PREEMPTION_CFG,
-	QSYS_CIR_CFG,
-	QSYS_EIR_CFG,
-	QSYS_SE_CFG,
-	QSYS_SE_DWRR_CFG,
-	QSYS_SE_CONNECT,
-	QSYS_SE_DLB_SENSE,
-	QSYS_CIR_STATE,
-	QSYS_EIR_STATE,
-	QSYS_SE_STATE,
-	QSYS_HSCH_MISC_CFG,
-	QSYS_TAG_CONFIG,
-	QSYS_TAS_PARAM_CFG_CTRL,
-	QSYS_PORT_MAX_SDU,
-	QSYS_PARAM_CFG_REG_1,
-	QSYS_PARAM_CFG_REG_2,
-	QSYS_PARAM_CFG_REG_3,
-	QSYS_PARAM_CFG_REG_4,
-	QSYS_PARAM_CFG_REG_5,
-	QSYS_GCL_CFG_REG_1,
-	QSYS_GCL_CFG_REG_2,
-	QSYS_PARAM_STATUS_REG_1,
-	QSYS_PARAM_STATUS_REG_2,
-	QSYS_PARAM_STATUS_REG_3,
-	QSYS_PARAM_STATUS_REG_4,
-	QSYS_PARAM_STATUS_REG_5,
-	QSYS_PARAM_STATUS_REG_6,
-	QSYS_PARAM_STATUS_REG_7,
-	QSYS_PARAM_STATUS_REG_8,
-	QSYS_PARAM_STATUS_REG_9,
-	QSYS_GCL_STATUS_REG_1,
-	QSYS_GCL_STATUS_REG_2,
-	REW_PORT_VLAN_CFG = REW << TARGET_OFFSET,
-	REW_TAG_CFG,
-	REW_PORT_CFG,
-	REW_DSCP_CFG,
-	REW_PCP_DEI_QOS_MAP_CFG,
-	REW_PTP_CFG,
-	REW_PTP_DLY1_CFG,
-	REW_RED_TAG_CFG,
-	REW_DSCP_REMAP_DP1_CFG,
-	REW_DSCP_REMAP_CFG,
-	REW_STAT_CFG,
-	REW_REW_STICKY,
-	REW_PPT,
-	SYS_COUNT_RX_OCTETS = SYS << TARGET_OFFSET,
-	SYS_COUNT_RX_UNICAST,
-	SYS_COUNT_RX_MULTICAST,
-	SYS_COUNT_RX_BROADCAST,
-	SYS_COUNT_RX_SHORTS,
-	SYS_COUNT_RX_FRAGMENTS,
-	SYS_COUNT_RX_JABBERS,
-	SYS_COUNT_RX_CRC_ALIGN_ERRS,
-	SYS_COUNT_RX_SYM_ERRS,
-	SYS_COUNT_RX_64,
-	SYS_COUNT_RX_65_127,
-	SYS_COUNT_RX_128_255,
-	SYS_COUNT_RX_256_1023,
-	SYS_COUNT_RX_1024_1526,
-	SYS_COUNT_RX_1527_MAX,
-	SYS_COUNT_RX_PAUSE,
-	SYS_COUNT_RX_CONTROL,
-	SYS_COUNT_RX_LONGS,
-	SYS_COUNT_RX_CLASSIFIED_DROPS,
-	SYS_COUNT_TX_OCTETS,
-	SYS_COUNT_TX_UNICAST,
-	SYS_COUNT_TX_MULTICAST,
-	SYS_COUNT_TX_BROADCAST,
-	SYS_COUNT_TX_COLLISION,
-	SYS_COUNT_TX_DROPS,
-	SYS_COUNT_TX_PAUSE,
-	SYS_COUNT_TX_64,
-	SYS_COUNT_TX_65_127,
-	SYS_COUNT_TX_128_511,
-	SYS_COUNT_TX_512_1023,
-	SYS_COUNT_TX_1024_1526,
-	SYS_COUNT_TX_1527_MAX,
-	SYS_COUNT_TX_AGING,
-	SYS_RESET_CFG,
-	SYS_SR_ETYPE_CFG,
-	SYS_VLAN_ETYPE_CFG,
-	SYS_PORT_MODE,
-	SYS_FRONT_PORT_MODE,
-	SYS_FRM_AGING,
-	SYS_STAT_CFG,
-	SYS_SW_STATUS,
-	SYS_MISC_CFG,
-	SYS_REW_MAC_HIGH_CFG,
-	SYS_REW_MAC_LOW_CFG,
-	SYS_TIMESTAMP_OFFSET,
-	SYS_CMID,
-	SYS_PAUSE_CFG,
-	SYS_PAUSE_TOT_CFG,
-	SYS_ATOP,
-	SYS_ATOP_TOT_CFG,
-	SYS_MAC_FC_CFG,
-	SYS_MMGT,
-	SYS_MMGT_FAST,
-	SYS_EVENTS_DIF,
-	SYS_EVENTS_CORE,
-	SYS_CNT,
-	SYS_PTP_STATUS,
-	SYS_PTP_TXSTAMP,
-	SYS_PTP_NXT,
-	SYS_PTP_CFG,
-	SYS_RAM_INIT,
-	SYS_CM_ADDR,
-	SYS_CM_DATA_WR,
-	SYS_CM_DATA_RD,
-	SYS_CM_OP,
-	SYS_CM_DATA,
-	S2_CORE_UPDATE_CTRL = S2 << TARGET_OFFSET,
-	S2_CORE_MV_CFG,
-	S2_CACHE_ENTRY_DAT,
-	S2_CACHE_MASK_DAT,
-	S2_CACHE_ACTION_DAT,
-	S2_CACHE_CNT_DAT,
-	S2_CACHE_TG_DAT,
-	PTP_PIN_CFG = PTP << TARGET_OFFSET,
-	PTP_PIN_TOD_SEC_MSB,
-	PTP_PIN_TOD_SEC_LSB,
-	PTP_PIN_TOD_NSEC,
-	PTP_CFG_MISC,
-	PTP_CLK_CFG_ADJ_CFG,
-	PTP_CLK_CFG_ADJ_FREQ,
-};
-
-enum ocelot_regfield {
-	ANA_ADVLEARN_VLAN_CHK,
-	ANA_ADVLEARN_LEARN_MIRROR,
-	ANA_ANEVENTS_FLOOD_DISCARD,
-	ANA_ANEVENTS_MSTI_DROP,
-	ANA_ANEVENTS_ACLKILL,
-	ANA_ANEVENTS_ACLUSED,
-	ANA_ANEVENTS_AUTOAGE,
-	ANA_ANEVENTS_VS2TTL1,
-	ANA_ANEVENTS_STORM_DROP,
-	ANA_ANEVENTS_LEARN_DROP,
-	ANA_ANEVENTS_AGED_ENTRY,
-	ANA_ANEVENTS_CPU_LEARN_FAILED,
-	ANA_ANEVENTS_AUTO_LEARN_FAILED,
-	ANA_ANEVENTS_LEARN_REMOVE,
-	ANA_ANEVENTS_AUTO_LEARNED,
-	ANA_ANEVENTS_AUTO_MOVED,
-	ANA_ANEVENTS_DROPPED,
-	ANA_ANEVENTS_CLASSIFIED_DROP,
-	ANA_ANEVENTS_CLASSIFIED_COPY,
-	ANA_ANEVENTS_VLAN_DISCARD,
-	ANA_ANEVENTS_FWD_DISCARD,
-	ANA_ANEVENTS_MULTICAST_FLOOD,
-	ANA_ANEVENTS_UNICAST_FLOOD,
-	ANA_ANEVENTS_DEST_KNOWN,
-	ANA_ANEVENTS_BUCKET3_MATCH,
-	ANA_ANEVENTS_BUCKET2_MATCH,
-	ANA_ANEVENTS_BUCKET1_MATCH,
-	ANA_ANEVENTS_BUCKET0_MATCH,
-	ANA_ANEVENTS_CPU_OPERATION,
-	ANA_ANEVENTS_DMAC_LOOKUP,
-	ANA_ANEVENTS_SMAC_LOOKUP,
-	ANA_ANEVENTS_SEQ_GEN_ERR_0,
-	ANA_ANEVENTS_SEQ_GEN_ERR_1,
-	ANA_TABLES_MACACCESS_B_DOM,
-	ANA_TABLES_MACTINDX_BUCKET,
-	ANA_TABLES_MACTINDX_M_INDEX,
-	QSYS_TIMED_FRAME_ENTRY_TFRM_VLD,
-	QSYS_TIMED_FRAME_ENTRY_TFRM_FP,
-	QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO,
-	QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL,
-	QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T,
-	SYS_RESET_CFG_CORE_ENA,
-	SYS_RESET_CFG_MEM_ENA,
-	SYS_RESET_CFG_MEM_INIT,
-	REGFIELD_MAX
-};
-
-enum ocelot_clk_pins {
-	ALT_PPS_PIN	= 1,
-	EXT_CLK_PIN,
-	ALT_LDST_PIN,
-	TOD_ACC_PIN
-};
-
 struct ocelot_multicast {
 	struct list_head list;
 	unsigned char addr[ETH_ALEN];
@@ -429,88 +60,6 @@ struct ocelot_multicast {
 	u16 ports;
 };
 
-enum ocelot_tag_prefix {
-	OCELOT_TAG_PREFIX_DISABLED	= 0,
-	OCELOT_TAG_PREFIX_NONE,
-	OCELOT_TAG_PREFIX_SHORT,
-	OCELOT_TAG_PREFIX_LONG,
-};
-
-struct ocelot_port;
-struct ocelot;
-
-struct ocelot_stat_layout {
-	u32 offset;
-	char name[ETH_GSTRING_LEN];
-};
-
-struct ocelot_ops {
-	void (*pcs_init)(struct ocelot *ocelot, int port);
-	int (*reset)(struct ocelot *ocelot);
-};
-
-struct ocelot {
-	const struct ocelot_ops *ops;
-	struct device *dev;
-
-	struct regmap *targets[TARGET_MAX];
-	struct regmap_field *regfields[REGFIELD_MAX];
-	const u32 *const *map;
-	const struct ocelot_stat_layout *stats_layout;
-	unsigned int num_stats;
-
-	u8 base_mac[ETH_ALEN];
-
-	struct net_device *hw_bridge_dev;
-	u16 bridge_mask;
-	u16 bridge_fwd_mask;
-
-	struct workqueue_struct *ocelot_owq;
-
-	int shared_queue_sz;
-
-	u8 num_phys_ports;
-	u8 num_cpu_ports;
-	u8 cpu;
-	struct ocelot_port **ports;
-
-	u32 *lags;
-
-	/* Keep track of the vlan port masks */
-	u32 vlan_mask[VLAN_N_VID];
-
-	struct list_head multicast;
-
-	/* Workqueue to check statistics for overflow with its lock */
-	struct mutex stats_lock;
-	u64 *stats;
-	struct delayed_work stats_work;
-	struct workqueue_struct *stats_queue;
-
-	u8 ptp:1;
-	struct ptp_clock *ptp_clock;
-	struct ptp_clock_info ptp_info;
-	struct hwtstamp_config hwtstamp_config;
-	struct mutex ptp_lock; /* Protects the PTP interface state */
-	spinlock_t ptp_clock_lock; /* Protects the PTP clock */
-};
-
-struct ocelot_port {
-	struct ocelot *ocelot;
-
-	void __iomem *regs;
-
-	/* Ingress default VLAN (pvid) */
-	u16 pvid;
-
-	/* Egress default VLAN (vid) */
-	u16 vid;
-
-	u8 ptp_cmd;
-	struct list_head skbs;
-	u8 ts_id;
-};
-
 struct ocelot_port_private {
 	struct ocelot_port port;
 	struct net_device *dev;
@@ -531,37 +80,12 @@ struct ocelot_skb {
 	u8 id;
 };
 
-u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
-#define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-#define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
-#define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
-#define ocelot_read(ocelot, reg) __ocelot_read_ix(ocelot, reg, 0)
-
-void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
-#define ocelot_write_ix(ocelot, val, reg, gi, ri) __ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-#define ocelot_write_gix(ocelot, val, reg, gi) __ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi))
-#define ocelot_write_rix(ocelot, val, reg, ri) __ocelot_write_ix(ocelot, val, reg, reg##_RSZ * (ri))
-#define ocelot_write(ocelot, val, reg) __ocelot_write_ix(ocelot, val, reg, 0)
-
-void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
-		     u32 offset);
-#define ocelot_rmw_ix(ocelot, val, m, reg, gi, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
-#define ocelot_rmw_gix(ocelot, val, m, reg, gi) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi))
-#define ocelot_rmw_rix(ocelot, val, m, reg, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_RSZ * (ri))
-#define ocelot_rmw(ocelot, val, m, reg) __ocelot_rmw_ix(ocelot, val, m, reg, 0)
-
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
-int ocelot_regfields_init(struct ocelot *ocelot,
-			  const struct reg_field *const regfields);
-struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
-
 #define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
 #define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
 
-int ocelot_init(struct ocelot *ocelot);
-void ocelot_deinit(struct ocelot *ocelot);
 int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops);
 int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 		      void __iomem *regs,
@@ -575,7 +99,7 @@ extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
 
-int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
-void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts);
+#define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
+#define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
 
 #endif
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
new file mode 100644
index 000000000000..a836afe8f68e
--- /dev/null
+++ b/include/soc/mscc/ocelot.h
@@ -0,0 +1,539 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/* Copyright (c) 2017 Microsemi Corporation
+ */
+
+#ifndef _SOC_MSCC_OCELOT_H
+#define _SOC_MSCC_OCELOT_H
+
+#include <linux/ptp_clock_kernel.h>
+#include <linux/net_tstamp.h>
+#include <linux/if_vlan.h>
+#include <linux/regmap.h>
+#include <net/dsa.h>
+
+#define IFH_INJ_BYPASS			BIT(31)
+#define IFH_INJ_POP_CNT_DISABLE		(3 << 28)
+
+#define IFH_TAG_TYPE_C			0
+#define IFH_TAG_TYPE_S			1
+
+#define IFH_REW_OP_NOOP			0x0
+#define IFH_REW_OP_DSCP			0x1
+#define IFH_REW_OP_ONE_STEP_PTP		0x2
+#define IFH_REW_OP_TWO_STEP_PTP		0x3
+#define IFH_REW_OP_ORIGIN_PTP		0x5
+
+#define OCELOT_TAG_LEN			16
+#define OCELOT_SHORT_PREFIX_LEN		4
+#define OCELOT_LONG_PREFIX_LEN		16
+
+#define OCELOT_SPEED_2500		0
+#define OCELOT_SPEED_1000		1
+#define OCELOT_SPEED_100		2
+#define OCELOT_SPEED_10			3
+
+#define TARGET_OFFSET			24
+#define REG_MASK			GENMASK(TARGET_OFFSET - 1, 0)
+#define REG(reg, offset)		[reg & REG_MASK] = offset
+
+#define REG_RESERVED_ADDR		0xffffffff
+#define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
+
+enum ocelot_target {
+	ANA = 1,
+	QS,
+	QSYS,
+	REW,
+	SYS,
+	S2,
+	HSIO,
+	PTP,
+	GCB,
+	TARGET_MAX,
+};
+
+enum ocelot_reg {
+	ANA_ADVLEARN = ANA << TARGET_OFFSET,
+	ANA_VLANMASK,
+	ANA_PORT_B_DOMAIN,
+	ANA_ANAGEFIL,
+	ANA_ANEVENTS,
+	ANA_STORMLIMIT_BURST,
+	ANA_STORMLIMIT_CFG,
+	ANA_ISOLATED_PORTS,
+	ANA_COMMUNITY_PORTS,
+	ANA_AUTOAGE,
+	ANA_MACTOPTIONS,
+	ANA_LEARNDISC,
+	ANA_AGENCTRL,
+	ANA_MIRRORPORTS,
+	ANA_EMIRRORPORTS,
+	ANA_FLOODING,
+	ANA_FLOODING_IPMC,
+	ANA_SFLOW_CFG,
+	ANA_PORT_MODE,
+	ANA_CUT_THRU_CFG,
+	ANA_PGID_PGID,
+	ANA_TABLES_ANMOVED,
+	ANA_TABLES_MACHDATA,
+	ANA_TABLES_MACLDATA,
+	ANA_TABLES_STREAMDATA,
+	ANA_TABLES_MACACCESS,
+	ANA_TABLES_MACTINDX,
+	ANA_TABLES_VLANACCESS,
+	ANA_TABLES_VLANTIDX,
+	ANA_TABLES_ISDXACCESS,
+	ANA_TABLES_ISDXTIDX,
+	ANA_TABLES_ENTRYLIM,
+	ANA_TABLES_PTP_ID_HIGH,
+	ANA_TABLES_PTP_ID_LOW,
+	ANA_TABLES_STREAMACCESS,
+	ANA_TABLES_STREAMTIDX,
+	ANA_TABLES_SEQ_HISTORY,
+	ANA_TABLES_SEQ_MASK,
+	ANA_TABLES_SFID_MASK,
+	ANA_TABLES_SFIDACCESS,
+	ANA_TABLES_SFIDTIDX,
+	ANA_MSTI_STATE,
+	ANA_OAM_UPM_LM_CNT,
+	ANA_SG_ACCESS_CTRL,
+	ANA_SG_CONFIG_REG_1,
+	ANA_SG_CONFIG_REG_2,
+	ANA_SG_CONFIG_REG_3,
+	ANA_SG_CONFIG_REG_4,
+	ANA_SG_CONFIG_REG_5,
+	ANA_SG_GCL_GS_CONFIG,
+	ANA_SG_GCL_TI_CONFIG,
+	ANA_SG_STATUS_REG_1,
+	ANA_SG_STATUS_REG_2,
+	ANA_SG_STATUS_REG_3,
+	ANA_PORT_VLAN_CFG,
+	ANA_PORT_DROP_CFG,
+	ANA_PORT_QOS_CFG,
+	ANA_PORT_VCAP_CFG,
+	ANA_PORT_VCAP_S1_KEY_CFG,
+	ANA_PORT_VCAP_S2_CFG,
+	ANA_PORT_PCP_DEI_MAP,
+	ANA_PORT_CPU_FWD_CFG,
+	ANA_PORT_CPU_FWD_BPDU_CFG,
+	ANA_PORT_CPU_FWD_GARP_CFG,
+	ANA_PORT_CPU_FWD_CCM_CFG,
+	ANA_PORT_PORT_CFG,
+	ANA_PORT_POL_CFG,
+	ANA_PORT_PTP_CFG,
+	ANA_PORT_PTP_DLY1_CFG,
+	ANA_PORT_PTP_DLY2_CFG,
+	ANA_PORT_SFID_CFG,
+	ANA_PFC_PFC_CFG,
+	ANA_PFC_PFC_TIMER,
+	ANA_IPT_OAM_MEP_CFG,
+	ANA_IPT_IPT,
+	ANA_PPT_PPT,
+	ANA_FID_MAP_FID_MAP,
+	ANA_AGGR_CFG,
+	ANA_CPUQ_CFG,
+	ANA_CPUQ_CFG2,
+	ANA_CPUQ_8021_CFG,
+	ANA_DSCP_CFG,
+	ANA_DSCP_REWR_CFG,
+	ANA_VCAP_RNG_TYPE_CFG,
+	ANA_VCAP_RNG_VAL_CFG,
+	ANA_VRAP_CFG,
+	ANA_VRAP_HDR_DATA,
+	ANA_VRAP_HDR_MASK,
+	ANA_DISCARD_CFG,
+	ANA_FID_CFG,
+	ANA_POL_PIR_CFG,
+	ANA_POL_CIR_CFG,
+	ANA_POL_MODE_CFG,
+	ANA_POL_PIR_STATE,
+	ANA_POL_CIR_STATE,
+	ANA_POL_STATE,
+	ANA_POL_FLOWC,
+	ANA_POL_HYST,
+	ANA_POL_MISC_CFG,
+	QS_XTR_GRP_CFG = QS << TARGET_OFFSET,
+	QS_XTR_RD,
+	QS_XTR_FRM_PRUNING,
+	QS_XTR_FLUSH,
+	QS_XTR_DATA_PRESENT,
+	QS_XTR_CFG,
+	QS_INJ_GRP_CFG,
+	QS_INJ_WR,
+	QS_INJ_CTRL,
+	QS_INJ_STATUS,
+	QS_INJ_ERR,
+	QS_INH_DBG,
+	QSYS_PORT_MODE = QSYS << TARGET_OFFSET,
+	QSYS_SWITCH_PORT_MODE,
+	QSYS_STAT_CNT_CFG,
+	QSYS_EEE_CFG,
+	QSYS_EEE_THRES,
+	QSYS_IGR_NO_SHARING,
+	QSYS_EGR_NO_SHARING,
+	QSYS_SW_STATUS,
+	QSYS_EXT_CPU_CFG,
+	QSYS_PAD_CFG,
+	QSYS_CPU_GROUP_MAP,
+	QSYS_QMAP,
+	QSYS_ISDX_SGRP,
+	QSYS_TIMED_FRAME_ENTRY,
+	QSYS_TFRM_MISC,
+	QSYS_TFRM_PORT_DLY,
+	QSYS_TFRM_TIMER_CFG_1,
+	QSYS_TFRM_TIMER_CFG_2,
+	QSYS_TFRM_TIMER_CFG_3,
+	QSYS_TFRM_TIMER_CFG_4,
+	QSYS_TFRM_TIMER_CFG_5,
+	QSYS_TFRM_TIMER_CFG_6,
+	QSYS_TFRM_TIMER_CFG_7,
+	QSYS_TFRM_TIMER_CFG_8,
+	QSYS_RED_PROFILE,
+	QSYS_RES_QOS_MODE,
+	QSYS_RES_CFG,
+	QSYS_RES_STAT,
+	QSYS_EGR_DROP_MODE,
+	QSYS_EQ_CTRL,
+	QSYS_EVENTS_CORE,
+	QSYS_QMAXSDU_CFG_0,
+	QSYS_QMAXSDU_CFG_1,
+	QSYS_QMAXSDU_CFG_2,
+	QSYS_QMAXSDU_CFG_3,
+	QSYS_QMAXSDU_CFG_4,
+	QSYS_QMAXSDU_CFG_5,
+	QSYS_QMAXSDU_CFG_6,
+	QSYS_QMAXSDU_CFG_7,
+	QSYS_PREEMPTION_CFG,
+	QSYS_CIR_CFG,
+	QSYS_EIR_CFG,
+	QSYS_SE_CFG,
+	QSYS_SE_DWRR_CFG,
+	QSYS_SE_CONNECT,
+	QSYS_SE_DLB_SENSE,
+	QSYS_CIR_STATE,
+	QSYS_EIR_STATE,
+	QSYS_SE_STATE,
+	QSYS_HSCH_MISC_CFG,
+	QSYS_TAG_CONFIG,
+	QSYS_TAS_PARAM_CFG_CTRL,
+	QSYS_PORT_MAX_SDU,
+	QSYS_PARAM_CFG_REG_1,
+	QSYS_PARAM_CFG_REG_2,
+	QSYS_PARAM_CFG_REG_3,
+	QSYS_PARAM_CFG_REG_4,
+	QSYS_PARAM_CFG_REG_5,
+	QSYS_GCL_CFG_REG_1,
+	QSYS_GCL_CFG_REG_2,
+	QSYS_PARAM_STATUS_REG_1,
+	QSYS_PARAM_STATUS_REG_2,
+	QSYS_PARAM_STATUS_REG_3,
+	QSYS_PARAM_STATUS_REG_4,
+	QSYS_PARAM_STATUS_REG_5,
+	QSYS_PARAM_STATUS_REG_6,
+	QSYS_PARAM_STATUS_REG_7,
+	QSYS_PARAM_STATUS_REG_8,
+	QSYS_PARAM_STATUS_REG_9,
+	QSYS_GCL_STATUS_REG_1,
+	QSYS_GCL_STATUS_REG_2,
+	REW_PORT_VLAN_CFG = REW << TARGET_OFFSET,
+	REW_TAG_CFG,
+	REW_PORT_CFG,
+	REW_DSCP_CFG,
+	REW_PCP_DEI_QOS_MAP_CFG,
+	REW_PTP_CFG,
+	REW_PTP_DLY1_CFG,
+	REW_RED_TAG_CFG,
+	REW_DSCP_REMAP_DP1_CFG,
+	REW_DSCP_REMAP_CFG,
+	REW_STAT_CFG,
+	REW_REW_STICKY,
+	REW_PPT,
+	SYS_COUNT_RX_OCTETS = SYS << TARGET_OFFSET,
+	SYS_COUNT_RX_UNICAST,
+	SYS_COUNT_RX_MULTICAST,
+	SYS_COUNT_RX_BROADCAST,
+	SYS_COUNT_RX_SHORTS,
+	SYS_COUNT_RX_FRAGMENTS,
+	SYS_COUNT_RX_JABBERS,
+	SYS_COUNT_RX_CRC_ALIGN_ERRS,
+	SYS_COUNT_RX_SYM_ERRS,
+	SYS_COUNT_RX_64,
+	SYS_COUNT_RX_65_127,
+	SYS_COUNT_RX_128_255,
+	SYS_COUNT_RX_256_1023,
+	SYS_COUNT_RX_1024_1526,
+	SYS_COUNT_RX_1527_MAX,
+	SYS_COUNT_RX_PAUSE,
+	SYS_COUNT_RX_CONTROL,
+	SYS_COUNT_RX_LONGS,
+	SYS_COUNT_RX_CLASSIFIED_DROPS,
+	SYS_COUNT_TX_OCTETS,
+	SYS_COUNT_TX_UNICAST,
+	SYS_COUNT_TX_MULTICAST,
+	SYS_COUNT_TX_BROADCAST,
+	SYS_COUNT_TX_COLLISION,
+	SYS_COUNT_TX_DROPS,
+	SYS_COUNT_TX_PAUSE,
+	SYS_COUNT_TX_64,
+	SYS_COUNT_TX_65_127,
+	SYS_COUNT_TX_128_511,
+	SYS_COUNT_TX_512_1023,
+	SYS_COUNT_TX_1024_1526,
+	SYS_COUNT_TX_1527_MAX,
+	SYS_COUNT_TX_AGING,
+	SYS_RESET_CFG,
+	SYS_SR_ETYPE_CFG,
+	SYS_VLAN_ETYPE_CFG,
+	SYS_PORT_MODE,
+	SYS_FRONT_PORT_MODE,
+	SYS_FRM_AGING,
+	SYS_STAT_CFG,
+	SYS_SW_STATUS,
+	SYS_MISC_CFG,
+	SYS_REW_MAC_HIGH_CFG,
+	SYS_REW_MAC_LOW_CFG,
+	SYS_TIMESTAMP_OFFSET,
+	SYS_CMID,
+	SYS_PAUSE_CFG,
+	SYS_PAUSE_TOT_CFG,
+	SYS_ATOP,
+	SYS_ATOP_TOT_CFG,
+	SYS_MAC_FC_CFG,
+	SYS_MMGT,
+	SYS_MMGT_FAST,
+	SYS_EVENTS_DIF,
+	SYS_EVENTS_CORE,
+	SYS_CNT,
+	SYS_PTP_STATUS,
+	SYS_PTP_TXSTAMP,
+	SYS_PTP_NXT,
+	SYS_PTP_CFG,
+	SYS_RAM_INIT,
+	SYS_CM_ADDR,
+	SYS_CM_DATA_WR,
+	SYS_CM_DATA_RD,
+	SYS_CM_OP,
+	SYS_CM_DATA,
+	S2_CORE_UPDATE_CTRL = S2 << TARGET_OFFSET,
+	S2_CORE_MV_CFG,
+	S2_CACHE_ENTRY_DAT,
+	S2_CACHE_MASK_DAT,
+	S2_CACHE_ACTION_DAT,
+	S2_CACHE_CNT_DAT,
+	S2_CACHE_TG_DAT,
+	PTP_PIN_CFG = PTP << TARGET_OFFSET,
+	PTP_PIN_TOD_SEC_MSB,
+	PTP_PIN_TOD_SEC_LSB,
+	PTP_PIN_TOD_NSEC,
+	PTP_CFG_MISC,
+	PTP_CLK_CFG_ADJ_CFG,
+	PTP_CLK_CFG_ADJ_FREQ,
+	GCB_SOFT_RST = GCB << TARGET_OFFSET,
+};
+
+enum ocelot_regfield {
+	ANA_ADVLEARN_VLAN_CHK,
+	ANA_ADVLEARN_LEARN_MIRROR,
+	ANA_ANEVENTS_FLOOD_DISCARD,
+	ANA_ANEVENTS_MSTI_DROP,
+	ANA_ANEVENTS_ACLKILL,
+	ANA_ANEVENTS_ACLUSED,
+	ANA_ANEVENTS_AUTOAGE,
+	ANA_ANEVENTS_VS2TTL1,
+	ANA_ANEVENTS_STORM_DROP,
+	ANA_ANEVENTS_LEARN_DROP,
+	ANA_ANEVENTS_AGED_ENTRY,
+	ANA_ANEVENTS_CPU_LEARN_FAILED,
+	ANA_ANEVENTS_AUTO_LEARN_FAILED,
+	ANA_ANEVENTS_LEARN_REMOVE,
+	ANA_ANEVENTS_AUTO_LEARNED,
+	ANA_ANEVENTS_AUTO_MOVED,
+	ANA_ANEVENTS_DROPPED,
+	ANA_ANEVENTS_CLASSIFIED_DROP,
+	ANA_ANEVENTS_CLASSIFIED_COPY,
+	ANA_ANEVENTS_VLAN_DISCARD,
+	ANA_ANEVENTS_FWD_DISCARD,
+	ANA_ANEVENTS_MULTICAST_FLOOD,
+	ANA_ANEVENTS_UNICAST_FLOOD,
+	ANA_ANEVENTS_DEST_KNOWN,
+	ANA_ANEVENTS_BUCKET3_MATCH,
+	ANA_ANEVENTS_BUCKET2_MATCH,
+	ANA_ANEVENTS_BUCKET1_MATCH,
+	ANA_ANEVENTS_BUCKET0_MATCH,
+	ANA_ANEVENTS_CPU_OPERATION,
+	ANA_ANEVENTS_DMAC_LOOKUP,
+	ANA_ANEVENTS_SMAC_LOOKUP,
+	ANA_ANEVENTS_SEQ_GEN_ERR_0,
+	ANA_ANEVENTS_SEQ_GEN_ERR_1,
+	ANA_TABLES_MACACCESS_B_DOM,
+	ANA_TABLES_MACTINDX_BUCKET,
+	ANA_TABLES_MACTINDX_M_INDEX,
+	QSYS_TIMED_FRAME_ENTRY_TFRM_VLD,
+	QSYS_TIMED_FRAME_ENTRY_TFRM_FP,
+	QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO,
+	QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL,
+	QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T,
+	SYS_RESET_CFG_CORE_ENA,
+	SYS_RESET_CFG_MEM_ENA,
+	SYS_RESET_CFG_MEM_INIT,
+	GCB_SOFT_RST_SWC_RST,
+	REGFIELD_MAX
+};
+
+enum ocelot_clk_pins {
+	ALT_PPS_PIN	= 1,
+	EXT_CLK_PIN,
+	ALT_LDST_PIN,
+	TOD_ACC_PIN
+};
+
+struct ocelot_stat_layout {
+	u32 offset;
+	char name[ETH_GSTRING_LEN];
+};
+
+enum ocelot_tag_prefix {
+	OCELOT_TAG_PREFIX_DISABLED	= 0,
+	OCELOT_TAG_PREFIX_NONE,
+	OCELOT_TAG_PREFIX_SHORT,
+	OCELOT_TAG_PREFIX_LONG,
+};
+
+struct ocelot;
+
+struct ocelot_ops {
+	void (*pcs_init)(struct ocelot *ocelot, int port);
+	int (*reset)(struct ocelot *ocelot);
+};
+
+struct ocelot_port {
+	struct ocelot			*ocelot;
+
+	void __iomem			*regs;
+
+	/* Ingress default VLAN (pvid) */
+	u16				pvid;
+
+	/* Egress default VLAN (vid) */
+	u16				vid;
+
+	u8				ptp_cmd;
+	struct list_head		skbs;
+	u8				ts_id;
+};
+
+struct ocelot {
+	struct device			*dev;
+
+	const struct ocelot_ops		*ops;
+	struct regmap			*targets[TARGET_MAX];
+	struct regmap_field		*regfields[REGFIELD_MAX];
+	const u32 *const		*map;
+	const struct ocelot_stat_layout	*stats_layout;
+	unsigned int			num_stats;
+
+	int				shared_queue_sz;
+
+	struct net_device		*hw_bridge_dev;
+	u16				bridge_mask;
+	u16				bridge_fwd_mask;
+
+	struct ocelot_port		**ports;
+
+	u8				base_mac[ETH_ALEN];
+
+	/* Keep track of the vlan port masks */
+	u32				vlan_mask[VLAN_N_VID];
+
+	u8				num_phys_ports;
+	u8				num_cpu_ports;
+	u8				cpu;
+
+	u32				*lags;
+
+	struct list_head		multicast;
+
+	/* Workqueue to check statistics for overflow with its lock */
+	struct mutex			stats_lock;
+	u64				*stats;
+	struct delayed_work		stats_work;
+	struct workqueue_struct		*stats_queue;
+
+	u8				ptp:1;
+	struct ptp_clock		*ptp_clock;
+	struct ptp_clock_info		ptp_info;
+	struct hwtstamp_config		hwtstamp_config;
+	/* Protects the PTP interface state */
+	struct mutex			ptp_lock;
+	/* Protects the PTP clock */
+	spinlock_t			ptp_clock_lock;
+
+	void (*port_pcs_init)(struct ocelot_port *port);
+};
+
+#define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
+#define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
+#define ocelot_read(ocelot, reg) __ocelot_read_ix(ocelot, reg, 0)
+
+#define ocelot_write_ix(ocelot, val, reg, gi, ri) __ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_write_gix(ocelot, val, reg, gi) __ocelot_write_ix(ocelot, val, reg, reg##_GSZ * (gi))
+#define ocelot_write_rix(ocelot, val, reg, ri) __ocelot_write_ix(ocelot, val, reg, reg##_RSZ * (ri))
+#define ocelot_write(ocelot, val, reg) __ocelot_write_ix(ocelot, val, reg, 0)
+
+#define ocelot_rmw_ix(ocelot, val, m, reg, gi, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_rmw_gix(ocelot, val, m, reg, gi) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_GSZ * (gi))
+#define ocelot_rmw_rix(ocelot, val, m, reg, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_RSZ * (ri))
+#define ocelot_rmw(ocelot, val, m, reg) __ocelot_rmw_ix(ocelot, val, m, reg, 0)
+
+/* I/O */
+u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
+void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
+u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
+void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
+void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
+		     u32 offset);
+
+/* Hardware initialization */
+int ocelot_regfields_init(struct ocelot *ocelot,
+			  const struct reg_field *const regfields);
+struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res);
+void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
+			 enum ocelot_tag_prefix injection,
+			 enum ocelot_tag_prefix extraction);
+int ocelot_init(struct ocelot *ocelot);
+void ocelot_deinit(struct ocelot *ocelot);
+void ocelot_init_port(struct ocelot *ocelot, int port);
+
+/* DSA callbacks */
+void ocelot_port_enable(struct ocelot *ocelot, int port,
+			struct phy_device *phy);
+void ocelot_port_disable(struct ocelot *ocelot, int port);
+void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
+void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
+int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
+int ocelot_get_ts_info(struct ocelot *ocelot, int port,
+		       struct ethtool_ts_info *info);
+void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
+void ocelot_adjust_link(struct ocelot *ocelot, int port,
+			struct phy_device *phydev);
+void ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
+				bool vlan_aware);
+void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
+int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
+			    struct net_device *bridge);
+int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
+			     struct net_device *bridge);
+int ocelot_fdb_dump(struct ocelot *ocelot, int port,
+		    dsa_fdb_dump_cb_t *cb, void *data);
+int ocelot_fdb_add(struct ocelot *ocelot, int port,
+		   const unsigned char *addr, u16 vid, bool vlan_aware);
+int ocelot_fdb_del(struct ocelot *ocelot, int port,
+		   const unsigned char *addr, u16 vid);
+int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
+		    bool untagged);
+int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid);
+int ocelot_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
+void ocelot_get_hwtimestamp(struct ocelot *ocelot, struct timespec64 *ts);
+
+#endif
-- 
2.17.1

