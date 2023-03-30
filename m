Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392ED6CFA92
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjC3FIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjC3FIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:08:36 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02FC55B5;
        Wed, 29 Mar 2023 22:08:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZllMeQ2pQPIMPIdCLd7lawhoVJs019wpdWiY3xzfL1MMTf49KY5m5F06zKkMF9uL1rcUpxXNRKUk/KaM0iYnF4WZwWtX4VweOrJREQKQO0O8Tf0KtMVNFuNzrTsWu0914ITDjqVswTxwyWp3i2+KMPGMcPu1R+fIaTq4m22qkO+Mp0Mw7ofWhbcveGCYkUezs+l+B+dGtAvbMd0X2hdVV2IS7NXaKiHiNAwx0o9Lm6AwcIYPmQb2iKdz/+cyrgBFs0YheeupmepUVAoClTQJ0MhIt82xeTJEAyqCbUqdAta+pdzOs2E010GnFc0YDYPCsOks1Uto/wo0dqhVOHfODA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUgLKD7DlPP8+Q/mfEVSP8QnuXADLP5dohv2zJCXjhE=;
 b=K4sVbdhIie6bKbQdhGPp+m04caEtcg8JUEiv0JfgrOT6i6R5/Lm/j6MRna1jE7Vkc5R2fsSjh9EZ2N5ivq11jcwlX3hdzZ2Xdimq50KyH+ClEdfLLqBrCEtnXoHWogiXKzq5hivblkXiUNcHs35EYI3Yw3Jv2s9VPRxWWLtjRpHnDAT2PzQhUYd4Vs0dm0lJ1tTRTC5obCWxhba0bE8awlo16yA3EJfRCYf507+BTZ7Ha5966aXzC+ziKxNDMIy1Pp5xDPypPzHyIkAgUOqEVc8Cj6hzHz5izMQzhbNNPRKTP7WiTjwPAD+WOwHhvtFz/r+k5faFMqXTdqMPMS+F4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUgLKD7DlPP8+Q/mfEVSP8QnuXADLP5dohv2zJCXjhE=;
 b=p9GUq8Ioaeb1LaTqK2KFJxoeqBuk8cajNDypRPb9zOZxMykWFfX2ohxNn5PHRsz4OyP2WtWbvX3M7WUhtc8/2TCiiIO56Ra2/XM/15n/2kfQXs74nR+bE4L7zGu7sOeZRBzCTS4lE21vbd76wPBqKjPgt/bSWJ6l/dgRMV3UuxQ=
