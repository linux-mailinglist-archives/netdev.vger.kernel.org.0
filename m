Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170554C1FFF
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 00:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243639AbiBWXkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 18:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244974AbiBWXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 18:40:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1C95B89D;
        Wed, 23 Feb 2022 15:39:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5BFA3CE1CE5;
        Wed, 23 Feb 2022 23:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B17C340EB;
        Wed, 23 Feb 2022 23:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645659577;
        bh=qGz7EbQ53bmHTgG9hRn74lRJirmYcVm7oKU8gQeCHYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lo2sPg5wVS3ZFRrE98VjbGb1qWnEabhMaId1yrWW0672yPj1rPLLFB0dTC6bKo3hM
         D43vSpt0rw6nl9cZwX1hvQQkxCnvIJToF4IIzECUrC9234FIONKyzw9GJEYo2FgtpC
         6gZuX0WJQz5WITM9gSBjb6To0x2YFvmOtRivGESCDydMbZgQULGKiCPhs/cZfjprsj
         uCYgYFhiQwMJW6QpvMcPLYP0ykDffqCIHH7sLQWysOMiCF3bfMFUJdsDMYRPFZKyAZ
         ssFH4CPfus0aVX4zPti5I25/E2u+9Vbl9bfUi+MPWdQ2oBgqAURGBQ9ikrSjhTeSAD
         CQocn6iyEwpYQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [for-next v2 01/17] mlx5: remove unused static inlines
Date:   Wed, 23 Feb 2022 15:39:14 -0800
Message-Id: <20220223233930.319301-2-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

mlx5 has some unused static inline helpers in include/
while at it also clean static inlines in the driver itself.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/en_accel.h    |  9 ---------
 drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  |  7 -------
 include/linux/mlx5/driver.h                            | 10 ----------
 3 files changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index d964665eaa63..62cde3e87c2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -139,15 +139,6 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 	return true;
 }
 
-static inline bool mlx5e_accel_tx_is_ipsec_flow(struct mlx5e_accel_tx_state *state)
-{
-#ifdef CONFIG_MLX5_EN_IPSEC
-	return mlx5e_ipsec_is_tx_flow(&state->ipsec);
-#else
-	return false;
-#endif
-}
-
 static inline unsigned int mlx5e_accel_tx_ids_len(struct mlx5e_txqsq *sq,
 						  struct mlx5e_accel_tx_state *state)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
index 4bad6a5fde56..f240ffe5116c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h
@@ -92,13 +92,6 @@ mlx5_hv_vhca_agent_create(struct mlx5_hv_vhca *hv_vhca,
 static inline void mlx5_hv_vhca_agent_destroy(struct mlx5_hv_vhca_agent *agent)
 {
 }
-
-static inline int
-mlx5_hv_vhca_write_agent(struct mlx5_hv_vhca_agent *agent,
-			 void *buf, int len)
-{
-	return 0;
-}
 #endif
 
 #endif /* __LIB_HV_VHCA_H__ */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 78655d8d13a7..1b398c9e17b9 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -863,20 +863,10 @@ struct mlx5_hca_vport_context {
 	bool			grh_required;
 };
 
-static inline void *mlx5_buf_offset(struct mlx5_frag_buf *buf, int offset)
-{
-		return buf->frags->buf + offset;
-}
-
 #define STRUCT_FIELD(header, field) \
 	.struct_offset_bytes = offsetof(struct ib_unpacked_ ## header, field),      \
 	.struct_size_bytes   = sizeof((struct ib_unpacked_ ## header *)0)->field
 
-static inline struct mlx5_core_dev *pci2mlx5_core_dev(struct pci_dev *pdev)
-{
-	return pci_get_drvdata(pdev);
-}
-
 extern struct dentry *mlx5_debugfs_root;
 
 static inline u16 fw_rev_maj(struct mlx5_core_dev *dev)
-- 
2.35.1

