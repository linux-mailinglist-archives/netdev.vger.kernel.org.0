Return-Path: <netdev+bounces-2829-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBED77043AB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEEBD1C20CFB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFD423C1;
	Tue, 16 May 2023 02:55:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93B7621
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:55:47 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20628.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::628])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348C5E58
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKMjP8ykhBy8daiXfUXRw2TDCa5dIkxXt7c61qcRcgtrYXyqYvgd3Mi0PPiHLW/UYLSdfNutnCtwQ/wz74KOMzaBmS8PorSpiet8ELGjNZyKXeFLb7Ihr2rg5KwmHITz29IVChf3gFZM9+DnE1LXjaf5kvmNdzqHjv3fNarEVn1FMgcGWssc9q7M1401mmDA2pq8MGv+9IWcsgIw4kVFC/wcAL9WQ9K9WGus5aMmnLP2Zr2vrOjrHDsbv3I8cIBYX3tASHAyxXh0rFEpG41mXIVFuQRFyAxWhGFqT8hb0x1lsXvA2n0ICM2yZ60G5Y4V7D01t0MQslKpc/sVpyNuKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQX839/a/62muy8bTajfcUDcOx44qAXJ7sWd03XQSdo=;
 b=Lj3p81h1G7HNvsmxSQvbZ8hmlpeIFGXxVGqgzyWmnrKA+TiFFnXeBY5ATZzumlRsflT8BVvtgz24wlvTHQA2kC1odKEmIcIBx6QlXVu8ZMP7/t6Cm5eJpjm71+yVTVCdqqL5pYW9Igb7Q8OT6DuQnbwMtm810KxmYs7TX8JMYyXm6gGKiJVIfzw0NS6FXgGtO8f/SUIypBBK7GJqJNsK/+eTWkEzj4CllmhDhvbkwLPCXyiilpo78qvMAJFoYFTzCap4469jxV4Ca5L6cAnKIKqou6j9HkNwjD5hj6KydTGt4iQo18oPHsBKJfeeHBFnq//tidqYiA/tj0b9bDQLIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQX839/a/62muy8bTajfcUDcOx44qAXJ7sWd03XQSdo=;
 b=jotZbSThva8LeV+qj57KNp1kQGuuzOs49v9A3QKw5EKZ4q+BF6rpJZaE79KJDaZ3gsyRPIqUzSelfFqxXHY02efqhNQwD6JII2d12esTJwKfuSzYZqY6tSbcoxPjMCHe8/qqHsdSg0l7xzKVEkWW4xhWmpo4+jTszDIBrR15+V8=
