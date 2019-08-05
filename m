Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C257E8251E
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfHESzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:55:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:43661 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728870AbfHESzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 14:55:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 11:55:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="373801218"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2019 11:55:01 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/8][pull request] 40GbE Intel Wired LAN Driver Updates 2019-08-05
Date:   Mon,  5 Aug 2019 11:54:51 -0700
Message-Id: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e driver only.

Dmitrii adds missing statistic counters for VEB and VEB TC's.

Slawomir adds support for logging the "Disable Firmware LLDP" flag
option and its current status.

Jake fixes an issue where VF's being notified of their link status
before their queues are enabled which was causing issues.  So always
report link status down when the VF queues are not enabled.  Also adds
future proofing when statistics are added or removed by adding checks to
ensure the data pointer for the strings lines up with the expected
statistics count.

Czeslaw fixes the advertised mode reported in ethtool for FEC, where the
"None BaseR RS" was always being displayed no matter what the mode it
was in.  Also added logging information when the PF is entering or
leaving "allmulti" (or promiscuous) mode.  Fixed up the logging logic
for VF's when leaving multicast mode to not include unicast as well.

v2: drop Aleksandr's patch (previously patch #2 in the series) to
    display the VF MAC address that is set by the VF while community
    feedback is addressed.

The following are changes since commit a9e21bea1f815c2ec917ecc0efe0a7049c825d5b:
  ][next] selftests: nettest: fix spelling mistake: "potocol" -> "protocol"
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Czeslaw Zagorski (3):
  i40e: Update visual effect for advertised FEC mode.
  i40e: Log info when PF is entering and leaving Allmulti mode.
  i40e: Remove unicast log when VF is leaving multicast mode.

Dmitrii Golovanov (1):
  i40e: fix incorrect ethtool statistics veb and veb.tc_

Jacob Keller (2):
  i40e: don't report link up for a VF who hasn't enabled queues
  i40e: verify string count matches even on early return

Jeff Kirsher (1):
  i40e: fix code comments

Slawomir Laba (1):
  i40e: Log disable-fw-lldp flag change by ethtool

 drivers/net/ethernet/intel/i40e/i40e.h        |  1 +
 .../net/ethernet/intel/i40e/i40e_ethtool.c    | 74 +++++++++++--------
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 11 ++-
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 54 +++++++++-----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  1 +
 5 files changed, 90 insertions(+), 51 deletions(-)

-- 
2.21.0

