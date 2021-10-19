Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4CF433408
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhJSLB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:01:29 -0400
Received: from mail-bn8nam12on2087.outbound.protection.outlook.com ([40.107.237.87]:51712
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230117AbhJSLB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:01:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNUdDikuGQofP0HziY3UCkTm4zdEkUT/KlWP4glsj10oX2y7C1tPT2jH3nPyyMoilWE462H3XOpz7rTCKBqFw/Uz/Aelc/xpWAbbvsvuJYwzBVP5bcYQ6M2fhU1SIVofQgT3fS8Z1ZVwZikNBilTJN+S6CGoaqsCR5XDUtMncbJTFef3AsrOqz648w6nDbuLktrLX5IuZl0RKm5ii8RUbfVhe2OSy4dHHSy2maRA8rF67C8acsZqnV7F6J4ULwdjRBws0hR4x3PszCP0pFEXoAzKOGvCy1FCa0FBWJIt/YhwUpgrg1ad7hBfDjWRN8zO/ITOyFs8Kt2B7ers1+gEZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIW7f98pEps+PFQ9rQDGHaydqnEgrWdOKhDGMV6nZgk=;
 b=kmjbgd/397/s5LmmZreOU66DFk+O7WY1Fl3CwnSKmNh7OS/TAipQfKaO0ZmGHjNBBB80xro0jrEwIPVUVNvBMbJ0yZI8kSiGa7T5Vi/Nm6Tb1I9e1VnpiGvpAiw4s5BSbXo3kee4o5eXB4cDzNqSFkl8hRpDEdlyf3wIlnKayJ4LggrIBThM0qj93yiy1WQKzOvWjuJlS+Ew/ehIWItK3drJW0qBNpw7tfGtC+X8E+1CXcHq4ijG3dcs3oQE56Eds685dtsb7JUgRpSkA7HpxhiVeL8iPLFkjxhpSWoztsUS7riL0V7IdMqRcS3Jq5lcI1MTXJxaohbBsJdQ/QqkIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIW7f98pEps+PFQ9rQDGHaydqnEgrWdOKhDGMV6nZgk=;
 b=GIucVAPm2lMRl9IB7XzZUlPLf+7UbI69bEEbO01NKcKOTcFLKl4NWPw5WhX0fmb7paW4uWNPb8r3sgvOBuzL9RR7vAm0x1lomdh2a0A9ZQs3oTXzL4l0YOocUyZzrW52knvZ0bk1ngycdfsX0OtarsXE0E6uXpwV2gy+ZNiZ3ZHMHKhYHl8hBJZ2F0ngLRSZGFa369jEEG4RKbJXZ5SnqweLX5lnQpIXpzIEB8VhXxyImdCOi+Nv3wVgvDmbxUsIXkCIUXY5stfVtvJ1vRuaj1oIXlNmjI3fOyXIAMJyFXRdYKBXUneW4v/pGXqjH8IoaoTFIedoIbNlA+Qhkz9G4g==
Received: from BN9PR03CA0374.namprd03.prod.outlook.com (2603:10b6:408:f7::19)
 by BY5PR12MB3665.namprd12.prod.outlook.com (2603:10b6:a03:1a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 10:59:13 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::bc) by BN9PR03CA0374.outlook.office365.com
 (2603:10b6:408:f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 10:59:12 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 10:59:10 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 10:59:07 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 mlx5-next 00/14] Add mlx5 live migration driver
Date:   Tue, 19 Oct 2021 13:58:24 +0300
Message-ID: <20211019105838.227569-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddabfa37-c2e9-4e0b-6079-08d992ef7c40
X-MS-TrafficTypeDiagnostic: BY5PR12MB3665:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3665E4F32BF02E79DB252BDEC3BD9@BY5PR12MB3665.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MFEp/EDC/xAybhEtXT+SkXYB0PJFt/ZQhpgdX3FMiK69p0I3u/DWdFVdZloXOiBGJIUFlJ4KRLwcq+CMIXD96hwl3EwnJb0/4L/NxvE16e8CL10KOs0oHFtZBLo7w7Z1hbSHTzMTlIUZ3C10OFzPale4pjM5ipe8+kwwwku1r/tPMFXml9XCpeuiwzEL0kElT61wG0UkIUNI5fopTc8KNRGKIq1vFKrrUJnsie7XwUqa67EVdljBG86kGcudjkgyJbcc2B9BxKtk7CmFyLsP4d+b3Uk9BFOsxoa037FNkMLpjPwYp7DH6qIpvlu3sIr10cGrIq1mRzW75saCxCAKmWcG8h8OYv8Vyyd3CH7DPTnda6ttO6FSO6M9/Q+sA1IVtiiZtgsE99IzzfWHBgJokWmXQhB9Ud8vS36bvaW2q5ri+wo3D7y0wHMt4odBER5dsm3njCNGjPrw0z5mclFLs2Ty9hhUeXtrIvsTsU2kUZEYq1uXhH4rJUMFn4JvNN55PPfcbwjeTAZquB+OyP0eV2F+qGco1ZVUMfcj3pvOFtKcdJK1bswd/GKAXk4keQpsOZFLQVWol5n2/QreJN5tx0E/AafvFz/TEOME9HpMKtdJ6+H9EUj5Z8evs341h9amGD6WXHVo1Xou7Ik6w5wU/5G1OhlTxtl5JrimweToYiiDf5sqtLv6JP5LbrB4Em/EJagKWSJ0HQU2azFKyiC90w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7636003)(26005)(186003)(7696005)(86362001)(508600001)(107886003)(426003)(36860700001)(70586007)(110136005)(316002)(4326008)(6636002)(70206006)(6666004)(83380400001)(356005)(2906002)(2616005)(1076003)(5660300002)(36906005)(36756003)(82310400003)(47076005)(8936002)(54906003)(336012)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:59:12.3761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddabfa37-c2e9-4e0b-6079-08d992ef7c40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3665
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

Are you fine with taking this V2 series through mlx5-next and we'll send
a PR to you to include ?

Thanks,
Yishai

Jason Gunthorpe (2):
  PCI/IOV: Add pci_iov_vf_id() to get VF index
  PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata
    of a PF

Leon Romanovsky (1):
  net/mlx5: Reuse exported virtfn index function call

Yishai Hadas (11):
  net/mlx5: Disable SRIOV before PF removal
  net/mlx5: Expose APIs to get/put the mlx5 core device
  vdpa/mlx5: Use mlx5_vf_get_core_dev() to get PF device
  vfio: Fix VFIO_DEVICE_STATE_SET_ERROR macro
  Vfio: Add a macro for VFIO_DEVICE_STATE_ERROR
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
 drivers/pci/iov.c                             |  43 ++
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |  27 +-
 drivers/vfio/pci/Kconfig                      |   3 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/Kconfig                 |  10 +
 drivers/vfio/pci/mlx5/Makefile                |   4 +
 drivers/vfio/pci/mlx5/cmd.c                   | 353 +++++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  43 ++
 drivers/vfio/pci/mlx5/main.c                  | 727 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c              |   8 +-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 145 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio_pci_core.h                 |   2 +
 include/uapi/linux/vfio.h                     |   4 +-
 19 files changed, 1431 insertions(+), 26 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

