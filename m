Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2452EF5C7B
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfKIAop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:25215 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfKIAoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:44:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 16:44:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="215111194"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2019 16:44:31 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 0/6][pull request] Intel Wired LAN Driver Fixes 2019-11-08
Date:   Fri,  8 Nov 2019 16:44:24 -0800
Message-Id: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to igb, igc, ixgbe, i40e, iavf and ice
drivers.

Colin Ian King fixes a potentially wrap-around counter in a for-loop.

Nick fixes the default ITR values for the iavf driver to 50 usecs
interval.

Arkadiusz fixes 'ethtool -m' for X722 devices where the correct value
cannot be obtained from the firmware, so add X722 to the check to ensure
the wrong value is not returned.

Jake fixes igb and igc drivers in their implementation of launch time
support by declaring skb->tstamp value as ktime_t instead of s64.

Magnus fixes ixgbe and i40e where the need_wakeup flag for transmit may
not be set for AF_XDP sockets that are only used to send packets.

The following are changes since commit 1b53d64435d56902fc234ff2507142d971a09687:
  net: fix data-race in neigh_event_send()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Fix for ethtool -m issue on X722 NIC

Colin Ian King (1):
  ice: fix potential infinite loop because loop counter being too small

Jacob Keller (1):
  igb/igc: use ktime accessors for skb->tstamp

Magnus Karlsson (2):
  i40e: need_wakeup flag might not be set for Tx
  ixgbe: need_wakeup flag might not be set for Tx

Nicholas Nunley (1):
  iavf: initialize ITRN registers with correct values

 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h |  2 ++
 drivers/net/ethernet/intel/i40e/i40e_common.c     |  3 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c        | 10 ++--------
 drivers/net/ethernet/intel/iavf/iavf_main.c       |  4 ++--
 drivers/net/ethernet/intel/ice/ice_sched.c        |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c         |  4 ++--
 drivers/net/ethernet/intel/igc/igc_main.c         |  4 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c      | 10 ++--------
 8 files changed, 15 insertions(+), 24 deletions(-)

-- 
2.21.0

