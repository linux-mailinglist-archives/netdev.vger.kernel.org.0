Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052872EFBF9
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbhAIADg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbhAIADe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:03:34 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD79C0613ED
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:23 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id x16so16774868ejj.7
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=os7h/qzDCL0BGCkNDaOwkudAvTX443yhD243XVB30l0=;
        b=quXbSc+8HPyEOEygTYF55BHDwHc8gX+Mv5PsIxbFJkWSvg+jIyNklwLXO+rwtjuTDN
         PFJmC7vgynWgPWcDJHZFiPvDSNnPlDrRKnI2UT8SpQ6WfBQpw9VpYGnhqcUFyYVM0taR
         CmpShUKSILJ3knTdqMlFoNAxxeykucovdYT1Micn3juheFx8AXunukvqEE3aDV8sO20J
         knc8AawMxiMEuLfX5W35rVTyY45BBIT7pyy/+aN4m+EojqilKl3A2iW70iA+BEQmUi45
         LSY2DF/0i9WWFxnE1kwfFlss857AnVet3sG325F/RDMBu0xXI8FmBVlINwCk84DReWXd
         goGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=os7h/qzDCL0BGCkNDaOwkudAvTX443yhD243XVB30l0=;
        b=toW10FHEV8zcPWtsn5EeHnt0AQQXtWawY6JiJpAiHoKAH68OZySQpWnnX/np554m7k
         wgWfAfIyYYjSL85dknHVzz+Iuk07jillUWZ6rjwC/CJFtwGjh7TmODBzQRnwR1iEnycJ
         i+rkVhOqHvxLj+Rgj6RYlDnTX//DrccwRXmGmpACOC1XAgsgStKJ+NEXDgSIkUk2h0TF
         JTvLPPrZU0ZRhlj+1KK7MWNr0Ii21TMHWH+3v/f8Y3FJIN5fSgy4IpD45xm5AfSn/5+m
         JRuBYHM/TWeWJ/NO4XZUeMoXuhfzZE01ULvwUniUwU0J8juUHTGI3hSblPgb7EbLmf5q
         gYmQ==
X-Gm-Message-State: AOAM5301Sw3bYVOCUDrtfppT5QhCuPOGTVtFJdlDfekS1oalgNFZh7u7
        TG+Lo6UADUc0/iQo9xgPSPs=
X-Google-Smtp-Source: ABdhPJwUnXMU3Xgg72TKcshhrO932okEFRmAYQ1wY4hzDDi6K6V0O1h32zdiRcYHyssDSRxP0q2WgA==
X-Received: by 2002:a17:906:b79a:: with SMTP id dt26mr3955579ejb.337.1610150542558;
        Fri, 08 Jan 2021 16:02:22 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:21 -0800 (PST)
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
Subject: [PATCH v4 net-next 07/11] net: dsa: remove the transactional logic from MDB entries
Date:   Sat,  9 Jan 2021 02:01:52 +0200
Message-Id: <20210109000156.1246735-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

For many drivers, the .port_mdb_prepare callback was not a good opportunity
to avoid any error condition, and they would suppress errors found during
the actual commit phase.

Where a logical separation between the prepare and the commit phase
existed, the function that used to implement the .port_mdb_prepare
callback still exists, but now it is called directly from .port_mdb_add,
which was modified to return an int code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de> # hellcreek
Reviewed-by: Linus Wallei <linus.walleij@linaro.org> # RTL8366
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Propagating errors better now.

 drivers/net/dsa/b53/b53_common.c       | 19 +++----------------
 drivers/net/dsa/b53/b53_priv.h         |  6 ++----
 drivers/net/dsa/bcm_sf2.c              |  1 -
 drivers/net/dsa/lan9303-core.c         | 12 ++++++++----
 drivers/net/dsa/microchip/ksz8795.c    |  1 -
 drivers/net/dsa/microchip/ksz9477.c    | 14 +++++++++-----
 drivers/net/dsa/microchip/ksz_common.c | 16 +++++-----------
 drivers/net/dsa/microchip/ksz_common.h |  6 ++----
 drivers/net/dsa/mv88e6xxx/chip.c       | 24 +++++++-----------------
 drivers/net/dsa/ocelot/felix.c         | 14 +++-----------
 drivers/net/dsa/sja1105/sja1105_main.c | 14 +++-----------
 include/net/dsa.h                      |  4 +---
 net/dsa/switch.c                       | 15 ++++++---------
 13 files changed, 49 insertions(+), 97 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 99c9b528884e..122636eb362e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1741,8 +1741,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
