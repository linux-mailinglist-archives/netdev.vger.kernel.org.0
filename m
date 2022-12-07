Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B336450B8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLGBH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiLGBH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:07:27 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248F1F59A;
        Tue,  6 Dec 2022 17:07:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaaStIRoF/w1DpBzTCEb18dZqdubpPfhRmH/syghtZWU3/9QvMSmMLlTmP+kbutrTkICwld/oJxqr50/ItNHVrJtUNWloBwVICehhT5pPsClVhBKlPnHtgA9Nd3xsIb0Iqg2hMv+6GJVnexu8rEE7l2FZKdghmK6OZNsvpQwDrnhFV8W4xYwDPV3VD8ySqxARHFMiQRE7nt0klU4k8A6N0sBZVGX6L3wYFED6yhjvvcfM1Pv0od35uZeEiGhWC2ZBRm94MC2Ybszqoi0qIayfmXl5qGTzFtWZXQRVfTxobr6j8b0qHzP8XeVPQDuE9HJlj7BLW6AKJA9zNX78HgrJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8N2OqjWm/QQ8PRAaOZWV10wBoWFgTlIgPyjC+s6zGs=;
 b=WqIw1PCZ6vkz5xeYViHflWLxHN+i1JPTycfV6AboNZvICJNCyKRP+ECNtywn1f+fuphDrWP1GQczED3CiasxHKfIB02RDTHysRRpt/oXsyMAhI3YBX+RlWWNNYiT2kKN00LuUgrMdUB4chmGru/DblyZ8MEQBhZWYqsMwTrlV4ASPsQzyJOHmh/NdsekAOhH2/5few1oX60I30BHwPKMUrMM1XxZTK6maxJfddjsr49Yt1AtEJeWtWmDVzuu4YOeOCSLikXdp6fZWCptjj4vSq+oZqWVKQMJ/O9oVKpM1TetCS+Ujrj8C7b4RlGcAwP2pppgFoQZ/AHT6FUUWVqUrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8N2OqjWm/QQ8PRAaOZWV10wBoWFgTlIgPyjC+s6zGs=;
 b=hA2hmbB68/v7uSvBAfUcRbNVIN8+A1LN+eAIwpGq+VpguVyxNCunckt6mDnTrTozub+QAT8Vfg9fjaO04VLPAYOqq/zs464z+PbU95EpzSMnIueuU3uwMzM7nsCGR5zZqd9Gnx9a9wJC2kJ5pogz5GGxrAKGRr/tOuQHiGOA+VY=
Received: from MW4PR04CA0364.namprd04.prod.outlook.com (2603:10b6:303:81::9)
 by SA0PR12MB7075.namprd12.prod.outlook.com (2603:10b6:806:2d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 01:07:24 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::41) by MW4PR04CA0364.outlook.office365.com
 (2603:10b6:303:81::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 01:07:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 01:07:22 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 19:07:19 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH vfio 0/7] pds vfio driver
Date:   Tue, 6 Dec 2022 17:06:58 -0800
Message-ID: <20221207010705.35128-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT021:EE_|SA0PR12MB7075:EE_
X-MS-Office365-Filtering-Correlation-Id: 0edf2e91-f044-49a0-852c-08dad7ef65bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QOrKEJGxrBkKQE8z4+nUvgkL7TiUxP0t1sK9EwNXoENTHjm6MecoEEMpQJpykrr6Cw6BnOn7qHaflJu3sXtEOvn2tYm+WFPgnfHzELmMLTaMyXLTBna8w92lLoKAhE2UoyIHWxYHCtRi9qoxB0t7zrEa1C5o9nMAtZtkhO38fTxF/vGj8LaitRhWxul3vq2lugcbQFQg5MNOQD76eKxYjEBJlQYngiM+/jBcKrZj3gSTk+DZRiIsFfwaylcvHkRK7ABF8ygC4GkcBrNxQ2qm0CbO9Ixo7TUVXKDZ6lCheCO6K2ezwH49Wg4+cRfdiyCy2YGynrkA7iEgxxNg9Aqn4XUsSG/UlBQjzznZEm20OQoZtQVgCf/qboqsNSMs5FeBPYLqcJkqxJiubP7+DrxVH14wf9tgcc3C95Pv9j3+eUL5ZWEUe8KIFClka4n2DaOfZtcrsUD4nLBM3Z6WLNFLucu47AJwabtuZybv3D6MFWLq/1JgvNXpu4nUM60pw7LFHjrYQaugKBNRhCnPc8wMcoSYHXdpkrD0jFwBAh/4DUowGT7KlvwfXTE3pt7F3ANe3qABMwEmLvpm5aYUJUq4gdsprzmgYUxkrfN3sh6sXZr/ybsb6f+w6f136laZfwjjIs+s529frotzuF581feIpKNp9oZr4HXlXzsIwsCjCU8Z8PQ2jdmRjilM85jpjB957/EHh8jlVCVSYodbsPFkfbH0OIhx7la1EB2l4EOV2M/kxb87kkXlWOFlEuOdCBad6cerfNQfxK3lbvkxO6xTuA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(36756003)(81166007)(86362001)(5660300002)(356005)(8936002)(4326008)(40460700003)(41300700001)(2906002)(82740400003)(44832011)(36860700001)(83380400001)(70586007)(478600001)(110136005)(316002)(2616005)(54906003)(966005)(8676002)(40480700001)(70206006)(82310400005)(6666004)(426003)(336012)(47076005)(1076003)(186003)(16526019)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:07:22.8858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0edf2e91-f044-49a0-852c-08dad7ef65bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7075
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a first draft patchset for a new vendor specific VFIO driver for
use with the AMD/Pensando Distributed Services Card (DSC). This driver
(pds_vfio) is a client of the newly introduced pds_core driver.

