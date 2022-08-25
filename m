Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D915A0EC8
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241163AbiHYLNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236708AbiHYLNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:13:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80794AE9F1;
        Thu, 25 Aug 2022 04:13:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBxXyNuuDrPTIJej/+TW3Rtw+3YJ3HTus/cNM2hgec31xCR+Xfjv6vSddiYm+lHWxhIR8q68Yb59ru7XwacvBthzdgBNQxsszEYeqTVIHm8q8AgE7ZtrpE9RrHBVMuWmtZy5JbW9UzxID+xqtvyI1LhwfLoA3gP8wGsByWVfialLp6DOmG/oTYtT7tYOC3AvG2CxkWpi+61yiKTWAjyOQYbZo2b0Sx2tTkNcMNj3x2lvyi6xnu6H35Kz4CT3toWA3yp/rEOtCx5nOqDyCBBe5YNEtDCZQTGKo7nG/ueiYOrF0au+PeFBkyuCAdYXNJ+UK1ouQw3c1pWRxfts81dtGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nyiAWbh8bF3/cgJFzNAv6JsCMhVnIHYm47fa6qku+YM=;
 b=W/gKvrGVEWFUBGf+Phn15ZRhwW6j3rdGtbXboQ6Yj0JrbyiLtqQpHU8upwmksbbIQ6Va93Mi2Vhb2Fv04ENzI6yQHYk8TN6ra9LuBdsztMPXe56qaPpR5NAj/4fyz6cdTh0345X0gClRXXToiB5F5IG/hwEziAjp/ARqSEYX8XHz9TXZOejkq/AbZZPDkI0t1Ry+sqnjZwkmJ3qP9w9vnHJ4iJVFM1js0FPguOhlS6GnTTeiOy49DAL1VofhYZxqIRuStjjd+SltRrJsYvSSsS3x4/EccrKYKQNXg/B45tbEC6nmvnlA8zKmBP4zJlRyzZIB/LP3XsNq3E1FU0bZkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyiAWbh8bF3/cgJFzNAv6JsCMhVnIHYm47fa6qku+YM=;
 b=mtvwBfTFSTSnlQ1W3z/e2Trw/iLZyXs2nqqIukOW08i4N2501HCE8KtLdA2lNt4myY0I2yhDqIuOlGtL1p0j51NOrwLnpvxmEgG3gNAfEM+sXZDyOXajsZCymesIit0bA0gAUfa+i8+AuLp9/yWJbvnjisXuKj5F+KPl7wWFBS9eFWtkyo8fMXOy+sKiKdSBrNq8+3IZl+B+Rqy2WVrdDg6jUXE23bn7W3x4zw11oNRHU6eblPJRIlP2tvtmdskxplxHmVb5H0sbuUistq5aGFVxSl3xk8W2apxkzSsWXH76LACaSxCdFEe1kadVu9TyVZyuXcz1QEIoZJeRpvR0OA==
