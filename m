Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0FF2DFEE6
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 18:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgLURRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 12:17:48 -0500
Received: from atlmailgw1.ami.com ([63.147.10.40]:45050 "EHLO
        atlmailgw1.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgLURRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 12:17:48 -0500
X-AuditID: ac1060b2-a93ff700000017ec-5f-5fe0d4e5ce60
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw1.ami.com (Symantec Messaging Gateway) with SMTP id DE.3D.06124.5E4D0EF5; Mon, 21 Dec 2020 12:01:25 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Mon, 21 Dec 2020 12:01:24 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed,ncsi-rx, v1 1/1] net: ftgmac100: Fix AST2600 EVB NCSI RX issue
Date:   Mon, 21 Dec 2020 12:00:46 -0500
Message-ID: <20201221170048.29821-2-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215192323.24359-1-hongweiz@ami.com>
References: <20201215192323.24359-1-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWyRiBhgu7TKw/iDfpuWFrsusxhMed8C4vF
        7/N/mS0ubOtjtWhefY7Z4vKuOWwWxxaIWZxqecHiwOFxtX0Xu8eWlTeZPC5+PMbssWlVJ5vH
        +RkLGT0+b5ILYIvisklJzcksSy3St0vgypg/W6egT6Biz/rdjA2MJ3m7GDk5JARMJNb/W8PS
        xcjFISSwi0ni3M3/7CAJIIdRYvp3HhCbTUBNYu/mOUwgRSICqxklejb8YgRxmAU6GCWmvvgK
        1iEs4C/x/PBlZhCbRUBVYk/PBUYQm1fAVGLFjwnMEOvkJVZvOABkc3BwCphJ7DklB7HMVKJ1
        3zsmiHJBiZMzn7CA2MwCEhIHX7xghqiRlbh16DETxBhFiQe/vrNOYBSYhaRlFpKWBYxMqxiF
        EktychMzc9LLDfUSczP1kvNzNzFCwnrTDsaWi+aHGJk4GA8xSnAwK4nwmkndjxfiTUmsrEot
        yo8vKs1JLT7EKM3BoiTOu8r9aLyQQHpiSWp2ampBahFMlomDU6qBsYQjXlJvq+G/2T8D+Fhj
        z1ZNVqnINJubeIjtiPX97MntXDNNPms3O7SX3ZjjKLxic2bfUr+aRVWK+6LMOja82OxUX2dp
        bGB41WpPd+mkq7ote2uvpzbf+yX2JTn95un2ZncXL+bw2U/2vNvLxCRfcO3w7APTz11dZBej
        7W3opbihXm7d/PxYJZbijERDLeai4kQAoGSfzlkCAAA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When FTGMAC100 driver is used on other NCSI Ethernet controllers, few
controllers have compatible issue, removing FTGMAC100_RXDES0_RX_ERR bit
from RXDES0_ANY_ERROR can fix the issue.

Fixes: 7ee2d5b4d4340353 ("ARM: dts: nuvoton: Add Fii Kudo system")
Signed-off-by: Hongwei Zhang <hongweiz@ami.com>
---
 drivers/net/ethernet/faraday/Kconfig     | 9 +++++++++
 drivers/net/ethernet/faraday/ftgmac100.h | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/faraday/Kconfig b/drivers/net/ethernet/faraday/Kconfig
index c2677ec0564d..ccd0c30be0db 100644
--- a/drivers/net/ethernet/faraday/Kconfig
+++ b/drivers/net/ethernet/faraday/Kconfig
@@ -38,4 +38,13 @@ config FTGMAC100
 	  from Faraday. It is used on Faraday A369, Andes AG102 and some
 	  other ARM/NDS32 SoC's.
 
+config FTGMAC100_RXDES0_RX_ERR_CHK
+	bool "Include FTGMAC100_RXDES0_RX_ERR in RXDES0_ANY_ERROR"
+	default y
+	depends on FTGMAC100
+	help
+	  Say N here if the NCSI controller on your platform has compatible
+	  issue with FTGMAC100, thus always trigger RXDES0_RX_ERR. Exclude
+	  this bit can fix the issue.
+
 endif # NET_VENDOR_FARADAY
diff --git a/drivers/net/ethernet/faraday/ftgmac100.h b/drivers/net/ethernet/faraday/ftgmac100.h
index 63b3e02fab16..59e1bd52d261 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.h
+++ b/drivers/net/ethernet/faraday/ftgmac100.h
@@ -251,12 +251,20 @@ struct ftgmac100_rxdes {
 #define FTGMAC100_RXDES0_RXPKT_RDY	(1 << 31)
 
 /* Errors we care about for dropping packets */
+#ifdef CONFIG_FTGMAC100_RXDES0_RX_ERR_CHK
 #define RXDES0_ANY_ERROR		( \
 	FTGMAC100_RXDES0_RX_ERR		| \
 	FTGMAC100_RXDES0_CRC_ERR	| \
 	FTGMAC100_RXDES0_FTL		| \
 	FTGMAC100_RXDES0_RUNT		| \
 	FTGMAC100_RXDES0_RX_ODD_NB)
+#else
+#define RXDES0_ANY_ERROR		( \
+	FTGMAC100_RXDES0_CRC_ERR	| \
+	FTGMAC100_RXDES0_FTL		| \
+	FTGMAC100_RXDES0_RUNT		| \
+	FTGMAC100_RXDES0_RX_ODD_NB)
+#endif
 
 #define FTGMAC100_RXDES1_VLANTAG_CI	0xffff
 #define FTGMAC100_RXDES1_PROT_MASK	(0x3 << 20)
-- 
2.17.1

