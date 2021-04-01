Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A281350EC6
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhDAGCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:02:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:24122 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233589AbhDAGCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 02:02:18 -0400
IronPort-SDR: UWmDSWNdsWUV+rcRMAK5bEsrFweQJpG3mtTOzoTiOWvzj330R7pQKAOAAz0wJjfQ2axZbSle96
 Y35IJkTk0sKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="189929995"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="189929995"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 23:02:14 -0700
IronPort-SDR: 3syucskN8LM8LtLBaJYl15+HJr2elqI3Irezo8nFFZK7qqndb3cAk7h8Sm6ZMiEAa1rK5s636C
 M8QXjV6XVGBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="377569641"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 31 Mar 2021 23:02:09 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.59])
        by linux.intel.com (Postfix) with ESMTP id 6387F5808ED;
        Wed, 31 Mar 2021 23:02:07 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] net: stmmac: remove unnecessary pci_enable_msi() call
Date:   Thu,  1 Apr 2021 14:06:28 +0800
Message-Id: <20210401060628.27339-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit d2a029bde37b ("stmmac: pci: add MSI support for Intel Quark
X1000") introduced a pci_enable_msi() call in stmmac_pci.c.

With the commit 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to
contain all Intel platform"), Intel Quark platform related codes
have been moved to the newly created driver.

Removing this unnecessary pci_enable_msi() call as there are no other
devices that uses stmmac-pci and need MSI to be enabled.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 272cb47af9f2..95e0e4d6f74d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -198,8 +198,6 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 
-	pci_enable_msi(pdev);
-
 	memset(&res, 0, sizeof(res));
 	res.addr = pcim_iomap_table(pdev)[i];
 	res.wol_irq = pdev->irq;
-- 
2.25.1

