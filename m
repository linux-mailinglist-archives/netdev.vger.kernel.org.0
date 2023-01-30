Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850D86817D2
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 18:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbjA3RhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 12:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237575AbjA3Rg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 12:36:28 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD8327987;
        Mon, 30 Jan 2023 09:36:23 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 54752188382D;
        Mon, 30 Jan 2023 17:36:22 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 49E74250007B;
        Mon, 30 Jan 2023 17:36:22 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 3986B9B403E5; Mon, 30 Jan 2023 17:36:22 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 77C249B403E2;
        Mon, 30 Jan 2023 17:36:21 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com (maintainer:MICROCHIP KSZ SERIES ETHERNET
        SWITCH DRIVER), Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-renesas-soc@vger.kernel.org (open list:RENESAS RZ/N1 A5PSW SWITCH
        DRIVER),
        bridge@lists.linux-foundation.org (moderated list:ETHERNET BRIDGE)
Subject: [PATCH net-next 3/5] drivers: net: dsa: add fdb entry flags incoming to switchcore drivers
Date:   Mon, 30 Jan 2023 18:34:27 +0100
Message-Id: <20230130173429.3577450-4-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130173429.3577450-1-netdev@kapio-technology.com>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignore FDB entries with set flags coming in on all switchcore drivers.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/b53/b53_common.c       | 12 ++++++++++--
 drivers/net/dsa/b53/b53_priv.h         |  4 ++--
 drivers/net/dsa/hirschmann/hellcreek.c | 12 ++++++++++--
 drivers/net/dsa/lan9303-core.c         | 12 ++++++++++--
 drivers/net/dsa/lantiq_gswip.c         | 12 ++++++++++--
 drivers/net/dsa/microchip/ksz9477.c    |  8 ++++----
 drivers/net/dsa/microchip/ksz9477.h    |  8 ++++----
 drivers/net/dsa/microchip/ksz_common.c | 14 +++++++++++---
 drivers/net/dsa/mt7530.c               | 12 ++++++++++--
 drivers/net/dsa/mv88e6xxx/chip.c       | 12 ++++++++++--
 drivers/net/dsa/ocelot/felix.c         | 12 ++++++++++--
 drivers/net/dsa/qca/qca8k-common.c     | 12 ++++++++++--
 drivers/net/dsa/qca/qca8k.h            |  4 ++--
 drivers/net/dsa/rzn1_a5psw.c           | 12 ++++++++++--
 drivers/net/dsa/sja1105/sja1105_main.c | 19 ++++++++++++++-----
 include/net/dsa.h                      |  4 ++--
 net/dsa/switch.c                       | 12 ++++++++----
 17 files changed, 137 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 59cdfc51ce06..cec60af6dfdc 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1684,11 +1684,15 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 
 int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
-		struct dsa_db db)
+		u16 fdb_flags, struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
 	 */
@@ -1705,11 +1709,15 @@ EXPORT_SYMBOL(b53_fdb_add);
 
 int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
-		struct dsa_db db)
+		u16 fdb_flags, struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	mutex_lock(&priv->arl_mutex);
 	ret = b53_arl_op(priv, 0, port, addr, vid, false);
 	mutex_unlock(&priv->arl_mutex);
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 795cbffd5c2b..7673c4e712bb 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -362,10 +362,10 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
-		struct dsa_db db);
+		u16 fdb_flags, struct dsa_db db);
 int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
-		struct dsa_db db);
+		u16 fdb_flags, struct dsa_db db);
 int b53_fdb_dump(struct dsa_switch *ds, int port,
 		 dsa_fdb_dump_cb_t *cb, void *data);
 int b53_mdb_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 595a548bb0a8..b5884fc9cf85 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -839,12 +839,16 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 
 static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 			     const unsigned char *addr, u16 vid,
-			     struct dsa_db db)
+			     u16 fdb_flags, struct dsa_db db)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
 	int ret;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	dev_dbg(hellcreek->dev, "Add FDB entry for MAC=%pM\n", addr);
 
 	mutex_lock(&hellcreek->reg_lock);
