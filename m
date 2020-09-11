Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E564266932
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgIKTxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgIKTxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 15:53:07 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FB7721D47;
        Fri, 11 Sep 2020 19:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599853986;
        bh=3GCJphc7UjVHKhd/GGloiV9MiwhirAqjRnCpesjUTKU=;
        h=From:To:Cc:Subject:Date:From;
        b=xWa0QdTOioqRaLN7EHHnAc0k1PEjswnEt5mdkwchMVMY8aY3zlUVSBU2hocoYlaA1
         M6xsTRRMRIfzhBIpOtBnXx1kkLENBAL/SVoB0J0CAr4DvAfb8HeIqO7ozlQZuuo8wG
         1meP4122/rl4gIqFQh/Lf4w2uWs5cMmD5mp3TU1w=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com, andrew@lunn.ch,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/7] ethtool: add pause frame stats
Date:   Fri, 11 Sep 2020 12:52:50 -0700
Message-Id: <20200911195258.1048468-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This is the first (small) series which exposes some stats via
the corresponding ethtool interface. Here (thanks to the
excitability of netlink) we expose pause frame stats via
the same interfaces as ethtool -a / -A.

In particular the following stats from the standard:
 - 30.3.4.2 aPAUSEMACCtrlFramesTransmitted
 - 30.3.4.3 aPAUSEMACCtrlFramesReceived

4 real drivers are converted, hopefully the semantics match
the standard.

Jakub Kicinski (8):
  ethtool: add standard pause stats
  docs: net: include the new ethtool pause stats in the stats doc
  netdevsim: add pause frame stats
  selftests: add a test for ethtool pause stats
  bnxt: add pause frame stats
  mlx5: add pause frame stats
  ixgbe: add pause frame stats
  mlx4: add pause frame stats

 Documentation/networking/ethtool-netlink.rst  |  11 ++
 Documentation/networking/statistics.rst       |  57 ++++++++-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  19 +++
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  11 ++
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |  19 +++
 .../net/ethernet/mellanox/mlx4/mlx4_stats.h   |  12 ++
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   2 +
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  15 +++
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   9 ++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  30 +++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   3 +
 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/ethtool.c               |  64 +++++++++++
 drivers/net/netdevsim/netdev.c                |   1 +
 drivers/net/netdevsim/netdevsim.h             |  11 ++
 include/linux/ethtool.h                       |  26 +++++
 include/uapi/linux/ethtool_netlink.h          |  18 ++-
 net/ethtool/pause.c                           |  57 ++++++++-
 .../drivers/net/netdevsim/ethtool-pause.sh    | 108 ++++++++++++++++++
 19 files changed, 467 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/netdevsim/ethtool.c
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh

-- 
2.26.2

