Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2458523D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbiG2PTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbiG2PTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:19:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE3B820D3;
        Fri, 29 Jul 2022 08:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659107939; x=1690643939;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Shuy9iGIy3e1bElJke/MLRaI0NEiRx4O4lziejrQgyI=;
  b=oWXkOezlsKgnrKk0EIfOFj/lj9QmCumGTEDDO13FfsHbuAl0YJZBDUp7
   rAl8DNBFA/b9C+yS/rDBBZDtMjTquG0e7eByPAdTiZP2GQfKF0hF3Fzoq
   AzNjYUUYdeP9GcSt2J87R0abr5Y1Fwmg7/g6SpxD5LRlHgyJapAqW6rzV
   /zpk1kwKOXdaeYYN1ZMZ4eSFga+Lmh9+l3xhhDuglQ/aS15Jho3oa2FEk
   dPERj2r/UW4LERTRWh02x4TsTrXS7OltTcbuOc86K2TyXCLz5blt457o+
   LhzRpSMorUMtz8mYRHXKo0zxfO4ph61a4DW3cSweA48poQFwViH8ZsYmp
   A==;
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="174162834"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2022 08:18:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 29 Jul 2022 08:18:57 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 29 Jul 2022 08:18:47 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>
Subject: [Patch RFC net-next 4/4] net: dsa: microchip: use private pvid for bridge_vlan_unwaware
Date:   Fri, 29 Jul 2022 20:47:33 +0530
Message-ID: <20220729151733.6032-5-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220729151733.6032-1-arun.ramadoss@microchip.com>
References: <20220729151733.6032-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To remove ds->configure_vlan_while_not_filtering, for the bridge vlan
unaware the private pvid of 4095 is used. The bridged vlan pvid is
stored in the ksz port structure and it is used only when vlan_filtering
is enabled. If vlan_filtering is disabled then private pvid is used.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8.h       |  1 +
 drivers/net/dsa/microchip/ksz8795.c    | 23 +-------
 drivers/net/dsa/microchip/ksz9477.c    | 19 ++----
 drivers/net/dsa/microchip/ksz9477.h    |  1 +
 drivers/net/dsa/microchip/ksz_common.c | 81 ++++++++++++++++++++++++--
 drivers/net/dsa/microchip/ksz_common.h | 10 +++-
 6 files changed, 95 insertions(+), 40 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8.h b/drivers/net/dsa/microchip/ksz8.h
index 6529f2e2426a..c5b0ab031427 100644
--- a/drivers/net/dsa/microchip/ksz8.h
+++ b/drivers/net/dsa/microchip/ksz8.h
@@ -42,6 +42,7 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
 		       u16 flags);
 int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 		       const struct switchdev_obj_port_vlan *vlan);
+void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state);
 int ksz8_port_mirror_add(struct ksz_device *dev, int port,
 			 struct dsa_mall_mirror_tc_entry *mirror,
 			 bool ingress, struct netlink_ext_ack *extack);
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index b8843697c5a5..16709949d079 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -952,7 +952,7 @@ int ksz8_port_vlan_filtering(struct ksz_device *dev, int port, bool flag,
 	return 0;
 }
 
