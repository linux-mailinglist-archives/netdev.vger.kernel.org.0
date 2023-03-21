Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458DF6C31E2
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCUMkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCUMkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:40:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE99C14A;
        Tue, 21 Mar 2023 05:40:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gy63QcAhDjXWZ0SeHPT5ZVXOGhhSddBJqZkZOS72KQb2EdogwkPO5/hbJIk2E9bmuTKGY+39aF8uRybcJkRjLYYPTf9V9izxX5mqFg6gvNhfx7g2rQFmuJT70dW4Bc+FQpj8x/nzfQugDvj1hlactbYCzvYqDJfSac3M8dzHPMN+rPPd4D9bAo2mBFRDzzQwgeclAeCgIsoO7FSrV8DO6DgkYi608CM4/ZIUWU2Vzf7v4ZybVchgYyCm0yYOEof3+AJIKr5Vyt2fdjYhHNGAJh86+aIkQ5+HCcXDYh4MYAWpbQ4/dUyteFe65Ce0Mzu+xkZPMfWRTJ+n+kTIq7Limg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6WEEhg49v3+3iROgDmHgjFTD2ZPMS3r+TroKLngfkCs=;
 b=a9td65NlV8FVmS2z+cbPQ4P83Z65apPfRCBf4Y/wz3GpERh7rEYTpepsbI8Zi0VlHhbMOJJS02L05rj7wM1wk0zbsz38JkWKCb9RPR1XQKbjvDQ/S0lzL1leXatYXXl+uyvNU3ZIFYgjwsaw4RI6L4pB4EtnwFWroZzmJrC4cvYXZA4Di17UQCr4aW6QdaDatdlsj+eORc0npHTsOpYdmfLfEDyaS7uDAcWw7Z6PdaVYn2nZ82beUhnpvkRLgty5T5dOWuQv/IcCiEdW1RJBNkyUHIn00ia253n9RsXN7AYri8jEeQHr2EhHZ1pZiwyvWXH9K5UeWyNAr+ecMzYKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6WEEhg49v3+3iROgDmHgjFTD2ZPMS3r+TroKLngfkCs=;
 b=ZXf/JO8ygcoS/veWM+0To8pdVwQz1aX0h/pEB8u22DySVXpmIQGxp5tto2Q0Hsn1JIjmJzCfOQl+sOt57ZILcvY6XAh+gnhW2LtDYOCITSyDIFIWvz/ddltx/LT7rBEKHE3KI6y3dnrO/UoISOwhjSnZviHJgemhyYPaqDBpY/s=
Received: from CY5PR14CA0021.namprd14.prod.outlook.com (2603:10b6:930:2::28)
 by SJ0PR12MB7033.namprd12.prod.outlook.com (2603:10b6:a03:448::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 12:40:18 +0000
Received: from CY4PEPF0000C97B.namprd02.prod.outlook.com
 (2603:10b6:930:2:cafe::e5) by CY5PR14CA0021.outlook.office365.com
 (2603:10b6:930:2::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 12:40:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000C97B.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Tue, 21 Mar 2023 12:40:17 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 21 Mar
 2023 07:40:16 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 21 Mar 2023 07:40:13 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v2 2/2] net: macb: Optimize reading HW timestamp
Date:   Tue, 21 Mar 2023 18:10:05 +0530
Message-ID: <20230321124005.7014-3-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230321124005.7014-1-harini.katakam@amd.com>
References: <20230321124005.7014-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C97B:EE_|SJ0PR12MB7033:EE_
X-MS-Office365-Filtering-Correlation-Id: fd5031a2-9b6c-4d06-7dd7-08db2a096d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bd8hrincujUyR3I5LF1OxxwduC8PbR5bfzlOJT/e9d2jlj7jMFVR2MUEidmvaRhbzWIlz0Rv4ZZf0xXb83GcYqLjVq/UxhxlvEILX+oYsm65Ifd/sPYN0f9rnAXZolmPzw20zgRgvE1VA0kN2782p5P1W1mgod1utmEceZaSzLPOrsx8FHAR/+QgMHDNipL1h45bh43gYSWxe3E7OycIkOMUJzJ+tatCu5T8g7Qmg2gtsbU/QS9kdCVD6ligM0jEQkNfSR4k0sJhaaXVwp35E7ynNriNcgtSIf84NZ7zQ10LgNgBtYxKjJ8Zu7XyJpvudvJNw9tM3Vidwonrpr7+bqFUbO54jQC8rNrc4YJ1I11u0CRVzTF8yzP8wXu/yjvrmkghh3cY4SRoxtFmWssZ9ZyR4j/Cj6zOw7VRB8bThS5AxvTAhD+3ZHvzPUsQf2aTlaI3bjGVK2mJsR072LVJu+eMLEgnIONALOT8NQGeLzADCrI9/0SF1zYxWTpSOKDABAR8YEzFqjEONCNvirN8D1J8cywC1a4Ig9m2MecNwcgHeZkZzmAn4BrEFxz3XKw5JemMY+i32hvnknyjognTwGDLNjva0xIqqirCYdIh0UKXgvaAiusTSFr6JWLTuyX6nMERl4jQMUpFMF27QvKu+P27OihhP5k3ZyAna67TwGNoLZj2srvOBpR3QO1ilQ1g2euRIaOONaqg/wE+gkxHIe67cSyY0h13qBvG/7Waixs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199018)(46966006)(36840700001)(40470700004)(86362001)(26005)(478600001)(316002)(82310400005)(110136005)(54906003)(356005)(8676002)(70586007)(186003)(6666004)(70206006)(1076003)(41300700001)(4326008)(81166007)(82740400003)(40480700001)(5660300002)(7416002)(40460700003)(36756003)(44832011)(8936002)(2616005)(2906002)(36860700001)(336012)(426003)(83380400001)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 12:40:17.5488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd5031a2-9b6c-4d06-7dd7-08db2a096d1a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C97B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7033
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

The seconds input from BD (6 bits) just needs to be ORed with the
upper bits from timer in this function. Avoid addition operation
every single time. Seconds rollover handling is left untouched.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
v2:
- Update HW timestamp logic to remove sec_rollover variable as per
Cladiu's comment
- Remove Richard Cochran's ACK on original patch as the patch changed

 drivers/net/ethernet/cadence/macb_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
index e6cb20aaa76a..f9db4501b995 100644
--- a/drivers/net/ethernet/cadence/macb_ptp.c
+++ b/drivers/net/ethernet/cadence/macb_ptp.c
@@ -258,6 +258,8 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	 */
 	gem_tsu_get_time(&bp->ptp_clock_info, &tsu, NULL);
 
+	ts->tv_sec |= ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
+
 	/* If the top bit is set in the timestamp,
 	 * but not in 1588 timer, it has rolled over,
 	 * so subtract max size
@@ -266,8 +268,6 @@ static int gem_hw_timestamp(struct macb *bp, u32 dma_desc_ts_1,
 	    !(tsu.tv_sec & (GEM_DMA_SEC_TOP >> 1)))
 		ts->tv_sec -= GEM_DMA_SEC_TOP;
 
-	ts->tv_sec += ((~GEM_DMA_SEC_MASK) & tsu.tv_sec);
-
 	return 0;
 }
 
-- 
2.17.1

