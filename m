Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA962001E5
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 08:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgFSGWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 02:22:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:50185 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgFSGWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 02:22:16 -0400
IronPort-SDR: gDusetXIfwLhPNtBCbJ6mwRhfRlF4KvTdgRKpeMD22o30xmshQC58bIel7ZqVJ9r7RnMiwCNDH
 zBVURnTqMtOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="130229724"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="130229724"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 23:22:13 -0700
IronPort-SDR: F7t0MRKbV/D12jy/S0UgfJqKfMLsB4pz7t6wzCAe5SyMNCNNk/bnXZnEVuobUJ1Rk1FDJmzZLl
 oSrSa7D8K+mQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="421753955"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 18 Jun 2020 23:22:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-06-18
Date:   Thu, 18 Jun 2020 23:22:06 -0700
Message-Id: <20200619062210.3159291-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains fixes to ixgbe, i40e and ice driver.

Ciara fixes up the ixgbe, i40e and ice drivers to protect access when
allocating and freeing the rings.  In addition, made use of READ_ONCE
when reading the rings prior to accessing the statistics pointer.

Björn fixes a crash where the receive descriptor ring allocation was
moved to a different function, which broke the ethtool set_ringparam()
hook.

The following are changes since commit 0ad6f6e767ec2f613418cbc7ebe5ec4c35af540c:
  net: increment xmit_recursion level in dev_direct_xmit()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue 40GbE

Björn Töpel (1):
  i40e: fix crash when Rx descriptor count is changed

Ciara Loftus (3):
  ixgbe: protect ring accesses with READ- and WRITE_ONCE
  i40e: protect ring accesses with READ- and WRITE_ONCE
  ice: protect ring accesses with WRITE_ONCE

 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  3 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 29 ++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_lib.c      |  8 ++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 12 ++++----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 14 +++++++--
 6 files changed, 44 insertions(+), 24 deletions(-)

-- 
2.26.2

