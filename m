Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8D14EBF4
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 12:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgAaLsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 06:48:18 -0500
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:14701
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728446AbgAaLsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 06:48:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJULE1fbDDj+sLykdALDxBeWW3yZhAKXcA2MB/gIrXfOls/3BLH4GhzGEG1S2D8RcdJkCxCCSv/pMelhshDpFq0N5whzcqNmxEKyvb3gfGKVXBul8s9yXPoYouURzmpfzb4cSJNGX18Gq4sJ1rLhwxb/+sY/XXMXVjtj1sguaoSxlQMvQM6PjFTzm7O2gUIS1kyhiMXim5h7cNn4UsQgKERAtBoCbd3YuZ7xjCR6XGR7SeNym38qbRe1HhoIOIl93AQOkbSgpbRjaz62T7K+gLg5TeOpXNNEOcKfIkRxK/VIjN6Ziaibd3CEVEUwWCnRl8s634bE91rphKFisG5wqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zm1zHOufKb9+3ANaZrnrp9VGdpYdYquLI2mcr2QZY4Y=;
 b=oW7Vo0rSGm6k7fgL6cyvM+oq6fbN2KOzREqva6cAG0p3c7Mvy/PvNK6SKTGvzdOIlBYVrq8SVbkwMHAlsyMPSrz0q2n80JSRuh3QmHUFeCKmyC80YyPF7izpQMvHNGl/wd64Gf4ijUm48K2uemhIOO4k3mGAIcd9f3DiBJCntryTbLFJ0hDfDgct1lnv1f6DQgivbx7DjyJX2XYIZdNGM5f1kOsl8WmFs2uya8f0KqCezP988BHzacjxLzK6+8+UV5Sj2tQ8bjvCyX8YKCU3+jPzEMA+tTLGpzrux43X8UnQ8PpPHDYMwR7El1K5DoaLu5Kyi/g/AQAzUqgXX2UIDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zm1zHOufKb9+3ANaZrnrp9VGdpYdYquLI2mcr2QZY4Y=;
 b=YbQjNRcEva0oJFteWXclllSi1LOCQMZ2M/g3+76FAuiANQB6Wy5fEWjrR9VhOe41wGwQTFw2zFnQNGvp2HFtB8kwnCvyrw6YZfqKWQC6sQA9czPt0H2DayBuByhpUIg7io+a4H0w71Ytl+nGu240HJI7J7rcKUshyDCr2UwZxGQ=
Received: from CY4PR02CA0044.namprd02.prod.outlook.com (2603:10b6:903:117::30)
 by BY5PR02MB6641.namprd02.prod.outlook.com (2603:10b6:a03:200::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27; Fri, 31 Jan
 2020 11:48:12 +0000
Received: from SN1NAM02FT048.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::200) by CY4PR02CA0044.outlook.office365.com
 (2603:10b6:903:117::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.27 via Frontend
 Transport; Fri, 31 Jan 2020 11:48:12 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT048.mail.protection.outlook.com (10.152.72.202) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2686.25
 via Frontend Transport; Fri, 31 Jan 2020 11:48:12 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmR-0006bL-V7; Fri, 31 Jan 2020 03:48:11 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmM-0004pr-Qz; Fri, 31 Jan 2020 03:48:06 -0800
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id 00VBm50B012174;
        Fri, 31 Jan 2020 03:48:06 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1ixUmL-0004om-CT; Fri, 31 Jan 2020 03:48:05 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 8A021FF8A9; Fri, 31 Jan 2020 17:18:04 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v3 -next 1/4] net: emaclite: Fix coding style
