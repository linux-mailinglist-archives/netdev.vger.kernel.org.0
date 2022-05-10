Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758C8520D6B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiEJGCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbiEJGCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:08 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EE7283A0D
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXqoR0VMLfapxeoseu4+WpDtJPr7l7VeSSTXT6i09gZNx1AcS/zlWCXiWkQKD9VAtt4mQFabmPaZWI0p42rprg+Gdjayp54h5d3ws9nL+sZ9FzmQK+DWbre2dGpYJ4VvuowqkeD/k7k236Vondszs76i7iLB16RzfEkP6nBfddo5NscMF81xse502y6c9tmEVPgUpzNhNlmW+kdbwCl1kXfcEO+txRyWE5dc2Gmes35i2kIhcaEZtXDDEEK+lMTNz7BH5JbBsTMUxQ6S3jv14j/N6Ae4I1+aft+X+rz29p3wnmYaEHlKTRVHX78sVj9MoPxW9+lsaHMeASnomTk1wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYQ64SqbFNU+STJYLujzs0X5Yf7PJTLow6boB240ioU=;
 b=hJCmucfvu6v3dTmeMR/skzQ674nLKQeOWVpuCsVXhyKTrcB8BE5MaHkJGBmpuvr4lcwoVrj0L8k+kcNf7KEIrwb5NSXXms8TVql6HxpTqlx9lwu+KUSbL4cIVA9RsRrH031EXqAk7hKMHWed8+iMUF7hlyv34hMACunZIo/awWxWZEhEYpi7xLyFNDoW0p+xDi8lu2syfshatok2L+USZqutA2goyQMv40JLc+VKIIC/5CkY3RYeqPSdlFggoUbOf4YOP88wCGjD6aP7r5E97FJm+uu5wQKo3EM8x5SjhVQCm/e0bFmxrJ81vL/vJMK6Fzb1xto4LmkZukaGkjylgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYQ64SqbFNU+STJYLujzs0X5Yf7PJTLow6boB240ioU=;
 b=SEzOVuJcElHq7KSL8/cTRBOTpxUIAwf7oN7wCryuxeW0uum0cuq2A9W0egQp4BPp81rzoRaN002q6s/QWWIldq5QAVwaxbOerbl+nSyY1q5Gm19WIJD+OvpHc6hmPoKbKys5b2MsTTaKcBDVEsyFdR5lUw4CHeFUIOFchH9PbU8wCbxgruUfCsy4H67elg3i3xGpphBkVnpd2Jp/ks5YL64OzRDiAQQUJvL5FIw7xSF6ycfySosDaUTJHu9S26OQVtZDKGICdydFRtwOIBLqXijAFXyCFCqiSfUiyZxUaz+25e+/K+H1dE+72cxiE9Klq3nlg89KUSUHLqExDGkhiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:05 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:05 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Lag, move E-Switch prerequisite check into lag code
