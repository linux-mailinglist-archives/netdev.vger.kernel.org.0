Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625ED2EED0F
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbhAHFcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727489AbhAHFcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05E9323403;
        Fri,  8 Jan 2021 05:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083859;
        bh=mdwVSbRH5eEhxTjqaDtaoXYM4NwSCcLKgGfFHlIWcNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/klehQv5fq00zQNFBhlLsi4G+SvH1ioQ5MEscK99N1sZYxYxcO9rogniABHnYOg+
         INBuzOzN0eRlTjxeydYPfjhCC69DsmhklV6+4QUTSuEV5vopQdP+EjcDk4t5lXC1I/
         swySzxyxVHRkKJDhIDtA2jQ+02PAbKKCw/uUsoWCpJTQ24EVaVW/fEFOlAq98udvV9
         sSe/EeKGPADL8EbHqFtdBoxu1wIir0XbXJ+L8BKnynjL/mck1FLHp+TFVt+xrSSlGT
         +JPh/XhPgnwOAhnP+EVtpLTrC9Ksqs6u0oxoi94WmwA1eVoHfOVSz70J2Uq2KnIC9m
         v2XX0jDCrf2vw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: Remove redundant initialization to null
Date:   Thu,  7 Jan 2021 21:30:45 -0800
Message-Id: <20210108053054.660499-7-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
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

