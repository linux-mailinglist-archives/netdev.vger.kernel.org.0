Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34BD554B6C9
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344731AbiFNQvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239255AbiFNQvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:51:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CB3403E9
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655225475; x=1686761475;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nqZnWk+VOk6XJbM0LOE+afAnKbzy9wPkvl2Wmnbmnpo=;
  b=E1GGjHI4Uc9MQVktLXMVrWMGb1BUwyINhNAByd1s4gLxrwlYqGOP6dKG
   DyAIHb8W/uVUTUe9XYv92/MoS3SRcvsmPVePo/QldVkNQu/u8MU2P+c3k
   TASqT2uDrCB6KaHt9xiBE6h28uI/5a2csQ9FD6r1MfE5JhB1KLHqZnLOA
   FXrZjgM8EHWLQjl6uKjC9bAEo4S8xe5rhe01kWHui3DPUw39VP3x9lw5m
   v3i+dMVm42ibp9m9KGO4+9qfraSDeWcnlsvgbOZmBFT7/6KiSR77zqksw
   g5AYSsc6KAZ89Tdtn7YYJHbPKvfhR+mImAF5Ndrgth4/iCMD/b7rkm3EJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="278715011"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="278715011"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 09:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="582775181"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2022 09:51:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2022-06-14
Date:   Tue, 14 Jun 2022 09:48:02 -0700
Message-Id: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Michal fixes incorrect Tx timestamp offset calculation for E822 devices.

Roman enforces required VLAN filtering settings for double VLAN mode.

Przemyslaw fixes memory corruption issues with VFs by ensuring
queues are disabled in the error path of VF queue configuration and to
disabled VFs during reset.

The following are changes since commit 4b7a632ac4e7101ceefee8484d5c2ca505d347b3:
  mlxsw: spectrum_cnt: Reorder counter pools
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Michal Michalik (1):
  ice: Fix PTP TX timestamp offset calculation

Przemyslaw Patynowski (2):
  ice: Fix queue config fail handling
  ice: Fix memory corruption in VF driver

Roman Storozhenko (1):
  ice: Sync VLAN filtering features for DVM

 drivers/net/ethernet/intel/ice/ice_main.c     | 49 ++++++++++-------
 drivers/net/ethernet/intel/ice/ice_ptp.c      |  2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h      | 31 +++++++++++
 drivers/net/ethernet/intel/ice/ice_vf_lib.c   |  5 ++
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 53 +++++++++----------
 5 files changed, 94 insertions(+), 46 deletions(-)

-- 
2.35.1

