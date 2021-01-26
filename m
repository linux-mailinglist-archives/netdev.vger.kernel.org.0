Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44941305195
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238538AbhA0EZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:25:08 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8201 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388668AbhAZXZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:22 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4b70000>; Tue, 26 Jan 2021 15:24:39 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 devlink trap support
Date:   Tue, 26 Jan 2021 15:24:05 -0800
Message-ID: <20210126232419.175836-1-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703479; bh=BlNYq1rbnJj0Lm6j2VO44w1uKOBrwjFfEb8Fdm5CbiU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=pHudfSfHH4RTh7Sn1AwfVm5wW6FGQQjD/6FqkDsLKv+5+TeyNSvgHDwALW8iy3NrI
         sbu/GZqQamHP6BWkRhGsVQJ5AyulGahFhzMaecMi5y3N0PK8y+RGsmai5Stvlcdbn5
         uSoxUkFspjZq5Pdh8rfqusvygxqk+FkYeJp3Avry3lHFbJ+MRs2aZCJEpevFPnx6dK
         B5Df1NIT6ltWnZwEflxsKtV7+//uYd17F1xYa8A/yjAAKMhrBhW6glMxsngGfkbxOM
         tgYxsDlrkFUPSYORHLjpC1CjlxRfEo6U9XKJZQUbQwrLQPFIgfqaGggcRk7Kxds15m
         W69HG/DbZBVdQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Dave,

This series adds devlink trap support to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 02c26940908fd31bb112e9742adedfb06eca19e1=
:

  nfc: fix typo (2021-01-25 19:35:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2021-01-26

for you to fetch changes up to 243898b5d77445555e8de350269fd879f2283208:

  net/mlx5e: Enable traps according to link state (2021-01-26 14:22:09 -080=
0)

----------------------------------------------------------------
mlx5-updates-2021-01-26

mlx5 devlink traps support:

Add support for devlink traps [1] reporting in mlx5,
mlx5 will also report/trap packets filtered due to dest mac steering miss

The first patch in the series defines the new DMAC trap type in devlink
for this purpose.

Other patches in the series are mlx5 only and they gradually traps support.
Supported traps:

DMAC: Drops due to destination MAC not configured in the MAC table
VLAN: Drops due to vlan not configured in the vlan table

Design note:
devlink instance is managed by the low level mlx5 core layer, mlx5 core wil=
l
serve as an abstraction layer for trap reporting, since we might have multi=
ple
mlx5 interfaces who might want to report traps on the same device.

----------------------------------------------------------------
Aya Levin (14):
      devlink: Add DMAC filter generic packet trap
      net/mlx5: Add support for devlink traps in mlx5 core driver
      net/mlx5: Register to devlink ingress VLAN filter trap
      net/mlx5: Register to devlink DMAC filter trap
      net/mlx5: Rename events notifier header
      net/mlx5: Notify on trap action by blocking event
      net/mlx5e: Optimize promiscuous mode
      net/mlx5e: Add flow steering VLAN trap rule
      net/mlx5e: Add flow steering DMAC trap rule
      net/mlx5e: Expose RX dma info helpers
      net/mlx5e: Add trap entity to ETH driver
      net/mlx5e: Add listener to trap event
      net/mlx5e: Add listener to DMAC filter trap event
      net/mlx5e: Enable traps according to link state

 Documentation/networking/devlink/devlink-trap.rst |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 188 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h |  18 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h   |  16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c | 457 ++++++++++++++++++=
++++
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.h |  37 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   | 212 ++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  52 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |  46 +++
 drivers/net/ethernet/mellanox/mlx5/core/events.c  |  47 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   2 +
 include/linux/mlx5/device.h                       |   9 +
 include/linux/mlx5/driver.h                       |  16 +
 include/net/devlink.h                             |   3 +
 net/core/devlink.c                                |   1 +
 18 files changed, 1076 insertions(+), 49 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/trap.h
