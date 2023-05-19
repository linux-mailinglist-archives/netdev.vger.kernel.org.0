Return-Path: <netdev+bounces-3978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2150F709EA7
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0FF9281D43
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4A213AD0;
	Fri, 19 May 2023 17:56:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994AC13AC2
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 17:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FA6C43443;
	Fri, 19 May 2023 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684518974;
	bh=fQbCHBLMVLU6ZJsmCB6I+CxujM+ffJULRncvcYxbYvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXtjJBk02H9Flch1nekraOk5VK4jUyU7SHI85E7EmyMTiHwaKyAtRmDHVQcssO2fX
	 Ach4S3wI0ii7XI56QG22+XolqedRLmHs8F7xUU5h+1jaNOakURBZiFUbe3/AjXNhtf
	 90w7YtmZCNu30Y4zwswERHiX3wwORAIkZc9H7vG4zqh3osKjnDx1wJXSJ9CQNozX7Y
	 CxfBtEgZq1XQLUROq6YUC5Evn826yx73NJiH9Bfho0oFjLkunxbYECfrFt/3C+nude
	 MeFKdqfxtfBUMkmv9PgQxrJZ7ZF2Bqx0qy1azdXcQOTnYEkfDt2PfaRR09bUMgbsNw
	 kmDy+MxuZVjOA==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Maor Dickman <maord@nvidia.com>
Subject: [net-next 06/15] net/mlx5e: E-Switch, Allow get vport api if esw exists
Date: Fri, 19 May 2023 10:55:48 -0700
Message-Id: <20230519175557.15683-7-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519175557.15683-1-saeed@kernel.org>
References: <20230519175557.15683-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Roi Dayan <roid@nvidia.com>

We could have an esw manager device which is not a vport group manager.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index bf97a593d1d4..692cea3a6383 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -92,7 +92,7 @@ mlx5_eswitch_get_vport(struct mlx5_eswitch *esw, u16 vport_num)
 {
 	struct mlx5_vport *vport;
 
-	if (!esw || !MLX5_CAP_GEN(esw->dev, vport_group_manager))
+	if (!esw)
 		return ERR_PTR(-EPERM);
 
 	vport = xa_load(&esw->vports, vport_num);
-- 
2.40.1


