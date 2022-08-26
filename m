Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A825A27C6
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344269AbiHZMZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344257AbiHZMZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:25:53 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27E8D34F9;
        Fri, 26 Aug 2022 05:25:48 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id AC468188DE9C;
        Fri, 26 Aug 2022 12:25:46 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 814F325032BC;
        Fri, 26 Aug 2022 12:25:46 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 721EB9EC00A4; Fri, 26 Aug 2022 11:46:02 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from wse-c0127.beijerelectronics.com (unknown [208.127.141.28])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 2F4B59EC0006;
        Fri, 26 Aug 2022 11:46:00 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Schultz <netdev@kapio-technology.com>,
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v5 net-next 3/6] drivers: net: dsa: add locked fdb entry flag to drivers
Date:   Fri, 26 Aug 2022 13:45:35 +0200
Message-Id: <20220826114538.705433-4-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826114538.705433-1-netdev@kapio-technology.com>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignore locked fdb entries coming in on all drivers.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/b53/b53_common.c       | 5 +++++
 drivers/net/dsa/b53/b53_priv.h         | 1 +
 drivers/net/dsa/hirschmann/hellcreek.c | 5 +++++
 drivers/net/dsa/lan9303-core.c         | 5 +++++
 drivers/net/dsa/lantiq_gswip.c         | 5 +++++
 drivers/net/dsa/microchip/ksz_common.c | 5 +++++
 drivers/net/dsa/mt7530.c               | 5 +++++
 drivers/net/dsa/mv88e6xxx/chip.c       | 5 +++++
 drivers/net/dsa/ocelot/felix.c         | 5 +++++
 drivers/net/dsa/qca/qca8k-common.c     | 5 +++++
 drivers/net/dsa/qca/qca8k.h            | 1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 7 ++++++-
 include/net/dsa.h                      | 1 +
 net/dsa/switch.c                       | 4 ++--
 14 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 48cf344750ff..8a3c8a286d8c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1684,11 +1684,16 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 
 int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
+		bool is_locked,
 		struct dsa_db db)
 {
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
 	 */
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 795cbffd5c2b..19501b76b9df 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -362,6 +362,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 		 const struct switchdev_obj_port_vlan *vlan);
 int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
