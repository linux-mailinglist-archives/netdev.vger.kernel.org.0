Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B454C2E19
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235400AbiBXOVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiBXOVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:21:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91B529A555;
        Thu, 24 Feb 2022 06:20:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVBI4sRLzXJCPGrU389Dlk8pvcndNHuOoYdfK+1lTH8aDJ9sUHC/gMxgYswa9iQwq87BxGtQqeamFGb92UCLwr+bV8UylAAYnPWGJSGDkRaqx/kOwWR8pr61tftzSUV1fJi1qjvBWiMFvjYNHIpqdeS5GyWL1UCHlfL9yThuUOHNGH0uKwgLYybfFBULl3GN6SmCHNtM9oqaIjU9r1UH3oXGUHvku8vFwbnkgJLRrS/9S+vTbI3wDdyC6nAmxD2qCd4i8OlPeZ0NFwq+gAkhAAwdShCOyJOALX1lVWzFIuGoMe1BW4olCt0voXec0lcrSm+B5s+Sno480RQZeYd/Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n37PSRHlAq3ae3J5v2lM79ZYSrF1HJJ88jpadAE2lhw=;
 b=YiehT5V9heUOgNIJ4DfGdvdcAkZ1234F6Ut9sQoSBELL6k/LOoloSL5gw5XhCLYDSbjkc0ghbzM02QDd6kIbc34+PutncqbBghNY6qp1jhri7ek3BNW9dD5IT4Dp+NZ46QMZf2gDNfhtkAEsIRoCxnIZg9EfN6GzpVrncDDLzxrK+bZxsXOTt5SzuN5HuskGp2j8SI1cNdf1Ah8h5ySng3rzRQ5pMByseMpHallLLOiJ7IpU1rXljNHtKDyaLErPLGyveGf78kBYGzceUpgS3WQJI/e5SzjTORMEBQ33uRJ0K9Di9V6KnZzGNw5kp1P+qNDXIUqVrlAEGUzuP839DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n37PSRHlAq3ae3J5v2lM79ZYSrF1HJJ88jpadAE2lhw=;
 b=hpYBE/5ohMZG7JPW7yJ8Fn14lLrfyaBcdDkaqPOJ2POr0sz8SCExtNnR/CHASj27m3P/cPkobVJZidK8pv0uxbt4ovKEIrTyI0SxyxplGXMON5QIGhecYfsgGVppNiEOCM61B+o0wOa8K1k8/UksOqjXVTqdHpZhIUnP5OeIoR87WVLS4ugPmOUQkjcEGkBXHcIXGW4BtnxxqUSJiOZqgrvbiaUjp7z2Yu19Fqg8J2oC+K6fZAlkQzg9qot1MyurwRiI6aVNC8/ccZkavt9kCbdsg6iS2hupMSid0MZvpWq/vGffacznmDPXoTcMG/dfWRuDLBNgiGBptR6GYy41cQ==
Received: from BN9PR03CA0433.namprd03.prod.outlook.com (2603:10b6:408:113::18)
 by DM5PR12MB1195.namprd12.prod.outlook.com (2603:10b6:3:7a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 14:20:51 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::8) by BN9PR03CA0433.outlook.office365.com
 (2603:10b6:408:113::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Thu, 24 Feb 2022 14:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 14:20:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 14:20:50 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 06:20:49 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 06:20:45 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V9 mlx5-next 00/15] Add mlx5 live migration driver and v2 migration protocol
Date:   Thu, 24 Feb 2022 16:20:09 +0200
Message-ID: <20220224142024.147653-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bc07ee6-8526-4769-e6b3-08d9f7a0dc44
X-MS-TrafficTypeDiagnostic: DM5PR12MB1195:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1195F2E7BDB485EFCCE7662EC33D9@DM5PR12MB1195.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 94Mfh9OJGT/c0VG+Z1QtZD4mw6YvGMH0acVaagBnIZ7YSwXaSlZ8pkYtfTIEk1KKro6OFBqxoEsAnbWvvEZTX1wgnJsuccuNF3c/QaVOJth4QYmSYL4/YKcr/Eq8H9+HeBKlfV+0o/beUbgTyAfP5Bx9J+wLL2HQfXjlkwQDnMMX9YZlIEOuoSsjuw7+X1UhbrL7m/ad3o2UAaq9W31s1iqjIkX1Tu6JqSxyKOc1hy0512muMppEhUIqe7kTwkHGIwvdDd0Eo2AeqxKHlwzVTE21swl7Ui+DRDP5tjKg0XY+t2ve3/vGMvHeIjqGmZczPmE4NlWmdnf+2kK56UlxQJxlnhVs6Pm4E+HjlB9Xx5HAciURZ1kys/liVTnJn3oZeMFhzThEDzSTduPFMJtJe0MhkMOKnazpqTcDh6GXHON5PTj8o+5LIT4FNklcT8XBjFi1CjmefmUqUW6Af9ntlMOsyXLuWmbENwkRR1Fq5KBA65ciRGKfh+a+3ZTF5BcT6pMZDD32MooeqtqSJGnNOzV6dufTokLCPlkqxjEMJrXdfUjROvBtqU/qkwsZiSVs9vymGli84HUPzu9A1VAQIn3CmlfyrijXeE35CVrXcpSPXHXdwNRQ4AZbMMum+11leocx8liZCgCoDj4Ie9tSItzl0+UbI+2biDQFBrr4LOyWbrGFKtn1egd47Ee0z6OaPCHI1EXuxVWON+zQF+Mk0mmfAx4VgG3j0sUv0fuTkFlIOtvWj5T+oA924ZOUIfMZR2kZcEAI/d91f19H/dN4+SVIYk8M5VP0GVd+SsjXXxZyNA76X5gFyH4bkpSNnKPwOaj9375S4VCV7yaV0I6QmQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(5660300002)(356005)(36756003)(2906002)(8936002)(86362001)(40460700003)(47076005)(7696005)(316002)(2616005)(966005)(186003)(110136005)(26005)(336012)(426003)(83380400001)(54906003)(82310400004)(36860700001)(81166007)(6666004)(508600001)(6636002)(1076003)(4326008)(70586007)(70206006)(7416002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 14:20:51.0248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc07ee6-8526-4769-e6b3-08d9f7a0dc44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1195
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

Changes from V8: https://lore.kernel.org/kvm/20220220095716.153757-1-yishaih@nvidia.com/
vfio:
- Fix some documentation notes given by Alex and Cornelia for v2.
- Add Reviewed-by: Kevin Tian <kevin.tian@intel.com>
vfio/mlx5, net/mlx5:
- Use more inclusive terminology for slave/master as was asked by Alex.

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
 include/linux/vfio.h                          |  53 ++
 include/linux/vfio_pci_core.h                 |   4 +
 include/uapi/linux/vfio.h                     | 406 +++++------
 22 files changed, 1846 insertions(+), 291 deletions(-)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/cmd.c
 create mode 100644 drivers/vfio/pci/mlx5/cmd.h
 create mode 100644 drivers/vfio/pci/mlx5/main.c

-- 
2.18.1