@@ -885,12 +889,16 @@ static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 
 static int hellcreek_fdb_del(struct dsa_switch *ds, int port,
 			     const unsigned char *addr, u16 vid,
-			     struct dsa_db db)
+			     u16 fdb_flags, struct dsa_db db)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
 	int ret;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	dev_dbg(hellcreek->dev, "Delete FDB entry for MAC=%pM\n", addr);
 
 	mutex_lock(&hellcreek->reg_lock);
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index cbe831875347..809da5fb23a8 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1183,10 +1183,14 @@ static void lan9303_port_fast_age(struct dsa_switch *ds, int port)
 
 static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
-				struct dsa_db db)
+				u16 fdb_flags, struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
 	if (vid)
 		return -EOPNOTSUPP;
@@ -1196,10 +1200,14 @@ static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int lan9303_port_fdb_del(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
-				struct dsa_db db)
+				u16 fdb_flags, struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
 	if (vid)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 05ecaa007ab1..a945e8e62232 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1399,15 +1399,23 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 
 static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
 			      const unsigned char *addr, u16 vid,
-			      struct dsa_db db)
+			      u16 fdb_flags, struct dsa_db db)
 {
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	return gswip_port_fdb(ds, port, addr, vid, true);
 }
 
 static int gswip_port_fdb_del(struct dsa_switch *ds, int port,
 			      const unsigned char *addr, u16 vid,
-			      struct dsa_db db)
+			      u16 fdb_flags, struct dsa_db db)
 {
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	return gswip_port_fdb(ds, port, addr, vid, false);
 }
 
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index bf13d47c26cf..c6a09b444153 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -449,8 +449,8 @@ int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-int ksz9477_fdb_add(struct ksz_device *dev, int port,
-		    const unsigned char *addr, u16 vid, struct dsa_db db)
+int ksz9477_fdb_add(struct ksz_device *dev, int port, const unsigned char *addr,
+		    u16 vid, struct dsa_db db)
 {
 	u32 alu_table[4];
 	u32 data;
@@ -505,8 +505,8 @@ int ksz9477_fdb_add(struct ksz_device *dev, int port,
 	return ret;
 }
 
-int ksz9477_fdb_del(struct ksz_device *dev, int port,
-		    const unsigned char *addr, u16 vid, struct dsa_db db)
+int ksz9477_fdb_del(struct ksz_device *dev, int port, const unsigned char *addr,
+		    u16 vid, struct dsa_db db)
 {
 	u32 alu_table[4];
 	u32 data;
diff --git a/drivers/net/dsa/microchip/ksz9477.h b/drivers/net/dsa/microchip/ksz9477.h
index b6f7e3c46e3f..bb6182fa65b9 100644
--- a/drivers/net/dsa/microchip/ksz9477.h
+++ b/drivers/net/dsa/microchip/ksz9477.h
@@ -41,10 +41,10 @@ void ksz9477_get_caps(struct ksz_device *dev, int port,
 		      struct phylink_config *config);
 int ksz9477_fdb_dump(struct ksz_device *dev, int port,
 		     dsa_fdb_dump_cb_t *cb, void *data);
-int ksz9477_fdb_add(struct ksz_device *dev, int port,
-		    const unsigned char *addr, u16 vid, struct dsa_db db);
-int ksz9477_fdb_del(struct ksz_device *dev, int port,
-		    const unsigned char *addr, u16 vid, struct dsa_db db);
+int ksz9477_fdb_add(struct ksz_device *dev, int port, const unsigned char *addr,
+		    u16 vid, struct dsa_db db);
+int ksz9477_fdb_del(struct ksz_device *dev, int port, const unsigned char *addr,
+		    u16 vid, struct dsa_db db);
 int ksz9477_mdb_add(struct ksz_device *dev, int port,
 		    const struct switchdev_obj_port_mdb *mdb, struct dsa_db db);
 int ksz9477_mdb_del(struct ksz_device *dev, int port,
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 46becc0382d6..a45e75ed4c36 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2390,10 +2390,14 @@ static int ksz_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 
 static int ksz_port_fdb_add(struct dsa_switch *ds, int port,
 			    const unsigned char *addr, u16 vid,
-			    struct dsa_db db)
+			    u16 fdb_flags, struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (!dev->dev_ops->fdb_add)
 		return -EOPNOTSUPP;
 
@@ -2401,11 +2405,15 @@ static int ksz_port_fdb_add(struct dsa_switch *ds, int port,
 }
 
 static int ksz_port_fdb_del(struct dsa_switch *ds, int port,
-			    const unsigned char *addr,
-			    u16 vid, struct dsa_db db)
+			    const unsigned char *addr, u16 vid,
+			    u16 fdb_flags, struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (!dev->dev_ops->fdb_del)
 		return -EOPNOTSUPP;
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 616b21c90d05..fea14c093df8 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1362,12 +1362,16 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 static int
 mt7530_port_fdb_add(struct dsa_switch *ds, int port,
 		    const unsigned char *addr, u16 vid,
-		    struct dsa_db db)
+		    u16 fdb_flags, struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
 	u8 port_mask = BIT(port);
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	mutex_lock(&priv->reg_mutex);
 	mt7530_fdb_write(priv, vid, port_mask, addr, -1, STATIC_ENT);
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_WRITE, NULL);
@@ -1379,12 +1383,16 @@ mt7530_port_fdb_add(struct dsa_switch *ds, int port,
 static int
 mt7530_port_fdb_del(struct dsa_switch *ds, int port,
 		    const unsigned char *addr, u16 vid,
-		    struct dsa_db db)
+		    u16 fdb_flags, struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
 	u8 port_mask = BIT(port);
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	mutex_lock(&priv->reg_mutex);
 	mt7530_fdb_write(priv, vid, port_mask, addr, -1, STATIC_EMP);
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_WRITE, NULL);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0a5d6c7bb128..61d5dc4680e3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2724,11 +2724,15 @@ static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
 
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
-				  struct dsa_db db)
+				  u16 fdb_flags, struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	/* Ignore entries with flags set */
+	if (fdb_flags)
+		return 0;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
 					   MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
@@ -2739,11 +2743,15 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
-				  struct dsa_db db)
+				  u16 fdb_flags, struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	/* Ignore entries with flags set */
+	if (fdb_flags)
+		return 0;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
 	mv88e6xxx_reg_unlock(chip);
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f57b4095b793..38e6a8d64a0b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -782,12 +782,16 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 
 static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid,
