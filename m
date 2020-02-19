Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA05164F74
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgBSUCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:02:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:51506 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 15:02:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 12:02:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,461,1574150400"; 
   d="scan'208";a="228700457"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by fmsmga007.fm.intel.com with ESMTP; 19 Feb 2020 12:02:53 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 0/3][pull request] Intel Wired LAN Driver Updates 2020-02-19
Date:   Wed, 19 Feb 2020 12:02:48 -0800
Message-Id: <20200219200251.370445-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to the ice driver.

Brett fixes an issue where if a user sets an odd [tx|rx]-usecs value
through ethtool, the request is denied because the hardware is set to
have an ITR with 2us granularity.  Also fix an issue where the VF has
not been completely removed/reset after being unbound from the host
driver, so resolve this by waiting for the VF remove/reset process to
happen before checking if the VF is disabled.

Michal fixes an issue, where when the user changes flow control via
ethtool, the OS is told the link is going down when that may not be the
case.  Before the fix, the only way to get out of this state was to take
the interface down and up again.

The following are changes since commit 33c4acbe2f4e8f2866914b1fb90ce74fc7216c21:
  bridge: br_stp: Use built-in RCU list checking
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 100GbE

Brett Creeley (2):
  ice: Don't reject odd values of usecs set by user
  ice: Wait for VF to be reset/ready before configuration

Michal Swiatkowski (1):
  ice: Don't tell the OS that link is going down

 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  56 +++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 134 ++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   3 +-
 4 files changed, 115 insertions(+), 80 deletions(-)

-- 
2.24.1

