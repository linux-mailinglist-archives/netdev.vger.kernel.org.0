Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D24257466F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiGNIOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiGNIOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:14:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E82B201A6;
        Thu, 14 Jul 2022 01:14:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgDUrdHg9yNrr+WIx6dDtPZo+1qmOuw6i2LERR2fS6naflmJMg/3XVhI5u51FcC/zkv5p/vXmPz747BhLpafvul0g68oRazMbD5aLZMRCGsyQ2w2JBB3Eg4XfjXNE3K2fAyIEfi5TiDOxsrw1AHlG/HpwhAh62Z5BKmdMBpA5o5wR5WKvywQlJJn8PuP0qd5BSHSnXCFEaXuMUaGNOKzIgh98k08U8nger5fa+kpDFHN8I+9Rqkc+MKkeCeWM+OtBj9cQFgTcY5FCXCVHlxwqjSS/do8dS5m15YPtCjwv+4SncQA2G0FDoMgmU6YLw9KzGJ+fQqIAsqUI32e5onDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=PzkV9EVFinNy3vSTJezATJlgH/l2JdLfY39BXB6qFfFGRHVlxeK+SfqBcYfPprAi7D7SstQlKe9rKOc2BUVH+HQsOYPNLggmJYzTKkHxMhDJc+SBFDckuzBoZq0YmE9nGhj0hQtPTV4dAjSRwptbrC0hTtfOcy0uS0td2WOFst5yW+FI4PEEHn8hWLWfSsyqNYcDeh3iUcr96pzvZUHx8YPN8kL1pQfqI8zl10pmSOsfIBCrWlDFidSYouWrmzUGDL9wsHmMEjT0tvczTOCqxI2nvbimRJ31IstiOdLzxFglj7uKTVMt9LJbRGYtYYQ0b4Ypa8h4nV4p2jiXAixUFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=EtnvyAiiG+6PJzUNdhn2xBOr0clB7aX/9MK6UtoI41RTrHShun+AaWXy4B6LFURJK9uRoF/uQEaNbntD3i/AddsgoPo2T2QmgoC/39RT8iwYtvtmd5IEv0WZGUl1s+WtRbqjV7UcUh9GRuwhBOOmUIN/kYzbPWPhnYX1YXnRXaO3NugU56dbdhalQdPUbpBF8LiAYMkaG81VVtHmAKzJkD2fQUcKZpQe3twZA55W07FQcVEaX6qfDj9ZGbztZpSFLzmAi2tcg2hL2dMM6HWXa7zlZ/deFPuEVB8qr9Nvq8vz1PswAbJgCBFYixNk/v8oxmPcuI1l/yfclXWVya3Cng==
Received: from BN9PR03CA0957.namprd03.prod.outlook.com (2603:10b6:408:108::32)
 by MN2PR12MB2912.namprd12.prod.outlook.com (2603:10b6:208:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Thu, 14 Jul
 2022 08:14:31 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::fc) by BN9PR03CA0957.outlook.office365.com
 (2603:10b6:408:108::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13 via Frontend
 Transport; Thu, 14 Jul 2022 08:14:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:14:30 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:14:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:14:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:24 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 04/11] vfio: Move vfio.c to vfio_main.c
Date:   Thu, 14 Jul 2022 11:12:44 +0300
Message-ID: <20220714081251.240584-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec92bb90-96ad-446d-54ba-08da6570e0a9
X-MS-TrafficTypeDiagnostic: MN2PR12MB2912:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TCuUddkQPH1xM+5sotvPt/cVxgIyLHEL+eIxoj0wb1okGE4dAeO8OBtBWCxPQev/87pEx6QKo6afaGutXXPejWKZQiEgOCa0co3Asel/XQT7Uq1q7XaoJoQEM00bckU0ZAJdzlFxF4xPtF+fNmshaZJUgK2tDAzYT2q2uRUJOdi/wvvv5jUVyn9uKJ3heGSK2fzfaeR+th/Yv5g8aiq0qts4k4p2LR33EX2CApYl2Ns9H4F5I4glK+YuXu+BXqfyfq8CUwgzkyT7UqL0+hBuuS1ovgzQQZawXoonEAaMTNVcfvess8bLz/X+kJ6UFRbH4XkvittNanwYMew4DDXJaiprYvpRix/kU1rlu7Qk5tHQ20CrY1dWQswwAyPXgGLxy8JHYdZouZ+IZ5QNkcF4/t7pb9dxwhUQfM3z0FtZcrTkkLnQl/UK6kWKaH+K77SyAbjAJxxRqEmOpuHT/FRQ+Z0n2YaURDWPq3flkt7jIfkTEPbZN25/WFM21LfQumZFZgdCZ9y8RdEx7K/Vj8NTyks8uYYumdGaJgZoVupT0w5jn06qxK3KjhOwbv/E6Kz4eG0vpMh6adUbk35/OjMkU9tOxsUJB59n4NQ8jwc6lFfQF5+4/epc9napZQYuHFrcyT6pg+c+I13yxpvRiUdrTRS2RMWpFMnhuOP6+4TtNOPHMfpDEyrUBnNfHmru7lTjjARfeUUTTnm1HLBIRg1JxUVWgPtQuwQZAmK3MoZakObpeqU7htyEGFErOBBlRpq0kPha2fXiEi2d5WjpAL7thXEOsnvEYjKTJ06S1K77nq161xRjTq3YiH4tZGNc3LqhirQcmyJ3xFNIRTcUdh52mTX7Xbv6cJlPQC/s2hUEjCA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(376002)(40470700004)(36840700001)(46966006)(82740400003)(82310400005)(8676002)(6666004)(336012)(40460700003)(478600001)(86362001)(426003)(47076005)(2616005)(316002)(356005)(41300700001)(7696005)(2906002)(6636002)(36860700001)(26005)(70206006)(40480700001)(70586007)(8936002)(5660300002)(1076003)(36756003)(81166007)(186003)(110136005)(4326008)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:14:30.4407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec92bb90-96ad-446d-54ba-08da6570e0a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2912
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

