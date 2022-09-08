Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F75B25D7
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiIHSfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbiIHSfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:18 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F29F7E839;
        Thu,  8 Sep 2022 11:35:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ajs3G2DD7eTFm8MiHk/2zBZxd6COESBedU89g25dVH/dGYj2cs1T8VxHJ9vFVZYFjKqP8dkYLMmP8+befb8HNktXOm4lNfJ+JRBfgs7SwDzPyavG1CFdC9wxMpP26hcOvD5/zNgdHQ8LJVMjtm+1p9vX2Fv2YtJ8gcxETq2OPE67XZxVAq/MfeA98zBLnTWx2q9D7WMu8Zls2+pBgKXmhq31QRnr6+tQZr8En19lydWhY7jO9Td8t9YZvahRvZ7DWpjAyOgo2PRM4UJb3Oc9SuwV9gePUbwWY93ekIpNiYGBaRUV8Co8CyL77tZdPJalQTsGmk2FloC0CyvRjGamzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPzI/rQba4IdtyrPIl10ikOaIm2m4QLuaHNstlWmJ7c=;
 b=BlTPV/JZXnoLFr1OJ+44+O5ynutsQGr+C4aoOl2sRRUaUqgOsu294iWul2cc1OMYIIwl7SrNvpESiW+y5/VosvcR2cY6WikrthYQ22L3RQpQK7g2OHO/kxF2DtoxpVG+vdG5gkoEqfC5+W+XwlDft850YCX/WCE7OTE0RWoT01vmzGaIZI6RVhvNAZLzkJGsS7BtUiUeGGGyqUj4+NmUmA7qxpMIAMnLPHZXfOU+y/NvpyVgSqe5i3bfiSclAwL3r7efpCQVRW38pbwYbpr+BB51ocdRKYD73Q2AWJ39gt/0qnmc+MF4A//zdjnMIgZ8NpRWFZ6VPwHso2WQ5SZqMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rPzI/rQba4IdtyrPIl10ikOaIm2m4QLuaHNstlWmJ7c=;
 b=K5OFcpw99ssGA8DtdNQnsQqFQgADIEFpSx/DSNrF18OVZy2oUk9YdyPZy2vcEW3e0rTBGuIi3YYzXTUbb3j6HIsqjij6Wg5d5YldRr6mXGtuxvbDkz6wTp2VSs62ErdmXreqeuXTaNpG4TsITZHnmWlO2xjFgswF0EB0fZ8+87+NlS1BkMTbBQEet0vmpySqoEKbT4GTRF/8QHWeopPnEWKaJx3y/oUHZ57ZQIbuvnPcbVQ8uEIR+bUudTCFXsJYrh9acSjpjasjJfE8/qSiTlnEo/gaxBwdFdg0UT9rfGCFe36IAFYd39OLzKOZaQJzms+13mjdoxChCBUgw6S8+A==
Received: from MW4PR03CA0122.namprd03.prod.outlook.com (2603:10b6:303:8c::7)
 by PH7PR12MB6537.namprd12.prod.outlook.com (2603:10b6:510:1f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 8 Sep
 2022 18:35:13 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::b) by MW4PR03CA0122.outlook.office365.com
 (2603:10b6:303:8c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 18:35:12 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:08 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:05 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V7 vfio 00/10] Add device DMA logging support for mlx5 driver
