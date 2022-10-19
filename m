Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C97E60398F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJSGGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiJSGGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:06:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C56165273
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D02D3B82223
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B474DC433D6;
        Wed, 19 Oct 2022 06:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666159609;
        bh=DwosMLpD7QCJKhicXe9oN971GNAA/zbCsFhKf3irEA4=;
        h=From:To:Cc:Subject:Date:From;
        b=IYiL3090PK++95hxIkoYUaBMm8Kj4BVC+Osz+ijqWI+jmG0Mb3KEpNO47Nh7Mtyh0
         jGoWnaksoVcWiFtaU4lwXqzXdis4r8sTGp9Ep4G+5DksWRWRSMh7CCwIrOBGFqaslA
         qd84y928vyJnYD3uor+JjeIbfeyk3JK6mQdawUk3JJX6Ni8dTS4NEReVNw5RG6YL4o
         ze404crOefLtJx4xdg5HcLyb5CSNxNoPjADd2OrTnuGnC6lFlcPzDvOv4FdtNST9lK
         iN7OirtH/HxuXDza9Nq/9otHfnuHtkqMF8t/tEmhCq4T2Auj2hpKo0bRd5OpAVWx+7
         tvtWsyifT+4tQ==
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
Subject: [PATCH RESEND net] net/mlx5e: Cleanup MACsec uninitialization routine
Date:   Wed, 19 Oct 2022 09:06:43 +0300
Message-Id: <4bd5c6655c5970ac30adb254a1f09f4f5e992158.1666159448.git.leonro@nvidia.com>
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

The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
doesn't support MACsec (priv->macsec will be NULL) together with useless
comment line, assignment and extra blank lines.

Fix everything in one patch.

Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Resend: https://lore.kernel.org/all/b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com
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

