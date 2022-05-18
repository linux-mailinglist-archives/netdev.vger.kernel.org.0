Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF35852B2B7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 08:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiERGtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiERGtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:49:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715C42228A
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E63760C05
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D998C385A5;
        Wed, 18 May 2022 06:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652856583;
        bh=ERk/q7yynBn3ExG67f6Nm4Kbn1V+ovT7TBB5z8v86KQ=;
        h=From:To:Cc:Subject:Date:From;
        b=bOkyiHC7dR7rCq37jxK+k5lDCx/0i6+QtkSKi+scw9Tv8cowxH05RB8j9/Dikz8Vw
         Iu5GklFi4ZmjwGoQtqzjiMQjHvH2bGdL+b1Gln4Yc83BE2O86GNdZ67MnSs0bHLmco
         w/jdX1BksAHhtkxQX4atpxeVtzt5SiiYiblU+1nT331gEFepCKVSsHHWncZOwQSXBY
         kMBvBPt5O1Mn/b82gKcpSnApMgEaZz5yiUGfv73pYjxpXkYuNcHlnf+puN0l97fJde
         KADnTrdN4I6M/14XTP+OSMwJaNAcUR9aeEI78N0wx24/6Oz6rL9pd4mxdytFIpQVjM
         X3ZuKXQ0l+Rtg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2022-05-17
Date:   Tue, 17 May 2022 23:49:22 -0700
Message-Id: <20220518064938.128220-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series adds misc updates and Multi "uplink" port eswitch support
For more information please see tag log below.

Please pull and let me know if there is any problem.

There will be a minor conflict, mostly contextual when net-next is merged with
the current mlx5 net PR [1], I will provide resolution details if necessary. 

[1] https://patchwork.kernel.org/project/netdevbpf/list/?series=642587

Thanks,
Saeed.


The following changes since commit 6e144b47f560edc25744498f360835b1042b73dd:

  octeontx2-pf: Add support for adaptive interrupt coalescing (2022-05-17 18:05:28 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-05-17

for you to fetch changes up to 94db3317781922ba52722c58061e0e8517d4d80d:

  net/mlx5: Support multiport eswitch mode (2022-05-17 23:41:51 -0700)

----------------------------------------------------------------
mlx5-updates-2022-05-17

MISC updates to mlx5 dirver

1) Aya Levin allows relaxed ordering over VFs

2) Gal Pressman Adds support XDP SQs for uplink representors in switchdev mode

3) Add debugfs TC stats and command failure syndrome for debuggability

4) Tariq uses variants of vzalloc where it could help

5) Multiport eswitch support from Elic Cohen:

Eli Cohen Says:
===============

The multiport eswitch feature allows to forward traffic from a
representor net device to the uplink port of an associated eswitch's
uplink port.

This feature requires creating a LAG object. Since LAG can be created
only once for a function, the feature is mutual exclusive with either
bonding or multipath.

Multipath eswitch mode is entered automatically these conditions are
met:
1. No other LAG related mode is active.
2. A rule that explicitly forwards to an uplink port is inserted.

The implementation maintains a reference count on such rules. When the
reference count reaches zero, the LAG is released and other modes may be
used.

When an explicit rule that explicitly forwards to an uplink port is
inserted while another LAG mode is active, that rule will not be
offloaded by the hardware since the hardware cannot guarantee that the
rule will actually be forwarded to that port.

Example rules that forwards to an uplink port is:

$ tc filter add dev rep0 root flower action mirred egress \
  redirect dev uplinkrep0

$ tc filter add dev rep0 root flower action mirred egress \
  redirect dev uplinkrep1

This feature is supported only if LAG_RESOURCE_ALLOCATION firmware
configuration parameter is set to true.

The series consists of three patches:
1. Lag state machine refactor
   This patch does not add new functionality but rather changes the way
   the state of the LAG is maintained.
2. Small fix to remove unused argument.
3. The actual implementation of the feature.
===============

----------------------------------------------------------------
Aya Levin (1):
      net/mlx5e: Allow relaxed ordering over VFs

Eli Cohen (3):
      net/mlx5: Lag, refactor lag state machine
      net/mlx5: Remove unused argument
      net/mlx5: Support multiport eswitch mode

Gal Pressman (3):
      net/mlx5e: IPoIB, Improve ethtool rxnfc callback structure in IPoIB
      net/mlx5e: Support partial GSO for tunnels over vlans
      net/mlx5e: Add XDP SQs to uplink representors steering tables

Moshe Shemesh (1):
      net/mlx5: Add last command failure syndrome to debugfs

Moshe Tal (1):
      net/mlx5e: Correct the calculation of max channels for rep

Saeed Mahameed (2):
      net/mlx5: sparse: error: context imbalance in 'mlx5_vf_get_core_dev'
      net/mlx5e: CT: Add ct driver counters

Tariq Toukan (5):
      net/mlx5: Inline db alloc API function
      net/mlx5: Allocate virtually contiguous memory in vport.c
      net/mlx5: Allocate virtually contiguous memory in pci_irq.c
      net/mlx5e: Allocate virtually contiguous memory for VLANs list
      net/mlx5e: Allocate virtually contiguous memory for reps structures

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |   6 -
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |  14 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  52 +++++-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  35 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  28 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   7 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   3 +
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |  14 +-
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |  21 +--
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  | 192 +++++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |  41 +++--
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    | 101 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |  26 +++
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 -
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  52 +++---
 include/linux/mlx5/driver.h                        |   9 +-
 include/linux/mlx5/mlx5_ifc.h                      |   5 +-
 27 files changed, 489 insertions(+), 166 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h
