Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8CAC5617CD
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiF3K1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiF3K0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218FCB841;
        Thu, 30 Jun 2022 03:26:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k68rGEbuFjGOxCiahnDJjjUVPsM3YB7zj59SJNiEcPnHxUJ8cITmlg8vFji1xlLRsVuXKZpUxRZgDVtlasOAzd8+ArJu7jWjUgeahYAVtaN/GhvNNfLlQ1zD8/r44ISrXgTuYqsU/ZESxN/vshRSVL3mKZdgdOd26LeSGVvpm/y+B5G8AuWqqn/E6kqj2JJJdwzTSTghjX+2wK6oGpq9nC+7FnEPrNxIyKAqPw/jgBSR1FgBXjUI8gpJ29d91rHEJWaFPGplrGdj96IZWbIs8i5rYh9b9ew30bUJLnobFW8n49rK/92VCDohP1Y/bq6scKore2woCn1wpUW0dN/Dpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=O0YwKVsW3IFbSToay03z1gnJeHU52GRcLhNaVvBrhXVXj7UEX7jOpYQFGlYLEwyRllEz2AANOw9B/cWlNaPWaE2YOQd7QiIgk9ZaQe5bwasd6PHSHkhuglhXC0o3CdxOvxPg7SpTpCJlBG0+msfR3hSEH4aakbuPAmeyRyKLWruAzzD3eDR1EUGZfBAYorqmQlLp9V2IjzVZq5rOrUGVNZLOu6A3TS38RCf8rO6vzyPcFJ7zp0jwgq3WSaAtuUciLCtHvhxWBEqZ8c+EocuerpAU0QRqOB/tBA5wuaAaLncwuH0/fNch9mI1gcuBCYCAiXppzlHHxXdD31DMfFd/8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=LvMpWVtNFGfdATdoKwfAVvAgZod8XIRAv1X6D7pmk/sKWxKJw87140eFHpmNQnVh+4wZLMVQkuz2V7AGgQ4Nm0KST7JEjke9lU4cURxbRnk1MQ2CjT5wqQsN+me1BtjCHvlMgKqAMNSuR6sASH0gK7doo8qOptoqzTEwI+Mbh7tz8wK352hJpsQcRpWMGBYWJVroF3Nd8IrAw29t5G2fKOnCPTOFRiS/daT+2MVl/RZgIX6EyiNHZPG5hgje+1Hs5wc30VsCjiOBNIIDyQ/P2gSfCmRqiePump9/gPHQC5jy0aZfr1tlNnQIGGwZGkFajmu1B7yQGHCgGOKqnzdrLQ==
Received: from BN8PR16CA0018.namprd16.prod.outlook.com (2603:10b6:408:4c::31)
 by DM5PR1201MB0044.namprd12.prod.outlook.com (2603:10b6:4:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Thu, 30 Jun
 2022 10:26:49 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::7) by BN8PR16CA0018.outlook.office365.com
 (2603:10b6:408:4c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.21 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:48 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:47 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:44 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 06/13] vfio: Move vfio.c to vfio_main.c
Date:   Thu, 30 Jun 2022 13:25:38 +0300
Message-ID: <20220630102545.18005-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 945e707b-6129-42ed-3886-08da5a830ac8
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0044:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56zNlVMdbKHWvMVgkf78IKL3HB8hvLLELj8UIMcWIGS1WigyoqVZMXDMkdO8BGv3mHg7f3UDNhru/1y22ZYUgdg2X6V53FdVDsSsxZ6XPORRNBDoDPyAj6coytPE+xSnd8xweNGghe31mCrilv/4QTx1rqo5PNvVPJc7pPcKc/WaaK7O3xDCtMg43NpEkFxxvCTYT8UrcFoTLWA1D/JAKg6eUoQ024IPL2x6stHmflhJsNo0CMhfbXmYZGAwz/1TDD79nHwqvM1LN+f95YntaPdMlWRum9ezSEBKKtKajk9LjyAgq+IFlj07mA6dsYrl+0hwpzcKgQ0m9HmwBEsKmCgdjc/UjC7BWMcpqZ34rX6KuqYKka4ZlCVVoDkLzL2W+j/lkKRanRK1c2FdPJBQthOZQnAfArmaxfqA6hfrBcFLKbnZ534DcoAHEYVDISNyXZMUg9edQsmsaMcvtgrJg+PA3KeiEoGSj/5GKeJRo+Lc6jv3RrRqmBGpTLUmpDXQcvuGHef4bzmeco3XaVUkLuMPUPjVGA4xz7vOzy6Zb3rCnIqzUbUzRZIn+WhkULiVP5ef/ndmD4xwbFAo4D7SECa1006S2dMj17ZxxHgA0rG4N4IePz4C0SOgviZGbEh+goiVeEVvKFAs7/YDsSyPwvsUwV57UO2qKZAoiDG/r22bDG3JYVvTXnynNZBFEJ9bVlGvD0nDl/07HVxcxrupL5go7n+HtxckIw5NsGPnARYNSIWJZhYEghO4+heFczddeoKYzkWHRyqWtn3AMikVCoe8R+7g4Ra8cWlqOfWC9I51+k1/cQ6fbkINhv59iOaUzICmNGQze7vq1CvkDDGZJ7SwqT2i21I0+cGQqCqD00M=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(40470700004)(54906003)(70586007)(6636002)(82740400003)(36756003)(110136005)(70206006)(4326008)(8936002)(86362001)(26005)(186003)(2906002)(40480700001)(478600001)(36860700001)(47076005)(5660300002)(336012)(41300700001)(356005)(426003)(6666004)(82310400005)(316002)(8676002)(7696005)(40460700003)(81166007)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:49.2893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 945e707b-6129-42ed-3886-08da5a830ac8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0044
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

If a source file has the same name as a module then kbuild only supports
a single source file in the module.

Rename vfio.c to vfio_main.c so that we can have more that one .c file
in vfio.ko.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

---
 drivers/vfio/Makefile                | 2 ++
 drivers/vfio/{vfio.c => vfio_main.c} | 0
 2 files changed, 2 insertions(+)
 rename drivers/vfio/{vfio.c => vfio_main.c} (100%)

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index fee73f3d9480..1a32357592e3 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,6 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio_virqfd-y := virqfd.o
 
+vfio-y += vfio_main.o
+
 obj-$(CONFIG_VFIO) += vfio.o
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio_main.c
similarity index 100%
rename from drivers/vfio/vfio.c
rename to drivers/vfio/vfio_main.c
-- 
2.18.1

