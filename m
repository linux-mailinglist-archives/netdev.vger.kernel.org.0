Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1882567C70
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiGFDNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiGFDNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:13:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A638B482;
        Tue,  5 Jul 2022 20:13:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2HUCyTRKCefeb6abTvA/dBshcPyOZuTHI2qtqteLXxbzpG+95K02BtkSX9+8l8BGkpYg5JI5L3GKTVEr11CILucoRVehBsEOyXwNo1VUoDMDRhyX2QT3cLowQqyMnTCXv69REBIcoRoHXCKjlpaymZCuRr+78Jaa+1r7JXM6FU47X8FOuKMSz7ELtGUU87OWdZlPc9x+v8xJVvBXoyRkR5aFItkdvOV8h0hVyDtbnz1p4+gtny4JdQh3Uw8RJGY2rhtf9svsc5CWQ+Gpp4j3GSyp8qa2/8BgePACe/t9WAfWwDPVudjI8A1tigG3eqs+6H2SLoSdmARllKxKCoCXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAVuJXVLr88hyfSIstyPY8cigZSeQMQ3uR8deAPcZiI=;
 b=k697Ir+DHoX9VRl6N3sf2fGY4O0GfNg/7sLW27V9quqktnG8u1zEUiIxifiO5jcsUGej6zkqdqlHR5tHIXyZ62CSUvPCUGl8xTWwZeTpifFCReGJnGAAdyINzDszIGhkv8bd7r9okuAGCxZWf3v6NWq/k+9ptDxz9b3yPPtMpjG0IdMfDON3+fQd9EkliWkSdWYNQCFGQT5h2IZVjssd8Lrqli+amYqRQVutsLn3PKxlVZIWcokBzV+JYXl32W6RZJ2/JykMyfazHSc7WptaQQteg53k/Lt+PIbWpXRvimWwlhBZoTyKPNY19WpTwZ98pnCp1YmqEAu0DJwqa/U8bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAVuJXVLr88hyfSIstyPY8cigZSeQMQ3uR8deAPcZiI=;
 b=uQigIezdYMyHhfUhI9QbpL6ZBHSHipbFMxyKKFs7T4cAiAJira/neQtoKsp4t+3ST7PMhaGKqIIHw08KqN7uRY/AThEMWSinXL7FmY9fd56kP5pfCWOSETVwGUYH3tctOTfxQc1W6uTXUJeQSSh4mCbhQjQuNbkMicFp3J3R0efp6wjDe61T5nl8M6I5EiRorEbNptmPaiCOxnWd9CGyT7Ga1OP9BOKVcUz6v6RnEu5cqXM6OgIyOmk57jikFa71qbbdgfZqouzl7CQ5tsoFIRzMa6kFsOAl8ar1nTgzqwu+Pf0+/GKJN9efyy58VXlcjKHaDiBCk2FRq+s11Zr2xg==
Received: from DS7PR03CA0311.namprd03.prod.outlook.com (2603:10b6:8:2b::23) by
 MWHPR12MB1709.namprd12.prod.outlook.com (2603:10b6:300:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Wed, 6 Jul
 2022 03:13:28 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::67) by DS7PR03CA0311.outlook.office365.com
 (2603:10b6:8:2b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15 via Frontend
 Transport; Wed, 6 Jul 2022 03:13:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5417.15 via Frontend Transport; Wed, 6 Jul 2022 03:13:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 6 Jul 2022 03:13:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 20:13:26 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Tue, 5 Jul 2022 20:13:22 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        <pabeni@redhat.com>, <davem@davemloft.net>, <edumazet@google.com>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v2 3/9] dt-bindings: memory: Add Tegra234 MGBE memory clients
