Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447DC30B820
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 07:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhBBG4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:56:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhBBGzv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:55:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FE4B64EDF;
        Tue,  2 Feb 2021 06:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248910;
        bh=/prsh9z8VMXmPloEnLATNq1fRh81ogHJozhpUOCDVWc=;
        h=From:To:Cc:Subject:Date:From;
        b=SiRewS7yqcGeeg0OumQnzWbD/r66af7eJkRgnPF/DU0VzBDJXLullxYGdD0YmxJb5
         8KoOUhJNPHb73N+RJ0wBJLNSy8LEXvsZECobZEHQOwqvFAxTyr/xZjNWJi9i+H8vib
         wJnOmVhLK7hZ5UTUxLVjRsPb4IdjV1/jg0baJiAEZtj6phH0EZbEt3B5U+xUvw7f3d
         eA3w4ZT2Ub+U+7W6hnY0PZaQhFGPF8qRDu3W0/41LBu/TmOsA5N8QOhB6ReHONhhR+
         BFThJK/Z0x/NnshGckLkPG2LMAt+IA9bd2FZWLnImvhk/C70CYbuKIKc1z9hmrmuHQ
         C1llnDjoFCVVg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2021-02-01
Date:   Mon,  1 Feb 2021 22:54:43 -0800
Message-Id: <20210202065457.613312-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Jakub, Dave,

This series adds misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 9ae4bdc6e4c1281ddf8d6335bea35864d086cbf9:

  Merge branch 'rework-the-memory-barrier-for-scrq-entry' (2021-02-01 20:21:14 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-02-01

for you to fetch changes up to a283ea1b97163d21e0f1a3df387b71787042b990:

  net/mlx5: DR, Avoid unnecessary csum recalculation on supporting devices (2021-02-01 22:52:36 -0800)

----------------------------------------------------------------
mlx5-updates-2021-02-01

mlx5 netdev updates:

1) Trivial refactoring ahead of the upcoming uplink representor series.
2) Increased RSS table size to 256, for better results
3) Misc. Cleanup and very trivial improvements

----------------------------------------------------------------
Noam Stolero (1):
      net/mlx5e: Increase indirection RQ table size to 256

Roi Dayan (5):
      net/mlx5e: Refactor mlx5e_netdev_init/cleanup to mlx5e_priv_init/cleanup
      net/mlx5e: Move netif_carrier_off() out of mlx5e_priv_init()
      net/mlx5e: Move set vxlan nic info to profile init
      net/mlx5e: Avoid false lock depenency warning on tc_ht
      net/mlx5e: Move representor neigh init into profile enable

Saeed Mahameed (4):
      net/mlx5e: Separate between netdev objects and mlx5e profiles initialization
      net/mxl5e: Add change profile method
      net/mlx5e: accel, remove redundant space
      net/mlx5e: CT: remove useless conversion to PTR_ERR then ERR_PTR

Tariq Toukan (2):
      net/mlx5e: Enable napi in channel's activation stage
      net/mlx5e: kTLS, Improve TLS RX workqueue scope

Tom Rix (1):
      net/mlx5e: remove h from printk format specifier

Yevgeny Kliteynik (1):
      net/mlx5: DR, Avoid unnecessary csum recalculation on supporting devices

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  36 ++--
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |  18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   7 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  24 ++-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |   7 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 226 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  90 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 ++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  26 +--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   5 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   6 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |   9 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   5 +
 .../mellanox/mlx5/core/steering/dr_types.h         |   2 +
 17 files changed, 304 insertions(+), 185 deletions(-)
