Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9376E55DE
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 02:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDRAc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 20:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDRAc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 20:32:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6B6422C
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 17:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lrk/lff0j4YEmaTk0aj8je08aK0CZA+rSQLmv0tiehaXkHvPiALMq5xYjwcReewDbXUxrI/FbvkvWIM1/Y1Z0L1Nnvbh2uAqgZ30O3nbu3vj26QL3mOO1naEQrDX+OPNiExmUJt1ohqDvBIOvqgJyOTWz3dPlK0XCOcsAi/Xhn61lFdMBxK6dtfNg20K6QfreU4KXEWofyopE149qqRZXnvt9AaK1r117Kqd11L0DhPU1ogBcYG0XHr/K3Kf83XK9XNl6au6e3Itit4dx1AowP5ifzjDU4oq5SpU+c2qFqWq7vFxTDN7FnyZ/KOe59lpiIKbIiTTC0g2rXHlNFqPDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOlTbd2Eb8NXUTJOs/XXoSmVsC2FE/0LrCJqPyEDrzw=;
 b=eYnDjtp93yyiX2GbsyES7XGH2SFU0wrOA1iywOCpc+t0nEDUx/Q+8MDqFYtro5Kg+jOrEyYc9oUBb30X1MgEeK6j0xKwF5tk2wtr5gou3+xEkmQKL2OmTdo7qHhoEIv7GgSt3ztN+cZlU4J43wKF3UtBYW+/2NBWi471V5eOhWC0aFHcq2Dnz5/u5fbwabtrXRYRZxJEBTuIKJ4NoSxwFSwMDNfaW/wSAPAZf0DQIWp7igorruc1IL10GTAgYAFS2G8aeXiNLYu1RJ7hHOI4lGCwfWqI0UivdqNpejD/y3+JQ823S7Vj5vQ62NZ6Yz6YmlAFffjJ4P/hAWZNT8rzDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOlTbd2Eb8NXUTJOs/XXoSmVsC2FE/0LrCJqPyEDrzw=;
 b=nQ46CVwFuFNAqqxw25HyJo1Qr6CvZLWk+UlwK+3bHjLwqKxs/4INxzx1rZ7+0FsEjW63G+/CIL1JDQrKqIO9VcmtYVODMJRclOSyyr1mXWsXjfzRhFj+ImoCcRh56w5Uab9EwEtpMPitf1xk/IC3dYXvXKSI8Vo+hpesbUlMXOE=
Received: from BN9PR03CA0145.namprd03.prod.outlook.com (2603:10b6:408:fe::30)
 by BY5PR12MB4871.namprd12.prod.outlook.com (2603:10b6:a03:1d1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 00:32:53 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::23) by BN9PR03CA0145.outlook.office365.com
 (2603:10b6:408:fe::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Tue, 18 Apr 2023 00:32:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.20 via Frontend Transport; Tue, 18 Apr 2023 00:32:52 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 17 Apr
 2023 19:32:50 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v10 net-next 00/14] pds_core driver
Date:   Mon, 17 Apr 2023 17:32:14 -0700
Message-ID: <20230418003228.28234-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT054:EE_|BY5PR12MB4871:EE_
X-MS-Office365-Filtering-Correlation-Id: ea26abcd-00b2-453f-1dc9-08db3fa47219
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFShrKfFBqDrApBIW5VW5AhqDzCmAosDiiLFqMFp5n7Sl3YQLOGCDksPGX4TuQu6SENoMh0r1eSgg+++GBNULaKfknFwyivLbe5TEpe88ucx0A8NLDvr1XyWr1Qlebzj2UposahYqnNtODiTjxCOi7/IrLvi01nNIVoWXeSJDOmkov2byNVgeX1lJnE34i5MdkpN/E/FtTI2zPZDML1WP/NnvyPIX0lFGxeVjv5MHfowFeCvfJR5uoUPaO1dO9z54OfshJvf61mR+QVafNegepc1RDed6Xs1NRClhU8GCo56YAg+5aLMHgN/gU1B5WruIA0vtaLviv1b4ve/IcK/11R4wwOSxCqhJ48QKM/WEf9JXnX3x/ZX1Sp+30OqIpUB+4nPX+g4S2T6kbPGx6L5gem/veyouLG0nWOvi/uiwCc+e11jLZCY1ehwHXS+06ZhXEIPV4abPdDAdljONvUP20tIbadLrvK+XvEhWq9GvLycJTepV2i9EhziJtoeoLDV/7IDHnefm7x6Vu6V1S7gxcrm9itBB0FQjMqH2qIo5ifZR7800iTz8wLNVv4ojnvH3eb/yXSB7EdqQsXcAsSOK47paJ+hF65pL9WgbhRhFlIFO9UtV6zukzvcZ6Jej790uLKflkdelt7wc5Kkealh/h8vyDMSSqMRU+5eL9FvnoV3tYa9azNfDjqBEve1NlREKvo7fkf0D68Ku/TX5wBz2iZIJa0UMtkErO+o0lGrq0UvIJr7itBeIbDGBurq8SQhA8v7UBHn49knyQYUA9TfUA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(36756003)(8936002)(8676002)(40460700003)(44832011)(5660300002)(2906002)(30864003)(82310400005)(86362001)(40480700001)(478600001)(6666004)(54906003)(110136005)(16526019)(186003)(2616005)(966005)(36860700001)(1076003)(70586007)(70206006)(26005)(41300700001)(356005)(82740400003)(316002)(83380400001)(81166007)(4326008)(47076005)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 00:32:52.4023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea26abcd-00b2-453f-1dc9-08db3fa47219
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4871
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
  v10:
 - remove CONFIG_DEBUG_FS guard static inline stuff
 - remove unnecessary 0 and null initializations
 - verify in driver load that PDS_CORE_DRV_NAME matches KBUILD_MODNAME
 - remove debugfs irqs_show(), redundant with /proc
 - return -ENOMEM if intr_info = kcalloc() fails
 - move the status code enum into pds_core_if.h as part of API definition
 - fix up one place in pdsc_devcmd_wait() we're using the status codes where we could use the errno
 - remove redundant calls to flush_workqueue()
 - grab config_lock before testing state bits in pdsc_fw_reporter_diagnose()
 - change pdsc_color_match() to return bool
 - remove useless VIF setup loop and just setup vDPA services for now
 - remove pf pointer from struct padev and have clients use pci_physfn()
 - drop use of "vf" in auxdev.c function names, make more generic
 - remove last of client ops struct and simply export the functions
 - drop drivers@pensando.io from MAINTAINERS and add new include dir
 - include dynamic_debug.h in adminq.c to protect dynamic_hex_dump()
 - fixed fw_slot type from u8 to int for handling error returns
 - fixed comment spelling
 - changed void arg in pdsc_adminq_post() to struct pdsc *

  v9:
