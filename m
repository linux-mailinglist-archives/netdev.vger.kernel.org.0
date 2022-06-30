Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA825617BD
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbiF3K1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiF3K0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657464F1BC;
        Thu, 30 Jun 2022 03:26:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB/cY/FqbVDrRqSZ+Z6k0syIN2c+ZBWj/7b82jz05xMshjxo3xRVDPAyUP7peZb34A5zfPSVrTPo9uYtePTlLQE/vAB2kEJBKJs6F8UjBolfgQ1Gof9kK9v0cQC8UoCepCRtYcW88Qap+3HfRLR5SPgRwSKEq5j/8Dnkkf8FuFTP+YxgftJrdaHs87blwAca4vOaNdiBIsJC4K6LyfZYiG8sNaUikV82W34loewnB/p8igmtFFYckgrH651wzKx0QwGY0jFIE7eOTWV2N8M/SlwGBfYtHzzB3BBXC1H73gZ6Ggu+61pYrpI4q9j0MmBMUZt5xBXN4BQQRO4RFfPYbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6E8STGiPDonglNFDg49DH91mCe7hNd+m058SXmDaZIc=;
 b=n4YuWNq/steII4z+WXJiOPkAi5N5iqlwIpHhCtYoFig5IMUsBFJIMSDpahrGSMKc1hSzH4925TRehpQZeHnZ5ofPLpFMppCygnJjDfexI3n6OVAUD/K0y0auaY9CKiWkf1v3G71pI6kkTCpPqruyJ0ce0xd/GhhkzWHvipMwUMrCfFhuClSU2pGSJiJ1lEZb4iTvRe9gkuKEjZNkaUOUW5b9SpHMctv8Fp2JhWzsSQqrTtxNJBDCb601H7v83mFTZ3BrKyK5PwSURMZ/OdWzNnJmiRHSdJu/nHlY29IJDxheplHCKJtpUW3s1Q7NcgaxqZiRO2vzVryZCTkA8pl7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6E8STGiPDonglNFDg49DH91mCe7hNd+m058SXmDaZIc=;
 b=dZXGrzBTIPYNkW2iZh8Qw3HYXZ+JePHesa+FLR9bw9XvE7ReP4gfl0b+YbuiQrGJ4yoSF5zinM8M7vpi6DLARYAaHYDLLJOxSgJ5bVNlcrlZZiVqgk0bMHXI+LLzXCljqJR7NWBXso78aui75peEhcL8VpKN+xWMSOUI/Ns48+9MaMlCnitSysPawVtu48M/HJoqphKscVUrLPC9wY930KvxAQagvMLFph4uSRnv7ZiqRvTAHPgzhA3pulQviBp+z87/je80OJDfUvY37J+zqWKnms+q+5/g71PuVQW+11dFKclavpS2+vou9WPSRF0Ppq9D/mlSQJoWViFP47/9HA==
Received: from BN8PR16CA0008.namprd16.prod.outlook.com (2603:10b6:408:4c::21)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 30 Jun
 2022 10:26:27 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::48) by BN8PR16CA0008.outlook.office365.com
 (2603:10b6:408:4c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:27 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:26 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:22 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 00/13] Add device DMA logging support for mlx5 driver
