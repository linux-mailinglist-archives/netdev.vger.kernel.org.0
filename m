Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A718B30B240
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbhBAVqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:46:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:26807 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhBAVqS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:46:18 -0500
IronPort-SDR: Vm+oHW5cCPOBygcn2Ru68O4Z0kte94mtUug2Zls1rR3r3makGjNVV+dH0ZOM1NDFBi2BOrvbww
 ah/mtEIYvATg==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="177249324"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="177249324"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 13:45:34 -0800
IronPort-SDR: TWaqImGRfw9DpB8K8hINTIG1cQE4e2gg5HYJLKzyv5CRW5PNQjD0AiGZ9ISengC+ankuBxvagn
 K3yuiX2zSKdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="354638533"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 01 Feb 2021 13:45:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net v2 0/4][pull request] Intel Wired LAN Driver Updates 2021-02-01
Date:   Mon,  1 Feb 2021 13:46:14 -0800
Message-Id: <20210201214618.852831-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc and i40e drivers.

Kai-Heng Feng fixes igc to report unknown speed and duplex during suspend
as an attempted read will cause errors.

Kevin Lo sets the default value to -IGC_ERR_NVM instead of success for
writing shadow RAM as this could miss a timeout. Also propagates the return
value for Flow Control configuration to properly pass on errors for igc.

Aleksandr reverts commit 2ad1274fa35a ("i40e: don't report link up for a VF
who hasn't enabled queues") as this can cause link flapping.

v2: Additional information to commit message of i40e revert patch.

The following are changes since commit eb4e8fac00d1e01ada5e57c05d24739156086677:
  neighbour: Prevent a dead entry from updating gc_list
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Aleksandr Loktionov (1):
  i40e: Revert "i40e: don't report link up for a VF who hasn't enabled
    queues"

Kai-Heng Feng (1):
  igc: Report speed and duplex as unknown when device is runtime
    suspended

Kevin Lo (2):
  igc: set the default return value to -IGC_ERR_NVM in
    igc_write_nvm_srwr
  igc: check return value of ret_val in igc_config_fc_after_link_up

 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 13 +------------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |  1 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |  3 ++-
 drivers/net/ethernet/intel/igc/igc_i225.c          |  3 +--
 drivers/net/ethernet/intel/igc/igc_mac.c           |  2 +-
 5 files changed, 5 insertions(+), 17 deletions(-)

-- 
2.26.2