Link: https://lore.kernel.org/netdev/20230406234143.11318-1-shannon.nelson@amd.com/
 - change pdsc field name id to uid to clarify the unique id used for aux device
 - remove unnecessary pf->state and other checks in aux device creation
 - hardcode fw slotnames for devlink info, don't use strings from FW
 - handle errors from PDS_CORE_CMD_INIT devcmd call
 - tighten up health thread use of config_lock
 - remove pdsc_queue_health_check() layer over queuing health check
 - start pds_core.rst file in first patch, add to it incrementally
 - give more user interaction info in commit messages
 - removed a few more extraneous includes

  v8:
Link: https://lore.kernel.org/netdev/20230330234628.14627-1-shannon.nelson@amd.com/
 - fixed deadlock problem, use devl_health_reporter_destroy() when devlink is locked
 - don't clear client_id until after auxiliary_device_uninit()

  v7:
Link: https://lore.kernel.org/netdev/20230330192313.62018-1-shannon.nelson@amd.com/
 - use explicit devlink locking and devl_* APIs
 - move some of devlink setup logic into probe and remove
 - use debugfs_create_u{type}() for state and queue head and tail
 - add include for linux/vmalloc.h
     Reported-by: kernel test robot <lkp@intel.com>
     Link: https://lore.kernel.org/oe-kbuild-all/202303260420.Tgq0qobF-lkp@intel.com/

  v6:
Link: https://lore.kernel.org/netdev/20230324190243.27722-1-shannon.nelson@amd.com/
 - removed version.h include noticed by kernel test robot's version check
     Reported-by: kernel test robot <lkp@intel.com>
     Link: https://lore.kernel.org/oe-kbuild-all/202303230742.pX3ply0t-lkp@intel.com/
 - fixed up the more egregious checkpatch line length complaints
 - make sure pdsc_auxbus_dev_register() checks padev pointer errcode

  v5:
Link: https://lore.kernel.org/netdev/20230322185626.38758-1-shannon.nelson@amd.com/
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
Link: https://lore.kernel.org/netdev/20230308051310.12544-1-shannon.nelson@amd.com/
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
Link: https://lore.kernel.org/netdev/20230217225558.19837-1-shannon.nelson@amd.com/
 - changed names from "pensando" to "amd" and updated copyright strings
 - dropped the DEVLINK_PARAM_GENERIC_ID_FW_BANK for future development
 - changed the auxiliary device creation to be triggered by the
   PCI bus event BOUND_DRIVER, and torn down at UNBIND_DRIVER in order
   to properly handle users using the sysfs bind/unbind functions
 - dropped some noisy log messages
 - rebased to current net-next

  RFC to v2:
Link: https://lore.kernel.org/netdev/20221207004443.33779-1-shannon.nelson@amd.com/
 - added separate devlink param patches for DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION
   and DEVLINK_PARAM_GENERIC_ID_FW_BANK, and dropped the driver specific implementations
 - updated descriptions for the new devlink parameters
 - dropped netdev support
 - dropped vDPA patches, will followup later
 - separated fw update and fw bank select into their own patches

  RFC:
Link: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

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

 .../device_drivers/ethernet/amd/pds_core.rst  | 139 ++++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   9 +
 drivers/net/ethernet/amd/Kconfig              |  12 +
 drivers/net/ethernet/amd/Makefile             |   1 +
 drivers/net/ethernet/amd/pds_core/Makefile    |  14 +
 drivers/net/ethernet/amd/pds_core/adminq.c    | 290 ++++++++
 drivers/net/ethernet/amd/pds_core/auxbus.c    | 264 +++++++
 drivers/net/ethernet/amd/pds_core/core.c      | 597 ++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h      | 312 +++++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c   | 170 +++++
 drivers/net/ethernet/amd/pds_core/dev.c       | 351 ++++++++++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 183 +++++
 drivers/net/ethernet/amd/pds_core/fw.c        | 194 ++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 475 +++++++++++++
 include/linux/pds/pds_adminq.h                | 647 ++++++++++++++++++
 include/linux/pds/pds_auxbus.h                |  20 +
 include/linux/pds/pds_common.h                |  68 ++
 include/linux/pds/pds_core_if.h               | 571 ++++++++++++++++
 include/linux/pds/pds_intr.h                  | 163 +++++
 20 files changed, 4481 insertions(+)
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

