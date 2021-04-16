Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4B0362811
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbhDPSzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235944AbhDPSzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29864613C1;
        Fri, 16 Apr 2021 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599280;
        bh=aZyP5isp+KOUA8KNShIUZ5D9DRHVfOL44iQfJDbihlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVhCt2hjExPqRbGa1O0UeZrHnY1c2iVlMtrCl4RV6GLrYRRuYidPpuhfedta1fIHL
         wrJRqB6wLGm77XxTSd5PWXtY+U0kvjbs8EDP5HMG7e0djqTTm8E1LtDPNtC+2pauPh
         IBgtT5T1fo4/K/i9Cg8ZcKtvgsTc5Bzd/3P3UU6IrjqFDEjUZuw6gUACdaOYfx/JUr
         Ykm72LJXa44qrIaUwqxjWLWlVF1aOBPoC7l8MEbTPo2TrJv8BwvaaENJzZRzYrTTON
         yXjQ0Jy2tDPrisbd9XFinVSNBFiDrn8jrAieHgX9AooQ/FfAQstjbAZmNF8/fqEc4/
         IqSQ3rzuPvTmg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/14] net/mlx5e: Cleanup unused function parameter
Date:   Fri, 16 Apr 2021 11:54:18 -0700
Message-Id: <20210416185430.62584-3-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Socket parameter is not used in accel_rule_init(), remove it.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 8c0f78c09215..76fd4b230003 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -119,8 +119,7 @@ static void accel_rule_handle_work(struct work_struct *work)
 	complete(&priv_rx->add_ctx);
 }
 
-static void accel_rule_init(struct accel_rule *rule, struct mlx5e_priv *priv,
-			    struct sock *sk)
+static void accel_rule_init(struct accel_rule *rule, struct mlx5e_priv *priv)
 {
 	INIT_WORK(&rule->work, accel_rule_handle_work);
 	rule->priv = priv;
@@ -618,7 +617,7 @@ int mlx5e_ktls_add_rx(struct net_device *netdev, struct sock *sk,
 
 	init_completion(&priv_rx->add_ctx);
 
-	accel_rule_init(&priv_rx->rule, priv, sk);
+	accel_rule_init(&priv_rx->rule, priv);
 	resync = &priv_rx->resync;
 	resync_init(resync, priv);
 	tls_offload_ctx_rx(tls_ctx)->resync_async = &resync->core;
-- 
2.30.2

