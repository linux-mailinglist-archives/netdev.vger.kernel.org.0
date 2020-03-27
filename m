Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E819195369
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 09:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgC0I47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 04:56:59 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55237 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgC0I46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 04:56:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 707F85C0454;
        Fri, 27 Mar 2020 04:56:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 27 Mar 2020 04:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=2/Fy03bEdu8YZ6wZqZolsZCEn2abfyEVOlTWoVXHd
        38=; b=q/jMRtI+2DeZzJ+ecUtWdb370U7YWZZ5AwijDNal7oUYW1kanJJIBTYLt
        daVbhipj3Oj7F1UgZYnhtSAgeg1ldoysiUPVVJyil+ROtXV3Y5zK1BRH4l2mAHWT
        RMYrTPAYFfG76mgfGmDbNjlDcTk5U5pm3uviUN9156TBGSM1/7idnjJutTOPOE/+
        XNVv3liiAHwTNlvFf6fqXRfwEIb1741bkwlV/PO0kK4r9nES8rsBQM1UBuCaVWXb
        29sWUeuoAX8vcIVolQn86twziR5XZOXLtStD+G6KqgRsGon89Ay49PO90UbB3bOa
        W4FJpn1uLJnMCBy3J02xKO73lrs0g==
X-ME-Sender: <xms:2b99XgHQMd_6HmkasfiaynpkuGFV8_Acp7qQy3OdtkVREv7cFsvbwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhggtgfgsehtke
    ertdertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:2b99XuqrdTIv95NjTt0089mMFRlDtce_eze6enAJ8H7Ar-jVPGYLjA>
    <xmx:2b99XmNmFPk3dnOndTNpFReFHrLcOLvtp991HD65xokFxCotW2CWdg>
    <xmx:2b99XupsfXxNx98wK8RySnfvwqa92aBStbcSJU6RFvy2DLweI7ORQA>
    <xmx:2b99Xk-JZ1rrnjzgVT6xMPnuEulvyq2U-PcHVV4aQzU1Yem35ds7UA>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A97C306C157;
        Fri, 27 Mar 2020 04:56:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/6] mlxsw: spectrum: Remove unused RIF and FID families
Date:   Fri, 27 Mar 2020 11:55:22 +0300
Message-Id: <20200327085525.1906170-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200327085525.1906170-1-idosch@idosch.org>
References: <20200327085525.1906170-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

