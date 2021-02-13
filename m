Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C9031AE06
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBMUpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhBMUpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:45:12 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7FBC06178B
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:08 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id y26so5104591eju.13
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 12:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JSK4vz0I9asq+JeuVzbnb236TasqYkIyoBZV2dYqW8M=;
        b=CB8UOeRMHJqDFzrOEWINY/nQkV7w7Cv3NHPNn2FHbZVUvBMdoe3k+7BvR9HmMxsB2R
         SRuHOpaP9sVxFaakVKXfL4N6kssDSeZhfXvaEwxeJXFq38QRSlfkLzjar2W1IJ23hUg8
         ea6vgRe8tFOCDJi2Rztna8QxEnh2f9QLc7zzvqoo0XigeTzLTlqgHTeXN55SJc12q9w1
         iF6akpL085hdOBdHa40kg/YfrhNKYsCTbPWzD8dU5Bqd6Gfs/kCpbZdtQvVezHjVHJGG
         GWQbyu0sHv6rOdCuRviXBjPJS+ZAu/XJUUkspUxL0IyPjlLenldXj/Tcge1bnAZtVeS2
         fa7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JSK4vz0I9asq+JeuVzbnb236TasqYkIyoBZV2dYqW8M=;
        b=S0yUpc0YE4WT+6krRj4yRNcfkwLyMaL4ZwKE4UKNVAsB99T/aA/RWWaRVXXCeZh+OO
         wOIeTAHQEa1KhRVQdOgotpDujPWfsznH5jgUtisgmN6jIpwPGpBFO/xQYsGl7xksp4Pi
         nbntpc/XEIzYaZKOso9lxaKWkGUw+a3ZhXr+yX6nQ0CejBWrGOVG20dQgWlZSx7+2h2V
         +qF4L0NBZF2q89l/JJ23GTi+ow0zofzwgPNC/sXp8Cm1ygVO3anip/kONgcs1R4excHr
         PCLnIrXP2HsHcJHKzSWeDZIa7IlOpEQ70W6kC8fLWeH9vueF4iPyu3ZBULM3h3VNJ8Nf
         l0Cw==
X-Gm-Message-State: AOAM533IRNgbIfcdMi9ipu89GwomRGmczqdVWXzITO8q2DUIUf0HtHKo
        PFy+8DYXmAEF0sYw+Ju86SA=
X-Google-Smtp-Source: ABdhPJyrqFOOC1I1BNk7s55hl5iFIo4Pw7NheMlhQsdiTIHY8soB8EeGj2gjDUE25zrbCQXdWHZ3LA==
X-Received: by 2002:a17:906:fca:: with SMTP id c10mr8976938ejk.272.1613249047343;
        Sat, 13 Feb 2021 12:44:07 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p6sm2363937ejw.79.2021.02.13.12.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 12:44:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: [PATCH net-next 5/5] net: dsa: propagate extack to .port_vlan_filtering
Date:   Sat, 13 Feb 2021 22:43:19 +0200
Message-Id: <20210213204319.1226170-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213204319.1226170-1-olteanv@gmail.com>
References: <20210213204319.1226170-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some drivers can't dynamically change the VLAN filtering option, or
impose some restrictions, it would be nice to propagate this info
through netlink instead of printing it to a kernel log that might never
be read. Also netlink extack includes the module that emitted the
message, which means that it's easier to figure out which ones are
driver-generated errors as opposed to command misuse.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c          |  3 ++-
 drivers/net/dsa/b53/b53_priv.h            |  3 ++-
 drivers/net/dsa/dsa_loop.c                |  3 ++-
 drivers/net/dsa/hirschmann/hellcreek.c    |  3 ++-
 drivers/net/dsa/lantiq_gswip.c            | 10 +++++++---
 drivers/net/dsa/microchip/ksz8795.c       |  3 ++-
 drivers/net/dsa/microchip/ksz9477.c       |  3 ++-
 drivers/net/dsa/mt7530.c                  |  4 ++--
 drivers/net/dsa/mv88e6xxx/chip.c          |  3 ++-
 drivers/net/dsa/ocelot/felix.c            |  3 ++-
 drivers/net/dsa/qca8k.c                   |  3 ++-
 drivers/net/dsa/realtek-smi-core.h        |  4 ++--
 drivers/net/dsa/rtl8366.c                 |  3 ++-
 drivers/net/dsa/sja1105/sja1105.h         |  3 ++-
 drivers/net/dsa/sja1105/sja1105_devlink.c |  2 +-
 drivers/net/dsa/sja1105/sja1105_main.c    |  9 +++++----
 include/net/dsa.h                         |  3 ++-
 net/dsa/dsa_priv.h                        |  3 ++-
 net/dsa/port.c                            | 18 +++++++++++-------
 net/dsa/slave.c                           |  3 ++-
 net/dsa/switch.c                          |  6 +++++-
 21 files changed, 61 insertions(+), 34 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 98cc051e513e..ae86ded1e2a1 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1409,7 +1409,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_phylink_mac_link_up);
 
