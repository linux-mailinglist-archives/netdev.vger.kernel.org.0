Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD3E5843A1
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbiG1Pyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiG1Pyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:31 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB4C6BD6E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsq1pviJJVSB7D1KKSGEYUzHsKeirNAYHicldjG28x1+RKzpVIbhqqN/9HQXKq95o3WRqR9HPyh2DqQHxIUC1+2xXhsI6F+HlaE3xys2k7Y0Wx4ntOZebB57ba75pL8TrXx+dwr03KPbgogUO8mJml4wS+lKLTJHw6ar6qCw+tJBzslO4YQQJbW6SKQfqY0oec+pUFAbkS90/q/0WQOgcB+PIG5BNdscdAmKKbwyBtoYTvXs4Nkg1zh1/A510aNemx3uGo4zzM5jbZ7R0UifBatmDWLvgqs+Bz5X/ZyaD3tR70xOwjlzdjx9N0FYTsraNY9sgr1H7Ryi6Rs6kgAz0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GRkaKhwSFn7V7fhjd2tOFSMr+g62GrRYxCIRtk8q7aQ=;
 b=KRBtNMp2vSBZyDvLTKC/DwW6P35D35UHctNTl5yUeI5pUTzzt7M78VtJtO9wVSKlkb+/jCVOqxTrQl8LLgGT5WruQUo74TRT13m3G/i02iZdppSGLo0zyewTtQ3dDorT7pIKDPN3OiS3MDMPbaxWSB+XiiFSfaZojcMunwNmHLQdUgBqj358DHxSLPzqX0T78s1648Nc2YbK6YUe3fHSV3W6SbijkRYspBO+xcWRufde5uQ2fLfFE3AVMIUAJC1Z4sOkLQqneRa8fMM1Dzjvi11nre00l+0Ixh2WvRTzTtH/HSsOxXEx+lSrUhUjPpo2Ot4KwTlbWx5o9nqEuOetUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GRkaKhwSFn7V7fhjd2tOFSMr+g62GrRYxCIRtk8q7aQ=;
 b=MS+WeshW5cB585ce+3jwTy14QdBLRWA+/Chm5TJkNtvkrQvlKw/eRmaGBhJyvT+XA8FqRMOjm1LyM4hQj56RnM017Ad07yppszBdfwXjmVKMJ8UJHk/beE7fqw6vkrw8UJ3i+WA+L7ZWWQW28woqgeoLOacCSiG+Fklj0eSpccXojG4OqQETrOVgmHU4CSr20VzqbpuhoHixunz549L7k9gPbUa16oUkPjeGcfB1SEmGsK889d5YJIXODn+cTWbGIEW0JcJhHi1GdYXPwEJXcMh5z1tsxR9RBk3KsBZUgztB7Id8RSQQQsoS4Ic6NZupJT+sXWiJitdE2HU+6nexHw==
Received: from BN0PR04CA0157.namprd04.prod.outlook.com (2603:10b6:408:eb::12)
 by SA0PR12MB4367.namprd12.prod.outlook.com (2603:10b6:806:94::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 15:54:28 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::e6) by BN0PR04CA0157.outlook.office365.com
 (2603:10b6:408:eb::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:27 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:21 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:20 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:18 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 0/9] Take devlink lock on mlx4 and mlx5 callbacks
