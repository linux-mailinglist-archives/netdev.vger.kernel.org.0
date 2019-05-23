Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACE927744
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 09:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbfEWHiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 03:38:50 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:43560 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730031AbfEWHha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 03:37:30 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 96925C018E;
        Thu, 23 May 2019 07:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1558597057; bh=dSfsoxY1Y48tR+b/ya+TEKJwI7LJAv92EQzHP9XM8ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=QPQVN0X5EnXGh6wImOV/KNt6sJK8YroIE6r6/hDD7TkY0Zr1YFCneBi5Xc75Q0Os+
         6EJRjggIk3ZcAX/ya0tymv62bgMER9W6FVgDqflZnqVf56s2VreWQRWH1v2sW81Psa
         ABDkhI6cNybzOWiHycCznzp8cTSJveIn2wXv1+nk+qe4Tg3DusEn6xQgDzpl2bbGVn
         3vq9gpPXyCV5m/o+DKbPm4fzglYLhtPcTEYeEdK39kpG2QI3kmiggHbqwcZFFnrvQZ
         byVOFCeNyh5OlddJLa15r0EWM3Pu84UtmcG0j7JKea2SbUEZ1UISTUc2HY9Pcbegr/
         bFPyQp4v63paQ==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 048D4A00AC;
        Thu, 23 May 2019 07:37:30 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 9ACCC3D955;
        Thu, 23 May 2019 09:37:28 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 10/18] net: stmmac: dwxgmac2: Also pass control frames while in promisc mode
Date:   Thu, 23 May 2019 09:37:00 +0200
Message-Id: <5054f5b9e5a7d88d328d81c22e184e2e7412304d.1558596600.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
In-Reply-To: <cover.1558596599.git.joabreu@synopsys.com>
References: <cover.1558596599.git.joabreu@synopsys.com>
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

