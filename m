Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8F469C929
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 12:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjBTLCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 06:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjBTLCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 06:02:15 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7B813DCE;
        Mon, 20 Feb 2023 03:02:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AP3KDSN0YTgElTamkfeiQ5AMZS7rJhBkWVXAQhGLny9vbXg3PyXXQOVeyN+x1D/YvVlwmSL+eMpMJ2JUGNS6qG0ZutSa/ihnMLv8BP45NS3jLvPgHc13CA1Myhln2BMsMIBsY/F1K2DEY1Vv1MzCG3DPC4f0eZnrj8fuLILkjETu/bG9fFq/KvdruYQVj3+9Z3XBBmSP0UGNSF+GsA85SA2evHeLqUL4p6Sc+Lu4hvb3qa7DVqkGEsGlyZXEASeGvVSgR7g32X+jbUTbgQaa7BQmdU4VRSuNfjl1hgRlLRNcx1gfkoPi3+WRfzgAPPju0Wl7JooTHj4HqUjNe+TtuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EW7xrii3HEtJeiSjbDaqVaf4KWtSec1OjJOb9beydWI=;
 b=k3JBpUVq+eP52yAuUFwYgZfBnt3JSUjc3xLYV3dkJlM8oeRjwlHUQKHVbXywKe+YHwXZWSxzLEqEZNfqb64OoZ6xHFTix/yY5pTAdniUwJaMqf6B2jYvx0RzP6z9vf207YQhrG8Y00qbitnTrZtX1pXghaH596oQJZupkHaHciYKPcj45ZLdYOWBv0oZTYH1obOw3U4R9fd4LRGngrWN5JNDgBnw3FGAYjDc0rTaFgrcXXYkNPgNpWnMRxAXMKGCFQYPLgzwGjHf8Iyjw6XV9KjZ2zT5mAd4imY3LlUWquJIGiI+BIbK1bk3m7y8qFixnBcMvllfB/P24BfNKm81Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW7xrii3HEtJeiSjbDaqVaf4KWtSec1OjJOb9beydWI=;
 b=Sp+YJY3+izt7rz8Jw1WzMxUKrDAh5ARmRr3pzAxWMA0xwAPcpRQRg3bVab21L/bb8QqzKrcwccMrS99A3baezLuwmMLwq7wPruLmZoiDPqZIamie8dufcia46bjlbQPgGYan7qY+vaCD6ipBomXMqrreFtNO3fsPsj4aH5xaJpc=
Received: from MW2PR2101CA0015.namprd21.prod.outlook.com (2603:10b6:302:1::28)
 by DM8PR12MB5416.namprd12.prod.outlook.com (2603:10b6:8:28::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 11:02:11 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::1) by MW2PR2101CA0015.outlook.office365.com
 (2603:10b6:302:1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.4 via Frontend
 Transport; Mon, 20 Feb 2023 11:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.19 via Frontend Transport; Mon, 20 Feb 2023 11:02:10 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 05:01:42 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 03:01:42 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 20 Feb 2023 05:01:40 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next] sfc: fix builds without CONFIG_RTC_LIB
Date:   Mon, 20 Feb 2023 11:01:33 +0000
Message-ID: <20230220110133.29645-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT057:EE_|DM8PR12MB5416:EE_
X-MS-Office365-Filtering-Correlation-Id: e0ba1e25-a087-4f8e-ae68-08db1331ea5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k44YfcyPzgzLywtE6NxWCfSD+FVk2QS8mO+s8D8liPpNgUJ8SDiH7vj0ihwiSd/CWcXs29SWutMowJE3hq42TbMXXEozOuYQuz1X6c5dxGhO8RfXOb62bM2xS4My+Q36PrxrjNRn9IM7u4q45O1tx+01Z3SHbrGeX+W/gmfNp3XDiEw7htnaLkvhEIimnmBYb1dLOOs89Bod16WtSGVO9WVKUURyzyg1KKVaYXIgNP4gXOoDbzngvoZwCB2fw6jqP/J+kUqXUJkiq1Z1SNL1WU84JyGr8vUQhsbcHEdkZLfmdfHZ/WuELV0Aod0/fLHkAja4hj0fPKS1u+f2jaVnLRjqyKYpZLrwpbTq3ESDFN2u2jACGRSPpiu0M0BgU49Ny+YCn1iDmO4kb1MwrDFCjh76i37vQr24GwQsEYcJkGIGxoSE73+mn/PwGfMymMt3IjAl2wnhnfF8wjIevTeD/640E9y8hUquM/B2piJe4ETvzGNyaJi39XrFF7NRxx5MAm+tH9ZLSYp0WHmJyFHMeUxgdzOaxEH1kG4/yKwaEYQIz1Fds1dXJWBgNB5yGw/4h4rM7E46c3dgJGzNbZ80rQDWfqtfHtXmEUi4CTzGp+aj0vM2tWmQdb6KB/bMEPTmE94VK6oO2h8mR4AR0E7J7D5MVocN5Vf9tp3whxFEsoRGEgtwWYGtA0sShbc05O3jIbDhEuz9qPKfiV8qGfDqDwuxiyWkMwtUgHUQMxIr9fM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(54906003)(70586007)(110136005)(316002)(6636002)(4326008)(41300700001)(8936002)(83380400001)(70206006)(6666004)(8676002)(2616005)(1076003)(426003)(186003)(26005)(47076005)(40480700001)(478600001)(966005)(336012)(356005)(36756003)(82310400005)(86362001)(2906002)(2876002)(82740400003)(7416002)(5660300002)(36860700001)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 11:02:10.7818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0ba1e25-a087-4f8e-ae68-08db1331ea5d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5416
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Add an embarrassingly missed semicolon plus and embarrassingly missed
parenthesis breaking kernel building when CONFIG_RTC_LIB is not set
like the one reported with ia64 config.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202302170047.EjCPizu3-lkp@intel.com/
Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index d2eb6712ba35..c829362ca99f 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -323,7 +323,7 @@ static void efx_devlink_info_running_v2(struct efx_nic *efx,
 				    GET_VERSION_V2_OUT_SUCFW_BUILD_DATE);
 		rtc_time64_to_tm(tstamp, &build_date);
 #else
-		memset(&build_date, 0, sizeof(build_date)
+		memset(&build_date, 0, sizeof(build_date));
 #endif
 		build_id = MCDI_DWORD(outbuf, GET_VERSION_V2_OUT_SUCFW_CHIP_ID);
 
-- 
2.17.1

