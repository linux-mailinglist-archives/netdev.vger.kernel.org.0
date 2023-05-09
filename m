Return-Path: <netdev+bounces-1048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 747C86FC01C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30325281243
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:07:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C11911CB0;
	Tue,  9 May 2023 07:06:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874943D6A
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:06:21 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::613])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B001949C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:06:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DV9zvtTe/x8Fk+G7JX2+MlQTrH6lj8+D/K1nw68c+fFiMp5CCEjZjI0niFlSzJOGU7tXzWVn1FscviF/R63sASxzKMy09SQtRI9hU1rlr8IZhbVxbrocKZBwbHqRvcQS8O+QRAkSV78aJ82VCQn6awGiofk4k0k4yqSPafL3a5yz0/JV/om4jat4zaBfMiwbe/u1b7kgJT8XWnZAHjJTzGb6g4NBElIVGoioXQ70B6LtRLlYd6a7OawOG4C6xBnjWNGsry8lr4pPojijzam5cDm6uMCsb+8tSJqqswFBcf9gZmbWTIGqtz/P+mC9IO3qFQsbfhKCriOs+zaa6qa5PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9S6RUlmO9Z/UshuanS11ere5EERT8XTAs7u4y0iWwc=;
 b=AqI+305mPekUxAX32RJjsjkkl+0XRRtVGMYGA42pWSUD2tDjGcTcrL0BjBLF+2TYOLRDXGy5SkFKXK/g7/FL3A1hQXvM5mcuI0Ut86Ya4kC9mb8HD9tDhHQzjo3+7uI4tvvyuAqJ9utesLzXNlKOrPoD32Kz3Ag9QzXwIigwKM6OU9Vl2Cj5aMX3sTlsnWM2GKFVSLblIzo0zxLgo4q32mSuw6I/0GYBMEkBelkSnDcWziN+HBt9Ba7ZfiqdAHv5Q5cORrYqw3frpyaYC9juZD6D46eIzOw1diE21ZUU3gTkBbBKaYZMPtIzfBc2Qleg2yw0/1JZAYZRPm3WFOcMGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9S6RUlmO9Z/UshuanS11ere5EERT8XTAs7u4y0iWwc=;
 b=dHZqPtwdYNjO2SUriDNwqsVFloFlueC1sa3+xBNChaF4itALjSRxvZndyaP9L584z94sKboHQC5ep2Df2pfEWz3aReX6kVI3zZQU27axgiGWAJxn0+CTxRvv2wvvxxcEbRjbIXf72tXvYaWWD3lhnNd2mHXOwhIAGde/ThmPeIVF4pl9Qaesg776WhmPCD4hdcaxlP1FRV7LJt1YMepww1yIx9l4+ihn9MJDO6OnUnhi3QCtVzIRDpWrByDgwgQvHAOF7gL479nw9+C6QVgpuYoqkz9rXVNuFOTLl1M/Ru6PDwW355M/e/kLtkJVW1MPtLHRBSnvdShOUiydr1g2Ew==
