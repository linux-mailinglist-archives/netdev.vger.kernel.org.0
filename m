Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC663E9773
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhHKSSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230089AbhHKSSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00E0060FE6;
        Wed, 11 Aug 2021 18:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705894;
        bh=89YPJ4EGHPXCq7j7fHVHeUCtMT9wTa+xUI56NX7e0Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XlF+T2F+XylpVXEgGcPBd7W94DTJm3+s1m+ERH2A5vpibmgJNAfNgVk8b2fK3+8zg
         FhvGUeWIv/lkXODcClwPhsBqcP78zT5MHp9Hlp+5bHEkbIRpbLl1+NxXP3uQ11kZLl
         qkQCZb5UGrffxB/EbKpn00CO/DF9g839z0PrNX2Bn+SEFQBU2I+dvALkQ0R4mGYEsv
         Pv7QWFPlTPFSTTOWVEB4EboEHFQYeau3tM3V9aBegbH2hda1XBh1UukE/afS0Nck6i
         Dbq1hE+roYbjsydb54akTsHuMJS0ZjPYXjlRfDfaWYLtmgeheZhZNgbKPGAzXJ61ah
         uKX2HQQXtxQ0w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/12] net/mlx5: Change SF missing dedicated MSI-X err message to dbg
Date:   Wed, 11 Aug 2021 11:16:51 -0700
Message-Id: <20210811181658.492548-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

When MSI-X vectors allocated are not enough for SFs to have dedicated,
MSI-X, kernel log buffer has too many entries.
Hence only enable such log with debug level.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index a4f6ba0c91da..717b9f1850ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -479,7 +479,7 @@ static int irq_pools_init(struct mlx5_core_dev *dev, int sf_vec, int pf_vec)
 	if (!mlx5_sf_max_functions(dev))
 		return 0;
 	if (sf_vec < MLX5_IRQ_VEC_COMP_BASE_SF) {
-		mlx5_core_err(dev, "Not enough IRQs for SFs. SF may run at lower performance\n");
+		mlx5_core_dbg(dev, "Not enught IRQs for SFs. SF may run at lower performance\n");
 		return 0;
 	}
 
-- 
2.31.1

