Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBED6EB694
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 03:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbjDVBHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 21:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbjDVBHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 21:07:14 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2046.outbound.protection.outlook.com [40.107.244.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1665510D8;
        Fri, 21 Apr 2023 18:07:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Exx2A0eC64GollUVWVjWoQf5P5fC58t+qFE/1pb0GadYCW6M8Bud95l9lbYFFWJXQapFNfy1ksPpU36IN0VOoiXvw2gYVm3/fDNLLlaHbliLpPeqEGBmyle9GR2YEztCzCqjarnSX5KNUcQ9XUMVSNgRhDmPFXL0W7TfI5xeBBZTamCXt+8lfjeGTJsieGNoLaVY/7AeML0xKS4PWNOR0W+UJPSAYHi9oM4v7lN1tsxRi1K8Yo0Mn57TZMvjz/A3+T7w+L79t4qyp8cUIU8QAyueg54HqFJTNysrULNROzs+NA68DoGhbCTtk+1YYpyQkKNSDMrDeYF8B57BCL1d/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVgpYaONT7E+4ijlq4euD0dV1tTox32F8CwSfrboRPA=;
 b=S0GJENmLbLwPqkCqpjrP5U3pfbsVIQhX9uN4inH8TbFbe5nfCDV2G5Dj/VkWq2N1/omP7Nhd6S3ML4KMIwyGahNgxuExaXDiLcXCHNMOZwxJlG9ea4AvrGj3asquNwjbZBrjnJv3axruc2yQHPExig0snqgCvIUkAUj9rYIqoKwcP9UeFHsJ5PC2UlQdcQjdMYEakqZw4NHG/sT8wpF2iudxhQEUFzH6lbshMM0wtyBsoC/R1fUdKMCZxfxd27XXCwyq3Mmif1GPFC5AM+NP9RUlrk0pj4Kn6XMbxmgjBpnQte/IZGTdtwg9HpWkObTTvQXtCFZCVhE9Ux1FaQZD+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVgpYaONT7E+4ijlq4euD0dV1tTox32F8CwSfrboRPA=;
 b=c1rL5YTdRlMPB/dNfIXEfv3L3nUk1bzX/sp5G9vMskjakVojJBwk65ySnoY4GTY0NhUQ/hOtXEOtWNIvMuUOhjKj58nkj8XQ3FExKltZ7Vl+SpaDwLfD2galoZzhFvGgd3Yd4p7/UdXaBnhm2TvZpUFE+lIpoovDxgGVenSVnh0=
Received: from BN9PR03CA0360.namprd03.prod.outlook.com (2603:10b6:408:f6::35)
 by MW6PR12MB7087.namprd12.prod.outlook.com (2603:10b6:303:238::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 01:07:07 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::fb) by BN9PR03CA0360.outlook.office365.com
 (2603:10b6:408:f6::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.28 via Frontend
 Transport; Sat, 22 Apr 2023 01:07:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Sat, 22 Apr 2023 01:07:07 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 20:07:03 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v9 vfio 0/7] pds_vfio driver
Date:   Fri, 21 Apr 2023 18:06:35 -0700
Message-ID: <20230422010642.60720-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT063:EE_|MW6PR12MB7087:EE_
X-MS-Office365-Filtering-Correlation-Id: f2357778-2c01-44c0-5f5b-08db42cde467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/4gSr9/hORLfB2VD30ttMbX7Q4fWC+eOJGahZh6+Fd/5hOgwkPVB39JFUiJBJtbFe8I2EKRWsEoDKYZhznTqEJq8nL7FrCB5pX6cDrrw44q7/v99DLX7aLlRnM6M6oky2CH9jDq+ccBDDoP/USKRi5V1RQ5FTPO43tNSmezEETU3qatAW3jYErO1bUBDtVwdxzZR4EvqfGN5+HWOF1hfPna3V5TGulvgpyzCKEgy+S4TnRbDyHRO8Oz+ifj0M1fNejEtK4x0eu/5gFDeqD9llOkgpa1ltpO8lpxurwzpsC5fpqW05v3zIxXUJO7XHE1rIs6N8p2EtKP5aqwzru+ysbx6/HFW8BL72zDZ9HSsObxbtZAzamyfeT+0zRbERT5S31RmYyY9UmXb+XJ7+TRr3odZK2wd1Ve7S4tDLkyPMV8Uj0jwL+SlMoFLG59/zaxipEu9AUp9PNAZylpeDC0Im0UQAKknGt1Hg4zcTD2JeeF422v22i9SarbcKmqUZ7shjp4NYILAej8pOhHgnq69Pa7WeM+q34BKzbxIg2/2nW/1jzU5/uL02bfIsbGdP1hjvvBTrakG0wvEEDtmx3K4tbSKb1xv7+TAMTwle0Xe1gig3VP8au3ZQpgyYKie5zalAcOaZQUbJYxZh1F+j3Ijpw+Sr+iOTDYn6NuzCCDq1X8KhV0YKcHcR0rKAYVZ1A5iwX5FRabQRHZYe2/4oASlqvto+txCms3zhS4z/JVG3+a/7BPOFogZ0WL+ZL4HWM8kOpBB2fqcHcpLoHgBIj9eoJdDkUEj+O7da60Eyk0RiM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(966005)(54906003)(478600001)(336012)(6666004)(82310400005)(110136005)(186003)(26005)(426003)(1076003)(2906002)(5660300002)(70586007)(70206006)(44832011)(4326008)(8936002)(41300700001)(16526019)(2616005)(8676002)(36756003)(40480700001)(40460700003)(86362001)(316002)(36860700001)(47076005)(81166007)(83380400001)(82740400003)(356005)(333604002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 01:07:07.0297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2357778-2c01-44c0-5f5b-08db42cde467
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7087
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patchset for a new vendor specific VFIO driver
(pds_vfio) for use with the AMD/Pensando Distributed Services Card
(DSC). This driver makes use of the newly accepted pds_core
driver, which can be referenced at:

https://lore.kernel.org/netdev/168206343035.30967.14987352827118974870.git-patchwork-notify@kernel.org/

This driver will use the pds_core device's adminq as the VFIO
control path to the DSC. In order to make adminq calls, the VFIO
instance makes use of functions exported by the pds_core driver.

In order to receive events from pds_core, the pds_vfio driver
registers to a private notifier. This is needed for various events
that come from the device.

An ASCII diagram of a VFIO instance looks something like this and can
be used with the VFIO subsystem to provide the VF device VFIO and live
migration support.

                               .------.  .-----------------------.
                               | QEMU |--|  VM  .-------------.  |
                               '......'  |      |   Eth VF    |  |
                                  |      |      .-------------.  |
                                  |      |      |  SR-IOV VF  |  |
                                  |      |      '-------------'  |
                                  |      '------------||---------'
                               .--------------.       ||
                               |/dev/<vfio_fd>|       ||
                               '--------------'       ||
Host Userspace                         |              ||
===================================================   ||
Host Kernel                            |              ||
                                  .--------.          ||
                                  |vfio-pci|          ||
                                  '--------'          ||
       .------------------.           ||              ||
       |   | exported API |<----+     ||              ||
       |   '--------------|     |     ||              ||
       |                  |    .-------------.        ||
       |     pds_core     |--->|   pds_vfio  |        ||
       '------------------' |  '-------------'        ||
               ||           |         ||              ||
             09:00.0     notifier    09:00.1          ||
== PCI ===============================================||=====
               ||                     ||              ||
          .----------.          .----------.          ||
    ,-----|    PF    |----------|    VF    |-------------------,
    |     '----------'          '----------'  |       VF       |
    |                     DSC                 |  data/control  |
    |                                         |      path      |
    -----------------------------------------------------------


The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
It makes use of and introduces new files in the common include/linux/pds
include directory.

Changes:

v9:
- Various fixes/suggestions by Alex Williamson
	- Fix how ID is generated in client registration
	- Add helper functions to get the VF's struct device and struct
	  pci_dev pointers instead of caching the struct pci dev
	- Remove redundant pds_vfio_lm_state() function and remove any
	  places this was being called
	- Fix multi-line comments to follow standard convention
	- Remove confusing comments in
	  pds_vfio_step_device_state_locked() since the driver's
	  migration states align with the VFIO documentation
	- Validate pdsc returned from pdsc_get_pf_struct()
- Various fixes/suggestions by Jason Gunthorpe
	- Use struct pdsc instead of void *
	- Use {} instead of {0} for structure initialization
	- Use unions on the stack instead of casting to the union when
	  sending AQ commands, which required including pds_lm.h in
	  pds_adminq.h
	- Replace use of dma_alloc_coherent() when creating the sgl DMA
	  entries for the LM file
	- Remove cached struct device *coredev and instead use
	  pci_physfn() to get the pds_core's struct device pointer
	- Drop the recovery work item and call pds_vfio_recovery()
	  directly from the notifier callback
	- Remove unnecessary #define for "pds_vfio_lm" and just use the
	  string inline to the anon_inode_getfile() argument
- Fix LM file reference counting
- Move initialization of some struct members to when the struct is being
  initialized for AQ commands
- Make use of GFP_KERNEL_ACCOUNT where it makes sense
- Replace PDS_VFIO_DRV_NAME with KBUILD_MODNAME
- Update to latest pds_core exported functions
- Remove duplicated prototypes for
  pds_vfio_dma_logging_[start|stop|report] from lm.h
- Hold pds_vfio->state_mutex while starting, stopping, and reporting
  dirty page tracking in pds_vfio_dma_logging_[start|stop|report]
- Remove duplicate PDS_DEV_TYPE_LM_STR define from pds_lm.h that's
  already included in pds_common.h
- Replace use of dma_alloc_coherent() when creating the sgl DMA
  entries for the dirty bitmaps

v8:
https://lore.kernel.org/netdev/20230404190141.57762-1-brett.creeley@amd.com/
- provide default iommufd callbacks for bind_iommufd, unbind_iommufd, and
  attach_ioas for the VFIO device as suggested by Shameerali Kolothum
  Thodi

v7:
https://lore.kernel.org/netdev/20230331003612.17569-1-brett.creeley@amd.com/
- Disable and clean up dirty page tracking when the VFIO device is closed
- Various improvements suggested by Simon Horman:
	- Fix RCT in vfio_combine_iova_ranges()
	- Simplify function exit paths by removing unnecessary goto
	  labels
	- Cleanup pds_vifo_print_guest_region_info() by adding a goto
	  label for freeing memory, which allowed for reduced
	  indentation on a for loop
	- Where possible use C99 style for loops

v6:
https://lore.kernel.org/netdev/20230327200553.13951-1-brett.creeley@amd.com/
- As suggested by Alex Williamson, use pci_domain_nr() macro to make sure
  the pds_vfio client's devname is unique
- Remove unnecessary forward declaration and include
- Fix copyright comment to use correct company name
- Remove "." from struct documentation for consistency

v5:
https://lore.kernel.org/netdev/20230322203442.56169-1-brett.creeley@amd.com/
- Fix SPDX comments in .h files
- Remove adminqcq argument from pdsc_post_adminq() uses
- Unregister client on vfio_pci_core_register_device() failure
- Other minor checkpatch issues

v4:
https://lore.kernel.org/netdev/20230308052450.13421-1-brett.creeley@amd.com/
- Update cover letter ASCII diagram to reflect new driver architecture
- Remove auxiliary driver implementation
- Use pds_core's exported functions to communicate with the device
- Implement and register notifier for events from the device/pds_core
- Use module_pci_driver() macro since auxiliary driver configuration is
  no longer needed in __init/__exit

v3:
https://lore.kernel.org/netdev/20230219083908.40013-1-brett.creeley@amd.com/
- Update copyright year to 2023 and use "Advanced Micro Devices, Inc."
  for the company name
- Clarify the fact that AMD/Pensando's VFIO solution is device type
  agnostic, which aligns with other current VFIO solutions
- Add line in drivers/vfio/pci/Makefile to build pds_vfio
- Move documentation to amd sub-directory
- Remove some dead code due to the pds_core implementation of
  listening to BIND/UNBIND events
- Move a dev_dbg() to a previous patch in the series
- Add implementation for vfio_migration_ops.migration_get_data_size to
  return the maximum possible device state size

RFC to v2:
https://lore.kernel.org/all/20221214232136.64220-1-brett.creeley@amd.com/
- Implement state transitions for VFIO_MIGRATION_P2P flag
- Improve auxiliary driver probe by returning EPROBE_DEFER
  when the PCI driver is not set up correctly
- Add pointer to docs in
  Documentation/networking/device_drivers/ethernet/index.rst

RFC:
https://lore.kernel.org/all/20221207010705.35128-1-brett.creeley@amd.com/

Brett Creeley (7):
  vfio: Commonize combine_ranges for use in other VFIO drivers
  vfio/pds: Initial support for pds_vfio VFIO driver
  vfio/pds: register with the pds_core PF
  vfio/pds: Add VFIO live migration support
  vfio/pds: Add support for dirty page tracking
  vfio/pds: Add support for firmware recovery
  vfio/pds: Add Kconfig and documentation

 .../device_drivers/ethernet/amd/pds_vfio.rst  |  79 +++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   7 +
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
 drivers/vfio/pci/pds/Kconfig                  |  20 +
 drivers/vfio/pci/pds/Makefile                 |  11 +
 drivers/vfio/pci/pds/cmds.c                   | 487 +++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  25 +
 drivers/vfio/pci/pds/dirty.c                  | 562 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  45 ++
 drivers/vfio/pci/pds/lm.c                     | 436 ++++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  41 ++
 drivers/vfio/pci/pds/pci_drv.c                | 214 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 248 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  46 ++
 drivers/vfio/vfio_main.c                      |  47 ++
 include/linux/pds/pds_adminq.h                |  17 +
 include/linux/pds/pds_lm.h                    | 390 ++++++++++++
 include/linux/vfio.h                          |   3 +
 22 files changed, 2693 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/dirty.c
 create mode 100644 drivers/vfio/pci/pds/dirty.h
 create mode 100644 drivers/vfio/pci/pds/lm.c
 create mode 100644 drivers/vfio/pci/pds/lm.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
 create mode 100644 include/linux/pds/pds_lm.h

-- 
2.17.1

