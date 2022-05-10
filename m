Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CEF520D72
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbiEJGCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbiEJGCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F5F294489
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OED2/W0sSx06h/BakK+atf2g3majpbAFxmPvuZTdfUIcfDRtpv+EqRZx2cgyYQ/8NSKWVbXiuPutCLFNBh2osTyNYz708NoLqF+3OviXhTAul+cS4fk9Ap7cpC5Q8B6sYue+idmcC/Qh41oNK+dlXo4LrgOxs8LiZ6oNrMVtTSxR8f1KTTDOBZfT+y6cWdmoEhrvPITXt6Xc/s2fjHjBYnVQx1cgDLgEkvsfbTG5Sna/TpMeKlnbzDmyek6bEXfisek8l/BvfQKmCI3a5ZMBAzVMZlQdWvTUu/BPdqZeqZkrObOrco/9ilkS0aIX9GjyN2uGAdMNmmSTubaU2sjqUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffkI/8Qz1d2fVTz6duSjReWvyk53wqVZMYw1nEu4uhg=;
 b=LZ92xhllLl00nmR3KntEFBRU0gBWukJHuq+NrFK+FpzUeImTVAasFt5yzOvn/SOxskl7zhoVbWQ/KFilkbcLQHEvxJfdXVwyIAyy1S64DPu8//BJjIC7VTFxMBF57Xn/irz9H+s/ePoNHkwF/dRu3J+XYgVRZ006WrhFM2dJQq9yqUMvsI79SRdvhVkAmT83ylvjH1qa7B/uvznt5opgdglkSwMqyga+pt3UTFU5oCHKEolTK/l2FVpcsyFcbrUv2ldbiHbpHhDinGCjZbNGUtXCopYu7BdN92SkRu0mBlBgkrrESGOqeTi6TjDr8fy5bZUv5cV8kFnViOxOzC26tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffkI/8Qz1d2fVTz6duSjReWvyk53wqVZMYw1nEu4uhg=;
 b=j9K1qdrinx4DpsGjQp+k5u83KIty3Bc58/cp3LFndK1YKe8F8siY4Hb+3qs24PoKQtTZs1nenuNk9c2Nlvv6IfOx1v6nSq6ljstfOCY+6yfDxe2e4o2h8EaPBmxpeFVIKD9T+pla5pXY47oqptiNRt4li8ACBXPsAA1TJjKsHNpXhEWoHQhF+6Dq9RQmHaijpFXswYDn5um/8G78ea7oXypeLiNs3RIfMkzPYfnS0dCYS+EqpB6soY9YO4UmMeOVRLKGqT/r2HwFEidvyYYEfNBgvOJZalYutfh9ErSgfiTxI2/6/d0wSdldUyeHQ9ewGS9Cng4vhTiH3AQcs9YvVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:12 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:12 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: Lag, use actual number of lag ports
