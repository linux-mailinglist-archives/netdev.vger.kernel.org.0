Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281E7554634
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357362AbiFVJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357181AbiFVJJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:09:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3205B2E6A8;
        Wed, 22 Jun 2022 02:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655888909; x=1687424909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DR3V22t93asKRt0ERchSEMSSo5qzvTnouqjDwvaeqkQ=;
  b=RzYu32W8jwTtavAHWF0M4G0IwdT9YIIShm20ut1P3xo9HSlM5aGg1BbF
   +TtBEVlgFT9SWEpsK5aJzvWTRkn9IAgbGge58CXVwJh5thr2BQx0x20yw
   025zWqD4B4YKO8ALY6dupMYSYOfSFBx5elT3Vw+j8H871tx8zm6IqT+o9
   IPJ2jpOuzM92GSfez6mucfRrB4oSCc8oAcmQmhM2SRUG1v4wODAPk0vqV
   Eq3mjzM7lo5Esb0VggQ/8gGq9ccIR/ktS8Yt8YdhcQ9gAJYkoUrmDDqWl
   OOkKhbPEMb/e5FzzIVIbiD5ogw0mGLv5Xtov1Xe5IoTUKIcGJALau4r23
   w==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="169135366"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 02:08:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 02:08:28 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 22 Jun 2022 02:08:23 -0700
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
Subject: [Patch net-next 08/13] net: dsa: microchip: common dsa_switch_ops for ksz switches
Date:   Wed, 22 Jun 2022 14:34:20 +0530
Message-ID: <20220622090425.17709-9-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220622090425.17709-1-arun.ramadoss@microchip.com>
References: <20220622090425.17709-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, ksz8795.c and ksz9477.c have separate dsa_switch_ops
structure initialization. This patch modifies the files such a way that
ksz switches has common dsa_switch_ops in the ksz_common.c file.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz8795.c    |  28 -----
 drivers/net/dsa/microchip/ksz9477.c    |  33 +----
 drivers/net/dsa/microchip/ksz_common.c | 164 +++++++++++++------------
 drivers/net/dsa/microchip/ksz_common.h |  54 +-------
 4 files changed, 89 insertions(+), 190 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 662493db8638..0734ee63ed19 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1437,32 +1437,6 @@ static void ksz8_get_caps(struct ksz_device *dev, int port,
 		config->mac_capabilities |= MAC_ASYM_PAUSE;
 }
 
