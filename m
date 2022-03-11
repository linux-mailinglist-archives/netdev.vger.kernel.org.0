Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3F84D63FE
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242539AbiCKOot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 09:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350073AbiCKOnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 09:43:42 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9EF47AF2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:42:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkhbwU6o0rr98wrz6B6Y4JKpF0JJf0QVwSBQznt5Q3erNh5yzR2SaagqJEiIDWc5oYtV+OPwIjqFc/lcBJYLhp5BCHIN9lOt+l01Wow/g5jl5AZMnzZsL0tdWdfwIagKE9stUoyTHSC5XRtTtFQf2LVsAcyL0w91WL7TxL478rgLTIYwvR3veD3plzsxY5gjS+gn9qLUbif5lE71yvFP2+2nTLOIQQWq4X44Y2K2pAoE2B8bNZ/5cUxyAA/NJzfyJM2lMV/6G1ne6PRu0ySoWeCf3bVtvIbs2BITI8Ese2DHM8iCU2ASj+v4McWHsXpTO2IA1hWJHlAKLNa9sfjsQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jR2OYXs6X0fv6daUJ2+6YituGpOwH03VRsSFGAbpkKM=;
 b=iG55EEv9bT2LaflLNPSBbh+kft8eiqpj+sqU6R0E1twBD90bIQda82I9sdfNUEoLsXYwSYEIGOu82mWXPfjt8+oO+aRMdYM5s+YC9PdsX9yukilPTVqOSMx5sIGNX0J9p8nbqUOUabfCpa/jx1IL8wyKHoUBGreATxjCSSGKH3h+URygeTUNx2TS5mrJ9T+WdmNl2GY04bmONsVphg1KExeB7f6muQxZf1n8VTatPwEG3QLEyX/b5LpZNN5cYTRY29pRbF3lzOUexnLyC5xb4FJSJxUrGrdr/GPqZt2voUf3iyqvTyqMMDocHPQM2RJW1vrJKv2tWjXj0BRvm7VNug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jR2OYXs6X0fv6daUJ2+6YituGpOwH03VRsSFGAbpkKM=;
 b=B5DBzKY+mRVmsw7FKrPxN5iKxy4j46b8HsYc5+IS2H/nM5DwsUMn7Z3cQlE3iuqmJ9EhEFXjmdChDe1qRmAOnlklH8V3t1gseBmn29gYeQyX6VBikMp8tc50j656GqOYWHOOhOSZhNDgLjZF6wpJAuucdVUTS9ar9AHr8FrARmef4+aY437XKxOya+2JQYtRQzwwzw89LY7zTQOtzujhf0U+PjZHNmQKTfwcbB0xPGtM+xL5T+LTt29iT/ObQ3dz1tutz+RSxuv7l3y0qEwP9nSIXrlQYxm1pO5PwHHCtNnXM36opMR4c/sc01wI8kbPkPKNy2Ai8llJPdH1WBY0yQ==
Received: from BN7PR06CA0072.namprd06.prod.outlook.com (2603:10b6:408:34::49)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24; Fri, 11 Mar
 2022 14:42:35 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::f6) by BN7PR06CA0072.outlook.office365.com
 (2603:10b6:408:34::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Fri, 11 Mar 2022 14:42:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 14:42:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 14:42:33 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 06:42:30 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next v2 0/3] netdevsim: Support for L3 HW stats
