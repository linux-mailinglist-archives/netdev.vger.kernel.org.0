Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3421042BBED
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhJMJu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:50:29 -0400
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com ([40.107.244.51]:41313
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235811AbhJMJu2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:50:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euRy5gcUqlChYDYj5zioJy1bmTIW824dM/N/6/rsPU7+xbzpvUgQtjXBtiPDRwo4+meU9DjmyL23mhXkwJPPkyJo53YxPM6s8Frw7W3mhZgpaktpAJJ6zgC6Socj/MThoYr4JpI7zZYIkYy7x5NEtb7ir8h2O/Md884MMQyA28T+qJMa7iYO5PyWdbtRb2CmJ7cLiid0XTsZOsrzMcWN8LtiNMk9/aTpxTUttrxF9XntE/t8pPGu2egJX5oU6XQQz7GaJnRUKOj4mmchH+GwPdIuJFeq3JV8SRRZ3iqmgPRNJGYX3Qhb5H02Jcup3Sg2+RjJmyBHJDXn8TxPZnAsfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1I162L7yvpQdq4kUMGIeyV2F1Dm3zZ3PJa7LGhR7ns=;
 b=diTMm+RL9SjwyC+Ceo3LxQw8B+iOId4FvG2biGY5Gk0fp42zXYC8OHtZ+x/ulSJlXO1UxwDV1bYIy4Rbz2wM/fgBW7RwHFY06T0NOsRP2Pw6gR6dB2ReHuh961zyXtIbjOV27Q90ftfSDVRICe9bYQNM1a0Ydf0JrGPoJflper6dI8C6YyDhm0ZXp8pmQSoaeGYKUlJLSNgOTgWjYgmE4xRP7WPuZpUEmv/za64TzWI8Q5M3jSv4NjZ7j6msQxmvIfdMx1GuAKJU4dsJHZLmvK47iuyAfk3/4XX5h60GqwvY6OXab9+wreA7HNWZAtdI2yVf3e0rnof0g7Le6LM5JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1I162L7yvpQdq4kUMGIeyV2F1Dm3zZ3PJa7LGhR7ns=;
 b=VspMuDNyml0dludg5LAY/kyZed/RNUDr5sL3RxKT1vleYdMrOQhjHUVVxH5FqlWi/Xr3TqSAjS4oA8J6zTyrcI5o+6NpJvrhFYu1gp5SllV2kK8pXGI0/iwt1L0q8VGB2kt5ga1CypHSl7FaDFHKSiUBJmXATl2+VTNAdCf7aMgmoWgzkWSCDeT1HrNOshilBfSHqM3gliGtIaXJsHojgkzkit05LO3w5TtlUCUVJrJRJRqvEm+HSEj37WzsPFhgzAZLsGeF0Fa/kccLk5cEJT3InUzh3a/w9pn2cuOVZUYL8e7Bz/oBTIv0rwBJWKKXl5YCSMZyBTO54o7Vi1PSQQ==
Received: from MW4P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::12)
 by BN6PR1201MB0081.namprd12.prod.outlook.com (2603:10b6:405:4f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 09:48:24 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::83) by MW4P223CA0007.outlook.office365.com
 (2603:10b6:303:80::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Wed, 13 Oct 2021 09:48:23 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 13 Oct
 2021 09:48:23 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 13 Oct 2021 09:48:19 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V1 mlx5-next 00/13] Add mlx5 live migration driver
