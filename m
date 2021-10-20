Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3526F4350AB
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhJTQyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:54:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:63160 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230245AbhJTQyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 12:54:01 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="292294199"
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="292294199"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 09:51:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,167,1631602800"; 
   d="scan'208";a="567627034"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Oct 2021 09:51:45 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-10-20
Date:   Wed, 20 Oct 2021 09:49:53 -0700
Message-Id: <20211020164957.3371484-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e1000e, igc, and ice drivers.

Sasha fixes an issue with dropped packets on Tiger Lake platforms for
e1000e and corrects a device ID for igc.

Tony adds missing E810 device IDs for ice.

---
Note this will conflict when merging with net-next.
Resolution should be:

--- a/drivers/net/ethernet/intel/ice/ice_devids.h
+++ b/drivers/net/ethernet/intel/ice/ice_devids.h
@@@ -21,8 -21,10 +21,12 @@@
  #define ICE_DEV_ID_E810C_QSFP         0x1592
  /* Intel(R) Ethernet Controller E810-C for SFP */
  #define ICE_DEV_ID_E810C_SFP          0x1593
 +#define ICE_SUBDEV_ID_E810T           0x000E
 +#define ICE_SUBDEV_ID_E810T2          0x000F
+ /* Intel(R) Ethernet Controller E810-XXV for backplane */
+ #define ICE_DEV_ID_E810_XXV_BACKPLANE 0x1599
+ /* Intel(R) Ethernet Controller E810-XXV for QSFP */
+ #define ICE_DEV_ID_E810_XXV_QSFP      0x159A
  /* Intel(R) Ethernet Controller E810-XXV for SFP */
  #define ICE_DEV_ID_E810_XXV_SFP               0x159B
  /* Intel(R) Ethernet Connection E823-C for backplane */

The following are changes since commit 4225fea1cb28370086e17e82c0f69bec2779dca0:
  ptp: Fix possible memory leak in ptp_clock_register()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Sasha Neftin (3):
  e1000e: Separate TGP board type from SPT
  e1000e: Fix packet loss on Tiger Lake and later
  igc: Update I226_K device ID

Tony Nguyen (1):
  ice: Add missing E810 device ids

 drivers/net/ethernet/intel/e1000e/e1000.h   |  4 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 31 +++++++++++++-
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  3 ++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 45 +++++++++++----------
 drivers/net/ethernet/intel/ice/ice_common.c |  2 +
 drivers/net/ethernet/intel/ice/ice_devids.h |  4 ++
 drivers/net/ethernet/intel/ice/ice_main.c   |  2 +
 drivers/net/ethernet/intel/igc/igc_hw.h     |  2 +-
 8 files changed, 68 insertions(+), 25 deletions(-)

-- 
2.31.1

