Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080A35A9352
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbiIAJkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiIAJke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:40:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2329FD8B1A;
        Thu,  1 Sep 2022 02:40:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dCjXN6wbl+NcAU01aViESjqDU0ayXA0Frx9FjUB3qH4R7DMTGF4tP3g/bSsVAF9NU8YIhy8iSELoV+spAwSJz0Mtr4zldLmL5IjKrkUNJrBr5GnfYb9+M1v5Y9EHSsUeFjEcZQOm6tG16lonveT0wSbfnZitUr3H882yMlNMGnog4YLc5/RpZUkuP9ahRVcEGFH8hqliQCTsfNIY8H9MCc8ByOv8Bnv3nYC8mz+oAYPw9Y1b3+eZwPgbARkxfen1cOR+XPzQJsBzKNjeCUcQAflijN5qMPDHKwD6pd2ad9o3OuM5onZV+L8dBABzIbjLsSqJCwBEjGR9M3fslH0GWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B48T8XiW685plLKgZE2LQ4mYOPPBTF7au37dftSgeDo=;
 b=D/4PVUvgakX0dvfkfBU2+f8hFcEfEeL0t3xuB1cYRapO/b6Xcsq3DVzap0CHjP6WwUOudOsSnEj2Cfrie15Jlw+Ct5G/hrFZrIUjokCIakDq0yEI94YRxMAJux5N0Sj86DYajlX6sDbO2GjtWQwBSH8QYTI0lgCqCZObVPENIWyjz2pD+smLXZtjCij+zr7vhYs81zVQjjzuOrtWDOoAfUe4PiZgKOUJo6p2XWkhIqgbQbLeJWM5pdi9KeMQ4/g+8ABjuBZ8YxkK9PkenKU5D9X/hLTk2lQ4zhA1DpnAvQfiYBvEpzxNBCupG4tVJBBQhpuxgg2NwTV1TJ9vPXOX8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B48T8XiW685plLKgZE2LQ4mYOPPBTF7au37dftSgeDo=;
 b=a4+oFeyOqDO7DkXeF3G9Gd4nV1k8hCTx2SCquCA4lGPyVvCF85tLdwGEU3BCLH9+VF5sAIYuRYnlux0uqKeMQwUh9S9ufDtopsKeoOXYKYzDAuflU5Y4MtsDkLyH1uvUIbtK9bmHrsJqaasR7cM9TrZB85UqhDnuSp2A6ymRbIZRBk4HjvT+em+AjxsILqhY/0HbaQYySJRP4jPnc8KtrQqijLbniu2r1X/+L5nyOsaaSDb8TAKYn34MB6QqUWwVAupRtjZGGNI24hQpdAs53r4UXEpKF8T4JsxKDg08cNlzRoWRjS7YUQL09+qMKHZ5FqjvolcY0qIfHpynroyp5Q==
Received: from BN9P222CA0027.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::32)
 by BY5PR12MB4935.namprd12.prod.outlook.com (2603:10b6:a03:1d9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 09:40:30 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::fe) by BN9P222CA0027.outlook.office365.com
 (2603:10b6:408:10c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11 via Frontend
 Transport; Thu, 1 Sep 2022 09:40:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:40:29 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:40:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:40:28 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:25 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 00/10] Add device DMA logging support for mlx5 driver
