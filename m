Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23CEB2B1F93
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgKMQHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:07:03 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50575 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbgKMQHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:07:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A9CA45C018D;
        Fri, 13 Nov 2020 11:06:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=dtqDEcRQBQqOA+PiiUGCM08gd8rA8X+tB/Eelq20zIg=; b=jnwdbeb2
        pNlxN8qxcMqoppXd88zTKbjQLgdmuAktyZ99MKfe6fLIZ6jqzV0WMBvu0TCfLKsv
        8VLCkrdKHIx1YtQtUs3+h4rk0iojYJw1sdy61dbsnsDBx6lsHfulTfRbZWMofUzq
        o5rZaUCuUcDtBJpT99yyvli0ynuATiVoyt9NeU+pOIlNrwJUQo803rC793DoYYrz
        oO6FtKEjNUYXykHxosLZKEJMg5Nbh/jtuNFHtb4pvErtU5pEWJrwGKTAmtwoQxJJ
        AOptlgd0nwj5SSPKsd1e/h6oK30IQFqlLjTMdU1Yd3Bbp+IEUKV6C+fvTZlbew8B
        7lIE9SqQJDhsqA==
X-ME-Sender: <xms:I6-uX4Aqk_PtSjVEySLFk8_fla2pdR6QU22K-VhUSFw0h8KVEH_B2A>
    <xme:I6-uX6g0zmOLkz0UvHBql532ZUBaSw51MKwe07cHCF_u2m3XWolflNZpYf8z6Xxvc
    lPW78xzz1Osw4E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:I6-uX7mzW_SxubMMQaHulMgy6hOnTohgZLO8SIUdu4lhHqqfV9VQDg>
    <xmx:I6-uX-wn88_P2URPB2oAi6tJqkv8-MuQY4jhyl3-k92lpwfsPoFX3g>
    <xmx:I6-uX9TLObKkpZBOCKUWJR07vuQtCGLlfosx6wsfOGr08kJZsjj0bA>
    <xmx:I6-uX_cfZeB-I4eBrjXLV18u-Hc84NYDZR3R_bKQU0_9oC12OT1y5A>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9F0A53280059;
        Fri, 13 Nov 2020 11:06:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/15] mlxsw: spectrum_router: Consolidate mlxsw_sp_nexthop{4, 6}_type_init()
Date:   Fri, 13 Nov 2020 18:05:57 +0200
Message-Id: <20201113160559.22148-14-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The two functions are now identical, so consolidate them to
mlxsw_sp_nexthop_type_init().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 78 +++++--------------
 1 file changed, 21 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 49b7b9294684..bbe07d74f2e8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3893,24 +3893,9 @@ static bool mlxsw_sp_nexthop4_ipip_type(const struct mlxsw_sp *mlxsw_sp,
 	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, dev, p_ipipt);
 }
 
-static void mlxsw_sp_nexthop_type_fini(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_nexthop *nh)
-{
-	switch (nh->type) {
-	case MLXSW_SP_NEXTHOP_TYPE_ETH:
-		mlxsw_sp_nexthop_neigh_fini(mlxsw_sp, nh);
-		mlxsw_sp_nexthop_rif_fini(nh);
-		break;
-	case MLXSW_SP_NEXTHOP_TYPE_IPIP:
-		mlxsw_sp_nexthop_rif_fini(nh);
-		mlxsw_sp_nexthop_ipip_fini(mlxsw_sp, nh);
-		break;
-	}
-}
-
-static int mlxsw_sp_nexthop4_type_init(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_nexthop *nh,
-				       const struct net_device *dev)
+static int mlxsw_sp_nexthop_type_init(struct mlxsw_sp *mlxsw_sp,
+				      struct mlxsw_sp_nexthop *nh,
+				      const struct net_device *dev)
 {
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
@@ -3944,6 +3929,21 @@ static int mlxsw_sp_nexthop4_type_init(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
+static void mlxsw_sp_nexthop_type_fini(struct mlxsw_sp *mlxsw_sp,
+				       struct mlxsw_sp_nexthop *nh)
+{
+	switch (nh->type) {
+	case MLXSW_SP_NEXTHOP_TYPE_ETH:
+		mlxsw_sp_nexthop_neigh_fini(mlxsw_sp, nh);
+		mlxsw_sp_nexthop_rif_fini(nh);
+		break;
+	case MLXSW_SP_NEXTHOP_TYPE_IPIP:
+		mlxsw_sp_nexthop_rif_fini(nh);
+		mlxsw_sp_nexthop_ipip_fini(mlxsw_sp, nh);
+		break;
+	}
+}
+
 static void mlxsw_sp_nexthop4_type_fini(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_nexthop *nh)
 {
@@ -3987,7 +3987,7 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	}
 	rcu_read_unlock();
 
-	err = mlxsw_sp_nexthop4_type_init(mlxsw_sp, nh, dev);
+	err = mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
 	if (err)
 		goto err_nexthop_neigh_init;
 
@@ -4023,7 +4023,7 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 
 	switch (event) {
 	case FIB_EVENT_NH_ADD:
-		mlxsw_sp_nexthop4_type_init(mlxsw_sp, nh, fib_nh->fib_nh_dev);
+		mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, fib_nh->fib_nh_dev);
 		break;
 	case FIB_EVENT_NH_DEL:
 		mlxsw_sp_nexthop4_type_fini(mlxsw_sp, nh);
@@ -5351,42 +5351,6 @@ static bool mlxsw_sp_nexthop6_ipip_type(const struct mlxsw_sp *mlxsw_sp,
 	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, rt->fib6_nh->fib_nh_dev, ret);
 }
 
-static int mlxsw_sp_nexthop6_type_init(struct mlxsw_sp *mlxsw_sp,
-				       struct mlxsw_sp_nexthop *nh,
-				       const struct net_device *dev)
-{
-	const struct mlxsw_sp_ipip_ops *ipip_ops;
-	struct mlxsw_sp_ipip_entry *ipip_entry;
-	struct mlxsw_sp_rif *rif;
-	int err;
-
-	ipip_entry = mlxsw_sp_ipip_entry_find_by_ol_dev(mlxsw_sp, dev);
-	if (ipip_entry) {
-		ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
-		if (ipip_ops->can_offload(mlxsw_sp, dev)) {
-			nh->type = MLXSW_SP_NEXTHOP_TYPE_IPIP;
-			mlxsw_sp_nexthop_ipip_init(mlxsw_sp, nh, ipip_entry);
-			return 0;
-		}
-	}
-
-	nh->type = MLXSW_SP_NEXTHOP_TYPE_ETH;
-	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
-	if (!rif)
-		return 0;
-	mlxsw_sp_nexthop_rif_init(nh, rif);
-
-	err = mlxsw_sp_nexthop_neigh_init(mlxsw_sp, nh);
-	if (err)
-		goto err_nexthop_neigh_init;
-
-	return 0;
-
-err_nexthop_neigh_init:
-	mlxsw_sp_nexthop_rif_fini(nh);
-	return err;
-}
-
 static void mlxsw_sp_nexthop6_type_fini(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_nexthop *nh)
 {
@@ -5414,7 +5378,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	nh->ifindex = dev->ifindex;
 
-	return mlxsw_sp_nexthop6_type_init(mlxsw_sp, nh, dev);
+	return mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, dev);
 }
 
 static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,
-- 
2.28.0

