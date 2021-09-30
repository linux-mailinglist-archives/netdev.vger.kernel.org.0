Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C27741E4A5
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350253AbhI3XRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350131AbhI3XQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3DAE61A7B;
        Thu, 30 Sep 2021 23:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043707;
        bh=uK0TED/slbDPKKBJrmqWq7WOWEg2HyYNgAUqn5eSdZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLC2srA42nhXwv0e3fJfZe9MpX2naoXtE8C3EaPyeFvUfc2dRreiaaIU9l544k9zE
         DKrY/Eqfwje2AIZg6Zcv48Ory0Nkc2I1WTXYrsNyEZt01XGGmThjqRo0qQceoVO/mO
         MkIF+535ElcqCEmoO2kaGlBk8JUBTwmogv3aap9n/iHnXQ/DOhCnJuJvu27oTp0mX+
         DRrXWZdSNbTZyEyGutgidOk1RZc+rRV1wz41oG/IBQdJf+Ayv2pRGlQFebEyzxDlzX
         K+1HFu5FmB8/2iLjeaWM4/HVkkfkL6ibppijCfPsRXyccRdRUhJA0A9Ilx8YJvc1we
         mo6cUv/smAQ6w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/10] net/mlx5: Fix length of irq_index in chars
Date:   Thu, 30 Sep 2021 16:14:58 -0700
Message-Id: <20210930231501.39062-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930231501.39062-1-saeed@kernel.org>
References: <20210930231501.39062-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

The maximum irq_index can be 2047, This means irq_name should have 4
characters reserve for the irq_index. Hence, increase it to 4.

Fixes: 3af26495a247 ("net/mlx5: Enlarge interrupt field in CREATE_EQ")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index c79a10b3454d..df54f62a38ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -13,8 +13,8 @@
 #endif
 
 #define MLX5_MAX_IRQ_NAME (32)
-/* max irq_index is 255. three chars */
-#define MLX5_MAX_IRQ_IDX_CHARS (3)
+/* max irq_index is 2047, so four chars */
+#define MLX5_MAX_IRQ_IDX_CHARS (4)
 
 #define MLX5_SFS_PER_CTRL_IRQ 64
 #define MLX5_IRQ_CTRL_SF_MAX 8
-- 
2.31.1

