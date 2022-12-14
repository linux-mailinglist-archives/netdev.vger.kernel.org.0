Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8529364D349
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiLNXXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiLNXWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:22:43 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2052.outbound.protection.outlook.com [40.107.212.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8695217E;
        Wed, 14 Dec 2022 15:21:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FD2v0aH80h9WM+mSi9ZiC102az7/aC9JKHR4VBf0lcqXLmYYZigLKoLT1NPzeourg6ga3AZFgnc1dmuMxvC34f5tda2nY06vpsE5Yk2ufGER1QkwwdBnlgF/YPcGnIfcbPOuLg7ynBrHcwbH1OqwLAsf6CB+e7GAm0E2usiP4VJ6k65sYic0Fvyb9vyET/q5noMONlWrNolE+gs0hs+EdCzmzHwQ0p6D8DakYWDcac5jkfqfALKUiDMFUQpZzAYi8xzhkEK2zI3MI4am8jvEmOfKcM50XHfZFK4ZEIbHM8CYbowWoeS2tkGCrRY36tPjQi+fJV2XgHKWpYQGAB5CPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XW9TFSNN6/+EpznrKytrIqxkFOPjdgqPzvuppy2RT5A=;
 b=eG/faIwo2wY5FlgVljDfY9c5Zq5b6Ptmiz/efSDV8S1p08KZMbVCEnyNari5gqB5CZu6eZqQtGvNEXt3wMFwAhlfltE8TidHOhmEKlCw/jQydvVI8f2m5zqt1PqfC1viHFoNL7aTQiYATl0zK4n2PYFwvVEI+HtxCJFndycfakzB576ctWGmZBr4IvD1nXTVifpVfrZ0007MultyQhIFd+3qJHGVNYgm06aO/85hWbeZLl1jk9x3o2ycIcSFmV34757tkJ1bZYC5hvrgBpMDNZ9IAySkQRMro1fyQYzOo7HE0JhezpP+GZsyAzK5GsgcVrVu9y9rlYwXtcgZccnMJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XW9TFSNN6/+EpznrKytrIqxkFOPjdgqPzvuppy2RT5A=;
 b=TQqA4NUgF8aD9qw2a0KuCO5n2Xv9wBxuhwA+1T/sQE25qbffa10nFC5RbgheRgEt4vOV3+f2lUB7dhGhbxiIbTpauMxaVjxRrw9PB4sFdtfy3Cx4nPiNZOcw3MygxBLLpdVeR8JbdzZhtp4o3OzhjrizDbmKTT1xBa70UkBQW90=
Received: from BN9PR03CA0655.namprd03.prod.outlook.com (2603:10b6:408:13b::30)
 by SA0PR12MB4429.namprd12.prod.outlook.com (2603:10b6:806:73::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 23:21:52 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::b5) by BN9PR03CA0655.outlook.office365.com
 (2603:10b6:408:13b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 23:21:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.12 via Frontend Transport; Wed, 14 Dec 2022 23:21:52 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 17:21:50 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH v2 vfio 0/7] pds vfio driver
Date:   Wed, 14 Dec 2022 15:21:29 -0800
Message-ID: <20221214232136.64220-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|SA0PR12MB4429:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c7450a4-e8d7-4d3e-730d-08dade29fb80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYQrT6Pmn5nfZ1eOgSGMJl0wg4qB37qCYDsBhCc19Tc3YZcGh3qwzMz3ATqTlGS5Ub5ohh/PcaFG3hoEyKNMm1lQDfGR7xSbFF9f0zfPJ16yHa1q4srJQEQdP+OGClIZeluZJO7WM7TaYgYWS6MFe/f8+Dq9zuvliXECSySTW4WDhWvQfjDFEGqmtD5f7U1eCUI6Vt449BmoFv7IZQZLG8Xxaaeym8sMqAUMMArwtvG1MsGjFWe+A+SvDDPChTgH0Jn585W7owyy5h8yLe3jxqXOG7RLq5ttNfn7nDNrCa2qRR6ogZfmtDnTX3gwii2KUIlgV2v+GmcFCGD6KbkuXQyNzjprXO/3iTV0Rm3hd9PTAofPr7SUUc1N1BRFrB3E3ySSoBWvEA6ngqlm3u/C1+xju97Huwwtj2i1qEHiPAG1KOyGEUZoz4YYit/ZZ6+OkasXroPn5eJzIKTGefFPxwDXjSijiOOE27Ebo3vqVWpKy14I00vnYGj83XvbCYEFJ7WvatgA8skPUylRpWrJDyrTThvoi3gJ2pjUpXClS5a7a5GFrox1TIS98wLBluAKM5uor/gzVQsBvbiw0bGUlIa8XqkmZyiBmsKm6xwWNvaKpdL3mYDpBlMxiqhCbbbqN/rgeIESH/OcL5xa0tIlOe0JunAiRjEpxjL9T3CLWoVtBtbeJnJ9qbiikYC+IpsbxygZRLuzIPN1Cp9wXzkzxeMmWP2BCgiQ38ydFmwTmLit4TjEDzPtQpGMFvQXVGN0121upj/a5MaMRu8z7SNrEQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(82310400005)(5660300002)(86362001)(36756003)(47076005)(8936002)(426003)(40480700001)(1076003)(356005)(16526019)(336012)(186003)(41300700001)(83380400001)(82740400003)(81166007)(40460700003)(2906002)(44832011)(36860700001)(26005)(8676002)(478600001)(70586007)(2616005)(966005)(4326008)(70206006)(110136005)(316002)(54906003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:21:52.0402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7450a4-e8d7-4d3e-730d-08dade29fb80
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4429
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

Changes:
v2:
- Implement state transitions for VFIO_MIGRATION_P2P flag
- Improve auxiliary driver probe by returning EPROBE_DEFER
  when the PCI driver is not set up correctly
- Add pointer to docs in
  Documentation/networking/device_drivers/ethernet/index.rst

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

