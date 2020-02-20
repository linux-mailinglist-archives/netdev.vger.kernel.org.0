Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DA4166031
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 15:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgBTO7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 09:59:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgBTO7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 09:59:01 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11B4D208E4;
        Thu, 20 Feb 2020 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582210740;
        bh=qrRcJ5x7ii9Y24YqqYS31Gz/fkiLGCK0d+o/TrbU1Ok=;
        h=From:To:Cc:Subject:Date:From;
        b=O27VRgjJQa0WF7urhQYCIY26wZUMWTfj7LuMjZZD1TDzieIWhZVvl1V2kbxR0RudN
         9K2QpA+RgAmKQvUvGgAWeHWmF3sBhkVOWXzS3Ni1CBIMXwNiZUs4StrIOUdk3GN6Cw
         IJYsBzPtEVO0aTdCu8BEcBoNBdOs+kreVKDfTUNo=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net-next 00/16] Clean driver, module and FW versions
Date:   Thu, 20 Feb 2020 16:58:39 +0200
Message-Id: <20200220145855.255704-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is first patchset to netdev (already sent RDMA [1] and arch/um)
in attempt to unify the version management for in-tree kernel code.
The patches follow already accepted ethtool change [2] to set as
a default linux kernel version.

It allows us to remove driver version and present to the users unified
picture of driver version, which is similar to default MODULE_VERSION().

As part of this series, I deleted various creative attempts to mark
absence of FW. There is no need to set "N/A" in ethtool ->fw_version
field and it is enough to do not set it.

1.
The code is compile tested and passes 0-day kbuild.
2.
The proposed changes are based on commit:
  2bb07f4e1d86 ("tc-testing: updated tdc tests for basic filter")
3.
WIP branch is [3].

[1] https://lore.kernel.org/linux-rdma/20200220071239.231800-1-leon@kernel.org/
[2] https://lore.kernel.org/linux-rdma/20200127072028.19123-1-leon@kernel.org/
[3] https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=ethtool

Leon Romanovsky (16):
  net/bond: Delete driver and module versions
  net/dummy: Ditch driver and module versions
  net/3com: Delete driver and module versions from 3com drivers
  net/adaptec: Clean driver versions
  net/aeroflex: Clean ethtool_info struct assignments
  net/agere: Delete unneeded driver version
  net/alacritech: Delete driver version
  net/allwinner: Remove driver version
  net/alteon: Properly report FW version
  net/althera: Delete hardcoded driver version
  net/amazon: Ensure that driver version is aligned to the linux kernel
  net/amd: Remove useless driver version
  net/apm: Remove useless driver version and properly mark lack of FW
  net/aquantia: Delete module version
  net/arc: Delete driver version
  net/atheros: Clean atheros code from driver version

 drivers/net/bonding/bond_main.c                 |  4 +---
 drivers/net/bonding/bonding_priv.h              |  4 ++--
 drivers/net/dummy.c                             |  3 ---
 drivers/net/ethernet/3com/3c509.c               |  7 +------
 drivers/net/ethernet/3com/3c515.c               |  6 ++----
 drivers/net/ethernet/3com/3c589_cs.c            |  2 --
 drivers/net/ethernet/3com/typhoon.c             |  1 -
 drivers/net/ethernet/adaptec/starfire.c         | 11 +++++------
 drivers/net/ethernet/aeroflex/greth.c           |  2 --
 drivers/net/ethernet/agere/et131x.c             |  1 -
 drivers/net/ethernet/agere/et131x.h             |  1 -
 drivers/net/ethernet/alacritech/slicoss.c       |  3 ---
 drivers/net/ethernet/allwinner/sun4i-emac.c     |  2 --
 drivers/net/ethernet/alteon/acenic.c            |  5 ++---
 .../net/ethernet/altera/altera_tse_ethtool.c    |  1 -
 drivers/net/ethernet/amazon/ena/ena_ethtool.c   |  1 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c    | 17 ++---------------
 drivers/net/ethernet/amazon/ena/ena_netdev.h    | 11 -----------
 drivers/net/ethernet/amd/amd8111e.c             |  5 +----
 drivers/net/ethernet/amd/au1000_eth.c           |  5 -----
 drivers/net/ethernet/amd/nmclan_cs.c            |  9 +++------
 drivers/net/ethernet/amd/pcnet32.c              |  7 -------
 drivers/net/ethernet/amd/sunlance.c             | 10 ----------
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c    |  1 -
 drivers/net/ethernet/amd/xgbe/xgbe-main.c       |  1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h            |  1 -
 drivers/net/ethernet/apm/xgene-v2/ethtool.c     |  2 --
 drivers/net/ethernet/apm/xgene-v2/main.c        |  1 -
 drivers/net/ethernet/apm/xgene-v2/main.h        |  1 -
 .../net/ethernet/apm/xgene/xgene_enet_ethtool.c |  2 --
 .../net/ethernet/apm/xgene/xgene_enet_main.c    |  1 -
 .../net/ethernet/apm/xgene/xgene_enet_main.h    |  1 -
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h |  4 ----
 .../net/ethernet/aquantia/atlantic/aq_common.h  |  1 -
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c |  1 -
 .../net/ethernet/aquantia/atlantic/aq_main.c    |  1 -
 drivers/net/ethernet/aquantia/atlantic/ver.h    | 12 ------------
 drivers/net/ethernet/arc/emac.h                 |  1 -
 drivers/net/ethernet/arc/emac_arc.c             |  2 --
 drivers/net/ethernet/arc/emac_main.c            |  1 -
 drivers/net/ethernet/arc/emac_rockchip.c        |  2 --
 drivers/net/ethernet/atheros/atl1c/atl1c.h      |  1 -
 .../net/ethernet/atheros/atl1c/atl1c_ethtool.c  |  2 --
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |  5 -----
 drivers/net/ethernet/atheros/atl1e/atl1e.h      |  1 -
 .../net/ethernet/atheros/atl1e/atl1e_ethtool.c  |  2 --
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |  4 ----
 drivers/net/ethernet/atheros/atlx/atl1.c        |  6 ------
 drivers/net/ethernet/atheros/atlx/atl2.c        | 10 ----------
 49 files changed, 19 insertions(+), 166 deletions(-)
 delete mode 100644 drivers/net/ethernet/aquantia/atlantic/ver.h

--
2.24.1

