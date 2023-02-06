Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A7068BF34
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjBFOCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjBFOBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:01:09 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37B328207
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkrWva0MACSxirlPde7GbFvw9XUxhNuK0kma1rg1d4+HhmD23W/rBuzLus489ae3XPL+53AtvokPP9JJ2/p5hC/qv0l2sf9ONfKbqCi3aCtpectYtzAk+REYxJPsIEK457G8h6UcrFO10RTIJTJbv++kqr+5fLfXzq2SIo38GOULMKDEfIfPWNTA4yr6jlYZlTK3SlbKX6UoU0h+l5Uo+SWpip+1ZKiI2pkT1PToiouPIGWZlSUbaQVhox3Xpx9rEYzO1HcXIk0KHEn7oU7WSrL0uuASeMZLjYeyYfFsZyEdjcLx6Z2r9AIeLHKT3ZH7oij1oEkE1n8CqfEmOBIt5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qH0uDYc0Gcl8lsCxYn8R81YLZ0hLaQjmJgjBfaeb48k=;
 b=mc0iCcXZazF+AbQDAwQzWc/QTgCnkbo5JcJIP+LsM8ZA07Y+4O7k1hyS+mBQ29Lu/NHrbN4g4DgRks2beqbEDTVosjssITRc2i/JsHKxEXZvcv4SHVJrFS0+VU0JPm77mynEqpj8iFPZ7llq+B2OzE/IBOhElgVidA2Bk0XE4bo50UDYmVIDj8sTso96vRkzn2dYyGNd1y3Rd/0Gvx8sZ9gXlqN+2WsaHe7CAmhi38ydazXWr19vP1yEgn7hliBaeilkuWq+0rtQYIGP8GEGV3MIMujd/XxQX4BF59kBLY/j2Dh7TWOZfAqUZPKq1iHIUIaWpmVeqvtnFvvkZNjv8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qH0uDYc0Gcl8lsCxYn8R81YLZ0hLaQjmJgjBfaeb48k=;
 b=UZEk5Sex3OwuTiI5LmVrn5G7SjxneQkFRtnCis2gApzOGlQhgnAfjJjLDDcHR0vtq5n+WIgnGLkuXIKWoJNeKzna86uYwZbtTSoiVCiaOXWUWMkIuBotlte75MPwvnJ3DYf7fMfZvMwiAPe4+CjpMCBGayvESC7sQ6Uf+R345PPGw2/tUmJ2vjtYZqzgseoINodT+5ksgJgnLxi9wTYQJzILpgB7SbaXgIKKinY36gEYPJAoDX2zLZ2q9mVIgaCRpYRhIO6YVWgtJv0ATA+lbLT52ntPvOdtGbhRq23XBzglOiR1E12TFPZPZvnCd3H+5LhA3tPxS4EcqBrp8KRnWw==
Received: from DM6PR02CA0102.namprd02.prod.outlook.com (2603:10b6:5:1f4::43)
 by DS0PR12MB7972.namprd12.prod.outlook.com (2603:10b6:8:14f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Mon, 6 Feb
 2023 14:00:37 +0000
Received: from DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::6d) by DM6PR02CA0102.outlook.office365.com
 (2603:10b6:5:1f4::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT070.mail.protection.outlook.com (10.13.173.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:25 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:25 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:22 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v3 7/9] net/mlx5e: TC, store tc action cookies per attr
Date:   Mon, 6 Feb 2023 15:54:40 +0200
Message-ID: <20230206135442.15671-8-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT070:EE_|DS0PR12MB7972:EE_
X-MS-Office365-Filtering-Correlation-Id: 14d36683-8788-4145-bf3b-08db084a85fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HvLie6dEBTt7Wq+7QunvSjvHqOJzCQ4GFzHQPWmjTqp6mmfCo5R6hccXkKuawq+IkPPCNle8CxBA496BaAwTq9x/Obme6dxP3Fwoe50HLeil+pNEtQlO0ZPtsa7McQLvylRFwRtOeqwJHIR7s1GSdwQl7LfxFshsLkOGxqoLo5lwBr7flvhgoE1KPXLQ3M0642Qy5TueAgNbfk+CjhvCymM7XG53weqS+tC2lnAS8HKoZrfLzza/IHcYBvFADgaAWEHyXrgxgfioYM8YUjz1jjwYd3j55yAQApboWkK9FeaGrmvAGbVa7ipSoqhaKF2hb7OTpK07FhwCySmD4f7wmrHUb+5hDkWz5inHpAl7Is8XDDchxz07fxNGzCxoPWxBUNhzyrWjdBnguRyq0Mu3+v78Ta2JGsEKGwe7ZgsS+wp7BgocXefqfYrW2ANVqzMI27gwuQszNdwbBktiBUvPIRkBqDRDkXvvhAmeaLlVMkiRS44mTl1hxfhYEhMQf6SpR4JZ5tU8e1Y+1iViXe/S6jDN4x/iiFdijn5rbeUUCrO484p19YARU51GuTuA403n/gK++rtMnFyqlbj4oGaEa26e2PG7iZX9320B3a9hdrbBZgD0+4kTwb+frtE2gKQXhrWVQqmOCVJdUKLx0qJg0M8gt1NIAsYnqm1kQg9s2agIpdEi1jn3wTp7YGV+rU82eYiFZmPQM+HxCsFWSr/LGw==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(136003)(376002)(451199018)(46966006)(40470700004)(36840700001)(82310400005)(5660300002)(36756003)(2906002)(356005)(41300700001)(86362001)(8936002)(26005)(316002)(54906003)(70586007)(6916009)(70206006)(186003)(478600001)(8676002)(82740400003)(40480700001)(4326008)(7636003)(40460700003)(2616005)(107886003)(6666004)(336012)(47076005)(1076003)(36860700001)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:37.0252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d36683-8788-4145-bf3b-08db084a85fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7972
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc parse action phase translates the tc actions to mlx5 flow
attributes data structure that is used during the flow offload phase.
Currently, the flow offload stage instantiates hw counters while
associating them to flow cookie. However, flows with branching
actions are required to associate a hardware counter with its action
cookies.

Store the parsed tc action cookies on the flow attribute.
Use the list of cookies in the next patch to associate a tc action cookie
with its allocated hw counter.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>

---
Change log:
    V1 -> V2:
    - Reduce tc_act_cookies_count size from int to u16
    - Rearange mlx5_flow_attr attributes for better cache alignment
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 39f75f7d5c8b..a5118da3ed6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3797,6 +3797,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
 	attr2->counter = NULL;
+	attr->tc_act_cookies_count = 0;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
@@ -4160,6 +4161,8 @@ struct mlx5_flow_attr *
 			goto out_free;
 
 		parse_state->actions |= attr->action;
+		if (!tc_act->stats_action)
+			attr->tc_act_cookies[attr->tc_act_cookies_count++] = act->act_cookie;
 
 		/* Split attr for multi table act if not the last act. */
 		if (jump_state.jump_target ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ce516dc7f3fd..75b34e632916 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -69,6 +69,7 @@ struct mlx5_nic_flow_attr {
 
 struct mlx5_flow_attr {
 	u32 action;
+	unsigned long tc_act_cookies[TCA_ACT_MAX_PRIO];
 	struct mlx5_fc *counter;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
@@ -79,6 +80,7 @@ struct mlx5_flow_attr {
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	u32 chain;
 	u16 prio;
+	u16 tc_act_cookies_count;
 	u32 dest_chain;
 	struct mlx5_flow_table *ft;
 	struct mlx5_flow_table *dest_ft;
-- 
1.8.3.1

