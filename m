Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92E573FD2
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiGMW7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGMW7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E791B29809
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D3C618B0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F26C34114;
        Wed, 13 Jul 2022 22:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753152;
        bh=PZQv3NoxyLWG+EjWxyooV5sFWIFwHmOdRntQ31DHqIY=;
        h=From:To:Cc:Subject:Date:From;
        b=FdcZk58XptNAQ4n1EdS9lKXB02ZvgSnFdO2TMHAKew9tnFg4/purGrLSd45PXnS/I
         rJNum4LoH+cvh4VBtih4/RtRbmDms+Z3Mw2iBAa/0IurHqDn6iuSYtDmhYgIRrfO0M
         7ekGWNV5OeAxOkfS8xUTGE/8eLABIgIlb9ZH+pzbUAXXiqibe7tKIfOBk99oGQMv8L
         KaMKKDtUEdJl0D8PG9tYcLZYZXLhbrfnKfGPPwi1fsFW1WdRe0ySOr/x/KFknh8TRq
         8C2S0TVNX7M5Rso50CwLkyzah71j11iHhDp7ugDlZjaN4c7fymAAZ+ddtCIU7k7N4O
         LOVgqHh2mNU8g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
Subject: [pull request][net-next 00/15] mlx5 updates 2022-07-13
Date:   Wed, 13 Jul 2022 15:58:44 -0700
Message-Id: <20220713225859.401241-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 6a605eb1d71ea8cec50bdf7151c772c599a5fb70:

  octeontx2-af: returning uninitialized variable (2022-07-13 14:51:34 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2022-07-13

for you to fetch changes up to 1a55048674379f9b093e0a6dbef586d28b55f9ae:

  net/mlx5e: Remove the duplicating check for striding RQ when enabling LRO (2022-07-13 15:56:49 -0700)

----------------------------------------------------------------
mlx5-updates-2022-07-13

1) Support 802.1ad for bridge offloads

Vlad Buslov Says:
=================

Current mlx5 bridge VLAN offload implementation only supports 802.1Q VLAN
Ethernet protocol. That protocol type is assumed by default and
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL notification is ignored.

In order to support dynamically setting VLAN protocol handle
SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL notification by flushing FDB and
re-creating VLAN modify header actions with a new protocol. Implement support
for 802.1ad protocol by saving the current VLAN protocol to per-bridge variable
and re-create the necessary flow groups according to its current value (either
use cvlan or svlan flow fields).
==================

2) debugfs to count ongoing FW commands

3) debugfs to query eswitch vport firmware diagnostic counters

4) Add missing meter configuration in flow action

5) Some misc cleanup

----------------------------------------------------------------
Christophe JAILLET (1):
      net/mlx5: Use the bitmap API to allocate bitmaps

Jianbo Liu (1):
      net/mlx5e: configure meter in flow action

Maxim Mikityanskiy (2):
      net/mlx5e: Move the LRO-XSK check to mlx5e_fix_features
      net/mlx5e: Remove the duplicating check for striding RQ when enabling LRO

Michael Guralnik (1):
      net/mlx5: Expose vnic diagnostic counters for eswitch managed vports

Rustam Subkhankulov (1):
      net/mlx5e: Removed useless code in function

Tariq Toukan (1):
      net/mlx5: debugfs, Add num of in-use FW command interface slots

Vlad Buslov (6):
      net/mlx5: Bridge, refactor groups sizes and indices
      net/mlx5: Bridge, rename filter fg to vlan_filter
      net/mlx5: Bridge, extract VLAN push/pop actions creation
      net/mlx5: Bridge, implement infrastructure for VLAN protocol change
      net/mlx5: Bridge, implement QinQ support
      net/mlx5e: Extend flower police validation

Yishai Hadas (2):
      net/mlx5: Introduce ifc bits for using software vhca id
      net/mlx5: Use software VHCA id when it's supported

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |  24 ++
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |   6 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |   6 +
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  18 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   | 408 +++++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |   6 +-
 .../net/ethernet/mellanox/mlx5/core/esw/debugfs.c  | 182 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   5 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  21 ++
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |  19 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  49 +++
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |  14 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |  25 +-
 18 files changed, 684 insertions(+), 117 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
