Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D97206B60
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388824AbgFXErj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:47:39 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388036AbgFXErg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:47:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k7KmOmy78Vylf26QFaA7gH2S5fyyX2LWuTe54ZzHFBp1Kfd5K7WWBQyLZW285HDhXcNDcfW4lU+ZIRHV2r3LEFa4C9vmknwjYByCJBWhx/h3GeLO10xBT04XLHbZWXgs+fXC5novAdA4XPaDrnc7VKEY3Ovv5LIRVApNx94CJ+SOoOT1zafnwiCde3e/00QnnwFxKVobxkq8yNfKZwAow26tFZlVWzpP+EeH0wCTAt1NZMfvfAEnoTG+Zz14ma4sZSuXgS0sDMSMWCkTfJ95+8MJ0I8PLvFREKHNtqIS69teQeQehIjOvbfPvwzx1tz8+fAcRD+jWYCKRwds5lgWHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=Udfe4QH6uH366uKmUb8ao7jI+xYahom7tUdb2q7n8dHlcBaWAvn0z9br1Pg02gXtGXrw6lcnwKE+E29KzRHgTlglo41CCUYpmqR8rA38RN0ZRN0Jqth/uCrTJFm1OpdJqMuYOXV3XFXjpykF16xdDrLdvOvMls2nRp6RzHuenQt8v8P0XnBBzBiU43BfV96XZIVH5ceT+ySUJQ56STjij0SoUvcorr2dJFl8UHRHljEJjKbPtx29kq9xj8Y3x5fhMyX0F62W5XupuPdtxUueU2YAt/g7nyXb1QkD5RG0/kFDIoseWJD9ZclVkId0BWXPACl8AH89ngu9moRl0hccpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=T+Ne7o5ObGNsQLonYaD2HOhDGcJ4K8654QA/5mP90aZ3mcHiIIq+vTiL2QxLNntGlHlYGwjvhYRgApbIHuxWnZVpC2isbf/gGsARL+JFF6yflngBOboyPfy4Rz/S4PxKRJNo2ZSKa7HAPqXu7wbp0FOjZia3LNye7SSQhxSNcHA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 4/9] net/mlx5e: Remove unused mlx5e_xsk_first_unused_channel
Date:   Tue, 23 Jun 2020 21:46:10 -0700
Message-Id: <20200624044615.64553-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:24 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a1e9dceb-47ff-4553-0392-08d817f9b0cc
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51355B69A36DED2EF231C4D4BE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:162;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t4IU/b3gE6dMUiBG3jw32oumOkcOsEJyB/NRQubVoDsUr6jPa5FUdAWNPPEaRi4P3FjIab+l6kLE2L5ruo2w0RAIHqguGL2OeYAaXs6bBEEudAsgpqpJ3GxtfEkA/cH9fd89cAipl68yvYJ+raLp0WsUBNCsegOuhKVInRJD21cqCskGguROq/vsi0ZSZQVfswDNcGCU/YON7MXbBJOAIfFc0QDEnTuyUTdJvzho8B5FW1mJXe3WX7oEfEpYbFFkSI16hl8ua3Sw5F6mBSgMEViQUu1WRs73ts76rvd0eOU9EE2IZZAbKR8+HhkjEjVfGDaPJ/5t1cXqFNyG+179G8/YH6DD7pHDc0RRwbSCHAW2viN5eXI0xzPTvd4FR2qr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(54906003)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: AmgIAjCFn0Z3uwGX65WL1ASDIgQrx3lvlXlYZe9+4XUW3+ADLazFnrx2HwWLipZ/z8nSyGTkrbN2wFzZVGcIiEABvCWifLmMEtTCYLaW4zxu3uPvWsum/z7D+Sm0jV641RAjubbCj5FvabvUHFjj3ZHqkeskk1Y5rfzrutEDjYxLReu4C+jXdW5rMd8/ihUlg0kWG3/eEkf+5hS0qIdgmA6N267IO6l7Mxm/9jDtqYrL1TINz8QMQqPUp9xkN+b2u7SDijhi6mC0BQsNsvenjb0NKaxRrWC6pTsXlceYtYcGVX6LvkKzEdpfM37yHbPV8h7o0NugQ+cvuctjLUZZEX+XSvnHyPFTxvoaEym+NNGwb1+qrgj4Og94SXcLGqWrkv69hN6A7RwH1pI1XmpCQvX4XEV83VEy1+58V2ZwxOEyW+a09PJqpGu+rm7ohIsT1TuLyBNnIKVjj3jZ0Z1TCwEgulUzaUwPPv6gLR8ueu//QV3lwWXpGkl9K3ePC1z8
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e9dceb-47ff-4553-0392-08d817f9b0cc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:25.6449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXHDzvkxd5RwQeU+Bh4I8jnw1voYAtS3CZvLdC30ZFlNondsxbU7kyxjzgWr0RXA8p+uIhVRxdJy0x1bpTqZZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_xsk_first_unused_channel is a leftover from old versions of the
first XSK commit, and it was never used. Remove it.

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c   | 13 -------------
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h   |  2 --
 2 files changed, 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
index 7b17fcd0a56d7..331ca2b0f8a4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
@@ -215,16 +215,3 @@ int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
 	return umem ? mlx5e_xsk_enable_umem(priv, umem, ix) :
 		      mlx5e_xsk_disable_umem(priv, ix);
 }
-
-u16 mlx5e_xsk_first_unused_channel(struct mlx5e_params *params, struct mlx5e_xsk *xsk)
-{
-	u16 res = xsk->refcnt ? params->num_channels : 0;
-
-	while (res) {
-		if (mlx5e_xsk_get_umem(params, xsk, res - 1))
-			break;
-		--res;
-	}
-
-	return res;
-}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
index 25b4cbe58b540..bada949735867 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
@@ -26,6 +26,4 @@ int mlx5e_xsk_setup_umem(struct net_device *dev, struct xdp_umem *umem, u16 qid)
 
 int mlx5e_xsk_resize_reuseq(struct xdp_umem *umem, u32 nentries);
 
-u16 mlx5e_xsk_first_unused_channel(struct mlx5e_params *params, struct mlx5e_xsk *xsk);
-
 #endif /* __MLX5_EN_XSK_UMEM_H__ */
-- 
2.26.2