In merge commit 50853808ff4a ("Merge branch
'mlxsw-Prepare-for-VLAN-aware-bridge-w-VxLAN'") I flipped mlxsw to use
emulated 802.1Q FIDs and correspondingly emulated VLAN RIFs. This means
that the non-emulated variants are no longer used. Remove them and
suppress the following warnings when compiling with W=1:

drivers/net/ethernet/mellanox/mlxsw//spectrum_router.c:7572:38: warning:
‘mlxsw_sp_rif_vlan_ops’ defined but not used [-Wunused-const-variable=]

drivers/net/ethernet/mellanox/mlxsw//spectrum_fid.c:584:41: warning:
‘mlxsw_sp_fid_8021q_family’ defined but not used
[-Wunused-const-variable=]

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 152 +-----------------
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 143 +++++-----------
 2 files changed, 47 insertions(+), 248 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 65486a90b526..004c42274e48 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -438,16 +438,6 @@ static int mlxsw_sp_fid_vni_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
-static int mlxsw_sp_fid_vid_map(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
-				u16 vid, bool valid)
-{
-	enum mlxsw_reg_svfa_mt mt = MLXSW_REG_SVFA_MT_VID_TO_FID;
-	char svfa_pl[MLXSW_REG_SVFA_LEN];
-
-	mlxsw_reg_svfa_pack(svfa_pl, 0, mt, valid, fid_index, vid);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
-}
-
 static int __mlxsw_sp_fid_port_vid_map(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 				       u8 local_port, u16 vid, bool valid)
 {
@@ -458,140 +448,6 @@ static int __mlxsw_sp_fid_port_vid_map(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(svfa), svfa_pl);
 }
 
-static int mlxsw_sp_fid_8021q_configure(struct mlxsw_sp_fid *fid)
-{
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
-	struct mlxsw_sp_fid_8021q *fid_8021q;
-	int err;
-
-	err = mlxsw_sp_fid_op(mlxsw_sp, fid->fid_index, fid->fid_index, true);
-	if (err)
-		return err;
-
-	fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
-	err = mlxsw_sp_fid_vid_map(mlxsw_sp, fid->fid_index, fid_8021q->vid,
-				   true);
-	if (err)
-		goto err_fid_map;
-
-	return 0;
-
-err_fid_map:
-	mlxsw_sp_fid_op(mlxsw_sp, fid->fid_index, 0, false);
-	return err;
-}
-
-static void mlxsw_sp_fid_8021q_deconfigure(struct mlxsw_sp_fid *fid)
-{
-	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
-	struct mlxsw_sp_fid_8021q *fid_8021q;
-
-	fid_8021q = mlxsw_sp_fid_8021q_fid(fid);
-	mlxsw_sp_fid_vid_map(mlxsw_sp, fid->fid_index, fid_8021q->vid, false);
-	mlxsw_sp_fid_op(mlxsw_sp, fid->fid_index, 0, false);
-}
-
-static int mlxsw_sp_fid_8021q_index_alloc(struct mlxsw_sp_fid *fid,
-					  const void *arg, u16 *p_fid_index)
-{
-	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
-	u16 vid = *(u16 *) arg;
-
-	/* Use 1:1 mapping for simplicity although not a must */
-	if (vid < fid_family->start_index || vid > fid_family->end_index)
-		return -EINVAL;
-	*p_fid_index = vid;
-
-	return 0;
-}
-
-static bool
-mlxsw_sp_fid_8021q_compare(const struct mlxsw_sp_fid *fid, const void *arg)
-{
-	u16 vid = *(u16 *) arg;
-
-	return mlxsw_sp_fid_8021q_fid(fid)->vid == vid;
-}
-
-static u16 mlxsw_sp_fid_8021q_flood_index(const struct mlxsw_sp_fid *fid)
-{
-	return fid->fid_index;
-}
-
-static int mlxsw_sp_fid_8021q_port_vid_map(struct mlxsw_sp_fid *fid,
-					   struct mlxsw_sp_port *mlxsw_sp_port,
-					   u16 vid)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
-
-	/* In case there are no {Port, VID} => FID mappings on the port,
-	 * we can use the global VID => FID mapping we created when the
-	 * FID was configured.
-	 */
-	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 0)
-		return 0;
-	return __mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index, local_port,
-					   vid, true);
-}
-
-static void
-mlxsw_sp_fid_8021q_port_vid_unmap(struct mlxsw_sp_fid *fid,
-				  struct mlxsw_sp_port *mlxsw_sp_port, u16 vid)
-{
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	u8 local_port = mlxsw_sp_port->local_port;
-
-	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 0)
-		return;
-	__mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index, local_port, vid,
-				    false);
-}
-
-static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021q_ops = {
-	.setup			= mlxsw_sp_fid_8021q_setup,
-	.configure		= mlxsw_sp_fid_8021q_configure,
-	.deconfigure		= mlxsw_sp_fid_8021q_deconfigure,
-	.index_alloc		= mlxsw_sp_fid_8021q_index_alloc,
-	.compare		= mlxsw_sp_fid_8021q_compare,
-	.flood_index		= mlxsw_sp_fid_8021q_flood_index,
-	.port_vid_map		= mlxsw_sp_fid_8021q_port_vid_map,
-	.port_vid_unmap		= mlxsw_sp_fid_8021q_port_vid_unmap,
-};
-
-static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021q_flood_tables[] = {
-	{
-		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
-		.bridge_type	= MLXSW_REG_SFGC_BRIDGE_TYPE_1Q_FID,
-		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
-		.table_index	= 0,
-	},
-	{
-		.packet_type	= MLXSW_SP_FLOOD_TYPE_MC,
-		.bridge_type	= MLXSW_REG_SFGC_BRIDGE_TYPE_1Q_FID,
-		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
-		.table_index	= 1,
-	},
-	{
-		.packet_type	= MLXSW_SP_FLOOD_TYPE_BC,
-		.bridge_type	= MLXSW_REG_SFGC_BRIDGE_TYPE_1Q_FID,
-		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
-		.table_index	= 2,
-	},
-};
-
-/* Range and flood configuration must match mlxsw_config_profile */
-static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021q_family = {
-	.type			= MLXSW_SP_FID_TYPE_8021Q,
-	.fid_size		= sizeof(struct mlxsw_sp_fid_8021q),
-	.start_index		= 1,
-	.end_index		= VLAN_VID_MASK,
-	.flood_tables		= mlxsw_sp_fid_8021q_flood_tables,
-	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021q_flood_tables),
-	.rif_type		= MLXSW_SP_RIF_TYPE_VLAN,
-	.ops			= &mlxsw_sp_fid_8021q_ops,
-};
-
 static struct mlxsw_sp_fid_8021d *
 mlxsw_sp_fid_8021d_fid(const struct mlxsw_sp_fid *fid)
 {
@@ -846,6 +702,14 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021d_family = {
 	.lag_vid_valid		= 1,
 };
 
+static bool
+mlxsw_sp_fid_8021q_compare(const struct mlxsw_sp_fid *fid, const void *arg)
+{
+	u16 vid = *(u16 *) arg;
+
+	return mlxsw_sp_fid_8021q_fid(fid)->vid == vid;
+}
+
 static void
 mlxsw_sp_fid_8021q_fdb_clear_offload(const struct mlxsw_sp_fid *fid,
 				     const struct net_device *nve_dev)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 85f80cac5fe0..97b7e6ebd9fa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7475,13 +7475,14 @@ u8 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp)
 	return mlxsw_core_max_ports(mlxsw_sp->core) + 1;
 }
 
