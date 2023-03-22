Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527716C548F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCVTLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjCVTK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:10:58 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6109D57D34
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQa0gLgHjabX06UKqfzgP0FlkvhsgOzSd5TkZBMTJwsieYy61CWARbuxLpBoR0Vm53nCmJ4YMNW/AnFNtPa6r5INhC/4+dOXLpAdrqpzz8LghdQjuOA4UJ+B7O2zMoct3oVbJHnJ4UVEyEZH6xa978omGRT7i+mKjKPi5l+UUyIy9xsyRZZmJ89WLDVN9q76Hn8La5lrm5Wa0MpzXIHlIdiboPsDTm8C7xOlHc1VMfYRyHFc+zXbAsdfWVUb/63KO60oi6AWcKDUppr/oU8/wlaNXzJFHXbiCnPiEgFtZdkTpLJoja1dJ1e+oL3wUV1ehKhNMMTOurVnnM9RdE7SBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9WGMa1kiPZA430UqHNUbSiEEuND0hzWYfGO7SAdCy8=;
 b=O8JwksZyboqHD5v6R7tb7g2zaUUu62iCUsTBPLXMkw4qQhgq0yBRLUX4Vz5Junt4f0lyNFw96Wljuhw+yAJowAFf8UmYqxtrTxwqGZ4wpqXJ9waQj41Vm6Bl5/wg7iR9KoxezjAEKXSac8b8tweKYsOEusS93AMq0MyBDbNKyUG/qeC4CXRtMjqeoUMFuWeYEW4u+NlRx1eUNI0a30Aetj3dUmAdv+9l/DkFaxciOay3hZKx9lCqJPUiRjpfKqKyRsCB05xhAI7PChYSitczRgmvn5BabKKGPAzxRXm1RHWQFuP/+zfSF3dSlg2Crf5vhMpFJnHrUoIl8TxYS4y0GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9WGMa1kiPZA430UqHNUbSiEEuND0hzWYfGO7SAdCy8=;
 b=HxGQN90Vba0g6eKjbb7cU7aogDf9VKwPL+Ufz7Cp9MO+upym6tcC9QhJKagaRw0JrIlAi7OewVOOCTaC1hBV+fRiEkB/LZssRzgPbCOJNUAJngl0WQ35qmlYAyCA3ms7cKCsVuH6PcUBXSAmW5E9g3U3KCsDzDxFEd9pvHhYsAM=
Received: from DS7PR03CA0293.namprd03.prod.outlook.com (2603:10b6:5:3ad::28)
 by MN2PR12MB4437.namprd12.prod.outlook.com (2603:10b6:208:26f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:10:54 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::7b) by DS7PR03CA0293.outlook.office365.com
 (2603:10b6:5:3ad::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:10:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:10:54 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:10:52 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 0/8] pds_vdpa driver
Date:   Wed, 22 Mar 2023 12:10:30 -0700
Message-ID: <20230322191038.44037-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|MN2PR12MB4437:EE_
X-MS-Office365-Filtering-Correlation-Id: d8a5128b-0f59-41ec-cfd7-08db2b0928d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bv377U1TuOOxHrAmvuoVg/sFnZKzbJp7W4zoAPi8e2jf6A6NjobMMha+TKa7/M31QbjlliG8uDpkDGZV58YODbIQ7P0lUxbnvArAUeZBcqOT0maEgC0aphzSbUgMQ/Vl5Vk5VwdUY2FqtKW7I/oI6xVx8Cvvfg3Qu2n/wX6IIucS8R+acEXw4NNMDZ6XcnXGsi+/iHVD4RoCZgNz6nGfoEfxZBJ6JAkq0zXQdsThCHeaVmeoGsYoqhFc+KhHEQkUT1Skd+m3C5JZtDKYCf4qTl7N9Wa+U5TGWAaYFQby04BuviihR11Uxg4NRyLuEU8gOmAeLo3Yki2lqypSUWBJG8wF+mMar3F11jtJ/LUTlwjnqcSy5IZV6+7/w7oqu7+fFtSgIXJrg6jl5pdPblRW5mtNgiDKKDAkUOmxCi9RZbPr17B7dDEqNCT6L96xJHgu/TUhsA0tlF7o2vXCTGKQNhYDAAAQIE4bvUXUGzNuZsCII2OiZIKHNdV+pwu8uKICF+1P7+JqGazpggnDrSYTMwfeo9g0TEy09Fdo7qFQR4HNl1bpw+Ba6FgDG492ayQ0l1HG1QYJB3l8eAY1SVMP8zjGJkwQlucUeR5eXA7jtO5yJl6KcT32/nlPjDV33Xm9GF0oYA2zagGbumLgdtPzE1TqAF5870u1BTeX8WWVVcA6gqcC0t9SWtgAyKqjJEhYis8u+XRudiaSpMLSom3QP2P94eDClWsUqv1Hd62iuZ7SJRu3M8HjngLMUiyKFI6iarpxmMufN8OORskq8JBHkA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199018)(40470700004)(36840700001)(46966006)(2616005)(41300700001)(16526019)(186003)(426003)(47076005)(4326008)(966005)(83380400001)(478600001)(6666004)(336012)(8676002)(316002)(110136005)(70586007)(70206006)(1076003)(26005)(36860700001)(8936002)(44832011)(5660300002)(82310400005)(81166007)(82740400003)(2906002)(40460700003)(36756003)(356005)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:10:54.1804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a5128b-0f59-41ec-cfd7-08db2b0928d8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4437
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements a new module for the AMD/Pensando DSC that
supports vDPA services on PDS Core VF devices.  This code is based on
and depends on include files from the pds_core driver described here[0].
The pds_core driver creates the auxiliary_bus devices that this module
connects to, and this creates vdpa devices for use by the vdpa module.

