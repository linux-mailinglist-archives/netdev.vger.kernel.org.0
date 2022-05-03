Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBBA517CAA
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiECEq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiECEqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55873E0ED
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:42:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrLZti8m/03A5KbpFTpXWy59c0nl+D3JdKx+9C4HKB+imEPtKzFm4hixzhl177WJpNanprFKKnzB3OViqaPpXbAjWO4TuSrJeYoLKHFrb4wB4+WkY3Dmo0IALJPNrx8nRghHIX3QsDLrSNoaShQUf9PueCLFyoOECXh+SpkymqtE/8wa8/bgZoU56UgJ6X//OdEnzugEe3opVe3xSq4KgtXh8hSRBDPog5tCKfSzrEdos2VzF31fyKdG4M5GO+TFLJRGI8Q9j/G9lFkA6GIdt/YivkmsaVUE+puawE6a9n5PiUV0swSs6VihIlzmYTC2EItCk8uvVZnNbAvWtKyv4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zkrtctFuP8S4km0caUvh5q8jQsNoedXX6aSvV1mfiAc=;
 b=NlmoNBK0o4NzCod8q46J3rhbHpIyi0Qlfp2lg91YBjkC6QesSHk4jCKii5LmVtZ/bjHe8JaErfXmQVHVhEXlExHeqUiJ64pQh5d9rsC0nRN3IoFMO3Jek3cOVESgM2mXlIg0+VUj+pEz4rJrwAmDVm1AyWDJptEv1uAXghosDiXw6NDPsA2FeojOcCdxeNP/qAW2/owRqkJc24slb+ZgONJPSOQbhRdejrdlz9laPk4RGYX/7CClYzNbB67dMwB7tidZykk+GZOhEgL7uacT3OMbPUY1tRnK7KHnCa7lFHavlgnT2Ebj8NhsSzAk/D9ijR1w0iT9+yybb4/h8q1IiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkrtctFuP8S4km0caUvh5q8jQsNoedXX6aSvV1mfiAc=;
 b=YL6+hn3bdZt0nS0obCC9Bdp4Ox+7q9CKKLZ7XYeuvkF80tbtUmkgpHeaT08j1rlSFiItRvygwg1R/ckvQGTfDK7KqakW1+XC9wUDJd6SVFXewUBbUvMZKXdkmgK7+r0LAavI60H2vBt3Svr9MOLPZF5tGg3K/WeLH/bla18IX0pRg75jPFDEi8NbqDfGHAgka7XSpIs7mvFpjqNzhOvRkaokYU78pd8YFL0z935A5F8fpwPHRXlrke3wBHoKAOR8rutwRQMrC636X8iAI9Llm0tjlv5WfjL597C7na/d5zCJI1tHOTfHYl/GUbtaGAN7Xk2XWcBOIhPxfdW2Ex3W5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:42:43 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:42:42 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5: Delete redundant default assignment of runtime devlink params