Date:   Fri, 11 Mar 2022 15:41:21 +0100
Message-ID: <cover.1647009587.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3db776c-792d-4d04-c21c-08da036d6168
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB457565DA6750E50FEF63011FD60C9@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkRb/Tw/X5zNhXugVgLxtZ8neAZi4FAF7mmazgsfCV0pHIuHse9PH0s4eZ7BRjzWdYGS2wH+bZZehQSqBb7z/cE/LbxdPGVcJno+SBJaJRXK3KQms3r43agzGyMbmqhHNzH//VUn35vlmw2UoXlcGMya4mA4flv3GWhCFCsy7SWY8OIihG4rgxiSy2ZQydfa7cKSgTuSM6A06PV5wpdhSxuFAY6t+U3/W3MDNezjI8vt4/n8I274x9Ty74QfpPQv9lmZLcdmX0R3/QGQQMCj+aU4s/mlOmwYL1jwgN15t30OuEGVmLq/4xo+wAMFp8p1oAYW5Zskw1uN5MdYXexeDrqDR0okjyOR5xKAOMHUeRRQZnUyp1ksxLSIHD4A4Bt64MuHyYvrNO4891bd6nIS4MsczR7wvlFjn2cmiaJm2XhrgE046U3oPfpdj9XX9FQPETCkWiiJv/FcOt9mhG+za/T7pzJEULic4VX2dWTWYtFKmQwwF73tPf8y6pXm4kZ1WEpTcEPLMl4IXYAdVBuPYO3qyTomEoIZLhD8xncZOtZFsBjgrLyRC4N3UFpdzF/rWldS5kJhTOF/pqn0zqDot3nlYbMOZQlCyX94zvTJGyrUwMRMRttcI4hw77D8DIIPtkvkpNVDq71fT+eXF0CgUt4YfjolTuc9j9oG82sGL0ewXc3drI5+0a3vgoPAHUSiMye/UJJb59laNbRgIvg+Vg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(47076005)(70206006)(70586007)(86362001)(36860700001)(4326008)(8676002)(26005)(16526019)(36756003)(336012)(426003)(508600001)(186003)(2906002)(356005)(40460700003)(83380400001)(81166007)(5660300002)(8936002)(6666004)(107886003)(316002)(82310400004)(54906003)(6916009)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 14:42:34.5045
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3db776c-792d-4d04-c21c-08da036d6168
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"L3 stats" is a suite of interface statistics aimed at reflecting traffic
taking place in a HW device, on an object corresponding to some software
netdevice. Support for this stats suite has been added recently, in commit
ca0a53dcec94 ("Merge branch 'net-hw-counters-for-soft-devices'").

In this patch set:

- Patch #1 adds support for L3 stats to netdevsim.

  Real devices can have various conditions for when an L3 counter is
  available. To simulate this, netdevsim maintains a list of devices
  suitable for HW stats collection. Only when l3_stats is enabled on both a
  netdevice itself, and in netdevsim, will netdevsim contribute values to
  L3 stats.

  This enablement and disablement is done via debugfs:

    # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/enable_ifindex
    # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/disable_ifindex

  Besides this, there is a third toggle to mark a device for future failure:

    # echo $ifindex > /sys/kernel/debug/netdevsim/$DEV/hwstats/l3/fail_next_enable

- This allows HW-independent testing of stats reporting and in-kernel APIs,
  as well as a test for enablement rollback, which is difficult to do
  otherwise. This netdevsim-specific selftest is added in patch #2.

- Patch #3 adds another driver-specific selftest, namely a test aimed at
  checking mlxsw-induced stats monitoring events.

v2:
- Patch #1:
    - Embed fops into a structure that carries the necessary metadata
      together with the fops. Extract the data in the generic write
      handler to determine what debugfs file the op pertains to. This
      obviates the need to have a per-debugfs file helper wrapper.

Petr Machata (3):
  netdevsim: Introduce support for L3 offload xstats
  selftests: netdevsim: hw_stats_l3: Add a new test
  selftests: mlxsw: hw_stats_l3: Add a new test

 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/dev.c                   |  17 +-
 drivers/net/netdevsim/hwstats.c               | 485 ++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h             |  23 +
 .../drivers/net/mlxsw/hw_stats_l3.sh          |  31 ++
 .../drivers/net/netdevsim/hw_stats_l3.sh      | 421 +++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  60 +++
 7 files changed, 1036 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/netdevsim/hwstats.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh

-- 
2.31.1

