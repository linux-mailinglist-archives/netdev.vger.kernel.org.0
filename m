Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500CB1D8A9A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgERWRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:17:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:58882 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgERWRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 18:17:05 -0400
IronPort-SDR: s6U1pBJy5VxM7JIuf5R/trQAecJkeHwzxRe33HCtWKmmqErfN0JMnJ1W9zku+kPJWKdZyNQURD
 IOYXAVlQHHxQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 15:16:59 -0700
IronPort-SDR: NTtwKpSwaO0ppzrBtI8fOx3iSKZoxExeE9yAfrrHbUNO86e4uDIqMDRCqDvmrwMkQ6Wbrce0sd
 RVU08UqhhiLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="439387793"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 18 May 2020 15:16:59 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v4 0/9][pull request] 1GbE Intel Wired LAN Driver Updates 2020-05-18
Date:   Mon, 18 May 2020 15:16:48 -0700
Message-Id: <20200518221657.1420070-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc driver only.

Sasha adds ECN support for TSO by adding the NETIF_F_TSO_ECN flag, which
aligns with other Intel drivers.  Also cleaned up defines that are not
supported or used in the igc driver.

Andre does most of the changes with updating the log messages for igc
driver.

Vitaly adds support for EEPROM, register and link ethtool
self-tests.

v2: Fixed up the added ethtool self-tests based on feedback from the
    community.  Dropped the four patches that removed '\n' from log
    messages.
v3: Reverted the debug message changes in patch 2 for messages in
    igc_probe, also made reg_test[] static in patch 3 based on community
    feedback
v4: Updated the patch description for patch 2, which referred to changes
    that no longer existed in the patch

The following are changes since commit dbfe7d74376e187f3c6eaff822e85176bc2cd06e:
  rds: convert get_user_pages() --> pin_user_pages()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Andre Guedes (5):
  igc: Use netdev log helpers in igc_main.c
  igc: Use netdev log helpers in igc_ethtool.c
  igc: Use netdev log helpers in igc_ptp.c
  igc: Use netdev log helpers in igc_dump.c
  igc: Use netdev log helpers in igc_base.c

Sasha Neftin (3):
  igc: Add ECN support for TSO
  igc: Remove unneeded definition
  igc: Remove unneeded register

Vitaly Lifshits (1):
  igc: add support to eeprom, registers and link self-tests

 drivers/net/ethernet/intel/igc/Makefile      |   2 +-
 drivers/net/ethernet/intel/igc/igc.h         |   4 +
 drivers/net/ethernet/intel/igc/igc_base.c    |   6 +-
 drivers/net/ethernet/intel/igc/igc_defines.h |   1 -
 drivers/net/ethernet/intel/igc/igc_diag.c    | 186 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_diag.h    |  30 +++
 drivers/net/ethernet/intel/igc/igc_dump.c    | 109 ++++++-----
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  93 ++++++++--
 drivers/net/ethernet/intel/igc/igc_main.c    | 116 ++++++------
 drivers/net/ethernet/intel/igc/igc_ptp.c     |  12 +-
 drivers/net/ethernet/intel/igc/igc_regs.h    |   3 +-
 11 files changed, 415 insertions(+), 147 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.c
 create mode 100644 drivers/net/ethernet/intel/igc/igc_diag.h

-- 
2.26.2

