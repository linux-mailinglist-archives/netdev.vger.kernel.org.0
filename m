Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE0E574665
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiGNIOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiGNIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:14:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE54B15FE5;
        Thu, 14 Jul 2022 01:14:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B+CCRmwP2Ld8p7gazf1JCqvUVVfuKPlsMRDwmyuUqdMC+KDpGVGOZ9mAFI01Ru49kEWPCxNZV1tGCTWiAhJXueuU3znRUH1XK7Zl8P9W0XisygdZZClMsMLvw/BMmsXC1P79ieaV9xQPhcW55Ah7ekz6btvwlsFinrk2+YHBo1hZO+36iPQ6eo9IpCkcV/e/rIfa3qAfdz1BncmLmj17oSfdZ7H+tkrwPL5n1yuJJARR7aFI9+H9u6NUABQ24ODHbtPx/R0wF7h3VA+wPwaL3YOadvV7mhiW6TKwK7u3iVOfTJwH2avprS5N8ySa5F8qzIPdIgU86IFzebl/CuhYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4JdbKu0MzhBJ0sGh2SqiweMMesCWP51YM9yxxylbHxg=;
 b=nK5L/4UW2I7tDpayiCmj1b5YVClKrkhnTM+CvrmNi5veKn0HcgRo3RErkAblXMSoLRZyVK5tdn1YmUFKpAtWikuB6yuoePZzGuIbm3ydppXskvhqa8wPvBhDOjMcfQm8pPmHRGBQrHdcusiDZpI9aVgBhHkDYkZmL5tGyB8wkIPN70RyC48on1JMYJKEDJPVXYvf0OLcnLyf0Hf1dq+ZYJxhOhjeAAYAtDUt7UDlSYjx3Kzm6aJkV9WkGFMXj9/8G+Sj8vO3wg7XAwfrpKXP6SllC2NAepiiAubHZIKAjoW9v0SseCJb20MsVA7OMiOcwsPhaygpGt3sM8dQrJgeiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4JdbKu0MzhBJ0sGh2SqiweMMesCWP51YM9yxxylbHxg=;
 b=tCH7dJOQVAhaV051v8JtTTmpIaPzVq0lyWAuY3XHc4hYX1IyOOjUYTilDfO2KZAjjnRqABgrN+ByOwa6aeNFtTzCJY2AtLNvUMy3BEKyF2t/7UrZLPZda3ke3dyJkWzsM4+liDj375KBPSV6zYUxrUuLwK0AbOt1Y6giB/somOOyJfkyIAah9h/48glzYTEMItwtMVKstOUS0YN8Zw8Y7urL9rTGgfg2Ebyi5gPhYtRGCSlmaU/ii9mTLigJMmyrYBJTJmEwB1yHoGz6RoimGDdtb+ReDiTY5VOla/zmo/Rz0ZjiiS/PAjoOvZSobcaXihw0ndllXkWO1bplvJpgwQ==
Received: from MW4PR04CA0254.namprd04.prod.outlook.com (2603:10b6:303:88::19)
 by BL0PR12MB2515.namprd12.prod.outlook.com (2603:10b6:207:40::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 08:14:08 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::4) by MW4PR04CA0254.outlook.office365.com
 (2603:10b6:303:88::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26 via Frontend
 Transport; Thu, 14 Jul 2022 08:14:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:14:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:14:07 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:14:06 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:03 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 00/11] Add device DMA logging support for mlx5 driver