+		bool is_locked,
 		struct dsa_db db);
 int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 01f90994dedd..d93fc198dcb8 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -829,12 +829,17 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 
 static int hellcreek_fdb_add(struct dsa_switch *ds, int port,
 			     const unsigned char *addr, u16 vid,
+			     bool is_locked,
 			     struct dsa_db db)
 {
 	struct hellcreek_fdb_entry entry = { 0 };
 	struct hellcreek *hellcreek = ds->priv;
 	int ret;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	dev_dbg(hellcreek->dev, "Add FDB entry for MAC=%pM\n", addr);
 
 	mutex_lock(&hellcreek->reg_lock);
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e03ff1f267bb..426b9ea668da 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1190,10 +1190,15 @@ static void lan9303_port_fast_age(struct dsa_switch *ds, int port)
 
 static int lan9303_port_fdb_add(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
+				bool is_locked,
 				struct dsa_db db)
 {
 	struct lan9303 *chip = ds->priv;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	dev_dbg(chip->dev, "%s(%d, %pM, %d)\n", __func__, port, addr, vid);
 	if (vid)
 		return -EOPNOTSUPP;
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e531b93f3cb2..6622bf3c7249 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1399,8 +1399,13 @@ static int gswip_port_fdb(struct dsa_switch *ds, int port,
 
 static int gswip_port_fdb_add(struct dsa_switch *ds, int port,
 			      const unsigned char *addr, u16 vid,
+			      bool is_locked,
 			      struct dsa_db db)
 {
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	return gswip_port_fdb(ds, port, addr, vid, true);
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 6bd69a7e6809..9786983114ba 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1205,6 +1205,7 @@ static void ksz_port_fast_age(struct dsa_switch *ds, int port)
 
 static int ksz_port_fdb_add(struct dsa_switch *ds, int port,
 			    const unsigned char *addr, u16 vid,
+			    bool is_locked,
 			    struct dsa_db db)
 {
 	struct ksz_device *dev = ds->priv;
@@ -1212,6 +1213,10 @@ static int ksz_port_fdb_add(struct dsa_switch *ds, int port,
 	if (!dev->dev_ops->fdb_add)
 		return -EOPNOTSUPP;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	return dev->dev_ops->fdb_add(dev, port, addr, vid, db);
 }
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 835807911be0..df657747fb09 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1366,12 +1366,17 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 static int
 mt7530_port_fdb_add(struct dsa_switch *ds, int port,
 		    const unsigned char *addr, u16 vid,
+		    bool is_locked,
 		    struct dsa_db db)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
 	u8 port_mask = BIT(port);
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	mutex_lock(&priv->reg_mutex);
 	mt7530_fdb_write(priv, vid, port_mask, addr, -1, STATIC_ENT);
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_WRITE, NULL);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 07e9a4da924c..57ef20aac300 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2714,11 +2714,16 @@ static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
 
 static int mv88e6xxx_port_fdb_add(struct dsa_switch *ds, int port,
 				  const unsigned char *addr, u16 vid,
+				  bool is_locked,
 				  struct dsa_db db)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
 					   MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC);
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ee19ed96f284..65da02c42061 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -704,12 +704,17 @@ static int felix_fdb_dump(struct dsa_switch *ds, int port,
 
 static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 const unsigned char *addr, u16 vid,
+			 bool is_locked,
 			 struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
 	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
index bba95613e218..e7022f528bbf 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -795,11 +795,16 @@ int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 
 int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 		       const unsigned char *addr, u16 vid,
+		       bool is_locked,
 		       struct dsa_db db)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	u16 port_mask = BIT(port);
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
 }
 
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index e36ecc9777f4..cac21267211f 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -479,6 +479,7 @@ int qca8k_port_fdb_insert(struct qca8k_priv *priv, const u8 *addr,
 			  u16 port_mask, u16 vid);
 int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 		       const unsigned char *addr, u16 vid,
+		       bool is_locked,
 		       struct dsa_db db);
 int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 		       const unsigned char *addr, u16 vid,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b03d0d0c3dbf..4419787ebdfb 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1802,10 +1802,15 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 
 static int sja1105_fdb_add(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid,
+			   bool is_locked,
 			   struct dsa_db db)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	/* Ignore locked entries */
+	if (is_locked)
+		return 0;
+
 	if (!vid) {
 		switch (db.type) {
 		case DSA_DB_PORT:
@@ -1944,7 +1949,7 @@ static int sja1105_mdb_add(struct dsa_switch *ds, int port,
 			   const struct switchdev_obj_port_mdb *mdb,
 			   struct dsa_db db)
 {
-	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, db);
+	return sja1105_fdb_add(ds, port, mdb->addr, mdb->vid, false, db);
 }
 
 static int sja1105_mdb_del(struct dsa_switch *ds, int port,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index f2ce12860546..abda2806c5cb 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -1017,6 +1017,7 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
+				bool is_locked,
 				struct dsa_db db);
 	int	(*port_fdb_del)(struct dsa_switch *ds, int port,
 				const unsigned char *addr, u16 vid,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index f29604f25c67..849d5a39d021 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -243,7 +243,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 
 	/* No need to bother with refcounting for user ports */
 	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid, db);
+		return ds->ops->port_fdb_add(ds, port, addr, vid, is_locked, db);
 
 	mutex_lock(&dp->addr_lists_lock);
 
@@ -259,7 +259,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		goto out;
 	}
 
-	err = ds->ops->port_fdb_add(ds, port, addr, vid, db);
+	err = ds->ops->port_fdb_add(ds, port, addr, vid, is_locked, db);
 	if (err) {
 		kfree(a);
 		goto out;
-- 
2.30.2

