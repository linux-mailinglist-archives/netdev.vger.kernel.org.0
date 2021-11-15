Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C772451BBA
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbhKPAGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:06:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:19402 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352074AbhKPAEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:04:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="214284241"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="214284241"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163109"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 00/10][pull request] Intel Wired LAN Driver Updates 2021-11-15
Date:   Mon, 15 Nov 2021 15:59:24 -0800
Message-Id: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Mateusz adds a wait for reset completion when changing queue count which
could otherwise cause issues with VF reset.

Nick adds a null check for vf_res in iavf_fix_features(), corrects
ordering of function calls to resolve dependency issues, and prevents
possible freeing of a lock which isn't being held.

Piotr fixes logic that did not allow setting all multicast mode without
promiscuous mode.

Jake prevents possible accidental freeing of filter structure.

Mitch adds null checks for key and indir parameters in iavf_get_rxfh().

Surabhi adds an additional check that would, previously, cause the driver
to print a false error due to values obtained while the VF is in reset.

Grzegorz prevents a queue request of 0 which would cause queue count to
reset to default values.

Akeem restores VLAN filters when bringing the interface back up.

The following are changes since commit cf4f5530bb55ef7d5a91036b26676643b80b1616:
  net/smc: Make sure the link_id is unique
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Akeem G Abodunrin (1):
  iavf: Restore VLAN filters after link down

Grzegorz Szczurek (1):
  iavf: Fix for setting queues to 0

Jacob Keller (1):
  iavf: prevent accidental free of filter structure

Mateusz Palczewski (1):
  iavf: Fix return of set the new channel count

Mitch Williams (1):
  iavf: validate pointers

Nicholas Nunley (3):
  iavf: check for null in iavf_fix_features
  iavf: free q_vectors before queues in iavf_disable_vf
  iavf: don't clear a lock we don't hold

Piotr Marczak (1):
  iavf: Fix failure to exit out from last all-multicast mode

Surabhi Boob (1):
  iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset

 drivers/net/ethernet/intel/iavf/iavf.h        |  1 +
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 30 +++++++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 55 ++++++++++++++-----
 3 files changed, 64 insertions(+), 22 deletions(-)

-- 
2.31.1

