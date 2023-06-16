Return-Path: <netdev+bounces-11597-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E0B733A94
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C531F280F23
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240351F178;
	Fri, 16 Jun 2023 20:11:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B771ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BBCC433D9;
	Fri, 16 Jun 2023 20:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946300;
	bh=kcmaIcIlaivhHFwOLz58fm7YHzehvsBw5ALsGJ9zK4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iL9i1vmXwFPU+nUGsdJEfTEGclzdHG1nSOERfoJF9Jox26ALC1wefxY/UhbOeg1IV
	 sIlHy6WKGeWBN155+JTvDVg2NdSyv1w3zNdkjWV2uYQLfUkpzp/o9rvsIB3Bzcedy6
	 bS3CAM5YlxNsfIz+1ttielNU6BEQArA1ZNy/EEX0kiHUapHAeU3M6w5wueuD7CSCkY
	 mACNoS3SrHF8c3rGLZXtXPDTDO+P9BY5IEaNyXY4Q/xzukaOsb5rl8ONUxYx3UMLzD
	 791NLbUtT0qvd25458i3nmIVDjCELl1gp/N4fMQK07DqUY2prMuHO4aArHfdUgmreS
	 7pFJXSdsip3yg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [net-next 08/15] net/mlx5: E-Switch, remove redundant else statements
Date: Fri, 16 Jun 2023 13:11:06 -0700
Message-Id: <20230616201113.45510-9-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

These else statement blocks are redundant since the if block already
jumps to the function abort label.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index fabe49a35a5c..255bc8b749f9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -285,9 +285,8 @@ static int _mlx5_eswitch_set_vepa_locked(struct mlx5_eswitch *esw,
 	if (IS_ERR(flow_rule)) {
 		err = PTR_ERR(flow_rule);
 		goto out;
-	} else {
-		esw->fdb_table.legacy.vepa_uplink_rule = flow_rule;
 	}
+	esw->fdb_table.legacy.vepa_uplink_rule = flow_rule;
 
 	/* Star rule to forward all traffic to uplink vport */
 	memset(&dest, 0, sizeof(dest));
@@ -299,9 +298,8 @@ static int _mlx5_eswitch_set_vepa_locked(struct mlx5_eswitch *esw,
 	if (IS_ERR(flow_rule)) {
 		err = PTR_ERR(flow_rule);
 		goto out;
-	} else {
-		esw->fdb_table.legacy.vepa_star_rule = flow_rule;
 	}
+	esw->fdb_table.legacy.vepa_star_rule = flow_rule;
 
 out:
 	kvfree(spec);
-- 
2.40.1


