Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD24E30809F
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhA1VjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:39:02 -0500
Received: from mga12.intel.com ([192.55.52.136]:19316 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229819AbhA1VjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:39:00 -0500
IronPort-SDR: nxFvVtj1pHM+mtvppbRy6+YZU6/cpWzdT+LHWP3+R1O01T1rbXvJJgPWt34z/7jRHsvxFS1q7F
 hPbLgOBxvNXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="159491174"
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="159491174"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 13:38:20 -0800
IronPort-SDR: 1dqNXV38r4J/zE2yWqM8aLh7Wx/PnE6/rRUliixqBwC0l3kChqX4uSFT0G0yDcc6IHSO29g23O
 gAOQB6HGPKLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,383,1602572400"; 
   d="scan'208";a="474240992"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jan 2021 13:38:19 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-01-28
Date:   Thu, 28 Jan 2021 13:38:47 -0800
Message-Id: <20210128213851.2499012-1-anthony.l.nguyen@intel.com>
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
who hasn't enabled") as this can cause link flapping.

The following are changes since commit 44a674d6f79867d5652026f1cc11f7ba8a390183:
  Merge tag 'mlx5-fixes-2021-01-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
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
 5 files changed, 5 insertions(+), 17 deletions

-- 
2.26.2

