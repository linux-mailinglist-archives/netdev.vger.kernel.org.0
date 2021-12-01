Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7B0464959
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347864AbhLAIRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:17:03 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35315 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347861AbhLAIRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:17:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6227D5C0256;
        Wed,  1 Dec 2021 03:13:41 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 01 Dec 2021 03:13:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=7KwoSFM3mUKoWkxUJJ9XyEgg3h4GOqhUIh/3tiUT/Mc=; b=MUpaN3RM
        DHnhpftBdbiqEi//BE/0DAfjEvwDJCBM3CQ8n5c6DDTbIgKem+x0WdiQXrY/Qnmf
        R0R6cxS7jvartvJMX8WBTkAMFvyzF/q2sAbGn8Cgx4UEOV2VlZqWgW4DbikOb//D
        r+ExmcllN+mp0xECs3pUIID6FGIHxFFDSFx2Fa8XH9wlHeqLuN8O4OVqZ3JVAm3h
        cAoeGcAm59wdkXiOEOC1agD7p+mElEbuSpueFPb1TUqe73Qx7ScStTur6URT0W+Q
        Iyb591jQfCmULCStj0Qfsv7c/boqxNFJhvTSNBNoyLEn5lToPWGyFRu+XW4bDGSe
        iukWbPFwBsnG/w==
X-ME-Sender: <xms:tS6nYVSntdZF7w078e0WnbFtsjyKTRJv1bxDISoXVNzlmAkufx7ZFg>
    <xme:tS6nYezSEwG5KGbQh_vMQPqnK2Stb0uydZ5opUavaGo4XZsIwZq2XMqWewXoCnRfK
    NHK1jvFIC4jbaU>
X-ME-Received: <xmr:tS6nYa0u4VWD83AMdH4VpVRp-KuWxplqMEOn0SmnNztTlrTA_GsczkiIgPqGHM_gFcuTfZj1iB7k5zI_b5G1geLljF1c8TkPfrWkXDZwV6Gizw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tS6nYdC5LzNySL8RkiDlmR8u9eVCavgJggqe8ERYP3oXkqP08NFVmQ>
    <xmx:tS6nYejBRpTO5F0M-MtdxgnbE_kX1vc7NGnmhSpeF-oESM1g6xvGYQ>
    <xmx:tS6nYRqcHSdu0p_x1GfcGnhh6CqDkMtFii-SrMSOL86UPtpS4-wjMg>
    <xmx:tS6nYWfu4Ev5pzVbkVGFpriL7D9IDTTFfIrPlCbc-zfkwPkPVBr8Pg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:39 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] mlxsw: Use Switch Multicast ID Register Version 2
Date:   Wed,  1 Dec 2021 10:12:40 +0200
Message-Id: <20211201081240.3767366-11-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The SMID-V2 register maps Multicast ID (MID) into a list of local ports.
It is a new version of SMID in order to support 1024 bits of local_port.

Add SMID-V2 register and use it instead of SMID.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 94 +++++++++----------
 .../mellanox/mlxsw/spectrum_switchdev.c       | 50 +++++-----
 2 files changed, 72 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 43cac526b9ad..5eaba2abf212 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -69,52 +69,6 @@ MLXSW_REG_DEFINE(spad, MLXSW_REG_SPAD_ID, MLXSW_REG_SPAD_LEN);
  */
 MLXSW_ITEM_BUF(reg, spad, base_mac, 0x02, 6);
 
