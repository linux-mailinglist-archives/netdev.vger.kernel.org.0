Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77F06C1F06
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCTSHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCTSGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:06:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA74A3B3DA
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1A451CE13A0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E7DC433EF;
        Mon, 20 Mar 2023 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334711;
        bh=rdnVQA2s/tshIQrkCmazQo7f3hHijqtswzNrkWPMmcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhjORTvfeTqvwcp+MeLynANT42HYHLv2hHuXvbVCJ8JJEJ1r6mbiPzHD0eu+frd5H
         apw6e4Yi6hZen6NQcDxOXmThxKYYOU010etUCFLaJYO1cOjgNzVcJZJgJUIv4+rtNq
         hAjMY+4tL36PYKvbplUqrG29NH0ZBz1Drgbf49juXbOZlCXqKx3cl5r1OwgJD7aa6l
         TkfhdMTM/K956Fka3iIoBJnsfqtTcrg//rK4hhqq3tp0WFXoNuWOGLt+axV5y7UDrr
         KrOFPZ34+aBsCFHyb6uLExmtHTTLqhYLdcx+L09F59KepmOsI3j1b5DmfwNX4Sicr9
         9U3CtV8uBdEaQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [net-next 05/14] net/mlx5: Fix wrong comment
Date:   Mon, 20 Mar 2023 10:51:35 -0700
Message-Id: <20230320175144.153187-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
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
2.39.2

