Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2856B1938C3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgCZGjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:39:03 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:8291
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727768AbgCZGjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:39:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyT/MxNIv9fpztOnySQw5ng4WCT50m6xrN81KoBdOskmDZucRwxj9Pqt7gxu0p7RiPaWhHVASbVIlJWL7/9zTClcUYpVw3DfPGWz/kG3Y4flm/bkF7okR2EqI7A8N71hlYfYPj8v31j4C/w7JOp7+mRC7BDj7c1kA5/ZDyaQA7GyzfyGYx++EMg2Ikxa6ZX0t1CUed8J1R0zkd8jUFF9WPbp8y/L87cPQCsajmer7o1GkcxSJkzF1o4rrPxBvCNA7kUGLdB73Lp7BRj4TgfbNiqkwKl9QN+2MhCxDyzgD/yYB+2VVUU5h/GOjcfqWHtL0xTxVuTPIvX9ZPfx2pUMmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MqRGQeZ7PJ+rNcDhPlyWzhr+lwZJFqJr5ZrBptvgT8=;
 b=gqDyjZTbASQJAVO5IH3n5II0QrLoQVoSTFerHyLYgTZYCwsbkADVoJcYxot7KOStq4KQpyqfXJO+2MXpSaZ/JEkYal5/74JO7o5QFbU5pRNHDMks+UQ/olKuzwXN1jf5ZAkzvMcX2TVSB18fj8pwM+ITwjuCDj31vRyE/jlHtOdpDvOqIuOJawcdPbBRg5+v2gUhNkbUpk2DMplZPdp2tyHC9nYGS/N2De4WYxDOUf/bUTJr6LEcG9jAukhVo6ykBOswRKdBXunYsRtcyxf4PS+wGde8zw+qUCO4cPsfaZeM5bDHA3m4QuhQI03UkDbROPcW3ZKdVEYbB3a9+OjTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MqRGQeZ7PJ+rNcDhPlyWzhr+lwZJFqJr5ZrBptvgT8=;
 b=ZCeEhecEnrGAqkKUdrOne/nYFwaodfKEDaeU5dxN+uGbGoaf4S5/Xzx+8bUvjzK1L+cI2jfUuRYlNDDgPwf9k6Hq3UGXuDHL0ZD3Y7kFxA08JCbwq0HK7LxBrqebdQzQZsQhK4uQFUYlfZGoF2D118qiHSBc6ww5y7P8/rbTblk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/16] net/mlx5: Simplify mlx5_register_device to return void
Date:   Wed, 25 Mar 2020 23:38:04 -0700
Message-Id: <20200326063809.139919-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326063809.139919-1-saeedm@mellanox.com>
References: <20200326063809.139919-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:54 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e81bab32-89bc-4ef0-ebe7-08d7d1505bec
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6479A193D7BEDA6AC8838737BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZi7wtahvoqU4eT8xnR8oIYqUUTH4FH+P6dPu80WjjpQ8LXJJfhbU/bL+bzClBwFhVJNVBz1abK4ZOF+XZe03vZJfFrQ8EauZjDPSt7VH1JRq4vVqyyGRRlmLKEjNyeJT1FBHAVtqP0XiGZvijxc6a3wQc7MwTX21Yd9jdiLKM+AVBgQ6ufWOMpzh7JG9LYXBWtyL0dmgnMR+JH0dWzPgwWzgZ8ZI91YZ/RNzYooMpAwajgrnFMIw2qMHjqyTx/A8ad1V/4rRRZe67bUeOEvtGgKiFlB6hW2bzefJHdMVht3jrPfwcEZZ3gJESi7EasEDWS2xhyQ/MuHdxTsNcrUuU96v2uyUQTjPfSdQBaWOnBer4m/89QOB2ABQ2Mj6sgHiugyLEApkfTcsDszlFnspy872aSTgJFkVYFPmhf+76HQML8nUPTI+BUnyXah+lRKxIzeWa4J+uPeyqbU8j3pEy621ylRG4G8SgMv9DynGpKy/JF/f9Ai9jvirhQeXQKu
X-MS-Exchange-AntiSpam-MessageData: 7MQvXzWHZ52zpYPkCBo5pffuhTZuu4gMV5HpILzVHHE/QJYUaEPsNk8z3lEl9nnQYjSBu4iRvi8buNWpDeFJlhwP+hq/H3uGVIpxdDX723OG5Gg/XcNZouugHdaD1THfFcv6d5PKyqTn2BHY9Ffsqg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e81bab32-89bc-4ef0-ebe7-08d7d1505bec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:56.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d380pwxawsWz3ZluZT8hgQDfDTbMGLPlx5bSyYvztVYb0YLdiOXqU9AVv8RLcCmSntWI4HibbxTKOv3AmyYXMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

mlx5_register_device() doesn't check for any error and always returns 0.
Simplify mlx5_register_device() to return void and its caller, remove
dead code related to it.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  4 +---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     | 14 +++-----------
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  2 +-
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 50862275544e..1972ddd12704 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -193,7 +193,7 @@ bool mlx5_device_registered(struct mlx5_core_dev *dev)
 	return found;
 }
 
-int mlx5_register_device(struct mlx5_core_dev *dev)
+void mlx5_register_device(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
 	struct mlx5_interface *intf;
@@ -203,8 +203,6 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 	list_for_each_entry(intf, &intf_list, list)
 		mlx5_add_device(intf, priv);
 	mutex_unlock(&mlx5_intf_mutex);
-
-	return 0;
 }
 
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 204a26bf0a5f..dc58feb5a975 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1211,15 +1211,10 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 			goto err_devlink_reg;
 	}
 
-	if (mlx5_device_registered(dev)) {
+	if (mlx5_device_registered(dev))
 		mlx5_attach_device(dev);
-	} else {
-		err = mlx5_register_device(dev);
-		if (err) {
-			mlx5_core_err(dev, "register device failed %d\n", err);
-			goto err_reg_dev;
-		}
-	}
+	else
+		mlx5_register_device(dev);
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 out:
@@ -1227,9 +1222,6 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 	return err;
 
-err_reg_dev:
-	if (boot)
-		mlx5_devlink_unregister(priv_to_devlink(dev));
 err_devlink_reg:
 	mlx5_unload(dev);
 err_load:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index da67b28d6e23..8c12f1be27ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -182,7 +182,7 @@ void mlx5_remove_device(struct mlx5_interface *intf, struct mlx5_priv *priv);
 void mlx5_attach_device(struct mlx5_core_dev *dev);
 void mlx5_detach_device(struct mlx5_core_dev *dev);
 bool mlx5_device_registered(struct mlx5_core_dev *dev);
-int mlx5_register_device(struct mlx5_core_dev *dev);
+void mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
 void mlx5_add_dev_by_protocol(struct mlx5_core_dev *dev, int protocol);
 void mlx5_remove_dev_by_protocol(struct mlx5_core_dev *dev, int protocol);
-- 
2.25.1

