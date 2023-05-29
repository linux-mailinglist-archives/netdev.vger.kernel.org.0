Return-Path: <netdev+bounces-6053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D501B7148E8
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 902D5280E4A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF3E6D3F;
	Mon, 29 May 2023 11:50:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1DD746A
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 11:50:16 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on20606.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::606])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E339B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 04:50:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzHeFU6Pk3rt5hqcyZn+KuloqkyXfJcGld1Vm4TV2u6fjrIRC2gqRg92TZQVXelB+uYtopq4QyVwlv1dtb4o+vieDlWF2T13sGFzBv8cZ3AODw/nHpHEtbRvR/MS7sFFRG07TeW/hwsxFSO6BtP7ItcgsiDVhI54sR9VAk1wK5LXMMeSISQJGbEfauGGD6kaZB4fH6w3LV0v5fuli+5dYdftbq0X/UNYrVmuGF5yeiveDlHJNXuEgRaC9RErrJHSMzfd9seZ22+vaE3OXFC3L5moSl24jS690608gHfMQ8zO+7/CnGVJ4OUxFkQi+GHc2q4gkSe/WZdTZcdsPCfknQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCuNlmQ0Y+rlYqtiEwRxPujaPtzLQLWlpsV08N4GMOk=;
 b=jweztk2nda+YdVrsZOakP8RtCKVzemyb8PAZsBnNKX1fMSm6eRRjKJ1K3D+pRU3HIAJEWxeYP/+UUBjtK0X0FJqXkgRngPi/RME5cmBVtITD3GsVpenLwjNr9yjo3nmhz9l/Vg/GYpRQk9+RetCCkE4FgUygfgnhpToauvHhl3qAZUNLjHRiMAT0zSG+KbgWojjacnqstVH50UGqAy9e0j9+xvaWuV7Mb+ViHSPVp6wwnmhArfHzJwrvD6xTYMqoThtPn13fq1uH83h4c5HPs4X1WpHenEdKcUE9xZXegYEpklDuuYmvHz4IYFRNIklK/I3m+rcUC9MhKOwfmm5N7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCuNlmQ0Y+rlYqtiEwRxPujaPtzLQLWlpsV08N4GMOk=;
 b=EFGsWBVAwZqd9fFLXAP7dEdobuvRRtmmnYYk6fxqaQkMRRFaF58BXe6WsPOoiZq3t7X6zlpFszvLQFkBJvi0ZjMGq5d5oj7ZY2mdZvsKAbtoojxVCyI/l4MbYt3GJxCYBAy/XCgkmMTIHW8tLaI597YSikfT90y67tq/3jeyu95Qd7HQeVSY7IX0X/q5dAQioqdjdLYrtyXv9GvgBbZ+7CqjT/PISpVQmAzYJG/7iKwPNhWjNQJwMux8t7qbQHaJFiQSw7gQeqMM4gpSVsFTW5T4JL4B3Vjd3nJXImYCFHAOMtRBYgQJ2kPrlYHCBCFkGd5BnmnkzRTM8ZHF+rGb/A==
Received: from DM6PR05CA0040.namprd05.prod.outlook.com (2603:10b6:5:335::9) by
 DM4PR12MB6373.namprd12.prod.outlook.com (2603:10b6:8:a4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Mon, 29 May 2023 11:50:12 +0000
Received: from DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::62) by DM6PR05CA0040.outlook.office365.com
 (2603:10b6:5:335::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21 via Frontend
 Transport; Mon, 29 May 2023 11:50:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT036.mail.protection.outlook.com (10.13.172.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.21 via Frontend Transport; Mon, 29 May 2023 11:50:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 29 May 2023
 04:50:00 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 29 May 2023 04:49:54 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <taras.chornyi@plvision.eu>, <saeedm@nvidia.com>,
	<leon@kernel.org>, <petrm@nvidia.com>, <vladimir.oltean@nxp.com>,
	<claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
	<UNGLinuxDriver@microchip.com>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <roopa@nvidia.com>,
	<razor@blackwall.org>, <simon.horman@corigine.com>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [PATCH net-next v2 6/8] mlxsw: spectrum_flower: Do not force matching on iif
Date: Mon, 29 May 2023 14:48:33 +0300
Message-ID: <20230529114835.372140-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529114835.372140-1-idosch@nvidia.com>
References: <20230529114835.372140-1-idosch@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT036:EE_|DM4PR12MB6373:EE_
X-MS-Office365-Filtering-Correlation-Id: 709638a7-c7df-4df5-670a-08db603adc38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	F7k5mFEOks2Ha9Jv5s09r1iOfpRzxYhtMIMuBGMeXoOLizQOX4iHCopTj4PLsgIdVixi++f3H9+wq2NCzahALUC8IjPKF1+iMvZ3qSzjuluUfqCPl4zK6FUgeOMruGBIQo27CDpAHFGECS/CxNYbhgb62JRoNPLqnzhKMOe7+Sp7m708buX9jAoxGGjZcvuBt+5tlbJAsA6PFAVuKa06afzht57SaNfqHZJky6/IvPijIjDmcsYxWpoCGGPf/MrJHKLsxW2wlNjWgtcsx1iUS2ypPxY+mNAK1s/J+vUb7I71PBdplM30tk6GYyWwngMCJsKvRYrnYupqbGSIElcNwTKyUMDr3aVZi9yiEbncItZP7BlpeVMzi+Quvi1dCyYaUVG+4/YD0jlBi/tUngOtCDLUaENgYMlFsbVnInnVrVXecQmtrO6oldy4A/SAAE+PGB5A2KSwzQd+cwqm3l1GPsyBMh52FTjpPC9FsInYodyICrrQxiZr9V46UBSwTCpdKdgT9N3C5byEmKmCaa9TSRsNwc9U5fGx59oqAh64jfcGI2mKZ7luzHZ08vQUVXaTiLGYAIJr8di5kwXcCiOtVu3wM7jd2eMDk9Bs3tNH6dbretEj93iw7xMXX2COoXpqSQF93BSv24iHUIDriMIE4L4f+NCPtDlzeFgW4idrtE4SAMgwEzI4ROVDAN+uJAlI3ItAo+U3A3iC0Arx6NIH6qDcxYubg+qoWgSEAfw12WgOgL8VdFtaD59mVw+pQCum
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(396003)(39860400002)(376002)(451199021)(40470700004)(36840700001)(46966006)(186003)(2906002)(2616005)(54906003)(110136005)(26005)(426003)(336012)(478600001)(1076003)(16526019)(47076005)(40460700003)(36860700001)(86362001)(8936002)(7636003)(82740400003)(356005)(41300700001)(8676002)(40480700001)(5660300002)(70586007)(36756003)(70206006)(6666004)(316002)(82310400005)(107886003)(7416002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 11:50:12.0704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 709638a7-c7df-4df5-670a-08db603adc38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6373
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently, mlxsw only supports the 'ingress_ifindex' field in the
'FLOW_DISSECTOR_KEY_META' key, but subsequent patches are going to add
support for the 'l2_miss' field as well. It is valid to only match on
'l2_miss' without 'ingress_ifindex', so do not force matching on it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v2:
    * New patch.

 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 2b0bae847eb9..9c62c12e410b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -290,6 +290,9 @@ mlxsw_sp_flower_parse_meta_iif(struct mlxsw_sp_acl_rule_info *rulei,
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct net_device *ingress_dev;
 
+	if (!match->mask->ingress_ifindex)
+		return 0;
+
 	if (match->mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
 		return -EINVAL;
-- 
2.40.1


