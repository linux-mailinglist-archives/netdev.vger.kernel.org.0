Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36461A3769
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgDIPsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:48:32 -0400
Received: from mga07.intel.com ([134.134.136.100]:53939 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbgDIPsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 11:48:31 -0400
IronPort-SDR: wF4/dJZxCXb53RPzecd/8EQi/Xs3jTnnth1yoyzlrFS4CtLhcNAdS8DvDXKfR5T9hJ3hQCo6XA
 R8Stlf8trwOA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 08:48:26 -0700
IronPort-SDR: MjIasUa9+1fKs3aAMLD6jReyrtKTSoH3j6Ba3NucOU5qu0QW7mhMVnQ9y57fEJvkekrEOsu12u
 E4mmP8Ud1YLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,363,1580803200"; 
   d="scan'208";a="244349156"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by fmsmga008.fm.intel.com with ESMTP; 09 Apr 2020 08:48:23 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [RFC,net-next,v2, 0/1] Enable SERDES power up/down
Date:   Thu,  9 Apr 2020 23:48:22 +0800
Message-Id: <20200409154823.26480-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes from v1:
1.Only the configuration of the SERDES logic is kept, other SW acrh has
  changed.
2.Removed the proposed new files intel_serdes.c and intel_serdes.h and
  moved the SERDES configuration logic to dwmac-intel.c and dwmac_intel.h.
3.Added 2 BSP callbacks ->serdes_powerup() and ->serdes_powerup().
4.The suggested 2 new BSP callbacks is called in stmmac_dvr_probe() and
  stmmac_dvr_remove().

This platform specific SERDES configuration not able separate 100% cleanly
from the main dwmac logic because mdio communication is needed for
configuring the SERDES power-up sequence. As for SERDES power-down
sequence, it must be configured after all dma stop and before unregister
the mdio bus.
This implementation should have the least changes on the
main dwmac logic but still serve the purpose for providing BSP callback
for any platform that needs to configure SERDES.

Voon Weifeng (1):
  net: stmmac: Enable SERDES power up/down sequence

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 171 ++++++++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  10 +
 include/linux/stmmac.h                        |   3 +
 3 files changed, 184 insertions(+)

-- 
2.17.1