-int b53_mdb_prepare(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb)
+int b53_mdb_add(struct dsa_switch *ds, int port,
+		const struct switchdev_obj_port_mdb *mdb)
 {
 	struct b53_device *priv = ds->priv;
 
@@ -1752,19 +1752,7 @@ int b53_mdb_prepare(struct dsa_switch *ds, int port,
 	if (is5325(priv) || is5365(priv))
 		return -EOPNOTSUPP;
 
-	return 0;
-}
-EXPORT_SYMBOL(b53_mdb_prepare);
-
-void b53_mdb_add(struct dsa_switch *ds, int port,
-		 const struct switchdev_obj_port_mdb *mdb)
-{
-	struct b53_device *priv = ds->priv;
-	int ret;
-
-	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, true);
-	if (ret)
-		dev_err(ds->dev, "failed to add MDB entry\n");
+	return b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, true);
 }
 EXPORT_SYMBOL(b53_mdb_add);
 
@@ -2205,7 +2193,6 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_fdb_del		= b53_fdb_del,
 	.port_mirror_add	= b53_mirror_add,
 	.port_mirror_del	= b53_mirror_del,
-	.port_mdb_prepare	= b53_mdb_prepare,
 	.port_mdb_add		= b53_mdb_add,
 	.port_mdb_del		= b53_mdb_del,
 	.port_max_mtu		= b53_get_max_mtu,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 24893b592216..224423ab0682 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -360,10 +360,8 @@ int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid);
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data);
-int b53_mdb_prepare(struct dsa_switch *ds, int port,
-		    const struct switchdev_obj_port_mdb *mdb);
-void b53_mdb_add(struct dsa_switch *ds, int port,
-		 const struct switchdev_obj_port_mdb *mdb);
+int b53_mdb_add(struct dsa_switch *ds, int port,
+		const struct switchdev_obj_port_mdb *mdb);
 int b53_mdb_del(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb);
 int b53_mirror_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 1e9a0adda2d6..4c493bb47d30 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1123,7 +1123,6 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.set_rxnfc		= bcm_sf2_set_rxnfc,
 	.port_mirror_add	= b53_mirror_add,
 	.port_mirror_del	= b53_mirror_del,
-	.port_mdb_prepare	= b53_mdb_prepare,
 	.port_mdb_add		= b53_mdb_add,
 	.port_mdb_del		= b53_mdb_del,
 };
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index aa1142d6a9f5..344374025426 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1232,14 +1232,19 @@ static int lan9303_port_mdb_prepare(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static void lan9303_port_mdb_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int lan9303_port_mdb_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb)
 {
 	struct lan9303 *chip = ds->priv;
+	int err;
+
+	err = lan9303_port_mdb_prepare(ds, port, mdb);
+	if (err)
+		return err;
 
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, mdb->addr,
 		mdb->vid);
