Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE9F6C546E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjCVTAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjCVS64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:58:56 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4949169235
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:57:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4paij68zSZPyTiM3eI2DGCvcHlmFjrpqHEyho/7Tz/BQDlq+BBRfTCa5Upg6ZK5TTmHTLd63mVvLkquYTXdOMqFL7XewQF4o7itju0l5qqsYy+ZQfwQvMqMCse0hXM9vXfVBzKwDM1/1Du/ZnPRPlTuglaY4YlmjJ5FLqN42ijLixeHYjPaoFM8bS0Bc6gGXHWtCFnRdC27T9dePbLXsnRdDVcxOcy954VuUp5rSOalSRWN4yVtOGaWzdKMeMpQvsuFIyD6IDwkdGBLuNnTUzELXRFDgojNuuPlnBW2oJZbGTYgMYVQZAIOs0QRE+VPxNxX14MQPTtYmkIPUgKF6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JJW+HWwlcx2dzfPTuopZ6D4Ae7ktlzSXh2i5pKKbLpg=;
 b=Xy852pOsVVUED67E37Nz1PSYDnNW5VDGd9FuDC1Mwg8ecVZsICmK3BTEVoJlMMtDI/FAUDcfWfZXWIgLHRdoI4CnPJ7bvA3ImqyLHo7zzZ1Yc4Bbm/U9s15PWSCNvl8M0+F19ro3sjGGNoFOaJIBeEFwkMGs6Tfc6moL7Y9/36g/0Gc4K1Dgxaf+5z9sQ305dzG+croqT/BYXhlgi2HJKlhTW6F210ikzkVdVH/x+W4RJdr+8Pnr983mlFqv2oVv+xq2kueaVfayPzQU9rQN6pMhBi3+dQl2qhlSBWeiHOKiG5AmfJ6kuRZhkKcuo+XoDMh7O7s5OiB+n4dpNnzwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJW+HWwlcx2dzfPTuopZ6D4Ae7ktlzSXh2i5pKKbLpg=;
 b=i1jy+NjjJq/uPt7DmMNrVkMvTXBPqxJospWe35rBWkeBOdEt+uXqxP/m0E+up+VspG6xmdvEwRuT9wpqq09QrPMQQFAIPtL5FDcUEpi1Lq016ffxUcRvwAZQqTTY56XduAkB5L1A9/5VpiqPY6VWEtAPXxbEbUKH/CYHuruJmjY=
Received: from BN9PR03CA0394.namprd03.prod.outlook.com (2603:10b6:408:111::9)
 by DS0PR12MB7727.namprd12.prod.outlook.com (2603:10b6:8:135::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 18:56:45 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::b6) by BN9PR03CA0394.outlook.office365.com
 (2603:10b6:408:111::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 18:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 18:56:45 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 13:56:43 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v5 net-next 00/14] pds_core driver
