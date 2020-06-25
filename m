Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D30F20A674
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405081AbgFYUOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:14:04 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6061
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404386AbgFYUOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:14:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Htz0iTMHp28/q01TFB4F0W46syQas6OVyK6Zd1qIP3/tjptXsf61ciaq07gRzFpy7rI/meQSIFlD5XCqLOwPmcbL9Mf2D6kZSmWodqTFEGzvRoCa0vMs5Rr5PT/pwVLHA5Bmor/xiP+b2NI92d5dZqfcsYcNNKKnNmyVqbLszXdBr5V8+kOdagAEKYJ1nZSgJkR5Fd8mc6jHP6rssIzvaopey4pvLrmJn4Bo7F7ya60RcIn6mBc8yMV26YUv1aCh+fY8cl9T1Ed06isCBY6P1gKdUblJdEFqB4yN291ueDVHvlhy7vYEDYt/yEfJDcxEJXDQJ54DcZtc5Xg1nQdnIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=hHlpkW+oJoxzwem0v+GY0EDZjzgtbXi1+mE2twIb/ZzWi3FdEDEd2ieke1sdmT5d3LTabLTA2vymx53xeb5XJRcr0NkPUIp6S6gQUpZYE4p+cTqwnM4o4ovplgzM1F5eW782Vj/eKXcfjpM/cADxEmvnIahGhLkcmlQgd5ni37aHmbjMh8uOLIBbtUVhiVRgyXz4EHJCzy7sBevEsMWR8Ca4LNDkueA4SBs7L7NQwEH4vTfYMJyfOumZP69I+Nw5sBe7/bGwjH+WKy0jnN7Jq8p1u1wlG5r+hk8LpmWZCr3xHATa3i0Iw0DaybJFg3IXiZ0wbbSo23EFuq69q7fvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvlrTmQHnXAEK9ooKha8cL1GrEdP0cdhD8iDygZfaQ0=;
 b=IDWqr4xOZyqQpQQaISSgVU8N1s1NgjQbe81kmd8H5ZMAQdP5EA2tzO0nnB+qZoAsuNEtQ2IlM0BDPZ1MYNxCtEa7Y2vflH/Y290Ogl/zUx0SM1gTETAvmIORVXrSqa5MLtY4ci0Xsi9Pe2KRrQ0YLtgGF1jAeDpBH2b5g2WdFog=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:13:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:13:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 4/8] net/mlx5e: Remove unused mlx5e_xsk_first_unused_channel
Date:   Thu, 25 Jun 2020 13:13:25 -0700
Message-Id: <20200625201329.45679-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:13:54 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c441248f-4fea-45bf-acb2-08d8194449ee
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB24482F0A4F7CACEBB4C81300BE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:162;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvJRk66FooqM9kQInzij5Qz7t0lidan2g35DPTDm5KgkB0WBUkpMmAm9Nmt8H9TW1w324h1w9M0LzclSYkUeYO5+tSSt1G4Ffj4MQjU32trWpi+k1ygOZpP8QfnMsZde0bubVN2911KYvd/U5/ktRZetXMA//ikbpFgUhuoUcg/1xkvJ+F24/pEogEPdJCGMth1khNKQHUvO1d76SuW5vW8dcdcEs5aHjKaMcA/T4oAZGO8RiP4Ig+FecLm2bI9wL0LGX00gqWJRcL8Gs+Rz0ykzbDS2iGxssQklpG/8ZgpBHUni/Cw2j/aHZK9QLdr2L8GOhwLMXhpDfBjsTu30g2OI0l3T5NjPkEX/L/OwxPIg8w77q1QzqDrER/s6uogT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(54906003)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: y575hMQ45PYILltqVDS7OVjw8XmdpvrNJBbZBxxp+F1HzTJ09TKC6pCpC/JT+YxWDX3AQH6+AJcoww6WkHPVcQbnO/7BPkXyMhoxhfy2UD9yElRm0zQL+k8jSVJBlK75K2qPrBX1iRhLpAtI5ipJE15GvddtrIKObq0WKHKoAd7sqSP/ojtQ10q5rHNh/VA5HRDS3l/BeFemzU67tnU84POtlRChExe4caVmg/aQa1mkF5nrcmvnirRvZiXIAamIJtwOXx/IlKtXGzSvZSqpa/kC3VnEYp/UGaDHEhydywEf3Z5wevxLGBxAVPK8SAdlIfzDDNs4m5WlpiN2dxkAgcdwO2Hagb9lczkUWtkPHrFjWtMVbsrra7OynSriCkFL5yYy5mO3AoZ+vgY31hhwlt7dtlbu8p6UTqpSf9V0a+MVyKirwPxsTfeU0fuvWtr3WkBhjMLhomyP0nEgs9K3u9FwyZQb03ujh6zO78bkmQc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c441248f-4fea-45bf-acb2-08d8194449ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:13:56.6141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QdYFnO9L14qXY7otaBOU6do1m+A67MYIx8aMVWlNneCBKR6lY6AfE5WnVvj+8OAGjbagdUJYQpeCWj4zI1vy/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

