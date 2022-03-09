Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8B24D2FA8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbiCINEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiCINEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:04:10 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF1865D1B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:03:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bg4vYUFhM8pnA1iP7Ikgy2v0vGq3DHnzyEXbS+aLh1fYa6BwzNai5Bl4rv5fDE2IJ+MYVKviB035hZdgjmdsj/vLVytU2rgM5bUTDiDjTAxzSBQmZJzoNGW9dnuJthrQ3Yo0a0ikALbaEZpcPl5dQegh0hH/saQbWLYTlZ6XIGRunqe+t7/Nvm9Fa3bDocBvfSLzkR3hsGMupjJEr1ZfebxGgC6OTVk1ghyA9s8zdMk8ITdG/Uwvqur1S38eZYiNloJnNbT5CKj4+Uf27SZk80XSda4Y2+aKLbHiaC0SVvMUTFw6ex963UfeJl1qXYDRCi+3bAi1k1FsZ5ECogJL/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EMc6H+fEOQ0YHdrcTjQLk7WmjSdjjB0Ge8IxHG/RH/M=;
 b=Q59Pw6U21+3SbgJ2lGvHDoncqnE4kej7/TLCf6+fcFchsjcs8FEvX2qMBbfXu+2DOwVd9RWHZuY/RsJeZ1UP/d9vw02QLle7qaEoF5ZxYcq9g7Dwtg7B57Zxv3HZspmmIMen2/vlAFkM71jbLnDx69EpulejI6Z0LX1+AeU/9NcOmBo6K+r+QqHgpAAOzQnWSxYxvPRzjZBX00aNHplZs1j9vpwuXaAvEk8N9dtWXu1qSys+BfAjFKYI5Dwnw3P5Quxw1Z5nxUwtUekDVShoTj28d3tOS4opZ3mSKVc/Ge9hF+AhthUgKonuwdot/VVXYdr6HrCURM5h6BqWrYWhig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMc6H+fEOQ0YHdrcTjQLk7WmjSdjjB0Ge8IxHG/RH/M=;
 b=EPRtfovwgL0MLy7cEgK3ihfAEOD2YbvoXDrM9+fStT2ETPLMv8MNgbzSoerGeH3ETLZkYQy0QQCEWyiBY/uqeBuxygxEuxSmBopdx5yT+wplU4QLU3p8XItDVIXJM8jvXlRQXwZp2lxo4BilvcaJRTH/m+5tJnbklYaQLZ5VC6o6WqOIrC0OzuwcH7647Sef4ys0DbtvZVPOjgSyRwimrcK27qdC75ND2bhB+T0a4qS7QBmsZ9sWEjY9AObFipKME6g64X/hExIqbtJVqsdaoxAi+9Ci0OXvii7oLOiS3fwF/GL7QHiXsNw2oSfYXiP63Y3sq/rtw/AMemfaXKap/A==
Received: from BN9PR03CA0450.namprd03.prod.outlook.com (2603:10b6:408:113::35)
 by DM8PR12MB5477.namprd12.prod.outlook.com (2603:10b6:8:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 13:03:10 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::a5) by BN9PR03CA0450.outlook.office365.com
 (2603:10b6:408:113::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.27 via Frontend
 Transport; Wed, 9 Mar 2022 13:03:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 13:03:09 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 13:03:08 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 05:03:07 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Wed, 9 Mar 2022 05:03:05 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 3/3] net/mlx5e: MPLSoUDP encap, support action vlan pop_eth explicitly
