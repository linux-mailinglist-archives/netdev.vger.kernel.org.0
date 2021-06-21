Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8743AE661
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhFUJsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:48:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:62591 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230479AbhFUJsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 05:48:30 -0400
IronPort-SDR: cxiT4A+hFsFQS8WsrkA2drggYYxaWXo5BdCSCiX/OdYraVSjzp2PLhJSZi0YnfLB/4YYURmeeZ
 MfWEAo3CaPSg==
X-IronPort-AV: E=McAfee;i="6200,9189,10021"; a="206852457"
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="206852457"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 02:46:15 -0700
IronPort-SDR: neKELTmt31WoAvjNQcXp+1P6WpL/4Do+v28x74Uedwxd8vt3xG6AIgcdfznSP26mRdEAIRLioM
 CD6Zrh0XniJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,289,1616482800"; 
   d="scan'208";a="638720326"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga006.fm.intel.com with ESMTP; 21 Jun 2021 02:46:10 -0700
From:   Ling Pei Lee <pei.lee.ling@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     pei.lee.ling@intel.com
Subject: [PATCH net-next V1 4/4] stmmac: intel: set PCI_D3hot in suspend
Date:   Mon, 21 Jun 2021 17:45:36 +0800
Message-Id: <20210621094536.387442-5-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210621094536.387442-1-pei.lee.ling@intel.com>
References: <20210621094536.387442-1-pei.lee.ling@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>

During suspend, set the Intel mgbe to D3hot state
to save power consumption.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ling Pei Lee <pei.lee.ling@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 73be34a10a4c..69a725b661c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1088,6 +1088,7 @@ static int __maybe_unused intel_eth_pci_suspend(struct device *dev)
 		return ret;
 
 	pci_wake_from_d3(pdev, true);
+	pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
 }
 
-- 
2.25.1

