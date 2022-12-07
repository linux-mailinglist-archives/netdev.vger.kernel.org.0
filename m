Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2667F645CF5
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiLGOzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiLGOzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:55:37 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E984E6AD;
        Wed,  7 Dec 2022 06:55:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIz9APdPd6Ww86l97BD8guJJyM6oaKHhP3zM9FmcCPE44A9Sq3jvidcOntTfaLq3PpDosJvR0WypiLhFSl3CCjPSuduv8Zr662SO819VFe+nar+gtTectoEBI26xvIJBRDyL0Vvjjg2xy/ODDXL+162lkVHFs4d6SJ6eajCQ2sU/XRl+DlU4WXycABcKrjoNH1H7mrOxz1cYZrXg8sTJYmggzvAw9JlwGsvL62dKRYVss+aixPAMAIZj82exci6VvTlb9GS7k+DILweiImlV2nGZC/OC/S4epYeEsO2+Qv1MLwFVas8UaagRF6Ppb1N+2rdxqWR2bfER6DX+xt197g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xr3BBTUqancdT4JZNTXiuj2xuYuGSAcrxZD4d88bvp0=;
 b=RYGzE7wf68vc75QCKlRuV9idGOx4YC+Ead7kjs0hzqf4ocalEfrCrmQOs1cgbqT3Tit95eUMJj51L5vQZ/rb/HQ7ZeU4zUdQ3M6LycXpMS6t4usIEiXZxRnneohqTRkSLX01BvlZLBEtBwMrv9BL4KLWifvuPnxQL7wDYzB57kEXOvD+Wh0Tt5Gr86P8QGu1t/Oh2soEiCeYiueOFlaiGAI+UrzENvPVXq+cgKJSzfg22J3noAtSDOYh3JwZwLfef3y1wd8ycWBUwfNUE7RGiqhtWtBKu57Lo2Ikiuo1+Nc71JQfnNNAt5yX0kElqsvm/HGX4K/jOAqtwZ3F5jhh9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xr3BBTUqancdT4JZNTXiuj2xuYuGSAcrxZD4d88bvp0=;
 b=nFIYcljk4w3QuP/IhRtC4RTOldfoYs5ndoQjel2G1bRqhIxD1mFQJpr65sqSbLhRUQ9oZoXSb9+HLq8gLNB6oRKE5oTrxAtkxasZhJZe/knQziRFfhEhwGMVkovoZ4VmBDCvlo31JfAqLBtiAnW/w54atV6tBLNPqO5yNbYQAnc=
Received: from MW4PR03CA0012.namprd03.prod.outlook.com (2603:10b6:303:8f::17)
 by SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 14:55:33 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::e1) by MW4PR03CA0012.outlook.office365.com
 (2603:10b6:303:8f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 14:55:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 14:55:33 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 7 Dec
 2022 08:55:32 -0600
Received: from xndengvm004102.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server id 15.1.2375.34
 via Frontend Transport; Wed, 7 Dec 2022 08:55:28 -0600
From:   Gautam Dawar <gautam.dawar@amd.com>
To:     <linux-net-drivers@amd.com>, <netdev@vger.kernel.org>,
        <jasowang@redhat.com>, <eperezma@redhat.com>
CC:     <tanuj.kamde@amd.com>, <Koushik.Dutta@amd.com>,
        <harpreet.anand@amd.com>, Gautam Dawar <gautam.dawar@amd.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 00/11] sfc: add vDPA support for EF100 devices
