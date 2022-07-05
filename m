Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDCF5667EE
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbiGEK2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiGEK2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:28:33 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46C214089;
        Tue,  5 Jul 2022 03:28:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6avaZ2A6P9F9EaYX9wIR4gWkWX0/gIfkDNj6O0E/ZmemArGCciGgEAqRJYhIF1DBOeaeBlyQ8EJF7iRuTnNtS4S7ukvJc1U/CF37kyE9JC3CgvDGj6I2OqJtnWGE93mzyi/N2x6VjIwxcJF5apnXZx8YIGgL4dLtCQQ2TGt+kMd/mqwTVUYa+PnuLWFYHrZ6wDOSnxtKfloNXrqLzZ7PZM2MYaWZwPMVEI/Xol9dkY1220MoTZflTOkx90rwONbJY36sYo6Nw5XpZO266d5X1pNfhizzMs4guU0bC9FYyhphRNhivIMPni9cDes/WZ4HxUc3/FexEZQTe87PQ1eWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRYI1akULLd6anTNE0veE8u3YQLk6wqpBq5j+t41MCY=;
 b=GMogT5245v2Adkv+/afjH1sF3TzMxAI2RdOwFaptHw6uasAb/nRrigjyOv8x61V4ml/K4AKNQNUQlZ6DQ3E8iaKZEsDCmppC6IQdpNl5u4cWkHMG0Yhuc4Fv8JlP5ruGTy2/Er/t1TJwxO2g+Jdwv5NXshMmEDLb1413JqYzI1GxtuaYjhIEIxLKJ6Hu4zVOQx3bDJod09RYw0fVTUtw6jj1ZXk6a6RPB33/bDSJx28eT+n1uiHMQlVbU/76wDSWJGQhGerxbOS2ROBGCBVz+j9G+nl/IRIB6i5CILbruOM84XcSN2swoYcNACAOh1dBhuelCZ3K7eXUY56WfBWFsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRYI1akULLd6anTNE0veE8u3YQLk6wqpBq5j+t41MCY=;
 b=tmrXgoZNoQig2GUaEnyA9Wun7MXiiq4MhrrW5FPiE6sXvxFGkHMjRdjiOkwv9E0DEA6scbTB8vU6oKWvtig5MtDbw3f9Hr7TY22VSpWaNo3wjtvDStnWz9R8/0dvL50l3DWf9ZxycZK3zU8eICOrEZnyDNpCoThsUp7voc96qg+0D2KGznhYa8WPbt0kcFbwT1IZ6VqH0QH2Z1FYmWk3FVckUV5isJSMlFvov37eN7mxw9dpxW3E3FRq2V3t4B5sGe+Y9GHhix8uCudnqIiVoBe9Fq0ck5WUmT3qGeBZ58tQxPOICXGEuQPC4xIVHyc5FyEiXjcwKnYRZmTgfqXJxw==
Received: from CO1PR15CA0063.namprd15.prod.outlook.com (2603:10b6:101:1f::31)
 by DM5PR12MB2488.namprd12.prod.outlook.com (2603:10b6:4:b5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Tue, 5 Jul
 2022 10:28:29 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:1f:cafe::da) by CO1PR15CA0063.outlook.office365.com
 (2603:10b6:101:1f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21 via Frontend
 Transport; Tue, 5 Jul 2022 10:28:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Tue, 5 Jul 2022 10:28:29 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 5 Jul 2022 10:28:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Tue, 5 Jul 2022 03:28:18 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Tue, 5 Jul 2022 03:28:15 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V1 vfio 00/11] Add device DMA logging support for mlx5 driver
Date:   Tue, 5 Jul 2022 13:27:29 +0300
Message-ID: <20220705102740.29337-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62b4b42e-3d06-4ae1-bd59-08da5e711a6e
X-MS-TrafficTypeDiagnostic: DM5PR12MB2488:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5Zhr0KqalBsPrUDeKq1KziqS9g76GtEzGPLH0B43bcTthK+GIE44GPaogUHy?=
 =?us-ascii?Q?CN/Pf0DkF5XwKrIYRbi3r2eAOMbOnIsMn1zARTyhrhvL1B2yj2R2JR+DmXqI?=
 =?us-ascii?Q?N7PnQOGVuoVzbaCV51xdK4OT2HnSSk+JZJ+8fF70phFaSEgt1L1BCCyq88BV?=
 =?us-ascii?Q?9qAs0EkGDthStQdaXLePLWJfCgAY1daeld8WdcM5p8hxy9qyi33I1zJsOBV/?=
 =?us-ascii?Q?7K7yupChr2PSDUcwOADttgS0bBhXUyQ1LimvmltYKfb4Y3zZ3lUIBGki7Bkm?=
 =?us-ascii?Q?aTOD4eCMbKA9R6BQvm/gixGlSmNxLtnDdYpJa856o75CvkxeMsSXZXdXcTr7?=
 =?us-ascii?Q?L5LOtqwb3miHAcAH25kpvkc0EQp33WBTLB36YgBaU2V3Gn4SR/K+uFu1fnSW?=
 =?us-ascii?Q?NSSZx1AZJxkbJz/PIMviBA79PA72ODRls1Z26+W536dp17PmFYX61h84hWtv?=
 =?us-ascii?Q?Z6O+1uWq/rJvNQBqWysnLK3Nh1A3u0XjEpXx1/al0Y8b2bd9TgJRf448GtsD?=
 =?us-ascii?Q?wD1PLxnZUeR9o1kEEiVnCpjJoPHGjC7Bqjonv59/yI4c3mdE1pqrh7fEGiol?=
 =?us-ascii?Q?FnbCpJ6c0Uz0jotbQldT9gmhVJcpTPUhBwNd6RwLGMhjAr49/jXM9mfhO2Xw?=
 =?us-ascii?Q?LNtrX8cFjTZufh9Dl+OUh4DGKVHpPSBb6IbZI8i6JBDgar7TtdseZ5qpuwTR?=
 =?us-ascii?Q?Hn34l7B8gO/nRtOUc9q21QyYPsnSzpw5UbsdziOnhTldOO1AwCEXAd6cy7OI?=
 =?us-ascii?Q?M0je8OEFomgEIBaZSHyQ4lCWsRcBlzkcJyko/WSWNuOpbDLxQPvWpaT6ziXE?=
 =?us-ascii?Q?Mt3L74U1speCVt5DzXYA83EZsGheQ5Eq/nUhHLlU2TbT9vVgc3Bh1wZIDNt0?=
 =?us-ascii?Q?oyfNVwBFJhmaT7HdyUjfCJaFo+aXjz77SkYkLyVN9Am0SJ/cOJwTygSCr0ku?=
 =?us-ascii?Q?P4HwAxvB1brw/ygV4CsxPhXmdSrfzjoRSN7D09tv4RA=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(40470700004)(8676002)(4326008)(70586007)(70206006)(82310400005)(2906002)(86362001)(5660300002)(356005)(8936002)(40480700001)(81166007)(82740400003)(41300700001)(426003)(47076005)(336012)(83380400001)(26005)(2616005)(186003)(6666004)(7696005)(1076003)(36860700001)(40460700003)(316002)(110136005)(54906003)(6636002)(966005)(478600001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 10:28:29.3189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b4b42e-3d06-4ae1-bd59-08da5e711a6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2488
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 14 files changed, 1624 insertions(+), 18 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 rename drivers/vfio/{vfio.c => vfio_main.c} (93%)
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

