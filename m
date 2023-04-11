Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5686DDB00
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjDKMhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjDKMhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:37:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C144495;
        Tue, 11 Apr 2023 05:37:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8ccdjCC7LqfLcLrlkX7iocnC73aUsr1WQarPdPSoATaTjh3Gr6+B5BDgQ07yFkP92oLQA6hUYKS/KhBEin3nuq2lz2zLNbL61GYDNjenRm4vAxQz30wkXryy1vMQJjxxhS52TJu3Mt9FhfEIaNFWGpH5YItzQDerXWy15nlnjsaphlehf0LhqJ6mVOSl3p+p9aQ5RsYF5R6I2bghwIdkb4ZMOZRWJTwJX9kFo+8nHSz4p/0uvLIemburrACpotKS2AI3H/UZli1F40aOHnQiBGFhEKE9Tw9si2+2Izv11o5ZRnLcAj69/JBPI//PVfOfOfjQnCGd4NXDY3ncUaR9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTPRXST47667/UIqNtvDQHH8ThBYJikWD4B7SbIuU6c=;
 b=aNHOX8HoG855ibmKDXja5LnJxrhie8Jl776w/vK3pLkn4d010bhnjXVSfvK7kZXI42PZqHjiETiX7HLWKloVMbfvps0Cm8mceBPR0mJy1sWSDb1OvcaoPppdkN4Gt59O8szt9H8/YWSdSVX+Yhz6RWs4VVzn3ma7GWDZDDiZlBTJXwYLfklwMd0r6rXK4D1tS3/oX5eQlvc8Kt8I6TDRy6abtB8miyamL1tS31Lbkztc4LsYBJTQINz4E9UO8tSk9idepoQ7Yf/S1XBNN0ZB44aakfLIFLrSwbUWQYnQaxg26SoB0cg4D37JYG/MTO9J49McfdyxtEVFWWIe/F81SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTPRXST47667/UIqNtvDQHH8ThBYJikWD4B7SbIuU6c=;
 b=1pr6ocGa/s9IhpIyJkr+eC1UKtWRn0sy7Vty0j1KQVywRSxFYt1r3ZYTy9OhysUIi5LF9+1+YNQO+dlgBMI9zynNY6BCjN46EVzQXET1IRKJnv0Bx6ClO40BNZrYT9ALU9HuQukCHcWeGRbMuT1cONlSGk7Jr18NYKwmTMduJA8=
Received: from MW4P222CA0017.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::22)
 by SA0PR12MB4350.namprd12.prod.outlook.com (2603:10b6:806:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Tue, 11 Apr
 2023 12:37:31 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::9c) by MW4P222CA0017.outlook.office365.com
 (2603:10b6:303:114::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Tue, 11 Apr 2023 12:37:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:37:30 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:37:29 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 07:37:26 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v5 2/3] net: macb: Enable PTP unicast
