Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151DF3A42C2
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 15:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhFKNN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 09:13:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:13487 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhFKNN1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 09:13:27 -0400
IronPort-SDR: dxJyTGTaJb9taIOS70nVGE4i4WHZ9y0muaiRxkFnVFfITAW/yZZTRTwj9bccBt6iD/WubtOrub
 ZW/VHVxAVWRw==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="185895071"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="185895071"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 06:11:29 -0700
IronPort-SDR: T9+sZks7mTlAmO2MqDEeaV+rkrR40TlgFFjS1rHQbgX3eYrkZ0gVPkjH8TctM+QpiGoIIDWM4Y
 5VjUWBxK7HFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="403010705"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 11 Jun 2021 06:11:29 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 31E635808BA;
        Fri, 11 Jun 2021 06:11:27 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] stmmac: intel: move definitions to dwmac-intel header file
Date:   Fri, 11 Jun 2021 21:16:08 +0800
Message-Id: <20210611131609.1685105-2-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611131609.1685105-1-vee.khee.wong@linux.intel.com>
References: <20210611131609.1685105-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently some of the dwmac-intel definitions are in the header file,
while some are in the driver source file. Cleaning this by moving all
the definitions to the header file.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c    | 16 ----------------
 .../net/ethernet/stmicro/stmmac/dwmac-intel.h    | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 6a9a19b0844c..a38e47e6d470 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -10,22 +10,6 @@
 #include "stmmac.h"
 #include "stmmac_ptp.h"
 
-#define INTEL_MGBE_ADHOC_ADDR	0x15
-#define INTEL_MGBE_XPCS_ADDR	0x16
-
-/* Selection for PTP Clock Freq belongs to PSE & PCH GbE */
-#define PSE_PTP_CLK_FREQ_MASK		(GMAC_GPO0 | GMAC_GPO3)
-#define PSE_PTP_CLK_FREQ_19_2MHZ	(GMAC_GPO0)
-#define PSE_PTP_CLK_FREQ_200MHZ		(GMAC_GPO0 | GMAC_GPO3)
-#define PSE_PTP_CLK_FREQ_256MHZ		(0)
-#define PCH_PTP_CLK_FREQ_MASK		(GMAC_GPO0)
-#define PCH_PTP_CLK_FREQ_19_2MHZ	(GMAC_GPO0)
-#define PCH_PTP_CLK_FREQ_200MHZ		(0)
-
-/* Cross-timestamping defines */
-#define ART_CPUID_LEAF		0x15
-#define EHL_PSE_ART_MHZ		19200000
-
 struct intel_priv_data {
 	int mdio_adhoc_addr;	/* mdio address for serdes & etc */
 	unsigned long crossts_adj;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
index 20d14e588044..0a37987478c1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
@@ -34,4 +34,20 @@
 #define SERDES_RATE_PCIE_SHIFT	8
 #define SERDES_PCLK_SHIFT	12
 
+#define INTEL_MGBE_ADHOC_ADDR	0x15
+#define INTEL_MGBE_XPCS_ADDR	0x16
+
+/* Cross-timestamping defines */
+#define ART_CPUID_LEAF		0x15
+#define EHL_PSE_ART_MHZ		19200000
+
+/* Selection for PTP Clock Freq belongs to PSE & PCH GbE */
+#define PSE_PTP_CLK_FREQ_MASK		(GMAC_GPO0 | GMAC_GPO3)
+#define PSE_PTP_CLK_FREQ_19_2MHZ	(GMAC_GPO0)
+#define PSE_PTP_CLK_FREQ_200MHZ		(GMAC_GPO0 | GMAC_GPO3)
+#define PSE_PTP_CLK_FREQ_256MHZ		(0)
+#define PCH_PTP_CLK_FREQ_MASK		(GMAC_GPO0)
+#define PCH_PTP_CLK_FREQ_19_2MHZ	(GMAC_GPO0)
+#define PCH_PTP_CLK_FREQ_200MHZ		(0)
+
 #endif /* __DWMAC_INTEL_H__ */
-- 
2.25.1

