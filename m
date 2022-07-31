Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46564585EFF
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiGaM4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiGaM4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2043.outbound.protection.outlook.com [40.107.92.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A4DDFAC;
        Sun, 31 Jul 2022 05:56:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biH7RnobiGJ7Z6yzNBUUkivv7tCbdFKurYzg/U1amKxu0gGD35rvyzYXwzYpPnwIN/qawT89kK+xw9wIQW2Fm/FhpKcdIs5JJk6j6D4igReiaSAsOY8/RlG7Rt7rzvidXyTyW9+5vJ0N4hxjFR46Zen/7Z/AZevGGk0gLjlFHInMOcsn9VyXNxA0cVlK6/fUp2qMjPgmJiP14QkdXXaLo7hXHz3WWo01B7cuwMHfvY1wbsQDirVQbaoWYXeoMhhfCVNfsKFxhUHB7LkgL6epCq4ZaGsxzkjl/ZR2KtXm98OtGbmjmTcftUMfe/0BbVKMLlXP2X1Vcx2e3SamxARyCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=kI9mbdCXqSb9ZRjZ2KxFfBNtHQUExfLSUTsWxYO3d52j0nhPcXsjmb0XUqvpcwKCMPLk20GXCT7y/9d7DQ1mypUCeKkc+NPG6pa+JlWCeEe5yVotY67xcLUJtIA8tvEYKezCXWAq1HJiDKDhd+T8q5ZdBA0sBLyyioFEExbSfxafNgG+8j2Sx513ASe92T8Mj2muvAn/g58un61fLNpoENUXZIzu9ZubNttBdZsHFZAUUe9rWE7tAfrVIJR61eMJsB/U34FIggxx6SUS8y4c95Zev8+VziAb5KnENqp4ma3kPgfHWABDAdmRPgOf3hICNnfIjzMy8B9B6gGdQt74IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=pRBgw1DqThXY8B+mP4E9lRSf+7CRKsfhYFxZyA8mAS/KZxs6HNwcOmxTzkbYj/5ZYohEofAbHsSItd9CbrOydgLB8X9RtBY7XgfIjpErRbwh1hLZF6GvQ2O4IY5o3BcfYaCeU6PSkp+87wblvlgTZ0P7X10x3LVXRdxikMKnSqo0Gk8Q67YvYMIr7i4B+NdW81JJasvXG7d7KwYgpxFfoKB8hhJqaga3O2jrtW3Ovdkt3zOs1B5Nt4GpvUewwXLS+efkSp5agZA79jcc10QJUwcHd9XG/8mwWfr5rYO72wnxtRI9d+X0mozYjwFFDCYCp35aKoHinuEjK65RyfzIHw==
Received: from BN1PR14CA0030.namprd14.prod.outlook.com (2603:10b6:408:e3::35)
 by DM6PR12MB4713.namprd12.prod.outlook.com (2603:10b6:5:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Sun, 31 Jul
 2022 12:56:11 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::64) by BN1PR14CA0030.outlook.office365.com
 (2603:10b6:408:e3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:56:06 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 04/11] vfio: Move vfio.c to vfio_main.c
Date:   Sun, 31 Jul 2022 15:54:56 +0300
Message-ID: <20220731125503.142683-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a6cba06-003e-49b9-793f-08da72f40b66
X-MS-TrafficTypeDiagnostic: DM6PR12MB4713:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +7zgAqXBIPmL7f+IHVwBI5kD8Ro419VeFHad6NZ8FvFuufuf1qUEe8+jyBuZ1wYhYYeciwMXTCWu7N/tY2c9I1YopbrWmwIjNmPiGL91elI9oPe/iawINEiX9hDLLlSUKSsD7mzknEAm3/su5KWjtmq+CcYCGa/cRd4wRBF4puKyOA/LGSHfBkLsBhEeoczypycF83O4x+mw+Yt/LMdZtfdK49WnzgtNN7Kc/OA7mxnLzN6WIksWfKEBnAyl5pvFroyyjdHA0BwFuhglXLH+9TF77YI2u3jKw0vr2R2eX2rPo3z1Us7q0uDHmIQQXxB2TqGpi7fYQnE1tG/sdU51/ie5SveT3EZ0TpYIJa5vUF24SOd5R2QR8/xVLS5MioQp5IdxBUE36mOVterbNmWgAm2fMuf9f+q+hQqDoVm2zvxBeqBmL4coXS/mvqBetbUpNURkAqU67edEHRwcMJPQ73oGl+5AZpEiks5G0KNxtv3bxLM8beZqDaKK6Yz2wAlMTU3Q3q8KAaQ4TFoceNraBIbAQy2xEuIOGdRDLyFtTtq/RQ4OmIo11s1QXc7pq5fvOKKOyge7kTUflSsu+V0jziIjlaBUdgmNL0gx4YL2FRS3i8XnbY5+oDlQ+HkQVrOI0CMfhS5VDclNoFVxT0Dv9x7cVKDs4UwBBuHiP40GrOGhJ8womqVUBLw6+fHgiKNB9vb8gATZ8DxWS0zbLm1xJdCjmWgWShfCnbFwWHHCD3uFfPvRzJAAHsebU+EbOrj+9BxcJIAkx7JGVJ6DMVBNUb+Kf/40rcu89u0pE2+2zq+8OmWCOk5DXNYRSwIcDPj8GBZuVKZCaTwKckcH/nrigg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(136003)(376002)(36840700001)(46966006)(40470700004)(81166007)(426003)(47076005)(26005)(41300700001)(2906002)(186003)(1076003)(7696005)(336012)(356005)(40460700003)(86362001)(82740400003)(40480700001)(2616005)(36860700001)(54906003)(82310400005)(316002)(110136005)(6636002)(6666004)(36756003)(8676002)(8936002)(4326008)(70206006)(478600001)(70586007)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:11.3479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6cba06-003e-49b9-793f-08da72f40b66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4713
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

