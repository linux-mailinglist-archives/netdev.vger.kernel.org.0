Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667BF1277A9
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbfLTI5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:57:30 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:16768
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbfLTI5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:57:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUHwC1ecoasqsQKF8qNMIzm4k03fHZJtwTFQFj/ue4U7C1roaiRNAs54pbpbJ7Csi0OD3pK+nuaT08ztCELHJkoKn1+Xrgde32rCt+Ko1+X0C5cE83qkQwGdOX3VpCmHXR4umZc9bnlhcyoeFNVG14hxKrLliw6s2BW86bOHg+Pm1wyQP3ghfNEl7nJoOizp+B/gqdPiVnTqWACJaUUZX/71fyNcK1EO3LC8c+YGrRs5DhlHamXota61XYpMlK4yiAPAEu/rpXRmLKVKayhnG8mTLGlJYDeLBGoMcCkMaV+hRCZQMLcBDfIMSPHBlHDx3r1zs5Dq1d7IbpMZQSrnFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMPatnnUQXHgD41Ks+lYOhCFaua62ymlbssx9Frc+i0=;
 b=f4HzX0S3wpHBv80CZb1TFrczXlrl/5eWEIPGFsD2P9DeK/yjQbv22wiQp5XiukQsfKOaLRgq+LXR7z7eQD1Tv0lHhRgruoilg/jOVYJf9XQTptfRag/2m+6UPPZ0qWGjUS7omSGLIUDinjIJAlK8R6np1mxjpfy2PkuzvVIXPrrPBcfrarQbF/xjOREPKcfaQ2KmjOdwiY+7dWSgZRVZD1SkHRqBc8OcdAlbtATguTt7Ib6lBkO4ds1oHL1r0f2/0MKn5+KKU0fpqNkgjb2SJS+1vyPssZpboNdpm87KJzYAg9e7V5MbxB/vTrtzOZGlNXDD1vtb0ccCSb+reG6dxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMPatnnUQXHgD41Ks+lYOhCFaua62ymlbssx9Frc+i0=;
 b=OUInLjhcz0qNyBEghGDoNwbywu9vreTkJZRf+nRNrQmebssc0qJBLUGVrg3GBRHixBHIeGzQV/y4qegUR7MzBLiWERJhd44sIpscYk80B4jd4gtWC3/vrRKbCYOE+q1Du5FqizVGhKNppfjRfZ5/m8BpWKoCgAG/KSgAQPCcpMU=
Received: from CH2PR02CA0015.namprd02.prod.outlook.com (2603:10b6:610:4e::25)
 by BN6PR02MB2882.namprd02.prod.outlook.com (2603:10b6:404:ff::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14; Fri, 20 Dec
 2019 08:57:17 +0000
Received: from SN1NAM02FT009.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::207) by CH2PR02CA0015.outlook.office365.com
 (2603:10b6:610:4e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.18 via Frontend
 Transport; Fri, 20 Dec 2019 08:57:17 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT009.mail.protection.outlook.com (10.152.73.32) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2559.14
 via Frontend Transport; Fri, 20 Dec 2019 08:57:16 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5y-0003Dl-Uk; Fri, 20 Dec 2019 00:57:14 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5s-000105-7P; Fri, 20 Dec 2019 00:57:08 -0800
Received: from xsj-pvapsmtp01 (smtp-fallback.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xBK8v79K029827;
        Fri, 20 Dec 2019 00:57:07 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5q-0000zh-R5; Fri, 20 Dec 2019 00:57:07 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 0EB72103F2B; Fri, 20 Dec 2019 14:27:06 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next v2 1/3] net: emaclite: Fix coding style
Date:   Fri, 20 Dec 2019 14:26:58 +0530
Message-Id: <1576832220-9631-2-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576832220-9631-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1576832220-9631-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--2.931-7.0-31-1
X-imss-scan-details: No--2.931-7.0-31-1;No--2.931-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(428003)(249900001)(199004)(189003)(70586007)(70206006)(26005)(42882007)(4326008)(336012)(498600001)(316002)(8936002)(450100002)(36756003)(5660300002)(6666004)(356004)(107886003)(8676002)(2906002)(6266002)(6636002)(42186006)(81166006)(81156014)(2616005)(42866002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR02MB2882;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09b2bb79-24fc-408a-9420-08d7852a9d5f
X-MS-TrafficTypeDiagnostic: BN6PR02MB2882:
X-Microsoft-Antispam-PRVS: <BN6PR02MB28827654F83DCAFCBDBC895AD52D0@BN6PR02MB2882.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 025796F161
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oa8lmDdShs18QfJqJYHOuCEDl7xB6P1Mq/ZGg9TUjHDnP6CJp6jdeBa67b+LIEcVzjM9BOIeE0Q1iiswWgUB37YPIQ+2ZdwLMU5z7O9d3e0H6NtzITsJ9NGlRjshT0ZVplmYRn2qetWJ4g4M3QDdG3bgqOVZ/vCaAVuso1BPIR2EDlDv0DYHEHuMYSHCne2yu86qJlxHsNC6UWuDGta1mc4ntLyje2g8Ny3j+0Oy+oFeiabjmqK/9pXyNy4CKm4/1sDGHbLRoyO/9oiP7+OM2A/ylcRJFX7Q1fojkUV9nYmmYMLPAUq5+PZgeg1XuivWvOvKf6IIjh6QMaI+kOrdfNCceY6kYcUD6G1GcrIXrhxWUIqi45lu5470jP+Ymdt5+hw+PLZcAo6PVVJ8naOCW6MTAolBwYNjpST2TN9vvb4T0rTmSuqlhKCxMK0l+fxOcVjQofDGdaf/mT2dwd3YAByUakFZE9uXizLp/DMOdPH5QK2RWUEZK5dJqqQiUeN2
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2019 08:57:16.9800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b2bb79-24fc-408a-9420-08d7852a9d5f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR02MB2882
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
Changes for v2:
Modified description of reset_lock spinlock variable.
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