Date:   Mon,  9 May 2022 22:57:33 -0700
Message-Id: <20220510055743.118828-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0020.namprd21.prod.outlook.com
 (2603:10b6:a03:114::30) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44a78a37-a512-43b9-3aad-08da324a0ca9
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB63834FFF0C2AF91D705D6ABDB3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kDen+9braHR1DuXTWolpzgQOypfF50QZUcivQZTW7sfeyAeU+a6smHIA0Mc6kHBbcruK9k8E6dM5lrQ86bZ3nNjv8D6VR1NUmuJ4/CGWmNQ3bUv0jkPw17BEEm5vy43AyiCT31LwEAIPJJszPcRLqtD68Of/unf4IUl7slAED+Szi1ZioAhGKgbaTB4UPZT+AIAEAyaTP2mRMx5QZR9gjgtRtf5T4FBqvKDWlwo3PTpxikzcCTvJLN4fAlijojvC0XCRyB7ybQ30ABQMUPHwsrKVg2FsYugBhrvdUdMRIADu8C1ccSxuysnpzSu24UZ48fgNOdklVYzp0+VpkAWxnRGrIkk51SrXQxnGe28IQuvVZigiva0j3SKJaKJTPlog7+kj4dPIdh5oQ5adDDEh9nawmcAev3EgMYPbhdbJrplbHcXgSztH2UyKn18yY6t7uwNYxHXxsx+yhU43mu5fcov+DQnlhnkeaaqql7Tu/khkRo/ba+Bi6zit5YxiQjpgoyv4esWoPRGjq/Yi0ebypgPG+r+jIMprcQtYKg/bciglK7ymE1vxWbZcVmvXzL48ttjwVLxY/0XQyOARnQPotzCDS+WgvDUaMmqc6oE4hUyB3ahXQcxvoz46kfk/nt+jVS4j0a3vzL/ARRmvO1EAiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KkB2P9f3tlcwC/u/xmPWnZthgcdc2Pqua+Ddp7PH0SiL9XCPTcBPY9dQnOCD?=
 =?us-ascii?Q?qrPDX2CR+e94IgwxBj8+n/Yhe+lqS1ELf1P3V2FUeWINwTkE6pRwpnbs4NQ2?=
 =?us-ascii?Q?f00RsYoQYhZthBTNPFjenv8SUZzIRL9TzqujbLrMm7F6Ky9EuSuJGaIJHT8K?=
 =?us-ascii?Q?tgedmPYwv7izhhedoYv4dHBo1fjV/Rl4j4CkGJKFRHCjtUh5Jye019/xbVzd?=
 =?us-ascii?Q?0F7Iv155e6jBx9CdTYJzyb/v8cuQcQrDtzdvmzM1Z33fWsaXr2m0x602YeOQ?=
 =?us-ascii?Q?JpdtpfoI/h9f+GqOOvxWTjpsRlLQ5dS4zPSYT/IDrC7BtOEG1kdNe0gidrWh?=
 =?us-ascii?Q?SntcLx7eW/9MuGNk/x+uoy0AZ+7ETqLrCwhL8WSVnqXGleTEJ+wWYNtaFOCV?=
 =?us-ascii?Q?U05UzrgJnVvYZ0kXkqHzNQzL7J94s6X+VdD/MBKWDCv+O4piSDBra4gDY+Ws?=
 =?us-ascii?Q?RVbvDPeWYD8Kc2HIqg2TPm5X7G44y2KEgQAEtMlEOO5DKx8qOm+Pc7q1Fedv?=
 =?us-ascii?Q?so69zk2m8k4iM8N7WTP52oY/Agflsra4seEGsofNpCC4eDMykDU+w2ZAqRYO?=
 =?us-ascii?Q?ikwvYQ2gI2yxldCNlaL7JgjPg/g8ruwSam/zZW5jkSHnAdzpRvaMuJWMWmwQ?=
 =?us-ascii?Q?nntMgfWJI54mo2ImN3CP5gL68WPI+fWZ9AQBHW2AF5KOMT7P/fsNgQe/JqMY?=
 =?us-ascii?Q?g7HBt9IC9EQv6YslJbOwJFTwWarXEaUu3KpQliQKUAz74RiL5HWNdmG+H+Fn?=
 =?us-ascii?Q?O/UagcKWya+OoKDKvibVaXPMonyvnmXHw/EXus1yYN5hHKHKLCYjshUga2w/?=
 =?us-ascii?Q?Q0KwlT4ILhcNyq3eP+t3hFXD4/5hbVOwwjhS3CyoE8b4IiqACwl9W/NeNFnK?=
 =?us-ascii?Q?guyNgpoUQx9S1VR1ZwclNsNKlkh+GFiput2Gb+PT0Gp/7amwJJk1dpdL+3YY?=
 =?us-ascii?Q?RSwFPh6jdg6Yd36yjrE8hVYv65rB9hwc3UklsxbruLaYfRc56LHz16xEm3jm?=
 =?us-ascii?Q?fUUwf5ofxozA83fFz5fJZ9UhHBtWoA6yVi6bwVf7cUzwTJFkN8IF9cSH++/c?=
 =?us-ascii?Q?LK8JSLZcQJgv2CNXRdczKIBTiAQPXDzKJF8qsU2+vn3fHV9tAjnIyCsY7Mvz?=
 =?us-ascii?Q?0ttVaaAWxFVgeQvtOMkpMW/LFiIeECM0hYSc4AO4uTQjJ67WEdlRRLn+pzsJ?=
 =?us-ascii?Q?DOsAO9keUY+Ik7rSitqupkqliXY+bipEEe1a8XGTR1/Sd8qsPk594/xsooBA?=
 =?us-ascii?Q?30a02R0k7Rr9lIg0oiEepvno7ftxjQKz9Dwt+67k9DkflxX8wb9nInYYgwKq?=
 =?us-ascii?Q?adV74+l7EDs0uFV0IVht2NOHQeYNewyn6ntascWZH1T+bKAtwzGTWHM3WsHE?=
 =?us-ascii?Q?S0IUMQr4ylaBGH+hAunq2g6P/UiP0zj0ep/fxuVsTWAUhA7SYaa1EoVbSnXj?=
 =?us-ascii?Q?+1ctHThyYzWLYiaE3iBF5QmKN46eQiupmzCjnGakZteMGTsUdj86ozE+YBv0?=
 =?us-ascii?Q?KWtn6LVx9rWRvHB8RBRNlpFPGBRu13BOPGi+190t0naRj1KYalQ2YiLRsx51?=
 =?us-ascii?Q?PZdaqntK2UAT9CNzTLHwTgoKsVh445RN8YTR64dWUueRj1b6NEWtqtB+0r41?=
 =?us-ascii?Q?cq+R9ENl3IizS94bXPxSwOjWitGUDTLkD1dcy+5I3gdxARMfG+2WoV47Lh0v?=
 =?us-ascii?Q?7oRhSTkl6meFyjt00hXG9ZuimZ8CeMl7yClkl+78ILw1jqeIBqVwSHDMY/RE?=
 =?us-ascii?Q?z/OBVnS6io631qddTwn9fS5aUx13VVyskzYihAbKCc7iFPWWpJ+s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44a78a37-a512-43b9-3aad-08da324a0ca9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:04.9607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ARnSKSGZ3hnJHfGDcjU/B4E1IUbhoPzaKglyl25vDOD3jaBBE584y/j/4yZw6LXh6h/cKPhdkBLBiIDDiEMZg==
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