-static const struct dsa_switch_ops ksz8_switch_ops = {
-	.get_tag_protocol	= ksz_get_tag_protocol,
-	.get_phy_flags		= ksz_get_phy_flags,
-	.setup			= ksz_setup,
-	.phy_read		= ksz_phy_read16,
-	.phy_write		= ksz_phy_write16,
-	.phylink_get_caps	= ksz_phylink_get_caps,
-	.phylink_mac_link_down	= ksz_mac_link_down,
-	.port_enable		= ksz_enable_port,
-	.get_strings		= ksz_get_strings,
-	.get_ethtool_stats	= ksz_get_ethtool_stats,
-	.get_sset_count		= ksz_sset_count,
-	.port_bridge_join	= ksz_port_bridge_join,
-	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz_port_stp_state_set,
-	.port_fast_age		= ksz_port_fast_age,
-	.port_vlan_filtering	= ksz_port_vlan_filtering,
-	.port_vlan_add		= ksz_port_vlan_add,
-	.port_vlan_del		= ksz_port_vlan_del,
-	.port_fdb_dump		= ksz_port_fdb_dump,
-	.port_mdb_add           = ksz_port_mdb_add,
-	.port_mdb_del           = ksz_port_mdb_del,
-	.port_mirror_add	= ksz_port_mirror_add,
-	.port_mirror_del	= ksz_port_mirror_del,
-};
-
 static u32 ksz8_get_port_addr(int port, int offset)
 {
 	return PORT_CTRL_ADDR(port, offset);
@@ -1472,8 +1446,6 @@ static int ksz8_switch_init(struct ksz_device *dev)
 {
 	struct ksz8 *ksz8 = dev->priv;
 
-	dev->ds->ops = &ksz8_switch_ops;
-
 	dev->cpu_port = fls(dev->info->cpu_ports) - 1;
 	dev->phy_port_cnt = dev->info->port_cnt - 1;
 	dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev->info->cpu_ports;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 5fa5b3d09146..e3989aef93f4 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1290,36 +1290,6 @@ static int ksz9477_setup(struct dsa_switch *ds)
 	return 0;
 }
 
-static const struct dsa_switch_ops ksz9477_switch_ops = {
-	.get_tag_protocol	= ksz_get_tag_protocol,
-	.setup			= ksz_setup,
-	.phy_read		= ksz_phy_read16,
-	.phy_write		= ksz_phy_write16,
-	.phylink_mac_link_down	= ksz_mac_link_down,
-	.phylink_get_caps	= ksz_phylink_get_caps,
-	.port_enable		= ksz_enable_port,
-	.get_strings		= ksz_get_strings,
-	.get_ethtool_stats	= ksz_get_ethtool_stats,
-	.get_sset_count		= ksz_sset_count,
-	.port_bridge_join	= ksz_port_bridge_join,
-	.port_bridge_leave	= ksz_port_bridge_leave,
-	.port_stp_state_set	= ksz_port_stp_state_set,
-	.port_fast_age		= ksz_port_fast_age,
-	.port_vlan_filtering	= ksz_port_vlan_filtering,
-	.port_vlan_add		= ksz_port_vlan_add,
-	.port_vlan_del		= ksz_port_vlan_del,
-	.port_fdb_dump		= ksz_port_fdb_dump,
-	.port_fdb_add		= ksz_port_fdb_add,
-	.port_fdb_del		= ksz_port_fdb_del,
-	.port_mdb_add           = ksz_port_mdb_add,
-	.port_mdb_del           = ksz_port_mdb_del,
-	.port_mirror_add	= ksz_port_mirror_add,
-	.port_mirror_del	= ksz_port_mirror_del,
-	.get_stats64		= ksz_get_stats64,
-	.port_change_mtu	= ksz_change_mtu,
-	.port_max_mtu		= ksz_max_mtu,
-};
-
 static u32 ksz9477_get_port_addr(int port, int offset)
 {
 	return PORT_CTRL_ADDR(port, offset);
@@ -1330,8 +1300,6 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 	u8 data8;
 	int ret;
 
-	dev->ds->ops = &ksz9477_switch_ops;
-
 	dev->port_mask = (1 << dev->info->port_cnt) - 1;
 
 	/* turn off SPI DO Edge select */
@@ -1369,6 +1337,7 @@ static int ksz9477_switch_init(struct ksz_device *dev)
 		if (!(data8 & SW_GIGABIT_ABLE))
 			dev->features &= ~GBIT_SUPPORT;
 	}
+
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 6da4df520397..9ebeaba2c755 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -489,8 +489,8 @@ static int ksz_check_device_id(struct ksz_device *dev)
 	return 0;
 }
 
-void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
-			  struct phylink_config *config)
+static void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
+				 struct phylink_config *config)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -513,7 +513,6 @@ void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 	if (dev->dev_ops->get_caps)
 		dev->dev_ops->get_caps(dev, port, config);
 }
-EXPORT_SYMBOL_GPL(ksz_phylink_get_caps);
 
 void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 {
@@ -558,8 +557,8 @@ void ksz_r_mib_stats64(struct ksz_device *dev, int port)
 }
 EXPORT_SYMBOL_GPL(ksz_r_mib_stats64);
 
-void ksz_get_stats64(struct dsa_switch *ds, int port,
-		     struct rtnl_link_stats64 *s)
+static void ksz_get_stats64(struct dsa_switch *ds, int port,
+			    struct rtnl_link_stats64 *s)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port_mib *mib;
@@ -570,10 +569,9 @@ void ksz_get_stats64(struct dsa_switch *ds, int port,
 	memcpy(s, &mib->stats64, sizeof(*s));
 	spin_unlock(&mib->stats64_lock);
 }
