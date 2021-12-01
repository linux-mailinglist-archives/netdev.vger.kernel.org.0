Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E50F464958
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347872AbhLAIRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:17:02 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52787 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347714AbhLAIQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:59 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 50BB95C0256;
        Wed,  1 Dec 2021 03:13:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 01 Dec 2021 03:13:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=J688way4O+wKbz1RqwkI7EMEosTw/LZOUeSmhIzpcfg=; b=QzOJQGsh
        HuMFTD5tsZaYahgewd3XV4YzIxSazVCewZn7pDDHV0JRynz7sgLw6KEjl9HEfIJj
        k3lyjYLAtPs/lz1jRpn0fFZQCMtYHhGIOx682MxV1z1o7xDR+TGiPltGVXlzbPDG
        kBqCToNDEEydnQ5+dRKsBvA8fhFrU/ZNlWSU0SiHVpBuyN1PCQgwCU0yYWTGIDrU
        xMzN2o06WSubYnRT6g4OTX2aH6VXO2p72C9c2VBnkp0gx19FPbwWrQLOYKkQQ2zu
        kjzGmZ3LCgHUPl18bVBarjNvhFdLOuOQk7XnIjjg0dlUKV/9qket8Si2vxF3cjr6
        o4k4SH5LBD631g==
X-ME-Sender: <xms:sy6nYVKlGyPHWDoXU3TuLvpzfbJW6m9sS9Ok1WMHnMD9wybag4mBWA>
    <xme:sy6nYRIs25Svm8JHc75ii3MXgf-l5setev-OBEcAT9p9MZcMZO3tjU8b0oJ01D6PM
    -b5Efw3zRA_zYk>
X-ME-Received: <xmr:sy6nYdtH4n6UBL_Kjv2i9VtAEgnlz7BKZ2mxDr_IHn0dz-t7VYTW2gI0_0tUyCZVujrJ08eCJZdZO7FAHksL08l8Er799TAdQ6LBzYQ4SzRTUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:sy6nYWbGrr-2xZ0qBUxrPv7moZW7UJ-91L7LNIxVl9dV4kL00AfIAw>
    <xmx:sy6nYcbh9Tl4rwuaFKYPfsoH2VO0PjvYD5EHy5zzWncpe0saYQUDsg>
    <xmx:sy6nYaCh9-3aLqNxAW78l1XUYs7f3ReFS91pX5G3kMc4EdIFDhPvrQ>
    <xmx:sy6nYTUgnJsx7PrY0X0xePeSWfIHmguDsakMT4nnRWrXOq8ugP7DDw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:37 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/10] mlxsw: Use Switch Flooding Table Register Version 2
Date:   Wed,  1 Dec 2021 10:12:39 +0200
Message-Id: <20211201081240.3767366-10-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The SFTR-V2 register is used for flooding packet replication.
It is a new version of SFTR in order to support 1024 bits of local_port.

Add SFTR-V2 register and use it instead of SFTR.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 142 +++++++++---------
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |  18 +--
 2 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 4c26188d541c..43cac526b9ad 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1108,76 +1108,6 @@ mlxsw_reg_sfgc_pack(char *payload, enum mlxsw_reg_sfgc_type type,
 	mlxsw_reg_sfgc_mid_set(payload, MLXSW_PORT_MID);
 }
 