Reference to the pds_core patchset:
https://lore.kernel.org/netdev/20221207004443.33779-1-shannon.nelson@amd.com/

AMD/Pensando already supports a NVMe VF device (1dd8:1006) in the
Distributed Services Card (DSC). This patchset adds the new pds_vfio
driver in order to support NVMe VF live migration.

This driver will use the pds_core device and auxiliary_bus as the VFIO
control path to the DSC. The pds_core device creates auxiliary_bus devices
for each live migratable VF. The devices are named by their feature plus
the VF PCI BDF so the auxiliary_bus driver implemented by pds_vfio can find
its related VF PCI driver instance. Once this auxiliary bus connection
is configured, the pds_vfio driver can send admin queue commands to the
device and receive events from pds_core.

An ASCII diagram of a VFIO instance looks something like this and can
be used with the VFIO subsystem to provide devices VFIO and live
migration support.

                               .------.  .--------------------------.
                               | QEMU |--|  VM     .-------------.  |
                               '......'  |         | nvme driver |  |
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
    |     '----------'         '----------'  |      nvme      |
    |                     DSC                |  data/control  |
    |                                        |      path      |
    -----------------------------------------------------------


The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
It makes use of and introduces new files in the common include/linux/pds
include directory.

Brett Creeley (7):
  pds_vfio: Initial support for pds_vfio VFIO driver
  pds_vfio: Add support to register as PDS client
  pds_vfio: Add VFIO live migration support
  vfio: Commonize combine_ranges for use in other VFIO drivers
  pds_vfio: Add support for dirty page tracking
  pds_vfio: Add support for firmware recovery
  pds_vfio: Add documentation files

 .../ethernet/pensando/pds_vfio.rst            |  88 +++
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
 drivers/vfio/pci/pds/Kconfig                  |  10 +
 drivers/vfio/pci/pds/Makefile                 |  12 +
 drivers/vfio/pci/pds/aux_drv.c                | 216 +++++++
 drivers/vfio/pci/pds/aux_drv.h                |  30 +
 drivers/vfio/pci/pds/cmds.c                   | 486 ++++++++++++++++
 drivers/vfio/pci/pds/cmds.h                   |  44 ++
 drivers/vfio/pci/pds/dirty.c                  | 541 ++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h                  |  49 ++
 drivers/vfio/pci/pds/lm.c                     | 484 ++++++++++++++++
 drivers/vfio/pci/pds/lm.h                     |  53 ++
 drivers/vfio/pci/pds/pci_drv.c                | 134 +++++
 drivers/vfio/pci/pds/pci_drv.h                |   9 +
 drivers/vfio/pci/pds/vfio_dev.c               | 238 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h               |  42 ++
 drivers/vfio/vfio_main.c                      |  48 ++
 include/linux/pds/pds_core_if.h               |   1 +
 include/linux/pds/pds_lm.h                    | 356 ++++++++++++
 include/linux/vfio.h                          |   3 +
 21 files changed, 2847 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
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

