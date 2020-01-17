Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B68141139
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbgAQS4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:56:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:5303 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbgAQS4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 13:56:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 10:56:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,331,1574150400"; 
   d="scan'208";a="220819547"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jan 2020 10:56:18 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/9][pull request] Intel Wired LAN Driver Updates 2020-01-17
Date:   Fri, 17 Jan 2020 10:56:08 -0800
Message-Id: <20200117185617.1585693-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc, i40e, fm10k and ice drivers.

Sasha fixes a typo in a code comment that referred to silicon that is
not supported in the igc driver.  Cleaned up a defined that was not
being used.  Added support for another i225 SKU which does not have an
NVM.  Added support for TCP segmentation offload (TSO) into igc.  Added
support for PHY power management control to provide a reliable and
accurate indication of PHY reset completion.

Jake adds support for the new txqueue parameter to the transmit timeout
function in fm10k which reduces the code complexity when determining
which transmit queue is stuck.

Julio Faracco makes the similar changes that Jake did for fm10k, for
i40e and ice drivers.  Added support for the new txqueue parameter in
the transmit timeout functions for i40e and ice.

Colin Ian King cleans up a redundant initialization of a local variable.

The following are changes since commit 56f200c78ce4d94680a27a1ce97a29ebeb4f23e1:
  netns: Constify exported functions
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Colin Ian King (1):
  ice: remove redundant assignment to variable xmit_done

Jacob Keller (1):
  fm10k: use txqueue parameter in fm10k_tx_timeout

Julio Faracco (2):
  i40e: Removing hung_queue variable to use txqueue function parameter
  ice: Removing hung_queue variable to use txqueue function parameter

Sasha Neftin (5):
  igc: Fix typo in a comment
  igc: Remove unused definition
  igc: Add SKU for i225 device
  igc: Add support for TSO
  igc: Add PHY power management control

 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  17 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  41 ++-----
 drivers/net/ethernet/intel/ice/ice_main.c     |  41 ++-----
 drivers/net/ethernet/intel/ice/ice_xsk.c      |   2 +-
 drivers/net/ethernet/intel/igc/igc_base.c     |   1 +
 drivers/net/ethernet/intel/igc/igc_defines.h  |   5 +
 drivers/net/ethernet/intel/igc/igc_hw.h       |   3 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 116 +++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_phy.c      |  16 ++-
 drivers/net/ethernet/intel/igc/igc_regs.h     |   1 +
 10 files changed, 170 insertions(+), 73 deletions(-)

-- 
2.24.1

