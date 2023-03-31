Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8699B6D1426
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCaAg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCaAg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:36:28 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399BAEF89;
        Thu, 30 Mar 2023 17:36:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fASExg0MPkceQin5fVhy0/k48OH+SJL2SQSGfG7q6nctEQEXA3Tc+t/ymJdLMr/Pzdkfr3YSNPnKrPiKjrUtYLmKIRXcj18pB5wAmO+/d7SvM72egfGsRAQ+B9MN+5MK4irp/VF9Aasmg8zamb3G/Q7Gf+DwwW8GSAxxSrr2eHZ+QieeDXYr1T/jU1ylYm3s/nUXaa5cUF7y3YYMWlH7aNnA3he5EjvYRwTWyAM1dgIWCGvnlYA3ndht3MiCnlWei9Vh9XDr/ypf5cw8zRVPv6fuUxl3pYA5aIQA4+F2TywLS9Fkd7P8mB4yeBs28PMTuKt2UxDD8RoUUs4+UJ0jhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWxXoH91L4TQUkHchP4YhzxxwFMiZ3Ave0YYCLhIuIg=;
 b=LO/c0FTWO31sbbFX+yeBLKxPZdWeXNeaIe9illDn7qlj2TPzsxjsFbliz0QXo5oaf5HkqEJnI84EPWgFx6fryXS7fszu30TWXfW7P/zsDnkkAark0Jr48tHGtIs3j1jQiWgQZkoYwQ9uJbl/CenvWDhhe3EnCFgxM6y3ECRfKdjHe6hHts7MiJwpFNEnAy9JwhPnZupet7cZCS+JL9PnlC2YFzUnt/X8wRK1lSLEmS1iR9j3OaJ8bQyTYxhSM/JQJAVe3E0liE98NVxiDsMrk0BMx9492uLVDwzt3QI+B6SKDxY8leBLbIVT9fByDg4Q2SBJ37h32+4axrGrhZgPzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWxXoH91L4TQUkHchP4YhzxxwFMiZ3Ave0YYCLhIuIg=;
 b=aMqUrzQZ1agt5iEcws9jJdYE8O3Fk2pkcfzScLygkXGYDwWf0EsC5jpSWNF11urvFXgRntyF2R5csC0zAiueSmvBi+PBngxv5kwJKJRKUtSTRyHAmJ0RQVT/QOjnxQIIdjxAzLxhwO1IZyEnTy5433O4INdfOG3V2IJpkXg3cH8=
Received: from DM6PR06CA0045.namprd06.prod.outlook.com (2603:10b6:5:54::22) by
 SN7PR12MB7156.namprd12.prod.outlook.com (2603:10b6:806:2a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20; Fri, 31 Mar
 2023 00:36:23 +0000
Received: from DS1PEPF0000E64E.namprd02.prod.outlook.com
 (2603:10b6:5:54:cafe::a3) by DM6PR06CA0045.outlook.office365.com
 (2603:10b6:5:54::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Fri, 31 Mar 2023 00:36:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E64E.mail.protection.outlook.com (10.167.18.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 00:36:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 19:36:22 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v7 vfio 0/7] pds_vfio driver
Date:   Thu, 30 Mar 2023 17:36:05 -0700
Message-ID: <20230331003612.17569-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64E:EE_|SN7PR12MB7156:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ba8a12-eb4b-434b-de2d-08db317ff49c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S+nmmgy9q5FgthJrkVgx6cSt2v5eojkyzEujsVnEBufPWT42/JeDVmqrCNDui257QPD+VR1yvagcHEOpIxfvr93NPG0swxV9Yfc1PuP8/OxK2BcyL0GVVKgyHDdpq2ccJDtOmSs2/+sz0OQHKfLOxBZv92SzREdXSm/yL5yFK920wJULp7AJB87imD5WyJ8DGFjNHHQnip6P8DWa22GjT8YKz3Xz+P1gJDuA2F1Y+AjjiAoUGyRZ6ROrtZQGhh+UDN1Cu2lY5tayA4o47EJGWaabDasT4GPhcXLzIhh3hIdQsH96QBiQMt0W8t3koZgiW/xU2AaOY523SCKioZzyyeERNVw2/c4AuaerkU3uFANhZ4qcaDTq9FS7geM+PpTfb0qSvezMMv0CYppwGpFJvjgmtbfqt+Ztg7Vs7u221yWv7Vk1k6HhBS8seL5iTzYBJHbrW0HI2FyTgwOzoYGmiIQpwUh/ifalxXkNkANEOuPJhN4sbSsb8TAutAAHad1rI+UItpI+HtFuYHG1n12EadIX4E5Bx4XX7VwW8YhFvUgODyB2L6DPXTnpNLlgxO+hBiMZmAZv3TWGI4SVZVDJvnX4fhwL4aawdzELcMlfFoQxCD4G99nWXPIupaBbPT93QCHsJOz4FeWqIhRJ85m/NJKowsVxIIdGxf+1O5EHOEiubJFBtaYUmXLXZ1Azl5KaZhilQRZHcSc03ibbwSt6wWiwSQzSn7ht3AFT6V1d+de4E2xirr3lzUBOda5PaWAoCO5VygVzFzYZJj5xtctnyh+q3Qxxs+UHyj/W8PGOSiA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199021)(46966006)(36840700001)(40470700004)(16526019)(86362001)(1076003)(26005)(6666004)(186003)(316002)(70586007)(5660300002)(478600001)(8676002)(40460700003)(70206006)(110136005)(966005)(36756003)(41300700001)(4326008)(54906003)(44832011)(8936002)(36860700001)(82740400003)(81166007)(356005)(40480700001)(426003)(336012)(82310400005)(2616005)(2906002)(83380400001)(47076005)(333604002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 00:36:23.6804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ba8a12-eb4b-434b-de2d-08db317ff49c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7156
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
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

v7:
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
 drivers/vfio/pci/pds/vfio_dev.c               | 236 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  40 ++
 drivers/vfio/vfio_main.c                      |  47 ++
 include/linux/pds/pds_lm.h                    | 389 +++++++++++++
 include/linux/vfio.h                          |   3 +
 21 files changed, 2725 insertions(+), 47 deletions(-)
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