-/* SMID - Switch Multicast ID
- * --------------------------
- * The MID record maps from a MID (Multicast ID), which is a unique identifier
- * of the multicast group within the stacking domain, into a list of local
- * ports into which the packet is replicated.
- */
-#define MLXSW_REG_SMID_ID 0x2007
-#define MLXSW_REG_SMID_LEN 0x240
-
-MLXSW_REG_DEFINE(smid, MLXSW_REG_SMID_ID, MLXSW_REG_SMID_LEN);
-
-/* reg_smid_swid
- * Switch partition ID.
- * Access: Index
- */
-MLXSW_ITEM32(reg, smid, swid, 0x00, 24, 8);
-
-/* reg_smid_mid
- * Multicast identifier - global identifier that represents the multicast group
- * across all devices.
- * Access: Index
- */
-MLXSW_ITEM32(reg, smid, mid, 0x00, 0, 16);
-
-/* reg_smid_port
- * Local port memebership (1 bit per port).
- * Access: RW
- */
-MLXSW_ITEM_BIT_ARRAY(reg, smid, port, 0x20, 0x20, 1);
-
-/* reg_smid_port_mask
- * Local port mask (1 bit per port).
- * Access: W
- */
-MLXSW_ITEM_BIT_ARRAY(reg, smid, port_mask, 0x220, 0x20, 1);
-
-static inline void mlxsw_reg_smid_pack(char *payload, u16 mid,
-				       u8 port, bool set)
-{
-	MLXSW_REG_ZERO(smid, payload);
-	mlxsw_reg_smid_swid_set(payload, 0);
-	mlxsw_reg_smid_mid_set(payload, mid);
-	mlxsw_reg_smid_port_set(payload, port, set);
-	mlxsw_reg_smid_port_mask_set(payload, port, 1);
-}
-
 /* SSPR - Switch System Port Record Register
  * -----------------------------------------
  * Configures the system port to local port mapping.
@@ -2105,6 +2059,52 @@ static inline void mlxsw_reg_sftr2_pack(char *payload,
 	mlxsw_reg_sftr2_port_mask_set(payload, port, 1);
 }
 
+/* SMID-V2 - Switch Multicast ID Version 2 Register
+ * ------------------------------------------------
+ * The MID record maps from a MID (Multicast ID), which is a unique identifier
+ * of the multicast group within the stacking domain, into a list of local
+ * ports into which the packet is replicated.
+ */
+#define MLXSW_REG_SMID2_ID 0x2034
+#define MLXSW_REG_SMID2_LEN 0x120
+
+MLXSW_REG_DEFINE(smid2, MLXSW_REG_SMID2_ID, MLXSW_REG_SMID2_LEN);
+
+/* reg_smid2_swid
+ * Switch partition ID.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, smid2, swid, 0x00, 24, 8);
+
+/* reg_smid2_mid
+ * Multicast identifier - global identifier that represents the multicast group
+ * across all devices.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, smid2, mid, 0x00, 0, 16);
+
+/* reg_smid2_port
+ * Local port memebership (1 bit per port).
+ * Access: RW
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, smid2, port, 0x20, 0x80, 1);
+
+/* reg_smid2_port_mask
+ * Local port mask (1 bit per port).
+ * Access: WO
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, smid2, port_mask, 0xA0, 0x80, 1);
+
+static inline void mlxsw_reg_smid2_pack(char *payload, u16 mid, u16 port,
+					bool set)
+{
+	MLXSW_REG_ZERO(smid2, payload);
+	mlxsw_reg_smid2_swid_set(payload, 0);
+	mlxsw_reg_smid2_mid_set(payload, mid);
+	mlxsw_reg_smid2_port_set(payload, port, set);
+	mlxsw_reg_smid2_port_mask_set(payload, port, 1);
+}
+
 /* CWTP - Congetion WRED ECN TClass Profile
  * ----------------------------------------
  * Configures the profiles for queues of egress port and traffic class
@@ -12373,7 +12373,6 @@ static inline void mlxsw_reg_sbib_pack(char *payload, u16 local_port,
 static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(sgcr),
 	MLXSW_REG(spad),
-	MLXSW_REG(smid),
 	MLXSW_REG(sspr),
 	MLXSW_REG(sfdat),
 	MLXSW_REG(sfd),
@@ -12396,6 +12395,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(spvc),
 	MLXSW_REG(spevet),
 	MLXSW_REG(sftr2),
+	MLXSW_REG(smid2),
 	MLXSW_REG(cwtp),
 	MLXSW_REG(cwtpm),
 	MLXSW_REG(pgcr),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 6eb54cd082d0..c5fd69a6bedd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -865,17 +865,17 @@ static int mlxsw_sp_port_mc_disabled_set(struct mlxsw_sp_port *mlxsw_sp_port,
 static int mlxsw_sp_smid_router_port_set(struct mlxsw_sp *mlxsw_sp,
 					 u16 mid_idx, bool add)
 {
-	char *smid_pl;
+	char *smid2_pl;
 	int err;
 
-	smid_pl = kmalloc(MLXSW_REG_SMID_LEN, GFP_KERNEL);
-	if (!smid_pl)
+	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
+	if (!smid2_pl)
 		return -ENOMEM;
 
-	mlxsw_reg_smid_pack(smid_pl, mid_idx,
-			    mlxsw_sp_router_port(mlxsw_sp), add);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid), smid_pl);
-	kfree(smid_pl);
+	mlxsw_reg_smid2_pack(smid2_pl, mid_idx,
+			     mlxsw_sp_router_port(mlxsw_sp), add);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
+	kfree(smid2_pl);
 	return err;
 }
 
@@ -1477,30 +1477,30 @@ static int mlxsw_sp_port_smid_full_entry(struct mlxsw_sp *mlxsw_sp, u16 mid_idx,
 					 long *ports_bitmap,
 					 bool set_router_port)
 {
-	char *smid_pl;
+	char *smid2_pl;
 	int err, i;
 
-	smid_pl = kmalloc(MLXSW_REG_SMID_LEN, GFP_KERNEL);
-	if (!smid_pl)
+	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
+	if (!smid2_pl)
 		return -ENOMEM;
 
-	mlxsw_reg_smid_pack(smid_pl, mid_idx, 0, false);
+	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, 0, false);
 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++) {
 		if (mlxsw_sp->ports[i])
-			mlxsw_reg_smid_port_mask_set(smid_pl, i, 1);
+			mlxsw_reg_smid2_port_mask_set(smid2_pl, i, 1);
 	}
 
-	mlxsw_reg_smid_port_mask_set(smid_pl,
-				     mlxsw_sp_router_port(mlxsw_sp), 1);
+	mlxsw_reg_smid2_port_mask_set(smid2_pl,
+				      mlxsw_sp_router_port(mlxsw_sp), 1);
 
 	for_each_set_bit(i, ports_bitmap, mlxsw_core_max_ports(mlxsw_sp->core))
-		mlxsw_reg_smid_port_set(smid_pl, i, 1);
+		mlxsw_reg_smid2_port_set(smid2_pl, i, 1);
 
-	mlxsw_reg_smid_port_set(smid_pl, mlxsw_sp_router_port(mlxsw_sp),
-				set_router_port);
+	mlxsw_reg_smid2_port_set(smid2_pl, mlxsw_sp_router_port(mlxsw_sp),
+				 set_router_port);
 
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid), smid_pl);
-	kfree(smid_pl);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
+	kfree(smid2_pl);
 	return err;
 }
 
@@ -1508,16 +1508,16 @@ static int mlxsw_sp_port_smid_set(struct mlxsw_sp_port *mlxsw_sp_port,
 				  u16 mid_idx, bool add)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char *smid_pl;
+	char *smid2_pl;
 	int err;
 
-	smid_pl = kmalloc(MLXSW_REG_SMID_LEN, GFP_KERNEL);
-	if (!smid_pl)
+	smid2_pl = kmalloc(MLXSW_REG_SMID2_LEN, GFP_KERNEL);
+	if (!smid2_pl)
 		return -ENOMEM;
 
-	mlxsw_reg_smid_pack(smid_pl, mid_idx, mlxsw_sp_port->local_port, add);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid), smid_pl);
-	kfree(smid_pl);
+	mlxsw_reg_smid2_pack(smid2_pl, mid_idx, mlxsw_sp_port->local_port, add);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smid2), smid2_pl);
+	kfree(smid2_pl);
 	return err;
 }
 
-- 
2.31.1

