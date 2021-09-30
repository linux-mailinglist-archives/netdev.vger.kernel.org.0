Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B9A41E49E
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349794AbhI3XQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhI3XQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12FFD611C8;
        Thu, 30 Sep 2021 23:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633043703;
        bh=M6icDje46EQuA4MALY+Z8UzHMdsoA1OMn1epJRjV1BI=;
        h=From:To:Cc:Subject:Date:From;
        b=uJQBMXOa+ss/A1VF1bVBQQkjgScX1WK8DWSKgFNK5IaMZauyRoCQIxTVdiYwTEiED
         pJ0TsqlbQTbh9HSlT4MwGXUk229+Q7XQ4WRnV/y7nfCHf1ofEBUEHf0OAK34bzElEB
         rPfzpx4PkHopngssXUiEFZGnyoKDsCfOCh+9dJGSVF2LKxp0GaefoVOgBtTe5I8ID1
         tuR26ExAY78eSWvbxsLLRWgU+qj7sILpLpDL+Qge9s3uG30GQMBOkyJE+f8rsjd7zr
         OXk9vbcYYDMSavk9Jvy+FX4fjBkpJCRhpqDhJ/aYJBSVjZOqtM4sYYkZh1VujGQeKl
         enVLYdjibEFQg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net 00/10] mlx5 fixes 2021-09-30
Date:   Thu, 30 Sep 2021 16:14:51 -0700
Message-Id: <20210930231501.39062-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub 

This series introduces some fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 35306eb23814444bd4021f8a1c3047d3cb0c8b2b:

  af_unix: fix races in sk_peer_pid and sk_peer_cred accesses (2021-09-30 14:18:40 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-09-30

for you to fetch changes up to 3bf1742f3c69501dec300b55917b9352428cb4dd:

  net/mlx5e: Mutually exclude setting of TX-port-TS and MQPRIO in channel mode (2021-09-30 14:07:57 -0700)

----------------------------------------------------------------
mlx5-fixes-2021-09-30

----------------------------------------------------------------
Aya Levin (3):
      net/mlx5: Force round second at 1PPS out start time
      net/mlx5: Avoid generating event after PPS out in Real time mode
      net/mlx5e: Mutually exclude setting of TX-port-TS and MQPRIO in channel mode

Lama Kayal (1):
      net/mlx5e: Fix the presented RQ index in PTP stats

Moshe Shemesh (1):
      net/mlx5: E-Switch, Fix double allocation of acl flow counter

Raed Salem (1):
      net/mlx5e: IPSEC RX, enable checksum complete

Shay Drory (2):
      net/mlx5: Fix length of irq_index in chars
      net/mlx5: Fix setting number of EQs of SFs

Tariq Toukan (2):
      net/mlx5e: Keep the value for maximum number of channels in-sync
      net/mlx5e: Improve MQPRIO resiliency

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  12 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  11 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 178 +++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  11 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |  12 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |   4 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |  37 ++---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   9 +-
 14 files changed, 194 insertions(+), 105 deletions(-)