-int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
+int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+		       struct netlink_ext_ack *extack)
 {
 	struct b53_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index fc5d6fddb3fe..faf983fbca82 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -346,7 +346,8 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     struct phy_device *phydev,
 			     int speed, int duplex,
 			     bool tx_pause, bool rx_pause);
-int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering);
+int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+		       struct netlink_ext_ack *extack);
 int b53_vlan_add(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan,
 		 struct netlink_ext_ack *extack);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index e55b63a7e907..bfdf3324aac3 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -190,7 +190,8 @@ static void dsa_loop_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_vlan_filtering(struct dsa_switch *ds, int port,
-					bool vlan_filtering)
+					bool vlan_filtering,
+					struct netlink_ext_ack *extack)
 {
 	dev_dbg(ds->dev, "%s: port: %d, vlan_filtering: %d\n",
 		__func__, port, vlan_filtering);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 5816ef922e55..463137c39db2 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -875,7 +875,8 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
-				    bool vlan_filtering)
+				    bool vlan_filtering,
+				    struct netlink_ext_ack *extack)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 174ca3a484a0..52e865a3912c 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -727,14 +727,18 @@ static int gswip_pce_load_microcode(struct gswip_priv *priv)
 }
 
 static int gswip_port_vlan_filtering(struct dsa_switch *ds, int port,
-				     bool vlan_filtering)
+				     bool vlan_filtering,
+				     struct netlink_ext_ack *extack)
 {
 	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	struct gswip_priv *priv = ds->priv;
 
 	/* Do not allow changing the VLAN filtering options while in bridge */
-	if (bridge && !!(priv->port_vlan_filter & BIT(port)) != vlan_filtering)
+	if (bridge && !!(priv->port_vlan_filter & BIT(port)) != vlan_filtering) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Dynamic toggling of vlan_filtering not supported");
 		return -EIO;
+	}
 
 	if (vlan_filtering) {
 		/* Use port based VLAN tag */
@@ -773,7 +777,7 @@ static int gswip_setup(struct dsa_switch *ds)
 	/* disable port fetch/store dma on all ports */
 	for (i = 0; i < priv->hw_info->max_ports; i++) {
 		gswip_port_disable(ds, i);
-		gswip_port_vlan_filtering(ds, i, false);
+		gswip_port_vlan_filtering(ds, i, false, NULL);
 	}
 
 	/* enable Switch */
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 1e27a3e58141..b4b7de63ca79 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -783,7 +783,8 @@ static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 }
 
 static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag)
+				       bool flag,
+				       struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 772e34d5b6b8..55e5d479acce 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -493,7 +493,8 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 }
 
 static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag)
+				       bool flag,
+				       struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c089cd48e65d..c17de2bcf2fe 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1376,8 +1376,8 @@ mt7530_vlan_cmd(struct mt7530_priv *priv, enum mt7530_vlan_cmd cmd, u16 vid)
 }
 
 static int
-mt7530_port_vlan_filtering(struct dsa_switch *ds, int port,
-			   bool vlan_filtering)
+mt7530_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			   struct netlink_ext_ack *extack)
 {
 	if (vlan_filtering) {
 		/* The port is being kept as VLAN-unaware port when bridge is
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d46f0c096c97..903d619e08ed 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1600,7 +1600,8 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
-					 bool vlan_filtering)
+					 bool vlan_filtering,
+					 struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	u16 mode = vlan_filtering ? MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE :
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4db54d91eae2..c1e02d56dd45 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -643,7 +643,8 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 				   flags & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
-static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
+static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
+				struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 73978e7e85cd..cdaf9f85a2cb 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1294,7 +1294,8 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int
-qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
+qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			  struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = ds->priv;
 
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 93a3e05a6f71..fcf465f7f922 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -130,8 +130,8 @@ int rtl8366_enable_vlan4k(struct realtek_smi *smi, bool enable);
 int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
 int rtl8366_reset_vlan(struct realtek_smi *smi);
 int rtl8366_init_vlan(struct realtek_smi *smi);
-int rtl8366_vlan_filtering(struct dsa_switch *ds, int port,
-			   bool vlan_filtering);
+int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			   struct netlink_ext_ack *extack);
 int rtl8366_vlan_add(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan,
 		     struct netlink_ext_ack *extack);
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 76303a77aa82..75897a369096 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -340,7 +340,8 @@ int rtl8366_init_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_init_vlan);
 
-int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
+int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
+			   struct netlink_ext_ack *extack)
 {
 	struct realtek_smi *smi = ds->priv;
 	struct rtl8366_vlan_4k vlan4k;
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 15a0893d0ff1..90f0f6f3124e 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -247,7 +247,8 @@ enum sja1105_reset_reason {
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
 				 enum sja1105_reset_reason reason);
-int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled);
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
+			   struct netlink_ext_ack *extack);
 void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
 
 /* From sja1105_devlink.c */
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index b4bf1b10e66c..b6a4a16b8c7e 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -143,7 +143,7 @@ static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
 		dp = dsa_to_port(ds, port);
 		vlan_filtering = dsa_port_is_vlan_filtering(dp);
 
-		rc = sja1105_vlan_filtering(ds, port, vlan_filtering);
+		rc = sja1105_vlan_filtering(ds, port, vlan_filtering, NULL);
 		if (rc)
 			break;
 	}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 6aea8034c32b..85a39d599ff3 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2639,7 +2639,8 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv, bool notify)
  * which can only be partially reconfigured at runtime (and not the TPID).
  * So a switch reset is required.
  */