-static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif)
+static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif)
 {
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
-	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
+	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
 	int err;
 
-	err = mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_VLAN_IF, vid, true);
+	err = mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index,
+				       true);
 	if (err)
 		return err;
 
@@ -7510,13 +7511,13 @@ static int mlxsw_sp_rif_vlan_configure(struct mlxsw_sp_rif *rif)
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
 err_fid_mc_flood_set:
-	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_VLAN_IF, vid, false);
+	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
 	return err;
 }
 
-static void mlxsw_sp_rif_vlan_deconfigure(struct mlxsw_sp_rif *rif)
+static void mlxsw_sp_rif_fid_deconfigure(struct mlxsw_sp_rif *rif)
 {
-	u16 vid = mlxsw_sp_fid_8021q_vid(rif->fid);
+	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	struct mlxsw_sp_fid *fid = rif->fid;
 
@@ -7528,9 +7529,40 @@ static void mlxsw_sp_rif_vlan_deconfigure(struct mlxsw_sp_rif *rif)
 			       mlxsw_sp_router_port(mlxsw_sp), false);
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
-	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_VLAN_IF, vid, false);
+	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
+}
+
+static struct mlxsw_sp_fid *
+mlxsw_sp_rif_fid_fid_get(struct mlxsw_sp_rif *rif,
+			 struct netlink_ext_ack *extack)
+{
+	return mlxsw_sp_fid_8021d_get(rif->mlxsw_sp, rif->dev->ifindex);
 }
 
+static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
+{
+	struct switchdev_notifier_fdb_info info;
+	struct net_device *dev;
+
+	dev = br_fdb_find_port(rif->dev, mac, 0);
+	if (!dev)
+		return;
+
+	info.addr = mac;
+	info.vid = 0;
+	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
+				 NULL);
+}
+
+static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_fid_ops = {
+	.type			= MLXSW_SP_RIF_TYPE_FID,
+	.rif_size		= sizeof(struct mlxsw_sp_rif),
+	.configure		= mlxsw_sp_rif_fid_configure,
+	.deconfigure		= mlxsw_sp_rif_fid_deconfigure,
+	.fid_get		= mlxsw_sp_rif_fid_fid_get,
+	.fdb_del		= mlxsw_sp_rif_fid_fdb_del,
+};
+
 static struct mlxsw_sp_fid *
 mlxsw_sp_rif_vlan_fid_get(struct mlxsw_sp_rif *rif,
 			  struct netlink_ext_ack *extack)
