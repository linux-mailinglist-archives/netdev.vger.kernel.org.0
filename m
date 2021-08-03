Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E783DE469
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhHCC3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233702AbhHCC3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AADF61100;
        Tue,  3 Aug 2021 02:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957746;
        bh=x0ctrKM95hfP9V2qtYxEzALujyhYffRFoYwHZ0Nt1SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVsFyQAr5yuRwJNkZL94VxoYbebGVDpJFvoJ7g8FXTesEdpzMKG0aTzTw7O/PefGH
         bO4+cP+E3XVdDLOpMnlfiweF+NnpCktLk5NCoqmkyhdJ2vrRMt741XS6rQI5SmC+GW
         Io7qo9XGHRurvqkaM6p3G2j/FxbWMydoeGqZz4lmhd9E4Afg/P0kCGn2epGllP7xau
         9cYQ3+BCbcUBKXwjRwq7tahkXBVtj/QhB9rDmAB57g9sSIsp6dz7ivM+QeIH4coL6l
         VePEbhZROW2EaDMVrpoyFO2vzOeckw0jeiWg0QjlLbHAxGE19O3r3MtOB+bkcC1LtO
         dg/WNVQQf8ySA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/16] net/mlx5e: Return -EOPNOTSUPP if more relevant when parsing tc actions
Date:   Mon,  2 Aug 2021 19:28:52 -0700
Message-Id: <20210803022853.106973-16-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Instead of returning -EINVAL.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 980a668bbc3c..349a93e0213d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3400,7 +3400,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 						   "device is not on same HW, can't offload");
 				netdev_warn(priv->netdev, "device %s not on same HW, can't offload\n",
 					    peer_dev->name);
-				return -EINVAL;
+				return -EOPNOTSUPP;
 			}
 			}
 			break;
@@ -3410,7 +3410,7 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 			if (mark & ~MLX5E_TC_FLOW_ID_MASK) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "Bad flow mark - only 16 bit is supported");
-				return -EINVAL;
+				return -EOPNOTSUPP;
 			}
 
 			nic_attr->flow_tag = mark;
@@ -3921,7 +3921,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 					    "devices %s %s not on same switch HW, can't offload forwarding\n",
 					    priv->netdev->name,
 					    out_dev->name);
-				return -EINVAL;
+				return -EOPNOTSUPP;
 			}
 			}
 			break;
-- 
2.31.1