Date:   Wed, 7 Dec 2022 20:24:16 +0530
Message-ID: <20221207145428.31544-1-gautam.dawar@amd.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT053:EE_|SJ0PR12MB5504:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b99add-be67-4dc1-15c0-08dad86317c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SviVNqf9/YpMh3S1Q18/s8MlyQmmhu7xXyF5eHhH8Ba0uP20gK7LEHyKHVQEkOiVyVVAqIeaHdc/vkptYzdJ09w3sl1RVw7g7dO9VVQcJI0t4DEEI8/ewO6d065DqcJTrc807dVcjGZH+BAQ/p9dsG7gQ4HwzEadfzkG4gz0gpS5cVvt67KRHuNa0j7t3siCrbLJkPGZfQ5NGMW888PMHdujIa9qL+VmyjvutjyczVw7r4sLRKnybjv6lTaPvJFdwHwmMD0IrKVMV7jYGSfhH4KbYyaSOYl+HTfWmX18F8ymweOWCcREHZXbDuljAyc6niJcw8n2isqw+fgYJHk/bYy2UCeBIwtzLtA1ujZueSwlD6VL9kp+/4Zd5apMedNF7/3JfJdiFGvggf0OWREJ+XlhDIacn2+8jWjlGUD5vL8uYS2/r8V6Qcx2F8JPCvjN2H7NvMUV6NjJRFpp5qQ+1VtxJQmEiyeJMx7h2VjE9+eLrDpupyG706gVTU5Jjxf/aPn6W9juiyq8wwtPPxLikC3TVEO+bbfbiAfsCsovp5vYGrZbRjWxh3J40/6ZckOHOfLFGRxTyV9x256IzRa5dasqhFW+9FoYAUUYI3geMleKJRdXWeL7jRkydD5fXoCw5ypm+2lLtM3HnmKbLEev6a88bOi/dqFVHDqidfLzkL9NzvtuQMOIfloKWV8PEVH3Hc9Yt0SAQAwxLydoF2ETtfUS3xzXcjJUmfeiNrYJU9E=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(478600001)(36860700001)(83380400001)(356005)(8936002)(81166007)(70586007)(86362001)(2906002)(54906003)(40460700003)(5660300002)(7416002)(4326008)(44832011)(41300700001)(40480700001)(47076005)(8676002)(1076003)(82310400005)(26005)(186003)(336012)(6666004)(426003)(110136005)(2616005)(316002)(70206006)(82740400003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 14:55:33.6746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b99add-be67-4dc1-15c0-08dad86317c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5504
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
target net device must be specified at the device creation time
via the `mac` parameter of the `vdpa dev add` command as the control
virtqueue is not supported yet.

To use with vhost-vdpa, QEMU version 6.1.0 or later must be used
as it fixes the incorrect feature negotiation (vhost-vdpa backend)
without which VIRTIO_F_IN_ORDER feature bit is negotiated but not
honored when using the guest kernel virtio driver.

Gautam Dawar (11):
  sfc: add function personality support for EF100 devices
  sfc: implement MCDI interface for vDPA operations
  sfc: implement init and fini functions for vDPA personality
  sfc: implement vDPA management device operations
  sfc: implement vdpa device config operations
  sfc: implement vdpa vring config operations
  sfc: implement filters for receiving traffic
  sfc: implement device status related vdpa config operations
  sfc: implement iova rbtree to store dma mappings
  sfc: implement vdpa config_ops for dma operations
  sfc: register the vDPA device

 drivers/net/ethernet/sfc/Kconfig          |   8 +
 drivers/net/ethernet/sfc/Makefile         |   2 +
 drivers/net/ethernet/sfc/ef10.c           |   2 +-
 drivers/net/ethernet/sfc/ef100.c          |   6 +-
 drivers/net/ethernet/sfc/ef100_iova.c     | 205 +++++
 drivers/net/ethernet/sfc/ef100_iova.h     |  40 +
 drivers/net/ethernet/sfc/ef100_nic.c      | 126 ++-
 drivers/net/ethernet/sfc/ef100_nic.h      |  22 +
 drivers/net/ethernet/sfc/ef100_vdpa.c     | 693 +++++++++++++++++
 drivers/net/ethernet/sfc/ef100_vdpa.h     | 241 ++++++
 drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 897 ++++++++++++++++++++++
 drivers/net/ethernet/sfc/mcdi.h           |   7 +
 drivers/net/ethernet/sfc/mcdi_filters.c   |  51 +-
 drivers/net/ethernet/sfc/mcdi_functions.c |   9 +-
 drivers/net/ethernet/sfc/mcdi_functions.h |   3 +-
 drivers/net/ethernet/sfc/mcdi_vdpa.c      | 268 +++++++
 drivers/net/ethernet/sfc/mcdi_vdpa.h      |  84 ++
 drivers/net/ethernet/sfc/net_driver.h     |  19 +
 18 files changed, 2650 insertions(+), 33 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_iova.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_iova.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.c
 create mode 100644 drivers/net/ethernet/sfc/mcdi_vdpa.h

-- 
2.30.1

