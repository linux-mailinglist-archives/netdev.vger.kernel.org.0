Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD1068CA8B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjBFXaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjBFXaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:30:12 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37144305EA
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 15:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675726206; x=1707262206;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9KeJX9N8W2pTblQtGsh2PRayyj1C1r5EL46aN1as9O0=;
  b=MC46Qz4f+w14NOz8En7VWQ+lkd44beS81C/5SeWvYY1epBbaItDmhazA
   56kbay6mkWsLu8POPROxmbfzmKWFXC3mrM8kpM85fsXLajgbgAwib8tlH
   yOX7mxWY7p9tfM7nyCuPNWn7vs0c0Tz9umciAw68cptcPlHMc4lmCBMt6
   s75ZzJQYRAKI9W+CMfcf2IYMPcxyx4oJ9E09d1HI2uDyNAmUmrAiOA4Zf
   c+a7ZjyGdlT4ZPpvcK8Rplh97hLpP0vscoKna100A6ZKHqU3RikmAcQxR
   slox2W/08tfZ4yalLgcwTUxKwK52OnwelSoR28hdPl8H/SrK6bykejvs7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="309678389"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="309678389"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 15:29:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809305655"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="809305655"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2023 15:29:54 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/5][pull request] Intel Wired LAN Driver Updates 2023-02-06 (ice)
Date:   Mon,  6 Feb 2023 15:29:29 -0800
Message-Id: <20230206232934.634298-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Ani removes WQ_MEM_RECLAIM flag from workqueue to resolve
check_flush_dependency warning.

Michal fixes KASAN out-of-bounds warning.

Brett corrects behaviour for port VLAN Rx filters to prevent receiving
of unintended traffic.

Dan Carpenter fixes possible off by one issue.

Zhang Changzhong adjusts error path for switch recipe to prevent memory
leak.
---
v2: Dropped, previous, patch 1

v1: https://lore.kernel.org/netdev/20230131213703.1347761-1-anthony.l.nguyen@intel.com/

The following are changes since commit 811d581194f7412eda97acc03d17fc77824b561f:
  net: USB: Fix wrong-direction WARNING in plusb.c
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Do not use WQ_MEM_RECLAIM flag for workqueue

Brett Creeley (1):
  ice: Fix disabling Rx VLAN filtering with port VLAN enabled

Dan Carpenter (1):
  ice: Fix off by one in ice_tc_forward_to_queue()

Michal Swiatkowski (1):
  ice: fix out-of-bounds KASAN warning in virtchnl

Zhang Changzhong (1):
  ice: switch: fix potential memleak in ice_add_adv_recipe()

 drivers/net/ethernet/intel/ice/ice_common.c   |  9 ++++----
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +-
 drivers/net/ethernet/intel/ice/ice_switch.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c   | 21 +++++++------------
 .../ethernet/intel/ice/ice_vf_vsi_vlan_ops.c  | 16 +++++++++++++-
 6 files changed, 30 insertions(+), 22 deletions(-)

-- 
2.38.1

