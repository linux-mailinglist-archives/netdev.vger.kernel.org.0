Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C60C1C03C1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgD3RVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:01 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbgD3RVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9Kujh8xLbECCo1mRAtwERofizTnIlPyXClET4PWZpQR904Fgdixh5dEJorDC1jc7S12YKuhqqEJVle66leYcpkAelArzwftgksxEN8oBXZDD6AB+lcKVJANqqvD79wEB8HhX+toe/uI3Ur6A3OVqKdBM2uNVUtFyEnbCBKuh0Iw415v2q7kKseUcZe4XHdTKBMhtfBMuUqafnP8AvoXs/1sW6OKyKCpVUrHQWZwvORDFEYFvvOo7TxukQcP/+SGmYkiwA7FKjVohZ1BNLGANGsBWgB70FGt5FEJiCmwWtaXWOJRqiv4J1MJrllAGz3ZdFUgZxsOfIvbFwVvjGC3Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDH5NQgNPos9Qojv5Ih5d2Mll4SSc0txlHL0w2WE6fE=;
 b=MOXudP9lccNvYyQEzoJXfHrEcIIoUWks1tb2Awu878rrfxOWYovRLwjpstwq7xOnG9/EGFxf0GG1pAgkP+uSLJZWBNAfwpE6ySGF27f52XHmS8AlUJ7Fyy5cbaA+MAb6zLM9/Pb29LMJ6EPr1dtk3jCwo5HwoWq+C1KPAV63K1rNOybE9Ve7mObGGaq/VmLi2MQRG2zbyMJ8xeAlt3wSxVYwWcT/9A4/5QJTUKnAgD6BxJa+OqEcikuA8hIEk4lcOz9ulluoEO8aRCKruRB1SXtnhrNklCpQxUCVlpllNYPgODkXe/lgRWkisCdL5Er9+hVGbSM8xrgPEkIds5MPag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDH5NQgNPos9Qojv5Ih5d2Mll4SSc0txlHL0w2WE6fE=;
 b=TgyrimQTvr9Mc3nPqz9Xj8q20NY4RpKeH9skGm7KJz+B1t/1Ku0F9tSrH2jl8fnafTrj83gjGAAymv2Qh61ER4rA+ApgHstKGDY3iVQJWT4Orh05D5J/D19KdlD0eBGEd4qYOPn5VA2PyEgAytTaiaw+g+Yc9Raul25BnarpCRc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:20:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:20:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5: IPsec, Fix coverity issue