Date:   Thu, 30 Jun 2022 13:25:32 +0300
Message-ID: <20220630102545.18005-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d5ac86f-c093-4400-0f9a-08da5a82fdd4
X-MS-TrafficTypeDiagnostic: IA1PR12MB6458:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QZsjU2EMSxWiFV6lEpw+1gCqywBJ2sS13HMFBH7KChgxYhUy+B3Gg/kKH4Yo?=
 =?us-ascii?Q?nB+jLxs5EAYiYIv2p6VP8aBnoVzg14nD8xEjBNUB8w+CWwSozvjQiBwAP1yy?=
 =?us-ascii?Q?0liuZS04CqYq9EY0YAsBxbuMqTJKacfH29rmbwFozRooLptW8FUxJF6tBtym?=
 =?us-ascii?Q?PCkyDj4KKHi5iUziu1dQul7nL7jo/8GXAovs/8hLR0C8vf6541z6GhMEag4y?=
 =?us-ascii?Q?D6ojpUEbwUSUmIY5u+QIT8jARQJwPPoIM4L/rAfg28HpWcdnC85xy83Vs95K?=
 =?us-ascii?Q?nXOAKa146yab2gBcwOHx1B2bCfWYZD34y70A4lPiqyQ0KyQmYm1+MCYbJdHd?=
 =?us-ascii?Q?rCZdb/nNDEsvGc/1qQF+Hqvi94QmyTzuY6f26dj8FS1pEFi8L/Z18vb1hF65?=
 =?us-ascii?Q?Qy/QEFnH4lUlivJzL0knEswsHbj5cZfWsQwW0+FCK/bN76QAPc2KaKwFc0TN?=
 =?us-ascii?Q?8RwZ56JZnq0ayyx06uoVNtEQOLtTaGe3a2uBv2OKKbfj4IFmThYns4EKos8b?=
 =?us-ascii?Q?I8MK8IrMI2zLUmQJhmF4vv8ryJIEZB1pxEI5pG2lVAAtHTCBp5HuF7jF61Zk?=
 =?us-ascii?Q?ro1ymgWGdvlkMjHPJhXCwfs6mwI4vsfw0WuetMFdKoPXj73wcAeLk2yC/73W?=
 =?us-ascii?Q?Og9FXDaJCU4/Bls6MzOp7+Me7RhHVaQnk8Kg7AmDBymMEIsavkAFaQZwn6SI?=
 =?us-ascii?Q?3b8BOt74utv12W9zbRoG54O7ke7l+NZfY45FcoszI/prwJbg/IuinORDLmIv?=
 =?us-ascii?Q?H3nENRs3KytO8HtB0S43RATJRtpV0KeXb57d8bYnBFBJ0ZsPbytRyNo571bY?=
 =?us-ascii?Q?j8WeHt4q9u6zmOX7YceE8ziSaCoMSXDWtliazzC7gTAM+LaOf38VgJkogeyh?=
 =?us-ascii?Q?KSUb5Iw8Sqn69SajI5oZQFitFrGr2FznioNU3Z4JQ5Nh09h/mBCWmAy47DJe?=
 =?us-ascii?Q?BcHBt/NZ+Ttx9lTEs+RY2jiRBfo8cZAvbPEDTV0m3A8=3D?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(40470700004)(36840700001)(46966006)(40460700003)(426003)(36756003)(47076005)(40480700001)(4326008)(356005)(6666004)(186003)(5660300002)(82310400005)(36860700001)(82740400003)(41300700001)(2906002)(478600001)(86362001)(8936002)(7696005)(1076003)(70586007)(70206006)(336012)(83380400001)(2616005)(54906003)(316002)(110136005)(966005)(26005)(8676002)(81166007)(6636002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:27.5253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5ac86f-c093-4400-0f9a-08da5a82fdd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Yishai


Jason Gunthorpe (1):
  vfio: Move vfio.c to vfio_main.c

Joao Martins (1):
  vfio: Add an IOVA bitmap support

Yishai Hadas (11):
  vfio/mlx5: Protect mlx5vf_disable_fds() upon close device
  vfio: Split migration ops from main device ops
  net/mlx5: Introduce ifc bits for page tracker
  net/mlx5: Query ADV_VIRTUALIZATION capabilities
  vfio: Introduce DMA logging uAPIs
  vfio: Introduce the DMA logging feature support
  vfio/mlx5: Init QP based resources for dirty tracking
  vfio/mlx5: Create and destroy page tracker object
  vfio/mlx5: Report dirty pages from tracker
  vfio/mlx5: Manage error scenarios on tracker
  vfio/mlx5: Set the driver DMA logging callbacks

 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |    6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |    1 +
 drivers/vfio/Makefile                         |    4 +
 drivers/vfio/iova_bitmap.c                    |  164 +++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |   11 +-
 drivers/vfio/pci/mlx5/cmd.c                   | 1007 ++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |   65 +-
 drivers/vfio/pci/mlx5/main.c                  |   18 +-
 drivers/vfio/pci/vfio_pci_core.c              |   12 +
 drivers/vfio/{vfio.c => vfio_main.c}          |  173 ++-
 include/linux/iova_bitmap.h                   |   46 +
 include/linux/mlx5/device.h                   |    9 +
 include/linux/mlx5/mlx5_ifc.h                 |   79 +-
 include/linux/vfio.h                          |   47 +-
 include/uapi/linux/vfio.h                     |   79 ++
 15 files changed, 1683 insertions(+), 38 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 rename drivers/vfio/{vfio.c => vfio_main.c} (93%)
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

