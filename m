Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7046DDAFD
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjDKMhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjDKMhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:37:31 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCAD49C9;
        Tue, 11 Apr 2023 05:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEhwIYKkixFFzrRXyvLxgiFbuqjDPA1Oi2AFkaT6lmTv3wESqtSb5O322iAOtyglG9JrmvTpk6FXp9uD+aRLXmP2/4DF4VTJyFi/D7inkIBs8j9RfAaJhBYMunh91unJ1quHYnELstWVds4FUAOyOpkkh3J7E5XB7DWw1xo1VNQF9HCw9KE83CA2LbDtVz/3CiHJhIOoKbnFkadEIDxdd6u3kXoTpB7V+LjL4k0oNVNK15DWkfwiAD2sPpVoJSEu27FfWWsdu3otNUJ0LkVv0J4K00apXpS3h7uT0lxFqlnni5pc8uu9ZnfAO23/Fod0YZ6M1v5yfeTz3GGTN3PjOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XR5H+zetU8Qj5jKRJfHbo6rDiAB+edNxl0vk75tLFvE=;
 b=D43pwKe9vzGFm4V0iQ2rpzmw7lvih/xZcPQaGu3SBdRfU5Yg0zQ4r15/uQeHeniEBqKJj5d0V0cJmCAZgw7CDRriQQpfMREeSwYS55KZ1/BzVqpKijcKAi0s1FCiDWJqMUEX1tq7vxOcbFf0yKUjZgFBuw3UG2eGll/r2WDuHD9vlDqhQCbykUOqpMjhvUap5yVBovbnY4n5Fw+W8+g/aveahSHA4uaAdoYncUv46yTX2yv/FJy5hLp4/z68AaMgHnTA56V2ZcrM/INllMDN3HaF7oUepF4quHTwHmE1QreMvDZfsMAfZXOd1OYU9/cwG5Ju9TNDIlueqYNlcB0Fmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XR5H+zetU8Qj5jKRJfHbo6rDiAB+edNxl0vk75tLFvE=;
 b=GieAJakEtJid9VdZIzU7nUNSHJWTvcPAUd82eMlrHWyO7VG7OoAaY7vGYjggQrXqt7R4LLEjs160VXV7+BqhVtX7KcTxIMR2e/d3uGLpPR2f6LG6ovYldVBtuuMZV+Jyo5GYA6HpvEklkkQw7EHtCDSPE0gzYyWammAU/8aNUmE=
Received: from DS7PR03CA0285.namprd03.prod.outlook.com (2603:10b6:5:3ad::20)
 by DS7PR12MB8081.namprd12.prod.outlook.com (2603:10b6:8:e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 11 Apr
 2023 12:37:26 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::d0) by DS7PR03CA0285.outlook.office365.com
 (2603:10b6:5:3ad::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28 via Frontend
 Transport; Tue, 11 Apr 2023 12:37:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.28 via Frontend Transport; Tue, 11 Apr 2023 12:37:26 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:37:25 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 07:37:22 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v5 1/3] net: macb: Update gem PTP support check
Date:   Tue, 11 Apr 2023 18:07:10 +0530
Message-ID: <20230411123712.11459-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230411123712.11459-1-harini.katakam@amd.com>
References: <20230411123712.11459-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT059:EE_|DS7PR12MB8081:EE_
X-MS-Office365-Filtering-Correlation-Id: 54631ce0-aead-4d2e-8879-08db3a8981e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TC3eYmdP7Gp5F9nwmG0OKq/Hc3EOwAEeW5eUcnncCR/FJVF6ycz/1ogfEGC8kbWUTNk1XAUiRoBvxFy7tCbq+ujvEX0cHxsH0Ekz5DGv4UxswzdA0y/oOpp9ndbSSufp4/4bVvW+m65Io5LsGciuPV3IxzfQxVgh8WZ9RiDfVAbBBgBEwlNNTBQPC97LuHJ4L6INj8MWOl4okePhkLblyhTSncZZv/5kO1x0xKf3yFQ1mulMALnyRca2nAcXIEBSalOsoTSdLMjB4eEOisRu5iU1kkcFxSo6bFXUvYLiTULQWA8byVSAQB6u9uxkxof1mFT/kAZIxt76MySTAakdG6A40ptSlMEhog10Q4BieU0hn26xcYRZDUhSRoLKMyyR39h9ITHKcrh/2/7Ir7Fl/1Njm5XojrCXvZbExnBJ+ov4FQTLAJg7zenXA/hxVmpe/UGXwABE51sLJfpl7YZgX2bkXQDyNaF8LOYjF1xWg0UpXKQkF6SzpV5Htf1krKnbx7OEhb1vuQcSjOAG2RnO4eBvIk0Smqj2mMB4yCTcChC+eW2JEYen68Ki+7nZiZqbjtQNLlwhuJLLRp83miXz8UUoVVy3LwJpR6EjcIRjTjcCVfJPkiPY6WTQw5c/VjVDmhs5iAW8g4TRpC0f07ZbZhi2On3smNvSV0lHWPZk8z6TG43Q5yIVTC8KnLdYmiXSLMhqWJ+la8hEnxGMyoSL+Omg0ICvP1gbSAA8T5b+awk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199021)(40470700004)(36840700001)(46966006)(86362001)(356005)(82740400003)(81166007)(36860700001)(40480700001)(36756003)(82310400005)(2906002)(40460700003)(966005)(6666004)(1076003)(70586007)(4326008)(41300700001)(8676002)(54906003)(7416002)(70206006)(478600001)(44832011)(5660300002)(8936002)(83380400001)(47076005)(110136005)(316002)(26005)(2616005)(186003)(336012)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:37:26.6706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54631ce0-aead-4d2e-8879-08db3a8981e8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8081
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
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
v5:
Remove unnecessary braces and !!
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
index c1fc91c97cee..07560803aa26 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1363,7 +1363,7 @@ static inline bool macb_is_gem(struct macb *bp)
 
 static inline bool gem_has_ptp(struct macb *bp)
 {
-	return !!(bp->caps & MACB_CAPS_GEM_HAS_PTP);
+	return IS_ENABLED(CONFIG_MACB_USE_HWSTAMP) && (bp->caps & MACB_CAPS_GEM_HAS_PTP);
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

