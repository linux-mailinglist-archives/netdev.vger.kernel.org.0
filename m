Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0BC69C543
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjBTGRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjBTGRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28714F75D
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9CE660C79
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E79C433EF;
        Mon, 20 Feb 2023 06:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873821;
        bh=i7zaMP+ch0sCZbF0f2V+TLmMpcRhSRVMEiOrzxdtrKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsICrcgl42dI05PnxzkFnwKUZi8NVjoNxDU95u6EMyo8gBCxhB5t3irUYrH22YGwc
         iGLvsGjhaM7vV/oJ4x7z+tCQ3YCH7CPdx5P6VTETwWJoWMJ/kt+DL/ZyT4kXSB6Q6K
         5g+8kiHjf8iGm3MZM7jYhs/cirFX4NO/KSX0C+GCXVHQyUHmAnEHx1e8rZk6Y9L2T2
         v78aQ7yal/TzPbUL9krDwNq+Zb9JK9PbNrifLGsALkX3ijbr2thAeLmzQugjHRgo7q
         JT6i7phraqvlFQYXtXHcKCCxjGTu8U6Fp1mwRpbfS8ga0y9cyzk4vDzSZVxlWxyZCd
         WCuEM4WQilKRg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 08/14] net/mlx5: Improve naming of pci function vectors
Date:   Sun, 19 Feb 2023 22:14:36 -0800
Message-Id: <20230220061442.403092-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

The variable pf_vec is used to denote the number of vectors required for
the pci function's own use. To avoid confusion interpreting pf as
physical function, change the name to pcif_vec.

Same reasoning goes for pf_pool which is really pci function pool.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 46 +++++++++----------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index df6c2f8eb5df..c8e2b1ac7fe5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -33,7 +33,7 @@ struct mlx5_irq {
 };
 
 struct mlx5_irq_table {
-	struct mlx5_irq_pool *pf_pool;
+	struct mlx5_irq_pool *pcif_pool;
 	struct mlx5_irq_pool *sf_ctrl_pool;
 	struct mlx5_irq_pool *sf_comp_pool;
 };
@@ -337,7 +337,7 @@ struct mlx5_irq_pool *mlx5_irq_pool_get(struct mlx5_core_dev *dev)
 	/* In some configs, there won't be a pool of SFs IRQs. Hence, returning
 	 * the PF IRQs pool in case the SF pool doesn't exist.
 	 */
-	return pool ? pool : irq_table->pf_pool;
+	return pool ? pool : irq_table->pcif_pool;
 }
 
 static struct mlx5_irq_pool *ctrl_irq_pool_get(struct mlx5_core_dev *dev)
@@ -351,7 +351,7 @@ static struct mlx5_irq_pool *ctrl_irq_pool_get(struct mlx5_core_dev *dev)
 	/* In some configs, there won't be a pool of SFs IRQs. Hence, returning
 	 * the PF IRQs pool in case the SF pool doesn't exist.
 	 */
-	return pool ? pool : irq_table->pf_pool;
+	return pool ? pool : irq_table->pcif_pool;
 }
 
 /**
@@ -426,7 +426,7 @@ struct mlx5_irq *mlx5_irq_request(struct mlx5_core_dev *dev, u16 vecidx,
 	struct mlx5_irq_pool *pool;
 	struct mlx5_irq *irq;
 
-	pool = irq_table->pf_pool;
+	pool = irq_table->pcif_pool;
 	irq = irq_pool_request_vector(pool, vecidx, af_desc);
 	if (IS_ERR(irq))
 		return irq;
@@ -519,7 +519,7 @@ static void irq_pool_free(struct mlx5_irq_pool *pool)
 	kvfree(pool);
 }
 
-static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
+static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pcif_vec)
 {
 	struct mlx5_irq_table *table = dev->priv.irq_table;
 	int num_sf_ctrl_by_msix;
@@ -527,12 +527,12 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 	int num_sf_ctrl;
 	int err;
 
-	/* init pf_pool */
-	table->pf_pool = irq_pool_alloc(dev, 0, pf_vec, NULL,
-					MLX5_EQ_SHARE_IRQ_MIN_COMP,
-					MLX5_EQ_SHARE_IRQ_MAX_COMP);
-	if (IS_ERR(table->pf_pool))
-		return PTR_ERR(table->pf_pool);
+	/* init pcif_pool */
+	table->pcif_pool = irq_pool_alloc(dev, 0, pcif_vec, NULL,
+					  MLX5_EQ_SHARE_IRQ_MIN_COMP,
+					  MLX5_EQ_SHARE_IRQ_MAX_COMP);
+	if (IS_ERR(table->pcif_pool))
+		return PTR_ERR(table->pcif_pool);
 	if (!mlx5_sf_max_functions(dev))
 		return 0;
 	if (sf_vec < MLX5_IRQ_VEC_COMP_BASE_SF) {
@@ -546,7 +546,7 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 					  MLX5_SFS_PER_CTRL_IRQ);
 	num_sf_ctrl = min_t(int, num_sf_ctrl_by_msix, num_sf_ctrl_by_sfs);
 	num_sf_ctrl = min_t(int, MLX5_IRQ_CTRL_SF_MAX, num_sf_ctrl);
