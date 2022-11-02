Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F98B616982
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiKBQoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiKBQof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:44:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD23FFD0
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:40:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QT47rPhRVDe4tDPIqi2/h3Tg/uZqeEVsrCavyP4a4aH0AszD2Z69Sd1k/57hia6fxKJIpcTe12/jrL+Kcu+rKzIIKFOGgQjND7kphSWCmBltiWXlGAul1pjOwno6/qiqlWQfH41qTGkQe6AdI9HAx6lyr3FNLRcFMyuuhQsi+JDSCCQiBHAzjy0zByuNyWHPPyqPWOYMkt6ysnCHYmFIacb1odf+wdivryZQIvAJyQag/ZDEAX/D7jqXkB4CJj0ojRxAzPhdkXooe2fHLb7YOD5I/wTqqG0fZYMU9hkBj1EEVrkikMn4KPgv025mV5UErwH0yxlbVpGgNW35WVzZ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g72bVVSgjvpTExPvOwevnjZElktngZJ9//OKEkUfsJA=;
 b=NG00FwFDhuScsuKgkGnW6wuKUw1FYU3bquy4PnlSy41XQqzwRAdNipKqPeDMcVkxAZhRMg3Z9nZwGMfYgooczjDqXO6y5wuu+zJzkySpAJ6ZeI4rqC6WCDc4AX7piKVy2eXmo9k3Wsoy00P6MvOMjw9Rv7qkxKvzAXGXcBjhkMoljI9NxoUYzLAyD1B74LPwKa9g515jCo4BO7pAjuiFmVLmb4BE9+h5IRJUYNhe3YF5Rbhky4wJDBGaaaGBnq7cppLOmc5xmir7R4AEzmB8jgtrBKQUTbJyJmqaNbAcwhmwobeAER/iLrKakip08G3MhHu6OF6JxHbUZtovPtx8bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g72bVVSgjvpTExPvOwevnjZElktngZJ9//OKEkUfsJA=;
 b=Un4JrENhSIw1AdlrJp34LDtM6fCfPzacaAJ3Av1FSgT3EGbHPfc0bHiF88d8j53n1in/B3GgeJDp+ZzWW3M8+y9EQmk34kwBu1PIiT32ADnRC+aSFAIiJYr17uZOfnxMnSXhkyazxkd94Rx1FGCGX98jp4jmcp4YyhYFiRZMxmwOzawNZkH8Ir+pHfcx1FTFCJUq9bOVc4dL9776Z15usbG0n+ouKUY3L1GxTPpu2oQHph52MqAB4qAbkddalT0YXcOIchu4+QhEzCY7Xhv+A/H6/P7oBR/OKZZIvaeP8H3xINuL5WQGPy7r8FAzGsCOgciis/5tn0MHZL+E1l6bCA==
