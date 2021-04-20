Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CAC3650C2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbhDTDVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhDTDVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 872A8600EF;
        Tue, 20 Apr 2021 03:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888833;
        bh=6qA7/K26k0A3w45tVRFqef1ScQ5+I7GZ+mdAIYhac9A=;
        h=From:To:Cc:Subject:Date:From;
        b=KnG0nwSl4R1zSVwpdHU+6uUM9mkjekONZ8FYVvIHWmy7pj6wAsbTh8adVoWfVRBOP
         CIeUz5wULWDPO+8vfl2Phm81R1QGcsoB9OQ4zZRETMF5G1Lz269eW9rGZ+JMJ+EJyE
         dgldFST4S3MJoStEGumn2Ka74vGxXZjLHgbcd3Y8TNQmzC2NNscfb/ctf2jYNdwIS+
         gykQTI6t94qUhFDp4PowjtBEGGMagIcbRj2xT7M5SEUI5xLmSu+PegwCGYnsroYgnO
         j5bd0qep96eoD2EaeAicFfhb8QYQ1xfNxDg/ZbJ5C+TmhQmLkYyp9QFQUHC4MOlJEq
         4cj0pUziob0xg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2021-04-19
Date:   Mon, 19 Apr 2021 20:20:03 -0700
Message-Id: <20210420032018.58639-1-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides updates for mlx5, mostly around mlx5 software
steering

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit e9377a911d772d27ef2810c241154ba479bad368:

  ethtool: add missing EEPROM to list of messages (2021-04-19 16:29:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-04-19

for you to fetch changes up to aeacb52a8de7046be5399ba311f49bce96e1b269:

  net/mlx5: DR, Add support for isolate_vl_tc QP (2021-04-19 20:17:46 -0700)

----------------------------------------------------------------
mlx5-updates-2021-04-19

This patchset provides some updates to mlx5e and mlx5 SW steering drivers:

1) Tariq and Vladyslav they both provide some trivial update to mlx5e netdev.

The next 12 patches in the patchset are focused toward mlx5 SW steering:
2) 3 trivial cleanup patches

3) Dynamic Flex parser support:
   Flex parser is a HW parser that can support protocols that are not
    natively supported by the HCA, such as Geneve (TLV options) and GTP-U.
    There are 8 such parsers, and each of them can be assigned to parse a
    specific set of protocols.

4) Enable matching on Geneve TLV options

5) Use Flex parser for MPLS over UDP/GRE

6) Enable matching on tunnel GTP-U and GTP-U first extension
   header using

7) Improved QoS for SW steering internal QPair for a better insertion rate

----------------------------------------------------------------
Muhammad Sammar (1):
      net/mlx5: DR, Remove protocol-specific flex_parser_3 definitions

Tariq Toukan (2):
      net/mlx5e: Fix lost changes during code movements
      net/mlx5e: RX, Add checks for calculated Striding RQ attributes

Vladyslav Tarasiuk (1):
      net/mlx5e: Fix possible non-initialized struct usage

Yevgeny Kliteynik (11):
      net/mlx5: DR, Rename an argument in dr_rdma_segments
      net/mlx5: DR, Fix SQ/RQ in doorbell bitmask
      net/mlx5: E-Switch, Improve error messages in term table creation
      net/mlx5: mlx5_ifc updates for flex parser
      net/mlx5: DR, Add support for dynamic flex parser
      net/mlx5: DR, Set STEv0 ICMP flex parser dynamically
      net/mlx5: DR, Add support for matching on geneve TLV option
      net/mlx5: DR, Set flex parser for TNL_MPLS dynamically
      net/mlx5: DR, Add support for matching tunnel GTP-U
      net/mlx5: DR, Add support for force-loopback QP
      net/mlx5: DR, Add support for isolate_vl_tc QP

 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  91 +++--
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  15 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  14 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |  66 ++++
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 256 ++++++++++++--
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  11 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  51 ++-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 145 +++++++-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |  31 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        | 366 ++++++++++++++++++---
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        | 270 ++++++++++++++-
 .../mellanox/mlx5/core/steering/dr_types.h         | 101 +++++-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |  16 +-
 include/linux/mlx5/device.h                        |   7 +-
 include/linux/mlx5/mlx5_ifc.h                      |  43 ++-
 17 files changed, 1339 insertions(+), 173 deletions(-)
