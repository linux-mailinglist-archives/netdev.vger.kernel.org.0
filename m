Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F625AD11C
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbiIEK7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 06:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiIEK7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 06:59:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90EE5A3E1;
        Mon,  5 Sep 2022 03:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A1FLhMZmFPFNjL7SsPmdAfrIpaoFGKXvWuXyDa8CwrGPxuEzK1JF7C5TMt4wTbORLsLnFOT6LCg6YG/64/8B4lumZsHkyP+TNYirBUOQJeCC1xSwQYrTsjfwE8/18prW8iRyhoQXeDFiyexJqaxEAX8AYpUTWlUpGdYV790HwgeaxHCZZm1aHO+gIMTP6ujkUUwiUGjYrqzoHp6Mg+YiXiTR89dtAfoEzRDBwkY0vL383JU79kOAzrEx0JH0gQlXw/v0aF2h0mtd8A72nzhtTTfpEf91RHZWRwYdEiZ56VwlFB9zhsTJjn4KrErQTnLsgOyApPgqVAj1RvT8LvYwsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nnsWvQxwsBtLG7IgJsKgIwjVGidi4hs7XQSH5RPxRpo=;
 b=PnHnDXlsuTrd7wLDRGB0Jznar9qqa3YOMqKaiqbARE/kFXQNWRH4Vt2szrqTTSmVsfmT88dFjMJBmDI9pqNj2WACmSzqu7Y/aRkqHhgPRAOTHMECPegyT6AME3odHlp5K7+FZOiiSKjbirJeSqc8b7VjhIsb4daCE0IcNQzkUOfu+WrBnzBdJFJYXO0Sehgu54ygdOyYbAC6yg5Aa/6w7vEpO35PNDDVQlldmhiz/oHRGuzzexAmpZATlk11699/M/Eo98FulWEtpndKMFUVgwkri7ztgGUJO11tVDprEztSUFbaZ8NULaoTw0iYFWFtGDe81vewVRTsVBkgHfHP0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nnsWvQxwsBtLG7IgJsKgIwjVGidi4hs7XQSH5RPxRpo=;
 b=IE7JiIANWvrqCCKCq6faTKLqIXZkU2ihtbGdHRMqLP+9ajVRYKq2us2UTHR5pyY6Jx/PNMap3BKiQ7K4AvuJEOy2NI0ew5KYCn4EQWaICB4ndzeGPeYTZvaSlbAny3I9cKnGeoB7zJ92GQ0W+PMbp/cPv2VzPtrA2KEiRxbnp7t2vh2RRwCbO0gawodUDg8DUqWjUo4cDYwUm/fLx4Ba77HWCfGN0WRLbIL6unPAj+xcCr6FSeR3lIKCGzJMpD+ECtDmttAIqwpJhi1FBk10KiMIv1CSZE2yIX7hzzDhJ6UYRWIxU0GcpyBv150fDOyh+6WwjNUXXpAbAbYKFsKo/g==
Received: from MW4P221CA0025.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::30)
 by PH7PR12MB6612.namprd12.prod.outlook.com (2603:10b6:510:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Mon, 5 Sep
 2022 10:59:15 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::a5) by MW4P221CA0025.outlook.office365.com
 (2603:10b6:303:8b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Mon, 5 Sep 2022 10:59:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Mon, 5 Sep 2022 10:59:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 5 Sep 2022 10:59:15 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 5 Sep 2022 03:59:14 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 5 Sep 2022 03:59:11 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V6 vfio 00/10] Add device DMA logging support for mlx5 driver
Date:   Mon, 5 Sep 2022 13:58:42 +0300
Message-ID: <20220905105852.26398-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4525d692-aee3-45f8-0977-08da8f2dac78
X-MS-TrafficTypeDiagnostic: PH7PR12MB6612:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qJtiuBoBu0J0XQQBD1981CZXBnnJVGaQbMwn205nestZmB8mEOBST9Vm01y7OWcrYCvWBQanwbw4Xz0svBF13bqOEp5f857BecKIQruQwluuX2pfMjaWAzWCQSvucvD+fNbzNPCD1C8QlYRHBmgXY4CvnEXQE8ZQB08DborOm4XJ08a80/Ft2zZ0yzr7l49e49LndvbzgVwfrHmztW4+WkOLax3LsrKMC5h9isLzCs+8XwnQJB/gmW968jFEsdWS1qkcmpCiXezFgSAfOBzyp20ivtOgybhPPukTaKjP0oYBdAVRSV007I2Iodq8t8gslK1N1EiqiBMwB46aQAZHSxUBqOgwv9avKaooDaET+ROSs5DK08mdoUCafx+zucHfMYQoKLHf3vhmzZX9Ii80JfjoOGy5jJKkRRFSwyCzbEEwLDozPCIKBOvkfCRUD5fDnhU8UsaJvA0LO7N0deHDcx0477gtjdvmXIs9UYTPIqCTMQ6yn05V7NvNEBpk+l73INz0oVFF8bpR/SGSEPEC0pWiUNxHXtClF0ErVu5TjLZ+g7U27rQ0c2baoXovm06Ue2vMJfl5DD3Zw1rfQk4MjRF74YWODBhWYF9fNO64wMnUeyxkrmCUk01mRdH1EYST4VyLE1z+MJEcheUedn7+Pw1CHpYeQDf+NCY7dCT4vC9wRjfCJCSEntDoKLn40JzijnbQTdpQ77qLKvXetHOT2+5zpXZjobF/zCfSF3/1GgfI+vQoOEMcAgD6JN0wzBV6ZXvmXZyamNh8UDKW84QnfndMT3o7ghB6kDHKUsJmRHjG6z+ljYFeeKCCelvLqOS7LmnqFpilNZegj/fqTysKVF2f5qMkdCF00tUe3YWVldCFDuPb6gqgEWa+YBKwcB7WJRK8d7cBwKc/F8Ex73zEexAdlpj/GFYeMmA2eyTvInw=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(346002)(396003)(36840700001)(40470700004)(46966006)(26005)(478600001)(82310400005)(966005)(7696005)(41300700001)(6666004)(81166007)(40480700001)(1076003)(40460700003)(356005)(2616005)(336012)(83380400001)(186003)(86362001)(36860700001)(47076005)(4326008)(82740400003)(5660300002)(6636002)(110136005)(8676002)(426003)(36756003)(54906003)(316002)(70586007)(8936002)(70206006)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 10:59:15.4944
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4525d692-aee3-45f8-0977-08da8f2dac78
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6612
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
 include/linux/vfio.h                          |  21 +-
 include/uapi/linux/vfio.h                     |  86 ++
 15 files changed, 1888 insertions(+), 20 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 include/linux/iova_bitmap.h

-- 
2.18.1