Date:   Wed, 22 Mar 2023 11:56:12 -0700
Message-ID: <20230322185626.38758-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT027:EE_|DS0PR12MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dd8956d-9e67-40c1-df44-08db2b072ee3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8Jc0tw7ogVy7bY3n4KsO+ADbarC5ylpkZi2HTe3DEUqpxyRKXByOl6M6FxQeFy2UQ8LeLifeSzwo++K2dcraoH9KZOWPnptyLtUAgX2CgLUR2jlslpTAcPa5twvvjL0cV3htV/1AcGNwwLsxNPOCDh84qHMA5HMb3StVLN+mUggj1Ybhk2FHExw57V/6zj7QSYSY3Ua70vkuNxk/56tFLP9c4tWs+GL49SbN/lO1UPkkA6kiOydINNmBzEtXYa5dbfI5B3vcshig5EEDTu1aDhBV1N4WJAX4dpEoYv36IVhLniTpGCz61bglPlpRERTwvWpY2/RhQMLSBmjTcuRJ2pRj6K6E9PGCv1EuXpTodjTHxEscjY+gt+1/DKS1Fp385+Z9uSkcevG+PdN1ro1M+7JXuCDs/HClGmbruoidHGRcEvLDCisDxGiDweClSNLEyTyFqp3EWRK5/TWqeajyJHOexjS3BcK7F4AAK/q57HwV4oRVKP6JG8P9aU7AfhiHjdOlSVaeQL1ZunSGq3Tsr/0q/LryUEHpOFuXCSlwHyzh+Y8ODHz7OU2R8BKu8F0NFGeY6E9jGd2S2NOjsvl5x/ihKQZrEZd8e7E0KAheDpSgeM29HL5QleIipnYeuifowCaVH1D8pAAEBfmNcgDMVN1uI/z2jEY2A9jDBPA1jgwG3Jypu1uQ5es+YhRqgxQo2/sGV7Y4msX3SNDLgD50MpnUJl4cykiUqgCmcQFaPpdJkEBmPejKvm5CjlDrLxqrMwJt4xWZYo1C/6ZqUhQ+g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(46966006)(40470700004)(36840700001)(81166007)(54906003)(316002)(6666004)(70586007)(8676002)(110136005)(4326008)(478600001)(336012)(70206006)(426003)(2906002)(966005)(36860700001)(2616005)(41300700001)(1076003)(82740400003)(186003)(26005)(16526019)(356005)(47076005)(86362001)(40460700003)(83380400001)(40480700001)(5660300002)(36756003)(30864003)(8936002)(44832011)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 18:56:45.1696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd8956d-9e67-40c1-df44-08db2b072ee3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7727
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Summary:
--------
This patchset implements a new driver for use with the AMD/Pensando
Distributed Services Card (DSC), intended to provide core configuration
services through the auxiliary_bus and through a couple of EXPORTed
functions for use initially in VFio and vDPA feature specific drivers.

To keep this patchset to a manageable size, the pds_vdpa and pds_vfio
drivers have been split out into their own patchsets to be reviewed
separately.


Detail:
-------
AMD/Pensando is making available a new set of devices for supporting vDPA,
VFio, and potentially other features in the Distributed Services Card
(DSC).  These features are implemented through a PF that serves as a Core
device for controlling and configuring its VF devices.  These VF devices
have separate drivers that use the auxiliary_bus to work through the Core
device as the control path.

Currently, the DSC supports standard ethernet operations using the
ionic driver.  This is not replaced by the Core-based devices - these
new devices are in addition to the existing Ethernet device.  Typical DSC
configurations will include both PDS devices and Ionic Eth devices.
However, there is a potential future path for ethernet services to come
through this device as well.

The Core device is a new PCI PF/VF device managed by a new driver
'pds_core'.  The PF device has access to an admin queue for configuring
the services used by the VFs, and sets up auxiliary_bus devices for each
vDPA VF for communicating with the drivers for the vDPA devices.  The VFs
may be for VFio or vDPA, and other services in the future; these VF types
are selected as part of the DSC internal FW configurations, which is out
of the scope of this patchset.

When the vDPA support set is enabled in the core PF through its devlink
param, auxiliary_bus devices are created for each VF that supports the
feature.  The vDPA driver then connects to and uses this auxiliary_device
to do control path configuration through the PF device.  This can then be
used with the vdpa kernel module to provide devices for virtio_vdpa kernel
module for host interfaces, or vhost_vdpa kernel module for interfaces
exported into your favorite VM.

A cheap ASCII diagram of a vDPA instance looks something like this:

                                ,----------.
                                |   vdpa   |
                                '----------'
                                  |     ||
                                 ctl   data
                                  |     ||
                          .----------.  ||
                          | pds_vdpa |  ||
                          '----------'  ||
                               |        ||
                       pds_core.vDPA.1  ||
                               |        ||
                    .---------------.   ||
                    |   pds_core    |   ||
                    '---------------'   ||
                        ||         ||   ||
                      09:00.0      09:00.1  
        == PCI ============================================
                        ||            ||
                   .----------.   .----------.
            ,------|    PF    |---|    VF    |-------,
            |      '----------'   '----------'       |
            |                  DSC                   |
            |                                        |
            ------------------------------------------


