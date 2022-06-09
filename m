Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CBC54459B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 10:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbiFIIZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiFIIZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 04:25:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD7214D79F;
        Thu,  9 Jun 2022 01:25:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awdKPaBvR/rrRwwg9uSB/8qivRxEqPrz99mc38F9MdUx+df7/8YfrnfT5+6CnjVjtMIIf4FQKenW/lTp66BSfMj0dRA3jy/zNNh9AV+dALtne102poUrFSz9SuFhy13IOFLtQ8fe5OMkKo4tFlzj689H9UzfBonHWq/0LkeIGj+GGBZNqa+hCkdg9Z9/q/3FdNCBXmxmrPr7HNUqwlBJi7NrjZHjCUj27+v7UJ9eGSDdoJjWvUo1Jtwy3IJ4ijbuobvhCVY0GdFPBGZyAB7eDZQn4bD02Lf+C5seOhU6gC4pMPjymwtA4KzhBCxycE2lAfRpydBv3fbWW99f4MacDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rPwDCkMxaovxkO6KuICJ6Aw0mUDH8IhfXqjniw8GTo=;
 b=JIq4pLNCFLNfw0Rf8fWPOJFWFmhrQsynghr8QOsUmLzkZwjcgN9FPgd6KaMV0V0R9Fzvhx+uExHBhlcMZfjd74QT01zhBCKO25p6QDrfynxMoE3mewnfAFieH8hb6x2dULF84Eu1YuETNLmKPn19JiGYn36jkgoKfnwPaoBNz14Qn7JMKxIUh5ddUw14NIiXO2sXAlLJ6PS/m5DAQfPUSLZsBd0HcnweX56QCmZ4ezUH6Gj6/cDkQ3eOHck4WU/hIYYp8OOtkeoJ7PqqC0BftZqdmHHhZpjIIVeri1zPPLVRzs3cSK+86qMgc5TQn5snX+zsyh6LiOD0toyhCycAbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=grandegger.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rPwDCkMxaovxkO6KuICJ6Aw0mUDH8IhfXqjniw8GTo=;
 b=snTgV/TJCldpERoVM69D3m979bOdnGV1XkuvkHeZ6XPCmD/Rb/jEqqgeF8JsOB3Pv5D8jeh+fhpLaKzKghLA0tDN+UwdcZTSl7IrvrP3a9C28AT5O90uggkpYhah/t7iUB7uobDpcr7Q14gq9aQqdSI1pd7ZIb2ZxcJsI0vAP80=
Received: from DM5PR1101CA0014.namprd11.prod.outlook.com (2603:10b6:4:4c::24)
 by MW2PR02MB3851.namprd02.prod.outlook.com (2603:10b6:907:9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Thu, 9 Jun
 2022 08:25:04 +0000
Received: from DM3NAM02FT003.eop-nam02.prod.protection.outlook.com
 (2603:10b6:4:4c:cafe::a3) by DM5PR1101CA0014.outlook.office365.com
 (2603:10b6:4:4c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.17 via Frontend
 Transport; Thu, 9 Jun 2022 08:25:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT003.mail.protection.outlook.com (10.13.4.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5332.12 via Frontend Transport; Thu, 9 Jun 2022 08:25:03 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 9 Jun 2022 01:24:59 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 9 Jun 2022 01:24:59 -0700
Envelope-to: git@xilinx.com,
 wg@grandegger.com,
 mkl@pengutronix.de,
 davem@davemloft.net,
 edumazet@google.com,
 srinivas.neeli@amd.com,
 neelisrinivas18@gmail.com,
 kuba@kernel.org,
 pabeni@redhat.com,
 linux-can@vger.kernel.org,
 netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Received: from [10.140.6.39] (port=37838 helo=xhdsgoud40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <srinivas.neeli@xilinx.com>)
        id 1nzDTO-0008BE-BH; Thu, 09 Jun 2022 01:24:58 -0700
From:   Srinivas Neeli <srinivas.neeli@xilinx.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <srinivas.neeli@amd.com>,
        <neelisrinivas18@gmail.com>, <appana.durga.rao@xilinx.com>,
        <sgoud@xilinx.com>, <michal.simek@xilinx.com>
CC:     <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Srinivas Neeli <srinivas.neeli@xilinx.com>
Subject: [PATCH V3 1/2] Revert "can: xilinx_can: Limit CANFD brp to 2"
Date:   Thu, 9 Jun 2022 13:54:32 +0530
Message-ID: <20220609082433.1191060-2-srinivas.neeli@xilinx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
References: <20220609082433.1191060-1-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fe30a26-81f7-497b-6799-08da49f18d92
X-MS-TrafficTypeDiagnostic: MW2PR02MB3851:EE_
X-Microsoft-Antispam-PRVS: <MW2PR02MB3851D070EC88019165C6E57AAFA79@MW2PR02MB3851.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKpydUdpAL3lhkLW8ZHK4qy/EaXRE/o5dqeu9K3f/egFiKyxyc/BdJKolQ6Dt7RHLgRoyS7rL/YRyGfSkz4quqQpN1KST9xyVVa0gN+DdDhGq68RgdRoKHl9+Gai7ysbZSBpsby+u89SgmChTnG7lGDSf23TAhDqJA0yLDe4QPuB5FPWJur9p7/0InwQQvmIKRtTDMwjjWyN68c7oGi7RHvQYDY4hrqLv8Xp71eK9UI+FOL+BKx2K0jpSnImydj/4Ksa1piGQKjnAgABrvwSgXBoF+K9hUG7lEvkk+6tnsszMBUtMFZNhI9pckem/Ue/1A/oSj0cm0NJ/kdMXc1MPH/D30EO3qLsRQjdtwUWHeeqH5KtKe+75ibikCSZ0+jYHSpxXidGQPR+knrLqixv87Tua2h/R/ghhpDMYn/g58rOecpSOiJDuQq39523oi+hkT8JhGnD0lAw2ng8GdBlOMpDG9dggU4MKAC4M6+T3R4fiGHfQ4H7tAFFRHKE1BkcdkJojpprACnNp1GGenoQwU81JoePZsyU/Yieveu/B8hjqV/0r1NQ6L6y63mxyoamci4arLQUMcUeeLDg6yICb5PKat0bzB/qdQqV8kotsqv8vdaspRBGaie4e/RSrhqBuINE4jPUwNPReAipc2gLTV71HLPP1jkcKIS8Cdhye0Crk0TiFS6PGcw4jvJETq1dpcVH/h1zc3QJKHRpER1fUA==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36756003)(83380400001)(82310400005)(40460700003)(7636003)(508600001)(36860700001)(356005)(8936002)(9786002)(7696005)(8676002)(7416002)(6666004)(5660300002)(4326008)(70586007)(70206006)(110136005)(54906003)(2906002)(6636002)(26005)(47076005)(316002)(426003)(186003)(336012)(2616005)(1076003)(107886003)(44832011)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 08:25:03.5443
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe30a26-81f7-497b-6799-08da49f18d92
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT003.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3851
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
Changes in V3:
-None
Changes in V2:
-New patch
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

