Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428ED4D4E45
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbiCJQO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiCJQOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:14:25 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAF9D4470
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:13:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IU1tm0sj1RwcukJpuCD7ypboNyzq7brWdaonJPMqVttsiTlH0kH7e0qTOM59W+30xhA8baoe78C09MxewWRvugU3TgfbzSG7BdH6jXj+8a8dcBZPS930YfahCGJ3AEd8ECDVQCTSbJ286aj3CE+ddyFj0D0PrdRBAvJ2D8GcVfvxvKDq5PXdfeee1LL1BAIibAVkUJ2zhFBRmfKd3IPtbk5PzR3EDD7XzD+BH/0aNJ9eGdPK/ID+x5kukG7B3UxE5/ndg/JjKSwamie0/SSPfWs41Vw/lXeEbiktuua6ehH2fYNEEE2mPeIwNHHXqp0qzDnU81jt01w1E4tZ0jMyrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o2T7P2YXwuwPFFGIKLSlZEK7dVzBXZ3cRURf46GaBu8=;
 b=djmKlH+jVK5y4cAWmVj60NhKDyS/YGXTaY74FNFX3SSpfjhd4RodTAEU0oTcvPxW+FUap+ZXPSuCGHVW9kaG9bOY/UyPTqksiuCmjpz/O3y/50tZWjPbNcmokUHt0Wwd6TrRjB6hjDipTCBelHOAt7U5RwfMotVoSDKkRPku6Gwkq3V2J4gi2T9WgysWR0nvz06xAtJESf7ojediLLp4br2m8W6mTWYXryULuguizafRyegvXduSAHyejrRqO14qJj0VPtZ6/l/yQwqatK2qnyuNeXm/z2ngaqBrJgKPR/TDEPHZiC6YZ+34VBO6gLBYqQhgH2u4kXU9JNdzDhoIdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o2T7P2YXwuwPFFGIKLSlZEK7dVzBXZ3cRURf46GaBu8=;
 b=Dz/VLjMKuBW2PJ1Uz25WzHvdBUO2rFegoXoL4rMGSWaHvLjvPVsoQHYKp+mTRyqP5GIIeZ9h/ERswFkFwYtcWEu9m5Fe932clTOd61W2L/SHD/Xj2J4+P7zfpn1YsCf/5FOabWMbRU2CX0M/79FGUUL7wfqutxhj78AVQZt0rXoX2PBIgAldrOcCpdYpHEoKDCpFfcT1dIhokdtkl/RPqW/XqrhLMTyjtk1TrkRYtT07uYd/Glce+n2D/jpufeeMKJ9uaVQC5Oh/rL8aEIZ4XUsEKxfmM8cmpOc/xkMW/M4NJYx++cGcosCuj2yjTljjtl9//+hszOuoQAU9xsBZdw==
Received: from MWHPR20CA0002.namprd20.prod.outlook.com (2603:10b6:300:13d::12)
 by SJ0PR12MB5662.namprd12.prod.outlook.com (2603:10b6:a03:429::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Thu, 10 Mar
 2022 16:13:21 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:13d:cafe::39) by MWHPR20CA0002.outlook.office365.com
 (2603:10b6:300:13d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Thu, 10 Mar 2022 16:13:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Thu, 10 Mar 2022 16:13:20 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 16:13:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 16:13:17 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 08:13:14 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 0/3] netdevsim: Support for L3 HW stats
Date:   Thu, 10 Mar 2022 17:12:21 +0100
Message-ID: <cover.1646928340.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 561aa7b5-8790-4551-5b87-08da02b0e546
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5662:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB5662CC5ADFAB83B38B5F0D83D60B9@SJ0PR12MB5662.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gHMVFBXbDT6x3+54SsGK+KJ9K4MQVT5JojDOCBY0fHazrNgDH1g5XTJ3EtPxu+kWQw/vIUGXcbCEaw9MT7Sf5RhQOb6gPUkIDV3osK742s82rWqtKOaTZChuvH/e7t1yEMu328bHVFqUxWCrfXBOmsIcQVUpbzAyp9P4ubL20wc3tu36TAHMQ1LBjfNVuFhBMauZ1vshUeKr4zEPChDeZdD0XRUO7hEEqbTMg4R9MeMRX4cy15aypuGuDvM3FNhm4z+4gkVbTZiAXyeG2sAP/0m9nS29w60jzSYNh1/364cNHoOOwUKxr23fk5iWEMo6Ki4QwwItSfVp9haKvZ00rlv4Rwx5qwTLa6jvQkFYecdvLLqbHubG1R8B2ZNKS6KBfz3Jhb9xikT7rlIUCguxbYMwTquXDuCRlqGCt8kWDQiljT17XmBZ9/uLFAs0EnLt1QpKo6HDDceHUZWs6IWoQTFBkOcfUYdA31xXzTmPyTWj2a5G5cYQDOlpTpeZlDvNH6VBJTBuc12Qt+DPlf1HBOfH+TcElaIG3X9W/FLPIgYYBApGVGKIULH6SIegsMYNwT9+Cd7K4wj9PjNlrv0PADQOxq2+CFJJFh60AekmT3DwioPHsuYg5QOUy9Wnq1UDO+N5L9xjBr8sFhL6+UM4T77Pe3oBbWiuBbpR7vrgDYD4Xb3Kbu0ckESreSPlD9U2
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(107886003)(54906003)(26005)(82310400004)(4326008)(8676002)(186003)(83380400001)(426003)(508600001)(336012)(2616005)(16526019)(36756003)(70586007)(6916009)(36860700001)(70206006)(6666004)(356005)(7636003)(5660300002)(8936002)(86362001)(316002)(47076005)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 16:13:20.7002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 561aa7b5-8790-4551-5b87-08da02b0e546
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5662
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

Petr Machata (3):
  netdevsim: Introduce support for L3 offload xstats
  selftests: netdevsim: hw_stats_l3: Add a new test
  selftests: mlxsw: hw_stats_l3: Add a new test

 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/dev.c                   |  17 +-
 drivers/net/netdevsim/hwstats.c               | 497 ++++++++++++++++++
 drivers/net/netdevsim/netdevsim.h             |  23 +
 .../drivers/net/mlxsw/hw_stats_l3.sh          |  31 ++
 .../drivers/net/netdevsim/hw_stats_l3.sh      | 421 +++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  60 +++
 7 files changed, 1048 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/netdevsim/hwstats.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh

-- 
2.31.1