Date:   Thu, 8 Sep 2022 21:34:38 +0300
Message-ID: <20220908183448.195262-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT041:EE_|PH7PR12MB6537:EE_
X-MS-Office365-Filtering-Correlation-Id: dce77104-dcfe-47e0-f2e2-08da91c8ddc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYB0mOuda7L0y5tItmtssm/rFhSjzWD/Ghseqx4EJyoR3fZzpz7BxVQo1pqsOWYtnfAwOeAHNS8qpG5diT7joDHZgeHMe9ShWhD5CvHaAyARURm1JZsA7HA0K3sLc/XdJRH1MNSHI2r01qikaIOyWELu/krxNx6xg3lkJ/1nOmBK0KjfXnMT5m1aAFJ3hLfxsPc2NHjnclkVjwmAHg9djHPYe4PncEEhCR7I2Hps462WHU8yIPftmSAUiKtH2ard4AoOBf9xz5B2lBqU9KTBPB+FtWOgQQxmXw6C+qk5abrkfLa0M/E7nxKQAFP4PYVXdv8eqHLTLVFkksLDGNTeM7vaXOONzyBfAZctOV6AUOvHE0CaQYd5+MLyMK4sBPXK7JudtHm9tFvZ2rqgLsahaBb0qT6Q8OHclrCMjRso2lFDXexOK3cZvNe8g97Dfjf1OpG4VurFNasZKuQoD9SDyXxHEdIr6bEii0pydPNh+7RZphOParkYMHk4Cjk4oxi72IMTwULJEKRBxM9690bBn1+KqnTnJRBTBKgx/Rw6FgwS6X0Vfp3zCEscz3vdNG92NnBUGd5fNX9ryA5bJdV1XT530p+/ff3gOK1FyJe9AfkEG16Djdyk5BfCaQU2XRUx7hajYM2Z+hDyrejniO7voDll5rnCPRinoC6qC1x+BYuJLkK0/rBvTlzPOKXNUQ30nQExFVYCwj18G+uzb7Wgt/k28eM4Lus0Yr8jQWlO8I6gjBjalJlhgT5bFUoL1nzyWqqSOS+QHx0Vg7gd7VAZ9BX5+pvJhtHsE/28Gov35hCvqJegLVUBUdl6p0OoKYJ2mrN6DgFslqeM8H2Qg6XTXOOIrIghk2BCyUxbxKW69gw9H0Pxkr6pIU9lgU2L/QjwssF3NZKihxy9mlOKhgBadb1YxmomVfb+dID387qXuy4=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(40470700004)(70206006)(186003)(7696005)(426003)(86362001)(8676002)(4326008)(70586007)(54906003)(40460700003)(356005)(81166007)(316002)(47076005)(110136005)(41300700001)(82310400005)(6666004)(83380400001)(478600001)(26005)(1076003)(82740400003)(36860700001)(40480700001)(966005)(36756003)(6636002)(336012)(2616005)(8936002)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:12.5542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dce77104-dcfe-47e0-f2e2-08da91c8ddc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6537
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

Changes from V6: https://lore.kernel.org/all/20220905105852.26398-11-yishaih@nvidia.com/T/
- Use the first two patches from the PR that was sent by Leon, no code
  change was involved.
- Patch #5:
* Add a documentation note near vfio_log_ops as Alex suggested.

Changes from V5: https://lore.kernel.org/netdev/20220901093853.60194-3-yishaih@nvidia.com/T/
- Rebase on top of the latest code from vfio/next.
- Patch #4:
Improvements from Joao for his IOVA bitmap patch, it includes the below:
* Make sure documentation refers to struct page pointer size
* Some rephrasing and grammar fixes in the documentation.
* Make iova_bitmap_set() return void
* Turn the iterator callback function pointer into a type as part of the
  header file
* Use max_t instead of max as part of iova_bitmap_set() to address krobot
  note

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
 drivers/vfio/iova_bitmap.c                    | 422 ++++++++
 drivers/vfio/pci/mlx5/cmd.c                   | 995 +++++++++++++++++-
 drivers/vfio/pci/mlx5/cmd.h                   |  63 +-
 drivers/vfio/pci/mlx5/main.c                  |   9 +-
 drivers/vfio/pci/vfio_pci_core.c              |   5 +
 drivers/vfio/vfio_main.c                      | 175 +++
 include/linux/iova_bitmap.h                   |  26 +
 include/linux/mlx5/device.h                   |   9 +
 include/linux/mlx5/mlx5_ifc.h                 |  83 +-
 include/linux/vfio.h                          |  28 +-
 include/uapi/linux/vfio.h                     |  86 ++
 15 files changed, 1895 insertions(+), 20 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