-	table->sf_ctrl_pool = irq_pool_alloc(dev, pf_vec, num_sf_ctrl,
+	table->sf_ctrl_pool = irq_pool_alloc(dev, pcif_vec, num_sf_ctrl,
 					     "mlx5_sf_ctrl",
 					     MLX5_EQ_SHARE_IRQ_MIN_CTRL,
 					     MLX5_EQ_SHARE_IRQ_MAX_CTRL);
@@ -555,7 +555,7 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 		goto err_pf;
 	}
 	/* init sf_comp_pool */
-	table->sf_comp_pool = irq_pool_alloc(dev, pf_vec + num_sf_ctrl,
+	table->sf_comp_pool = irq_pool_alloc(dev, pcif_vec + num_sf_ctrl,
 					     sf_vec - num_sf_ctrl, "mlx5_sf_comp",
 					     MLX5_EQ_SHARE_IRQ_MIN_COMP,
 					     MLX5_EQ_SHARE_IRQ_MAX_COMP);
@@ -577,7 +577,7 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 err_sf_ctrl:
 	irq_pool_free(table->sf_ctrl_pool);
 err_pf:
-	irq_pool_free(table->pf_pool);
+	irq_pool_free(table->pcif_pool);
 	return err;
 }
 
@@ -587,7 +587,7 @@ static void irq_pools_destroy(struct mlx5_irq_table *table)
 		irq_pool_free(table->sf_comp_pool);
 		irq_pool_free(table->sf_ctrl_pool);
 	}
-	irq_pool_free(table->pf_pool);
+	irq_pool_free(table->pcif_pool);
 }
 
 /* irq_table API */
@@ -618,9 +618,9 @@ void mlx5_irq_table_cleanup(struct mlx5_core_dev *dev)
 
 int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table)
 {
-	if (!table->pf_pool->xa_num_irqs.max)
+	if (!table->pcif_pool->xa_num_irqs.max)
 		return 1;
-	return table->pf_pool->xa_num_irqs.max - table->pf_pool->xa_num_irqs.min;
+	return table->pcif_pool->xa_num_irqs.max - table->pcif_pool->xa_num_irqs.min;
 }
 
 int mlx5_irq_table_create(struct mlx5_core_dev *dev)
@@ -629,16 +629,16 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 		      MLX5_CAP_GEN(dev, max_num_eqs) :
 		      1 << MLX5_CAP_GEN(dev, log_max_eq);
 	int total_vec;
-	int pf_vec;
+	int pcif_vec;
 	int err;
 
 	if (mlx5_core_is_sf(dev))
 		return 0;
 
-	pf_vec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() + 1;
-	pf_vec = min_t(int, pf_vec, num_eqs);
+	pcif_vec = MLX5_CAP_GEN(dev, num_ports) * num_online_cpus() + 1;
+	pcif_vec = min_t(int, pcif_vec, num_eqs);
 
-	total_vec = pf_vec;
+	total_vec = pcif_vec;
 	if (mlx5_sf_max_functions(dev))
 		total_vec += MLX5_IRQ_CTRL_SF_MAX +
 			MLX5_COMP_EQS_PER_SF * mlx5_sf_max_functions(dev);
@@ -646,9 +646,9 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
 	total_vec = pci_alloc_irq_vectors(dev->pdev, 1, total_vec, PCI_IRQ_MSIX);
 	if (total_vec < 0)
 		return total_vec;
-	pf_vec = min(pf_vec, total_vec);
+	pcif_vec = min(pcif_vec, total_vec);
 
-	err = irq_pools_init(dev, total_vec - pf_vec, pf_vec);
+	err = irq_pools_init(dev, total_vec - pcif_vec, pcif_vec);
 	if (err)
 		pci_free_irq_vectors(dev->pdev);
 
-- 
2.39.1

