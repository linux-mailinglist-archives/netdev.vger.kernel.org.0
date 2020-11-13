Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E262B1F91
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgKMQG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:06:59 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50205 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726949AbgKMQG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:06:56 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 952F75C0184;
        Fri, 13 Nov 2020 11:06:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 13 Nov 2020 11:06:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Y8bs7y2f/qNcndZtGM38IyvrYHvGKzi6agkFqoA3hDw=; b=J4UvgJG/
        t+Gety8337wqsxu9y+pMsX7gjAsA+M2Rpt89gW9yo3MOtaaU0vKWVnFRCM1vXdX8
        /XgpX1ewhQd8Q0nxbKPEaLipGSH6kMExoVE1eY0VyH+h8M+4VX6UrDrK0SbSueEc
        zWUEAcjUSreKViUKR8vPz1z3SutM9KHRWuS0IIzR+vXi4pPqX2NxCMjKa9Bop9HR
        1/4fFO8kJGIdhwocQMEnBuqKOVrLPlZy5h95IPDE54PgR/pXLROigG+P7gWovSHR
        nyEWyQDztDqIQM3WTfLp+PXf2zC8dYPB6hegkkcGyBbj7AOeikqUMbUpnaMcvg9I
        evQHnmLbNnf/Hw==
X-ME-Sender: <xms:H6-uX0ERcDOLXI84hUikjpmhVw6CN6hGvD4eb8ssaOB9xmQLYanmbQ>
    <xme:H6-uX9XaGSSnY3sa_1lfOZ1qy9TWrdECleJj7uAPvJlMRS3NTqdDYG7DJzHCD2l-o
    Dmz0IL3PzhNVMM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddvhedgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:H6-uX-LiWQOK16OI1TmDZudpT7YuSZDk5-LujgW5yt2c97X37iHyEg>
    <xmx:H6-uX2ESWJh0fQnAhTboKkCgBUplT7FIk2TghXlLeSIEgBU_UcNtYQ>
    <xmx:H6-uX6W9skkMIyaBr3mBJmBOoy0Z-nAHdR-QGG1KdCSwT2D0x6RAcQ>
    <xmx:H6-uX5R-vFf1uzxFrPH4QqyZ2AInnz4x-TXUDFbI5cbHr82k2rBjSQ>
Received: from shredder.lan (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 86FB3328005D;
        Fri, 13 Nov 2020 11:06:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/15] mlxsw: spectrum_router: Pass nexthop netdev to mlxsw_sp_nexthop4_type_init()
Date:   Fri, 13 Nov 2020 18:05:55 +0200
Message-Id: <20201113160559.22148-12-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113160559.22148-1-idosch@idosch.org>
References: <20201113160559.22148-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Instead of passing the nexthop and resolving the nexthop netdev from it,
pass the nexthop netdev directly.

This will later allow us to consolidate code paths between IPv4 and IPv6
code.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3bb93865f7b0..77be06b703bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3910,10 +3910,9 @@ static void mlxsw_sp_nexthop_type_fini(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_nexthop4_type_init(struct mlxsw_sp *mlxsw_sp,
 				       struct mlxsw_sp_nexthop *nh,
-				       struct fib_nh *fib_nh)
+				       const struct net_device *dev)
 {
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
-	struct net_device *dev = fib_nh->fib_nh_dev;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
 	struct mlxsw_sp_rif *rif;
 	int err;
@@ -3988,7 +3987,7 @@ static int mlxsw_sp_nexthop4_init(struct mlxsw_sp *mlxsw_sp,
 	}
 	rcu_read_unlock();
 
-	err = mlxsw_sp_nexthop4_type_init(mlxsw_sp, nh, fib_nh);
+	err = mlxsw_sp_nexthop4_type_init(mlxsw_sp, nh, dev);
 	if (err)
 		goto err_nexthop_neigh_init;
 
@@ -4024,7 +4023,7 @@ static void mlxsw_sp_nexthop4_event(struct mlxsw_sp *mlxsw_sp,
 
 	switch (event) {
 	case FIB_EVENT_NH_ADD:
-		mlxsw_sp_nexthop4_type_init(mlxsw_sp, nh, fib_nh);
+		mlxsw_sp_nexthop4_type_init(mlxsw_sp, nh, fib_nh->fib_nh_dev);
 		break;
 	case FIB_EVENT_NH_DEL:
 		mlxsw_sp_nexthop4_type_fini(mlxsw_sp, nh);
-- 
2.28.0

