Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7FD517CB3
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbiECErC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiECEq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBEF3E0FF
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaO44hW1HBfZSfMCfb2dCmxJD8hUwcEmSYcW6w4JlDertbB9LSXdjRcoro59b9zgCgxbNDhtO01i6QQJDNTsjbm0dOzfCQ1e2YPU/xk8w1XkciL8eEejLucgVL4EWuURVnqKYQEbUTSe6F6fla+0wrTttY9gdiXGAC99kpbPjvoNi4mWahPs9PDdh4uOAi4zTHJVHuPTrx4LtY4qBXxArO+59oS0NMKBKBQMfdZICifDiRWsFPHJgDTCauAjXePbn1fvzOjjZYX0/5bMVflT3HAGlZ1ryARxnlpEk19nqMhYgQcBMExDn1XPZmr+IO6eTCmF+kt0GCHk5wwcK8sxDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFY0MGYo8O3gn75xmVl+38uRkeJalTSY31SEDzVboKU=;
 b=kqPQRJZdn1Xn1NkISGOFGgHYHOW1kYAEO7+j9hHMBxYXrbT6JDKt6ezugdvrgGfAJJACitYBl3tqSi7kex5HMZaktOhd6BEX4NHkzl6bTB0J91ybdMo2B78U9k0Uy9XtQjST8YEra+ZhYBOMAStlAaH+AjrHZcjgGNJNFPYM8Kbb5Ix7OqQGEO439UdsvGOzMRuV0y/Dp6o3ckiGMRj8ea1Vm/E4WYh67YxOgbnMSU8WjEJI5Cm78+miEgQxyPu42lVGRfPvvHhF/Ae5T0c7ADgb0yyqUuPFKhQ35X+llEwxI8CYDfpTlcmyga6qtyxogiCIH0TFPOAStBM9JEo3Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFY0MGYo8O3gn75xmVl+38uRkeJalTSY31SEDzVboKU=;
 b=EkGHwgmGa4O3g3k9RAIKMaHTxjGUwjwPu4HIODB3fHwGI1lDQq0ehxb9Kc5A9k8JFFyEGUGylp5YGn1BxqgRfKUI5JFWfpJ5cwVJr0mYcI6yPeU42eu01BwObPj8QU01nmHRHU1Fh9505ckAmW483TLmCY1yGxQO8OoNVbQxcCR5zk9jUaMetO/Bhuq7SpaRSEFXjRJZ7Myaks9603p6SKnJIrpt1QMAGVCHLZHDlv4gMeJofqn7va/xj3NyRsxXyxMQbojhv1qJ9faeyfoXkPPQLEzGYieYxjD8GKr8c333GJb/MZJDBvEURIHHGHQY1mZMfVqalvxiIw00MuCbPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:27 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:27 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: TC, set proper dest type
