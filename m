Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906445DBD38
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbiIUSLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiIUSLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:11:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CC658DF7
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B347CB83275
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C86EC433D7;
        Wed, 21 Sep 2022 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663783864;
        bh=T7yqwD4NLnvRaMYs3VeGuXfjFGlYgjE2VbKtRMujwOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5iMIMFxXcpZirKWP3UphHeDJs8Q5hcoeEYZ8yee/Gn2MtN33Bjss3dOSCNRpQUzn
         /uxEMPInaVOJhiWLHc0RIDE3FHRVouwDQd17W3cu3AsZhCeXjfQpDwbiIok0eArZIV
         AgGMrwx94JBzZC+y25Q5/3LTIa1ft7hbGYkmgyT+Ru91S1FPtI4gUEMhZjY7JXwK/P
         HSvaE0Rh9xFf4MHJPkQrkPP7SQSUln3qpk7Bf9CcHgLSmi6hjDVA/hck7JgGuSnkF0
         Sb1KTYiYoN1joWm+u3sOfIDKqBjt0RbR9p0g67Z2Di8KinMPtNQW0SMvNCHI/MfDcD
         +Jja1joRE43sA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V3 06/10] net/mlx5e: Expose memory key creation (mkey) function
Date:   Wed, 21 Sep 2022 11:10:50 -0700
Message-Id: <20220921181054.40249-7-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921181054.40249-1-saeed@kernel.org>
References: <20220921181054.40249-1-saeed@kernel.org>
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