Received: from MW4PR04CA0112.namprd04.prod.outlook.com (2603:10b6:303:83::27)
 by BL1PR12MB5335.namprd12.prod.outlook.com (2603:10b6:208:317::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 16:40:21 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::b8) by MW4PR04CA0112.outlook.office365.com
 (2603:10b6:303:83::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21 via Frontend
 Transport; Wed, 2 Nov 2022 16:40:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Wed, 2 Nov 2022 16:40:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 2 Nov 2022
 09:40:09 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 2 Nov 2022 09:40:08 -0700
From:   Daniel Jurgens <danielj@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <saeedm@nvidia.com>, <yishaih@nvidia.com>,
        "Daniel Jurgens" <danielj@nvidia.com>
Subject: [PATCH 0/2] devlink: Add port function attribute to enable/disable roce
Date:   Wed, 2 Nov 2022 18:39:52 +0200
Message-ID: <20221102163954.279266-1-danielj@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT006:EE_|BL1PR12MB5335:EE_
X-MS-Office365-Filtering-Correlation-Id: 06dda11c-33c5-4058-ab33-08dabcf0ee77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSahk4ocClPHopl2Tx0O7StniuLbXgKeO0i1rW/emyLi+2dBWGD/56zWf0zTbXjn5JNV61d356tnGq4LJOd0nLkhCk1mYSwwGX9RrNuL3jZJyyknbb/J7xC601gdCDYPFvbXUITwpb9K5GnjgqD+jQddItjT7t57BEgP5Wg58Xu3mycYEWMQfNu9vayuZ7wPrpsXaLkqjInedODtcuLdgOf9bPn3g02KPz104+QeyubrNeXOMBUajNEUvdVffyAZ803usoPjCFqKKReitI9QKUurg3JH9AJveYl2xAmQqgXfGaMo2kVbuubAf8cJP7n523kEjfVjO8cjkQqYhSfuFBDHkDg0giG+yKTP/T+Xg59j/MTepp/J8zQCckBrv0ftU+u0CeSI6ldEaRCVe6Oa0kjgtc9Xnz9Uk261VQFTWX8XfniANl9F+/JoXv4gahaQUiXfT+nDQVZPBAfrtkVsWBukbd1qs9URyoAgC+bW2zvRIWH7fQRYJkCvX9ycBL9T0cFlmB+KV0XoUoSx/ajcB6bX35037b8jmGnWSh3qjSpX7/+J+xhFxsNYmnfmSV9axVhtw0L9BtvPdSKoCGv8nFDICPAkcwcm8iQUhNw57VSYE7gLQ7vyg9DfUOkiq7tjqH42WyHu+GJlaRIJGQCVQGhWoJpO+dZuGm7EV7qAs+2kBYubfAAwb36AQecGVv5DkK8u5A1E9RBYTHrmD3BzFm6GVRiYNhtS0Y7BQoUbhqJgc8WGefuEZzJV8jd04tM0BV5reyV96HFMsryyxCmJlw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(82310400005)(83380400001)(40460700003)(36756003)(36860700001)(40480700001)(54906003)(110136005)(82740400003)(6666004)(86362001)(7636003)(107886003)(316002)(356005)(478600001)(41300700001)(70586007)(26005)(16526019)(186003)(1076003)(5660300002)(8936002)(2616005)(336012)(4326008)(8676002)(2906002)(70206006)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 16:40:20.4402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06dda11c-33c5-4058-ab33-08dabcf0ee77
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently mlx5 PCI VF and SF are enabled by default for RoCE
functionality.

Currently a user does not have the ability to disable RoCE for a PCI
VF/SF device before such device is enumerated by the driver.

User is also incapable to do such setting from smartnic scenario for a
VF from the smartnic.

Current 'enable_roce' device knob is limited to do setting only at
driverinit time. By this time device is already created and firmware has
already allocated necessary system memory for supporting RoCE.

This is a hyper visor level control, to restrict the functionality of
devices passed through to guests.

This is achieved by extending existing 'port function' object to control
capabilities of a function. This enables users to control capability of
the device before enumeration.

Examples when user prefers to disable RoCE for a VF when using switchdev
mode:

$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce on

$ devlink port function set pci/0000:06:00.0/1 roce off
  
$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce off

FAQs:
-----
1. What does roce on/off do?
Ans: It disables RoCE capability of the function before its enumerated,
so when driver reads the capability from the device firmware, it is
disabled.
At this point RDMA stack will not be able to create UD, QP1, RC, XRC
type of QPs. When RoCE is disabled, the GID table of all ports of the
device is disabled in the device and software stack.

2. How is the roce 'port function' option different from existing
devlink param?
Ans: RoCE attribute at the port function level disables the RoCE
capability at the specific function level; while enable_roce only does
at the software level.

3. Why is this option for disabling only RoCE and not the whole RDMA
device?
Ans: Because user still wants to use the RDMA device for non RoCE
commands in more memory efficient way.

Patch summary:
Patch-1 adds devlink attribute to control roce
Patch-2 implements mlx5 callbacks for roce control

Yishai Hadas (2):
  devlink: Expose port function commands to control roce
  net/mlx5: E-Switch, Implement devlink port function cmds to control
    roce

 .../device_drivers/ethernet/mellanox/mlx5.rst |  32 ++++++
 .../networking/devlink/devlink-port.rst       |   5 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  34 ++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   8 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 105 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  23 ++++
 include/net/devlink.h                         |  20 ++++
 include/uapi/linux/devlink.h                  |   1 +
 net/core/devlink.c                            |  61 ++++++++++
 11 files changed, 291 insertions(+), 2 deletions(-)

-- 
2.27.0

