Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CED03584ED
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhDHNk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:28 -0400
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:53088
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231777AbhDHNkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZZ2L9EwvxwLCSNWSYg1EuMhr0zXImqgca1D9xlapTY2yHx91eEMn7OfmlrRMP4nxXX5q8WXMp6evUHgD48hCuV+oiZBM0PDDMaWTpe0molztXTFOfzdxDpPs10VmXu/jhkVhPM0d5wUuoyDezbczjsXNoIVyF1bLWRwN3kTA37OR+qFSwXkNZTdeiDTBl7GxMBAXhhUblqFnGovzF09LKRCg4FDLJ/ZfQkauPkcUBT/CicJjVEsKnhzFR7iSvtRkesfJZdUFnG4CMny2WWOy0/HDR9HIRtIg7yBKVOYnGUUnavM6wtnKdiPAipnDTYhyVlfqaU8UodS+CEofSakxPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJzRTCnK2XO6I6rO2bfGCuK7ecwpCL7fmVVPDBY2aKc=;
 b=f4H6taHqDth/all2twyK6bW+7ZDlYBxf8rb71MKr1Y0mSo38H2Sa6QmHtvvMJ4IsqQGmkWZmcmIExaxVD+U7qJs82MX9rj+BqqRIkQEGQAS4nBc/4f6DNyzNMI2DKxED49Ay1yswstrQxVLgbmK9yHD9QoZ5MTrPyqf7lkdCabMppKEwRTet8Pxitj57zNmV5+LfK0e+vHtCidL1SQ4V4ETGtU2BabSAAk3HTqq5jTJZup8KgH48aXygXM41cen1FmiFn9yw7TtL7vZl3Ea39XVs4Lg5j8QYmIDbFMZNRqrjpBAQgEsf9OukyePsfqq9SuOwtj0oynH2PYHJiZJNAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJzRTCnK2XO6I6rO2bfGCuK7ecwpCL7fmVVPDBY2aKc=;
 b=H3Pwu2CJn2iBRnv5mC660CPb1gYv5N2f8xFsHNxONsbFtQ/Jp7mXk3zyMdnTNtOWJWAt0+VPRPLe5Ca8eDo0ZJovXRITczbbJxAWENvVgOYZ/6Ynl/22UpSwnw185l2SXRa/bpdnEZ2fQn5XvmRacSUUItO3kbK6UPwzBUAUFA0C2OGehr8IIBgln+wpuuFeJZ42/U6dF4FoWTbIFBuAvcUlzBWZ0hy4QGiWbp8ifAjgvWczKPURqQYoJlZnosOzBqcglwhuedyq6ZYYgQr661h23ZexTwFuIpiNzFfLPFdMKYKpQRREufz1lTpBgS9ZTIwuHUl/7jbqXAqA4Zx1fw==
Received: from BN6PR19CA0073.namprd19.prod.outlook.com (2603:10b6:404:133::11)
 by CH2PR12MB4022.namprd12.prod.outlook.com (2603:10b6:610:22::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 13:40:09 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:133:cafe::f0) by BN6PR19CA0073.outlook.office365.com
 (2603:10b6:404:133::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 13:40:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:40:09 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:40:06 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 5/7] mlxsw: Offload trap_fwd
