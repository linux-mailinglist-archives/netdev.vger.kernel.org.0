Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A905525362
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 19:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356930AbiELRTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 13:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346013AbiELRTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 13:19:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15962269EF6;
        Thu, 12 May 2022 10:19:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6mw8HxH78uY4NwRj0MoTw4jxrr0ZVpwmF8cwlRJyRXtJrWYEQLnVzxGPqjFZQwPLMOqoqevRjZCzfTBOb0Easgi86BqXVPGbONBH22UEDMXjrMMGp5WajYEp6bWN4b0tbvfUF9vMKV/8Q+40sCQKHyf431B3TADn8CcHQSjjU844PuV/75BFEjyjWdG18hJGmwRYptX494IigycexNAHY+WK93YZM8nQrMxPgIqnxqfRZz9SnBcF6X9r5a/iX+8mDxlMK0n/V1L6Uto4gSiRiLkYQ67DB0kE9XqBev+8M1FkyEsdv+t4M0bd40JJjTD46MgdRe6tcmD+e6irsKUYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTIpCzzFkH3+WvwGyQL0rWLAyo/cJ4CAU3SIJ9P1Jg4=;
 b=jpZktSsixc4pZAcG9X/872en2I97SNp7S8GgKDXu/e+U8cFK5jEKUBLmvp4H07p76uB9SsXqsQph3kdGUOZ54q0rYYJwL2JPTNk6onDceRLjhIFUtE4rhtcIJCT4qdVhGz5a4p4X7uHR7DJUYmC/hAQHwMNaqrlFQRNiEbM/52QcW4VJqGcpxxNuRg9sFXbHFRQv53vm3ATJSMChNFDllUmw1iNNEfjLmgmxVAXRxnRyCBGU4DJIoUHEb8SQIcwxRUGae6KBTuBdFlsB0pF3/KJXLE7EGkyuxyDJd20jjnV7DeWhHAHZOq0qa2TzzNiDnHSfvdcQbgJb3OjQ/4m6Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTIpCzzFkH3+WvwGyQL0rWLAyo/cJ4CAU3SIJ9P1Jg4=;
 b=OXCWpFuUobzJd+40esiPRCQ0SIlrtiacppZ/6lX1i+SgEe0XrLm9Skvzm1+PG6AGOD5O34+BJqBEiJQtElHGvCRSpaBLHz4CAnvXrH7tmN5jAn41Ed8+KiS20TOma4zuuSh6Cnwj8VlylAKpxvZTF3URKi39JFe8Z0dqRY7uU7g=
Received: from BN8PR07CA0027.namprd07.prod.outlook.com (2603:10b6:408:ac::40)
 by SJ0PR02MB7774.namprd02.prod.outlook.com (2603:10b6:a03:323::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 17:19:07 +0000
Received: from BN1NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::13) by BN8PR07CA0027.outlook.office365.com
 (2603:10b6:408:ac::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Thu, 12 May 2022 17:19:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT060.mail.protection.outlook.com (10.13.3.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 17:19:06 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 12 May 2022 10:19:03 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 12 May 2022 10:19:03 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=35344 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1npCSt-0009hD-FI; Thu, 12 May 2022 10:19:03 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2] net: macb: Increment rx bd head after allocating skb and buffer
Date:   Thu, 12 May 2022 22:49:00 +0530
Message-ID: <20220512171900.32593-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6c52e93-1357-4f00-640a-08da343b853d
X-MS-TrafficTypeDiagnostic: SJ0PR02MB7774:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR02MB777430DAC50AB0B1B06F471FC9CB9@SJ0PR02MB7774.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xEVSxJErTt8EpJ2MmZvhasFFhAE6cy7DZIazH291HnJneywRLU5EAof5yoz4yXMUv48oo2vjaOi0lwesBUgGviaaDOrrf8cBZ8SZx3RZe5XiDuJ791LWZWz9sExdP3pbMqBmVWh7+8pqb0z97GOhnZuR8tqoN3pVGp++biwEmMwkzBW4RvT5JRO7Vjbsgr2YrDQ1S2q8GqNzdIpFcKHEtRsmwUYixnq+RMg58SXKD2rBjkt//HvvgZ1THUtrUGH+ygdhpSNIy3kEoYO2UhGWfp8oQTOzUvzlL217j1Vyo/6luyvqbTwuDFh/e0V/822/mQIakRLVJMq2p+HvrMR9zrkt0S1gzbClGSGf6FDsmB6eWDjb1O6hVi7VpS0JHpUObSoEElAKbWzLNYIuFrrq+Rc0BZT+WXVzpNKQVllGpNje2o1IHtZD9FqSWyzHJevcLC6CIH6SfUwvr3NZipoZN4FSvy4sHq9hDCLa8C8qTd4IoXxt8RcwRe0VNPFiyzKY1CxpWhhjG1wohBR84cQF+OLVPLriZr5PNZ0OV5Wsgr7ygQqEJBNuTKtAn4x6gHcNQiqGoHzWr3ZcLKiHtstNeU8ZsQf0UvHEq5A3iEO7Ovjb1JMGfUtj/1LcUIZl/7S3AesyAssTDKgP99a8CkavBG+RofKHoQpXf2gWATihqsNWSssDl/FREkFgfxa/jzLUmfu8nhreASG2GMne/cMnCw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7636003)(336012)(40460700003)(426003)(82310400005)(47076005)(36756003)(316002)(83380400001)(7696005)(4326008)(8676002)(36860700001)(2906002)(186003)(107886003)(508600001)(44832011)(1076003)(9786002)(8936002)(2616005)(70586007)(70206006)(26005)(5660300002)(356005)(54906003)(110136005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 17:19:06.8048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6c52e93-1357-4f00-640a-08da343b853d
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT060.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7774
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gem_rx_refill rx_prepared_head is incremented at the beginning of
the while loop preparing the skb and data buffers. If the skb or data
buffer allocation fails, this BD will be unusable BDs until the head
loops back to the same BD (and obviously buffer allocation succeeds).
In the unlikely event that there's a string of allocation failures,
there will be an equal number of unusable BDs and an inconsistent RX
BD chain. Hence increment the head at the end of the while loop to be
clean.

Fixes: 4df95131ea80 ("net/macb: change RX path for GEM")
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
v2:
Add Fixes tag and Reviewed-by tag

 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 0b03305ad6a0..9c7d590c0188 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1215,7 +1215,6 @@ static void gem_rx_refill(struct macb_queue *queue)
 		/* Make hw descriptor updates visible to CPU */
 		rmb();
 
-		queue->rx_prepared_head++;
 		desc = macb_rx_desc(queue, entry);
 
 		if (!queue->rx_skbuff[entry]) {
@@ -1254,6 +1253,7 @@ static void gem_rx_refill(struct macb_queue *queue)
 			dma_wmb();
 			desc->addr &= ~MACB_BIT(RX_USED);
 		}
+		queue->rx_prepared_head++;
 	}
 
 	/* Make descriptor updates visible to hardware */
-- 
2.17.1

