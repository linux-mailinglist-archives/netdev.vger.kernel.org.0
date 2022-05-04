Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5080551994C
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 10:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244221AbiEDINo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 04:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346071AbiEDINm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 04:13:42 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733982251E
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 01:10:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=no/deLKou7IQWUuYcd1wDpY3T8JLaxB5RXxnNX77qlgBrW0hCWDGya3unmxWJw8FbToSZPinV2iYsG0EQ0v4g/wm09/JxiBl5wUrz/dkKn7VHL/i9gc8bid47mSn+2kMCU3TEk6d9fGjZFhj3qIR3nTHlaZDH/FWtuAMHL5bnKO+rAdGiN+UATulPFCZJJZ7iVO/sqSDfr50tAQ/EN84UmbAiRH7amGqCvO8gH6LMA8zEyy6PiUTPNGHS3bflz7I6cJO+idvlblK7zPJc+rpq6GIEXPx1Tg37ve9zFEe6/dpBzcrVRHz/oMSGGP/R+pCKwQa1vpnzYHo99gA9Szw6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QszXCAhu0UqrjOF92VgdV0YqiyIxpzBJLppq9uKU0Hg=;
 b=CiLRlqYLxc/Sx8Foi4ZHEK6bWoxM8ORVQ4G98WTzKrcmF5GyxeS59elcjze3pNHDw0+ad83svryWSoP7LHSPxxDNDE6Bv1RzhZzoBVGzjUaHLm+6q8IWr8t6MRgUeA+Cw1jOzobQeOm+dYgMKdF0dS5oZ8OzGaj/q3N0vIWhUDC7pfPtqX849qeGKkctidmcg1PIiFPU2G5PtBdqfCpMWpwqxwQGiDygdiratYKOkUpHBKbcf1yE6+nRczksa16AUHcPfwK8QJaDforpXfT1m3rpVAEVeEPFgcgjLPzJ4Bk4UL+2kqG/GCL60lEYkJo8Vwh92VDhqHKxqco0b38Qgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QszXCAhu0UqrjOF92VgdV0YqiyIxpzBJLppq9uKU0Hg=;
 b=BQi/HIa9KYkN9uXjV9ZMz+8qZ5r0TljyVjZvH8XCu76X+WU9mxVTDUmqqfQhF2vxevXBcHsHzU2Eb9AcMEFdQv1chhzjt1f/1/dgNLlJFYpW8LAbMMedecfWC6w0w7xGTwiVS5cPx31iBW/lFpNX17BKI4SrHPayP/8D/MRyOPu7Jo1rGexmu3dd9SjYqFhDkOpwMEUILs58FCkgrIIKMZJpzUOHrpwkuCKrZ7Vv8smv4A0YBy7lGOFdrEqjnHWrVpHw9wksY9YGrGHMZPH4tn5yewaEO5XajT011p3sfDuym39fqoEO+ozJwD9CtgMHErmXkDjHb21UUib2wYO5bw==
Received: from DM6PR13CA0059.namprd13.prod.outlook.com (2603:10b6:5:134::36)
 by MN2PR12MB3455.namprd12.prod.outlook.com (2603:10b6:208:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.23; Wed, 4 May
 2022 08:10:02 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::18) by DM6PR13CA0059.outlook.office365.com
 (2603:10b6:5:134::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.13 via Frontend
 Transport; Wed, 4 May 2022 08:10:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Wed, 4 May 2022 08:10:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 4 May 2022 08:09:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 4 May 2022 01:09:59 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 4 May 2022 01:09:58 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH net] net: Fix features skip in for_each_netdev_feature()
Date:   Wed, 4 May 2022 11:09:14 +0300
Message-ID: <20220504080914.1918-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65e18d2e-54d6-4fa6-ef93-08da2da57ca5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3455:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB345566882AB5EEF681C1D2EEA3C39@MN2PR12MB3455.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0uE0CLYdNtGb93ksdvu+NBsFr9EMa2m7t7nTtbpd5LYyns58yuf69axuxflgYkTBTjsYTWbJ0NzkPxLtRNlOsBEEPeciJhxghSbHMnKE0Xly05aZiezAfMLQRrO5D99FInKcN+jF4KPPrJl0lOCjOC2RK7/CCnw86XaYkH/ENo8G97GSFfxoohD6bygvZ84KwmLH+wZ9A1eSM/TfgVz4iCnoYr9Iq9a17nZtdUamXcYD6WxFtlw3K67QfbdevttnEb0Buim6+AMa5ya3w1qSE1NhjHx7B91444bCqE0Biwoh9m/xLTjH6B7067KN8PFCui/QJaHN0T68VggiOHFPgZXXCkxLAj4W5g03bXCJcf3FEdX9C512Tsmf2SomwjVEPMRNI3by5aLAsYnKqDttBBrFqLg2BK3/sFrs6UpjKVVFhjjKWYHK45cazZDO3OGRpFBi9ZhdZ8tiKqRGFVBQsfYbkCmA7E+Mqdk36t5kQlyhRwDRFJYg7PeO4zIEMTxyxOpSZj2J1FaH8UbVfUIkVsZA/2lM3MhfoRkzHsFTXEfXgoV05+Qxfd/tdLC8bIuzNyHNB8P8/2QOYzeZonukfu8VKQqbwC8Wl3Yc7fa5//NPr0ab0li6erSup94Ex9anHZFFWbFyOC3HPneqOr0FoGXTqpXFIy9d7zMVxNyGCbCCT9+cMc1OO5El58XYLzpWDDkaIDywQLl6NtScMFkkw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(2906002)(5660300002)(110136005)(54906003)(36860700001)(6666004)(7696005)(316002)(8936002)(508600001)(26005)(356005)(83380400001)(82310400005)(2616005)(8676002)(47076005)(4326008)(81166007)(40460700003)(107886003)(426003)(336012)(36756003)(1076003)(86362001)(186003)(70586007)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 08:10:00.9356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e18d2e-54d6-4fa6-ef93-08da2da57ca5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3455
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The find_next_netdev_feature() macro gets the "remaining length",
not bit index.
Passing "bit - 1" for the following iteration is wrong as it skips
the adjacent bit. Pass "bit" instead.

Fixes: 3b89ea9c5902 ("net: Fix for_each_netdev_feature on Big endian")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
---
 include/linux/netdev_features.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Hi,
Please queue to -stable >= v5.0.

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e416225..7c2d77d75a88 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -169,7 +169,7 @@ enum {
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
 
-/* Finds the next feature with the highest number of the range of start till 0.
+/* Finds the next feature with the highest number of the range of start-1 till 0.
  */
 static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 {
@@ -188,7 +188,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 	for ((bit) = find_next_netdev_feature((mask_addr),		\
 					      NETDEV_FEATURE_COUNT);	\
 	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
-- 
2.21.0

