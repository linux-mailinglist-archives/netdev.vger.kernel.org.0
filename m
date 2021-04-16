Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DBF36280F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbhDPSzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234948AbhDPSzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 794846137D;
        Fri, 16 Apr 2021 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599279;
        bh=fjL5TelqY7CJesmYHj4ZZcFMAhcX9s/O8x2KgVUVq48=;
        h=From:To:Cc:Subject:Date:From;
        b=hQghVbOwpfWP949Tl/l2MSu10fWHi5wdxGPb0kyYKFIr+p31wOeJTI5+mTLQxoIoo
         MueoODvQS6188q/WLtCJ3e1+VN4P9kWOpb9v1C3SJn0PcIo51M/C1vKfqorKvwsTIK
         pG+M+ieHzJS6cXbG+gM9iVcLNfoh6XgMQtafo64XtrC6xsXW9MWPFwoIaRQiOCgZFC
         nRyUBc9bw+vMfu5RauvHRG1/I8/8k5DdWot27Zqq/3mMfcklOAQ0m8j0H92cq6lAEp
         qS/k4TPQ4tGuzgf/M8PjqKrZC9yw1mDBhdrKT6eZsr+Bslk4X6yoAwMyU8xjARyUfE
         lmpP9txLaeMxQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2021-04-16
Date:   Fri, 16 Apr 2021 11:54:16 -0700
Message-Id: <20210416185430.62584-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides some updates to mlx5e driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 392c36e5be1dee19ffce8c8ba8f07f90f5aa3f7c:

  Merge branch 'ehtool-fec-stats' (2021-04-15 17:08:30 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-04-16

for you to fetch changes up to 95742c1cc59d0a6aa2ca9e75bd21f2a8721f5129:

  net/mlx5: Enhance diagnostics info for TX/RX reporters (2021-04-16 11:48:34 -0700)

----------------------------------------------------------------
mlx5-updates-2021-04-16

This patchset introduces updates to mlx5e netdev driver.

1) Tariq refactors TLS offloads and adds resiliency against RX resync
   failures

2) Maxim reduces code duplications by unifying channels reset flow
   regardless if channels are closed or open

3) Aya Enhances TX/RX health reporters diagnostics to expose the
   internal clock time-stamping format

4) Moshe adds support for ethtool extended link state, to show the reason
   for link down

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5: Add helper to initialize 1PPS
      net/mlx5: Enhance diagnostics info for TX/RX reporters

Maor Dickman (1):
      net/mlx5: Allocate FC bulk structs with kvzalloc() instead of kzalloc()

Maxim Mikityanskiy (4):
      net/mlx5e: Allow mlx5e_safe_switch_channels to work with channels closed
      net/mlx5e: Use mlx5e_safe_switch_channels when channels are closed
      net/mlx5e: Refactor on-the-fly configuration changes
      net/mlx5e: Cleanup safe switch channels API by passing params

Moshe Tal (2):
      net/mlx5: Add register layout to support extended link state
      net/mlx5e: Add ethtool extended link state

Tariq Toukan (5):
      net/mlx5e: Remove non-essential TLS SQ state bit
      net/mlx5e: Cleanup unused function parameter
      net/mlx5e: TX, Inline TLS skb check
      net/mlx5e: TX, Inline function mlx5e_tls_handle_tx_wqe()
      net/mlx5e: kTLS, Add resiliency to RX resync failures

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   3 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   6 +
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   6 +
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   7 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  11 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 129 ++++++--
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |  20 ++
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |   9 -
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |  34 +--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 338 ++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 250 +++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   5 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  16 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |  19 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  25 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |  50 +++
 23 files changed, 621 insertions(+), 344 deletions(-)
