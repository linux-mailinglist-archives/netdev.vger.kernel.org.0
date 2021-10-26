Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3811543AE89
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhJZJJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:09:36 -0400
Received: from mail-bn8nam08on2072.outbound.protection.outlook.com ([40.107.100.72]:51105
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230420AbhJZJJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:09:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EO/+vxFTQsP0bBQHHsJEXO8rWMOpg3ge6NZsYaBczkcRb6DL2CKZvOx1fVKWnu5k3xTCdlcszZ+9ZAJpP9E70Rs2gHju+aBCmI+RoYMVtZAyE3t42ezLyqxtylFS+TnkVWLTe+vTSOvGiFZJz8a7Rnyvlx+U4DMRp4Rcnz8gMWGNILX5xgBLy/thPyMYqyuHEAMZeajTGlgOyhvwE2iCDGTYLXC5pIKrGMQ0kZOnDxZVYEgBp0tc/HXnjz2oWZumXriQKrc4exbBuwtKggOcpMSejd51f9+0qLfYxsT8h8CjXMrgUEBJPKBkOH4neCgX1jpPbihoWA/8ZpuyATQ4aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cAwzOO8VqQefKN9HkXGQYlFv1O+BsftMRkHBrwLtvg=;
 b=JPHl54XvyVHnO+tKNsGc/GJ3nJmpC7iUfq0+hc1pdvwn89mA/JTgIUyDeDFXvHc+5UE0TiamVDNTIuM0r6r3O+uQZFtD7cSGs47wHy9bjYWd4dJ0oAaQxNMoajmk47j3hvhJ+J6q4UD9ZVG9Cp3pgwFWjFDJYqfCLd6iz7ll1dR8WP48rJvB74Bhb7iHul9yrfKsAnzFRXrnaSlP4MtemskwbUuZSXnQqtGBtVKwL004/s7ccvXWv7BKoj0+KH1EG6tfrcrv74Tu1UIaNSSh7KQlxsvCfHAroZ+mCXh5oM3fCfehQ1TYUsnWZ0D87aDh/l2JuC2Yiu34jaT92xMtdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cAwzOO8VqQefKN9HkXGQYlFv1O+BsftMRkHBrwLtvg=;
 b=I00rhPQ4DOvDWEjng9d10/FM0VpHfQy6BnMknENJr8fFpmBhzRhGqnkPXd9XKUQ6IDsaUNnb0A97YBOE9jLPtcD9rmEzAtdfm/wXZzReF1O6sDzjM9MinPKq33bBKlodeWuzjqvmBk3Vff00PHAwU0zhNqaGBb7m4hRuVd7QMJn/5YeBNxFIPM2vklHxhZTlFYtGYP40rnmZiDkzvO1gEiFhH0/K9NhU/IxIAryvomFjXJ60FTvIZXtyrTx5PO02peG/I1OufDRtqkSM7oUJssisKtQeoJTJh9IdrpB8s9KHZL6IbQJKs2hHEnfCOr5dTFwQrVi+a5Q23atvLNtRvw==
Received: from DS7PR03CA0188.namprd03.prod.outlook.com (2603:10b6:5:3b6::13)
 by BN9PR12MB5163.namprd12.prod.outlook.com (2603:10b6:408:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:07:10 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b6:cafe::d2) by DS7PR03CA0188.outlook.office365.com
 (2603:10b6:5:3b6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:07:10 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 26 Oct
 2021 09:07:09 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 26 Oct 2021 09:07:06 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 mlx5-next 00/13] Add mlx5 live migration driver
Date:   Tue, 26 Oct 2021 12:05:52 +0300
Message-ID: <20211026090605.91646-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f00fa934-e3d7-4904-39f2-08d9985ffe43
X-MS-TrafficTypeDiagnostic: BN9PR12MB5163:
X-Microsoft-Antispam-PRVS: <BN9PR12MB516387560F46E5D50E090C02C3849@BN9PR12MB5163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yVgZHyitg3QEYFQ5906q/HLHnlRfHsL6MjTdKJS9Mv3wufj46zOGqkIu9M3gAZAvMWaxrlEyQ8y17qGU5q5p3g4m6Is3MXSCEnEgquyhggKEXgIRyl5rec5alU+gObY9uoDDdLb0BmeG3edVc2zKEnaOzInua6ufdezGGGAbEJnR/a/teVSKvI4thU+++MQ5tegc+XtcgvV6/WwHbellpWDKEK/KZVU8CzDMNaTBOoaXY/ukbqFGI2vY8fwCg4Ali9C0iWzRZKrjYVkN+XJWxR9jt6XYzPg0SGEiXjpp55UcjesHx92t+tARiw61j13IO0pVXejTynycfijdhjjmJBoBCIkrj3+7Z0pjzjZenWlANDLmsbXgN9gJSZrzdh+0693TlestvwedOcD4fnP1C199jzcbqo6bJafWUBY7ooIzCfRIeVab+pNhxf84ncrk7VjIBzmpJeXkJJeejDaNls3FYBRaRW8GFPwzQbMz2TgwvIWGk6tm+jfbjdUopltXJutYiktQx7In8W7eF/M0G8ihm6p2vJQB/Ua6XW1iPKt0Et7EbL03cEw1YTJH51SXtKvjV5Xsg+jWzWNAEKnwQ0jb6yMw1r/nW9JAM2GMywkwV3t+9AjSm68tWOn482fBAggAJsMmfNTThrqChutGXtkOB1yvT+Vs5UM9gpIiiap/foeHryumOIo0x5gPSS7O7tCD495Nwfeiy6sDhGV2iw==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(70586007)(7636003)(2906002)(47076005)(356005)(1076003)(36756003)(6636002)(82310400003)(110136005)(86362001)(54906003)(2616005)(426003)(8936002)(186003)(5660300002)(316002)(6666004)(4326008)(508600001)(107886003)(83380400001)(26005)(7696005)(336012)(8676002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:07:10.3720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f00fa934-e3d7-4904-39f2-08d9985ffe43
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5163
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds mlx5 live migration driver for VFs that are migrated
capable.

It uses vfio_pci_core to register to the VFIO subsystem and then
implements the mlx5 specific logic in the migration area.

The migration implementation follows the definition from uapi/vfio.h and
uses the mlx5 VF->PF command channel to achieve it.

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

Changes from V3:
vfio/mlx5:
- Align with mlx5 latest specification to create the MKEY with full read
  write permissions.
- Fix unlock ordering in mlx5vf_state_mutex_unlock() to prevent some
  race.

Changes from V2:
vfio:
- Put and use the new macro VFIO_DEVICE_STATE_SET_ERROR as Alex asked.
vfio/mlx5:
- Improve/fix state checking as was asked by Alex & Jason.
- Let things be done in a deterministic way upon 'reset_done' following
  the suggested algorithm by Jason.
- Align with mlx5 latest specification when calling the SAVE command.
- Fix some typos.
vdpa/mlx5:
- Drop the patch from the series based on the discussion in the mailing
  list.

Changes from V1:
PCI/IOV:
- Add actual interface in the subject as was asked by Bjorn and add
  his Acked-by.
- Move to check explicitly for !dev->is_virtfn as was asked by Alex.
vfio:
- Come with a separate patch for fixing the non-compiled
  VFIO_DEVICE_STATE_SET_ERROR macro.
- Expose vfio_pci_aer_err_detected() to be set by drivers on their own
  pci error handles.
- Add a macro for VFIO_DEVICE_STATE_ERROR in the uapi header file as was
  suggested by Alex.
vfio/mlx5:
- Improve to use xor as part of checking the 'state' change command as
  was suggested by Alex.
- Set state to VFIO_DEVICE_STATE_ERROR when an error occurred instead of
  VFIO_DEVICE_STATE_INVALID.
- Improve state checking as was suggested by Jason.
- Use its own PCI reset_done error handler as was suggested by Jason and
  fix the locking scheme around the state mutex to work properly.

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
  'reset_done' to let it sets its internal state accordingly.
- Add some helper stuff for 'invalid' state handling.
vfio/mlx5:
- Move to use the 'command mode' instead of the 'state machine'
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

Are you fine with taking this V4 series through mlx5-next and we'll send
a PR to you to include ?

Thanks,
Yishai

Jason Gunthorpe (2):
  PCI/IOV: Add pci_iov_vf_id() to get VF index
  PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata
    of a PF

Leon Romanovsky (1):
  net/mlx5: Reuse exported virtfn index function call

Yishai Hadas (10):
  net/mlx5: Disable SRIOV before PF removal
  net/mlx5: Expose APIs to get/put the mlx5 core device
  vfio: Fix VFIO_DEVICE_STATE_SET_ERROR macro
  vfio: Add a macro for VFIO_DEVICE_STATE_ERROR
  vfio/pci_core: Make the region->release() function optional
  net/mlx5: Introduce migration bits and structures
  vfio/mlx5: Expose migration commands over mlx5 device
  vfio/mlx5: Implement vfio_pci driver for mlx5 devices
  vfio/pci: Expose vfio_pci_aer_err_detected()
  vfio/mlx5: Use its own PCI reset_done error handler

 MAINTAINERS                                   |   6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  44 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  17 +-
 drivers/pci/iov.c                             |  43 +
 drivers/vfio/pci/Kconfig                      |   3 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/Kconfig                 |  10 +
 drivers/vfio/pci/mlx5/Makefile                |   4 +
 drivers/vfio/pci/mlx5/cmd.c                   | 356 +++++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  43 +
 drivers/vfio/pci/mlx5/main.c                  | 746 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c              |   8 +-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 147 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio_pci_core.h                 |   2 +
 include/uapi/linux/vfio.h                     |   8 +-
 18 files changed, 1435 insertions(+), 23 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

