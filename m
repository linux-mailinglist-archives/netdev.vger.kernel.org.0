Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2776B51FC8C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 14:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbiEIMYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 08:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbiEIMYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 08:24:02 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2080.outbound.protection.outlook.com [40.107.100.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74661C94D4;
        Mon,  9 May 2022 05:20:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qa4rKUobNhIL5gwMLMId117V+crZQ/vk7W3+vWkOXzgh1QnUSo2Vn4pDQUq2LWimKIHlTq2a0i4Y3cyK1EkxIP7D2p5ezMhy1I0zobAkxrZLct7iDBBbeuXlZUTD8HPQKulG2CghGIEG3gGfoqM/ZNY9/Fq4+ftxbiVTOO3zCtwwRJ3YO+Ub+yIrRSUlmqA6zgrdDAj41U0t62XTDl3fYoPQl+wJNi8kZ/pDj1rHEZovHVfXsP4beX2TOYrn8Qab8e7Lcr3Xfy/u/jozI2DP7S2FImXP1uzOR7x8VdR9olamO3KwTxTePuj2OGrG7OYjILmzIGbGhC9xT1xUOgHBrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fVKCgyi5wB9FasdB7+m9wdDstWa00VlGKS4zBlp6OQE=;
 b=Q6V8yRB9QE2kThkl0i6oirg3v60AzjQ4uc3jdHQxF6VaqIECdcUbfBFVWn33euIadZaLFt08uDZZHPE5NnxhCePa4L8kK0N3dUoZfAhu1sIkNFxJm+OgmLDFJwzmoYQlf21KolLAr8yUgEG63OMggeGdgbVe911UX3w2VeiJUTNYGUsmjNMtT79xEF2SMbxsWiHA7W8q/WACrDUxpWJHzIcY0UpNwu9VTlSpWcZJgfWIhbcxKhdnWNfLoRXdAe4aF9+k8HVn9zEGioU/zYNi3OVnfD3K/sXl4aWaArCkMeidwDKl8JEdpZUM+zPk4VcVknagtDZily6kejhG0jzToA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVKCgyi5wB9FasdB7+m9wdDstWa00VlGKS4zBlp6OQE=;
 b=qBjMmYj0szDK3FDAVmEc0scs2PcTz8JX+1MHntHB9DldLD5yLAjz/yNCDVqUxvXVFPaTNYlikLObxk9pYLHU+kiYgP/shuSVG5MAbZYUOx8KTDeApmxKYWCrUIEa+4p8GROGcDDFPLu0jWsgZ3Bafi11UZzNIPPu0dg62c9i6tk=
Received: from DM6PR12CA0019.namprd12.prod.outlook.com (2603:10b6:5:1c0::32)
 by BYAPR02MB3942.namprd02.prod.outlook.com (2603:10b6:a03::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.20; Mon, 9 May 2022 12:20:04 +0000
Received: from DM3NAM02FT060.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::b9) by DM6PR12CA0019.outlook.office365.com
 (2603:10b6:5:1c0::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23 via Frontend
 Transport; Mon, 9 May 2022 12:20:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT060.mail.protection.outlook.com (10.13.4.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5227.15 via Frontend Transport; Mon, 9 May 2022 12:20:04 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 9 May 2022 05:20:02 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Mon, 9 May 2022 05:20:02 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 dumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=58196 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1no2Ms-0006Qo-2B; Mon, 09 May 2022 05:20:02 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <dumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH] net: macb: Increment rx bd head after allocating skb and buffer
Date:   Mon, 9 May 2022 17:49:58 +0530
Message-ID: <20220509121958.3976-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9d6e490-aeba-48d8-d929-08da31b63f47
X-MS-TrafficTypeDiagnostic: BYAPR02MB3942:EE_
X-Microsoft-Antispam-PRVS: <BYAPR02MB3942AC07CD97948F72F527A9C9C69@BYAPR02MB3942.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WrTS8WU7wK8Lwe3qKWd+mGfIDS8seGQiL/IyP7OGao42aqMufq/a8wF2Ormi3dljpfoal/+WdfftYhsNrNcMAaf7TmHWvT1PsC8w8dHxQ4GFJ9YIcNfVZsn03ZJoEZ19ivm8UJWl/AS0MeQb0a1iyAW9nAaliT4NZeG5+IYTvBAbjhEBk0jrQTH/JfOAVAlWkVXlYjwMPwX05uka1TypNEx/8iMDh/vcMXKLToKXXATBUQRxEdagv8Wac2tCNS8mCwNean9N3kuno0hZLoOp5gZLEjgWfaXLjlSca73sRWYBODkPBWnoQXahF5dBOBfj9HQezUYMIHDZ8IqJDH7MjQ4N1spwdvp3K+3Q8wrwAtABlR+Z2yq7mA9sdtDRMhKFTUZ2sFkW3vU/Un9BbenRekJT7E/SWADMB9SvZ2qXRjAqPqVHtu1YusaKF4OLU6QSAxPlqZWlES2xDKI4eUTkcPp09DDxk2Lkgqx/iwGkc/OBxTl5It0q/RQYEWXzFYZ+B3vg1JaOdxRbJrpcZiiX0jFaiKBnLwHAZYa0qdjBXEGbttWbaYbb4UylprKmM0u6Rl0siva07PmqcuTUHKS48iW/LaxT0rT0BQrCzDmsAi1y0o5W7INGcMVh5LIFxl6j/EY359FFj+ZRXeC0D6zzU2Z/MbuDP2xwo4h5IxGmpFzFFjEnFlb09vZVk1qVdK1bRhxyblGbaRPfD3qh0I4jSQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8676002)(70586007)(70206006)(508600001)(4326008)(40460700003)(44832011)(83380400001)(82310400005)(7636003)(5660300002)(316002)(110136005)(54906003)(356005)(9786002)(8936002)(36860700001)(47076005)(26005)(107886003)(2616005)(186003)(426003)(7696005)(36756003)(6666004)(336012)(2906002)(1076003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 12:20:04.0891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d6e490-aeba-48d8-d929-08da31b63f47
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT060.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB3942
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

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
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

