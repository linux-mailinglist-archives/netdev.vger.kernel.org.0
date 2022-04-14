Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E852500DBF
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242878AbiDNMlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233352AbiDNMlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:41:10 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EB19027D;
        Thu, 14 Apr 2022 05:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVCgdsjCuAsd20+Y44d0vR3fPsyHgb3nCxbFK+qoRpiPNqLsVVMcK+EOFQEaYHgTIxC+SpbEezR7sU5GcAzA5qLuc8uCW+Zi19I2wWZ3IVfX+rgwp+dV+poZVrPqtEh4PTWMqIcBOokgiKv0NjPPo3cU9RTRhjo0p0lQzcQ/zpcSrKHGV8uX0kouZUgb8EPNcB31DwxBJ/i3RYsTKUlFHNuqhla3a0k2wGXccE0dRLN6LrNG5us4PWTK5gtHteh9Ynmxjrkb0KTHzoGflkZzyWjK1ov6JKxtOxUXKdJbVm7Dw93drwLOlIBl9ySG3gXyWwztLJiJGsi09dZbaKT5TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERScTANQNWWzuRaQXEXf9XcN7vExEMh0K9W4dzjHkmA=;
 b=MDizmhRcB9z5a05sxm7pZgkXula7lQZJ8+fls6er+WToS2Yig4ANDCRMAB8tNmFfmp0itjPG02fxUdSFk4Yp53EDSVXlOUtiE9PsTB/GH038rVpYbeaObplMrhaMHPNiHY+kZD/zDd/S+zMoDZmumB2bB29WOJyzsD6QIwrdh8hCEqLCokGFn/3hOOoMnovE5WD1Cu5jnuXsABZhYBAt7TEbU+5yWI2BV5O7JGi252f5h4smeNj16U6CsxEZyNneJwQkQ6kkaWQnwYrNDnyg3eZ322bw9a7ORU/+OJudW06ZZrhaHMPwcDSksk77vHVjCOSx1Fw1/u8QulePNXHoEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERScTANQNWWzuRaQXEXf9XcN7vExEMh0K9W4dzjHkmA=;
 b=s4GeB4IxnPvqwCy0W7mymEsJ/ZzLiW48smUPaYqYWrmS497602JgtDIAzTK/bQLJd/la4NbNBO9sKWS/WmiNOIFrs/d+2eGN/RPGfIcdtaQu8/rDYLwKW77/uBQhIo1iu3t8BqO2wGgom48cQEMij8el7Pj9aMWzbHcD/Jnsk90=
