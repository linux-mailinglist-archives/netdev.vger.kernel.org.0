Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1474500DBC
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243441AbiDNMkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242863AbiDNMkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:40:18 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB289024D;
        Thu, 14 Apr 2022 05:37:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZA/+i84HO4VpYmDZUEDkS5YW4xhLu2FM2C/uDIGNEov4Rxwv0IG2cvGN1K1ZPlzrjm991NuaDAPGGZX47kwOkcGfxMEOTJHkWyRC//c9Gd60GmlNjRDceKfWcUSQkjzxjstStz3Yjl9MsYAkO+I1xWhghCC4Eko85s7dYzgig41RNIAucYh0GSIxYWchu+fLn8MJeYM2kTnFcH0+PJxPFFC2vOdDskwWE3VpL27nsqpaSVCyNf0bzMN33qSmWIZABAjRnCeVsVWWVRwzRdlwwOItCLHI5YGB2bMEMOmSyEtkiV3FeORgQiVTm+xT7orNz5lehb7I2ZUMzwYGMmbsuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUzmbD21xEL2uVjUNJ5UxIA8ohCfobohDasC6OAUTSE=;
 b=ifalR+AF5iwMYfp6Dax6aDdMd3FllUa+pArIVwOFcUBqnAe3MUnF1MPbnEDBv2tl8DsVjWdit0RWKw+vwAuLpNHbbi3JHnFlUnooxLYel4B5q4b35WSrQf1NJm7nbd24UEpyZkddzV8uuW8y9y0lvXyxt9AM9SInfktsQM5/d+s0WvbqJs3mlkKWaIuVTBU/UunZPgB4uFrWsT0Rn2BJE2+c3co6vss8Ak5K0TDaOD+lG1Dli/stZiTjvWHNTlZYVOu2PY7UMd33nhfwfWpxT2hpoJr7KPHtkOku2szIqwj1EwHepsjreOYlG8gSPB9jTCDQ09GCmAMeRF9eel2wXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUzmbD21xEL2uVjUNJ5UxIA8ohCfobohDasC6OAUTSE=;
 b=sY0Q7qybvdQ2c22Rjp1V9GNXTr8ryDCf24KLYh34o74UzRH6SjoDzdbhdke/MWW8dtFRGSYf+6BnoT2+nDcsv293U8dh5CJK7u6bGBH6hgkC2IvkMFuKCi5p9LEfQHU8E2h2fn1zatVigbnB21KN2jurFzELP5FS/vZCm4PIO+U=
