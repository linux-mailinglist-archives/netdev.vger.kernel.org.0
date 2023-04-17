Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE386E4786
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjDQMVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbjDQMV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:21:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888068A5B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 05:20:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjVbRo1adMGu3A1Vm54PxuRc4lbL+5apTwBHxS625ffoE/7506s4o91o6M7IzTiUSyV1ZtaRldLv3qHlyRpk0H3cEBIDJ4Oclxc4DvFJX8MAgvHlCmL98sWFD+dtJijBkSsBSVkrNyNhnKN6DirYBOZERHbUSqnVpihz+N/ixRvRAdX2CPdnwk8iGGO7fj+W3U6jSSm7Llun7LKUm2RlkmppqcO5Ja5ubnMD5LV6EOMJqQ1sl5VwrpGiGW8od7jX3MK0losHDpAvFPxeveAY0dm2YChKuEiXTzfiJUrmDm8Nh8joIsGGs+NrlReeNLc021vGEDWJpRolpk7/VgqEBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yNMVqE1TpCawff5sY7F/k+w7uuZ6nDXklzkzSWhdj4=;
 b=HiFwnM7kqV8IiKfFR/G/Xc+1weqgsjPro/QK/9fn4JZrL6sj+wNB7oFOxEmv+8Z7RFPXQryccA3X5vIhrMlmmw7Ea0pFLtnpqW7NTG7pw2CxP2XRCiUWtmX6BwAOTttDoYtPETJzps0lrZ+NkhsgMtoO+8ulCppIcvvl4rPN7B0SdZY17q2PSVz+5a3O0RzINYYNSVmyHg4M3pQN2rVa/4WEnQzPEeeW9I12LQo0SGzGM/lbqLup+FzLWS/Bj5DB/+0n0IeSMRzy92CG2QuEPs3076nvejy5MlC8jzSmLAfbR+9JdCdN62cB0oA2y0gruPGozejHGoWK2Fvyf8K6tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yNMVqE1TpCawff5sY7F/k+w7uuZ6nDXklzkzSWhdj4=;
 b=m0Iww2Rcy3fg9dgWuctEZIKdJYdijnPWRQNQWjox5+dv80Nw9Xygb0XBKayacFrRz8rR8M9sBO0CyOGiKqep+aA1B/DGSIbEVIovXn/+2nm8fLB1MlFh9m3syNETFKTfOgZpRvGXCqLlcbBq6WnzH6VNVGjToU9EPc01h/aGDq/jxKALe4aWwcqsCijcVFv7VIIm8ZRDjnLaumtnD3S8yFnBKSCYmEf33d0Ggd3NmkSLs+ofHcm+5waOAACpwW1Q3gwZtx3xv2hKwgdUTIQcfCii51gdeNY/rBtQYvsCvUypj4ovqh7rlmOySTUcVVke5YnRtS2dnYEOtgKd5KzwPQ==
Received: from DM6PR02CA0163.namprd02.prod.outlook.com (2603:10b6:5:332::30)
 by CH0PR12MB5281.namprd12.prod.outlook.com (2603:10b6:610:d4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 12:20:46 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::ba) by DM6PR02CA0163.outlook.office365.com
 (2603:10b6:5:332::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.46 via Frontend
 Transport; Mon, 17 Apr 2023 12:20:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20 via Frontend Transport; Mon, 17 Apr 2023 12:20:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 17 Apr 2023
 05:20:35 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 17 Apr
 2023 05:20:34 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Mon, 17 Apr
 2023 05:20:31 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Henning Fehrmann <henning.fehrmann@aei.mpg.de>,
        "Oliver Behnke" <oliver.behnke@aei.mpg.de>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 13/15] net/mlx5e: RX, Generalize mlx5e_fill_mxbuf()
