Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E1858475A
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 22:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiG1U5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 16:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiG1U5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 16:57:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F0778217
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 13:57:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9D40B82596
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 20:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825ABC433D6;
        Thu, 28 Jul 2022 20:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659041850;
        bh=KmuWDbO7BzucaCU0KIpKPjNZXg1KWr7OZxdH9WKjhGw=;
        h=From:To:Cc:Subject:Date:From;
        b=U2dFm2lOEZWrRZtI/GjF1UdpXU/FoeRsJVIMP7lcnYmRQHK6xBxFo/9gF7qclv2mI
         Bp60NO19LIpCgU7FxWM6afo76QOnGPbPEhcLSjQXbstDW6Rue7jmmO3boojA7Qli7h
         wVjahXTm9i/wj1rSL8h8Hu/2oa5UgK5me3NuJk85/5Fa/7i+S786hcnBn1cLF3J09Q
         nYKuPS6G6GO+dsfOgJSfu+lbc7TK96zVnfmgykaPBwntOY8RNIkZwdP4xoB3LikZ4F
         ePxgSF/OfLJ60XGZcAoZ8J7uU0+Hw5C4Z1iBayCQz+6d3/r6yPku9TnGCLI9W0IBsl
         PDhEdGlYtBxsA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2022-07-28
Date:   Thu, 28 Jul 2022 13:57:13 -0700
Message-Id: <20220728205728.143074-1-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
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

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 623cd87006983935de6c2ad8e2d50e68f1b7d6e7:

  net: cdns,macb: use correct xlnx prefix for Xilinx (2022-07-28 13:08:53 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-07-28

for you to fetch changes up to 069448b2fd0a40b5252915dc10ae561c4b5c8c5a:

  net/mlx5e: Move mlx5e_init_l2_addr to en_main (2022-07-28 13:55:30 -0700)

----------------------------------------------------------------
mlx5-updates-2022-07-28

Misc updates to mlx5 driver:

1) Gal corrects to use skb_tcp_all_headers on encapsulated skbs.

2) Roi Adds the support for offloading standalone police actions.

3) Lama did some refactoring to minimize code coupling with
mlx5e_priv "god object" in some of the follows, and converts some of the
objects to pointers to preserve on memory when these objects aren't needed.
This is part one of two parts series.

----------------------------------------------------------------
Gal Pressman (1):
      net/mlx5e: Fix wrong use of skb_tcp_all_headers() with encapsulation

Lama Kayal (9):
      net/mlx5e: Convert mlx5e_tc_table member of mlx5e_flow_steering to pointer
      net/mlx5e: Make mlx5e_tc_table private
      net/mlx5e: Allocate VLAN and TC for featured profiles only
      net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer
      net/mlx5e: Report flow steering errors with mdev err report API
      net/mlx5e: Add mdev to flow_steering struct
      net/mlx5e: Separate mlx5e_set_rx_mode_work and move caller to en_main
      net/mlx5e: Split en_fs ndo's and move to en_main
      net/mlx5e: Move mlx5e_init_l2_addr to en_main

Roi Dayan (4):
      net/mlx5e: TC, Allocate post meter ft per rule
      net/mlx5e: Add red and green counters for metering
      net/mlx5e: TC, Separate get/update/replace meter functions
      net/mlx5e: TC, Support tc action api for police

Yevgeny Kliteynik (1):
      net/mlx5: DR, Add support for flow metering ASO

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |  44 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         |  72 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    | 117 ++++-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |  10 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c | 100 +++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  | 189 +++++--
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.h  |  18 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c |  33 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.h |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |  32 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  58 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    | 554 +++++++++++----------
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |  24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  63 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  34 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 143 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  20 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |  99 ++++
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  56 +++
 .../mellanox/mlx5/core/steering/dr_types.h         |  17 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  21 +
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |  26 +
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   8 +
 30 files changed, 1265 insertions(+), 511 deletions(-)
