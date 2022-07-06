Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB27567C78
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiGFDN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiGFDNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F61DDED;
        Tue,  5 Jul 2022 20:13:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EviEnDOJyEwbx6Sl7NA/G2GQJgmW9ERsLlBDV36gUeG1OUvqTh4aKBry1ua0xpvFUp7kA+kZJ85VhPkd1GaGUqTMjRvnVX7TBvR9vwOrxUqManqRTuLPvIr7ftLYvgiWPh+/GUZ5QAyD5w0o68z42imhmuZLTZrgLQ0QuS/gQOzoPit5LEvr635vr7W2Cr/8Wtp9/a1YIwB0mwAZ6tR+V07qNoEMMKORLghD9Jqz29EW2x1BqtnHFNQE+j0XN9wdweGEReiNGXR3CgdOBIKZfqpQSswcFKLXi5TMVMBrRWCU/3+qErVHWM0ajx/fbYBIm1lvcpK4ZDQ9iSbMjU23Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U4zZt4PoIT5NPRkdhm9OYO2gcnN+PnXtnKtYzei29tY=;
 b=eIgIcmetdr2F7hu4qTJOa/BDBb9y2LnXroRgyL2fIjT8fDkQopp4GIJFhwL6CiCDs27sbohDh1e7Ju6YuI1hfDZRlOw2zQhAEBb784/xCrRzF0WLOGLuNFEJ65rztqnvSMSwJ2wb6glBRq0GSAK3cWGwdhj+5EoD1CFH9ADGw84x1RPwA7p2cyvSFXB8K9FwhqIMv47DDVicM+yl2yewqAMUlVC2ik+uX/HYsyAUkkEBL55unBaGzbb8d7JgNmREfNNrdvoyWFdtIgkJvhvC6VIDrvv/+uPzJ/qvmv9mZgZlkIsymLZ1nyRmPs/DKd6y4dsg1Qy22g/ZQavsjXV+cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U4zZt4PoIT5NPRkdhm9OYO2gcnN+PnXtnKtYzei29tY=;
 b=T60pgE8mCZT4jb22cOLhiJHmIueQLy3/ZdT4D4ziVcdzv+l6EKS9G006AotFMzGaxr01QeRGtAJyfUza1uqF9aN77zzlnBzDu7b9hi8cax0V8gTkGjexflaWsCAsRPomULKEVeXpxk3EJ430KPr2CIXwTgOVzetT7RKQjC7INhPSefFpJGf/uCDxoRVpDchyedzG293F2wSTZybCnAfBmOeysPW0l7S4kWF8vDcVvQCmzLCSuaG8ParNQkoDv8PiUrj4MtnzIzpvmx/klp3rpjs0Ucsv8ixRxqBKsOFGMBjeLbPCv/6556QIsSELwjdjkbWgDHmX5ykhzs8avCGdgg==
Received: from DS7PR03CA0310.namprd03.prod.outlook.com (2603:10b6:8:2b::9) by
 MWHPR12MB1773.namprd12.prod.outlook.com (2603:10b6:300:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Wed, 6 Jul
 2022 03:13:19 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::eb) by DS7PR03CA0310.outlook.office365.com
 (2603:10b6:8:2b::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:18 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:18 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:14 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 1/9] dt-bindings: power: Add Tegra234 MGBE power domains
Date:   Wed, 6 Jul 2022 08:42:51 +0530
Message-ID: <20220706031259.53746-2-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c2b7375-392d-4a92-bf41-08da5efd79fc
X-MS-TrafficTypeDiagnostic: MWHPR12MB1773:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OG/Ge9CCFU2bIsWMMWcYB8TIHsDvJO2M991doxU1LiVt4ZaOymNtDEecdXVHkR0UW0bu1NR2vlEz4q8wXChFfyF67pVXJOjxvG6t211mcAGPTrOKKfvAFDQ7NvSRUwMXNZzoCi6Ie4cJTYJF02TRnnZlAWO6bJ5d6zshvIFODmmiOlElM0JqpGo0dBqiELWOsWpO0JfhYOZ8JWDnAjmclDjylJhmQgg4NjCCNqXse5KzL5cIpiSV1++/JHsdbyHRLGRkLmXUTEmoM8FkIK2ApkVS72TLv7xKxj3d0LYfUlRufugWCY2VvHCe433MzRmXmsoN26WxdBtRPyjVGlLf8dgmVJB1Rf1j0E93Qf6kZCWGzw1Nq02qJpvKEV4xNxfps578/QkG1qlZyJzA+QBzkdw2eK/ZLoR+cK0SbVtBy8cPJGH7zSt0rvqjkswWAEqQZuaKtZbMfeC/PXOOo+s3Sp42akOrxCU78nB70jdWNaq27Oaf04lVSbVZmfaVw5gRojbXkfj1+nHX+1Fyeb+pI1ekNGvaDW54Toqwx2OUt5QYZFbE1kDHC84fJFDr8gAFA+SQM0rzA5gPITGegVZRcs9XEjuGMsTI8d/fKtwWEU68cR7feqZGNhN2144fRtDEcbC98cwQziL/ss/Mnl0HZc7JMmc2y8pmYmI/IHm1LFBLEUSz7A47IN1C2MMBSJozz3pbB/l2xrTdgdUsVzAWLdVXXrot5lChyyOZzYaP9aULYgdvi8MtAzR6iNd/erFF3kL7rMojOlA4n/DubN1UmtaCuSmzpxkUWOqf83aDt5IkhvyI5EamVprGGvIbi6nNGQrt0CkP5PuFgxGnOQ71qGsK3avlcpw6q2V1D90DYsw=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(136003)(36840700001)(40470700004)(46966006)(82310400005)(8676002)(4326008)(70586007)(70206006)(81166007)(1076003)(478600001)(186003)(6666004)(7696005)(41300700001)(2616005)(107886003)(110136005)(54906003)(82740400003)(316002)(26005)(47076005)(86362001)(426003)(336012)(356005)(2906002)(8936002)(36756003)(4744005)(36860700001)(7416002)(5660300002)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:19.1440
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2b7375-392d-4a92-bf41-08da5efd79fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1773
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Add power domain IDs for the four MGBE power partitions found on
Tegra234.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 include/dt-bindings/power/tegra234-powergate.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/tegra234-powergate.h b/include/dt-bindings/power/tegra234-powergate.h
index f610eee9bce8..df1d4dd8dcf3 100644
--- a/include/dt-bindings/power/tegra234-powergate.h
+++ b/include/dt-bindings/power/tegra234-powergate.h
@@ -18,5 +18,6 @@
 #define TEGRA234_POWER_DOMAIN_MGBEA	17U
 #define TEGRA234_POWER_DOMAIN_MGBEB	18U
 #define TEGRA234_POWER_DOMAIN_MGBEC	19U
+#define TEGRA234_POWER_DOMAIN_MGBED	20U
 
 #endif
-- 
2.17.1