-static void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
+void ksz8_port_enable_pvid(struct ksz_device *dev, int port, bool state)
 {
 	if (ksz_is_ksz88x3(dev)) {
 		ksz_cfg(dev, REG_SW_INSERT_SRC_PVID,
@@ -967,8 +967,8 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
 {
 	bool untagged = flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct ksz_port *p = &dev->ports[port];
-	u16 data, new_pvid = 0;
 	u8 fid, member, valid;
+	u16 data;
 
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
@@ -1015,32 +1015,18 @@ int ksz8_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
 	ksz8_to_vlan(dev, fid, member, valid, &data);
 	ksz8_w_vlan_table(dev, vlan_vid, data);
 
-	/* change PVID */
-	if (flags & BRIDGE_VLAN_INFO_PVID)
-		new_pvid = vlan_vid;
-
-	if (new_pvid) {
-
-		ksz_set_pvid(dev, port, new_pvid);
-
-		ksz8_port_enable_pvid(dev, port, true);
-	}
-
 	return 0;
 }
 
 int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 		       const struct switchdev_obj_port_vlan *vlan)
 {
-	u16 data, pvid;
+	u16 data;
 	u8 fid, member, valid;
 
 	if (ksz_is_ksz88x3(dev))
 		return -ENOTSUPP;
 
-	ksz_get_pvid(dev, port, &pvid);
-	pvid = pvid & 0xFFF;
-
 	ksz8_r_vlan_table(dev, vlan->vid, &data);
 	ksz8_from_vlan(dev, data, &fid, &member, &valid);
 
@@ -1055,9 +1041,6 @@ int ksz8_port_vlan_del(struct ksz_device *dev, int port,
 	ksz8_to_vlan(dev, fid, member, valid, &data);
 	ksz8_w_vlan_table(dev, vlan->vid, data);
 
-	if (pvid == vlan->vid)
-		ksz8_port_enable_pvid(dev, port, false);
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index a43a581520fb..b423aebe4473 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -354,6 +354,12 @@ void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
+void ksz9477_port_drop_untagged(struct ksz_device *dev, int port, bool state)
+{
+	ksz_port_cfg(dev, port, REG_PORT_MRI_MAC_CTRL, PORT_DROP_NON_VLAN,
+		     state);
+}
+
 int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
 				bool flag, struct netlink_ext_ack *extack)
 {
@@ -394,10 +400,6 @@ int ksz9477_port_vlan_add(struct ksz_device *dev, int port, u16 vlan_vid,
 	if (err)
 		return err;
 
-	/* change PVID */
-	if (flags & BRIDGE_VLAN_INFO_PVID)
-		ksz_set_pvid(dev, port, vlan_vid);
-
 	return 0;
 }
 
@@ -406,10 +408,6 @@ int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 {
 	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	u32 vlan_table[3];
-	u16 pvid;
-
-	ksz_get_pvid(dev, port, &pvid);
-	pvid = pvid & 0xFFF;
 
 	if (ksz9477_get_vlan_table(dev, vlan->vid, vlan_table)) {
 		dev_dbg(dev->dev, "Failed to get vlan table\n");
@@ -418,9 +416,6 @@ int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 
 	vlan_table[2] &= ~BIT(port);
 
-	if (pvid == vlan->vid)
-		pvid = 1;
-
 	if (untagged)
 		vlan_table[1] &= ~BIT(port);
 
@@ -429,8 +424,6 @@ int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 		return -ETIMEDOUT;
 	}
 
-	ksz_set_pvid(dev, port, pvid);
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index 30a1fff9b8ec..2bd88319a2c0 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -28,6 +28,7 @@ int ksz9477_port_vlan_filtering(struct ksz_device *dev, int port,
 int ksz9477_port_vlan_add(struct ksz_device *dev, int port, u16 vid, u16 flags);
 int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 			  const struct switchdev_obj_port_vlan *vlan);
+void ksz9477_port_drop_untagged(struct ksz_device *dev, int port, bool state);
 int ksz9477_port_mirror_add(struct ksz_device *dev, int port,
 			    struct dsa_mall_mirror_tc_entry *mirror,
 			    bool ingress, struct netlink_ext_ack *extack);
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 516fb9d35c87..8a5583b1f2f4 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -161,6 +161,7 @@ static const struct ksz_dev_ops ksz8_dev_ops = {
 	.vlan_filtering = ksz8_port_vlan_filtering,
 	.vlan_add = ksz8_port_vlan_add,
 	.vlan_del = ksz8_port_vlan_del,
+	.drop_untagged = ksz8_port_enable_pvid,
 	.mirror_add = ksz8_port_mirror_add,
 	.mirror_del = ksz8_port_mirror_del,
 	.get_caps = ksz8_get_caps,
@@ -187,6 +188,7 @@ static const struct ksz_dev_ops ksz9477_dev_ops = {
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
+	.drop_untagged = ksz9477_port_drop_untagged,
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = ksz9477_get_caps,
@@ -220,6 +222,7 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.vlan_filtering = ksz9477_port_vlan_filtering,
 	.vlan_add = ksz9477_port_vlan_add,
 	.vlan_del = ksz9477_port_vlan_del,
+	.drop_untagged = ksz9477_port_drop_untagged,
 	.mirror_add = ksz9477_port_mirror_add,
 	.mirror_del = ksz9477_port_mirror_del,
 	.get_caps = lan937x_phylink_get_caps,
@@ -1254,6 +1257,9 @@ static int ksz_enable_port(struct dsa_switch *ds, int port,
 {
 	struct ksz_device *dev = ds->priv;
 
+	dev->dev_ops->vlan_add(dev, port, KSZ_DEFAULT_VLAN,
+			       BRIDGE_VLAN_INFO_UNTAGGED);
+
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
@@ -1335,7 +1341,7 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 	return proto;
 }
 
-void ksz_get_pvid(struct ksz_device *dev, int port, u16 *pvid)
+static void ksz_get_pvid(struct ksz_device *dev, int port, u16 *pvid)
 {
 	const u16 *regs = dev->info->regs;
 	u16 val;
@@ -1345,45 +1351,110 @@ void ksz_get_pvid(struct ksz_device *dev, int port, u16 *pvid)
 	*pvid = val & VLAN_VID_MASK;
 }
 
-void ksz_set_pvid(struct ksz_device *dev, int port, u16 pvid)
+static void ksz_set_pvid(struct ksz_device *dev, int port, u16 pvid)
 {
 	const u16 *regs = dev->info->regs;
 
 	ksz_prmw16(dev, port, regs[P_DEFAULT_PVID], VLAN_VID_MASK, pvid);
 }
 
+static int ksz_commit_pvid(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct net_device *br = dsa_port_bridge_dev_get(dp);
+	struct ksz_device *dev = ds->priv;
+	u16 pvid = KSZ_DEFAULT_VLAN;
+	bool drop_untagged = false;
+	struct ksz_port *p;
+
+	p = &dev->ports[port];
+
+	if (br && br_vlan_enabled(br)) {
+		pvid = p->bridge_pvid.vid;
+		drop_untagged = !p->bridge_pvid.valid;
+	}
+
+	ksz_set_pvid(dev, port, pvid);
+
+	if (dev->dev_ops->drop_untagged)
+		dev->dev_ops->drop_untagged(dev, port, drop_untagged);
+
+	return 0;
+}
+
 static int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
 				   bool flag, struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
+	int ret;
 
 	if (!dev->dev_ops->vlan_filtering)
 		return -EOPNOTSUPP;
 
-	return dev->dev_ops->vlan_filtering(dev, port, flag, extack);
+	ret = dev->dev_ops->vlan_filtering(dev, port, flag, extack);
+	if (ret)
+		return ret;
+
+	return ksz_commit_pvid(ds, port);
 }
 
 static int ksz_port_vlan_add(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan,
 			     struct netlink_ext_ack *extack)
 {
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
+	int ret;
+
+	p = &dev->ports[port];
 
 	if (!dev->dev_ops->vlan_add)
 		return -EOPNOTSUPP;
 
-	return dev->dev_ops->vlan_add(dev, port, vlan->vid, vlan->flags);
+	ret = dev->dev_ops->vlan_add(dev, port, vlan->vid, vlan->flags);
+	if (ret)
+		return ret;
+
+	if (pvid) {
+		p->bridge_pvid.vid = vlan->vid;
+		p->bridge_pvid.valid = true;
+	} else if (vlan->vid && p->bridge_pvid.vid == vlan->vid) {
+		/* The old pvid was reinstalled as a non-pvid VLAN */
+		p->bridge_pvid.valid = false;
+	}
+
+	return ksz_commit_pvid(ds, port);
 }
 
 static int ksz_port_vlan_del(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ksz_device *dev = ds->priv;
+	struct ksz_port *p;
+	u16 pvid;
+	int ret;
+
+	p = &dev->ports[port];
 
 	if (!dev->dev_ops->vlan_del)
 		return -EOPNOTSUPP;
 
-	return dev->dev_ops->vlan_del(dev, port, vlan);
+	ksz_get_pvid(dev, port, &pvid);
+
+	ret = dev->dev_ops->vlan_del(dev, port, vlan);
+	if (ret)
+		return ret;
+
+	if (vlan->vid == pvid) {
+		p->bridge_pvid.valid = false;
+
+		ret = ksz_commit_pvid(ds, port);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int ksz_port_mirror_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 3bcd4e20bfaa..3d7eb170e3ec 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -15,6 +15,7 @@
 #include <net/dsa.h>
 
 #define KSZ_MAX_NUM_PORTS 8
+#define KSZ_DEFAULT_VLAN			(VLAN_N_VID - 1)
 
 struct vlan_table {
 	u32 table[3];
@@ -63,6 +64,11 @@ struct ksz_chip_data {
 	bool internal_phy[KSZ_MAX_NUM_PORTS];
 };
 
+struct ksz_vlan {
+	u16	vid;
+	bool	valid;
+};
+
 struct ksz_port {
 	bool remove_tag;		/* Remove Tag flag set, for ksz8795 only */
 	int stp_state;
@@ -81,6 +87,7 @@ struct ksz_port {
 	u16 max_frame;
 	u32 rgmii_tx_val;
 	u32 rgmii_rx_val;
+	struct ksz_vlan bridge_pvid;
 };
 
 struct ksz_device {
@@ -271,6 +278,7 @@ struct ksz_dev_ops {
 	int  (*vlan_add)(struct ksz_device *dev, int port, u16 vid, u16 flags);
 	int  (*vlan_del)(struct ksz_device *dev, int port,
 			 const struct switchdev_obj_port_vlan *vlan);
+	void (*drop_untagged)(struct ksz_device *dev, int port, bool untagged);
 	int (*mirror_add)(struct ksz_device *dev, int port,
 			  struct dsa_mall_mirror_tc_entry *mirror,
 			  bool ingress, struct netlink_ext_ack *extack);
@@ -320,8 +328,6 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
 bool ksz_get_gbit(struct ksz_device *dev, int port);
 phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit);
 extern const struct ksz_chip_data ksz_switch_chips[];
-void ksz_get_pvid(struct ksz_device *dev, int port, u16 *pvid);
-void ksz_set_pvid(struct ksz_device *dev, int port, u16 pvid);
 
 /* Common register access functions */
 
-- 
2.36.1