Date:   Mon,  2 May 2022 21:41:57 -0700
Message-Id: <20220503044209.622171-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0111.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::26) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b455dcef-b8e8-468c-7f77-08da2cbf5c69
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB43222B1F60E4CCF19B972F67B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfkiRzp6CvC0kdXjEI4fhSxBr1oaM5YG2gUa+03GsFjZYD/ZAW4c1HsEKxvNGFWzHIoSlAstoX9jwLVp/CP2iElflmev8UKC7hzLzfzztcEe4W0UniPa2X5roh4Osi13Qxfi+RCZ19QyDUYJAhP1xB8rhSwZjmD7WigTuVt7ncp6BHTzjq9a9H84WN2EZJtPPBJhMGp4ClqoWK+VCgLdRvaGEMU7SA0SAChhXCHmQRT2YM/ipuI6XPEe6HN06WhFmW2YZuptcnLAIk5MBMPZGHgUWrkhsLtVRKWXnv8T7e0vVv4bqJgg/tDzrXcKK5MelMYTsTCN+kI89GUQtd442eXHivqXblbGD1YqsdUhiGJ481t718gnoqccNF0jzXJhD6CXzZ7dmkoZjwtia/WfmDWgxuAF96tvOeapnF2vav6LarOiQIq2rdrGspPNp6dX8uwT4rnllSJzJgwILkzkV9zPolJyPGv5Zj4AjrHNzSHXHiI+8QOuJMyC/4kxLFrnLuSqd7vUxorZd1MniYDAs/VtODh/Hr4au7D5Ew1iHvc7so8cT6QGx3aMUhTrpTETrIs30YegmkHEVekYaRw1Oz69WaUs7qzkZIRHQZxoy63320Pvg23cMzJcbRyPdpzP0reZM6RLWkZWQe72LU6J2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gDGHJtZiu/zC1xmwrz1gGQ4C3ZMyl7FnbVqrUD0SxG117p/gZBpM/6LqYCTk?=
 =?us-ascii?Q?G45LYs7vYL641XG0irRUNwbpiyBD/+1BC8fE2Z5QGLmtr6+h6hG0TYIw3jd1?=
 =?us-ascii?Q?FQsy3CC/1jAEf9ba97GgOLMtG/tLVnF3cVk1HaB2m/6ICXDfDv0UZU1jB+5y?=
 =?us-ascii?Q?EscEWR0f7ZN6ljBG8/d+Rp4EBkhbpW9bi8+rTzmVwcTbTiX6decMQd3jkn5n?=
 =?us-ascii?Q?mxTojnTZ5lFFJYAUCgl2cehpfwKvO+JtX8NNhowGpeeGMRUzCyrC5XTIaV6z?=
 =?us-ascii?Q?OjhF5sep1FLumvQpdZamJD9pSHNchEAdUamZRXj1hWjxBY5sABNgWDbs/i6O?=
 =?us-ascii?Q?fiiysbnqsfgRXY0lmcWjGgV4/AHLT6KoVzD41ZIbsoMWBC79U/tFW0iJ/B2x?=
 =?us-ascii?Q?Lzq35aJwmIXWhaV1lJkgUBQgTT00FizrkgpYno3jzJ9JL760MqA5ShVPotuT?=
 =?us-ascii?Q?7JxlaJVFW1Yt9dnL97PwIDTGsNUPRbhl2ahFQ944aM/GdpkXDqsAuX1LfS+Q?=
 =?us-ascii?Q?+nsM+bpSHYVkTz95vvha1OLnnJ4OPdQcDzHhsGRZlE2ibZrlZABkvqCnfUwY?=
 =?us-ascii?Q?yzZcAb90r9Sks3SOY6CyBeJUpsBYN9Sok6WHZpl3rmgjgYGPkgVGosMDGPdO?=
 =?us-ascii?Q?GiQ0aaY/bRo4u0B/eM0QD6872tUS2CRwkZNB5qhweBdmUADi1Yi7lRw5GxDW?=
 =?us-ascii?Q?WlxqngBwTKkEWx9r4S2zcdRvuMqWl3VG90pnlcOMBQQHwuY4RzC3JPYQenri?=
 =?us-ascii?Q?89LwX4CQjZqUFm13Idw+kmfyWBrqDXTCsihylty1diSSmPJ0yhdz9YXv8sVK?=
 =?us-ascii?Q?3e3OZhsO7wqsVWVrIUH9j34dB+h3yxgat7S85FymsxMukTtL7un/4BGzMsX1?=
 =?us-ascii?Q?dXcn2f7ItCyJXccGI9mqM4x0ILHJ2GC+enkVFMfFuo02pzJiTqAp4MAMfJQV?=
 =?us-ascii?Q?OqwmXvr7kNUfgeGlvxkzHkqXry95D8VHhkvK3BVcWsxrMMSsLYE//N8VRdn1?=
 =?us-ascii?Q?4WmwhMGTFMp0amqhNMjTkq1SYi+tJ8N+V4NKvpJxe7kMl9QtbmqA4dBPIIc7?=
 =?us-ascii?Q?1AmJLF0/xNwfRsP7LisabSQuM11NvMYTyRLVF0Ki6pIu9GrSrtKfI9GAcYT5?=
 =?us-ascii?Q?JqaBD4i8js8emxKHldJVrIIaDnKi15LuR7pRL78PU/DJsUoRUur5itpQsnCI?=
 =?us-ascii?Q?WPpjNAz14Z/fYfqvUB3VUdWW7iD6rhIj8i5CvjP9X6RLC9kXffhoxlVQtXtW?=
 =?us-ascii?Q?rBeeJuDlAFiYbGfYkhAuTKFTlOYzNVd0pWmXzmo/x9oMtP0LTq5LDLVNZs2r?=
 =?us-ascii?Q?98F3IsNowJTPmQOfC34Mw9mFLd++jfcSxMqlrqzGYaGOjPf1296XclYjMKSm?=
 =?us-ascii?Q?6Vnge5rzBUTApJXuSV9PDiTLUcL/d6P5GL5EldDJNYhWXhmyiP8Y0A4733qh?=
 =?us-ascii?Q?IMcaaox6COCeQFCwPFY2gHTkZ2arCrd+nwp9+bFiXDDb/jcp9RNmhwcipkC4?=
 =?us-ascii?Q?RpgbJGy2LCxLGKyGyqhpvq0U7sa+MsTpsa8GEK7QdlTynAEmZLMSVvg61FHh?=
 =?us-ascii?Q?Og1lj3Cos/pXMR94v8Zmfud52xWchivE12Dqxppf1eH/yockAdWmywB0eIfz?=
 =?us-ascii?Q?74gdyh9Z0diDLB7dqGBKtIM728E6j8bEzWHXK8KyxQBUTg00x2AU4P7cpbya?=
 =?us-ascii?Q?V1sK5atmmNOgX4r6/cFEmzWBPs5HBN6hyCavoCp/DrTUjDiiA5O7Rw4xtjQl?=
 =?us-ascii?Q?oFsKnoJumPVHjHoi6jTEjuzSfXZhB0Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b455dcef-b8e8-468c-7f77-08da2cbf5c69
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:42:42.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uc5wL+eFiJrXGagM6DYvOehRR3j3PNVdl+AaMOlwErTr6U3NjkBSdumVK/8wnJfw/Mv9uO2e7LqasO8NDrMAsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Runtime devlink params always read their values from the get() callbacks.
Also, it is an error to set driverinit_value for params which don't
support driverinit cmode. Delete such assignments.

In addition, move the set of default matching mode inside eswitch code.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 20 -------------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  3 +++
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 057dde6f4417..e8789e6d7e7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -584,14 +584,6 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
 
-	if (dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_DMFS)
-		strcpy(value.vstr, "dmfs");
-	else
-		strcpy(value.vstr, "smfs");
-	devlink_param_driverinit_value_set(devlink,
-					   MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
-					   value);
-
 	value.vbool = MLX5_CAP_GEN(dev, roce);
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
@@ -602,18 +594,6 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
 					   value);
-
-	if (MLX5_ESWITCH_MANAGER(dev)) {
-		if (mlx5_esw_vport_match_metadata_supported(dev->priv.eswitch)) {
-			dev->priv.eswitch->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
-			value.vbool = true;
-		} else {
-			value.vbool = false;
-		}
-		devlink_param_driverinit_value_set(devlink,
-						   MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
-						   value);
-	}
 #endif
 
 	value.vu32 = MLX5_COMP_EQ_SIZE;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 458ec0bca1b8..25f2d2717aaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1582,6 +1582,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
 	else
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+	if (MLX5_ESWITCH_MANAGER(dev) &&
+	    mlx5_esw_vport_match_metadata_supported(esw))
+		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
 
 	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
-- 
2.35.1

