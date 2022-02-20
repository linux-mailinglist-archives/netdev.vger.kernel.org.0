Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CD14BCDC1
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbiBTJ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 04:58:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiBTJ6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:58:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EC053B49;
        Sun, 20 Feb 2022 01:58:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZf0u2RatpJu+BD8x5Jh1HDaZEw2nlFBpNHDphzRELoS5WgUKZzV+lGmpYOOQVxYZg3TCpSi0/+5TxvvRbeQ7dg30IDxW+hmLHEI/MdzZ5fvfrsRK/TlWALs1sRy22vuJyXNgLY9J7Wg0HNwNcaFblhMRC1ye+jmI5S6k+vNI6SkKe6kaOXe7bbVYev3aeaECuU+G+ZVwZBUeLieOp79WP54gbxzvFa6YFZCl/xk7SuXX+E1QQhfk5K5jvoLJfG0ZUfd1oIDpgfzPxtIHpI393cEbCfOb3DUeaCbg8A6Ij43iNoqMbytxeXzDHrUiijiHt9IbWJwQc0f2hG1yBTgMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iHZQOzn4hQK0LFupTN9X1pVkcQkUPG7hWWkKplsWEkw=;
 b=d940sc2aZcbdLmuenQ0PicpUsAx+26SXaaEiMb/ExJAi/3GycK3AMl6odRYatA+AznmoHxkt6ToWDiV5uk7B09TUBEMxg+fyXTuiDZFdMPVY/8Jl1cln53rIt/73KdHZ3plt3/r5PGnQBc3ZluKKrFL0/EY1kMxEgYmYxXjgFiz/5oXMOzzj6vECbAZlXKqB4Vnl7vA2HXRoR2nmqRyzLR7f+e/WzU9XMFVOxdm0hRBb5VVvBFWIbYB1MmIybMzdDocNkkCjXd0nbOSJnhDDglIoaKyme8FfvzhSBV36HTVUP+bUIRP1wjHlVcGtr7O9UKlq5z4GxAZRykE4naH7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iHZQOzn4hQK0LFupTN9X1pVkcQkUPG7hWWkKplsWEkw=;
 b=oWxOutvTCKYh5rbJF71MuEGeRjQXfPF+aN93yI90Lo7givXR6gSDBzfbvJwDAsA/dFOUT2Lqi8g0VP7FiKLnako8kaxzJbCwKGlatQ4SsTCgB2XgXfZU2Kcutak3eUZTSc1ANxczHN1p82AGG8CL/3lGRCbIEPTwyLl2z0W6R9vRnZQ8H6JhYzMk04IroiV0q41Qm53bt7qFtkn1CDUJsUdhLsm2seGD9xLwh//1/j4Ln02BRHp35NPjxjg7O75/USqSjeaBl7KYxTsPJD6WCdw366YD7bk154jyPCnkVZu3MZ4cRfVMr0YgWOpwd0HydTo7IPq3FqeBprmuvsi5jA==
