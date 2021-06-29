Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA4A3B6CCD
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhF2DMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:12:54 -0400
Received: from mga17.intel.com ([192.55.52.151]:40075 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhF2DMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 23:12:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="188454181"
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="188454181"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 20:10:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="558597289"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2021 20:10:21 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, vee.khee.wong@linux.intel.com,
        vee.khee.wong@intel.com, tee.min.tan@intel.com,
        michael.wei.hong.sit@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com
Subject: [PATCH net-next V2 0/3] Add option to enable PHY WOL with PMT enabled
Date:   Tue, 29 Jun 2021 11:08:56 +0800
Message-Id: <20210629030859.1273157-1-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset main objective is to provide an option to enable PHY WoL even the PMT is enabled by default in the HW features.

The current stmmac driver WOL implementation will enable MAC WOL if MAC HW PMT feature is on. Else, the driver will check for PHY WOL support.
Intel EHL mgbe are designed to wake up through PHY WOL although the HW PMT is enabled.Hence, introduced use_phy_wol platform data to provide this PHY WOL option. Set use_phy_wol will disable the plat->pmt which currently used to determine the system to wake up by MAC WOL or PHY WOL.

This WOL patchset includes of setting the device power state to D3hot.
This is because the EHL PSE will need to PSE mgbe to be in D3 state in order for the PSE to goes into suspend mode.

Change Log:
 V2: Drop Patch #3 net: stmmac: Reconfigure the PHY WOL settings in stmmac_resume().

Ling Pei Lee (2):
  net: stmmac: option to enable PHY WOL with PMT enabled
  stmmac: intel: Enable PHY WOL option in EHL

Voon Weifeng (1):
  stmmac: intel: set PCI_D3hot in suspend

 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 include/linux/stmmac.h                            | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.25.1

