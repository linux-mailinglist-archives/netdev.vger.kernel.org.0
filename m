Return-Path: <netdev+bounces-8295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5E17238A5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:16:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16CE1281521
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A184A2773D;
	Tue,  6 Jun 2023 07:12:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D1F2770A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46067C43326;
	Tue,  6 Jun 2023 07:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686035564;
	bh=SCPGQDaiOmgv4WfRu3mWoyJB1OIsY/K3JEmAQ5RxAxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECYHGwhI0xsGNGsdWTd6IxZpD0TLqszF7toES4OTzahw9JEiKhaziAQMaj7oJVvCf
	 MIEJzgDCX/jlhVP6LRMxg5itW7rq+wlBuGqrM80LAjRmopdn1T0uYJHS9xdELbJvkL
	 2U22hlj7w0t4hwnqYtGxFZ3aWc6D1tzhrSW4vlD5sx0cntVlRPhFDAA2hf0jx2+Vgf
	 RR2iBqyzVZLTU5CmxW/YghXUsCv5TAimH3TCxfMZDvZNplhjqGAX1lQxYCTaLUGNOb
	 1QtwujFauTn4MMxA2UqJQ2EuvjPO63DYPvUVEn8zoNzBzxTcaAXYS52OPVXTLtd6p7
	 qWxorKuHJbwRg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org,
	Dragos Tatulea <dtatulea@nvidia.com>
Subject: [net-next 11/15] net/mlx5e: Remove RX page cache leftovers
Date: Tue,  6 Jun 2023 00:12:15 -0700
Message-Id: <20230606071219.483255-12-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606071219.483255-1-saeed@kernel.org>
References: <20230606071219.483255-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tariq Toukan <tariqt@nvidia.com>

Remove unused definitions left after the removal
of the RX page cache feature.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8e999f238194..ceabe57c511a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -594,13 +594,6 @@ struct mlx5e_mpw_info {
 
 #define MLX5E_MAX_RX_FRAGS 4
 
-/* a single cache unit is capable to serve one napi call (for non-striding rq)
- * or a MPWQE (for striding rq).
- */
-#define MLX5E_CACHE_UNIT (MLX5_MPWRQ_MAX_PAGES_PER_WQE > NAPI_POLL_WEIGHT ? \
-			  MLX5_MPWRQ_MAX_PAGES_PER_WQE : NAPI_POLL_WEIGHT)
-#define MLX5E_CACHE_SIZE	(4 * roundup_pow_of_two(MLX5E_CACHE_UNIT))
-
 struct mlx5e_rq;
 typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64*);
 typedef struct sk_buff *
-- 
2.40.1


