Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26EF464957
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 09:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347868AbhLAIRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 03:17:02 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48189 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347881AbhLAIQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 03:16:57 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C2C45C011A;
        Wed,  1 Dec 2021 03:13:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 01 Dec 2021 03:13:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=tIVPbnqO6jmC+Qv/SiwO6YrUE9E//eDGsIAwScngixU=; b=UlAMV3k6
        aj0w5s9LCHcwM+LsYteNf6nIM3pggsEkerAkH6dPH0PW9hk8LbdOSnw9f8lBvfx9
        j46hurvlTJRPcLVhg4zSfaSSvDvqpEhunYkx/4gXX1RjrDE5a/nKaPge4V8UUgEJ
        aLxrMDTmx1fiEv2wOOQHf1ToKYq5aHChVScNgC4yg9SPxCcXi9zOW2yxEI2Jzs9B
        WORMpMqStXoyj9PFNW+SVbxAxcTIPmIm4aoiNt28BBYl6T2NGHfTwaADAXFL4vHg
        rSUTRUDZpGEuxdUZZlNYaD1tXm2p+asvUDWurWUoZ3NCN+xvfwOB7zo067yJO2/r
        hoIkZB3ySHLgxg==
X-ME-Sender: <xms:sC6nYR51ugUiWIDeO4KHTvTolbI7RY9LxruF5Q35mhDbwRmNDDUDTw>
    <xme:sC6nYe7tOjmPy9iLsrnP09k-UK7FEGZe52IWIMA0mlrpY17XqyP-zsmkXuOeUfogu
    rnuvJ4rg4CrzJk>
X-ME-Received: <xmr:sC6nYYd6owLBvny6NeDyZlPP3W3LBYFazkagsSssuLlfWYUbl9WJxJYFsHUw6TTiFk3u1XvL7tl4gbtgUHnqYweDaSQhU0mYwSu0ZkmtdHHB4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdduudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepfeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:sC6nYaLhB0t3gjiSmtWdiqHnFh0keR4XWbU9pNbFnanM7bURvog9oQ>
    <xmx:sC6nYVJirsD4ecDDA-kZUrRm3M066Lrdo6AUSDyWE1_kDteAc1AOkw>
    <xmx:sC6nYTwlFPdzfoNhVHTOK6HIKWFR8u8pD3SJmeM0v-hdN-lHu2qYyg>
    <xmx:sS6nYSGTYoKh76cuVISz58BCARFjc-Dyp7Hi3oUuWWBY9b7dt8k6kQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Dec 2021 03:13:35 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: Add support for more than 256 ports in SBSR register
Date:   Wed,  1 Dec 2021 10:12:38 +0200
Message-Id: <20211201081240.3767366-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
References: <20211201081240.3767366-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add 'port_page' field in SBSR to be able to query occupancy of more than
256 ports. The field determines the range of the ports specified in the
'ingress_port_mask' and 'egress_port_mask' bit masks:
>From '256 * port_page' to '256 * port_page + 255'.

For each local port, the appropriate port page is used. A query is never
performed for a port range that spans multiple port pages.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 10 +++++++
 .../mellanox/mlxsw/spectrum_buffers.c         | 26 +++++++++++++++----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 1e182069ba91..4c26188d541c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -12255,6 +12255,16 @@ MLXSW_REG_DEFINE(sbsr, MLXSW_REG_SBSR_ID, MLXSW_REG_SBSR_LEN);
  */
 MLXSW_ITEM32(reg, sbsr, clr, 0x00, 31, 1);
 
+#define MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE 256
+
+/* reg_sbsr_port_page
+ * Determines the range of the ports specified in the 'ingress_port_mask'
+ * and 'egress_port_mask' bit masks.
+ * {ingress,egress}_port_mask[x] is (256 * port_page) + x
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, sbsr, port_page, 0x04, 0, 4);
+
 /* reg_sbsr_ingress_port_mask
  * Bit vector for all ingress network ports.
  * Indicates which of the ports (for which the relevant bit is set)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index ad250b301d7e..98f26f596e30 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -1582,13 +1582,12 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 			     unsigned int sb_index)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	u16 local_port, local_port_1, last_local_port;
 	struct mlxsw_sp_sb_sr_occ_query_cb_ctx cb_ctx;
+	u8 masked_count, current_page = 0;
 	unsigned long cb_priv = 0;
 	LIST_HEAD(bulk_list);
 	char *sbsr_pl;
-	u8 masked_count;
-	u16 local_port_1;
-	u16 local_port;
 	int i;
 	int err;
 	int err2;
@@ -1602,6 +1601,10 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	local_port_1 = local_port;
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, false);
+	mlxsw_reg_sbsr_port_page_set(sbsr_pl, current_page);
+	last_local_port = current_page * MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE +
+			  MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE - 1;
+
 	for (i = 0; i < MLXSW_SP_SB_ING_TC_COUNT; i++)
 		mlxsw_reg_sbsr_pg_buff_mask_set(sbsr_pl, i, 1);
 	for (i = 0; i < MLXSW_SP_SB_EG_TC_COUNT; i++)
@@ -1609,6 +1612,10 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 	for (; local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
 		if (!mlxsw_sp->ports[local_port])
 			continue;
+		if (local_port > last_local_port) {
+			current_page++;
+			goto do_query;
+		}
 		if (local_port != MLXSW_PORT_CPU_PORT) {
 			/* Ingress quotas are not supported for the CPU port */
 			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
@@ -1651,10 +1658,11 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 			      unsigned int sb_index)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	u16 local_port, last_local_port;
 	LIST_HEAD(bulk_list);
-	char *sbsr_pl;
 	unsigned int masked_count;
-	u16 local_port;
+	u8 current_page = 0;
+	char *sbsr_pl;
 	int i;
 	int err;
 	int err2;
@@ -1667,6 +1675,10 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 next_batch:
 	masked_count = 0;
 	mlxsw_reg_sbsr_pack(sbsr_pl, true);
+	mlxsw_reg_sbsr_port_page_set(sbsr_pl, current_page);
+	last_local_port = current_page * MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE +
+			  MLXSW_REG_SBSR_NUM_PORTS_IN_PAGE - 1;
+
 	for (i = 0; i < MLXSW_SP_SB_ING_TC_COUNT; i++)
 		mlxsw_reg_sbsr_pg_buff_mask_set(sbsr_pl, i, 1);
 	for (i = 0; i < MLXSW_SP_SB_EG_TC_COUNT; i++)
@@ -1674,6 +1686,10 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
 	for (; local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
 		if (!mlxsw_sp->ports[local_port])
 			continue;
+		if (local_port > last_local_port) {
+			current_page++;
+			goto do_query;
+		}
 		if (local_port != MLXSW_PORT_CPU_PORT) {
 			/* Ingress quotas are not supported for the CPU port */
 			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
-- 
2.31.1

