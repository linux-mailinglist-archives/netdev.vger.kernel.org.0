Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03A926BD4E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgIPGgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:36 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:40803 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgIPGgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:14 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id D8154874;
        Wed, 16 Sep 2020 02:36:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Sep 2020 02:36:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=FJsRuH/fNiyrq22+RR2hgtZbVCZ9IURcNGuveui+AVc=; b=ZkWzyGH0
        ZUudaYAU1DZTPV4cp+TsmEt0WjLUdOT8w5vBIyWfSN4sy3+DbI0ZRfKPG/0LymA4
        M++0krriFNtj8AfeAoWP2tjfL6R9H/qXcgvztID/irHV3zsZB477995ctLD7zTGj
        VM79mO+Nkj9TzLNNbzMUxSGemuBBYH9twAE0txdozP6TKyuG5z5rWUoBqhh2vqkC
        4uW68PLkuqPuVcNh3UDCVNo4C72OiMcO35K1n0fvcYMnPSdZ757rZmYMI9FxABEP
        DxenPyLlhcp0+Hsh1AVwyzxsiDa5nzhKI7PHpHiXXI18hhXSEdjNMOi6FNEM+/8O
        X2EZXg3dVU5U1w==
X-ME-Sender: <xms:W7JhX5bM08RoQU8tV5ocFiChDgdTCmUvfQV3-stDdL09H5dSedkzxw>
    <xme:W7JhXwb8Og4CCn71a8UQ9gJhaCOCgeItslDjvi_ql7bzD3NSEw7fYhzBYAGY2ditR
    JNT8Vw7YhZZRJI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrtddugddutdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:W7JhX78Kc44lqqi25hZRTDtYeAmY_sN4nnLFznIDciLU-juMz3IHoQ>
    <xmx:W7JhX3qZmtEFd7SkBiNv18y0P1eqYsoBf6Xh1CNYAHhpYeTuhJob6Q>
    <xmx:W7JhX0q5cqmcOlNTKNuxg_cSZkNcbNMeiSnUf7D__EurIN_DoyprqQ>
    <xmx:W7JhX_Woww2finUxvtQKtodNr31zVZY8MX9L7ELXY3P6ysFgdQWf6w>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04DD73064680;
        Wed, 16 Sep 2020 02:36:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/15] mlxsw: spectrum_buffers: Inline mlxsw_sp_sb_max_headroom_cells()
Date:   Wed, 16 Sep 2020 09:35:25 +0300
Message-Id: <20200916063528.116624-13-idosch@idosch.org>
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

This function is now only used from the buffers module, and is a trivial
field reference. Just inline it and drop the related artifacts.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h         | 1 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 06008a17ae64..061f58e09b63 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -504,7 +504,6 @@ int mlxsw_sp_sb_occ_tc_port_bind_get(struct mlxsw_core_port *mlxsw_core_port,
 				     u32 *p_cur, u32 *p_max);
 u32 mlxsw_sp_cells_bytes(const struct mlxsw_sp *mlxsw_sp, u32 cells);
 u32 mlxsw_sp_bytes_cells(const struct mlxsw_sp *mlxsw_sp, u32 bytes);
-u32 mlxsw_sp_sb_max_headroom_cells(const struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_hdroom_prios_reset_buf_idx(struct mlxsw_sp_hdroom *hdroom);
 void mlxsw_sp_hdroom_bufs_reset_lossiness(struct mlxsw_sp_hdroom *hdroom);
 void mlxsw_sp_hdroom_bufs_reset_sizes(struct mlxsw_sp_port *mlxsw_sp_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 1f44add89a6c..3fdca44c5c56 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -131,11 +131,6 @@ u32 mlxsw_sp_bytes_cells(const struct mlxsw_sp *mlxsw_sp, u32 bytes)
 	return DIV_ROUND_UP(bytes, mlxsw_sp->sb->cell_size);
 }
 
-u32 mlxsw_sp_sb_max_headroom_cells(const struct mlxsw_sp *mlxsw_sp)
-{
-	return mlxsw_sp->sb->max_headroom_cells;
-}
-
 static struct mlxsw_sp_sb_pr *mlxsw_sp_sb_pr_get(struct mlxsw_sp *mlxsw_sp,
 						 u16 pool_index)
 {
@@ -488,14 +483,12 @@ static bool mlxsw_sp_hdroom_bufs_fit(struct mlxsw_sp *mlxsw_sp,
 				     const struct mlxsw_sp_hdroom *hdroom)
 {
 	u32 taken_headroom_cells = 0;
-	u32 max_headroom_cells;
 	int i;
 
 	for (i = 0; i < MLXSW_SP_PB_COUNT; i++)
 		taken_headroom_cells += hdroom->bufs.buf[i].size_cells;
 
-	max_headroom_cells = mlxsw_sp_sb_max_headroom_cells(mlxsw_sp);
-	return taken_headroom_cells <= max_headroom_cells;
+	return taken_headroom_cells <= mlxsw_sp->sb->max_headroom_cells;
 }
 
 static int __mlxsw_sp_hdroom_configure(struct mlxsw_sp_port *mlxsw_sp_port,
-- 
2.26.2

