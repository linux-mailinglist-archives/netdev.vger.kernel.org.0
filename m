Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48C6280815
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbgJATxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbgJATxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:10 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6F320780;
        Thu,  1 Oct 2020 19:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581989;
        bh=Xjg604oIXpd1LUJ0ZPoPlPaIrTsAhVLtb4XB16qRsoY=;
        h=From:To:Cc:Subject:Date:From;
        b=VPTTULGg3PI4O0HPe+337ujgrE13BKz3ffCE3s3JwEhgUPigFROq3qO4rV0CW1Inb
         Vnxph1tsMsNNgej8AWHPv2MPRcdPN5F1yk2DgvHUuVYCCOj1FTaqfuE8S/sEBIshEP
         4Us/V7nYgmoywdS9t0F9TrmGjKiDGbg3d2U0Cn2M=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net V2 00/15] mlx5 fixes 2020-09-30
Date:   Thu,  1 Oct 2020 12:52:32 -0700
Message-Id: <20201001195247.66636-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave,

This series introduces some fixes to mlx5 driver.

v1->v2:
  - Patch #1 Don't return while mutex is held. (Dave)

Please pull and let me know if there is any problem.

For -stable v4.15
 ('net/mlx5e: Fix VLAN cleanup flow')
 ('net/mlx5e: Fix VLAN create flow')

For -stable v4.16
 ('net/mlx5: Fix request_irqs error flow')

For -stable v5.4
 ('net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU')
 ('net/mlx5: Avoid possible free of command entry while timeout comp handler')

For -stable v5.7
 ('net/mlx5e: Fix return status when setting unsupported FEC mode')

For -stable v5.8
 ('net/mlx5e: Fix race condition on nhe->n pointer in neigh update')

Thanks,
Saeed.

---
The following changes since commit a59cf619787e628b31c310367f869fde26c8ede1:

  Merge branch 'Fix-bugs-in-Octeontx2-netdev-driver' (2020-09-30 15:07:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-09-30

for you to fetch changes up to ae2cc06daf21c2a38c6caca2c19599d61a5b3890:

  net/mlx5e: Fix race condition on nhe->n pointer in neigh update (2020-10-01 12:46:37 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-09-30

----------------------------------------------------------------
Aya Levin (6):
      net/mlx5e: Fix error path for RQ alloc
      net/mlx5e: Add resiliency in Striding RQ mode for packets larger than MTU
      net/mlx5e: Fix driver's declaration to support GRE offload
      net/mlx5e: Fix return status when setting unsupported FEC mode
      net/mlx5e: Fix VLAN cleanup flow
      net/mlx5e: Fix VLAN create flow

Eran Ben Elisha (4):
      net/mlx5: Fix a race when moving command interface to polling mode
      net/mlx5: Avoid possible free of command entry while timeout comp handler
      net/mlx5: poll cmd EQ in case of command timeout
      net/mlx5: Add retry mechanism to the command entry index allocation

Maor Dickman (1):
      net/mlx5e: CT, Fix coverity issue

Maor Gottlieb (1):
      net/mlx5: Fix request_irqs error flow

Saeed Mahameed (1):
      net/mlx5: cmdif, Avoid skipping reclaim pages if FW is not accessible

Shay Drory (1):
      net/mlx5: Don't allow health work when device is uninitialized

Vlad Buslov (1):
      net/mlx5e: Fix race condition on nhe->n pointer in neigh update

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 198 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c |  81 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 104 +++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  42 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  11 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   2 +-
 include/linux/mlx5/driver.h                        |   4 +
 15 files changed, 364 insertions(+), 119 deletions(-)
