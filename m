Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2F169BF20
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBSIjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBSIjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:39:31 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F86D53B;
        Sun, 19 Feb 2023 00:39:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YdwIPveVvYkRLIxdh7+tnig7Qh0RXC5wA1Y/SSpgAtemfLIQyuXrbkRxDqZgH1iPHb3IE6dwZRnUf1DdSvDCWaoPp6uOExgzJotx9Fndo48kQu5P1b7DqAowkqo7JxFPMqtLSEvA8jXG/j4N+0Lplpytn/7qch0DWL6ITmbhAAHIqI2ySJwU5qgbOl6uG7RjhZbtpHTWUxYP9WtcJqcWcDb3v92ZnyNweS8GudEvYyAS/l/V0iIXwC0C4TqZ08uVmkfZidKxmHNyEK+Vx5oqT5FZDXT+9akQ8eV7ha2S7eovXw4ebgwhQh2uHAZqnV8G7L1Mb0h7Fal0rtGZNAzN4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+co0NGJVSnMIehJTVOYtPMETigStlhCOEma43OlHWnM=;
 b=Nd8QiwOMBYr24hlfPOZ6yxRrd/Zkc1xxNCw8XvDK9Ax7RxClwTK+gjxDkeqpFFq6YjbK3ZVNKfvJ1zWzFZ59ez7obEqYhVtBvxna6mibLgI3D7AUuNj4odohwafhOWAjx8xxOoht8/KaFIjyj6shCeKRFq7cGgQeZcJmAgKhQJMAXRCMHDVWhSFEaq0lE+JRVORAgD0QpdRVNB+cExbJX5+BHAAaR/NxXfDsPW/z03c8TFNrfC47OECyKgSot+ZgHd94W62Zk2owBMbTjhZCkprwlbQ22mFuQtQEjflEXiFsQhgxqzUYNby3SAxQgwWdYk+tFa2aoFoQpCmf9Qpolw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+co0NGJVSnMIehJTVOYtPMETigStlhCOEma43OlHWnM=;
 b=OmJuWHtOLm99aXjUqh3L1tC3XUA7swg4RBPyK2ggu9Za/UyPjOMC3WGxIce55iqdw3tAZz8FJ8+uLjxPM2Rg56ALgTYboldM+yl6wWNfdV3qksLxyCoRAPpZzk4K/7XfJgmekGsEaBmDHm3P6Ch/Hro7OUiJD+Db2+jCmBq0mlA=