Date:   Mon,  9 May 2022 22:57:39 -0700
Message-Id: <20220510055743.118828-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:a03:114::13) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4609593-2ef4-4561-600e-08da324a113d
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB63832665443CA0D467AB05D2B3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Fl+QVRQ4qfKPVEMJi/ouMdnfprXRB5Urg3KM9TwKRhQ1fjateG6SrcCeSftbyftZ6RIqpHOHFGXqUiF2jLQ9T5Kl6G4omjLekVGR1Yam2AiFVRJ0SA7VOee4xbOIHH+urcT2tEYWoKkc/hC2dzT0z8fz6swDLlHhsSdtI8vRE6sd+TlHO1baMZ/CVdqa83s4OgJwRFpBs1Nlx+ef6x8F2WmvayN345T+fENCRV+3n8S31E8HNKUQstPSQM+lbXaq07c79u16eHHMqaoGytNXVdF536OvuB9+LCaJ9SCvcGcBGQLPWiF69M2cwY6xrPG9ekXSjCSyAhLf+Ch8qQnWa8GT4XEWH/ZPH84bsDbY3ZsY+8gwllJR/v5H6AAUVSxkMq3dg9eOFwDgaCwz+OgTWnhsEzjjlMIV810iHDoU64z4wGOwBz4fyiLMOJC3bTYynp/WSgVHCdwVV/MpcLYnU2s8zgkye6mJmrScdZVnTk+P43mDtF8FX0XFaz1G/1N2cdCGh3mBeb3PfjkTR16EpO96TMqqbbL1IOffU0vRt/DtrUdMpLhSn5UlSPgEL/8Bg4B5w7YK+iNyy6nkhyx8ctBcyITq0nCVVSlnwsDA9SCpeC1IahRpv9EW9Xyr3CeY9vyKCLjRZj2zQmIxAmTrweOVEayFJC08Tcehd2ngJExHVJikughA1M8MnifPSJT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003)(30864003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aKYcvokWvCUSH+Bb2aqkXTNWNKyfrMk4s0Q9rmkNr8/VfpLwLIrzONNlDeuE?=
 =?us-ascii?Q?A38niTvXXcECsKWmwFivAqi3TlEWamfmP8iVlllK2mGKGVFxrMtMEFXO/NmC?=
 =?us-ascii?Q?3H56xNcUuRWQ9zQiKZ6vFYwzaXL/q91sqIeZBcBH2dEr6MUYYO5W7n+IakSK?=
 =?us-ascii?Q?8tUllxs14wjxxafDqs//HUPMZ9TBnp7lST93JwSuDwGyWH6Lcv+cHmf5C193?=
 =?us-ascii?Q?P3LLoqawtOrvoIDhOVGeSdnJX7FTxSXOi/t3b83shxea4EziYFMDX2dMxGga?=
 =?us-ascii?Q?OH9okxPVORYMPYOvaz8I7BHAdjLYPjA3mz+w20fgxaS5JZU1vkSG84Tznh8+?=
 =?us-ascii?Q?DUfl59B/K/IG0eAhHsKoMkb82RU3Xs9bY405Nn4HefVh1mDL1899tmbmOSV4?=
 =?us-ascii?Q?V3xKdAt3ovywcx3rZzlkz4p8IP5d5qUUULNikHz+WD9E1rXNP1nvvBFrWDPk?=
 =?us-ascii?Q?GhjkVX/g1sw4tv91/mqWSQaVHxHdhIdTTBBLTeS95y5XGxNWAn3oXzbXCH4D?=
 =?us-ascii?Q?kk6jJX6bQ74/e4qKe3GPc3kP/xgmh2zX+llRaD5kWBgP0mwlKVF6Wm8gzGuh?=
 =?us-ascii?Q?2mA9QTDUOU0W4Yt4WnoSwj7nJ7vEUQJu79SAxQC428bErm2Pbc5Yc3shVPIc?=
 =?us-ascii?Q?gPLb80gKgaXVXGRPEgK/P49Y5fOz+SbsyXWOOCpYXPVnIDxYdc/jp+ceuQLp?=
 =?us-ascii?Q?c6YyoLUMzGm54qkIZIJtdqigTDcDeNRetxYRw3/P+Eve+zxcM6C9LfSrGF3D?=
 =?us-ascii?Q?EfjHCT4NwcQIsw9AYA8GPU9cEJZ7PYK9CHGirZ2xnlIHAvy+WL86Gq9NbCHA?=
 =?us-ascii?Q?9A9T/1ZWLglD+CkpmoCQnV0++EHSM3/Paw4Czdjq3amaZB2MKi8aLz1m2OMo?=
 =?us-ascii?Q?F2ik6fusrikTRR8GuUgWaJoAplmpJLhayR7ss5YnCsg4rZkgPCLv3JdZfalA?=
 =?us-ascii?Q?5lGzFXY0XfoUQdT34Zls0Zwn2+9gUosCtJrSfC5CYSz4M+sqe+Kb6jedVTR5?=
 =?us-ascii?Q?3wJggwTOd/eK0hmHYYHTtzjf6WfVckQ5Ife2x2g5yi2acHuFtz17Pq82s0qs?=
 =?us-ascii?Q?H7FXhwGIACxpW7koA3RJNK2mzh52S9uEuUotqWMBxF3p8UikYl8OsUO6GFRE?=
 =?us-ascii?Q?HBO9Ty/m7Ey1RwX/jqd2R6guCRJ7DvuTjBuk2D6vDHZAKbqiJ7JqtVxjO7Xj?=
 =?us-ascii?Q?CmRrFvBUOdwBf2By0zS2Zstn9SvpnkmFZCuOFjSK+NMwm76npSkGHd4NdydK?=
 =?us-ascii?Q?yy9fp+7lFLkQPx3Vx4Wvt+aN6s9GuaN4A+9U8zW5i1c6BLvLz4abobcR3qR4?=
 =?us-ascii?Q?3rSYRhuXm+BpmUTXwCiI2IL25hZs2SMIDIkdbEBkSy4uEixMUX0cy59WmUu7?=
 =?us-ascii?Q?isXJJaZFwmtvEFhbS1MX7mIMKmJpoABbOvhOx4+xgxfuL0mHJpy1GZNkr2p5?=
 =?us-ascii?Q?Bx+z4tKrXbiWyLijpPupswU0zcVkiKu+h/+YjUx48kq8k1yzVbWr7ot4BRMs?=
 =?us-ascii?Q?D+vER1iM9DLtOXJ78etCEsb0uzlDFhmteRDVo2//3utvcuF1s2gSLKy9UmhE?=
 =?us-ascii?Q?da6pk4RNtV2EHH7I3+AMH38sXY6x03gY2atMzeYiBiI9ZmzvNrdEyClDXTYv?=
 =?us-ascii?Q?oTHS+6AAZ9HvNZA4ZTiLIlPPh321AvPzOJtZoUbV+I0B+CFl55uDSU0fo8di?=
 =?us-ascii?Q?1IIGKkC33FUymDoajQ/zw2lHDH5CKVLdnSMEWLGMmGdeHxmddmVMfXLFlT7R?=
 =?us-ascii?Q?oTCy01+DuthP82omCaLW3HpTjNNU7esmkzvaQfRnEYVbSfwGdsO7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4609593-2ef4-4561-600e-08da324a113d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:12.6268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FaNyzXcyQKQmEqCFPBZcNfTP67iTcSgkn7+GLYzmUzc9ryB067FNc/eFbxG+/o4m6YFuAlhpmNyBPUN51Y+4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Refactor the entire lag code to use ldev->ports instead of hard-coded
defines (like MLX5_MAX_PORTS) for its operations.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/lag/lag.c | 295 +++++++++++-------
 .../mellanox/mlx5/core/lag/port_sel.c         |  60 ++--
 .../mellanox/mlx5/core/lag/port_sel.h         |  10 +-
 3 files changed, 216 insertions(+), 149 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4f6867eba5fb..f2659b0f8cc5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -53,8 +53,7 @@ enum {
  */
 static DEFINE_SPINLOCK(lag_lock);
 
-static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 remap_port1,
-			       u8 remap_port2, bool shared_fdb, u8 flags)
+static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 *ports, bool shared_fdb, u8 flags)
 {
 	u32 in[MLX5_ST_SZ_DW(create_lag_in)] = {};
 	void *lag_ctx = MLX5_ADDR_OF(create_lag_in, in, ctx);
@@ -63,8 +62,8 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 
 	MLX5_SET(lagc, lag_ctx, fdb_selection_mode, shared_fdb);
 	if (!(flags & MLX5_LAG_FLAG_HASH_BASED)) {
-		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, remap_port1);
-		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, remap_port2);
+		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[0]);
+		MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[1]);
 	} else {
 		MLX5_SET(lagc, lag_ctx, port_select_mode,
 			 MLX5_LAG_PORT_SELECT_MODE_PORT_SELECT_FT);
@@ -73,8 +72,8 @@ static int mlx5_cmd_create_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 	return mlx5_cmd_exec_in(dev, create_lag, in);
 }
 