Changes:
  v5:
 - added devlink health reporter for FW issues
 - removed asic_type, asic_rev, serial_num, fw_version from debugfs as
   they are available through other means
 - trimed OS info in pdsc_identify(), we don't need to send that much info to the FW
 - removed reg/unreg from auxbus client API, they are now in the core when VF
   is started
 - removed need for pdsc definition in client by simplifying the padev to only carry
   struct pci_dev pointers rather than full struct pdsc to the pf and vf
 - removed the unused pdsc argument in pdsc_notify()
 - moved include/linux/pds/pds_core.h to driver/../pds_core/core.h
 - restored a few pds_core_if.h interface values and structs that are shared
   with FW source
 - moved final config_lock unlock to before tear down of timer and workqueue
   to be sure there are no deadlocks while waiting for any stragglers
 - changed use of PAGE_SIZE to local PDS_PAGE_SIZE to keep with FW layout needs
   without regard to kernel PAGE_SIZE configuration
 - removed the redundant *adminqcq argument from pdsc_adminq_post()

  v4:
https://lore.kernel.org/netdev/20230308051310.12544-1-shannon.nelson@amd.com/
 - reworked to attach to both Core PF and vDPA VF PCI devices
 - now creates auxiliary_device as part of each VF PCI probe, removes them on PCI remove
 - auxiliary devices now use simple unique id rather than PCI address for identifier
 - replaced home-grown event publishing with kernel-based notifier service
 - dropped live_migration parameter, not needed when not creating aux device for it
 - replaced devm_* functions with traditional interfaces
 - added MAINTAINERS entry
 - removed lingering traces of set/get_vf attribute adminq commands
 - trimmed some include lists
 - cleaned a kernel test robot complaint about a stray unused variable
        Link: https://lore.kernel.org/oe-kbuild-all/202302181049.yeUQMeWY-lkp@intel.com/

  v3:
https://lore.kernel.org/netdev/20230217225558.19837-1-shannon.nelson@amd.com/
 - changed names from "pensando" to "amd" and updated copyright strings
 - dropped the DEVLINK_PARAM_GENERIC_ID_FW_BANK for future development
 - changed the auxiliary device creation to be triggered by the
   PCI bus event BOUND_DRIVER, and torn down at UNBIND_DRIVER in order
   to properly handle users using the sysfs bind/unbind functions
 - dropped some noisy log messages
 - rebased to current net-next

  RFC to v2:
https://lore.kernel.org/netdev/20221207004443.33779-1-shannon.nelson@amd.com/
 - added separate devlink param patches for DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION
   and DEVLINK_PARAM_GENERIC_ID_FW_BANK, and dropped the driver specific implementations
 - updated descriptions for the new devlink parameters
 - dropped netdev support
 - dropped vDPA patches, will followup later
 - separated fw update and fw bank select into their own patches

  RFC:
