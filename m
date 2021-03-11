Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B414C337BAF
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCKSEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:04:44 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:32420
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229965AbhCKSE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:04:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtcQH15eVIXuMAxyXNjmNMZk3UK4U8IMnEGgbkdJQj0owvEbrFy5+tnlWTWa6I7DMrl1wDJfIrbJ1fGfGgWkytd4eYF/8QqcmRvrF4cu3NbF60/8T25rRFmvFwxhmmS6M0nCZvcHia6mAnfKh/NRi8B8+0F5Dz7MdFwpprX3R9o3K8mdRDWhYsLbjfnt1z1BMJVKBZVpCGNqTYe5OPoDNWz0YRRBeRxyxLQsK4utNwWTcWcVqCfSa5V0m4G2QDTzFR1tHkMvH6Gg0sGnAZu67fZR9i2h4zszdVs+FybQbFFIEUbPVLmxtRUrp99y2/JYhwBdkJzjXJHaIpsDcpzi/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFVIDRAaq+wngvGkg1P218mGgt2af8tM0GZ4jHsAg6M=;
 b=SXCYkXC2auaUqXWSFtIFN9nEkvNpt7+vzrUT7qDVxZk0lT+MNpmKiyxuext7eTCHnbZxGb4UU2giPLZvJJeIPY7Y3/I3v1W4jcKAa1kn2rKxF7qK7RWA/qveDH/W4D6ULgUVY4NWJlGlSlHq7tgA360J2C3in5K41kNBts63MUTb8rjcj874qi7V7ZVnMd30u8FTSSZ4WPEoo0/lwMwzpFxS7duNN2pBJO927Fy2qG+QoB8y7+b+OYuyutMR+nMpwr0WAyAj3L+/55oTX3JIrPBnfdFUkgmCu7O5UyQWiO5M2ydXnxWyChGyzqJG5U3TMlvZDCeFJTZroQP/WMGLIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFVIDRAaq+wngvGkg1P218mGgt2af8tM0GZ4jHsAg6M=;
 b=SoHjqxTSZEhF9sNF2YWHff7C4sFzQzr/AMqa/BOCeB3sjC4lqbumbINsFUDoCfkr18a5yC8hPgfLFXJajC0rVzfbsGOqbQqPBa1CBqXgRse3wkn+RWplZNPhcXZ0XYfLu8wwejhC8zWHwBnxpIu5nQkPW1H6GFpChPEqb+qtjVav0xW9OnVziVCrES4IzEP6XioggpUQjLA1BCtUHYxcB1cOHmDlyRxOhxKiPooeX12j+6T6jFO5GRUfcIgrxIA5vbg3wxhRtvWYq6BaiPTNkjg0WAkNROMVEEpQPcMC1Oij9mIJEixvLx2io8zRavbPb6DlPaG7LnbJkIjXB32L7Q==
Received: from BN6PR13CA0047.namprd13.prod.outlook.com (2603:10b6:404:13e::33)
 by CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Thu, 11 Mar
 2021 18:04:26 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::28) by BN6PR13CA0047.outlook.office365.com
 (2603:10b6:404:13e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend
 Transport; Thu, 11 Mar 2021 18:04:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 18:04:26 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 18:04:18 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next v2 09/14] nexthop: Allow reporting activity of nexthop buckets