Received: from DM6PR21CA0030.namprd21.prod.outlook.com (2603:10b6:5:174::40)
 by DM6PR12MB4909.namprd12.prod.outlook.com (2603:10b6:5:1ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 02:55:43 +0000
Received: from DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::19) by DM6PR21CA0030.outlook.office365.com
 (2603:10b6:5:174::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.4 via Frontend
 Transport; Tue, 16 May 2023 02:55:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT103.mail.protection.outlook.com (10.13.172.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.15 via Frontend Transport; Tue, 16 May 2023 02:55:42 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 15 May
 2023 21:55:41 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v6 virtio 00/11] pds_vdpa driver
Date: Mon, 15 May 2023 19:55:10 -0700
Message-ID: <20230516025521.43352-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT103:EE_|DM6PR12MB4909:EE_
X-MS-Office365-Filtering-Correlation-Id: ec43ccaf-ece6-43b0-3884-08db55b90a16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DFGr/DjHZhcBopHmAK6H6oY/+6K2VoQ1hbD4xitXJ3ewmP2BzJ/uB0bAJTCW0NcSmUyYCn2uU4YwK7BKosZZWvs3Sarqmw24jMD5/7JGz+Z+nwswcrXPHZr0EXOaOSKDvEnXfOMzsMp0aUaMxG3cT0ByBZ8AkxnBAgCtShFWUesSWRnNk1rik8BbBol+yWG+U/vJDmQyO4fDZpe4MU+yKvQaQUY9yGl7GcNGIEwZEc4rV3gYhF9V/SM95LgY351PsaWR4fvVQCG/GIEKiQBDVJDTD2KYf0FpIVkKn+lgMiTmIeG6TqCiiBVuEjJtIQ+2wG0w1Z31XlrxJz43j9A1lUEwtXqYtvSe4WO/7+262rFg7Q4zX60uR2SM1aRDA+C7a70fcTko1dq/JF3HNkL72SlSEy0KtkROmLd9FccHmlGLPbKaAitVq6XHMYt72kcqZAJ6NwZx4rHZg50eUubRl3BineevvdVuNgAoPhGDPE46TLebmaPu40tqdcp1nXhoHJpSuhlIWxny2a90qKF3dGu23evNP+rIolup20E/ETop3Ku7UpuIiQGaIJZa+Lv2uzP40bAwbBZEqXOreB2afjK9Jm0YB6utNm4kmIjPXQZGQLEvuYTVijM7pIst8fisrzpbr72rbOY568esAzFRoDAWv5wEXaKrEq4AFCLQzwlRJQstm/aCG0AYPKnZX3/A4Zyz9x0sWicOWvUy1nSZE5HsB4mgVO0x3McOjDIGaX4FsX0GdDyYGNVjC+2m4v77ONipBuk0a04dfqJm2maFD/1XhFH5+Ir/+bpu2QNJBwg=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(46966006)(36840700001)(40470700004)(16526019)(186003)(86362001)(36860700001)(2906002)(26005)(1076003)(966005)(6666004)(2616005)(47076005)(83380400001)(82310400005)(426003)(336012)(8676002)(8936002)(478600001)(36756003)(40460700003)(54906003)(110136005)(81166007)(5660300002)(82740400003)(316002)(356005)(4326008)(41300700001)(44832011)(70206006)(70586007)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 02:55:42.8502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec43ccaf-ece6-43b0-3884-08db55b90a16
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4909
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
pds_core PF, then use the 'vdpa' utility to create devices for use by
virtio_vdpa or vhost_vdpa:
   echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
   devlink dev param set pci/$PF_BDF name enable_vnet value true cmode runtime
   PDS_VDPA_MGMT=`vdpa mgmtdev show | grep vDPA | head -1 | cut -d: -f1`
   vdpa dev add name vdpa1 mgmtdev $PDS_VDPA_MGMT mac 00:11:22:33:44:55

[0] Link: https://lore.kernel.org/netdev/20230419170427.1108-1-shannon.nelson@amd.com/
[1] Link: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Changes:
 v6:
 - removed misleading comments from pds_vdpa_notify_handler()
 - added Kconfig "select VIRTIO_PCI_LIB" and "depends on PCI_MSI"
 - changed pds_vdpa_set_status() to use an adminq cmd to bypass a FW sequencing issue
 - added map vq notify after features_ok for correct placement after feature negotiation
 - added support for dev_add() option VDPA_ATTR_DEV_FEATURES
 - reworked get/set_vq_state() to better support packed, split, and legacy use
 - dropped Jason's Acked-by on 09/11 because of these last four changes

 v5:
Link: https://lore.kernel.org/virtualization/20230503181240.14009-1-shannon.nelson@amd.com/
 - split dma_mask and device_id_check() into separate patches
 - simplify use of dma_mask into a single line change
 - changed test of VIRTIO_F_RING_PACKED to use BIT_ULL()

 v4:
Link: https://lore.kernel.org/virtualization/20230425212602.1157-1-shannon.nelson@amd.com/
 - rename device_id_check_override() to device_id_check()
 - make device_id_check() return the device_id found and checked
 - removed pds_vdpa.h, put its adminq changes into pds_adminq.h
 - added a patch to separate out the adminq changes
 - added a patch to move an adminq enum from pds_common.h to pds_adminq.h
 - moved adminq calls for get/set_vq_state into cmds.c
 - limit max_vqs by number of msix available
 - don't increment nintrs for CVQ, it should already be covered from max_vqs
 - pds_core API related rework following pds_core inclusion to net-next
 - use non-debugfs method to find PF pci address in pds_vdpa.rst instructions

 v3:
Link: https://lore.kernel.org/netdev/20230330192313.62018-1-shannon.nelson@amd.com/
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

Shannon Nelson (11):
  virtio: allow caller to override device id in vp_modern
  virtio: allow caller to override device DMA mask in vp_modern
  pds_vdpa: Add new vDPA driver for AMD/Pensando DSC
  pds_vdpa: move enum from common to adminq header
  pds_vdpa: new adminq entries
  pds_vdpa: get vdpa management info
  pds_vdpa: virtio bar setup for vdpa
  pds_vdpa: add vdpa config client commands
  pds_vdpa: add support for vdpa and vdpamgmt interfaces
  pds_vdpa: subscribe to the pds_core events
  pds_vdpa: pds_vdps.rst and Kconfig

 .../device_drivers/ethernet/amd/pds_vdpa.rst  |  85 ++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   4 +
 drivers/vdpa/Kconfig                          |  10 +
 drivers/vdpa/Makefile                         |   1 +
 drivers/vdpa/pds/Makefile                     |  10 +
 drivers/vdpa/pds/aux_drv.c                    | 140 ++++
 drivers/vdpa/pds/aux_drv.h                    |  26 +
 drivers/vdpa/pds/cmds.c                       | 185 +++++
 drivers/vdpa/pds/cmds.h                       |  18 +
 drivers/vdpa/pds/debugfs.c                    | 289 +++++++
 drivers/vdpa/pds/debugfs.h                    |  17 +
 drivers/vdpa/pds/vdpa_dev.c                   | 768 ++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h                   |  49 ++
 drivers/virtio/virtio_pci_modern_dev.c        |  33 +-
 include/linux/pds/pds_adminq.h                | 247 ++++++
 include/linux/pds/pds_common.h                |  21 +-
 include/linux/virtio_pci_modern.h             |   6 +
 18 files changed, 1878 insertions(+), 32 deletions(-)
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

-- 
2.17.1


