Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51939645089
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiLGApK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLGApJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:09 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD942AE3E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWnmh7FpcUSGnCQaKkwQ/VVi77gsed9Xoa1ZRirXw/A7JU89N3gRKXWDtQ6MBi5r+HxyY5shY+Wt+kyXxeiaZ5rJ1Y12eSEKEQXwwtjSl2DX7BBQzLct14MwALEKHvRu1uB3LnKzMwljWbtEKXUqAVaFR0zeOUl9vDmp0ONs7/H4lUa7ArduacTTS4pkG8+m7z60YmpOsZ8qkoXcbkcd+HrHzeiIArwF04vpSkxZnOg4x08Wb99yIb2ACKuJSL5Nh/M4IIpqufh1AGAt2jMjgaXl289v6EWvWeN8eivPvNMD4vcT8BKjHlepMZXDVzKouvzrWPys+B556LEKbuPfiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nt8UFyxKffN26X6GcMvy7C5JM+Rrgnx7VpGa7YBlfBM=;
 b=nWt/cRl8ePvEqCEvkLNQrony1UbfrW6YNoDMPehuOR0ux4dNVvhvpTGq+xxaU9TZAMPdBh+9snxNTBPHDNYjCFKFreyrCvRvAbBaMkiqPyjXjyngt3P7eBd5Ffi6Wg0t93yFz/OvWq4Q6VIjwZmdrmRt/UfTtkA+JrK2M9LrADlFTqiz0NZrKDn69x147J9LzQ6hDmlpSx1f+t3+X67G880G5F5CReToy7vLBC6/f9AW6bG35FhmBLx4N2MFSTbxF+oJH8XVofWjzX9/+dvcE6GbMzbWBeRtwvqWm0plRZ7di3nUssUV23mSTgIWJzVCOgFsmt6DSE0NaLq5UGcCzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nt8UFyxKffN26X6GcMvy7C5JM+Rrgnx7VpGa7YBlfBM=;
 b=YV4eUmEgTcyZ2VHojmGtiKxPvUm70s13tNCGfvNblP1MOYrEuKWnK/LJdMUvG7uIcgWkrIfSrEOu73jEMwO7SwliIshqyxPboH9Oo5CTFALtPED3kqjTIRJUOW/o3kvcDRCLHg79+okxCerzwK/SGRSqo+xedLRN3qjGwgQBjzA=
Received: from BN8PR16CA0032.namprd16.prod.outlook.com (2603:10b6:408:4c::45)
 by BN9PR12MB5196.namprd12.prod.outlook.com (2603:10b6:408:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 00:45:05 +0000
Received: from BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::ad) by BN8PR16CA0032.outlook.office365.com
 (2603:10b6:408:4c::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT103.mail.protection.outlook.com (10.13.176.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:05 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:04 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 00/16] pds_core driver
Date:   Tue, 6 Dec 2022 16:44:27 -0800
Message-ID: <20221207004443.33779-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT103:EE_|BN9PR12MB5196:EE_
X-MS-Office365-Filtering-Correlation-Id: b1c9972a-c1e2-460e-8ee5-08dad7ec487e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X/DPL7XOOaFHMGLYs4WiLUxVzB1A4O0llaWlt/qFW+zfOgV7nnj4S80WYJl/VYbvz5OioRNZ9JKDMBK7qdn531imfnkAi1X12jUaSzqVm9XqQ3bLOLN+MVwX2/JLk7uuwEu7tEJ768p7KWlC7VDTpVo7htBdVQyZ5DX24Gr9p31nomN7xEuvl373/phJiX4t6U9wcS5F/JohT+Nb0l+7pkucYxhqL1zgiGovoocUtsG65vrkCJw6VYHod2llmwqHebSMv2Pdwo8rJ7LV4QmXcOPgSxY54n4578whDA0pLAGtfDmUwgXRwfkMdNkexWD+IIghJgIHeTZa/FG0GEoAjJVummSGR+QQTIH1zvlpWWvBd/AmH2ys8uZA7ofTXHKtmSP6iiYXvOFAEEIVWkxeNvnhXt5I+NH23vi1mZkGQQ1P50jdFibnNGr2+ruafjT4+6NwQYpcL3cKoLuLlt8bcBii8UyHwVBXmy9uvBsuHn497fG/Hh7L5G/9POBSQnwrzsFYqI5LYYIQNGE3DIXfIB8gC/fXpMWVDW7orw/pu4JKpRUMmaDisfjknPFmv9uDatvn4WBNM821rW6HHw3U8aolxV7WLAVcbVJ1XH5hNI2aAb9NsQD4so9OazXielZTUUii5B4wl3hXk9pf9b3IGpGgvZ4vzmPuwQMXNSVumxqJREJbRxN+XTverW4Od42bCD08kkbSxvNdavzI39JWCiRinRn1dvqcWP51nnI8WVI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199015)(36840700001)(46966006)(40470700004)(81166007)(40480700001)(36756003)(86362001)(336012)(40460700003)(478600001)(26005)(6666004)(4326008)(44832011)(5660300002)(41300700001)(8936002)(110136005)(70586007)(2906002)(8676002)(70206006)(316002)(54906003)(36860700001)(82310400005)(83380400001)(82740400003)(16526019)(2616005)(1076003)(186003)(356005)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:05.4385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1c9972a-c1e2-460e-8ee5-08dad7ec487e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5196
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
drivers.  These work along side the existing ionic Ethernet driver.

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
It sets up auxiliary_bus devices for each VF for communicating with
the drivers for the VF devices.  The VFs may be for VFio/NVMe or vDPA,
and other services in the future; these VF types are selected as part
of the DSC internal FW configurations, which is out of the scope of
this patchset.  The Core device sets up devlink parameters for enabling
available feature sets.