There is no need to expose E-Switch function for something that can be
checked with already present API inside lag code.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 11 -----------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h |  3 ---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 11 +++++++++--
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 25f2d2717aaa..8ef22893e5e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1893,17 +1893,6 @@ mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev)
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
 
-bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1)
-{
-	if ((dev0->priv.eswitch->mode == MLX5_ESWITCH_NONE &&
-	     dev1->priv.eswitch->mode == MLX5_ESWITCH_NONE) ||
-	    (dev0->priv.eswitch->mode == MLX5_ESWITCH_OFFLOADS &&
-	     dev1->priv.eswitch->mode == MLX5_ESWITCH_OFFLOADS))
-		return true;
-
-	return false;
-}
-
 bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *dev0,
 			       struct mlx5_core_dev *dev1)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index bac5160837c5..a5ae5df4d6f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -518,8 +518,6 @@ static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev
 		MLX5_CAP_ESW_FLOWTABLE_FDB(dev, push_vlan_2);
 }
 
-bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0,
-			 struct mlx5_core_dev *dev1);
 bool mlx5_esw_multipath_prereq(struct mlx5_core_dev *dev0,
 			       struct mlx5_core_dev *dev1);
 
@@ -724,7 +722,6 @@ static inline int  mlx5_eswitch_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw) {}
 static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs) { return 0; }
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf) {}
-static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
 static inline
 int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw, u16 vport, int link_state) { return 0; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index fe34cce77d07..1de843d2f248 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -457,12 +457,19 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 
 static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 {
+#ifdef CONFIG_MLX5_ESWITCH
+	u8 mode;
+#endif
+
 	if (!ldev->pf[MLX5_LAG_P1].dev || !ldev->pf[MLX5_LAG_P2].dev)
 		return false;
 
 #ifdef CONFIG_MLX5_ESWITCH
-	return mlx5_esw_lag_prereq(ldev->pf[MLX5_LAG_P1].dev,
-				   ldev->pf[MLX5_LAG_P2].dev);
+	mode = mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P1].dev);
+
+	return (mode == MLX5_ESWITCH_NONE || mode == MLX5_ESWITCH_OFFLOADS) &&
+		(mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P1].dev) ==
+		 mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P2].dev));
 #else
 	return (!mlx5_sriov_is_enabled(ldev->pf[MLX5_LAG_P1].dev) &&
 		!mlx5_sriov_is_enabled(ldev->pf[MLX5_LAG_P2].dev));
-- 
2.35.1

