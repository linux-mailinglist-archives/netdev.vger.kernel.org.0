Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6941F6C31E0
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCUMko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCUMkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:40:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCE03BC48;
        Tue, 21 Mar 2023 05:40:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5onZIb2E2VvRdEfoLEEFaHKz5Z6FN/z+vTamKy+zOS6i6DTRfcutPxtEMa2e45AlFZxTEBl1Uv23L0i2MQ3nynZ84egKxUZWebya/PxehkeRoQhZYwDuEp47/xc+lO9EaKvyYh3jfhYIOuJDgiNbtkfK2QkTnEd6QNYTObmCPabxLnWc9W9Q0la73KwG2+4+j18bposXbpn23OhplWd4wTHoXtHOOzcejdTDgpQXx50l0D5m77T246O4PJ+w3UxooIIPWVm32RmldvEnw5Sb5zPE/8GSVuwYVTDOpeYZxXPC+AxQsalclAADMz8bZvPqmI8JF7CEb1g8KkqStHZ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gi05toNJXz/rs0Dvqoiewl4UTdYJxCp8LhCVrGszmM0=;
 b=D3MNHbbGCs1JSuBPeNcIMgcv4F5v4S148p88bbhv3tq9TZu+3npKanjjnP3ifjNj6A09xyJNOr/fM8d9KSy/5XJHKh5kZqC9N0yhUSfzM7Uvx7V3cM7NFnoSYxXxt63tYo171h9KpTUEd2lSpJdZiRqtSiiYwFmeo1hLpLhymcgmO1azYxFp/WVhFfzuL2tDUVUMlOcOsrmqE37BreQ8Jir+WCYqAvnbuPzf7mpYqafVhBczb6oweEmJn7IaPBF9NYhW7Kd5suubFnN5eyKlrDzB22bwPHRpWpzL/V04yogZ36k3d1SRqF/lFXgaFpW40uFkfu38k3g3WLlDvGP9mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gi05toNJXz/rs0Dvqoiewl4UTdYJxCp8LhCVrGszmM0=;
 b=pgKorIkmbduqxd7qVI+QAniJXPsoTfcxyURCDIEq3uqGafbxxSIXTZAGXUjfXm5CaPYkLEvjmt1hfyYIyTylaTRFn/hLm8VRBSFrLO3gyhptOn9/cJPjk7Uc8p12SQ5JS3so5M5multl5j1EDMXm8GGIwlJgU8FkLTxb353vHjQ=
Received: from MW4PR04CA0211.namprd04.prod.outlook.com (2603:10b6:303:87::6)
 by DM4PR12MB5819.namprd12.prod.outlook.com (2603:10b6:8:63::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 12:40:15 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::bd) by MW4PR04CA0211.outlook.office365.com
 (2603:10b6:303:87::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 12:40:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Tue, 21 Mar 2023 12:40:14 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 21 Mar
 2023 07:40:13 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 21 Mar
 2023 07:40:13 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 21 Mar 2023 07:40:09 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v2 1/2] net: macb: Enable PTP unicast
Date:   Tue, 21 Mar 2023 18:10:04 +0530
Message-ID: <20230321124005.7014-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230321124005.7014-1-harini.katakam@amd.com>
References: <20230321124005.7014-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT015:EE_|DM4PR12MB5819:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ca0ef80-64c9-4fc3-75f3-08db2a096b76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iXRzkq6sfbkkzCPFnYiQbTWvkny9Kvd2neeaLrzJkYzl/OKqNoINT2uj6w6DuEqkIu3VKVwL+MiHh5xQOOgq0qq/B3mPKHKIuQA6JIdL2gDoGWvSz3ZaZyF4bg+mMx2+OSnKNPehTqGLy4ChSfrMU7vibIzcOjatV5kBy7W8ad+ZlE/ZPjoqztGXL1cmyin8Fa4HpWd18bdi7sPVQIpYKilv5xEG94Ycf/yz2RHqrs0kl2VG75LaMOEKwxdNNRIys8xegUAh+a+imu9FtfVb3s3CQKmUGLSB9eHzvOQxn2nOSKEpmj/y8lg2GvSWVmngPjzyDfEagx3Kkyk1WK+eYu2GsVHnf9KZ52MsXLgOPbBmHDgCdIjhlOGfiOV2Zz/fy0sWWyA2MDtJzt5WdfCIRC1ikbC7MVsD/KJFQOtxfeyY3QsMD3dBXm4UZnjHqT870JW3Ic2AIVM8zeJ+t5keTkXLjVGg7R66m8RzWAZWYxVrQllOAKynrYG3k+TtwUvOBhKQ6xQef3uAfq3Hj1gdnOtRk7CpKJgmELSx2RkLKOenL/8UNDqlLA24u30ry6eYYqRDsQlLoDCJNEjFZcPSgPb+D95CeVGaeUo0BFBCyZl5cs1TaE5MOboseBdEzJpOB48+aRFGywYbL0hmaQNzwZDS5vX7ynsJl9vBVOBTkY6GOIBZN05FGp6uvtIjtifhxASUpv4BUaV7TXr8gAmJ9Miib+sWSvsRrTl+vMUM+rk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199018)(40470700004)(46966006)(36840700001)(426003)(4326008)(8676002)(70586007)(70206006)(44832011)(7416002)(8936002)(82740400003)(356005)(2616005)(5660300002)(47076005)(186003)(40480700001)(2906002)(81166007)(86362001)(110136005)(83380400001)(41300700001)(1076003)(316002)(54906003)(26005)(36860700001)(6666004)(82310400005)(336012)(36756003)(478600001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 12:40:14.7648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ca0ef80-64c9-4fc3-75f3-08db2a096b76
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5819
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

Enable transmission and reception of PTP unicast packets by
updating PTP unicast config bit and setting current HW mac
address as allowed address in PTP unicast filter registers.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
v2:
Handle operation using a single write as suggested by Cladiu

 drivers/net/ethernet/cadence/macb.h      |  4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 15 +++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 9c410f93a103..1aa578c1ca4a 100644
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
index 51c9fd6f68a4..4c2c82573399 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -288,6 +288,13 @@ static void macb_set_hwaddr(struct macb *bp)
 	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
 	macb_or_gem_writel(bp, SA1T, top);
 
+#ifdef CONFIG_MACB_USE_HWSTAMP
+	if (gem_has_ptp(bp)) {
+		gem_writel(bp, RXPTPUNI, bottom);
+		gem_writel(bp, TXPTPUNI, bottom);
+	}
+#endif
+
 	/* Clear unused address register sets */
 	macb_or_gem_writel(bp, SA2B, 0);
 	macb_or_gem_writel(bp, SA2T, 0);
@@ -721,8 +728,12 @@ static void macb_mac_link_up(struct phylink_config *config,
 
 	spin_unlock_irqrestore(&bp->lock, flags);
 
-	/* Enable Rx and Tx */
-	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(RE) | MACB_BIT(TE));
+	/* Enable Rx and Tx; Enable PTP unicast */
+	ctrl = macb_readl(bp, NCR);
+	if (IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) && gem_has_ptp(bp))
+		ctrl |= MACB_BIT(PTPUNI);
+
+	macb_writel(bp, NCR, ctrl | MACB_BIT(RE) | MACB_BIT(TE));
 
 	netif_tx_wake_all_queues(ndev);
 }
-- 
2.17.1