Date:   Thu, 14 Jul 2022 11:12:40 +0300
Message-ID: <20220714081251.240584-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33cd4560-4b0a-4dbe-84f2-08da6570d356
X-MS-TrafficTypeDiagnostic: BL0PR12MB2515:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?foKXhngkeGPUHGQfsGZheFOlX7Et47RLZcxIWU8vRNc2nt3RfpW35D1Qa5q4?=
 =?us-ascii?Q?sw0byZ5CP1Xi6xmlE/U1KRv9HWSROeH/VOF+cAGw0yRYseefpW7DXOLkwAQx?=
 =?us-ascii?Q?D/8yT+JWXnvZg/M0FzfFmoIA2Y9CemOnvvVr8EEPCGOoOCED5wdNWsMuk26z?=
 =?us-ascii?Q?BRXXzfGISvkuf6Dyn3LygyXhRttonJjkxQR+NYISXKa+VYSV6BiNXzL4aFzC?=
 =?us-ascii?Q?cd0SxhWUQRPA6RfuWxOMoWQDyGFNYJwtt/2ZKMxC7G01DDvfIOlGk2vZzq5Y?=
 =?us-ascii?Q?9gFGTj+Kk3M2hHJWBWznFr+aN4mFk4hBusXVpMIdZHc81+0akrGC4wj6Pzvm?=
 =?us-ascii?Q?DDuzMwDsUUjs6/80At1XZ/Vxihj4u/urj4WrRsHnsqcOSrkrV2bacH172I5L?=
 =?us-ascii?Q?S632onwvLlFWuWDA6rXF3hUnJcpgsjxcw+sz0okwsS8zYUuMHu+/hj1vpo6g?=
 =?us-ascii?Q?9n/j31DBYhacXVZe7EYV3S+mnJWBOWtPcelZcwL8HGjh6KGtUvngsLtKobsH?=
 =?us-ascii?Q?nNf1PVxa7UWRJOV930RoQ1CD792E105/0LEEzJhJ6xTkPE1BJcIa+PyVFRpc?=
 =?us-ascii?Q?Dx77XA8EJ2Nda5aeVA0DQ8U+giYw4KHZfXsOiIOrnp8WPITqcDKYeYcCrrhQ?=
 =?us-ascii?Q?QPnnM09dT3vHLiifLiCLfOUOYu+fSVr8GN/PVQX8LQi4OdSz5RMXhA7cLAbK?=
 =?us-ascii?Q?Jqv84euKIV2zGwf2ZhBJTEv/f1bZWgdZrPTeqYDYrBlZzvKCgH9/2+7TngAu?=
 =?us-ascii?Q?6Z4z0PXYb8e3beH4uresx60Emm6NI9GyLG8ZVdSsuGJg+XDYk3houSDyZtz9?=
 =?us-ascii?Q?vGLlZXLsqK0Wfsop3vReM2U9qisBGiGROOSB7AVmISV7E3DV4sglwj+fC1jn?=
 =?us-ascii?Q?AkhC4O040cV8DupYz4K+MmoScOZbMcFMVM8zxUVFXNEpJfnUX7xb6QBLwwBf?=
 =?us-ascii?Q?bjJGm5OjtF+Hsm1LGuynSC6JGoVOyj3ev/AKFmGvf9o=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(40470700004)(36840700001)(86362001)(8936002)(5660300002)(1076003)(478600001)(2616005)(966005)(40480700001)(83380400001)(6666004)(7696005)(40460700003)(41300700001)(2906002)(26005)(186003)(336012)(47076005)(36756003)(4326008)(81166007)(8676002)(356005)(82310400005)(70586007)(6636002)(70206006)(426003)(82740400003)(110136005)(54906003)(316002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:14:08.1658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33cd4560-4b0a-4dbe-84f2-08da6570d356
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2515
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds device DMA logging uAPIs and their implementation as
part of mlx5 driver.

DMA logging allows a device to internally record what DMAs the device is
initiating and report them back to userspace. It is part of the VFIO
migration infrastructure that allows implementing dirty page tracking
during the pre copy phase of live migration. Only DMA WRITEs are logged,
and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.

The uAPIs are based on the FEATURE ioctl as were introduced earlier by
the below RFC [1] and follows the notes that were discussed in the
mailing list.

It includes:
- A PROBE option to detect if the device supports DMA logging.
- A SET option to start device DMA logging in given IOVAs ranges.
- A GET option to read back and clear the device DMA log.
- A SET option to stop device DMA logging that was previously started.

Extra details exist as part of relevant patches in the series.

In addition, the series adds some infrastructure support for managing an
IOVA bitmap done by Joao Martins.

It abstracts how an IOVA range is represented in a bitmap that is
granulated by a given page_size. So it translates all the lifting of
dealing with user pointers into its corresponding kernel addresses
backing said user memory into doing finally the bitmap ops to change
various bits.

This functionality will be used as part of IOMMUFD series for the system
IOMMU tracking.

Finally, we come with mlx5 implementation based on its device
specification for the DMA logging APIs.

The matching qemu changes can be previewed here [2].
They come on top of the v2 migration protocol patches that were sent
already to the mailing list.

Few notes:
- The first 2 patches were sent already separately, as the series relies
  on add them here as well.

- As this series touched mlx5_core parts we may need to send the
  net/mlx5 patches as a pull request format to VFIO to avoid conflicts
  before acceptance.

[1] https://lore.kernel.org/all/20220501123301.127279-1-yishaih@nvidia.com/T/
[2] https://github.com/avihai1122/qemu/commits/device_dirty_tracking

Changes from V1: https://lore.kernel.org/netdev/202207052209.x00Iykkp-lkp@intel.com/T/

- Patch #6: Fix a note given by krobot, select INTERVAL_TREE for VFIO.

Changes from V0: https://lore.kernel.org/netdev/202207011231.1oPQhSzo-lkp@intel.com/T/

- Drop the first 2 patches that Alex merged already.
- Fix a note given by krobot, based on Jason's suggestion.
- Some improvements from Joao for his IOVA bitmap patch to be
  cleaner/simpler. It includes the below:
    * Rename iova_bitmap_array_length to iova_bitmap_iova_to_index.
    * Rename iova_bitmap_index_to_length to iova_bitmap_index_to_iova.
    * Change iova_bitmap_iova_to_index to take an iova_bitmap_iter
      as an argument to pair with iova_bitmap_index_to_length.
    * Make iova_bitmap_iter_done() use >= instead of
      substraction+comparison. This fixes iova_bitmap_iter_done()
      return as it was previously returning when !done.
    * Remove iova_bitmap_iter_length().
    * Simplify iova_bitmap_length() overcomplicated trailing end check
    * Convert all sizeof(u64) into sizeof(*iter->data).
    * Use u64 __user for ::data instead of void in both struct and
      initialization of iova_bitmap.

Yishai

Jason Gunthorpe (1):
  vfio: Move vfio.c to vfio_main.c

Joao Martins (1):
  vfio: Add an IOVA bitmap support

Yishai Hadas (9):
  net/mlx5: Introduce ifc bits for page tracker
  net/mlx5: Query ADV_VIRTUALIZATION capabilities
  vfio: Introduce DMA logging uAPIs
  vfio: Introduce the DMA logging feature support
  vfio/mlx5: Init QP based resources for dirty tracking
  vfio/mlx5: Create and destroy page tracker object
  vfio/mlx5: Report dirty pages from tracker
  vfio/mlx5: Manage error scenarios on tracker
  vfio/mlx5: Set the driver DMA logging callbacks

 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
 drivers/vfio/Kconfig                          |   1 +
 drivers/vfio/Makefile                         |   4 +
 drivers/vfio/iova_bitmap.c                    | 164 +++
 drivers/vfio/pci/mlx5/cmd.c                   | 995 +++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  63 +-
 drivers/vfio/pci/mlx5/main.c                  |   9 +-
 drivers/vfio/pci/vfio_pci_core.c              |   5 +
 drivers/vfio/{vfio.c => vfio_main.c}          | 161 +++
 include/linux/iova_bitmap.h                   |  46 +
 include/linux/mlx5/device.h                   |   9 +
 include/linux/mlx5/mlx5_ifc.h                 |  79 +-
 include/linux/vfio.h                          |  21 +-
 include/uapi/linux/vfio.h                     |  79 ++
 15 files changed, 1625 insertions(+), 18 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 rename drivers/vfio/{vfio.c => vfio_main.c} (93%)
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

