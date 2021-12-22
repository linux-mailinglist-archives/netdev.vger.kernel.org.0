Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB84147CB95
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 04:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbhLVDQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 22:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbhLVDQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 22:16:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33E7C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 19:16:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE0BB617F8
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 03:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5266C36AE8;
        Wed, 22 Dec 2021 03:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142970;
        bh=jBg2wS4CInYoxlSNYcDXeb6JVdpY5+JtY+D55w5uFdc=;
        h=From:To:Cc:Subject:Date:From;
        b=LVT5R91aChWn2xObcUOBETRSdk4nleucdKX3p18/E1QWxR6p3i6azON5S3AhSRgsq
         jD7KmsHFjt8tUcbEC8UMIzXcuY6kZ0Ulc6L4ZcjiMrvJMtvmwGEOZ+dAHL7ellit/2
         Bepd6QqxCYznyUjIBYIws1J2n3h6oRbsPWgsggOsTEtTBjAWrtf4x1J3dc29fvjlfc
         BJ7vtWeuRaM01Tudhq2s7IBmnx4Z7I9/1NMC1gbUIGXcS/dqp/ax7I17pffQisS7MZ
         p97llaneFJbQXgOgZ5Ur6cNftiTm1JEIhWRLxgQtaXaQ9jaocidSSjSuiDj0IQpAmf
         +UtUB5VXhYy1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next v0 00/14] mlx5 updates 2021-12-21
Date:   Tue, 21 Dec 2021 19:15:50 -0800
Message-Id: <20211222031604.14540-1-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series adds 2 main changes to mlx5
1) New Devlink knobs to control EQ sizes, already acked by Jiri and
Jakub. first 6 commits.

Link: https://lore.kernel.org/netdev/20211208141722.13646-1-shayd@nvidia.com/

2) Memory optimization of netdev's channels data.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit f4f2970dfd87e5132c436e6125148914596a9863:

  Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2021-12-21 17:20:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-12-21

for you to fetch changes up to 1f08917ab929a6939cb0c95d47f928db43f6d3c9:

  net/mlx5e: Take packet_merge params directly from the RX res struct (2021-12-21 19:08:58 -0800)

----------------------------------------------------------------
mlx5-updates-2021-12-21

1) From Shay Drory: Devlink user knobs to control device's EQ size

This series provides knobs which will enable users to
minimize memory consumption of mlx5 Functions (PF/VF/SF).
mlx5 exposes two new generic devlink params for EQ size
configuration and uses devlink generic param max_macs.

LINK: https://lore.kernel.org/netdev/20211208141722.13646-1-shayd@nvidia.com/

2) From Tariq and Lama, allocate software channel objects and statistics
  of a mlx5 netdevice private data dynamically upon first demand to save on
  memory.

----------------------------------------------------------------
Lama Kayal (1):
      net/mlx5e: Allocate per-channel stats dynamically at first usage

Shaokun Zhang (1):
      net/mlx5: Remove the repeated declaration

Shay Drory (6):
      devlink: Add new "io_eq_size" generic device param
      net/mlx5: Let user configure io_eq_size param
      devlink: Add new "event_eq_size" generic device param
      net/mlx5: Let user configure event_eq_size param
      devlink: Clarifies max_macs generic devlink param
      net/mlx5: Let user configure max_macs generic param

Tariq Toukan (6):
      net/mlx5e: Use bitmap field for profile features
      net/mlx5e: Add profile indications for PTP and QOS HTB features
      net/mlx5e: Save memory by using dynamic allocation in netdev priv
      net/mlx5e: Allow profile-specific limitation on max num of channels
      net/mlx5e: Use dynamic per-channel allocations in stats
      net/mlx5e: Take packet_merge params directly from the RX res struct

 .../networking/devlink/devlink-params.rst          |  12 +-
 Documentation/networking/devlink/mlx5.rst          |  10 ++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  88 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  26 ++--
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |  14 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 165 +++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  17 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  34 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 -
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   3 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  21 +++
 include/net/devlink.h                              |   8 +
 net/core/devlink.c                                 |  10 ++
 22 files changed, 365 insertions(+), 81 deletions(-)
