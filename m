Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E7644460D
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhKCQlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:41:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:30954 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhKCQln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 12:41:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="255168198"
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="255168198"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 09:21:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,206,1631602800"; 
   d="scan'208";a="497645548"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 03 Nov 2021 09:21:09 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net v2 0/5][pull request] Intel Wired LAN Driver Updates 2021-11-03
Date:   Wed,  3 Nov 2021 09:19:30 -0700
Message-Id: <20211103161935.2997369-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Brett fixes issues with promiscuous mode settings not being properly
enabled and removes setting of VF antispoof along with promiscuous
mode. He also ensures that VF Tx queues are always disabled and resolves
a race between virtchnl handling and VF related ndo ops.

Sylwester fixes an issue where a VF MAC could not be set to its primary
MAC if the address is already present.
---
v2:
 - Rebased

The following are changes since commit 92f62485b3715882cd397b0cbd80a96d179b86d6:
  net: dsa: felix: fix broken VLAN-tagged PTP under VLAN-aware bridge
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Brett Creeley (4):
  ice: Fix VF true promiscuous mode
  ice: Remove toggling of antispoof for VF trusted promiscuous mode
  ice: Fix not stopping Tx queues for VFs
  ice: Fix race conditions between virtchnl handling and VF ndo ops

Sylwester Dziedziuch (1):
  ice: Fix replacing VF hardware MAC to existing MAC filter

 drivers/net/ethernet/intel/ice/ice.h          |   5 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |   2 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 141 ++++++++++--------
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  |   5 +
 4 files changed, 82 insertions(+), 71 deletions(-)

-- 
2.31.1