-			 struct dsa_db db)
+			 u16 fdb_flags, struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
@@ -803,12 +807,16 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 
 static int felix_fdb_del(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid,
-			 struct dsa_db db)
+			 u16 fdb_flags, struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index 96773e432558..6d6aa2d0d487 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -758,21 +758,29 @@ int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 
 int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 		       const unsigned char *addr, u16 vid,
-		       struct dsa_db db)
+		       u16 fdb_flags, struct dsa_db db)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
 }
 
 int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 		       const unsigned char *addr, u16 vid,
-		       struct dsa_db db)
+		       u16 fdb_flags, struct dsa_db db)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (!vid)
 		vid = QCA8K_PORT_VID_DEF;
 
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 7996975d29d3..f51306e04e52 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -473,10 +473,10 @@ int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 			  u16 port_mask, u16 vid);
 int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 		       const unsigned char *addr, u16 vid,
-		       struct dsa_db db);
+		       u16 fdb_flags, struct dsa_db db);
 int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 		       const unsigned char *addr, u16 vid,
-		       struct dsa_db db);
+		       u16 fdb_flags, struct dsa_db db);
 int qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 			dsa_fdb_dump_cb_t *cb, void *data);
 
diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
index 919027cf2012..236e0754e5eb 100644
--- a/drivers/net/dsa/rzn1_a5psw.c
+++ b/drivers/net/dsa/rzn1_a5psw.c
@@ -396,7 +396,7 @@ static int a5psw_lk_execute_lookup(struct a5psw *a5psw, union lk_data *lk_data,
 
 static int a5psw_port_fdb_add(struct dsa_switch *ds, int port,
 			      const unsigned char *addr, u16 vid,
-			      struct dsa_db db)
+			      u16 fdb_flags, struct dsa_db db)
 {
 	struct a5psw *a5psw = ds->priv;
 	union lk_data lk_data = {0};
@@ -405,6 +405,10 @@ static int a5psw_port_fdb_add(struct dsa_switch *ds, int port,
 	u16 entry;
 	u32 reg;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	ether_addr_copy(lk_data.entry.mac, addr);
 	lk_data.entry.port_mask = BIT(port);
 
@@ -447,7 +451,7 @@ static int a5psw_port_fdb_add(struct dsa_switch *ds, int port,
 
 static int a5psw_port_fdb_del(struct dsa_switch *ds, int port,
 			      const unsigned char *addr, u16 vid,
-			      struct dsa_db db)
+			      u16 fdb_flags, struct dsa_db db)
 {
 	struct a5psw *a5psw = ds->priv;
 	union lk_data lk_data = {0};
@@ -456,6 +460,10 @@ static int a5psw_port_fdb_del(struct dsa_switch *ds, int port,
 	u32 reg;
 	int ret;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	ether_addr_copy(lk_data.entry.mac, addr);
 
 	mutex_lock(&a5psw->lk_lock);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b70dcf32a26d..6fddd832017b 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1802,10 +1802,14 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid,
-			   struct dsa_db db)
+			   u16 fdb_flags, struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (!vid) {
 		switch (db.type) {
 		case DSA_DB_PORT:
@@ -1824,10 +1828,14 @@ static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 
 static int sja1105_fdb_del(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid,
-			   struct dsa_db db)
+			   u16 fdb_flags, struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (!vid) {
 		switch (db.type) {
 		case DSA_DB_PORT:
@@ -1930,7 +1938,8 @@ static void sja1105_fast_age(struct dsa_switch *ds, int port)
 
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
-		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid, db);
+		rc = sja1105_fdb_del(ds, port, macaddr, l2_lookup.vlanid,
+				     0, db);
 		if (rc) {
 			dev_err(ds->dev,
 				"Failed to delete FDB entry %pM vid %lld: %pe\n",
@@ -1944,14 +1953,14 @@ static int sja1105_mdb_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_mdb *mdb,
 			   struct dsa_db db)
 {
-	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, db);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, 0, db);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_mdb *mdb,
 			   struct dsa_db db)
 {
-	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, db);
+	return sja1105_fdb_del(ds, port, mdb->addr, mdb->vid, 0, db);
 }
 
 /* Common function for unicast and broadcast flood configuration.
diff --git a/include/net/dsa.h b/include/net/dsa.h
index ff95bf1cdd14..4971e67d6481 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1047,10 +1047,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
-				struct dsa_db db);
+				u16 fdb_flags, struct dsa_db db);
 	int	(*port_fdb_del)(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
-				struct dsa_db db);
+				u16 fdb_flags, struct dsa_db db);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
 	int	(*lag_fdb_add)(struct dsa_switch *ds, struct dsa_lag lag,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 9b0d6ce0f7da..397665962451 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -248,7 +248,8 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid, db);
+		return ds->ops->port_fdb_add(ds, port, addr,
+					     vid, fdb_flags, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -264,7 +265,8 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		goto out;
 	}
 
-	err = ds->ops->port_fdb_add(ds, port, addr, vid, db);
+	err = ds->ops->port_fdb_add(ds, port, addr,
+				    vid, fdb_flags, db);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -292,7 +294,8 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_del(ds, port, addr, vid, db);
+		return ds->ops->port_fdb_del(ds, port, addr,
+					     vid, fdb_flags, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -305,7 +308,8 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	if (!refcount_dec_and_test(&a->refcount))
 		goto out;
 
-	err = ds->ops->port_fdb_del(ds, port, addr, vid, db);
+	err = ds->ops->port_fdb_del(ds, port, addr,
+				    vid, fdb_flags, db);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
-- 
2.34.1

