Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5382050B7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 13:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732443AbgFWLbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 07:31:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbgFWLa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 07:30:57 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B4720702;
        Tue, 23 Jun 2020 11:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592911856;
        bh=BbKj/hAo8dcJrmgK/HQEO3BCEI5Pim0NsUGOFehoCmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAw/PokSCMW/M2FE07RpcV6z2VvLojfMlTKoO+eVi5I24Xr1+R9ouWDeHlvjxtXbu
         V9u/bkuJEN9gWFQHtPXxIy55c9cJmZ3e9m+dxk+xpc/uFe9Hsd/wiWXtMYOSbVV66e
         UkOohR7eQ2YVXUlvt6G6FtP/z8VL8B9rSSvLuT/4=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v3 02/11] net/mlx5: Add support in query QP, CQ and MKEY segments
Date:   Tue, 23 Jun 2020 14:30:34 +0300
Message-Id: <20200623113043.1228482-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623113043.1228482-1-leon@kernel.org>
References: <20200623113043.1228482-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Introduce new resource dump segments - PRM_QUERY_QP,
PRM_QUERY_CQ and PRM_QUERY_MKEY. These segments contains the resource
dump in PRM query format.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c | 3 +++
 include/linux/mlx5/rsc_dump.h                           | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index 10218c2324cc..4924a5658853 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -23,6 +23,9 @@ static const char *const mlx5_rsc_sgmt_name[] = {
 	MLX5_SGMT_STR_ASSING(SX_SLICE_ALL),
 	MLX5_SGMT_STR_ASSING(RDB),
 	MLX5_SGMT_STR_ASSING(RX_SLICE_ALL),
+	MLX5_SGMT_STR_ASSING(PRM_QUERY_QP),
+	MLX5_SGMT_STR_ASSING(PRM_QUERY_CQ),
+	MLX5_SGMT_STR_ASSING(PRM_QUERY_MKEY),
 };
 
 struct mlx5_rsc_dump {
diff --git a/include/linux/mlx5/rsc_dump.h b/include/linux/mlx5/rsc_dump.h
index 87415fa754fe..d11c0b228620 100644
--- a/include/linux/mlx5/rsc_dump.h
+++ b/include/linux/mlx5/rsc_dump.h
@@ -23,6 +23,9 @@ enum mlx5_sgmt_type {
 	MLX5_SGMT_TYPE_SX_SLICE_ALL,
 	MLX5_SGMT_TYPE_RDB,
 	MLX5_SGMT_TYPE_RX_SLICE_ALL,
+	MLX5_SGMT_TYPE_PRM_QUERY_QP,
+	MLX5_SGMT_TYPE_PRM_QUERY_CQ,
+	MLX5_SGMT_TYPE_PRM_QUERY_MKEY,
 	MLX5_SGMT_TYPE_MENU,
 	MLX5_SGMT_TYPE_TERMINATE,
 
-- 
2.26.2

