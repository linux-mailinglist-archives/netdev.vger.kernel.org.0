Return-Path: <netdev+bounces-3589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A016707F85
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D53A02818D9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D943E19933;
	Thu, 18 May 2023 11:35:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E219932
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:35:10 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451C219A5
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 04:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hdt18Mbr3eNz6zJvtuUtShg/iXUwm9HFWkP7YrYbYiJ+wCg6y10cay4OBkltWeG+4Z6aWfsYxibDcuAPrtLjq3BcqJ0Uyprpeqxt8KD8xt5W+EqRyBCdp1c6Nw4oEFRIp2q4+y6ntpQcVVEKgKbsNN3P3OsjSs1nezxACBWxrTQHb9D1eHRiGB9+ILWz6Dw6y7PJcyLClN5AdEJWrawyowch8RqQU7f1jcTzp89SzeB99PUTymnYqVA/++ntdP/6KOoaGZQA9zmYF45y8VgUY/SzGmjOCcb4auZ6F3bZIa1pu7wJwlOjnn9M/j6RxaLyOaP5ktT7KWt6PZifOA/zXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nruIgm4v7mpElLZK3vX2XDPG6wn+168Lo+vJlkqbJmg=;
 b=VGPWJf0ltDfOjrbnq6Xb3dY4nmw00Z4HgRWA1dCAD87rDrd2TCSF9e5bchEyaOVbQQ8bBRgzN2nvFTMt9DKrgO3fLWItyf1jq6IjQJcrOoyju7je7sjj/WFzckkhoCmX4bBUW9QcBHMrkXNRoJirt7uFEuF2q4viszYNDLtmio5WRSSdQF0RtJiSF8U1Zg7SJA4Glc9BE3DA+okqY5Fh+S2xgJKrrwALJwN84MqLTezM0frEXEf+8AbJqJLe3c4qSn/zj/6ZlKMNTjgHLTD5hPsIzXRcS2l3AjQ3N8ZNCSfIT6dEN05QcutT6OU0MrOyvD1DamgsyLYaPs8GYPnsLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nruIgm4v7mpElLZK3vX2XDPG6wn+168Lo+vJlkqbJmg=;
 b=WsFPXonT23gA9HSwHacsCmopa5QKKTeVP5pV65CwdmEY5phsDO5Z+gv5TzjqjM/b+KoeD5+4y3COMoslyvEsfaz8CCpdSUcVEKlzn2Z6z0YkNv44wA8O786hoeCv93LA2F58lvZjOnqTIv6NTa2HbjE4JTi01Lhv1RWyfd4jq6XZ33BpLPn7WZgkkEzkW9w8KwQaTRsXGs1+G2tVUvvoxCVDm/Enz4LbjZHyq0Dme5bvB7x3/dbKISshthgpELLNpCHy0JJ1cl7hxuYqJ/LX9NDOTHB4WFWaVVfYjVF4qT1Ylsb/tQj7QVb//uOEIT1m0eimXEDD0y8xTvHU2vPtrA==
Received: from MW4PR04CA0195.namprd04.prod.outlook.com (2603:10b6:303:86::20)
 by MN0PR12MB5931.namprd12.prod.outlook.com (2603:10b6:208:37e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Thu, 18 May
 2023 11:35:01 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::4) by MW4PR04CA0195.outlook.office365.com
 (2603:10b6:303:86::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19 via Frontend
 Transport; Thu, 18 May 2023 11:35:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.15 via Frontend Transport; Thu, 18 May 2023 11:35:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 18 May 2023
 04:34:55 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 18 May 2023 04:34:50 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <roopa@nvidia.com>,
	<taras.chornyi@plvision.eu>, <saeedm@nvidia.com>, <leon@kernel.org>,
	<petrm@nvidia.com>, <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
	<alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<taspelund@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/5] flow_offload: Reject matching on layer 2 miss
Date: Thu, 18 May 2023 14:33:26 +0300
Message-ID: <20230518113328.1952135-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518113328.1952135-1-idosch@nvidia.com>
References: <20230518113328.1952135-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT064:EE_|MN0PR12MB5931:EE_
X-MS-Office365-Filtering-Correlation-Id: 218a5ce5-770c-412b-68f4-08db5793ea6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Q+9ymGGY2IWmaiKqPfuB9mYchsImiJ5qTU+1lLVcp6Kpsp5XvFxo+mCCNauGocafO1iLHIEcOcfbNp/e8YrAjg9F+9IRypVGq4NKyftW4UVQfGmT45wflNPb/lKj+BYcbafIngAh+W2lPt2y6lVsrvh6AhUWhsDs0UJttXQ+8pYkqFAF9L4A3f3A8wu/Vdl+ezwXrZc+OhkHzaUD5m53BDEmB2gchKASMFnPXfCc/aohv9nFfgmGOICjchfX9INhjcHbxvRvSXjLFdJI8Ux0YwNFF9MD/lryNLdoPEvnl+I9sJFZgj8/po8xw93e6H3I1UcTne9Kp7qSIWPelYKtRbQBp5DzoDMxNTkMbh1d/2/G3IC/AN5WPl81gO580Y+3hn+vmED67YpzNUAAyeINVVhP1N87VrG9dTIf+BKYuEdcLN33ntKCXAFtd1laOpgDJDtkeVxLVkrw2cWpUd94ecvhQIQOXVicBp+kd6RlU730yk3MF4NHHp6WFQE+KmkV+7gjpzvKCmY+28vSCizPouzxeBrTF39lUrv3ygukfPBhbBeHDp5za65ZSwyRBWeo18JPiSL6l6Jmv4patSrBi9j/pMRKHRGIiagCjIpxnwiCCyIs3Wfse1v9YCxcNWSD2DLhVACE/d+/UzXgZAoFZpETpjCgwCfmDMj383842j3eUZI3EaxNkPD3Vs0boXawOgyoCm2oKHXeLC/bW3QzTEEoKQ7HrfaBnfTPdH9v1XQdxufGyvLzRPj7eQ04EeQh
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199021)(46966006)(40470700004)(36840700001)(86362001)(356005)(40460700003)(2906002)(41300700001)(7636003)(316002)(5660300002)(8676002)(7416002)(36756003)(82310400005)(8936002)(478600001)(6666004)(36860700001)(26005)(1076003)(336012)(107886003)(186003)(16526019)(426003)(54906003)(2616005)(40480700001)(83380400001)(110136005)(70206006)(4326008)(47076005)(70586007)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 11:35:00.6146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 218a5ce5-770c-412b-68f4-08db5793ea6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5931
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Adjust drivers that support the 'FLOW_DISSECTOR_KEY_META' key to reject
filters that try to match on the newly added layer 2 miss option. Add an
extack message to clearly communicate the failure reason to user space.

Example:

 # tc filter add dev swp1 egress pref 1 proto all flower skip_sw l2_miss true action drop
 Error: mlxsw_spectrum: Can't match on "l2_miss".
 We have an error talking to the kernel

Acked-by: Elad Nachman <enachman@marvell.com>
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