Received: from MW4PR04CA0317.namprd04.prod.outlook.com (2603:10b6:303:82::22)
 by BL0PR12MB4930.namprd12.prod.outlook.com (2603:10b6:208:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 08:39:26 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::b7) by MW4PR04CA0317.outlook.office365.com
 (2603:10b6:303:82::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18 via Frontend
 Transport; Sun, 19 Feb 2023 08:39:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Sun, 19 Feb 2023 08:39:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 19 Feb
 2023 02:39:24 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        <brett.creeley@amd.com>
Subject: [PATCH v3 vfio 0/7] pds vfio driver
Date:   Sun, 19 Feb 2023 00:39:01 -0800
Message-ID: <20230219083908.40013-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT056:EE_|BL0PR12MB4930:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c677839-e65b-459d-88a7-08db1254cf27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L9hrZOnM5a07MQq6ezSnOdTAkQCPWcDR45B06FZU6gyWlppAkXjP5IxII7bh/ubTX82T7uxLp4ayBWq1zz3U0ngeumjSWxMmiK917dhnrptWrH+hcJRZtLVSRbrKD4ZQEQ9slSk9Ic1RBDAUPlrSQ2eUZE4IkC5ioMbJUh+jVyueKGwxdb6/Jm0nTXaOj4D2TcO8K5EeYGRg4rJ0JwBMR3qG4QzkBYNMSg0SxG6epdOTE3eFLdzsbGmmWbX3p3v04q7/KsHxY0r6Bz5kMvvijrO/hsQBvswQpwP9m0edVmm9j0PheLFQ25dO4M4uq3DzkxMlvJDPszrLYiDbl5cltOmb7g8GmG3UmT/cK698/G2FX6LtMlVJRRh+P2bF/dJlTGuWA6Ui1X4HOOF+ifzRW/pLAfYFwNCNVKhgitueRjetGKEyyZ5lC/5vrqp4SFN57/EY0KteBX5QPnTErijXAmBnTEf58aGTaxcXPQ2YqL7yzJ9xV4BdRjcr7C7+0/3NIYeBS6QdSholDMJCJIxpDPaofRtrivQjuzzGKsVCo80HwCVNeCivRBk97hPshhRPgrbTvdvybiVOWZ+aYttvFnXGldmRoj6kD1fmfp06kY/thcO6GO5bK2SdtPZd4gVEPVhQavozXjR/a4aK8mcJowkNCQpaReMjU6VPSW8GfSckehnx2uJbDVcPRFOYPaUfOr8r1663JxRprQBTGDzps4C/krUoox4qby5a8SOVI8h44EilZYZTgWLF+EMuom+KGe06PMPv7xz0OI2LQ5R+3g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39850400004)(346002)(136003)(376002)(451199018)(36840700001)(40470700004)(46966006)(47076005)(426003)(336012)(2616005)(36860700001)(356005)(40480700001)(40460700003)(86362001)(36756003)(81166007)(82740400003)(82310400005)(5660300002)(8936002)(110136005)(54906003)(2906002)(44832011)(41300700001)(70586007)(8676002)(83380400001)(70206006)(4326008)(316002)(16526019)(26005)(186003)(478600001)(966005)(1076003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 08:39:26.3522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c677839-e65b-459d-88a7-08db1254cf27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4930
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a draft patchset for a new vendor specific VFIO driver
(pds_vfio) for use with the AMD/Pensando Distributed Services Card
(DSC). This driver is device type agnostic and live migration is
supported as long as the underlying SR-IOV VF supports live migration
on the DSC. This driver is a client of the newly introduced pds_core
driver, which the latest version can be referenced at:

https://lore.kernel.org/netdev/20230217225558.19837-1-shannon.nelson@amd.com/

This driver will use the pds_core device and auxiliary_bus as the VFIO
control path to the DSC. The pds_core device creates auxiliary_bus
devices for each live migratable VF. The devices are named by their
feature plus the VF PCI BDF so the auxiliary_bus driver implemented by
pds_vfio can find its related VF PCI driver instance. Once this
auxiliary bus connection is configured, the pds_vfio driver can send
admin queue commands to the device and receive events from pds_core.

An ASCII diagram of a VFIO instance looks something like this and can
be used with the VFIO subsystem to provide devices VFIO and live
migration support.

                               .------.  .--------------------------.
                               | QEMU |--|  VM     .-------------.  |
                               '......'  |         | PCI driver  |  |
                                  |      |         .-------------.  |
                                  |      |         |  SR-IOV VF  |  |
                                  |      |         '-------------'  |
                                  |      '---------------||---------'
                               .--------------.          ||
                               |/dev/<vfio_fd>|          ||
                               '--------------'          ||
Host Userspace                         |                 ||
===================================================      ||
Host Kernel                            |                 ||
                                       |                 ||
           pds_core.LM.2305 <--+   .--------.            ||
                   |           |   |vfio-pci|            ||
                   |           |   '--------'            ||
                   |           |       |                 ||
         .------------.       .-------------.            ||
         |  pds_core  |       |   pds_vfio  |            ||
         '------------'       '-------------'            ||
               ||                   ||                   ||
             09:00.0              09:00.1                ||
== PCI ==================================================||=====
               ||                   ||                   ||
          .----------.         .----------.              ||
    ,-----|    PF    |---------|    VF    |-------------------,
    |     '----------'         '----------'  |       VF       |
    |                     DSC                |  data/control  |
    |                                        |      path      |
    -----------------------------------------------------------


The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
It makes use of and introduces new files in the common include/linux/pds
include directory.

Changes:

v3:
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
  vfio/pds: Initial support for pds_vfio VFIO driver
  vfio/pds: Add support to register as PDS client
  vfio/pds: Add VFIO live migration support
  vfio: Commonize combine_ranges for use in other VFIO drivers
  vfio/pds: Add support for dirty page tracking
  vfio/pds: Add support for firmware recovery
  vfio/pds: Add Kconfig and documentation

 .../device_drivers/ethernet/amd/pds_vfio.rst  |  88 +++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   7 +
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
 drivers/vfio/pci/pds/Kconfig                  |  19 +
 drivers/vfio/pci/pds/Makefile                 |  12 +
 drivers/vfio/pci/pds/aux_drv.c                | 210 +++++++
 drivers/vfio/pci/pds/aux_drv.h                |  28 +
 drivers/vfio/pci/pds/cmds.c                   | 485 ++++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  44 ++
 drivers/vfio/pci/pds/dirty.c                  | 541 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  48 ++
 drivers/vfio/pci/pds/lm.c                     | 491 ++++++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  53 ++
 drivers/vfio/pci/pds/pci_drv.c                | 126 ++++
 drivers/vfio/pci/pds/pci_drv.h                |  14 +
 drivers/vfio/pci/pds/vfio_dev.c               | 239 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  42 ++
 drivers/vfio/vfio_main.c                      |  48 ++
 include/linux/pds/pds_lm.h                    | 391 +++++++++++++
 include/linux/vfio.h                          |   3 +
 23 files changed, 2895 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vfio.rst
 create mode 100644 drivers/vfio/pci/pds/Kconfig
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/aux_drv.c
 create mode 100644 drivers/vfio/pci/pds/aux_drv.h
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

