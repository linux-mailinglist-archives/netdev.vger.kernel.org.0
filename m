Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0282EB5D5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbhAEXG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbhAEXGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3608223106;
        Tue,  5 Jan 2021 23:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887915;
        bh=9AN2+PifaU9jHrEyuH1Yb8X7bH+U1O7NOGMFTQdJWJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PysIv5dr1UNJLO2oOHmUZqsw0GzivzVFtVSmg0cMlrHKH6q9VDT36sekxGqABkHQO
         JEvDHfkPHyNaX+eSLvRN+MgLH8T8BT1bBGtJMSs0ouqOFqy334FvizqhP05mr3IZbH
         8oGTQS22Dc/0DVX0mk/ZwNisObEb1+ECK/0Gmd/IAb6yIQuGdhfL9L4aQYw7jaXbJ8
         4ZMlMwe2eGVMlEY5RsLO+niIboNYvF87DIqNd7grvO+HZgaqS7ZhHWV2bD0ibniT3t
         AovVqlnAnuLhDuPcnxZv+bFOFGoyBmWwRAF+JCF/eUKX8GzB28cCuE35sgKVQwgu5n
         wgPlAx9Pu3ogw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/16] net/mlx5: DR, Add STE tx/rx actions per-device API
Date:   Tue,  5 Jan 2021 15:03:30 -0800
Message-Id: <20210105230333.239456-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Extend the STE context struct with per-device
tx/rx actions.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h    | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
index 53bb42978e84..9fbe60ed11ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.h
@@ -108,6 +108,18 @@ struct mlx5dr_ste_ctx {
 	void (*set_hit_addr)(u8 *hw_ste_p, u64 icm_addr, u32 ht_size);
 	void (*set_byte_mask)(u8 *hw_ste_p, u16 byte_mask);
 	u16  (*get_byte_mask)(u8 *hw_ste_p);
+
+	/* Actions */
+	void (*set_actions_rx)(struct mlx5dr_domain *dmn,
+			       u8 *action_type_set,
+			       u8 *hw_ste_arr,
+			       struct mlx5dr_ste_actions_attr *attr,
+			       u32 *added_stes);
+	void (*set_actions_tx)(struct mlx5dr_domain *dmn,
+			       u8 *action_type_set,
+			       u8 *hw_ste_arr,
+			       struct mlx5dr_ste_actions_attr *attr,
+			       u32 *added_stes);
 };
 
 extern struct mlx5dr_ste_ctx ste_ctx_v0;
-- 
2.26.2

