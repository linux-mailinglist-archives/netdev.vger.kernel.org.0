Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5400C3398A4
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 21:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhCLUr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 15:47:26 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:35262 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235069AbhCLUrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 15:47:04 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 45D0320D2E6A
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH net-next 4/4] sh_eth: place RX/TX descriptor *enum*s after
 their *struct*s
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
References: <41a26045-c70e-32d7-b13e-8a8bd0834fcc@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <4ba4d265-0714-ea16-1dbe-7a500a23d5bc@omprussia.ru>
Date:   Fri, 12 Mar 2021 23:47:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <41a26045-c70e-32d7-b13e-8a8bd0834fcc@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Place the RX/TX descriptor bit *enum*s where they belong -- after the
corresponding RX/TX descriptor *struct*s and, while at it, switch to
declaring one *enum* entry per line...

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/net/ethernet/renesas/sh_eth.h |   82 +++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 36 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.h
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.h
+++ net-next/drivers/net/ethernet/renesas/sh_eth.h
@@ -288,27 +288,6 @@ enum EESIPR_BIT {
 	EESIPR_CERFIP	= 0x00000001,
 };
 
-/* Receive descriptor 0 bits */
-enum RD_STS_BIT {
-	RD_RACT = 0x80000000, RD_RDLE = 0x40000000,
-	RD_RFP1 = 0x20000000, RD_RFP0 = 0x10000000,
-	RD_RFE = 0x08000000, RD_RFS10 = 0x00000200,
-	RD_RFS9 = 0x00000100, RD_RFS8 = 0x00000080,
-	RD_RFS7 = 0x00000040, RD_RFS6 = 0x00000020,
-	RD_RFS5 = 0x00000010, RD_RFS4 = 0x00000008,
-	RD_RFS3 = 0x00000004, RD_RFS2 = 0x00000002,
-	RD_RFS1 = 0x00000001,
-};
-#define RDF1ST	RD_RFP1
-#define RDFEND	RD_RFP0
-#define RD_RFP	(RD_RFP1|RD_RFP0)
-
-/* Receive descriptor 1 bits */
-enum RD_LEN_BIT {
-	RD_RFL	= 0x0000ffff,	/* receive frame  length */
-	RD_RBL	= 0xffff0000,	/* receive buffer length */
-};
-
 /* FCFTR */
 enum FCFTR_BIT {
 	FCFTR_RFF2 = 0x00040000, FCFTR_RFF1 = 0x00020000,
@@ -318,21 +297,6 @@ enum FCFTR_BIT {
 #define DEFAULT_FIFO_F_D_RFF	(FCFTR_RFF2 | FCFTR_RFF1 | FCFTR_RFF0)
 #define DEFAULT_FIFO_F_D_RFD	(FCFTR_RFD2 | FCFTR_RFD1 | FCFTR_RFD0)
 
-/* Transmit descriptor 0 bits */
-enum TD_STS_BIT {
-	TD_TACT = 0x80000000, TD_TDLE = 0x40000000,
-	TD_TFP1 = 0x20000000, TD_TFP0 = 0x10000000,
-	TD_TFE  = 0x08000000, TD_TWBI = 0x04000000,
-};
-#define TDF1ST	TD_TFP1
-#define TDFEND	TD_TFP0
-#define TD_TFP	(TD_TFP1|TD_TFP0)
-
-/* Transmit descriptor 1 bits */
-enum TD_LEN_BIT {
-	TD_TBL	= 0xffff0000,	/* transmit buffer length */
-};
-
 /* RMCR */
 enum RMCR_BIT {
 	RMCR_RNC = 0x00000001,
@@ -451,6 +415,24 @@ struct sh_eth_txdesc {
 	u32 pad0;		/* padding data */
 } __aligned(2) __packed;
 
+/* Transmit descriptor 0 bits */
+enum TD_STS_BIT {
+	TD_TACT	= 0x80000000,
+	TD_TDLE	= 0x40000000,
+	TD_TFP1	= 0x20000000,
+	TD_TFP0	= 0x10000000,
+	TD_TFE	= 0x08000000,
+	TD_TWBI	= 0x04000000,
+};
+#define TDF1ST	TD_TFP1
+#define TDFEND	TD_TFP0
+#define TD_TFP	(TD_TFP1 | TD_TFP0)
+
+/* Transmit descriptor 1 bits */
+enum TD_LEN_BIT {
+	TD_TBL	= 0xffff0000,	/* transmit buffer length */
+};
+
 /* The sh ether Rx buffer descriptors.
  * This structure should be 20 bytes.
  */
@@ -461,6 +443,34 @@ struct sh_eth_rxdesc {
 	u32 pad0;		/* padding data */
 } __aligned(2) __packed;
 
+/* Receive descriptor 0 bits */
+enum RD_STS_BIT {
+	RD_RACT	= 0x80000000,
+	RD_RDLE	= 0x40000000,
+	RD_RFP1	= 0x20000000,
+	RD_RFP0	= 0x10000000,
+	RD_RFE	= 0x08000000,
+	RD_RFS10 = 0x00000200,
+	RD_RFS9	= 0x00000100,
+	RD_RFS8	= 0x00000080,
+	RD_RFS7	= 0x00000040,
+	RD_RFS6	= 0x00000020,
+	RD_RFS5	= 0x00000010,
+	RD_RFS4	= 0x00000008,
+	RD_RFS3	= 0x00000004,
+	RD_RFS2	= 0x00000002,
+	RD_RFS1	= 0x00000001,
+};
+#define RDF1ST	RD_RFP1
+#define RDFEND	RD_RFP0
+#define RD_RFP	(RD_RFP1 | RD_RFP0)
+
+/* Receive descriptor 1 bits */
+enum RD_LEN_BIT {
+	RD_RFL	= 0x0000ffff,	/* receive frame  length */
+	RD_RBL	= 0xffff0000,	/* receive buffer length */
+};
+
 /* This structure is used by each CPU dependency handling. */
 struct sh_eth_cpu_data {
 	/* mandatory functions */
