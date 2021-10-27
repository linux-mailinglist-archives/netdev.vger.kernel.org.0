Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E15043C6F9
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbhJ0KAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 06:00:21 -0400
Received: from mail-dm6nam11on2080.outbound.protection.outlook.com ([40.107.223.80]:56897
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237126AbhJ0KAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 06:00:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqppDfk32GioBqXyXdDQ0x9Ajzmk1NGaNx8wf+/byAwZ+US1IPDqAxCTs0MZah3qzkbHs9v5D9B5Ca0xtjup/C+GGhWCVq8TLlsPh3D11PP1UI8OvEVaDprF09b79+H8rc24HmuZTFCIOofxg35jxh374+i091u33C7F7n9WWsQA2+w9U/4cWBvfUuYaz/NKbzmgqztUfC7uZ0qo9uxp3siOFy4JWT04v9weVzbVfPNkDq5D2yDf6O26X514ffaRkhFJkrCTFrfmY3C3PefQ5SwanMABI+RBLzs2a1hwmlJXGmwKG572M3IlrkryuKjiCAVFe6hVssZc2XB3y5AeTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+pj71FOrREwXZnQJ+ws2/x15UDHi6wj45n6oOYAQVn8=;
 b=ogtKIZCsHI4ksATroYBqiL5+i1mnBmKhea14Bbq+2B9I+A3tzulo81/yx4E6oL+dVuCQ30gAP0711E085hPXvtbI4N/rNTTjO1C7+T9Aw1WUpG8MxYtT8Ob64cN4UH5e02bHJYe+/15D/luj9gDKPMhnpwlrYRNho2tfuQbxbikUcMk6UxCM6UDZ529jXb4CLMbc3nyEGGtZA3Tlm+IfepW99wXkEMNA2vJ3ifAB1nGJidLvAe2PQB2M3tOmMg0ZmBvKh9nV5tat6lHrgBKHmRRsC+JXfiIZzF4feOkQ3dAbd2RfLeiNvhBti3XDmbHYaVF8rHtakuH8yHrBWyV/SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+pj71FOrREwXZnQJ+ws2/x15UDHi6wj45n6oOYAQVn8=;
 b=WzPDWJ/5/YJl5DIncBdBrgm6HCO6bN4lE3CbgiyPsTo5pOlLdzj69B5EL7MRkVsT3UgQ7WeDrmEyU8hOz6PWlUB9l+0tx2Ex2Um8Q3OqFnn8vKTBBEROjK41PtSsJbZv7fmJYXSClS+/j46C3wd6E9wQjmRnlPNsOioWEO8mn/OpqAw/PP9GpBZpet7qkG9ZIFnQaHMmSi/yiQNhE0AGGN/P2naGddma86ZPAbWPQJhrA917EMy0eOic1QYRbZDyeDxp1QZBnCv+2INQPKJnnSc8MLKWmlLf3hVNdfjBY4mpwn3wuKQsH2ftzc/8yKs3gmPMlGymQay3HtwSdLsUZA==
Received: from BN6PR16CA0007.namprd16.prod.outlook.com (2603:10b6:404:f5::17)
 by CH2PR12MB4214.namprd12.prod.outlook.com (2603:10b6:610:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 09:57:52 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f5:cafe::31) by BN6PR16CA0007.outlook.office365.com
 (2603:10b6:404:f5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend
 Transport; Wed, 27 Oct 2021 09:57:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 09:57:51 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 09:57:50 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 09:57:47 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 mlx5-next 00/13] Add mlx5 live migration driver
Date:   Wed, 27 Oct 2021 12:56:45 +0300
Message-ID: <20211027095658.144468-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3834bcc3-a900-4148-7325-08d999303da2
X-MS-TrafficTypeDiagnostic: CH2PR12MB4214:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4214A54A43C7DDF2B623FFCCC3859@CH2PR12MB4214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ckJOIohZqGg8CzVnLUi7L/UY/B9QBi862VBBFr3/pHo1uEKQy5cmhLtkpmGWJPPnqwlGj43ZtNTiEAdvowk0c21wd0MuoPE4qBc5Vq1dg0Osq7Kc7lkf/0/2hcXwaOeYmFUTlWEcvhin/s5Ztf0m/WdYWiKKPBocv7I1BGDGLnsqCacN6+uwsKU+RI1g29sH27HRWbd15dgpgLKveuW+ah0geq7m47+e4bgho+oaT0BhpXnNn5zlIsyKfacqzcfJwV5JgEM5HQFYOecDDtdc1T0qApStbXL6L7xhgWH54dumH6KnDndiQkYWGFY/qBXxuVWGjVV+SIKYcXiDPKGKw4sBqwhgrYd62oLr5BcXjAZ3nxuoLRWoeIb+OLRk2bIyIZGQayXiECuy1MZYeM7hzn5gYDQzpOG3Ow0bPK7RqNjNJA7nbj/VQaqinHXpJtDPB2OX4wF7fsZzNueHc/OYfFUjmhKs2ijwjkGFPWxbZWM6i1zSKQq1BPYwMW3qYcMXV2yArPJs0hJYV6M7WRihEuzWMPaRYOfGPr50VUvNderbS72KZGBDy/diiMTGbg6N7KWtU6oxZwkPHWqr1b9KBZOfdtrpEoGftzbIl2dymQ5rH5Vb6XVJlmND3J93ohkLVsi6YKHi7d6Q/6kc0DSKjq3uZ50eNklclE/gkthp+UdTlZyzaPM51ex9oTvloU5RaNXj/6wcHOd0wjz+PAJdw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(107886003)(316002)(70206006)(110136005)(54906003)(47076005)(7636003)(70586007)(26005)(426003)(2616005)(36756003)(86362001)(36860700001)(82310400003)(336012)(83380400001)(356005)(8936002)(4326008)(7696005)(5660300002)(2906002)(1076003)(508600001)(8676002)(6636002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 09:57:51.9373
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3834bcc3-a900-4148-7325-08d999303da2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214
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

Changes from V4:
vfio:
- Add some Reviewed-by.
- Rename to vfio_pci_core_aer_err_detected() as Alex asked.
vfio/mlx5:
- Improve to enter the error state only if unquiesce also fails.
- Fix some typos.
- Use the multi-line comment style as in drivers/vfio.

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

Are you fine with taking this V5 series through mlx5-next and we'll send
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
  vfio/pci: Expose vfio_pci_core_aer_err_detected()
  vfio/mlx5: Use its own PCI reset_done error handler

 MAINTAINERS                                   |   6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  44 +
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  17 +-
 drivers/pci/iov.c                             |  43 +
 drivers/vfio/pci/Kconfig                      |   3 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/Kconfig                 |  10 +
 drivers/vfio/pci/mlx5/Makefile                |   4 +
 drivers/vfio/pci/mlx5/cmd.c                   | 356 +++++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  43 +
 drivers/vfio/pci/mlx5/main.c                  | 750 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c              |  10 +-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 147 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio_pci_core.h                 |   2 +
 include/uapi/linux/vfio.h                     |   8 +-
 18 files changed, 1440 insertions(+), 24 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