-EXPORT_SYMBOL_GPL(ksz_get_stats64);
 
-void ksz_get_strings(struct dsa_switch *ds, int port,
-		     u32 stringset, uint8_t *buf)
+static void ksz_get_strings(struct dsa_switch *ds, int port,
+			    u32 stringset, uint8_t *buf)
 {
 	struct ksz_device *dev = ds->priv;
 	int i;
@@ -586,7 +584,6 @@ void ksz_get_strings(struct dsa_switch *ds, int port,
 		       dev->info->mib_names[i].string, ETH_GSTRING_LEN);
 	}
 }
-EXPORT_SYMBOL_GPL(ksz_get_strings);
 
 static void ksz_update_port_member(struct ksz_device *dev, int port)
 {
@@ -646,7 +643,7 @@ static void ksz_update_port_member(struct ksz_device *dev, int port)
 	dev->dev_ops->cfg_port_member(dev, port, port_member | cpu_port);
 }
 
-int ksz_setup(struct dsa_switch *ds)
+static int ksz_setup(struct dsa_switch *ds)
 {
 	struct ksz_device *dev = ds->priv;
 	int ret;
@@ -691,7 +688,6 @@ int ksz_setup(struct dsa_switch *ds)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ksz_setup);
 
 static void port_r_cnt(struct ksz_device *dev, int port)
 {
@@ -771,7 +767,7 @@ void ksz_init_mib_timer(struct ksz_device *dev)
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
-int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg)
+static int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg)
 {
 	struct ksz_device *dev = ds->priv;
 	u16 val = 0xffff;
@@ -780,9 +776,8 @@ int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg)
 
 	return val;
 }
-EXPORT_SYMBOL_GPL(ksz_phy_read16);
 
-int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
+static int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -790,9 +785,8 @@ int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ksz_phy_write16);
 
-u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
+static u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -807,10 +801,9 @@ u32 ksz_get_phy_flags(struct dsa_switch *ds, int port)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ksz_get_phy_flags);
 
-void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
-		       phy_interface_t interface)
+static void ksz_mac_link_down(struct dsa_switch *ds, int port,
+			      unsigned int mode, phy_interface_t interface)
 {
 	struct ksz_device *dev = ds->priv;
 	struct ksz_port *p = &dev->ports[port];
@@ -821,9 +814,8 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 	if (dev->mib_read_interval)
 		schedule_delayed_work(&dev->mib_read, 0);
 }
-EXPORT_SYMBOL_GPL(ksz_mac_link_down);
 
-int ksz_sset_count(struct dsa_switch *ds, int port, int sset)
+static int ksz_sset_count(struct dsa_switch *ds, int port, int sset)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -832,9 +824,9 @@ int ksz_sset_count(struct dsa_switch *ds, int port, int sset)
 
 	return dev->info->mib_cnt;
 }
-EXPORT_SYMBOL_GPL(ksz_sset_count);
 
-void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
+static void ksz_get_ethtool_stats(struct dsa_switch *ds, int port,
+				  uint64_t *buf)
 {
 	const struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ksz_device *dev = ds->priv;
@@ -850,12 +842,11 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 	memcpy(buf, mib->counters, dev->info->mib_cnt * sizeof(u64));
 	mutex_unlock(&mib->cnt_mutex);
 }
-EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
-int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge,
-			 bool *tx_fwd_offload,
-			 struct netlink_ext_ack *extack)
+static int ksz_port_bridge_join(struct dsa_switch *ds, int port,
+				struct dsa_bridge bridge,
+				bool *tx_fwd_offload,
+				struct netlink_ext_ack *extack)
 {
 	/* port_stp_state_set() will be called after to put the port in
 	 * appropriate state so there is no need to do anything.
@@ -863,27 +854,25 @@ int ksz_port_bridge_join(struct dsa_switch *ds, int port,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ksz_port_bridge_join);
 
-void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct dsa_bridge bridge)
+static void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
+				  struct dsa_bridge bridge)
 {
 	/* port_stp_state_set() will be called after to put the port in
 	 * forwarding state so there is no need to do anything.
 	 */
 }
