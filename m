Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2621B1853
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgDTVXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:08 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:60862
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgDTVXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KWeA6SnPK48Z9W10NfFs6mE0YuE2OSP7m5JypGtw2MYYvYfreP28P5Hp96cZctyOzt17x2PPkv00XOaozH+G9F/nCzEtmaHj/A2bt91TpsGdeiF6W1Pj7RXipWa/AsXXMb7+8oezkficBJsktZIBibLbe7qS3/2okO+6iE1WFBT1CawUEqd5UzA6F7ubdV0AQlEwR+diVhhAIWENkPgqaISWe9BoQV2O7yfZ5hQGHWY/eMqQ70Cv8b5zLj77TiZdbPoGHHZ6K7qVGlbuu0gEeSPuP3V1exKqluD6s5RSBoNd2Of2hTgCYeVDhtq9r9Zit48nY3LOrDeEBKCkAUhHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k4anqKfDs3FuBKQwLKOfJY2m6CM6gXWVKiyJFxrdC8=;
 b=FMp91IvtvGwz+qBKUPmNCUVWWnzNp7UDUKTGiNW/v60k73eltov5H/3K41b2/g/xnq5KjBDlBqvSIOSWywYEn096SdDib8KQeyt1cONd/CcCsTXXj95UFwub15pFrymUUZg+PjcLjzhKs69vTtKR30dN6zh6vz3qgmMeWtJHIvTuILryGOYu6GXc+yjPa9hJITJJjQxVgQWT273EvxADy9nCjVUgiykpm1lefVFQxrieYNy/YS7adrkyUXtHAfPX6l8B9h1v9v+Ax5CW1pvwCadKTzGr8LZfm9Jm8uQvXYb2mdimY2y2wvXXneGWU2sh5IR10jkgAooqqNSxbenMqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k4anqKfDs3FuBKQwLKOfJY2m6CM6gXWVKiyJFxrdC8=;
 b=SjKTmKH7uVxqHSceabSatyO02dZD8Kbmk/G/aMj+1p/hEj8vI1OhLbfAaDeU7Zm0mQhDHPWDrANcxR8ei/gWxUEjiJHlXVeC/BgTQOGoEECEvcs3nnuDnkBigHBoGCJWp9edTcVmigysfrBmvIyCXyRkha2NdxFYhv6jOgiSCD4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:23:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/10] net/mlx5: Refactor mlx5_accel_esp_create_hw_context parameter list
Date:   Mon, 20 Apr 2020 14:22:16 -0700
Message-Id: <20200420212223.41574-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:22:59 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6dfa0b32-efef-4a24-a3b6-08d7e5710177
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6478199D4EBB4AF267323B60BED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfZt31iXW8pgaNHmXPgYK7kmJXIWJrHiZ7xcuMtO8vB8zcdRRKn3EdxfM0AeiL6Q6aU/2CaZp4o1YjjzwezViNea7jX77CIiuz/VNH+sK7Y4pr9GsW79llk9R2renuaBfHoQp+2QFIPNBsci/ZOd8rtfmIn7CwLfE1FfGpByO82ztJ3iyBI3f3QhKxHXKD9Ut0pfUXN7iPp0Cds6oBZE6TmNo2CeStEoY+pJkuaZYS6C9Ge7qS/52NGcXO75IpIFnMLLQJS6eDK0/z+by7lupsnDMlXnQPWHHVfXoBY9602bmwxc0J0LG4Y14+PTnJJBVXFXhCY85c8aSAJEMM3zod4pZPucY16rXI+EFOT43WpuU20iHifULN/ydCGN1m53PORje/GXDbSQqz1c8pNW96cHTD24dnPgSgWDfg4mC7EbCTPJwI9Sq7jgVCstLWwoABAJ2WKLFEa346fVPmu6zKtNe+ZM73vtGkzkW4D5LJ+E3SabKAWrdYpFEZPXyCdD
X-MS-Exchange-AntiSpam-MessageData: m2Oq3eXbN5VDXfRK4ZovSMRRcCFTEpYtD/51ixLc9zd9v0ZMLckVLAmRnmoSjwuDlSNEg1T3ILIEHALVgTDpb9qkyMnloDluiRQgYuX1VIQjACo1767kLrUareh3Yqshm+6wDUdBGoS1dF+ZRyVv6g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dfa0b32-efef-4a24-a3b6-08d7e5710177
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:02.8389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crrKZfgE15dwwpiGa0yyhmM7jjyxPmvA/kF9m8HnNm4Lqi1UNUZyPXwxykRXyR0C+5r7Sd6Fe4ZXOjLvLEjI3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

Currently the FPGA IPsec is the only hw implementation of the IPsec
acceleration api, and so the mlx5_accel_esp_create_hw_context was
wrongly made to suit this HW api, among other in its parameter list
and some of its parameter endianness.

This implementation might not be suitable for different HW.

