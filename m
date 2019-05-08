Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D072172E6
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfEHHwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:52:24 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:56520 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726438AbfEHHva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 03:51:30 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3AAD9C00F1;
        Wed,  8 May 2019 07:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557301893; bh=+bRqanSndBDwhYIr9AZ4tJq7qIJWXtCtdw6+baQLE1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=XCXsXlxzFnlaPcB29aMFSUf82T+uRjthoaA/FBKopyZAvuplcF2kO4vy9kUQjMIIZ
         30YMlBvf5KjT1AHdraVHDUZWuTfmde8psj9+bTrk8iDVInAwKR42C1wyfaHCUmb5jq
         RHozOudoCM24JCTWBtrOmutLhQhTc8uohXI3K+7d1fHKTg3xl6fZ2gzcKx0OFq31/j
         1kszT58vKZ8KAULvdxYmv6mj0mRNYwBErssflGGpcGk45LKgSmj0jV1M/9a9W7+ZR3
         qqUnp4ckV4K9xMYX5+PGCmzL+l/iI10IwejnWYs8NCmHY0LI6KE06ykwixS46aqgZO
         ESCdIlD4xf+fw==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7891AA02D6;
        Wed,  8 May 2019 07:51:29 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id EB8DA3D532;
        Wed,  8 May 2019 09:51:27 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 09/11] net: stmmac: dwxgmac2: Also pass control frames while in promisc mode
Date:   Wed,  8 May 2019 09:51:09 +0200
Message-Id: <78a2b49986abea228d2f79d752466450e5f933bb.1557300602.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
In-Reply-To: <cover.1557300602.git.joabreu@synopsys.com>
References: <cover.1557300602.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order for the selftests to run the Flow Control selftest we need to
also pass control frames to the stack.

Pass this type of frames while in promiscuous mode.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h      | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index f629ccc8932a..b8296eb41011 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -40,6 +40,7 @@
 #define XGMAC_CORE_INIT_RX		0
 #define XGMAC_PACKET_FILTER		0x00000008
 #define XGMAC_FILTER_RA			BIT(31)
+#define XGMAC_FILTER_PCF		BIT(7)
 #define XGMAC_FILTER_PM			BIT(4)
 #define XGMAC_FILTER_HMC		BIT(2)
 #define XGMAC_FILTER_PR			BIT(0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index c27b3ca052ea..bfa7d6913fd4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -310,7 +310,7 @@ static void dwxgmac2_set_filter(struct mac_device_info *hw,
 	u32 value = XGMAC_FILTER_RA;
 
 	if (dev->flags & IFF_PROMISC) {
-		value |= XGMAC_FILTER_PR;
+		value |= XGMAC_FILTER_PR | XGMAC_FILTER_PCF;
 	} else if ((dev->flags & IFF_ALLMULTI) ||
 		   (netdev_mc_count(dev) > HASH_TABLE_SIZE)) {
 		value |= XGMAC_FILTER_PM;
-- 
2.7.4