Date:   Tue, 11 Apr 2023 18:07:11 +0530
Message-ID: <20230411123712.11459-3-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230411123712.11459-1-harini.katakam@amd.com>
References: <20230411123712.11459-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|SA0PR12MB4350:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d000a53-cb96-404a-9234-08db3a898466
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9m/0jnltXEiqkpLPsuc29lEJMihsf1VkLqtv5CbBm5UzeYIX3wfOZ5RfLlfbpcDLd5bW2IhemsESyBFaPVH1xgHXiDL7Fbzt0e8plX+cJrigKD6LFRkzctsWmoe4Un8L8zCyCmyjrwvhadoIu39JwpwadTOVY9wACvs9MbRjkWKzeNWpr9f3iRjyjElqfYdFVBCCe8RRMMieqaAUQ+sA3GUCPfCrfTzX5XpwFNQ+pFL279C5vQgIiL4AKot96uk3VU8kfqA6soECHoVL1RrLgLMIpzpvyl0mypmbxxP8KvwdV+bAS4B+RF3a3ZzrAaaj88hHrwwbRyLrxNHiW92Zzi+rIRHPuliApjJch7tK5qjPQaqYBRiBrmW2lgpJ1qwTNMrDdy4KjLK7VujyZudkH0l5oKx97T5dEP7BHDdu12beD5XEIYNU5IgBUXh1GWirgtX+4ENgJqv32c53j/nWQng5PtW8BSgh/OBUpW3PQmbqYbWqW+W73tqp+pkhj3EvgEKXRhvfyCYW+jsXOkMGfvtgqE72nom9krobM3NktUUUfWfZXYtsv9ZdB3AUwRNmMOLG3GySk1BIS9dgK+YG/RitImnV5YCkx8VNHiHuu+As5zfeDboXw5Q498XtCbk6D3pPSwjLb3wil9YS12p/EOlBBv+LatLU9km4spG9vq7cGvI2XCaIr8G10NQdrZTbBuyzFTrGqbAqhYOkSI42CAczx1RGJu+plR4wjS0vhM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199021)(40470700004)(36840700001)(46966006)(6666004)(8936002)(40460700003)(40480700001)(44832011)(7416002)(5660300002)(86362001)(4326008)(70206006)(70586007)(8676002)(478600001)(110136005)(316002)(82310400005)(82740400003)(81166007)(36860700001)(54906003)(356005)(2906002)(1076003)(26005)(83380400001)(2616005)(426003)(47076005)(336012)(41300700001)(36756003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:37:30.7739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d000a53-cb96-404a-9234-08db3a898466
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4350
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

Enable transmission and reception of PTP unicast packets by
updating PTP unicast config bit and setting current HW mac
address as allowed address in PTP unicast filter registers.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
v5 and v4:
No change
v3:
Remove config check as it is handled in gem_has_ptp
v2:
Handle operation using a single write as suggested by Cladiu

 drivers/net/ethernet/cadence/macb.h      |  4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 13 +++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 07560803aa26..cfbdd0022764 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -95,6 +95,8 @@
 #define GEM_SA4B		0x00A0 /* Specific4 Bottom */
 #define GEM_SA4T		0x00A4 /* Specific4 Top */
 #define GEM_WOL			0x00b8 /* Wake on LAN */
+#define GEM_RXPTPUNI		0x00D4 /* PTP RX Unicast address */
+#define GEM_TXPTPUNI		0x00D8 /* PTP TX Unicast address */
 #define GEM_EFTSH		0x00e8 /* PTP Event Frame Transmitted Seconds Register 47:32 */
 #define GEM_EFRSH		0x00ec /* PTP Event Frame Received Seconds Register 47:32 */
 #define GEM_PEFTSH		0x00f0 /* PTP Peer Event Frame Transmitted Seconds Register 47:32 */
@@ -245,6 +247,8 @@
 #define MACB_TZQ_OFFSET		12 /* Transmit zero quantum pause frame */
 #define MACB_TZQ_SIZE		1
 #define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
+#define MACB_PTPUNI_OFFSET	20 /* PTP Unicast packet enable */
+#define MACB_PTPUNI_SIZE	1
 #define MACB_OSSMODE_OFFSET	24 /* Enable One Step Synchro Mode */
 #define MACB_OSSMODE_SIZE	1
 #define MACB_MIIONRGMII_OFFSET	28 /* MII Usage on RGMII Interface */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index eab2d41fa571..e941ea365db1 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -287,6 +287,11 @@ static void macb_set_hwaddr(struct macb *bp)
 	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
 	macb_or_gem_writel(bp, SA1T, top);
 
+	if (gem_has_ptp(bp)) {
+		gem_writel(bp, RXPTPUNI, bottom);
+		gem_writel(bp, TXPTPUNI, bottom);
+	}
+
 	/* Clear unused address register sets */
 	macb_or_gem_writel(bp, SA2B, 0);
 	macb_or_gem_writel(bp, SA2T, 0);
@@ -773,8 +778,12 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 
-	/* Enable Rx and Tx */
-	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
+	/* Enable Rx and Tx; Enable PTP unicast */
+	ctrl = macb_readl(bp, NCR);
+	if (gem_has_ptp(bp))
+		ctrl |= MACB_BIT(PTPUNI);
+
+	macb_writel(bp, NCR, ctrl | MACB_BIT(RE) | MACB_BIT(TE));
 
 	netif_tx_wake_all_queues(ndev);
 }
-- 
2.17.1