@@ -7573,103 +7605,6 @@ static void mlxsw_sp_rif_vlan_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
 				 NULL);
 }
 
-static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_vlan_ops = {
-	.type			= MLXSW_SP_RIF_TYPE_VLAN,
-	.rif_size		= sizeof(struct mlxsw_sp_rif),
-	.configure		= mlxsw_sp_rif_vlan_configure,
-	.deconfigure		= mlxsw_sp_rif_vlan_deconfigure,
-	.fid_get		= mlxsw_sp_rif_vlan_fid_get,
-	.fdb_del		= mlxsw_sp_rif_vlan_fdb_del,
-};
-
-static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif)
-{
-	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
-	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
-	int err;
-
-	err = mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index,
-				       true);
-	if (err)
-		return err;
-
-	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
-				     mlxsw_sp_router_port(mlxsw_sp), true);
-	if (err)
-		goto err_fid_mc_flood_set;
-
-	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
-				     mlxsw_sp_router_port(mlxsw_sp), true);
-	if (err)
-		goto err_fid_bc_flood_set;
-
-	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
-				  mlxsw_sp_fid_index(rif->fid), true);
-	if (err)
-		goto err_rif_fdb_op;
-
-	mlxsw_sp_fid_rif_set(rif->fid, rif);
-	return 0;
-
-err_rif_fdb_op:
-	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
-			       mlxsw_sp_router_port(mlxsw_sp), false);
-err_fid_bc_flood_set:
-	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
-			       mlxsw_sp_router_port(mlxsw_sp), false);
-err_fid_mc_flood_set:
-	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
-	return err;
-}
-
-static void mlxsw_sp_rif_fid_deconfigure(struct mlxsw_sp_rif *rif)
-{
-	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
-	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
-	struct mlxsw_sp_fid *fid = rif->fid;
-
-	mlxsw_sp_fid_rif_set(fid, NULL);
-	mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
-			    mlxsw_sp_fid_index(fid), false);
-	mlxsw_sp_rif_macvlan_flush(rif);
-	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_BC,
-			       mlxsw_sp_router_port(mlxsw_sp), false);
-	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
-			       mlxsw_sp_router_port(mlxsw_sp), false);
-	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
-}
-
-static struct mlxsw_sp_fid *
-mlxsw_sp_rif_fid_fid_get(struct mlxsw_sp_rif *rif,
-			 struct netlink_ext_ack *extack)
-{
-	return mlxsw_sp_fid_8021d_get(rif->mlxsw_sp, rif->dev->ifindex);
-}
-
-static void mlxsw_sp_rif_fid_fdb_del(struct mlxsw_sp_rif *rif, const char *mac)
-{
-	struct switchdev_notifier_fdb_info info;
-	struct net_device *dev;
-
-	dev = br_fdb_find_port(rif->dev, mac, 0);
-	if (!dev)
-		return;
-
-	info.addr = mac;
-	info.vid = 0;
-	call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE, dev, &info.info,
-				 NULL);
-}
-
-static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_fid_ops = {
-	.type			= MLXSW_SP_RIF_TYPE_FID,
-	.rif_size		= sizeof(struct mlxsw_sp_rif),
-	.configure		= mlxsw_sp_rif_fid_configure,
-	.deconfigure		= mlxsw_sp_rif_fid_deconfigure,
-	.fid_get		= mlxsw_sp_rif_fid_fid_get,
-	.fdb_del		= mlxsw_sp_rif_fid_fdb_del,
-};
-
 static const struct mlxsw_sp_rif_ops mlxsw_sp_rif_vlan_emu_ops = {
 	.type			= MLXSW_SP_RIF_TYPE_VLAN,
 	.rif_size		= sizeof(struct mlxsw_sp_rif),
-- 
2.24.1

