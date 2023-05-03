Return-Path: <netdev+bounces-195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2934F6F5D99
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A2761C20B78
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D44A27725;
	Wed,  3 May 2023 18:13:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456F2103
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:13:02 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2076.outbound.protection.outlook.com [40.107.212.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C94BD
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:13:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYxUFb/J4vi9DVAldDjmeKf6+pIdl5E4FEcI9lo6G7WUDxHDNLL+ZBO7/rs/AJl09qDN6hmUHtV4llqOe1qF5+Fz2R5I6L1GxDTbWeMB4b0fh5+SGnX1UD6H+dizZV5mDHx4CPG/LrkZnL+ciuWjB/Xw6KdpuNrCs3CC4GRvalBijNmIScxnlUmfWZhAQSV+phpMOPhPKVblhm6gyPxxaUUuCQqz7biuVtD72MxWAyCDPF0OYqqLNkJQaXhqDWfpD6ZEnRlBgCrp+UKtkfieT7+dBMm6h5YLXCHdTzeQeFs9ICK6n8SM27+RAYcohiaBRjGPBOhK3DasNFekLeyUgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=suNY/GftPPz1DzbwYNWvMeaPVMo8XMf35wnbP9bws9c=;
 b=Cgie8wMnI2JjqK0hHFUyA7Spfgfdkrbzhd7j29/OleGH7mCDVoFw9xVayF/6Sf8zZxwiGYoLpNAof2S7yh1yZ7VRixc+ZBRMBTSYu9ahqPMrgL/6bR4WR5oOHuTj4zucpOG0LBiiZa2OD8xNUeYJjVKK6IG+BOZ645hsnOg7W18ek73KRQi8+3Hm5qUwV4R6S+rZQn+PQXiiGel2SEQAodRjoXH/JSp/KzYXLvHtkSUOwz85Dx8xs9xexIBSSGgE+tNzEHcjuL12pfkt2elPnVhTDnkStrZy1r/RGB+jWaYKFBrSrL70SFM32+/WUasiR2D2YdeTgqYcLE8ShrjcbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=suNY/GftPPz1DzbwYNWvMeaPVMo8XMf35wnbP9bws9c=;
 b=alhEM1BG3rfqL9sr5L4g1xI4UGY9B1pzeXhxC+v42KwXOxMwVCJNvkdbrwzgSIvxMnHVYLvsu14T9So7bqMbDkk6IF3G+HuaAnBfFyxI2oGeeNPjKgy9zgnNHPMpuHU/qpGYVa/KhKLcvE8fgBUcOc7k1qd3S+MfA+N9hpzJ9Do=
Received: from DM6PR08CA0042.namprd08.prod.outlook.com (2603:10b6:5:1e0::16)
 by SN7PR12MB6910.namprd12.prod.outlook.com (2603:10b6:806:262::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 18:12:57 +0000
Received: from DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::2f) by DM6PR08CA0042.outlook.office365.com
 (2603:10b6:5:1e0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22 via Frontend
 Transport; Wed, 3 May 2023 18:12:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT094.mail.protection.outlook.com (10.13.172.195) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.22 via Frontend Transport; Wed, 3 May 2023 18:12:57 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 3 May
 2023 13:12:56 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v5 virtio 00/11] pds_vdpa driver
Date: Wed, 3 May 2023 11:12:29 -0700
Message-ID: <20230503181240.14009-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT094:EE_|SN7PR12MB6910:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fcabe6d-0e26-4f66-8ca9-08db4c0205ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ito+9uxR4yilc5MT0np7nVkyW39IL3ASxdAIFYZrwiy5onCJl4+vf+3qNFhLkCR+t6n8nWAYDKIbL6vucDHlS4n5Bhe8TkuLqiHrcr9ZIPa3yy52BgFwgLwyScYjHf8BlXx4bBf7w48vxTXgpqXIg5CQJ6kB62e0q7L+PwIPHC3Ldwmfdz6oOLf8aDJ0pcQBpzI7F08Fad9VELpLr1fzZy4+UhdGvS8HN96eRAKnSrJa9Y1b6TViAoW+2LnALhax445riZ1RGUDmFtQBTOKuOFU8kNjb3Keern/0kQDcnzqH65TwMFDOcZjubQhdXWRVu1NUOzCUs1gjUHis8bWQ8eEh4Ia8KiR1rdd9xoXsZZwiw6iSV3OqNU1TYRllBpyBY7PT+/c5EH30uBPTqU2mZvn8kRNgn3NM+ewB3ykZdqbCNvQwjm+DhAVTMHZ0X3MiCCyos+dOLZ4c5eieg9QxUq8fiksAdLBJtSg/f/ppCSBEtYQaOk2Dx6at52TUvUkw0VkgzfimJO0MQfYYvxNQgHkzx2dNG6w5FoOfic3cYHdFYBAIU2uMs8VXXHIYqILPchCw6e0YmWhADwgvl2U5BhR30EtOiZqBMfcmfhFS53C0bB30G5Mp71bGfG7nysEZCOc2prtkYZiXRmLPmsjl8eXnhH0wHB8cxW1TZa5OkrYJZu1teUZIBiyY3ZD/2Bpz6kRjxscrNecg6hURzyfp8HuNeUpOqviDTwn8yuV0qFn40Lv8NGEuvqOSxMSoiZy/Bb5aXCMQh+wMBOzRlWwHAw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199021)(40470700004)(46966006)(36840700001)(478600001)(110136005)(8676002)(5660300002)(8936002)(2906002)(4326008)(316002)(70586007)(70206006)(54906003)(44832011)(41300700001)(6666004)(16526019)(966005)(82740400003)(26005)(83380400001)(1076003)(40460700003)(36860700001)(2616005)(426003)(36756003)(336012)(186003)(40480700001)(86362001)(82310400005)(356005)(81166007)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 18:12:57.5179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcabe6d-0e26-4f66-8ca9-08db4c0205ea
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6910
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
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

[0] Link: https://lore.kernel.org/netdev/20230322185626.38758-1-shannon.nelson@amd.com/
[1] Link: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Changes:
 v5:
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

 .../device_drivers/ethernet/amd/pds_vdpa.rst  |  85 +++
 .../device_drivers/ethernet/index.rst         |   1 +
 MAINTAINERS                                   |   4 +
 drivers/vdpa/Kconfig                          |   8 +
 drivers/vdpa/Makefile                         |   1 +
 drivers/vdpa/pds/Makefile                     |  10 +
 drivers/vdpa/pds/aux_drv.c                    | 140 ++++
 drivers/vdpa/pds/aux_drv.h                    |  26 +
 drivers/vdpa/pds/cmds.c                       | 207 +++++
 drivers/vdpa/pds/cmds.h                       |  20 +
 drivers/vdpa/pds/debugfs.c                    | 287 +++++++
 drivers/vdpa/pds/debugfs.h                    |  17 +
 drivers/vdpa/pds/vdpa_dev.c                   | 704 ++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h                   |  47 ++
 drivers/virtio/virtio_pci_modern_dev.c        |  33 +-
 include/linux/pds/pds_adminq.h                | 287 +++++++
 include/linux/pds/pds_common.h                |  21 +-
 include/linux/virtio_pci_modern.h             |   6 +
 18 files changed, 1872 insertions(+), 32 deletions(-)
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