Date:   Thu, 30 Apr 2020 10:18:21 -0700
Message-Id: <20200430171835.20812-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:20:54 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 85d40b14-42e6-4c57-7583-08d7ed2ad760
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32964E693DCCF7E02C0AE185BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:288;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3agkEYEGnib4/j5vrwbRxJZLKfmehhKuk/Xmrzd/LdXo4y3gaVNN7YqQYoNReFgV8jpBtivEHCoxmKvv56w56xw12a+SHONnXrup5qTAZJ9NUpXNlJZUd0ZyZ/FIuzRiGYUfxB0mqHzClG+a/fAm544PbQdoU7m/CaivIXadSYBoNK39F5SBcJoR2eGrWKZbNslQzfpi+D2XfjOOKZUXu2bbNg8U+zUzpCFqyjUqwPByZL0HraMhC/zPSmTB+ZxSPcW3covnBLQFVzXzlv4w19bej+DgaIIu/kP9KSNc/e7sxrorvGlmHivbPDyeS2ahifJrdfaINDf/jEeCW8EPUpfztjrZNg1k3UZiQjsav5WKlGcGfEZu3Z2H5U4JEMmiAj5hycyi6Mwwm/ujgwlU9XyIyVk2UUGtxq2b/66HKzKODmOq3/ka2HRp4V8SgLSDooFoXgpnSVYdAvdRFlGP1Vb4BwcKCW4v3g6GZUUOLAGW6mlDwszxLwxEUqpS3Xb3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6kDZ0XhZ3IBgRl6KtnZdiZorxwY7qa8vl+LLZzvdnxDuueQjaMf2u6QnpUWbXpeD1jeu3A3kD6B2ZEZu2dViCltqyo/L33Qv04OBX3VjHhc3x8K3rwtDZ/0YoIxijhRh5MKlq3jf/LH/77jjV5wmnMyeGE0VLpOMZJIgqtzmZEwZi/+f5BwhN6MIALNpFG4hXQ0i1XceRnoqdxVZPJGLob2ZrDxqvqTYzqrUB0dq/aMQqVjGsiZ6MNjjbwBfq22QE+fFuS8KwYRIfveixfrgw7RAm783luSJZAun9OEe107YJQsmiY5T44oAIHrj/sPj0mL4EX/sX3iu+maLUjSPXksAMogA1yG6EglaEfvyFJR3mFTO+9Ix9E3ohL4uy1TAMgUrkbQJrekfQTzfrYjkGR7u9tixRRvdYb52SjNK/zpfuAEcziYwlkiOvNGQIvSQXDkuwYf4S9864Rm1zPD1XOT8TPG3FBG7zuFrou4+QgbfxyWn8rsjUtIwAiF17o3gEAqER7v3dIgHh5QAcPgHBhKuGFQYXR/YrYfXcXO9/FREhFecRx3+VGmDpwM74nFiED3GHR+8/WtKFkYwQFK7YNiqc1GwfkO5zMvilB1XjI3XMdexQf8Dzhq5RY1tNLhyggAgXBtN6qRXNoqjD3FbUyEGlYhXArPYyVqzTAhgOGFii6jukGWr8Y5j1z5/HefXNVKcsuX065CzL0KiLEzMWrEjUPLPz0kxuZ6ZCVt960fFVWkFvKRkVjXg1Tej494PP689vL/V3NcMdq8HVc4i+gPE61YVYOiknQ9lyTLQliI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d40b14-42e6-4c57-7583-08d7ed2ad760
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:20:56.0233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2qur2W2fM3TjT8o+a5RFwQiU64lBdXvpoaC6hSw1R+8sm+gqIUyz3gPQbukk0CH/CMHN5AodtkdGt2jKp3b2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

The cited commit introduced the following coverity issue at functions
mlx5_fpga_is_ipsec_device() and mlx5_fpga_ipsec_release_sa_ctx():
- bit_and_with_zero:
  accel_xfrm->attrs.action & MLX5_ACCEL_ESP_ACTION_DECRYPT is always 0.

As MLX5_ACCEL_ESP_ACTION_DECRYPT is not a bitwise flag and was wrongly
used with bitwise operation, the above expression is always zero value
as MLX5_ACCEL_ESP_ACTION_DECRYPT is zero.

Fix by using "==" comparison operator instead.

Fixes: 7dfee4b1d79e ("net/mlx5: IPsec, Refactor SA handle creation and destruction")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index 0604216eb94f..b463787d6ca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -708,7 +708,7 @@ void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 		goto exists;
 	}
 
-	if (accel_xfrm->attrs.action & MLX5_ACCEL_ESP_ACTION_DECRYPT) {
+	if (accel_xfrm->attrs.action == MLX5_ACCEL_ESP_ACTION_DECRYPT) {
 		err = ida_simple_get(&fipsec->halloc, 1, 0, GFP_KERNEL);
 		if (err < 0) {
 			context = ERR_PTR(err);
@@ -759,7 +759,7 @@ void *mlx5_fpga_ipsec_create_sa_ctx(struct mlx5_core_dev *mdev,
 				       rhash_sa));
 unlock_hash:
 	mutex_unlock(&fipsec->sa_hash_lock);
-	if (accel_xfrm->attrs.action & MLX5_ACCEL_ESP_ACTION_DECRYPT)
+	if (accel_xfrm->attrs.action == MLX5_ACCEL_ESP_ACTION_DECRYPT)
 		ida_simple_remove(&fipsec->halloc, sa_ctx->sa_handle);
 exists:
 	mutex_unlock(&fpga_xfrm->lock);
-- 
2.25.4

