Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78721DA601
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgETAE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:15427 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726344AbgETAE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:28 -0400
IronPort-SDR: Vpm8Eq11ul9aikhkUTizJC1AI1tewVu/Yh5qLkkcMUkVK8eBfBk65CGhnfDCvp3V0wDLlIRBf2
 ZX1p4T7hgiHw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:21 -0700
IronPort-SDR: DpuY2SJilySZFsZrB7D+WVpKW1fuf6qZdgOG6Z1dyxyYGP6cL/BxXAXWwkWCjeuVvrC5uH3vS9
 CZWPXrmuMHwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324744"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:20 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 00/14][pull request] 1GbE Intel Wired LAN Driver Updates 2020-05-19
Date:   Tue, 19 May 2020 17:04:05 -0700
Message-Id: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc only.

Sasha cleans up the igc driver code that is not used or needed.

Vitaly cleans up driver code that was used to support Virtualization on
a device that is not supported by igc, so remove the dead code.

Andre renames a few macros to align with register and field names
described in the data sheet.  Also adds the VLAN Priority Queue Fliter
and EType Queue Filter registers to the list of registers dumped by
igc_get_regs().  Added additional debug messages and updated return codes
for unsupported features.  Refactored the VLAN priority filtering code to
move the core logic into igc_main.c.  Cleaned up duplicate code and
useless code.

The following are changes since commit 2de499258659823b3c7207c5bda089c822b67d69:
  Merge branch 's390-next'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (9):
  igc: Rename IGC_VLAPQF macro
  igc: Dump VLANPQF register
  igc: Return -EOPNOTSUPP when VLAN mask doesn't match
  igc: Refactor VLAN priority filtering code
  igc: Remove duplicated IGC_RXPBS macro
  igc: Remove ethertype filter in PTP code
  igc: Fix MAX_ETYPE_FILTER value
  igc: Refactor ethertype filtering code
  igc: Dump ETQF registers

Sasha Neftin (4):
  igc: Remove PCIe Control register
  igc: Clean up obsolete NVM defines
  igc: Remove unused IGC_ICS_DRSTA define
  igc: Remove unused registers

Vitaly Lifshits (1):
  igc: remove IGC_REMOVED function

 drivers/net/ethernet/intel/igc/igc.h         |   9 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |  15 +-
 drivers/net/ethernet/intel/igc/igc_dump.c    |   4 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 140 ++++--------------
 drivers/net/ethernet/intel/igc/igc_mac.h     |   4 -
 drivers/net/ethernet/intel/igc/igc_main.c    | 148 ++++++++++++++++++-
 drivers/net/ethernet/intel/igc/igc_ptp.c     |  12 --
 drivers/net/ethernet/intel/igc/igc_regs.h    |  15 +-
 8 files changed, 184 insertions(+), 163 deletions(-)

-- 
2.26.2

