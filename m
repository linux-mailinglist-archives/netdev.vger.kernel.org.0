Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE45B51FF
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiIKXlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiIKXlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAB82716E
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B066113A
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C684DC433C1;
        Sun, 11 Sep 2022 23:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939697;
        bh=T7yqwD4NLnvRaMYs3VeGuXfjFGlYgjE2VbKtRMujwOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oqx8TCMylH7NkrC/KzjWz+kbXObMQMHzGZWTw1ve+tD16Sf9xGuC95K1Z+oHRKuQu
         Jwv08g2ZGTsLQZwiZdwtIqBbnThlJYoOgkya6fVAMa/VdzTQt4yLHSQl+wNAOSXn0s
         +QuxgtSdnYdg3WP9zx2BW+dXSIzaHFRAZWOjcJ6qIX5QXUYIo/+0+XSkpPCUUSaS7M
         LxMKI+OO42fPPTd5a56+DT+66L+1rBWT5AVrijskl6AIcgWYMJfVilp9EbxbLh0W7Q
         04tXIjV4KnAO7ksIaM5eJOqZHyJ9zgoYTPSv3PS5CT+CsCcL9E+fjTVaQk3UGqSJX3
         +gdOdQUPltgxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next 06/10] net/mlx5e: Expose memory key creation (mkey) function
Date:   Mon, 12 Sep 2022 00:40:55 +0100
Message-Id: <20220911234059.98624-7-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911234059.98624-1-saeed@kernel.org>
References: <20220911234059.98624-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Expose mlx5e_create_mkey function, for future patches in the
macsec series to use.
The above function creates a memory key which describes a
region in memory that can be later used by both HW and SW.
The counterpart destroy functionality is already exposed.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 13aac5131ff7..648a178e8db8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1134,6 +1134,7 @@ static inline bool mlx5_tx_swp_supported(struct mlx5_core_dev *mdev)
 
 extern const struct ethtool_ops mlx5e_ethtool_ops;
 
+int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey);
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev);
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev);
 int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index c0f409c195bf..68f19324db93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -46,8 +46,7 @@ void mlx5e_mkey_set_relaxed_ordering(struct mlx5_core_dev *mdev, void *mkc)
 	MLX5_SET(mkc, mkc, relaxed_ordering_write, ro_pci_enable && ro_write);
 }
 
-static int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn,
-			     u32 *mkey)
+int mlx5e_create_mkey(struct mlx5_core_dev *mdev, u32 pdn, u32 *mkey)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
 	void *mkc;
-- 
2.37.3

