Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750B1339A07
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbhCLXjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235791AbhCLXi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAC1C64F8E;
        Fri, 12 Mar 2021 23:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592337;
        bh=rECLVQA13kP6xM5Hv/YcfZz1oc/M9/cAH/ze/TBPJSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JY18gJxx9t2Ougm1nwUMm8BAP/iLpOBkEL2diyA6CGOAE49rROj6evlIqUEI70KsX
         1zM8OUp86C7x3UbEjrKDSEnn6oXl+1yraiXfCxHjN52GgqpAR1YbEe1wRUz9qP7u7h
         yDL8aiBl7vLrod/+g8Rr1b7fp2AW6ZwUhdeO7kiaFLsXaWaYzHoT/XYCJbymIKkH/u
         869CqrWUoL9/qDrec7nHmXMBBJHt5grGLIJovkrnEhQND+qfzegh4yXmKAXUC/UNg1
         bxGaZAOweK7ng4hQaGQJbJaX4LbxGoFXBw/9exa4RSPcEO7AGJdKEGEnrrVq32p74r
         Vl0C88EGd4tfQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@mellanox.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/13] net/mlx5: DR, Add missing vhca_id consume from STEv1
Date:   Fri, 12 Mar 2021 15:38:41 -0800
Message-Id: <20210312233851.494832-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312233851.494832-1-saeed@kernel.org>
References: <20210312233851.494832-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The field source_eswitch_owner_vhca_id was not consumed
in the same way as in STEv0. Added the missing set.

Fixes: 10b694186410 ("net/mlx5: DR, Add HW STEv1 match logic")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 6f368ccc428e..815951617e7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1514,6 +1514,7 @@ static void dr_ste_v1_build_src_gvmi_qpn_bit_mask(struct mlx5dr_match_param *val
 
 	DR_STE_SET_ONES(src_gvmi_qp_v1, bit_mask, source_gvmi, misc_mask, source_port);
 	DR_STE_SET_ONES(src_gvmi_qp_v1, bit_mask, source_qp, misc_mask, source_sqn);
+	misc_mask->source_eswitch_owner_vhca_id = 0;
 }
 
 static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
-- 
2.29.2

