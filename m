Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AB2339A06
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 00:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhCLXjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 18:39:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhCLXi4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 18:38:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82DB364F1E;
        Fri, 12 Mar 2021 23:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615592335;
        bh=n4IbzXZhvfEPXDiYBzduvuH/8Nj3zSswMMGS/4WCPOo=;
        h=From:To:Cc:Subject:Date:From;
        b=qEV56x8NggXgkkgibN0DV86QMHMcaZ2u0OFBpCtNRAGOXvTBykcs7opljXsWm3hLK
         HqBLtXcX+e0KSy2o3/Xa6vn6Qyq9udFm7ARdugx5N6dzpQI18VqMNdF652Wa+4atsP
         fnxQDcbI/EvH/C3qHuJtDTurLXobUQ2WMJQmd0wMCF+DioB3jlFtlYrIY6jMqX37xc
         XKqx30IMq6ANJN7wcITpLznDcfUuMKk3sXlu1WDFw9Z7JviwsoYvTCgcpsKhzSBFTi
         ZodCGx94Q7SXS+P+eTJtmPUIcDaSrBopedDNrmS51uG5dj9Q+avrCUrh8Q26K17O1l
         zoecQeY4X2cJQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/13] mlx5 updates 2021-03-12
Date:   Fri, 12 Mar 2021 15:38:38 -0800
Message-Id: <20210312233851.494832-1-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This is another round of fixups and cleanups,
with two simple patches on top:

1) TC support for ICMP parameters
2) TC connection tracking with mirroring

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit bfdfe7fc1bf9e8c16e4254236c3c731bfea6bdc5:

  docs: networking: phy: Improve placement of parenthesis (2021-03-12 12:29:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-03-12

for you to fetch changes up to a3222a2da0a2d6c7682252d4bfdff05721a82b95:

  net/mlx5e: Allow to match on ICMP parameters (2021-03-12 15:29:34 -0800)

----------------------------------------------------------------
mlx5-updates-2021-03-12

1) TC support for ICMP parameters
2) TC connection tracking with mirroring
3) A round of trivial fixups and cleanups

----------------------------------------------------------------
Alaa Hleihel (1):
      net/mlx5: Display the command index in command mailbox dump

Arnd Bergmann (1):
      net/mlx5e: allocate 'indirection_rqt' buffer dynamically

Jiapeng Chong (1):
      net/mlx5: remove unneeded semicolon

Junlin Yang (1):
      net/mlx5: use kvfree() for memory allocated with kvzalloc()

Maor Dickman (1):
      net/mlx5e: Allow to match on ICMP parameters

Mark Zhang (1):
      net/mlx5: Read congestion counters from all ports when lag is active

Maxim Mikityanskiy (1):
      net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath

Paul Blakey (1):
      net/mlx5: CT: Add support for mirroring

Roi Dayan (1):
      net/mlx5e: Remove redundant newline in NL_SET_ERR_MSG_MOD

Tariq Toukan (1):
      net/mlx5e: Dump ICOSQ WQE descriptor on CQE with error events

Yevgeny Kliteynik (3):
      net/mlx5: DR, Fixed typo in STE v0
      net/mlx5: DR, Remove unneeded rx_decap_l3 function for STEv1
      net/mlx5: DR, Add missing vhca_id consume from STEv1

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      | 32 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  4 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 82 ++++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  | 10 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  2 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |  2 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  2 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        | 19 +----
 include/linux/mlx5/device.h                        |  2 +
 12 files changed, 107 insertions(+), 55 deletions(-)
