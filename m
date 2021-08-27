Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59AD3F91A8
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243983AbhH0A7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 20:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243989AbhH0A7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2467261027;
        Fri, 27 Aug 2021 00:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025893;
        bh=42W3hWTPxWRuPT0RkZoiJYu4XzsLVChZsIrC/C828iQ=;
        h=From:To:Cc:Subject:Date:From;
        b=dnFqxbUWpxVAtkUmpIbfrB5mUHXORvpnP5opBkYr4yxN8fi7eu8EXLcVXc+vnbpyy
         CUkfIUEfbySF4RoD8hfsMn/tyxxlSEyachjhFq0ZZLyaW+sUiWFBgIWVV+Vdgrxs9a
         yhj/Q/vp/6K+qRcSQqVYVY7EtTsQWQheTXiGhjsR4rkJM+SOUTe1Up8z4nZk6hSYrZ
         zAzic5rhGBIjCwzJ2FFS8SdQ1upH3O+Lq9th9EpZc2OBgvjmfnBWSmzFdRIc6y+uCh
         VFOzLjQuCwpzWfSlAqlAN51Sg+5S4o+dXp92X+Xrqsi7HJ0vpWk5Vys1NS+tfDu58p
         fiyQ66o2uU0uA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/17] mlx5 updates 2021-08-26
Date:   Thu, 26 Aug 2021 17:57:45 -0700
Message-Id: <20210827005802.236119-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This series contains various fixes, additions and improvements to
mlx5 software steering.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit deecae7d96843fceebae06445b3f4bf8cceca31a:

  Merge branch 'LiteETH-driver' (2021-08-26 12:13:52 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-08-26

for you to fetch changes up to a2ebfbb7b181774570224faee570f717ae11b6d8:

  net/mlx5: DR, Add support for update FTE (2021-08-26 15:38:04 -0700)

----------------------------------------------------------------
mlx5-updates-2021-08-26

This patch series contains various fixes, additions and improvements to
mlx5 software steering.

Patch 1:
  adds support for REMOVE_HEADER packet reformat - a new reformat type
  that is supported starting with ConnectX-6 DX, and allows removing an
  arbitrary size packet segment at a selected position.

Patches 2 and 3:
  add support for VLAN pop on TX and VLAN push on RX flows.

Patch 4:
  enables retransmission mechanism for the SW Steering RC QP.

Patch 5:
  does some improvements to error flow in building STE array and adds
  a more informative printout of an invalid actions sequence.

Patch 6:
  improves error flow on SW Steering QP error.

Patch 7:
  reduces the log level of a message that is printed when a table is
  connected to a lower/same level destination table, as this case proves to
  be not as rare as it was in the past.

Patch 8:
  adds missing support for matching on IPv6 flow label for devices
  older than ConnectX-6 DX.

Patch 9:
  replaces uintN_t types with kernel-style types.

Patch 10:
  allows for using the right API for updating flow tables - if it is
  a FW-owned table, then FW API will be used.

Patch 11:
  adds support for 'ignore_flow_level' on multi-destination flow
  tables that are created by SW Steering.

Patch 12:
   optimizes FDB RX steering rule by skipping matching on source port,
   as the source port for all incoming packets equals to wire.

Patch 13:
   is a small code refactoring - it merges several DR_STE_SIZE enums
   into a single enum.

Patch 14:
   does some additional refactoring and removes HW-specific STE type
   from NIC domain.

Patch 15:
   removes rehash ctrl struct from dr_htbl struct and saves some memory.

Patch 16:
   does a more significant improvement in terms of memory consumption
   and was able to save about 1.6 Gb for 8M rules.

Patch 17:
   adds support for update FTE, which is needed for cases where there
   are multiple rules with the same match.

----------------------------------------------------------------
Bodong Wang (1):
      net/mlx5: DR, Reduce print level for FT chaining level check

Yevgeny Kliteynik (16):
      net/mlx5: DR, Added support for REMOVE_HEADER packet reformat
      net/mlx5: DR, Split modify VLAN state to separate pop/push states
      net/mlx5: DR, Enable VLAN pop on TX and VLAN push on RX
      net/mlx5: DR, Enable QP retransmission
      net/mlx5: DR, Improve error flow in actions_build_ste_arr
      net/mlx5: DR, Warn and ignore SW steering rule insertion on QP err
      net/mlx5: DR, Support IPv6 matching on flow label for STEv0
      net/mlx5: DR, replace uintN_t with kernel-style types
      net/mlx5: DR, Use FW API when updating FW-owned flow table
      net/mlx5: DR, Add ignore_flow_level support for multi-dest flow tables
      net/mlx5: DR, Skip source port matching on FDB RX domain
      net/mlx5: DR, Merge DR_STE_SIZE enums
      net/mlx5: DR, Remove HW specific STE type from nic domain
      net/mlx5: DR, Remove rehash ctrl struct from dr_htbl
      net/mlx5: DR, Improve rule tracking memory consumption
      net/mlx5: DR, Add support for update FTE

 .../mellanox/mlx5/core/steering/dr_action.c        | 271 ++++++++++++++++-----
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   1 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |   8 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   4 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  16 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c | 150 ++++++------
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  17 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  36 +--
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |   2 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  57 +++--
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        | 101 +++++++-
 .../mellanox/mlx5/core/steering/dr_types.h         |  68 ++++--
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  51 +++-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |   6 -
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   4 +-
 15 files changed, 556 insertions(+), 236 deletions(-)
