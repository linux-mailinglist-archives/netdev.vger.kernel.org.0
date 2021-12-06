Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD046A4B9
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbhLFSj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:39:58 -0500
Received: from mga05.intel.com ([192.55.52.43]:31032 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243255AbhLFSj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 13:39:57 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="323631991"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="323631991"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 10:36:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="461943023"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 06 Dec 2021 10:36:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net v2 0/5][pull request] Intel Wired LAN Driver Updates 2021-12-06
Date:   Mon,  6 Dec 2021 10:35:14 -0800
Message-Id: <20211206183519.2733180-1-anthony.l.nguyen@intel.com>
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

Norbert fixes a NULL pointer dereference that can occur when getting VSI
descriptors for i40e.
---
v2:
- Change successful descriptor change from info to debug.
- Drop patch 5; awaiting changes from author

The following are changes since commit 2be6d4d16a0849455a5c22490e3c5983495fed00:
  net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero
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

Norbert Zulinski (1):
  i40e: Fix NULL pointer dereference in i40e_dbg_dump_desc

 .../net/ethernet/intel/i40e/i40e_debugfs.c    |  8 ++
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 75 ++++++++++++-------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  2 +
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 43 ++++++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  1 +
 5 files changed, 91 insertions(+), 38 deletions(-)

-- 
2.31.1

