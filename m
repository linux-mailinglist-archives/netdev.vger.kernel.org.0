Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BD0504CDA
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236882AbiDRGrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236909AbiDRGri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:38 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2084.outbound.protection.outlook.com [40.107.100.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A82F7E
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVNLlLE4ZuYTzW0h5+5fiJySC+8NYeP/OMx2OTTBm6RG302U45te7qwjLaQNwqFjF2nXPUoPhwg2iwugiDFTVQu90LBiT1FaSYLMHAEcshEWiedHC2jPqtz9ZgkjKiWz5EtIgjfkfaklC2+6+15VAfKzW/lNP/akGO/sjY0Juspcq8WCAXVfsYmhfIWENr2W2isQ6PeDNboqG5t4TqmtD+jua6mboXK6Er0RiRz06rWbg3tcVkbDSRpXAziGXxhf9JOOiGv+lg1JfYRIDMbYRMscVwrFV7MQaZoyGUHeh7f59w5VhswS1sLExky7CRAlhe1/JrvbGDd4VsuK6PqmHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URwJtH/4Z5IJZnUGw9Q5gNo3D9G+f4qm5qCqGm6Hk9I=;
 b=dXliHGRxtWemZM0RYgvc1fkqrQzTU27UlR4GMnqvDpQkNKxaEOtAh90p4+59LZLmCNybMVy2X5Jzx/8mxW/p6cW2ooDFaRqbwqcnrJpMmwdV3wziuu3WZWxPZxKFaErAy7cOdz6IxB/qVOLiYsgqPSj53baRqnUFk2Zpspbux1sSj0AgdOn08K8Lp6CMfhcImixGNUC2PKn0WizpzvKilFGbIqZJYDRzQ+UN5T/wAvtvHfj4OWTZOt15j93TgtKCAziLW6Pj2ucGzhF6ch14yepq53lXyFaF4oSEmDHmROVla/L8roYEhMF2sDFx6DqWnSF6GyALnPF+OUzOFMNSLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URwJtH/4Z5IJZnUGw9Q5gNo3D9G+f4qm5qCqGm6Hk9I=;
 b=doBfISZnrw0IKAjKOfnCSz8Dp1GUWCzLLVTNzKsqGktD91MhyHpDYc5QcQCEqt84KP1fBadE1Agni9eUnsRWL7KiubmfPI2e2fsNivA4xRmFBCJhtKTPiG+E3rw3qF3o7zWyOQ1ARWeGMd3gIf0OxnAeUW3XXSR+jm1bPCGW12fvxaJAmI/pk74N2ZbhZzd9ZD5wA1ubu1kG88tZNx0NC06D1SeOLiRpVjAkprOLZqF98YXEF5BWb2hTi9PKHa0hLL8waRyEIen06bT/uQx6qHhC4FLlfbz8HORN2lvYa0KY378RbCT5TcRqQduniqJARtZx0jyGuH/4IDw+7cweDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:51 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 15/17] mlxsw: core: Extend driver ops by remove selected ports op
