Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DEE2D5002
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 02:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgLJBDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 20:03:40 -0500
Received: from mga12.intel.com ([192.55.52.136]:15984 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgLJBDk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 20:03:40 -0500
IronPort-SDR: VVgoWPEo4cnVl9cKmCS11H7q7xpUpwVLfXCnMFm6xRuHa0Q1KuqIf9de2nGUqePoCn77cTF39Y
 J7Gg9JHDY/Og==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="153414663"
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="153414663"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 17:02:59 -0800
IronPort-SDR: UDWiUMMa4tWTM/YAdtcdPvT55i31t7lndYUvcAwk4ZW5M/9CpoT6nJlKlTFBEA1rKmEVbh3tnm
 3COGdBJUqVCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,407,1599548400"; 
   d="scan'208";a="338203370"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 09 Dec 2020 17:02:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [net 0/9][pull request] Intel Wired LAN Driver Updates 2020-12-09
Date:   Wed,  9 Dec 2020 17:02:43 -0800
Message-Id: <20201210010252.4029245-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igb, ixgbe, i40e, and ice drivers.

Sven Auhagen fixes issues with igb XDP: return correct error value in XDP
xmit back, increase header padding to include space for double VLAN, add
an extack error when Rx buffer is too small for frame size, set metasize if
it is set in xdp, change xdp_do_flush_map to xdp_do_flush, and update
trans_start to avoid possible Tx timeout.

Björn fixes an issue where an Rx buffer can be reused prematurely with
XDP redirect for ixgbe, i40e, and ice drivers.

The following are changes since commit 323a391a220c4a234cb1e678689d7f4c3b73f863:
  can: isotp: isotp_setsockopt(): block setsockopt on bound sockets
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Björn Töpel (3):
  i40e: avoid premature Rx buffer reuse
  ixgbe: avoid premature Rx buffer reuse
  ice: avoid premature Rx buffer reuse

Sven Auhagen (6):
  igb: XDP xmit back fix error code
  igb: take VLAN double header into account
  igb: XDP extack message on error
  igb: skb add metasize for xdp
  igb: use xdp_do_flush
  igb: avoid transmit queue timeout in xdp path

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 27 ++++++++++----
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 31 +++++++++++-----
 drivers/net/ethernet/intel/igb/igb.h          |  5 +++
 drivers/net/ethernet/intel/igb/igb_main.c     | 37 +++++++++++++------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 ++++++++----
 5 files changed, 90 insertions(+), 34 deletions(-)

-- 
2.26.2