Received: from BN6PR19CA0093.namprd19.prod.outlook.com (2603:10b6:404:133::31)
 by BN7PR02MB5073.namprd02.prod.outlook.com (2603:10b6:408:2f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 12:37:52 +0000
Received: from BN1NAM02FT058.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::e0) by BN6PR19CA0093.outlook.office365.com
 (2603:10b6:404:133::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Thu, 14 Apr 2022 12:37:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT058.mail.protection.outlook.com (10.13.2.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 12:37:51 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 14 Apr 2022 05:37:33 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 14 Apr 2022 05:37:33 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=53839 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1neyj7-0008bG-14; Thu, 14 Apr 2022 05:37:33 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id EB614600D1; Thu, 14 Apr 2022 18:07:18 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andrew@lunn.ch>
CC:     <michal.simek@xilinx.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 1/3] net: emaclite: Fix coding style
Date:   Thu, 14 Apr 2022 18:07:09 +0530
Message-ID: <1649939831-14901-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf8cb35b-4605-4fe0-c351-08da1e139733
X-MS-TrafficTypeDiagnostic: BN7PR02MB5073:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB50732F2C141655669E7DDCFDC7EF9@BN7PR02MB5073.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmQpAItluiaxwaTCU02f7mYOk/xjfR7P7rm91N+wO5/CgMMZNtGLTp7m/XpSTOq9fZBDWyyPUZ4QGiMIw1RCt9g69Vm4AOAU3NRLNZv8lYBHOnl+tsB3vfoH1rR7aByq1mNY+xyEIlywdyBHlihtDcQWmodn2r3SfouzvZdEmTjd8tmlXSYgsdI/OxC6iiHEznsNJejYasveF5+zRIjgQHLsvioAhV34V3lE0f1xPXrb0rXQ5GrEwLVax7rst5JOxMhkBlzVOVqxvyYwPWeC7wN5NsvSKfMH+8yUdNspkJDie+WGhcX80V7exq6mm42TFQNUUjtPuwpkdGJVNWho9NrOlOrMbnCDKwQzExEaY4NUUs/5/O4dZSyXpN1sHm81OnuQL8ueq9LXNyxt74BTQKGVjT/2OESScG79TR0zSjpbO0RI2V4Nw5RiuFogb+bP1HSKKS7/ApIOi5df7Q3hoga97Z6fWPE2SWHkjSDMOqw61I3zH8qvXXdI3llqQnQLDhyq8mjiUUmgAilyaY8vS9vuIBAf8QUqjJNlp2sC6MzN/ddyVgeet5yesmXuDPAcJ9rusCjD3iu6K3pi8uL2W6UsDaDMMGMx05jlJmycEd3zBsXEQXIaJ7KfcOEHzcI5zbNoaONbskZdlPSmkuar8UP2GNY2ewIK5qf4eIVir7bK9FWmWiyodN9Ld6d0oCenzk+jrU0kv/6FdiE+RAagFQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(2616005)(8676002)(8936002)(107886003)(4326008)(426003)(70206006)(47076005)(26005)(5660300002)(336012)(186003)(82310400005)(40460700003)(2906002)(36756003)(36860700001)(508600001)(83380400001)(110136005)(54906003)(42186006)(6266002)(356005)(6666004)(7636003)(316002)(70586007)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 12:37:51.4904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8cb35b-4605-4fe0-c351-08da1e139733
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT058.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5073
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make coding style changes to fix checkpatch script warnings.
There is no functional change. Fixes below check and warnings-

CHECK: Blank lines aren't necessary after an open brace '{'
CHECK: spinlock_t definition without comment
CHECK: Please don't use multiple blank lines
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
CHECK: braces {} should be used on all arms of this statement
CHECK: Unbalanced braces around else statement
CHECK: Alignment should match open parenthesis
WARNING: Missing a blank line after declarations

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 35 ++++++++++++---------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 57a24f62e353..6294b714fbfa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Xilinx EmacLite Linux driver for the Xilinx Ethernet MAC Lite device.
+/* Xilinx EmacLite Linux driver for the Xilinx Ethernet MAC Lite device.
  *
  * This is a new flat driver which is based on the original emac_lite
  * driver from John Williams <john.williams@xilinx.com>.
@@ -91,8 +90,6 @@
 #define XEL_ARP_PACKET_SIZE		28	/* Max ARP packet size */
 #define XEL_HEADER_IP_LENGTH_OFFSET	16	/* IP Length Offset */
 
-
-
 #define TX_TIMEOUT		(60 * HZ)	/* Tx timeout is 60 seconds. */
 #define ALIGNMENT		4
 
@@ -124,7 +121,6 @@
  * @last_link:		last link status
  */
 struct net_local {
-
 	struct net_device *ndev;
 
 	bool tx_ping_pong;
@@ -133,7 +129,7 @@ struct net_local {
 	u32 next_rx_buf_to_use;
 	void __iomem *base_addr;
 
-	spinlock_t reset_lock;
+	spinlock_t reset_lock; /* serialize xmit and tx_timeout execution */
 	struct sk_buff *deferred_skb;
 
 	struct phy_device *phy_dev;
@@ -144,7 +140,6 @@ struct net_local {
 	int last_link;
 };
 
-
 /*************************/
 /* EmacLite driver calls */
 /*************************/
@@ -207,7 +202,7 @@ static void xemaclite_disable_interrupts(struct net_local *drvdata)
  * address in the EmacLite device.
  */
 static void xemaclite_aligned_write(const void *src_ptr, u32 *dest_ptr,
-				    unsigned length)
+				    unsigned int length)
 {
 	const u16 *from_u16_ptr;
 	u32 align_buffer;
@@ -265,7 +260,7 @@ static void xemaclite_aligned_write(const void *src_ptr, u32 *dest_ptr,
  * to a 16-bit aligned buffer.
  */
 static void xemaclite_aligned_read(u32 *src_ptr, u8 *dest_ptr,
-				   unsigned length)
+				   unsigned int length)
 {
 	u16 *to_u16_ptr, *from_u16_ptr;
 	u32 *from_u32_ptr;
@@ -330,7 +325,6 @@ static int xemaclite_send_data(struct net_local *drvdata, u8 *data,
 	reg_data = xemaclite_readl(addr + XEL_TSR_OFFSET);
 	if ((reg_data & (XEL_TSR_XMIT_BUSY_MASK |
 	     XEL_TSR_XMIT_ACTIVE_MASK)) == 0) {
-
 		/* Switch to next buffer if configured */
 		if (drvdata->tx_ping_pong != 0)
 			drvdata->next_tx_buf_to_use ^= XEL_BUFFER_OFFSET;
@@ -346,8 +340,9 @@ static int xemaclite_send_data(struct net_local *drvdata, u8 *data,
 		if ((reg_data & (XEL_TSR_XMIT_BUSY_MASK |
 		     XEL_TSR_XMIT_ACTIVE_MASK)) != 0)
 			return -1; /* Buffers were full, return failure */
-	} else
+	} else {
 		return -1; /* Buffer was full, return failure */
+	}
 
 	/* Write the frame to the buffer */
 	xemaclite_aligned_write(data, (u32 __force *)addr, byte_count);
@@ -423,7 +418,6 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
 	 * or an IP packet or an ARP packet
 	 */
 	if (proto_type > ETH_DATA_LEN) {
-
 		if (proto_type == ETH_P_IP) {
 			length = ((ntohl(xemaclite_readl(addr +
 					XEL_HEADER_IP_LENGTH_OFFSET +
@@ -433,23 +427,25 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
 			length = min_t(u16, length, ETH_DATA_LEN);
 			length += ETH_HLEN + ETH_FCS_LEN;
 
-		} else if (proto_type == ETH_P_ARP)
+		} else if (proto_type == ETH_P_ARP) {
 			length = XEL_ARP_PACKET_SIZE + ETH_HLEN + ETH_FCS_LEN;
-		else
+		} else {
 			/* Field contains type other than IP or ARP, use max
 			 * frame size and let user parse it
 			 */
 			length = ETH_FRAME_LEN + ETH_FCS_LEN;
-	} else
+		}
+	} else {
 		/* Use the length in the frame, plus the header and trailer */
 		length = proto_type + ETH_HLEN + ETH_FCS_LEN;
+	}
 
 	if (WARN_ON(length > maxlen))
 		length = maxlen;
 
 	/* Read from the EmacLite device */
 	xemaclite_aligned_read((u32 __force *)(addr + XEL_RXBUFF_OFFSET),
-				data, length);
+			       data, length);
 
 	/* Acknowledge the frame */
 	reg_data = xemaclite_readl(addr + XEL_RSR_OFFSET);
@@ -671,8 +667,7 @@ static irqreturn_t xemaclite_interrupt(int irq, void *dev_id)
 	/* Check if the Transmission for the first buffer is completed */
 	tx_status = xemaclite_readl(base_addr + XEL_TSR_OFFSET);
 	if (((tx_status & XEL_TSR_XMIT_BUSY_MASK) == 0) &&
-		(tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
-
+	    (tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
 		tx_status &= ~XEL_TSR_XMIT_ACTIVE_MASK;
 		xemaclite_writel(tx_status, base_addr + XEL_TSR_OFFSET);
 
@@ -682,8 +677,7 @@ static irqreturn_t xemaclite_interrupt(int irq, void *dev_id)
 	/* Check if the Transmission for the second buffer is completed */
 	tx_status = xemaclite_readl(base_addr + XEL_BUFFER_OFFSET + XEL_TSR_OFFSET);
 	if (((tx_status & XEL_TSR_XMIT_BUSY_MASK) == 0) &&
-		(tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
-
+	    (tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
 		tx_status &= ~XEL_TSR_XMIT_ACTIVE_MASK;
 		xemaclite_writel(tx_status, base_addr + XEL_BUFFER_OFFSET +
 				 XEL_TSR_OFFSET);
@@ -840,6 +834,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	of_address_to_resource(npp, 0, &res);
 	if (lp->ndev->mem_start != res.start) {
 		struct phy_device *phydev;
+
 		phydev = of_phy_find_device(lp->phy_node);
 		if (!phydev)
 			dev_info(dev,
-- 
2.7.4

