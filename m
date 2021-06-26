Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA563B4D77
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 09:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFZHq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 03:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFZHq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 03:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77BAE6191B;
        Sat, 26 Jun 2021 07:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624693476;
        bh=jl1UUjuhXl4tOZRB/hIgvnMjn3w5fXZgkA50QukbUp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thoMBcs8dGTRDrglntdKkkDx19KxtJro43MoHhySb7TU2bQ8LnnGBci2ORJ3xlq2a
         CbkTnkT6UrVc74HtjLLey0G6xHGPyQe27DNm6JWCPNWkLiT3tprcPxWGoFX0hQbs3U
         zzm0NJZAvoq3ArZA4KKg5TzgCgvvFE89QqBMK8HwhICVY1WA0jT8gKOadh0jPjE4IU
         YNelAoiTB8LGao5TmuWL+HQIp2RJ8BIMbH2i4sjyCzBk9hAawzH2lM/R1qL4/bFHUh
         /brq1QhGVhbY+po0BKsXoL+M4r2GGdHpmGJSkvY8LL+hkTqD36mecyuYYFm1ujJNVX
         PFhlN41pRSXcA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 1/6] net/mlx5: Compare sampler flow destination ID in fs_core
Date:   Sat, 26 Jun 2021 00:44:12 -0700
Message-Id: <20210626074417.714833-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210626074417.714833-1-saeed@kernel.org>
References: <20210626074417.714833-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When comparing sampler flow destinations,
in fs_core, consider sampler ID as well.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index b8617458a3fd..d7bf0a3e4a52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1504,7 +1504,9 @@ static bool mlx5_flow_dests_cmp(struct mlx5_flow_destination *d1,
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_TIR &&
 		     d1->tir_num == d2->tir_num) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM &&
-		     d1->ft_num == d2->ft_num))
+		     d1->ft_num == d2->ft_num) ||
+		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER &&
+		     d1->sampler_id == d2->sampler_id))
 			return true;
 	}
 
-- 
2.31.1

