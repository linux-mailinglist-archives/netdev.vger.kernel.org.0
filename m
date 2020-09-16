Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B85526BD52
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgIPGgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:33 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:52087 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgIPGgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 91B3F7A0;
        Wed, 16 Sep 2020 02:36:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=bTSa1qHH71T44xwLQ1bMYQKzGHp0MHN5JfF2Yiq3oj8=; b=cILVxYad
        2skzdsvr28A6KdeR6dGrN1asRVIaepjPd038oFtGDoorFEw2HffI0w47FSBBDmVI
        EANtecIZS586Zo6l+jQIToIFSKSgUCaxyclIUHDSmaoXlZ8n1tiZs92ehXVDFzXi
        YwTh8TEYHkJn6zvrCYKRZkIQ/YvhVlBJUcszc52cHFDknNv5x948ZFRJWKSIQcke
        RucHFz4oKWypav4Yzgg6TbwoSLg7O20d83r95wyr/u02Yo9vezpybji+j9nOy9dt
        ry661XhcTGxkkrKA4VVDyye3C3/YQjohsiL0GnbAMsL4KP+WsaqJveAgKEvaItvr
        Qj1EWvsKOYtXkg==
X-ME-Sender: <xms:X7JhX3Q08mlZTGwfa2BdSd1jiYrUk0E3jxKMj-nv16GTLlNOiALcvg>
    <xme:X7JhX4ypJvJF-eEGxKfmvp0qMnpeh0sbSTD_c0v0SlNtzx7yhaOgar9lB0LYNi8rI
    1xnZddALMGcPRo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:X7JhX81QOoMRiwM7vlpH49Rkh2IU2fYM1TDvWb1GfOkgt9MnkWJ9bg>
    <xmx:X7JhX3ABTMxhUtdbdzhhW9hAX-PK-VQyEwr2VyNnLsU1urDkYJOS3Q>
    <xmx:X7JhXwgBK_W2_g3WU-eafKzg4_yl8WzSLKRyrvqeLLhGAzCHgvkjVw>
    <xmx:X7JhX5u_LHDEIpCGngx2GRvJzsmdhlvGnlPDgCQe04cvHQqFGL7-dg>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A2FE3064682;
        Wed, 16 Sep 2020 02:36:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/15] mlxsw: spectrum_buffers: Introduce shared buffer ops
Date:   Wed, 16 Sep 2020 09:35:27 +0300
Message-Id: <20200916063528.116624-15-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916063528.116624-1-idosch@idosch.org>
References: <20200916063528.116624-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The size of the internal buffer is currently calculated in the SPAN module.
Logically it belongs to the spectrum_buffers module, where it should be
moved. However, that being a chip-specific operation, it needs dynamic
dispatch. There currently is a chip-specific structure for description of
shared buffer values, struct mlxsw_sp_sb_vals. However placing ops into
this structure would be confusing. Therefore introduce a new per-chip
structure, currently empty, and initialize the ops pointer as appropriate.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |  3 +++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h       |  6 ++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c   | 12 ++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 2c4cc985e1f8..9d5a6f8d7438 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2697,6 +2697,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->mac_mask = mlxsw_sp1_mac_mask;
 	mlxsw_sp->rif_ops_arr = mlxsw_sp1_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp1_sb_vals;
+	mlxsw_sp->sb_ops = &mlxsw_sp1_sb_ops;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp1_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp1_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp1_span_ops;
@@ -2725,6 +2726,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
 	mlxsw_sp->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
+	mlxsw_sp->sb_ops = &mlxsw_sp2_sb_ops;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
@@ -2751,6 +2753,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
 	mlxsw_sp->rif_ops_arr = mlxsw_sp2_rif_ops_arr;
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
+	mlxsw_sp->sb_ops = &mlxsw_sp3_sb_ops;
 	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
 	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
 	mlxsw_sp->span_ops = &mlxsw_sp3_span_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 061f58e09b63..b402a73acb41 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -125,6 +125,7 @@ struct mlxsw_sp_mr_tcam_ops;
 struct mlxsw_sp_acl_rulei_ops;
 struct mlxsw_sp_acl_tcam_ops;
 struct mlxsw_sp_nve_ops;
+struct mlxsw_sp_sb_ops;
 struct mlxsw_sp_sb_vals;
 struct mlxsw_sp_port_type_speed_ops;
 struct mlxsw_sp_ptp_state;
@@ -171,6 +172,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_nve_ops **nve_ops_arr;
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
 	const struct mlxsw_sp_sb_vals *sb_vals;
+	const struct mlxsw_sp_sb_ops *sb_ops;
 	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
 	const struct mlxsw_sp_ptp_ops *ptp_ops;
 	const struct mlxsw_sp_span_ops *span_ops;
@@ -514,6 +516,10 @@ int mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
 extern const struct mlxsw_sp_sb_vals mlxsw_sp1_sb_vals;
 extern const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals;
 
+extern const struct mlxsw_sp_sb_ops mlxsw_sp1_sb_ops;
+extern const struct mlxsw_sp_sb_ops mlxsw_sp2_sb_ops;
+extern const struct mlxsw_sp_sb_ops mlxsw_sp3_sb_ops;
+
 /* spectrum_switchdev.c */
 int mlxsw_sp_switchdev_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_switchdev_fini(struct mlxsw_sp *mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 2f1d09a40058..cdd0f3dac68b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -121,6 +121,9 @@ struct mlxsw_sp_sb_vals {
 	unsigned int cms_cpu_count;
 };
 
+struct mlxsw_sp_sb_ops {
+};
+
 u32 mlxsw_sp_cells_bytes(const struct mlxsw_sp *mlxsw_sp, u32 cells)
 {
 	return mlxsw_sp->sb->cell_size * cells;
@@ -1101,6 +1104,15 @@ const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals = {
 	.cms_cpu_count = ARRAY_SIZE(mlxsw_sp_cpu_port_sb_cms),
 };
 
+const struct mlxsw_sp_sb_ops mlxsw_sp1_sb_ops = {
+};
+
+const struct mlxsw_sp_sb_ops mlxsw_sp2_sb_ops = {
+};
+
+const struct mlxsw_sp_sb_ops mlxsw_sp3_sb_ops = {
+};
+
 int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp)
 {
 	u32 max_headroom_size;
-- 
2.26.2

