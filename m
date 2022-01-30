Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18904A3783
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 17:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355486AbiA3QOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jan 2022 11:14:52 -0500
Received: from mail-bn8nam08on2079.outbound.protection.outlook.com ([40.107.100.79]:38785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243101AbiA3QOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jan 2022 11:14:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktHNURDJ6jb2VK+FMrViMroiLJFmS/G2lW+i/4/aKgM41bEEBZVuR75Wd7Go2jVQCL/65jgeOtrV9ti9bCUI4+ycA5t3/RNPAUzQs9p4cenxcxXmvmcy2BDG+6KlgKjrFqrCgFpHHOO1YOnambRGH1e3QE8/oyjDc2cNlbguuiKyjZ6RhGvBPQO4oYdsaGgEhsdiG1TksvFII+XdYlBjhzYV5DRo1WstIkjS4F37sx24lRsZ+NHTxVGYEOpuG291fXMG67TfSBLt86mhHHjtyDUuJ5UGeKsWogHkVs08/xBJDR9AabtUcqS6l1TwAXoJ+Av0tfCMZSi7x51hFaAX+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8KEZQpWavc4hDa1sUCJfFtmGhvn+2fKdJR9hefcOP4=;
 b=e/6gGb5POXrfaPqO51qCs7QfwQ4f7slkLGOfyQmMDQXNGrohvHED5gtJc0P5tO2YUdqNmto5ZiJeFhf+ItbV4Licncle0C9PK55P0qXDEDyNX4/a22+XLT8+0LfjqsIOk7HbinoKJ4T0NDe9I3vhfDEV6JZpSNrUX0xR3+epK3UyJoVzGh24yYAWbWBzy6OEVqu0o6/6/Ku5w9+VvhExJ6hjXMex//08hH0S5JXxocrmLkRIYixWmDw40/426J62FnML98x+LOqs+eCpcbqiYEkgxbPOqYK6o+Ci/5+Z8GUOpxt4Q4o9fcscnY67mSZSnsjjT7rOkDy3yiO3sx+Axw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8KEZQpWavc4hDa1sUCJfFtmGhvn+2fKdJR9hefcOP4=;
 b=Oe3l2T87ASw1QoT9B/cUz0QcNpC2fxQPlXpj9KE/NZSHx+wpyDTZ895bJnYOBpB+PRo2R7uvjz1Bm+RVGOGl8nYfXLAVuMmJzclIpy2V/MXex11XuosTfwrfsbQ0IfiFxsmBOSlJV93kkttZIecuwfwA4W7hcvddXCLx/FAsS+cHJK3jMeXLy8TM14hx2+g1duaLE6GTxU3Z5gWg64rowDUIQ4J2Kz9BzWhGWf52jAcwHzkE1R9F+LM/9wwEHkyFvtOvlC5ODbcnPfP2xzutqnXttidjHTJMj4C4fAFWzBSAFbmLoUWfuu3YCdLclnNDOEwVWGN3LrK2S1NSnGselA==
Received: from DM3PR12CA0107.namprd12.prod.outlook.com (2603:10b6:0:55::27) by
 SN1PR12MB2557.namprd12.prod.outlook.com (2603:10b6:802:22::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.17; Sun, 30 Jan 2022 16:14:47 +0000
Received: from DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::d4) by DM3PR12CA0107.outlook.office365.com
 (2603:10b6:0:55::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Sun, 30 Jan 2022 16:14:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT005.mail.protection.outlook.com (10.13.172.238) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Sun, 30 Jan 2022 16:14:46 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Sun, 30 Jan 2022 16:14:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Sun, 30 Jan 2022 08:14:44 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 30 Jan 2022 08:14:41 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 mlx5-next 00/15] Add mlx5 live migration driver and v2 migration protocol
Date:   Sun, 30 Jan 2022 18:08:11 +0200
Message-ID: <20220130160826.32449-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fedb9701-536b-4f73-e117-08d9e40ba238
X-MS-TrafficTypeDiagnostic: SN1PR12MB2557:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB2557CEC2CE4090B6C64E481CC3249@SN1PR12MB2557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYb6oQWbkei/3YJt03OlRlqtE2Z67q5w/Iodu71LoIiwU6pZcL70Q4dJPAtouh0AMOt1fBIwnZW/aFvwMcOOAYKnuJf6t02UwtsBAuNbPpYx1rfmDeNO2VPNgXP/vAhEOxM3iIoBoBU/xaFzUAZmVvfiPKZC6XBDlfKAo90VaZnOQI2ACpMb6+oCGHWBtmDcmm27/2ezreAQV22SWcNgPl+TP3KBSh59Itdf9xFyVwMr50fJV6B6+oIWXjdcdnyyVYA7N+lzRUPWKFPQehDogQTPrVqBhoVPp1yhiWEtatrolzJxn+xrI1SIpIlZ8uH8TJBkaowMY/njRkHjsyLdlNkjULwaH3Z+9+m6Uyk/uhfWgmZw2L3ur0KK/fyKIsxpHAT49ddoP0L2Q2lssU/enRE/TJGeVdbGm508K41KcfnN9QCmNiwr9tKAiNdxIHY4gubxC10DE1YfwdpnCGEJDZ4rgi0J50PFeInUnqzO/pslbmDMiDvc8TzRvqN3qUQB3e7NVsseTSW/B19DbWuPOZSuxmbenJMkCZV2VTkKEWoF6lur9Hs3t7iQ+NkEenB2ribTtiaABmc5dCOW5Yy1O08nYMfmE9sF5wFDJBrULeLYY9rxvsvGUpyJHvp5SRIuEgwswkwhB05OdJoTwXiqIg4v9lO2X2swwj6+YP3Stjj4sBV94x303xjJvk3zMWF8WAjiIHY9szCE9L4luvKHD9DEFFbTBD8cU9X5WJiTZC/UAbtal8YIE3tEEP5vn0q+gFVLjXEP67RxTGoKjAvvCJQhE/FlB47RUvgGbkPFUX04eJAYz5BNzQu1U3ooyh7oQA5ESEx4B9A+30A8wDIc0A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(70586007)(70206006)(8676002)(316002)(36860700001)(4326008)(5660300002)(47076005)(6636002)(36756003)(2906002)(8936002)(110136005)(54906003)(40460700003)(81166007)(1076003)(26005)(186003)(6666004)(966005)(7696005)(426003)(508600001)(86362001)(2616005)(107886003)(336012)(356005)(83380400001)(82310400004)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 16:14:46.5170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fedb9701-536b-4f73-e117-08d9e40ba238
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2557
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds mlx5 live migration driver for VFs that are migration
capable and includes the v2 migration protocol definition and mlx5
implementation.

The mlx5 driver uses the vfio_pci_core split to create a specific VFIO
PCI driver that matches the mlx5 virtual functions. The driver provides
the same experience as normal vfio-pci with the addition of migration
support.

In HW the migration is controlled by the PF function, using its
mlx5_core driver, and the VFIO PCI VF driver co-ordinates with the PF to
execute the migration actions.

The bulk of the v2 migration protocol is semantically the same v1,
however it has been recast into a FSM for the device_state and the
actual syscall interface uses normal ioctl(), read() and write() instead
of building a syscall interface using the region.

Several bits of infrastructure work are included here:
 - pci_iov_vf_id() to help drivers like mlx5 figure out the VF index from
   a BDF
 - pci_iov_get_pf_drvdata() to clarify the tricky locking protocol when a
   VF reaches into its PF's driver
 - mlx5_core uses the normal SRIOV lifecycle and disables SRIOV before
   driver remove, to be compatible with pci_iov_get_pf_drvdata()
 - Lifting VFIO_DEVICE_FEATURE into core VFIO code

This series comes after alot of discussion. Some major points:
- v1 ABI compatible migration defined using the same FSM approach:
   https://lore.kernel.org/all/0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com/
- Attempts to clarify how the v1 API works:
   Alex's:
     https://lore.kernel.org/kvm/163909282574.728533.7460416142511440919.stgit@omen/
   Jason's:
     https://lore.kernel.org/all/0-v3-184b374ad0a8+24c-vfio_mig_doc_jgg@nvidia.com/
- Etherpad exploring the scope and questions of general VFIO migration:
     https://lore.kernel.org/kvm/87mtm2loml.fsf@redhat.com/

NOTE: As this series touched mlx5_core parts we need to send this in a
pull request format to VFIO to avoid conflicts.

Matching qemu changes can be previewed here:
 https://github.com/jgunthorpe/qemu/commits/vfio_migration_v2

Changes from V5: https://lore.kernel.org/kvm/20211027095658.144468-1-yishaih@nvidia.com/
vfio:
- Migration protocol v2:
  + enum for device state, not bitmap
  + ioctl to manipulate device_state, not a region
  + Only STOP_COPY is mandatory, P2P and PRE_COPY are optional, discovered
    via VFIO_DEVICE_FEATURE
  + Migration data transfer is done via dedicated FD
- VFIO core code to implement the migration related ioctls and help
  drivers implement it correctly
- VFIO_DEVICE_FEATURE refactor
- Delete migration protocol, drop patches fixing it
- Drop "vfio/pci_core: Make the region->release() function optional"
vfio/mlx5:
- Switch to use migration v2 protocol, with core helpers
- Eliminate the region implementation

Changes from V4: https://lore.kernel.org/kvm/20211026090605.91646-1-yishaih@nvidia.com/
vfio:
- Add some Reviewed-by.
- Rename to vfio_pci_core_aer_err_detected() as Alex asked.
vfio/mlx5:
- Improve to enter the error state only if unquiesce also fails.
- Fix some typos.
- Use the multi-line comment style as in drivers/vfio.

Changes from V3: https://lore.kernel.org/kvm/20211024083019.232813-1-yishaih@nvidia.com/
vfio/mlx5:
- Align with mlx5 latest specification to create the MKEY with full read
  write permissions.
- Fix unlock ordering in mlx5vf_state_mutex_unlock() to prevent some
  race.

Changes from V2: https://lore.kernel.org/kvm/20211019105838.227569-1-yishaih@nvidia.com/
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

Changes from V1: https://lore.kernel.org/kvm/20211013094707.163054-1-yishaih@nvidia.com/
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

Changes from V0: https://lore.kernel.org/kvm/cover.1632305919.git.leonro@nvidia.com/
PCI/IOV:
- Add an API (i.e. pci_iov_get_pf_drvdata()) that allows SRVIO VF drivers
  to reach the drvdata of a PF.
mlx5_core:
- Add an extra patch to disable SRIOV before PF removal.
- Adapt to use the above PCI/IOV API as part of mlx5_vf_get_core_dev().
- Reuse the exported PCI/IOV virtfn index function call (i.e. pci_iov_vf_id().
vfio:
- Add support in the pci_core to let a driver be notified when
 'reset_done' to let it sets its internal state accordingly.
- Add some helper stuff for 'invalid' state handling.
mlx5_vfio_pci:
- Move to use the 'command mode' instead of the 'state machine'
 scheme as was discussed in the mailing list.
- Handle the RESET scenario when called by vfio_pci_core to sets
 its internal state accordingly.
- Set initial state as RUNNING.
- Put the driver files as sub-folder under drivers/vfio/pci named mlx5
  and update MAINTAINER file as was asked.
vdpa_mlx5:
Add a new patch to use mlx5_vf_get_core_dev() to get PF device.

Jason Gunthorpe (7):
  PCI/IOV: Add pci_iov_vf_id() to get VF index
  PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata
    of a PF
  vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
  vfio: Define device migration protocol v2
  vfio: Extend the device migration protocol with RUNNING_P2P
  vfio: Remove migration protocol v1
  vfio: Extend the device migration protocol with PRE_COPY

Leon Romanovsky (1):
  net/mlx5: Reuse exported virtfn index function call

Yishai Hadas (7):
  net/mlx5: Disable SRIOV before PF removal
  net/mlx5: Expose APIs to get/put the mlx5 core device
  net/mlx5: Introduce migration bits and structures
  vfio/mlx5: Expose migration commands over mlx5 device
  vfio/mlx5: Implement vfio_pci driver for mlx5 devices
  vfio/pci: Expose vfio_pci_core_aer_err_detected()
  vfio/mlx5: Use its own PCI reset_done error handler

 MAINTAINERS                                   |   6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  45 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  17 +-
 drivers/pci/iov.c                             |  43 ++
 drivers/vfio/pci/Kconfig                      |   3 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/Kconfig                 |  10 +
 drivers/vfio/pci/mlx5/Makefile                |   4 +
 drivers/vfio/pci/mlx5/cmd.c                   | 252 +++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  36 +
 drivers/vfio/pci/mlx5/main.c                  | 664 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/pci/vfio_pci_core.c              |  97 +--
 drivers/vfio/vfio.c                           | 346 ++++++++-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 147 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio.h                          |  43 ++
 include/linux/vfio_pci_core.h                 |   4 +
 include/uapi/linux/vfio.h                     | 516 ++++++++------
 21 files changed, 1946 insertions(+), 309 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

