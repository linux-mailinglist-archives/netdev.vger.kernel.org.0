Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D232EC584
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbhAFVHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:07:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbhAFVHt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:07:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E20052313B;
        Wed,  6 Jan 2021 21:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609967228;
        bh=DXrGwIQQ1Rz83DCz1vivzkPcZVwDgHaOaNpdxL8nX80=;
        h=From:To:Cc:Subject:Date:From;
        b=f2VRCXYBsEd2otlnKh65Uiex2BEaVU9w/391sc1lWoQAJ7qxPCYayIjw/aury/vIK
         JbYAwtj4O7I2QH1f5kSANgi2W07GCjtFgz99/okI99OGZg5/X6WT1XDwXaycdIK9VM
         WYSHQxG8qYTIUg6n1euUVCUP9itZN2WFoDm4TVDbfzCTMbhRQ9MlMzhg5W55YR3BGT
         HhRHfeC3Zj5T816KWnWOjji1vqFy2DVWzsXA52arP2PMPWQk7oFM4l7KxFQ/p7hHqJ
         AZBSAHszZGgP70sKK1QwQxZq68qOQcDqXp5HoFqzYZaXB8GmZkmziAib3o/nOp0d2G
         D7neagMHtFTHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, thomas.lendacky@amd.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        michael.chan@broadcom.com, rajur@chelsio.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, GR-Linux-NIC-Dev@marvell.com,
        ecree.xilinx@gmail.com, simon.horman@netronome.com,
        alexander.duyck@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] udp_tunnel_nic: post conversion cleanup
Date:   Wed,  6 Jan 2021 13:06:33 -0800
Message-Id: <20210106210637.1839662-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It has been two releases since we added the common infra for UDP
tunnel port offload, and we have not heard of any major issues.
Remove the old direct driver NDOs completely, and perform minor
simplifications in the tunnel drivers.

Jakub Kicinski (4):
  udp_tunnel: hard-wire NDOs to udp_tunnel_nic_*_port() helpers
  udp_tunnel: remove REGISTER/UNREGISTER handling from tunnel drivers
  net: remove ndo_udp_tunnel_* callbacks
  udp_tunnel: reshuffle NETIF_F_RX_UDP_TUNNEL_PORT checks

 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 --
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 --
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 --
 .../net/ethernet/cavium/liquidio/lio_main.c   |  2 --
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  2 --
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 --
 drivers/net/ethernet/cisco/enic/enic_main.c   |  4 ----
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 --
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  2 --
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 --
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 --
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  4 ----
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 --
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 --
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 --
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  6 -----
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  2 --
 drivers/net/ethernet/sfc/efx.c                |  2 --
 drivers/net/geneve.c                          | 14 ++++-------
 drivers/net/netdevsim/netdev.c                |  2 --
 drivers/net/vxlan.c                           | 15 ++++--------
 include/linux/netdevice.h                     | 17 -------------
 include/net/udp_tunnel.h                      |  8 +++++++
 net/core/dev.c                                |  2 +-
 net/ipv4/udp_tunnel_core.c                    | 24 ++++---------------
 26 files changed, 22 insertions(+), 106 deletions(-)

-- 
2.26.2

