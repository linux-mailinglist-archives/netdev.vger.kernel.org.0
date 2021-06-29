Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F1D3B6CD6
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhF2DNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:13:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:40097 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231949AbhF2DNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 23:13:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10029"; a="188454198"
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="188454198"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2021 20:10:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,307,1616482800"; 
   d="scan'208";a="558597330"
Received: from peileeli.png.intel.com ([172.30.240.12])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jun 2021 20:10:37 -0700
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
Subject: [PATCH net-next V2 3/3] stmmac: intel: set PCI_D3hot in suspend
Date:   Tue, 29 Jun 2021 11:08:59 +0800
Message-Id: <20210629030859.1273157-4-pei.lee.ling@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210629030859.1273157-1-pei.lee.ling@intel.com>
References: <20210629030859.1273157-1-pei.lee.ling@intel.com>
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

