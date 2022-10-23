Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2F60951C
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 19:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiJWRXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 13:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJWRXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 13:23:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5D86F54D
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 10:23:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5666A60BC2
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 17:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA91C433C1;
        Sun, 23 Oct 2022 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666545783;
        bh=6r3kRiqEpfs5D7m4e6NanhnR05mK8qaFrDaM5Rf8fYo=;
        h=From:To:Cc:Subject:Date:From;
        b=XcyHN4HLkn5ondh8qeDwUpKiW94v5nZCEVLsx/uAViTwfzmCp4k/BE7DNxRpV8rPk
         wCLRGZz4EavW0wkbDCHtvraFHPT81c7NhjcgpG27m8vGmzx4ZZ1nMfYodqe13tug0M
         FZJvTafkmelUDD9KymiJZv6ICiEPQDgQb4fAL7BWyVSC/ZmXozYohwe2lE7LmExSBU
         0YP6XILTeEra9Ahh3CZRrFY+9ht4IUSjyZXtRhfWfCu+NbUIpNiNGidgguyYIP7RQw
         4yB3b/RRvXlHYs26HKWxup6s2fDpaF8XStO3iYAW7cZYANI2kJoByQ1MScD89RoSDy
         Y3oZFmTegjB9Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 0/6] Various cleanups for mlx5
Date:   Sun, 23 Oct 2022 20:22:52 +0300
Message-Id: <cover.1666545480.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is a batch of various cleanups which I collected during development
of mlx5 IPsec full offload support.

Thanks.

Leon Romanovsky (6):
  net/mlx5e: Support devlink reload of IPsec core
  net/mlx5: Return ready to use ASO WQE
  net/mlx5e: Don't access directly DMA device pointer
  net/mlx5e: Delete always true DMA check
  net/mlx5: Remove redundant check
  net/mlx5e: Use read lock for eswitch get callbacks

 .../ethernet/mellanox/mlx5/core/en/tc/meter.c   |  1 -
 .../mellanox/mlx5/core/en_accel/ipsec.c         | 17 ++++++++---------
 .../mellanox/mlx5/core/en_accel/ipsec.h         |  5 ++---
 .../mellanox/mlx5/core/en_accel/macsec.c        | 11 +++++------
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  8 +++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    | 13 +++++++------
 .../mellanox/mlx5/core/eswitch_offloads.c       | 12 ++++++------
 .../net/ethernet/mellanox/mlx5/core/lib/aso.c   | 10 +++++-----
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h   |  2 +-
 9 files changed, 37 insertions(+), 42 deletions(-)

-- 
2.37.3

