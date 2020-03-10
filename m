Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B65B17EE20
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCJBnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:37 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6053
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726655AbgCJBnf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+dPa45qs0htTcnccgJSQtD6MwAbWmV6Tdpho9E9G/6ZbXn/wOTWG+pU5tHkGHRGKdIDhYRJeeNG1/cB57E1zzCQoc4rOfrW+/rGHoEBUcPc9AM9Rke8zX0a9ZPUz/3rcBR1E2GzJAoo19CXVGRTU1NfJBDlGbMIZo5YZkLHvMuYpC3HOdrl9TYG5FWLMNEMv6e7zAKGemXfGFFqeW0CDoHfBF6RFrjsFPLN8AD7Lm3eGXzOXFkMt43Tj9pWJTUsIutr9MaDEZFbiSnq5pYqb/f/Vpw3HIWCZAB6GBgjUIwjMweJHlxzndkf797wbJKq45ruQJ5QHtbjmHPAEQhP/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yD/HULi7fz1DyTmRdPxUocOuxBryU7I0jE5oj+zsPg=;
 b=hdyaQDoOHozp+6Lm3pKfufrRC9ZBCfh/TRc1e/dwONjzLKwktmGspluSWyInAs39Jf1kRp+74ivFXTNMgOOND71AszrwGCxnNr5S3HMhbY5plffy6+yrZwJVtrOMyt55X7+6MRnDhckR/p+rfMZOV2bTa29xz5NGVS+8q4Sk5qOGfHlCFKHIvZu/PODwtgNzencETZqxdEiGhtuYoGrIIeKyKY1IOc8sNI8doGuHomsSWBjQmiMk/CYWpdCwfOyLt/E6c1+rim1OUuGoZjcrHTnhawnnmJYLLJjLlwzUH7xVLb9qvw/pFhmLXD18l2f/6q9olrWnu2MP1+R1CeX7MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yD/HULi7fz1DyTmRdPxUocOuxBryU7I0jE5oj+zsPg=;
 b=OYJAHEbBccdIzgGayJZgOYqh0v8ye6jBDSnvI2v8+N2DwAGpWj50CpWISaDAR8m2aglH3FAPqDFcn/o7dBNfV+1gVDMXkJY6omV0Z3mOl+zT9v6BHZTAJJSNXvjqMVNQ23xoToldespJ59XSF15ewsF2LFV7OgJd73bVQeAUm/M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/11] net/mlx5e: Show/set Rx network flow classification rules on ul rep
Date:   Mon,  9 Mar 2020 18:42:46 -0700
Message-Id: <20200310014246.30830-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:24 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a9667f97-bcbb-4a69-1486-08d7c4946d55
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5533FA4A7CFBEF9D8BEC21A1BEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:264;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBWdoCxKwgoK2F3zmN7Qm1tIE5lMJ036CBgkhrs5l/jQ7oOHp+J/xzWCEoYbyTRQJWX4Ftb1FiJI4HjLcx/D/nZVXD62Nqn3mHNxWt4ZTz5mWCQF9IB1BfgicgH3dag3IRAyedWyFNQqXnaNxR1jrXMs9gmolOXO4nh4AyLZO0rLAqGgJ0RdCVwvKXB4LbLZ8HUTbl96DNK6nYgIHBoZCSTc+YRjW7lBTDRbl07j4/T7Zs0rdWH5oF545ZVMGM+33QBnncPb5Y+AVISeVBH0BMKf28SP1TVjQ/kLW7jSm5mcTeB55dLd4iu2syC59Ary+6q5zKNL3n3B7eZqhIO1o8O+2JP5pOGhkJaa8/LglpLWAzqpZTgZinH83c/LpAiBuiJja6e56fr6sKpoNAmP+AtnAWiQkUgs2c5vdcc9YAa/Lj8JTkMe/OMTJ9zwxrlFE3gmF0aaUFtAFoavSPU0W2NvUha3FEAoabFT7HQI4G+zFmmIAgxd48AfJCxm8leS9w5AEJYfIUZC1npWXR5deVPN6+YzgotekZ7NFryp6EQ=
X-MS-Exchange-AntiSpam-MessageData: WosgbavWAos10RO0A248zlasz/kVKQwbRn8jXNDFqWXbdYLj/oEblaH7MzdMq9yx1kiTam7eZbNSiKGubu1UeC4CSifELtr9oJ+O8MAd4lSAyra/tdJK7Ui2RbopsMIL5JReWGlBQR0csrbLJ+WFnA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9667f97-bcbb-4a69-1486-08d7c4946d55
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:26.6519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7FyQsx5nZAVguz2+ZnHagdwc4HihJXM8Ip3TY4W3LIqbgnFxeLM9OH6GLqRmJtRBKs9wdnXAFSarCqxHZxnu+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Reuse infrastructure that already exists for pf in legacy mode to show/set
Rx network flow classification rules for uplink representors.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     | 2 ++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0410cdaab475..6c4b45c2a8d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1172,6 +1172,9 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 int mlx5e_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key, u8 *hfunc);
 int mlx5e_set_rxfh(struct net_device *dev, const u32 *indir, const u8 *key,
 		   const u8 hfunc);
+int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
+		    u32 *rule_locs);
+int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd);
 u32 mlx5e_ethtool_get_rxfh_key_size(struct mlx5e_priv *priv);
 u32 mlx5e_ethtool_get_rxfh_indir_size(struct mlx5e_priv *priv);
 int mlx5e_ethtool_get_ts_info(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f28472471315..6d703ddee4e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1948,7 +1948,8 @@ static u32 mlx5e_get_priv_flags(struct net_device *netdev)
 	return priv->channels.params.pflags;
 }
 
-static int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u32 *rule_locs)
+int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
+		    u32 *rule_locs)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
@@ -1965,7 +1966,7 @@ static int mlx5e_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info, u
 	return mlx5e_ethtool_get_rxnfc(dev, info, rule_locs);
 }
 
-static int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 {
 	return mlx5e_ethtool_set_rxnfc(dev, cmd);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 5a7de0e93f8f..86f2c0bb9507 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -371,6 +371,8 @@ static const struct ethtool_ops mlx5e_uplink_rep_ethtool_ops = {
 	.get_rxfh_indir_size = mlx5e_rep_get_rxfh_indir_size,
 	.get_rxfh          = mlx5e_get_rxfh,
 	.set_rxfh          = mlx5e_set_rxfh,
+	.get_rxnfc         = mlx5e_get_rxnfc,
+	.set_rxnfc         = mlx5e_set_rxnfc,
 	.get_pauseparam    = mlx5e_uplink_rep_get_pauseparam,
 	.set_pauseparam    = mlx5e_uplink_rep_set_pauseparam,
 };
-- 
2.24.1

