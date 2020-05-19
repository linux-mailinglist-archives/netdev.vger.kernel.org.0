Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3E71D8CD7
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgESBDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:03:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:20124 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgESBDp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 21:03:45 -0400
IronPort-SDR: ItIVan8nTX927v9hhfR/zZV/iZBmsCJTMswok/0Gp0Co6u1ktR4rV4Yr23utohfKYYBU218Kg/
 M/aD3kkHXMTg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 18:03:45 -0700
IronPort-SDR: GoVFh/jokRS0wE+rFUKGb3jtVyanwm2vj/oh5h1qzkC5b+PV1Q/4DbF5zogQZ1a5ibMncGLg4l
 7tcWKKP2BvfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,408,1583222400"; 
   d="scan'208";a="267713965"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006.jf.intel.com with ESMTP; 18 May 2020 18:03:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v5 0/9][pull request] 1GbE Intel Wired LAN Driver Updates 2020-05-18
Date:   Mon, 18 May 2020 18:03:34 -0700
Message-Id: <20200519010343.2386401-1-jeffrey.t.kirsher@intel.com>
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
v5: Scrubbed patches 4-7 patch description, which also referred to
    changes that no longer existed in the patch

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

