Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903862B1F8D
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgKMQGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:49 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52167 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgKMQGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:47 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9C9E85C0156;
        Fri, 13 Nov 2020 11:06:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=G5ZYwbgsD0DabHTTd7802t1h6tscDZX19uMFdyuggrI=; b=UF5ykylw
        YCe2jjgnbPxYDffwjBCdspEJsINkRlhJQ8+xt2SFyTJtZ9wg59i2/3LCxgOkAByq
        izurIXjvNd44RdUdBq2JvYc5gi8pP+D6xZarRTWzFFYOhDtgmeBMRQN+1k7+GMDo
        lAg1yw9SIjVaQsBBXk8FcjYN1Nv4+/t/UfJ6cXkD+r05qfhUF3wUeP9f+BAhV1il
        2h/mhBasyB6kRkC0RpSLIWH6+AvCbFgElpYPvdNPZcA9RT3Jj8nZFKeWOE64Jz1P
        QFRpq/FxNYFfJptQdsiSMQp7OZ+6yHemZ/olsjDXnjsaDqV0kZMyrxIKwTLrGe6n
        SDyYGjj7R4oFAw==
X-ME-Sender: <xms:Fq-uXyGftjlklzvyswVzlTrHjzP5-DfgSNFJN_UHMptskd-ijmQvmg>
    <xme:Fq-uXzWDGz6OGkntmqsI0QypFKGHh_4SVrKYFKqOh5MAXx1cuuk7Vjn1gPOt23mU6
    YmYrDXTWuy8kjE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Fq-uX8LT1AtE1nFPFSwfs1o5zjD4G7VU1BqeYJXigreP1L6AB2QOLA>
    <xmx:Fq-uX8HhmfdxFQ6iK0RbwO-ZZW-qsixOH3Btb-o_VVo_cIcYFSPaoA>
    <xmx:Fq-uX4VJiGWwCyqIPe5cfsy37I9xINqcSMR9u_pXoo0O9r1bMda9QQ>
    <xmx:Fq-uX_S4238Qdc1EdkipeNsvWObf3qS1pi8zuZq9GdGVSS7JzTSIkg>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38FF9328005D;
        Fri, 13 Nov 2020 11:06:44 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/15] mlxsw: spectrum_router: Move IPv4 FIB info into a union in nexthop group struct
Date:   Fri, 13 Nov 2020 18:05:51 +0200
Message-Id: <20201113160559.22148-8-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Instead of storing the FIB info as 'priv' when the nexthop group
represents an IPv4 nexthop group, simply store it as a FIB info with a
proper comment.

When nexthop objects are supported, this field will become a union with
the nexthop object's identifier.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index bd4bf9316390..6612951b6911 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2867,7 +2867,11 @@ enum mlxsw_sp_nexthop_group_type {
 };
 
 struct mlxsw_sp_nexthop_group {
-	void *priv;
+	union {
+		struct {
+			struct fib_info *fi;
+		} ipv4;
+	};
 	struct rhash_head ht_node;
 	struct list_head fib_list; /* list of fib entries that use this group */
 	enum mlxsw_sp_nexthop_group_type type;
@@ -2988,12 +2992,6 @@ bool mlxsw_sp_nexthop_group_has_ipip(struct mlxsw_sp_nexthop *nh)
 	return false;
 }
 
-static struct fib_info *
-mlxsw_sp_nexthop4_group_fi(const struct mlxsw_sp_nexthop_group *nh_grp)
-{
-	return nh_grp->priv;
-}
-
 struct mlxsw_sp_nexthop_group_cmp_arg {
 	enum mlxsw_sp_nexthop_group_type type;
 	union {
@@ -3057,7 +3055,7 @@ mlxsw_sp_nexthop_group_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
 
 	switch (cmp_arg->type) {
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4:
-		return cmp_arg->fi != mlxsw_sp_nexthop4_group_fi(nh_grp);
+		return cmp_arg->fi != nh_grp->ipv4.fi;
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		return !mlxsw_sp_nexthop6_group_cmp(nh_grp,
 						    cmp_arg->fib6_entry);
@@ -3077,7 +3075,7 @@ static u32 mlxsw_sp_nexthop_group_hash_obj(const void *data, u32 len, u32 seed)
 
 	switch (nh_grp->type) {
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4:
-		fi = mlxsw_sp_nexthop4_group_fi(nh_grp);
+		fi = nh_grp->ipv4.fi;
 		return jhash(&fi, sizeof(fi), seed);
 	case MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV6:
 		val = nh_grp->count;
@@ -4101,12 +4099,12 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 	nh_grp = kzalloc(struct_size(nh_grp, nexthops, nhs), GFP_KERNEL);
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
-	nh_grp->priv = fi;
 	INIT_LIST_HEAD(&nh_grp->fib_list);
 	nh_grp->type = MLXSW_SP_NEXTHOP_GROUP_TYPE_IPV4;
 
 	nh_grp->gateway = mlxsw_sp_fi_is_gateway(mlxsw_sp, fi);
 	nh_grp->count = nhs;
+	nh_grp->ipv4.fi = fi;
 	fib_info_hold(fi);
 	for (i = 0; i < nh_grp->count; i++) {
 		nh = &nh_grp->nexthops[i];
@@ -4146,7 +4144,7 @@ mlxsw_sp_nexthop4_group_destroy(struct mlxsw_sp *mlxsw_sp,
 	}
 	mlxsw_sp_nexthop_group_refresh(mlxsw_sp, nh_grp);
 	WARN_ON_ONCE(nh_grp->adj_index_valid);
-	fib_info_put(mlxsw_sp_nexthop4_group_fi(nh_grp));
+	fib_info_put(nh_grp->ipv4.fi);
 	kfree(nh_grp);
 }
 
-- 
2.28.0

