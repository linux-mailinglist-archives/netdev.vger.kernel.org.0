Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD2C270346
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgIRR2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIRR2u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:50 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B88A721707;
        Fri, 18 Sep 2020 17:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450130;
        bh=WNytJwqzSpvit27wVP6KrweLtcs5Ue019smoXkqCwl4=;
        h=From:To:Cc:Subject:Date:From;
        b=TFo5WhuOn+mqQXA0pcMRDqhHStZit1CbQx8NOd5/No+xX8d1ICLOYc76Sknj0Ahyd
         1AABqsSj8b5sMUN8RMqDuYvtZ2mWeGKEM7jw0ywe4ZQmW5Ih1N2WCnYb+e5EXZlfLm
         sbBhp75Lrw9MAAYiBB3QOcVF+QJLMVATI8j4Z+FQ=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/15] mlx5 Fixes 2020-09-18
Date:   Fri, 18 Sep 2020 10:28:24 -0700
Message-Id: <20200918172839.310037-1-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave,

This series introduces some fixes to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

For -stable v5.1
 ('net/mlx5: Fix FTE cleanup')

For -stable v5.3
 ('net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported')
 ('net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported')

For -stable v5.7
 ('net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready')

For -stable v5.8
 ('net/mlx5e: Use RCU to protect rq->xdp_prog')
 ('net/mlx5e: Fix endianness when calculating pedit mask first bit')
 ('net/mlx5e: Protect encap route dev from concurrent release')
 ('net/mlx5e: Use synchronize_rcu to sync with NAPI')

Thanks,
Saeed.

---
The following changes since commit 5f6857e808a8bd078296575b417c4b9d160b9779:

  nfp: use correct define to return NONE fec (2020-09-17 17:59:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-09-18

for you to fetch changes up to dc01221751720815c51cf0f0f8b1c06079d2b8ad:

  net/mlx5e: mlx5e_fec_in_caps() returns a boolean (2020-09-18 10:17:47 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-09-18

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5e: Fix using wrong stats_grps in mlx5e_update_ndo_stats()

Jianbo Liu (1):
      net/mlx5e: Fix memory leak of tunnel info when rule under multipath not ready

Maor Dickman (2):
      net/mlx5e: Enable adding peer miss rules only if merged eswitch is supported
      net/mlx5e: Fix endianness when calculating pedit mask first bit

Maor Gottlieb (1):
      net/mlx5: Fix FTE cleanup

Maxim Mikityanskiy (2):
      net/mlx5e: Use RCU to protect rq->xdp_prog
      net/mlx5e: Use synchronize_rcu to sync with NAPI

Roi Dayan (1):
      net/mlx5e: CT: Fix freeing ct_label mapping

Ron Diskin (1):
      net/mlx5e: Fix multicast counter not up-to-date in "ip -s"

Saeed Mahameed (4):
      net/mlx5e: kTLS, Add missing dma_unmap in RX resync
      net/mlx5e: kTLS, Fix leak on resync error flow
      net/mlx5e: kTLS, Avoid kzalloc(GFP_KERNEL) under spinlock
      net/mlx5e: mlx5e_fec_in_caps() returns a boolean

Tariq Toukan (2):
      net/mlx5e: TLS, Do not expose FPGA TLS counter if not supported
      net/mlx5e: kTLS, Fix napi sync and possible use-after-free

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  3 +-
 .../ethernet/mellanox/mlx5/core/en/monitor_stats.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 21 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h | 26 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    | 14 +---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |  3 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 43 +++++------
 .../mellanox/mlx5/core/en_accel/tls_stats.c        | 12 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 85 ++++++++--------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 16 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 12 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 45 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  | 17 ++++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 52 +++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  8 +-
 20 files changed, 200 insertions(+), 180 deletions(-)
