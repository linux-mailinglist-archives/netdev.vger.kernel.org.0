Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E40F53F8E3
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238790AbiFGI5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238765AbiFGI5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:57:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7D9DC835;
        Tue,  7 Jun 2022 01:57:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1U65GQ+yHcEAApFsMaNMCwl9kZViSS3i6Ar1hjepRmwN71eljgITRq7S6BzZ43hUIybMNkzdW8t+dVNYZgHp6myy1iFB7LMKHuxcO6tId/hwWxAnS8dKEoM/aMVD6HnChjkvl5g5gwpcrUkCURWR4P2ucA+WCVgZl7TwbpoMxIXmheKqmW9xbORpKzrfhV1NFOy3+rzfsZFeJ/F5HIQsLVu3mOE4za0YoIXAOmbiyQ/CNLU8xvQi6X20de9WY0ipMfpDST0sgFJRKbNaDbm+XrqKjLFeAlp7W+8YSy4Q3PuMxltFVIRX6oJsVeQEd9t0vvd4GL4AhkA5SRWSFZY4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGC1XMAny+N+RiRJSNr1bdD6awFcuTck6C+0siBbms8=;
 b=cNFV6j8LZnGL+o2ifiOvpvUsSfDKfMbzSjBjT87kEhs1RntmhAiHzvpbhvTQSWiwlFb271YtDruMuMKX+2+BSk13/T59VgonAcfdHuXWu2jS6GuyVyqld8etT0u5KZLpUU+tzkKBZBAKUlvW+x491tABnWaCi8UZ26Jxtau4uRM3qaucMu5bhf7CSbszrZCU7Q54IL1aALRX+5y+gwfQkkcnX/x+bQjvBb/f+uk2rmNA34XB9F7PvQc829hhWlDAWyyTERX3MKgAKlx747fkiHJ00FYw/4ZS3E3pbcro648GBahWBc2fqWw016DM12JyuA2fW2nOwUKfNJczR6BWqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGC1XMAny+N+RiRJSNr1bdD6awFcuTck6C+0siBbms8=;
 b=ip+DlUtkTVvkXWzhXrhk0WolHkueeofuKtelpI0FiZTNLxkI1ZWzKMOuCP9KUOAwcnONpF2DDB7AMExKoWI7cTu4Glphzs9SszC2Rw2nRTYYRGdUWl18vlV3xo3dTzR9bSznjG0aLWjbx76lapCx0fTtc606VnSGqKvszz2e5Mo=
Received: from SA9PR13CA0168.namprd13.prod.outlook.com (2603:10b6:806:28::23)
 by CH2PR02MB6087.namprd02.prod.outlook.com (2603:10b6:610:4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Tue, 7 Jun
 2022 08:57:06 +0000
Received: from SN1NAM02FT0045.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:28:cafe::38) by SA9PR13CA0168.outlook.office365.com
 (2603:10b6:806:28::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.7 via Frontend
 Transport; Tue, 7 Jun 2022 08:57:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0045.mail.protection.outlook.com (10.97.5.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Tue, 7 Jun 2022 08:57:05 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 7 Jun 2022 01:57:04 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 7 Jun 2022 01:57:04 -0700
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.140.6.18] (port=44264 helo=xhdlakshmis40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nyV1L-0007h1-Sq; Tue, 07 Jun 2022 01:57:04 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH V2 1/2] Revert "can: xilinx_can: Limit CANFD brp to 2"
Date:   Tue, 7 Jun 2022 14:26:53 +0530
Message-ID: <20220607085654.4178-2-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
References: <20220607085654.4178-1-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88eff62f-6bcb-478a-8da6-08da4863b270
X-MS-TrafficTypeDiagnostic: CH2PR02MB6087:EE_
X-Microsoft-Antispam-PRVS: <CH2PR02MB60874C4EB2BCEE23D93E0966AFA59@CH2PR02MB6087.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qt3U6pP0ltBcTANuIvmd4GLpsztRbVsnDVQlULCWNfDTvXjCy+L0n5xIjcL2zwCYEoBrFv7gcgGnEfclTxVyc45S5kjiYsVuPZTkoj4ioNXFbvcwD/3sQ7iiZs7+2TgwY+9M9mWfRPLAsZVqIBSKAs1BXtntRlRm/cktlqrhkx/zgI6qibmiLd2gguyKqp+qrQdGV6hq6nhozd0GGra5fzD7aajAblk8LTtb2LLGgd5v3Yo0ICRSvrdTEp5XOXTOE/bDRlxFiFwzSVIcxawKzL43VBwPwuGhVURdOzdekNme6Q8ph+nrnY98y6i365LHcEvu+1mFSZhLY8Xgc8e3j0WDZG6VNNOix1859d7TmUO1f6lyYHvzoMBtnLZmuWb6OJzmM54dTzDT11kx/S/GSP9v5qQahmSbGV6xokM1L922RZRsztivubkRxsQA4x3iF1onkWbJWFxUm90mrGEWyAH2wMc/veqDj+V3abQ4a19OfDxpRaFjaFx4Qv3lhsiC0hYBKlZLYVt03roRVRtmB0t3v8uOLKVEHYEV/Z9t8ByUlL2Un/HjvkBHY0+tsyRoPOmCjHgoWw5A+sJd+T5q8IRqYDqloXB+x6Me5fr2QbSB1YwG4VTv6qy9/M/wESn39LeC+tU2HSb3W8lrSE/4vmRC0pd7o2mEfJLQDToaJyoWjozIv3YocG1tiRXj9FHZDhb1TwoHi8Qa3B6FmJ80/Q==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2616005)(8676002)(47076005)(336012)(426003)(36756003)(2906002)(4326008)(1076003)(7696005)(6666004)(316002)(82310400005)(107886003)(186003)(26005)(54906003)(36860700001)(70586007)(110136005)(6636002)(83380400001)(40460700003)(356005)(7416002)(508600001)(5660300002)(7636003)(44832011)(9786002)(8936002)(70206006)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 08:57:05.7935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88eff62f-6bcb-478a-8da6-08da4863b270
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0045.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6087
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 05ca14fdb6fe65614e0652d03e44b02748d25af7.

On early silicon engineering samples observed
bit shrinking issue when we use brp as 1.
Hence updated brp_min as 2. As in production
silicon this issue is fixed,so reverting the patch.

Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
---
 drivers/net/can/xilinx_can.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 8a3b7b103ca4..e179d311aa28 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -258,7 +258,7 @@ static const struct can_bittiming_const xcan_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 128,
 	.sjw_max = 128,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
@@ -271,7 +271,7 @@ static const struct can_bittiming_const xcan_data_bittiming_const_canfd2 = {
 	.tseg2_min = 1,
 	.tseg2_max = 16,
 	.sjw_max = 16,
-	.brp_min = 2,
+	.brp_min = 1,
 	.brp_max = 256,
 	.brp_inc = 1,
 };
-- 
2.25.1

