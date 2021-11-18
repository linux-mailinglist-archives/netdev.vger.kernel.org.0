Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A225A4551B0
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbhKRAgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:36:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:3443 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241939AbhKRAgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 19:36:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="234324555"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="234324555"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 16:33:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="736447977"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 17 Nov 2021 16:33:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/7][pull request] Intel Wired LAN Driver Updates 2021-11-17
Date:   Wed, 17 Nov 2021 16:31:52 -0800
Message-Id: <20211118003159.245561-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Eryk adds accounting for VLAN header in packet size when VF port VLAN is
configured. He also fixes TC queue distribution when the user has changed
queue counts as well as for configuration of VF ADQ which caused dropped
packets.

Michal adds tracking for when a VSI is being released to prevent null
pointer dereference when managing filters.

Karen ensures PF successfully initiates VF requested reset which could
cause a call trace otherwise.

Jedrzej moves validation of channel queue value earlier to prevent
partial configuration when the value is invalid.

Grzegorz corrects the reported error when adding filter fails.

The following are changes since commit c366ce28750e9633f8d4b07829a9cde0e59034eb:
  net: ax88796c: use bit numbers insetad of bit masks
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Eryk Rybak (3):
  i40e: Fix correct max_pkt_size on VF RX queue
  i40e: Fix changing previously set num_queue_pairs for PFs
  i40e: Fix ping is lost after configuring ADq on VF

Grzegorz Szczurek (1):
  i40e: Fix display error code in dmesg

Jedrzej Jagielski (1):
  i40e: Fix creation of first queue by omitting it if is not power of
    two

Karen Sornek (1):
  i40e: Fix warning message and call stack during rmmod i40e driver

Michal Maloszewski (1):
  i40e: Fix NULL ptr dereference on VSI filter sync

 drivers/net/ethernet/intel/i40e/i40e.h        |   2 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 160 ++++++++++++------
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 121 +++++--------
 3 files changed, 147 insertions(+), 136 deletions(-)

-- 
2.31.1

