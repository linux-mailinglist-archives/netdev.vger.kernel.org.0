Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3704E3935B6
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 20:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbhE0S6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 14:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236140AbhE0S6N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 14:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B795E61077;
        Thu, 27 May 2021 18:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622141800;
        bh=2v7mpDIOeeIVtX1p2mWAiZScfAgK8ujxQhDMQOyyyvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPQqYgYAHN8D8clhq8YZ2IhrVySTuq6jo2CJHmgKnkiHwivROpOtlzH24oa2KMJYW
         g/Pyt4pE5WRWoV0paF9lMxfUmjYLAVqGrhcessw7XzGlPNoEDw+oC1EUG2TwbFNxPD
         9duLZOkjNBNgRnAgf5109jMs1xx1Jp+6cI5wBleP0L5+9JdJHqa9ox/L0Zn1AputPP
         Ag+DUwD/p/fNUCbkv0oNAuflNFMaRTjBWvVmnIlVmVyE+qEYnMmAADrBT7rLtmJYUC
         ALOQEZ8hew0gidn+xTYEWDrJPHchTopkzJLeO/rCPymXFLvul+xOzC2ygy4a1afQxH
         Pr1c1Hroc/Pjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 11/15] net/mlx5: DR, Set max table size to 2G entries
Date:   Thu, 27 May 2021 11:56:20 -0700
Message-Id: <20210527185624.694304-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527185624.694304-1-saeed@kernel.org>
References: <20210527185624.694304-1-saeed@kernel.org>
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