Date:   Wed, 9 Mar 2022 15:02:56 +0200
Message-ID: <20220309130256.1402040-4-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309130256.1402040-1-roid@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4716802-2e27-441f-b611-08da01cd294a
X-MS-TrafficTypeDiagnostic: DM8PR12MB5477:EE_
X-Microsoft-Antispam-PRVS: <DM8PR12MB54775108BE970D160696C164B80A9@DM8PR12MB5477.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8bQVJQjT0k+R2eoRmzbu67GDFbGkKNBcUo6R6F3MeO7PlBila9HbpyZVQDw8Wk/je9uxIF1tP7NLwXi5ZiGcR7mwJeSdonJnso/P449aY6wGZA0HHp0XB4spYOY5osNFB5eQHKpfAy06aUJw356uxH56NZ5fpT1ciIU5nyKQwYlmd2zW+2f1JRoj7orrLsEo+/kVfrKhL/pawfG1eEMLTELRQO+0a8AGEIuS5tG9hqm6tRe9KaW/D1KJuA56ssXruHOEbXzZh/uRaWov3BL5a7lhhR6b98f7Q3V4wMj7G/0um71Cafj/cOvzPEVWBntwuoYL1yGvBY3+ikLlGYduf1H0K3phliAxlE7bmjCZ6iTifZPhbYCIkQ4IvPyS+6bSPQqTM/f/dB8mVEbUwgtOjZwEjcS8eagxJ+qyaEE69sZ2MukuwQY/noae+ISo8WKt1cPTPFUNopzGvIKz+IaI3NNH+Bcmdo0k2+y2mxUcmT0enN/dZmLVYSueHsce4tYY/cMzow/WyGOX4NGfrOpcadsStv7MuS1BpgHElJgDTjUUm8NitpTiQl+QJ2QAwCkRxgP55ct95KNd/VJ52uDwusE9KCfgb0BS9KQft7KCzvWpHTg3t+SVWZ/QWvWXx78FW++YswwIWiquQytM30hCIVrX7v5wQdwYr5itmYWXFDkEgUIRVzTktPqzXND7kJwFEcnHytO2vY5hqqn2MMtNw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(4326008)(86362001)(70586007)(70206006)(6666004)(6916009)(82310400004)(316002)(508600001)(47076005)(36860700001)(54906003)(40460700003)(2616005)(1076003)(26005)(426003)(356005)(336012)(186003)(83380400001)(107886003)(81166007)(2906002)(8936002)(36756003)(5660300002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 13:03:09.7157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c4716802-2e27-441f-b611-08da01cd294a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5477
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Currently the MPLSoUDP encap offload does the L2 pop implicitly
while adding such action explicitly (vlan eth_push) will cause
the rule to not be offloaded.

Solve it by adding offload support for vlan eth_push in case of
MPLSoUDP decap case.

Flow example:
filter root protocol ip pref 1 flower chain 0
filter root protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  dst_ip 2.2.2.22
  src_ip 2.2.2.21
  in_hw in_hw_count 1
        action order 1: vlan  pop_eth pipe
         index 1 ref 1 bind 1
        used_hw_stats delayed

        action order 2: mpls  push protocol mpls_uc label 555 tc 3 ttl 255 pipe
         index 1 ref 1 bind 1
        used_hw_stats delayed

        action order 3: tunnel_key  set
        src_ip 8.8.8.21
        dst_ip 8.8.8.22
        dst_port 6635
        csum
        tos 0x4
        ttl 6 pipe
         index 1 ref 1 bind 1
        used_hw_stats delayed

        action order 4: mirred (Egress Redirect to device bareudp0) stolen
        index 1 ref 1 bind 1
        used_hw_stats delayed

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   | 3 +++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
index 24403593b952..af37a8d247a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
@@ -41,6 +41,7 @@ static struct mlx5e_tc_act *tc_acts_fdb[NUM_FLOW_ACTIONS] = {
 	NULL, /* FLOW_ACTION_JUMP, */
 	NULL, /* FLOW_ACTION_PIPE, */
 	&mlx5e_tc_act_vlan,
+	&mlx5e_tc_act_vlan,
 };
 
 /* Must be aligned with enum flow_action_id. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 2616aee6ebf0..f34714c5ddd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -23,6 +23,7 @@ struct mlx5e_tc_act_parse_state {
 	bool decap;
 	bool mpls_push;
 	bool eth_push;
+	bool eth_pop;
 	bool ptype_host;
 	const struct ip_tunnel_info *tun_info;
 	struct mlx5e_mpls_info mpls_info;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index 14cfa39d30f7..2b002c6a2e73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -125,6 +125,11 @@ tc_act_can_offload_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 		return false;
 	}
 
+	if (parse_state->eth_pop && !parse_state->mpls_push) {
+		NL_SET_ERR_MSG_MOD(extack, "vlan pop eth is supported only with mpls push");
+		return false;
+	}
+
 	if (flow_flag_test(parse_state->flow, L3_TO_L2_DECAP) && !parse_state->eth_push) {
 		NL_SET_ERR_MSG_MOD(extack, "mpls pop is only supported with vlan eth push");
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
index b78e99ab60c7..37f14862f99a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -85,6 +85,9 @@ parse_tc_vlan_action(struct mlx5e_priv *priv,
 			*action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
 		}
 		break;
+	case FLOW_ACTION_VLAN_POP_ETH:
+		parse_state->eth_pop = true;
+		break;
 	case FLOW_ACTION_VLAN_PUSH_ETH:
 		if (!flow_flag_test(parse_state->flow, L3_TO_L2_DECAP))
 			return -EOPNOTSUPP;
-- 
2.34.1