-EXPORT_SYMBOL_GPL(ksz_port_bridge_leave);
 
-void ksz_port_fast_age(struct dsa_switch *ds, int port)
+static void ksz_port_fast_age(struct dsa_switch *ds, int port)
 {
 	struct ksz_device *dev = ds->priv;
 
 	dev->dev_ops->flush_dyn_mac_table(dev, port);
 }
-EXPORT_SYMBOL_GPL(ksz_port_fast_age);
 
-int ksz_port_fdb_add(struct dsa_switch *ds, int port,
-		     const unsigned char *addr, u16 vid, struct dsa_db db)
+static int ksz_port_fdb_add(struct dsa_switch *ds, int port,
+			    const unsigned char *addr, u16 vid,
+			    struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -892,10 +881,10 @@ int ksz_port_fdb_add(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->fdb_add(dev, port, addr, vid, db);
 }
-EXPORT_SYMBOL_GPL(ksz_port_fdb_add);
 
-int ksz_port_fdb_del(struct dsa_switch *ds, int port,
-		     const unsigned char *addr, u16 vid, struct dsa_db db)
+static int ksz_port_fdb_del(struct dsa_switch *ds, int port,
+			    const unsigned char *addr,
+			    u16 vid, struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -904,10 +893,9 @@ int ksz_port_fdb_del(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->fdb_del(dev, port, addr, vid, db);
 }
-EXPORT_SYMBOL_GPL(ksz_port_fdb_del);
 
-int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
-		      void *data)
+static int ksz_port_fdb_dump(struct dsa_switch *ds, int port,
+			     dsa_fdb_dump_cb_t *cb, void *data)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -916,11 +904,10 @@ int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 
 	return dev->dev_ops->fdb_dump(dev, port, cb, data);
 }
-EXPORT_SYMBOL_GPL(ksz_port_fdb_dump);
 
-int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct dsa_db db)
+static int ksz_port_mdb_add(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_mdb *mdb,
+			    struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -929,11 +916,10 @@ int ksz_port_mdb_add(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->mdb_add(dev, port, mdb, db);
 }
-EXPORT_SYMBOL_GPL(ksz_port_mdb_add);
 
-int ksz_port_mdb_del(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct dsa_db db)
+static int ksz_port_mdb_del(struct dsa_switch *ds, int port,
+			    const struct switchdev_obj_port_mdb *mdb,
+			    struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -942,9 +928,9 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->mdb_del(dev, port, mdb, db);
 }
-EXPORT_SYMBOL_GPL(ksz_port_mdb_del);
 
-int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
+static int ksz_enable_port(struct dsa_switch *ds, int port,
+			   struct phy_device *phy)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -960,7 +946,6 @@ int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ksz_enable_port);
 
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 {
@@ -1004,8 +989,9 @@ void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 }
 EXPORT_SYMBOL_GPL(ksz_port_stp_state_set);
 
-enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
-					   int port, enum dsa_tag_protocol mp)
+static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
+						  int port,
+						  enum dsa_tag_protocol mp)
 {
 	struct ksz_device *dev = ds->priv;
 	enum dsa_tag_protocol proto = DSA_TAG_PROTO_NONE;
@@ -1026,10 +1012,9 @@ enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
 
 	return proto;
 }
-EXPORT_SYMBOL_GPL(ksz_get_tag_protocol);
 
-int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
-			    bool flag, struct netlink_ext_ack *extack)
+static int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
+				   bool flag, struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -1038,11 +1023,10 @@ int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->vlan_filtering(dev, port, flag, extack);
 }
-EXPORT_SYMBOL_GPL(ksz_port_vlan_filtering);
 
