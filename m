Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CE34658BC
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbhLAWEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:04:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:6213 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239790AbhLAWD6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:03:58 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223795729"
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="223795729"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 14:00:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="540980312"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 01 Dec 2021 14:00:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/6][pull request] Intel Wired LAN Driver Updates 2021-12-01
Date:   Wed,  1 Dec 2021 13:59:08 -0800
Message-Id: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf and i40e drivers.

Mitch adds restoration of MSI state during reset for iavf.

Michal fixes checking and reporting of descriptor count changes to
communicate changes and/or issues for iavf.

Karen resolves an issue with failed handling of VF requests while a VF
reset is occurring for i40e.

Mateusz removes clearing of VF requested queue count when configuring
VF ADQ for i40e.

Norbert adds additional wait time in i40e for VF reset which could take
longer than current allotted time which causes init adminq to fail. He
also fixes a NULL pointer dereference that can occur when getting VSI
descriptors.

The following are changes since commit 3968e3cafafb72ecf12d1263f935d20bc9df9bc2:
  Merge tag 'wireless-drivers-2021-12-01' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Karen Sornek (1):
  i40e: Fix failed opcode appearing if handling messages from VF

Mateusz Palczewski (1):
  i40e: Fix pre-set max number of queues for VF

Michal Maloszewski (1):
  iavf: Fix reporting when setting descriptor count

Mitch Williams (1):
  iavf: restore MSI state on reset

Norbert Zulinski (2):
  i40e: Fix VF failed to init adminq: -53
  i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  8 ++
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 79 ++++++++++++-------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  4 +
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 43 +++++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  1 +
 5 files changed, 97 insertions(+), 38 deletions(-)

-- 
2.31.1

