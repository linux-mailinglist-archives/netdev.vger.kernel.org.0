Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C30D3482AD
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238171AbhCXUPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:17 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49171 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237807AbhCXUOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D844E5C00CA;
        Wed, 24 Mar 2021 16:14:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:14:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=r99IXa1yok/LH1t3meSnF2g4Mn4igYvm6fPPmkdURTo=; b=ls04/+vl
        jsuPA7BebujbJdRzFnAWh68VgIug7Xq7ZQtXN4denf5ry0NvcU+wSZfUM349NVTO
        I2wPLiK9dXYlxKtQ6IG0kugTa3q2oJnvcdDBUC+cLR3+XSeJgOs8tj3gEqhLKZS3
        CKhM6fx92BP5yx5grgRDGhTwx/4T4Ur1yqYkOSMXiBAHilfYQ9z2wEF/gWoCbRg3
        CqrxE3mm63ApJoYa5Ff2W+hWtBSFUy6d8BHGrZDH3tKBv8KWZa3SKCZkmQy7yg/b
        n8D/qJENdiqgU9K3+UFhBUTOHY9uke4u7k8bOX2w+d0Jpd7WcodNs5Zy5AYh+HM0
        5qVkKf2s0+gLyQ==
X-ME-Sender: <xms:vp1bYPrfohjhqDBNHbz7RJdtmyEDjOA6i-zB_dHUVIUe9IIPHhWmpA>
    <xme:vp1bYJoVAmG35jiXtCXjy3XNlpYqZWtmojKND1rgdkcRucHxs2ZmCiBMcbicsFYhf
    z9w66ulL-MEsNc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:vp1bYMPmo5qAc3GYLZ4tDUKThzujMF1P3Jk3tZpBl279fIj4D8SKFg>
    <xmx:vp1bYC7fwzMU2Ik5xyFL49rxShp6FYVv8OLrr4kipF-wUyVTArna1Q>
    <xmx:vp1bYO4eleO8kXwAok7UdfBKDo--jeqpYVa9fjbz1QEtii6QDKWHKA>
    <xmx:vp1bYJ0KiL-0vBvW9BNhFq2zyBKqtDCnWTwixc1YT-OZsN2oYfSXvw>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE8A424041F;
        Wed, 24 Mar 2021 16:14:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum_router: Update hardware flags on nexthop buckets
Date:   Wed, 24 Mar 2021 22:14:19 +0200
Message-Id: <20210324201424.157387-6-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

So far, mlxsw only updated hardware flags ('offload' / 'trap') on
nexthop objects. For resilient nexthop groups, these flags need to be
updated on individual nexthop buckets as well.

Update these flags whenever updating the flags of the encapsulating
nexthop object and whenever a nexthop bucket is replaced.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d6e91f1f48cc..862c8667813b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3762,10 +3762,30 @@ mlxsw_sp_nexthop6_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 		__mlxsw_sp_nexthop6_group_offload_refresh(nh_grp, fib6_entry);
 }
 
+static void
+mlxsw_sp_nexthop_bucket_offload_refresh(struct mlxsw_sp *mlxsw_sp,
+					const struct mlxsw_sp_nexthop *nh,
+					u16 bucket_index)
+{
+	struct mlxsw_sp_nexthop_group *nh_grp = nh->nhgi->nh_grp;
+	bool offload = false, trap = false;
+
+	if (nh->offloaded) {
+		if (nh->action == MLXSW_SP_NEXTHOP_ACTION_TRAP)
+			trap = true;
+		else
+			offload = true;
+	}
+	nexthop_bucket_set_hw_flags(mlxsw_sp_net(mlxsw_sp), nh_grp->obj.id,
+				    bucket_index, offload, trap);
+}
+
 static void
 mlxsw_sp_nexthop_obj_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 					   struct mlxsw_sp_nexthop_group *nh_grp)
 {
+	int i;
+
 	/* Do not update the flags if the nexthop group is being destroyed
 	 * since:
 	 * 1. The nexthop objects is being deleted, in which case the flags are
@@ -3779,6 +3799,18 @@ mlxsw_sp_nexthop_obj_group_offload_refresh(struct mlxsw_sp *mlxsw_sp,
 
 	nexthop_set_hw_flags(mlxsw_sp_net(mlxsw_sp), nh_grp->obj.id,
 			     nh_grp->nhgi->adj_index_valid, false);
+
+	/* Update flags of individual nexthop buckets in case of a resilient
+	 * nexthop group.
+	 */
+	if (!nh_grp->nhgi->is_resilient)
+		return;
+
+	for (i = 0; i < nh_grp->nhgi->count; i++) {
+		struct mlxsw_sp_nexthop *nh = &nh_grp->nhgi->nexthops[i];
+
+		mlxsw_sp_nexthop_bucket_offload_refresh(mlxsw_sp, nh, i);
+	}
 }
 
 static void
@@ -3832,6 +3864,10 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 			dev_warn(mlxsw_sp->bus_info->dev, "Failed to update neigh MAC in adjacency table.\n");
 			goto set_trap;
 		}
+		/* Flags of individual nexthop buckets might need to be
+		 * updated.
+		 */
+		mlxsw_sp_nexthop_group_offload_refresh(mlxsw_sp, nh_grp);
 		return 0;
 	}
 	mlxsw_sp_nexthop_group_normalize(nhgi);
@@ -4881,6 +4917,7 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
 
 	nh->update = 0;
 	nh->offloaded = 1;
+	mlxsw_sp_nexthop_bucket_offload_refresh(mlxsw_sp, nh, bucket_index);
 
 	return 0;
 }
-- 
2.30.2

