Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB2334116
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhCJPEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:39 -0500
Received: from mail-eopbgr690053.outbound.protection.outlook.com ([40.107.69.53]:22340
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233061AbhCJPES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8K1BEbh3cHGy6QIRs5WuJuvQyHONi1lBSytZmWtwHlxXgxCjoPWcdWgUPwvG99dedPL1acIXKB20p6sZQp8tp02F+6zlXYwCD8otn7G/Gm6rMzTscBXWDz7Fx3SNtC5My/GJNTGd2Km23e6O29a553LaSQckOXSw4kEqJgIiCeZTFt3pU2yV48SdSuZknwVQbSrSgiQuza5L84Wl9AYbcXyTiaFpI7UKIOnryjP2cL15NdUYj6DHVhsUi4VpDawNpOBEWi8aoyCM0a2YTLFrQLdBzv428EQ9ejUjOh0kcEiv4d0/NRU++8zJCMGEruElvQ/SYvaxhMtUrrJ1IVoug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBYOWHwjBsAcyrmK9jrMqyn35sCYgPI27mRUpgP5puE=;
 b=dXZFkafZDq9f0v/0gLOlINCyuNWGifcBR7w2tyJMSd2aQxV/kq1sr/0F4OgVdBcuOTyfHkyjzk+svlvHq0J0A0kuNd1Motv597cO3Ip87qPAPH+OXs34ItZl29ufEOkDfMeiCRauwjfPXeePLZxbdT+JfUIVlQQAUPOdBDAJW6YqftwWB74ngCOO1tpZfrttdvwT3IX1vHvNwLCLOVUD9FJh+zpDT1dpvysUgTrRbMWwoO6iKsoUAW4jv2XXrGFVxK5Ko1/0KB0wFZqjjHrC14nKWAiWuZd0mPp8zY4DTk3ou5LBcK0Q/rU79Nvi1AumSfsX1gpez1PKEghwa79hcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBYOWHwjBsAcyrmK9jrMqyn35sCYgPI27mRUpgP5puE=;
 b=eyTZ7uwIYGfRhh693ygk3U5UpEqEHOxsKACbWfM+Ze08RI4cb3QiTaj+R5sZfoXunFvtdqNix6HeoMFerjXRlPKETVTJIW+qnCir/rVOgX2nZzIj8X/yss99UFGAM9mIZMOXM7Iw3KfNM3ntI44TbZyeFt1Skk1/6OV4SujJ91HxVPvYOkpNlZhf0MCtjGEtr1Zdx3ftChfeCYyS9XXaEcZqpmcoYZUXq2kQTmBVD8DXHaF1qq7HNuswZh3f4YZoI26t4whcGF3iSGSkQZlxRB76Aa5O3M8iRd28fAvaYk5YACXuU4LK3o+p4jMyMK6SseWy8VkpopaNDQl5JtU26g==
Received: from BN0PR02CA0016.namprd02.prod.outlook.com (2603:10b6:408:e4::21)
 by BN9PR12MB5212.namprd12.prod.outlook.com (2603:10b6:408:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.8; Wed, 10 Mar
 2021 15:04:14 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::c4) by BN0PR02CA0016.outlook.office365.com
 (2603:10b6:408:e4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:13 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:10 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 08/14] nexthop: Allow setting "offload" and "trap" indication of nexthop buckets
Date:   Wed, 10 Mar 2021 16:02:59 +0100
Message-ID: <4cc22b59374344b666221f792a28bec597833047.1615387786.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615387786.git.petrm@nvidia.com>
References: <cover.1615387786.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30a2d0dd-7c21-4a47-7f72-08d8e3d5c4a6
X-MS-TrafficTypeDiagnostic: BN9PR12MB5212:
X-Microsoft-Antispam-PRVS: <BN9PR12MB52122267C5C1BDB3DC94CB27D6919@BN9PR12MB5212.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y8CXudbN2F1U+OHxoRTsu8CY5MY9InCfEZGT+N0pNw31zUA5U60OEcgzS48fhhDVC1HIkQLz6sW8zetnIyqDvHuz5SW/FJSSFewnydFasED+cn5sa49P6N3YnWcF/RTNEXeHIz/1NXMMGok+aSaXC2Xn70q1iIgtws7qZLucs2pdhizB/PLvppOGyS0z2lYZTcWbeXcGO0vCpA7wxjF0j+RMMINZu3E7cwqTzdIPJC+SSmASO9RZFENb183IXKoMZ3TqFVjE/XxZyV93WI9u0SjDi+rs9w/CpqNmraGoQuZpczGVSTL2KrKag4URMIo1Jw7AxIgxbYTFxwc7aNJaQVe1kC5uUPe1ZEb6oHBC2A/pOm/ddyPIhrMFQA4j9/VVVibQBUoSDB0aRqvPGKEsDYVHAlN6QKnvAPtzn0IsKXussyANQWYto8cDBD1cxLQBcwH4Cy9+gFkoNbYGKcNOyKcLn2b4u9Y8HRtkhZ56OF51ZbXrHx4y8boDLUWUAzi+HqVjSevTWjUW1YdQ2SNFR4DllzDYuWL5ZhyoNTd762U5AlPlzGitQOZocBIXIwCET8Z2aY7x8U5l70Ai2tdd6FJ9rJrTn3oi611mNHkQyzYYXk7sneKQX40wXjhgwWEXMAeHcMkqgVKVmKdCeVZOxjZfNnGgmtjjVE496yjIg0GWZL3LCQ+45XuBpkMHYB7v
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(36840700001)(46966006)(336012)(186003)(26005)(478600001)(34020700004)(2616005)(16526019)(86362001)(70586007)(36756003)(426003)(4326008)(8676002)(6666004)(8936002)(2906002)(83380400001)(107886003)(5660300002)(6916009)(36860700001)(54906003)(316002)(47076005)(36906005)(82310400003)(82740400003)(70206006)(7636003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:13.7381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a2d0dd-7c21-4a47-7f72-08d8e3d5c4a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5212
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add a function that can be called by device drivers to set "offload" or
"trap" indication on nexthop buckets following nexthop notifications and
other changes such as a neighbour becoming invalid.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 include/net/nexthop.h |  2 ++
 net/ipv4/nexthop.c    | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index fd3c0debe8bf..685f208d26b5 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -220,6 +220,8 @@ int register_nexthop_notifier(struct net *net, struct notifier_block *nb,
 			      struct netlink_ext_ack *extack);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap);
+void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u16 bucket_index,
+				 bool offload, bool trap);
 
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 8b06aafc2e9e..1fce4ff39390 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3072,6 +3072,40 @@ void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap)
 }
 EXPORT_SYMBOL(nexthop_set_hw_flags);
 
+void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u16 bucket_index,
+				 bool offload, bool trap)
+{
+	struct nh_res_table *res_table;
+	struct nh_res_bucket *bucket;
+	struct nexthop *nexthop;
+	struct nh_group *nhg;
+
+	rcu_read_lock();
+
+	nexthop = nexthop_find_by_id(net, id);
+	if (!nexthop || !nexthop->is_group)
+		goto out;
+
+	nhg = rcu_dereference(nexthop->nh_grp);
+	if (!nhg->resilient)
+		goto out;
+
+	if (bucket_index >= nhg->res_table->num_nh_buckets)
+		goto out;
+
+	res_table = rcu_dereference(nhg->res_table);
+	bucket = &res_table->nh_buckets[bucket_index];
+	bucket->nh_flags &= ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
+	if (offload)
+		bucket->nh_flags |= RTNH_F_OFFLOAD;
+	if (trap)
+		bucket->nh_flags |= RTNH_F_TRAP;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nexthop_bucket_set_hw_flags);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
-- 
2.26.2