Date:   Wed, 13 Oct 2021 12:46:54 +0300
Message-ID: <20211013094707.163054-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08a2a1b4-fb13-40c0-89c7-08d98e2e9920
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0081:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0081FFAAD26F48E3327C658AC3B79@BN6PR1201MB0081.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ddQTxPgR4ZQWay2dFagWoSo4YzxPmlamTa1w8ox7Suk2wmYopwKzqNTfzJFjoyXo/FeBMjlE8ZclvK61W2sCETyv330zSSGlAZggeOfBDHuWClWlbzkRmoWBp6L/Tl/9XB8D0/BiOFjOJcS/O6og+qs/TUT77CptfesBr/MPrd2q3VF2LdhFGOyMrcenaVil3E3kkPHFAlBhd1y1swd6oMtaP4X2zPhXyvL746VnVqNpuhzqYk+M2ZEO8TPZM8ftcd3Wt7Bne24deXlpbcv0tLQyixMp6F3hdHirw0ZblLo95OWEO/Fk10wg/NPANx5jbhfthb4p7f4byUzUjxM3LfwupMZM8yec6t89frOJ/xPWGGzAZSzSg16rNM6a80Ji6pRMa9YFEYqMGRPMhnJMhyxPVNvohMrN6u5Azn7+X/3+geLO4vptNHhKIESTnG1Sb90UWrFZ6jz9OYml+uEtscIU2J7buCLSThN9dKHGca0TR6MXwc546lexuYL2H5FFDziITYUerzttCu1b2QNMUUZM02JmfTMqT8aG7HptmWPQmNz2yq+7O1IzSmjVwIdGBUdaY4L9iGllYxQ1G+yWfUH2JjU8c2+ErL0QNHiH5Bw5xH9YYGGROW4MgqnJ5jvoak6PT8hEq4HYGBCgbvdXDAGodQZPLa6pmtfacttDEP+u6JxifR5iaQCGc2Le9VpevUj8AbG46uGVd/lqW9LuIw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36906005)(36860700001)(36756003)(2616005)(508600001)(107886003)(70586007)(316002)(70206006)(2906002)(47076005)(86362001)(6666004)(186003)(26005)(8936002)(356005)(8676002)(6636002)(1076003)(4326008)(7636003)(7696005)(82310400003)(110136005)(83380400001)(5660300002)(426003)(54906003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 09:48:23.6879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a2a1b4-fb13-40c0-89c7-08d98e2e9920
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds mlx5 live migration driver for VFs that are migrated
capable.

It uses vfio_pci_core to register to the VFIO subsystem and then
implements the mlx5 specific logic in the migration area.

The migration implementation follows the definition from uapi/vfio.h and
uses the mlx5 VF->PF command channel to achieve it.

The series adds an option in the vfio core layer to let a driver being
registered to get a 'device RESET done' notification. This is needed to
let the driver maintains its state accordingly.

As part of the migration process the VF doesn't ride on mlx5_core, the
device is driving *two* different PCI devices, the PF owned by mlx5_core
and the VF owned by the mlx5 vfio driver.

The mlx5_core of the PF is accessed only during the narrow window of the
VF's ioctl that requires its services.

To let that work properly a new API was added in the PCI layer (i.e.
pci_iov_get_pf_drvdata) that lets the VF access safely to the PF
drvdata. It was used in this series as part of mlx5_core and mlx5_vdpa
when a VF needed that functionality.

In addition, mlx5_core was aligned with other drivers to disable SRIOV
before PF has gone as part of the remove_one() call back.

This enables proper usage of the above new PCI API and prevents some
warning message that exists today when it's not done.

The series also exposes from the PCI sub system an API named
pci_iov_vf_id() to get the index of the VF. The PCI core uses this index
internally, often called the vf_id, during the setup of the VF, eg
pci_iov_add_virtfn().

The returned VF index is needed by the mlx5 vfio driver for its internal
operations to configure/control its VFs as part of the migration
process.

With the above functionality in place the driver implements the
suspend/resume flows to work over QEMU.

Changes from V0:
PCI/IOV:
- Add an API (i.e. pci_iov_get_pf_drvdata()) that allows SRVIO VF
  drivers to reach the drvdata of a PF.
net/mlx5:
- Add an extra patch to disable SRIOV before PF removal.
- Adapt to use the above PCI/IOV API as part of mlx5_vf_get_core_dev().
- Reuse the exported PCI/IOV virtfn index function call (i.e.
  pci_iov_vf_id().
vfio:
- Add support in the pci_core to let a driver be notified when
 ‘reset_done’ to let it sets its internal state accordingly.
- Add some helper stuff for ‘invalid’ state handling.
vfio/mlx5:
- Move to use the ‘command mode’ instead of the ‘state machine’
  scheme as was discussed in the mailing list.
-Handle the RESET scenario when called by vfio_pci_core to sets
 its internal state accordingly.
- Set initial state as RUNNING.
- Put the driver files as sub-folder under drivers/vfio/pci named mlx5
  and update the MAINTAINER file as was asked.
vdpa/mlx5:
Add a new patch to use mlx5_vf_get_core_dev() to get the PF device.

---------------------------------------------------------------
Alex,

This series touches our ethernet and RDMA drivers, so we will need to
route the patches through separate shared branch (mlx5-next) in order to
eliminate the chances of merge conflicts between different subsystems.

Thanks,
Yishai

Jason Gunthorpe (2):
  PCI/IOV: Provide internal VF index
  PCI/IOV: Allow SRIOV VF drivers to reach the drvdata of a PF

Leon Romanovsky (1):
  net/mlx5: Reuse exported virtfn index function call

Yishai Hadas (10):
  net/mlx5: Disable SRIOV before PF removal
  net/mlx5: Expose APIs to get/put the mlx5 core device
  vdpa/mlx5: Use mlx5_vf_get_core_dev() to get PF device
  vfio: Add 'invalid' state definitions
  vfio/pci_core: Make the region->release() function optional
  net/mlx5: Introduce migration bits and structures
  vfio/mlx5: Expose migration commands over mlx5 device
  vfio/mlx5: Implement vfio_pci driver for mlx5 devices
  vfio/pci: Add infrastructure to let vfio_pci_core drivers trap device
    RESET
  vfio/mlx5: Trap device RESET and update state accordingly

 MAINTAINERS                                   |   6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  44 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  17 +-
 drivers/pci/iov.c                             |  43 ++
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |  27 +-
 drivers/vfio/pci/Kconfig                      |   3 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/Kconfig                 |  11 +
 drivers/vfio/pci/mlx5/Makefile                |   4 +
 drivers/vfio/pci/mlx5/cmd.c                   | 353 +++++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  43 ++
 drivers/vfio/pci/mlx5/main.c                  | 707 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c            |   8 +-
 drivers/vfio/pci/vfio_pci_core.c              |   5 +-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 145 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio.h                          |   5 +
 include/linux/vfio_pci_core.h                 |  10 +
 include/uapi/linux/vfio.h                     |   4 +-
 21 files changed, 1428 insertions(+), 28 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

