Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C46A6D6CD7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbjDDTCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236123AbjDDTCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:02:32 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920BB59C4;
        Tue,  4 Apr 2023 12:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckKBpShMqRpkxfhYWuCSYcsEcq1/3474EIGcX6Pad6bnK1pPDs/qE3N02+SoMYswon5TJW5Zm9kDG3dMBiliyVy2YisWJDJK9UQsTMe/KG29eE0YfFilwzgFkAKn/U/cRhMnvm23poLXkIdtoDjHHoB1uF9YWK1B6GLOR50z2PIEDOyOa6diFF2xJ5p6Ca8l741i8edEHiQw92kgHyVs8CArqDnqrZF4Llq2LOPG6QiKrURwaLYQ6KsFtIR+oVLt+ZyjPJLJmHqIA+/yWIElBG/Cz5oKW9BK8EfgAUPkdoUAapZhd6mT4Ms75KiFgWPJdEFHrk3os6AdgiWPf7b10g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SEV4C/iVyhzSNa7SSDOdu3s0Zkg7aF88WhjpOpgG0Q=;
 b=jlrQWmKK7ntJUqm0W6WEGzJ+wqea38Rjpy74gWjuQyaCKWjjJhhsvdeFQJzBecchOTfumpGkAGbJRNW3U/sSV38VnDbjtjO/0kDLSOAwVLSEL7ZHXKsyyh3Qw4jWwBX9D2gAP0IP6rkpbIUT3QDEHnV4qL+jkSuhNGFNsCDi2GzANtpTw0rzwCfHAGfYPuxiHj81f1MCGzern0fWp2V0uigkIKTZJZBaRUks914EyerzZlyDUZHY1IHHrc+28Fd5tzpu5W7kspq+oAbdmn2MRQjb1JuKR04ux8F2ywolT3W2sSrzmYLJ5R9dGKJTojx5g1J38Fp5wkAP6BbvC4nmJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+SEV4C/iVyhzSNa7SSDOdu3s0Zkg7aF88WhjpOpgG0Q=;
 b=xkwrXh3pRpi59jisZG/CSC02yyCyO3JuZ5LxQO/tOZ7qzJd6jcx53zlp7YIulBnZwTfmKtKpvU6tBhzfwatvwN6zbSHxrmp0GEQkuO9Jef6zQDh2sUGYzUVcTLOsriI6SxL1SyDQ0IY8MTCBQ/N+BGWAzhppG/19hTMcmgTFDQM=
Received: from MW2PR16CA0067.namprd16.prod.outlook.com (2603:10b6:907:1::44)
 by MN2PR12MB4094.namprd12.prod.outlook.com (2603:10b6:208:15f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 19:01:59 +0000
Received: from CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::4d) by MW2PR16CA0067.outlook.office365.com
 (2603:10b6:907:1::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Tue, 4 Apr 2023 19:01:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT105.mail.protection.outlook.com (10.13.175.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.18 via Frontend Transport; Tue, 4 Apr 2023 19:01:58 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 4 Apr
 2023 14:01:56 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v8 vfio 0/7] pds_vfio driver
Date:   Tue, 4 Apr 2023 12:01:34 -0700
Message-ID: <20230404190141.57762-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT105:EE_|MN2PR12MB4094:EE_
X-MS-Office365-Filtering-Correlation-Id: c6ceb2ca-2adf-498d-54ba-08db353f10d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4xwyueFk3tsucqdqthtninPwd8NlhmmGJxvzURuMhoc+mR9DSXl1ikxQLvVliP8tjHBBIJxsXjEtd9rMAOALGhf8NpH4GNQeyZD46dBoe0XZ7y3Ntm8MngB+vQJLVpdimqBoFnKB77jN8cNcE1hXjxBoZ9UMm8LG1OH9icm6JNjNWd6eHBCBBNHn2TKgxOIk+vxvX/dQ8OFCAdIXJakiTFAQPT7rMcaxMWPTOL7P0LmfvLF1qS+qYZVI0I36yTfaoUWt5a27s6sSv7bTI7+pbkkYyEvTiswtDRaWRI3DrGnWzzsYrad2xMx0jmwuaow+rihwgXq3IfOGpu2ZYoYb+P2oWNjmpODYlX4gkyk8/I+zTYO6tq9HPQYsjfdbLLUAxD6qqyN1R3rxo9ZoNA/tX76YO649WbtAYviHtI50jRAPBASF7e6YPpIcELENkAoO/f9fVx3wiajrMLhN2R8NqfnrTasmhd2hQurlaKbbDiw92XAOMOqHVRde/cCzXpgJCsaXyFTI8mSFmMoj9rZyGpBaX8qo3uZqJd21k5vo1YvSOv78hZvjfy1WRaRenIUobsVmHcuasjELsOsRVELB2kVi36/Yshiia1qdXTx2DWX1iXS3kzrXHp7JF9Bg8651taklji+BsRrZs6IbLeu8Fxbs+eVVj9eAHKY9XOAV9mdnl2q3Ny+IHhMJBFOHGVtkTAoQXniL+it0HFNqqqU2uPp4Z2MmmUJSUxbukso58/RSMEXbNFFzYyy58gtuZeYEI3hk7OVOrEdo3QG/8SSZyAlykZZEJNGOYafSVaZTAc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199021)(46966006)(36840700001)(40470700004)(70586007)(186003)(16526019)(26005)(1076003)(426003)(336012)(70206006)(6666004)(41300700001)(81166007)(966005)(83380400001)(47076005)(2616005)(54906003)(478600001)(316002)(110136005)(40460700003)(36860700001)(86362001)(44832011)(82310400005)(2906002)(82740400003)(8676002)(40480700001)(4326008)(356005)(5660300002)(36756003)(8936002)(333604002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:01:58.2795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ceb2ca-2adf-498d-54ba-08db353f10d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4094
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patchset for a new vendor specific VFIO driver
(pds_vfio) for use with the AMD/Pensando Distributed Services Card
(DSC). This driver makes use of the newly introduced pds_core
driver, which the latest version can be referenced at:

https://lore.kernel.org/netdev/20230330234628.14627-1-shannon.nelson@amd.com/

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

v8:
- provide default iommufd callbacks for bind_iommufd, unbind_iommufd, and
  attach_ioas for the VFIO device as suggested by Shameerali Kolothum
  Thodi.

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
 drivers/vfio/pci/pds/cmds.c                   | 530 +++++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  25 +
 drivers/vfio/pci/pds/dirty.c                  | 536 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  45 ++
 drivers/vfio/pci/pds/lm.c                     | 478 ++++++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  52 ++
 drivers/vfio/pci/pds/pci_drv.c                | 212 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 239 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  40 ++
 drivers/vfio/vfio_main.c                      |  47 ++
 include/linux/pds/pds_lm.h                    | 389 +++++++++++++
 include/linux/vfio.h                          |   3 +
 21 files changed, 2728 insertions(+), 47 deletions(-)
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