Date:   Thu, 28 Jul 2022 18:53:41 +0300
Message-ID: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10fc5eb1-aaff-4d3c-5f90-08da70b173a4
X-MS-TrafficTypeDiagnostic: SA0PR12MB4367:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nLHOovMp3FTbXiM6QQ7w6/NYGamcC6jAiXZmeWYDoxlmOyOMJBQMwFnFnP+547jpOdnJHSNXG6e4ycwGaKQgNqNznsE6EBgBjf8QhaL80Kl/JiOP9qo7FMD8laJ+uNPLfmcUQUZaf2SjzCPxdGU6CG7u5v5hP7lo0nHo/6gi+3b6pjhfrxf0fqmzD7yjYpYzz/45Krczukj1amTVdNva7lxrFrz1OAzHvpxXAsnBqO6kYfYYnrORoDh7Zm58h19X16ERxksa/IcNQp/0avmGC0ir7nBxa4VeEYagzaefTxzYw7OI5s/+0vDE+CfX7GHoE/mxB5GSHdCearuJpCVzB7Sp2C8ErMuwGg5sgHs6R92YrPUXtZBiEnkyMbCAH+S/v/quhxjygtwvICFImuVSYEx86wq9aklnTNqSbGz5rbQb2tSRRw6K3rsfi4gQE3/wma0IMUxL/W3C+Y6Q9ns8CZ9a6kLtgnyEzLEKE6WAJwXKsy9NQuVDq+QXzvhK0uZEH1vgPLtsYOIyJgQ5MdHrMFCIriWAhEFOQR6ECiPa97GCIxZpdRL7NTkR05S9y8yEOlRYE2BAuxo+7RwVOQ/UrM06XW8cTeUwgTIQwT/HFwY2sckBfwx9xtvvOwHXcOF4BE/AaYP+7wWBC1JVRGKNTkLUmMiPqYNFVRacnkffaDD8p2V7j2yw+6gK4WVTO4mhdZh1Ti1RjgKq//FNCTxF3l9x3eRiUyqZtU9MRkDd5Km06Qf+eWmZXkeiMKVTR1yiOJd3xM/l4pqpxhAs7nTeAmKbm8VY/pPLiTkYui2LVsANwzVx/kMFCj9mN2lzdDZ8ATjumdz5HQNLIwWw9EGGZQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(40470700004)(46966006)(54906003)(316002)(70206006)(110136005)(356005)(81166007)(82310400005)(2616005)(107886003)(70586007)(82740400003)(36756003)(26005)(83380400001)(36860700001)(40480700001)(478600001)(8936002)(8676002)(336012)(7696005)(4326008)(5660300002)(47076005)(186003)(426003)(2906002)(40460700003)(6666004)(86362001)(41300700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:27.6146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10fc5eb1-aaff-4d3c-5f90-08da70b173a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4367
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare mlx4 and mlx5 drivers to have all devlink callbacks called with
devlink instance locked. Change mlx4 driver to use devl_ API where
needed to have devlink reload callbacks locked. Change mlx5 driver to
use devl_ API where needed to have devlink reload and devlink health
callbacks locked.

As mlx5 is the only driver which needed changes to enable calling health
callbacks with devlink instance locked, this patchset also removes
DEVLINK_NL_FLAG_NO_LOCK flag from devlink health callbacks.

This patchset will be followed by a patchset that will remove
DEVLINK_NL_FLAG_NO_LOCK flag from devlink and will remove devlink_mutex.

Jiri Pirko (2):
  net: devlink: remove region snapshot ID tracking dependency on
    devlink->lock
  net: devlink: remove region snapshots list dependency on devlink->lock

Moshe Shemesh (7):
  net/mlx5: Move fw reset unload to mlx5_fw_reset_complete_reload
  net/mlx5: Lock mlx5 devlink reload callbacks
  net/mlx4: Use devl_ API for devlink region create / destroy
  net/mlx4: Use devl_ API for devlink port register / unregister
  net/mlx4: Lock mlx4 devlink reload callback
  net/mlx5: Lock mlx5 devlink health recovery callback
  devlink: Hold the instance lock in health callbacks

 drivers/net/ethernet/mellanox/mlx4/catas.c    |   5 +
 drivers/net/ethernet/mellanox/mlx4/crdump.c   |  20 +--
 drivers/net/ethernet/mellanox/mlx4/main.c     |  44 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  19 +--
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  59 +++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  18 +--
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/health.c  |   4 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |  38 ++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |   6 +
 net/core/devlink.c                            | 135 ++++++++++--------
 12 files changed, 227 insertions(+), 133 deletions(-)

-- 
2.18.2

