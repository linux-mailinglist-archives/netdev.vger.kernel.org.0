Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19FE5131C39
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgAFXUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:20:01 -0500
Received: from mga05.intel.com ([192.55.52.43]:21026 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgAFXUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:20:01 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 15:20:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,404,1571727600"; 
   d="scan'208";a="303013015"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 06 Jan 2020 15:20:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next 0/5][pull request] 1GbE Intel Wired LAN Driver Updates 2020-01-06
Date:   Mon,  6 Jan 2020 15:19:51 -0800
Message-Id: <20200106231956.549255-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to igc to add basic support for
timestamping.

Vinicius adds basic support for timestamping and enables ptp4l/phc2sys
to work with i225 devices.  Initially, adds the ability to read and
adjust the PHC clock.  Patches 2 & 3 enable and retrieve hardware
timestamps.  Patch 4 implements the ethtool ioctl that ptp4l uses to
check what timestamping methods are supported.  Lastly, added support to
do timestamping using the "Start of Packet" signal from the PHY, which
is now supported in i225 devices.

While i225 does support multiple PTP domains, with multiple timestamping
registers, we currently only support one PTP domain and use only one of
the timestamping registers for implementation purposes.

The following are changes since commit df2c2ba831a04083ad7485684896eeb090ca3c7d:
  Merge branch 'Convert-Felix-DSA-switch-to-PHYLINK'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 1GbE

Vinicius Costa Gomes (5):
  igc: Add basic skeleton for PTP
  igc: Add support for RX timestamping
  igc: Add support for TX timestamping
  igc: Add support for ethtool GET_TS_INFO command
  igc: Use Start of Packet signal from PHY for timestamping

 drivers/net/ethernet/intel/igc/Makefile      |   2 +-
 drivers/net/ethernet/intel/igc/igc.h         |  45 ++
 drivers/net/ethernet/intel/igc/igc_defines.h |  66 ++
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  34 +
 drivers/net/ethernet/intel/igc/igc_main.c    |  87 +++
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 716 +++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_regs.h    |  27 +
 7 files changed, 976 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/intel/igc/igc_ptp.c

-- 
2.24.1

