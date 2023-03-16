Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36776BC920
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjCPIbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCPIbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:31:16 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA58FE381;
        Thu, 16 Mar 2023 01:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG2D+wa1jTKsvTwY0Kj1zPB51gjsuHx4AjtVQXH/xSn38ukzF81ybwI564swswUiu+zK2nLsZRm91eKXBORaZYVfEwx8RXFyuCmEcJpiGq6rV58cdjVhlDTDLPQGn7/ljWhecgu19oWum8QYzuyVpFditUIpGBJS+kf4D8PRt2hakC4gI1JvosmJrJUvmikNxx4jf1RuSeA0S1ENJ2jw6gP1t12Y1Jh9nnnlQ8h9BsTS4akGn2BvdIUcrcofmFYgX3b1lyby7VJ5bNSvJt4fYLiXMccTSTEiOyeOkF0sq43C+XPpbs+bkUnL38r/edXdBWHEdRDmBN0i83i3SzsBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nm+4cAl9fMY65eit/A7yIyWP/zKW5gko2ljpIWb6AXA=;
 b=TN+40f632435tWXtADacB9v21aWEt3osHTBCqwqcY0DRX15TwPY8lK8XJdT5E8TlhxSHHfXbzJt56PV9EYr3py6VZ7x8HHXQgynHk2rII7X1TUCVhCxQ8GUhdb2hrvUtnIF70e9qtiG30+bGG3cmHzrtc6THYaW59i9pWBiLQ8ycxwcKnZvNXcyH/tbAIWRK/O9qTno+qR704J3rW1kyUglMQlsetQoLdQ4fucE41Wv/NriCi+Lu9k/JLjZsV3ly/FU2GomCo5f57UC9zgT28q1t9Z91Y2OW0DJVW0L9iRghspKtd8EqvxYjiF3JtDVOPfrQDZVzA2m/eVOUHEenSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm+4cAl9fMY65eit/A7yIyWP/zKW5gko2ljpIWb6AXA=;
 b=uK2hFv/Zf8wKDdzmZRQ67MUQ9EgbSNwQ/JfJLr20bDB88iDSgR5GUW72ezootjdSpFW41PzKO9mwfiy+AUC0qFmbfpxXnCmp/TGe16B0FcDmjX3b1KRRH96fO4ZZq0u1u6RlW9eVs4Bh9flHWmDJdA6RFM40bdoE1AVeaASdveI=
Received: from CY8PR12CA0001.namprd12.prod.outlook.com (2603:10b6:930:4e::24)
 by SN7PR12MB7855.namprd12.prod.outlook.com (2603:10b6:806:343::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 08:30:55 +0000
Received: from CY4PEPF0000B8ED.namprd05.prod.outlook.com
 (2603:10b6:930:4e:cafe::2) by CY8PR12CA0001.outlook.office365.com
 (2603:10b6:930:4e::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30 via Frontend
 Transport; Thu, 16 Mar 2023 08:30:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8ED.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.7 via Frontend Transport; Thu, 16 Mar 2023 08:30:55 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 16 Mar
 2023 03:30:54 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 16 Mar
 2023 01:30:54 -0700
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Thu, 16 Mar 2023 03:30:51 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next] net: macb: Increase halt timeout to accommodate 10Mbps link
Date:   Thu, 16 Mar 2023 14:00:50 +0530
Message-ID: <20230316083050.2108-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8ED:EE_|SN7PR12MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f3004da-abee-4ebc-77fb-08db25f8c2fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c3RgXAoB2sHY+5AFDXj6n+KuFfy+DRsdGB5MbAN8Wnqy2yOsV+ljflChlxxuEoQTIuFdg8+ATvKT/s5hRsd1tbMt1Z3reB7LzRdfLEIlwBbjGQGXuO8567QQtIOanPuoK3QKOwJXmoLPRH8PAHNCzM8h5bjE2X99zvT7K5hjddRHoEi//fpByRh0WNqa8inQ6FSGIlIuhqY58Zaq+qUocOw4fR8gkLTYxWrO/6JmRq2IcXVIEgGQ3NXkXi94FPfs1G8dmGQcYhKm/Bu7wU45JxZyYQZv0vdfOfV4Y9V+/ORRBCbviYFN0eWPqKXk4Uk2KSI/guLzJYBcD7cY3X2d7EnDKvi+B42lw/neRM3rAiXnjf90mNTMUGv0GYyBGgl2DzQ/lEJRb0Ca2+hq+9TDTbtc1pqnGysEHDbL3mxNlS/iNGwCbJlC3DiHyjvHDiXmrDIDSxpyFDFpd5mcMes+MBzqz3Wd1G6YiEUTx8vLMtUqQXbOVaQz9QCcn9J5vUDrSz63sM9o/nhnAPs17n23ztboUVfwCzCO0/eY44U9ypGCUtHFyUR949xeA72wu09UEcdM6EQJX0R7YQMymD2B+xxhj6hcehytx0AyFcnt+vsbPncZoAG2fWnvE4eJLQR1q7BS7Bp7XA4xtiFW4B94xlDJGK+UOXmSkN7ip6zr6ZkVJYFyEwnKxj2lhYZ926iwJ0y/QkUo9jN69HmTvvco/xgaj9QwS8iiMjO/MYKrbL4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199018)(46966006)(40470700004)(36840700001)(83380400001)(336012)(82310400005)(2616005)(426003)(44832011)(47076005)(186003)(36860700001)(5660300002)(70206006)(8676002)(70586007)(4744005)(41300700001)(81166007)(2906002)(40460700003)(82740400003)(36756003)(1076003)(26005)(8936002)(478600001)(54906003)(4326008)(356005)(86362001)(40480700001)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 08:30:55.5628
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3004da-abee-4ebc-77fb-08db25f8c2fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8ED.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7855
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

Increase halt timeout to accommodate for 16K SRAM at 10Mbps rounded.

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 51c9fd6f68a4..96fd2aa9ee90 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -94,8 +94,7 @@ struct sifive_fu540_macb_mgmt {
 /* Graceful stop timeouts in us. We should allow up to
  * 1 frame time (10 Mbits/s, full-duplex, ignoring collisions)
  */
-#define MACB_HALT_TIMEOUT	1230
-
+#define MACB_HALT_TIMEOUT	14000
 #define MACB_PM_TIMEOUT  100 /* ms */
 
 #define MACB_MDIO_TIMEOUT	1000000 /* in usecs */
-- 
2.17.1

