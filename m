Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A53168B01A
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBEN4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjBEN4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:56:10 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D988F1E5E5
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:56:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSEZcO96VMRs5XdBvQeHuoFSV+jRXUYZ3qVHV/PcaU8B/MqCMiV9fU0Lp6Ds0McaGvIoUK5fgOZR/OKhXrqt1ZGwokHgSWVu6nHFKJmyv5fg3aBz8nlCMxDuhJXEivga0pE732qHheEWI3OwOEwV1+RYj/TPCnOsoWezWm5YuEkRt/Cbjfzskxq9sG0NiBZRAdiKgKatFEBxjIyANuaG4SrErI6zsiD+QdR8K/UC0BWHowAp3mzC1pqBz0VviFYU5bkOAfucEESBpsPyCaANkTd83igU36nTSA/kBd02xsbMhlNcMySwTUqXceWM2cAwNhDLyELOdpLinm3ysHlMgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qH0uDYc0Gcl8lsCxYn8R81YLZ0hLaQjmJgjBfaeb48k=;
 b=DG6ylCG76MP/21r/LV6Z0vElT0G5+XZG4795IkSevR0UBQ6gxY4SLKN8w2iyoeeOgJRpSsMBvQe7QqADMz1m/jhnFRQk9F0XDg7PCOur8/yq6DCrpBYxwl8QQ3LS5mBG+19SgdbmRjFhpKt7Kc/Bb9/6GILZJrzbBaRffFBXpnM2vg4FqTSPo5rcLsJOmNhNG12omdHqXsGkzzsvsqAoMuJwmaEH3aS4SGWEET3mn1gw4ZeikPmvrbk2TPWXcXISoD58GauRYbLa5c+7BlP7exme3RT24xF9dlGp+iP5k/MnMSmOTzOeehdgXfHWbnM7Cf+a+f3Lw97yeOF8s6eCJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qH0uDYc0Gcl8lsCxYn8R81YLZ0hLaQjmJgjBfaeb48k=;
 b=PkVNhb2hun+pk56SzfRN5xRD4KDlkPXzPxXjpbyLiSjWd33kMvvCZy7zatX9xIIe9BpRI+FN0t6462AN3v2p5+3KKbUc9DIfFS2pI5pC52ZhYAFm2S8g/j6rxQRCw8GUJcGKe5JsVX9fbST/spVdXMPZYEbsCrQeslfZx6yQhTMyFum7UBXyZolwPfLShRnpvI3RXce/GAsyww9xK7uAi7mB2KOsulOuFiKWL7t51FMkKWLCFfIpwchYrH0Ebv+OE3343F250JlMnTUlzCWxaYKFnXvwa6OlMkm0obcVdVkd0XxVrueglCutIR/Wl03zar2gLuuBCBuKUiyiS0Td2Q==
Received: from BN9PR03CA0749.namprd03.prod.outlook.com (2603:10b6:408:110::34)
 by DM4PR12MB6063.namprd12.prod.outlook.com (2603:10b6:8:b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sun, 5 Feb
 2023 13:56:06 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::4d) by BN9PR03CA0749.outlook.office365.com
 (2603:10b6:408:110::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 13:56:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 13:56:06 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:53 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:53 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:50 -0800
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
Subject: [PATCH  net-next v2 7/9] net/mlx5e: TC, store tc action cookies per attr
Date:   Sun, 5 Feb 2023 15:55:23 +0200
Message-ID: <20230205135525.27760-8-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT021:EE_|DM4PR12MB6063:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f3f029-f445-41f1-e183-08db0780ba24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ND28dgyPIWOewNpmU/JZNJyCVGVNRYIAQVotjOYyqawUoz4/bEITiXUK59mNcZo7xO8mmvn5V3KtDOzic7sk90g6VUd4SKT0rKNuI4Oebf7B2Ff3ubb4q6nDcWnZCpMH7+Ay3aNtq77mxYg+W9WpuS2HO0QxwlVYmDv5Z1XtJLTQt7LTbp/3ulxnr+Xi4q89Kbvjktbjr5rVy9Ej1d/PGFmD4r2cy+el99uwpDuOF2Bd92LhNQ9yuEOVSYI7pNK8lZtSe7OhBhJ5USs37rmJcFm/lWIC6ENBVIIExiEj2Ns3DDfyjjZThm8QBlyCws0DHVpLpFfGWgSvMt23UCMqtmnSFjcuqq7OcS4wFj89VjJiTywyIz92hF29voJKj4JLXg+WkOIL8erUiT86DqLrtSyQbgP4QmGxgOTkByG+4GI3JAyWwT+Y06YPFttlcrv/V0/6Nz17pHVt3kllrqWSBxiRrqbKgFN2/bmeKq+fE2baQtiNUiyg8/oSYMzSVZHK4IlRRHMWsVGOThfR0NHnUn+lS0rcBN6MR4AoN3rolRy2+I5y92zKy8usC4vR4LRz3KTsUg1gA4FrhdUcCOgIgtspaG4UjiujLUt0N917oNJsvX/M08Z18UORYdtZq5IuXAruRLNUcAfGoxyWYCP3G7C1dcNPxeAN2GiW/ii0N/TrIbbm+Us88x+8o2MZCwiaBLQG0q5sGY2zPEGSpsXVQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(46966006)(40470700004)(107886003)(6666004)(26005)(1076003)(186003)(70206006)(478600001)(70586007)(4326008)(6916009)(2616005)(82740400003)(7636003)(426003)(336012)(40460700003)(47076005)(8676002)(41300700001)(2906002)(36756003)(86362001)(82310400005)(8936002)(36860700001)(40480700001)(5660300002)(54906003)(316002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:56:06.1213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f3f029-f445-41f1-e183-08db0780ba24
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6063
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