Date:   Thu, 1 Sep 2022 12:38:43 +0300
Message-ID: <20220901093853.60194-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b247fdf5-c4ab-42fd-ea4a-08da8bfe022a
X-MS-TrafficTypeDiagnostic: BY5PR12MB4935:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xvvrqLbL32awGiwu90FtIuD3lRSi0sRaQry9DRs2/aLHwuGqpLTiwPgqCUXn0CnfpfOCOyjSZDbzQBfj3XtlsOpGTlGEnLqFzTfHs0nurds5E6mRgQsNRfvs8ejo8BEXebplBu+Y4Zm2Qlusfoo3iPKtZ1sUDFQF9crvBVA1feiHNgHwnUgdYeiwKESd4fbyG+iuFdooQpQw0etM6BCh6XquzcwXTlvSyoI800V2RtdsWHT0t7wtDdWWVxp802HXnrvbltEDjEjhiJzs2iKalVWXYC1AbmI0Gm2xJxcVEmNmomonMn2QBNgdNFEDX8y+sH7s4/q9lCiDUz8Z42eKydN5szvYlhtFdlhU1un+Xec3/0ZkEaeszWp76eQru5qNBVxQzn1r1nO4/obdGpoLS0ha5ySIE6iFXjlWL04TDR3hYuzuppqSzHrRfsHipOSZYpU5qAvIkpM8GHttqcwflOigmN30xRRMKRb5OgwD4KwATuvyUk66LpIMn98wmlWiJBRGAOmCuzclAp+uQiycOt56/PAiPa+GzZXZ+XVa0VnuQvQqYLfxvI1dx5H8x41EdBkT5D0xXlUQPHZb+NgXvztE7DfT5WlUNIAz3l6mZKDxQc7JRfbw3aoWzBNtV6Jz7uuJP/6qUw+X5MsEKZLEN/SvBiw+d2d/uSz0j/uiGVeptXM53/OUHS/YcYnE19tBhG8WnQVFoXNshry1tdGRs8fzwqCRrieQ2hupjJmndZbbdCPRnEfwtsok3H1ADMTZ1Ss+grBFvMIcpCSLRcH14I3sfhlhfX73scQfmpVbWMiyBRsQHBLuYYkrmMGZBICvCSdc01KbX4UBukJc1G/dvc29VYWOi3aZJPxybEhXVRiUnWedjv55KQ6EFyqzwuPP8snWJgwqprVvX26wY6YiO6y2u6QuYGNGro1KDv0i0SQ=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(136003)(40470700004)(46966006)(36840700001)(478600001)(41300700001)(966005)(426003)(26005)(336012)(7696005)(6666004)(186003)(1076003)(47076005)(2616005)(2906002)(8936002)(82310400005)(40480700001)(86362001)(36756003)(110136005)(36860700001)(54906003)(316002)(6636002)(5660300002)(70206006)(70586007)(40460700003)(4326008)(8676002)(83380400001)(81166007)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:40:29.8323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b247fdf5-c4ab-42fd-ea4a-08da8bfe022a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4935
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
dealing with user pointers into its corresponding kernel addresses.
This new functionality abstracts the complexity of user/kernel bitmap
pointer usage and finally enables an API to set some bits.

This functionality will be used as part of IOMMUFD series for the system
IOMMU tracking.

Finally, we come with mlx5 implementation based on its device
specification for the DMA logging APIs.

The matching qemu changes can be previewed here [2].
They come on top of the v2 migration protocol patches that were sent
already to the mailing list.

Note:
- As this series touched mlx5_core parts we may need to send the
  net/mlx5 patches as a pull request format to VFIO to avoid conflicts
  before acceptance.

[1] https://lore.kernel.org/all/20220501123301.127279-1-yishaih@nvidia.com/T/
[2] https://github.com/avihai1122/qemu/commits/device_dirty_tracking

Changes from V4: https://lore.kernel.org/netdev/20220815151109.180403-1-yishaih@nvidia.com/T/
Patch #4:
Improvements from Joao for his IOVA bitmap patch to be aligned with Alex
suggestions. It includes the below:
* Simplify API by removing iterator helpers to introduce a
  iova_bitmap_for_each() helper
* Simplify API by making struct iova_bitmap private and make it the
  argument of all API callers instead of having the iterator mode.
* Rename iova_bitmap_init() into _alloc() given that now it allocates
  the iova_bitmap structure
* Free the object in iova_bitmap_free(), given the previous change
* Rename struct iova_bitmap_iter into struct iova_bitmap
* Rename struct iova_bitmap into struct iova_bitmap_map
* Rename iova_bitmap_map::dirty into ::mapped and all its references
* Rename iova_bitmap_map::start_offset into ::pgoff
* Rename iova_bitmap::data into ::bitmap
* Rename iova_bitmap::offset into ::mapped_base_index
* Rename iova_bitmap::count into ::mapped_total_index
* Change ::mapped_base_index and ::mapped_total_index type to unsigned
  long
