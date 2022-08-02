Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A286E587AEC
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiHBKoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbiHBKoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:44:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E1033E0E;
        Tue,  2 Aug 2022 03:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wk1Mdb7e/SFCb3In5/pkArlKKeYnHZoreqfoe5MFVJCZiK6irWlZ9jf98fX2EVU++p5+JapQ+1N9FeHru2B9zDXjgOhnQ9yRhg4Wlm6nQLivkrmWJ6IuGzdoH+IJDgiPjzKn3e55fScPc3qUxBXS4W4KlM776my8UFWAcVASNGapVkBZxozaTHbRrzlGn1s6byU7gm6x7gNiavl+GFqzj/3NYfyuzX9jYVatf6eB9fm3W8eSpkfVokBXl2Kokz20+wqIQk5WwTwRVs9k7U0IRecX0H2FI5T7ENkimS8yQKxtS32GTEInz/AJYx2nT0wlD+h+HQv7R8MEHf+IyPTm/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9FdontukN0J4TOgpBudQpdOfZxYbxed4gMls+R7ytg=;
 b=fymfGjp/Io4kXG4zURqYQF6oQra+mjgASBHSS3++9yEaAgd1kJXXR9TcBD8OKnJL8x+c/AA8Q6DzmLqT2oSVDbMR7/Q1FohaKGl/jBb2PuVcluc4KaApvfJ7fizevlkOg9XXKrhoehpis43cX6ouUuWUispOhrhnEoofvTil67aNzaRnZJkvYHvvCo7MDlnXy1PtzJECAUs4npe/b+9YRfC7/7pmRwQ5TpkVyq4UYx4tJWKnOIXrIgj9UBZBqnbY9XU1ni8w21Pj0y3WpCPThRTfYFoOk2/TYr4luAP0SVjLYjlTdWA1kh18nU08S3HzO4eZzPu44BQzLm5YKlHKVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9FdontukN0J4TOgpBudQpdOfZxYbxed4gMls+R7ytg=;
 b=gdQ8wcok1UT7CEwq6/IbfbZnhtV9CGGjrjGqsW1RDdSEH3KGJvsZWMBmPeALPUggOFi/l5vKoyRpZ+Npuae2ZNSziQTFZBC2EiDEOKoZ8uUwVFRraA8DAKnNhRHTYXZAEqI8XlJIlezxIVFRf8tkJvncQ5TVzn1fjLM1zbmJ2Ew=
