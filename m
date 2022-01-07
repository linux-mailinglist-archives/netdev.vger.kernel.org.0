Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020B1486F45
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344928AbiAGA6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:58:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36498 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344869AbiAGA6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAAB8B82490
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F4CC36AE3;
        Fri,  7 Jan 2022 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517123;
        bh=V+Vs7fmM/z22O9eeJdkYGFH7n2H5LMocthjOApKWFlw=;
        h=From:To:Cc:Subject:Date:From;
        b=Ig8MXYrbzXm/IjI+dp4gTfyqtufsvXPvtju1e18Ui9mqYIrJBP0FfEm5nuv7J+lsK
         Vx24IicfX3OKCidlSEA7AlzS+pYSbbyikHlw0vWHW3MalT6aaid2pOig23DU3E404+
         QWVp0bwbGw5o0NWmdwTnAZNH3ObOe/Qggc2aUFC6iPjumJsgUqujk/sAQ8ubDo+tMo
         ebyyhkIMyJSwi7Lrk0zwXHQaQ147aPeBMbZeldMlMJvoOb2G3yd6C5CMnAWKwWWxsm
         YBPX+oUpRToINpFh2UD+hK9UA49nVFGd/Zo6kpjUVNAHpr/DDsJCSoZno3szec/Bnj
         +C6fhBZ70+/Xg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/11] mlx5 fixes 2022-01-06
Date:   Thu,  6 Jan 2022 16:58:20 -0800
Message-Id: <20220107005831.78909-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 36595d8ad46d9e4c41cc7c48c4405b7c3322deac:

  net/smc: Reset conn->lgr when link group registration fails (2022-01-06 13:54:06 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2022-01-06

for you to fetch changes up to 4f6626b0e140867fd6d5a2e9d4ceaef97f10f46a:

  Revert "net/mlx5: Add retry mechanism to the command entry index allocation" (2022-01-06 16:55:42 -0800)

----------------------------------------------------------------
mlx5-fixes-2022-01-06

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5e: Fix page DMA map/unmap attributes
      Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"
      Revert "net/mlx5e: Block offload of outer header csum for GRE tunnel"

Dima Chumak (1):
      net/mlx5e: Fix nullptr on deleting mirroring rule

Maor Dickman (3):
      net/mlx5e: Fix wrong usage of fib_info_nh when routes with nexthop objects are used
      net/mlx5e: Don't block routes with nexthop objects in SW
      net/mlx5e: Sync VXLAN udp ports during uplink representor profile change

Moshe Shemesh (2):
      net/mlx5: Set command entry semaphore up once got index free
      Revert "net/mlx5: Add retry mechanism to the command entry index allocation"

Paul Blakey (1):
      net/mlx5e: Fix matching on modified inner ip_ecn bits

Shay Drory (1):
      net/mlx5: Fix access to sf_dev_table on allocation failure

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  36 ++-----
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  19 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 120 ++++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  28 ++---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |   6 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |   5 +-
 10 files changed, 165 insertions(+), 65 deletions(-)
