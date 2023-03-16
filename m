Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B348C6BC941
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjCPIgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCPIgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:36:03 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E427F1E5DB;
        Thu, 16 Mar 2023 01:36:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCNagg/H/5K9xmv1rop0KPjts6H0Z+TRVVrzrzMtih4Qhs8AyXgvGtmJhdLjxyETdqgFPjwwtnXT0JsQP2xe7+h6ZwpWTiaWt0cs6UZkXcaEFQsfxCD1O3UAh2nOUWGDiWesvk1usp1XRXWAKbWzAPJyzE+mXgoROHz5qOlBYMXY4fNScIinO1fuSvu0F/DYGtVeBOD195FeE/HhA1H4j7k7CcsYqAbwxbLq4hAdEliodTVTlrNaWY8/2VC/Cojrxlp2TkClBRSYPek1uLGLF5o0XvstN4KFURuBFpPUAVZazXvoJSm+BcMwkstI7QQnJX2eMy/AtBFjoEQrGTOxdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crs55PWGu+i3OD9kcBKAsxMFWzEjA+2Qx4dCBHkR4O4=;
 b=Ju1a9G2WANVRoFanK+IPFIHZ+ij6ypGox6I5phJHcwPfAtzAR45ux6kxeAvjCDedXIwpeU8Sf1jSWKoDqArKXuAQOYef1vM79ppmwVdfNBs//Eqak6QmwOD0Dzbnna4KUBj9Anwxx4CXo3BDUzWqBteIVqFTHNffD2npCfUxV2snJMLDOxhrFOAGAPM3yY1UjaNc0J3rU3iUGbQJIlLsYfj52PgOUDvIQgMZeP3JdOxspnV0gYofcBLK3e3LQGKX92szdj0dx6VeNDGvl5KXjuYuF/JyjuFjwv2nYRRDPGzAYMSa/Ls54uc2DD1jsdG1fFgyi0ivylNbCnLGEXLQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crs55PWGu+i3OD9kcBKAsxMFWzEjA+2Qx4dCBHkR4O4=;
 b=wRtuxwE8YKZpuUIfj4sEnMMi9oiUXF/QJx6wTt1pBz7hCLeKtmxVdb0W7WxgUHoqFPQjKvSV6w+0pFniG6sc/WKVr3ao1EFYYvvrkNEufIqzNpLZzGTaI3cGrxX5xwi+ju+0Nsvj0b6MKWpXJ+HBWfytGSjYTmoGgqFls1cRQE8=
Received: from BN9PR03CA0195.namprd03.prod.outlook.com (2603:10b6:408:f9::20)
 by DM4PR12MB6448.namprd12.prod.outlook.com (2603:10b6:8:8a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Thu, 16 Mar 2023 08:35:59 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::bd) by BN9PR03CA0195.outlook.office365.com
 (2603:10b6:408:f9::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30 via Frontend
 Transport; Thu, 16 Mar 2023 08:35:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6199.11 via Frontend Transport; Thu, 16 Mar 2023 08:35:59 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 16 Mar
 2023 03:35:58 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 16 Mar 2023 03:35:55 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next] net: macb: Reset TX when TX halt times out
Date:   Thu, 16 Mar 2023 14:05:54 +0530
Message-ID: <20230316083554.2432-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT063:EE_|DM4PR12MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: d209569b-a291-441d-f364-08db25f977e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3i/1NQ6txJl8rCooyNaMbuDbu7uWywqyDTsxT98hDQWp1WigCAreihrcuLikFHD2crde9zah32wgi9GXJsoyG+QYGp0Awo/EzmFgqFATwCGLXKY2OsIhdz7VQNkkVxXAvIVWIngMF2anfk0AKWDKvZc+0iVbk2xMxDF/zOY+fhcCFqNnQVQykTtTEbhlaVZ97GrsfsXjK1sCmY242rSWQGychu9g8RITeu96A/FidkgUlbrPZfdhRpEmiBaIqP/fQocfM1xr6e9shPWpAMA73s39Mas2U1tEb0XDebrHnVomQ9yyku4YHUzyNulk6Cu1dS0sW00qycJoXtI2r3h4eyEnSPc93RlKPpOTEVSm302aO2IsbP/5GY9JL309/HzzIh+I9sAYiEwdICZ/UaLAwHW+BRjJ22jmd4460Q5cdeQl5loHWPE8sBSFoTcxNsdPSNRFM9kckifSdGd+8uo4sjxJJ/9X6HYeheF3IpeQb/OtjK3QD9wBqc9XuAXdrQ1XsOAPplcOeezUe8+NRA8zvEroLBK7YxOOD+kpEmCrbQe6MTKh5bjVzKTy0DLLQYpBMrsxZvoc7M9/HSDOh/7BFGQgQsQJ6y9KOGJR0wT75nInBx1E4IojShJ/tGhElmDMYLkXN5AFXXSJOnEP/i9srNJBSnopM9/JHxPkS1AYo2S1q+NMlGbw3cfqgza/JlJrWLGhjFoODFKIfIsm/YIRWJdGfvz5KCSsUYmUdBKlci4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(2906002)(47076005)(1076003)(426003)(83380400001)(82740400003)(336012)(40460700003)(40480700001)(5660300002)(44832011)(186003)(8936002)(26005)(4326008)(41300700001)(356005)(70206006)(2616005)(86362001)(70586007)(8676002)(81166007)(54906003)(110136005)(316002)(36756003)(36860700001)(82310400005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 08:35:59.1125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d209569b-a291-441d-f364-08db25f977e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6448
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

Reset TX when halt times out i.e. disable TX, clean up TX BDs,
interrupts (already done) and enable TX.
This addresses the issue observed when iperf is run at 10Mps Half
duplex where, after multiple collisions and retries, TX halts.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 96fd2aa9ee90..473c2d0174ad 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1021,6 +1021,7 @@ static void macb_tx_error_task(struct work_struct *work)
 	struct sk_buff		*skb;
 	unsigned int		tail;
 	unsigned long		flags;
+	bool			halt_timeout = false;
 
 	netdev_vdbg(bp->dev, "macb_tx_error_task: q = %u, t = %u, h = %u\n",
 		    (unsigned int)(queue - bp->queues),
@@ -1042,9 +1043,11 @@ static void macb_tx_error_task(struct work_struct *work)
 	 * (in case we have just queued new packets)
 	 * macb/gem must be halted to write TBQP register
 	 */
-	if (macb_halt_tx(bp))
-		/* Just complain for now, reinitializing TX path can be good */
+	if (macb_halt_tx(bp)) {
 		netdev_err(bp->dev, "BUG: halt tx timed out\n");
+		macb_writel(bp, NCR, macb_readl(bp, NCR) & (~MACB_BIT(TE)));
+		halt_timeout = true;
+	}
 
 	/* Treat frames in TX queue including the ones that caused the error.
 	 * Free transmit buffers in upper layer.
@@ -1115,6 +1118,9 @@ static void macb_tx_error_task(struct work_struct *work)
 	macb_writel(bp, TSR, macb_readl(bp, TSR));
 	queue_writel(queue, IER, MACB_TX_INT_FLAGS);
 
+	if (halt_timeout)
+		macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TE));
+
 	/* Now we are ready to start transmission again */
 	netif_tx_start_all_queues(bp->dev);
 	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
-- 
2.17.1

