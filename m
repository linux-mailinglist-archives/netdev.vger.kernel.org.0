Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1374AC759
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376400AbiBGR1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345450AbiBGRXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:23:11 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977D7C0401D5;
        Mon,  7 Feb 2022 09:23:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyMUaLore3Z0Z1Tv+4oIU/qnibDuuuZPvmiBujxbRU5xM+J+ikS1i4ZpGv4kdB7bzgwd5G3w21NY0khpeeST842BxSHQjk6FePA7lYw7hN0X/aOM2VkheAjHXLciH4/JGVE0c9oUw4aT/1SlqY70UMgpSJUsxM9xO4v1B6yRII484IACZ7H7zh4sPyRScD7hZJoTmQre+AJb0ddn6XBtA3U57AO9ln4tdx3Iv9+QxzJmhc1oxq5XfipfitNrrfGIAlRQra5hZ+KULMjFvUwIgAj1V02+Q2HgPsEs/yMawpFK1iTGqdOI/goOUvIfea/343fTRvX0XbezKTORE5d2cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rTFQH55KQBKEkrhel5/N78szLB56yVWOuj+baSXV0E=;
 b=JnercWuu1WGUeOlOpKalVeDwHHM4YiLSDmFzV3Mv4lL+X9bjqrKWQQDof/1ZdoGLb9XG5uIzbwMx2B+nl3XsJ+9RyY4z/FXQ9GyYu/izfO9DCy2WkOrlYCQC9aGtGtIV/y6ONQqg4eKAa99BBsxSKczuFWUGIJBEuL5x71lTq3FfgpeUkAjr8d2tLhV/KPyHS9Y5GIaredCP9LhDvU+91yUoKYBd7VCGf6y7FyQq1uCB+akt7Thadih79/4FhmM0SP8XepNcj/xhA15jaWKBfiCd26f3D5PfiiQsynOYydnOsClYs9c0SVRqHMHiX4M0wzcmxD7G09lTAmqD/WRTyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rTFQH55KQBKEkrhel5/N78szLB56yVWOuj+baSXV0E=;
 b=XC3zizKDnLfQ0yPGygghlXTIByjCC1tecghii786yejG/9MI9AQUASpmMyxtxlNp85QKffinkaBNti7Jl1tCBW55GCBTeo3ThaUFgy07lJGXfjiPzN76/7tHYp5XLhq4IoTt81AqM18zwjLg3ZNeg7PPlowWPC4vv3UWu6kv8otS5ea16BjGomHJ42iRr5S5kTevvotisxXoPs5lmqtQOk0g3zEDkHZ74/R7t0poYljnqf73ed/EvhnjIr0fyn3mseN9//ucHbvhXJHHhuB+ttMCoxJpmfg34wyY2XnIq7nkrL4BJDLhRtSGVuh9BFH9ke7dMkctu9WyZeEQiWT+PA==
Received: from MWHPR13CA0005.namprd13.prod.outlook.com (2603:10b6:300:16::15)
 by BYAPR12MB3032.namprd12.prod.outlook.com (2603:10b6:a03:dd::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 17:23:08 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::1) by MWHPR13CA0005.outlook.office365.com
 (2603:10b6:300:16::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.5 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:07 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:04 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:00 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 00/15] Add mlx5 live migration driver and v2 migration protocol
Date:   Mon, 7 Feb 2022 19:22:01 +0200
Message-ID: <20220207172216.206415-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e53c711b-7180-4a2e-e263-08d9ea5e8217
X-MS-TrafficTypeDiagnostic: BYAPR12MB3032:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB30320A74CD8B8A5329866ED1C32C9@BYAPR12MB3032.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uvu6L2dq14xabeSxJULr5UpOzmJq1hKthMztSIbro84HT3BV7tdudFYV/JyXqbyxH12k8XhcJQWDNqfDqKLYWWTxP9oa18goNygqjz0dU5Wmvo7VZg6GEsW3iQuBIP1LhApi3k1iuuP44O0MLxNED3nzpUYizvGVEkbj7MIOvKi3pDxvgDg9HtgxraC+gV1BVJ//PcmqZD+JLa8+UDES0Qv2mB66B5Cocwghun/aEq4T0By7hWMcbVZtl2dKZKXqgCbFdBu9xGd7pvqWDTc5xdG3ouK/h0Vrz+PuBQjiLX0OwVaPTUbY/81c8EUwPMYFyoEmMNOz16N/dfLtZgZwD5vqlbzw/d4KUdZI9bqxq3gMWqHS3QVFvoblOPPXjQ982e0z1hKqKgVO4RBaw0LxbaNQ7hdyDrBL0XNGo23M/Vlm1EJxGSESZgAMptEK2DSe7NXv8KuqK12/9FPg4Mxivcl0tGQRUqouU3cVLRW1RqYomg6dXGOaLSw+Yo0PxbJW+6VUTtN+grM6rptcTh+hj5ceKte0+Cl3AW8e00JB05zxYEMCwQTvFcSmDd5Hkt3lFNdq28l22QAL3fAWKcmjxwKMCcibkeAruK2tUiQnz6ZtnbcpMc5pJxAn13kgXfj0F3T4cuKqQ0KImpGTpO3OZjfrsBFMGgiabeZD2JzDOdQplqzql8NDqpxGJgbeqUEd8U9JuwWA61OY+nPt4FjL/Y/1rSodP6a6mD7CWU8eAsRkNozK4PxImnldTRdxDRRZvU0XW85XQnHt3zIZiCVRpywZ1XoyxL7K2QQqXMHGda8jyWGFVTi70iAxql0eUzxY+c2AlNJyXZV2eP5wACNYWw==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(5660300002)(70206006)(70586007)(966005)(508600001)(4326008)(8936002)(8676002)(36756003)(7696005)(40460700003)(82310400004)(110136005)(54906003)(6636002)(316002)(2906002)(47076005)(83380400001)(86362001)(1076003)(2616005)(426003)(36860700001)(81166007)(186003)(26005)(356005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:07.9127
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e53c711b-7180-4a2e-e263-08d9ea5e8217
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3032
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Jason Gunthorpe (7):
  PCI/IOV: Add pci_iov_vf_id() to get VF index
  PCI/IOV: Add pci_iov_get_pf_drvdata() to allow VF reaching the drvdata
    of a PF
  vfio: Have the core code decode the VFIO_DEVICE_FEATURE ioctl
  vfio: Define device migration protocol v2
  vfio: Extend the device migration protocol with RUNNING_P2P
  vfio: Remove migration protocol v1 documentation
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
 drivers/vfio/pci/mlx5/cmd.c                   | 259 +++++++
 drivers/vfio/pci/mlx5/cmd.h                   |  36 +
 drivers/vfio/pci/mlx5/main.c                  | 676 ++++++++++++++++++
 drivers/vfio/pci/vfio_pci.c                   |   1 +
 drivers/vfio/pci/vfio_pci_core.c              | 101 ++-
 drivers/vfio/vfio.c                           | 358 +++++++++-
 include/linux/mlx5/driver.h                   |   3 +
 include/linux/mlx5/mlx5_ifc.h                 | 147 +++-
 include/linux/pci.h                           |  15 +-
 include/linux/vfio.h                          |  50 ++
 include/linux/vfio_pci_core.h                 |   4 +
 include/uapi/linux/vfio.h                     | 504 +++++++------
 21 files changed, 1994 insertions(+), 291 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

