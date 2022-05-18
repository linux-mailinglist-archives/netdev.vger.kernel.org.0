Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B38D52B2AC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiERGtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbiERGts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:49:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A63F22291
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AACF160BAA
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072F0C385AA;
        Wed, 18 May 2022 06:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856586;
        bh=uFXD2DJ88OYuZENDUQ9Gka4/8GgYgNIXrwQimUtDwSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJSXoQ3hn/wQb/8CskRe2/kiN3HyKat+sOV4hNxHR/xBw0VLfDbYzVPPn5fhwIxcO
         kmXDzzlVu/co6inSo2cuMYjV7wHLPeLROBmMbORTUVYxBbDGrTyGE/gnJYD53yLTk0
         UdYyzw3g88pSA1EkXF0aoZeEPmUxlHpDmsHsabrOt+nAlZLuCHxeD/laP9TVFhpCFF
         2qEBeifihMdwvjwrGd47CVFn2cgRmTWMJP39ANvz0z+J1G3Xo/hurRq5YR/PvZP5UF
         ruHroqO+ZTVnPqNRFsQJX/xZyb7TiO4Coclx/C1A0EOTHpJVW2q3NZ71BlTbUdk3c5
         U47v8MBu1FLug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/16] net/mlx5: Inline db alloc API function
Date:   Tue, 17 May 2022 23:49:25 -0700
Message-Id: <20220518064938.128220-4-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518064938.128220-1-saeed@kernel.org>
References: <20220518064938.128220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Take the wrapper version which picks default node into a header file.
This reduces the number of exported functions.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 6 ------
 include/linux/mlx5/driver.h                     | 7 ++++++-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
index e52b0bac09da..6aca004e88cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
@@ -213,12 +213,6 @@ int mlx5_db_alloc_node(struct mlx5_core_dev *dev, struct mlx5_db *db, int node)
 }
 EXPORT_SYMBOL_GPL(mlx5_db_alloc_node);
 
-int mlx5_db_alloc(struct mlx5_core_dev *dev, struct mlx5_db *db)
-{
-	return mlx5_db_alloc_node(dev, db, dev->priv.numa_node);
-}
-EXPORT_SYMBOL_GPL(mlx5_db_alloc);
-
 void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db)
 {
 	u32 db_per_page = PAGE_SIZE / cache_line_size();
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 74c8cfb771a2..b064bc278f52 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1053,9 +1053,14 @@ int mlx5_core_access_reg(struct mlx5_core_dev *dev, void *data_in,
 			 int size_in, void *data_out, int size_out,
 			 u16 reg_num, int arg, int write);
 
-int mlx5_db_alloc(struct mlx5_core_dev *dev, struct mlx5_db *db);
 int mlx5_db_alloc_node(struct mlx5_core_dev *dev, struct mlx5_db *db,
 		       int node);
+
+static inline int mlx5_db_alloc(struct mlx5_core_dev *dev, struct mlx5_db *db)
+{
+	return mlx5_db_alloc_node(dev, db, dev->priv.numa_node);
+}
+
 void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db);
 
 const char *mlx5_command_str(int command);
-- 
2.36.1

