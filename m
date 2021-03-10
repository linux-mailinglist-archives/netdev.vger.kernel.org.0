Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44659334115
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhCJPEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:04:38 -0500
Received: from mail-dm6nam11on2043.outbound.protection.outlook.com ([40.107.223.43]:13438
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233072AbhCJPES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:04:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVnuZlS8/yhxjw9Jy0dXVj2/BjSRwyRGUgqiym5EYWTAfMuTlPspvuZqRa83KbXN/GiDOcb2o+k97pMGx97Ia8ydGYU825CsYsJ/0ve5ieARLGKRvR1FlbxfKkxrUVIkW+gnMIZX8KMOXK6qGkHmPgxZHLxNarL5x/cE92LbjcHCuP2yapW3vbbB+h6fdENT8gBuPw4TzvwyV89GaXPG+ayCAcA7S52cmaFNmEM941uN/QynPuKo7cKG0aaEbCkutxy3RpPxUw2//xL0JPulQZT9AiLp0e9YjMqo25PgtzaWaIAysJk/2oUqCC4PDY4Gi6nnq1KYJd3abdYPzA3Kaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/0P/r53StElDNs0CvOiG+UwGZBVO2omcVW5VaXqIbc=;
 b=Fx7EzVj7/z0NGSJoc5rPC8qOUbB/HTY/90vhTbsMpGi1aXg5y/zK/IptJnGlZeuUuaTwcJXIzURdZ/kRO4UMgiBeb9fJxkEIVcm8haf2W2jNrTT7hn1H2erw7C5M4j1ayhPobwzK2x9ulxyfI8EO1lx9y+KWPw4dt1BHIj7X5L6qPpxLFOMtEfA4xEvWwtviAHCFWEDf4ApcmFKqM27Tu9qNIDKWJmz18oLWr9fyukj6AFDHPoa4gxzYoMXMnl3G/VHz+TRrW9BSdd0jj4XevZsBdGrYTtcBhIkTdHuMA7iyY2/KCdc/UsPKtVusK/qJTwssUPezRxqPPGq8R50e/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/0P/r53StElDNs0CvOiG+UwGZBVO2omcVW5VaXqIbc=;
 b=Xj1WpmAmb1YwDrE/qCSGapzuooJOuz+nDAtqgOVHepgzhYGEJEamuZcUVBLDyBbf5t/F5M5l/totXVoP93CwKy+vheyLk/WEdeSqPMS3MlakSJOdpQRnx1TCXw216oMjkIEeHYVq02Oa0SR9gyrRbTJU3EzTviJIDlu6nFzUci/YgD+HtvSAig7q/HLObbFHeD60yQ3XVE7CiYTTp9Vi21cV/R5fM+Yh8VsK8Fj3zssQ+Vo6zx5YHYY5wHHJ8aWxSVtMyYeXppcfrWj8g5hz7pRk1Ud4ERmu7scTnh3g42P7ELo8xOSmopxxjH0t/JIJlaJBYZLotBqRNnZlaR2dvQ==
Received: from BN6PR17CA0043.namprd17.prod.outlook.com (2603:10b6:405:75::32)
 by DM5PR12MB1644.namprd12.prod.outlook.com (2603:10b6:4:f::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.26; Wed, 10 Mar 2021 15:04:17 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::af) by BN6PR17CA0043.outlook.office365.com
 (2603:10b6:405:75::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 15:04:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Wed, 10 Mar 2021 15:04:16 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 15:04:13 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 09/14] nexthop: Allow reporting activity of nexthop buckets
Date:   Wed, 10 Mar 2021 16:03:00 +0100
Message-ID: <d1e3bab356ae50c7e716721ed63d3ffeae91a451.1615387786.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9c6b7015-e4be-4954-8004-08d8e3d5c63e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1644:
X-Microsoft-Antispam-PRVS: <DM5PR12MB16445D503685A4DD3B8B2601D6919@DM5PR12MB1644.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WBg4GNBG5ZrryGd1NnO70QU79TBaMpa2Wk7pni/pg8QVj6RM8QZfJQZLob8pt8jJzYzBPnzVXirrY7XGy+15DtHPB+euFm4DxZFa1JQ4MLFH+Cd5grJLEK2hUhiLp4hyVuQlOzVF/vJo9zM4o2YwlKKJNqNF0AUsvJ2G+FKWc+Q6zdOxQbDOEvJtFbb4cDtRaQuyCtGKedwJ+7i7bcnDywPzrXrJnvA1oyrF2oBKTcCgWOWw86l5tz8M88ElSPNxrkLdPRHLYRw3p+mEjumWvocbhXXind5GPrlP6bK3sgh1eMSWptHgPIP2tvOVg3DQqWZMh3+95SzD4tCqyBDQkdQv5bGEdU+gyLFWaAN/WZEiUskASnI7ZNRIjHYSJ931C9o2f2dcwWp0G/c7blYb6F5G6E/M1yjH6dn6n5uF2fdhm5P20lpurqFCkcxVN+939lS3q6/NWkRLusgN5BttlFxDc1JXHBVlp+UvvoqCiyfyJJZPV7xFHYUjRzbBK41GISZ8UGO39MwjQR9rI2xUo2CMUh4QfBrF7RHm//lHosgDw/s5U5WB75f1QCVqYT9UhfRIF6/jI5oIC9Wbb/dg1nBAs+KV5VCqv6Q7q4bEQ1WKx3BG9GIodiF0Gl8+FsWUaGnYioB0oB8lG0K+u1hL7Itqk6/PVcRvD/rEDqHRDIs/lZnHyI7JbCgiO50KgoMS
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(83380400001)(70586007)(70206006)(54906003)(336012)(8676002)(86362001)(478600001)(5660300002)(426003)(2616005)(36860700001)(82740400003)(316002)(8936002)(16526019)(26005)(6916009)(6666004)(186003)(356005)(7636003)(36906005)(36756003)(34020700004)(2906002)(82310400003)(107886003)(4326008)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:04:16.4820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c6b7015-e4be-4954-8004-08d8e3d5c63e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1644
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