Date:   Thu, 8 Apr 2021 15:38:27 +0200
Message-ID: <20210408133829.2135103-6-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408133829.2135103-1-petrm@nvidia.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5dd9da5-d849-43e8-d898-08d8fa93d405
X-MS-TrafficTypeDiagnostic: CH2PR12MB4022:
X-Microsoft-Antispam-PRVS: <CH2PR12MB40224202DCB6F638372D6731D6749@CH2PR12MB4022.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZG0oZ/5NgC0+Zp9Va4PzZ3l9q8PvC31T+vWMs34tPn2rh2hliHrQif0qFfi1T2uftv/CagWkyVY9V6Zgmmn8Xnv0ItjqzVmHmUNkl/I6YrJcnFD4T3j4tTUci4eUEUVJMHKXLjI7ek8g+8cacVTZqvVmMqr/I2iBaCV3w6KpJ6KQA0zy81SJ4G+B427VB5LXMeXfcHagvkKct+1yPFRuVs168Fx3UJEy7mSGEa6T+FeTKxkgwSl5H44/ivOByTAoOcKmqhSZwvb9OVesbY7CnPyLUphY0IBoXDQD0Kq05wROEsBWQSt48RVMHcqt5y4kfZ6Mz+/ZBuzioKfyE+rQeVhHfUP08PVIL6lfKF9Ejv5s4z2ozoqZ4TBFEpVthW2PJKc2CY6GEHEudLBhz8WLyD7IB9MI4gV88eM9uAd2z87+COYclmNe5mRbbs3DLtg6nKBqNvIzluh5BPPolFEyrwSu8/+c+2udj0eY76DiryJd+Gb3slpcMlrWlIH8cNyegQXboFGpxbuRMgXtel72qO9iA5aK84Zv/HIH0UgWkbexdmPCB7cti1+Kd0PxOs6CsOpeDu4XbYGMEQ6+PSuAmGhWv0QQP3JmMfu8TQOqz4lB8cnotXwqBdInRWFxL07rFHLXMRDpdHKxKc+n21SzSA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(46966006)(36840700001)(5660300002)(7636003)(356005)(426003)(2616005)(36756003)(6916009)(82740400003)(83380400001)(16526019)(4326008)(70586007)(36906005)(316002)(6666004)(336012)(2906002)(1076003)(47076005)(36860700001)(26005)(82310400003)(86362001)(70206006)(8676002)(54906003)(8936002)(186003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:40:09.5215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c5dd9da5-d849-43e8-d898-08d8fa93d405
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4022
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offload the TC action trap_fwd. This is offloaded as a TRAP_ACTION with
forward_action of FORWARD (as opposed to NOP for the trap action). Unlike
trap, trap_fwd needs to be in an "goto"-typed action set, not "next"-typed
one.

Trap_fwd'd traffic is marked with offload_fwd_mark and offload_l3_fwd_mark
to prevent second forwarding in the SW datapath.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 23 +++++++++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  6 +++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |  7 ++++++
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |  8 +++++++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 ++
 6 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index faa90cc31376..d7d7e688139f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -94,7 +94,8 @@ struct mlxsw_afa_set {
 		      * kvdl_index is valid).
 		      */
 	   has_trap:1,
-	   has_police:1;
+	   has_police:1,
+	   has_trap_fwd:1;
 	unsigned int ref_count;
 	struct mlxsw_afa_set *next; /* Pointer to the next set. */
 	struct mlxsw_afa_set *prev; /* Pointer to the previous set,
@@ -263,14 +264,23 @@ static void mlxsw_afa_set_goto_set(struct mlxsw_afa_set *set,
 	mlxsw_afa_set_goto_next_binding_set(actions, group_id);
 }
 
-static void mlxsw_afa_set_next_set(struct mlxsw_afa_set *set,
+static int mlxsw_afa_set_next_set(struct mlxsw_afa_set *set,
 				  u32 next_set_kvdl_index,
 				  struct netlink_ext_ack *extack)
 {
 	char *actions = set->ht_key.enc_actions;
 
+	/* If the forwarding action is not drop, the next/goto record must not
+	 * be a next, it must be a goto.
+	 */
+	if (set->has_trap_fwd) {
+		NL_SET_ERR_MSG_MOD(extack, "Only goto permissible after a trap_fwd action");
+		return -EINVAL;
+	}
+
 	mlxsw_afa_set_type_set(actions, MLXSW_AFA_SET_TYPE_NEXT);
 	mlxsw_afa_set_next_action_set_ptr_set(actions, next_set_kvdl_index);
+	return 0;
 }
 
 static struct mlxsw_afa_set *mlxsw_afa_set_create(bool is_first)
