Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54D1594F8
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 09:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfF1HaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 03:30:24 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:48026 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726502AbfF1H3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 03:29:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5A2B2C0BF5;
        Fri, 28 Jun 2019 07:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561706965; bh=3trC633LXHdsbnL+z8ckfvG37DH+gbMbhg4GLhNIJwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Nv/ZMtER7FkR6UkUeKnLy57LYbPV1xDoVoPwD+6ixNY0gxsd+/mvlmgwaWwcqJdk9
         zkqlZ+ZRFzhiUZp8vCPXO3l3eaLEgRWRwYYlS/X36p8xIIRpgBAInlbt7uc8hKGdF8
         gtszstQY92+YLDGoEY9RVJbt8CARGWSx5IPitHcYUdah/t6T1Yt+JwyfhPHyKzY1Bd
         V3h8wWh6UMODdBeM4jATqmeCTliIXdjgQb5id0LqWcSvZecGFgY6mZv1WIqffOKu5j
         0/ZOYS3CB9we6ASg/yAIjj1e30b4T8cwBPOyxRRYA/POoIQsvp3Ux/lhu+EtnJjTcX
         0RSCbIwbK92lg==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id C8E3FA005C;
        Fri, 28 Jun 2019 07:29:23 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 53A2A3E945;
        Fri, 28 Jun 2019 09:29:23 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next v2 01/10] net: stmmac: dwxgmac: Enable EDMA by default
Date:   Fri, 28 Jun 2019 09:29:12 +0200
Message-Id: <c5fa7360c60654003685a6b0e0c3b5cb30cefb22.1561706801.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561706800.git.joabreu@synopsys.com>
References: <cover.1561706800.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the EDMA feature by default which gives higher performance.

Changes from v1:
	- Do not use magic values (David)

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 4 ++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index b8296eb41011..c9e802faabb5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -177,6 +177,10 @@
 #define XGMAC_BLEN8			BIT(2)
 #define XGMAC_BLEN4			BIT(1)
 #define XGMAC_UNDEF			BIT(0)
+#define XGMAC_TX_EDMA_CTRL		0x00003040
+#define XGMAC_TDPS			GENMASK(29, 0)
+#define XGMAC_RX_EDMA_CTRL		0x00003044
+#define XGMAC_RDPS			GENMASK(29, 0)
 #define XGMAC_DMA_CH_CONTROL(x)		(0x00003100 + (0x80 * (x)))
 #define XGMAC_PBLx8			BIT(16)
 #define XGMAC_DMA_CH_TX_CONTROL(x)	(0x00003104 + (0x80 * (x)))
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 7861a938420a..42448973c36e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -122,6 +122,8 @@ static void dwxgmac2_dma_axi(void __iomem *ioaddr, struct stmmac_axi *axi)
 	}
 
 	writel(value, ioaddr + XGMAC_DMA_SYSBUS_MODE);
+	writel(XGMAC_TDPS, ioaddr + XGMAC_TX_EDMA_CTRL);
+	writel(XGMAC_RDPS, ioaddr + XGMAC_RX_EDMA_CTRL);
 }
 
 static void dwxgmac2_dma_rx_mode(void __iomem *ioaddr, int mode,
-- 
2.7.4

