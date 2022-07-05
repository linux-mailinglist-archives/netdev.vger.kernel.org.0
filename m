Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CF25667F8
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiGEK3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbiGEK3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:29:07 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5B9140EB;
        Tue,  5 Jul 2022 03:28:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W00NQc8iHaAhHg+w9Tz7QshfQhAONw+CaT7N6zO0rjMXXfxK8xOhGooy+LyCkjr7plxp3G+Vx/+moXESBfUgwtwePsqzuJlOFzbXJufzQaf1WL01dnR9c7vqYUtREwx94fzTu1niNdJOqFWHjcNdrFrVrzymB6H4lAzLuiMQ9GQhHDYEaTzsEHJfZBdxKysKsgXC6E1BK2xatxooGkXT06uv0vFJVJu/At6iAhw8dSKcrK0cMgLS/b5kQ/jKbqFM5XjfPRRLo91eVCQ/kwUx2iMolC0PVjtMMNub3X5mtf9OSZ2PopBITxYn/vvXHUqaZozNBtZ9pV9VelNIsn3o3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=jf6XrkUZCUo/2mzYUg+d/JwFTVGENfxPO4zD8aw3ERO3UeBp7XSQz83MamF5FgB1dh7NBB8AUingqAeaDIPg+9f+kERI6q+NLHmsx/X6EDOyU7mjlBUeGfzkBaBxJRo/mmKh9y6DOihQ5zpRXASXSRNu9ZZM+6JcG2k3LRQcaZM9buf2Or2hfGmnBcn7N4sbjpsaL9V5528c4q0KfrYXZFzFtzalyCsU1+9gIkPtTwnji2qFwOFE1QpSv063Kq0yU8GNocVDeLqNPzvUVL4ayr13n/BTnJ+auEe4XAfoB64II9E23sGq/vwgcuJZIuWa/0Eg5mNy7Ri1ZH76DjeLug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1a9nPGQnJoIq+MBq1vFZ3JgFZjjSYJMAj3WLjTda+o=;
 b=ZpMtjRKeEOsVECnid4x9OTIFLODfqA9eAd+xTyGSstdX5jrVlIl3ZrGMXFfnRbYtDoHJLfAdlvaySP7NZLn9lILWO7g8EMt7j4L/GwLhUHCAtAz73oQEg4AtEFkwttyM6JT6umnL3H169nxo78+FZD6i3eUFzDxYVHRXrTATA4NfeOyiHHQ6amdI8gziXgLQ2dfET7X6vmigMXBH3qNJqqeQboFKmLuUXSLI7rDscCVdqJv9Qu60goX4qLGyrBorlMJgrnzGELy3/KyScqjge8gJXgWEfhd5hCoSQnnCTdGdF2CagCXvemTOj6ii1REcfcdTqaHYmMSaeD974bnYYQ==
Received: from MW2PR2101CA0006.namprd21.prod.outlook.com (2603:10b6:302:1::19)
 by DS7PR12MB6239.namprd12.prod.outlook.com (2603:10b6:8:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 10:28:46 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::41) by MW2PR2101CA0006.outlook.office365.com
 (2603:10b6:302:1::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.6 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:34 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:32 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 04/11] vfio: Move vfio.c to vfio_main.c
Date:   Tue, 5 Jul 2022 13:27:33 +0300
Message-ID: <20220705102740.29337-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220705102740.29337-1-yishaih@nvidia.com>
References: <20220705102740.29337-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64f3c6dd-0c31-4944-044f-08da5e712471
X-MS-TrafficTypeDiagnostic: DS7PR12MB6239:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 95QArsZzPHorz3WvMhsm9hcKN4CjVJ6EBAwiDFYggWgJV30MepHyYiC6IA19TerBZlt16vuaI1rKdVy6CuOLSqZ4Hjj33proX0AqhZGnYOj8aqsR+zt5koPaS3E5UctN2fvbWA10395W5SxmL9CkAT0KRpeyHKhwQpJldmeYs4926siKEFGCSP5WEPR4O7jhIUtYzqbGRh2i1wd9WZTp47f65a2tQQLwbwqMMKJeisu+SU57nih3hQyl6v0XBFdKf9zPpHuEa3Q8exKoOgnlMLqiSjYkejlQqVTiV9HTF49wymp4feuved7Q5ywpsaLswaAygpF94zxp8ImaOp2t7pDk5DBu6ELY/1K3dj0394Z50t/G4pvys992hG8t28WhSq7xXPHvXYddcf7LOmDtxAGVPZc/uu2bYmfBnd5tWpgel3BAe/RfJz+V/GEOHx1mBpCEKnJiJu/2bIPEEixigRAP38Kb4us0ktSLzhKunZflTYESw3QSCH4ZNotnFJ3bCC9Sm7kAiSNkKrvFqSAU/RZ8G8N/wHIb+XEyKzFa3QtvrQscWRzxnIoDd5VMyLb+uSJqfYaxJh7CtSbMbN8DpfoR19m4HR58s/By8RQ11lMARfvA/2yUsh0nOs8ETm8B2YBqSYSUXTA9BcHUHspsZfVHBGns3CZSH+rHRT4ArQwggB88ItCSXJYBs24/cIKG+d3FfFXuJiJp/4wIVLAAOkMpKjINUSi3rzE4G4rfuuUNciY21gnkFivoktqKy4kHZhu6ZRMM0YQOCqQrE79+za3Vz3lgJt1CxXSy2KzVmebVWqPNIEoJd8+Sk0VaJXcenDWFgzUr+/svu1H6JkKLpkUQkweBm27qT33xeKcjb+g=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(396003)(376002)(40470700004)(36840700001)(46966006)(7696005)(81166007)(1076003)(70586007)(4326008)(8676002)(70206006)(5660300002)(86362001)(2906002)(40480700001)(26005)(82740400003)(356005)(2616005)(8936002)(478600001)(36756003)(41300700001)(6666004)(426003)(336012)(47076005)(54906003)(316002)(110136005)(82310400005)(6636002)(40460700003)(186003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:46.0954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f3c6dd-0c31-4944-044f-08da5e712471
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6239
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

