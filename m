Return-Path: <netdev+bounces-9776-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 827C872A7C7
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 389BB281B07
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE92D311;
	Sat, 10 Jun 2023 01:43:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19599C14C
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BE1C43443;
	Sat, 10 Jun 2023 01:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361402;
	bh=eI4zq24/7AMG6A6328sOGb83vfkqC3nEDDV4ul9VODY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2xOE7C/fX4d3cx3/zYupXPkqEGF/R9ts8YhF00hx3Vh1DQdP0hfLGJK3qxzb/WOb
	 76qBPeCfKdzRntj/Fx4fCpdfyOhi2+dnqkntoGwhpXLT/A1dnIe1tKWQsNynpIHKAl
	 5ZCk3gpgxgYWD9awWQLbkI8aRCExEp3i4+fHStJ385+22Qa+16wEbeUEEbURSV4tPf
	 GcpcIBLktuT/gMddPWSHkePRJJFsRUsKwxs344skVZuz/hSvK6ADn6LvxCd0tRTIYI
	 KGF90DbT7+WoS2Bjz/03WqX+wXPnxS96kfJTP5vzpEfnmANXoDczuW5Y7cuAnEFhuR
	 8mcUZpuY5oJRQ==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>
Subject: [net-next 15/15] net/mlx5e: Remove a useless function call
Date: Fri,  9 Jun 2023 18:42:54 -0700
Message-Id: <20230610014254.343576-16-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'handle' is known to be NULL here. There is no need to kfree() it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index 0290e0dea539..4e923a2874ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -112,10 +112,8 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *po
 	int err;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (!handle) {
-		kfree(handle);
+	if (!handle)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	post_attr->chain = 0;
 	post_attr->prio = 0;
-- 
2.40.1


