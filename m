Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B792C4D2FA7
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiCINEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbiCINED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:04:03 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDF866F90
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:03:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YWueZZElUj+ikH4ViVVe3P9q+ME9nVl0RRy+6ZriRQKr3Rik+Uoy8yFknYen8wON4FNfZF61xjawRPV/7DVhdxt6AfMuX78Gc69EhexxTS3GET4kjZ7etDSv2EbOOOnLmr0XMrZZ2YTQ532W0kQJxYFYw3hmvygWmX6FgK9wPv+nBLzlbDipmmqPAL1bnob8eIC4V/FKVaJmm0FWfFr2rZwJMUNydT3bQHQ+ydRbrxqaoIg6fvnINW/BOEw3lEx36LwsQ/LnvnKWHuDu+XVFIgdKFo8++RhBJUNumVZQTbkLx+EDHZpTWVlOTrjtyY0bpCv1FS6XQU0mBYjgETqwkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSUDETdFc80kZMuXunIJn43r/+zzAgTGR7Iuzs6s9ms=;
 b=U8RTQ6AA1NL0NnCIiQUSVo+23BzgsyoRl2o5lKaJKd/QZg51erlrOzmYPvIawncgkrN+l+lUiQvf0eBQTrKnW5f2mpOItVmMtzQdydQQLAbV45uEXFsLoD7hq6dqnLb/g0WSeEfyQnTAyjWRj+KcRDnjEbRx5cvU7HQIk7ZILFEbJfKH8hy2DmFHoV5T5ybKJMIoQxD9FxHPM3i3H+Z4FU77FAgfu3yCbOc5DSwh0Ic4CtJDK/DQxbMATmhFg+jCEBSX2yY8SSCEeRMRezXqxIL0PiF/gwPvGPlhAWSk4ygNjKPSX2NLvC0Kwvdlfh/65J4IbGBp572LRXNmMQO10g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSUDETdFc80kZMuXunIJn43r/+zzAgTGR7Iuzs6s9ms=;
 b=R9mFK9RmcS2ORIjrSMa+m1XUROVRqPRW8iSR2/4XMu5uGACxvP8fWlBkgcDH3ERTAWHRP1j3N/+XSzIZhDJUzOZuE+yuOxRBaP9Ca81Co/9TbnXZ/ujfsYzG6dMxCQFOZfpRs9UFla/OfW4qjK2h4umYim3fBN4lL8VlcOfGJQMg6Mq7bjNuUSSUgonIrhk6Q1eEMHajY+2iZMdxOE4QYUL9B691MCHg3s4fCqYWHo1rtitmnfH+GjWUp/BNKkpkipJt58ws+/Up8/yDiaGqD6mJSNZWMDH9oIzOXPbgUoRkBaDQBofKdq+F1rrE50PJWqvPZD7loCzxNsfniMwkwg==
Received: from BN9PR03CA0977.namprd03.prod.outlook.com (2603:10b6:408:109::22)
 by CH2PR12MB4889.namprd12.prod.outlook.com (2603:10b6:610:68::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 13:03:02 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::77) by BN9PR03CA0977.outlook.office365.com
 (2603:10b6:408:109::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 9 Mar 2022 13:03:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 13:03:02 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 13:03:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 05:03:00 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Wed, 9 Mar 2022 05:02:58 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 0/3] flow_offload: add tc vlan push_eth and pop_eth actions
Date:   Wed, 9 Mar 2022 15:02:53 +0200
Message-ID: <20220309130256.1402040-1-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 570b2cde-83d9-432e-fc01-08da01cd24bd
X-MS-TrafficTypeDiagnostic: CH2PR12MB4889:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4889661C901EA14C971B7167B80A9@CH2PR12MB4889.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 58YdpbCpnTAr82+FK64Tz2NwgvQdOKhzCg2fJRbIYTTMvwqcaRg4dbaqfrI2fVG09sFzwRrRc2ruGrAiO2PeT4ol2hbmEXDQ7PDvSVI4OHP9jzjZqCHj8NSkYg1rWQ4AdOtY6Q6grSxr9XjhtaY7VrNnnifs7l7QIeyMJjYxAAYnlqPIl+OuOEWSxmexkJGLnNqpkm/4sC3t0EZNCORGOmiGVIhkg9V1LZFW3XTxf/TZ5sKJSyjY9WCH6n9cU5nKDVKIDsxibUR5jcETOQmwKopBpi596kvHJXXvODwZ5XgG+6/crOVSvlqgmysB+isbvvucYWH2qWbcH0A/bsE9NoVRNXtfjfu6d0HDBVszhPYgfjn8Mmy4E5mdQCqH1oCMv8npt2EmYidzYZJSwBPlIyhg0Gc/+Z7drDcNbaTT2YfJXLGWlFMdlbWzYGkpfe7fq8bn7m4gQghRIfZuMgNOH3E0Ad+JR2QO0ilXoThGpIeRk75A/ZeGDyGfLDGOq8iTG5J6SaprW84r+uO0xLSXpQVgs00nvGZqgsfabg0HyoIpTtEIuG3u7c5QYbNl2xKLVyz6d5kYIiUmmxrAf46l4p7R5/Dy7gd7jpOSDwXVJavqZzRGIuo19Jdiek2sDO91eEST4spBIJUqKiywANujyE5DNim/YufBsmng+v+92WyL/jZ9u1dSEDDfZq3FRR67tZQ7tLA4KLtWHELVA6BsBQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(426003)(336012)(86362001)(40460700003)(26005)(186003)(316002)(54906003)(6916009)(1076003)(107886003)(2616005)(36860700001)(81166007)(82310400004)(356005)(83380400001)(70586007)(8676002)(4326008)(70206006)(508600001)(47076005)(36756003)(5660300002)(8936002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 13:03:02.0981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 570b2cde-83d9-432e-fc01-08da01cd24bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4889
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading vlan push_eth and pop_eth actions is needed in order to
correctly offload MPLSoUDP encap and decap flows, this series extends
the flow offload API to support these actions and updates mlx5 to
parse them.

Maor Dickman (3):
  net/sched: add vlan push_eth and pop_eth action to the hardware IR
  net/mlx5e: MPLSoUDP decap, use vlan push_eth instead of pedit
  net/mlx5e: MPLSoUDP encap, support action vlan pop_eth explicitly

 .../mellanox/mlx5/core/en/tc/act/act.c        |  7 +++
 .../mellanox/mlx5/core/en/tc/act/act.h        |  2 +
 .../mellanox/mlx5/core/en/tc/act/mirred.c     | 10 ++++
 .../mellanox/mlx5/core/en/tc/act/mpls.c       |  7 ++-
 .../mellanox/mlx5/core/en/tc/act/pedit.c      | 59 +++----------------
 .../mellanox/mlx5/core/en/tc/act/pedit.h      |  3 +-
 .../mellanox/mlx5/core/en/tc/act/vlan.c       | 19 ++++--
 .../mlx5/core/en/tc/act/vlan_mangle.c         |  4 +-
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  1 -
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 10 ++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 include/net/flow_offload.h                    |  4 ++
 include/net/tc_act/tc_vlan.h                  | 14 +++++
 net/sched/act_vlan.c                          | 14 +++++
 14 files changed, 85 insertions(+), 70 deletions(-)

-- 
2.34.1

