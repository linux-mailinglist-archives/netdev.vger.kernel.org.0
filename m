Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BF22D4CA6
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 22:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387699AbgLIVOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 16:14:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:24061 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgLIVOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 16:14:34 -0500
IronPort-SDR: o+tDPgE4UR/yVSGd15PMDV6x3CWjUEuCVVFQVrR6ybE13frLIbj/cEiIzyL4cvqpwmyrwijD1y
 r4H+1Vf4JIFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="170641628"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="170641628"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 13:13:53 -0800
IronPort-SDR: ke1naeWSz/dzeGqLzezkoQlyufTE9E+ry1yMz4c5LU+vFpO4ATURbNm9UPFm4tsl+SV475hddh
 GpdB1AlqlJLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="408228639"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2020 13:13:52 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net-next v4 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2020-12-09
Date:   Wed,  9 Dec 2020 13:13:03 -0800
Message-Id: <20201209211312.3850588-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Bruce changes the allocation of ice_flow_prof_params from stack to heap to
avoid excessive stack usage. Corrects a misleading comment and silences a
sparse warning that is not a problem.

Paul allows for HW initialization to continue if PHY abilities cannot
be obtained.

Jeb removes bypassing FW link override and reading Option ROM and
netlist information for non-E810 devices as this is now available on
other devices.

Nick removes vlan_ena field as this information can be gathered by
checking num_vlan.

Jake combines format strings and debug prints to the same line.

Simon adds a space to fix string concatenation.

v4: Drop ACL patches. Change PHY abilities failure message from debug to
warning.
v3: Fix email address for DaveM and fix character in cover letter
v2: Expand on commit message for patch 3 to show example usage/commands.
    Reduce number of defensive checks being done.

The following are changes since commit afae3cc2da100ead3cd6ef4bb1fb8bc9d4b817c5:
  net: atheros: simplify the return expression of atl2_phy_setup_autoneg_adv()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Bruce Allan (3):
  ice: cleanup stack hog
  ice: cleanup misleading comment
  ice: silence static analysis warning

Jacob Keller (1):
  ice: join format strings to same line as ice_debug

Jeb Cramer (2):
  ice: Enable Support for FW Override (E82X)
  ice: Remove gate to OROM init

Nick Nunley (1):
  ice: Remove vlan_ena from vsi structure

Paul M Stillwell Jr (1):
  ice: don't always return an error for Get PHY Abilities AQ command

Simon Perron Caissy (1):
  ice: Add space to unknown speed

 drivers/net/ethernet/intel/ice/ice.h          |   1 -
 drivers/net/ethernet/intel/ice/ice_common.c   | 109 ++++++------------
 drivers/net/ethernet/intel/ice/ice_controlq.c |  42 +++----
 .../net/ethernet/intel/ice/ice_flex_pipe.c    |  24 ++--
 drivers/net/ethernet/intel/ice/ice_flow.c     |  53 +++++----
 drivers/net/ethernet/intel/ice/ice_main.c     |  13 +--
 drivers/net/ethernet/intel/ice/ice_nvm.c      |  61 +++-------
 drivers/net/ethernet/intel/ice/ice_sched.c    |  21 ++--
 drivers/net/ethernet/intel/ice/ice_switch.c   |  15 +--
 9 files changed, 117 insertions(+), 222 deletions(-)

-- 
2.26.2

