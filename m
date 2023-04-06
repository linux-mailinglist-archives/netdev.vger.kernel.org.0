Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C880E6D8FE2
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 08:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbjDFG7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 02:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbjDFG7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 02:59:41 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853F1EE;
        Wed,  5 Apr 2023 23:59:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TaM8U5m5PaeS8BCgkzl4w2SYhMfBFEA6NMIquJHlxB5ynifLPTLyKnhfhlGVL1CajT/B2NCC36DcGvlcTh82kmZXxmGVmxPy1VDLXkLw1e7y71gehJA1IEuCdYN73Bi2qF/8pZmVK/bNPExI/17vxKY94a1wyl9YqzF9CEUW19iK0S63+9WmdFkr/E5z3OCko79LkXSI++PEWnisnY3T0VpPToHfQC8PTwADXTB4wAtClST50f+nMsfshLy9aTixDr4ti8hOK+d93a/SF9ZIRgUJCs2YHaOqJSW6tW5ZKJ4TpdT1gTbI5WtQMbfN5NL7kP0ie65WWpTPOo4t1e4ERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xe8KMhEgiprJyUnOsbEfm9xiQJ9pjnC423ANZ2CLsDQ=;
 b=SFnwnRZh9pCpuK11LyoFMpJcOa4jiXTwoVTMex+WyIr7Baze5MkGw9LEPVNYbr5p8exe2J2fR6Vs+YlwTFKdP9Rl6WQ6PKGgJriqD8ARStldc78tZ3a4AO+ZArXJI3INK/YxOtYovdAHQEtmpBzqCBsb1HPF01OVhSklC5S+5tx6KGll160QUO/Hd9IWFWL7bNTSUUMnAnl2s/Ydk4DF7qI/5OlWghyCtDocemFtgv3OP8ilQzjSBD4WMIXm17Dr9XidM88Mmbb69ILyI9/J652bhag75Rmsoo4mgfpCtRCJNXBOdOuZkBT92S0ba5IPWizrOnm53CL0YHaVl8DMyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xe8KMhEgiprJyUnOsbEfm9xiQJ9pjnC423ANZ2CLsDQ=;
 b=Byce1//VnYh/LeIbOYH6H1XsAalskX8FLZN6D94ScP+Jwy75sLvvOfssoUbvcC20DttbKYz/d3nKRKKPfNhgEFwqF/xTCVywRmC5BvQkXUhUW3lokmQluVJb+KGoJhD5ZrXZ5p6WZ5PeL9miVeLpUOVLuyacWfeq0SUFG5A4jA0=