Received: from BN0PR07CA0002.namprd07.prod.outlook.com (2603:10b6:408:141::17)
 by PH0PR12MB8821.namprd12.prod.outlook.com (2603:10b6:510:28d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 07:06:11 +0000
Received: from BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::3c) by BN0PR07CA0002.outlook.office365.com
 (2603:10b6:408:141::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18 via Frontend
 Transport; Tue, 9 May 2023 07:06:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT070.mail.protection.outlook.com (10.13.177.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33 via Frontend Transport; Tue, 9 May 2023 07:06:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 9 May 2023
 00:05:58 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 9 May 2023 00:05:54 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<petrm@nvidia.com>, <taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 3/5] flow_offload: Reject matching on layer 2 miss
Date: Tue, 9 May 2023 10:04:44 +0300
Message-ID: <20230509070446.246088-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230509070446.246088-1-idosch@nvidia.com>
References: <20230509070446.246088-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT070:EE_|PH0PR12MB8821:EE_
X-MS-Office365-Filtering-Correlation-Id: 9da3c509-4f12-42c8-c2a3-08db505bde9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zWZMTQkgGMqOH2rU0R8G1zo3vKzEYtt4HJg4m+VFaPO6aRLh9kyimg8OMiB0YazsZ+XJZEASdiLlWwQn+JJOv6pNROWHBU7mX7Gjc7vIW29+rWJYTzwEuqphby1RWgaDYTMLtKyU5HlbecN7xbDHCqv9a7Arg6KNkJDh1CNEkEy9JMtw6qf3yxqdUvBGDZAXPRctV7nuZHpb35WX2aOesmb7urSNYFpS22eqW/CrD3NvJEtNogs5YWy3ab7IEnyzHWjL5xgczzJNfNiy6z4nb70vofCZZV8F5M3lt6cbV8bszK6gTMK20dFupq7Hqg4Hbo7gUtmMUbT57IX3jsXmsfYge9b+u8VeeeN6w4UP/BpXTpgmE8AJS84Qh7iCeISTkEMe5yrQTc3yyzcYr/U/vpIttITZFGxMrEnR3TQ/jjuhuWF+CRCunVNy1bABJWOAc8na7wLlUbRTF588IvVrYlr0wWViY7fSp5MVB3z6ygisXWt0BqZMrm3Ba3GOrdk8AFguCN6Lhw+lJsaP6DJx4sSfswOzzMwYzzCfI9nLdPwoOd88iwihzQ/rRX3P+iTOov9nLMJJfZHfn4FzyNneyJGw5nCdo8ngs4+9GVx/vvMy9mS63sYRDLUhC8f2eGY0QDyNZxC+hWL81xgTDrgXjWVVSJzVv0mpmTMJwFC8++LQ+VcvkwIHu/y5AWoPoY+G0E51dY3Hp9IqFf+QT9eHig==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(46966006)(40470700004)(36840700001)(7636003)(54906003)(4326008)(2906002)(8936002)(478600001)(316002)(5660300002)(8676002)(41300700001)(16526019)(110136005)(6666004)(70586007)(7416002)(70206006)(1076003)(26005)(107886003)(186003)(82740400003)(47076005)(40460700003)(2616005)(36756003)(36860700001)(426003)(336012)(83380400001)(40480700001)(82310400005)(86362001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 07:06:10.8268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da3c509-4f12-42c8-c2a3-08db505bde9a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8821
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Adjust drivers that support the 'FLOW_DISSECTOR_KEY_META' key to reject
filters that try to match on the newly added layer 2 miss option. Add an
extack message to clearly communicate the failure reason to user space.

Example:

 # tc filter add dev swp1 egress pref 1 proto all flower skip_sw l2_miss true action drop
 Error: mlxsw_spectrum: Can't match on "l2_miss".
 We have an error talking to the kernel

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/marvell/prestera/prestera_flower.c    |  6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  6 ++++++
 drivers/net/ethernet/mscc/ocelot_flower.c              | 10 ++++++++++
 4 files changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index 91a478b75cbf..3e20e71b0f81 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -148,6 +148,12 @@ static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 	__be16 key, mask;
 
 	flow_rule_match_meta(f_rule, &match);
+
+	if (match.mask->l2_miss) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on \"l2_miss\"");
+		return -EOPNOTSUPP;
+	}
+
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(f->common.extack,
 				   "Unsupported ingress ifindex mask");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 728b82ce4031..516653568330 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2586,6 +2586,12 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 		return 0;
 
 	flow_rule_match_meta(rule, &match);
+
+	if (match.mask->l2_miss) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on \"l2_miss\"");
+		return -EOPNOTSUPP;
+	}
+
 	if (!match.mask->ingress_ifindex)
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 594cdcb90b3d..6fec9223250b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -294,6 +294,12 @@ static int mlxsw_sp_flower_parse_meta(struct mlxsw_sp_acl_rule_info *rulei,
 		return 0;
 
 	flow_rule_match_meta(rule, &match);
+
+	if (match.mask->l2_miss) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Can't match on \"l2_miss\"");
+		return -EOPNOTSUPP;
+	}
+
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported ingress ifindex mask");
 		return -EINVAL;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ee052404eb55..e0916afcddfb 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -592,6 +592,16 @@ ocelot_flower_parse_key(struct ocelot *ocelot, int port, bool ingress,
 		return -EOPNOTSUPP;
 	}
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
+		struct flow_match_meta match;
+
+		flow_rule_match_meta(rule, &match);
+		if (match.mask->l2_miss) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't match on \"l2_miss\"");
+			return -EOPNOTSUPP;
+		}
+	}
+
 	/* For VCAP ES0 (egress rewriter) we can match on the ingress port */
 	if (!ingress) {
 		ret = ocelot_flower_parse_indev(ocelot, port, f, filter);
-- 
2.40.1


