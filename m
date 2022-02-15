Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DEB4B6381
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 07:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiBOGcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 01:32:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234434AbiBOGcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 01:32:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F0BAEF28
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 22:32:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BBA361515
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3763AC340F1;
        Tue, 15 Feb 2022 06:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644906756;
        bh=ryMP4CVPx6sfA37ZBcok60ToMeL3+KEE6QaiMnAKOos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ojcfw6EWox7mbUwatjjEdKODBohAn9pwWdeA1oocf2zRXkiRLItb0JQyPJ/4RzqJS
         kRSVTEpiAjhMBQEn7GkK+rrrWogNjd5QX1iBnFsCYKYVyAUT6OkwScunj7c7++nar1
         5iajfEuBXvh7ilbO5NqGXsUgdfWGEB1xYpzucqO+xE/vixQ06koci7NSwLiHJtZILm
         96x6mvk9IMmFmmh7Ogk3U7TTWHmYPY3PyA7KOJQQ4g7S4b5bdkeKQevFV2JhUkkiUs
         GZgl3IMQkrfFC5DRjHYyx3v2zl8rHZOz7h/lSJupmVvPRqksNMGlQpAYjbWLtCAZpb
         7HKVYoB4eX3Sw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: Remove unused tstamp SQ field
Date:   Mon, 14 Feb 2022 22:32:15 -0800
Message-Id: <20220215063229.737960-2-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215063229.737960-1-saeed@kernel.org>
References: <20220215063229.737960-1-saeed@kernel.org>
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

Remove tstamp pointer in mlx5e_txqsq as it's no longer used after
commit 7c39afb394c7 ("net/mlx5: PTP code migration to driver core section").

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c14e06ca64d8..1389fd91321b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -432,7 +432,6 @@ struct mlx5e_txqsq {
 	__be32                     mkey_be;
 	unsigned long              state;
 	unsigned int               hw_mtu;
-	struct hwtstamp_config    *tstamp;
 	struct mlx5_clock         *clock;
 	struct net_device         *netdev;
 	struct mlx5_core_dev      *mdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 82baafd3c00c..ad4e5e759426 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -195,7 +195,6 @@ static int mlx5e_ptp_alloc_txqsq(struct mlx5e_ptp *c, int txq_ix,
 	int node;
 
 	sq->pdev      = c->pdev;
-	sq->tstamp    = c->tstamp;
 	sq->clock     = &mdev->clock;
 	sq->mkey_be   = c->mkey_be;
 	sq->netdev    = c->netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bf80fb612449..31eab1ef14b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1313,7 +1313,6 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	int err;
 
 	sq->pdev      = c->pdev;
-	sq->tstamp    = c->tstamp;
 	sq->clock     = &mdev->clock;
 	sq->mkey_be   = c->mkey_be;
 	sq->netdev    = c->netdev;
-- 
2.34.1

