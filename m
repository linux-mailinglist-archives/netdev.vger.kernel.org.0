Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC3816F4D0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgBZBNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:23 -0500
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:44516
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729170AbgBZBNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PQAOuiXQUGdfWIYbcQffltPDkJaFBz9VyBuxgXLvr5/y61dQlFmqO5opPFujOjPZQXfoayTvJe3KeOY7tEmb9GXz6S0h5rtl27wDSBSoFqj49Of2fyS593gm9TRDQ5JsqHwUo71mLyb+tVC2PlkCawQ8rPq/EpH603pSIBrt9Mp+ZQIoIQqho9t5uc8T+R54SA4BPw30af7mwMFtdsqcXCN43sp3cCf7tC7exqLej9fgQCcegXRsuTKqjUf+QiW8g0YJy3amFlsu9iXFthW1X7WmSQnGNCJgry0rwgp1RSpTWHMjWM4segL2wMNAzBoLARMJ3Bcv5kZ+fQzRdJSM/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtnLMxptqcMSlGgYcMGlS6Qhwb80lvnPsBUzyfIlVJQ=;
 b=eCMwA1LA22ZeNdf4TVANk5Co9FCN0LHuoc6Q5iY3z7Lcpl+On5zx/1WU/9asMemQsQScqvVCFXphezfnmYniwWkFrIIv7vDPuqpUAZOKywzXnnTVM6HQ/Z4l+JgSGsP3Ow6Pey+flV+TRvZTmlB/BLBRMhYYeB+mI2LbYNnC09EW/qTyA6mL3m+9ywNdOwDVFsAx+u/PZNl9vRAUyPoIyYq/qcqAlbEv8+sClsK66ZHUWyLEF06a6lfXk5G7RRhDZgz969y3S4DsUSDWm1JZqsuZEXuBV6o1/pQ9EIL8kbeCbiO9RCIW9APox+DuSC/GPlr5GxJiuW3oODtHRwaE1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MtnLMxptqcMSlGgYcMGlS6Qhwb80lvnPsBUzyfIlVJQ=;
 b=HXgvFKOkMk4HpmtzrcZ4OH/zdC7udstTS8gEq/HHIapFSOcekcAyrJK7/or4Rzz4I+fTy5elwQm57pJoXhAUi1OOU13R9pOkC6Vx2TnnvD9qZz1gfoCThbH1Fy5uKQSnE3Dqu5fBSzaIPOA0SZgo5CQ0G40y3glD7RdZOcaHEzY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/16] net/mlx5e: Rename hw_modify to preactivate
Date:   Tue, 25 Feb 2020 17:12:34 -0800
Message-Id: <20200226011246.70129-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:17 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a33795c5-ee6b-4105-3e47-08d7ba5910a3
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5869A5C9E5CBEF50514C72CABEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(6666004)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(956004)(36756003)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7unqHtkko8+F/IEvSGu+/pJZvNh1Yg2nY5wtBKIzrZ6xZXI8sZjAIMKJWzkoK0HqbLYjEEtXILn+WeZ2fzD6Veq6Kovw3FlA5DXKwoR0fwLAJ3+o2FX0rEgHnu+yrhjQ5tVVNB5IrkkNzbmnAFse7+ViOkiIsocfVnEYIuEAKroBeK0slPiguwBeO8VwQJgfB1TSthLa2PhiFpFIBMhgJPCg8yXW8O6Y8GGFltl4sIeY1X+sSNtIA+Co2bsfIJJYFNEORUGRpFrDABLuG4r6SrGlIcn2fhUhxQFtMWRH8Bl9mfaRA47AvOEKHmtYzNSjBhMsfjjpJZ+X+ktGnW7JmkMdR797AvltFIROuKqr8m1OIAyEUKApRZRP4AbZx5yeBcGK1B9wJCRFcyRElao8bddvnB5dxmAs4cwkPua3Bz/ESfSAyfgyC7yeElzW2QHNab4dzqvB65/LPwpqHd+sWGWzq8V+00AYXQqp/GR40KIBxvPWKt2q1+tAURg8FluRHfDUEO2hdyH6imH0Wpg+KyaEv+xZOd7vZeRO7BzZeTA=
X-MS-Exchange-AntiSpam-MessageData: SdpeExUOpI4vFZ30LS9naM3dcSyhwsEhmoLNgO3au2357VPYLTsIIAACezOtNr0hjqbcd+FOzK87A4kLsKIDU+RQgkZE/aY8oGWSmGJ6j2zIYPV98bdy7fEOoFA0n7+iydv9uroe9CW+b/fw+okqFA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33795c5-ee6b-4105-3e47-08d7ba5910a3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:19.3801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oSSburL0VSn/CVmKfksgMrMxY/MJz0WPXWsqkYQOYvFQPZCmDpXDgjmO90g1+YQkli+ZByFUls0vAdO3nAG0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_safe_switch_channels accepts a callback to be called before
activating new channels. It is intended to configure some hardware
parameters in cases where channels are recreated because some
configuration has changed.

Recently, this callback has started being used to update the driver's
internal MLX5E_STATE_XDP_OPEN flag, and the following patches also
intend to use this callback for software preparations. This patch
renames the hw_modify callback to preactivate, so that the name fits
better.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 220ef9f06f84..bc2c96b34de1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1035,14 +1035,14 @@ int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs);
 void mlx5e_close_channels(struct mlx5e_channels *chs);
 
-/* Function pointer to be used to modify WH settings while
+/* Function pointer to be used to modify HW or kernel settings while
  * switching channels
  */
-typedef int (*mlx5e_fp_hw_modify)(struct mlx5e_priv *priv);
+typedef int (*mlx5e_fp_preactivate)(struct mlx5e_priv *priv);
 int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_hw_modify hw_modify);
+			       mlx5e_fp_preactivate preactivate);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 85a86ff72aac..152aa5d7df79 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2937,7 +2937,7 @@ void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv)
 
 static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				       struct mlx5e_channels *new_chs,
-				       mlx5e_fp_hw_modify hw_modify)
+				       mlx5e_fp_preactivate preactivate)
 {
 	struct net_device *netdev = priv->netdev;
 	int new_num_txqs;
@@ -2956,9 +2956,11 @@ static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 
 	priv->channels = *new_chs;
 
-	/* New channels are ready to roll, modify HW settings if needed */
-	if (hw_modify)
-		hw_modify(priv);
+	/* New channels are ready to roll, call the preactivate hook if needed
+	 * to modify HW settings or update kernel parameters.
+	 */
+	if (preactivate)
+		preactivate(priv);
 
 	priv->profile->update_rx(priv);
 	mlx5e_activate_priv_channels(priv);
@@ -2970,7 +2972,7 @@ static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
-			       mlx5e_fp_hw_modify hw_modify)
+			       mlx5e_fp_preactivate preactivate)
 {
 	int err;
 
@@ -2978,7 +2980,7 @@ int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 	if (err)
 		return err;
 
-	mlx5e_switch_priv_channels(priv, new_chs, hw_modify);
+	mlx5e_switch_priv_channels(priv, new_chs, preactivate);
 	return 0;
 }
 
-- 
2.24.1