Once a feature set is enabled in the core device, auxiliary_bus devices
are created for each VF that supports the feature.  These auxiliary_bus
devices are named by their feature plus VF PCI bdf so that the auxiliary
device driver can find its related VF PCI driver instance.  The VF's
driver then connects to and uses this auxiliary_device to do control path
configuration of the feature through the PF device.

A cheap ASCII diagram of a vDPA instance looks something like this and can
then be used with the vdpa kernel module to provide devices for virtio_vdpa
kernel module for host interfaces, vhost_vdpa kernel module for interfaces
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
  RFC to v2:
 - added separate devlink param patches for DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION
   and DEVLINK_PARAM_GENERIC_ID_FW_BANK, and dropped the driver specific implementations
 - updated descriptions for the new devlink parameters
 - dropped netdev support
 - dropped vDPA patches, will followup later
 - separated fw update and fw bank select into their own patches

Shannon Nelson (16):
  devlink: add fw bank select parameter
  devlink: add enable_migration parameter
  pds_core: initial framework for pds_core driver
  pds_core: add devcmd device interfaces
  pds_core: health timer and workqueue
  pds_core: set up device and adminq
  pds_core: Add adminq processing and commands
  pds_core: add fw bank select
  pds_core: add FW update feature to devlink
  pds_core: set up the VIF definitions and defaults
  pds_core: initial VF configuration
  pds_core: add auxiliary_bus devices
  pds_core: devlink params for enabling VIF support
  pds_core: add the aux client API
  pds_core: publish events to the clients
  pds_core: Kconfig and pds_core.rst

 .../ethernet/pensando/pds_core.rst            | 159 +++++
 .../networking/devlink/devlink-params.rst     |   7 +
 MAINTAINERS                                   |   3 +-
 drivers/net/ethernet/pensando/Kconfig         |  12 +
 .../net/ethernet/pensando/pds_core/Makefile   |  14 +
 .../net/ethernet/pensando/pds_core/adminq.c   | 299 ++++++++
 .../net/ethernet/pensando/pds_core/auxbus.c   | 303 +++++++++
 drivers/net/ethernet/pensando/pds_core/core.c | 599 ++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/core.h | 317 +++++++++
 .../net/ethernet/pensando/pds_core/debugfs.c  | 262 +++++++
 drivers/net/ethernet/pensando/pds_core/dev.c  | 358 ++++++++++
 .../net/ethernet/pensando/pds_core/devlink.c  | 279 ++++++++
 drivers/net/ethernet/pensando/pds_core/fw.c   | 192 ++++++
 drivers/net/ethernet/pensando/pds_core/main.c | 411 +++++++++++
 include/linux/pds/pds_adminq.h                | 643 ++++++++++++++++++
 include/linux/pds/pds_auxbus.h                |  88 +++
 include/linux/pds/pds_common.h                |  99 +++
 include/linux/pds/pds_core_if.h               | 581 ++++++++++++++++
 include/linux/pds/pds_intr.h                  | 160 +++++
 include/net/devlink.h                         |   8 +
 net/core/devlink.c                            |  10 +
 21 files changed, 4803 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_core.rst
 create mode 100644 drivers/net/ethernet/pensando/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/pensando/pds_core/adminq.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/auxbus.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/core.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/core.h
 create mode 100644 drivers/net/ethernet/pensando/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/dev.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/devlink.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/fw.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/main.c
 create mode 100644 include/linux/pds/pds_adminq.h
 create mode 100644 include/linux/pds/pds_auxbus.h
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core_if.h
 create mode 100644 include/linux/pds/pds_intr.h

-- 
2.17.1

