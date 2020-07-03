Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4BF213295
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgGCEJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:24 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgGCEJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwJq+CDyLqARI4vA5cmMA6D+jxmlA2/ivAL46BRnpKqxikhpt4z4VJi/+CATfuaDZHuQp7hpPTIJ87sEFToszBGBNLbs80VvLeqk2Tg5IfaTh8nKrqk+0Zjayucew5gQ15J0aJgxvu56rfsb1EqcmrGWt8ixDHIphpkaGT63F0Yw2oYz3xDdVMAtqv1Hl1O8iQ8+S7IFvH+cWZ9IO5BxABkJherdZ+X71pzWaSHm+QuCSa8lavfNUXcwhzpQ7FNM6UdTC6KS2+AljnStGsFKXGu8tZNREct1DUF4GJHbFlwYsIt+RAMRyXjOHF5BVcPv9jt3mwj5wnLSPCXhf89Xbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxhrgmSeboazxEPOXsm6aMwrRQr3YLz9zCEfc6Lh2CM=;
 b=T4U8aetocyeo9xph9ix2/2Fjj8qo+qzqcAIoTZPoKi96V7WKvJMHYRd/uKYe1AgtbfNbUhJRnOMDBsWZT0kM1fyPVd8X47gCPBetQ8MegqOmJ2bHWxUR2VD35cIsfuToog9hdxXi+jauvdh5ifLwi7dY5Lri5jRoRmd1egwpvFXZB8WDbq7paxNutL88+/ga4x06xMqCwee4cSCg3TAFj3gb7pHi97frXsqUicfABydRaklf83U6HRdSy08I8MrXrOOOu+0d0FczvAI6RIv9G9pXpyMCSIqpK0ajHVUDNIiSFghswrQrjrz5N0h1VrBmdTapCySNAL8nXNqAotte8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MxhrgmSeboazxEPOXsm6aMwrRQr3YLz9zCEfc6Lh2CM=;
 b=iCrp+sTk+VBGJ94OBFd74E2Q8dro8L/emxbuaJFpHHrDJvLo6/8NvfbpsIg21QY9o1DBEFix9llOoPt+XsAY95arJeZQAH+Ibt20jrxDtMaor56UoNXseubycxRaGmsitsVK/Rrzt8Qqm5a1OJanZchx/iONCQKyWtOyfSCpm4I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/12] net/mlx5e: Remove redundant RQ state query
