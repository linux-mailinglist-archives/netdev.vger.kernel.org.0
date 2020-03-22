Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AB318E91B
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 14:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgCVNXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 09:23:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:6483 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVNXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 09:23:47 -0400
IronPort-SDR: +fPXcTOanJZuutaMe3soX6yKnXTWMH7Zr8ZHZYarTCTYxZSIXEg00ch2ZfVucoqDpXdmR1YVLU
 t9CnXFzmv1tQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 06:23:46 -0700
IronPort-SDR: kmEj8gauI73f3PTu4kwvPQK/oTWq3PUfEU6KV4hf4PYBn8KE5P8yJrzVpDJ/WYSumVy/vL2ehb
 l7GmMrbx3Xhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="392638998"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2020 06:23:43 -0700
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
Subject: [RFC,net-next,v1, 0/1] Enable SERDES power up/down
Date:   Sun, 22 Mar 2020 21:23:41 +0800
Message-Id: <20200322132342.2687-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to enable Intel SERDES power up/down sequence. The SERDES
converts 8/10 bits data to SGMII signal.

1. Two new files intel_serdes.c and intel.h have been created to include
the power up/down logic.

2. Platform data has_serdes is created to identify HW system that requires
SERDES for SGMII mode. Expecting all Intel HW system will require it.
The identification logic is added in hwif.

3. A new stmmac_serdes_ops struct is introduced as helpers to program
SERDES.

Voon Weifeng (1):
  net: stmmac: Enable SERDES power up/down sequence

 drivers/net/ethernet/stmicro/stmmac/Makefile  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.c    |  44 ++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  12 ++
 .../ethernet/stmicro/stmmac/intel_serdes.c    | 181 ++++++++++++++++++
 .../ethernet/stmicro/stmmac/intel_serdes.h    |  23 +++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   8 +
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  |   6 +
 include/linux/stmmac.h                        |   2 +
 10 files changed, 278 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/intel_serdes.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/intel_serdes.h

-- 
2.17.1