Date:   Fri, 31 Jan 2020 17:17:47 +0530
Message-Id: <1580471270-16262-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1580471270-16262-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--2.387-7.0-31-1
X-imss-scan-details: No--2.387-7.0-31-1;No--2.387-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(428003)(249900001)(189003)(199004)(450100002)(70586007)(356004)(498600001)(26005)(336012)(70206006)(42882007)(2616005)(316002)(42186006)(6666004)(107886003)(2906002)(8936002)(6266002)(82310400001)(36756003)(5660300002)(4326008)(81156014)(8676002)(81166006)(42866002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR02MB6641;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;MX:0;A:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1623106c-9cbe-4a47-d7cd-08d7a643735c
X-MS-TrafficTypeDiagnostic: BY5PR02MB6641:
X-Microsoft-Antispam-PRVS: <BY5PR02MB6641A7C6531E8BF6C0DFA513D5070@BY5PR02MB6641.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 029976C540
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6wgRKPy/dgixv1MrlYMbumj3wFJwBIQZEvflaNHXbSZJkMRSuH3tzoQdivsP8ChnXtuXIShCR7oHZyLCPBSKw7EWQ9iQdmXyWByVitwjHDmov80CkLOeE/UHhmxCfKyRv7QTcSzXpDhC6WKRWbw9RwsyjNSpxtBlbixEIzJMdAdZ1nbecqpB1Nil35/PvrPaxF+LSjtOsg6vZJV7cM890Dz8UFLK460pBhiR7H6JQC4M3L+VUvsMFPlamngkL5sYs8X37mbXlEW/WyxQRflKM/STBYd/Z7RPulYMS0TS7J8BSYOddphQAVzndBng4Fdn0wm6qnUokrzk2BNq26cX/ZlzB/sTyDq00re9o+ciFy5Ou5OttKMGoTgdvsO6ZtfJvzHl+51zNVuaYIBgwmT18MEAkM7HMC0ftH9E0+3LJHwg+iQALt3y6J63ijaM7H94kkqdj2FavT9pBefbC7cwbZgjEd4D7kU4Ah69XW+sjCE/UooTFKln7RRhCdiw5CLg
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2020 11:48:12.3567
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1623106c-9cbe-4a47-d7cd-08d7a643735c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6641
Sender: netdev-owner@vger.kernel.org
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
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 37 ++++++++++++---------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 0c26f5b..7f98728 100644
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
 
@@ -115,7 +112,7 @@
  * @next_tx_buf_to_use:	next Tx buffer to write to
  * @next_rx_buf_to_use:	next Rx buffer to read from
  * @base_addr:		base address of the Emaclite device
- * @reset_lock:		lock used for synchronization
+ * @reset_lock:		lock to serialize xmit and tx_timeout execution
  * @deferred_skb:	holds an skb (for transmission at a later time) when the
  *			Tx buffer is not free
  * @phy_dev:		pointer to the PHY device
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
 static void xemaclite_aligned_write(void *src_ptr, u32 *dest_ptr,
-				    unsigned length)
+				    unsigned int length)
 {
 	u32 align_buffer;
 	u32 *to_u32_ptr;
@@ -264,7 +259,7 @@ static void xemaclite_aligned_write(void *src_ptr, u32 *dest_ptr,
  * to a 16-bit aligned buffer.
  */
 static void xemaclite_aligned_read(u32 *src_ptr, u8 *dest_ptr,
-				   unsigned length)
+				   unsigned int length)
 {
 	u16 *to_u16_ptr, *from_u16_ptr;
 	u32 *from_u32_ptr;
@@ -329,7 +324,6 @@ static int xemaclite_send_data(struct net_local *drvdata, u8 *data,
 	reg_data = xemaclite_readl(addr + XEL_TSR_OFFSET);
 	if ((reg_data & (XEL_TSR_XMIT_BUSY_MASK |
 	     XEL_TSR_XMIT_ACTIVE_MASK)) == 0) {
-
 		/* Switch to next buffer if configured */
 		if (drvdata->tx_ping_pong != 0)
 			drvdata->next_tx_buf_to_use ^= XEL_BUFFER_OFFSET;
@@ -345,8 +339,9 @@ static int xemaclite_send_data(struct net_local *drvdata, u8 *data,
 		if ((reg_data & (XEL_TSR_XMIT_BUSY_MASK |
 		     XEL_TSR_XMIT_ACTIVE_MASK)) != 0)
 			return -1; /* Buffers were full, return failure */
-	} else
+	} else {
 		return -1; /* Buffer was full, return failure */
+	}
 
 	/* Write the frame to the buffer */
 	xemaclite_aligned_write(data, (u32 __force *)addr, byte_count);
@@ -421,7 +416,6 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
 	 * or an IP packet or an ARP packet
 	 */
 	if (proto_type > ETH_DATA_LEN) {
-
 		if (proto_type == ETH_P_IP) {
 			length = ((ntohl(xemaclite_readl(addr +
 					XEL_HEADER_IP_LENGTH_OFFSET +
@@ -431,23 +425,25 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data, int maxlen)
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
@@ -668,8 +664,7 @@ static irqreturn_t xemaclite_interrupt(int irq, void *dev_id)
 	/* Check if the Transmission for the first buffer is completed */
 	tx_status = xemaclite_readl(base_addr + XEL_TSR_OFFSET);
 	if (((tx_status & XEL_TSR_XMIT_BUSY_MASK) == 0) &&
-		(tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
-
+	    (tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
 		tx_status &= ~XEL_TSR_XMIT_ACTIVE_MASK;
 		xemaclite_writel(tx_status, base_addr + XEL_TSR_OFFSET);
 
@@ -679,8 +674,7 @@ static irqreturn_t xemaclite_interrupt(int irq, void *dev_id)
 	/* Check if the Transmission for the second buffer is completed */
 	tx_status = xemaclite_readl(base_addr + XEL_BUFFER_OFFSET + XEL_TSR_OFFSET);
 	if (((tx_status & XEL_TSR_XMIT_BUSY_MASK) == 0) &&
-		(tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
-
+	    (tx_status & XEL_TSR_XMIT_ACTIVE_MASK) != 0) {
 		tx_status &= ~XEL_TSR_XMIT_ACTIVE_MASK;
 		xemaclite_writel(tx_status, base_addr + XEL_BUFFER_OFFSET +
 				 XEL_TSR_OFFSET);
@@ -837,6 +831,7 @@ static int xemaclite_mdio_setup(struct net_local *lp, struct device *dev)
 	of_address_to_resource(npp, 0, &res);
 	if (lp->ndev->mem_start != res.start) {
 		struct phy_device *phydev;
+
 		phydev = of_phy_find_device(lp->phy_node);
 		if (!phydev)
 			dev_info(dev,
-- 
2.7.4

