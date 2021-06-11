Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB03D3A3C95
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhFKHJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:09:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:17509 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhFKHJi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 03:09:38 -0400
IronPort-SDR: qMP3c1W5YYO7OcH7rYaVk3YWGfN+wDpfBFzBXH5nZfP1ZXX15r1DHi6hixFxq9Ff6JatA9X6zd
 EvKv6AilKZHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="185166837"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="185166837"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 00:07:04 -0700
IronPort-SDR: afjxRnVnKdW7kcXTge4k/NNkVMeLOqvtprD/PsspPRHe5JKjDig+E7erlN7fy+rUahcnJ5tQvL
 rc0eajHzK7NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="486491531"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 11 Jun 2021 00:07:02 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id B189F580BD5;
        Fri, 11 Jun 2021 00:06:59 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>
Subject: [PATCH net-next v1 1/1] net: stmmac: Fix unused values warnings
Date:   Fri, 11 Jun 2021 15:11:43 +0800
Message-Id: <20210611071143.987866-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines
for mac, safety, RX & TX") introduced the converity warnings:-

  1. Unused value (UNUSED_VALUE)
     assigned_value: Assigning value REQ_IRQ_ERR_MAC to irq_err here,
     but that stored value is not used.

  2. Unused value (UNUSED_VALUE)
     assigned_value: Assigning value REQ_IRQ_ERR_NO to irq_err here,
     but that stored value is overwritten before it can used.

  3. Unused value (UNUSED_VALUE)
     assigned_value: Assigning value REQ_IRQ_ERR_WOL to irq_err here,
     but that stored value is not used.

Fixed these by removing the unnecessary value assignments.

Fixes: 8532f613bc78 ("net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index db97cd4b871d..4177fd6a9db5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3406,8 +3406,8 @@ static void stmmac_free_irq(struct net_device *dev,
 
 static int stmmac_request_irq_multi_msi(struct net_device *dev)
 {
-	enum request_irq_err irq_err = REQ_IRQ_ERR_NO;
 	struct stmmac_priv *priv = netdev_priv(dev);
+	enum request_irq_err irq_err;
 	cpumask_t cpu_mask;
 	int irq_idx = 0;
 	char *int_name;
@@ -3554,8 +3554,8 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 
 static int stmmac_request_irq_single(struct net_device *dev)
 {
-	enum request_irq_err irq_err = REQ_IRQ_ERR_NO;
 	struct stmmac_priv *priv = netdev_priv(dev);
+	enum request_irq_err irq_err;
 	int ret;
 
 	ret = request_irq(dev->irq, stmmac_interrupt,
@@ -3565,7 +3565,7 @@ static int stmmac_request_irq_single(struct net_device *dev)
 			   "%s: ERROR: allocating the IRQ %d (error: %d)\n",
 			   __func__, dev->irq, ret);
 		irq_err = REQ_IRQ_ERR_MAC;
-		return ret;
+		goto irq_error;
 	}
 
 	/* Request the Wake IRQ in case of another line
@@ -3579,7 +3579,7 @@ static int stmmac_request_irq_single(struct net_device *dev)
 				   "%s: ERROR: allocating the WoL IRQ %d (%d)\n",
 				   __func__, priv->wol_irq, ret);
 			irq_err = REQ_IRQ_ERR_WOL;
-			return ret;
+			goto irq_error;
 		}
 	}
 
-- 
2.25.1