Date:   Mon, 18 Apr 2022 09:42:39 +0300
Message-Id: <20220418064241.2925668-16-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0461.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::16) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb93ead8-84f6-4e4c-49c3-08da2106f09f
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB36641AC5DBED775DCD3BFAC8B2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pGUUSMit+Vgxa8kVXs4Vw9tetHs9UgnnCG2ll6nnmrAJyVVcjvKsZblFqmuBP3fLsXneaU/pff3xqZXMhm77eO69bc3OO9LCc51imXJ9+VL7KdeWJWj7p1soS/5wrWW4DSsRcexlPriHAltAI+FrCABF1ELi709Mc2/xi4VWf60QQA/f/t56vsh5bavOkWsHKUDZBryJ9T2w0cioV1h9T6QyTYPE1sgy4syj2FkEzGPZsFIm0J6EBjcg1gTgPM8s61cGl2RGxAXRUJqkYWwVOvFJ6rpgsOVpILQ3bg7vmtQs1ZITkZC8PMD63JKtHSpBk7joEHearj+Iftcwt4oHXtwxGHQxZyax6BMrtfMcvVhx6a4fofzHisau9DR5WW2MzF/HhMtzzZEv8VDiMQwntRYmIbTbwC+fVb2Im0NlPvkrb79xnC6RytD400FQVTteMbATV+rG+MABJsvRadvV0T1VbP++nYWXFDK6gVIIQRmYNp2u5kRrW8NY3Wpj/0z1zmIlQCnA+XP7rRzxQp6ucZ3zjG2UpmNJ19VXZNWdX1PPSrjaMwS8DjXO9g4aOpN1xENH8Q7iZR/tKSE68DEgMQuE9BGN65NbPCQOFRlzUJQPFX87TX1DMNIfnEEygfTcd69RQ5eFGziZuNiVQmYrEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AFf9M7yafGe+Np9LaoUDTVmTJH8/Tr7ab+J/wbxre97wk5Qg7InCk0A8b9QZ?=
 =?us-ascii?Q?S2gljqPv1WmtXnbuuTuxgoHlWNrXSQmsUR0ivI+dWmS/SieBfPIpxHRoB3Nm?=
 =?us-ascii?Q?d3rvu29yuYJ2bjOxRfDMtFVWl3W5nYSAGIIHl55R9eQOxnVCsjkghc2dGfYJ?=
 =?us-ascii?Q?WKA05hYNoLw21Qr9U3rohXxOVioN9BR8IuTFq7cpcDAQYFZvBm574W2ffRjn?=
 =?us-ascii?Q?sesRV0BYKengqY7TjRYztoz21W0hl7BJRQYNBS17ArcPpgbKFNgAlOBGR3jv?=
 =?us-ascii?Q?xWuBr641IabX4xHKLFk4FBsAxQoF5bjbcGrpWnTQKzpPY8zx95rbv3Ee5UQP?=
 =?us-ascii?Q?ZZDKLcLivCIsZRFka04cSiJ9/UHn0gF1RkcXmdzWdBj27af0pm6GQNzfbuxr?=
 =?us-ascii?Q?JVuyo7TWGU7+62mgGDYu/9dw8UJ5ei6Uv/eOMJlGJSCzykcx2TKPK9sjSEVp?=
 =?us-ascii?Q?0Q+xojjGv1jb0+Eao4VWtVNpnGTS+aUIbmhEyOAbgj7LLzb8NwRGeqT7brBM?=
 =?us-ascii?Q?aHw66Y7+6Nfe/X8eym2jlR40aEmwL7CFkwqdsM/5oVkZj2pCBKJc88ydBvVJ?=
 =?us-ascii?Q?ALNxXisCE6O2klXsM76pZBPSaczfoaeEYSBo4AvZJS/FmZMaSpi9IIQape+L?=
 =?us-ascii?Q?2LpeflqTUm73z9ZhlCJYoFDxTNLgJxT+Jb7eJ2X2rtUOiCyrxH9Ihanbwt1Q?=
 =?us-ascii?Q?d10uAvztOU/bv6MeEL6Iw2Ls/pwVrOwrWQYbcKBL+PDdC40UNjLR8pK2Mw2B?=
 =?us-ascii?Q?tIxpQAtKIMyV82hC4sobpDJK7SKJJLdZFAVHOs+jv5OUzPVJ2Nk8c/bhDllU?=
 =?us-ascii?Q?+jwbyN2FlvGPGwpIJwXONlAv6Q0pRibTP8p3/nvYZZhaXXfF11/ZufS35sSl?=
 =?us-ascii?Q?YYB8UEnekAn6+3ZAY4ushEpY647B+uK0VjUORo9yqBoNZj3Yb2Tc947cJDSA?=
 =?us-ascii?Q?9i6sd0QNE0NxJ0QD5X+cTx+F+Q+p6ajvxOOyQJYo1kteGXLaU548YeWhdLUJ?=
 =?us-ascii?Q?KXYhZZk344L52in+I6R3QDN6bmdStJcO8bASwQnAW2rJWJiM73R17F5a92YT?=
 =?us-ascii?Q?TfTWvQk5eZVRHzUVsbOIZgk5V5zQd1t/FZbQ2nJz9qWAhf02vrSkLfEf5HX0?=
 =?us-ascii?Q?Mq/ry+PIRDaZ/SnNLjRuwyOo/fb3sr/V5A65XEZ0/QZqW1FpCzllv+oxdB+1?=
 =?us-ascii?Q?jnrYFC7w9hVy3bC5WM8hBanUhw5YrdJW8Seum6cx/tX6PXXzy4YOn1gAlXau?=
 =?us-ascii?Q?lacTyGVWQX8yiHf2phfWuo1p9fyoQvu9rCHcS/2LOvmZcviZweXxI6pO8HT4?=
 =?us-ascii?Q?OK0FA/dvIc2matGDCwKjAorAYeM8rK5fcLct5niWS9Eegu/NJ55Wz7uHmEKJ?=
 =?us-ascii?Q?7cVj70HTZQmacO5DD7UPGzKmsMT22vlVU+N0xZnCY1Acv3ir7y7OFW6ou/PT?=
 =?us-ascii?Q?l2Nzwla4QOfMAQGSYErSBBpoJqAXQJpGi6Ab1Nk9uo8ftomXuLAT3XRw38U4?=
 =?us-ascii?Q?509rK1nnEvAskkZLAyaapOGggCGpntY0dhS2oWSYrbWtL2ZO2/zlaLopAmhm?=
 =?us-ascii?Q?r1Ys3PW0/ip69UwGVoG1YRoOssaP1sY1BSjtcJedtHNc8XKzePJrFSeFutVC?=
 =?us-ascii?Q?1CV9yUVmevh9ENxuARfmQc7YBpsc6lKbTL78WPl8rpczrth8MCc7mM23Qjah?=
 =?us-ascii?Q?DIxg6CQoTa2JjFvdzI9k6M7W1ZOAwG3M2lE5Pd+LTGdvH1wTM07awWv0Pud5?=
 =?us-ascii?Q?ILbK0WHVQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb93ead8-84f6-4e4c-49c3-08da2106f09f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:51.7931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fedd8rYwMKlyswlEVEdQ25q48L3JcWWGL1YW1+55W3ree7wTus98isAayvOTKkNmD4/TU8R1eWsYafSBpn7AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In case of line card implementation, the core has to have a way to