Date:   Thu, 11 Mar 2021 19:03:20 +0100
Message-ID: <ce46d435597715038c5970eb8634ff5f085df1b1.1615485052.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615485052.git.petrm@nvidia.com>
References: <cover.1615485052.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14efb3c2-b5f1-48cc-baab-08d8e4b81bc0
X-MS-TrafficTypeDiagnostic: CH2PR12MB3895:
X-Microsoft-Antispam-PRVS: <CH2PR12MB389568462C09779F7DD61080D6909@CH2PR12MB3895.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /mJgpwmz9vFkKiureRF53lmo4nUVC3iqwhXHhacDQt9JjyZSKqVI8ZXTyX1F6mNEmLb5VfJ3DMofH9tOYoTZ+CG87VOo+s51wZ2IQSKRb9BJ+afsBRTsE98cixLivlj76phsWSK+K379/VnI6RboO/LDb1QtH/rr4Of3ZdLmH7xvmlGQ2FaakmjcbryhuwjoSr9ju5wvf/cYSrk5HgRJmY8NI6T1m5PZjbzLv/eqhwmxVWqIXyCI41F7rfPEha+uoxuEo20ulWvQeOqAskch4F4YKp9nznXtB4eO8lSbKO1wJBKdrPbCt5ZDzgKxyKHH2vXmf3jYXRLOqoUKZ7CyZElssrIYRcsZa2dhvsxDIzlSSth+txloygtmpCp+KCZBlbxMyfMA1QVff6dEnjupaTZEvOXshruXhrbC9oWFz5ufZ2HuZsa5wMGPn3BNx+mhdzuWnKg4viC5rVcYeW9RkluCqWHl/lb3i1z4HUn8AVkC6C/62y01WdDBZALnoYGAHnXy8XydCzFdXV4BXJ22K7WyHnAwaa5NDg2seMHkT0Fgl49Q9KJV5JWcRf0LPy7hiCFD9vZJxtaOj4E4dZYgvu21qiqbUqeF1JoWFohKi1Avi6F7ezwqktBT9RN0IZufHw4aJHE3ZgurMjxZ2931FBmFF1ZqIj6ElET+7i5tvhfTD+KP6eMaX7SVYTFoPKcE
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39860400002)(396003)(36840700001)(46966006)(83380400001)(2906002)(36860700001)(34020700004)(478600001)(8676002)(36756003)(356005)(82310400003)(5660300002)(7636003)(186003)(70586007)(16526019)(82740400003)(86362001)(6666004)(8936002)(47076005)(316002)(70206006)(36906005)(336012)(6916009)(4326008)(54906003)(426003)(26005)(107886003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 18:04:26.1667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14efb3c2-b5f1-48cc-baab-08d8e4b81bc0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3895
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The kernel periodically checks the idle time of nexthop buckets to
determine if they are idle and can be re-populated with a new nexthop.

When the resilient nexthop group is offloaded to hardware, the kernel
will not see activity on nexthop buckets unless it is reported from
hardware.

Add a function that can be periodically called by device drivers to
report activity on nexthop buckets after querying it from the underlying
device.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v1 (changes since RFC):
    - u32 -> u16 for bucket counts / indices

 include/net/nexthop.h |  2 ++
 net/ipv4/nexthop.c    | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 685f208d26b5..ba94868a21d5 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -222,6 +222,8 @@ int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
 void nexthop_set_hw_flags(struct net *net, u32 id, bool offload, bool trap);
 void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u16 bucket_index,
 				 bool offload, bool trap);
+void nexthop_res_grp_activity_update(struct net *net, u32 id, u16 num_buckets,
+				     unsigned long *activity);
 
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 1fce4ff39390..495b5e69ffcd 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -3106,6 +3106,41 @@ void nexthop_bucket_set_hw_flags(struct net *net, u32 id, u16 bucket_index,
 }
 EXPORT_SYMBOL(nexthop_bucket_set_hw_flags);
 
+void nexthop_res_grp_activity_update(struct net *net, u32 id, u16 num_buckets,
+				     unsigned long *activity)
+{
+	struct nh_res_table *res_table;
+	struct nexthop *nexthop;
+	struct nh_group *nhg;
+	u16 i;
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
+	/* Instead of silently ignoring some buckets, demand that the sizes
+	 * be the same.
+	 */
+	res_table = rcu_dereference(nhg->res_table);
+	if (num_buckets != res_table->num_nh_buckets)
+		goto out;
+
+	for (i = 0; i < num_buckets; i++) {
+		if (test_bit(i, activity))
+			nh_res_bucket_set_busy(&res_table->nh_buckets[i]);
+	}
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nexthop_res_grp_activity_update);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
-- 
2.26.2