-int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
+			   struct netlink_ext_ack *extack)
 {
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
@@ -2653,8 +2654,8 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	list_for_each_entry(rule, &priv->flow_block.rules, list) {
 		if (rule->type == SJA1105_RULE_VL) {
-			dev_err(ds->dev,
-				"Cannot change VLAN filtering with active VL rules\n");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot change VLAN filtering with active VL rules");
 			return -EBUSY;
 		}
 	}
@@ -2736,7 +2737,7 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
-		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
+		NL_SET_ERR_MSG_MOD(extack, "Failed to change VLAN Ethertype");
 
 	/* Switch port identification based on 802.1Q is only passable
 	 * if we are not under a vlan_filtering bridge. So make sure
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 94dfe96df39a..f9e9c149322f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -639,7 +639,8 @@ struct dsa_switch_ops {
 	 * VLAN support
 	 */
 	int	(*port_vlan_filtering)(struct dsa_switch *ds, int port,
-				       bool vlan_filtering);
+				       bool vlan_filtering,
+				       struct netlink_ext_ack *extack);
 	int	(*port_vlan_add)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan,
 				 struct netlink_ext_ack *extack);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 17a9f82db937..e9d1e76c42ba 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -170,7 +170,8 @@ int dsa_port_lag_change(struct dsa_port *dp,
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
-int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering);
+int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
+			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 03ecefe1064a..14a1d0d77657 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -294,7 +294,8 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 
 /* Must be called under rcu_read_lock() */
 static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
-					      bool vlan_filtering)
+					      bool vlan_filtering,
+					      struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
 	int err, i;
@@ -324,8 +325,8 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 			 */
 			err = br_vlan_get_info(br, vid, &br_info);
 			if (err == 0) {
-				dev_err(ds->dev, "Must remove upper %s first\n",
-					upper_dev->name);
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Must first remove VLAN uppers having VIDs also present in bridge");
 				return false;
 			}
 		}
@@ -351,14 +352,16 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 		if (other_bridge == dp->bridge_dev)
 			continue;
 		if (br_vlan_enabled(other_bridge) != vlan_filtering) {
-			dev_err(ds->dev, "VLAN filtering is a global setting\n");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "VLAN filtering is a global setting");
 			return false;
 		}
 	}
 	return true;
 }
 
-int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering)
+int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
+			    struct netlink_ext_ack *extack)
 {
 	struct dsa_switch *ds = dp->ds;
 	bool apply;
@@ -372,7 +375,7 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering)
 	 * dsa_slave_switchdev_event().
 	 */
 	rcu_read_lock();
-	apply = dsa_port_can_apply_vlan_filtering(dp, vlan_filtering);
+	apply = dsa_port_can_apply_vlan_filtering(dp, vlan_filtering, extack);
 	rcu_read_unlock();
 	if (!apply)
 		return -EINVAL;
@@ -380,7 +383,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering)
 	if (dsa_port_is_vlan_filtering(dp) == vlan_filtering)
 		return 0;
 
-	err = ds->ops->port_vlan_filtering(ds, dp->index, vlan_filtering);
+	err = ds->ops->port_vlan_filtering(ds, dp->index, vlan_filtering,
+					   extack);
 	if (err)
 		return err;
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9ec487b63e13..5ecb43a1b6e0 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -286,7 +286,8 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 		ret = dsa_port_set_state(dp, attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering);
+		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
+					      extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index c82d201181a5..db2a9b221988 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -106,6 +106,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 {
 	bool unset_vlan_filtering = br_vlan_enabled(info->br);
 	struct dsa_switch_tree *dst = ds->dst;
+	struct netlink_ext_ack extack = {0};
 	int err, i;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
@@ -137,7 +138,10 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	}
 	if (unset_vlan_filtering) {
 		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      false);
+					      false, &extack);
+		if (extack._msg)
+			dev_err(ds->dev, "port %d: %s\n", info->port,
+				extack._msg);
 		if (err && err != EOPNOTSUPP)
 			return err;
 	}
-- 
2.25.1

