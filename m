Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EB846399B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243244AbhK3PRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:17:49 -0500
Received: from mail-mw2nam12on2079.outbound.protection.outlook.com ([40.107.244.79]:7584
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235807AbhK3PLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:11:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sk6GfRj20dbqtAUecnYLBJUwyY9ecFvZIqNcDf2AoOlWljlzi6ZaT0cN+C+W4GjJ6Y731BhQuj/AtOK5b1HxepIYA26h82fvVSufHU4mM4g7VJjJF6GLN9WPVQ4zwmy+y4+mxCyoGEMGvHd3ZiSrVpC9dtxU0Oo+djw+hlQ5D65Brsmh0pbhqLgKH8i4yitmzbNSJHk+Wy92RpaCFhhJFl1mg8dzCGyFHlQQjc4OltCnwEPdnRo9rHnFllSxgb31VXbfUugYszKt01P3Ip5QhDccLlaoHCHciM/3ZCfCmtrmqSd3gwjxonTCvP8uoS0PkytXpHiVosjIDeocm0qhlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2qU2e2bzjMViJ82lZYXOwhqSmWe9mQ8rYHPSD9vcvs=;
 b=F0d69mgtVW453N400vTeUGk5/tr2yX78STRXKLRYq4xWdDh3cAD+YLdSbUYTi+eoInSl4VhxJHjlPo82CSqFmDLsKjEASkH246jGs7P19LjIwQPP0O/Ax7p7ZyWQjo+gABmX0JjC7xgVPCG2cW/QnxCph++POY7zg+41v1QbbKjso00IoWl02Ke5Qm/a8qGEO9FR7f/8TEl9nyRCInjOqRPije240XyuFfeuzekTlxD5kwXYCp/DaPLNthyOTDvO05bPvrH7axmkwTP0yHEeNowaFa2cRyfGfM+AEJplGCddBVD5PeYem93XlClKWvB2tq+JQmG9YAUm3N02/wRMOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2qU2e2bzjMViJ82lZYXOwhqSmWe9mQ8rYHPSD9vcvs=;
 b=aHmUJcA5oCeETR3lyvlfGIwobt0q33rwQs/DONsJ+QT5+zPVA10PCZ7NYsuf0mn6E1SsXwAiq+jUmfTitE89B1GOZJxsp6J8Upq2aU0j4MYr6Ipv2eMH6Kzwcdn/CXAKfMBVJghVwjNdztzsj0+ys0gLzk125gTJw+D3A1yY8t6ozaDBaxSxuH3Ro00LuS4PpTyBFB9ZQAlMukGMfLVj9NWVJGg4yFxJbbBhuYxlOAK/ekXVQ2nzzjcQCdvY2x4efSVyp8gqyNejbC2BknLIotNn6ekka5vXnG02I65IxkWTL4s4pKEqJ9PMk4hExL922lhZPMchf32lelWLH3u1hQ==
Received: from DM6PR11CA0017.namprd11.prod.outlook.com (2603:10b6:5:190::30)
 by SJ0PR12MB5422.namprd12.prod.outlook.com (2603:10b6:a03:3ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Tue, 30 Nov
 2021 15:07:57 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::ce) by DM6PR11CA0017.outlook.office365.com
 (2603:10b6:5:190::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Tue, 30 Nov 2021 15:07:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 15:07:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 15:07:56 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5;
 Tue, 30 Nov 2021 07:07:52 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Date:   Tue, 30 Nov 2021 17:07:02 +0200
Message-ID: <20211130150705.19863-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52778e60-f8c6-430d-a6ea-08d9b41330f7
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5422:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB542230F41A701DEFF42571C1CF679@SJ0PR12MB5422.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drGMK+HCl7Imnml3RK+REoar88R5PYJs8Eh0EDlSYSXJSOYjL93gIXZg314E934OOdC9M0nYjvei7ES524Pzy6jRxDoF9/DnbU/rbLmGeN53dqZJDWvfQ3PXp2Y0Us+9HQP8NjPxwFhTgm7SyA1D2ljCemnO2HWngBJUfbuMwK/UC0VdwcGUQ2a/G5ErlVkcUgzMO2UKviHadQQuMzwXvRnpYg2G1qolISsPIcC+9KJ4CGcmoipZ/qdPRjgB49fDjDgfqb30VpGR+UWEute5N/tED5T4CBRkVJ9A7w7LGJ0JHxZ6Y5jExwJwlytiNNpTBQ4BSULcczUBmKbR/BQakrLb47DXwxQSAVsIwmAQ9MxtZumRs/iQvTggXgLqe7ibKUlZYF0po0n62HgKJmPApBxrDCfG2XD8dasfDaLpUyrSknMvWDIFcXfQXDO97LSfe+8lky8oU5+TnzifOQVwMYS0KsohLFRGF0ZL2OPubJqtE+2LgExjF/MfqXz5rN1CwsZHdEQtaQs6r7QQwpBximXQgiOaow7vtgePjeRPzCkGaoUdJqDeEwaexBOGtDNH6piokbyBZTAkFh3t/SlU5438PFWZSDrT03gA/giVFMyeK75dIrHvJAFQwy9VQUyLeP8LC36HjGnUY0w9jZ6D/ln2tkjSmB2BPtY8FM6JWYBm7idhSAL4zgP4u6G78O5cmj+8knZeMILRXZYxkNVRwpQ+c3TnwKYIxloN0UDUUdh4y9b+wZk19/MYPjm7ljkW4ZdCDBwTZZ3tOqXX6akHqg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(70586007)(2616005)(70206006)(26005)(2906002)(7636003)(16526019)(110136005)(336012)(47076005)(1076003)(36756003)(83380400001)(426003)(186003)(40460700001)(508600001)(86362001)(316002)(6666004)(8936002)(54906003)(36860700001)(4326008)(82310400004)(356005)(107886003)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 15:07:56.7321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52778e60-f8c6-430d-a6ea-08d9b41330f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides knobs which will enable users to
minimize memory consumption of mlx5 Functions (PF/VF/SF).
mlx5 exposes two new generic devlink resources for EQ size
configuration and uses devlink generic param max_macs.

Patches summary:
 - Patch-1 Provides I/O EQ size resource which enables to save
   up to 128KB.
 - Patch-2 Provides event EQ size resource which enables to save up to
   512KB.
 - Patch-3 Clarify max_macs param.
 - Patch-4 Provides max_macs param which enables to save up to 70KB

In total, this series can save up to 700KB per Function.

Shay Drory (4):
  net/mlx5: Let user configure io_eq_size resource
  net/mlx5: Let user configure event_eq_size resource
  devlink: Clarifies max_macs generic devlink param
  net/mlx5: Let user configure max_macs generic param

 .../networking/devlink/devlink-params.rst     |  6 +-
 .../networking/devlink/devlink-resource.rst   |  4 +
 Documentation/networking/devlink/mlx5.rst     |  4 +
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 67 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.h | 12 +++
 .../ethernet/mellanox/mlx5/core/devlink_res.c | 79 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  |  5 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 21 +++++
 include/linux/mlx5/driver.h                   |  4 -
 include/linux/mlx5/eq.h                       |  1 -
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 include/net/devlink.h                         |  2 +
 13 files changed, 198 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/devlink_res.c

-- 
2.21.3

