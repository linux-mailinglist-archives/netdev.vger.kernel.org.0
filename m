Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 220884D8658
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242063AbiCNODC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239112AbiCNODB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:03:01 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2050.outbound.protection.outlook.com [40.107.100.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD2F25C48
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:01:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSum3Bk+SXX3JiPFkehCxL1qH6UDWzl7PN+CKhUVbIf4a/SPT+PzmIV5ibfK2T3QJLVfncOToYSMZjzzc19Z5LKZ8SRz2k01uiC0zsm4voFZ7txtEbjSHUxrDgEq+3qfX2Bfn/LxVc7WxmEgcWUL5AP1p1snvC8dGNNxTVSluFFFdmQp/1m6Om0exOj4QmY2hkPBJItV9MgVQbFGskG9fCQ2a9KnU5Ni78titaDaShGptw9BVWTBdH9Q9x9EAr1ZHOJx1T0dfdkxzIG42GPNZhsQEVXK9w21xEV2WHAPHxHxAm+bZNG6SuYrSYJOCF6h1/KNT++MY3AHmx8FDm4qsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qab8kA3QIgvtuctaTYFGfRHdOnONav6pzr4kkObZPo4=;
 b=Cjq3htj9GAqXip4aM2sg7GYMZHu1F3MjUUoom5opkTJlb8PLbXaqWjruDwxfIw7G8cst+XVhYa+YethzhjqjY0x1lQXB2CMm6dErYNqDQ8eWuBQRVdpNbxzNjYMesceinvVR092F2XQP43bxfZYRKu3x8XrES2Lfe2gIULqsG+CUErsfNiJg+yY9jyjxkJElMY6p8pOkRzd+xhsuN9XdI129lFe6qDzc+RqT+2U59j959s0so3hhOi1Oh2D1/vqdl9Tr9NU6X/5nxY0zrRhjFwHiSM8Sh8QYKF2/6o6szAeRpDWFUKo4PjaH2vwa/QXEkM0z2EIjDX56BIWk1C6EfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qab8kA3QIgvtuctaTYFGfRHdOnONav6pzr4kkObZPo4=;
 b=NfLgwVTr0iYT0k1ZhhjLHC32LMEWSh5DB2r08KnMkTqZct9IAufJNA4anTP18WRANhtlj/Lg0LmkFRemawmY7iiPX5DapJ6y4Pqk9blNX16NHfmJ4d81tfvjZXypRKpFvHWDUR5BFWn7tCy8qADtq58tRqpeSuxyTGXxb0vxrK0qwjOaIurvi5RvuTh5ZTerKv1nVlrF7E0tGZteVdODcet1lIDKpIdNFkt2UpXaojIHv1w3aaKwYwBd9TViDPnTz2Rljj4BNWA5HErwMBtkUPuFWXFtj/QYN8bZC27ePShQ42GZJP9OnReYGIVD5mNJOLB/7VxJ18mfiezSrL7yBA==
Received: from MWHPR17CA0086.namprd17.prod.outlook.com (2603:10b6:300:c2::24)
 by MN2PR12MB3438.namprd12.prod.outlook.com (2603:10b6:208:c8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Mon, 14 Mar
 2022 14:01:48 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::72) by MWHPR17CA0086.outlook.office365.com
 (2603:10b6:300:c2::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Mon, 14 Mar 2022 14:01:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Mon, 14 Mar 2022 14:01:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 14 Mar
 2022 14:01:40 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 14 Mar
 2022 07:01:37 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next v3 0/3] netdevsim: Support for L3 HW stats
Date:   Mon, 14 Mar 2022 15:01:14 +0100
Message-ID: <cover.1647265833.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b0b9b4f-e058-4cac-5f1b-08da05c32ddf
X-MS-TrafficTypeDiagnostic: MN2PR12MB3438:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3438F5C92A9867E298DFE4D0D60F9@MN2PR12MB3438.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xrq1E5eU6PCYI+xJbTUctuIJfyCJTPNlby2qBicjPSKKm517u3lg0+1djB9fiig+dNW5v1SRdFBM+6wk5jsi16RUrlyv+W+6NWP7hoBtHjoRkezKiaVcjgxZ9xaZP33G6OHuaXzFSW1i1o/XiYtBQrUKTs5jhCyUd+IwVouJ4FTOXXh9APqhSbvoqqSyncyHBy11iNuTnVYMc332ChmSspqOPHHJIaIaFwLlzoPjnyanZWsM/tBXnl5uxGLKMf1HR1lVZz8pIv8MM4lNJRNdV4ppXn2t9Gw1LZ4q5S4r7vd6CV0xeDf6tqOjAzydNpvfcjkxMelK5L1GxofZDTTehOiuPYrd3ZaxgUY2Ysi79AI9tXGjxTnsZDBodzUfHB/VYUDCqHkVfEDlXmwfp7M+hcKedJhgAt5kLS5U+JbYP3pxzqyLMGHa971TvUEtcCqGjFGY8zOsw7/4LvVLNQJexurqlpvsIQWn/3HOn0wsD6j4d6VrF7WGJfUXlnl7OPr7bG1O0XuPaDR4E7NsbLqqgjp++/rVTJFmi5rEEyxOBvxNYLiuKo0ro8IlTvuHtEz61Y83cAIZKTthW4ptfm//xCbt8Uw9obEJ5wsjTN0eQM/qoIYg8XAUzIty/DwJG1HkkaW5AkJ9BOUlcqc7y1f4wwXXRnLT1j2Wf6kYJOproBJtOwtMNAlOc02v/F5ysxzTnlLEl88hjuQnt5g7MH1Jmw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(6916009)(54906003)(36860700001)(316002)(36756003)(70206006)(70586007)(508600001)(82310400004)(8936002)(5660300002)(2906002)(40460700003)(8676002)(4326008)(356005)(81166007)(86362001)(16526019)(426003)(2616005)(186003)(6666004)(26005)(47076005)(83380400001)(336012)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 14:01:47.1940
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0b9b4f-e058-4cac-5f1b-08da05c32ddf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3438
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

v3:
- Patch #1:
    - Rewrite the fops definitions as macros. clang didn't like the
      previous approach to reducing redundancy.

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
 drivers/net/netdevsim/hwstats.c               | 486 ++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h             |  23 +
 .../drivers/net/mlxsw/hw_stats_l3.sh          |  31 ++
 .../drivers/net/netdevsim/hw_stats_l3.sh      | 421 +++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  60 +++
 7 files changed, 1037 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/netdevsim/hwstats.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh

-- 
2.31.1

