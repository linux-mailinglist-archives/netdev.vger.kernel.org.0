Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7712B1F90
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgKMQG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:56 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49937 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgKMQGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 57AEC5C01B2;
        Fri, 13 Nov 2020 11:06:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=S28GrWgFxQmOAi7ZNGNkFSVJWwR3bvnfMtfFfx/KB/0=; b=UoVQppev
        LFTCU8PV7cItFPJXGEjjkrAMM+xRgh345mSBmrwiv1wy0nfG+c144TjR1wC5BG1i
        YPKsm4J+FbO1ilGNUdSSV6dSKedQooo1BMLovyYqb6WtBnTrvKT1PyOifcTqaaPw
        RxZUWeeVwb8nwI3UAZ5f0MsdZ3fK/EXxkRkKtStrdQSQ0Q0DOAfVZDc0J+EFplYp
        aS4JTtk5A2xqBzu2gKA8oK5F9/oIi0uVvnraSjLE7wsBrR+DFeMHjEjwI8LXdCjF
        Qxg0V4EBXY5p2aYgaYW8EHqvosP/Pd/m7J0U5QVS4IzuhoUP3z78cXyj+XhbFKiX
        DLcnmivUB+R2pg==
X-ME-Sender: <xms:Ha-uX-VBSivpT9aXnSee5KvPrfNSxjVBYGPjXnV6reubLkhEHr-V3g>
    <xme:Ha-uX6no48JjTWQsecLTp-MwK-iMSWa4sWYMtMqC7tLwbRsEdUSWApZznoNFEXvSQ
    pvCyUv06bn_LWU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Ha-uXyY-Pr--K_dBGS14ZGQgs1CChO7VIRQ-b-cUc91PXRCfv-K3jA>
    <xmx:Ha-uX1UGQt1_0PbPs2eS1fkCsinFStWVZTN2fgODDhLlW5U4yGCw9A>
    <xmx:Ha-uX4nUbE-hHsenGHuyYE8i_vK98XZkeaKQBHTkubrOe6PlRuiutg>
    <xmx:Ha-uXyhkBU5OOdNgyXqDO5foolpTBIUomurho-M6Xzaz8sJbfnWIQQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 493063280064;
        Fri, 13 Nov 2020 11:06:51 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/15] mlxsw: spectrum_router: Pass nexthop netdev to mlxsw_sp_nexthop6_type_init()
Date:   Fri, 13 Nov 2020 18:05:54 +0200
Message-Id: <20201113160559.22148-11-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Instead of passing the route and resolving the nexthop netdev from it,
pass the nexthop netdev directly.

This will later allow us to consolidate code paths between IPv4 and IPv6
code.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7c7caea59d57..3bb93865f7b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5355,11 +5355,10 @@ static bool mlxsw_sp_nexthop6_ipip_type(const struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_nexthop6_type_init(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_nexthop_group *nh_grp,
 				       struct mlxsw_sp_nexthop *nh,
-				       const struct fib6_info *rt)
+				       const struct net_device *dev)
 {
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
-	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
 	struct mlxsw_sp_rif *rif;
 	int err;
 
@@ -5417,7 +5416,7 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	nh->ifindex = dev->ifindex;
 
-	return mlxsw_sp_nexthop6_type_init(mlxsw_sp, nh_grp, nh, rt);
+	return mlxsw_sp_nexthop6_type_init(mlxsw_sp, nh_grp, nh, dev);
 }
 
 static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,
-- 
2.28.0

