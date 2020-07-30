Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2682339BA
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgG3UhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 16:37:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:30885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726838AbgG3UhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 16:37:24 -0400
IronPort-SDR: a7IV7tlDhkHBRaD8U0S9tDYjGH1L6r04S9FwohRozgl0zoyQofw7CiZBS6KCQ4/Xq2wFNYA4gJ
 ElwyfJMC7VfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="150885518"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="150885518"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 13:37:23 -0700
IronPort-SDR: MZthjpEzmxj/DcvrGW7pVu9949jMDzgAyOGO9rVA0DgT3C9/KV64hUSgtZ3ZjUOuUM5XmwWtXY
 EU/vkJtn66rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="274324242"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 30 Jul 2020 13:37:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com
Subject: [net-next 00/12][pull request] 1GbE Intel Wired LAN Driver Updates 2020-07-30
Date:   Thu, 30 Jul 2020 13:37:08 -0700
Message-Id: <20200730203720.3843018-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to e100, e1000, e1000e, igb, igbvf, ixgbe,
ixgbevf, iavf, and driver documentation.

Vaibhav Gupta converts legacy .suspend() and .resume() to generic PM
callbacks for e100, igbvf, ixgbe, ixgbevf, and iavf.

Suraj Upadhyay replaces 1 byte memsets with assignments for e1000,
e1000e, igb, and ixgbe.

Alexander Klimov replaces http links with https.

Miaohe Lin replaces uses of memset to clear MAC addresses with
eth_zero_addr().

The following are changes since commit 41d707b7332f1386642c47eb078110ca368a46f5:
  fib: fix fib_rules_ops indirect calls wrappers
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Alexander A. Klimov (1):
  Documentation: intel: Replace HTTP links with HTTPS ones

Miaohe Lin (2):
  ixgbe: use eth_zero_addr() to clear mac address
  igb: use eth_zero_addr() to clear mac address

Suraj Upadhyay (4):
  e1000: Remove unnecessary usages of memset
  e1000e: Remove unnecessary usages of memset
  igb: Remove unnecessary usages of memset
  ixgbe: Remove unnecessary usages of memset

Vaibhav Gupta (5):
  iavf: use generic power management
  igbvf: use generic power management
  ixgbe: use generic power management
  ixgbevf: use generic power management
  e100: use generic power management

 .../device_drivers/ethernet/intel/e100.rst    |  4 +-
 .../device_drivers/ethernet/intel/fm10k.rst   |  2 +-
 .../device_drivers/ethernet/intel/iavf.rst    |  2 +-
 .../device_drivers/ethernet/intel/igb.rst     |  2 +-
 .../device_drivers/ethernet/intel/igbvf.rst   |  2 +-
 .../device_drivers/ethernet/intel/ixgb.rst    |  2 +-
 drivers/net/ethernet/intel/e100.c             | 32 +++++-----
 .../net/ethernet/intel/e1000/e1000_ethtool.c  |  4 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c   |  4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 45 ++++----------
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |  4 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  4 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     | 37 +++--------
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 61 +++++--------------
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    |  2 +-
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 44 +++----------
 17 files changed, 77 insertions(+), 178 deletions(-)

-- 
2.26.2