-/* SFTR - Switch Flooding Table Register
- * -------------------------------------
- * The switch flooding table is used for flooding packet replication. The table
- * defines a bit mask of ports for packet replication.
- */
-#define MLXSW_REG_SFTR_ID 0x2012
-#define MLXSW_REG_SFTR_LEN 0x420
-
-MLXSW_REG_DEFINE(sftr, MLXSW_REG_SFTR_ID, MLXSW_REG_SFTR_LEN);
-
-/* reg_sftr_swid
- * Switch partition ID with which to associate the port.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr, swid, 0x00, 24, 8);
-
-/* reg_sftr_flood_table
- * Flooding table index to associate with the specific type on the specific
- * switch partition.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr, flood_table, 0x00, 16, 6);
-
-/* reg_sftr_index
- * Index. Used as an index into the Flooding Table in case the table is
- * configured to use VID / FID or FID Offset.
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr, index, 0x00, 0, 16);
-
-/* reg_sftr_table_type
- * See mlxsw_flood_table_type
- * Access: RW
- */
-MLXSW_ITEM32(reg, sftr, table_type, 0x04, 16, 3);
-
-/* reg_sftr_range
- * Range of entries to update
- * Access: Index
- */
-MLXSW_ITEM32(reg, sftr, range, 0x04, 0, 16);
-
-/* reg_sftr_port
- * Local port membership (1 bit per port).
- * Access: RW
- */
-MLXSW_ITEM_BIT_ARRAY(reg, sftr, port, 0x20, 0x20, 1);
-
-/* reg_sftr_cpu_port_mask
- * CPU port mask (1 bit per port).
- * Access: W
- */
-MLXSW_ITEM_BIT_ARRAY(reg, sftr, port_mask, 0x220, 0x20, 1);
-
-static inline void mlxsw_reg_sftr_pack(char *payload,
-				       unsigned int flood_table,
-				       unsigned int index,
-				       enum mlxsw_flood_table_type table_type,
-				       unsigned int range, u8 port, bool set)
-{
-	MLXSW_REG_ZERO(sftr, payload);
-	mlxsw_reg_sftr_swid_set(payload, 0);
-	mlxsw_reg_sftr_flood_table_set(payload, flood_table);
-	mlxsw_reg_sftr_index_set(payload, index);
-	mlxsw_reg_sftr_table_type_set(payload, table_type);
-	mlxsw_reg_sftr_range_set(payload, range);
-	mlxsw_reg_sftr_port_set(payload, port, set);
-	mlxsw_reg_sftr_port_mask_set(payload, port, 1);
-}
-
 /* SFDF - Switch Filtering DB Flush
  * --------------------------------
  * The switch filtering DB flush register is used to flush the FDB.
@@ -2105,6 +2035,76 @@ static inline void mlxsw_reg_spevet_pack(char *payload, u16 local_port,
 	mlxsw_reg_spevet_et_vlan_set(payload, et_vlan);
 }
 
+/* SFTR-V2 - Switch Flooding Table Version 2 Register
+ * --------------------------------------------------
+ * The switch flooding table is used for flooding packet replication. The table
+ * defines a bit mask of ports for packet replication.
+ */
+#define MLXSW_REG_SFTR2_ID 0x202F
+#define MLXSW_REG_SFTR2_LEN 0x120
+
+MLXSW_REG_DEFINE(sftr2, MLXSW_REG_SFTR2_ID, MLXSW_REG_SFTR2_LEN);
+
+/* reg_sftr2_swid
+ * Switch partition ID with which to associate the port.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, sftr2, swid, 0x00, 24, 8);
+
+/* reg_sftr2_flood_table
+ * Flooding table index to associate with the specific type on the specific
+ * switch partition.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, sftr2, flood_table, 0x00, 16, 6);
+
+/* reg_sftr2_index
+ * Index. Used as an index into the Flooding Table in case the table is
+ * configured to use VID / FID or FID Offset.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, sftr2, index, 0x00, 0, 16);
+
+/* reg_sftr2_table_type
+ * See mlxsw_flood_table_type
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, sftr2, table_type, 0x04, 16, 3);
+
+/* reg_sftr2_range
+ * Range of entries to update
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, sftr2, range, 0x04, 0, 16);
+
+/* reg_sftr2_port
+ * Local port membership (1 bit per port).
+ * Access: RW
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port, 0x20, 0x80, 1);
+
+/* reg_sftr2_port_mask
+ * Local port mask (1 bit per port).
+ * Access: WO
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, sftr2, port_mask, 0xA0, 0x80, 1);
+
+static inline void mlxsw_reg_sftr2_pack(char *payload,
+					unsigned int flood_table,
+					unsigned int index,
+					enum mlxsw_flood_table_type table_type,
+					unsigned int range, u16 port, bool set)
+{
+	MLXSW_REG_ZERO(sftr2, payload);
+	mlxsw_reg_sftr2_swid_set(payload, 0);
+	mlxsw_reg_sftr2_flood_table_set(payload, flood_table);
+	mlxsw_reg_sftr2_index_set(payload, index);
+	mlxsw_reg_sftr2_table_type_set(payload, table_type);
+	mlxsw_reg_sftr2_range_set(payload, range);
+	mlxsw_reg_sftr2_port_set(payload, port, set);
+	mlxsw_reg_sftr2_port_mask_set(payload, port, 1);
+}
+
 /* CWTP - Congetion WRED ECN TClass Profile
  * ----------------------------------------
  * Configures the profiles for queues of egress port and traffic class
@@ -12383,7 +12383,6 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(spvm),
 	MLXSW_REG(spaft),
 	MLXSW_REG(sfgc),
-	MLXSW_REG(sftr),
 	MLXSW_REG(sfdf),
 	MLXSW_REG(sldr),
 	MLXSW_REG(slcr),
@@ -12396,6 +12395,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(spvmlr),
 	MLXSW_REG(spvc),
 	MLXSW_REG(spevet),
+	MLXSW_REG(sftr2),
 	MLXSW_REG(cwtp),
 	MLXSW_REG(cwtpm),
 	MLXSW_REG(pgcr),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index d5e9af064ee6..ce80931f0402 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -323,7 +323,7 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 	const struct mlxsw_sp_flood_table *flood_table;
-	char *sftr_pl;
+	char *sftr2_pl;
 	int err;
 
 	if (WARN_ON(!fid_family->flood_tables || !ops->flood_index))
@@ -333,16 +333,16 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 	if (!flood_table)
 		return -ESRCH;
 
-	sftr_pl = kmalloc(MLXSW_REG_SFTR_LEN, GFP_KERNEL);
-	if (!sftr_pl)
+	sftr2_pl = kmalloc(MLXSW_REG_SFTR2_LEN, GFP_KERNEL);
+	if (!sftr2_pl)
 		return -ENOMEM;
 
-	mlxsw_reg_sftr_pack(sftr_pl, flood_table->table_index,
-			    ops->flood_index(fid), flood_table->table_type, 1,
-			    local_port, member);
-	err = mlxsw_reg_write(fid_family->mlxsw_sp->core, MLXSW_REG(sftr),
-			      sftr_pl);
-	kfree(sftr_pl);
+	mlxsw_reg_sftr2_pack(sftr2_pl, flood_table->table_index,
+			     ops->flood_index(fid), flood_table->table_type, 1,
+			     local_port, member);
+	err = mlxsw_reg_write(fid_family->mlxsw_sp->core, MLXSW_REG(sftr2),
+			      sftr2_pl);
+	kfree(sftr2_pl);
 	return err;
 }
 
-- 
2.31.1