Received: from BN9PR03CA0802.namprd03.prod.outlook.com (2603:10b6:408:13f::27)
 by BY5PR12MB4164.namprd12.prod.outlook.com (2603:10b6:a03:207::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 05:08:27 +0000
Received: from BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::c7) by BN9PR03CA0802.outlook.office365.com
 (2603:10b6:408:13f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Thu, 30 Mar 2023 05:08:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT116.mail.protection.outlook.com (10.13.176.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.21 via Frontend Transport; Thu, 30 Mar 2023 05:08:27 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 00:08:22 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 29 Mar
 2023 22:08:17 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 30 Mar 2023 00:08:14 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v4 1/3] net: macb: Update gem PTP support check
Date:   Thu, 30 Mar 2023 10:38:07 +0530
Message-ID: <20230330050809.19180-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330050809.19180-1-harini.katakam@amd.com>
References: <20230330050809.19180-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT116:EE_|BY5PR12MB4164:EE_
X-MS-Office365-Filtering-Correlation-Id: bb28aa0f-f635-468f-9066-08db30dccbb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdRe34FkoVLuPTF24/fGlIEB+ckZg+joxyvg2I2NzGG/MKJJKmSx7q+tnBf8pAQPd59vImCTLStX2nL6fdBPTsL1s/PHslMTgsAHhSCF1mdWZMvVrCdWV86zmwiSY/LqqSXyM3AL9Tr1Te4jmcF+8UTAwSn0eqHtEVblKxZ4b0evXTghZbVOcHV9rDyPFOgArytsKdwtiS1SKjeShlchPkRzhgzbm0f+OF9VTRs61OXPjJ0QI2vcea8gA752ciFXM/w3fpRuHBFVlqYIIW1AI+l0x5rnrSe8pmsvzxKAD/jE0qnitgo5ehOmMl4bFi3QO2r9Mvml2bkRk1X3xLzhwxTHCjzhkb39K7zi1By3fmrdwIqsw9/KBoryAhYuvyYM+0tzouLfJHIgvurLRoE3BpIeGMm/G7lNcGUdIK8PNfkOhgNG+i8wqXO9Gx7uaIpyOUYOWPC4o9GMDJUmL5JopkLNffoiAZP6eogxh6rwb/Qe1nrd+Sv6+xJ/9kzBeQJH55nGJw6O2lzZTbjwA/6qIhL3Gx9NKMdEwMZWiBWknDd9Hj1ia51aNMSfdBval/UjK5xdDj1/IPafGaDxFFu70ByfTn6EqOcDsD0KGahXUXxqcvFM+9XYkUFSurOpoiSOIviDm67IujWQd8/yZwcm9ToDTYdAzqe6VDBpe9bJi7Rcma0OPBDTU2V6BW370iNWkyLpwZqEE3O//tREmQ+wVXI0XxM4WqcdWlYfo8hP3BY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199021)(36840700001)(46966006)(40470700004)(70586007)(26005)(1076003)(6666004)(356005)(81166007)(82740400003)(966005)(47076005)(478600001)(426003)(36860700001)(186003)(44832011)(336012)(8936002)(5660300002)(2906002)(40460700003)(2616005)(7416002)(40480700001)(70206006)(36756003)(82310400005)(110136005)(316002)(54906003)(41300700001)(4326008)(86362001)(8676002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 05:08:27.1397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb28aa0f-f635-468f-9066-08db30dccbb8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4164
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are currently two checks for PTP functionality - one on GEM
capability and another on the kernel config option. Combine them
into a single function as there's no use case where gem_has_ptp is
TRUE and MACB_USE_HWSTAMP is false.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
---
v4:
Fixed error introduced in 1/3 in v3:
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202303280600.LarprmhI-lkp@intel.com/
v3:
New patch

 drivers/net/ethernet/cadence/macb.h      | 2 +-
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index c1fc91c97cee..b6c5ecbd572c 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1363,7 +1363,7 @@ static inline bool macb_is_gem(struct macb *bp)
 
 static inline bool gem_has_ptp(struct macb *bp)
 {
-	return !!(bp->caps & MACB_CAPS_GEM_HAS_PTP);
+	return (IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) && (!!(bp->caps & MACB_CAPS_GEM_HAS_PTP)));
 }
 
 /**
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index f77bd1223c8f..eab2d41fa571 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3889,17 +3889,17 @@ static void macb_configure_caps(struct macb *bp,
 		dcfg = gem_readl(bp, DCFG2);
 		if ((dcfg & (GEM_BIT(RX_PKT_BUFF) | GEM_BIT(TX_PKT_BUFF))) == 0)
 			bp->caps |= MACB_CAPS_FIFO_MODE;
-#ifdef CONFIG_MACB_USE_HWSTAMP
 		if (gem_has_ptp(bp)) {
 			if (!GEM_BFEXT(TSU, gem_readl(bp, DCFG5)))
 				dev_err(&bp->pdev->dev,
 					"GEM doesn't support hardware ptp.\n");
 			else {
+#ifdef CONFIG_MACB_USE_HWSTAMP
 				bp->hw_dma_cap |= HW_DMA_CAP_PTP;
 				bp->ptp_info = &gem_ptp_info;
+#endif
 			}
 		}
-#endif
 	}
 
 	dev_dbg(&bp->pdev->dev, "Cadence caps 0x%08x\n", bp->caps);
-- 
2.17.1

