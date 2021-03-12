Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C81B3393E9
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhCLQvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:50 -0500
Received: from mail-dm6nam11on2058.outbound.protection.outlook.com ([40.107.223.58]:5568
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232005AbhCLQv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2tIO/bzzFSxqx3NDi5jYDGI+vuqtde7bMEBs/U+jnQ47/msi+mymMJcsysXUWaB2WQvtK34ye3wHb63TV64UokS5GocFVFWGnCVb/ON9zk6ZAit6amyrkwiI/aPVXIUIy+Blwg7L2DdHeaNpaHOEnO30rIedIJZ3McRaRhJ6x0/zuY6BrtnpZbfPZzvUeOii5NJW/UoO0z6VEljp2dcZ5EXiJZkRPTQW0ZT2NDE9m2OZLJ+9k+clLwfUeyACvjTCN/INRH3LC0+XuyyopGfl8UtBCTBNt4aqYjbTf7oDjIbSbVFh2CkNlpH9Mq37fr4+s7eWBdEpLQ8nHvjKkEQZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDnZ6hFzM6pep7ZHkanmh22H/OQHG5ZuluwBRu3bXHA=;
 b=nnbjaboqwWDt3AYQlFVyuTDjF68GLHwOk80+l/P9ed46UklVXdzL3N6hO+1wQIOdsYFEIz9Q/b38eeqMLTg8bWKd90w9U4GMULJAfgS8+721mAvTdR+HJb8vZiu4gHCEqTBVRqzSxTR/nc8luz+SBwHbAAAb5E/7Cpd8Hwl1Ap2yEJhGX/g5jsC56dfb0Ls6mdctTkhBK5DSNBsWIFwb+Z0pLLEcFEoZNRMo6/OBS97CMKkxvlI0WM6hdOugkvM0qLa0Mw03sy2FKXTEaH1M/rD4Cs+Gtiuk5qz/9i0acik8ZQqY8gQz2JLur0fceAbXJeVETFYMD8nmCASdL17o0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDnZ6hFzM6pep7ZHkanmh22H/OQHG5ZuluwBRu3bXHA=;
 b=gGgzjoFVzPnPBpRanjZ9lfaPGwo4j3YD5m1bx9rdKD1yXv0WE7yqG+E6gtWFpURbQZ8b6VZaoZWNn6zkk/7IKpyCeETckp+GuRw7Pevm1p1HzRAl2E+zJVLp0kVcIQkYzpn/daiEGI5wUQTOHJuEIrjRuOPxeHnp+/whP2HZsl5mQuwvCein85WwhvzyFHvNQmucyrhwdw73lIFtAISyUZIuIGGcn/cSqqdkQRFlkPbJDHOjVS5mFe7HpDMc7aOdDUr3GLsGq0QBr1jt3MI2LFMq0ys0+owE2/sfu1e87k3CeyUk+0eqcivoAJdjgVN5EW2JNPSCyust/VXYa69IMA==
Received: from DM5PR04CA0048.namprd04.prod.outlook.com (2603:10b6:3:12b::34)
 by CY4PR12MB1591.namprd12.prod.outlook.com (2603:10b6:910:10::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Fri, 12 Mar
 2021 16:51:28 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::14) by DM5PR04CA0048.outlook.office365.com
 (2603:10b6:3:12b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:27 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:21 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 03/10] netdevsim: Add support for resilient nexthop groups
Date:   Fri, 12 Mar 2021 17:50:19 +0100
Message-ID: <a81f2da968ba36202dc1fb0de946eb2d0e8b6bab.1615563035.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8eaaf5d3-2d6c-4535-1bea-08d8e577146a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1591:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1591C6619C2DCAFE05F0BCCFD66F9@CY4PR12MB1591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jcXp8kaMwyp9uh70Hq5I4u3jwcLq2AW7Y0NRf/PKQHUkl/9Y0x6v8lLmNdH850Qx+j7raCKXycGAS0pP682mOqZpot8beg40bCtA3pMj/Qcv7htR7YhMv1oy/+K3A1C/Q4RB37Stim+k2sKeg39OB1/RiND5Ocn90Z+mfqxwCAIqDOQ571RjYOdOHFcoaoAFJBE91VKJszhr2EGOA4Du73bzyefK/ArQORQJjR5Jf0Ip9PQ/wxwJwpajo1YvW7h9zEvvjnDsZOPMNwMcUmSbOvwWqsar6Ihxywq+dL80p01SD1H+OQ8k1pPmEKXbmcQO/bC3PIflD/cfHoFouO5ipJ06PZ7M75QxWJW/pnY0jXXM4fOGJetHx3Sr4AU1xOZnLbH2yv87ErI9l3krL8B33P5x3tKqGwTKir0FlDYGDxJdJLNRgbaSUPmj2xsiPYi4AJZQv34n1aGDGaclazs3crXzOs56sNdrJzjvF7wAIEAtYNCfU5uQdVeYfdfbWGGNQctpKimoqkRaTlewMvFW/AUqtX/yZC0nB99qMEFGZRxCqSb3xMUbQtdGqwK/lPNRXhFfap/1Cj8YM73DP25lGciKePzB5JCojqCwO5pO5Ig74J0Nht+jRvnwVwkmy2ox/DDNZwAx0bFEUAgrLvt8OiAa9ZSB/81/Bu5JZ48/o8RXKGkGAF23YKuXi961m7ff
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(83380400001)(426003)(356005)(316002)(54906003)(186003)(16526019)(4326008)(2906002)(7636003)(70206006)(70586007)(336012)(26005)(8676002)(8936002)(47076005)(6916009)(34020700004)(36906005)(107886003)(86362001)(5660300002)(82310400003)(2616005)(36860700001)(478600001)(36756003)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:27.8223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eaaf5d3-2d6c-4535-1bea-08d8e577146a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1591
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Allow resilient nexthop groups to be programmed and account their
occupancy according to their number of buckets. The nexthop group itself
as well as its buckets are marked with hardware flags (i.e.,
'RTNH_F_TRAP').

Replacement of a single nexthop bucket can fail using the following
debugfs knob:

 # cat /sys/kernel/debug/netdevsim/netdevsim10/fib/fail_nexthop_bucket_replace
 N
 # echo 1 > /sys/kernel/debug/netdevsim/netdevsim10/fib/fail_nexthop_bucket_replace
 # cat /sys/kernel/debug/netdevsim/netdevsim10/fib/fail_nexthop_bucket_replace
 Y

Replacement of a resilient nexthop group can fail using the following
debugfs knob:

 # cat /sys/kernel/debug/netdevsim/netdevsim10/fib/fail_res_nexthop_group_replace
 N
 # echo 1 > /sys/kernel/debug/netdevsim/netdevsim10/fib/fail_res_nexthop_group_replace
 # cat /sys/kernel/debug/netdevsim/netdevsim10/fib/fail_res_nexthop_group_replace
 Y

This enables testing of various error paths.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/netdevsim/fib.c | 55 +++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 62cbd716383c..e41f3b98295c 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -57,6 +57,8 @@ struct nsim_fib_data {
 	struct mutex nh_lock; /* Protects NH HT */
 	struct dentry *ddir;
 	bool fail_route_offload;
+	bool fail_res_nexthop_group_replace;
+	bool fail_nexthop_bucket_replace;
 };
 
 struct nsim_fib_rt_key {
@@ -117,6 +119,7 @@ struct nsim_nexthop {
 	struct rhash_head ht_node;
 	u64 occ;
 	u32 id;
+	bool is_resilient;
 };
 
 static const struct rhashtable_params nsim_nexthop_ht_params = {
@@ -1115,6 +1118,10 @@ static struct nsim_nexthop *nsim_nexthop_create(struct nsim_fib_data *data,
 		for (i = 0; i < info->nh_grp->num_nh; i++)
 			occ += info->nh_grp->nh_entries[i].weight;
 		break;
+	case NH_NOTIFIER_INFO_TYPE_RES_TABLE:
+		occ = info->nh_res_table->num_nh_buckets;
+		nexthop->is_resilient = true;
+		break;
 	default:
 		NL_SET_ERR_MSG_MOD(info->extack, "Unsupported nexthop type");
 		kfree(nexthop);
@@ -1161,7 +1168,15 @@ static void nsim_nexthop_hw_flags_set(struct net *net,
 				      const struct nsim_nexthop *nexthop,
 				      bool trap)
 {
+	int i;
+
 	nexthop_set_hw_flags(net, nexthop->id, false, trap);
+
+	if (!nexthop->is_resilient)
+		return;
+
+	for (i = 0; i < nexthop->occ; i++)
+		nexthop_bucket_set_hw_flags(net, nexthop->id, i, false, trap);
 }
 
 static int nsim_nexthop_add(struct nsim_fib_data *data,
@@ -1262,6 +1277,32 @@ static void nsim_nexthop_remove(struct nsim_fib_data *data,
 	nsim_nexthop_destroy(nexthop);
 }
 
+static int nsim_nexthop_res_table_pre_replace(struct nsim_fib_data *data,
+					      struct nh_notifier_info *info)
+{
+	if (data->fail_res_nexthop_group_replace) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Failed to replace a resilient nexthop group");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int nsim_nexthop_bucket_replace(struct nsim_fib_data *data,
+				       struct nh_notifier_info *info)
+{
+	if (data->fail_nexthop_bucket_replace) {
+		NL_SET_ERR_MSG_MOD(info->extack, "Failed to replace nexthop bucket");
+		return -EINVAL;
+	}
+
+	nexthop_bucket_set_hw_flags(info->net, info->id,
+				    info->nh_res_bucket->bucket_index,
+				    false, true);
+
+	return 0;
+}
+
 static int nsim_nexthop_event_nb(struct notifier_block *nb, unsigned long event,
 				 void *ptr)
 {
@@ -1278,6 +1319,12 @@ static int nsim_nexthop_event_nb(struct notifier_block *nb, unsigned long event,
 	case NEXTHOP_EVENT_DEL:
 		nsim_nexthop_remove(data, info);
 		break;
+	case NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE:
+		err = nsim_nexthop_res_table_pre_replace(data, info);
+		break;
+	case NEXTHOP_EVENT_BUCKET_REPLACE:
+		err = nsim_nexthop_bucket_replace(data, info);
+		break;
 	default:
 		break;
 	}
@@ -1387,6 +1434,14 @@ nsim_fib_debugfs_init(struct nsim_fib_data *data, struct nsim_dev *nsim_dev)
 	data->fail_route_offload = false;
 	debugfs_create_bool("fail_route_offload", 0600, data->ddir,
 			    &data->fail_route_offload);
+
+	data->fail_res_nexthop_group_replace = false;
+	debugfs_create_bool("fail_res_nexthop_group_replace", 0600, data->ddir,
+			    &data->fail_res_nexthop_group_replace);
+
+	data->fail_nexthop_bucket_replace = false;
+	debugfs_create_bool("fail_nexthop_bucket_replace", 0600, data->ddir,
+			    &data->fail_nexthop_bucket_replace);
 	return 0;
 }
 
-- 
2.26.2

