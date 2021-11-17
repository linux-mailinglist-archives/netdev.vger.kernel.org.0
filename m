Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F18453F85
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhKQEhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:41386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhKQEhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CB6661057;
        Wed, 17 Nov 2021 04:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123646;
        bh=0/dlQY9MNCJjFFTeKFbEBrft5dwoqC2vgA0wtW/ajJc=;
        h=From:To:Cc:Subject:Date:From;
        b=j8qpiVrZKxdjQwed952D28svThWZYKhgcthbKLgCDESLy5LC1X2yejSBNTyUhNhUT
         CiCm0DrlY5XQS1dGXDmDWvQ3r9BZqiXTe4UT1giQHRsrPHm+RSryU4gE4EjNEl2kfc
         DstB3BVkgOmlMkkCgbQ4GfbdE/3Fqp8NMMm/HknqlJBTrWSCjcNStpDoiuDfuf3Y7U
         qlzKoOaepkjX9fDf8NMSoZbz39tdM+ZzU7PabC5SZBqyq6u81diwvVqgaJgo4Qv8H8
         87VASHy/AyMpEWCaD01jH5pX2FxkO4hzI6xhDWABYGAzyTGwaVQDVd24JgZ1iI8ULK
         8bbhNOHg0Cxww==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next v0 00/15] mlx5 updates 2021-11-16
Date:   Tue, 16 Nov 2021 20:33:42 -0800
Message-Id: <20211117043357.345072-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This series provides mlx5 misc updates.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit b9241f54138ca5af4d3c5ca6db56be83d7491508:

  net: document SMII and correct phylink's new validation mechanism (2021-11-16 19:22:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-11-16

for you to fetch changes up to 85c5f7c9200e5ce89f0c188d0c24ab4e731b6a51:

  net/mlx5: E-switch, Create QoS on demand (2021-11-16 20:31:52 -0800)

----------------------------------------------------------------
mlx5-updates-2021-11-16

Updates for mlx5 driver:

1) Support ethtool cq mode
2) Static allocation of mod header object for the common case
3) TC support for when local and remote VTEPs are in the same
4) Create E-Switch QoS objects on demand to save on resources
5) Minor code improvements

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5: Avoid printing health buffer when firmware is unavailable

Chris Mi (1):
      net/mlx5e: Specify out ifindex when looking up decap route

Dmytro Linkin (2):
      net/mlx5: E-switch, Enable vport QoS on demand
      net/mlx5: E-switch, Create QoS on demand

Parav Pandit (3):
      net/mlx5: E-switch, Remove vport enabled check
      net/mlx5: E-switch, Reuse mlx5_eswitch_set_vport_mac
      net/mlx5: E-switch, move offloads mode callbacks to offloads file

Paul Blakey (2):
      net/mlx5e: Refactor mod header management API
      net/mlx5: CT: Allow static allocation of mod headers

Roi Dayan (3):
      net/mlx5e: TC, Destroy nic flow counter if exists
      net/mlx5e: TC, Move kfree() calls after destroying all resources
      net/mlx5e: TC, Move comment about mod header flag to correct place

Saeed Mahameed (2):
      net/mlx5e: Support ethtool cq mode
      net/mlx5: Fix format-security build warnings

Yihao Han (1):
      net/mlx5: TC, using swap() instead of tmp variable

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.c   |  58 ++++++
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.h   |  26 +++
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  39 ++--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  23 +--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  49 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 110 +++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   5 -
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  | 220 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h  |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  94 +--------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  11 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  59 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   5 +
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   2 +-
 23 files changed, 432 insertions(+), 321 deletions(-)
