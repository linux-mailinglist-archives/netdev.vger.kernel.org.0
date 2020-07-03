Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E242132A0
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgGCELr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:11:47 -0400
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:4299
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725779AbgGCELq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:11:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYFYRLo0QdykM4fcMHkrroOdbpnfgu9OlSRPfZ0XpMpuyReOR/vVtOViCv7fOZSHlfK15XOSX08FIbYCe2vOsg9RIlPlatr/3OICnpC9T9D2bSHoG7xi4ASsoBBFSb1TKDNrtqAKB9g06SfGM5sqQUvHodngP4g+jnhYFWEWFxvKxm1y4ACAwoRSkpaHvlJj4e3Z3DMLcvOGlNcqOLOJOxEPa9PDGXc1xiV9frdf2PqgDmSdXAIvk+AiRWjtYxMbC8KqULJp8Seb/bBNmqTfuyInxeMMp1MkdtdtioX1ga9PgWwuJnHldXj0ryTQ8B4dHHE5GMfBAULi8QALz8FAiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2gR9yzP1TSZwQwklW9NAFMLw59Pf6Y0JIfF561SH0k=;
 b=WmawRmvchwp2cgN5kxN6rH2Sdh0D8mD29M8pgN9U4Jgz5dvU3x9auCvkriOlKJubg2+Id5aLVmahmawHH8XZeeVnxVzuCoHi/gu6OgK434ESCOa7YqWzUNJSzZ3zo+VgoDmP4WQloR1hRxNDTi02R+mnbiVF44gAZAfgZdGWTgt9L5sZXOt5JblC0qGZAi7dLOB3WFejB2jId8c6iS2TWf6IPe+DP6iAqsGyQ0BaU/cICIZk8PcZfwD+/PAMjD2AB6qXGXbQLOmKC4y8bP/8pmtp3G3yZuf0M9puRQEqvmhf2xAjo+ElNAsMe5FwwsNHwifQTH19C+tUBBIsrqfNyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2gR9yzP1TSZwQwklW9NAFMLw59Pf6Y0JIfF561SH0k=;
 b=oWTUhyKD4KeNiqpFxu9KKWNGx8OXlhacYDypmIOhER/13Cft1TyP9gHbfWJ7UwrxIE+t9tQCSmkcbujCvIWXvJNfrsPY8y5c8h9efVt9FjdcUeh86BrTiw0WDvGrm0ydFZbcHjgog7I+7uEcirQkB7MOHJk2yCIGNDN+fklsOHQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/12] net/mlx5e: Change reporters create functions to return void
Date:   Thu,  2 Jul 2020 21:08:21 -0700
Message-Id: <20200703040832.670860-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d40bd333-d455-4695-ae9c-08d81f06d40e
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5534CFCB2BCAB8D5032DC691BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P8SIFHNoU06DMeaScYk3BB9X2gH8llb4+L2yK6GMDcI8L9O+4l4c+TyUeVYdGQ02h2kId4XS173zIqMyb61ue7sQSYShnuv2wUDjkbeOySfo7ksJ3/40VO0KZLg6E78E9Y39Nk+qnWIbV5e05k/+iDaxRYCqxTXwE+dLicvqOfO04pvG6lLXXj6ug57wDizRZlQsnLcMDPK3SDi1ZQwCl4ue6GIGvndqS7GEbNP31usCy/b+eHKH8chmD8PpaHT2/JwmmM5/a6Q5+11yJgxLyb9P0XyoHbqW1faucGXU8VTNvioXzdQDnEq6vqHMGOb+0YHkgUUJC31Ds/J7NUJuqLUW3csyyFF+cevclY6L/AyFmpMYsTAo+nwrQ8EXWZ9V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ownEHVCd34wdQYZoHmqYDgRss3QMzyvvICOehBiI7teZPz2EOAX6jAzbr68N/BFbO2H11XTMnV/xDJhKeYOeQGWl4UrkQ5iXoybTY4TncAnUm8l50mDpPLZCRRwWJR/3sk1IP0BkW2A1IgGO+ka8FYBiNaJpb3/K2Nu9tfRI41EWtSQbLZRF40ZAHiU7ohsKRRbnW6ZxxmzgK3L71Xx5i33Biyy+VCxYcIkjIuAfd7crIJTO4GmX7sr3xPHuy8yRmL9RHmyg8IgSCT2MA04ssgatEQ69G5pj+vKFEb0DtIEVbXT5Bvpy+vf+QrcSZESFD979D7QOw3InbXPChus18uxL02ix81FcWNjF/BllVMs5iH1y6quBqh6dErhDHaeiJcRqb25HdtMwX85oc56zUEMGCDhdox6Bb4YSIcGy5ZE2UGmBccft5rhnisU/6k8VZoDQzfFvpO58xQ0v7XFPDxbD2/7ROqVouVQMwDtM6t4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40bd333-d455-4695-ae9c-08d81f06d40e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:06.4539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2D/YPvjYCYjeilJ12qPwp0sIfYoecDxk67FCSoWWSPTs8YIIRRZQeissc67rOeW8+DuuSFiLd7BAYIO+pwuXsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Creation of devlink health reporters is not fatal for mlx5e instance load.
In case of error in reporter's creation, the return value is ignored.
Change all reporters creation functions to return void.