Received: from DM6PR02CA0075.namprd02.prod.outlook.com (2603:10b6:5:1f4::16)
 by BN7PR12MB2772.namprd12.prod.outlook.com (2603:10b6:408:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 09:58:17 +0000
Received: from DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::e6) by DM6PR02CA0075.outlook.office365.com
 (2603:10b6:5:1f4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Sun, 20 Feb 2022 09:58:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT055.mail.protection.outlook.com (10.13.173.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:58:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:58:16 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:58:15 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:58:10 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 00/15] Add mlx5 live migration driver and v2 migration protocol
Date:   Sun, 20 Feb 2022 11:57:01 +0200
Message-ID: <20220220095716.153757-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 141ed59f-09b2-47a9-3836-08d9f457844c
X-MS-TrafficTypeDiagnostic: BN7PR12MB2772:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB2772477891937F32D7DD709EC3399@BN7PR12MB2772.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eiqC33gdGmNxid6g93dlfDOxAfhuwldiXKV8B1N/32tKyQenAsLkad0cYe2TSi1oczyLBL6lbJheP+QlQRhc//AS+WcTqqK/e9yfMMy2xgIr5vTsL9I2nXYjBxPnDoklFi8DVY0NiKOkPFr0SmFTjDLANPS07NAuDbNQwaVDXEIg4bJbrrbljos2/b/3k9UF0ycPmYu3eMHWN2lNHYY+S5IwZcObbUjc/M3vF1WBYYpLhOUVsugBjTCnEla1b04egQCFSpEmfmwr/RCLwCQig8SE2AAvGy4YQyIYGHM1FnCDBMLPHQkoaqQUnaqqA26odKIipdmHh17oFLQDwV7GEK0wzGhsWeyMNLLjm6alZ+RpnBIU7f6UJ7PQir5/MUDwd5tOmIKVmgVkjWEB1G9ZxeB1qCwYC3FhtsjR9b13coA/3pPt4VO27eenKugWNWahm2AwUWqM8JBdgtMjgIzGeZGimSN2mqM2j87Ys6+h+PeHOo4Zo+Fc6Ch6hpXvXiN6uRvTqavTLsjlml+XZosnxbkU68NAY5NeNIT0v0LAmhcwfhn88jko2BQxQYnuSG+cbL86UTQrgdvx8PuWXFtHoPbbaNCaWUpI3Y4oASG088R5jg7OyJDNNz1vPE+KkXx7eYIKLoemDEOX7dhQqPJcGopD56b2Wlrn6PxkkkGp9gpni42mkzphse86qcBXIoINehhYqc0AES6eXAKPvnvYcTszr8XGGuibELnm4UREPvubnHckYRUh/wAMGrEtYgjaUvhc9i2nIOl4v1ZPOZ2V9aJdOWhFiRL1HfchiHDu8kBPtsYHApwCneNqi/jCwx+6dPPyqm+10E9IOuFynrcc1Q==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(26005)(186003)(7696005)(8676002)(2616005)(70206006)(6636002)(70586007)(54906003)(110136005)(966005)(1076003)(6666004)(86362001)(82310400004)(316002)(508600001)(36860700001)(81166007)(356005)(40460700003)(83380400001)(426003)(336012)(4326008)(47076005)(5660300002)(7416002)(8936002)(36756003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:58:16.6993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 141ed59f-09b2-47a9-3836-08d9f457844c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2772
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Changes from V7: https://lore.kernel.org/kvm/20220207172216.206415-1-yishaih@nvidia.com/T/
vfio:
- Fix and improve some documentation notes.
- Improve vfio_ioctl_device_feature_migration() to check for the
  existence of both set and get device ops.
- Improve some commit logs.
- Drop the PRE_COPY patch as was asked by Alex since we have no proposed
  in-kernel users.
- Add Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>.
vfio/mlx5:
- Better packing struct mlx5vf_pci_core_device.
net/mlx5:
- Update mlx5 command list for error/debug cases.

Changes from V6: https://lore.kernel.org/netdev/20220130160826.32449-1-yishaih@nvidia.com/
vfio:
- Move to use the FEATURE ioctl for setting/getting the device state.
- Use state_flags_table as part of vfio_mig_get_next_state() and use
  WARN_ON as Alex suggested.
- Leave the V1 definitions in the uAPI header and drop only its
  documentation till V2 will be part of Linus's tree.
- Fix errno's usage in few places.
- Improve and adapt the uAPI documentation to match the latest code.
- Put the VFIO_DEVICE_FEATURE_PCI_VF_TOKEN functionality into a separate
  function.
- Fix some rebase note.
vfio/mlx5:
- Adapt to use the vfio core changes.
- Fix some bad flow upon load state.

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

Jason Gunthorpe (6):
  PCI/IOV: Add pci_iov_vf_id() to get VF index
  PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata
    of a PF
  vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
  vfio: Define device migration protocol v2
  vfio: Extend the device migration protocol with RUNNING_P2P
  vfio: Remove migration protocol v1 documentation

Leon Romanovsky (1):
  net/mlx5: Reuse exported virtfn index function call

Yishai Hadas (8):
  net/mlx5: Disable SRIOV before PF removal
  net/mlx5: Expose APIs to get/put the mlx5 core device
  net/mlx5: Introduce migration bits and structures
  net/mlx5: Add migration commands definitions
  vfio/mlx5: Expose migration commands over mlx5 device
  vfio/mlx5: Implement vfio_pci driver for mlx5 devices
  vfio/pci: Expose vfio_pci_core_aer_err_detected()
  vfio/mlx5: Use its own PCI reset_done error handler

 MAINTAINERS                                   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  10 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  45 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   1 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  17 +-
 drivers/pci/iov.c                             |  43 ++
 drivers/vfio/pci/Kconfig                      |   3 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/mlx5/Kconfig                 |  10 +
 drivers/vfio/pci/mlx5/Makefile                |   4 +
 drivers/vfio/pci/mlx5/cmd.c                   | 259 +++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  36 +
 drivers/vfio/pci/mlx5/main.c                  | 676 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/pci/vfio_pci_core.c              | 101 ++-
 drivers/vfio/vfio.c                           | 295 +++++++-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 147 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio.h                          |  51 ++
 include/linux/vfio_pci_core.h                 |   4 +
 include/uapi/linux/vfio.h                     | 405 +++++------
 22 files changed, 1843 insertions(+), 291 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