-int ksz_port_vlan_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan,
-		      struct netlink_ext_ack *extack)
+static int ksz_port_vlan_add(struct dsa_switch *ds, int port,
+			     const struct switchdev_obj_port_vlan *vlan,
+			     struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -1051,10 +1035,9 @@ int ksz_port_vlan_add(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->vlan_add(dev, port, vlan, extack);
 }
-EXPORT_SYMBOL_GPL(ksz_port_vlan_add);
 
-int ksz_port_vlan_del(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan)
+static int ksz_port_vlan_del(struct dsa_switch *ds, int port,
+			     const struct switchdev_obj_port_vlan *vlan)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -1063,11 +1046,10 @@ int ksz_port_vlan_del(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->vlan_del(dev, port, vlan);
 }
-EXPORT_SYMBOL_GPL(ksz_port_vlan_del);
 
-int ksz_port_mirror_add(struct dsa_switch *ds, int port,
-			struct dsa_mall_mirror_tc_entry *mirror,
-			bool ingress, struct netlink_ext_ack *extack)
+static int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			       struct dsa_mall_mirror_tc_entry *mirror,
+			       bool ingress, struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -1076,19 +1058,17 @@ int ksz_port_mirror_add(struct dsa_switch *ds, int port,
 
 	return dev->dev_ops->mirror_add(dev, port, mirror, ingress, extack);
 }
-EXPORT_SYMBOL_GPL(ksz_port_mirror_add);
 
-void ksz_port_mirror_del(struct dsa_switch *ds, int port,
-			 struct dsa_mall_mirror_tc_entry *mirror)
+static void ksz_port_mirror_del(struct dsa_switch *ds, int port,
+				struct dsa_mall_mirror_tc_entry *mirror)
 {
 	struct ksz_device *dev = ds->priv;
 
 	if (dev->dev_ops->mirror_del)
 		dev->dev_ops->mirror_del(dev, port, mirror);
 }
-EXPORT_SYMBOL_GPL(ksz_port_mirror_del);
 
-int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu)
+static int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -1097,9 +1077,8 @@ int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu)
 
 	return dev->dev_ops->change_mtu(dev, port, mtu);
 }
-EXPORT_SYMBOL_GPL(ksz_change_mtu);
 
-int ksz_max_mtu(struct dsa_switch *ds, int port)
+static int ksz_max_mtu(struct dsa_switch *ds, int port)
 {
 	struct ksz_device *dev = ds->priv;
 
@@ -1108,7 +1087,6 @@ int ksz_max_mtu(struct dsa_switch *ds, int port)
 
 	return dev->dev_ops->max_mtu(dev, port);
 }
-EXPORT_SYMBOL_GPL(ksz_max_mtu);
 
 static int ksz_switch_detect(struct ksz_device *dev)
 {
@@ -1176,6 +1154,37 @@ static int ksz_switch_detect(struct ksz_device *dev)
 	return 0;
 }
 
+static const struct dsa_switch_ops ksz_switch_ops = {
+	.get_tag_protocol	= ksz_get_tag_protocol,
+	.get_phy_flags		= ksz_get_phy_flags,
+	.setup			= ksz_setup,
+	.phy_read		= ksz_phy_read16,
+	.phy_write		= ksz_phy_write16,
+	.phylink_get_caps	= ksz_phylink_get_caps,
+	.phylink_mac_link_down	= ksz_mac_link_down,
+	.port_enable		= ksz_enable_port,
+	.get_strings		= ksz_get_strings,
+	.get_ethtool_stats	= ksz_get_ethtool_stats,
+	.get_sset_count		= ksz_sset_count,
+	.port_bridge_join	= ksz_port_bridge_join,
+	.port_bridge_leave	= ksz_port_bridge_leave,
+	.port_stp_state_set	= ksz_port_stp_state_set,
+	.port_fast_age		= ksz_port_fast_age,
+	.port_vlan_filtering	= ksz_port_vlan_filtering,
+	.port_vlan_add		= ksz_port_vlan_add,
+	.port_vlan_del		= ksz_port_vlan_del,
+	.port_fdb_dump		= ksz_port_fdb_dump,
+	.port_fdb_add		= ksz_port_fdb_add,
+	.port_fdb_del		= ksz_port_fdb_del,
+	.port_mdb_add           = ksz_port_mdb_add,
+	.port_mdb_del           = ksz_port_mdb_del,
+	.port_mirror_add	= ksz_port_mirror_add,
+	.port_mirror_del	= ksz_port_mirror_del,
+	.get_stats64		= ksz_get_stats64,
+	.port_change_mtu	= ksz_change_mtu,
+	.port_max_mtu		= ksz_max_mtu,
+};
+
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
@@ -1187,6 +1196,7 @@ struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 
 	ds->dev = base;
 	ds->num_ports = DSA_MAX_PORTS;
