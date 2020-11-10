Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D432AD2D0
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731421AbgKJJuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:44 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54819 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731031AbgKJJuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:39 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id EF56FDC3;
        Tue, 10 Nov 2020 04:50:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=8VjLMR/h/rMMGBEr6ukSAy3MYys0BF/k2gczYiXJgwg=; b=laiz1nFc
        mebgoh6mV5lwBZTWj4Oygh8S7PbJwz9s4/Oysj5PPuZzF6R71FQs9DdaGyyDOQLb
        1+90rMmPPjTLsNes7ohVSGYftevna8niNIp7lqpTDb6kjGQuZlW4rg6pM4HnyTOT
        B/jnKR23dI219AQLobucYpv42+OibXQ1ku5fAzi2BqturjJsg2y7DXY1Qb0dx8eu
        2f+DmyUwaoyBGMJR6j3MvaKfdqZ3Kx75b5RdufFUbGdJOLKhjgpdl8/Yu/1QvxCO
        ISlNkgm66mPTlLr0ExGH61ShiQUyoe0666Ltt4YHVAHHk4CRBVFzJraBizFi55jv
        kTP84F6fejOuJA==
X-ME-Sender: <xms:bWKqX9WyybdubUcljMREOBips4q7tiysDRotQX2MxGWZV7PzeCWMyg>
    <xme:bWKqX9me3lHsyWpaQcy8iXMgzPKfo8RtKhj_JHpfRBqx7apCbuCulZ3pVq7l52ihr
    1OAWBY4NvjXAxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedufeenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:bWKqX5bw7HNqdBVpBLXUPL_Ls80RZX0ynS08zaxqhC5WMgUaNtOZtA>
    <xmx:bWKqXwWgNF9G9E2kdPYo2cTMbYiW_dPuMXlJJ-oTp3JJCmOE9cCOww>
    <xmx:bWKqX3lkDOhh2mF-1MLd6HTkEkGr_oZFCPt1kQRejAmuTKjym081eQ>
    <xmx:bWKqX8wnSAV3vq5s3btweKf7lKLTIStQVVqbSndrPvpWKuHD-fO4Bw>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 569C2328006D;
        Tue, 10 Nov 2020 04:50:36 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 15/15] mlxsw: spectrum_router: Introduce FIB entry update op
Date:   Tue, 10 Nov 2020 11:49:00 +0200
Message-Id: <20201110094900.1920158-16-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Follow-up patchset introducing XMDR implementation is going to need
to distinguish write and update ops. Therefore introduce "update op"
and call "write op" only when new FIB entry is inserted.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c    | 16 +++++++++++-----
 .../ethernet/mellanox/mlxsw/spectrum_router.h    |  1 +
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ef95d126d29a..e692e5a39f6c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4350,6 +4350,7 @@ mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 {
 	switch (op) {
 	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
+	case MLXSW_SP_FIB_ENTRY_OP_UPDATE:
 		mlxsw_sp_fib_entry_hw_flags_set(mlxsw_sp, fib_entry);
 		break;
 	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
@@ -4381,6 +4382,7 @@ mlxsw_sp_router_ll_basic_fib_entry_pack(struct mlxsw_sp_fib_entry_op_ctx *op_ctx
 
 	switch (op) {
 	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
+	case MLXSW_SP_FIB_ENTRY_OP_UPDATE:
 		ralue_op = MLXSW_REG_RALUE_OP_WRITE_WRITE;
 		break;
 	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
@@ -4699,10 +4701,12 @@ static int mlxsw_sp_fib_entry_op(struct mlxsw_sp *mlxsw_sp,
 
 static int __mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_fib_entry_op_ctx *op_ctx,
-				       struct mlxsw_sp_fib_entry *fib_entry)
+				       struct mlxsw_sp_fib_entry *fib_entry,
+				       bool is_new)
 {
 	return mlxsw_sp_fib_entry_op(mlxsw_sp, op_ctx, fib_entry,
-				     MLXSW_SP_FIB_ENTRY_OP_WRITE);
+				     is_new ? MLXSW_SP_FIB_ENTRY_OP_WRITE :
+					      MLXSW_SP_FIB_ENTRY_OP_UPDATE);
 }
 
 static int mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
@@ -4711,7 +4715,7 @@ static int mlxsw_sp_fib_entry_update(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_fib_entry_op_ctx *op_ctx = mlxsw_sp->router->ll_op_ctx;
 
 	mlxsw_sp_fib_entry_op_ctx_clear(op_ctx);
-	return __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry);
+	return __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry, false);
 }
 
 static int mlxsw_sp_fib_entry_del(struct mlxsw_sp *mlxsw_sp,
@@ -5091,11 +5095,12 @@ static int mlxsw_sp_fib_node_entry_link(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib_entry *fib_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib_entry->fib_node;
+	bool is_new = !fib_node->fib_entry;
 	int err;
 
 	fib_node->fib_entry = fib_entry;
 
-	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry);
+	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, fib_entry, is_new);
 	if (err)
 		goto err_fib_entry_update;
 
@@ -5509,7 +5514,8 @@ static int mlxsw_sp_nexthop6_group_update(struct mlxsw_sp *mlxsw_sp,
 	 * currently associated with it in the device's table is that
 	 * of the old group. Start using the new one instead.
 	 */
-	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx, &fib6_entry->common);
+	err = __mlxsw_sp_fib_entry_update(mlxsw_sp, op_ctx,
+					  &fib6_entry->common, false);
 	if (err)
 		goto err_fib_entry_update;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index ed651b4200cb..8230f6ff02ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -84,6 +84,7 @@ struct mlxsw_sp_fib_entry_priv {
 
 enum mlxsw_sp_fib_entry_op {
 	MLXSW_SP_FIB_ENTRY_OP_WRITE,
+	MLXSW_SP_FIB_ENTRY_OP_UPDATE,
 	MLXSW_SP_FIB_ENTRY_OP_DELETE,
 };
 
-- 
2.26.2

