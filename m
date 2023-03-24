Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B836C8918
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjCXXOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjCXXOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBAF1E1D9
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68B0CB82662
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A20DC4339B;
        Fri, 24 Mar 2023 23:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699635;
        bh=1sjJusr5d747AN+IuI7iwpxpeDyv0U46C5gRi54lnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZfwvulDaNuECJXgLSnGErnf0MV+1vDO1mPkqbMEiN3aqBD0Y1EGgZnmnUPXjMrgd
         G/fL0ejzDPMlYgPbr72ILitL8+c4JeuEusENmCHk24FgBGM7TY4gEqdNF5oxeHcE0d
         Sf+lqcpyQkQyLLLyjYDyr8XUVSM5JBN5CHjx/g+rd6xXzwAJLoXStoB1flociL7pjh
         UqipnSoUJK9wK1/Og4gCuluq96fAmTt5PzyeWxkwZGox9mQ2wWu1QEwYxDDQYNiBID
         dlzqfefuiZQ2k3m9s+x6HscjIEvXM4bkHqLJhuz7+lWFWH9MKJ7HA14S6wRyJ7f5LK
         rFaXs78/oETAA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Cohen <elic@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next V2 05/15] net/mlx5: Fix wrong comment
Date:   Fri, 24 Mar 2023 16:13:31 -0700
Message-Id: <20230324231341.29808-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

A control irq may be allocated from the parent device's pool in case
there is no SF dedicated pool. This could happen when there are not
enough vectors available for SFs.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 6bde18bcd42f..c72736f1571f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -394,7 +394,9 @@ struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
 		return ERR_PTR(-ENOMEM);
 	cpumask_copy(req_mask, cpu_online_mask);
 	if (!mlx5_irq_pool_is_sf_pool(pool)) {
-		/* In case we are allocating a control IRQ for PF/VF */
+		/* In case we are allocating a control IRQ from a pci device's pool.
+		 * This can happen also for a SF if the SFs pool is empty.
+		 */
 		if (!pool->xa_num_irqs.max) {
 			cpumask_clear(req_mask);
 			/* In case we only have a single IRQ for PF/VF */
-- 
2.39.2

