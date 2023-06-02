Return-Path: <netdev+bounces-7580-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACA8720BA9
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:03:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30DE2281AE8
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E0BBE67;
	Fri,  2 Jun 2023 22:03:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2886848A
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:03:38 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B851BB;
	Fri,  2 Jun 2023 15:03:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDbGi/fg9/yYLUA7o4jCr6t80R6vF18BPABSj74ev5ajZnnSA4wt7tBQI06eI44KV+PRCODvvKyrj3t5aLCbuPlN7/wzoGBipluwk1P0SqbYy0JuXzE77Ws9RqEa7OTKLtDv/iHxM5G20FWnDOVQ0WqTDxgD2UrgupW5m52l3q68Z99DGM6ouJI6+sWxQXT0cpyXnv0+eHchF0XDvCAh0ivhHRmsn3xPGrd5Ja7i0D3rHRolIJYo9O4nNXZ4FMyx8nMhYb09FRYDccIktGt3jKZbHWI2LvR5JLi2LXoQxcv4ucx3Sr1px7bEOA8YrWZvsxA1X16IZYOoCp6Rl2LrZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CMxU3BKlDxgJNDqbDV91GwmQeT+qz4TBP0KYPc/omE=;
 b=VXDllnGvE00iwXnKzmJJ+vDRpltiNrrESOGgsNNzgsSLWNq+g/uJTLbaaBHS5THMkTDP9hvpUqwrm0SSGu6PUCd3QtCAPfrByZ/cNZW9U3IfDJmY+fyXCKgLS7bepRRzniLYVi80t62nNEbZX6IRcoU+HFTbJtPTHkmXzUBTOoi0fakYGt9GvVo544EEGu1WMasFoVNIbXvNz+Y2t/ggPIq0Z9H7stPzbOn+CeZFagbvucaRHNoTcDUgeP6Am9i7fr5ySbPbRswaTPnOTSB3qA5YUeavSJaYDOsqmQvFODzczcSzQe/LgrFDSOIeFgh4sJhH5HDyIJq36p72KB9GeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+CMxU3BKlDxgJNDqbDV91GwmQeT+qz4TBP0KYPc/omE=;
 b=nGOVAZXUdT+3aRzKUqGENgPjx1/VF3yQJPLW7F3INRIaQWA35xzlLxjUS5VaIrbzZtinwGESvNk470UYD7TfopypWHbElOPWiVoynzjKW97EZr4UAiDCSDesSzgiLXbL03uaNJnvCrh4z/bgin4XZYDIxef3r1AoLhRiUr/CT7s=
Received: from DS7PR03CA0164.namprd03.prod.outlook.com (2603:10b6:5:3b2::19)
 by CH3PR12MB7689.namprd12.prod.outlook.com (2603:10b6:610:14d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Fri, 2 Jun
 2023 22:03:34 +0000
Received: from DM6NAM11FT075.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2:cafe::ca) by DS7PR03CA0164.outlook.office365.com
 (2603:10b6:5:3b2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 22:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT075.mail.protection.outlook.com (10.13.173.42) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.23 via Frontend Transport; Fri, 2 Jun 2023 22:03:34 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Jun
 2023 17:03:32 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v10 vfio 0/7] pds_vfio driver
