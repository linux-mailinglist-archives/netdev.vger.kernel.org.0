Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31174440476
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhJ2U7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhJ2U7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECB2061056;
        Fri, 29 Oct 2021 20:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541003;
        bh=W3ODlFsjIKGUfeCJcduHT4dlu9g9RzqKebrh/AvNZfQ=;
        h=From:To:Cc:Subject:Date:From;
        b=XnovX32okbZ6oYpif+V4rMiI/9g1bvmkNDn41fbfcjep5aaMYn24VvNKuE3uK5UGM
         SHRLPXntTaS0P/y8jSDDeLji1PPqHsZcyTdpDSEy32P4UmU+QzAvQ0H7De3Bnexkvn
         p4XgZUhTtQVRvkcJH/YJwt++/wYCKlEgHNWYnP5PMZgbuWkJZlOYOWD7JtgwMNQI4F
         Buh3AEl2+Ie3wC5MKCl5QdHnR0orfXn/bimpucl7xYItaL4LMhB75vosVNiSJi7Z/k
         dMUIHco+EMox22omc4/JgtamYBbtvisJYFJdfBl56M4xazAuxJRaK4ktW/IztesS+F
         PlgIC5/TdRPZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/14] mlx5 updates 2021-10-29
Date:   Fri, 29 Oct 2021 13:56:18 -0700
Message-Id: <20211029205632.390403-1-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave and Jakub,

This pull request provides some misc updates and the support
for TC offload of OVS internal ports.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

The following changes since commit 28131d896d6d316bc1f6f305d1a9ed6d96c3f2a1:

  Merge tag 'wireless-drivers-next-2021-10-29' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next (2021-10-29 08:58:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2021-10-29

for you to fetch changes up to b16eb3c81fe27978afdb2c111908d4d627a88d99:

  net/mlx5: Support internal port as decap route device (2021-10-29 13:53:31 -0700)

----------------------------------------------------------------
mlx5-updates-2021-10-29

1) Minor trivial refactoring and improvements
2) Check for unsupported parameters fields in SW steering
3) Support TC offload for OVS internal port, from Ariel, see below.

Ariel Levkovich says:

=====================

Support HW offload of TC rules involving OVS internal port
device type as the filter device or the destination
device.

The support is for flows which explicitly use the internal
port as source or destination device as well as indirect offload
for flows performing tunnel set or unset via a tunnel device
and the internal port is the tunnel overlay device.

Since flows with internal port as source port are added
as egress rules while redirecting to internal port is done
as an ingress redirect, the series introduces the necessary
changes in mlx5_core driver to support the new types of flows
and actions.

=====================

----------------------------------------------------------------
Ariel Levkovich (9):
      net/mlx5e: Refactor rx handler of represetor device
      net/mlx5e: Use generic name for the forwarding dev pointer
      net/mlx5: E-Switch, Add ovs internal port mapping to metadata support
      net/mlx5e: Accept action skbedit in the tc actions list
      net/mlx5e: Offload tc rules that redirect to ovs internal port
      net/mlx5e: Offload internal port as encap route device
      net/mlx5e: Add indirect tc offload of ovs internal port
      net/mlx5e: Term table handling of internal port rules
      net/mlx5: Support internal port as decap route device

Muhammad Sammar (1):
      net/mlx5: DR, Add check for unsupported fields in match param

Nathan Chancellor (1):
      net/mlx5: Add esw assignment back in mlx5e_tc_sample_unoffload()

Paul Blakey (2):
      net/mlx5: CT: Remove warning of ignore_flow_level support for VFs
      net/mlx5: Allow skipping counter refresh on creation

Raed Salem (1):
      net/mlx5e: IPsec: Refactor checksum code in tx data path

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    | 118 ++++--
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.h    |  14 +-
 .../ethernet/mellanox/mlx5/core/en/tc/int_port.c   | 457 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/tc/int_port.h   |  65 +++
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |  13 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  36 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  32 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |  35 ++
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  26 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 193 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  20 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   8 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  60 ++-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |  14 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  28 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  | 272 ++++++------
 .../mellanox/mlx5/core/steering/dr_types.h         |   3 +-
 include/linux/mlx5/fs.h                            |   4 +
 27 files changed, 1193 insertions(+), 267 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.h
