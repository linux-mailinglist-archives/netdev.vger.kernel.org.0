Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925A92B1F94
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgKMQHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:07:08 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48475 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgKMQHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:07:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EBEBF5C0196;
        Fri, 13 Nov 2020 11:07:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:07:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/FgtsIOdVE+f2cWLDTcOYNsGSCNT9tb0M//DyYLav44=; b=WeefWDP5
        yHQeznDPhdhZh7UNwuu0YcqMLhjnTFnnTF5ngpg41Uxa3Sb17U6wZP2VhskJihaS
        0N+/jKaHdcvf6khmFs4yIFfxVobajAfSite5gk8tOzYq+77to8PDxgbDTFFRmrxC
        IT2igSnVsGRDyhdQ61Kt7NPQMzrSba+lcopU8I/R7S58NJo+PDtHL2/+W1cLJioe
        i5Y7aIWfPQeoUapXPmtDFBevfFBxCn9VW0DUN0Ff6RiTtZReb1ZeK9WRZhIW7KwZ
        sDQrQT3ahZeGEEIr6ukfW2mEsrscFYGOhf2lHM5KJXvcTFV6LwhsIyOiHnvgnmc3
        sN8o5dK9IHLQ/w==
X-ME-Sender: <xms:Ja-uXyDYTk5y_vlFP_I46SzFGtgNE8JqWOqP395Yj6838JYJfXgqwA>
    <xme:Ja-uX8jhNHOWXcu-N5VnAbz6umggrmPeFqjrnME9MpHrutJbek_ph2-smqxdhS7MX
    gPeZ1TdEdt6yaM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeduvdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Ja-uX1kqHhxH33vnorSo-7FOYwVIuvNlbSx1bhwnJ1Y_eck1rxAk9Q>
    <xmx:Ja-uXwxq049xj4qlxMhdY4ufm68hxb8aeA0ANZgSNgEQUG4iWLpbJg>
    <xmx:Ja-uX3SznpUYpsWOju0TyXrk4wrujflVwgEuK_knP_yZ5uOZwW0-qA>
    <xmx:Ja-uXxdDth67LFa92xFoGfOqFYlYgTNEh4I6_FsK0v3oeJFV2fx0WA>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id DBECD3280059;
        Fri, 13 Nov 2020 11:06:59 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/15] mlxsw: spectrum_router: Consolidate mlxsw_sp_nexthop{4, 6}_type_fini()
Date:   Fri, 13 Nov 2020 18:05:58 +0200
Message-Id: <20201113160559.22148-15-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The two functions are identical, so consolidate them to
mlxsw_sp_nexthop_type_fini().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c  | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index bbe07d74f2e8..ca9f7d06eab1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3944,12 +3944,6 @@ static void mlxsw_sp_nexthop_type_fini(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-static void mlxsw_sp_nexthop4_type_fini(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_nexthop *nh)
-{
-	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
-}
-
 static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_nexthop_group *nh_grp,
 				  struct mlxsw_sp_nexthop *nh,
@@ -4001,7 +3995,7 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_nexthop4_fini(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_nexthop *nh)
 {
-	mlxsw_sp_nexthop4_type_fini(mlxsw_sp, nh);
+	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
 	list_del(&nh->router_list_node);
 	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 	mlxsw_sp_nexthop_remove(mlxsw_sp, nh);
@@ -4026,7 +4020,7 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_nexthop_type_init(mlxsw_sp, nh, fib_nh->fib_nh_dev);
 		break;
 	case FIB_EVENT_NH_DEL:
-		mlxsw_sp_nexthop4_type_fini(mlxsw_sp, nh);
+		mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
 		break;
 	}
 
@@ -5351,12 +5345,6 @@ static bool mlxsw_sp_nexthop6_ipip_type(const struct mlxsw_sp *mlxsw_sp,
 	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, rt->fib6_nh->fib_nh_dev, ret);
 }
 
-static void mlxsw_sp_nexthop6_type_fini(struct mlxsw_sp *mlxsw_sp,
-					struct mlxsw_sp_nexthop *nh)
-{
-	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
-}
-
 static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_nexthop_group *nh_grp,
 				  struct mlxsw_sp_nexthop *nh,
@@ -5384,7 +5372,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_nexthop *nh)
 {
-	mlxsw_sp_nexthop6_type_fini(mlxsw_sp, nh);
+	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
 	list_del(&nh->router_list_node);
 	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
 }
-- 
2.28.0

