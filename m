Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BFE421B96
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 03:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhJEBQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 21:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhJEBQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 21:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDE936140B;
        Tue,  5 Oct 2021 01:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633396486;
        bh=NtICjx2b5VEnU073vCx0g+kauPrJoIrFTejtsB/iis0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfkPFGDn4HSPsAjjVwbpw+AtiSZ44Gy18jI9V9+SmKA+7LmYGRVsmpIWSW63VPFco
         O6+3h+eXiJ6H78qt2jW2QVHiU2jIMa7YvZk8t1pTAmU/tOWV1F0+FpF5NeCX1AzaXI
         naKvdRE0nBTZtza93mdWUhug5fy3iKRSDomeSqE5u2uBdqe3so7pAf8Mra5FR0mI2W
         U6p233RqAVqzKBjntLTh9A2cpF9NfRedJesRL1GbcNMzy+YFncQLdQi538qMQ+OTd9
         tRL+8e2Hkf0vARBu+gfBHX6XbLZjZORKptlpRAw93CkhOvHmEJzA3/R9z5H3ZtNplN
         zl/LpyoReXyiA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Reserve a value from TC tunnel options mapping
Date:   Mon,  4 Oct 2021 18:12:54 -0700
Message-Id: <20211005011302.41793-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005011302.41793-1-saeed@kernel.org>
References: <20211005011302.41793-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Reserve one more value from TC tunnel options range to be used by bridge
offload in following patches.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 606a7757bb04..dc21d28a4333 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5035,9 +5035,11 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	}
 	uplink_priv->tunnel_mapping = mapping;
 
-	/* 0xFFF is reserved for stack devices slow path table mark */
+	/* Two last values are reserved for stack devices slow path table mark
+	 * and bridge ingress push mark.
+	 */
 	mapping = mapping_create_for_id(mapping_id, MAPPING_TYPE_TUNNEL_ENC_OPTS,
-					sz_enc_opts, ENC_OPTS_BITS_MASK - 1, true);
+					sz_enc_opts, ENC_OPTS_BITS_MASK - 2, true);
 	if (IS_ERR(mapping)) {
 		err = PTR_ERR(mapping);
 		goto err_enc_opts_mapping;
-- 
2.31.1