* Change ::length type to size_t
* Rename iova_bitmap_iova_to_index into iova_bitmap_offset_to_index()
* Rename iova_bitmap_index_to_iova into iova_bitmap_index_to_offset()
* Rename iova_bitmap_iter_remaining() to iova_bitmap_mapped_remaining()
* Rename iova_bitmap_iova() to iova_bitmap_mapped_iova()
* Rename iova_bitmap_length() to iova_bitmap_mapped_length()
* Drop _iter_ suffix and rename @iter into @bitmap in variables/arguments
* Make a whole bunch of API calls static, given that the iteration is
  now private
* Move kdoc into the source file rather than the header
Patch #5:
* Adapt to use the new IOVA bitmap API
* Upon the report UAPI enforce at least 4K page size and not the system
  PAGE_SIZE as pointed out by Alex.
* Add an extra overflow checking in both the report/start UAPIs for the
  input iova and length as pointed out by Jason.

Changes from V3: https://lore.kernel.org/all/202207011231.1oPQhSzo-lkp@intel.com/t/
Rebase on top of v6.0 rc1.
Patch #3:
- Drop the documentation note regarding the 'atomic OR' usage of the bitmap
  as part of VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT.
  This deletion was missed as part of V3 to match kernel code.
  To better clarify, as part of testing V3, we could see a big penalty in
  performance (*2 in some cases) when the iova bitmap patch used atomic
  bit operations. As QEMU doesn't really share bitmaps between multiple
  trackers we saw no reason to use atomics and get a bad performance.
  If in the future, will be a real use case that will justify it, we can
  come with VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT_ATOMIC new option with
  the matching kernel code.
Patch #4:
- The rename patch from vfio.c to vfio_main.c was accepted already, not
  part of this series anymore.

Changes from V2: https://lore.kernel.org/netdev/20220726151232.GF4438@nvidia.com/t/
Patch #1
- Add some reserved fields that were missed.
Patch #3:
- Improve the UAPI documentation in few places as was asked by Alex and
  Kevin, based on the discussion in the mailing list.
Patch #5:
- Improvements from Joao for his IOVA bitmap patch to be
  cleaner/simpler as was asked by Alex. It includes the below:
   * Make iova_to_index and index_to_iova fully symmetrical.
   * Use 'sizeof(*iter->data) * BITS_PER_BYTE' in both index_to_iova
     and iova_to_index.
   * Remove iova_bitmap_init() and just stay with iova_bitmap_iter_init().
   * s/left/remaining/
   * To not use @remaining variable for both index and iova/length.
   * Remove stale comment on max dirty bitmap bits.
   * Remove DIV_ROUNDUP from iova_to_index() helper and replace with a
     division.
   * Use iova rather than length where appropriate, while noting with
     commentary the usage of length as next relative IOVA.
   * Rework pinning to be internal and remove that from the iova iter
     API caller.
   * get() and put() now teardown iova_bitmap::dirty npages.
   * Move unnecessary includes into the C file.
   * Add theory of operation and theory of usage in the header file.
   * Add more comments on private helpers on less obvious logic
   * Add documentation on all public APIs.
  * Change commit to reflect new usage of APIs.
Patch #6:
- Drop the hard-coded 1024 for LOG_MAX_RANGES and replace to consider
  PAGE_SIZE as was suggested by Jason.
- Return -E2BIG as Alex suggested.
- Adapt the loop upon logging report to new IOVA bit map stuff.

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
 drivers/vfio/Makefile                         |   6 +-
 drivers/vfio/iova_bitmap.c                    | 426 ++++++++
 drivers/vfio/pci/mlx5/cmd.c                   | 995 +++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  63 +-
 drivers/vfio/pci/mlx5/main.c                  |   9 +-
 drivers/vfio/pci/vfio_pci_core.c              |   5 +
 drivers/vfio/vfio_main.c                      | 175 +++
 include/linux/iova_bitmap.h                   |  24 +
 include/linux/mlx5/device.h                   |   9 +
 include/linux/mlx5/mlx5_ifc.h                 |  83 +-
 include/linux/vfio.h                          |  21 +-
 include/uapi/linux/vfio.h                     |  86 ++
 15 files changed, 1890 insertions(+), 20 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