Date:   Wed, 6 Jul 2022 08:42:53 +0530
Message-ID: <20220706031259.53746-4-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220706031259.53746-1-vbhadram@nvidia.com>
References: <20220706031259.53746-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b967e34-6ee6-400e-8f54-08da5efd7f0e
X-MS-TrafficTypeDiagnostic: MWHPR12MB1709:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9luX76piXYZNgY8tJ5KxiIRNbOaTShKxXrcekF+SOPlTYmoog3JEby6mQLXuEECdH7A0/u0CUPuEKg/9MSHRz8wbIU2AsGyzXDB/q0dO0tCGQpYw9PVshqT/vNzdgsKWeXDEAKP5Bu9CTXbKz5+gfNNuLO5KfH4cYPvjXXSQDf9l+eWog2rMEMIiiM4daRUqPNjKrjU05GbP6xnSDMNXRgzUw2V/Yb8LbBRXjgzntKUdoAPqDisD8hLkTzhVTkwF4Qex9OYi8DARd9XyMQLX0KZ5xvuxC+F2y2Evdv5x93RW2OyXgMDKmkJJKDRj1CinxmAcu3AHkc/bSUplrhT9nrwG0OFHbfbxcVk0vV7zA2UQdil55FbtOL5oLChDsr+cwmU79SCU3snc3mBDuChxhgF1zVdZHX9oDRgtVcGBqBaHnIS+VSpQNPeixRo7/eHiKWCVOW8zBnjYieBcpgR2i4YWPEvI1csZvdJ1zT8NFGSM43AlhQZO7q9qiO5L5+1b+1SWQSNXq9aCxeaD84STUi3ApU5h0igW9TxSxMEM7nxwRtn1BFeab0n0qN91IwEf6SFc0KghRvkFU1FOHULgS2I0cSlA84RxFgXa1fNpJMpboSZ5I2myYYlNpN5XOQMRxDfWVZX/N9N5vAfvavoWSAkIF/TqQGVYXeEjBIkN9MC19AbQ/Lu/QMdP/m/68SU9ONbLlfaITNFn0cNNebhe5JL1NUHF/PWhG6+MeMPYr1jfNWv8xQodsBMzrFHHlfhlyJltS3GXDXK+uIN3GsrkSzzt9HyNN8+bk1r4IXx8cMN2mSNSEINFrAnL0YW2wHdBaSb58W4xWcF9TrIXXRoT47qtYOIbOvHLzXAZApHIX7c=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966006)(40470700004)(36840700001)(186003)(336012)(47076005)(426003)(70586007)(70206006)(8676002)(4326008)(478600001)(86362001)(7416002)(40460700003)(8936002)(5660300002)(82740400003)(356005)(81166007)(26005)(82310400005)(6666004)(41300700001)(36860700001)(40480700001)(107886003)(1076003)(2616005)(2906002)(7696005)(110136005)(54906003)(316002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:13:27.6494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b967e34-6ee6-400e-8f54-08da5efd7f0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1709
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

Add the memory client and stream ID definitions for the MGBE hardware
found on Tegra234 SoCs.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
---
 include/dt-bindings/memory/tegra234-mc.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/dt-bindings/memory/tegra234-mc.h b/include/dt-bindings/memory/tegra234-mc.h
index e3b0e9da295d..8b0ddcb715ff 100644
--- a/include/dt-bindings/memory/tegra234-mc.h
+++ b/include/dt-bindings/memory/tegra234-mc.h
@@ -11,11 +11,16 @@
 /* NISO0 stream IDs */
 #define TEGRA234_SID_APE	0x02
 #define TEGRA234_SID_HDA	0x03
+#define TEGRA234_SID_GPCDMA	0x04
+#define TEGRA234_SID_MGBE	0x06
 #define TEGRA234_SID_PCIE0	0x12
 #define TEGRA234_SID_PCIE4	0x13
 #define TEGRA234_SID_PCIE5	0x14
 #define TEGRA234_SID_PCIE6	0x15
 #define TEGRA234_SID_PCIE9	0x1f
+#define TEGRA234_SID_MGBE_VF1	0x49
+#define TEGRA234_SID_MGBE_VF2	0x4a
+#define TEGRA234_SID_MGBE_VF3	0x4b
 
 /* NISO1 stream IDs */
 #define TEGRA234_SID_SDMMC4	0x02
@@ -61,8 +66,24 @@
 #define TEGRA234_MEMORY_CLIENT_PCIE10AR1 0x48
 /* PCIE7r1 read clients */
 #define TEGRA234_MEMORY_CLIENT_PCIE7AR1 0x49
+/* MGBE0 read client */
+#define TEGRA234_MEMORY_CLIENT_MGBEARD 0x58
+/* MGBEB read client */
+#define TEGRA234_MEMORY_CLIENT_MGBEBRD 0x59
+/* MGBEC read client */
+#define TEGRA234_MEMORY_CLIENT_MGBECRD 0x5a
+/* MGBED read client */
+#define TEGRA234_MEMORY_CLIENT_MGBEDRD 0x5b
+/* MGBE0 write client */
+#define TEGRA234_MEMORY_CLIENT_MGBEAWR 0x5c
+/* MGBEB write client */
+#define TEGRA234_MEMORY_CLIENT_MGBEBWR 0x5f
+/* MGBEC write client */
+#define TEGRA234_MEMORY_CLIENT_MGBECWR 0x61
 /* sdmmcd memory read client */
 #define TEGRA234_MEMORY_CLIENT_SDMMCRAB 0x63
+/* MGBED write client */
+#define TEGRA234_MEMORY_CLIENT_MGBEDWR 0x65
 /* sdmmcd memory write client */
 #define TEGRA234_MEMORY_CLIENT_SDMMCWAB 0x67
 /* BPMP read client */
-- 
2.17.1

