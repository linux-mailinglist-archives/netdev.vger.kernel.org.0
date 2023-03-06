Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A46AB4DC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 04:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCFDEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 22:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCFDEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 22:04:08 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25F9D302;
        Sun,  5 Mar 2023 19:03:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQVUDww2M2OLJMGBqE9CkpvlJpl4Q+Gm/YxvoHQ0s2NF0ugV+LJke+dNb4q0hSkTV2J2Vygh56LSDIOCS9GYS5hPgDiRLsVdZ/znOUutc6cAVhdZ5jqEsm7+9zTIO24v3KFIeKjk5actk3Bf2r1Pqm9E/1gOjXrBnaxUWJxjQTP6TQTBxd/6vI628WXhcTG9Vsnz7UaQVawqnvwgVH43yZFKR8n8GHPmpNFAq3zxfGuUaLw0fBEXgj5CQ9/TkYygV1TKI6eaPMyyGCq39E592pamZoqZBpPyV/jSK0XhumdbJV15Kfu5XigupulQRjfuyJBPSxgmrIO2eUXM7w3Oyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIiD0dPSjrZEFOFG6fQrmcNTk8rMCljUc+/AaQN5bfE=;
 b=OKHLQer/yh2HetBOsOMKMs6OM1Ph4rY6kpTaVsMtNifNen4uQvc51trFFsA0ac6KAitaTQI8nBcFbkuBLmD/0scon492Rz8L2BBwZ42rtFi4+ikNKJZD2HCr9bHtb5pzIsX76WNUYqoYYHcjNDYXs4osBeI2F193H0r0ilSy4rRIIRfDz1dO+Jqelp8vitkrRA08X+hYr+bw31yXqFl4IHxoWhVSXaL5G6Lf2gGqUTexHmmhrdwhsgu/2gRPXkBb0pxXYvYFcadWKnuO2VeeQzCg0RsOGfRcoB4fDZBs/HlJYeg1kRAxwGayQabkKjvhEAG07PqkOGEcHlnOr5i7Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIiD0dPSjrZEFOFG6fQrmcNTk8rMCljUc+/AaQN5bfE=;
 b=jI6uej5V2JRpdR+/JUaIxYe49w/AqHpLA+YozI3qvPNkwA5ePclNrN1lUd9XcXOGgTVjhTi3X7z5CNt4+W2ki+e22LsjZSICYr0F+eSdy2044Ce+VM+brw5tkbdmS7e2gi+3EBzCx7hngGVoA4Zo5IAqaTsZ/Vz1zNCKtYQzaJdh98CFHb/B/njFALrhiwMbjw4YsP3UyhjQUtIRJkEU1alBmgsvnmTjK5Y/xRI6fEvN1FDGsnlEzY/oYKd7KjIFdiqjjccO1rKghNykRK8mYjfL2CUbRiJDRUy6igvOQMeq/YkRwQjOhF18QVOAoxPYZ28Ds0sqhi3sfamIOXJD8Q==
