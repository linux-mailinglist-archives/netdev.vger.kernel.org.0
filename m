Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7EB3393E8
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhCLQvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:48 -0500
Received: from mail-dm6nam11on2070.outbound.protection.outlook.com ([40.107.223.70]:40704
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231519AbhCLQvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bo5iE/ZXiMRAaeiOtuxqCq5RXzS6XB2kWB8Vq3h1oUCQV+8xH1cMqseGF5++kG+0q0CuKBoj1XFxshGYyLpXZ+I6mikKv0G0QBT8HmE8Yl4wluMdeXNcEe4lJ2k7nndYqIf2huWZWOIpgjNypqFudKe9CVJvKetb8DOdJZOALS6dp/NqJH1aL7z/SEzYVP4/JB36uQQeCKUMGQhNc0tnDqvN8tkBqgKDqDR/x9RZGYhIj8GAM+hwIfmQ6Bs6vO1HEV225X7sYXSoGxdQAdPlrQeyW2qU1t35rSQN1FtLAUhW41A/KKav/K8TSivoh6jLTmyYoYr0h0ClX396YRMaqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmqO1/TO6AfSncTMKmxygUVI4/99Tj9Zfc6vFd3mgLM=;
 b=Uowk04WHGkTN8a4vKtO5/xsxW/9hRBii28w0AZKVP2jkTSiZ2XqXDHaXcjKAjhmdS+4axBNLRxIMpdw8Nwj7hvbsZVC+K077yrKQp4R81tSVqpJWbMvlES9QPnyearpJz4fjE/Dv7CqCUfoXDgYcWyeagOASL1EXgG8wH4TXLZJi2BLHZnVNExHJN7Dw6959/UkZxBcE97n9EsbNXkYEElNU88RRZ3JxyzTGke6m/ilEIv1cn+n8/vzoomArr6wGd23G9vNiEM6dUJpH88GBQK4/FAkkF3Uz1QtnGgkfwEXzL7YdXcmTNs9S0YtobD3DCWmgO/bzqeMG7iRLK+OJYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmqO1/TO6AfSncTMKmxygUVI4/99Tj9Zfc6vFd3mgLM=;
 b=H3E0+6q9Rh4EADPvXag1xhKDvQj/OAOciqcv44c1sjHu4X5yf7JgOCBkB57xkg33paKRqAdLIS8uTX1pOPFCUE4fb/R1d4pKcBxl5CIS1d1SG8BY+y88vtSXlSX9oxuikM+ID72FqLlP1ChL3uk5MLiAfEqXOxLHgNBr6sUhsjxpt3uQJHM8fxoC1j78ZwDU9hHKlsOEmNvQDrVtwCn+zsGjp5kNYABYwob99ix2jZzjUvgJlmpzOTtOfcKaf252vx5l5pCGzCXEUlXoMWHNXffp6L5pkSDMwGfP2oi/mHvbfYQ2pN+klZobag0TyDJ5LejJSAeyyMBkwacilpgxSg==
Received: from DM5PR04CA0028.namprd04.prod.outlook.com (2603:10b6:3:12b::14)
 by BN6PR12MB1617.namprd12.prod.outlook.com (2603:10b6:405:d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 16:51:19 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::2b) by DM5PR04CA0028.outlook.office365.com
 (2603:10b6:3:12b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:18 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:15 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 01/10] netdevsim: fib: Introduce a lock to guard nexthop hashtable
Date:   Fri, 12 Mar 2021 17:50:17 +0100
Message-ID: <2fd20274b50251496fbbf609584a1677ebe0dfc0.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615563035.git.petrm@nvidia.com>
References: <cover.1615563035.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2d5f8bc-4d4a-46d7-88ff-08d8e5770f05
X-MS-TrafficTypeDiagnostic: BN6PR12MB1617:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1617F5AB1DB1A459B82A3781D66F9@BN6PR12MB1617.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +oE+IYPjGWFwCOOL69NUsRe+Mq0MawrUu25C+MHf0EZbmdxYLcGcscbiMzgctNQ2zbfyyBoGmgJ4TgTb/FQ5FI+Zl/tJszu7xqP5AHRt9or9ox7oeE6kUkJxE8NhZsdAVtDzSb1F0I31e08h8bFh+bnkX48M0GeT2iHikI5WMYKL6u0UrnMSlmEnJrEf/xXb3lpLNYIHCHAsgbC2hrx5UvYbKtY75FvUd6K5GQAEaCDvc7q16QfVG8sscs5UelOs1kgdUzgieoRyAHzCX12eH/Bc0J/osVPXA7h+1TxD4ABIDGg/ZQINntbEtSqoxwxnpecdloqqg+FT0sLUoFkrgOgHLPFzSk7WOmfh7kogpKsvnvzr8/7tjHZnMUNf0deuO+RjBJbFgNUmWtUEIWy9B6VlsvxhmjRjdt1ScTSO13wwi1tRANsX/pCeCiXrM30QRyerPCMdWdLbly0ESQmFcDLvXYgZBdCuJfx8orqgAgQfHJnlGBUMTehd750fH1GimiXKdNzRsOlra38ZI/3WOhioiwPXrF5Z2yv7tTE2nf7TsQfAIN7s9uaasfnPSnTRmy2+X//k1CxkNUV0tq1YEP5ON5CwyyRbt804DvSa3I9GYFzB/KxZqYpfE2zNzUbTg87R19TThnGluEU8vi84WGlr2grO1T5ty3jHYy2/QOarhObLI8t9kf9Vkmgei/Uq
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(36840700001)(46966006)(5660300002)(316002)(2906002)(107886003)(478600001)(16526019)(186003)(36906005)(6916009)(8936002)(54906003)(426003)(26005)(2616005)(4326008)(86362001)(8676002)(336012)(356005)(7636003)(83380400001)(82740400003)(47076005)(36860700001)(36756003)(82310400003)(34020700004)(70206006)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:18.6726
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d5f8bc-4d4a-46d7-88ff-08d8e5770f05
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1617
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently netdevsim relies on RTNL to maintain exclusivity in accessing the
nexthop hash table. However, bucket notification may be called without RTNL
having been held. Instead, introduce a custom lock to guard the table.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 3ca0f54d0c3b..ba577e20b1a1 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -47,13 +47,14 @@ struct nsim_fib_data {
 	struct nsim_fib_entry nexthops;
 	struct rhashtable fib_rt_ht;
 	struct list_head fib_rt_list;
-	struct mutex fib_lock; /* Protects hashtable and list */
+	struct mutex fib_lock; /* Protects FIB HT and list */
 	struct notifier_block nexthop_nb;
 	struct rhashtable nexthop_ht;
 	struct devlink *devlink;
 	struct work_struct fib_event_work;
 	struct list_head fib_event_queue;
 	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
+	struct mutex nh_lock; /* Protects NH HT */
 	struct dentry *ddir;
 	bool fail_route_offload;
 };
@@ -1262,8 +1263,7 @@ static int nsim_nexthop_event_nb(struct notifier_block *nb, unsigned long event,
 	struct nh_notifier_info *info = ptr;
 	int err = 0;
 
-	ASSERT_RTNL();
-
+	mutex_lock(&data->nh_lock);
 	switch (event) {
 	case NEXTHOP_EVENT_REPLACE:
 		err = nsim_nexthop_insert(data, info);
@@ -1275,6 +1275,7 @@ static int nsim_nexthop_event_nb(struct notifier_block *nb, unsigned long event,
 		break;
 	}
 
+	mutex_unlock(&data->nh_lock);
 	return notifier_from_errno(err);
 }
 
@@ -1404,6 +1405,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 	if (err)
 		goto err_data_free;
 
+	mutex_init(&data->nh_lock);
 	err = rhashtable_init(&data->nexthop_ht, &nsim_nexthop_ht_params);
 	if (err)
 		goto err_debugfs_exit;
@@ -1469,6 +1471,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 				    data);
 	mutex_destroy(&data->fib_lock);
 err_debugfs_exit:
+	mutex_destroy(&data->nh_lock);
 	nsim_fib_debugfs_exit(data);
 err_data_free:
 	kfree(data);
@@ -1497,6 +1500,7 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 	WARN_ON_ONCE(!list_empty(&data->fib_event_queue));
 	WARN_ON_ONCE(!list_empty(&data->fib_rt_list));
 	mutex_destroy(&data->fib_lock);
+	mutex_destroy(&data->nh_lock);
 	nsim_fib_debugfs_exit(data);
 	kfree(data);
 }
-- 
2.26.2

