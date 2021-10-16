Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B88442FF72
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhJPAlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232480AbhJPAlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FCB161073;
        Sat, 16 Oct 2021 00:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344743;
        bh=wdUvTeA5V7uxY/cTDGKimXSBVSAcUiCtAa+hSyqEzQM=;
        h=From:To:Cc:Subject:Date:From;
        b=dJp67fSEnEEo5WuPqc67ST5AETySNEzwh8eWCT8YvPF2I5N5EUhqUA2o9s3s+DzQw
         W8aL6v6IixPCl3PX6UFl8WISIGx1E9EI3fN/YNXooOPt7D6qnqlZRKHEsF05SxqMNO
         4uREM9foKyUFi7aWANZ4GNHqrWLfajE0G64NSti4sjBwEety0BzvSks2GYnRo6vAUg
         +XS9OM9P4QC+Lf9APMlh21d6DRLD18G2G8o+vk7yFIXje6Y3IcixLPmwg/uAD5gXCh
         yCpoeUtYYjMVl8NNonaxBY1FoTYl9k7L4erC1BNe7+bujXCGAMSGe9iIcliOol+IWs
         Tq5qvkZ8TByvA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/13] mlx5 updates 2021-10-15
Date:   Fri, 15 Oct 2021 17:38:49 -0700
Message-Id: <20211016003902.57116-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Jakub,

This series provides updates to mlx5 driver.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 295711fa8fec42a55623bf6997d05a21d7855132:

  Merge branch 'dpaa2-irq-coalescing' (2021-10-15 14:32:41 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-10-15

for you to fetch changes up to 8a543184d79c83d0887c25cf202a43559ba39583:

  net/mlx5: Use system_image_guid to determine bonding (2021-10-15 17:37:47 -0700)

----------------------------------------------------------------
mlx5-updates-2021-10-15

1) From Rongwei Liu:

Use system_image_guid and native_port_num when bonding.
Don't relay on PCIe ids anymore.

With some specific NIC, the physical devices may have PCIe IDs like
0001:01:00.0/1 and 0002:02:00.0/1. All of these devices should have
the same system_image_guid and device index can be queried from
native_port_num.

For matching sibling devices/port of the same HCA, compare the HCA
GUID reported on each device rather than just assuming PCIe ids have
similar attributes.

2) From Amir Tzin: Use HCA defined Timouts

Replace hard coded timeouts with values stored by firmware in default
timeouts register (DTOR). Timeouts are read during driver load. If DTOR
is not supported by firmware then fallback to hard coded defaults
instead.

3) From Shay Drory: Disable roce at HCA level
Disable RoCE in Firmware when devlink roce parameter is set to off.

4) A small set of trivial cleanups

----------------------------------------------------------------
Abhiram R N (1):
      net/mlx5e: Add extack msgs related to TC for better debug

Amir Tzin (3):
      net/mlx5: Add layout to support default timeouts register
      net/mlx5: Read timeout values from init segment
      net/mlx5: Read timeout values from DTOR

Len Baker (1):
      net/mlx5: DR, Prefer kcalloc over open coded arithmetic

Moosa Baransi (1):
      net/mlx5i: Enable Rx steering for IPoIB via ethtool

Paul Blakey (1):
      net/mlx5: CT: Fix missing cleanup of ct nat table on init failure

Rongwei Liu (4):
      net/mlx5: Check return status first when querying system_image_guid
      net/mlx5: Introduce new device index wrapper
      net/mlx5: Use native_port_num as 1st option of device index
      net/mlx5: Use system_image_guid to determine bonding

Shay Drory (1):
      net/mlx5: Disable roce at HCA level

Vlad Buslov (1):
      net/mlx5: Bridge, provide flow source hints

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  18 ++-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   8 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   1 -
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   7 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   6 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 106 ++++++++++----
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   4 +
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   4 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |  21 ++-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  30 ++++
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c | 162 +++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |  41 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  69 ++++++---
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  16 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   2 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  21 +--
 include/linux/mlx5/device.h                        |   4 +-
 include/linux/mlx5/driver.h                        |  25 +++-
 include/linux/mlx5/mlx5_ifc.h                      |  40 ++++-
 32 files changed, 529 insertions(+), 133 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
