Return-Path: <netdev+bounces-8449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0287B7241FF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 154BA28166B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E74E2A9C2;
	Tue,  6 Jun 2023 12:23:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C2415ACE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:23:29 +0000 (UTC)
Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F51210C6
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:23:24 -0700 (PDT)
Date: Tue, 06 Jun 2023 12:23:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=atinb.me;
	s=protonmail; t=1686054202; x=1686313402;
	bh=cTfL7RXcA72zUyZdRLiJvjPG4O4S6ehTBzTONfxjw+s=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=GCuIgh0FEePKs4mNLQCOrXoJZNf6PveiPo8qbFgv+LFmlE0wmm8kM1nLIWNzvDirR
	 WBK740p1SjuGBC9fBii3Po92m8mGqnyLu7bYIs3UcrTdQ8kmVcx9YzBvys8561l1Zz
	 nuBFyN3PN2IpSM7+21VPfsfX7wtV0wAQw1BO0qDvYCCBIRf9EW1xfzg/XQluBiFwuf
	 Hau9bE/HhcYHBOYrt45ijH6EHshVT8y6CnaOP07KHLTQwD8/49CfqJJJ1IsuVSt+If
	 EcHjim0kiJMyjdlaz4HLxh756g7xZtQ70faIFf3zjaMKVTuDRIAvnp+kW4G7aeQsul
	 qy/zPdXMkv2zg==
To: andrew@lunn.ch
From: Atin Bainada <hi@atinb.me>
Cc: f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Atin Bainada <hi@atinb.me>
Subject: [PATCH] net: dsa: qca8k: remove unnecessary (void*) conversions
Message-ID: <20230606122129.141815-1-hi@atinb.me>
Feedback-ID: 64551405:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pointer variables of (void*) type do not require type cast.

Signed-off-by: Atin Bainada <hi@atinb.me>
---
 drivers/net/dsa/qca/ar9331.c       | 16 ++++++++--------
 drivers/net/dsa/qca/qca8k-8xxx.c   |  2 +-
 drivers/net/dsa/qca/qca8k-common.c |  6 +++---
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index e7b98b864fa1..b2bf78ac485e 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -391,7 +391,7 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *p=
riv)
=20
 static int ar9331_sw_setup_port(struct dsa_switch *ds, int port)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct regmap *regmap =3D priv->regmap;
 =09u32 port_mask, port_ctrl, val;
 =09int ret;
@@ -439,7 +439,7 @@ static int ar9331_sw_setup_port(struct dsa_switch *ds, =
int port)
=20
 static int ar9331_sw_setup(struct dsa_switch *ds)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct regmap *regmap =3D priv->regmap;
 =09int ret, i;
=20
@@ -484,7 +484,7 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
=20
 static void ar9331_sw_port_disable(struct dsa_switch *ds, int port)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct regmap *regmap =3D priv->regmap;
 =09int ret;
=20
@@ -527,7 +527,7 @@ static void ar9331_sw_phylink_mac_config(struct dsa_swi=
tch *ds, int port,
 =09=09=09=09=09 unsigned int mode,
 =09=09=09=09=09 const struct phylink_link_state *state)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct regmap *regmap =3D priv->regmap;
 =09int ret;
=20
@@ -542,7 +542,7 @@ static void ar9331_sw_phylink_mac_link_down(struct dsa_=
switch *ds, int port,
 =09=09=09=09=09    unsigned int mode,
 =09=09=09=09=09    phy_interface_t interface)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct ar9331_sw_port *p =3D &priv->port[port];
 =09struct regmap *regmap =3D priv->regmap;
 =09int ret;
@@ -562,7 +562,7 @@ static void ar9331_sw_phylink_mac_link_up(struct dsa_sw=
itch *ds, int port,
 =09=09=09=09=09  int speed, int duplex,
 =09=09=09=09=09  bool tx_pause, bool rx_pause)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct ar9331_sw_port *p =3D &priv->port[port];
 =09struct regmap *regmap =3D priv->regmap;
 =09u32 val;
@@ -665,7 +665,7 @@ static void ar9331_do_stats_poll(struct work_struct *wo=
rk)
 static void ar9331_get_stats64(struct dsa_switch *ds, int port,
 =09=09=09       struct rtnl_link_stats64 *s)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct ar9331_sw_port *p =3D &priv->port[port];
=20
 =09spin_lock(&p->stats_lock);
@@ -676,7 +676,7 @@ static void ar9331_get_stats64(struct dsa_switch *ds, i=
nt port,
 static void ar9331_get_pause_stats(struct dsa_switch *ds, int port,
 =09=09=09=09   struct ethtool_pause_stats *pause_stats)
 {
-=09struct ar9331_sw_priv *priv =3D (struct ar9331_sw_priv *)ds->priv;
+=09struct ar9331_sw_priv *priv =3D ds->priv;
 =09struct ar9331_sw_port *p =3D &priv->port[port];
=20
 =09spin_lock(&p->stats_lock);
diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8=
xxx.c
index 6d5ac7588a69..dee7b6579916 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1756,7 +1756,7 @@ static int qca8k_connect_tag_protocol(struct dsa_swit=
ch *ds,
 static int
 qca8k_setup(struct dsa_switch *ds)
 {
-=09struct qca8k_priv *priv =3D (struct qca8k_priv *)ds->priv;
+=09struct qca8k_priv *priv =3D ds->priv;
 =09int cpu_port, ret, i;
 =09u32 mask;
=20
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k=
-common.c
index 96773e432558..8c2dc0e48ff4 100644
--- a/drivers/net/dsa/qca/qca8k-common.c
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -760,7 +760,7 @@ int qca8k_port_fdb_add(struct dsa_switch *ds, int port,
 =09=09       const unsigned char *addr, u16 vid,
 =09=09       struct dsa_db db)
 {
-=09struct qca8k_priv *priv =3D (struct qca8k_priv *)ds->priv;
+=09struct qca8k_priv *priv =3D ds->priv;
 =09u16 port_mask =3D BIT(port);
=20
 =09return qca8k_port_fdb_insert(priv, addr, port_mask, vid);
@@ -770,7 +770,7 @@ int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 =09=09       const unsigned char *addr, u16 vid,
 =09=09       struct dsa_db db)
 {
-=09struct qca8k_priv *priv =3D (struct qca8k_priv *)ds->priv;
+=09struct qca8k_priv *priv =3D ds->priv;
 =09u16 port_mask =3D BIT(port);
=20
 =09if (!vid)
@@ -782,7 +782,7 @@ int qca8k_port_fdb_del(struct dsa_switch *ds, int port,
 int qca8k_port_fdb_dump(struct dsa_switch *ds, int port,
 =09=09=09dsa_fdb_dump_cb_t *cb, void *data)
 {
-=09struct qca8k_priv *priv =3D (struct qca8k_priv *)ds->priv;
+=09struct qca8k_priv *priv =3D ds->priv;
 =09struct qca8k_fdb _fdb =3D { 0 };
 =09int cnt =3D QCA8K_NUM_FDB_RECORDS;
 =09bool is_static;
--=20
2.40.0



