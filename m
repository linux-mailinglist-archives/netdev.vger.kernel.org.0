Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F735EDFB3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 17:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiI1PGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 11:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbiI1PGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 11:06:33 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A799082E;
        Wed, 28 Sep 2022 08:06:29 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6EF4D1884BE0;
        Wed, 28 Sep 2022 15:06:26 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 67B8B2500370;
        Wed, 28 Sep 2022 15:06:26 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 5EB809EC0009; Wed, 28 Sep 2022 15:06:26 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 918A39120FED;
        Wed, 28 Sep 2022 15:06:25 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v6 net-next 5/9] drivers: net: dsa: add fdb entry flags to drivers
Date:   Wed, 28 Sep 2022 17:02:52 +0200
Message-Id: <20220928150256.115248-6-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928150256.115248-1-netdev@kapio-technology.com>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Hans J. Schultz" <netdev@kapio-technology.com>

Ignore fdb entries with set flags coming in on all drivers.

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
 drivers/net/dsa/qca/qca8k-common.c     | 10 +++++++++-
 drivers/net/dsa/qca/qca8k.h            |  4 ++--
 drivers/net/dsa/sja1105/sja1105_main.c | 14 +++++++++++---
 include/net/dsa.h                      |  4 ++--
 net/dsa/switch.c                       |  8 ++++----
 16 files changed, 119 insertions(+), 39 deletions(-)

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
index eac6ace7c5f9..8988b930225c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -829,12 +829,16 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 
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
@@ -875,12 +879,16 @@ static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 
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
index 438e46af03e9..36187705833f 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1192,10 +1192,14 @@ static void lan9303_port_fast_age(struct dsa_switch *ds, int port)
 
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
@@ -1205,10 +1209,14 @@ static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 
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
index a6a0321a8931..e65daabf9865 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -457,8 +457,8 @@ int ksz9477_port_vlan_del(struct ksz_device *dev, int port,
 	return 0;
 }
 
-int ksz9477_fdb_add(struct ksz_device *dev, int port,
-		    const unsigned char *addr, u16 vid, struct dsa_db db)
+int ksz9477_fdb_add(struct ksz_device *dev, int port, const unsigned char *addr,
+		    u16 vid, struct dsa_db db)
 {
 	u32 alu_table[4];
 	u32 data;
@@ -513,8 +513,8 @@ int ksz9477_fdb_add(struct ksz_device *dev, int port,
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
index 00862c4cfb7f..a9c64e166cca 100644
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
index d612181b3226..cfcfc725fed9 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2227,10 +2227,14 @@ static int ksz_set_ageing_time(struct dsa_switch *ds, unsigned int msecs)
 
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
 
@@ -2238,11 +2242,15 @@ static int ksz_port_fdb_add(struct dsa_switch *ds, int port,
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
index e87f16a5756b..ff36b05bd03c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1366,12 +1366,16 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
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
@@ -1383,12 +1387,16 @@ mt7530_port_fdb_add(struct dsa_switch *ds, int port,
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
index 2479be3a1e35..352121cce77e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2722,11 +2722,15 @@ static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
 
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
@@ -2737,11 +2741,15 @@ static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 
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
index d2a9d292160c..0816cce715fe 100644
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
index fb45b598847b..0c5f49de6729 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -795,11 +795,15 @@ int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 
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
 
@@ -810,6 +814,10 @@ int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
 
+	/* Ignore entries with set flags */
+	if (fdb_flags)
+		return 0;
+
 	if (!vid)
 		vid = QCA8K_PORT_VID_DEF;
 
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 0b7a5cb12321..5d47e840ae1e 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -479,10 +479,10 @@ int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
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
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 412666111b0c..1f12a5b89c91 100644
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
@@ -1944,7 +1952,7 @@ static int sja1105_mdb_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_mdb *mdb,
 			   struct dsa_db db)
 {
-	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, db);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, false, db);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 26d82d71988e..875b20b910b9 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1045,10 +1045,10 @@ struct dsa_switch_ops {
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
index dd355556892e..6dacab9c1428 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -243,7 +243,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid, db);
+		return ds->ops->port_fdb_add(ds, port, addr, vid, fdb_flags, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -259,7 +259,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		goto out;
 	}
 
-	err = ds->ops->port_fdb_add(ds, port, addr, vid, db);
+	err = ds->ops->port_fdb_add(ds, port, addr, vid, fdb_flags, db);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -287,7 +287,7 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_del(ds, port, addr, vid, db);
+		return ds->ops->port_fdb_del(ds, port, addr, vid, fdb_flags, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -300,7 +300,7 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	if (!refcount_dec_and_test(&a->refcount))
 		goto out;
 
-	err = ds->ops->port_fdb_del(ds, port, addr, vid, db);
+	err = ds->ops->port_fdb_del(ds, port, addr, vid, fdb_flags, db);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
-- 
2.34.1