-	lan9303_alr_add_port(chip, mdb->addr, port, false);
+	return lan9303_alr_add_port(chip, mdb->addr, port, false);
 }
 
 static int lan9303_port_mdb_del(struct dsa_switch *ds, int port,
@@ -1274,7 +1279,6 @@ static const struct dsa_switch_ops lan9303_switch_ops = {
 	.port_fdb_add           = lan9303_port_fdb_add,
 	.port_fdb_del           = lan9303_port_fdb_del,
 	.port_fdb_dump          = lan9303_port_fdb_dump,
-	.port_mdb_prepare       = lan9303_port_mdb_prepare,
 	.port_mdb_add           = lan9303_port_mdb_add,
 	.port_mdb_del           = lan9303_port_mdb_del,
 };
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 6a9ec8a0f92f..89e1c01cf5b8 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1114,7 +1114,6 @@ static const struct dsa_switch_ops ksz8795_switch_ops = {
 	.port_vlan_add		= ksz8795_port_vlan_add,
 	.port_vlan_del		= ksz8795_port_vlan_del,
 	.port_fdb_dump		= ksz_port_fdb_dump,
-	.port_mdb_prepare       = ksz_port_mdb_prepare,
 	.port_mdb_add           = ksz_port_mdb_add,
 	.port_mdb_del           = ksz_port_mdb_del,
 	.port_mirror_add	= ksz8795_port_mirror_add,
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 446c088ce5c5..08bf54eb9f5f 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -774,14 +774,15 @@ static int ksz9477_port_fdb_dump(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
+				const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ksz_device *dev = ds->priv;
 	u32 static_table[4];
 	u32 data;
 	int index;
 	u32 mac_hi, mac_lo;
+	int err = 0;
 
 	mac_hi = ((mdb->addr[0] << 8) | mdb->addr[1]);
 	mac_lo = ((mdb->addr[2] << 24) | (mdb->addr[3] << 16));
@@ -796,7 +797,8 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 		ksz_write32(dev, REG_SW_ALU_STAT_CTRL__4, data);
 
 		/* wait to be finished */
-		if (ksz9477_wait_alu_sta_ready(dev)) {
+		err = ksz9477_wait_alu_sta_ready(dev);
+		if (err) {
 			dev_dbg(dev->dev, "Failed to read ALU STATIC\n");
 			goto exit;
 		}
@@ -819,8 +821,10 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 	}
 
 	/* no available entry */
-	if (index == dev->num_statics)
+	if (index == dev->num_statics) {
+		err = -ENOSPC;
 		goto exit;
+	}
 
 	/* add entry */
 	static_table[0] = ALU_V_STATIC_VALID;
@@ -842,6 +846,7 @@ static void ksz9477_port_mdb_add(struct dsa_switch *ds, int port,
 
 exit:
 	mutex_unlock(&dev->alu_mutex);
+	return err;
 }
 
 static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
@@ -1395,7 +1400,6 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_fdb_dump		= ksz9477_port_fdb_dump,
 	.port_fdb_add		= ksz9477_port_fdb_add,
 	.port_fdb_del		= ksz9477_port_fdb_del,
-	.port_mdb_prepare       = ksz_port_mdb_prepare,
 	.port_mdb_add           = ksz9477_port_mdb_add,
 	.port_mdb_del           = ksz9477_port_mdb_del,
 	.port_mirror_add	= ksz9477_port_mirror_add,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index cf743133b0b9..f2c9ff3ea4be 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -253,16 +253,8 @@ int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 }
 EXPORT_SYMBOL_GPL(ksz_port_fdb_dump);
 
-int ksz_port_mdb_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb)
-{
-	/* nothing to do */
-	return 0;
-}
-EXPORT_SYMBOL_GPL(ksz_port_mdb_prepare);
-
-void ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_mdb *mdb)
+int ksz_port_mdb_add(struct dsa_switch *ds, int port,
+		     const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ksz_device *dev = ds->priv;
 	struct alu_struct alu;
@@ -284,7 +276,7 @@ void ksz_port_mdb_add(struct dsa_switch *ds, int port,
 
 	/* no available entry */
 	if (index == dev->num_statics && !empty)
-		return;
+		return -ENOSPC;
 
 	/* add entry */
 	if (index == dev->num_statics) {
@@ -301,6 +293,8 @@ void ksz_port_mdb_add(struct dsa_switch *ds, int port,
 		alu.fid = mdb->vid;
 	}
 	dev->dev_ops->w_sta_mac_table(dev, index, &alu);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(ksz_port_mdb_add);
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 720f22275c84..a1f0929d45a0 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -165,10 +165,8 @@ int ksz_port_vlan_prepare(struct dsa_switch *ds, int port,
 			  const struct switchdev_obj_port_vlan *vlan);
 int ksz_port_fdb_dump(struct dsa_switch *ds, int port, dsa_fdb_dump_cb_t *cb,
 		      void *data);
-int ksz_port_mdb_prepare(struct dsa_switch *ds, int port,
-			 const struct switchdev_obj_port_mdb *mdb);
-void ksz_port_mdb_add(struct dsa_switch *ds, int port,
-		      const struct switchdev_obj_port_mdb *mdb);
+int ksz_port_mdb_add(struct dsa_switch *ds, int port,
+		     const struct switchdev_obj_port_mdb *mdb);
 int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_mdb *mdb);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bbf1a71ce55c..e9c517c0f89c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5238,27 +5238,18 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 	return chip->info->tag_protocol;
 }
 
-static int mv88e6xxx_port_mdb_prepare(struct dsa_switch *ds, int port,
-				      const struct switchdev_obj_port_mdb *mdb)
-{
-	/* We don't need any dynamic resource from the kernel (yet),
-	 * so skip the prepare phase.
-	 */
-
-	return 0;
-}
-
-static void mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
-				   const struct switchdev_obj_port_mdb *mdb)
+static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_mdb *mdb)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
 
 	mv88e6xxx_reg_lock(chip);
