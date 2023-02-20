Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2099369C541
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjBTGRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjBTGRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B91EFB9
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9BC060C79
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2348CC433D2;
        Mon, 20 Feb 2023 06:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873818;
        bh=xqoO9rp8pv1WyjAAkybRvNHntbUFUd7tSr62vx1y8q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCBfcQ/FATup7t06IcCasjDZA5oB6MlnfffCMwX4l6awXKaope1/viWq2PN+ro7AT
         QDlLS6VKvBMqMx0DbQrWpa8o3mz+hoqhgvqYoPW9ckZUQkXFqk7UX/WgguYSrWW/2X
         +MlWeOwSpAF52yDIPASzHtMBpxaOP2O6xbBxnmOm3tfUpC2kNd8uLAaQsovZbBpIzM
         LfbrdQoPjm7w5AVzNU/t2aDITXHPKFsKC0FagkAksfIzx2KvQkQVP4CSyG0zcXTz2z
         bdXH5fFP82d1QCPFUAbaBxqLXUCHmAGhdrnB6VUg1i/oge8ampMbKAZaSfdAlVG06g
         xGFqd4afxt3JQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 05/14] net/mlx5: Fix wrong comment
Date:   Sun, 19 Feb 2023 22:14:33 -0800
Message-Id: <20230220061442.403092-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
2.39.1