In addition, with this change, a failure in creating a reporter, will not
prevent the driver from trying to create the next reporter in the list.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/health.c   | 15 +++------------
 .../net/ethernet/mellanox/mlx5/core/en/health.h   |  6 +++---
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c  |  5 ++---
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c  |  5 ++---
 4 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 7283443868f3..d0625ee923d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -97,19 +97,10 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *
 	return 0;
 }
 
-int mlx5e_health_create_reporters(struct mlx5e_priv *priv)
+void mlx5e_health_create_reporters(struct mlx5e_priv *priv)
 {
-	int err;
-
-	err = mlx5e_reporter_tx_create(priv);
-	if (err)
-		return err;
-
-	err = mlx5e_reporter_rx_create(priv);
-	if (err)
-		return err;
-
-	return 0;
+	mlx5e_reporter_tx_create(priv);
+	mlx5e_reporter_rx_create(priv);
 }
 
 void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index 38f97f79ef16..895d03d56c9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -16,7 +16,7 @@ static inline bool cqe_syndrome_needs_recover(u8 syndrome)
 	       syndrome == MLX5_CQE_SYNDROME_WR_FLUSH_ERR;
 }
 
-int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
+void mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
@@ -26,7 +26,7 @@ int mlx5e_reporter_cq_common_diagnose(struct mlx5e_cq *cq, struct devlink_fmsg *
 int mlx5e_reporter_named_obj_nest_start(struct devlink_fmsg *fmsg, char *name);
 int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg *fmsg);
 
-int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
+void mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
 void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq);
@@ -46,7 +46,7 @@ int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
 int mlx5e_health_report(struct mlx5e_priv *priv,
 			struct devlink_health_reporter *reporter, char *err_str,
 			struct mlx5e_err_ctx *err_ctx);
-int mlx5e_health_create_reporters(struct mlx5e_priv *priv);
+void mlx5e_health_create_reporters(struct mlx5e_priv *priv);
 void mlx5e_health_destroy_reporters(struct mlx5e_priv *priv);
 void mlx5e_health_channels_update(struct mlx5e_priv *priv);
 int mlx5e_health_rsc_fmsg_dump(struct mlx5e_priv *priv, struct mlx5_rsc_key *key,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index c209579fc213..5161a1954577 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -563,7 +563,7 @@ static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops = {
 
 #define MLX5E_REPORTER_RX_GRACEFUL_PERIOD 500
 
-int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
+void mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 {
 	struct devlink *devlink = priv_to_devlink(priv->mdev);
 	struct devlink_health_reporter *reporter;
@@ -575,10 +575,9 @@ int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err = %ld\n",
 			    PTR_ERR(reporter));
-		return PTR_ERR(reporter);
+		return;
 	}
 	priv->rx_reporter = reporter;
-	return 0;
 }
 
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 9805fc085512..b95dc15f23b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -406,7 +406,7 @@ static const struct devlink_health_reporter_ops mlx5_tx_reporter_ops = {
 
 #define MLX5_REPORTER_TX_GRACEFUL_PERIOD 500
 
-int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
+void mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *mdev = priv->mdev;
@@ -421,10 +421,9 @@ int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 		netdev_warn(priv->netdev,
 			    "Failed to create tx reporter, err = %ld\n",
 			    PTR_ERR(reporter));
-		return PTR_ERR(reporter);
+		return;
 	}
 	priv->tx_reporter = reporter;
-	return 0;
 }
 
 void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv)
-- 
2.26.2

