Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05386BE878
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbjCQLme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCQLm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:42:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3A155065;
        Fri, 17 Mar 2023 04:42:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EC/qY6SwYYvsKe7WWFIz97xkJVce4WWocXxgKlme2fxhYd1EzE8kLv4ddq4ChpPLM4HYu6lqvlepbOYiw+3FS1+lBgYEfts7aEFwgvK8qVJuuV5Rw12ZwJHLazLxdmctnTZRfRCteztxh4gOZBzDZKTPJJnCo/NdYsrUzPH88M3n8khGkw+uNQ0zSkMUMv3tjL0yAAMZOTzWdIP5Fhixk3W2uCS0N47QXsjWuOK31dXncC/WK4PaP7udFFRMUPxQL14nVBzurt2K/yaYGEdMkL3fdFXozkJAhi0JOvr/hg/RghRPNNDiBB2FRH38lOPEdsegOYRnjwo8MXLCgpeRmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ieusvuLTcRliltPQivzvZEmZOQ5ZpMhsfC9FONqd34=;
 b=XKOI9TvHH6lhyf+QiXaU4TGBfVpUrz7u2bTxJvR3PkCiS5+HEF5ZUnR6DlkF5fiYglf3n+kWGk7mDSxRk/gDhkRMU2ru/ufzLYA9l9dQcJZ9osnd0G8HstUf8w4yMywVKbZlIAeVDRBc/77IAmeQIxKzXUbvCnDlLb7mHaQkPqb3ui4D2cbr/L6DZLnriqgQRei5rq88fWbOugeMVZqNdrgzomiCddEL4Kcu1xcrIYIRe7Kg+2lSafK7T1+nD/tQ/R3INNPcMtw3mBwpiP/GvZWs9odeAO3ptWuSW9c+d0sWfwFeM8SE1hKLw4t/5P2Xp3k075AZ//nVgaTzbN/lQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ieusvuLTcRliltPQivzvZEmZOQ5ZpMhsfC9FONqd34=;
 b=fMF4xjzFC1RY4a47frI8+wLX+kPCt65f1gVOgHnYP7ZnT7Q2TuRpLzJH8wwitNvs4fCd71Pg9vSQdOmlUiSWd6Um58Qzp9Ir+Q9dXDKlOtVv5EwyvAfA0HPTL94OEjKgEuEbMBhywUxQHs7+sNf15N0aTUQZHdkDRcwH+hddPyQ=
Received: from DS7PR03CA0272.namprd03.prod.outlook.com (2603:10b6:5:3ad::7) by
 IA0PR12MB7530.namprd12.prod.outlook.com (2603:10b6:208:440::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.35; Fri, 17 Mar 2023 11:39:48 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::f0) by DS7PR03CA0272.outlook.office365.com
 (2603:10b6:5:3ad::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35 via Frontend
 Transport; Fri, 17 Mar 2023 11:39:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6199.20 via Frontend Transport; Fri, 17 Mar 2023 11:39:48 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Mar
 2023 06:39:47 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Mar
 2023 04:39:47 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Fri, 17 Mar 2023 06:39:44 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v2] net: macb: Reset TX when TX halt times out
Date:   Fri, 17 Mar 2023 17:09:43 +0530
Message-ID: <20230317113943.24294-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT034:EE_|IA0PR12MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 334bba06-389e-4e79-abcb-08db26dc501c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: otri1sMYHlO58LV/71bgs02ZRVL/kSF+zCXYpuKFGgAFZJgEY2MNYSCvW6FFG01VvMdvUvI4LBjlEnN73pynRaTg9pBwfkMny+qvd61R5NrAr5hqXfHbfJMtckeSUuud+yY6SuK5FBhrZ5kpoZnvN8Jw4hIDTz6lbZHGi2o89CmOndYpvhSmVWo/iNQno9ebezbRi5/eYmHWGw0ZNVjFPN1wK15cXzm8R8udJJkl0cFQCRtegm/TT+J5YieY94AEFNriC8HZwlm3oHCGDdtIQCzjRCfIggya/BoP0iVuVAvOLPms3mFLYy/2JzQ7ozJNU6LmPoqNp6i4wZ2z/o31WNUPSkfzRVa+YEILYXIrvKj1iK0nI+Vs5YnW2hbcSojPlr4WgBkwUJBbyVE19UqSPaQfPOuDhBAgJCldI2xr8CTPdpPneHCaZjXUTtEXHBBjafSHbGLxcJ3mQwT1t/Z4Vlsf8wKf+96E7OHIpTBjKV8QozdvC95yE+xVL14cJZbaOPM8PtrvwLbQ+kvUlEHlVYi14wD9VXJT7lJlzQn11I/C3V2x9dG0C6JhqqDI74il5YrJhE1MahBfkIFpeAngzL8JePMbyyPjcOmrtDiLqkcgBHjYgx0MG88yNquaxo1TkhW/bztF0q3VYlJHwQYyqiclIY+fUg7FrHSB/Scdf5+IWLKr5CRqH711r21lkBDmqXi2lf6GATrAGf6QsZCR3cN0hiy3jHQR9j2J5aDbZ3U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(40470700004)(36840700001)(46966006)(70586007)(70206006)(2906002)(40460700003)(81166007)(186003)(2616005)(82740400003)(47076005)(426003)(82310400005)(86362001)(478600001)(41300700001)(356005)(36860700001)(83380400001)(336012)(316002)(36756003)(54906003)(110136005)(40480700001)(1076003)(26005)(8936002)(5660300002)(8676002)(44832011)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 11:39:48.0992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 334bba06-389e-4e79-abcb-08db26dc501c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7530
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
v2:
- Re-ordered declaration for reverse christmas tree.
- Added review tags

 drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 96fd2aa9ee90..7b9aea50e9bd 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1015,6 +1015,7 @@ static void macb_tx_error_task(struct work_struct *work)
 {
 	struct macb_queue	*queue = container_of(work, struct macb_queue,
 						      tx_error_task);
+	bool			halt_timeout = false;
 	struct macb		*bp = queue->bp;
 	struct macb_tx_skb	*tx_skb;
 	struct macb_dma_desc	*desc;
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

