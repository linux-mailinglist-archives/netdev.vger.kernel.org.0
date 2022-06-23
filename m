Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5B557448
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiFWHqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiFWHqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:46:52 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1746D46B3B;
        Thu, 23 Jun 2022 00:46:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hguVWuZsjeuiPI6ISQfHb39+xV6wIvwKUJUAWWynTCKimLu6qEjXG281JLkqxBVzTGKublzPjGQVTC/JnuKPUk4DUVv9v+mMIOgret82elEIGv6XX2mWc8KE+UPVzZhIqe5lwo73hyLZ9qR6pgSluWucQvpufmVtMTk3rDM6Oyn3XhBOVK7LvtJBrCpFq4U9i/LRx6P+RGLy+YlMz5cctoPehbA9IBepQUhNuQsxpdaxqV1A3eNnETbf+Z4km2jZl8rvvDKg9LmRiWx6GWISQjbKth+AgFhUqi05p06sy9Xqi8GOL8zqYpgoIoLhRHlIK45bBoJyxSmSmx5SnhUokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CAVuJXVLr88hyfSIstyPY8cigZSeQMQ3uR8deAPcZiI=;
 b=OGZkxefT31kJKZ8jeIoMBDl9fVdgm/O+crEy6weNTpqanT+/V2yGTRXSFR2ZRMmer/kmfwAcHK0YnrL8E+Lzm6MWprfMnLiamyHvPajIEpa6lqnd1QxNM4wRXdmr9N24oEXHy9JqfPsYfIULyld3OLQVYYpVNVeedZ2W89MWOPXJUctv/8RE77Tqs4kPKdGKaxyQ2d1G76B2ZZwsfXiwPUMxdY1PXhbmOQUpKiaWT18/UnAoqdQz21Nv1OOX6nxkHg2VXdWzCAfTmugtkJMShFGA0ixIzegVL9dyn+2DAZlRkj9Tb0S9z0IgS//nY5T4aXU4gkrWyDl6fLLz8iODww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CAVuJXVLr88hyfSIstyPY8cigZSeQMQ3uR8deAPcZiI=;
 b=n21zcKYLVpLoNG+jyqbrCR34dXUOBv/fs7KaLZIfE1vEqnFWJrFH6KMgnDhhbbUTN1EzV7pMzmRuNApjEXX56Yj+Iyx5wPAlJKLtngN2+kJ9cs7vNvmh2GtLAXsj3mcY0PmdoCiBJZClI1omtdzjAdA+LuskIrOhgLdchvRJWfNrd9FZhDTlzTnJTBX8ZmBEwEHsM280m/j9KALHDqHWk8QMDcjfW6o3k42IvD4m1Cr/KSaa22vOoTR8GhMm+lCqKDF0Jy71BH2BfjDwcNeo9rVobx8Rk6ooeu1hclVjSCL6rfvVo/sQrIg27NgJBIl2mkQPIEd5vj169+u9P2uy3A==
Received: from MWHPR13CA0046.namprd13.prod.outlook.com (2603:10b6:300:95::32)
 by MWHPR1201MB0207.namprd12.prod.outlook.com (2603:10b6:301:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 23 Jun
 2022 07:46:49 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:95:cafe::38) by MWHPR13CA0046.outlook.office365.com
 (2603:10b6:300:95::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.9 via Frontend
 Transport; Thu, 23 Jun 2022 07:46:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Thu, 23 Jun 2022 07:46:49 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 23 Jun
 2022 07:46:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 23 Jun
 2022 00:46:48 -0700
Received: from buildserver-hdc-comms.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Thu, 23 Jun 2022 00:46:45 -0700
From:   Bhadram Varka <vbhadram@nvidia.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC:     <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <kuba@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Bhadram Varka <vbhadram@nvidia.com>
Subject: [PATCH net-next v1 3/9] dt-bindings: memory: Add Tegra234 MGBE memory clients
Date:   Thu, 23 Jun 2022 13:16:09 +0530
Message-ID: <20220623074615.56418-3-vbhadram@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220623074615.56418-1-vbhadram@nvidia.com>
References: <20220623074615.56418-1-vbhadram@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cedf868a-f2c5-4371-d13d-08da54ec8804
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0207:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB02072F2D3A4A9BF64760DA20AFB59@MWHPR1201MB0207.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8CZLm893qaO8loVB++mg/n8QPVRZSIKMPOwFSLyBUaBdgwXpvqgHHDE8iaN7P2Q06cSZaACcTuXOclB3Xt1O8Ylf/6eP1A2ipnGZoqhd4WzKyo6OSgoUjvdkDRXqnVLjnGEX/VIW3iIqIt5QxN8LhVyNITcOf/wui8dT9iZh12Rl9BX0mbGMULeElxTA+CAfHCeDJC8ux6ixEXfxZmkREG6D6Wy5tOxuep9cuRxXLxzWZtG6Mff31wHJTOopHEw8Y/6ebsAVk6HDcOBjV4l3yyR26Ev8J+NirJSKoz1XrosOoZsdcTFlxNrqxIPUYIGvQ9+2bp2MRmdB07nzUdl8K93bu+Dxx0UaxFWwT7pzxcT0Zmk1aWRS+kYrh/GX2Md8hgtGX7WUD7dmfbBeDZ0Wvq5X9Hmw8Ig6+1exsGNb+ToI3wYU3IKiV2YqyWiW3EgDu6wthC9ud5IcPmProMngElNE1GJiwuial5UrwWOzCUounpYatuYpfXwsW/ZLeMzLScd6o9I7P4QiTKTGSIFbTkPKoqp0tkmUv5PFfDdeWVQePHF3Mpn2qGWZvRpQRbr9hzXnU34k5G0SBVgOSd36UgvZEPjMHU7KT8aY+AQ+F6Vz88Kykipt283DX1A4FMc/KKIkYb5sRsy2OTjyv9CsyuZ3cqTJpl9nSH0Hhx+S3aIWcXnmaqSMXOc3ZkT7aUPAmOx5OQ4tSS6EwF2xcmP3hTrF++mG6CzLMPAneQ4UfNOnDPDPKPU9ec5ZWerg9UZJDvVwyrGz0ezy6ghZ/ztgftqir7JuDnbzvCXljeSp7f8=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(40470700004)(86362001)(336012)(2906002)(36860700001)(356005)(82740400003)(7696005)(6666004)(81166007)(316002)(70206006)(47076005)(36756003)(4326008)(54906003)(8676002)(70586007)(110136005)(5660300002)(426003)(107886003)(82310400005)(40480700001)(40460700003)(2616005)(26005)(1076003)(186003)(8936002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:46:49.6128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cedf868a-f2c5-4371-d13d-08da54ec8804
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0207
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

