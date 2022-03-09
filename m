Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704264D3C2C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238291AbiCIVjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiCIVjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C2154BC7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF4A0B82020
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C57BC340E8;
        Wed,  9 Mar 2022 21:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861884;
        bh=AXkcP7kepdP6juNN6pcj65GALnL+XfSA9O6tVg/unhA=;
        h=From:To:Cc:Subject:Date:From;
        b=uipN401Ah1i3d/LeciQXEx72z6+xxFJWQ6BfqfberyADp/Q1CS6dFwirDWyYVcFeX
         cuGpFA9uWZrnkeihJEkFgzTPweZPF9jAN9V1uH4X5iDp+v8qhaZYOuG8X2Eqmcpwgi
         grhB/3nmrPNN9zS+g+SLCYbhEtIspMos7OcQE7i6a0RjQcyWtAbN1H94/BzifQQ5uJ
         OYvX5pNSUuXKqGyOhiosyngsUQw1MqX0YRySkv5B+Iz30AdbUuHgi1L3USVIFQ6LUg
         afQNQ8Nr3OhWHkJY8D051aV/SGCrLzi7zW0ly4DaSlDbGg7vV2fSrKPf463OgTmn78
         Ri7XMkAkcerTg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [pull request][net-next 00/16] mlx5 updates 2022-03-09
Date:   Wed,  9 Mar 2022 13:37:39 -0800
Message-Id: <20220309213755.610202-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Hi Dave, Hi Jakub,

This pull request adds two mlx5 updates.
 
 1) debugfs for to provide stats on FW command failures, especially the
to eliminate kernel log on FW events for FW page management commands.
 
 2) Support Software steering for ConnectX-7 device.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 24055bb87977e0c687b54ebf7bac8715f3636bc3:

  net: tcp: fix shim definition of tcp_inbound_md5_hash (2022-03-09 08:44:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-03-09

for you to fetch changes up to 6862c787c7e88df490675ed781dc9052dba88a56:

  net/mlx5: DR, Add support for ConnectX-7 steering (2022-03-09 13:33:04 -0800)

----------------------------------------------------------------
mlx5-updates-2022-03-09

1) Remove kernel log prints on FW events regarding FW pages management
   and replace that with debugfs entries to track FW pages management commands
   failures and general stats, we do that for all FW commands in general since
   it's the same effort to do so under the already existing debugfs entry for
   FW commands.

2) Add support for ConnectX-7 Software managed steering, in other words STEv2
   which shares a lot in common with STE V1, the difference is in specific
   offsets in the devices, the logic is almost the same, thus we implement
   STEv1 and STEv2 in the same file.

----------------------------------------------------------------
Dan Carpenter (1):
      net/mlx5e: TC, Fix use after free in mlx5e_clone_flow_attr_for_post_act()

Moshe Shemesh (8):
      net/mlx5: Add command failures data to debugfs
      net/mlx5: Remove redundant notify fail on give pages
      net/mlx5: Remove redundant error on give pages
      net/mlx5: Remove redundant error on reclaim pages
      net/mlx5: Change release_all_pages cap bit location
      net/mlx5: Move debugfs entries to separate struct
      net/mlx5: Add pages debugfs
      net/mlx5: Add debugfs counters for page commands failures

Shun Hao (1):
      net/mlx5: DR, Align mlx5dv_dr API vport action with FW behavior

Yevgeny Kliteynik (6):
      net/mlx5: DR, Add support for matching on Internet Header Length (IHL)
      net/mlx5: DR, Remove unneeded comments
      net/mlx5: DR, Fix handling of different actions on the same STE in STEv1
      net/mlx5: DR, Rename action modify fields to reflect naming in HW spec
      net/mlx5: DR, Refactor ste_ctx handling for STE v0/1
      net/mlx5: DR, Add support for ConnectX-7 steering

 drivers/infiniband/hw/mlx5/cong.c                  |   3 +-
 drivers/infiniband/hw/mlx5/main.c                  |   2 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  46 +++-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  58 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   8 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |  40 +++-
 .../mellanox/mlx5/core/steering/dr_action.c        |  12 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |   2 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |   2 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  19 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  24 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |   7 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  10 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        | 253 +++++++++++----------
 .../mellanox/mlx5/core/steering/dr_ste_v1.h        |  94 ++++++++
 .../mellanox/mlx5/core/steering/dr_ste_v2.c        | 231 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_types.h         |   5 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   2 +-
 include/linux/mlx5/driver.h                        |  38 +++-
 include/linux/mlx5/mlx5_ifc.h                      |   9 +-
 24 files changed, 665 insertions(+), 207 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
