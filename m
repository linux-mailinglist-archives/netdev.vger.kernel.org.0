Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D6D69651F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjBNNoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjBNNnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:43:19 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B9D27990;
        Tue, 14 Feb 2023 05:42:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSd8638bkIOnRS9nI0tPytAIltbJkSQWCmAlFBfcR+a4vknkBYKE9yAIjKXD6WHPGVKivEYa2+ujbbvyKMJIQq1Dn3FfXPppbKwNchyWeTquNXjmJ/qDDPfn/1uPkc1O5XUrcpQ1b03ymfLeBdSAnauuTxy8OD3h1DKo9Rp8MxBxJYe20P0Y/V2K63R/MTTY++8OFnHyIV3Sn3V1h+fixB+N3om30GJ++KbE76ThtNE26m6Ly0RynROkmKA/NDbHwF75TVx5hqEsJQ2FgY+ZSPQT4CIvZaTtr6Jvfwn8UoSj5pkULmQ4i6tk/Xqy0QEwz/Sun064UXqMdLiVh+ykuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCZ3SxcaPwFr68wEFW6ypc1MMOHCPYKBN/OkZROwvYQ=;
 b=RuEd3WFbl3IUbv4/2j+ZLUrIeNaI1Da4Xb/wHxXvFIl2WCiAFTPKp2yAUdlvQlFH3pEkZ/0VXxsvZXA6PYtAjc4RK5b8JRAMGjcGsLMaBOa156LmkEmmBR2Vww+qpgTF8KC1KmsSGf2xwiedvsqSfbQiOcuFy46I6TlQvtu5zhmm05uDNCcGkjNAnC5kj0D37xBdTpdRmsB6qbGnYj/mmXEJ+e39E8vFbYlYNliFo0q835dKMpAhcsdFFvn4NwqB55ay4WbaUgWolx94kjobguVnAfAWJDmqN6gYg27/sX1EPVNjLnvwMgZrnLKkMfTmH8/SU+G+iHMW4MQQyb9Bjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCZ3SxcaPwFr68wEFW6ypc1MMOHCPYKBN/OkZROwvYQ=;
 b=qikxxX0Dffda/LjYWu5FWalLslWKqPsCHSMAgsRuQNRc5IcI7KIRBbyAqsjgCICJlW29SXxld7G934AlQGYz44A0QGQP3OqYD4SHTVj2b9VivM12qVXVhmR0FNkCkDT2Bol1pcCFQVrklFEUwQlce83DDYbfgLagwMTUGciqD9ZyJGE69wcssmY8bpVe4SGF5Ml04jeoGDMe3ONWuFcUY2ENpCTLOStzOeW4yIlOBHlfRPPydBwwe2NKyrD/OzRGqolO3S0cxQfKCrZQ33KTJ9yuD9nzcBp7YaCFt2P+6Ie13yrIvBCrYGErEQ3j8+3NBquYwfyBMiNZry7lfLnfHA==
Received: from MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::27)
 by SA0PR12MB4494.namprd12.prod.outlook.com (2603:10b6:806:94::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 13:42:20 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::d) by MW4P222CA0022.outlook.office365.com
 (2603:10b6:303:114::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 13:42:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 13:42:19 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:06 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:03 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v1 0/3] net/mlx5e: Add GBP VxLAN HW offload support 
Date:   Tue, 14 Feb 2023 15:41:34 +0200
Message-ID: <20230214134137.225999-1-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT005:EE_|SA0PR12MB4494:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c44ffbe-57eb-43c1-679b-08db0e914b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xrDGomerhID9utKLrbkD1TISLEfNw/Kzc1oUXOpNZ6KX76Z0Dc05cc+kHUd+i92gp2Pipv6HEZS4bnp7lBodnDW7/Tu7bYkdrFOMTRfrBITjk99zFvWyP0dz+K83RNtr00T04GpE+J6rBB73fsVuIMIdP+tC7ymeMc8CdPhIfS18ScxCkgBvnnQSLF274x2jBzSWeANMIi3TxWvslxKx1MztXFnPIk5yMAN5xxkXm+UfJrf9U3XmFJz1jUV4SKahagiJ6fa8VuJoTqpRfOU2AvGRYU2g/SpD3kJ8qfVIx4gJwx+0tQkRjj8sxEQ7sel2ppRSii1WpaZDcKnBcrPt8ve+ZiNDemB/60SVvUjC8TIc+tElHPmpW1FykEzNUyFf2K5DT5zE1Nq5yzq6Xzr3vkCtQQ5ZPpqrNyZZLUCfI5xP6xku3v+zQx4wlQY2d90M8m8mSpmoAwSPn+XGjnM856Er3PFQkzWFtDlWEe6a5KalEEsc0wytu7FWgkDcSjCY+C3cP7iN5hZLxzco3pI7bYzbAvimhiNoSBDhvPhMWWo/CQ1/v+pTeq0sUn/pagpTWZm497PXv7UM5DHgXsCZoC9UWI1hT0ukGROpH/4p8OFHnqOQjGsyacLH42c8u31LypWovV4iEHIGL9sni8BJy6WUFTfj5owzmU483bepxhHga5u2fNAEhx1C+CUVBENumYCYJ3Cor89h5FffyXLtEg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199018)(36840700001)(46966006)(40470700004)(4743002)(26005)(186003)(6286002)(16526019)(2616005)(1076003)(40460700003)(356005)(41300700001)(70586007)(70206006)(8676002)(82310400005)(86362001)(4326008)(4744005)(36860700001)(8936002)(5660300002)(2906002)(7636003)(478600001)(82740400003)(336012)(7696005)(426003)(47076005)(6666004)(40480700001)(36756003)(55016003)(316002)(83380400001)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:42:19.5127
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c44ffbe-57eb-43c1-679b-08db0e914b25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4494
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds HW offloading support for TC flows with VxLAN GBP encap/decap.

Patch-1: Expose helper function vxlan_build_gbp_hdr.
Patch-2: Add helper function for encap_info_equal for tunnels with options.
Patch-3: Add HW offloading support for TC flows with VxLAN GBP encap/decap
        in mlx ethernet driver.

Gavin Li (3):
  vxlan: Expose helper vxlan_build_gbp_hdr
  net/mlx5e: Add helper for encap_info_equal for tunnels with options
  net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload

 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 29 +++++++
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 85 ++++++++++++++++++-
 drivers/net/vxlan/vxlan_core.c                | 20 -----
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 ++-
 include/net/vxlan.h                           | 20 +++++
 8 files changed, 153 insertions(+), 47 deletions(-)

-- 
2.31.1

