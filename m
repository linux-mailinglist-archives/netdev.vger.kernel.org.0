Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C938F292ED
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389537AbfEXIWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:22:02 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:38308 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389456AbfEXIUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:20:38 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BB77CC0134;
        Fri, 24 May 2019 08:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558686023; bh=yiL/SwWSfq3piLGk33q1eN8HnE24GZKTj2gsPp16vxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Y2Y8p34FaYKMDnVjqXiTFN3KXPFHPP2XFghD1ZKrNi6oYZ7yr8jw/0VCvZUuHhQje
         5bHQBT5sOm8o3fAbWi3vtMrIyFPPeLcrTR5/CZLy6ZwAk1ox0dPGlWzrzkFRSGnrPz
         kLzMIQ3tqHQHXqFX5RsjO7Rwq90TY32YRskhcoSfJJkYAIKDgneELYHtjv5xPzTiTA
         s+ZztZP2U0PJam8Um6MlnihcFC0q/R9Mw3ZRAhn4D4eGVTsDAmE5IjF4mTVgy1JsrU
         qN5f5jx7u+m4Pph7iN7nOJY7Gyh4Nq5RHHh3wDaB5lNW2M6Dezez4zEJEsR9Ji2vF4
         +xbGet0WMewhA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 76839A024F;
        Fri, 24 May 2019 08:20:37 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id F1F133FB05;
        Fri, 24 May 2019 10:20:35 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 09/18] net: stmmac: dwmac4/5: Also pass control frames while in promisc mode
Date:   Fri, 24 May 2019 10:20:17 +0200
Message-Id: <3cb0f3ace4174fdd323ec01e57f8bfa6eb41f23b.1558685827.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558685827.git.joabreu@synopsys.com>
References: <cover.1558685827.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for the selftests to run the Flow Control selftest we need to
also pass pause frames to the stack.

Pass this type of frames while in promiscuous mode.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 3dddd7902b0f..c3cbca804bcd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -64,6 +64,7 @@
 #define GMAC_PACKET_FILTER_PR		BIT(0)
 #define GMAC_PACKET_FILTER_HMC		BIT(2)
 #define GMAC_PACKET_FILTER_PM		BIT(4)
+#define GMAC_PACKET_FILTER_PCF		BIT(7)
 
 #define GMAC_MAX_PERFECT_ADDRESSES	128
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 45c294f39ea6..31679480564a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -406,7 +406,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	unsigned int value = 0;
 
 	if (dev->flags & IFF_PROMISC) {
-		value = GMAC_PACKET_FILTER_PR;
+		value = GMAC_PACKET_FILTER_PR | GMAC_PACKET_FILTER_PCF;
 	} else if ((dev->flags & IFF_ALLMULTI) ||
 			(netdev_mc_count(dev) > HASH_TABLE_SIZE)) {
 		/* Pass all multi */
-- 
2.7.4