Received: from BN9PR03CA0843.namprd03.prod.outlook.com (2603:10b6:408:13d::8)
 by MN2PR12MB4046.namprd12.prod.outlook.com (2603:10b6:208:1da::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 11:13:08 +0000
Received: from BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::65) by BN9PR03CA0843.outlook.office365.com
 (2603:10b6:408:13d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Thu, 25 Aug 2022 11:13:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT083.mail.protection.outlook.com (10.13.177.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Thu, 25 Aug 2022 11:13:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 25 Aug
 2022 11:13:07 +0000
Received: from [172.27.13.80] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 25 Aug
 2022 04:13:03 -0700
Message-ID: <e6e79361-a19c-9ad6-403b-9a08f8abcf34@nvidia.com>
Date:   Thu, 25 Aug 2022 14:13:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH V4 vfio 00/10] Add device DMA logging support for mlx5
 driver
Content-Language: en-US
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220815151109.180403-1-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70ef73e0-daa2-42ba-a644-08da868aca38
X-MS-TrafficTypeDiagnostic: MN2PR12MB4046:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eGc3YVMrZUg4b05qNmFMc25RS2JaUWJoZTVxWExwajVDdVF2Z1d3MjdvWVVj?=
 =?utf-8?B?blVQUDAxUmdjdis0L3VKN2Q5MjV5ZlpBanNTZTAxZ1dkaFNRR1BzbFVvL3I5?=
 =?utf-8?B?enhQWW5MV3F0Tm1hU0ZIYWRTTGtkMXRnUXlRQTJZQklXenJNNWwxNUhjTDAr?=
 =?utf-8?B?ZjFhU3ZvckY3QzlwTTBBMEFRUjByL2FXSG11TmVna2tJM2hYS3MwVUc2YTNu?=
 =?utf-8?B?S3kxMk53eUZ4WmFuR0crSXh1dVpvcW1aS1h3b2VFUUFsaGxJbGt4dGdvUmlB?=
 =?utf-8?B?S2QyL3QzOGdHdkk4YVJwZW9MdHBWaE12bGIvY0IvWTMrZE1pL1hucHZXdWcx?=
 =?utf-8?B?dVZtb2ZVUENRaDE1NlJVaTUrZEQraWxrbzdaSEZSNTFwOUZ1ZlRNR1pVbWRW?=
 =?utf-8?B?QnpZSWpQNmxTaG1jaVhtVjJ5TkZiald4K1lpQlpPMCtUSUw4N2htZkJCcnV5?=
 =?utf-8?B?SHJyOWpDamdwSlRGOWUwbkt3NHZaUmJ0NnNmNHI2c2ZVa1FaUVl6b0VmQ3lC?=
 =?utf-8?B?YVhlMVhCZXpoMjFmRTFrTzBOWGo1Um9zaVgvbG9qdDMrNFhORWVQUEEvWnVD?=
 =?utf-8?B?eHBLMFpreG1sSmgzdGwwWkN0cFZRU2VRSUFYSzJoMmxiQTRtOUQ0MGZxbncx?=
 =?utf-8?B?SHF3QzNTQnRXL1pabmh2eTlVSVRLS0x0THN4alhibTBHcm9Bbmt0a2pydGpY?=
 =?utf-8?B?QkNpMWlQMWNWU1MyTWR0SzFlRmFmYzBmMHp6emxhWVdoL3M0b0F1eTJSNXlR?=
 =?utf-8?B?ZVllNDBia0tXLzk0VmNtS2psK0ZjSjhwQmF1Zlg1QVBnWGkvKzA4NmtuYVdT?=
 =?utf-8?B?NnhXdUo3V21KOGlRSXlyWGgxeVgrUnRaT3VLQnBQbFg1dmE5RjA4Y1dFbk1D?=
 =?utf-8?B?d0NkWGNtWXpKVFNOYkR6YXB2U3JaRXU5akZNME5xQmlwb3VUVytPaGtndlNZ?=
 =?utf-8?B?anN6RnprQjZCK2xVandJOUlWVXhFVFZWSmJobXoyZjF3K3BkeHdOMVNQcFNV?=
 =?utf-8?B?bUZuMm5SYnpXWUdjL1pBZHQ1QlFmUWVlNDBRaG5jb0xlclRJdjlBOVlrWmkr?=
 =?utf-8?B?djNiVTBrd0dWTUdnV1dGNnJEMWQxWWhDNHNkdXhUTXoxV2NoeE9yemRMd1pF?=
 =?utf-8?B?VUU0RENNVGRsZVY1OFh0V2tqTXd0Z2JZU1NVZ1MzRGExVjd5NDQzVXpYYy9C?=
 =?utf-8?B?R1Z5QWl4a000Q3ZZZElRSXFiRWZ2SFlwZmYzeE1UUG8zb3RTU2FrQktkNUJF?=
 =?utf-8?B?MWJiMG9tK0Zmb1RqeWRsOHc4MmtFc25WcWhSZTJXelFvQ245QT09?=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(39860400002)(40470700004)(46966006)(36840700001)(5660300002)(2616005)(8676002)(82740400003)(4326008)(70586007)(110136005)(70206006)(36756003)(36860700001)(81166007)(31696002)(86362001)(31686004)(356005)(16526019)(336012)(47076005)(26005)(426003)(41300700001)(8936002)(478600001)(966005)(82310400005)(54906003)(6636002)(40460700003)(186003)(2906002)(16576012)(83380400001)(316002)(40480700001)(53546011)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 11:13:08.0790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ef73e0-daa2-42ba-a644-08da868aca38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT083.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4046
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/08/2022 18:10, Yishai Hadas wrote:
> This series adds device DMA logging uAPIs and their implementation as
> part of mlx5 driver.
>
> DMA logging allows a device to internally record what DMAs the device is
> initiating and report them back to userspace. It is part of the VFIO
> migration infrastructure that allows implementing dirty page tracking
> during the pre copy phase of live migration. Only DMA WRITEs are logged,
> and this API is not connected to VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE.
>
> The uAPIs are based on the FEATURE ioctl as were introduced earlier by
> the below RFC [1] and follows the notes that were discussed in the
> mailing list.
>
> It includes:
> - A PROBE option to detect if the device supports DMA logging.
> - A SET option to start device DMA logging in given IOVAs ranges.
> - A GET option to read back and clear the device DMA log.
> - A SET option to stop device DMA logging that was previously started.
>
> Extra details exist as part of relevant patches in the series.
>
> In addition, the series adds some infrastructure support for managing an
> IOVA bitmap done by Joao Martins.
>
> It abstracts how an IOVA range is represented in a bitmap that is
> granulated by a given page_size. So it translates all the lifting of
> dealing with user pointers into its corresponding kernel addresses.
> This new functionality abstracts the complexity of user/kernel bitmap
> pointer usage and finally enables an API to set some bits.
>
> This functionality will be used as part of IOMMUFD series for the system
> IOMMU tracking.
>
> Finally, we come with mlx5 implementation based on its device
> specification for the DMA logging APIs.
>
> The matching qemu changes can be previewed here [2].
> They come on top of the v2 migration protocol patches that were sent
> already to the mailing list.
>
> Note:
> - As this series touched mlx5_core parts we may need to send the
>    net/mlx5 patches as a pull request format to VFIO to avoid conflicts
>    before acceptance.
>
> [1] https://lore.kernel.org/all/20220501123301.127279-1-yishaih@nvidia.com/T/
> [2] https://github.com/avihai1122/qemu/commits/device_dirty_tracking
>
> Changes from V3: https://lore.kernel.org/all/202207011231.1oPQhSzo-lkp@intel.com/t/
> Rebase on top of v6.0 rc1.
> Patch #3:
> - Drop the documentation note regarding the 'atomic OR' usage of the bitmap
>    as part of VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT.
>    This deletion was missed as part of V3 to match kernel code.
>    To better clarify, as part of testing V3, we could see a big penalty in
>    performance (*2 in some cases) when the iova bitmap patch used atomic
>    bit operations. As QEMU doesn't really share bitmaps between multiple
>    trackers we saw no reason to use atomics and get a bad performance.
>    If in the future, will be a real use case that will justify it, we can
>    come with VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT_ATOMIC new option with
>    the matching kernel code.
> Patch #4:
> - The rename patch from vfio.c to vfio_main.c was accepted already, not
>    part of this series anymore.
>
> Changes from V2: https://lore.kernel.org/netdev/20220726151232.GF4438@nvidia.com/t/
> Patch #1
> - Add some reserved fields that were missed.
> Patch #3:
> - Improve the UAPI documentation in few places as was asked by Alex and
>    Kevin, based on the discussion in the mailing list.
> Patch #5:
> - Improvements from Joao for his IOVA bitmap patch to be
>    cleaner/simpler as was asked by Alex. It includes the below:
>     * Make iova_to_index and index_to_iova fully symmetrical.
>     * Use 'sizeof(*iter->data) * BITS_PER_BYTE' in both index_to_iova
>       and iova_to_index.
>     * Remove iova_bitmap_init() and just stay with iova_bitmap_iter_init().
>     * s/left/remaining/
>     * To not use @remaining variable for both index and iova/length.
>     * Remove stale comment on max dirty bitmap bits.
>     * Remove DIV_ROUNDUP from iova_to_index() helper and replace with a
>       division.
>     * Use iova rather than length where appropriate, while noting with
>       commentary the usage of length as next relative IOVA.
>     * Rework pinning to be internal and remove that from the iova iter
>       API caller.
>     * get() and put() now teardown iova_bitmap::dirty npages.
>     * Move unnecessary includes into the C file.
>     * Add theory of operation and theory of usage in the header file.
>     * Add more comments on private helpers on less obvious logic
>     * Add documentation on all public APIs.
>    * Change commit to reflect new usage of APIs.
> Patch #6:
> - Drop the hard-coded 1024 for LOG_MAX_RANGES and replace to consider
>    PAGE_SIZE as was suggested by Jason.
> - Return -E2BIG as Alex suggested.
> - Adapt the loop upon logging report to new IOVA bit map stuff.
>
> Changes from V1: https://lore.kernel.org/netdev/202207052209.x00Iykkp-lkp@intel.com/T/
>
> - Patch #6: Fix a note given by krobot, select INTERVAL_TREE for VFIO.
>
> Changes from V0: https://lore.kernel.org/netdev/202207011231.1oPQhSzo-lkp@intel.com/T/
>
> - Drop the first 2 patches that Alex merged already.
> - Fix a note given by krobot, based on Jason's suggestion.
> - Some improvements from Joao for his IOVA bitmap patch to be
>    cleaner/simpler. It includes the below:
>      * Rename iova_bitmap_array_length to iova_bitmap_iova_to_index.
>      * Rename iova_bitmap_index_to_length to iova_bitmap_index_to_iova.
>      * Change iova_bitmap_iova_to_index to take an iova_bitmap_iter
>        as an argument to pair with iova_bitmap_index_to_length.
>      * Make iova_bitmap_iter_done() use >= instead of
>        substraction+comparison. This fixes iova_bitmap_iter_done()
>        return as it was previously returning when !done.
>      * Remove iova_bitmap_iter_length().
>      * Simplify iova_bitmap_length() overcomplicated trailing end check
>      * Convert all sizeof(u64) into sizeof(*iter->data).
>      * Use u64 __user for ::data instead of void in both struct and
>        initialization of iova_bitmap.
>
> Yishai
>
> Joao Martins (1):
>    vfio: Add an IOVA bitmap support
>
> Yishai Hadas (9):
>    net/mlx5: Introduce ifc bits for page tracker
>    net/mlx5: Query ADV_VIRTUALIZATION capabilities
>    vfio: Introduce DMA logging uAPIs
>    vfio: Introduce the DMA logging feature support
>    vfio/mlx5: Init QP based resources for dirty tracking
>    vfio/mlx5: Create and destroy page tracker object
>    vfio/mlx5: Report dirty pages from tracker
>    vfio/mlx5: Manage error scenarios on tracker
>    vfio/mlx5: Set the driver DMA logging callbacks
>
>   drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
>   .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
>   drivers/vfio/Kconfig                          |   1 +
>   drivers/vfio/Makefile                         |   6 +-
>   drivers/vfio/iova_bitmap.c                    | 224 ++++
>   drivers/vfio/pci/mlx5/cmd.c                   | 995 +++++++++++++++++-
>   drivers/vfio/pci/mlx5/cmd.h                   |  63 +-
>   drivers/vfio/pci/mlx5/main.c                  |   9 +-
>   drivers/vfio/pci/vfio_pci_core.c              |   5 +
>   drivers/vfio/vfio_main.c                      | 159 +++
>   include/linux/iova_bitmap.h                   | 189 ++++
>   include/linux/mlx5/device.h                   |   9 +
>   include/linux/mlx5/mlx5_ifc.h                 |  83 +-
>   include/linux/vfio.h                          |  21 +-
>   include/uapi/linux/vfio.h                     |  86 ++
>   15 files changed, 1837 insertions(+), 20 deletions(-)
>   create mode 100644 drivers/vfio/iova_bitmap.c
>   create mode 100644 include/linux/iova_bitmap.h
>
Alex,

Can we please proceed with sending PR for the series to be accepted ?  
(i.e. as of the first two net/mlx5 patches).

The comments that were given in the previous kernel cycle were addressed 
and there is no open comment here for few weeks already.

Yishai

