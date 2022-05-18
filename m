Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8352B33C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiERH2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 03:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiERH2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 03:28:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A795C6669E
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 00:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3gDeqT6k60PnxMK1r0npY2VlzrL//uGkjO7XCYBAPuFdXTQS5oNMGgozPYRtb5hwploLHOrJA0EW57Mug4qZNHTWpFCPepzTCXFnj4cigz57W5MO8vSWlicw5ipsU0Q9LKcR6PkRKAgleZkEM6GL9kFNETZx7G8Kp3os4vOl66Q5nUQkrXP4xZDxp85gSh2w1T3PxSLBCZUCXU+nvQG0vp0LMxmjfkwBgM7fteDXr5S4zl+pJmbDBLAPSDxNEtmXpUp1H52P/wxxni8D8PUV78LG7sQWeMSAXjDIW+kqKGTbwLxk9pJH56lTmZ7hh72i3KoU1AhDMt3tzDKaHUAaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nb8tBZI2muEaSVb/vjoE5oedf4FpC3a8386VCkZuYWA=;
 b=lCUYzBJ9G/Yrin2nSk6AXvw68p8AVCUI+mntexhJeS7pyDbVd9mkePpOQmGolPfGziuxqhMERXaoFp50iPZ5bbEgPraTEOtgRD14i4u5Vo9kNW/XdgVPK8j0zlqy8U+KFIvhOD8dy0frbjKEcYI7rfP1iGub3Pm2zYg5HifTJIk1JjheGqOlG6NagwFwoaqIFplILDxkX5+dhrveSriB7qjiAe/yEg6l4+FdJ11Cr0/oKQQBJWrJCZwWfPJm/0A/e2d0jU4UVFtcoZJj74ta2Jz6gdm6ZQ1NPE4FABxBWEXDWaIsqDnOe74ctaIvVKp6WToncpvc3ejG4Ip18p4cPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nb8tBZI2muEaSVb/vjoE5oedf4FpC3a8386VCkZuYWA=;
 b=SF8k5Sg3ZWJYCb4+9F60cu1W3/ndrLXzsQobzWAifVkeALMVLgddcH+1VRH60MurjUgSSFfZsAEZFcy8t1IKsmRw5mcTYpA7j0wZO17zxHlyPBbO0tSMWiu/zCFgvXEXqOJ58bTnve0sEZ2mVTgBYLz+COLPC8/I2zxJB1q5m1+BX9+IitATEw7s08AdMscpRyA2SXqlsW6hYACcNon4Do7TEqoP2I2HCF+41gwVRe/uEzkcnz6BMeTx6rVFMmKSg9HDo6litM0qlvs4Wzr2trDzmR8uhjGSsVp2BlIYZfjhzygB3ZFP8CclT7gQ3e8o9jRAvQ9C/FFcJxcrpQFnYA==
Received: from DM6PR13CA0019.namprd13.prod.outlook.com (2603:10b6:5:bc::32) by
 BL1PR12MB5221.namprd12.prod.outlook.com (2603:10b6:208:30b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.14; Wed, 18 May 2022 07:27:57 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::37) by DM6PR13CA0019.outlook.office365.com
 (2603:10b6:5:bc::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.12 via Frontend
 Transport; Wed, 18 May 2022 07:27:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 07:27:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 18 May
 2022 07:27:57 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 18 May 2022 00:27:54 -0700
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <shuah@kernel.org>, <petrm@nvidia.com>,
        <pabeni@redhat.com>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next] selftests: netdevsim: Increase sleep time in hw_stats_l3.sh test
Date:   Wed, 18 May 2022 10:27:26 +0300
Message-ID: <20220518072726.741777-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d34ed29-7610-48ec-a7f2-08da389fee71
X-MS-TrafficTypeDiagnostic: BL1PR12MB5221:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB522143BD163717A681A8B991D8D19@BL1PR12MB5221.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W5VvJylpHsz+o+Sj/6W4p6Zq+zmvUQjHk7y96AZ2kkkG8hqe8PrfwlJWFEqEB8NsNUUyusMNb1JTrbVxM5Nzd4DqTwEtVEpBWP1mdZLxI2ENBkU+8aIH+ytlt4FQKj1BIK2gLhYtcChVBL0oQYyuxFTttKst1lOVFIKfRIc7eqS8BwBD6bhxR9hRQRrSwfZV9ReFyNphWpk+jxPAUqfMTg/3I3HtYFyP+1CpWKLXqYj4zHq1TgsdC2T8swgqwIcdS2QiPnEE9Mr2E9oBttzw47m4bOjCS1sq7Jw4kxMZ7HQM0qB6ES4+TSrB+LIsRByPfQY6iHSh1DXEsMWklsQE2ffUTPaqq4JzVyCPaUiJIdiYLqzF2t9AoOlToua4A6h7P949GoNk9FxLRSbLw5yzehrQLpTlCoWOGNZYmDbHdlFdqEtS2OmM1d+FxTZ+dlAsUCTItw4FHjFIaJ6eysgAMnxDZ/f/h+2P1SYwbTbXKm4iYdsz5Cf9bHgUtZaj4uNc0GLJo4Ne2jvlCRyyWwEHRViu5s5fvsguO4rov7k7NlnPIP+Hnu5aJRgIL8Sd4QU0rh72WzorajihP1Mt/vaUlF0cizB54YwMAXx0EX4ROmOIb71LuAd5XxZBGmMt1g7bUkNGQiKf3oMfDSfVpWBKW5FhPOdR9G0V/zicXac6TQ6X+h5LjIomITw0fOTMueRk0Qv8NxPkEpt/9oQQa42uLA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(508600001)(36860700001)(2906002)(426003)(47076005)(8676002)(336012)(4326008)(70586007)(70206006)(26005)(8936002)(5660300002)(81166007)(86362001)(83380400001)(1076003)(316002)(2616005)(40460700003)(107886003)(54906003)(6916009)(186003)(16526019)(356005)(36756003)(6666004)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 07:27:57.6478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d34ed29-7610-48ec-a7f2-08da389fee71
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5221
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hw_stats_l3.sh test is failing often for l3 stats shows less than 20
packets after 2 seconds sleep.

This is happening since there is a race between the 2 seconds sleep and
the netdevsim actually delivering the packets.

Increase the sleep time so the packets will be delivered successfully on
time.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh b/tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh
index fe1898402987..cba5ac08426b 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh
@@ -319,11 +319,11 @@ counter_test()
 	((pkts < 10))
 	check_err $? "$type stats show >= 10 packets after first enablement"
 
-	sleep 2
+	sleep 2.5
 
 	local pkts=$(get_hwstat dummy1 l3 rx.packets)
 	((pkts >= 20))
-	check_err $? "$type stats show < 20 packets after 2s passed"
+	check_err $? "$type stats show < 20 packets after 2.5s passed"
 
 	$IP stats set dev dummy1 ${type}_stats off
 
-- 
2.31.1

