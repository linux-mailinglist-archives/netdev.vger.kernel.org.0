Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1621549D21D
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 19:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244293AbiAZS5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 13:57:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48766 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239299AbiAZS5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 13:57:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D01CB81FBD;
        Wed, 26 Jan 2022 18:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73E1C340E3;
        Wed, 26 Jan 2022 18:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643223431;
        bh=Ed9EwkKbLgkBdFkWEQD73AJ85rJ7TgyaO0y55goyRkA=;
        h=From:To:Cc:Subject:Date:From;
        b=BASYHkuOLJuIvRQTfsPbFJ10Uk+xb3ut/d89pSmAGk303tHxdsOttKe75+cWbAo7h
         CmuRlokUZFSItjq0iRENeko8e8XCIMN4h41Q14oK1K4ZWtBx8MZYT+tIXDQim8IrLk
         JNO0WGDPNV0n4+u0xU1s14cyEnY6FRRlVtAV7lYNxmmoHRodUgiDVApzDDIDyPihrf
         I70Gdz7C5ABcr6oxgZuax2PaVkkMr/33WYBNNWdp5Cpa9D3NXhWb77ayx9RrvF6SKU
         JxdBlIo/W5X5rRSnPBBvPWmyLfnCy/mg4ShQSAgR5Z1yx5ki99fHs+1CNhNz+IYmjW
         rPRekERdnrHEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, tariqt@nvidia.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] mlx5: remove usused static inlines
Date:   Wed, 26 Jan 2022 10:57:07 -0800
Message-Id: <20220126185707.2787329-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5 has some unused static inline helpers in include/
while at it also clean static inlines in the driver itself.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
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
2.34.1

