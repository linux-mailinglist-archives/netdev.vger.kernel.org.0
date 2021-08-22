Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142683F3F14
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 13:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhHVLjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 07:39:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37975 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233504AbhHVLjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 07:39:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 25FEF5C0039;
        Sun, 22 Aug 2021 07:38:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 22 Aug 2021 07:38:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bKJmGUTn72Ya7a0B4RipUeoZ4L1QEbjxsdsPh6swsb0=; b=BX9BuJmv
        06aTPbbo/mKwp6muA1Zvx8JJAdbIOPlxmS5bc7vvuvUkD+GGMkFeCw0Bjz++VF8k
        PMiE9GI1AD1l81jxdKqO39qpCTWBk8MrToSCSM4S3Uwtc1r1tYbI1z/NVLzt/Kit
        +sc1aXlKR9qVkAc2LJk+PiqawCb/ix7gXXX8trjnbmjHKGEgW/9lly3tQDFAVVgt
        d+LJ6Nwypz0PnZVwXqlteRA3vgWYl25lVDV2R4xO4yj89nNILY9SBSxANrsOR93q
        EpegAImBS4J5QTIw4kXET71R0pHhUD+VCyhx9FsgpQgIOoyoztPY5hON0/sOvWXa
        Ey0tzUDhgmFFhQ==
X-ME-Sender: <xms:PTciYVJ1_AvsTf9r7Kt9NWZEXSdYnlaNpbKZx7jozfNlA288QbGC_Q>
    <xme:PTciYRK8c3eNgZBuzeQTRqGAZlMK0rYE9Nx32lGRlHd1dkKRoA2QeDeN5OUoULQGU
    P-CFzynY7saRCY>
X-ME-Received: <xmr:PTciYduXN8sDZlekAjISdOR0JuKhXVw8QafqcuV38iF900QzpZhB34Uk1-oLwKs4q-yeKpzXkDIDyAuC7INNpWw3z2PHcaEVdytiRCr15DNo4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtfedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PTciYWbW4aXtWH1rzI97k-8Jxpzw1Ai_IfuU3wvWTmUmg_b1ln16Vg>
    <xmx:PTciYcaxE942bcWHt-CN885aeDMP_C5L9wzu6WvlV-Wp4W2de__4pg>
    <xmx:PTciYaAxiVfM99XMNXH0jB-WJmQpA0kbhRIZ1qwnklJHMN_IF30oNw>
    <xmx:PTciYTVw8Ajbz3fZaVyr_5WXc5zoZ2hozsab1G_dmcOpvLg4zuGxSQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 07:38:35 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/4] mlxsw: spectrum_router: Increase parsing depth for multipath hash
Date:   Sun, 22 Aug 2021 14:37:16 +0300
Message-Id: <20210822113716.1440716-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822113716.1440716-1-idosch@idosch.org>
References: <20210822113716.1440716-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Commit 01848e05f8bb ("mlxsw: spectrum_router: Add support for inner
layer 3 multipath hash policy") and commit daeabf89eb89 ("mlxsw:
spectrum_router: Add support for custom multipath hash policy") added
support for multipath hash policies where the hash is calculated based
on inner packet fields.

For IPv6-in-IPv6 packets, the default parsing depth (96 bytes) is not
enough when these policies are used.

Therefore, for such cases, call the new API to increase / decrease the
parsing depth as necessary. Care is taken to ensure the API is not
called multiple times.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 44 ++++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.h |  1 +
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f69cbb3852d5..19bb3ca0515e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9484,6 +9484,7 @@ struct mlxsw_sp_mp_hash_config {
 	DECLARE_BITMAP(fields, __MLXSW_REG_RECR2_FIELD_CNT);
 	DECLARE_BITMAP(inner_headers, __MLXSW_REG_RECR2_HEADER_CNT);
 	DECLARE_BITMAP(inner_fields, __MLXSW_REG_RECR2_INNER_FIELD_CNT);
+	bool inc_parsing_depth;
 };
 
 #define MLXSW_SP_MP_HASH_HEADER_SET(_headers, _header) \
@@ -9654,6 +9655,7 @@ static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
 		MLXSW_SP_MP_HASH_FIELD_SET(fields, IPV6_FLOW_LABEL);
 		/* Inner */
 		mlxsw_sp_mp_hash_inner_l3(config);
+		config->inc_parsing_depth = true;
 		break;
 	case 3:
 		/* Outer */
@@ -9678,22 +9680,53 @@ static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp,
 			MLXSW_SP_MP_HASH_FIELD_SET(fields, TCP_UDP_DPORT);
 		/* Inner */
 		mlxsw_sp_mp_hash_inner_custom(config, hash_fields);
+		if (hash_fields & FIB_MULTIPATH_HASH_FIELD_INNER_MASK)
+			config->inc_parsing_depth = true;
 		break;
 	}
 }
 
