Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DF266B94B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjAPIvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjAPIvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:51:20 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2045.outbound.protection.outlook.com [40.107.212.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B302716
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 00:51:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N6ivOO2N4W0y/JjroJk4rwAEcYdmflOMweeE68Aq2VJziIqUbjo4b4mWsfsl5DsfdaLQMjnL1zNhCknrIaGOQGa3yTx9FCE8iMYeZ12vrBqy4xQ/D5Zvwn2UK0Xwt+uX1V1OJ8EorL6wn7n6PsDpp943WahoxOUpbA5uTeeGlf+ZEdwcFFzBaI7LKv8xtbMbSUEKHQnWcZN5m6x8IOGPTlj6MnsKAzOETaNDVK+/OukDujcrr8W3u6+tUgWuM773URQowXUm7+cESDRj3Rabr5k3muj6MWX4qJypZZyiTVllIPssblg4QgXJCCSyEbRGrmrUKO1yW1y9E+SBljRADg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mUbqQmcsxd17xaxg0eE+kheFtfwm5djPRkizU0nplio=;
 b=KndkAgdpwPkB4YAnCg9zFpZKYnLVlYw80mHNWDuhoBNzdZVK//uQwg/AClgoKVJ7lkVMwH+tBGciMUhbNKURqoRO5Uaw6SmF8Aw0ZdgZTJXWC5Z49nAJJVv2iXkuc2m0Utox6kM5Ueh7S4BjSdes0pBvUD+fv0/gzhsrn+vFNiJ2Yg/PC/q8YZoaj3onPWTZgxbDV9LKWxpK47H9L8oc26VH69hEYyhEy96GgNbEs13VqP6Iu/GtXo0XEjAzzkwZLXOgAIZjnwnrJiGGG38xvLIJKMbUXuNIIbdtFgCQFK47UwWzjK9kgcsrB4aBhl/A2GMjh1EvffZq9Rg2Ni2NTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mUbqQmcsxd17xaxg0eE+kheFtfwm5djPRkizU0nplio=;
 b=vvUWiG8qbsiiFH2RYunIw2dTAEykutbRLSAjn39v6+bxkX2qiyop8Iu5LVyr3vpXxBAYo99sDyv99EwGot2rFgidKkkHaVrMDH1Fy1L62XCaZsAExvYqZRRLIY21+3DoVgnQSf8IlBFSLrOofNP2SQOorzVPLfoSLCe+nUD6ifw=
Received: from MW4PR04CA0136.namprd04.prod.outlook.com (2603:10b6:303:84::21)
 by BN9PR12MB5115.namprd12.prod.outlook.com (2603:10b6:408:118::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 08:51:16 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::a5) by MW4PR04CA0136.outlook.office365.com
 (2603:10b6:303:84::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 08:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Mon, 16 Jan 2023 08:51:15 +0000
Received: from jatayu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 02:51:10 -0600
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <Raju.Rangoju@amd.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH net v2] MAINTAINERS: Update AMD XGBE driver maintainers
Date:   Mon, 16 Jan 2023 14:20:15 +0530
Message-ID: <20230116085015.443127-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT005:EE_|BN9PR12MB5115:EE_
X-MS-Office365-Filtering-Correlation-Id: 5459a1a8-cd8d-4385-dea5-08daf79ed399
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VJbCRG66ASBPZ0N3/vIsCnVFDJ7dL8kFG8yxENRBD7FszQ7jDC4jaViaXHsTxUph9zwWNp+WQMc6psrPTI3w/0ojcP3q283D56R/0wmqMSjHrMSJNuNI4ykWC+nGabvnhifOrqvo/xcrCZkTXXH8HS/CuLX9RWJWrOHPB3rTAUxdAkLlkyz6tDSXy2nhMNYaiBpCs6l55akBk3jgPQ3CVbX6jDhru+aiLFLWfkB+yH5BazNpp0jhxwCJ5ugMUXw9tyad7yhsZhbGYwCAz2lqF2ZlH97eq+EBjc3/SzBcXVvL5adE2JW6gfr6FYxF/AnYOdiU1GhGPLTtvX9yB9MwKULZEoUyBG75m2d/JRGkSB7oCMhOMFD+LGyVUG/h1CVo473f1HK5nsCNBlexcEY0x6lWD97Khc1461BLdrPcEnPHYjKVHsufknVM86S0UMFn+hsrDstdcfXgJTsTFKCuKgbYQd0J2M8elsA8LYqKJRnSTkO+o9+mXMSc04b48t/TZyjFwP8lfy94EPh+v6dShf2jH7kmI/DFawqazlm16VTh9cqJdHRS46lN2kh1XhdgFA5OAIv8SyUsVciStrk3cvWkAbZSZEqV0bIg6dq8ckr+Ct+pj7gtExbKffVxF2uUPpzwjMywgKfrEpBDlk0IE+wH6PsO3+BeYbj2WOkxlvXtbl80VI2by65cYov5dWPBioDnxLzxKWSj2njxEW6AClLFLcUYjeOVKlGQ8i6D3Q8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(82740400003)(83380400001)(81166007)(86362001)(356005)(8676002)(2906002)(5660300002)(4744005)(15650500001)(4326008)(70586007)(70206006)(8936002)(41300700001)(82310400005)(40480700001)(16526019)(186003)(26005)(2616005)(47076005)(336012)(1076003)(426003)(316002)(40460700003)(110136005)(54906003)(478600001)(7696005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 08:51:15.1754
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5459a1a8-cd8d-4385-dea5-08daf79ed399
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5115
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to other additional responsibilities Tom would no longer
be able to support AMD XGBE driver.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
---
v1->v2
- Update the subject prefix with "net"

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e278cd5d0de0..e5c43cbffea7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1104,7 +1104,6 @@ S:	Supported
 F:	arch/arm64/boot/dts/amd/
 
 AMD XGBE DRIVER
-M:	Tom Lendacky <thomas.lendacky@amd.com>
 M:	"Shyam Sundar S K" <Shyam-sundar.S-k@amd.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.25.1

