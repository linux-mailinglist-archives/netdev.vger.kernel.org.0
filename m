Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A256CAF59
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 22:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjC0UGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 16:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjC0UGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 16:06:11 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522A51718;
        Mon, 27 Mar 2023 13:06:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+oUy2eig7DMPVB4qJhEEicWs3zHBAYthtdaNv0Z6d/s9MzlkF3dD1YUSoGAC6DWdJLHWROoJH7EKfjIQnvYXlHrusns5k01Bx4L81Cj6q+1Uhl6kzxB2MwJ+vDZAKY/Q3GHE871EjFcfCRNzbD0NEO81NMJRxla8ELcb4RrGfhfS75EwSwAtEG7RjDW+r5rDN2qwgD1RLByOYO0sJ5wMjUH2WQ7IEwP7b/mPzWBlSbYycYweQCd/WI4mpG15KHPjBHygeHPLsLG2597StCn4mavjwpJShwxxqIMP0z9GXxu5T4gqWq9vAMbM+ajDH+jeOTqa0HGuGhgvJ8wc4QTnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bceFv6lLpDVxjUouQHJs0W7LU6F7chmYK9oEZ+tkCFU=;
 b=MeXOu6YqRNeAzlhgc6szollBXBHT3AIagSYZwXz43zaAr7PRuu8wQvkC9DSElaVXgMgzUTrGHL465TIjLz94UeUTV1IEV194gJk/XMSMx04LYVc7+Oir/AbnM8wNEsvuUeh2x+JL7Oiu1gpiUO7+0Hd8p4hz4lSLSw3YytXk4akI/9+7DZ3X/lsuPOkZVqn9dCd8wTjzuX64I+tGx7YaIp0LGgS6qOX2W6kvGFUo5UFuKhNoppbH+bKb2LBw4UkWyDbKaUYTn7stW/tH6tEQlUE1Qel+ViK5qPRSg1vrdWP1QI23kz5g+O+TPDwT0IgtRi/gajUSCaHUH1VKVgZP1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bceFv6lLpDVxjUouQHJs0W7LU6F7chmYK9oEZ+tkCFU=;
 b=TbzfdotcWg0Y6TzXRTeIwK/ynwpbGpT+/OTmne5PWWmwSdkC9fMVKWNFZNhDMEPYncaoREtN4h+4n57/uPApoq4jWHIqy9oY3xDhStpW1O7Ek9duP6HJrI4Zd5BXdpshAaEm78ZqMEg5QtOBpsrBG+3FP6o+UehzyDyFcsDLV5Y=
Received: from MW4PR03CA0058.namprd03.prod.outlook.com (2603:10b6:303:8e::33)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 20:06:07 +0000
Received: from CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::81) by MW4PR03CA0058.outlook.office365.com
 (2603:10b6:303:8e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 20:06:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT095.mail.protection.outlook.com (10.13.174.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Mon, 27 Mar 2023 20:06:07 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 15:06:05 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v6 vfio 0/7] pds_vfio driver
Date:   Mon, 27 Mar 2023 13:05:46 -0700
Message-ID: <20230327200553.13951-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT095:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: ab76453b-0cba-4013-5a08-08db2efeb3a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YFZB/0nc8D+BnnUmtZ07428VOclh4SClPX+50FC0PeOg0qdo6bD625X9/pyp60zQCobgrFIkjgAcVa2zfOPmaSx9TCDrH/qFQ0rKh8oB8KAgLfr4+F11emi+D72ai36D0Ux/pt8HrbuO4bIUYQhCSI3pdPjZIv4zWOOm3XqgjTIs2rfkQt1kJh/gs2lxnuAqZAHpklYhfmmUUHhnfVlhWpWXTec/Vf4vJQY85H2gxPVUHL/aMOcagPdC69HhDFa7DxneCpfNCiphqlryYPDrdKhsRpdHtucfwCUPlJ/iJCZQ9cXptkw+u4Cltz0BKnjG5ESjwmce9Z8mw21WZp3Nys/XkCLo5cBGKPiUZm0B0STJ2OBrq9BarfQjTbeIGf5DOYt3SSyDTcySjefjXaiBVCHx9hUfT10asy1qFjbob88wzE27ZNsGMvoOE/Ob4peWZXnZAv1WQQw32TMZGm3HjYRAtNfHsAKxt1DdxKbgvZnwjBC8qmiI+jHYHju4BNSlHjv7FzrNj4xmMqhLA4KN0FmTHDfocDqG/ErTymFls2X08ttEHuYkQCs6ZL1QWQuHK/DOhMfnP7IwJWC1QsQPgASgufcySw17ZFYYfCua2F/+3LSXYBvie+q/59hR6WjgZpUhdlCdbSAoU0P/BJMv75eC5wiF7IrSQGFWubbVRsnZPk2YE3u+U+3NlJug1kphSYfu2ia/IewtUMcSLONdeKDpx4xMD0mjAa7JtldXSNF8T8R9RRwKiTgYqvxZSXf/ONJVBVpfWOy90gV8zcxU9c1La9+elunEW7fplqQwBJA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(47076005)(36756003)(2616005)(426003)(41300700001)(81166007)(8676002)(70206006)(82740400003)(70586007)(86362001)(8936002)(356005)(40480700001)(4326008)(110136005)(40460700003)(966005)(478600001)(36860700001)(83380400001)(316002)(336012)(2906002)(26005)(5660300002)(1076003)(82310400005)(44832011)(16526019)(6666004)(186003)(54906003)(333604002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 20:06:07.2220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab76453b-0cba-4013-5a08-08db2efeb3a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980
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

https://lore.kernel.org/netdev/20230324190243.27722-1-shannon.nelson@amd.com/

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
v6:
- As suggested by Alex Williamson, use pci_domain_nr() macro to make sure
  the pds_vfio client's devname is unique
- Remove unnecessary forward declaration and include
- Fix copyright comment to use correct company name
- Remove "." from struct documentation for consistency

v5:
- Fix SPDX comments in .h files
- Remove adminqcq argument from pdsc_post_adminq() uses
- Unregister client on vfio_pci_core_register_device() failure
- Other minor checkpatch issues
https://lore.kernel.org/netdev/20230322203442.56169-1-brett.creeley@amd.com/

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
 drivers/vfio/pci/pds/cmds.c                   | 531 +++++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  25 +
 drivers/vfio/pci/pds/dirty.c                  | 540 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  45 ++
 drivers/vfio/pci/pds/lm.c                     | 486 ++++++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  52 ++
 drivers/vfio/pci/pds/pci_drv.c                | 212 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 235 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  40 ++
 drivers/vfio/vfio_main.c                      |  48 ++
 include/linux/pds/pds_lm.h                    | 389 +++++++++++++
 include/linux/vfio.h                          |   3 +
 21 files changed, 2738 insertions(+), 47 deletions(-)
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

