Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C882EFBF8
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbhAIADc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbhAIADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:03:32 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A10C0613D3
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:20 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id b9so16901129ejy.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N6hJg2/gY1Z5U4bxQvSlTi6oKIPm2cl40xptfMUpmiw=;
        b=J/ytXKWo60J6KfquTJuxSuHGQBRNoCzboA03pPGaJ37sXyxepc36/vo25ijKV4BJxl
         /y0aRHZCOgEbPYshLD0s7lIRh+gtbC/zwkPH4XLnkzPU7TSQ8XYsQ2zI/N0lm54qbAm8
         ErrT/8PSVYHuSVy5B6JZBepLJs4lJLVO1JvrdYRj7wchy/CvYpV5tXTSIMgexUkG+W6x
         iZmDQtOAe0+UArgh7cqVY4q73vnsqQoalZZ0pHZGJEM0h4WaBwsVvmr8+hlur7e8JWWb
         SMnZl5rwT5k0JYb2lnKxdIn5dEYfdx/1ThjnsuQvCq2E/gTatm6NeF8MKBS1jd+znmvf
         bviA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N6hJg2/gY1Z5U4bxQvSlTi6oKIPm2cl40xptfMUpmiw=;
        b=lJlgR5vhX9UYybWyTdgiRSY6ThERe7f2zGLSHAVW6kYRBCCemgpK292SzAKNF8HO7T
         xIdBqeh1E2NaMy3tWgbBSCIqCcDy3Zw0wszyO0jRnEvsmDafixLMyUof3b03Pz01yiLL
         AKr2F9VOD2XhOEIqEiFYTNgSimmmQoZA0ovmzT0d8j2dEQ2c75LcoXO1UmSuOnBkUr+F
         zpKISKomsp0NBa94BpIQbpQqCeB3bVmkj8TAaxmi/JkHGDrX4Sf00CZ+vqAIWwBqaWxp
         gjPIJsH0QuH+mL0Px2wuGpueoT2w95s14ux+2oBzKxOz+jq7Q+v2VQf1Ye6DLeTDWlE1
         Kdew==
X-Gm-Message-State: AOAM533vH/W8HwLWfGT/qjMs7JhCSPbnpEj3OCCB42vXy1C7K61skyCI
        o620K4lw0IwhPb3xzpn2TP2tsunAFvg=
X-Google-Smtp-Source: ABdhPJzv//Ywv4Odrb8SIR+BskW8yE+hnMN83iAZXOSD1Nv59zFpy/Jdr7ST9DBgz6nMui2vP5JR9Q==
X-Received: by 2002:a17:906:7f10:: with SMTP id d16mr4165139ejr.104.1610150538998;
        Fri, 08 Jan 2021 16:02:18 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:18 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 05/11] net: switchdev: remove the transaction structure from port attributes
Date:   Sat,  9 Jan 2021 02:01:50 +0200
Message-Id: <20210109000156.1246735-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the introduction of the switchdev API, port attributes were
transmitted to drivers for offloading using a two-step transactional
model, with a prepare phase that was supposed to catch all errors, and a
commit phase that was supposed to never fail.

Some classes of failures can never be avoided, like hardware access, or
memory allocation. In the latter case, merely attempting to move the
memory allocation to the preparation phase makes it impossible to avoid
memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
transaction item queue") which has removed the unused mechanism of
passing on the allocated memory between one phase and another.

It is time we admit that separating the preparation from the commit
phase is something that is best left for the driver to decide, and not
something that should be baked into the API, especially since there are
no switchdev callers that depend on this.

This patch removes the struct switchdev_trans member from switchdev port
attribute notifier structures, and converts drivers to not look at this
member.

In part, this patch contains a revert of my previous commit 2e554a7a5d8a
("net: dsa: propagate switchdev vlan_filtering prepare phase to
drivers").

For the most part, the conversion was trivial except for:
- Rocker's world implementation based on Broadcom OF-DPA had an odd
  implementation of ofdpa_port_attr_bridge_flags_set. The conversion was
  done mechanically, by pasting the implementation twice, then only
  keeping the code that would get executed during prepare phase on top,
  then only keeping the code that gets executed during the commit phase
  on bottom, then simplifying the resulting code until this was obtained.
- DSA's offloading of STP state, bridge flags, VLAN filtering and
  multicast router could be converted right away. But the ageing time
  could not, so a shim was introduced and this was left for a further
  commit.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
Reviewed-by: Linus Walleij <linus.walleij@linaro.org> # RTL8366RB
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/dsa/b53/b53_common.c              |  6 +-
 drivers/net/dsa/b53/b53_priv.h                |  3 +-
 drivers/net/dsa/dsa_loop.c                    |  3 +-
 drivers/net/dsa/hirschmann/hellcreek.c        |  6 +-
 drivers/net/dsa/lantiq_gswip.c                | 26 +----
 drivers/net/dsa/microchip/ksz8795.c           |  6 +-
 drivers/net/dsa/microchip/ksz9477.c           |  6 +-
 drivers/net/dsa/mt7530.c                      |  6 +-
 drivers/net/dsa/mv88e6xxx/chip.c              |  7 +-
 drivers/net/dsa/ocelot/felix.c                |  5 +-
 drivers/net/dsa/qca8k.c                       |  6 +-
 drivers/net/dsa/realtek-smi-core.h            |  3 +-
 drivers/net/dsa/rtl8366.c                     | 11 +--
 drivers/net/dsa/sja1105/sja1105.h             |  3 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c     |  9 +-
 drivers/net/dsa/sja1105/sja1105_main.c        | 17 ++--
 .../marvell/prestera/prestera_switchdev.c     | 37 ++-----
 .../mellanox/mlxsw/spectrum_switchdev.c       | 63 +++---------
 drivers/net/ethernet/mscc/ocelot.c            | 32 ++----
 drivers/net/ethernet/mscc/ocelot_net.c        | 13 +--
 drivers/net/ethernet/rocker/rocker.h          |  6 +-
 drivers/net/ethernet/rocker/rocker_main.c     | 46 +++------
 drivers/net/ethernet/rocker/rocker_ofdpa.c    | 23 ++---
 drivers/net/ethernet/ti/cpsw_switchdev.c      | 20 +---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       | 21 +---
 include/net/dsa.h                             |  3 +-
 include/net/switchdev.h                       |  7 +-
 include/soc/mscc/ocelot.h                     |  3 +-
 net/dsa/dsa_priv.h                            | 18 ++--
 net/dsa/port.c                                | 97 ++++++++-----------
 net/dsa/slave.c                               | 17 ++--
 net/dsa/switch.c                              | 11 +--
 net/switchdev/switchdev.c                     | 46 +--------
 33 files changed, 162 insertions(+), 424 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 7470fcd4da35..99c9b528884e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1374,14 +1374,10 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_phylink_mac_link_up);
 
-int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-		       struct switchdev_trans *trans)
+int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 {
 	struct b53_device *dev = ds->priv;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
 
 	return 0;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 7c67409bb186..24893b592216 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -347,8 +347,7 @@ void b53_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			     struct phy_device *phydev,
 			     int speed, int duplex,
 			     bool tx_pause, bool rx_pause);
