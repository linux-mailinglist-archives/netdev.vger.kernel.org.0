Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DB96AFE1D
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCHFNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCHFNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:13:42 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1255D46D
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjNUcccdfyWxTKKYLc5cqv1ftFGIWCvHmTRUiuvQI0YiQu+3bcfwhMc1H5REIztC2ukA9Vl+WAsK73AgANngC23/ek0/WjjrsHcXApQKNgcczwvGM079uxN6VHMOpb4z3NDz8S8FJrFMzvJLU1ONwS0Or5o4O7FD6E0NKJjuAXWwuJTjluo04U3Y7Fr6+wZMmnDrXG0Sfdvmb7TeGv25BAEYA9GCMqbAGIdyjVWMkeXn/FvLTUOHl5PafpiC82tXG8JdxQr13Wt5dLW9/6n/pUWUwetxPfsZdV/VmNozGe/LA0n2HQ0cJz5RRa6ke89f9pzsBQUP1O4QcVA5nugC5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tWJN07m9ImelN92RMc3O3eR43Wxv10ArpXVsbBX6LXM=;
 b=FZeQrSpj9B1YnpLn0xewHMRhX1EM+nFWnbrf+7F0fwgwLGqMWl77i71TxPp3QK3myLEgQYmsFAUPOrXrT4LAtBTsRdOrJxufIyTZ8kRn336F49++mwIGrC28USLyqO8Iou7BRuMTIaGMfin+LmAlfdCVxDOlyN86TngvfwaO/OK68WZPzjYH7etkJ8dXidJaTxk9sxqhSiAQITn2qQMs8gNsWVH9vBdIIcBKwErpZY0HqR/MrfESSVoVCiH8+cPYzmUj19Dg6ekw1kn4GYwdxDUu4+ButLzLHwYKzNgYhVia/gGX8hCFlacTqh5V2IqitkEKllRRCe856scyD0rWvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tWJN07m9ImelN92RMc3O3eR43Wxv10ArpXVsbBX6LXM=;
 b=r8/wA5Js+HI6yKAj4A4zy5ofc7qh8cocSdzUs74k+iA2lB8fioVSAeN2SzwwLFQcL4wLgEyVg2Gv5T8pdUND1lk8wzx2NxKMrot6jI5vk3b/EfQaw8BxhEvpT/l3CJFROMJEmofGoOjiFm8/r2UM8XYD+Ky/TPSJXPyeZZkLxVg=
Received: from BN1PR12CA0022.namprd12.prod.outlook.com (2603:10b6:408:e1::27)
 by CH3PR12MB7546.namprd12.prod.outlook.com (2603:10b6:610:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 05:13:35 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::e7) by BN1PR12CA0022.outlook.office365.com
 (2603:10b6:408:e1::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:13:33 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:30 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 00/13] pds_core driver
Date:   Tue, 7 Mar 2023 21:12:57 -0800
Message-ID: <20230308051310.12544-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT013:EE_|CH3PR12MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: ba4abd82-3bf8-4a54-2a53-08db1f93dd82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pUQ/3tjl30VqTsA+8NHqOlJ9mrQ6ad7gBqXrS6oNCEub1fekLosPcZpZLXVGwhtzfyECd+j83K5pGV2k4eLf8JzDvkp6vluZnBy8MtzuanyAJjSCggkWU1mTnVDCb9u6t4gFSGl8zjXS9maYX7iALJjpzWfbfQu8ufzaI1F3oX+OwJ5ed7tFxN60VnpU35UQaJX9R7pUjHsUasyorOKb4VacaQXLa21RuptR6rOwxwHXUiGsuSjmjMhW5IqWOCauRaTN8TDKB6aX91xup6i4Yay5zb9vRpQXogRsLABu9n5IPtamRPfTjjz7ozgcPnMCbfZWkxsBysNiMf9tQLasXucUUEHwLnymVxpyLI+GzwFRgUM3qG/ShmsChdahdABwSLVSwJZYyyUvFND/LurpZuLeCIqx6Lw7IeeIR37t54Fe55AZUzWlXqlzGaxqD9OlHplkeEEZdMu7CAnHWWqjqiURysjP/ox+REbItdPWuC6qzIUYhY/XtVO0hCOx+JOqnlUtC+2FFWQvVu3kWA460PdlvZr/Au8x4gKdGDGlg2juqDu2ka9BlMlpcqfAL76eNsCspYnl6aXFVOsSGVMWtvgULy+yQlCShYJg/nJ20fimq5FrRewDmvqlfRS3zlol+/WI3r5BGodONklBl+B1Y3jY4nRVK8Yklf+b4fuXbM79vuVqHH0CeDIyvvghCjRMK7I8rb5yT1g8eRevQfJ+9rmsKUryGBu/LHOQLXHSGEvK3HaEGuurMBQ2LPZV4slJs5/xFETQHI824iE8QY/Ivg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199018)(36840700001)(40470700004)(46966006)(316002)(6666004)(4326008)(8676002)(82310400005)(70206006)(70586007)(336012)(40460700003)(966005)(478600001)(54906003)(110136005)(83380400001)(426003)(40480700001)(36756003)(356005)(47076005)(2906002)(16526019)(44832011)(186003)(81166007)(82740400003)(2616005)(1076003)(26005)(5660300002)(86362001)(41300700001)(8936002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:33.9537
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4abd82-3bf8-4a54-2a53-08db1f93dd82
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7546
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Note:   After comments on our previous patchset versions about the
        suitability of mixing auxiliary and PCI drivers, this patchset
        has been re-designed to better follow the existing examples of
        one core PCI driver for both PF and VF use, a vDPA client that
        is auxiliary driver only, and a VFio client that is PCI only.
	See the changes notes below for more details.

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
  v4:
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

