Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43EE96C57E2
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCVUmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjCVUmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:42:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E351E85B34;
        Wed, 22 Mar 2023 13:34:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht0kuE4MPaurZE/nxr/VlzsN3Hmx3ZcF8y6OKvBusuWATz9h4G81C3hYz9xgZkoj3xF7PCB5a+jBPLyXCFdiPfn99e+LZRgdA45IPWVrJY363dp4Rvv50RqVMllQ9giUtDCDV9fyavCNAhT+q/r4VEMJuNRgrrS9rAYXef1oYds3svbXd9toYScKpvPKFBbxXrEexfnCwPiwzLY+D9/LAdcotWTz4AWE0TmIp2hEl3bvgSJ434OxAVCOZBWOJ8SD5lw7L3N3PRkf800hJKtvNKFtjZpKQD8FulL5poNggzs3uPmYEpre7+skhpLDA/uGiW5BA8M6gYLNMEEjEXw+lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XghprXbshvX2FhxF4s8Pto7UaHr8h++Y2Nrw5ZTTKo=;
 b=TNl8PWwV4OXFU4jnP5DHrsEmdTrsDNddoenjQbIIvF8pe6AynLcdi+smDh+B77PCJDh9xmZUmGHCvFuOlzgwivl4t5KTcVx4ED1auL93t8ZZSYOamzyzbv1bf0GVB590qL31pRZ0CAXT1f8UfEPCf0YeA40G4rfc6YU1UMNXL5jYjSgp/RXgd6n7LJnoOgiJmx1Mjv2pQDAeNaV0u1fkQ3cJo2TKwf/PtuCdlKw5Yi7FTtrFrlZPhbG40VglB+atMzMKO6XvCaWqa1UAnFWsPKRIFAGGwk4+QEmqqrps2tWP0PodzXbcW1DuCssI6s4u4PjGMvSoMBLb/MaAN3mNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XghprXbshvX2FhxF4s8Pto7UaHr8h++Y2Nrw5ZTTKo=;
 b=qAIo/D6dtqlnYeQm4CPKOp6r1tgGmYb/TCE0ZFZt0lEJrPYMajXdg/1TMqfVsQ/dGjHOxwBtkhbw2n28FmvtCOZsnE3EePDHjYzt9Zt4TzJB7Q9dUFMJsyRqqdCsthXy8E98kOS+Wash5zRZMd21XQJ5mqFbXojxiSbe7EOjA04=
Received: from BN0PR10CA0026.namprd10.prod.outlook.com (2603:10b6:408:143::21)
 by MW4PR12MB7438.namprd12.prod.outlook.com (2603:10b6:303:219::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:34:56 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::2a) by BN0PR10CA0026.outlook.office365.com
 (2603:10b6:408:143::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 20:34:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 20:34:56 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 15:34:55 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drviers@pensando.io>
Subject: [PATCH v5 vfio 0/7] pds_vfio driver
Date:   Wed, 22 Mar 2023 13:34:35 -0700
Message-ID: <20230322203442.56169-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT043:EE_|MW4PR12MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: c5923e83-0040-4575-14bb-08db2b14e635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cHDn20esDD+ez+CzP5OYu3xEUMW6ZIjl4tQ9u0bn12niHuDtD1Zarp8StDsXFEJoIK+FcjC0FTPfYBMnnMsVbEGOFLlYKXBefhu+nLeLNePxRDiF9mdFtEYiuf000+XCFd5wLSLND3B6QRHiWBXirWXlZuQjn/Oq0Vs7e9E9BBQjw01SxUYgB3SXLWFLO5kCctpWIENodg5AGSCif9mQ9oSOvZvEBcBi/3VWjPv85Krmp7RseuaeqS4/AuIIjYUwZN/AYx84JWM6q1/jQkUo3eJx1vuqRxNCAuK3MTEmRkq23Z7dveI//TiMUWP44+y0DMEo9qY5RekgxAELJiQW31/PSCB3K/3k0MLarKl3SEOOT7aQIaMWqQWAnj8Whi4UbGcORntuSTAYcg67UiN7plagb+vF8syQCj/soDfQ2wvz/ENjoRabb1/RPSjulSwW30UdH8ka/ikRYJff8nonqTwGuYby1fh05sqRsced0bxHq2jH8TUv3HkeQuMae2mP+ftaYcHVoQmOAlu8sk4f2i/9SKVsXy6+v78xbrJkYuEeIuB0Rt6cV/93TO8yeZbhLUEJtrcADLaFVonWmcpOt+P4LspXcvXeuigY1EpwaQId7uX7eINjg66jsZNtejABYK9MD/LtdcOUZVag9mPE/TdZv0gbx4jxv1bjln1G3yB/6QnHMq2kbA81yA7uRozqm41Q1aNw8ioNxlsnbtrVbQTK3T5G5VJZN+UUko6WDVAz6KEQ8vq9Dh4jSGMQcDINgI9iP37RUeJHFIXw1thtg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(316002)(54906003)(966005)(6666004)(81166007)(4326008)(8676002)(70206006)(110136005)(478600001)(70586007)(336012)(47076005)(82740400003)(426003)(2906002)(2616005)(41300700001)(186003)(40460700003)(26005)(86362001)(16526019)(356005)(36860700001)(8936002)(83380400001)(36756003)(40480700001)(5660300002)(1076003)(44832011)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:34:56.3229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5923e83-0040-4575-14bb-08db2b14e635
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7438
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patchset for a new vendor specific VFIO driver
(pds_vfio) for use with the AMD/Pensando Distributed Services Card
(DSC). This driver makes use of the newly introduced pds_core
driver, which the latest version can be referenced at:

https://lore.kernel.org/netdev/20230322185626.38758-1-shannon.nelson@amd.com/

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
v5:
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
 drivers/vfio/pci/pds/cmds.c                   | 529 +++++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  27 +
 drivers/vfio/pci/pds/dirty.c                  | 540 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  45 ++
 drivers/vfio/pci/pds/lm.c                     | 486 ++++++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  52 ++
 drivers/vfio/pci/pds/pci_drv.c                | 212 +++++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 235 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  40 ++
 drivers/vfio/vfio_main.c                      |  48 ++
 include/linux/pds/pds_lm.h                    | 391 +++++++++++++
 include/linux/vfio.h                          |   3 +
 21 files changed, 2740 insertions(+), 47 deletions(-)
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