Received: from DM6PR06CA0068.namprd06.prod.outlook.com (2603:10b6:5:54::45) by
 BN0PR02MB7950.namprd02.prod.outlook.com (2603:10b6:408:168::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 2 Aug
 2022 10:44:00 +0000
Received: from DM3NAM02FT009.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::1b) by DM6PR06CA0068.outlook.office365.com
 (2603:10b6:5:54::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15 via Frontend
 Transport; Tue, 2 Aug 2022 10:44:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT009.mail.protection.outlook.com (10.13.5.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Tue, 2 Aug 2022 10:44:00 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 2 Aug 2022 03:43:59 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 2 Aug 2022 03:43:59 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 andrei.pistirica@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 michal.simek@amd.com,
 harini.katakam@amd.com,
 radhey.shyam.pandey@amd.com
Received: from [10.140.6.13] (port=38092 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oIpNX-0004qa-EZ; Tue, 02 Aug 2022 03:43:59 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [PATCH 2/2] net: macb: Optimize reading HW timestamp
Date:   Tue, 2 Aug 2022 16:13:46 +0530
Message-ID: <20220802104346.29335-3-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220802104346.29335-1-harini.katakam@xilinx.com>
References: <20220802104346.29335-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 359fe3e9-7815-46c1-eb0a-08da7473e907
X-MS-TrafficTypeDiagnostic: BN0PR02MB7950:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pqpKJLG4u6Jm5OQ8l/uAO8VHMJOKeujl2zqaQYbfTMsnEGtaQM1E4fpSM0kL4gkb57yEgONN90A1yy+VUKtK1p4rWRxf4dtJms7QlDrZrgajDrdvvworoZvO2et+KMzvelq2kvdiXXPGKfvN9rYZL2VwxAQPawJVFJyyqazA6HBM7eiYWaEf8vlQMPBPS1WmzPyLGwCa7Lg1U+k+LMUTWWdaRBjfbRSnXpfd4zEobIh9mg4Hu3pA6J+qJ8iABudEee2MbtjAwqEBNx16XVL+A+DprikTE7uw/lGhIHYDDY6EHTSC7Rlt+/Lu514g0jHG/3od0QIoSE91uhadlRsIDACvndjAFD5pjUh1e+XcRu9jY5nvWO0JvGm3Tb8jKNBj0sLOyPFIf4mwAp4WUOBr3qpFWRcf/Kw0bix9rwDP3H93JqGZ/0FeX2WIbTKryREl7lyJFT6N3SIwx8VNc3jEwZUWwN5XxtZwi+k1F+DhkeQUkJU97tRUSs49Cu4hrqvC+jhG/1aKv6PiKAoSnLCyJQqRZR5yaA3whQE9Zb+/j5fdkE7FcNzwZSZJbVXNKdUR/0WV/7+/gEF7/MVnqK/kljsvJe9gG9HUwxgyRTxt2nwxvGMVa4uKDnjQ78E47l3yh4xDfI4gw6cnuOGRwIUjrU0S5apS7bJVMCEoXB2MJzD3OIdQxdCBMGbJ2exY8qZfe+thIVhP35NtsW+sMnvKiuU42b6tGcDDk8JvWaYljVgDB97tL0Lez5RsI0+hoZOQj9KW3iKpqNoVdpehG1zFhUVDO32zc6xEsbhBwHZebmgjvzfLe3TVbSQn+KYWXyXpWG/mkyd2XpySWZiREaeSNg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(346002)(39860400002)(46966006)(36840700001)(40470700004)(70206006)(6666004)(70586007)(316002)(82740400003)(8676002)(7416002)(4326008)(1076003)(5660300002)(426003)(44832011)(336012)(9786002)(47076005)(41300700001)(356005)(7636003)(2906002)(8936002)(54906003)(83380400001)(40460700003)(186003)(478600001)(40480700001)(36756003)(26005)(110136005)(36860700001)(7696005)(2616005)(82310400005)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 10:44:00.5080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 359fe3e9-7815-46c1-eb0a-08da7473e907
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT009.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB7950
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The seconds input from BD (6 bits) just needs to be ORed with the
upper bits from timer in this function. Avoid +/- operations every
single time. Check for seconds rollover at BIT 5 and subtract the
overhead only in that case.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/cadence/macb_ptp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index e6cb20aaa76a..674002661366 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -247,6 +247,7 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 			    u32 dma_desc_ts_2, struct timespec64 *ts)
 {
 	struct timespec64 tsu;
+	bool sec_rollover = false;
 
 	ts->tv_sec = (GEM_BFEXT(DMA_SECH, dma_desc_ts_2) << GEM_DMA_SECL_SIZE) |
 			GEM_BFEXT(DMA_SECL, dma_desc_ts_1);
@@ -264,9 +265,12 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	 */
 	if ((ts->tv_sec & (GEM_DMA_SEC_TOP >> 1)) &&
 	    !(tsu.tv_sec & (GEM_DMA_SEC_TOP >> 1)))
-		ts->tv_sec -= GEM_DMA_SEC_TOP;
+		sec_rollover = true;
+
+	ts->tv_sec |= ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
 
-	ts->tv_sec += ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
+	if (sec_rollover)
+		ts->tv_sec -= GEM_DMA_SEC_TOP;
 
 	return 0;
 }
-- 
2.17.1

