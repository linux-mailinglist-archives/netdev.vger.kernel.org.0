Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286006EF26C
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240543AbjDZKnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240520AbjDZKnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:43:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C497CC3;
        Wed, 26 Apr 2023 03:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLwE5/3EJzolvrobiWYjCOklw32mUVzkEZ5OaTrszcfmFTFltm2xyVwTaf7VlJNEk31V6FCABZD0LhGi24aJziQKFq9uMojvxENUgUcX4tGh0zrU0XuiDEjbQD5kB7ADnsMkaEjwfV8sRfKekA8Q/wDbF79URjLVFPhAaRMSqNsu/VZ+R0MW+3yEQ/tTEaqM3hMQ9AASXm0ic2DEeL1eYY/YSQvKVKapaPj9T/Qlw94y3d3vJx3LMNJWDiKNxYC1EpCCuy9ljIFlrQ8Ap0BUiqZx5OCigUVIHxChhc9hzCWbcvFipgvpgWw+4nw4RF2Id/RzGfcjz9Kqn5gJ6/ozug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQL404UFTNRUQBSuX8SLLI1nflcqMJ5lhOvYMeMR1m8=;
 b=HZFPM/CVHhf2Af9de6OR/ReTG2UlAMk/8tNbxH4CmGnfL1DjfTlFfcey3s27li3dGP1IKVFWIrpQkMKZq5vPSmJl1EcJd7mVCdnLF6JQ3aeEtvUNbDvA3uSRKlYaE19FO7OviCoVAHSt+JRWggDGOSV4EHEbCiZYIGwAUXQk7XfxmwGkHmSnQTkumLVBMyfuo7r93IcfILp6uZZ0VnOhAqGI6Gc5pZ1w9stnHelfaGVoPoxrxK1qkvoc+wF1uDL03/IttKUQdhkaPmSR4ki88o7FXQ3udSyhjeQjQ0SRfPaiG+KQM4CwBxO7hYD0W7Rh1VOLaVz0brfBqTf6KRerSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQL404UFTNRUQBSuX8SLLI1nflcqMJ5lhOvYMeMR1m8=;
 b=S3oXWdsqjh/mDTmyEqIT6J5CnVycm6vE5HtxMf0Rw+WzmsiM4G70osgXUdBox1ZILdFNd01RVdZsnzBZG9Hk0Pi8Wnf//5+syUrV6xuBAL7U9ZXHMBzVwE+0dvamY93fyyn+I2ncJG2AWqKKlUA0g2kN15qxYpASVbYj4/S0xjc=
Received: from MW4P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::23)
 by PH0PR12MB5646.namprd12.prod.outlook.com (2603:10b6:510:143::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 10:43:25 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::a9) by MW4P222CA0018.outlook.office365.com
 (2603:10b6:303:114::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34 via Frontend
 Transport; Wed, 26 Apr 2023 10:43:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Wed, 26 Apr 2023 10:43:24 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 26 Apr
 2023 05:43:23 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 26 Apr 2023 05:43:19 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <robh+dt@kernel.org>, <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <vladimir.oltean@nxp.com>, <wsa+renesas@sang-engineering.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <harinikatakamlinux@gmail.com>,
        <michal.simek@amd.com>, <harini.katakam@amd.com>,
        <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next v2 1/3] phy: mscc: Use PHY_ID_MATCH_VENDOR to minimize PHY ID table
Date:   Wed, 26 Apr 2023 16:13:11 +0530
Message-ID: <20230426104313.28950-2-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230426104313.28950-1-harini.katakam@amd.com>
References: <20230426104313.28950-1-harini.katakam@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT060:EE_|PH0PR12MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: e2fe37ce-5dab-4272-37ae-08db4643100e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYUArBB40H9xOdYmsj9wV+nlja1GyiOvqEl87fOKfLXq0clQIjVM0D41t0NTaESDXsQxXeV3ZqwOVylWVW7Xt49wwKRxi+wm5HhwJnrR+loX19hVD6DneuH4+WgtVcP4SXUHl/fkcKyAGvIFI00V5Y80NlbDUyMi93klwe+cFkWDSTsyc+U209A+XY5KFHFKpAd05I2C+fEqhHt5U/G8FEaq5Z2Nxi1WxzNhppr98yAsglj8x626TZbcuQbgbHf1t0RFQwEbIGKO3mFSRV108cpFTKsjIo4tngbr9Yor/7+JJqIM9wamZzEiux07JPdZxrD3EkqWFf3zO25MliXFevOBNA8KB9w9O0qGBysoARZ1tYxYwbfyH4tBOgBHfYxrm4enH6g43PjsY8mb9tVmzMik1ItWEiPLh9mADiNy/pIUlsRbWDN33oRCNNXsUq//KzgFdsf/PmhD1ZG0CLvL5ib+GZl4EkCr6jJ2jaPa7J71D1A0f778dnQWk/l6yQp3cRZM7GM8MGz10X6t0lnwZ4CjVDiqGWl+oCPtm8bxEJbTvg/MhlkoGb7PatuhBA19D5DDHKNub9AMtmVkUYrcDh6cacXRLiOxjQob3AvDTKuU0r9iaDwwMmVt11ACzx5sbduh9Dbb2LegfC6S90usdCSwagArM40dG3RVXlzjsFU0Mq6iLCIq7XHlB9JciBhu9JZl0MXsp0X+vVdo1UeJnUhqrpd1uIZGsuOX7ofGOfSf+ibvbJ0i71AJ7bpoW6HQ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(36756003)(86362001)(40480700001)(81166007)(921005)(356005)(82740400003)(83380400001)(36860700001)(47076005)(316002)(82310400005)(426003)(26005)(1076003)(186003)(54906003)(478600001)(6666004)(110136005)(44832011)(336012)(70206006)(70586007)(8936002)(4326008)(8676002)(5660300002)(7416002)(2906002)(41300700001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 10:43:24.7615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2fe37ce-5dab-4272-37ae-08db4643100e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5646
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the PHY devices variants specified have the same mask and
hence can be simplified to one vendor look up for 0xfffffff0.
Any individual config can be identified by PHY_ID_MATCH_EXACT
in the respective structure.

Signed-off-by: Harini Katakam <harini.katakam@amd.com>
---
v2:
New patch

 drivers/net/phy/mscc/mscc_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 62bf99e45af1..75d9582e5784 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2656,19 +2656,7 @@ static struct phy_driver vsc85xx_driver[] = {
 module_phy_driver(vsc85xx_driver);
 
 static struct mdio_device_id __maybe_unused vsc85xx_tbl[] = {
-	{ PHY_ID_VSC8504, 0xfffffff0, },
-	{ PHY_ID_VSC8514, 0xfffffff0, },
-	{ PHY_ID_VSC8530, 0xfffffff0, },
-	{ PHY_ID_VSC8531, 0xfffffff0, },
-	{ PHY_ID_VSC8540, 0xfffffff0, },
-	{ PHY_ID_VSC8541, 0xfffffff0, },
-	{ PHY_ID_VSC8552, 0xfffffff0, },
-	{ PHY_ID_VSC856X, 0xfffffff0, },
-	{ PHY_ID_VSC8572, 0xfffffff0, },
-	{ PHY_ID_VSC8574, 0xfffffff0, },
-	{ PHY_ID_VSC8575, 0xfffffff0, },
-	{ PHY_ID_VSC8582, 0xfffffff0, },
-	{ PHY_ID_VSC8584, 0xfffffff0, },
+	{ PHY_ID_MATCH_VENDOR(0xfffffff0) },
 	{ }
 };
 
-- 
2.17.1