Received: from BN9PR03CA0543.namprd03.prod.outlook.com (2603:10b6:408:138::8)
 by MWHPR0201MB3596.namprd02.prod.outlook.com (2603:10b6:301:79::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 12:38:42 +0000
Received: from BN1NAM02FT013.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::c0) by BN9PR03CA0543.outlook.office365.com
 (2603:10b6:408:138::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Thu, 14 Apr 2022 12:38:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT013.mail.protection.outlook.com (10.13.2.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 12:38:41 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 14 Apr 2022 05:37:59 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 14 Apr 2022 05:37:59 -0700
Envelope-to: git@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 andrew@lunn.ch,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.6] (port=53841 helo=xhdvnc106.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1neyjX-0006t9-CM; Thu, 14 Apr 2022 05:37:59 -0700
Received: by xhdvnc106.xilinx.com (Postfix, from userid 13245)
        id 05E7661070; Thu, 14 Apr 2022 18:07:19 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <andrew@lunn.ch>
CC:     <michal.simek@xilinx.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Shravya Kumbham <shravya.kumbham@xilinx.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 3/3] net: emaclite: Remove custom BUFFER_ALIGN macro
Date:   Thu, 14 Apr 2022 18:07:11 +0530
Message-ID: <1649939831-14901-4-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
References: <1649939831-14901-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a08b520-d528-4439-9122-08da1e13b502
X-MS-TrafficTypeDiagnostic: MWHPR0201MB3596:EE_
X-Microsoft-Antispam-PRVS: <MWHPR0201MB3596934057498E9BFE2FEAD8C7EF9@MWHPR0201MB3596.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJqx79BPMXIHxuiLb+cwBLiVDzctVjNLhtORUXMSX+hAJKWo2oGqpsAxu3RjZn10LaJ6GNEE1nwJLNzujukFlc1bYP6aNOZNUeBsE+lQdHWWMYnYwJBqrTjxV/scBJXA5DD4Ok5WCaJjIGTCvv6Y0VbRy5qkdyy4b901wAEA0CBirB18a8yRHOclrTaBcvJlOHDK/4pKkqRUSaDRsDzg8ZGtlv+5Puk50UxPWUtvKUwEXxyGUJjv2sb35ECR048Vz0gKku+0/BK1e+Txkdc9fgb+CULDfkExVHEId2Rngyr5HHLWfDc9PO/8EEiCtdGN1oGFdTPdM1PA10inUnhWZhcItDHFjckjIDXjuld5mjXwbVq4S9s3cdgrM83PeyTfTHsh+l1ZHI0rsWdvwwXu5tRzNlm6nOBS0yS1qdOc8At6wwonvjpRPhetuvbnKQ2OP7xWPpnfV+8/rqbbOvOCawAounecXzCa59bGE85MMGBsAkqX7HBV8S1NqWRLjhqQCzsxk/kNHnsQF3FsJTJuvydrMAbI13SwrRRxmUkeOBztSVhXJrqAnnwGepXh3IKnDQaoQJjRxfjWQ9UOchO2HvF6pazu9uGudg27DI07YDwOszP0fBCbXoEgM+AU7kPGWh0IFXpFBUSWFkyn7DCuu32stiFuVPn1nh+UUF6LOY3W9oirhdKKJGosavr1YHRXCvYAbghkUD0VCZSVl4A2Gg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(47076005)(82310400005)(70586007)(508600001)(6666004)(83380400001)(426003)(336012)(42186006)(7636003)(36756003)(316002)(36860700001)(356005)(110136005)(8936002)(54906003)(70206006)(5660300002)(2906002)(186003)(40460700003)(2616005)(8676002)(26005)(107886003)(4326008)(6266002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 12:38:41.4996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a08b520-d528-4439-9122-08da1e13b502
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT013.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0201MB3596
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shravya Kumbham <shravya.kumbham@xilinx.com>

BUFFER_ALIGN macro is used to calculate the number of bytes
required for the next alignment. Instead of this, we can directly
use the skb_reserve(skb, NET_IP_ALIGN) to make the protocol header
buffer aligned on at least a 4-byte boundary, where the NET_IP_ALIGN
is by default defined as 2. So removing the BUFFER_ALIGN and its
related defines which it can be done by the skb_reserve() itself.

Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index bb9c3ebde522..7a86ae82fcc1 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -91,10 +91,6 @@
 #define XEL_HEADER_IP_LENGTH_OFFSET	16	/* IP Length Offset */
 
 #define TX_TIMEOUT		(60 * HZ)	/* Tx timeout is 60 seconds. */
-#define ALIGNMENT		4
-
-/* BUFFER_ALIGN(adr) calculates the number of bytes to the next alignment. */
-#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((uintptr_t)adr)) % ALIGNMENT)
 
 #ifdef __BIG_ENDIAN
 #define xemaclite_readl		ioread32be
@@ -595,11 +591,10 @@ static void xemaclite_rx_handler(struct net_device *dev)
 {
 	struct net_local *lp = netdev_priv(dev);
 	struct sk_buff *skb;
-	unsigned int align;
 	u32 len;
 
 	len = ETH_FRAME_LEN + ETH_FCS_LEN;
-	skb = netdev_alloc_skb(dev, len + ALIGNMENT);
+	skb = netdev_alloc_skb(dev, len + NET_IP_ALIGN);
 	if (!skb) {
 		/* Couldn't get memory. */
 		dev->stats.rx_dropped++;
@@ -607,16 +602,7 @@ static void xemaclite_rx_handler(struct net_device *dev)
 		return;
 	}
 
-	/* A new skb should have the data halfword aligned, but this code is
-	 * here just in case that isn't true. Calculate how many
-	 * bytes we should reserve to get the data to start on a word
-	 * boundary
-	 */
-	align = BUFFER_ALIGN(skb->data);
-	if (align)
-		skb_reserve(skb, align);
-
-	skb_reserve(skb, 2);
+	skb_reserve(skb, NET_IP_ALIGN);
 
 	len = xemaclite_recv_data(lp, (u8 *)skb->data, len);
 
-- 
2.7.4

