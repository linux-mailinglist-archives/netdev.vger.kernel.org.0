Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F55595B48
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbiHPMGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiHPMF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:05:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CD53AB0D;
        Tue, 16 Aug 2022 04:55:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEFvWkS1LB+QmpTCq7ckSIF4fFx3HYiYPyN4s/aRdIX3zRA34FYX1extdF61LKXPSy4+JO4BR5ORt3t5YX3UfpS9uKIkqIqzmsmVd0tY5UyP3bNjQUR0Eqv+FMiWUw2DyMj4DDt81cFBSFDDx5R3ZRXjgOAxOJgmFutkXVdD7j78Mnkuw/qU/HakbHtmUq9B52j0VXid9nQHB1VIDHaq+ejgLIMvrrlQrkqx2+MrqFkqsz2cT7g6sQGHGc/QoN37WaZEK4ofvsPeYRd0FlnEbPr5ubEBjtmmPKoocLWTBN0kDXwl4X0+vOlLFeIOj7SrIoTgzXrMZftSD9V4mmwufQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bn5tMllLEJap3DJ5krVzBZpmh/y+vz987PbXvJqPy1A=;
 b=jN8WOAu+OnW7MBVF5UAYkAk6B461uMnGVFxA8pJyMjB27FiZQA0ndIwZe4q3tYwo+0aPa3AwZ2H9OPOzUY8HdVVUfdb8TZC80R6wRsQdsXWWge16UijgjUQ2e/PtiazarmSR7LZzChlyxTqh9AzO2EqgdrWV7srnNhTsQGZ2cUREhyGUSY7KT7e1hdubdHr7XGfPZ6y90Qlf5ZGShw1J8feuxeJgdcUeViE9KXjdTpQMJd+lP7lnY+es6gZpRGS9Qu15ugF8JirEzzK7xVD8WaC1VKH8Zu0y4sL1Hca/VhR3AXVPRWlFRgCcdB7MHVYLKU53RTRXEOLf32OrVL9YnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bn5tMllLEJap3DJ5krVzBZpmh/y+vz987PbXvJqPy1A=;
 b=HLaZF0/yfjj6DvikU9Q7L0fyiqWUNYShuKkA3STWvPkVz8foHCp06TZtiBjOYqpuOtBGu6HSQfHkgM9R306gYIgeurOv+DeWk+A9aKS4CoZDOnYrRWw7veeduyXnXTHBIx3rOuvEEZzuobarxH5TGOzfTYZZAdT9SxGOMe4CSas=
Received: from MW4PR03CA0052.namprd03.prod.outlook.com (2603:10b6:303:8e::27)
 by DM6PR12MB2780.namprd12.prod.outlook.com (2603:10b6:5:4e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Tue, 16 Aug
 2022 11:55:42 +0000
Received: from CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::8c) by MW4PR03CA0052.outlook.office365.com
 (2603:10b6:303:8e::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Tue, 16 Aug 2022 11:55:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT113.mail.protection.outlook.com (10.13.174.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5546.7 via Frontend Transport; Tue, 16 Aug 2022 11:55:41 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 16 Aug
 2022 06:55:36 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 16 Aug
 2022 04:55:17 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 16 Aug 2022 06:55:12 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [RESEND PATCH 2/2] net: macb: Optimize reading HW timestamp
Date:   Tue, 16 Aug 2022 17:25:00 +0530
Message-ID: <20220816115500.353-3-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220816115500.353-1-harini.katakam@amd.com>
References: <20220816115500.353-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a1abbe3-5902-4e39-610d-08da7f7e3eb0
X-MS-TrafficTypeDiagnostic: DM6PR12MB2780:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: liA/lHzjktWRNe1esJqHkgT5/NKKBBmJyKR5lCKPmJpFOzVFHq2baYLUMciNCoeNcRox6piKjpXZ/GB6udH9oq1q4UF23coHEbQnXJHRCEyR/NMCuACTvwk43bYcGBO1OLimhUeJX6QU6utH8yKg33DTzzZIlBExH4B+N+uD/C0dPM2qLwZxrsJeIm3vrIL/zlcZnAJwAoaGOelFv7Jf9ppP6D0grIKcdAnacsnzjATwrXDVTZmUKkJbPProIRkR5+ZkceFR6xAN1uRPhSkwJDCzSogD5HJPu6PUCc3Tv/CLQ1Qfv41XL3EieQqwGWs7LJug6VueJt28WmjIsfnKN8TRSG+PilKH1Jm69Yfb1vAtmaAlP04Np4OOLD1PsxScecou4QtiLrmMVGt9t66asBnX7CCGtHjLd3a/pHc/sfBKq+Tzr1pzfdvdX2eBSnFOGu4N2rfGDW4477rvU1p6LViNcfidC7N+lNqumgCWE4GDC+82c+fwQneP2Gid3tKemYcsTmMG1hSO8RDyXDWpkASW6x7SrYpAACGXnTcozUBfac8nps24azA03twxIYJq6oWYco3fzhNtwieyfV14FG3yyqkhyi+0vJJtB85DH+1yJBgkqjl5YfKizHEWCICWDUInG8Dm4nEPldGgRZQnCQxayRxP2NXJXsteXByM1Y1tPRlnagXxtWpTgBv3BG9Tto869HqgY2kBNqcvs8SDrYdPh5makk0qmw7r9nRf6iSPW2dy2UtgRpTSzN+FvPZOUYlwMrDbyoKN+ZL3HPjMl79HktLlU36wWc0f5xV4Z1gwNPvNz7x4uyEz2nSw460nlgaF95JmWdWbxd6m/946hQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(346002)(396003)(46966006)(36840700001)(40470700004)(110136005)(54906003)(26005)(426003)(41300700001)(1076003)(6666004)(83380400001)(8936002)(316002)(36756003)(336012)(70586007)(70206006)(4326008)(8676002)(186003)(2906002)(82310400005)(356005)(40480700001)(7416002)(40460700003)(82740400003)(36860700001)(44832011)(5660300002)(47076005)(2616005)(478600001)(86362001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 11:55:41.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1abbe3-5902-4e39-610d-08da7f7e3eb0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2780
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

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