Refactor by group and pass all function arguments of
mlx5_accel_esp_create_hw_context in common mlx5_accel_esp_xfrm_attrs
struct field of mlx5_accel_esp_xfrm struct and correct the endianness
according to the HW being called.

Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/accel/ipsec.c | 20 +++++++++++-----
 .../ethernet/mellanox/mlx5/core/accel/ipsec.h | 10 ++------
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 23 ++++++++-----------
 include/linux/mlx5/accel.h                    | 12 ++++++++++
 4 files changed, 37 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index eddc34e4a762..a92cd88d369c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -57,13 +57,21 @@ int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
 }
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       const __be32 saddr[4],
-				       const __be32 daddr[4],
-				       const __be32 spi, bool is_ipv6)
+				       struct mlx5_accel_esp_xfrm *xfrm)
 {
-	return mlx5_fpga_ipsec_create_sa_ctx(mdev, xfrm, saddr, daddr,
-					     spi, is_ipv6);
+	__be32 saddr[4] = {}, daddr[4] = {};
+
+	if (!xfrm->attrs.is_ipv6) {
+		saddr[3] = xfrm->attrs.saddr.a4;
+		daddr[3] = xfrm->attrs.daddr.a4;
+	} else {
+		memcpy(saddr, xfrm->attrs.saddr.a6, sizeof(saddr));
+		memcpy(daddr, xfrm->attrs.daddr.a6, sizeof(daddr));
+	}
+
+	return mlx5_fpga_ipsec_create_sa_ctx(mdev, xfrm, saddr,
+					     daddr, xfrm->attrs.spi,
+					     xfrm->attrs.is_ipv6);
 }
 
 void mlx5_accel_esp_free_hw_context(void *context)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
index 530e428d46ab..f9b8e2a041c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
@@ -47,10 +47,7 @@ int mlx5_accel_ipsec_counters_read(struct mlx5_core_dev *mdev, u64 *counters,
 				   unsigned int count);
 
 void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				       struct mlx5_accel_esp_xfrm *xfrm,
-				       const __be32 saddr[4],
-				       const __be32 daddr[4],
-				       const __be32 spi, bool is_ipv6);
+				       struct mlx5_accel_esp_xfrm *xfrm);
 void mlx5_accel_esp_free_hw_context(void *context);
 
 int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
@@ -63,10 +60,7 @@ void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
 
 static inline void *
 mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
-				 struct mlx5_accel_esp_xfrm *xfrm,
-				 const __be32 saddr[4],
-				 const __be32 daddr[4],
-				 const __be32 spi, bool is_ipv6)
+				 struct mlx5_accel_esp_xfrm *xfrm)
 {
 	return NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 29626c6c9c25..9e6c2216c93e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -199,6 +199,14 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	attrs->flags |= (x->props.mode == XFRM_MODE_TRANSPORT) ?
 			MLX5_ACCEL_ESP_FLAGS_TRANSPORT :
 			MLX5_ACCEL_ESP_FLAGS_TUNNEL;
+
+	/* spi */
+	attrs->spi = x->id.spi;
+
+	/* source , destination ips */
+	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
+	memcpy(&attrs->daddr, x->id.daddr.a6, sizeof(attrs->daddr));
+	attrs->is_ipv6 = (x->props.family != AF_INET);
 }
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
@@ -284,8 +292,6 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	struct net_device *netdev = x->xso.dev;
 	struct mlx5_accel_esp_xfrm_attrs attrs;
 	struct mlx5e_priv *priv;
-	__be32 saddr[4] = {0}, daddr[4] = {0}, spi;
-	bool is_ipv6 = false;
 	int err;
 
 	priv = netdev_priv(netdev);
@@ -331,20 +337,9 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 	}
 
 	/* create hw context */
-	if (x->props.family == AF_INET) {
-		saddr[3] = x->props.saddr.a4;
-		daddr[3] = x->id.daddr.a4;
-	} else {
-		memcpy(saddr, x->props.saddr.a6, sizeof(saddr));
-		memcpy(daddr, x->id.daddr.a6, sizeof(daddr));
-		is_ipv6 = true;
-	}
-	spi = x->id.spi;
 	sa_entry->hw_context =
 			mlx5_accel_esp_create_hw_context(priv->mdev,
-							 sa_entry->xfrm,
-							 saddr, daddr, spi,
-							 is_ipv6);
+							 sa_entry->xfrm);
 	if (IS_ERR(sa_entry->hw_context)) {
 		err = PTR_ERR(sa_entry->hw_context);
 		goto err_xfrm;
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index 5613e677a5f9..b919d143a9a6 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -92,6 +92,18 @@ struct mlx5_accel_esp_xfrm_attrs {
 	union {
 		struct aes_gcm_keymat aes_gcm;
 	} keymat;
+
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} saddr;
+
+	union {
+		__be32 a4;
+		__be32 a6[4];
+	} daddr;
+
+	u8 is_ipv6;
 };
 
 struct mlx5_accel_esp_xfrm {
-- 
2.25.3

