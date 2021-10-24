Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B35438779
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 10:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhJXIeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 04:34:00 -0400
Received: from mail-dm6nam10on2079.outbound.protection.outlook.com ([40.107.93.79]:29536
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229638AbhJXId7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 04:33:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDjneWzs5u8f9N6qYEclibHh29X4vNOMncV8L18xhgDN2X9MWHlBParLvn+EbjZkYgqQu764C5lYtUpntTWQJRwuUzykwv+ukB6XvJedAmc52QQIZhFNbB1JzFwTCat95fZVPpA/LZ/nDEoThI6XPnhxqGUqNRjPYhC4K0Nh98hSFDwj7L6VOmWnUek/RXRVMMv/7hp0XpE7zJf5OxKohbUxzdTwYL9n6se89DrfOuaZPpNIg3oBt8A6E5bCe+JMGXAyQgFl2ioZo+/O1CRM4dl5DFlDu2jRPOtvyE9ZKM1wHBAsIeVfZrz8OWSRwASwob8AyO3xLW7sf/psmdmlsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y769OZ8LD/y216NOT+Iab2kGIgBuUiZo/YG+13mjcDQ=;
 b=Jod9UFDDd5B6F4ZJvIeNUSUx+T5cnAV1mDd+OKq0aQofqN8Ig5d6lLfxfwNbTTH/ZLn8sn74ZQAvrugBR+hSVI3p6ZU1lXq4DGFtaQAXqbUQvCRqQgLdtoX96gmSoiNVx7PdNWJsQQaYThIQ3CYhdTckD7CwOagdWBPcOG0iqCsZripA8SdaIEi7OztYE0BcuM9GbbzeZPKXqLJQM1WLXHn9Nbn/P3k/BhcvJbiLPvTyu/04W8VbUKYrFi6B5UPaZSJhlY7ep2SibTO63nIEh2iLNpcs1HXon29h3tuapYzHPxc8XTl/ZQK5jCwUZQ03c3THqrtx6uE1p8uxy0meEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y769OZ8LD/y216NOT+Iab2kGIgBuUiZo/YG+13mjcDQ=;
 b=m2CpoqzV/MrVx12SDPSEMjFteMNGD5sjBgJmfLFngHAgC9bMuVfvlOlHTOlek7XprzIIXFDBElPwD9ACz2Be5jVO7deFqWD9sCm2xZ1+9YpUvYtOPp0tunjn1y35uR3Gel1E7p/+J8qTHtsJ1SIyKyNfJduRG3B2H0Zy40XikJU46bENnrGNHGT2JAcFhDEsY7Qthnuyt+IysIDySwo+kZr+9UIiifd2pGtjLpVcook7sdj6iH3t83XPcbpAHwGmZPEzpXw7btXYqFn5VweiYBytTbncMVXOurzqCrepyKtUKmeQWbeMgYBtL98UB0Ozvf4LtaSjceNe90EjS0eRYQ==
Received: from BN6PR1101CA0013.namprd11.prod.outlook.com
 (2603:10b6:405:4a::23) by MW3PR12MB4393.namprd12.prod.outlook.com
 (2603:10b6:303:2c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 08:31:35 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4a:cafe::53) by BN6PR1101CA0013.outlook.office365.com
 (2603:10b6:405:4a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend
 Transport; Sun, 24 Oct 2021 08:31:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4628.16 via Frontend Transport; Sun, 24 Oct 2021 08:31:34 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:33 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 24 Oct
 2021 08:31:33 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 24 Oct 2021 01:31:30 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V3 mlx5-next 00/13] Add mlx5 live migration driver
Date:   Sun, 24 Oct 2021 11:30:06 +0300
Message-ID: <20211024083019.232813-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9e4c036-f340-465a-96f7-08d996c8b070
X-MS-TrafficTypeDiagnostic: MW3PR12MB4393:
X-Microsoft-Antispam-PRVS: <MW3PR12MB4393B1E6CD5B1B47FBB8A673C3829@MW3PR12MB4393.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9R4Tg3BapM2WzA2l4JtxgndUuWSGwLfQlbiGnUhTmBIzYByU8Lqflk2Bi9ptRtbpsVvsayV2Tb4ZLg156nuteYZezvpYt7tLjfckWo/TCPy0Jb9zmzPXn4PbC7/bsYreErwaJU07b3tQCiXb6S1VHPfmBEjamXACaLGDa/qDQRWivI7bHcws1CGyI4Ux3fg8YkjoSzdMyCl1oADKaxP7o5c6DMvru6v+guq7kQqe9KhlZzOrGr/JqNL9mAItZn9oWIJfhjnC0rKHnlguyhib9hFKDA+g/qj6tgazrDXQx0zIm4DBaByQLbbEkjOZR/IyG9SykUxRQDIjE2vXUf+YMpm7GIZJ+nuZoQfVjYcRB1SzyooENE2c8SpgKmbIKeAURd60870bMDsTr+lqL4/Cj8NNsc3jip5jdpWhFWEDG2VUupV3ipLD6BTgg/FHLo8yyDh9Pmde/ECd4nZqpXpJwP7Mmedz+ccHSlJN8bH0w6p367rLXMesws+3egxqwA68NNlnKF32dUrnYFT+R+e3kbTurUbK7VwgQvnmOO9U/18jodlQ7ItWqjbtyfz4zVozpg0lgjjfQQLN0G9TkZuxGIVYjxMkpJHCIdPBc1cDLbryVPIQaGqyVXhvbCtOF37/VqleHEtYc8EMyLK+UessetoU94di0dI0J+KdLlDtlojK+/vtP3h08oWFnZNVklOuVzIAUM8mFcmKik6/4hw9rg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(5660300002)(83380400001)(8936002)(186003)(70206006)(70586007)(36906005)(8676002)(316002)(336012)(4326008)(508600001)(7636003)(2906002)(54906003)(110136005)(107886003)(426003)(6666004)(36756003)(86362001)(82310400003)(36860700001)(2616005)(1076003)(7696005)(26005)(6636002)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 08:31:34.5661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e4c036-f340-465a-96f7-08d996c8b070
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4393
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

Are you fine with taking this V3 series through mlx5-next and we'll send
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
 drivers/vfio/pci/mlx5/cmd.c                   | 354 +++++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  43 +
 drivers/vfio/pci/mlx5/main.c                  | 746 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c              |   8 +-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 147 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio_pci_core.h                 |   2 +
 include/uapi/linux/vfio.h                     |   8 +-
 18 files changed, 1433 insertions(+), 23 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