remove relevant ports manually. Extend the Spectrum driver ops by an op
that implements port removal of selected ports upon request.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     |  9 +++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h     |  8 ++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 17 +++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 5e1855f752d0..9b5c2c60b9aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3143,6 +3143,15 @@ bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port)
 }
 EXPORT_SYMBOL(mlxsw_core_port_is_xm);
 
+void mlxsw_core_ports_remove_selected(struct mlxsw_core *mlxsw_core,
+				      bool (*selector)(void *priv, u16 local_port),
+				      void *priv)
+{
+	if (WARN_ON_ONCE(!mlxsw_core->driver->ports_remove_selected))
+		return;
+	mlxsw_core->driver->ports_remove_selected(mlxsw_core, selector, priv);
+}
+
 struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core)
 {
 	return mlxsw_core->env;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 7d6f8f3bcd93..865252e97e14 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -258,6 +258,10 @@ struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u16 local_port);
 bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port);
+void mlxsw_core_ports_remove_selected(struct mlxsw_core *mlxsw_core,
+				      bool (*selector)(void *priv,
+						       u16 local_port),
+				      void *priv);
 struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core);
 
 int mlxsw_core_schedule_dw(struct delayed_work *dwork, unsigned long delay);
@@ -331,6 +335,10 @@ struct mlxsw_driver {
 			  unsigned int count, struct netlink_ext_ack *extack);
 	int (*port_unsplit)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			    struct netlink_ext_ack *extack);
+	void (*ports_remove_selected)(struct mlxsw_core *mlxsw_core,
+				      bool (*selector)(void *priv,
+						       u16 local_port),
+				      void *priv);
 	int (*sb_pool_get)(struct mlxsw_core *mlxsw_core,
 			   unsigned int sb_index, u16 pool_index,
 			   struct devlink_sb_pool_info *pool_info);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b4e064bd77bc..c3b9e244e888 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1999,6 +1999,20 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
 	mlxsw_sp->ports = NULL;
 }
 
+static void
+mlxsw_sp_ports_remove_selected(struct mlxsw_core *mlxsw_core,
+			       bool (*selector)(void *priv, u16 local_port),
+			       void *priv)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_core);
+	int i;
+
+	for (i = 1; i < max_ports; i++)
+		if (mlxsw_sp_port_created(mlxsw_sp, i) && selector(priv, i))
+			mlxsw_sp_port_remove(mlxsw_sp, i);
+}
+
 static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_sp->core);
@@ -3785,6 +3799,7 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.fini				= mlxsw_sp_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
+	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
 	.sb_pool_set			= mlxsw_sp_sb_pool_set,
 	.sb_port_pool_get		= mlxsw_sp_sb_port_pool_get,
@@ -3822,6 +3837,7 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.fini				= mlxsw_sp_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
+	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
 	.sb_pool_set			= mlxsw_sp_sb_pool_set,
 	.sb_port_pool_get		= mlxsw_sp_sb_port_pool_get,
@@ -3857,6 +3873,7 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.fini				= mlxsw_sp_fini,
 	.port_split			= mlxsw_sp_port_split,
 	.port_unsplit			= mlxsw_sp_port_unsplit,
+	.ports_remove_selected		= mlxsw_sp_ports_remove_selected,
 	.sb_pool_get			= mlxsw_sp_sb_pool_get,
 	.sb_pool_set			= mlxsw_sp_sb_pool_set,
 	.sb_port_pool_get		= mlxsw_sp_sb_port_pool_get,
-- 
2.33.1