Date:   Mon,  2 May 2022 21:42:01 -0700
Message-Id: <20220503044209.622171-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0365.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::10) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 469406fd-955f-431e-14f3-08da2cbf76bd
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB432207EBAE96E26F3C83ECF1B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q5OefNR7BbYMZhbkTlAJRZNYGAT+7NGgfXXY9STpytfmQrGe8DyBs3XFGKd+MldfZe7JaaNyxx82D5+ldO4nqRRHuYuOM6uZ9XHhJX4CPyk7YJuVNuvZjq7JJ1JuwaWGZzRANykNCemTBddUcOIor3WE88r/hlnIIlnUF8ARx43ehyqyQ7f23ciDjD5l1RlLTZbzucpE4MoPLjfGAwH1KGV4wDKgoEM82fcTAWtjl6ZXIywpwtLIjtOG8e5tcv+QYg1XYjui4w4dd9HY5UM6OS5RyedZ2ZTtnEvNc3028qWEE72/wKeiA0/ppX54A4BjAbvXxCCEn2ZMgvRCvgDO9K6NEQHLoO2vfveNwgmN0mEd2gPc/+RIL0Ffvh9KVUL0HigR0+dNpvn8rfA6vufgVxNZIx1KJ9Nuc/KLPSYcqX96USx8Bp/sYX2+aQM6p3hd02bNZGqhjo0Pq8Ws23VGmGBpfVpQ56Sn7ESpSDZk86jUo0/SknYP9oGeehZdyk3VGSBTnMknCXMuXjAleOlt9xK1PSfTIKn8/sQWtS3vem8JCOt6v1oS/gnRZ+6FY1Lm7tEl5KV9GFvpoepCXvy4V93YTwGtF+RSS/ayZayikIEClno5ajfXjXS27qne2h9ZPFAet8kZPQaw9SsREZ8HFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I0af7qmt5r1/l8eGXnGuPBrIY8p9x+rCQ1YCMb6iSwGwgdl366TzuzKdVNNs?=
 =?us-ascii?Q?pke91t7AzTQDCK/oR5CMS7+sdM7Rfs6q3iaTPq8xXaCRBlw8IaXM60SirE88?=
 =?us-ascii?Q?iQMRtPKW6K0CJrWztsnmXBbf//ar1ElobSPqWcvKfPVgt2PuQMd2OHFZ4JV+?=
 =?us-ascii?Q?BwdSr9l4mpk+AmbFpPtdZgURXDuN+R10VA9jQ4khQCM7WT16AaHL7y72MNcE?=
 =?us-ascii?Q?Ll9XkJMEPwRoe7gNU/jxvLxa/beLx2mmoYnX/+Z5HS7h49881dAC7b4x62cs?=
 =?us-ascii?Q?4Ylzz1JfmEeZMzsZ2gI6NwGD2KF8azM1i/NP5gEbzbu9PZ/d3tuUoPVhADj0?=
 =?us-ascii?Q?4+bR4OlzrF0MC5h/AE544Y3MGEdZ6BFI4K6MuKftGBipGFJmzp0B/5kgfgD6?=
 =?us-ascii?Q?GSXL1OLQRDGBqJZXbJt2Pk2b6VUX/fK409a4XYwGeOZSciCy/6z5X24JD4D4?=
 =?us-ascii?Q?TMAHZ73P4PIam/73wKKcvWlr6Uq7nlIKRuTAXMNE4lii1b3o5a8zXOKhKUk6?=
 =?us-ascii?Q?6eqYkOc/nEmNJpAuiUhZpnEbbsbhn/8X2TeV4tcsmUBWgoxD080r5GJl6H7M?=
 =?us-ascii?Q?W08KcKI4TCYddcv0zzPNGix5vGJ7yChTPkp7jE7CHPlsrDdu9aubFiU//O+/?=
 =?us-ascii?Q?9NehiCzGxsTGklBH6KEbPY/ym3e8+fqWUndDOxg0HSvOCSMcPWUC5SKAwl0p?=
 =?us-ascii?Q?jMo0ehMx4+PgS7vXiQ6wwPQNxMyqme11OQk44Eb1TbHm0HQ5qH72ZzZB8o2t?=
 =?us-ascii?Q?dXqPnlhZov6kZyxEkiiUREn5GrMXjbJHMju42GOF/huthKIKOlGa8ju0FSCu?=
 =?us-ascii?Q?HgCalEjWRPdfmSLRoce7D7f+l2izFAIQ15WaHQG45qR9i0cA5wPaihYtLbH1?=
 =?us-ascii?Q?MlGagTxDLi5ABYP9NJZdqm+BUfYa8y9A+jTnQJi5vEEPcnfENrTS2jKjI7vc?=
 =?us-ascii?Q?F1csH8wuEFH6zMrsF/j9mWg9EQqbASPB8vSgYfkyrm9cceP2CAumobuD5DTP?=
 =?us-ascii?Q?vS0R+obkscVldn9F89APhfTTfzH9C5zvXKWw87T7hUeiqMwOterKjwzJYBjD?=
 =?us-ascii?Q?TqQqa1tRK+LY77PyIaPFpIGUbxKSqNStxt1qPq7nxBOofW/qPoxWxmuhAFfv?=
 =?us-ascii?Q?TckcACzulbrE3pXggm6VDHLlkvjAWI0GAeKgNgSWBKmBNMYWArEzKCIKuTqC?=
 =?us-ascii?Q?OEEMA01QTHO8/ah0TqCeyK2bFqPnte7SBPrXgpTciM0HC13l6ePiQPhAwWXd?=
 =?us-ascii?Q?rMKPx5OdjJIeTQ+YJbBeH0ufhIZrxJs5gHtZG8nE3xUJQpG++bqgnSbBS3jV?=
 =?us-ascii?Q?wA4y0yUpq3v5qPevN+UahdtLQyy+sLYtT+vyb/NvDCH6vknq+9iewXhBkA9L?=
 =?us-ascii?Q?kM6KTc+i5VcemV0ODm00th2eswFCP8E0O1TnqYTrU/EBEa55IXTSFcLF3IJe?=
 =?us-ascii?Q?TpeM/zl2EGdQJ+PlSXAb7hLyUXqMklEksWVDTQnlhD82pn9vepYQTPok0UD+?=
 =?us-ascii?Q?S9wB6hTBWuSPds3XprDNMDnpgtpJoDg/yxeDep1yCgxkTrkwp/62rGl6p80y?=
 =?us-ascii?Q?fdtW+UJX84ilAz8udHTPLVosUmnOJtbdrqQvF4B5iqQIfkQRAMXCt+gDrIBV?=
 =?us-ascii?Q?d8a5xp5TG2OcD3rv/fpNXPRVzur+vbwx6Fz4IFnSOpdiyXUEj6DWQd9pbmL4?=
 =?us-ascii?Q?yw7+Z4V2TRfkZ2+n7WJdhNN0fi0W3fVlDuQbLXSqciajK6sI1XpYLOPCblt2?=
 =?us-ascii?Q?SQOVYrZHFRUM0T9Um5Q4eWpo+1Dd0bo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 469406fd-955f-431e-14f3-08da2cbf76bd
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:27.0075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ykmH+oVFch4sbIWIx7JWlyhPl45TYIr2sPLQr0DjZzzTmp5LbxZZiIdPHCrnqI86n9vF0DaRttA3GAbcZqPXxQ==
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

From: Mark Bloch <mbloch@nvidia.com>

Dest type isn't set, this works only because
MLX5_FLOW_DESTINATION_TYPE_VPORT is zero. Set the proper type.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index fd4504518578..1cbd2eb9d04f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -93,6 +93,7 @@ sampler_termtbl_create(struct mlx5e_tc_psample *tc_psample)
 
 	act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	dest.vport.num = esw->manager_vport;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_VPORT;
 	tc_psample->termtbl_rule = mlx5_add_flow_rules(tc_psample->termtbl, NULL, &act, &dest, 1);
 	if (IS_ERR(tc_psample->termtbl_rule)) {
 		err = PTR_ERR(tc_psample->termtbl_rule);
-- 
2.35.1