+static int mlxsw_sp_mp_hash_parsing_depth_adjust(struct mlxsw_sp *mlxsw_sp,
+						 bool old_inc_parsing_depth,
+						 bool new_inc_parsing_depth)
+{
+	int err;
+
+	if (!old_inc_parsing_depth && new_inc_parsing_depth) {
+		err = mlxsw_sp_parsing_depth_inc(mlxsw_sp);
+		if (err)
+			return err;
+		mlxsw_sp->router->inc_parsing_depth = true;
+	} else if (old_inc_parsing_depth && !new_inc_parsing_depth) {
+		mlxsw_sp_parsing_depth_dec(mlxsw_sp);
+		mlxsw_sp->router->inc_parsing_depth = false;
+	}
+
+	return 0;
+}
+
 static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 {
+	bool old_inc_parsing_depth, new_inc_parsing_depth;
 	struct mlxsw_sp_mp_hash_config config = {};
 	char recr2_pl[MLXSW_REG_RECR2_LEN];
 	unsigned long bit;
 	u32 seed;
+	int err;
 
 	seed = jhash(mlxsw_sp->base_mac, sizeof(mlxsw_sp->base_mac), 0);
 	mlxsw_reg_recr2_pack(recr2_pl, seed);
 	mlxsw_sp_mp4_hash_init(mlxsw_sp, &config);
 	mlxsw_sp_mp6_hash_init(mlxsw_sp, &config);
 
+	old_inc_parsing_depth = mlxsw_sp->router->inc_parsing_depth;
+	new_inc_parsing_depth = config.inc_parsing_depth;
+	err = mlxsw_sp_mp_hash_parsing_depth_adjust(mlxsw_sp,
+						    old_inc_parsing_depth,
+						    new_inc_parsing_depth);
+	if (err)
+		return err;
+
 	for_each_set_bit(bit, config.headers, __MLXSW_REG_RECR2_HEADER_CNT)
 		mlxsw_reg_recr2_outer_header_enables_set(recr2_pl, bit, 1);
 	for_each_set_bit(bit, config.fields, __MLXSW_REG_RECR2_FIELD_CNT)
@@ -9703,7 +9736,16 @@ static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
 	for_each_set_bit(bit, config.inner_fields, __MLXSW_REG_RECR2_INNER_FIELD_CNT)
 		mlxsw_reg_recr2_inner_header_fields_enable_set(recr2_pl, bit, 1);
 
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(recr2), recr2_pl);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(recr2), recr2_pl);
+	if (err)
+		goto err_reg_write;
+
+	return 0;
+
+err_reg_write:
+	mlxsw_sp_mp_hash_parsing_depth_adjust(mlxsw_sp, new_inc_parsing_depth,
+					      old_inc_parsing_depth);
+	return err;
 }
 #else
 static int mlxsw_sp_mp_hash_init(struct mlxsw_sp *mlxsw_sp)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index c5d7007f9173..25d3eae63501 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -81,6 +81,7 @@ struct mlxsw_sp_router {
 	size_t adj_grp_size_ranges_count;
 	struct delayed_work nh_grp_activity_dw;
 	struct list_head nh_res_grp_list;
+	bool inc_parsing_depth;
 };
 
 struct mlxsw_sp_fib_entry_priv {
-- 
2.31.1

