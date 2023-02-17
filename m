Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD1969B5BC
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjBQW5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjBQW5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:57:15 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3962D5F812
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:56:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cPRq4oXhmaS6W/vPWOU5K3UyEUsmk3imMADDkXWbasuO7Qks5yD9UL2aO7JOsgery36W08tvB33y8Ut8z6qi8U1CrOqvq81toq2xmSsrYhJphn33y/kU37Cr9ud64HaAYBvsUraFnlFJGH1FPeVQWGEKSAEZIFFaSrEHRO/WrEeQVM9GZaY8i8mh3usTL2z+l8MPOrlEGjyUSd+yQc4n1Wy/pw0pkG7Q5dxr+ssU3WhE/rVxnX8hhu4TlT7Wba4C/lPlrUDJCqTA8rKkpBTWJnpv4eDVmju5pVj7rUOS8JAzCidXtb4bLbnt689ELNctJ2g2aFZBB5LMzehysIKVyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WSv2TPq8cjvffqUyeSiHAPIR/Q//WtOE2PpOgdNDuKY=;
 b=eALaExk5QabrB87yKVssbt79VSd07ek1kWgmwnLCkqXTkmLlgnKiKdmnvzTMxeOWH1tUza/3eY/xR0tDSXuHiOVWdpkVcqxJzCsyo35yuR71+dYdLxUATVD8j+Iu9Nu/rYYSyCOJlpaaSy2fyvjKVsmmE7NwgbvExC2aLpIwLbYlUU/TEHy054O2BnQpchmZnbWbaZhOXm8ODMzTivqiN/usk/oKtfUV1YHeBg7RBfZmXkWsIxOLOFaj6oyUzTaa8mTnY5A3EWOtMAN2Q4L7FYreqptfyqkzxZlXozx+PP0iNnwG2KKuW1VB3ljtNBvJnpe2JZBN+gH0FFwPsjd7JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WSv2TPq8cjvffqUyeSiHAPIR/Q//WtOE2PpOgdNDuKY=;
 b=SblZ7fsrSobHLCu9hvTmq6POakkN4Fxbb5Jj0qAWXfJeSi7ZRghOGytIVKpgqQnqHmzDM0kltStOiOv1PNVhX7dnY3sH4ciotqH+j2578S3k7R9hx42eYiqjMJVjj6hvjlCgLYtfKlrS4Tk4IxW+ba0CuLUG0E+1rybK1Za4uO0=
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by SJ2PR12MB8111.namprd12.prod.outlook.com (2603:10b6:a03:4fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 22:56:37 +0000
Received: from CO1PEPF00001A62.namprd05.prod.outlook.com
 (2603:10b6:303:6a:cafe::a4) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17 via Frontend
 Transport; Fri, 17 Feb 2023 22:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A62.mail.protection.outlook.com (10.167.241.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Fri, 17 Feb 2023 22:56:36 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 17 Feb
 2023 16:56:34 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <brett.creeley@amd.com>,
        Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v3 net-next 00/14] pds_core driver
Date:   Fri, 17 Feb 2023 14:55:44 -0800
Message-ID: <20230217225558.19837-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A62:EE_|SJ2PR12MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c768650-6a08-4fea-e4e0-08db113a3906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmj4mNKOGRAnoQLp2ZZh5taAcwsmUWz3f++MmfMEaXbrPWsC65tLsFQ9NyZ0dLKQ22UJSixuaK8U7AvXyhJdUv8H9uKAZsvEjT/Sc6HycuzJyqwuhR3d2v63V9MXFpwshabizUWC5+zyXrRdgKQ1rl8nDZ6szBx0IZTju1T1Kz2RQNyLD8Uk45h7xIQscdoUdbcsuo25EQ9VXlPnRSll2i25R9G6ylg7Amjcke2HVOXjW1kLUH16ldf1mg0mY8+NX1sIDLxqVlYSHmgm8ozgNlDGr85HAFIYgqNIDnbeAO3+Guhab2ah6KqOeAOdiAcJMe2FlTm0DgnB0T65xCn6DRfc3YrnXRrTZ+kkjKCyGnzMCSsd4ody1xlz9hmc80USUoTxsn/ELfoOo3YQRPmNBj9s1CFhXwZO1I9mN4pSnxZ3dDyW6F9k7ZZY+MftRnp4Rxb7skGfuCJjZHa48zUvJ/Un1cp05LsxhYLyd1u0+KgBTT/8iqcWsH508Lll0WKyW2AyHnXL1VEbdGF7S9zGaq8PKGpBn8wPLZNDaAlvq9tX5wHPtzLh1K/zoYSUIePuG8okwPW39hS6rSP0jF1BWZF60yAhKB086hc06hl3He1ndna3BLxxTG7uI09bSC2BkN7LZN9fnXw5PfKmVsTCSTS4LqWo5edLFKgv0kX9WRvjC3t8FQpQNY9q5WsGryn7+mBixhJCsLXty9KhAjwlGJrRstE5TOUuMviktOa5sQYPxFl5jFcpzUOVF4q/EZZKdDtf7VQS7m5YNtmXdLs6tQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(39860400002)(376002)(396003)(451199018)(46966006)(36840700001)(40470700004)(8936002)(41300700001)(5660300002)(44832011)(4326008)(70206006)(2906002)(70586007)(8676002)(110136005)(316002)(54906003)(40480700001)(186003)(1076003)(16526019)(6666004)(36756003)(26005)(40460700003)(83380400001)(2616005)(336012)(478600001)(356005)(966005)(47076005)(36860700001)(426003)(81166007)(82310400005)(82740400003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:56:36.4179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c768650-6a08-4fea-e4e0-08db113a3906
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A62.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8111
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Summary:
--------
This patchset implements new driver for use with the AMD/Pensando
Distributed Services Card (DSC), intended to provide core configuration
services through the auxiliary_bus for VFio and vDPA feature specific
drivers.

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

The Core device is a new PCI PF device managed by a new driver 'pds_core'.
It sets up auxiliary_bus devices for each VF for communicating with the
drivers for the VF devices.  The VFs may be for VFio or vDPA, and other
services in the future; these VF types are selected as part of the DSC
internal FW configurations, which is out of the scope of this patchset.
The Core device sets up devlink parameters for enabling available
feature sets.

Once a feature set is enabled in the core device, auxiliary_bus devices
are created for each VF that supports the feature.  These auxiliary_bus
devices are named by their feature plus VF PCI bdf so that the auxiliary
device driver can find its related VF PCI driver instance.  The VF's
driver then connects to and uses this auxiliary_device to do control path
configuration of the feature through the PF device.

A cheap ASCII diagram of a vDPA instance looks something like this and can
then be used with the vdpa kernel module to provide devices for virtio_vdpa
kernel module for host interfaces, or vhost_vdpa kernel module for interfaces
exported into your favorite VM.


                                  ,----------.
                                  |   vdpa   |
                                  '----------'
                                       |
                                     vdpa_dev
                                    ctl   data
                                     |     ||
           pds_core.vDPA.2305 <---+  |     ||
                   |              |  |     ||
       netdev      |              |  |     ||
          |        |              |  |     ||
         .------------.         .------------.
         |  pds_core  |         |  pds_vdpa  |
         '------------'         '------------'
               ||                     ||
             09:00.0                09:00.1
== PCI =========================================================
               ||                     ||
          .----------.           .----------.
    ,-----|    PF    |-----------|    VF    |-------,
    |     '----------'           -----------'       |
    |                     DSC                       |
    |                                               |
    -------------------------------------------------


Changes:
  v3:
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

Shannon Nelson (14):
  devlink: add enable_migration parameter
  pds_core: initial framework for pds_core driver
  pds_core: add devcmd device interfaces
  pds_core: health timer and workqueue
  pds_core: set up device and adminq
  pds_core: Add adminq processing and commands
  pds_core: add FW update feature to devlink
  pds_core: set up the VIF definitions and defaults
  pds_core: initial VF configuration
  pds_core: add auxiliary_bus devices
  pds_core: devlink params for enabling VIF support
  pds_core: add the aux client API
  pds_core: publish events to the clients
  pds_core: Kconfig and pds_core.rst

 .../device_drivers/ethernet/amd/pds_core.rst  | 150 ++++
 .../device_drivers/ethernet/index.rst         |   1 +
 .../networking/devlink/devlink-params.rst     |   3 +
 drivers/net/ethernet/amd/Kconfig              |  12 +
 drivers/net/ethernet/amd/Makefile             |   1 +
 drivers/net/ethernet/amd/pds_core/Makefile    |  14 +
 drivers/net/ethernet/amd/pds_core/adminq.c    | 299 ++++++++
 drivers/net/ethernet/amd/pds_core/auxbus.c    | 303 +++++++++
 drivers/net/ethernet/amd/pds_core/core.c      | 599 ++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h      | 318 +++++++++
 drivers/net/ethernet/amd/pds_core/debugfs.c   | 262 +++++++
 drivers/net/ethernet/amd/pds_core/dev.c       | 358 ++++++++++
 drivers/net/ethernet/amd/pds_core/devlink.c   | 199 ++++++
 drivers/net/ethernet/amd/pds_core/fw.c        | 192 ++++++
 drivers/net/ethernet/amd/pds_core/main.c      | 435 ++++++++++++
 include/linux/pds/pds_adminq.h                | 643 ++++++++++++++++++
 include/linux/pds/pds_auxbus.h                |  85 +++
 include/linux/pds/pds_common.h                |  93 +++
 include/linux/pds/pds_core_if.h               | 580 ++++++++++++++++
 include/linux/pds/pds_intr.h                  | 161 +++++
 include/net/devlink.h                         |   4 +
 net/devlink/leftover.c                        |   5 +
 22 files changed, 4717 insertions(+)
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

