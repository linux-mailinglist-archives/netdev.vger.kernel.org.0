Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1044D99DE
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 12:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347784AbiCOLEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 07:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347782AbiCOLD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 07:03:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EBAF6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 04:02:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeS+XvfAZ3D+7Oeq6FMp/JJuoiqHlDHxhiJ4ZMK7qOsTxrsiFo/r6S3k+jzQrS0p790Uyyltm7w8J184eFyT/krtpf4KTLmCoX5KTRhidA16IQjp6gfLhEppVFqWwt/OLmaU2awmfcGxPX4nh9fKrlIqUoo/mEn0zE1HL9aiD1xy+7QQaPjnFawC5r2GcoRGhX5UplOnY9I4RSm+Ee4zaxi9IyNy0B8hWwZwwbO8Dj2rS9qivWWtqJHrd0KjB87y4yoE5ZY+ne0AV7xn9XGX3z5CDf2hphQJ6QVq3y9VcKGnee+e2On4dSrcHf4VuVtBepPfUrPWB1d9CDGGZZoQFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MbbdebdXOBO0OFxvR2tVNdo5UQw7I4PHEyHD9wIat8=;
 b=W/80gAM+C9xkkNVewbZHzPp5Amssr9/JYMuV0SEGYjVZ/w1jEEMn4QiGZmH0xpRMJsR4DDNmjOlu8XBRv0G0e1bgKt2iZzUlxsZ6PxTwgYkyO9HFyy1dQ5ddVazGZ0i5yJZfxO9yPfaJtRrY9IHUPKzm6K8WNpJEfyLARPfFssoBJtcHd7abpftvYdhvC3HHyx6F85gB7nY61EUHTRihgjZQ9GssZ9I9agUAXgS/5+Azl/q/pnBuexISoYK4eNeqEQJVSc0zJzo6g3XIw+lQDPLc3iYlWp7xXpCAOjqh57rrDkgaJaeED6ZEqV12rYeu3zK5hKcDHSgepV+oMxhNoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MbbdebdXOBO0OFxvR2tVNdo5UQw7I4PHEyHD9wIat8=;
 b=hWnGzsww90MEAH4+H7+GkQ5H6KgEtL7Pof4Oh+7N4PNngoZ7cdtRU3svaRL07DO+TJkbiV3NhUQ5P7SZCRaBgaJf4Q+35DZZ3kBH1jfKykupvosPWY7gUNqqKmXqndLSA1D7Y8mFetPeF9nvG97K3papi6CcL407gUXRHERzUuOdsvkHRtjqh/+U1iHFjfJ5PJub9v4mipIwwAonmJCsSg4B23BKFgOrfmppSKxRJpWG/fNsxhAVAcj9gxP2N+t0iGgw+z/Ex4p5FEK3EfCI/wcQuFDwdEL8BuXGm0PvzWkm9efTHz9ltXzQqkijYRUiL65jogtorLpWgHFjE4UzPA==
Received: from MWHPR14CA0031.namprd14.prod.outlook.com (2603:10b6:300:12b::17)
 by CH2PR12MB3878.namprd12.prod.outlook.com (2603:10b6:610:2a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 11:02:44 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::82) by MWHPR14CA0031.outlook.office365.com
 (2603:10b6:300:12b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14 via Frontend
 Transport; Tue, 15 Mar 2022 11:02:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 11:02:43 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 11:02:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 04:02:37 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 15 Mar 2022 04:02:35 -0700
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 3/3] net/mlx5e: MPLSoUDP encap, support action vlan pop_eth explicitly
Date:   Tue, 15 Mar 2022 13:02:11 +0200
Message-ID: <20220315110211.1581468-4-roid@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220315110211.1581468-1-roid@nvidia.com>
References: <20220315110211.1581468-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 481ddb99-ef53-42c8-5d14-08da067354ba
X-MS-TrafficTypeDiagnostic: CH2PR12MB3878:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB38781BF90E878EAF7B2BA189B8109@CH2PR12MB3878.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxSlESCGsXpY55QFaghmDxZII0sboXCqNRPLHEPbzEqX4R08GuFPFBhu4StPFfY6xlxVC/389QArEYPDCCnz9xN7PfvLtvAcLzqqDa2KGyv8FF4La1dgVTPFLu5RSTrki6MScZnQmp4SfELSJzeVfpu1dc5jkMjTGjvjiTuk/pW/wfbtjg3q3b6P1nntoTIt+qegFwu6uUcTEOL2JcLjMlp1lAXQO5QFIK+pjIpPBuU/k5uazJAoMbYna3xI/8yAHdIhMHhgXfXK3+OHzgWPpyDU4WWCynroItaqQXFaICCR8WU8zka7I53hajOh33p3fGOfeiz7Md8drBYLZ9s5BDGyT0TB8YV3yl7YWtFUotb05Uh8xgwty3LtFc8PbyDF66vO9ldZSg2KeP4CN7L5ptTs7tjPqGyr1FwDbSLQ+dcrb0APkIUx43bLWlD4fvCfA/YJBZyTS1l9PhJbyKxbAfNkm16mAQn43upTC725VzCCQhKGS4rO0EuccTAfYSoJ3f5c42rVOu9tZi8Dd2EgmpiRvPofMIGs/lG6zEa96mf0rzk1Gou9OSARLNWgAZ0/dS6HgcPHVg7O63ia2AGJJSJgLF/EzksPqBtUBF8WqhYvQFlT04ig3ZK5ND0lK6A87DcNTwP/fUnWLiDldq1Y93Yhp1DCvtN6WUXXEqfvFIrqRXjot79cRzVFKhWIwvqH1NMuPUKtNl0ShJye8pKGqw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(36756003)(70586007)(70206006)(4326008)(5660300002)(8676002)(40460700003)(6916009)(54906003)(83380400001)(316002)(8936002)(82310400004)(2616005)(426003)(336012)(86362001)(6666004)(186003)(81166007)(26005)(356005)(508600001)(47076005)(2906002)(1076003)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 11:02:43.7758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 481ddb99-ef53-42c8-5d14-08da067354ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3878
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index cf1acf678270..b86ac604d0c2 100644
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

