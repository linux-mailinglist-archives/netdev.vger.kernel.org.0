Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15B9357072
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343785AbhDGPgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:36:49 -0400
Received: from mail-bn8nam12on2067.outbound.protection.outlook.com ([40.107.237.67]:25537
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233984AbhDGPgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:36:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2MyOYgaTuOYUE9frzIcLbmEWBB6jfYP5dBzypHVJGhpjETHj9itq0A68GLBf6kIuzPb8AJujVJEh91zmCIdB4UpR8EdSu0NYVBa77LNqxnjbX87YdWN18wmwn9k/O2GzAPU5Kk+JPt+jsrFR9QkKXSQrH5RllDJAYXGHlHBG5lHYrH/ofTOfRW7TcAVl7p5NxIwC280EwE8KZZPRm/bPlViqWxrWkXYsxfK7PGrjWRk4hOEJ0B/0GlhYzjYc2kJ8to2koi89Z0vuz9j3YW6ozXibRFa5W7PaYOXsf45uyDZS1CvEgRF4hgTkJHNKQI/Te8tvkXbVi5hTB/LSwYkiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGNvQSk03x01IyuQGBIlujmIBHELUpP0ZJQfqnokdSg=;
 b=Z1qxnNJb1hDo25lREuXAHYi5PmqekHtKOydsrhUEetp/cCEqtIvLoibw9oGX4v9WXD3syTrz4VZ9bnskPZjQw+vYnGfmVuL4BYz5R3OsNEl2hnxAerNMjCvXrLDulXABN4d8ZR5f1eQUHym3zLcInkROT/j6rjrdsB4xQkRoE0BaP/qXVsKE4xchgKgPrY08mQbnbobOItWcIIcKseZVMkYa3LJXityPA9X6mx2oh2u8AUTIbbFnT318/1AchyqhCXS2oblk1zbamRUzbXqOYfbNuo32HV1aZG5B0vB65+QPu026Ny3cPpeqa1aJuGUx/UML61UhA1tlwuI21dAB8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGNvQSk03x01IyuQGBIlujmIBHELUpP0ZJQfqnokdSg=;
 b=Ik8hugqOfGHI7l84byuKA4/W+HdDiS3Iu+3cfK7u/LBuIcBDvAQDXkKSlBczlNqsOboC8wXc3WZKTzI1wWUqMS2rn8IBOm7D6nPJqzkSMupR0IdBC31LxCgxlM36l/sNtRNd93r9w3LBz65ad9BD36OTUjVHCJmTy1gUm+6E2Jf5KDNhGgFSUnveHQsqZss/CNybxz5oz6p6xNjcvHVVpsh2sRa/TPVe9O6uZuvHAGDfjuwex5awExTNt4fuO4mUX1r7YK/I58Ip+Ss3PVhGZBlvIoJpLK3EETqipbvGoYJJZHgixM/dj2t10kGwkNeMpqQ7iCAak8b2uCy6+mR93Q==
Received: from DM6PR04CA0001.namprd04.prod.outlook.com (2603:10b6:5:334::6) by
 DM4PR12MB5086.namprd12.prod.outlook.com (2603:10b6:5:389::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.18; Wed, 7 Apr 2021 15:36:35 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::7e) by DM6PR04CA0001.outlook.office365.com
 (2603:10b6:5:334::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:36:34 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 15:36:34 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:31 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 0/3] Action initalization fixes
Date:   Wed, 7 Apr 2021 18:36:01 +0300
Message-ID: <20210407153604.1680079-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db1f28a3-1adb-42b4-5770-08d8f9daed26
X-MS-TrafficTypeDiagnostic: DM4PR12MB5086:
X-Microsoft-Antispam-PRVS: <DM4PR12MB508678810CA95E397514CC8BA0759@DM4PR12MB5086.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Dq9OCrBrB7Px8yIbOFy5gPQ/7gsHbVmB591v5w4WM20fBuOHH/trXQBTGW7exQ2WjG1e6teRg4qimLlaM5bZMVgCheUUQkuBW/Q97WamW8HNvTN28vKN0frv7pDsJ+OX+yAuYPhpLydodmsoUt9MJlXLWSP7Ozo4yXNrlHwZ0w+CxOOal3hEoGnj0d0z9ur1Gv1KRRDyNZznCPkzfBsjLNOLCw5vsVY5jn8j+BvTrsrceUN29x21nO8Gr3VO9GjSSbqnWlalvzHoSyu/M+IMg52Q624u30YP9JI7x80Yl7nRndEgbuEV3MzrKSucadXNElJlowUraRzOi/Be+ebATgnO++Q5FDiJkkTkGl0ErWUskInj0Le+1/7iYOsh/Za/ahJepJ5I1D9pgvDL9NM47aw34eAfNwEaT31QH6Kpz8DfSx0+xYIoD6GNdY0UdZjcudjPxB7VjXLzNcERYoW54ybEz/XCnbrrlQ1B2W2OWxPgQLNTNrvS0I2WWQKNmnzwpIAD8P5Hw5v3hUnlOA4Uobm44zyfJX6TWoM+sqn/p7vzt5pZMfs6Uvb1mwF640CGBO7dXOQxwbKkl1lcWDZFy0pdjBcXFzw5FVeG6gKDODtF+gN79in/dGEy3+4y8bqqXE+Z2gZNyqiA7tm7xzDlaUL037wZSs9goNtginnAi8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(478600001)(6666004)(8936002)(26005)(82740400003)(47076005)(107886003)(70586007)(70206006)(7416002)(7696005)(54906003)(5660300002)(83380400001)(8676002)(1076003)(2906002)(82310400003)(7636003)(356005)(36756003)(36906005)(336012)(36860700001)(2616005)(426003)(6916009)(316002)(4744005)(86362001)(4326008)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:36:34.8765
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db1f28a3-1adb-42b4-5770-08d8f9daed26
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5086
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes reference counting of action instances and modules in
several parts of action init code. The first patch reverts previous fix
that didn't properly account for rollback from a failure in the middle of
the loop in tcf_action_init() which is properly fixed by the following
patch.

Vlad Buslov (3):
  Revert "net: sched: bump refcount for new action in ACT replace mode"
  net: sched: fix action overwrite reference counting
  net: sched: fix err handler in tcf_action_init()

 include/net/act_api.h | 12 ++++------
 net/sched/act_api.c   | 51 ++++++++++++++++++++++++++-----------------
 net/sched/cls_api.c   | 14 ++++++------
 3 files changed, 42 insertions(+), 35 deletions(-)

-- 
2.29.2