Date: Fri, 2 Jun 2023 15:03:11 -0700
Message-ID: <20230602220318.15323-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT075:EE_|CH3PR12MB7689:EE_
X-MS-Office365-Filtering-Correlation-Id: bd9e8ab9-ae9d-47a6-8ebc-08db63b53592
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Rt0qjprzKPm3RkmvOFf8ee9wTXAby8RXu4uQ5Ol0EZYTMK26w+/ilLu75phob7gpNcrdqXMi3g7X3UnU03N9XDDEdYEygFyIpAL5QbA2X8SnVhTVPltm5Tb9aVfX8aNqCPdDAHYTUyjpH4GIyqOl83Q3Ch+cCQ7OAA4N+B6QW2XhAi+1U1DEWh0uvwoj7O58bpAQAN8rQ+kyq0nwenbDlpaDaMAtb8Q2khAC2H8n2XiB53Edshh6empcIWlgzh5d5cAQ0UslI7P6NgDIfj0pJOEcwuoRbdg9YkHA7AHFc09fXHP+vbwuFx8xi9Y2RuFVopr4XYaxlJlERCDYtWVRoE2kIS/R3zXL2AdYLa/WUTOsgIyURI0guVMuFxZU7yo5cLDmTfXoFYRjWltNAVkoeqvY4NEMJSOaZAEb17PWLRUdzSfq8Ai1RUJeLbIVGL3crvuZF5ip3cETUnGyjdNE49gH2fYnXYGgc46nVTBjT3NkNnrBhMQovkKkvOkg+REJkEelKuR99nqp6T1ujwHFaPIU5FMFTdcfPSbD5w//7M1LDA4a25GzLoFGimDo+6BLklFMns3Pi7uVqUG7ixEAa0lsSdeE2OYoo0C4VhQWrLfd3LzJlbpS1uhcStL02WNDhS1OtEbHi/29+0O8EITkmVuYgATreh+D2Aq0kQ9Da+KhDgjAePtChUqjAlRs9bNBTV2/rAttleVmMOXLQ0RedVT1FBsQF2wdObZ9tisfed+6sCN+L7bjQku/xr6u/9qdTonkxgCDYw6DQVz19dAEK4a1XbGgGZLXtCtd6qouEIrVVDcaZiahipovsyFabdMZ2899YB4OcRxAMN9RqGD0rw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199021)(36840700001)(40470700004)(46966006)(8676002)(8936002)(6666004)(110136005)(54906003)(478600001)(966005)(81166007)(82740400003)(356005)(316002)(41300700001)(5660300002)(186003)(26005)(1076003)(16526019)(44832011)(70206006)(4326008)(70586007)(83380400001)(426003)(336012)(2906002)(86362001)(36756003)(2616005)(47076005)(40460700003)(36860700001)(40480700001)(82310400005)(333604002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:03:34.1303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd9e8ab9-ae9d-47a6-8ebc-08db63b53592
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT075.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7689
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a patchset for a new vendor specific VFIO driver
(pds_vfio) for use with the AMD/Pensando Distributed Services Card
(DSC). This driver makes use of the pds_core driver.

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

v10:
- Various fixes/suggestions by Jason Gunthorpe
	- Simplify pds_vfio_get_lm_file() based on fpga_mgr_buf_load()
	- Clean-ups/fixes based on clang-format
	- Remove any double goto labels
	- Name goto labels baesed on what needs to be cleaned/freed
	  instead of a "call from" scheme
	- Fix any goto unwind ordering issues
	- Make sure call dma_map_single() after data is written to
	  memory in pds_vfio_dma_map_lm_file()
	- Don't use bitmap_zalloc() for the dirty bitmaps
- Use vzalloc() for dirty bitmaps and refactor how the bitmaps are DMA'd
  to and from the device in pds_vfio_dirty_seq_ack()
- Remove unnecessary goto in pds_vfio_dirty_disable()

v9:
https://lore.kernel.org/netdev/20230422010642.60720-1-brett.creeley@amd.com/
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
 drivers/vfio/pci/pds/dirty.c                  | 577 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  38 ++
 drivers/vfio/pci/pds/lm.c                     | 421 +++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  41 ++
 drivers/vfio/pci/pds/pci_drv.c                | 206 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 234 +++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  45 ++
 drivers/vfio/vfio_main.c                      |  47 ++
 include/linux/pds/pds_adminq.h                | 395 ++++++++++++
 include/linux/pds/pds_common.h                |   2 +
 include/linux/vfio.h                          |   3 +
 22 files changed, 2653 insertions(+), 47 deletions(-)
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

-- 
2.17.1