https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Shannon Nelson (13):
  pds_core: initial framework for pds_core PF driver
  pds_core: add devcmd device interfaces
  pds_core: health timer and workqueue
  pds_core: set up device and adminq
  pds_core: Add adminq processing and commands
  pds_core: add FW update feature to devlink
  pds_core: set up the VIF definitions and defaults
  pds_core: add initial VF device handling
  pds_core: add auxiliary_bus devices
  pds_core: devlink params for enabling VIF support
  pds_core: add the aux client API
  pds_core: publish events to the clients
  pds_core: Kconfig and pds_core.rst

 .../device_drivers/ethernet/amd/pds_core.rst  | 133 ++++
 .../device_drivers/ethernet/index.rst         |   1 +
 drivers/net/ethernet/amd/Kconfig              |  12 +
 drivers/net/ethernet/amd/Makefile             |   1 +
 drivers/net/ethernet/amd/pds_core/Makefile    |  14 +
 drivers/net/ethernet/amd/pds_core/adminq.c    | 283 ++++++++
 drivers/net/ethernet/amd/pds_core/auxbus.c    | 268 ++++++++
 drivers/net/ethernet/amd/pds_core/core.c      | 605 +++++++++++++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c   | 243 +++++++
 drivers/net/ethernet/amd/pds_core/dev.c       | 353 ++++++++++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 202 ++++++
 drivers/net/ethernet/amd/pds_core/fw.c        | 187 ++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 442 ++++++++++++
 include/linux/pds/pds_adminq.h                | 635 ++++++++++++++++++
 include/linux/pds/pds_auxbus.h                |  58 ++
 include/linux/pds/pds_common.h                |  93 +++
 include/linux/pds/pds_core.h                  | 320 +++++++++
 include/linux/pds/pds_core_if.h               | 406 +++++++++++
 include/linux/pds/pds_intr.h                  | 161 +++++
 19 files changed, 4417 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
 create mode 100644 drivers/net/ethernet/amd/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/amd/pds_core/adminq.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/fw.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/main.c
 create mode 100644 include/linux/pds/pds_adminq.h
 create mode 100644 include/linux/pds/pds_auxbus.h
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core.h
 create mode 100644 include/linux/pds/pds_core_if.h
 create mode 100644 include/linux/pds/pds_intr.h

-- 
2.17.1


*** BLURB HERE ***

Shannon Nelson (14):
  pds_core: initial framework for pds_core PF driver
  pds_core: add devcmd device interfaces
  pds_core: health timer and workqueue
  pds_core: add devlink health facilities
  pds_core: set up device and adminq
  pds_core: Add adminq processing and commands
  pds_core: add FW update feature to devlink
  pds_core: set up the VIF definitions and defaults
  pds_core: add initial VF device handling
  pds_core: add auxiliary_bus devices
  pds_core: devlink params for enabling VIF support
  pds_core: add the aux client API
  pds_core: publish events to the clients
  pds_core: Kconfig and pds_core.rst

 .../device_drivers/ethernet/amd/pds_core.rst  | 143 ++++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   9 +
 drivers/net/ethernet/amd/Kconfig              |  12 +
 drivers/net/ethernet/amd/Makefile             |   1 +
 drivers/net/ethernet/amd/pds_core/Makefile    |  14 +
 drivers/net/ethernet/amd/pds_core/adminq.c    | 284 ++++++++
 drivers/net/ethernet/amd/pds_core/auxbus.c    | 266 ++++++++
 drivers/net/ethernet/amd/pds_core/core.c      | 607 ++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h      | 321 +++++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c   | 237 +++++++
 drivers/net/ethernet/amd/pds_core/dev.c       | 350 ++++++++++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 262 +++++++
 drivers/net/ethernet/amd/pds_core/fw.c        | 187 +++++
 drivers/net/ethernet/amd/pds_core/main.c      | 446 ++++++++++++
 include/linux/pds/pds_adminq.h                | 645 ++++++++++++++++++
 include/linux/pds/pds_auxbus.h                |  44 ++
 include/linux/pds/pds_common.h                |  97 +++
 include/linux/pds/pds_core_if.h               | 540 +++++++++++++++
 include/linux/pds/pds_intr.h                  | 161 +++++
 20 files changed, 4627 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
 create mode 100644 drivers/net/ethernet/amd/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/amd/pds_core/adminq.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.h
 create mode 100644 drivers/net/ethernet/amd/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/fw.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/main.c
 create mode 100644 include/linux/pds/pds_adminq.h
 create mode 100644 include/linux/pds/pds_auxbus.h
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core_if.h
 create mode 100644 include/linux/pds/pds_intr.h

-- 
2.17.1

