Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B96EA142
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbjDUBvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbjDUBvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C77D4C20
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:51:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3695761D5A
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A19EC433D2;
        Fri, 21 Apr 2023 01:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041894;
        bh=7xTHmC2bsCaai6a2Ee8RGxm+h6mDGNLrqhfTY/mlG8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFP1KKMeuCA7Oz8mfutVVmnwKu/T9BSq1PURSR193SZIIzFqIrskXloJmrI8KAsbF
         V575virGCDrZ5XYgL0Gz/2hkvhq8FNdBR/OcTVhv+yw+ElZCTJxzY49ztAOrmCohgt
         OY5a85LPFlycWvJMSJnNHofV4St764IAIRfOP3PA2jUf8jdnOAaqOponvfKhMsxBwa
         iNxfuLrzKQQ8U2mx5BZWBut5TUbU9qjQe23vgHM1NtxjdmZRN3QbP7EUM/4iZJrm5V
         IsjYheEwZIAu96l4Rxln2eG7TRCPvvEGM/xDlpQ1+orfcni1bDXU0pqjNxyaJzEb80
         QnI+5TzNHJnTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>
Subject: [net V2 07/10] Revert "net/mlx5: Remove "recovery" arg from mlx5_load_one() function"
Date:   Thu, 20 Apr 2023 18:50:54 -0700
Message-Id: <20230421015057.355468-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421015057.355468-1-saeed@kernel.org>
References: <20230421015057.355468-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

This reverts commit 5977ac3910f1cbaf44dca48179118b25c206ac29.

Revert this patch as we need the "recovery" arg back in mlx5_load_one()
function. This arg will be used in the next patch for using recovery
timeout during sync reset flow.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c  | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 4c2dad9d7cfb..289e915def98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -167,7 +167,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
-			mlx5_load_one(dev);
+			mlx5_load_one(dev, false);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f1de152a6113..ad90bf125e94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1509,13 +1509,13 @@ int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery)
 	return err;
 }
 
-int mlx5_load_one(struct mlx5_core_dev *dev)
+int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery)
 {
 	struct devlink *devlink = priv_to_devlink(dev);
 	int ret;
 
 	devl_lock(devlink);
-	ret = mlx5_load_one_devl_locked(dev, false);
+	ret = mlx5_load_one_devl_locked(dev, recovery);
 	devl_unlock(devlink);
 	return ret;
 }
@@ -1912,7 +1912,8 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	mlx5_pci_trace(dev, "Enter, loading driver..\n");
 
-	err = mlx5_load_one(dev);
+	err = mlx5_load_one(dev, false);
+
 	if (!err)
 		devlink_health_reporter_state_update(dev->priv.health.fw_fatal_reporter,
 						     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
@@ -2003,7 +2004,7 @@ static int mlx5_resume(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	return mlx5_load_one(dev);
+	return mlx5_load_one(dev, false);
 }
 
 static const struct pci_device_id mlx5_core_pci_table[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index be0785f83083..a3c5c2dab5fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -321,7 +321,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool suspend);
 void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend);
-int mlx5_load_one(struct mlx5_core_dev *dev);
+int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
 int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 function_id,
-- 
2.39.2

