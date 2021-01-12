Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1332F28CB
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391915AbhALHPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbhALHPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D44C22CF6;
        Tue, 12 Jan 2021 07:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435626;
        bh=mdwVSbRH5eEhxTjqaDtaoXYM4NwSCcLKgGfFHlIWcNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2TrVCsTJkUcn6Wl+Cpg+ZwC8nbaOLFURlxswNY6oERPEHp3PbCRZMqdCNbtYp5pS
         Pr93u09JKVHD1YtFD9YWa/3nRjx/nIXuts/wCJyG/qEBtdoMdh8lWwiuDym2kVfJ0+
         hRM9GfFPdGykji9oASQtEGJsRExNA9QDQ7RMuOHaG7qkkRsD+Osd4f9uqYstuQOUiF
         mzTmOXUEruMZ09ijT8g38xSnY2z5XSgIdvAdtZeD+K6bcAAQf2itm0BIwAcr/IiEUN
         yQWiehMeTjojBeqRVXMS2xl3efdjMMc8il4VQxzgy1485TiodU4Fdy0QeoN1ydAzJD
         msYWOvsjhb5NA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 06/11] net/mlx5e: Remove redundant initialization to null
Date:   Mon, 11 Jan 2021 23:05:29 -0800
Message-Id: <20210112070534.136841-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

miss_rule and prio_s args are not being referenced before assigned
so there is no need to init them.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index fa61d305990c..381325b4a863 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -538,13 +538,13 @@ mlx5_chains_create_prio(struct mlx5_fs_chains *chains,
 			u32 chain, u32 prio, u32 level)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
-	struct mlx5_flow_handle *miss_rule = NULL;
+	struct mlx5_flow_handle *miss_rule;
 	struct mlx5_flow_group *miss_group;
 	struct mlx5_flow_table *next_ft;
 	struct mlx5_flow_table *ft;
-	struct prio *prio_s = NULL;
 	struct fs_chain *chain_s;
 	struct list_head *pos;
+	struct prio *prio_s;
 	u32 *flow_group_in;
 	int err;
 
-- 
2.26.2

