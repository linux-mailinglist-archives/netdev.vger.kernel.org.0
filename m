Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF126B040
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgIOWF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728019AbgIOU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 16:26:00 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6782208E4;
        Tue, 15 Sep 2020 20:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600201555;
        bh=ULlyxEWuKZThlYPCpEBBmLt0eB7+VNnZmIDpphdFkVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwqPNEoXXQBl76EJ9ilDMxCLDWlv0gXpQChxUf436TDpBL7OfhK6YwTnnHhB7wGQO
         wrve0PsDJqk5Pzd9ZEFAeIgNxaXDeZVCQegopBJXp7BKq2j273dZ4bLR2dYpavsosp
         yw/qbTaexpx0TGfsGMzlo38vmabG+b03iXGLJ6lg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5: remove erroneous fallthrough
Date:   Tue, 15 Sep 2020 13:25:19 -0700
Message-Id: <20200915202533.64389-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915202533.64389-1-saeed@kernel.org>
References: <20200915202533.64389-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This isn't a fall through because it was after a return statement.  The
fall through annotation leads to a Smatch warning:

    drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c:246
    mlx5e_ethtool_get_sset_count() warn: ignoring unreachable code.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 5cb1e4839eb7..e2f092e6da3f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -243,7 +243,6 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset)
 		return MLX5E_NUM_PFLAGS;
 	case ETH_SS_TEST:
 		return mlx5e_self_test_num(priv);
-		fallthrough;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.26.2

