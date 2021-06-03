Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6624639ABA5
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbhFCUNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 16:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhFCUNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 16:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 615936140F;
        Thu,  3 Jun 2021 20:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622751122;
        bh=YSrDFqeX1SRtC4e4s2UzUUYnUf4jnY6M9JUal4Hw8s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d277b87svp7PTwWaA+vreitWyi4A477o2zbyEDN1rSKRzTyEJJbr0540MI/z5DRpH
         2FQb0twLKMrvIoHj6D65Cp42LmvehPkJ4EwuJrNq1Dpu+u3gA9K+IdyJ4UP08o+xiC
         oMJU5HXiX7EgjTH72IkSjEbmyBob/8D3iCXvPXNKKCyLfsVfGz2FTXmNFq77pfUUNi
         I0jxyy+MWK00G0O4tR/+D6E+angunaXRgExfebS2O25E6Js+g6TtAjI/D/AlYsudpv
         3ffY8Gv/UvtsOHeIM7TPvz1+yvZP0OLyeaCHtqAX//wDgk5QteW0aaKBzyHQy4jyFe
         2PJue75Sxz5oA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/10] net/mlx5e: Zero-init DIM structures
Date:   Thu,  3 Jun 2021 13:11:51 -0700
Message-Id: <20210603201155.109184-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603201155.109184-1-saeed@kernel.org>
References: <20210603201155.109184-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Initialize structs to avoid unexpected behavior.

No immediate issue in current code, structs are return values, it's
safer to initialize.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index f410c1268422..69cdc4e41a46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -201,7 +201,7 @@ int mlx5e_validate_params(struct mlx5_core_dev *mdev, struct mlx5e_params *param
 
 static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
 {
-	struct dim_cq_moder moder;
+	struct dim_cq_moder moder = {};
 
 	moder.cq_period_mode = cq_period_mode;
 	moder.pkts = MLX5E_PARAMS_DEFAULT_TX_CQ_MODERATION_PKTS;
@@ -214,7 +214,7 @@ static struct dim_cq_moder mlx5e_get_def_tx_moderation(u8 cq_period_mode)
 
 static struct dim_cq_moder mlx5e_get_def_rx_moderation(u8 cq_period_mode)
 {
-	struct dim_cq_moder moder;
+	struct dim_cq_moder moder = {};
 
 	moder.cq_period_mode = cq_period_mode;
 	moder.pkts = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_PKTS;
-- 
2.31.1

