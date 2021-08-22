Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07B803F3F11
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 13:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbhHVLjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 07:39:17 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59343 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233491AbhHVLjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 07:39:13 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 84EF95C00B5;
        Sun, 22 Aug 2021 07:38:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 22 Aug 2021 07:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=wPlt8VctMj8ndjFBGcNht1rqyHQN+hy0x+OU2VQBZb0=; b=gjHthq//
        HtF5j8Bbty44uK4T/ej6ArfhiVZqBuNIViBOWb+H4JeM1HEkcBqoacJ7L1ew6O52
        +fpja4D+iXYNewKm/pysDriGj0TPzQxGFccXRg1gkaXqwCKLJwMwDvs1sNQGmolj
        DmPbPm2IMr/gKBdsrWcHUWU38cirCI9mdVUuoyBCw0dyM/4SUMSLFjdQaNp/jwCK
        dIWpm5mhWkrfxc/Og34dwzfjxrFcHOo6bxhESgNiq/8xKWn2eHYsOioiG1SCDpeD
        4p3YUzlUy2FILCzwcqMj2jPnm2mq/8W9BbJUFEapJa6XAS5Q7gQ8kQY+Vd0G6d3b
        O8OGYuFb6mR2HA==
X-ME-Sender: <xms:ODciYdp6dkcdBHjsWE2Sj3ukte4WSzzZKmHFh3hKoUybI0FvDSTcjw>
    <xme:ODciYfpGwHT3x9lqD1ryQ-KMSyK_zYTDZoyh9xqZgu7ixmeHU5nq3GDvOx7aOmeL1
    OX4wpDsOBGWK5k>
X-ME-Received: <xmr:ODciYaMse6cJbKIwyKMbbdoNF8GFD4yNQQTuNryTS2uBTyxzEWp20_AFbEJSSal7olr1UZdz2HE6jo-3MQ4wX6OIG6LbfrTPCzR4EN2QAYK90w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtfedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ODciYY7fs74YWtcIi0DJPiSJahF_1d_qjwIPGo9FmFqno61uhul-hA>
    <xmx:ODciYc6Hm0SBnoJpWk-W1y8Q40TEOLjh8NW8vgAIuRuhAkkP3-Vhtw>
    <xmx:ODciYQiDCkn4TEfBz38x7EeTOC3kseqWTlCsQYuQYxuc2NOyM-5VgA>
    <xmx:ODciYX1qgmYJDo70sd-ZeP3KqsqkRqqI7dGaBxWSiO1wY81hE7JLiw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 07:38:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/4] mlxsw: Convert existing consumers to use new API for parsing configuration
Date:   Sun, 22 Aug 2021 14:37:14 +0300
Message-Id: <20210822113716.1440716-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822113716.1440716-1-idosch@idosch.org>
References: <20210822113716.1440716-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Convert VxLAN and PTP modules to increase parsing depth using new API
that was added in the previous patch.

Separate MPRS register's configuration to VxLAN related configuration
and parsing depth configuration. Handle each one using the appropriate
API.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 26 ++++++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |  4 +--
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index b84bb4b65098..c722ac370fb6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -238,10 +238,14 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	struct mlxsw_sp *mlxsw_sp = nve->mlxsw_sp;
 	int err;
 
-	err = __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, config->udp_dport);
+	err = mlxsw_sp_parsing_vxlan_udp_dport_set(mlxsw_sp, config->udp_dport);
 	if (err)
 		return err;
 
+	err = mlxsw_sp_parsing_depth_inc(mlxsw_sp);
+	if (err)
+		goto err_parsing_depth_inc;
+
 	err = mlxsw_sp1_nve_vxlan_config_set(mlxsw_sp, config);
 	if (err)
 		goto err_config_set;
@@ -263,7 +267,9 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 err_rtdp_set:
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
-	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
+	mlxsw_sp_parsing_depth_dec(mlxsw_sp);
+err_parsing_depth_inc:
+	mlxsw_sp_parsing_vxlan_udp_dport_set(mlxsw_sp, 0);
 	return err;
 }
 
@@ -275,7 +281,8 @@ static void mlxsw_sp1_nve_vxlan_fini(struct mlxsw_sp_nve *nve)
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
-	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
+	mlxsw_sp_parsing_depth_dec(mlxsw_sp);
+	mlxsw_sp_parsing_vxlan_udp_dport_set(mlxsw_sp, 0);
 }
 
 static int
@@ -412,10 +419,14 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	struct mlxsw_sp *mlxsw_sp = nve->mlxsw_sp;
 	int err;
 
-	err = __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, config->udp_dport);
+	err = mlxsw_sp_parsing_vxlan_udp_dport_set(mlxsw_sp, config->udp_dport);
 	if (err)
 		return err;
 
+	err = mlxsw_sp_parsing_depth_inc(mlxsw_sp);
+	if (err)
+		goto err_parsing_depth_inc;
+
 	err = mlxsw_sp2_nve_vxlan_config_set(mlxsw_sp, config);
 	if (err)
 		goto err_config_set;
@@ -438,7 +449,9 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 err_rtdp_set:
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
-	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
+	mlxsw_sp_parsing_depth_dec(mlxsw_sp);
+err_parsing_depth_inc:
+	mlxsw_sp_parsing_vxlan_udp_dport_set(mlxsw_sp, 0);
 	return err;
 }
 
@@ -450,7 +463,8 @@ static void mlxsw_sp2_nve_vxlan_fini(struct mlxsw_sp_nve *nve)
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
-	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
+	mlxsw_sp_parsing_depth_dec(mlxsw_sp);
+	mlxsw_sp_parsing_vxlan_udp_dport_set(mlxsw_sp, 0);
 }
 
 const struct mlxsw_sp_nve_ops mlxsw_sp2_nve_vxlan_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index bfef65d1587c..1a180384e7e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -975,14 +975,14 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 
 	if ((ing_types || egr_types) && !(orig_ing_types || orig_egr_types)) {
-		err = mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp);
+		err = mlxsw_sp_parsing_depth_inc(mlxsw_sp);
 		if (err) {
 			netdev_err(mlxsw_sp_port->dev, "Failed to increase parsing depth");
 			return err;
 		}
 	}
 	if (!(ing_types || egr_types) && (orig_ing_types || orig_egr_types))
-		mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp);
+		mlxsw_sp_parsing_depth_dec(mlxsw_sp);
 
 	return mlxsw_sp1_ptp_mtpppc_set(mlxsw_sp_port->mlxsw_sp,
 				       ing_types, egr_types);
-- 
2.31.1