-static int mlx5_cmd_modify_lag(struct mlx5_core_dev *dev, u8 remap_port1,
-			       u8 remap_port2)
+static int mlx5_cmd_modify_lag(struct mlx5_core_dev *dev, u8 num_ports,
+			       u8 *ports)
 {
 	u32 in[MLX5_ST_SZ_DW(modify_lag_in)] = {};
 	void *lag_ctx = MLX5_ADDR_OF(modify_lag_in, in, ctx);
@@ -82,8 +81,8 @@ static int mlx5_cmd_modify_lag(struct mlx5_core_dev *dev, u8 remap_port1,
 	MLX5_SET(modify_lag_in, in, opcode, MLX5_CMD_OP_MODIFY_LAG);
 	MLX5_SET(modify_lag_in, in, field_select, 0x1);
 
-	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, remap_port1);
-	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, remap_port2);
+	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_1, ports[0]);
+	MLX5_SET(lagc, lag_ctx, tx_remap_affinity_2, ports[1]);
 
 	return mlx5_cmd_exec_in(dev, modify_lag, in);
 }
@@ -174,7 +173,7 @@ int mlx5_lag_dev_get_netdev_idx(struct mlx5_lag *ldev,
 {
 	int i;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
+	for (i = 0; i < ldev->ports; i++)
 		if (ldev->pf[i].netdev == ndev)
 			return i;
 
@@ -191,39 +190,69 @@ static bool __mlx5_lag_is_sriov(struct mlx5_lag *ldev)
 	return !!(ldev->flags & MLX5_LAG_FLAG_SRIOV);
 }
 
+static void mlx5_infer_tx_disabled(struct lag_tracker *tracker, u8 num_ports,
+				   u8 *ports, int *num_disabled)
+{
+	int i;
+
+	*num_disabled = 0;
+	for (i = 0; i < num_ports; i++) {
+		if (!tracker->netdev_state[i].tx_enabled ||
+		    !tracker->netdev_state[i].link_up)
+			ports[(*num_disabled)++] = i;
+	}
+}
+
 static void mlx5_infer_tx_affinity_mapping(struct lag_tracker *tracker,
-					   u8 *port1, u8 *port2)
+					   u8 num_ports, u8 *ports)
 {
-	bool p1en;
-	bool p2en;
+	int disabled[MLX5_MAX_PORTS] = {};
+	int enabled[MLX5_MAX_PORTS] = {};
+	int disabled_ports_num = 0;
+	int enabled_ports_num = 0;
+	u32 rand;
+	int i;
 
-	p1en = tracker->netdev_state[MLX5_LAG_P1].tx_enabled &&
-	       tracker->netdev_state[MLX5_LAG_P1].link_up;
+	for (i = 0; i < num_ports; i++) {
+		if (tracker->netdev_state[i].tx_enabled &&
+		    tracker->netdev_state[i].link_up)
+			enabled[enabled_ports_num++] = i;
+		else
+			disabled[disabled_ports_num++] = i;
+	}
 
-	p2en = tracker->netdev_state[MLX5_LAG_P2].tx_enabled &&
-	       tracker->netdev_state[MLX5_LAG_P2].link_up;
+	/* Use native mapping by default */
+	for (i = 0; i < num_ports; i++)
+		ports[i] = MLX5_LAG_EGRESS_PORT_1 + i;
 
-	*port1 = MLX5_LAG_EGRESS_PORT_1;
-	*port2 = MLX5_LAG_EGRESS_PORT_2;
-	if ((!p1en && !p2en) || (p1en && p2en))
+	/* If all ports are disabled/enabled keep native mapping */
+	if (enabled_ports_num == num_ports ||
+	    disabled_ports_num == num_ports)
 		return;
 
-	if (p1en)
-		*port2 = MLX5_LAG_EGRESS_PORT_1;
-	else
-		*port1 = MLX5_LAG_EGRESS_PORT_2;
+	/* Go over the disabled ports and for each assign a random active port */
+	for (i = 0; i < disabled_ports_num; i++) {
+		get_random_bytes(&rand, 4);
+
+		ports[disabled[i]] = enabled[rand % enabled_ports_num] + 1;
+	}
 }
 
 static bool mlx5_lag_has_drop_rule(struct mlx5_lag *ldev)
 {
-	return ldev->pf[MLX5_LAG_P1].has_drop || ldev->pf[MLX5_LAG_P2].has_drop;
+	int i;
+
+	for (i = 0; i < ldev->ports; i++)
+		if (ldev->pf[i].has_drop)
+			return true;
+	return false;
 }
 
 static void mlx5_lag_drop_rule_cleanup(struct mlx5_lag *ldev)
 {
 	int i;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+	for (i = 0; i < ldev->ports; i++) {
 		if (!ldev->pf[i].has_drop)
 			continue;
 
@@ -236,12 +265,12 @@ static void mlx5_lag_drop_rule_cleanup(struct mlx5_lag *ldev)
 static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 				     struct lag_tracker *tracker)
 {
-	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
-	struct mlx5_core_dev *inactive;
-	u8 v2p_port1, v2p_port2;
-	int inactive_idx;
+	u8 disabled_ports[MLX5_MAX_PORTS] = {};
+	struct mlx5_core_dev *dev;
+	int disabled_index;
+	int num_disabled;
 	int err;
+	int i;
 
 	/* First delete the current drop rule so there won't be any dropped
 	 * packets
@@ -251,58 +280,60 @@ static void mlx5_lag_drop_rule_setup(struct mlx5_lag *ldev,
 	if (!ldev->tracker.has_inactive)
 		return;
 
-	mlx5_infer_tx_affinity_mapping(tracker, &v2p_port1, &v2p_port2);
+	mlx5_infer_tx_disabled(tracker, ldev->ports, disabled_ports, &num_disabled);
 
-	if (v2p_port1 == MLX5_LAG_EGRESS_PORT_1) {
-		inactive = dev1;
-		inactive_idx = MLX5_LAG_P2;
-	} else {
-		inactive = dev0;
-		inactive_idx = MLX5_LAG_P1;
+	for (i = 0; i < num_disabled; i++) {
+		disabled_index = disabled_ports[i];
+		dev = ldev->pf[disabled_index].dev;
+		err = mlx5_esw_acl_ingress_vport_drop_rule_create(dev->priv.eswitch,
+								  MLX5_VPORT_UPLINK);
+		if (!err)
+			ldev->pf[disabled_index].has_drop = true;
+		else
+			mlx5_core_err(dev,
+				      "Failed to create lag drop rule, error: %d", err);
 	}
-
-	err = mlx5_esw_acl_ingress_vport_drop_rule_create(inactive->priv.eswitch,
-							  MLX5_VPORT_UPLINK);
-	if (!err)
-		ldev->pf[inactive_idx].has_drop = true;
-	else
-		mlx5_core_err(inactive,
-			      "Failed to create lag drop rule, error: %d", err);
 }
 
-static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 v2p_port1, u8 v2p_port2)
+static int _mlx5_modify_lag(struct mlx5_lag *ldev, u8 *ports)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 
 	if (ldev->flags & MLX5_LAG_FLAG_HASH_BASED)
-		return mlx5_lag_port_sel_modify(ldev, v2p_port1, v2p_port2);
-	return mlx5_cmd_modify_lag(dev0, v2p_port1, v2p_port2);
+		return mlx5_lag_port_sel_modify(ldev, ports);
+	return mlx5_cmd_modify_lag(dev0, ldev->ports, ports);
 }
 
 void mlx5_modify_lag(struct mlx5_lag *ldev,
 		     struct lag_tracker *tracker)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
-	u8 v2p_port1, v2p_port2;
+	u8 ports[MLX5_MAX_PORTS] = {};
 	int err;
+	int i;
+	int j;
 
-	mlx5_infer_tx_affinity_mapping(tracker, &v2p_port1,
-				       &v2p_port2);
+	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ports);
 
-	if (v2p_port1 != ldev->v2p_map[MLX5_LAG_P1] ||
-	    v2p_port2 != ldev->v2p_map[MLX5_LAG_P2]) {
-		err = _mlx5_modify_lag(ldev, v2p_port1, v2p_port2);
+	for (i = 0; i < ldev->ports; i++) {
+		if (ports[i] == ldev->v2p_map[i])
+			continue;
+		err = _mlx5_modify_lag(ldev, ports);
 		if (err) {
 			mlx5_core_err(dev0,
 				      "Failed to modify LAG (%d)\n",
 				      err);
 			return;
 		}
-		ldev->v2p_map[MLX5_LAG_P1] = v2p_port1;
-		ldev->v2p_map[MLX5_LAG_P2] = v2p_port2;
-		mlx5_core_info(dev0, "modify lag map port 1:%d port 2:%d",
-			       ldev->v2p_map[MLX5_LAG_P1],
-			       ldev->v2p_map[MLX5_LAG_P2]);
+		memcpy(ldev->v2p_map, ports, sizeof(ports[0]) *
+		       ldev->ports);
+
+		mlx5_core_info(dev0, "modify lag map\n");
+		for (j = 0; j < ldev->ports; j++)
+			mlx5_core_info(dev0, "\tmap port %d:%d\n",
+				       j + 1,
+				       ldev->v2p_map[j]);
+		break;
 	}
 
 	if (tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP &&
@@ -362,13 +393,15 @@ static int mlx5_create_lag(struct mlx5_lag *ldev,
 	struct mlx5_core_dev *dev1 = ldev->pf[MLX5_LAG_P2].dev;
 	u32 in[MLX5_ST_SZ_DW(destroy_lag_in)] = {};
 	int err;
+	int i;
 
-	mlx5_core_info(dev0, "lag map port 1:%d port 2:%d shared_fdb:%d mode:%s",
-		       ldev->v2p_map[MLX5_LAG_P1], ldev->v2p_map[MLX5_LAG_P2],
+	mlx5_core_info(dev0, "lag map:\n");
+	for (i = 0; i < ldev->ports; i++)
+		mlx5_core_info(dev0, "\tport %d:%d\n", i + 1, ldev->v2p_map[i]);
+	mlx5_core_info(dev0, "shared_fdb:%d mode:%s\n",
 		       shared_fdb, get_str_port_sel_mode(flags));
 
-	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map[MLX5_LAG_P1],
-				  ldev->v2p_map[MLX5_LAG_P2], shared_fdb, flags);
+	err = mlx5_cmd_create_lag(dev0, ldev->v2p_map, shared_fdb, flags);
 	if (err) {
 		mlx5_core_err(dev0,
 			      "Failed to create LAG (%d)\n",
@@ -404,16 +437,14 @@ int mlx5_activate_lag(struct mlx5_lag *ldev,
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
 	int err;
 
-	mlx5_infer_tx_affinity_mapping(tracker, &ldev->v2p_map[MLX5_LAG_P1],
-				       &ldev->v2p_map[MLX5_LAG_P2]);
+	mlx5_infer_tx_affinity_mapping(tracker, ldev->ports, ldev->v2p_map);
 	err = mlx5_lag_set_port_sel_mode(ldev, tracker, &flags);
 	if (err)
 		return err;
 
 	if (flags & MLX5_LAG_FLAG_HASH_BASED) {
 		err = mlx5_lag_port_sel_create(ldev, tracker->hash_type,
-					       ldev->v2p_map[MLX5_LAG_P1],
-					       ldev->v2p_map[MLX5_LAG_P2]);
+					       ldev->v2p_map);
 		if (err) {
 			mlx5_core_err(dev0,
 				      "Failed to create LAG port selection(%d)\n",
@@ -491,30 +522,37 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 #ifdef CONFIG_MLX5_ESWITCH
 	u8 mode;
 #endif
+	int i;
 
-	if (!ldev->pf[MLX5_LAG_P1].dev || !ldev->pf[MLX5_LAG_P2].dev)
-		return false;
+	for (i = 0; i < ldev->ports; i++)
+		if (!ldev->pf[i].dev)
+			return false;
 
 #ifdef CONFIG_MLX5_ESWITCH
 	mode = mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P1].dev);
 
-	if (mode == MLX5_ESWITCH_OFFLOADS && ldev->ports != MLX5_LAG_OFFLOADS_SUPPORTED_PORTS)
+	if (mode != MLX5_ESWITCH_NONE && mode != MLX5_ESWITCH_OFFLOADS)
 		return false;
 
-	return (mode == MLX5_ESWITCH_NONE || mode == MLX5_ESWITCH_OFFLOADS) &&
-		(mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P1].dev) ==
-		 mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P2].dev));
+	for (i = 0; i < ldev->ports; i++)
+		if (mlx5_eswitch_mode(ldev->pf[i].dev) != mode)
+			return false;
+
+	if (mode == MLX5_ESWITCH_OFFLOADS && ldev->ports != MLX5_LAG_OFFLOADS_SUPPORTED_PORTS)
+		return false;
 #else
-	return (!mlx5_sriov_is_enabled(ldev->pf[MLX5_LAG_P1].dev) &&
-		!mlx5_sriov_is_enabled(ldev->pf[MLX5_LAG_P2].dev));
+	for (i = 0; i < ldev->ports; i++)
+		if (mlx5_sriov_is_enabled(ldev->pf[i].dev))
+			return false;
 #endif
+	return true;
 }
 
 static void mlx5_lag_add_devices(struct mlx5_lag *ldev)
 {
 	int i;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+	for (i = 0; i < ldev->ports; i++) {
 		if (!ldev->pf[i].dev)
 			continue;
 
@@ -531,7 +569,7 @@ static void mlx5_lag_remove_devices(struct mlx5_lag *ldev)
 {
 	int i;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+	for (i = 0; i < ldev->ports; i++) {
 		if (!ldev->pf[i].dev)
 			continue;
 
@@ -551,6 +589,7 @@ static void mlx5_disable_lag(struct mlx5_lag *ldev)
 	bool shared_fdb = ldev->shared_fdb;
 	bool roce_lag;
 	int err;
+	int i;
 
 	roce_lag = __mlx5_lag_is_roce(ldev);
 
@@ -561,7 +600,8 @@ static void mlx5_disable_lag(struct mlx5_lag *ldev)
 			dev0->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 			mlx5_rescan_drivers_locked(dev0);
 		}
-		mlx5_nic_vport_disable_roce(dev1);
+		for (i = 1; i < ldev->ports; i++)
+			mlx5_nic_vport_disable_roce(ldev->pf[i].dev);
 	}
 
 	err = mlx5_deactivate_lag(ldev);
@@ -598,6 +638,23 @@ static bool mlx5_shared_fdb_supported(struct mlx5_lag *ldev)
 	return false;
 }
 
+static bool mlx5_lag_is_roce_lag(struct mlx5_lag *ldev)
+{
+	bool roce_lag = true;
+	int i;
+
+	for (i = 0; i < ldev->ports; i++)
+		roce_lag = roce_lag && !mlx5_sriov_is_enabled(ldev->pf[i].dev);
+
+#ifdef CONFIG_MLX5_ESWITCH
+	for (i = 0; i < ldev->ports; i++)
+		roce_lag = roce_lag &&
+			ldev->pf[i].dev->priv.eswitch->mode == MLX5_ESWITCH_NONE;
+#endif
+
+	return roce_lag;
+}
+
 static void mlx5_do_bond(struct mlx5_lag *ldev)
 {
 	struct mlx5_core_dev *dev0 = ldev->pf[MLX5_LAG_P1].dev;
@@ -605,6 +662,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	struct lag_tracker tracker;
 	bool do_bond, roce_lag;
 	int err;
+	int i;
 
 	if (!mlx5_lag_is_ready(ldev)) {
 		do_bond = false;
@@ -621,14 +679,7 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 	if (do_bond && !__mlx5_lag_is_active(ldev)) {
 		bool shared_fdb = mlx5_shared_fdb_supported(ldev);
 
-		roce_lag = !mlx5_sriov_is_enabled(dev0) &&
-			   !mlx5_sriov_is_enabled(dev1);
-
-#ifdef CONFIG_MLX5_ESWITCH
-		roce_lag = roce_lag &&
-			   dev0->priv.eswitch->mode == MLX5_ESWITCH_NONE &&
-			   dev1->priv.eswitch->mode == MLX5_ESWITCH_NONE;
-#endif
+		roce_lag = mlx5_lag_is_roce_lag(ldev);
 
 		if (shared_fdb || roce_lag)
 			mlx5_lag_remove_devices(ldev);
@@ -645,7 +696,8 @@ static void mlx5_do_bond(struct mlx5_lag *ldev)
 		} else if (roce_lag) {
 			dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 			mlx5_rescan_drivers_locked(dev0);
-			mlx5_nic_vport_enable_roce(dev1);
+			for (i = 1; i < ldev->ports; i++)
+				mlx5_nic_vport_enable_roce(ldev->pf[i].dev);
 		} else if (shared_fdb) {
 			dev0->priv.flags &= ~MLX5_PRIV_FLAGS_DISABLE_IB_ADEV;
 			mlx5_rescan_drivers_locked(dev0);
@@ -713,7 +765,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	bool is_bonded, is_in_lag, mode_supported;
 	bool has_inactive = 0;
 	struct slave *slave;
-	int bond_status = 0;
+	u8 bond_status = 0;
 	int num_slaves = 0;
 	int changed = 0;
 	int idx;
@@ -744,7 +796,7 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	rcu_read_unlock();
 
 	/* None of this lagdev's netdevs are slaves of this master. */
-	if (!(bond_status & 0x3))
+	if (!(bond_status & GENMASK(ldev->ports - 1, 0)))
 		return 0;
 
 	if (lag_upper_info) {
@@ -757,7 +809,8 @@ static int mlx5_handle_changeupper_event(struct mlx5_lag *ldev,
 	 * A device is considered bonded if both its physical ports are slaves
 	 * of the same lag master, and only them.
 	 */
-	is_in_lag = num_slaves == MLX5_MAX_PORTS && bond_status == 0x3;
+	is_in_lag = num_slaves == ldev->ports &&
+		bond_status == GENMASK(ldev->ports - 1, 0);
 
 	/* Lag mode must be activebackup or hash. */
 	mode_supported = tracker->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP ||
@@ -886,7 +939,7 @@ static void mlx5_ldev_add_netdev(struct mlx5_lag *ldev,
 {
 	unsigned int fn = mlx5_get_dev_index(dev);
 
-	if (fn >= MLX5_MAX_PORTS)
+	if (fn >= ldev->ports)
 		return;
 
 	spin_lock(&lag_lock);
@@ -902,7 +955,7 @@ static void mlx5_ldev_remove_netdev(struct mlx5_lag *ldev,
 	int i;
 
 	spin_lock(&lag_lock);
-	for (i = 0; i < MLX5_MAX_PORTS; i++) {
+	for (i = 0; i < ldev->ports; i++) {
 		if (ldev->pf[i].netdev == netdev) {
 			ldev->pf[i].netdev = NULL;
 			break;
@@ -916,7 +969,7 @@ static void mlx5_ldev_add_mdev(struct mlx5_lag *ldev,
 {
 	unsigned int fn = mlx5_get_dev_index(dev);
 
-	if (fn >= MLX5_MAX_PORTS)
+	if (fn >= ldev->ports)
 		return;
 
 	ldev->pf[fn].dev = dev;
@@ -928,11 +981,11 @@ static void mlx5_ldev_remove_mdev(struct mlx5_lag *ldev,
 {
 	int i;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
+	for (i = 0; i < ldev->ports; i++)
 		if (ldev->pf[i].dev == dev)
 			break;
 
-	if (i == MLX5_MAX_PORTS)
+	if (i == ldev->ports)
 		return;
 
 	ldev->pf[i].dev = NULL;
@@ -1045,11 +1098,11 @@ void mlx5_lag_add_netdev(struct mlx5_core_dev *dev,
 	mutex_lock(&ldev->lock);
 	mlx5_ldev_add_netdev(ldev, dev, netdev);
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
+	for (i = 0; i < ldev->ports; i++)
 		if (!ldev->pf[i].dev)
 			break;
 
-	if (i >= MLX5_MAX_PORTS)
+	if (i >= ldev->ports)
 		ldev->flags |= MLX5_LAG_FLAG_READY;
 	mutex_unlock(&ldev->lock);
 	mlx5_queue_bond_work(ldev, 0);
@@ -1163,6 +1216,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 {
 	struct net_device *ndev = NULL;
 	struct mlx5_lag *ldev;
+	int i;
 
 	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev(dev);
@@ -1171,9 +1225,11 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
 		goto unlock;
 
 	if (ldev->tracker.tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP) {
-		ndev = ldev->tracker.netdev_state[MLX5_LAG_P1].tx_enabled ?
-		       ldev->pf[MLX5_LAG_P1].netdev :
-		       ldev->pf[MLX5_LAG_P2].netdev;
+		for (i = 0; i < ldev->ports; i++)
+			if (ldev->tracker.netdev_state[i].tx_enabled)
+				ndev = ldev->pf[i].netdev;
+		if (!ndev)
+			ndev = ldev->pf[ldev->ports - 1].netdev;
 	} else {
 		ndev = ldev->pf[MLX5_LAG_P1].netdev;
 	}
@@ -1192,16 +1248,19 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 {
 	struct mlx5_lag *ldev;
 	u8 port = 0;
+	int i;
 
 	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev(dev);
 	if (!(ldev && __mlx5_lag_is_roce(ldev)))
 		goto unlock;
 
-	if (ldev->pf[MLX5_LAG_P1].netdev == slave)
-		port = MLX5_LAG_P1;
-	else
-		port = MLX5_LAG_P2;
+	for (i = 0; i < ldev->ports; i++) {
+		if (ldev->pf[MLX5_LAG_P1].netdev == slave) {
+			port = i;
+			break;
+		}
+	}
 
 	port = ldev->v2p_map[port];
 
@@ -1213,7 +1272,13 @@ EXPORT_SYMBOL(mlx5_lag_get_slave_port);
 
 u8 mlx5_lag_get_num_ports(struct mlx5_core_dev *dev)
 {
-	return MLX5_MAX_PORTS;
+	struct mlx5_lag *ldev;
+
+	ldev = mlx5_lag_dev(dev);
+	if (!ldev)
+		return 0;
+
+	return ldev->ports;
 }
 EXPORT_SYMBOL(mlx5_lag_get_num_ports);
 
@@ -1243,7 +1308,7 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 				 size_t *offsets)
 {
 	int outlen = MLX5_ST_SZ_BYTES(query_cong_statistics_out);
-	struct mlx5_core_dev *mdev[MLX5_MAX_PORTS];
+	struct mlx5_core_dev **mdev;
 	struct mlx5_lag *ldev;
 	int num_ports;
 	int ret, i, j;
@@ -1253,14 +1318,20 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 	if (!out)
 		return -ENOMEM;
 
+	mdev = kvzalloc(sizeof(mdev[0]) * MLX5_MAX_PORTS, GFP_KERNEL);
+	if (!mdev) {
+		ret = -ENOMEM;
+		goto free_out;
+	}
+
 	memset(values, 0, sizeof(*values) * num_counters);
 
 	spin_lock(&lag_lock);
 	ldev = mlx5_lag_dev(dev);
 	if (ldev && __mlx5_lag_is_active(ldev)) {
-		num_ports = MLX5_MAX_PORTS;
-		mdev[MLX5_LAG_P1] = ldev->pf[MLX5_LAG_P1].dev;
-		mdev[MLX5_LAG_P2] = ldev->pf[MLX5_LAG_P2].dev;
+		num_ports = ldev->ports;
+		for (i = 0; i < ldev->ports; i++)
+			mdev[i] = ldev->pf[i].dev;
 	} else {
 		num_ports = 1;
 		mdev[MLX5_LAG_P1] = dev;
@@ -1275,13 +1346,15 @@ int mlx5_lag_query_cong_counters(struct mlx5_core_dev *dev,
 		ret = mlx5_cmd_exec_inout(mdev[i], query_cong_statistics, in,
 					  out);
 		if (ret)
-			goto free;
+			goto free_mdev;
 
 		for (j = 0; j < num_counters; ++j)
 			values[j] += be64_to_cpup((__be64 *)(out + offsets[j]));
 	}
 
-free:
+free_mdev:
+	kvfree(mdev);
+free_out:
 	kvfree(out);
 	return ret;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
index 5be322528279..478b4ef723f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
@@ -12,7 +12,8 @@ enum {
 
 static struct mlx5_flow_group *
 mlx5_create_hash_flow_group(struct mlx5_flow_table *ft,
-			    struct mlx5_flow_definer *definer)
+			    struct mlx5_flow_definer *definer,
+			    u8 ports)
 {
 	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
 	struct mlx5_flow_group *fg;
@@ -25,7 +26,7 @@ mlx5_create_hash_flow_group(struct mlx5_flow_table *ft,
 	MLX5_SET(create_flow_group_in, in, match_definer_id,
 		 mlx5_get_match_definer_id(definer));
 	MLX5_SET(create_flow_group_in, in, start_flow_index, 0);
-	MLX5_SET(create_flow_group_in, in, end_flow_index, MLX5_MAX_PORTS - 1);
+	MLX5_SET(create_flow_group_in, in, end_flow_index, ports - 1);
 	MLX5_SET(create_flow_group_in, in, group_type,
 		 MLX5_CREATE_FLOW_GROUP_IN_GROUP_TYPE_HASH_SPLIT);
 
@@ -36,7 +37,7 @@ mlx5_create_hash_flow_group(struct mlx5_flow_table *ft,
 
 static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 					  struct mlx5_lag_definer *lag_definer,
-					  u8 port1, u8 port2)
+					  u8 *ports)
 {
 	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_flow_table_attr ft_attr = {};
@@ -45,7 +46,7 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 	struct mlx5_flow_namespace *ns;
 	int err, i;
 
-	ft_attr.max_fte = MLX5_MAX_PORTS;
+	ft_attr.max_fte = ldev->ports;
 	ft_attr.level = MLX5_LAG_FT_LEVEL_DEFINER;
 
 	ns = mlx5_get_flow_namespace(dev, MLX5_FLOW_NAMESPACE_PORT_SEL);
@@ -61,7 +62,8 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 	}
 
 	lag_definer->fg = mlx5_create_hash_flow_group(lag_definer->ft,
-						      lag_definer->definer);
+						      lag_definer->definer,
+						      ldev->ports);
 	if (IS_ERR(lag_definer->fg)) {
 		err = PTR_ERR(lag_definer->fg);
 		goto destroy_ft;
@@ -70,8 +72,8 @@ static int mlx5_lag_create_port_sel_table(struct mlx5_lag *ldev,
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	for (i = 0; i < MLX5_MAX_PORTS; i++) {
-		u8 affinity = i == 0 ? port1 : port2;
+	for (i = 0; i < ldev->ports; i++) {
+		u8 affinity = ports[i];
 
 		dest.vport.vhca_id = MLX5_CAP_GEN(ldev->pf[affinity - 1].dev,
 						  vhca_id);
@@ -279,8 +281,7 @@ static int mlx5_lag_set_definer(u32 *match_definer_mask,
 
 static struct mlx5_lag_definer *
 mlx5_lag_create_definer(struct mlx5_lag *ldev, enum netdev_lag_hash hash,
-			enum mlx5_traffic_types tt, bool tunnel, u8 port1,
-			u8 port2)
+			enum mlx5_traffic_types tt, bool tunnel, u8 *ports)
 {
 	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
 	struct mlx5_lag_definer *lag_definer;
@@ -308,7 +309,7 @@ mlx5_lag_create_definer(struct mlx5_lag *ldev, enum netdev_lag_hash hash,
 		goto free_mask;
 	}
 
-	err = mlx5_lag_create_port_sel_table(ldev, lag_definer, port1, port2);
+	err = mlx5_lag_create_port_sel_table(ldev, lag_definer, ports);
 	if (err)
 		goto destroy_match_definer;
 
@@ -331,7 +332,7 @@ static void mlx5_lag_destroy_definer(struct mlx5_lag *ldev,
 	struct mlx5_core_dev *dev = ldev->pf[MLX5_LAG_P1].dev;
 	int i;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++)
+	for (i = 0; i < ldev->ports; i++)
 		mlx5_del_flow_rules(lag_definer->rules[i]);
 	mlx5_destroy_flow_group(lag_definer->fg);
 	mlx5_destroy_flow_table(lag_definer->ft);
@@ -356,7 +357,7 @@ static void mlx5_lag_destroy_definers(struct mlx5_lag *ldev)
 
 static int mlx5_lag_create_definers(struct mlx5_lag *ldev,
 				    enum netdev_lag_hash hash_type,
-				    u8 port1, u8 port2)
+				    u8 *ports)
 {
 	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
 	struct mlx5_lag_definer *lag_definer;
@@ -364,7 +365,7 @@ static int mlx5_lag_create_definers(struct mlx5_lag *ldev,
 
 	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
 		lag_definer = mlx5_lag_create_definer(ldev, hash_type, tt,
-						      false, port1, port2);
+						      false, ports);
 		if (IS_ERR(lag_definer)) {
 			err = PTR_ERR(lag_definer);
 			goto destroy_definers;
@@ -376,7 +377,7 @@ static int mlx5_lag_create_definers(struct mlx5_lag *ldev,
 
 		lag_definer =
 			mlx5_lag_create_definer(ldev, hash_type, tt,
-						true, port1, port2);
+						true, ports);
 		if (IS_ERR(lag_definer)) {
 			err = PTR_ERR(lag_definer);
 			goto destroy_definers;
@@ -513,13 +514,13 @@ static int mlx5_lag_create_inner_ttc_table(struct mlx5_lag *ldev)
 }
 
 int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
-			     enum netdev_lag_hash hash_type, u8 port1, u8 port2)
+			     enum netdev_lag_hash hash_type, u8 *ports)
 {
 	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
 	int err;
 
 	set_tt_map(port_sel, hash_type);
-	err = mlx5_lag_create_definers(ldev, hash_type, port1, port2);
+	err = mlx5_lag_create_definers(ldev, hash_type, ports);
 	if (err)
 		return err;
 
@@ -546,12 +547,13 @@ int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
 static int
 mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
 				      struct mlx5_lag_definer **definers,
-				      u8 port1, u8 port2)
+				      u8 *ports)
 {
 	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
 	struct mlx5_flow_destination dest = {};
 	int err;
 	int tt;
+	int i;
 
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
@@ -559,19 +561,13 @@ mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
 	for_each_set_bit(tt, port_sel->tt_map, MLX5_NUM_TT) {
 		struct mlx5_flow_handle **rules = definers[tt]->rules;
 
-		if (ldev->v2p_map[MLX5_LAG_P1] != port1) {
-			dest.vport.vhca_id =
-				MLX5_CAP_GEN(ldev->pf[port1 - 1].dev, vhca_id);
-			err = mlx5_modify_rule_destination(rules[MLX5_LAG_P1],
-							   &dest, NULL);
-			if (err)
-				return err;
-		}
-
-		if (ldev->v2p_map[MLX5_LAG_P2] != port2) {
+		for (i = 0; i < ldev->ports; i++) {
+			if (ldev->v2p_map[i] == ports[i])
+				continue;
 			dest.vport.vhca_id =
-				MLX5_CAP_GEN(ldev->pf[port2 - 1].dev, vhca_id);
-			err = mlx5_modify_rule_destination(rules[MLX5_LAG_P2],
+				MLX5_CAP_GEN(ldev->pf[ports[i] - 1].dev,
+					     vhca_id);
+			err = mlx5_modify_rule_destination(rules[i],
 							   &dest, NULL);
 			if (err)
 				return err;
@@ -581,14 +577,14 @@ mlx5_lag_modify_definers_destinations(struct mlx5_lag *ldev,
 	return 0;
 }
 
-int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 port1, u8 port2)
+int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 *ports)
 {
 	struct mlx5_lag_port_sel *port_sel = &ldev->port_sel;
 	int err;
 
 	err = mlx5_lag_modify_definers_destinations(ldev,
 						    port_sel->outer.definers,
-						    port1, port2);
+						    ports);
 	if (err)
 		return err;
 
@@ -597,7 +593,7 @@ int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 port1, u8 port2)
 
 	return mlx5_lag_modify_definers_destinations(ldev,
 						     port_sel->inner.definers,
-						     port1, port2);
+						     ports);
 }
 
 void mlx5_lag_port_sel_destroy(struct mlx5_lag *ldev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
index 6d15b28a42fc..79852ac41dbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
@@ -27,22 +27,20 @@ struct mlx5_lag_port_sel {
 
 #ifdef CONFIG_MLX5_ESWITCH
 
-int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 port1, u8 port2);
+int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 *ports);
 void mlx5_lag_port_sel_destroy(struct mlx5_lag *ldev);
 int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
-			     enum netdev_lag_hash hash_type, u8 port1,
-			     u8 port2);
+			     enum netdev_lag_hash hash_type, u8 *ports);
 
 #else /* CONFIG_MLX5_ESWITCH */
 static inline int mlx5_lag_port_sel_create(struct mlx5_lag *ldev,
 					   enum netdev_lag_hash hash_type,
-					   u8 port1, u8 port2)
+					   u8 *ports)
 {
 	return 0;
 }
 
-static inline int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 port1,
-					   u8 port2)
+static inline int mlx5_lag_port_sel_modify(struct mlx5_lag *ldev, u8 *ports)
 {
 	return 0;
 }
-- 
2.35.1

