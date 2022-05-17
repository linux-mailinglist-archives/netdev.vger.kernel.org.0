Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92B7529AE6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbiEQHdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241258AbiEQHdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:33:31 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA96483B4;
        Tue, 17 May 2022 00:33:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RwyYjNXIaiXXcLZ5gS+apoW0twoAZuKxkl8HygR/zj9jpWOfhMBKno2/f4jyCzQYov74DspyKJoXAT22gi03WU3ZDzAMLO80O2JLTJvsOA+BRtv/CDxU5HjssKA0T2yjqsX/ExctdWE0YFAoeV69EmSjm2ITKKeju9tM6WO7dBMY6HYUhpi3rSULPPcxklvkN66PfR/Oy96mCnO6sankL4uYo5JvkgSEbXPeEqNXQZaZNO3oHeJbl+9oQ+jLkGRJ9wF5ShP1UdEIG/vvsQyOCQSHd2Ye4vOiTNlpcqfUhSx7Kshz7N0vKbsuD+8XSgETsZsRy9LHTPGbvGkwz/q3Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cpnYqFDx/8J0k9YnxZiCpqTzjZBbi5uzYOjNr8QPBw=;
 b=Z3iXsY+NpiqEjKQ0Eu/Wzr/fX+ZB4oVTXtf12sWhkVdmqAm0+LvIVJ/qwuOnJ/tysrTmPfZF+RUAeUY3KYCdN0TOHTBrBIU37MBkmCoJV1wcfUOZQUoUcgrJ8eileW1hS7JYQUza0rddIK0V5uJn73C1hemlBgY3+98oi9bdXJV54F5SHDpmokvli7PKonVo+8vJsxB/fOMmXwqPrHPC3d5JJNKJGfin56OEgjY4eJQG3KxqOABMiRJ26+gljm2RaX74aCuyowg055leuT3CoCbBb7NW2OOK3Omc8WnYJ7D66SODBIKRkx5KttgK/z7j77QrqjHQJCK8jkcwFUASpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/cpnYqFDx/8J0k9YnxZiCpqTzjZBbi5uzYOjNr8QPBw=;
 b=dr5zULaW2zFs+cQVT72JK3ZIE1c3M77TXT2v2gg3BUhUn+oFoW2jySsT5JgNYEYB3HJaDkI08Ls1cDTomS3gyRAL6kM4RSbLRSWydaHnGEikpRZHd1TF1UjwVJqzKPasjyDW0nFZd/qW5y1JXJ58z9scsd1v76T2ANsPQzSzkKo=
Received: from DS7PR05CA0015.namprd05.prod.outlook.com (2603:10b6:5:3b9::20)
 by SJ0PR02MB7678.namprd02.prod.outlook.com (2603:10b6:a03:32f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 07:33:23 +0000
Received: from DM3NAM02FT027.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::a1) by DS7PR05CA0015.outlook.office365.com
 (2603:10b6:5:3b9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.17 via Frontend
 Transport; Tue, 17 May 2022 07:33:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT027.mail.protection.outlook.com (10.13.5.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 07:33:23 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 17 May 2022 00:33:14 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 17 May 2022 00:33:14 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 richardcochran@gmail.com,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com
Received: from [10.140.6.13] (port=40442 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1nqrhh-000GAX-HK; Tue, 17 May 2022 00:33:13 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 3/3] net: macb: Optimize reading HW timestamp
Date:   Tue, 17 May 2022 13:02:59 +0530
Message-ID: <20220517073259.23476-4-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517073259.23476-1-harini.katakam@xilinx.com>
References: <20220517073259.23476-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc23510e-7d31-4919-02e6-08da37d78613
X-MS-TrafficTypeDiagnostic: SJ0PR02MB7678:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR02MB7678A2625CD87033732BDC59C9CE9@SJ0PR02MB7678.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k9Ga9HbiFH0uDS+/n56KPA7VA4kRQgKcezj8+EOxJ2SHPO/27ht6LuWXtFh+j6y+NR/YOtK1n4y+VKRXQgfjDG7cDx0gHyskP29R0oNzlR0yUIoQPuniMlMxdxnEejPPVLMNsBVrEBzzb/KCPyB4opJ4Rv50ZMaNVmjlj5qm7gehFHEVe61Sl0vEaMwzTePbw0HaMF8W3VPBea4R4GJ6RaelzSN2WUbFupBhPFCZdXQUx4ortRUdVwMdf/w1wX0Iuv3S8QLwXRDr7iQrGi+dNhfHHTM97vaylXtjYn0Uxyrkstm0Vm7vGRWR1dzbaUPJMzrdnqzpe7dxSMq5AEmjC5Ej+AVmCd46lKe8c0Nt+z0EFi1yE2t3YrsiRT6UMenmIIghdXm/u6VwhCNuBOo8DjXn4BvFVHe23voTbmfujAeRr0faXxCUoR4pvNii+s0WtiqH7CTExpw3rl55vWqoU+owbQsqVTHuL9FsjDReJ/4SYgz9EjIWaLrKMQeB4sZrNtepeVaWrnKMCQ2y0eGXEd4wcwpwBNl1ymYdtzJQc1Iy74vFSDJuD9QLQzkx7v3mNwps8cgVra/VPl7ZU3h7U1IkDZGG6Bbx5I+ym0WF3msro2ZB3WHiGDDHHM0AnyDoduRbGySJlydGrBUvztc0PLZRsiDcSTbGDXE6W9Xn6rkeL2MsOK8Dmvu+4aYPB/uJN8ZIfOZeeTYjshChQ3jvtQ==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(2616005)(426003)(7696005)(186003)(26005)(107886003)(36756003)(83380400001)(508600001)(9786002)(6666004)(5660300002)(8936002)(1076003)(44832011)(47076005)(336012)(8676002)(2906002)(40460700003)(7636003)(4326008)(70206006)(36860700001)(70586007)(356005)(54906003)(82310400005)(110136005)(316002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 07:33:23.2298
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc23510e-7d31-4919-02e6-08da37d78613
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT027.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7678
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/net/ethernet/cadence/macb_ptp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index 9559c16078f9..c853518c0406 100644
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

