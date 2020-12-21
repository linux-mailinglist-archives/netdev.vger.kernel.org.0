Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC3F2E0131
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgLUTlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:41:25 -0500
Received: from atlmailgw2.ami.com ([63.147.10.42]:44677 "EHLO
        atlmailgw2.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgLUTlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:41:25 -0500
X-AuditID: ac10606f-231ff70000001934-53-5fe0fa3b97ea
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw2.ami.com (Symantec Messaging Gateway) with SMTP id AE.EF.06452.B3AF0EF5; Mon, 21 Dec 2020 14:40:44 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Mon, 21 Dec 2020 14:40:43 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed,ncsi-rx, v2 1/1] net: ftgmac100: Fix AST2600 EVB NCSI RX issue
Date:   Mon, 21 Dec 2020 14:40:26 -0500
Message-ID: <20201221194026.30715-2-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215192323.24359-1-hongweiz@ami.com>
References: <20201215192323.24359-1-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRiBhgq7NrwfxBr/Ps1nsusxhMed8C4vF
        7/N/mS0ubOtjtWhefY7Z4vKuOWwWxxaIWZxqecHiwOFxtX0Xu8eWlTeZPC5+PMbssWlVJ5vH
        +RkLGT0+b5ILYIvisklJzcksSy3St0vgypg/W6egT6Biz/rdjA2MJ3m7GDk5JARMJI4daWfu
        YuTiEBLYxSRx4vUhViiHUeLzuQ0sIFVsAmoSezfPYQJJiAisZpTo2fCLEcRhFuhglJj64is7
        SJWwgL/Euu+TwDpYBFQl9u68wgRi8wqYSrxZ/JYJYp+8xOoNB4D2cXBwCphJ7DklBxIWAipp
        3fcOqlxQ4uTMJ2BjmAUkJA6+eMEMUSMrcevQY6gxihIPfn1nncAoMAtJyywkLQsYmVYxCiWW
        5OQmZuaklxvpJeZm6iXn525ihAR2/g7Gjx/NDzEycTAeYpTgYFYS4TWTuh8vxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnHeV+9F4IYH0xJLU7NTUgtQimCwTB6dUA+NE76s2TWf3rrr3ffO8TQqz
        P5T9F03U9kphXT5PiOWt55ZndsnvNj1V/5EszP1tlq/ul+l3D5c/7PwaaREgOV056si5vzv1
        DtZLdRj5fD65480HJrP64j/PrJm3ZNfv+fEuvaB6vdnzhpQFntObtsrn7HfIO7ZfaO5jDZ8N
        YY7RjBpCM+5sSexXYinOSDTUYi4qTgQAMXQx8FoCAAA=
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

