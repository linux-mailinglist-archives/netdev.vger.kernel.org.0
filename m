Return-Path: <netdev+bounces-4016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6062870A22C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E05BF281BDA
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 21:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1357917FF9;
	Fri, 19 May 2023 21:56:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055D512B9E
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 21:56:53 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127E1B1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:56:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCqCZl1FF3+yw9/MJ5/gL19gdiY1jTGz5oOGak92KxwK2Wjh4p3AFE4uPbrLKIlVFPKclb0tfTGiKOhTvLrtUhWMLcvJ67Qf0PawbWFYJ68cJPLpLrDNv9zBaW7pgcts6ImLd83SMMAWrUpxe1w0FRWJBTw9npk4SXpvCjSx0Fo6CIq08BWO/0BJOvak5lp+Md77epYK+Jl0wA2QHZ0QtYGmpcX4uBXLAMzqqTyCwlXhCRSYsE6tQwAr3cRy5xpBGVzGH4Xb40oir7EaFT4GazZdRbbCwWfu+F+rqo4DHILVHLdTCKikwRJyX2DmIVBdcbCSO94fURLGaj0CFAf7lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDw6/P/+jWejB4X1+wm5jYm2LvWluCgBk0KPxA8BgEU=;
 b=lweA26paYJ48flLcnwpJeGZg1jcMAdy0dBmx3ZEZ7U/vPqnMrT2e1tCyRKv3/3TruLvaj0QQjy9XlWov/6/gmasnmNx87eAM7CGSFXj3KqJ/mH9ACbl5qBHmXJR3WO5aZEF/IbX/kQDmySSBDah554nGcYxkxx43+wxYw4OoYS5AUB4WELGB1TBIt/U9BJVDHR3+gw+ECwmoClG1FvL6LmmHkLipFJBsnuIPCBRX5RBfgRJooxuJ0a7oWlluCJnMNSWEXCHsSC9g3I3l7u9wItuDa51SBc519VwCuunCBtLadLiz996T0yhNeatlchzx8k6wE4w4Cn2RROlORTSpdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDw6/P/+jWejB4X1+wm5jYm2LvWluCgBk0KPxA8BgEU=;
 b=WKpLAMUKz+3Hi4nHx83QZBrRInuMCQvqaA2Z24sfekGiC7Fke3kdST110Iq/8b5PW6DxNbOhdeeg2FZigVx0x6wNEGvi6WrYLWmPA1/O1qmMfHN+X/8BhWv8FZb/bsAfJ0mrCd8i0JrCoHQ5jl2omWwrdAatkLnbB+WmR6geaK8=
Received: from BN9PR03CA0297.namprd03.prod.outlook.com (2603:10b6:408:f5::32)
 by DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 21:56:49 +0000
Received: from BN8NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::a9) by BN9PR03CA0297.outlook.office365.com
 (2603:10b6:408:f5::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21 via Frontend
 Transport; Fri, 19 May 2023 21:56:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT104.mail.protection.outlook.com (10.13.177.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6411.21 via Frontend Transport; Fri, 19 May 2023 21:56:49 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 19 May
 2023 16:56:48 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v7 virtio 00/11] pds_vdpa driver
Date: Fri, 19 May 2023 14:56:21 -0700
Message-ID: <20230519215632.12343-1-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT104:EE_|DM6PR12MB4297:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b550a9-b70d-4102-7ba4-08db58b3f2a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d8xtROVWVLcVId8cW3fmAckd6EXz2rz8GUTvTmZhSx0K+IBlqKB2H36ZalxxQNLitr5zy6toGZltAdaMEedUueFT+Guc+Jt53lwuLD2Nk2f7w90CiiGf4Yn9JnG9IY/3T71G2CcCRbKZzGQ4LhQcefoIqzYJvC+x9oKDKp5iFP9uVXR+nyxLWADFe9Ivc50uZhhMLdK5/HOXmkkeCAEWjLIpalL/LAeUqzUaz0SqzKu0FoqQKQ1IzWV71qYCzniRJ1yka4yWMsPC2MwF2vW4bsrnxAkUJVamPLchd5UnRw0aPaWWg+RUA7TlFTnAyHnGYBdlW9UqoHEcXBBVWdn5/Jl8FrQo964R0xzm3QVSlkRkXSDW9TuKXGJHI0+0kA3LvaXnCByxjVaYmNFqI2/dE+tA1j6J36Sn8ic0Llgsb0xZX0BVbIuyRu8TgL8cpucL2l/0ESx6xcrjNo0Yyusv1CDXT/ZgY7qFjfnI9iPffXnHjzAWfWbGm15CADpcBcFhec8IrKVX8seN5d+kHUVgZihUJws+KMLxLtS17fcTc9C5Q/a9zn8ADonTX97M1XpPzWbSDrU0KE1mFEQNbNmeXJeuoZM5KbIFocv0y9i6jzGVIGLkuHAyCIXh0M8soB7aplIVbiQS1un6qIWv4SWbOK6uGTdhKQYLsgPdPEER/bKEtTo076RsgqGrIwQCL8UIsGszO6a086lxk8Ijr7s+MokLdjUp1D8MrVobUzfJveLmGcTdhRfMjhBG58jJXQHz6CrwpQd4ZGLNvnoiwBPJm8JSwWfqjzzrq6yOkTdqcXc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(136003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(2906002)(478600001)(41300700001)(8676002)(8936002)(4326008)(54906003)(110136005)(316002)(44832011)(6666004)(70586007)(70206006)(5660300002)(40460700003)(966005)(1076003)(26005)(82740400003)(186003)(16526019)(356005)(81166007)(40480700001)(2616005)(83380400001)(47076005)(36860700001)(36756003)(82310400005)(336012)(86362001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 21:56:49.5779
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b550a9-b70d-4102-7ba4-08db58b3f2a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
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

[0] Link: https://lore.kernel.org/netdev/20230419170427.1108-1-shannon.nelson@amd.com/
[1] Link: https://lore.kernel.org/netdev/20221118225656.48309-1-snelson@pensando.io/

Changes:
 v7:
 - fixed undefined err value noticed by Simon and the kernel test robot

 v6:
Link: https://lore.kernel.org/netdev/20230516025521.43352-1-shannon.nelson@amd.com/
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
 drivers/vdpa/pds/vdpa_dev.c                   | 769 ++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h                   |  49 ++
 drivers/virtio/virtio_pci_modern_dev.c        |  33 +-
 include/linux/pds/pds_adminq.h                | 247 ++++++
 include/linux/pds/pds_common.h                |  21 +-
 include/linux/virtio_pci_modern.h             |   6 +
 18 files changed, 1879 insertions(+), 32 deletions(-)
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