-int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-		       struct switchdev_trans *trans);
+int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering);
 int b53_vlan_prepare(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_vlan *vlan);
 void b53_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 3be9f665d174..8e3d623f4dbd 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -190,8 +190,7 @@ static void dsa_loop_port_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int dsa_loop_port_vlan_filtering(struct dsa_switch *ds, int port,
-					bool vlan_filtering,
-					struct switchdev_trans *trans)
+					bool vlan_filtering)
 {
 	dev_dbg(ds->dev, "%s: port: %d, vlan_filtering: %d\n",
 		__func__, port, vlan_filtering);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index a59cc40170fc..4e1dbf91720c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -858,14 +858,10 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int hellcreek_vlan_filtering(struct dsa_switch *ds, int port,
-				    bool vlan_filtering,
-				    struct switchdev_trans *trans)
+				    bool vlan_filtering)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	dev_dbg(hellcreek->dev, "%s VLAN filtering on port %d\n",
 		vlan_filtering ? "Enable" : "Disable", port);
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index d35eb2cd2924..805421f354eb 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -727,23 +727,14 @@ static int gswip_pce_load_microcode(struct gswip_priv *priv)
 }
 
 static int gswip_port_vlan_filtering(struct dsa_switch *ds, int port,
-				     bool vlan_filtering,
-				     struct switchdev_trans *trans)
+				     bool vlan_filtering)
 {
+	struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
 	struct gswip_priv *priv = ds->priv;
 
 	/* Do not allow changing the VLAN filtering options while in bridge */
-	if (switchdev_trans_ph_prepare(trans)) {
-		struct net_device *bridge = dsa_to_port(ds, port)->bridge_dev;
-
-		if (!bridge)
-			return 0;
-
-		if (!!(priv->port_vlan_filter & BIT(port)) != vlan_filtering)
-			return -EIO;
-
-		return 0;
-	}
+	if (bridge && !!(priv->port_vlan_filter & BIT(port)) != vlan_filtering)
+		return -EIO;
 
 	if (vlan_filtering) {
 		/* Use port based VLAN tag */
@@ -781,15 +772,8 @@ static int gswip_setup(struct dsa_switch *ds)
 
 	/* disable port fetch/store dma on all ports */
 	for (i = 0; i < priv->hw_info->max_ports; i++) {
-		struct switchdev_trans trans;
-
-		/* Skip the prepare phase, this shouldn't return an error
-		 * during setup.
-		 */
-		trans.ph_prepare = false;
-
 		gswip_port_disable(ds, i);
-		gswip_port_vlan_filtering(ds, i, false, &trans);
+		gswip_port_vlan_filtering(ds, i, false);
 	}
 
 	/* enable Switch */
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index a4c814f6a4b5..6a9ec8a0f92f 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -783,14 +783,10 @@ static void ksz8795_flush_dyn_mac_table(struct ksz_device *dev, int port)
 }
 
 static int ksz8795_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag,
-				       struct switchdev_trans *trans)
+				       bool flag)
 {
 	struct ksz_device *dev = ds->priv;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	ksz_cfg(dev, S_MIRROR_CTRL, SW_VLAN_ENABLE, flag);
 
 	return 0;
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 5a6ac0749ab0..446c088ce5c5 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -493,14 +493,10 @@ static void ksz9477_flush_dyn_mac_table(struct ksz_device *dev, int port)
 }
 
 static int ksz9477_port_vlan_filtering(struct dsa_switch *ds, int port,
-				       bool flag,
-				       struct switchdev_trans *trans)
+				       bool flag)
 {
 	struct ksz_device *dev = ds->priv;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	if (flag) {
 		ksz_port_cfg(dev, port, REG_PORT_LUE_CTRL,
 			     PORT_VLAN_LOOKUP_VID_0, true);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 31d2d23bc815..fcaddc9c9370 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1376,12 +1376,8 @@ mt7530_vlan_cmd(struct mt7530_priv *priv, enum mt7530_vlan_cmd cmd, u16 vid)
 
 static int
 mt7530_port_vlan_filtering(struct dsa_switch *ds, int port,
-			   bool vlan_filtering,
-			   struct switchdev_trans *trans)
+			   bool vlan_filtering)
 {
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	if (vlan_filtering) {
 		/* The port is being kept as VLAN-unaware port when bridge is
 		 * set up with vlan_filtering not being set, Otherwise, the
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index fb25cb87156a..bbf1a71ce55c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1583,16 +1583,15 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
-					 bool vlan_filtering,
-					 struct switchdev_trans *trans)
+					 bool vlan_filtering)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	u16 mode = vlan_filtering ? MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE :
 		MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return mv88e6xxx_max_vid(chip) ? 0 : -EOPNOTSUPP;
+	if (!mv88e6xxx_max_vid(chip))
+		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_set_8021q_mode(chip, port, mode);
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 216fcfbc5daf..8c4cd9168dba 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -134,12 +134,11 @@ static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 				   flags & BRIDGE_VLAN_INFO_UNTAGGED);
 }
 
-static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
-				struct switchdev_trans *trans)
+static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_vlan_filtering(ocelot, port, enabled, trans);
+	return ocelot_port_vlan_filtering(ocelot, port, enabled);
 }
 
 static void felix_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index df99c696b688..1de6473b221b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1294,14 +1294,10 @@ qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 }
 
 static int
-qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-			  struct switchdev_trans *trans)
+qca8k_port_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 {
 	struct qca8k_priv *priv = ds->priv;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	if (vlan_filtering) {
 		qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(port),
 			  QCA8K_PORT_LOOKUP_VLAN_MODE,
diff --git a/drivers/net/dsa/realtek-smi-core.h b/drivers/net/dsa/realtek-smi-core.h
index 6b6a3dec0984..bc7bd47fb037 100644
--- a/drivers/net/dsa/realtek-smi-core.h
+++ b/drivers/net/dsa/realtek-smi-core.h
@@ -131,8 +131,7 @@ int rtl8366_enable_vlan(struct realtek_smi *smi, bool enable);
 int rtl8366_reset_vlan(struct realtek_smi *smi);
 int rtl8366_init_vlan(struct realtek_smi *smi);
 int rtl8366_vlan_filtering(struct dsa_switch *ds, int port,
-			   bool vlan_filtering,
-			   struct switchdev_trans *trans);
+			   bool vlan_filtering);
 int rtl8366_vlan_prepare(struct dsa_switch *ds, int port,
 			 const struct switchdev_obj_port_vlan *vlan);
 void rtl8366_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index 1a8f93112bc6..27f429aa89a6 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -340,20 +340,15 @@ int rtl8366_init_vlan(struct realtek_smi *smi)
 }
 EXPORT_SYMBOL_GPL(rtl8366_init_vlan);
 
-int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering,
-			   struct switchdev_trans *trans)
+int rtl8366_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 {
 	struct realtek_smi *smi = ds->priv;
 	struct rtl8366_vlan_4k vlan4k;
 	int ret;
 
 	/* Use VLAN nr port + 1 since VLAN0 is not valid */
-	if (switchdev_trans_ph_prepare(trans)) {
-		if (!smi->ops->is_vlan_valid(smi, port + 1))
-			return -EINVAL;
-
-		return 0;
-	}
+	if (!smi->ops->is_vlan_valid(smi, port + 1))
+		return -EINVAL;
 
 	dev_info(smi->dev, "%s filtering on port %d\n",
 		 vlan_filtering ? "enable" : "disable",
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 4ebc4a5a7b35..d582308c2401 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -245,8 +245,7 @@ enum sja1105_reset_reason {
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
 				 enum sja1105_reset_reason reason);
-int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
-			   struct switchdev_trans *trans);
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled);
 void sja1105_frame_memory_partitioning(struct sja1105_private *priv);
 
 /* From sja1105_devlink.c */
diff --git a/drivers/net/dsa/sja1105/sja1105_devlink.c b/drivers/net/dsa/sja1105/sja1105_devlink.c
index 4a2ec395bcb0..b4bf1b10e66c 100644
--- a/drivers/net/dsa/sja1105/sja1105_devlink.c
+++ b/drivers/net/dsa/sja1105/sja1105_devlink.c
@@ -135,7 +135,6 @@ static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
 
 	rtnl_lock();
 	for (port = 0; port < ds->num_ports; port++) {
-		struct switchdev_trans trans;
 		struct dsa_port *dp;
 
 		if (!dsa_is_user_port(ds, port))
@@ -144,13 +143,7 @@ static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
 		dp = dsa_to_port(ds, port);
 		vlan_filtering = dsa_port_is_vlan_filtering(dp);
 
-		trans.ph_prepare = true;
-		rc = sja1105_vlan_filtering(ds, port, vlan_filtering, &trans);
-		if (rc)
-			break;
-
-		trans.ph_prepare = false;
-		rc = sja1105_vlan_filtering(ds, port, vlan_filtering, &trans);
+		rc = sja1105_vlan_filtering(ds, port, vlan_filtering);
 		if (rc)
 			break;
 	}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 807e65ac2518..c1b7f2b0e40c 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2631,8 +2631,7 @@ static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
  * which can only be partially reconfigured at runtime (and not the TPID).
  * So a switch reset is required.
  */
-int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
-			   struct switchdev_trans *trans)
+int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 {
 	struct sja1105_l2_lookup_params_entry *l2_lookup_params;
 	struct sja1105_general_params_entry *general_params;
@@ -2644,16 +2643,12 @@ int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 	u16 tpid, tpid2;
 	int rc;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		list_for_each_entry(rule, &priv->flow_block.rules, list) {
-			if (rule->type == SJA1105_RULE_VL) {
-				dev_err(ds->dev,
-					"Cannot change VLAN filtering with active VL rules\n");
-				return -EBUSY;
-			}
+	list_for_each_entry(rule, &priv->flow_block.rules, list) {
+		if (rule->type == SJA1105_RULE_VL) {
+			dev_err(ds->dev,
+				"Cannot change VLAN filtering with active VL rules\n");
+			return -EBUSY;
 		}
-
-		return 0;
 	}
 
 	if (enabled) {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3235458a5501..e2374a39e4f8 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -580,16 +580,12 @@ int prestera_bridge_port_event(struct net_device *dev, unsigned long event,
 }
 
 static int prestera_port_attr_br_flags_set(struct prestera_port *port,
-					   struct switchdev_trans *trans,
 					   struct net_device *dev,
 					   unsigned long flags)
 {
 	struct prestera_bridge_port *br_port;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
 	if (!br_port)
 		return 0;
@@ -608,35 +604,26 @@ static int prestera_port_attr_br_flags_set(struct prestera_port *port,
 }
 
 static int prestera_port_attr_br_ageing_set(struct prestera_port *port,
-					    struct switchdev_trans *trans,
 					    unsigned long ageing_clock_t)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
 	u32 ageing_time_ms = jiffies_to_msecs(ageing_jiffies);
 	struct prestera_switch *sw = port->sw;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		if (ageing_time_ms < PRESTERA_MIN_AGEING_TIME_MS ||
-		    ageing_time_ms > PRESTERA_MAX_AGEING_TIME_MS)
-			return -ERANGE;
-		else
-			return 0;
-	}
+	if (ageing_time_ms < PRESTERA_MIN_AGEING_TIME_MS ||
+	    ageing_time_ms > PRESTERA_MAX_AGEING_TIME_MS)
+		return -ERANGE;
 
 	return prestera_hw_switch_ageing_set(sw, ageing_time_ms);
 }
 
 static int prestera_port_attr_br_vlan_set(struct prestera_port *port,
-					  struct switchdev_trans *trans,
 					  struct net_device *dev,
 					  bool vlan_enabled)
 {
 	struct prestera_switch *sw = port->sw;
 	struct prestera_bridge *bridge;
 
-	if (!switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	bridge = prestera_bridge_by_dev(sw->swdev, dev);
 	if (WARN_ON(!bridge))
 		return -EINVAL;
@@ -666,7 +653,6 @@ static int prestera_port_bridge_vlan_stp_set(struct prestera_port *port,
 }
 
 static int presterar_port_attr_stp_state_set(struct prestera_port *port,
-					     struct switchdev_trans *trans,
 					     struct net_device *dev,
 					     u8 state)
 {
@@ -675,9 +661,6 @@ static int presterar_port_attr_stp_state_set(struct prestera_port *port,
 	int err;
 	u16 vid;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	br_port = prestera_bridge_port_by_dev(port->sw->swdev, dev);
 	if (!br_port)
 		return 0;
@@ -712,16 +695,14 @@ static int presterar_port_attr_stp_state_set(struct prestera_port *port,
 }
 
 static int prestera_port_obj_attr_set(struct net_device *dev,
-				      const struct switchdev_attr *attr,
-				      struct switchdev_trans *trans)
+				      const struct switchdev_attr *attr)
 {
 	struct prestera_port *port = netdev_priv(dev);
 	int err = 0;
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		err = presterar_port_attr_stp_state_set(port, trans,
-							attr->orig_dev,
+		err = presterar_port_attr_stp_state_set(port, attr->orig_dev,
 							attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
@@ -730,17 +711,15 @@ static int prestera_port_obj_attr_set(struct net_device *dev,
 			err = -EINVAL;
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-		err = prestera_port_attr_br_flags_set(port, trans,
-						      attr->orig_dev,
+		err = prestera_port_attr_br_flags_set(port, attr->orig_dev,
 						      attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
-		err = prestera_port_attr_br_ageing_set(port, trans,
+		err = prestera_port_attr_br_ageing_set(port,
 						       attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		err = prestera_port_attr_br_vlan_set(port, trans,
-						     attr->orig_dev,
+		err = prestera_port_attr_br_vlan_set(port, attr->orig_dev,
 						     attr->u.vlan_filtering);
 		break;
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index eff5920aed06..409c206f813f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -527,7 +527,6 @@ mlxsw_sp_port_bridge_vlan_stp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_attr_stp_state_set(struct mlxsw_sp_port *mlxsw_sp_port,
-					    struct switchdev_trans *trans,
 					    struct net_device *orig_dev,
 					    u8 state)
 {
@@ -535,9 +534,6 @@ static int mlxsw_sp_port_attr_stp_state_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp_bridge_vlan *bridge_vlan;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	/* It's possible we failed to enslave the port, yet this
 	 * operation is executed due to it being deferred.
 	 */
@@ -659,7 +655,6 @@ mlxsw_sp_bridge_port_learning_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port
 					       *mlxsw_sp_port,
-					       struct switchdev_trans *trans,
 					       unsigned long brport_flags)
 {
 	if (brport_flags & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
@@ -669,16 +664,12 @@ static int mlxsw_sp_port_attr_br_pre_flags_set(struct mlxsw_sp_port
 }
 
 static int mlxsw_sp_port_attr_br_flags_set(struct mlxsw_sp_port *mlxsw_sp_port,
-					   struct switchdev_trans *trans,
 					   struct net_device *orig_dev,
 					   unsigned long brport_flags)
 {
 	struct mlxsw_sp_bridge_port *bridge_port;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp_port->mlxsw_sp->bridge,
 						orig_dev);
 	if (!bridge_port)
@@ -724,35 +715,26 @@ static int mlxsw_sp_ageing_set(struct mlxsw_sp *mlxsw_sp, u32 ageing_time)
 }
 
 static int mlxsw_sp_port_attr_br_ageing_set(struct mlxsw_sp_port *mlxsw_sp_port,
-					    struct switchdev_trans *trans,
 					    unsigned long ageing_clock_t)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock_t);
 	u32 ageing_time = jiffies_to_msecs(ageing_jiffies) / 1000;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		if (ageing_time < MLXSW_SP_MIN_AGEING_TIME ||
-		    ageing_time > MLXSW_SP_MAX_AGEING_TIME)
-			return -ERANGE;
-		else
-			return 0;
-	}
+	if (ageing_time < MLXSW_SP_MIN_AGEING_TIME ||
+	    ageing_time > MLXSW_SP_MAX_AGEING_TIME)
+		return -ERANGE;
 
 	return mlxsw_sp_ageing_set(mlxsw_sp, ageing_time);
 }
 
 static int mlxsw_sp_port_attr_br_vlan_set(struct mlxsw_sp_port *mlxsw_sp_port,
-					  struct switchdev_trans *trans,
 					  struct net_device *orig_dev,
 					  bool vlan_enabled)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_bridge_device *bridge_device;
 
-	if (!switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, orig_dev);
 	if (WARN_ON(!bridge_device))
 		return -EINVAL;
@@ -765,16 +747,12 @@ static int mlxsw_sp_port_attr_br_vlan_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_attr_br_vlan_proto_set(struct mlxsw_sp_port *mlxsw_sp_port,
-						struct switchdev_trans *trans,
 						struct net_device *orig_dev,
 						u16 vlan_proto)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_bridge_device *bridge_device;
 
-	if (!switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	bridge_device = mlxsw_sp_bridge_device_find(mlxsw_sp->bridge, orig_dev);
 	if (WARN_ON(!bridge_device))
 		return -EINVAL;
@@ -784,16 +762,12 @@ static int mlxsw_sp_port_attr_br_vlan_proto_set(struct mlxsw_sp_port *mlxsw_sp_p
 }
 
 static int mlxsw_sp_port_attr_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
-					  struct switchdev_trans *trans,
 					  struct net_device *orig_dev,
 					  bool is_port_mrouter)
 {
 	struct mlxsw_sp_bridge_port *bridge_port;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	bridge_port = mlxsw_sp_bridge_port_find(mlxsw_sp_port->mlxsw_sp->bridge,
 						orig_dev);
 	if (!bridge_port)
@@ -825,7 +799,6 @@ static bool mlxsw_sp_mc_flood(const struct mlxsw_sp_bridge_port *bridge_port)
 }
 
 static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
-					 struct switchdev_trans *trans,
 					 struct net_device *orig_dev,
 					 bool mc_disabled)
 {
@@ -834,9 +807,6 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	struct mlxsw_sp_bridge_port *bridge_port;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	/* It's possible we failed to enslave the port, yet this
 	 * operation is executed due to it being deferred.
 	 */
@@ -896,16 +866,12 @@ mlxsw_sp_bridge_mrouter_update_mdb(struct mlxsw_sp *mlxsw_sp,
 
 static int
 mlxsw_sp_port_attr_br_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				  struct switchdev_trans *trans,
 				  struct net_device *orig_dev,
 				  bool is_mrouter)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_bridge_device *bridge_device;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	/* It's possible we failed to enslave the port, yet this
 	 * operation is executed due to it being deferred.
 	 */
@@ -921,54 +887,52 @@ mlxsw_sp_port_attr_br_mrouter_set(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int mlxsw_sp_port_attr_set(struct net_device *dev,
-				  const struct switchdev_attr *attr,
-				  struct switchdev_trans *trans)
+				  const struct switchdev_attr *attr)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	int err;
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		err = mlxsw_sp_port_attr_stp_state_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_attr_stp_state_set(mlxsw_sp_port,
 						       attr->orig_dev,
 						       attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		err = mlxsw_sp_port_attr_br_pre_flags_set(mlxsw_sp_port,
-							  trans,
 							  attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-		err = mlxsw_sp_port_attr_br_flags_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_attr_br_flags_set(mlxsw_sp_port,
 						      attr->orig_dev,
 						      attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
-		err = mlxsw_sp_port_attr_br_ageing_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_attr_br_ageing_set(mlxsw_sp_port,
 						       attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		err = mlxsw_sp_port_attr_br_vlan_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_attr_br_vlan_set(mlxsw_sp_port,
 						     attr->orig_dev,
 						     attr->u.vlan_filtering);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL:
-		err = mlxsw_sp_port_attr_br_vlan_proto_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_attr_br_vlan_proto_set(mlxsw_sp_port,
 							   attr->orig_dev,
 							   attr->u.vlan_protocol);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_MROUTER:
-		err = mlxsw_sp_port_attr_mrouter_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_attr_mrouter_set(mlxsw_sp_port,
 						     attr->orig_dev,
 						     attr->u.mrouter);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
-		err = mlxsw_sp_port_mc_disabled_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_mc_disabled_set(mlxsw_sp_port,
 						    attr->orig_dev,
 						    attr->u.mc_disabled);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
-		err = mlxsw_sp_port_attr_br_mrouter_set(mlxsw_sp_port, trans,
+		err = mlxsw_sp_port_attr_br_mrouter_set(mlxsw_sp_port,
 							attr->orig_dev,
 							attr->u.mrouter);
 		break;
@@ -977,8 +941,7 @@ static int mlxsw_sp_port_attr_set(struct net_device *dev,
 		break;
 	}
 
-	if (switchdev_trans_ph_commit(trans))
-		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
+	mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 0b9992bd6626..af620f7ce469 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -208,25 +208,20 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 }
 
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-			       bool vlan_aware, struct switchdev_trans *trans)
+			       bool vlan_aware)
 {
+	struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct ocelot_vcap_filter *filter;
 	u32 val;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
-		struct ocelot_vcap_filter *filter;
-
-		list_for_each_entry(filter, &block->rules, list) {
-			if (filter->ingress_port_mask & BIT(port) &&
-			    filter->action.vid_replace_ena) {
-				dev_err(ocelot->dev,
-					"Cannot change VLAN state with vlan modify rules active\n");
-				return -EBUSY;
-			}
+	list_for_each_entry(filter, &block->rules, list) {
+		if (filter->ingress_port_mask & BIT(port) &&
+		    filter->action.vid_replace_ena) {
+			dev_err(ocelot->dev,
+				"Cannot change VLAN state with vlan modify rules active\n");
+			return -EBUSY;
 		}
-
-		return 0;
 	}
 
 	ocelot_port->vlan_aware = vlan_aware;
@@ -1179,7 +1174,6 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 			     struct net_device *bridge)
 {
 	struct ocelot_vlan pvid = {0}, native_vlan = {0};
-	struct switchdev_trans trans;
 	int ret;
 
 	ocelot->bridge_mask &= ~BIT(port);
@@ -1187,13 +1181,7 @@ int ocelot_port_bridge_leave(struct ocelot *ocelot, int port,
 	if (!ocelot->bridge_mask)
 		ocelot->hw_bridge_dev = NULL;
 
-	trans.ph_prepare = true;
-	ret = ocelot_port_vlan_filtering(ocelot, port, false, &trans);
-	if (ret)
-		return ret;
-
-	trans.ph_prepare = false;
-	ret = ocelot_port_vlan_filtering(ocelot, port, false, &trans);
+	ret = ocelot_port_vlan_filtering(ocelot, port, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 16d958a6e206..4fb9095be3ea 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -825,12 +825,8 @@ static const struct ethtool_ops ocelot_ethtool_ops = {
 };
 
 static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
-					   struct switchdev_trans *trans,
 					   u8 state)
 {
-	if (switchdev_trans_ph_prepare(trans))
-		return;
-
 	ocelot_bridge_stp_state_set(ocelot, port, state);
 }
 
@@ -858,8 +854,7 @@ static void ocelot_port_attr_mc_set(struct ocelot *ocelot, int port, bool mc)
 }
 
 static int ocelot_port_attr_set(struct net_device *dev,
-				const struct switchdev_attr *attr,
-				struct switchdev_trans *trans)
+				const struct switchdev_attr *attr)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
@@ -868,15 +863,13 @@ static int ocelot_port_attr_set(struct net_device *dev,
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		ocelot_port_attr_stp_state_set(ocelot, port, trans,
-					       attr->u.stp_state);
+		ocelot_port_attr_stp_state_set(ocelot, port, attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ocelot_port_vlan_filtering(ocelot, port,
-					   attr->u.vlan_filtering, trans);
+		ocelot_port_vlan_filtering(ocelot, port, attr->u.vlan_filtering);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
diff --git a/drivers/net/ethernet/rocker/rocker.h b/drivers/net/ethernet/rocker/rocker.h
index 6fad25321dc5..315a6e5c0f59 100644
--- a/drivers/net/ethernet/rocker/rocker.h
+++ b/drivers/net/ethernet/rocker/rocker.h
@@ -103,15 +103,13 @@ struct rocker_world_ops {
 	int (*port_attr_stp_state_set)(struct rocker_port *rocker_port,
 				       u8 state);
 	int (*port_attr_bridge_flags_set)(struct rocker_port *rocker_port,
-					  unsigned long brport_flags,
-					  struct switchdev_trans *trans);
+					  unsigned long brport_flags);
 	int (*port_attr_bridge_flags_support_get)(const struct rocker_port *
 						  rocker_port,
 						  unsigned long *
 						  p_brport_flags);
 	int (*port_attr_bridge_ageing_time_set)(struct rocker_port *rocker_port,
-						u32 ageing_time,
-						struct switchdev_trans *trans);
+						u32 ageing_time);
 	int (*port_obj_vlan_add)(struct rocker_port *rocker_port,
 				 const struct switchdev_obj_port_vlan *vlan);
 	int (*port_obj_vlan_del)(struct rocker_port *rocker_port,
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 1018d3759316..740a715c49c6 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1550,17 +1550,13 @@ static void rocker_world_port_stop(struct rocker_port *rocker_port)
 }
 
 static int rocker_world_port_attr_stp_state_set(struct rocker_port *rocker_port,
-						u8 state,
-						struct switchdev_trans *trans)
+						u8 state)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
 	if (!wops->port_attr_stp_state_set)
 		return -EOPNOTSUPP;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	return wops->port_attr_stp_state_set(rocker_port, state);
 }
 
@@ -1580,8 +1576,7 @@ rocker_world_port_attr_bridge_flags_support_get(const struct rocker_port *
 
 static int
 rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
-					    unsigned long brport_flags,
-					    struct switchdev_trans *trans)
+					    unsigned long brport_flags)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 	unsigned long brport_flags_s;
@@ -1603,37 +1598,26 @@ rocker_world_port_attr_pre_bridge_flags_set(struct rocker_port *rocker_port,
 
 static int
 rocker_world_port_attr_bridge_flags_set(struct rocker_port *rocker_port,
-					unsigned long brport_flags,
-					struct switchdev_trans *trans)
+					unsigned long brport_flags)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
 	if (!wops->port_attr_bridge_flags_set)
 		return -EOPNOTSUPP;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
-	return wops->port_attr_bridge_flags_set(rocker_port, brport_flags,
-						trans);
+	return wops->port_attr_bridge_flags_set(rocker_port, brport_flags);
 }
 
 static int
 rocker_world_port_attr_bridge_ageing_time_set(struct rocker_port *rocker_port,
-					      u32 ageing_time,
-					      struct switchdev_trans *trans)
-
+					      u32 ageing_time)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
 	if (!wops->port_attr_bridge_ageing_time_set)
 		return -EOPNOTSUPP;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
-	return wops->port_attr_bridge_ageing_time_set(rocker_port, ageing_time,
-						      trans);
+	return wops->port_attr_bridge_ageing_time_set(rocker_port, ageing_time);
 }
 
 static int
@@ -2062,8 +2046,7 @@ static const struct net_device_ops rocker_port_netdev_ops = {
  ********************/
 
 static int rocker_port_attr_set(struct net_device *dev,
-				const struct switchdev_attr *attr,
-				struct switchdev_trans *trans)
+				const struct switchdev_attr *attr)
 {
 	struct rocker_port *rocker_port = netdev_priv(dev);
 	int err = 0;
@@ -2071,23 +2054,19 @@ static int rocker_port_attr_set(struct net_device *dev,
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		err = rocker_world_port_attr_stp_state_set(rocker_port,
-							   attr->u.stp_state,
-							   trans);
+							   attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		err = rocker_world_port_attr_pre_bridge_flags_set(rocker_port,
-							      attr->u.brport_flags,
-							      trans);
+							      attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
 		err = rocker_world_port_attr_bridge_flags_set(rocker_port,
-							      attr->u.brport_flags,
-							      trans);
+							      attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
 		err = rocker_world_port_attr_bridge_ageing_time_set(rocker_port,
-								    attr->u.ageing_time,
-								    trans);
+								    attr->u.ageing_time);
 		break;
 	default:
 		err = -EOPNOTSUPP;
@@ -2719,8 +2698,7 @@ rocker_switchdev_port_attr_set_event(struct net_device *netdev,
 {
 	int err;
 
-	err = rocker_port_attr_set(netdev, port_attr_info->attr,
-				   port_attr_info->trans);
+	err = rocker_port_attr_set(netdev, port_attr_info->attr);
 
 	port_attr_info->handled = true;
 	return notifier_from_errno(err);
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index d9d5188b7627..d067da1ef070 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -2488,8 +2488,7 @@ static int ofdpa_port_attr_stp_state_set(struct rocker_port *rocker_port,
 }
 
 static int ofdpa_port_attr_bridge_flags_set(struct rocker_port *rocker_port,
-					    unsigned long brport_flags,
-					    struct switchdev_trans *trans)
+					    unsigned long brport_flags)
 {
 	struct ofdpa_port *ofdpa_port = rocker_port->wpriv;
 	unsigned long orig_flags;
@@ -2497,14 +2496,11 @@ static int ofdpa_port_attr_bridge_flags_set(struct rocker_port *rocker_port,
 
 	orig_flags = ofdpa_port->brport_flags;
 	ofdpa_port->brport_flags = brport_flags;
-	if ((orig_flags ^ ofdpa_port->brport_flags) & BR_LEARNING &&
-	    !switchdev_trans_ph_prepare(trans))
+
+	if ((orig_flags ^ ofdpa_port->brport_flags) & BR_LEARNING)
 		err = rocker_port_set_learning(ofdpa_port->rocker_port,
 					       !!(ofdpa_port->brport_flags & BR_LEARNING));
 
-	if (switchdev_trans_ph_prepare(trans))
-		ofdpa_port->brport_flags = orig_flags;
-
 	return err;
 }
 
@@ -2520,18 +2516,15 @@ ofdpa_port_attr_bridge_flags_support_get(const struct rocker_port *
 
 static int
 ofdpa_port_attr_bridge_ageing_time_set(struct rocker_port *rocker_port,
-				       u32 ageing_time,
-				       struct switchdev_trans *trans)
+				       u32 ageing_time)
 {
 	struct ofdpa_port *ofdpa_port = rocker_port->wpriv;
 	struct ofdpa *ofdpa = ofdpa_port->ofdpa;
 
-	if (!switchdev_trans_ph_prepare(trans)) {
-		ofdpa_port->ageing_time = clock_t_to_jiffies(ageing_time);
-		if (ofdpa_port->ageing_time < ofdpa->ageing_time)
-			ofdpa->ageing_time = ofdpa_port->ageing_time;
-		mod_timer(&ofdpa_port->ofdpa->fdb_cleanup_timer, jiffies);
-	}
+	ofdpa_port->ageing_time = clock_t_to_jiffies(ageing_time);
+	if (ofdpa_port->ageing_time < ofdpa->ageing_time)
+		ofdpa->ageing_time = ofdpa_port->ageing_time;
+	mod_timer(&ofdpa_port->ofdpa->fdb_cleanup_timer, jiffies);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 3232f483c068..9967cf985728 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -24,16 +24,12 @@ struct cpsw_switchdev_event_work {
 	unsigned long event;
 };
 
-static int cpsw_port_stp_state_set(struct cpsw_priv *priv,
-				   struct switchdev_trans *trans, u8 state)
+static int cpsw_port_stp_state_set(struct cpsw_priv *priv, u8 state)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 	u8 cpsw_state;
 	int ret = 0;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	switch (state) {
 	case BR_STATE_FORWARDING:
 		cpsw_state = ALE_PORT_STATE_FORWARD;
@@ -60,16 +56,12 @@ static int cpsw_port_stp_state_set(struct cpsw_priv *priv,
 }
 
 static int cpsw_port_attr_br_flags_set(struct cpsw_priv *priv,
-				       struct switchdev_trans *trans,
 				       struct net_device *orig_dev,
 				       unsigned long brport_flags)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
 	bool unreg_mcast_add = false;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	if (brport_flags & BR_MCAST_FLOOD)
 		unreg_mcast_add = true;
 	dev_dbg(priv->dev, "BR_MCAST_FLOOD: %d port %u\n",
@@ -82,7 +74,6 @@ static int cpsw_port_attr_br_flags_set(struct cpsw_priv *priv,
 }
 
 static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
-					   struct switchdev_trans *trans,
 					   unsigned long flags)
 {
 	if (flags & ~(BR_LEARNING | BR_MCAST_FLOOD))
@@ -92,8 +83,7 @@ static int cpsw_port_attr_br_flags_pre_set(struct net_device *netdev,
 }
 
 static int cpsw_port_attr_set(struct net_device *ndev,
-			      const struct switchdev_attr *attr,
-			      struct switchdev_trans *trans)
+			      const struct switchdev_attr *attr)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	int ret;
@@ -102,15 +92,15 @@ static int cpsw_port_attr_set(struct net_device *ndev,
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		ret = cpsw_port_attr_br_flags_pre_set(ndev, trans,
+		ret = cpsw_port_attr_br_flags_pre_set(ndev,
 						      attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		ret = cpsw_port_stp_state_set(priv, trans, attr->u.stp_state);
+		ret = cpsw_port_stp_state_set(priv, attr->u.stp_state);
 		dev_dbg(priv->dev, "stp state: %u\n", attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-		ret = cpsw_port_attr_br_flags_set(priv, trans, attr->orig_dev,
+		ret = cpsw_port_attr_br_flags_set(priv, attr->orig_dev,
 						  attr->u.brport_flags);
 		break;
 	default:
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index 197dea9c3b42..ca3d07fe7f58 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -901,19 +901,14 @@ static void dpaa2_switch_teardown_irqs(struct fsl_mc_device *sw_dev)
 }
 
 static int dpaa2_switch_port_attr_stp_state_set(struct net_device *netdev,
-						struct switchdev_trans *trans,
 						u8 state)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	return dpaa2_switch_port_set_stp_state(port_priv, state);
 }
 
 static int dpaa2_switch_port_attr_br_flags_pre_set(struct net_device *netdev,
-						   struct switchdev_trans *trans,
 						   unsigned long flags)
 {
 	if (flags & ~(BR_LEARNING | BR_FLOOD))
@@ -923,15 +918,11 @@ static int dpaa2_switch_port_attr_br_flags_pre_set(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_attr_br_flags_set(struct net_device *netdev,
-					       struct switchdev_trans *trans,
 					       unsigned long flags)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	int err = 0;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	/* Learning is enabled per switch */
 	err = dpaa2_switch_set_learning(port_priv->ethsw_data,
 					!!(flags & BR_LEARNING));
@@ -945,22 +936,21 @@ static int dpaa2_switch_port_attr_br_flags_set(struct net_device *netdev,
 }
 
 static int dpaa2_switch_port_attr_set(struct net_device *netdev,
-				      const struct switchdev_attr *attr,
-				      struct switchdev_trans *trans)
+				      const struct switchdev_attr *attr)
 {
 	int err = 0;
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		err = dpaa2_switch_port_attr_stp_state_set(netdev, trans,
+		err = dpaa2_switch_port_attr_stp_state_set(netdev,
 							   attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		err = dpaa2_switch_port_attr_br_flags_pre_set(netdev, trans,
+		err = dpaa2_switch_port_attr_br_flags_pre_set(netdev,
 							      attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-		err = dpaa2_switch_port_attr_br_flags_set(netdev, trans,
+		err = dpaa2_switch_port_attr_br_flags_set(netdev,
 							  attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
@@ -1197,8 +1187,7 @@ static int dpaa2_switch_port_attr_set_event(struct net_device *netdev,
 {
 	int err;
 
-	err = dpaa2_switch_port_attr_set(netdev, port_attr_info->attr,
-					 port_attr_info->trans);
+	err = dpaa2_switch_port_attr_set(netdev, port_attr_info->attr);
 
 	port_attr_info->handled = true;
 	return notifier_from_errno(err);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9a0cab5fb7c4..d0f043091969 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -565,8 +565,7 @@ struct dsa_switch_ops {
 	 * VLAN support
 	 */
 	int	(*port_vlan_filtering)(struct dsa_switch *ds, int port,
-				       bool vlan_filtering,
-				       struct switchdev_trans *trans);
+				       bool vlan_filtering);
 	int (*port_vlan_prepare)(struct dsa_switch *ds, int port,
 				 const struct switchdev_obj_port_vlan *vlan);
 	void (*port_vlan_add)(struct dsa_switch *ds, int port,
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index cbe6e35d51f5..f873e2c5e125 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -239,7 +239,6 @@ struct switchdev_notifier_port_obj_info {
 struct switchdev_notifier_port_attr_info {
 	struct switchdev_notifier_info info; /* must be first */
 	const struct switchdev_attr *attr;
-	struct switchdev_trans *trans;
 	bool handled;
 };
 
@@ -298,8 +297,7 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr,
-				      struct switchdev_trans *trans));
+				      const struct switchdev_attr *attr));
 #else
 
 static inline void switchdev_deferred_process(void)
@@ -390,8 +388,7 @@ switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr,
-				      struct switchdev_trans *trans))
+				      const struct switchdev_attr *attr))
 {
 	return 0;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 2f4cd3288bcc..f3db75c0172b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -739,8 +739,7 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
 void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			struct phy_device *phydev);
-int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
-			       struct switchdev_trans *trans);
+int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 int ocelot_port_bridge_join(struct ocelot *ocelot, int port,
 			    struct net_device *bridge);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index ebbc900a37c6..d1071c9fdaa1 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -137,19 +137,16 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 }
 
 /* port.c */
-int dsa_port_set_state(struct dsa_port *dp, u8 state,
-		       struct switchdev_trans *trans);
+int dsa_port_set_state(struct dsa_port *dp, u8 state);
 int dsa_port_enable_rt(struct dsa_port *dp, struct phy_device *phy);
 int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy);
 void dsa_port_disable_rt(struct dsa_port *dp);
 void dsa_port_disable(struct dsa_port *dp);
 int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br);
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br);
-int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
-			    struct switchdev_trans *trans);
+int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
-int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
-			 struct switchdev_trans *trans);
+int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
 int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
 			bool propagate_upstream);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
@@ -161,12 +158,9 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
-			      struct switchdev_trans *trans);
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
-			  struct switchdev_trans *trans);
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct switchdev_trans *trans);
+int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags);
+int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags);
+int dsa_port_mrouter(struct dsa_port *dp, bool mrouter);
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_vlan_del(struct dsa_port *dp,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6668fe188f47..14bf0053ae01 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -40,17 +40,15 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 	return notifier_to_errno(err);
 }
 
-int dsa_port_set_state(struct dsa_port *dp, u8 state,
-		       struct switchdev_trans *trans)
+int dsa_port_set_state(struct dsa_port *dp, u8 state)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return ds->ops->port_stp_state_set ? 0 : -EOPNOTSUPP;
+	if (!ds->ops->port_stp_state_set)
+		return -EOPNOTSUPP;
 
-	if (ds->ops->port_stp_state_set)
-		ds->ops->port_stp_state_set(ds, port, state);
+	ds->ops->port_stp_state_set(ds, port, state);
 
 	if (ds->ops->port_fast_age) {
 		/* Fast age FDB entries or flush appropriate forwarding database
@@ -75,7 +73,7 @@ static void dsa_port_set_state_now(struct dsa_port *dp, u8 state)
 {
 	int err;
 
-	err = dsa_port_set_state(dp, state, NULL);
+	err = dsa_port_set_state(dp, state);
 	if (err)
 		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
 }
@@ -145,7 +143,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 	int err;
 
 	/* Set the flooding mode before joining the port in the switch */
-	err = dsa_port_bridge_flags(dp, BR_FLOOD | BR_MCAST_FLOOD, NULL);
+	err = dsa_port_bridge_flags(dp, BR_FLOOD | BR_MCAST_FLOOD);
 	if (err)
 		return err;
 
@@ -158,7 +156,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br)
 
 	/* The bridging is rolled back on error */
 	if (err) {
-		dsa_port_bridge_flags(dp, 0, NULL);
+		dsa_port_bridge_flags(dp, 0);
 		dp->bridge_dev = NULL;
 	}
 
@@ -185,7 +183,7 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
 
 	/* Port is leaving the bridge, disable flooding */
-	dsa_port_bridge_flags(dp, 0, NULL);
+	dsa_port_bridge_flags(dp, 0);
 
 	/* Port left the bridge, put in BR_STATE_DISABLED by the bridge layer,
 	 * so allow it to be in BR_STATE_FORWARDING to be kept functional
@@ -259,43 +257,36 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	return true;
 }
 
-int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
-			    struct switchdev_trans *trans)
+int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering)
 {
 	struct dsa_switch *ds = dp->ds;
+	bool apply;
 	int err;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		bool apply;
-
-		if (!ds->ops->port_vlan_filtering)
-			return -EOPNOTSUPP;
+	if (!ds->ops->port_vlan_filtering)
+		return -EOPNOTSUPP;
 
-		/* We are called from dsa_slave_switchdev_blocking_event(),
-		 * which is not under rcu_read_lock(), unlike
-		 * dsa_slave_switchdev_event().
-		 */
-		rcu_read_lock();
-		apply = dsa_port_can_apply_vlan_filtering(dp, vlan_filtering);
-		rcu_read_unlock();
-		if (!apply)
-			return -EINVAL;
-	}
+	/* We are called from dsa_slave_switchdev_blocking_event(),
+	 * which is not under rcu_read_lock(), unlike
+	 * dsa_slave_switchdev_event().
+	 */
+	rcu_read_lock();
+	apply = dsa_port_can_apply_vlan_filtering(dp, vlan_filtering);
+	rcu_read_unlock();
+	if (!apply)
+		return -EINVAL;
 
 	if (dsa_port_is_vlan_filtering(dp) == vlan_filtering)
 		return 0;
 
-	err = ds->ops->port_vlan_filtering(ds, dp->index, vlan_filtering,
-					   trans);
+	err = ds->ops->port_vlan_filtering(ds, dp->index, vlan_filtering);
 	if (err)
 		return err;
 
-	if (switchdev_trans_ph_commit(trans)) {
-		if (ds->vlan_filtering_is_global)
-			ds->vlan_filtering = vlan_filtering;
-		else
-			dp->vlan_filtering = vlan_filtering;
-	}
+	if (ds->vlan_filtering_is_global)
+		ds->vlan_filtering = vlan_filtering;
+	else
+		dp->vlan_filtering = vlan_filtering;
 
 	return 0;
 }
@@ -314,26 +305,29 @@ bool dsa_port_skip_vlan_configuration(struct dsa_port *dp)
 		!br_vlan_enabled(dp->bridge_dev));
 }
 
-int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock,
-			 struct switchdev_trans *trans)
+int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock);
 	unsigned int ageing_time = jiffies_to_msecs(ageing_jiffies);
-	struct dsa_notifier_ageing_time_info info = {
-		.ageing_time = ageing_time,
-		.trans = trans,
-	};
+	struct dsa_notifier_ageing_time_info info;
+	struct switchdev_trans trans;
+	int err;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
+	info.ageing_time = ageing_time;
+	info.trans = &trans;
+
+	trans.ph_prepare = true;
+	err = dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
+	if (err)
+		return err;
 
 	dp->ageing_time = ageing_time;
 
+	trans.ph_prepare = false;
 	return dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
 }
 
-int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
-			      struct switchdev_trans *trans)
+int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags)
 {
 	struct dsa_switch *ds = dp->ds;
 
@@ -344,16 +338,12 @@ int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 	return 0;
 }
 
-int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
-			  struct switchdev_trans *trans)
+int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 	int err = 0;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return 0;
-
 	if (ds->ops->port_egress_floods)
 		err = ds->ops->port_egress_floods(ds, port, flags & BR_FLOOD,
 						  flags & BR_MCAST_FLOOD);
