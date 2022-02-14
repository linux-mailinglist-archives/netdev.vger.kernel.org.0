Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FD04B3EFB
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 02:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239053AbiBNBp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 20:45:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiBNBpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 20:45:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E402527F9
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 17:45:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIzvh81I9QlVIrfod43rJW23EkgC0syuR48IIVKvtzpzBT4OrvypjihwPwv1YlFkoO7+rhonXu1X4tCUcE0/dWfEioxKkAUo9MKzE99aBlhS05cHx3DFymNMK9rxBjxHkSV+zvaNEikxF2pgwTINVVI7KYjZriASJzO6tt4bk0wWuq+YgD/wKagL8Cr8yFNGI6xwgbENbTLAX8GHO8vCETUaLamTQQ107n3OyJdtsczSaM2sbmtFGZXLxw797TzTmEJJUOHUJKzrR+nLZoCQuelDsQ+6Ev0Z3FB/APUyumQOMEaVbH2s9J1T8KAU78/x640mYFEU0kISGfQ752FPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOPzOoC1JF5YnhrulzPIcWytaklWubpy2eyueOJPIRM=;
 b=TIX3yA0C79caJmIpfwZqbtLyA/iikcEP1rrFfY8R5Wp+NXXHppsjmdw912KDqX85cOjYl2fUmtenTgbYr2DYcMvk8/AkNnYKAb9W3hmUTJwCQambgkOs/hdAsUyc52E7grQw1Y0KXzFkE2VS7Rsoa7k7Jeu9Ip5pIroDfCLp8tbTQ5mOMgH57hJ/q/fh7SavUktlmtWtcZvNQUpSaWFOubZf4CLcbiXVi/R3cVUScG5uYkmFm9e6ux3ceUrqFgkRYfJYyNUUjEmVbL04fyWpPlfDbhMQ24t+GMr+rZHPYb3qmfzuoNOUXGLdr92Vlulul6E900y7r+2xbWlvxQSkOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOPzOoC1JF5YnhrulzPIcWytaklWubpy2eyueOJPIRM=;
 b=PUpEmTLMJFcu00DN5X+JN2rgeCfB4P18vft817HBQP31kfkPNyE/9vQt+he0FUFHtQe2Tp4cSv61A6CTifa9SrUViCn1VqUXJxjaU7ovqvkfPxFO+Yr7AsBGCQN+DCKmHN4mkUuiRruqLjghloPlXAcg70/HjgeThpS6CVXZDcPoi5r6iORCLSLBMgf2tuw5fmixLHGuf8gDm1hFlJzjZwZkAaeKDJmj94mZ7DUTct7uDl3AHdfSiftWPQUeEnZJXam/ZB5q2r7Sr8WBb3UZI7gmYKZfU+fW42ffsQ9vjVnGZrmtlqT5W90Tbd1KTQZhl1PIamRK/jtJmVBJKcuxjA==
Received: from BN0PR04CA0129.namprd04.prod.outlook.com (2603:10b6:408:ed::14)
 by CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 01:45:16 +0000
Received: from BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::84) by BN0PR04CA0129.outlook.office365.com
 (2603:10b6:408:ed::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15 via Frontend
 Transport; Mon, 14 Feb 2022 01:45:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT045.mail.protection.outlook.com (10.13.177.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Mon, 14 Feb 2022 01:45:15 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 14 Feb
 2022 01:45:15 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 13 Feb 2022
 17:45:14 -0800
Received: from d3.nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 13 Feb
 2022 17:45:14 -0800
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH iproute2 1/2] bridge: Fix error string typo
Date:   Mon, 14 Feb 2022 10:44:45 +0900
Message-ID: <20220214014446.22097-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214014446.22097-1-bpoirier@nvidia.com>
References: <20220214014446.22097-1-bpoirier@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9298793a-5191-482a-37d5-08d9ef5ba648
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB5001B39D40C15352B5D8142AB0339@CH2PR12MB5001.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3MTeos2/kLGKFpeqcVzryOUJspUOE6veoDhKGV/CgxZTBfg++VzkKM++O9AzIroIVtvPHMbU6kXL5j29BkgtH/rrh1+6LKMrQ//ZmjeYOWDrhlGHH4zeGPttsroTn6+tfEbNjBvfOsOR2lxG6Ie6IXCRY3Lzw4zmEcqRgqsBRacXCkaFCcHYileqAF2LoVO9r4v0kKmPR4HVawolPZl7THOd1WGY/2ZEM03TrT72UZZs2yZe4sbHTT8W/a5i8Ug3xy1RRIRYWPrBDfSAdUgLE3etIzBgp2AEbl0CBYSF/0uu1Obd0aFx7pxlm1pVQ4U/4qn+qPrZl4j5QMsMnG7KokpZBlI46nf1Yto0/OmXqGXjGOKpzQ8Yy7ZH8wAzkzl8DoRaWpYk/HAsVESBl5g1oRWjywMzs02uLJG5/QAXlruAhrLxGHA7qc2fr+oZCwwVR+DcZjWkF9/hJaPD5FZmdzQCtq0nSLEAfvSsySads2GqgeHBeVpohTVVKvnjI11UUw5SG6IOVf1UAXeIbZPmR4/LEVkfpinVUNEmIKOFTnvXd8UnsaXxrXwuCqFw16pFmhvq3Pngm1eMzxXaC2aZKu4X5aOZT6uHFLhqyIWorx3Hf5rjQLxBCHh8ZZiRVXPLYM60kKrPCyhnpQFwCQ3rLhaRvVSWhNmlM9JvH/dPO0sojHhdasWHG96874ssMEIZsn7Ub9GppT8AXNl5A9jBhA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36860700001)(47076005)(508600001)(426003)(83380400001)(336012)(7696005)(26005)(36756003)(40460700003)(186003)(1076003)(2616005)(81166007)(316002)(8936002)(82310400004)(2906002)(86362001)(70586007)(5660300002)(70206006)(6916009)(8676002)(356005)(4326008)(6666004)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 01:45:15.7792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9298793a-5191-482a-37d5-08d9ef5ba648
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5001
X-Spam-Status: No, score=-1.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: fab9a18a2e52 ("bridge: request vlans along with link information")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 bridge/link.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index 205a2fe7..b6292984 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -543,12 +543,12 @@ static int brlink_show(int argc, char **argv)
 					     (compress_vlans ?
 					      RTEXT_FILTER_BRVLAN_COMPRESSED :
 					      RTEXT_FILTER_BRVLAN)) < 0) {
-			perror("Cannon send dump request");
+			perror("Cannot send dump request");
 			exit(1);
 		}
 	} else {
 		if (rtnl_linkdump_req(&rth, PF_BRIDGE) < 0) {
-			perror("Cannon send dump request");
+			perror("Cannot send dump request");
 			exit(1);
 		}
 	}
-- 
2.34.1