@@ -461,6 +471,7 @@ int mlxsw_afa_block_commit(struct mlxsw_afa_block *block,
 {
 	struct mlxsw_afa_set *set = block->cur_set;
 	struct mlxsw_afa_set *prev_set;
+	int err;
 
 	block->cur_set = NULL;
 	block->finished = true;
@@ -481,8 +492,10 @@ int mlxsw_afa_block_commit(struct mlxsw_afa_block *block,
 			return PTR_ERR(set);
 		if (prev_set) {
 			prev_set->next = set;
-			mlxsw_afa_set_next_set(prev_set, set->kvdl_index,
-					       extack);
+			err = mlxsw_afa_set_next_set(prev_set, set->kvdl_index,
+						     extack);
+			if (err)
+				return err;
 			set = prev_set;
 		}
 	} while (prev_set);
@@ -1346,6 +1359,8 @@ int mlxsw_afa_block_append_trap_and_forward(struct mlxsw_afa_block *block,
 
 	if (IS_ERR(act))
 		return PTR_ERR(act);
+
+	block->cur_set->has_trap_fwd = true;
 	mlxsw_afa_trap_pack(act, MLXSW_AFA_TRAP_TRAP_ACTION_TRAP,
 			    MLXSW_AFA_TRAP_FORWARD_ACTION_FORWARD, trap_id);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index d74fc7ff8083..6067a049dcf2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -940,6 +940,7 @@ int mlxsw_sp_acl_rulei_act_drop(struct mlxsw_sp_acl_rule_info *rulei,
 				const struct flow_action_cookie *fa_cookie,
 				struct netlink_ext_ack *extack);
 int mlxsw_sp_acl_rulei_act_trap(struct mlxsw_sp_acl_rule_info *rulei);
+int mlxsw_sp_acl_rulei_act_trap_fwd(struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_act_mirror(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_acl_rule_info *rulei,
 				  struct mlxsw_sp_flow_block *block,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index b9c4c1feba6d..6f7913424bd9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -401,6 +401,12 @@ int mlxsw_sp_acl_rulei_act_trap(struct mlxsw_sp_acl_rule_info *rulei)
 					   MLXSW_TRAP_ID_ACL0);
 }
 
+int mlxsw_sp_acl_rulei_act_trap_fwd(struct mlxsw_sp_acl_rule_info *rulei)
+{
+	return mlxsw_afa_block_append_trap_and_forward(rulei->act_block,
+						       MLXSW_TRAP_ID_ACL3);
+}
+
 int mlxsw_sp_acl_rulei_act_fwd(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_acl_rule_info *rulei,
 			       struct net_device *out_dev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 936788f741dd..1f52ea7ba202 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -86,6 +86,13 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return err;
 			}
 			break;
+		case FLOW_ACTION_TRAP_FWD:
+			err = mlxsw_sp_acl_rulei_act_trap_fwd(rulei);
+			if (err) {
+				NL_SET_ERR_MSG_MOD(extack, "Cannot append trap_fwd action");
+				return err;
+			}
+			break;
 		case FLOW_ACTION_GOTO: {
 			u32 chain_index = act->chain_index;
 			struct mlxsw_sp_acl_ruleset *ruleset;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index 26d01adbedad..504fb7440a1f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -1154,6 +1154,14 @@ static const struct mlxsw_sp_trap_item mlxsw_sp_trap_items_arr[] = {
 					     false),
 		},
 	},
+	{
+		.trap = MLXSW_SP_TRAP_CONTROL(FLOW_ACTION_TRAP_FWD,
+					      ACL_TRAP, MIRROR),
+		.listeners_arr = {
+			MLXSW_SP_RXL_L3_MARK(ACL3, FLOW_LOGGING, MIRROR_TO_CPU,
+					     false),
+		},
+	},
 	{
 		.trap = MLXSW_SP_TRAP_DROP(BLACKHOLE_NEXTHOP, L3_DROPS),
 		.listeners_arr = {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 9e070ab3ed76..5271d7ad092a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -108,6 +108,8 @@ enum {
 	MLXSW_TRAP_ID_ACL2 = 0x1C2,
 	MLXSW_TRAP_ID_DISCARD_INGRESS_ACL = 0x1C3,
 	MLXSW_TRAP_ID_DISCARD_EGRESS_ACL = 0x1C4,
+	/* Packets trapped due to FLOW_ACTION_TRAP_FWD. */
+	MLXSW_TRAP_ID_ACL3 = 0x1C5,
 	MLXSW_TRAP_ID_MIRROR_SESSION0 = 0x220,
 	MLXSW_TRAP_ID_MIRROR_SESSION1 = 0x221,
 	MLXSW_TRAP_ID_MIRROR_SESSION2 = 0x222,
-- 
2.26.2

