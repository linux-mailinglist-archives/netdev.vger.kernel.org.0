Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010D5275173
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgIWGYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbgIWGYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:40 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BF3921D43;
        Wed, 23 Sep 2020 06:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842280;
        bh=YFopCGSf6CQibZxW/QvhYoTuhLxjKACiFY3AM90iQY4=;
        h=From:To:Cc:Subject:Date:From;
        b=eWFvNfWRI9Be/2YkEPqeZoaDaXM/hrGmYv9XZRrkVMDjdmyYnkxNp2MK4oUbXTtX2
         q53qv8N6vIxhqRaEMWiTuZHiXMTJgEUrKO866kjvVkcaQNwVrNzqI105HSshWgxxRp
         Kwy0n0XDx9uLUS9I18NaGjEoKPnBAjaBJOx+l1SE=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 Connection Tracking in NIC mode 
Date:   Tue, 22 Sep 2020 23:24:23 -0700
Message-Id: <20200923062438.15997-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series adds the support for connection tracking in NIC mode,
and attached to this series some trivial cleanup patches.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 748d1c8a425ec529d541f082ee7a81f6a51fa120:

  Merge branch 'devlink-Use-nla_policy-to-validate-range' (2020-09-22 17:38:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-09-22

for you to fetch changes up to 6e9a79f0d4e98ef8b48f2a059fadf755a464bcc7:

  net/mlx5: remove unreachable return (2020-09-22 23:15:59 -0700)

----------------------------------------------------------------
mlx5-updates-2020-09-22

This series includes mlx5 updates

1) Add support for Connection Tracking offload in NIC mode.
 1.1) Refactor current flow steering chains infrastructure and
      updates TC nic mode implementation to use flow table chains.
 1.2) Refactor current Connection Tracking (CT) infrastructure to not
      assume E-switch backend, and make the CT layer agnostic to
      underlying steering mode (E-Switch/NIC)
 1.3) Plumbing to support CT offload in NIC mode.

2) Trivial code cleanups.

----------------------------------------------------------------
Ariel Levkovich (9):
      net/mlx5: Refactor multi chains and prios support
      net/mlx5: Allow ft level ignore for nic rx tables
      net/mlx5e: Tc nic flows to use mlx5_chains flow tables
      net/mlx5e: Split nic tc flow allocation and creation
      net/mlx5: Refactor tc flow attributes structure
      net/mlx5e: Add tc chains offload support for nic flows
      net/mlx5e: rework ct offload init messages
      net/mlx5e: Support CT offload for tc nic flows
      net/mlx5e: Keep direct reference to mlx5_core_dev in tc ct

Denis Efremov (2):
      net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()
      net/mlx5e: Use kfree() to free fd->g in accel_fs_tcp_create_groups()

Oz Shlomo (1):
      net/mlx5e: CT: Use the same counter for both directions

Pavel Machek (CIP) (1):
      net/mlx5: remove unreachable return

Qinglang Miao (1):
      net/mlx5: simplify the return expression of mlx5_ec_init()

Saeed Mahameed (1):
      net/mlx5e: TC: Remove unused parameter from mlx5_tc_ct_add_no_trk_match()

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   7 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 525 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  75 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 865 +++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  97 +++
 .../net/ethernet/mellanox/mlx5/core/esw/chains.c   | 944 ---------------------
 .../net/ethernet/mellanox/mlx5/core/esw/chains.h   |  68 --
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  39 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 309 +++++--
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   2 -
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 911 ++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |  93 ++
 21 files changed, 2339 insertions(+), 1658 deletions(-)
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