+	ds->ops = &ksz_switch_ops;
 
 	swdev = devm_kzalloc(base, sizeof(*swdev), GFP_KERNEL);
 	if (!swdev)
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 2cf8474ba626..8a2ebce37a49 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -225,60 +225,8 @@ int ksz9477_switch_register(struct ksz_device *dev);
 
 void ksz_init_mib_timer(struct ksz_device *dev);
 void ksz_r_mib_stats64(struct ksz_device *dev, int port);
-void ksz_get_stats64(struct dsa_switch *ds, int port,
-		     struct rtnl_link_stats64 *s);
-void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
-			  struct phylink_config *config);
-extern const struct ksz_chip_data ksz_switch_chips[];
-
-/* Common DSA access functions */
-
-int ksz_setup(struct dsa_switch *ds);
-int ksz_phy_read16(struct dsa_switch *ds, int addr, int reg);
-int ksz_phy_write16(struct dsa_switch *ds, int addr, int reg, u16 val);
-u32 ksz_get_phy_flags(struct dsa_switch *ds, int port);
-void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
-		       phy_interface_t interface);
-int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
-void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
-int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct dsa_bridge bridge, bool *tx_fwd_offload,
-			 struct netlink_ext_ack *extack);
-void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
-			   struct dsa_bridge bridge);
 void ksz_port_stp_state_set(struct dsa_switch *ds, int port, u8 state);
-void ksz_port_fast_age(struct dsa_switch *ds, int port);
-int ksz_port_fdb_add(struct dsa_switch *ds, int port,
-		     const unsigned char *addr, u16 vid, struct dsa_db db);
-int ksz_port_fdb_del(struct dsa_switch *ds, int port,
-		     const unsigned char *addr, u16 vid, struct dsa_db db);
-int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
-		      void *data);
-int ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct dsa_db db);
-int ksz_port_mdb_del(struct dsa_switch *ds, int port,
-		     const struct switchdev_obj_port_mdb *mdb,
-		     struct dsa_db db);
-int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
-void ksz_get_strings(struct dsa_switch *ds, int port,
-		     u32 stringset, uint8_t *buf);
-enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
-					   int port, enum dsa_tag_protocol mp);
-int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
-			    bool flag, struct netlink_ext_ack *extack);
-int ksz_port_vlan_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan,
-		      struct netlink_ext_ack *extack);
-int ksz_port_vlan_del(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_vlan *vlan);
-int ksz_port_mirror_add(struct dsa_switch *ds, int port,
-			struct dsa_mall_mirror_tc_entry *mirror,
-			bool ingress, struct netlink_ext_ack *extack);
-void ksz_port_mirror_del(struct dsa_switch *ds, int port,
-			 struct dsa_mall_mirror_tc_entry *mirror);
-int ksz_change_mtu(struct dsa_switch *ds, int port, int mtu);
-int ksz_max_mtu(struct dsa_switch *ds, int port);
+extern const struct ksz_chip_data ksz_switch_chips[];
 
 /* Common register access functions */
 
-- 
2.36.1

