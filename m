Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D770D350801
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbhCaUQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:16:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236407AbhCaUQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0F0D6109E;
        Wed, 31 Mar 2021 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221797;
        bh=1iyHyvtZANCYUZhgCPvwbt2ERLGsnaEHv/GmXGG6nLw=;
        h=From:To:Cc:Subject:Date:From;
        b=Iwl4j4BnSa6lTtlW5LHZB6JKqdhfeahSMtQ7T6essxGpKb9muUIHXIxwAvs5RtbNg
         6vx9LgMbCY2IOfwIN94uyMIJYSPHqQflquA/EW8o5EPZsX6vQMUC3ur/gmVrgM2cGg
         /baO6ggZmD875gzOP0BuPQ73X5/BJ03vhPJ1aVVw1H+RybtayRLvqkISg+yk+Q2W4j
         Vpbd/jyNvlERbklm01ccMk5V81DLc22xfQJX6tTpRZuCAQp3EWS+m0PsyfLZk+T7V2
         O09dZvrOp7SiSGFFJnJTLnq0mLsAv3PCFTDKEGO46YHStf1wO5ohnjkW/ZXYP+j7xx
         5m408sdwE5f9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 0/9] mlx5 fixes 2021-03-31
Date:   Wed, 31 Mar 2021 13:14:15 -0700
Message-Id: <20210331201424.331095-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 61431a5907fc36d0738e9a547c7e1556349a03e9:

  net: ensure mac header is set in virtio_net_hdr_to_skb() (2021-03-30 17:40:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-03-31

for you to fetch changes up to 3ff3874fa0b261ef74f2bfb008a82ab1601c11eb:

  net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOSQ (2021-03-31 13:12:24 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-03-31

----------------------------------------------------------------
Ariel Levkovich (1):
      net/mlx5e: Fix mapping of ct_label zero

Aya Levin (1):
      net/mlx5e: Fix ethtool indication of connector type

Daniel Jurgens (1):
      net/mlx5: Don't request more than supported EQs

Dima Chumak (1):
      net/mlx5e: Consider geneve_opts for encap contexts

Maor Dickman (2):
      net/mlx5: Delete auxiliary bus driver eth-rep first
      net/mlx5: E-switch, Create vport miss group only if src rewrite is supported

Tariq Toukan (3):
      net/mlx5e: kTLS, Fix TX counters atomicity
      net/mlx5e: kTLS, Fix RX counters atomicity
      net/mlx5e: Guarantee room for XSK wakeup NOP on async ICOSQ

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 36 +++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    | 10 ++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 23 +++-----
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c | 29 +++++++++
 .../ethernet/mellanox/mlx5/core/en/tc_tun_gre.c    |  1 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        |  1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  6 ++
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c | 40 ++++++-------
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |  3 +
 .../mellanox/mlx5/core/en_accel/tls_stats.c        | 49 ++++++++++------
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   | 22 +++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 21 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 10 ----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  6 --
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       | 13 ++++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 68 +++++++++++++---------
 20 files changed, 227 insertions(+), 122 deletions(-)
