Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0549E5FD57F
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiJMHVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 03:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJMHVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 03:21:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07B5EB756;
        Thu, 13 Oct 2022 00:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC2BA616DB;
        Thu, 13 Oct 2022 07:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9B5C433C1;
        Thu, 13 Oct 2022 07:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665645666;
        bh=4Qg/4YlRRt7iol1x7LUDGs9R5uxzJP8b7ENofNmE/DI=;
        h=From:To:Cc:Subject:Date:From;
        b=oWSBG0s4B1XMobz5kBptwR16cM43AD+TQP/SfojdpdnMp2aGcLYeqFA3dp8r7++xu
         pj9DdMsonfZWCEQ59RH1Ixjs/+HHDNw9MtKXGUh7hmmEW/YmT6aac6bi7InNhLQZvt
         uIjBfQaln8c+fIvlAgM6z7oK0P3CS5nttJBkwHh1Etq5U+s10pqMWJu9tYPJYMo8xb
         f+FxybFYJ2IxTvS3ZOTHYWvd54u8WNMoc6XHz+3Fzc/x3z3yWuPeq9NOaB8lzaEfO2
         BEni37BdMkoQxjugmI83UYANEHbqNmhaaTDKvCLgVEwiaUtv2UX8OLXo0w2QbDiHnX
         41MjgDEbCJ0Xg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx5e: Cleanup MACsec uninitialization routine
Date:   Thu, 13 Oct 2022 10:21:00 +0300
Message-Id: <b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
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

From: Leon Romanovsky <leonro@nvidia.com>

The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
doesn't support MACsec (priv->macsec will be NULL) together with useless
comment line, assignment and extra blank lines.

Fix everything in one patch.

Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 41970067917b..4331235b21ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1846,25 +1846,16 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 void mlx5e_macsec_cleanup(struct mlx5e_priv *priv)
 {
 	struct mlx5e_macsec *macsec = priv->macsec;
-	struct mlx5_core_dev *mdev = macsec->mdev;
+	struct mlx5_core_dev *mdev = priv->mdev;
 
 	if (!macsec)
 		return;
 
 	mlx5_notifier_unregister(mdev, &macsec->nb);
-
 	mlx5e_macsec_fs_cleanup(macsec->macsec_fs);
-
-	/* Cleanup workqueue */
 	destroy_workqueue(macsec->wq);
-
 	mlx5e_macsec_aso_cleanup(&macsec->aso, mdev);
-
-	priv->macsec = NULL;
-
 	rhashtable_destroy(&macsec->sci_hash);
-
 	mutex_destroy(&macsec->lock);
-
 	kfree(macsec);
 }
-- 
2.37.3

