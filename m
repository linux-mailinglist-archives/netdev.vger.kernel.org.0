Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17AF1C03CD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgD3RVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:30 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD3RV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTUrwbt7qTCr0WIgUI48Ca8rCLCAYIqiuJrp/o8JZeKZ5zyz7mQmZMO1fxt8YCGJoVcsku3O33UCnH+eP6GM1Q3qz2EVCqJQFC9PNpVcL7uYFZTsH4FRa20zIrf//fYldaqXfodloVp/DSYtYjr3hdTzXUmDw6ODq1NvT5VjXQ7H1eUytcKuSn2A9ffR4kGULXzzVI8+qEFOu4cNBL8Vcgz9GzVzB3bSujUSNER2WGm1GdmlEoW2GO+lA2fajIf7oLfC38heiL1GsCeNJSubSeSjHsB6RZ/dAwdgyGtBunDnwLR/AM9+O+B9MJqYABvvymHfxrx9VfWuaYOgdg/jjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQFrRT6kRr5BGj6OXXqR/0Lkdh8qeDl45jgeNGVHQcw=;
 b=Km9Ew9YLL2qYs+KezXN9ePaL9eLx7wJQuO9VZk49ARnr2hEVUPkaa9Zkr46FPPpWvIAoNlN2HcCdSdLwg7eUA6lLmRqbWG7lk/Xi3TqZyWkKcwDBgV8EaU/BDHQpw1tH8kNtrCw8sNL6NDshco09H54hS4TEbHWHhe7WNMcCq0hi8Itrt1SO6VfLMPW0Jb/Git4cHVHdmGyxf3cQtk33BDdP93ysTyn3ly9KgfgpAXySlUZxyfwBK8C7Ol4OV24nXbHgsSQOqK6mnSzL3qjum1nzc8I2NYMypAOpjtD2zgV8vKyLqTjEbXMGv+BKJC7Xe973o6WUEyTUzFDkCSxFJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RQFrRT6kRr5BGj6OXXqR/0Lkdh8qeDl45jgeNGVHQcw=;
 b=gDmadrDt7iLP6oik1Ou3I28CGxOqPbeVt9regdIApkFQCEBvRbz1VBvNpdlf2EYQBc8mkB1X8oueVzS7f8jfQBRsmBhSLy74VKvzMENUEO2kyXKY/qcl84TNejZO1sm4WjYuRsfwwneQlWm7qkgtmaHTY5MXFcEUzV4yIAvUhXA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/mlx5e: Use proper name field for the UMR key
Date:   Thu, 30 Apr 2020 10:18:30 -0700
Message-Id: <20200430171835.20812-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:17 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7da36791-9322-45c0-a210-08d7ed2ae54b
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296C1BFB67F8FDB20C09ADDBEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrbMUv9DXZP+i+cCatsDC8C+T1jvrFkUPU+62gydd1DodMPozcUnU0aF97hvPjCwwlFVBoX7sPwXMyQv9AHSFH3Vo54FI6oujNBPdNXArNiLsXvR4C0p6NabWYULhTlzMYsTwFYFQi8gAeFEAgSFmocV6YvOosdM+dOuERI2XhEnFnytGm72llMTr82/3Fojshd54XeqxvcypOZpZ6Kxm/rWbZXxK1HVIWeYIhFt9b7KyJkboZQhRHZufa7dFawVdXVoBJkTPc164pNjI2mMg74e7vIbnHqciKC8N2I5KXtb6g+LWURs6VpOqj4mNjJqwLG2orSbAd7yQklNjtaLx7+Xu/xBW0nJq2wIg1tgHsydYr3Glys4TdujiRTVT3CIU6T8ypyi51y5DNwiEL5kWk9cC1XWKkJ9wENvl+tXHUn8EDhYI/TuGqlKl9AlPr7oN9qu+7xLCfKxdb7qW30tY8+EuadzqrVDiylKRzUVrHNNWgotzNaIC8pk1z/TpV8E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hCbZm/QlshOk5LwUHgUFs25eil/Ktgkhl7fcR7oP1QC3NUpHRV4kDJiwuz79JL88xJUsGH5U/H6G7N4tCGPt5RgBAerSnvYf5DRPy4fe6tgTI0t0HJTYgPkO3XO6ixa8ISUo7QxrXQJ+I02VMS/pA2q0mRgTG36iy8+GE9EbaTXOisZJpd1ZUWjufyqmCDvAqJl5VnRX0OW+mt2SSCa2XBlzSkre9tJUfcZukUqtkTRgs7sNpguSrYIQCmzYT+LtUy0/ozK2xEmGTkfKZIdX7NWaldGSjz+i/vsT6FnTMYWWkLUnvkoEvjLSuvJ4QoOPuO8HIfCtvpbyCjYK9Y46DhODo3gmSWBk05d3QQzvRFeCY3srOSKozA+B34xbViCDebjgxCFq735i17Rd+OxsZEUkfOwdSHzjtGOr59ktfCFnZoEKGR7v1jzGKtjOtpfrOkeDpc+IuFgoDRQbbcaDdW5u+qMGKxQPm3QjZspR3R29NszUFyKL/3IFZstvJBo3pmKtjQttk8Yooh9Ke+B0vuSA8TyKVmzP3Lrn7xc3hrw02frCdhHXsYdG3hoQmcoMu5aOVcUfnGgZnyj/TN1VWf1zSEcpnFzDC3IFboRKV4zxpb8SuTRw2YPmRyoOUYIb0GgBRW2soSgS7sPpPXikOyRZ21NZqlj+iYAUCcVPSJlqOYEePTVEPpQ5MoVdNnyRXIMjSznAieFgGI8jJ+rW7okUlV/lWvvwgyM0hYzpuSvZLjx/bt03GhAuXnc5Tw0zmONrKKQ3jW2rsU4jHQX/eisJmg13uuIQA6rs+Qs0AdA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da36791-9322-45c0-a210-08d7ed2ae54b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:19.5798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kz9AnXiNHUDZ7j2Qh8m6r8VBXVahOTAXeAZuNnhDpj1KQQV3uyX0fQ74bwhjAs4i4EJpgzgBiaA2TNM9mRHJVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Even though some of the WQE control segment's field share
the same memory bits (a union of fields), prefer having the
right field name for every different usage.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 10c933e5da9a..bf3fdbea1074 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -233,7 +233,7 @@ static inline void mlx5e_build_umr_wqe(struct mlx5e_rq *rq,
 	cseg->qpn_ds    = cpu_to_be32((sq->sqn << MLX5_WQE_CTRL_QPN_SHIFT) |
 				      ds_cnt);
 	cseg->fm_ce_se  = MLX5_WQE_CTRL_CQ_UPDATE;
-	cseg->imm       = rq->mkey_be;
+	cseg->umr_mkey  = rq->mkey_be;
 
 	ucseg->flags = MLX5_UMR_TRANSLATION_OFFSET_EN | MLX5_UMR_INLINE;
 	ucseg->xlt_octowords =
-- 
2.25.4

