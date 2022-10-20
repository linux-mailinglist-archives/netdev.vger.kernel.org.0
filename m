Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E9B6056C6
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 07:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJTF2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 01:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJTF2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 01:28:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DBB192DA9
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 22:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2683B82618
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E218FC433C1;
        Thu, 20 Oct 2022 05:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666243713;
        bh=8HpxITCOvkzcIWdrilsG8OpUvYsdFZKUtBabbDDqzYU=;
        h=From:To:Cc:Subject:Date:From;
        b=smabr43oyBDB/1MsEoMxCPtyr7j2Zn1bciYibx/wgB8BaXMkIP/uG1pitAhpgeYd9
         MrnzFn9M5SNybM+Qgbpna0l6gR++TFKnCqfxQjBHvpPo0K+jmAEt30L61xEa9LDkbV
         TedjW1r4WCQD5mCT3+dQrhkmvGWp2rGE24D8cqlZw7MWAafM4QKb13r47wxL+jYm9l
         C2bHp0wXGdyj+E1ILEM2b83X44sjV8gNqWdHXF9xdZQCYlvytkJ+sFf/CeTOEArQAM
         PZiZbyBw72hMCrnzg04GWgV8kpsfggKVdqVogTmREYruJRJ9hvXHJgZsQ/3G7pnYtX
         14mKw3YzDOPFQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net v1] net/mlx5e: Cleanup MACsec uninitialization routine
Date:   Thu, 20 Oct 2022 08:28:28 +0300
Message-Id: <186d1af058b29186f7eaefbdc91b16c84111dcf1.1666243464.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The mlx5e_macsec_cleanup() routine has NULL pointer dereferencing if mlx5
device doesn't support MACsec (priv->macsec will be NULL).

While at it delete comment line, assignment and extra blank lines, so fix
everything in one patch.

Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changelog:
v1: 
 * Fixed commit message 
v0: https://lore.kernel.org/all/4bd5c6655c5970ac30adb254a1f09f4f5e992158.1666159448.git.leonro@nvidia.com
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