Date:   Thu,  2 Jul 2020 21:08:23 -0700
Message-Id: <20200703040832.670860-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:08 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5043e793-5aae-49a0-0eaa-08d81f06d660
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB553420C0D6A752EFECA1A836BE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFC+nLVLOyEL9Z0LJBvMFXpPkmhISw9L+Tb4/b/J4AGan74wDVNsZtRdLVLTOKuf7WRWzMQ5YVBOivbf982CDK9VmyKf3HvVNU4JZ3oKx+mP+oAHDjOB6hjV3vryM8shtWC6VbAImBaGR0ULUqwJS+a71t/9SLXv6AEwkcbEVXoYEXbKYa6wpW2aTqsl4XSRc5VpGaDcvT5+1nHEq/XDeAxFYZAdZluu6/WSqVj399XuugIhPWV9NZZzxnsEzAwAzretkkAaVIueAdS91rN7UrAWGgMXHxR5l7ORCSYUsJ37kzPSw+fZK0O/Dd8YTRyOTw/SPi5B16MvovqRwpeopOkUkVlQxAXO+67S/AvTcqAm371G0MfBoz+cKE8JIJh6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jDUK5Bi0ch56it+Oh5c52+4bKAOBsmnUngVfTiow61ni8JJN9sYhtqNZe+p4iuBk5ZyOGXSrsVWY4nm96Iz9W92hq0Ty3kbzbzHUTRwP/pHVptETA33ZI8rJzgDdLWxP2zA8zHJMlblVONHG2behVY7Hq+1Ali1oVseuvv4HpLsUFfK8kqlpFp8soBmrlG538c9k/F0O+Qq6txPD6PJ/6cCi9yf9tu0D09qDbpXO1DJzt4JuhJXurudgmZFnXbjVQHXcv5KwqbZhkOAzoKVZVbLnYqelKUB0PA+1ilZRFcwSMGokLtbPp6Bddl1IBG3DxUyoSvIulOHbLa4/r0lJLFaeNUwVwvCU5z7ChkB1vf1lerL9y9zjdkAbEcuADLAUQWz7EhqdUlTua0v0FOZyPsfnvJEoPX1SSP+FcR3e+x15wJTdcrMWXt5S7VW43nJgdRxLqgfQXLDIfqxt9LdaEzqhsEd3c7d1SeCnUEAv67k=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5043e793-5aae-49a0-0eaa-08d81f06d660
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:10.1768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yX1dojGarLG7sjWY8zELL5gRzzjzCJzSigjQx7oYzrJjw2+cPw5V6To/7LHGNI8dwT3yE/1eFJPpmn19pAquPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When received a CQE error, the driver inspect the syndrome given by the
firmware. RQ recovery is initiated only as a result of a fatal syndrome;
syndrome which set the RQ into an error state. Hence no need to query
the RQ state at the beginning of the recovery process. Add additional
debug prints before recovering.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_rx.c        | 18 +-----------------
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h  |  6 +++---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c    |  4 +++-
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 495a3e6bf82b..b8b32aef1363 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -124,25 +124,9 @@ static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 
 static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 {
-	struct mlx5_core_dev *mdev;
-	struct net_device *dev;
-	struct mlx5e_rq *rq;
-	u8 state;
+	struct mlx5e_rq *rq = ctx;
 	int err;
 
-	rq = ctx;
-	mdev = rq->mdev;
-	dev = rq->netdev;
-	err = mlx5e_query_rq_state(mdev, rq->rqn, &state);
-	if (err) {
-		netdev_err(dev, "Failed to query RQ 0x%x state. err = %d\n",
-			   rq->rqn, err);
-		goto out;
-	}
-
-	if (state != MLX5_RQC_STATE_ERR)
-		goto out;
-
 	mlx5e_deactivate_rq(rq);
 	mlx5e_free_rx_descs(rq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index e9d4a61b6bbb..be7692897fc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -268,7 +268,7 @@ static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
 	}
 }
 
-static inline void mlx5e_dump_error_cqe(struct mlx5e_cq *cq, u32 sqn,
+static inline void mlx5e_dump_error_cqe(struct mlx5e_cq *cq, u32 qn,
 					struct mlx5_err_cqe *err_cqe)
 {
 	struct mlx5_cqwq *wq = &cq->wq;
@@ -277,8 +277,8 @@ static inline void mlx5e_dump_error_cqe(struct mlx5e_cq *cq, u32 sqn,
 	ci = mlx5_cqwq_ctr2ix(wq, wq->cc - 1);
 
 	netdev_err(cq->channel->netdev,
-		   "Error cqe on cqn 0x%x, ci 0x%x, sqn 0x%x, opcode 0x%x, syndrome 0x%x, vendor syndrome 0x%x\n",
-		   cq->mcq.cqn, ci, sqn,
+		   "Error cqe on cqn 0x%x, ci 0x%x, qn 0x%x, opcode 0x%x, syndrome 0x%x, vendor syndrome 0x%x\n",
+		   cq->mcq.cqn, ci, qn,
 		   get_cqe_opcode((struct mlx5_cqe64 *)err_cqe),
 		   err_cqe->syndrome, err_cqe->vendor_err_synd);
 	mlx5_dump_err_cqe(cq->mdev, err_cqe);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 8b42f729a4f7..350f9c54e508 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1187,8 +1187,10 @@ static void trigger_report(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	struct mlx5_err_cqe *err_cqe = (struct mlx5_err_cqe *)cqe;
 
 	if (cqe_syndrome_needs_recover(err_cqe->syndrome) &&
-	    !test_and_set_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state))
+	    !test_and_set_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state)) {
+		mlx5e_dump_error_cqe(&rq->cq, rq->rqn, err_cqe);
 		queue_work(rq->channel->priv->wq, &rq->recover_work);
+	}
 }
 
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
-- 
2.26.2

