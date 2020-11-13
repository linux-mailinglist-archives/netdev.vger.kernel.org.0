Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6A32B1F8B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgKMQGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:45 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37313 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726884AbgKMQGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:42 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DFBB85C0193;
        Fri, 13 Nov 2020 11:06:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=a1mYGK3QcmjdFiMjAx2jzR2caSqqERjnHsLoRmSkyn4=; b=gG/BXMNL
        Qi2oIZHR2xzAcsuiSE6Rf9rWSZ6y44bsSQPi4mGvF2Zxg7aCUfviheMNdBgVQI8K
        IULZewg/INiF0BJk2kmldNOPRV8o3U4bk6ySS+DzU0KTJtd2tWK8vKrs0fTpHfn8
        yvhRjACaE6t1hebB+QkvAZnccaJzbMKe10tgRCRLyxlzLkWzzoUP/6lWtDtTawh5
        Vs6qykmMCRhztpBp6QRgbfPzOPAKolvtWt2PE2u2sXH0mRciFiKi1deKSd8C5FdP
        WFMtpGN1IDrjWQ6Qt48pB5wvnVScyRwUGlgnJNDP1n0vxRV2vA+tyuNYgZj5skIT
        j/wPQc5uzfGwyQ==
X-ME-Sender: <xms:Ea-uX5pXQNyEAmyjMYVt-qXyMyq82HBz_W3Hr4A4S917urxS49bpBg>
    <xme:Ea-uX7rEBywpWxipTC1KJemItozI4KawrUqbMBC3P7lMPZttkiq1LQOusE1Y-f96a
    WabTrHx0nhwfIY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Ea-uX2M35lhIi7xA2MGh1NP0TXXWl9rJpqgNuYbTt4uiSKjoCHz8tA>
    <xmx:Ea-uX07z790Sh2Pn27xMbFVjBctm-Iv2_mez3ZOQoFyzB5ncp6TBuw>
    <xmx:Ea-uX45w7j9yo7CMCwTXnGKluEIeXTbL1Y1_393PmXPr5kPJoC77CA>
    <xmx:Ea-uX2lTaGzNW3sj0VjY0_CMGrqCoQRrwXqUFGniCvnJKYWcGOPT8A>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB0F33280059;
        Fri, 13 Nov 2020 11:06:39 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/15] mlxsw: spectrum_router: Store FIB info in route
Date:   Fri, 13 Nov 2020 18:05:49 +0200
Message-Id: <20201113160559.22148-6-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When needed, IPv4 routes fetch the FIB info (i.e., 'struct fib_info')
from their associated nexthop group. This will not work when the nexthop
group represents a nexthop object (i.e., 'struct nexthop'), as it will
only have access to the nexthop's identifier.

Instead, store the FIB info in the route itself.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c   | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 462ddab11c07..87acb2bbb6fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -431,6 +431,7 @@ struct mlxsw_sp_fib_entry {
 
 struct mlxsw_sp_fib4_entry {
 	struct mlxsw_sp_fib_entry common;
+	struct fib_info *fi;
 	u32 tb_id;
 	u32 prio;
 	u8 tos;
@@ -4240,7 +4241,6 @@ static void
 mlxsw_sp_fib4_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct fib_info *fi = mlxsw_sp_nexthop4_group_fi(fib_entry->nh_group);
 	u32 *p_dst = (u32 *) fib_entry->fib_node->key.addr;
 	int dst_len = fib_entry->fib_node->key.prefix_len;
 	struct mlxsw_sp_fib4_entry *fib4_entry;
@@ -4250,7 +4250,7 @@ mlxsw_sp_fib4_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 	should_offload = mlxsw_sp_fib_entry_should_offload(fib_entry);
 	fib4_entry = container_of(fib_entry, struct mlxsw_sp_fib4_entry,
 				  common);
-	fri.fi = fi;
+	fri.fi = fib4_entry->fi;
 	fri.tb_id = fib4_entry->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
@@ -4265,7 +4265,6 @@ static void
 mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_fib_entry *fib_entry)
 {
-	struct fib_info *fi = mlxsw_sp_nexthop4_group_fi(fib_entry->nh_group);
 	u32 *p_dst = (u32 *) fib_entry->fib_node->key.addr;
 	int dst_len = fib_entry->fib_node->key.prefix_len;
 	struct mlxsw_sp_fib4_entry *fib4_entry;
@@ -4273,7 +4272,7 @@ mlxsw_sp_fib4_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 
 	fib4_entry = container_of(fib_entry, struct mlxsw_sp_fib4_entry,
 				  common);
-	fri.fi = fi;
+	fri.fi = fib4_entry->fi;
 	fri.tb_id = fib4_entry->tb_id;
 	fri.dst = cpu_to_be32(*p_dst);
 	fri.dst_len = dst_len;
@@ -4831,6 +4830,8 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_nexthop4_group_get;
 
+	fib4_entry->fi = fen_info->fi;
+	fib_info_hold(fib4_entry->fi);
 	fib4_entry->prio = fen_info->fi->fib_priority;
 	fib4_entry->tb_id = fen_info->tb_id;
 	fib4_entry->type = fen_info->type;
@@ -4852,6 +4853,7 @@ mlxsw_sp_fib4_entry_create(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_fib4_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib4_entry *fib4_entry)
 {
+	fib_info_put(fib4_entry->fi);
 	mlxsw_sp_nexthop4_group_put(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib4_entry_type_unset(mlxsw_sp, &fib4_entry->common);
 	mlxsw_sp_fib_entry_priv_put(fib4_entry->common.priv);
@@ -4883,8 +4885,7 @@ mlxsw_sp_fib4_entry_lookup(struct mlxsw_sp *mlxsw_sp,
 	if (fib4_entry->tb_id == fen_info->tb_id &&
 	    fib4_entry->tos == fen_info->tos &&
 	    fib4_entry->type == fen_info->type &&
-	    mlxsw_sp_nexthop4_group_fi(fib4_entry->common.nh_group) ==
-	    fen_info->fi)
+	    fib4_entry->fi == fen_info->fi)
 		return fib4_entry;
 
 	return NULL;
-- 
2.28.0

