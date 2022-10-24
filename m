Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462B260B661
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbiJXS4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbiJXSzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:55:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AFB16D88F
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:36:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14F8D612B9
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9039C433B5;
        Mon, 24 Oct 2022 17:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666630805;
        bh=yovxjT4O6Qtb+uv3J/yHH8vE1VwXjIrhI1rw6yMt0ww=;
        h=From:To:Cc:Subject:Date:From;
        b=WahSxQPRBKM7m9UTvrjaO6NxeQwWHjJQ9Ho4f9JncdKdgR1olAzS7Z9W/qyz/jiN0
         bI8DGgBM+5VfVYMXXTcGbzEXtMD9ipvvGi8KdFkxIxcVwAYILg9rTzKUTbuEhYZYHX
         kW6ncax3HS1IzVZlojiOQm2dj7OidP8IREg9Axte8wT+ZdI/yb4IVTl/XCSIRtcFC8
         PNGPEd3TU00gyevBRz6501zfm37B+kOrU4nXy2QHNL9C2dSUpiONs1yBoJgJw8Q5lA
         51afA+IZYbCwfc3Z47b8m87pN/N2pZbGgk5cjYyWz8IIIDO9pTjbs8zaqH6seC+3/I
         P7q/gt17RWIww==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 0/6] Various cleanups for mlx5
Date:   Mon, 24 Oct 2022 19:59:53 +0300
Message-Id: <cover.1666630548.git.leonro@nvidia.com>
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

Changelog:
v1:
Patch #1:
 * Removed extra blank line
 * Removed ipsec initialization for uplink
v0: https://lore.kernel.org/all/cover.1666545480.git.leonro@nvidia.com
-----------------------------------------------------------------------

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
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  7 ++-----
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    |  9 +++------
 .../mellanox/mlx5/core/eswitch_offloads.c       | 12 ++++++------
 .../net/ethernet/mellanox/mlx5/core/lib/aso.c   | 10 +++++-----
 .../net/ethernet/mellanox/mlx5/core/lib/aso.h   |  2 +-
 9 files changed, 32 insertions(+), 42 deletions(-)

-- 
2.37.3