-	if (mv88e6xxx_port_db_load_purge(chip, port, mdb->addr, mdb->vid,
-					 MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC))
-		dev_err(ds->dev, "p%d: failed to load multicast MAC address\n",
-			port);
+	err = mv88e6xxx_port_db_load_purge(chip, port, mdb->addr, mdb->vid,
+					   MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC);
 	mv88e6xxx_reg_unlock(chip);
+
+	return err;
 }
 
 static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
@@ -5403,7 +5394,6 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_fdb_add           = mv88e6xxx_port_fdb_add,
 	.port_fdb_del           = mv88e6xxx_port_fdb_del,
 	.port_fdb_dump          = mv88e6xxx_port_fdb_dump,
-	.port_mdb_prepare       = mv88e6xxx_port_mdb_prepare,
 	.port_mdb_add           = mv88e6xxx_port_mdb_add,
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
 	.port_mirror_add	= mv88e6xxx_port_mirror_add,
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 8c4cd9168dba..2825dd11feee 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -65,19 +65,12 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 	return ocelot_fdb_del(ocelot, port, addr, vid);
 }
 
-/* This callback needs to be present */
-static int felix_mdb_prepare(struct dsa_switch *ds, int port,
-			     const struct switchdev_obj_port_mdb *mdb)
-{
-	return 0;
-}
-
-static void felix_mdb_add(struct dsa_switch *ds, int port,
-			  const struct switchdev_obj_port_mdb *mdb)
+static int felix_mdb_add(struct dsa_switch *ds, int port,
+			 const struct switchdev_obj_port_mdb *mdb)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_mdb_add(ocelot, port, mdb);
+	return ocelot_port_mdb_add(ocelot, port, mdb);
 }
 
 static int felix_mdb_del(struct dsa_switch *ds, int port,
@@ -772,7 +765,6 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_fdb_dump		= felix_fdb_dump,
 	.port_fdb_add		= felix_fdb_add,
 	.port_fdb_del		= felix_fdb_del,
-	.port_mdb_prepare	= felix_mdb_prepare,
 	.port_mdb_add		= felix_mdb_add,
 	.port_mdb_del		= felix_mdb_del,
 	.port_bridge_join	= felix_bridge_join,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index c1b7f2b0e40c..be200d4289af 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1524,17 +1524,10 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-/* This callback needs to be present */
-static int sja1105_mdb_prepare(struct dsa_switch *ds, int port,
-			       const struct switchdev_obj_port_mdb *mdb)
-{
-	return 0;
-}
-
-static void sja1105_mdb_add(struct dsa_switch *ds, int port,
-			    const struct switchdev_obj_port_mdb *mdb)
+static int sja1105_mdb_add(struct dsa_switch *ds, int port,
+			   const struct switchdev_obj_port_mdb *mdb)
 {
-	sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
@@ -3288,7 +3281,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_vlan_filtering	= sja1105_vlan_filtering,
 	.port_vlan_add		= sja1105_vlan_add,
 	.port_vlan_del		= sja1105_vlan_del,
-	.port_mdb_prepare	= sja1105_mdb_prepare,
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
 	.port_hwtstamp_get	= sja1105_hwtstamp_get,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index d0f043091969..b8c0550dfa74 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -585,10 +585,8 @@ struct dsa_switch_ops {
 	/*
 	 * Multicast database
 	 */
-	int (*port_mdb_prepare)(struct dsa_switch *ds, int port,
+	int	(*port_mdb_add)(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_mdb *mdb);
-	void (*port_mdb_add)(struct dsa_switch *ds, int port,
-			     const struct switchdev_obj_port_mdb *mdb);
 	int	(*port_mdb_del)(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_mdb *mdb);
 	/*
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index c6b3ac93bcc7..5f5e19c5e43a 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -181,24 +181,21 @@ static bool dsa_switch_mdb_match(struct dsa_switch *ds, int port,
 static int dsa_switch_mdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
-	int port, err;
+	int err = 0;
+	int port;
 
-	if (!ds->ops->port_mdb_prepare || !ds->ops->port_mdb_add)
+	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
 	for (port = 0; port < ds->num_ports; port++) {
 		if (dsa_switch_mdb_match(ds, port, info)) {
-			err = ds->ops->port_mdb_prepare(ds, port, info->mdb);
+			err = ds->ops->port_mdb_add(ds, port, info->mdb);
 			if (err)
-				return err;
+				break;
 		}
 	}
 
-	for (port = 0; port < ds->num_ports; port++)
-		if (dsa_switch_mdb_match(ds, port, info))
-			ds->ops->port_mdb_add(ds, port, info->mdb);
-
-	return 0;
+	return err;
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
-- 
2.25.1

