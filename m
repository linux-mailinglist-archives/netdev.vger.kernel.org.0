Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB313375F7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 15:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhCKOmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 09:42:38 -0500
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:58460
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233869AbhCKOmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 09:42:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dvd2JbD7bUyAttM9og+3vXA3lmSPel4DMFmNEPiROBLHUWyX/Z2xNgJOuT+Qt1PGx3xx7pb/Vt1aOzr9+jOOlsdMkWmLC3O6LYX+lfReM6qDgPd4WxxTeTYyN1XnTgQSKyZaH3zWgs5wlb5zg7C+HPrkfhu8Gr3RQV6PzMw7EZws7KL/nnlXdDqiNsOQgh7GPJEMb6b+pu+4YU39GbOwfxGJ0MztHYCjXmTB+MdsgohqTc8WGu22xnpRCUZdTkaa5uvD87Zs9VqLyxQKlWF3mGqogfH7AFvLHxtEP7rReEAAKFEqR6hDHV4UtyUgoP01fzkOmLqNSm280GUxZaHXkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03hwXMKMNgrR5Rc7aBYtBRc3Q47Jow/CuvntVi0OR7s=;
 b=D2GF8nv7g4cdmM/4jHzWfT1DKRLZiDMhK7kqqhjUGNj6Gc75NzGoE8r0zGrmaXnHBXIYG6xdHQwuUk+f39oObx5zvcE0dnDN231A/e9n6TB4dc+UR1hIr6ts+wqn5QYuYZ7rO+ZfcJMck3RboW1/36zjP4Ax0bmr7BGcigOLohSaFrQe3/6i4O8pTBZ5IIZzNq0oyOiyNc4m+Bbl//liWOs8dTj3HlJwXF3gb9pJwWcVOJnVCqvujg108Ik6MDKy+gVrIarzzdz124SiF37v0Qq+sMdKYb1z8yxZC7OIicojnKGczKsbz0FNsS8eei4I8heJTFVsXetFD7qyIPbLwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03hwXMKMNgrR5Rc7aBYtBRc3Q47Jow/CuvntVi0OR7s=;
 b=PM1anU+v/OPB5GQDDDF+JknzuSstflh5YOFWzwPAAetH3/Uk4/iKHY6BkuPVpqXUGoMA7FHKbFuv/VkEzgkDPJbbMauJH8wz2s4S9Aw+zkudLaxpdA8YS50kln5UhwfEzqk1R47EBuJhzef9A0zw/rOFgvkYwJYVIvO+pUxNgohXnQAcBk9HjOkHgQxqvvDbXQ8/xX23F4abWHQ1ujDpkIK9ZKyfq9umnlD3+JTgrjXzkgtko0O67wb/N3VRF3e13PFEYWVIbhcdyHBr1okrQsWrURV/bp4wCAewOoiNoOVzUqOcztZ5s3unidrMSRtw/JF1+7wlj33+Ux7p8IRpUw==
Received: from BN9PR03CA0292.namprd03.prod.outlook.com (2603:10b6:408:f5::27)
 by BYAPR12MB3495.namprd12.prod.outlook.com (2603:10b6:a03:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Thu, 11 Mar
 2021 14:42:12 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::63) by BN9PR03CA0292.outlook.office365.com
 (2603:10b6:408:f5::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 14:42:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 14:42:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:42:11 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:42:11 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 14:42:08 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net 0/2] Bugfixes for HTB
Date:   Thu, 11 Mar 2021 16:42:04 +0200
Message-ID: <20210311144206.2135872-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2706d71c-b010-492c-8ede-08d8e49bdb2c
X-MS-TrafficTypeDiagnostic: BYAPR12MB3495:
X-Microsoft-Antispam-PRVS: <BYAPR12MB34953E54F0C4EDB6C894364EDC909@BYAPR12MB3495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B2BsdypbClHbR6MRYMPiuZJuMcQB7lwuYB0t3gF6f7j216N4gZp3W/QtL6XI6Jyl0zIobp1p+zjtOL8JpgR2/99vM+wjyfz08rK7nHKmaeLc+BwyRMKpGgjUYPFDYmKnn3ZNiM3y72/vLYe/F1UQBm7pMyxWaQls7FzQJrJFl8O5gGeI8Y9tj9LcAUDup9qBMNMPLgl8pBRqEiugXgX7HVxMjOWqqno8AmPW1lwG4bQ0alrKuoeLdLDMfcpWUvSfuasavG5D2K4qx70YEmVM8ijxJCJzaUhTWzfy/3Qv0u93rphKDP7351yc3xaGh19aVTGc5sXwVgCCGtIgb2zfAf1K0L+nsVGbmU+Tdnw2sq+h/Msy/Yrsj75cWqRbEGo5LJVbNFnlOqcd+my6wnp5spJUaFT2uPTb19y//Vg+a9DFbSUokw9jYs1k5zRTkXZDMzQF9zjQ2eWR2k9fluu90lr0Wrxf7a2MWwCJ+ollIX6oAGk0Vgl50J2nkRUMPsthSxtIpnpqU91LdPW7jxNbsOWLf+C8QnjhGD1OeIDVBrlPgOJHnLn9zD7czIf/HrEm1Fkeq7QEDtisz+zLL/l4rm/OWqvwjmnmlSX+m/2ZF+Q7IqT3aKj1trHw8u23SNN8f/+em4z/SfcjLxSbrt5RpqldGAfw0z4BTgv4vPWB5MArgzNiL7XvcGM4NeJCb3ma
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(46966006)(36840700001)(426003)(82310400003)(6666004)(47076005)(110136005)(2616005)(7696005)(316002)(478600001)(8936002)(186003)(336012)(1076003)(34070700002)(83380400001)(4326008)(54906003)(26005)(36756003)(2906002)(4744005)(70206006)(70586007)(86362001)(107886003)(8676002)(7636003)(5660300002)(82740400003)(356005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 14:42:11.9540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2706d71c-b010-492c-8ede-08d8e49bdb2c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3495
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The HTB offload feature introduced a few bugs in HTB. One affects the
non-offload mode, preventing attaching qdiscs to HTB classes, and the
other affects the error flow, when the netdev doesn't support the
offload, but it was requested. This short series fixes them.

Maxim Mikityanskiy (2):
  sch_htb: Fix select_queue for non-offload mode
  sch_htb: Fix offload cleanup in htb_destroy on htb_init failure

 net/sched/sch_htb.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

-- 
2.25.1

