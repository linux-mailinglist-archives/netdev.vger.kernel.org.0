Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87C56EA114
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbjDUBjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjDUBjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B644210
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1048964202
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF82C433D2;
        Fri, 21 Apr 2023 01:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041138;
        bh=ocxTawyHmP3hy9mQpfA22nNggmkOi5RosNJlBEDbGY0=;
        h=From:To:Cc:Subject:Date:From;
        b=Irn5S94TJyVEE+UygUC2pQuvJG0UI6apwS/Vh95UiPz5+apFFRDWb4D1ITf5AkWAR
         7jCru/D19GWbq4N7HBO8/n+UNUSRbtchx8lFQkJSKVrI6szuAbquQsr3C9ksu/UM+1
         h2PHWMOEVjWq/H7yxWl/LEzj1YkNK22pY8Dy7RxhN4hgY9NqRMQdHhudVpKvagN/sK
         E5MYgf5PbFKNld9fbxghyCkGNGIy/fuVQ3Iv70LFCU4LmtUN3t5urzX5ab1McGmD2j
         G0T19y+DCDW6PTSJ6Bdz3wjO0pdCDD6FWFos1juhdIUR+pEGyM8/V9qYY4nUtvbwXz
         1sHduwS41sh/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-04-20
Date:   Thu, 20 Apr 2023 18:38:35 -0700
Message-Id: <20230421013850.349646-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit e315e7b83a22043bffee450437d7089ef373cbf6:

  net: libwx: fix memory leak in wx_setup_rx_resources (2023-04-20 15:39:15 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-04-20

for you to fetch changes up to f9c895a72a390656f9582e048fdcc3d2cec1dd7c:

  net/mlx5: Update op_mode to op_mod for port selection (2023-04-20 18:35:50 -0700)

----------------------------------------------------------------
mlx5-updates-2023-04-20

1) Dragos Improves RX page pool, and provides some fixes to his previous series:
 1.1) Fix releasing page_pool for striding RQ and legacy RQ nonlinear case
 1.2) Hook NAPIs to page pools to gain more performance.

2) From Roi, Some cleanups to TC and eswitch modules.

3) Maher migrates vnic diagnostic counters reporting from debugfs to a
    dedicated devlink health reporter

Maher Says:
===========
 net/mlx5: Expose vnic diagnostic counters using devlink

Currently, vnic diagnostic counters are exposed through the following
debugfs:

$ ls /sys/kernel/debug/mlx5/0000:08:00.0/esw/vf_0/vnic_diag/
cq_overrun
quota_exceeded_command
total_q_under_processor_handle
invalid_command
send_queue_priority_update_flow
nic_receive_steering_discard

The current design does not allow the hypervisor to view the diagnostic
counters of its VFs, in case the VFs get bound to a VM. In other words,
the counters are not exposed for representor interfaces.
Furthermore, the debugfs design is inconvenient future-wise, in case more
counters need to be reported by the driver in the future.

As these counters pertain to vNIC health, it is more appropriate to
utilize the devlink health reporter to expose them.

Thus, this patchest includes the following changes:

* Drop the current vnic diagnostic counters debugfs interface.
* Add a vnic devlink health reporter for PFs/VFs core devices, which
  when diagnosed will dump vnic diagnostic counter values that are
  queried from FW.
* Add a vnic devlink health reporter for the representor interface, which
  serves the same purpose listed in the previous point, in addition to
  allowing the hypervisor to view its VFs diagnostic counters, even when
  the VFs are bounded to external VMs.

Example of devlink health reporter usage is:
$devlink health diagnose pci/0000:08:00.0 reporter vnic
 vNIC env counters:
    total_error_queues: 0 send_queue_priority_update_flow: 0
    comp_eq_overrun: 0 async_eq_overrun: 0 cq_overrun: 0
    invalid_command: 0 quota_exceeded_command: 0
    nic_receive_steering_discard: 0

===========

4) SW steering fixes and improvements

Yevgeny Kliteynik Says:
=======================
These short patch series are just small fixes / improvements for
SW steering:

 - Patch 1: Fix dumping of legacy modify_hdr in debug dump to
   align to what is expected by parser
 - Patch 2: Have separate threshold for ICM sync per ICM type
 - Patch 3: Add more info to the steering debug dump - Linux
   version and device name
 - Patch 4: Keep track of number of buddies that are currently
   in use per domain per buddy type

=======================

----------------------------------------------------------------
Dragos Tatulea (3):
      net/mlx5e: RX, Fix releasing page_pool pages twice for striding RQ
      net/mlx5e: RX, Fix XDP_TX page release for legacy rq nonlinear case
      net/mlx5e: RX, Hook NAPIs to page pools

Eli Cohen (1):
      net/mlx5: Include linux/pci.h for pci_msix_can_alloc_dyn()

Maher Sanalla (4):
      Revert "net/mlx5: Expose steering dropped packets counter"
      Revert "net/mlx5: Expose vnic diagnostic counters for eswitch managed vports"
      net/mlx5: Add vnic devlink health reporter to PFs/VFs
      net/mlx5e: Add vnic devlink health reporter to representors

Roi Dayan (3):
      net/mlx5: E-Switch, Remove redundant dev arg from mlx5_esw_vport_alloc()
      net/mlx5: E-Switch, Remove unused mlx5_esw_offloads_vport_metadata_set()
      net/mlx5: Update op_mode to op_mod for port selection

Yevgeny Kliteynik (4):
      net/mlx5: DR, Fix dumping of legacy modify_hdr in debug dump
      net/mlx5: DR, Calculate sync threshold of each pool according to its type
      net/mlx5: DR, Add more info in domain dbg dump
      net/mlx5: DR, Add memory statistics for domain object

 .../ethernet/mellanox/mlx5/devlink.rst             |  33 ++++
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   4 +-
 .../mellanox/mlx5/core/diag/reporter_vnic.c        | 125 +++++++++++++
 .../mellanox/mlx5/core/diag/reporter_vnic.h        |  16 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  52 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  11 +-
 .../net/ethernet/mellanox/mlx5/core/esw/debugfs.c  | 198 ---------------------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  20 +--
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   6 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  25 ---
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   1 +
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |  24 ++-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |  41 +++--
 .../mellanox/mlx5/core/steering/dr_types.h         |   3 +
 include/linux/mlx5/driver.h                        |   1 +
 include/linux/mlx5/mlx5_ifc.h                      |   2 +-
 20 files changed, 297 insertions(+), 273 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