Received: from MW2PR2101CA0016.namprd21.prod.outlook.com (2603:10b6:302:1::29)
 by BY5PR12MB4997.namprd12.prod.outlook.com (2603:10b6:a03:1d6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 06:59:36 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::21) by MW2PR2101CA0016.outlook.office365.com
 (2603:10b6:302:1::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.14 via Frontend
 Transport; Thu, 6 Apr 2023 06:59:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.28 via Frontend Transport; Thu, 6 Apr 2023 06:59:36 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 01:59:33 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 5 Apr
 2023 23:59:09 -0700
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Thu, 6 Apr 2023 01:59:04 -0500
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <jasowang@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <eperezma@redhat.com>, <harpreet.anand@amd.com>,
        <tanuj.kamde@amd.com>, <koushik.dutta@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Subject: [PATCH net-next v3 00/14] sfc: add vDPA support for EF100 devices
Date:   Thu, 6 Apr 2023 12:26:45 +0530
Message-ID: <20230406065706.59664-1-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|BY5PR12MB4997:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e4d52fe-e6b6-4100-dfed-08db366c7bc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUNv+WKM2cOAycW+Vmqs7/sUbBaMc3hsAJo5uHcI/hy1RODlFp7MUOJrqGpZPodURUe0pN3frlxJYgAJJaUvA3vr3oZiYaYkrsTOfNjfflVwtb4rT4RZ2ltvxWyQiHDLNaFBOqlc81dWqy89SSMhXU8GvuQlvFbJDxU5fIuQ7WKnwDYV+Q19ydhmYPtAt6Qu870PTOzWFKDbxAZ3iH0bJY313lRF+cUDYZKRZvAt8mH2V8VCdIgzzRFT6tHHT645mkNvBem2QRNYdOug/ATvNxrEpYld7viw9eCMm1O02V9IHRsrT/mL4z1amlRW8Np6dgtI5SnFObzgpY3TYsho3v+JTpp5S5U1hN4fUIEpmWBv4r8ChNM8fMahFTHckJbzhHmBlflsSVEKLNMIon93D4LOaweL+YXigNo8L6NnpNfaCNOdd3TtQpIIqi46SwVymO+4eT80DH/JVgr73Hf8ZGmTMeOP3TXvwNXSD7TwoMkvQHCe4Z01YNUFgqt007a/EyajqW5EkCfomDGRwkPJxiicQkXfPYgV5yp+fSzHxkPZ3HJrnA8EqaBwC68FaQ4So1AjREj8ZLyltrsFJs0TgPQSqFlUAFFffRd/P0dBXIkRmneYXFVquV8KBuMifh+koWd5WJNZ5R+A77wlqIApbPj08L5UM/KAaDgwnu92z9o3dM/p9d1z0XGOGlaJC5Y4LMh+cJrLDVX6U25zYlP4ZXzv689R3fgqowbT2yUdBPD0yIQKkG4Mp6Focp4xBuhjaP82ALIq4q1XvzNLbG4nWg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199021)(40470700004)(46966006)(36840700001)(186003)(7416002)(40460700003)(26005)(44832011)(1076003)(6666004)(40480700001)(426003)(36756003)(110136005)(81166007)(54906003)(82310400005)(36860700001)(478600001)(316002)(70206006)(83380400001)(8676002)(4326008)(82740400003)(921005)(356005)(2906002)(47076005)(41300700001)(70586007)(86362001)(336012)(5660300002)(8936002)(2616005)(21314003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 06:59:36.2518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4d52fe-e6b6-4100-dfed-08db366c7bc4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4997
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

This series adds the vdpa support for EF100 devices.
For now, only a network class of vdpa device is supported and
they can be created only on a VF. Each EF100 VF can have one
of the three function personalities (EF100, vDPA & None) at
any time with EF100 being the default. A VF's function personality
is changed to vDPA while creating the vdpa device using vdpa tool.

A vDPA management device is created per VF to allow selection of
the desired VF for vDPA device creation. The MAC address for the
target net device must be set either by specifying at the vdpa
device creation time via the `mac` parameter of the `vdpa dev add`
command or should be specified as the hardware address of the virtual
function using `devlink port function set hw_addr` command before
creating the vdpa device with the former taking precedence.

To use with vhost-vdpa, QEMU version 6.1.0 or later must be used
as it fixes the incorrect feature negotiation (vhost-vdpa backend)
without which VIRTIO_F_IN_ORDER feature bit is negotiated but not
honored when using the guest kernel virtio driver.

Changes since v2:

- Introduced vdpa state EF100_VDPA_STATE_SUSPENDED to avoid updating
  vdpa device config space after device is suspended during VM LM
- Removed the masking off of features not supported by SVQ implementation
  in QEMU for Live Migration. This in-turn imposes the restriction of using
  QEMU version 6.1.0 and above with vhost-vdpa
- Used IS_ENABLED(CONFIG_SFC_VDPA) to replace #ifdef CONFIG_SFC_VDPA,
  wherever possible
- Updated the values for EF100_VRING_XXX_CONFIGURED macros to use the
  initial bits (0, 1, 2 and 3)
- Used  __maybe_unused in ef100_probe_vf() to avoid #ifdef for conditional
  compilation
- Fixed possible uninitialized return code from ef100_vdpa_delete_filter()
- Avoided use of goto and else at a couple of places in filters handling
- Replaced switch statement with single case with if statement in a couple
  of functions in mcdi_vdpa.c
- Updated patch 4 commit description to explain the need of refactoring
  around efx_ef100_update_tso_features()

Changes since v1:

- To ensure isolation between DMA initiated by userspace (guest OS)
  and the host MCDI buffer, ummap VF's MCDI DMA buffer and use PF's
  IOMMU domain instead for executing vDPA VF's MCDI commands.
- As a result of above change, it is no more necessary to check for
  MCDI buffer's IOVA range overlap with the guest buffers. Accordingly,
  the DMA config operations and the rbtree/list implementation to store
  IOVA mappings have been dropped.
- Support vDPA only if running Firmware supports CLIENT_CMD_VF_PROXY
  capability. 
- Added .suspend config operation and updated get_vq_state/set_vq_state
  to support Live Migration. Also, features VIRTIO_F_ORDER_PLATFORM and
  VIRTIO_F_IN_ORDER have been masked off in get_device_features() to
  allow Live Migration as QEMU SVQ doesn't support them yet.
- Removed the minimum version (v6.1.0) requirement of QEMU as
  VIRTIO_F_IN_ORDER is not exposed
- Fetch the vdpa device MAC address from the underlying VF hw_addr (if
  set via `devlink port function set hw_addr` command)
- Removed the mandatory requirement of specifying mac address while
  creating vdpa device
- Moved create_vring_ctx() and get_doorbell_offset() in dev_add()
- Moved IRQ allocation at the time of vring creation
- Merged vring_created member of struct ef100_vdpa_vring_info as one
  of the flags in vring_state
- Simplified .set_status() implementation
- Removed un-necessary vdpa_state checks against
  EF100_VDPA_STATE_INITIALIZED
- Removed userspace triggerable warning in kick_vq()
- Updated year 2023 in copyright banner of new files
 
Gautam Dawar (14):
  sfc: add function personality support for EF100 devices
  sfc: implement MCDI interface for vDPA operations
  sfc: update MCDI headers for CLIENT_CMD_VF_PROXY capability bit
  sfc: evaluate vdpa support based on FW capability CLIENT_CMD_VF_PROXY
  sfc: implement init and fini functions for vDPA personality
  sfc: implement vDPA management device operations
  sfc: implement vdpa device config operations
  sfc: implement vdpa vring config operations
  sfc: implement device status related vdpa config operations
  sfc: implement filters for receiving traffic
  sfc: use PF's IOMMU domain for running VF's MCDI commands
  sfc: unmap VF's MCDI buffer when switching to vDPA mode
  sfc: update vdpa device MAC address
  sfc: register the vDPA device

 drivers/net/ethernet/sfc/Kconfig          |    8 +
 drivers/net/ethernet/sfc/Makefile         |    1 +
 drivers/net/ethernet/sfc/ef10.c           |    2 +-
 drivers/net/ethernet/sfc/ef100.c          |    8 +-
 drivers/net/ethernet/sfc/ef100_netdev.c   |   26 +-
 drivers/net/ethernet/sfc/ef100_nic.c      |  187 +-
 drivers/net/ethernet/sfc/ef100_nic.h      |   29 +-
 drivers/net/ethernet/sfc/ef100_vdpa.c     |  548 +++
 drivers/net/ethernet/sfc/ef100_vdpa.h     |  225 ++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  793 ++++
 drivers/net/ethernet/sfc/mcdi.c           |  108 +-
 drivers/net/ethernet/sfc/mcdi.h           |   13 +-
 drivers/net/ethernet/sfc/mcdi_filters.c   |   51 +-
 drivers/net/ethernet/sfc/mcdi_functions.c |    9 +-
 drivers/net/ethernet/sfc/mcdi_functions.h |    3 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h      | 4391 ++++++++++++++++++++-
 drivers/net/ethernet/sfc/mcdi_vdpa.c      |  251 ++
 drivers/net/ethernet/sfc/mcdi_vdpa.h      |   83 +
 drivers/net/ethernet/sfc/net_driver.h     |   21 +
 drivers/net/ethernet/sfc/ptp.c            |    4 +-
 20 files changed, 6583 insertions(+), 178 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h

-- 
2.30.1

