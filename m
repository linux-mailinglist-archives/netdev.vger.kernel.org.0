Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F3F6E4782
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbjDQMVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjDQMVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:12 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1377DA7
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEhaASO/FeIXF1lDY5rvVyd588tRwblg88ZNwsYYdsbseWpNAGE6gmjRHjNSJOgwsFzUzqPWVjPfieWvCt4+GFGogW/aj8xS1/WQMAp8NX+Z6IOkvOJX+2JliACz7Tc2hnwivRI5ltceoJc/oYkHxPcTYSTY4WzCvhDpmgha0As2+zsFg1ofDCMcy4DZ8tcn2Y/YKZBw7H8tIHb9qgB103cvrHzL6vLtixvx6qSICjzOLQ1UDWMGSvKMYprNzZUmbw2ReqvO9m4mAG6daSmA0oPDb+AT7tqg3KfZsc1ex8/hvxy7dxWIyDsFVlEm1LHuo9ykY8QayMFZ5agOzNOWLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpSovxxu0w/FldQa8kWpECApiGI1zFbWcM0R+WK9slE=;
 b=JKU6N+UsLYlvj4lb8n0IGEamobolWTO161u98KgGNB3UE5j48q+liqQyGQxK/5JevOVfVPkVTTQRdwMc/G7jGCKIBi962Ci+wNowgb7vpHUkN7QqOKtskLFWl/3UOydLMczCik+6G1kANgC/atXcUZ+K33OvAOFq1Ft+nMmvrRXeYWbPnVaqVzkCW37f9d1yoyD6tIFhLcFoIn39KqhAzBAe7RDlYkn9GhcI4ursINaUuwQ9Pahq1m8P6CDk00+Q9AAZnBcuisFEzjA5xQHtJ04cTTXbnlW6EIe57mh/LVBpYJA2jm5pp/C0GfVDEaUsXzjGsm79ZABpjs8/6d9msw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpSovxxu0w/FldQa8kWpECApiGI1zFbWcM0R+WK9slE=;
 b=lOnK9rQeEow+NO1VYJm9JPMBNu7LF+V7sjO7D+jq0frCZpOkBw4PRy5A63HmwIhVimQAfT6ukutsr6nFI3Ho11tXBQjO45D8oxh/zY0/Nod1zmFEYdJx9Gv7S5WbqW4AdqxmZOF9ApTZnPu9lQ++vtBxzT7YLBLW7AoHHX3LWQ9CHx3cGqYrcNkVeac21oMV0+3rGEL0uXfIWpzb7wJ97i/LyM7KhsY2SGl6sUIJVrwvjJzp39i0RSk7Ppx4ewnSVBhVIflQivqyKFZcbUSj4cmH3e1+F85B3v3+Tyaho1sczb5z5Di3mJY7gs1GH7UJZ65MdJ9TALjrgBiah7cZHQ==
Received: from BN1PR10CA0023.namprd10.prod.outlook.com (2603:10b6:408:e0::28)
 by BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:38 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e0:cafe::aa) by BN1PR10CA0023.outlook.office365.com
 (2603:10b6:408:e0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19 via Frontend Transport; Mon, 17 Apr 2023 12:20:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:17 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:16 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:13 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 08/15] net/mlx5e: XDP, Let XDP checker function get the params as input
