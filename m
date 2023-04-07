Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1596DA9C4
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjDGIKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjDGIKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:10:48 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE231AF0E;
        Fri,  7 Apr 2023 01:10:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlRU1kz8bPMgMHlbtK2QI4nBVgUBd37O26OQ0wJ07KXgeFwKU8FBxxgTv5VyDJtB0uX09si++IUGK13Zk3wC7ElWfC7Q6BoSmalT8qYyIRY6S0J6/1nspan+w7s9zbj3KAUbG5ckHSqNEjL6YFLA4p0oF8VXnvzPOknrS5dU0n9Mscnp/QtG76VTxbB2vS1ZiDBKnNhlIucEnfS5l2JePpJD3yPwjj9xYu4GtZ2+hPczuhJS2MRJ/0xZHGrgctkbw1h/B0AvjC3XcODsSOPNA3w/Xuo5Q12fRZdQal3WupEL8BFfM6IDBp9D18aVHnTMTo9Uwu/HCPXcYGfRsYW5cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/+TxX/zTnDxxh7H1OuzAc0jX1+SKY+4zQyjl3GvkFs=;
 b=UjPEKytNzosn26Fqm5KfUha1Sc5wcnXprsR3HN+r2K4yLFCbV2ubVVeDIOXSwgVWEne8Y6tQadciYDZd+JQN/uqMcqd8ou8h21tK3P2fv2Wz0DB/XmDDYcnamIsbdI+omLuyM3UZv7+2TFC5ATIjfo6PKKAd7SGS5sVNfAnBVWnNJjRXcRw14ZnmhWh4tMcBXJsmsBa2+/JxnTZhE/CApa/20JQDrqoYbsdb57zRNA1MOVTNKoMFdILCZeX6UljyI5+yInxfZvnYZQYsuNcuSEY0pZAsldj8lqvBgNSLgohQ9A1x5MdHWG2Oc/0SziFIeLT1QCzooTj89ygi03Zc0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/+TxX/zTnDxxh7H1OuzAc0jX1+SKY+4zQyjl3GvkFs=;
 b=4DpKRgLxPsPn4+kfDezmgUwaWv6bgGZnxvqLO1p5tpkFMmdLQgwXJ4nQ+xWn3JMn2Q96vpwt2tmBltQOCBA3hyGPksThcrVgdNXzuFEq0O1Z0KpSvV1My8Fn9qcBjsPPx0KmOmaOm/NuRqzzU6CMopTU14GAWOpnVtc6ccrT64g=
Received: from MW2PR2101CA0023.namprd21.prod.outlook.com (2603:10b6:302:1::36)
 by SA1PR12MB6704.namprd12.prod.outlook.com (2603:10b6:806:254::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 08:10:37 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::af) by MW2PR2101CA0023.outlook.office365.com
 (2603:10b6:302:1::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.19 via Frontend
 Transport; Fri, 7 Apr 2023 08:10:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.20 via Frontend Transport; Fri, 7 Apr 2023 08:10:36 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:10:35 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 7 Apr
 2023 03:10:35 -0500
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Fri, 7 Apr 2023 03:10:31 -0500
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
Subject: [PATCH net-next v4 00/14] sfc: add vDPA support for EF100 devices
Date:   Fri, 7 Apr 2023 13:40:01 +0530
Message-ID: <20230407081021.30952-1-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT005:EE_|SA1PR12MB6704:EE_
X-MS-Office365-Filtering-Correlation-Id: b63250b1-b526-442f-77aa-08db373f918e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h+dFJn/41phf50MMQ519UGFn26r3oSjwMF9egmueZ+DVs5yBF5ZotRelzP9OozoIaMF8nGc6ogo6ibVFN7IJjexcWmR8qUct/yr8envZkMzyGFx+HJ/xfpeA1arA2UF/IKLs7mc31TdrHTERIHyDTfipB4jiWytZ1A06Yyx9P1MZGUZLgtUZ4j5iXnKztbJHkO4xXRWSWaX6sOTv+C7kJPcdVTGqbJLw7WnvtMhZ9inORV03QMprpfOZ+aJetwmm9RfpR9t3xngy/ocY6wT4Bw/Y/IIYwP1Jc1WM/ZLonM6PDkDf3BR26RMgp2A+RnNPMcfLu8wbQFGZAJQ4rR50YZUxmHHBTOoxm5zoXYEasZDfFXAxRcHvEP/CqnZOOSFj7evRjxWWKqhYPatnxqgdSfHj5we4aH/0w6UjXq9rV2wf0/aJMugGKsAsNlv6DFbiNd/iBTuTMrMC/E3yq0DPpjo6i/ekJdMafxMBhuenmNtT2HES/857zI9ii6bhxiNz6BK4MTGrUITEs66OFd0RJI7u0XYpdTmA/BbCovOxDznDbsbqrvRmgLn4cxeQaWRS4sCLKc5odHdVAHQAwRKNVsGdHuKElNUVAmvg9f+sr1rhrXrJwxv+01eO9bh7lkJA/zhpxw3+aY5IbB1LARwMVk0UO+MI066ShKS71uV2aWfxGY7jRT3YbI9+Pi4Avmi0X1OKzJ3RudRNVzjk6qk9mrRoqjC2lGmvlap10cTNMvzPOKalUm4dv7X4y5/t1WeGyDTPVHhW8Chu/qVqoFhtDg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199021)(36840700001)(40470700004)(46966006)(83380400001)(2616005)(336012)(316002)(40480700001)(70206006)(8676002)(8936002)(86362001)(2906002)(5660300002)(426003)(44832011)(7416002)(70586007)(47076005)(36756003)(921005)(81166007)(356005)(41300700001)(82310400005)(36860700001)(40460700003)(478600001)(82740400003)(26005)(1076003)(6666004)(4326008)(110136005)(54906003)(186003)(21314003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 08:10:36.5838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b63250b1-b526-442f-77aa-08db373f918e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6704
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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

Changes since v3:

- Removed the patch v3 13/13 which was included mistakenly in the series
- Fixed build error and warning on patches 4 and 6, reported by kernel
  test robot.

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
 drivers/net/ethernet/sfc/ef100_nic.c      |  186 +-
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
 20 files changed, 6582 insertions(+), 178 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h

-- 
2.30.1

