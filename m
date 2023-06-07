Return-Path: <netdev+bounces-9078-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B67172704B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76DB21C20F43
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA78051820;
	Wed,  7 Jun 2023 21:04:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3589E3D380
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F56C4331E;
	Wed,  7 Jun 2023 21:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686171884;
	bh=+x5l76jEigP+jfedcLp5qK2IoJnrnOHNChSi6eV9RfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PlyRi4egE7WcLCeYsXKBDXKkCCNpShyLc063sG6Cw7H0MBCp9cVtbF+m1Vg1FSUOg
	 3RDim0Fs7km0dhD8Xlx1kX7KPp/Ty1yoEoFek95kfhdH697MkgTXFdDtZnRA4dU3Ut
	 /RaRbeWqRgvOY0WtjRKtLW3nGWRlVUHKTWchFypVwg5o5owFXt6qNXAK5lkJXbrrCR
	 A7+YH1tMwdQhs5a7B/iAYEIJaOOLhSKzLw8DddOkeJPD9rdZJhHFG+kw8Z2ve2GvMI
	 UIQX4oI9p12hQbDltvhDK4owz2AlhCyutDQzliikOcme9tx/hY/USQDpgSQ+Oc1+Ud
	 3n/c9hnIDF+NQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org
Subject: [net-next V2 14/14] net/mlx5e: simplify condition after napi budget handling change
Date: Wed,  7 Jun 2023 14:04:10 -0700
Message-Id: <20230607210410.88209-15-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607210410.88209-1-saeed@kernel.org>
References: <20230607210410.88209-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

Since recent commit budget can't be 0 here.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index fbb2d963fb7e..a7d9b7cb4297 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -207,7 +207,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 		}
 		ch_stats->aff_change++;
 		aff_change = true;
-		if (budget && work_done == budget)
+		if (work_done == budget)
 			work_done--;
 	}
 
-- 
2.40.1


