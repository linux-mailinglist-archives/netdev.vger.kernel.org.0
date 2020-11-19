Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849312B932F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgKSNJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:09:28 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:59123 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbgKSNJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 08:09:27 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C8975ED3;
        Thu, 19 Nov 2020 08:09:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 19 Nov 2020 08:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=I16vN61kiDjRMMQ4cZ/wLyeMr2QSwswmCDLc6gvJs9c=; b=ah3ULHk+
        hlDQX8vMQolecJZFy/PwlBGZIj1zHZodtpFJiz5ep7fFm/YJtJDr3LEkgs7VKeNq
        7nrUHngwjSyN1XUPUC0o1N4Q80TKMGJFxqgyqpxvgsAywQWU+SKYz3alvDgv5Aoo
        i3tlCeFQivCkhud2ghQhVNS4FkVY0lESJFVRccSuZoJW4/FWBTh9xzN11KGaRBzL
        R1dibtQ0MQk/NwrlE5WFoPzH5q9oDtlB7Ucc1bx1DQcz8MqvLox3gmMdv9cFxq5Q
        T/e6kP8G0lfyiaAmgNsXKaLKPjyGv2stQMPFmhHIRC2zXAoceXmuD2gwbshfsyY3
        g0JI1ZUjiFGSNQ==
X-ME-Sender: <xms:hm62X6HHoTNdkcnE7oEZFptHQhtDFo56HtL9ECagoyFr1C3yFa_Wbg>
    <xme:hm62X7XBnkP_CuRiH43Y6h3tuGhptATx8uPphcpC1t-SG1xlmsycgNgu7iQRdk32F
    g-dn_xV-HAIJnY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefjedggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hm62X0Jw3ex_84fPeXU36lqjbElMYqo2vrGDpTBZCL15F--ie_M6yw>
    <xmx:hm62X0GE38oanqRWSkPxMd98_3GkMI8WbZWKfMv7KCb4f2sKGcQbzA>
    <xmx:hm62XwV6LbgufDgYZz7xFuUwcq612r-VDDtPSmypCrkk1qb0yNzZTA>
    <xmx:hm62X3Svwtz2o_tOokW8wuCTkyGD7NK3jzP3MU6yY6UvurQANYLRnQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 612733280067;
        Thu, 19 Nov 2020 08:09:24 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: spectrum_router: Enable resolution of nexthop groups from nexthop objects
Date:   Thu, 19 Nov 2020 15:08:42 +0200
Message-Id: <20201119130848.407918-3-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201119130848.407918-1-idosch@idosch.org>
References: <20201119130848.407918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

If the FIB info (i.e, 'struct fib_info', 'struct fib6_info') uses a
nexthop object, then use the object's identifier to resolve the nexthop
group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 480d47ef9362..ad335d5b8d66 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4648,12 +4648,21 @@ static int mlxsw_sp_nexthop4_group_get(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_nexthop_group *nh_grp;
 
+	if (fi->nh) {
+		nh_grp = mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp,
+							   fi->nh->id);
+		if (WARN_ON_ONCE(!nh_grp))
+			return -EINVAL;
+		goto out;
+	}
+
 	nh_grp = mlxsw_sp_nexthop4_group_lookup(mlxsw_sp, fi);
 	if (!nh_grp) {
 		nh_grp = mlxsw_sp_nexthop4_group_create(mlxsw_sp, fi);
 		if (IS_ERR(nh_grp))
 			return PTR_ERR(nh_grp);
 	}
+out:
 	list_add_tail(&fib_entry->nexthop_group_node, &nh_grp->fib_list);
 	fib_entry->nh_group = nh_grp;
 	return 0;
@@ -4667,6 +4676,12 @@ static void mlxsw_sp_nexthop4_group_put(struct mlxsw_sp *mlxsw_sp,
 	list_del(&fib_entry->nexthop_group_node);
 	if (!list_empty(&nh_grp->fib_list))
 		return;
+
+	if (nh_grp->type == MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ) {
+		mlxsw_sp_nexthop_obj_group_destroy(mlxsw_sp, nh_grp);
+		return;
+	}
+
 	mlxsw_sp_nexthop4_group_destroy(mlxsw_sp, nh_grp);
 }
 
@@ -5957,8 +5972,17 @@ mlxsw_sp_nexthop6_group_destroy(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_nexthop6_group_get(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_fib6_entry *fib6_entry)
 {
+	struct fib6_info *rt = mlxsw_sp_fib6_entry_rt(fib6_entry);
 	struct mlxsw_sp_nexthop_group *nh_grp;
 
+	if (rt->nh) {
+		nh_grp = mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp,
+							   rt->nh->id);
+		if (WARN_ON_ONCE(!nh_grp))
+			return -EINVAL;
+		goto out;
+	}
+
 	nh_grp = mlxsw_sp_nexthop6_group_lookup(mlxsw_sp, fib6_entry);
 	if (!nh_grp) {
 		nh_grp = mlxsw_sp_nexthop6_group_create(mlxsw_sp, fib6_entry);
@@ -5971,6 +5995,7 @@ static int mlxsw_sp_nexthop6_group_get(struct mlxsw_sp *mlxsw_sp,
 	 */
 	__mlxsw_sp_nexthop6_group_offload_refresh(nh_grp, fib6_entry);
 
+out:
 	list_add_tail(&fib6_entry->common.nexthop_group_node,
 		      &nh_grp->fib_list);
 	fib6_entry->common.nh_group = nh_grp;
@@ -5986,6 +6011,12 @@ static void mlxsw_sp_nexthop6_group_put(struct mlxsw_sp *mlxsw_sp,
 	list_del(&fib_entry->nexthop_group_node);
 	if (!list_empty(&nh_grp->fib_list))
 		return;
+
+	if (nh_grp->type == MLXSW_SP_NEXTHOP_GROUP_TYPE_OBJ) {
+		mlxsw_sp_nexthop_obj_group_destroy(mlxsw_sp, nh_grp);
+		return;
+	}
+
 	mlxsw_sp_nexthop6_group_destroy(mlxsw_sp, nh_grp);
 }
 
-- 
2.28.0

