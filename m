Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B046E205C38
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgFWTxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:13 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:47755
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387457AbgFWTxM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/7cgTcFBcBSwVBLG45eCYkXZAeKs9gaZDxSEsmGaB2XC5j2OaE9EGWDkd8E44k7yb0WyNOwO9VHbmgETIeMPgVgW0yrljEfADxSsmm17zgFPmSwx5shpD/DyWiFYlsoWvmOdglHlTJvuRdECN14ArB96xtYF6FkTE7eX4x5qV41JaLuScpIalbsF127O21fsCfM+QRpcI6hEvU2PD/xp3wxyrlZHwup6xvhyQ9Pqcka1a43P36AaBXOtPJebIrjz8FYMV9OGbF/X1jnqFOlvLx3Yx2cKHwkxrUoK+yawHqHOXHOD6/tZoA37yTCMftNaxqZCe5Fk8VHQ1fvsOSr/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=PYTRZT1dwtJ9iHJThK8Dl2annvvl5AknZBMimLgowREcf07qbXkTrfbZQ8T179gwG2MxvFA8Gipi0it0gVpu5Wwem1uLVWZlkHf2f3NcbaYY5e7O+ly3SFwrZjoLJPJ3p0eDeDxudxfHo02Ok4GSvuBH3YIuaDP1iVzqw0H0romf6Z61yp9yx9Uu+nQTxCLhpuJtdtvJce8w/UXJ5s6ACsnoryWWhWdpIzAaKtjcx+nvPWr21Orx+SWTGKlA4B8iiK/vxZG+18/ghfdNgTou9tBf/bDiwa2RStLvH7TsmT65dFVJmZMeAl2NsKTTBMFiV1S/P8uX5SP5RWdaE7qycw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=Alh/rTCxnzOyrDTciBdvYuK6uGo9Mm224wrrQ4fd0kGb17uTwxdMq2uIuDf234+xz65iAda14RkOAlBV7vus0dQyF8jjulOOAdS0feGQz+/fCGdSf2iHMAHvKuUgFJL6ZCRTNnzSl8HsjywmYBY+Q2kkpiFoKp60I5+7c2YQ3Bw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB6101.eurprd05.prod.outlook.com (2603:10a6:20b:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Tue, 23 Jun
 2020 19:53:03 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:53:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/10] net/mlx5e: Remove unused mlx5e_xsk_first_unused_channel
Date:   Tue, 23 Jun 2020 12:52:24 -0700
Message-Id: <20200623195229.26411-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623195229.26411-1-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:53:01 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 354ccae0-6a57-475e-5c42-08d817af0a31
X-MS-TrafficTypeDiagnostic: AM6PR05MB6101:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6101458720BB4FB91EF90144BE940@AM6PR05MB6101.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:162;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /LG59X74pPF4k6mgMQe2fCaj9Xo7utZWtYBjbukwVLqrlwW5iWjBLneqBb+OxzxQxwzmoDYsWrP3KL0+B2xmOCi3h5fcEcXasfE7hcbRUret9mgNen4u0Ax3hvKuhIWJfztYOc0V2KIKS611L9UR9Qzjw3+TD2cC2OQ6C7lQr2NBrsMss84vQ6jWH6HyXJ6s7I9/aegVOxACt7Pipuyu2IDD+76KEGeK2SakXAKcJ9Uoi+h/ylvazYKeB80X9q5yHi1mNMUXaVLpUR3VZthFRjKuEmraAAyUVyOlynMlggtbkBoHEiAwbGCKtOog6EKM3QNHnbXpFF6SjPldwB6Qqh90QJgdbJHuaoz8AYMQPZgzmxUd5O1HHDkLqHxu1g4U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39840400004)(346002)(316002)(107886003)(2616005)(4326008)(6506007)(956004)(186003)(54906003)(6666004)(16526019)(6486002)(66946007)(1076003)(66476007)(36756003)(66556008)(8676002)(52116002)(8936002)(86362001)(83380400001)(2906002)(6512007)(26005)(5660300002)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /yT3VkdRbo2aVt1M83kgEOqbpMvfvNHcDWKFaj7pFa8H1U8r7zFz5Z7z+6Un730xb0eDpcEbZRtRnIeLqlUEhyBG4lNMruJ0Z1Dp5kd/vyq3HNlGneZGyJsx0ufpwQmfxcj3H8nO11YHNi33z8b24HBW+i2sOsqS97LGi1CO/kQG3c110Qw5cGyxzJmd8RweT86j3YpSBzC6vWzlaBNdMrtC8+UZyNQMNR4Iv/XzRWF5Bf0BLxEcjpo+xsnLRLo+a7hiFTpdORVkqfNd2FoiGYZdo1pV0cImB4mzZvVd2By/DA/SIZaEduS0bV2ROxPjgA1F8N3OgdHeyK2qgzGInWyLblecsKytrqzz4lxMz7dJkbMcbgQIIodFkKIU2EbFPMFlbCpvOqNUpRCI6kDy1unaJwCU/JM7S5rvB3XDHCYHidaRcOSc6vkZyLylZW9cLwusQWXtCj8nsYa9AdWJU2I2LQUCwKhB/hSnNh3wNws=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354ccae0-6a57-475e-5c42-08d817af0a31
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:53:03.1897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWQMY66bd2hDXZxFIlePlmApKoCyUFXPno8vvch0Eq0dCOqSCFBAEEHL3duPcVnqpwYGzHngmJVRmrUrefI9iA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6101
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

