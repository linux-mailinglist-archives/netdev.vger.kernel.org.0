Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6F05731B1
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbiGMI5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiGMI5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:57:04 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDD2D214F
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657702623; x=1689238623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O+VNUCblORUuf5ZQVtzLX/WC3kcdBeMeLLeUsfwe3bo=;
  b=UwmKFY0gRi1m0sEBg5XQe1yeEG1aUIZGSzj4fDInf1McK13//4LpQgr1
   QTd/QKHkiFDAYSdCothhLcrIfCoG65UoN/qUV17ZEVU2XAxpkkBEtBgJ+
   0kASWAMJZjZAxtU4S0zdYbqj6zOs519Bb448EVq6Wbl+/SUYacH9javYe
   3NQ2/KLPSQt1kMsGTFqpOFFp1o56uuff+WnCNf9RySKDZ2P7duwt/OCwg
   6FxytebGo/ZgQm16TI3kdoGkfXqDyi/yy/XsgC25q/4TikETY/dsd593N
   5nYyyPCtSaMF0W/DOAQOoGbB0OY15+0mVkQZx9nbiy8vW+DfvJYi7FyIP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="265566767"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="265566767"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 01:57:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="622859459"
Received: from junxiaochang.bj.intel.com ([10.238.135.52])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 01:57:01 -0700
From:   Junxiao Chang <junxiao.chang@intel.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org
Cc:     junxiao.chang@intel.com
Subject: [PATCH 2/2] net: stmmac: remove duplicate dma queue channel macros
Date:   Wed, 13 Jul 2022 16:47:28 +0800
Message-Id: <20220713084728.1311465-2-junxiao.chang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220713084728.1311465-1-junxiao.chang@intel.com>
References: <20220713084728.1311465-1-junxiao.chang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It doesn't need extra macros for queue 0 & 4. Same macro could
be used for all 8 queues.

Signed-off-by: Junxiao Chang <junxiao.chang@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  4 +---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 11 ++++-------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 462ca7ed095a2..a7b725a7519bb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -330,9 +330,7 @@ enum power_event {
 
 #define MTL_RXQ_DMA_MAP0		0x00000c30 /* queue 0 to 3 */
 #define MTL_RXQ_DMA_MAP1		0x00000c34 /* queue 4 to 7 */
-#define MTL_RXQ_DMA_Q04MDMACH_MASK	GENMASK(3, 0)
-#define MTL_RXQ_DMA_Q04MDMACH(x)	((x) << 0)
-#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	GENMASK(11 + (8 * ((x) - 1)), 8 * (x))
+#define MTL_RXQ_DMA_QXMDMACH_MASK(x)	GENMASK(3 + (8 * (x)), 8 * (x))
 #define MTL_RXQ_DMA_QXMDMACH(chan, q)	((chan) << (8 * (q)))
 
 #define MTL_CHAN_BASE_ADDR		0x00000d00
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index c4d1072fbea39..eccd6b7702c4a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -266,15 +266,12 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	else
 		value = readl(ioaddr + MTL_RXQ_DMA_MAP1);
 
-	if (queue == 0 || queue == 4) {
-		value &= ~MTL_RXQ_DMA_Q04MDMACH_MASK;
-		value |= MTL_RXQ_DMA_Q04MDMACH(chan);
-	} else if (queue > 4) {
-		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
-		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
-	} else {
+	if (queue < 4) {
 		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue);
 		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);
+	} else {
+		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
+		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
 	}
 
 	if (queue < 4)
-- 
2.25.1

