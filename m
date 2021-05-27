Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F62939267E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 06:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbhE0Eic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 00:38:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232816AbhE0EiL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 00:38:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1728E61181;
        Thu, 27 May 2021 04:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622090198;
        bh=2v7mpDIOeeIVtX1p2mWAiZScfAgK8ujxQhDMQOyyyvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOmJXtsltWj4b4N27fv0Eka/+xS6nhTedG8AprBMGRBy0XhzISHGLaCZrAMN+O+HK
         /wdatuiG5WahnPpMbCr54i1iwDJKJzcVByyHoJ897KNds5Wsk+Kc0TZ7wgXbDaqG+H
         VZuWy5aXTwSmLdtIvKDmbf/16W0i1weoweqaUeKXaNhBZQxuuJqCleLuki0wD9y/it
         0yfVnH/AR8miJ3yD9t2pEEs8/hpCcf8SNm9X1PlTWLhr/HfTXniKZex7ri3BUnzAMQ
         xyEpRpuSu1rpBe/ukT4Ppuh++QwBbSUXEnKQj3rs1G/Zd1eKF4gEUckXzYlpRMwy2l
         8KG+/xaFYbGqA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/17] net/mlx5: DR, Set max table size to 2G entries
Date:   Wed, 26 May 2021 21:36:03 -0700
Message-Id: <20210527043609.654854-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527043609.654854-1-saeed@kernel.org>
References: <20210527043609.654854-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

SW steering has no table size limitations.
However, fs_core API is size aware.

Set SW steering tables to the maximum possible table size (INT_MAX).

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index ee45d698cd9c..ee0e9d79aaec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -97,7 +97,7 @@ static int mlx5_cmd_dr_create_flow_table(struct mlx5_flow_root_namespace *ns,
 		}
 	}
 
-	ft->max_fte = size ? roundup_pow_of_two(size) : 1;
+	ft->max_fte = INT_MAX;
 
 	return 0;
 }
-- 
2.31.1