The first version of this driver was a part of the original pds_core RFC
[1] but has since been reworked to pull out the PCI driver and to make
better use of the virtio and virtio_net configuration spaces made available
by the DSC's PCI configuration.  As the device development has progressed,
the ability to rely on the virtio config spaces has grown.

This patchset includes a modification to the existing vp_modern_probe()
which implements overrides for the PCI device id check and the DMA mask.
These are intended to be used with vendor vDPA devices that implement
enough of the virtio config space to be used directly, but don't use the
virtio device id.

To use this module, enable the VFs and turn on the vDPA services in the
pre_core PF, then use the 'vdpa' utility to create devices for use by
virtio_vdpa or vhost_vdpa:
   echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
   devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
   PDS_VDPA_MGMT=`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1`
   vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55

[0] Link: https://lore.kernel.org/netdev/20230322185626.38758-1-shannon.nelson@amd.com/
[1] Link: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Changes:
 v3:
 - added a patch to modify vp_modern_probe() such that specific device id and
   DMA mask overrides can be used
 - add pds_vdpa.rst into index file
 - dev_dbg instead of dev_err on most of the adminq commands
 - rework use of pds_vdpa_cmd_reset() and pds_vdpa_init_hw() for better
   firmware setup in start-stop-start scenarios
 - removed unused pds_vdpa_cmd_set_features(), we can rely on vp_modern_set_features()
 - remove unused hw_qtype and hw_qindex from pds_vdpa_vq_info
 - reworked debugfs print_feature_bits to also print unknown bits
 - changed use of PAGE_SIZE to local PDS_PAGE_SIZE to keep with FW layout needs
   without regard to kernel PAGE_SIZE configuration

 v2:
https://lore.kernel.org/netdev/20230309013046.23523-1-shannon.nelson@amd.com/
 - removed PCI driver code
 - replaced home-grown event listener with notifier
 - replaced many adminq uses with direct virtio_net config access
 - reworked irqs to follow virtio layout
 - removed local_mac_bit logic
 - replaced uses of devm_ interfaces as suggested in pds_core reviews
 - updated copyright strings to reflect the new owner

Shannon Nelson (8):
  virtio: allow caller to override device id and DMA mask
  pds_vdpa: Add new vDPA driver for AMD/Pensando DSC
  pds_vdpa: get vdpa management info
  pds_vdpa: virtio bar setup for vdpa
  pds_vdpa: add vdpa config client commands
  pds_vdpa: add support for vdpa and vdpamgmt interfaces
  pds_vdpa: subscribe to the pds_core events
  pds_vdpa: pds_vdps.rst and Kconfig

 .../device_drivers/ethernet/amd/pds_vdpa.rst  |  84 ++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   4 +
 drivers/vdpa/Kconfig                          |   8 +
 drivers/vdpa/Makefile                         |   1 +
 drivers/vdpa/pds/Makefile                     |  10 +
 drivers/vdpa/pds/aux_drv.c                    | 141 ++++
 drivers/vdpa/pds/aux_drv.h                    |  26 +
 drivers/vdpa/pds/cmds.c                       | 178 +++++
 drivers/vdpa/pds/cmds.h                       |  16 +
 drivers/vdpa/pds/debugfs.c                    | 291 +++++++
 drivers/vdpa/pds/debugfs.h                    |  28 +
 drivers/vdpa/pds/vdpa_dev.c                   | 738 ++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h                   |  47 ++
 drivers/virtio/virtio_pci_modern_dev.c        |  36 +-
 include/linux/pds/pds_vdpa.h                  | 275 +++++++
 include/linux/virtio_pci_modern.h             |   6 +
 17 files changed, 1878 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_vdpa.rst
 create mode 100644 drivers/vdpa/pds/Makefile
 create mode 100644 drivers/vdpa/pds/aux_drv.c
 create mode 100644 drivers/vdpa/pds/aux_drv.h
 create mode 100644 drivers/vdpa/pds/cmds.c
 create mode 100644 drivers/vdpa/pds/cmds.h
 create mode 100644 drivers/vdpa/pds/debugfs.c
 create mode 100644 drivers/vdpa/pds/debugfs.h
 create mode 100644 drivers/vdpa/pds/vdpa_dev.c
 create mode 100644 drivers/vdpa/pds/vdpa_dev.h
 create mode 100644 include/linux/pds/pds_vdpa.h

-- 
2.17.1