@@ -361,14 +351,13 @@ int dsa_port_bridge_flags(const struct dsa_port *dp, unsigned long flags,
 	return err;
 }
 
-int dsa_port_mrouter(struct dsa_port *dp, bool mrouter,
-		     struct switchdev_trans *trans)
+int dsa_port_mrouter(struct dsa_port *dp, bool mrouter)
 {
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 
-	if (switchdev_trans_ph_prepare(trans))
-		return ds->ops->port_egress_floods ? 0 : -EOPNOTSUPP;
+	if (!ds->ops->port_egress_floods)
+		return -EOPNOTSUPP;
 
 	return ds->ops->port_egress_floods(ds, port, true, mrouter);
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f8314e3cb534..ca0be052af25 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -268,32 +268,29 @@ static int dsa_slave_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 }
 
 static int dsa_slave_port_attr_set(struct net_device *dev,
-				   const struct switchdev_attr *attr,
-				   struct switchdev_trans *trans)
+				   const struct switchdev_attr *attr)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
-		ret = dsa_port_set_state(dp, attr->u.stp_state, trans);
+		ret = dsa_port_set_state(dp, attr->u.stp_state);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering,
-					      trans);
+		ret = dsa_port_vlan_filtering(dp, attr->u.vlan_filtering);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME:
-		ret = dsa_port_ageing_time(dp, attr->u.ageing_time, trans);
+		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
-		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags,
-						trans);
+		ret = dsa_port_pre_bridge_flags(dp, attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags, trans);
+		ret = dsa_port_bridge_flags(dp, attr->u.brport_flags);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MROUTER:
-		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter, trans);
+		ret = dsa_port_mrouter(dp->cpu_dp, attr->u.mrouter);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 5b0bf29e1375..17979956d756 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -139,17 +139,8 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 		}
 	}
 	if (unset_vlan_filtering) {
-		struct switchdev_trans trans;
-
-		trans.ph_prepare = true;
-		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      false, &trans);
-		if (err && err != EOPNOTSUPP)
-			return err;
-
-		trans.ph_prepare = false;
 		err = dsa_port_vlan_filtering(dsa_to_port(ds, info->port),
-					      false, &trans);
+					      false);
 		if (err && err != EOPNOTSUPP)
 			return err;
 	}
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 3509d362056d..855a10feef3d 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -100,15 +100,13 @@ static int switchdev_deferred_enqueue(struct net_device *dev,
 
 static int switchdev_port_attr_notify(enum switchdev_notifier_type nt,
 				      struct net_device *dev,
-				      const struct switchdev_attr *attr,
-				      struct switchdev_trans *trans)
+				      const struct switchdev_attr *attr)
 {
 	int err;
 	int rc;
 
 	struct switchdev_notifier_port_attr_info attr_info = {
 		.attr = attr,
-		.trans = trans,
 		.handled = false,
 	};
 
@@ -129,34 +127,7 @@ static int switchdev_port_attr_notify(enum switchdev_notifier_type nt,
 static int switchdev_port_attr_set_now(struct net_device *dev,
 				       const struct switchdev_attr *attr)
 {
-	struct switchdev_trans trans;
-	int err;
-
-	/* Phase I: prepare for attr set. Driver/device should fail
-	 * here if there are going to be issues in the commit phase,
-	 * such as lack of resources or support.  The driver/device
-	 * should reserve resources needed for the commit phase here,
-	 * but should not commit the attr.
-	 */
-
-	trans.ph_prepare = true;
-	err = switchdev_port_attr_notify(SWITCHDEV_PORT_ATTR_SET, dev, attr,
-					 &trans);
-	if (err)
-		return err;
-
-	/* Phase II: commit attr set.  This cannot fail as a fault
-	 * of driver/device.  If it does, it's a bug in the driver/device
-	 * because the driver said everythings was OK in phase I.
-	 */
-
-	trans.ph_prepare = false;
-	err = switchdev_port_attr_notify(SWITCHDEV_PORT_ATTR_SET, dev, attr,
-					 &trans);
-	WARN(err, "%s: Commit of attribute (id=%d) failed.\n",
-	     dev->name, attr->id);
-
-	return err;
+	return switchdev_port_attr_notify(SWITCHDEV_PORT_ATTR_SET, dev, attr);
 }
 
 static void switchdev_port_attr_set_deferred(struct net_device *dev,
@@ -186,10 +157,6 @@ static int switchdev_port_attr_set_defer(struct net_device *dev,
  *	@dev: port device
  *	@attr: attribute to set
  *
- *	Use a 2-phase prepare-commit transaction model to ensure
- *	system is not left in a partially updated state due to
- *	failure from driver/device.
- *
  *	rtnl_lock must be held and must not be in atomic section,
  *	in case SWITCHDEV_F_DEFER flag is not set.
  */
@@ -519,8 +486,7 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr,
-				      struct switchdev_trans *trans))
+				      const struct switchdev_attr *attr))
 {
 	struct net_device *lower_dev;
 	struct list_head *iter;
@@ -528,8 +494,7 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
 
 	if (check_cb(dev)) {
 		port_attr_info->handled = true;
-		return set_cb(dev, port_attr_info->attr,
-			      port_attr_info->trans);
+		return set_cb(dev, port_attr_info->attr);
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -556,8 +521,7 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 			struct switchdev_notifier_port_attr_info *port_attr_info,
 			bool (*check_cb)(const struct net_device *dev),
 			int (*set_cb)(struct net_device *dev,
-				      const struct switchdev_attr *attr,
-				      struct switchdev_trans *trans))
+				      const struct switchdev_attr *attr))
 {
 	int err;
 
-- 
2.25.1

