Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DE841E4AC
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345182AbhI3XWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhI3XWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 873F2619E7;
        Thu, 30 Sep 2021 23:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044053;
        bh=oD1ZvNDz/D9J/jdSztTuoSvXSpqy09g/lD0JnXkNtlQ=;
        h=From:To:Cc:Subject:Date:From;
        b=O1RE9nqLZjbu4nHK446wA1N6P90H0K/hKq85bSaGyh1UWkAwBdjFIJ6tg3x1rZBoT
         MsDtFduvZwkuK8vmaaAS/GZMhWHecIiJfyCH19vYTWhZt5wEZ3OeR2FBPssC1OeGZS
         S2BdrMwVRbs7ku0KOQjmkGnxSqV8Hv/zJ3ISya8eUQSjzmyYBf1paNavHCcKmImLrf
         LKRRKODrg+PXsJ0HHlAVUhXn1wRxx5Sjs7tBPJEcB2BmqiYThIpPNxklvGZIjhB9yk
         UNSYjuQLs80xQ/du0l9uzwE4C9ee7xNfyX4IEGmjAS7ivXhRFmW6mWdvDXAiyrFAp0
         QfID4BDHZyj1Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-09-30
Date:   Thu, 30 Sep 2021 16:20:35 -0700
Message-Id: <20210930232050.41779-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides misc mlx5 updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit dd9a887b35b01d7027f974f5e7936f1410ab51ca:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-09-30 14:49:21 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-09-30

for you to fetch changes up to 51984c9ee01e784ff578e583678958709b18f7b7:

  net/mlx5e: Use array_size() helper (2021-09-30 16:19:02 -0700)

----------------------------------------------------------------
mlx5-updates-2021-09-30

Misc mlx5 updates:

1) SW steering, Vports handling and SFs support

From Yevgeny Kliteynik
======================
This patch series deals with vport handling in SW steering.

For every vport, SW steering queries FW for this vport's properties,
such as RX/TX ICM addresses to be able to add this vport as dest action.
The following patches rework vport capabilities managements and add support
for Scalable Functions (SFs).

 - Patch 1 fixes the vport number data type all over the DR code to 16 bits
   in accordance with HW spec.
 - Patch 2 replaces local SW steering WIRE_PORT macro with the existing
   mlx5 define.
 - Patch 3 adds missing query for vport 0 and and handles eswitch manager
   capabilities for ECPF (BlueField in embedded CPU mode).
 - Patch 4 fixes error messages for failure to obtain vport caps from
   different locations in the code to have the same verbosity level and
   similar wording.
 - Patch 5 adds support for csum recalculation flow tables on SFs: it
   implements these FTs management in XArray instead of the fixed size array,
   thus adding support for csum recalculation table for any valid vport.
 - Patch 6 is the main patch of this whole series: it refactors vports
   capabilities handling and adds SFs support.

======================

2) Minor and trivial updates and cleanups

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5: Tolerate failures in debug features while driver load

Gustavo A. R. Silva (3):
      net/mlx5: Use kvcalloc() instead of kvzalloc()
      net/mlx5: Use struct_size() helper in kvzalloc()
      net/mlx5e: Use array_size() helper

Lama Kayal (1):
      net/mlx5: Warn for devlink reload when there are VFs alive

Yevgeny Kliteynik (10):
      net/mlx5: DR, Fix vport number data type to u16
      net/mlx5: DR, Replace local WIRE_PORT macro with the existing MLX5_VPORT_UPLINK
      net/mlx5: DR, Add missing query for vport 0
      net/mlx5: DR, Align error messages for failure to obtain vport caps
      net/mlx5: DR, Support csum recalculation flow table on SFs
      net/mlx5: DR, Add support for SF vports
      net/mlx5: DR, Increase supported num of actions to 32
      net/mlx5: DR, Fix typo 'offeset' to 'offset'
      net/mlx5: DR, init_next_match only if needed
      net/mlx5: DR, Add missing string for action type SAMPLER

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  10 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   4 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |  19 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   6 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        | 212 ++++++++++++++-------
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   4 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  13 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  18 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  47 ++---
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   2 +-
 16 files changed, 215 insertions(+), 146 deletions(-)