Received: from BN9PR03CA0098.namprd03.prod.outlook.com (2603:10b6:408:fd::13)
 by BL1PR12MB5972.namprd12.prod.outlook.com (2603:10b6:208:39b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 03:03:48 +0000
Received: from BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::b5) by BN9PR03CA0098.outlook.office365.com
 (2603:10b6:408:fd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27 via Frontend
 Transport; Mon, 6 Mar 2023 03:03:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT094.mail.protection.outlook.com (10.13.176.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.15 via Frontend Transport; Mon, 6 Mar 2023 03:03:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 5 Mar 2023
 19:03:38 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Sun, 5 Mar 2023
 19:03:34 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH RESEND net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW offload support
Date:   Mon, 6 Mar 2023 05:02:58 +0200
Message-ID: <20230306030302.224414-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT094:EE_|BL1PR12MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: c4590d95-f507-4e1d-3aa7-08db1def682d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l9D8w2lbgXNB7kHh9Fhjd7s3Iq5dtmyzsDn5hQZ1YmAsv+JvP6vcDoUMpoa6aXbGv3ydCBAMKVqx76h8ExU3VuHvzXgxUv8UjstR1OLUpJ+nZtba1bKNscDfz53G/yHbzTUSbyDkd9EKRHGTPXaac2da64ERIJSpdSg5hTPlIsrfNgPPk9XO0d4uSr29El/oYD2fggyulPDjwKusVbh+WNA74CYagaSNwcexTt+KpZu8/vL9IX5SU5PNXtZb+ELCCT7ZvKtYutqpmiDWoXQ9IM2D6ZG48pK80M8fi4HKle2mPXdZg+m/gPwi7F2H9qH11wBUwumwYOTM2dCURJFcqGlwRbX7ikZ+SBE2VaTBCL/aDLGzmlGE6lXsBywGyWW6Wkblp9aAOEbnaJD3UsZfcLQnT/iUtzn1oSAnYGiZJz3DJhHc9rJDCUKEzWj9ORTTE8tewATAQHdFwBYLUKSRoORDyngM8czf0RUQG9BSAy4Ux/vV4M7rA4QpSJ5JmREb8U7qufnWaQrC6Po/9LhxdaT94NJJyxrqQLyODqiu5Pcl8VOE5Ndt6QVcP0svNc+13JP1EzPVNuRru7SZEIL4Usqkw80pk88DuqFi4Dk1AMd+TXg0yRS2QtDqN2+/CPdbGIy59iOmpJl82B6vVocXkh2HAFSMqdPg7H1KBvWISKQOjC8wgATn94De/kzV6BK+q8oAgl22x4GX5hSEq/abWw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199018)(46966006)(36840700001)(40470700004)(6286002)(40460700003)(16526019)(186003)(6666004)(7636003)(356005)(8936002)(36860700001)(4326008)(8676002)(41300700001)(82740400003)(2906002)(70586007)(70206006)(5660300002)(426003)(47076005)(7696005)(478600001)(107886003)(2616005)(1076003)(26005)(336012)(316002)(110136005)(54906003)(36756003)(55016003)(40480700001)(82310400005)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 03:03:48.3209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4590d95-f507-4e1d-3aa7-08db1def682d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT094.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5972
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch-1: Remove unused argument from functions.
Patch-2: Expose helper function vxlan_build_gbp_hdr.
Patch-3: Add helper function for encap_info_equal for tunnels with options.
Patch-4: Add HW offloading support for TC flows with VxLAN GBP encap/decap
        in mlx ethernet driver.

Gavin Li (4):
  vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
    vxlan_build_gpe_hdr( )
---
changelog:
v2->v3
- Addressed comments from Paolo Abeni
- Add new patch
---
  vxlan: Expose helper vxlan_build_gbp_hdr
---
changelog:
v1->v2
- Addressed comments from Alexander Lobakin
- Use const to annotate read-only the pointer parameter
---
  net/mlx5e: Add helper for encap_info_equal for tunnels with options
---
changelog:
v3->v4
- Addressed comments from Alexander Lobakin
- Fix vertical alignment issue
v1->v2
- Addressed comments from Alexander Lobakin
- Replace confusing pointer arithmetic with function call
- Use boolean operator NOT to check if the function return value is not zero
---
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
---
changelog:
v3->v4
- Addressed comments from Simon Horman
- Using cast in place instead of changing API
v2->v3
- Addressed comments from Alexander Lobakin
- Remove the WA by casting away
v1->v2
- Addressed comments from Alexander Lobakin
- Add a separate pair of braces around bitops
- Remove the WA by casting away
- Fit all log messages into one line
- Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
---

 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 drivers/net/vxlan/vxlan_core.c                | 27 +------
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 include/net/vxlan.h                           | 19 +++++
 8 files changed, 149 insertions(+), 51 deletions(-)

-- 
2.31.1

