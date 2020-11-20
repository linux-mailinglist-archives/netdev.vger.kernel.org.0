Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F52BB994
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgKTXEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1186 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbgKTXEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:10 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0002>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:02 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <elic@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH mlx5-next 12/16] net/mlx5: Export steering related functions
Date:   Fri, 20 Nov 2020 15:03:35 -0800
Message-ID: <20201120230339.651609-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913439; bh=ki7lHks8iH/kfFiDtW1h+H8ISkj2E8Qyyuoavy9EtyM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=WStAD0Lf3BaOkJos3VJgNg+P0Hhdm5nj9gR5eb3+LJKG/G4Fzp+dEHZiCZ+ukXJs0
         oDoNiU9d4Wd8edVu4LaFoo53NoIoSBrGHTRwoG/lKdNsuzzoMLek1udWz6JWH0GrdV
         IBfFfm1KyECMMrjIctqCXj8CQq5UzsAiuTTE9VGOI37W0S1iW3/1l6WTcn71DA5XBw
         br0EeVxjP99MvFqBgobKuRdJp7QG+I6fzL73Pj1ZVmnjFxw3/OD7WcVW9Ztc20VhtH
         CdJW+SEpqJlzkS72We0kBAVvx6xycXYY+urnBOroPSujKAVkeJkcZg860yd3ZS31l4
         mCarLebgLV/bA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Export
 mlx5_create_flow_table()
 mlx5_create_flow_group()
 mlx5_destroy_flow_group().

These symbols are required by the VDPA implementation to create rules
that consume VDPA specific traffic.

We do not deal with putting the prototypes in a header file since they
already exist in include/linux/mlx5/fs.h.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index e095c5968e67..9feab81ab919 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1153,6 +1153,7 @@ struct mlx5_flow_table *mlx5_create_flow_table(struct=
 mlx5_flow_namespace *ns,
 {
 	return __mlx5_create_flow_table(ns, ft_attr, FS_FT_OP_MOD_NORMAL, 0);
 }
+EXPORT_SYMBOL(mlx5_create_flow_table);
=20
 struct mlx5_flow_table *mlx5_create_vport_flow_table(struct mlx5_flow_name=
space *ns,
 						     int prio, int max_fte,
@@ -1244,6 +1245,7 @@ struct mlx5_flow_group *mlx5_create_flow_group(struct=
 mlx5_flow_table *ft,
=20
 	return fg;
 }
+EXPORT_SYMBOL(mlx5_create_flow_group);
=20
 static struct mlx5_flow_rule *alloc_rule(struct mlx5_flow_destination *des=
t)
 {
@@ -2146,6 +2148,7 @@ void mlx5_destroy_flow_group(struct mlx5_flow_group *=
fg)
 		mlx5_core_warn(get_dev(&fg->node), "Flow group %d wasn't destroyed, refc=
ount > 1\n",
 			       fg->id);
 }
+EXPORT_SYMBOL(mlx5_destroy_flow_group);
=20
 struct mlx5_flow_namespace *mlx5_get_fdb_sub_ns(struct mlx5_core_dev *dev,
 						int n)
--=20
2.26.2