Date:   Mon, 17 Apr 2023 15:18:56 +0300
Message-ID: <20230417121903.46218-9-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|BN9PR12MB5179:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d1e8d96-9eb9-4f88-2202-08db3f3e2752
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8q+qbptDwAhsgDWmwEKUDsATCf1IRLbAU5Wgzw3/UHqPqqplZqPFgRxzLm0f+KiIocyDg/qNFra4pX7rdgKetJfhiWxInQcBFVaJE0+Mw1tEmtZxh2ebS0lopH6j+2qKcF1UCpUOksgQchawyoDfgEvRhH0JBBb4xCkThL1lVpJ71T03GYyGJZ1NZLO8hbd40fR5/dOBVr+I0PT/q9HTTshE4kIg1HM34fvqcdHPMsNc4a2HOMdAxz9VF2IK90fxs/CnGFvNvBZ2HuO7kdPx2zByX7+GNKT1RWtLZw7dD1veYADrGjSDB8Qret1CkRGwZNKAlpXmEbO7R/Uor+H26Pmrz8ItPt6vu70sHYNkviwA23xSzWLa41J1g8A1V9p7VGqM/kxPFTjGRAGFhGCJQwKVwjhj+tHYre9JqJxPyC/lfhgSg2paebL6PCgC4pB5UWpsDVizdzHvF1ugDSdCWfD4vF8aichfSslg/G0/ytbu34IgkZIkSHzR03OGmasc9+iWRxzChha/vD7dS/kqahR3h6N9DWThC2YAb2dBThjSZJm3lFAT7r2cRYmB6YymMnBx/76Lyon3rditnFy5PLPHP6Q3mM6Bh4/zZQBmB2da5pR58dtRHkoHzTZI2koeFEXZbLANoTsXyOtnOZUvstBoiMc5+KCqOMkRDnfAUniaL3/Vt1+N8bpemUjuoVQVTlXAS/kcrpR1QnLXdYo36GhbSSEW3TcsdXyi31qKgf3NuGhfFn1QCSbLyxyluHOcE+LX9oVUZEyT5SfpB374PUrty+NJnpJKRgOJmgldqCTCgRtDXshaJ/lXZm1t7ltY
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(426003)(7416002)(5660300002)(82310400005)(2616005)(336012)(86362001)(47076005)(83380400001)(186003)(356005)(1076003)(26005)(7636003)(82740400003)(107886003)(36860700001)(34020700004)(8936002)(8676002)(110136005)(54906003)(478600001)(40480700001)(6666004)(7696005)(41300700001)(316002)(40460700003)(36756003)(4326008)(70206006)(70586007)(2906002)(15583001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:38.1242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1e8d96-9eb9-4f88-2202-08db3f3e2752
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5179
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change mlx5e_xdp_allowed() so it gets the params structure with the
xdp_prog applied, rather than creating a local copy based on the current
params in priv.

This reduces the amount of memory on the stack, and acts on the exact
params instance that's about to be applied.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index faae443770bb..6a278901b40b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4773,20 +4773,15 @@ static void mlx5e_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	queue_work(priv->wq, &priv->tx_timeout_work);
 }
 
-static int mlx5e_xdp_allowed(struct mlx5e_priv *priv, struct bpf_prog *prog)
+static int mlx5e_xdp_allowed(struct net_device *netdev, struct mlx5_core_dev *mdev,
+			     struct mlx5e_params *params)
 {
-	struct net_device *netdev = priv->netdev;
-	struct mlx5e_params new_params;
-
-	if (priv->channels.params.packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
+	if (params->packet_merge.type != MLX5E_PACKET_MERGE_NONE) {
 		netdev_warn(netdev, "can't set XDP while HW-GRO/LRO is on, disable them first\n");
 		return -EINVAL;
 	}
 
-	new_params = priv->channels.params;
-	new_params.xdp_prog = prog;
-
-	if (!mlx5e_params_validate_xdp(netdev, priv->mdev, &new_params))
+	if (!mlx5e_params_validate_xdp(netdev, mdev, params))
 		return -EINVAL;
 
 	return 0;
@@ -4813,8 +4808,11 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 
 	mutex_lock(&priv->state_lock);
 
+	new_params = priv->channels.params;
+	new_params.xdp_prog = prog;
+
 	if (prog) {
-		err = mlx5e_xdp_allowed(priv, prog);
+		err = mlx5e_xdp_allowed(netdev, priv->mdev, &new_params);
 		if (err)
 			goto unlock;
 	}
@@ -4822,9 +4820,6 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 	/* no need for full reset when exchanging programs */
 	reset = (!priv->channels.params.xdp_prog || !prog);
 
-	new_params = priv->channels.params;
-	new_params.xdp_prog = prog;
-
 	old_prog = priv->channels.params.xdp_prog;
 
 	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, reset);
-- 
2.34.1