Date:   Mon, 17 Apr 2023 15:19:01 +0300
Message-ID: <20230417121903.46218-14-tariqt@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417121903.46218-1-tariqt@nvidia.com>
References: <20230417121903.46218-1-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|CH0PR12MB5281:EE_
X-MS-Office365-Filtering-Correlation-Id: e17e08a6-41d5-4845-4b12-08db3f3e2be3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zXbfGebUv64IslF2im3in6fHKAbszWScVVt5wBO96xCuRGHfPCt/EwHhyDuNMEzF0UkS/XhcgrpJBW1DHhujMSg6EACkXT8iyi3/CuyBqHcgUqQ+5cOhYp9Caa6MQr0lzIU+ckNDSuBEvAToFZchSW0CqtR3ZhfczXLw14EVQMsTLqbT3ZwZADYuaVOhZ3qhLFd7XvcrzzD+2fxnen15HJkX03TkEdOOqb6JLyxcGwnKMoWcFFw99uRDt+TFCYccIeOa0B3rdSpPg4qvZ+zxfIJ71zhpj73wCGqXeEehJdmvrucpTxl4ymFNoiQeD706gOrHxFuZh/WNcs+fK/P+Pyh2xY6oe1jIRfP714Ca1HR9tAFdvb6FtgZ/FpIbvJeta6IW7x3TAjnM2+Ev+p4fx024tih85n2ZLl4j1AMZqo8QYlFlpsPbolYd3EpNAigurP/U7cp2sXawd+CWJriZWaDGjzB7f8f+RMnJ1P/TlbWQOnjEef+54hxuVVw80x3q82Orhe/6hpLYRA2S35GCyKkfPfIQaHxwMOTPLGCvintyR94m/X37KUOLP1eXKo4tYQJXmBf74Vvf2c9g+lZYtQJnzwRsxb+uhExnwuY89qzez+ioJlGIzbfWuTRBq3fD2OwKIglZH0Q6aDgHsi45/hrRtSzx0e5KHAokXDGBhBMz/gC9XP+aEIIkfXb0YZ4WQbgrl3AfyvIA98QTWrsqy+w96QSzwy9mQ4qvz/Ex3wk5OyoRvNN7SJB0oOhcdHn3085HFlohv7P51ZNBs6KczbEM7b0IbwalyYlje4dQkyw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(336012)(7696005)(6666004)(86362001)(478600001)(110136005)(34020700004)(36860700001)(2616005)(47076005)(426003)(36756003)(83380400001)(26005)(40480700001)(107886003)(186003)(1076003)(40460700003)(82740400003)(82310400005)(7636003)(356005)(70206006)(70586007)(316002)(2906002)(4326008)(8936002)(8676002)(5660300002)(7416002)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 12:20:45.8333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e17e08a6-41d5-4845-4b12-08db3f3e2be3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5281
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the function more generic. Let it get an additional frame_sz
parameter instead of deriving it from the RQ struct.

No functional change here, just a preparation for a downstream patch.

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1118327f6467..a2c4b3df5757 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1630,10 +1630,10 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e_rq *rq, void *va,
 }
 
 static void mlx5e_fill_mxbuf(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
-			     void *va, u16 headroom, u32 len,
+			     void *va, u16 headroom, u32 frame_sz, u32 len,
 			     struct mlx5e_xdp_buff *mxbuf)
 {
-	xdp_init_buff(&mxbuf->xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
+	xdp_init_buff(&mxbuf->xdp, frame_sz, &rq->xdp_rxq);
 	xdp_prepare_buff(&mxbuf->xdp, va, headroom, len, true);
 	mxbuf->cqe = cqe;
 	mxbuf->rq = rq;
@@ -1666,7 +1666,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 		struct mlx5e_xdp_buff mxbuf;
 
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
+		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, rq->buff.frame0_sz,
+				 cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, prog, &mxbuf))
 			return NULL; /* page/packet was consumed by XDP */
 
@@ -1714,7 +1715,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(va + rx_headroom);
 
-	mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, frag_consumed_bytes, &mxbuf);
+	mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, rq->buff.frame0_sz,
+			 frag_consumed_bytes, &mxbuf);
 	sinfo = xdp_get_shared_info_from_buff(&mxbuf.xdp);
 	truesize = 0;
 
@@ -2042,7 +2044,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		struct mlx5e_xdp_buff mxbuf;
 
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
+		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, rq->buff.frame0_sz,
+				 cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->skip_release_bitmap); /* non-atomic */
-- 
2.34.1

