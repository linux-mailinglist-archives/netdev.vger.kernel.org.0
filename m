Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054E93380A7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCKWhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhCKWhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE6864F88;
        Thu, 11 Mar 2021 22:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502253;
        bh=TyJrryqfkQ/T2X4cLBMEhs0uvLMvLAWMl2bEx7ZsMC4=;
        h=From:To:Cc:Subject:Date:From;
        b=mkFShoK8XMsfj7wz5pHQqWMgIlcMGT1dtNuXKX8Cr6z7Xzsmm6fhXU1ZckSU6pWYu
         XtaozQnLR6FQqGkh+PivkHPPWsrUCWGiL+QttNyKLUwOkFTLYI6E/rinEHLdyGprv5
         1sWoUW79ch60pjYJdQkY3RsujSP0iTz2epn6vEGw52eLzusgIxXd01/V2YuE6XRbSy
         UK59a1rS0aNrcyUO16GjI8bQaL4UI5rRvMCxbS0lFKxbUtmloxLicMQAwlcJ/KQ0s5
         m7jqOl5Ii1clvJYXxXEQEJaW380AY02lI1rnAthuKFs1sKDjujnbJC1JvyIXIejtGs
         TkM+S6+8hmC6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-03-11
Date:   Thu, 11 Mar 2021 14:37:08 -0800
Message-Id: <20210311223723.361301-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides some cleanups to mlx5 driver
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 34bb975126419e86bc3b95e200dc41de6c6ca69c:

  net: fddi: skfp: Mundane typo fixes throughout the file smt.h (2021-03-10 15:42:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-03-11

for you to fetch changes up to 9f4d9283388d9069dcf4d68ae9a212d7f0e6a985:

  net/mlx5e: Alloc flow spec using kvzalloc instead of kzalloc (2021-03-11 14:35:15 -0800)

----------------------------------------------------------------
mlx5-updates-2021-03-11

Cleanups for mlx5 driver

1) Fix build warnings form Arnd and Vlad
2) Leon improves locking for driver load/unload flows
3) From Roi, Lockdep false dependency warning
4) Other trivial cleanups

----------------------------------------------------------------
Arnd Bergmann (1):
      net/mlx5e: fix mlx5e_tc_tun_update_header_ipv6 dummy definition

Eli Cohen (1):
      net/mlx5: Avoid unnecessary operation

Leon Romanovsky (5):
      net/mlx5: Remove impossible checks of interface state
      net/mlx5: Separate probe vs. reload flows
      net/mlx5: Remove second FW tracer check
      net/mlx5: Don't rely on interface state bit
      net/mlx5: Check returned value from health recover sequence

Roi Dayan (3):
      net/mlx5e: CT, Avoid false lock dependency warning
      net/mlx5: SF, Fix return type
      net/mlx5e: Alloc flow spec using kvzalloc instead of kzalloc

Saeed Mahameed (3):
      net/mlx5: Don't skip vport check
      net/mlx5e: mlx5_tc_ct_init does not fail
      net/mlx5e: rep: Improve reg_cX conditions

Vlad Buslov (2):
      net/mlx5e: Add missing include
      net/mlx5: Fix indir stable stubs

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   6 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  24 +++-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |  10 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   8 --
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   2 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.h  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  10 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c  |   5 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 143 ++++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   8 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.h   |   2 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |  14 +-
 20 files changed, 169 insertions(+), 118 deletions(-)
