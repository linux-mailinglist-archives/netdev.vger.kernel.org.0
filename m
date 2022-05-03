Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127B1517CAE
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiECEq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiECEq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:46:56 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2076.outbound.protection.outlook.com [40.107.212.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B543E0F5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9yjN2WqKLKK8oAoHMFk0qkwjiYNdBIJCoDOPz9GvSyLOcaj0ro/xS4yvdRVqR1vu42NKNZfDpzkwSyyBWpLwYScXuSGkRQA0loJe38kFJrZtbepSr4Ckh7WAriUW11pYs3lonHCkSOOn+HHn7h5uBemCG+3xxmrmOOhCUtF0UU/B48+gCZa2Wy6ZbCtA6cHuPZO0MKhFShwbEEQkvZy0iWiDiokLjqooVk2CYG6Gmtk0ZWTh+iQJUHhgpKvreuQFdtbiP+UUzIpjhsYjObZltNxizZVqNm80RSAluXJEvkabQeroKpQZWnsn6kBi1apWGrF4utL2lbZC+F2+sNzrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgZkxfpc07h1tqFxUKyl1Qa3mzZW5TyNIGBUw7iBsbQ=;
 b=bZUZJXVPTWr9g4S8pII788O+81uiXqvUd4V/EPvCCr2DkCB8apgncNabm33g1w2gB14JYbdBtberlV4DhyEVCAvrqxY6qMj83VITeyf/2eh8i0dpOF/mNIn4E4CueIppvjWgZyNEy1x47qsGgIygqJDAjLXZ9ialdJ9qTKoSZ+/8vLSu4zHb0xjXU+Hp/Q2JJLWSq4328kNUbvgpzkKEskxqbrJv5DL5JOtB8Pq+3R9CQQaeaff+9y3/zHJqmMw/A1CZ+iccsNiEFLbpfR/sDlCcwI/+DWitOo+ePp+ysGZXqTrUJxh7apkQg9xrAELPdAflBYkqbpCQEEM3uogmdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgZkxfpc07h1tqFxUKyl1Qa3mzZW5TyNIGBUw7iBsbQ=;
 b=W+8kovskAEZR4UEK9q67u35a3QmpX2AlSa6aWMT4sSDqACwD5wVymrNvdR+KAxWQMMDse8RrjFh7OHy58wi5tM+yAdE6sv6LQFrEfW/Sq0N6Z2mGGN8XCT/XePZz3jwi5OAFVLfM+rw1PzunKusIV7fDOSAbo6dQ+UO9Jqia8aVw07BPtKtoaWCpK2GgISJWXaNqc2EnwIr3vsACgGqZsHIiXPPOgZeqNy/m9fPcjnfbO71JJePPSWI0tEKewLoPvxlgoao06ZW/FdI8iOsI1/S9jsoBZoD1bjtUTMF7EmXsWLWEDvpkBzeVUnlPG073232Lfw9gbX3RMEbR8+BhCA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:24 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:23 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Drop error CQE handling from the XSK RX handler
Date:   Mon,  2 May 2022 21:41:59 -0700
Message-Id: <20220503044209.622171-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::22) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dad8f12c-aff1-4cf3-35d9-08da2cbf74d6
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322CBD93F5F936F78FC9790B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hWBGzHJ7csNdUNaTcoPdCLgi87BF1xi5ikUUok7weKHvxNzDwmz4ir+oOqD/skio2lrQlh6RrY9GpJKHpD/294iaFcAvEs6o6LIdGQQneDASxGSbIcQF7+TPxIPkDHhpBvFKCAyRyKukAMv5LFh60X5FIuTvx4FYGSg+VUxTxAVAYq2t0T4BeWNLgUf8MTH96lLPcoK1NvYE2tP2dnYEHUIJV9IR11QNgWHyqWaVeRUSOeY2gaoZgDv2KIVgQTWH3g8AdvxCCmaUoxjRO8URo9bjmEnHQ/f3NHU7+YkkWvSgSn8dMs0r07yjl/AJODMM1upGou1CO3yvsIsNy7doSF6Ksp9QAlGahdHOCHVnVhyltaBE5uTq63Mwlyax0EDmPLdVlgun1YkIKJMNrbzYgAOoBKBKTx/zxb8+ZeZx8asIukhfZhWM+cq2lChH66iKha8G+6oHIsp66UagKnMTQyF8gxLNiackv3dTfbAv8LBhHLIIKuZlublkMoiLjIZTG1h0vjxkI8cBxjj7Bfc4AT9pqH6swmbK2GAsobVbfqzAJZyN9/v7RtFli2w/mr8BP+tMmPNbbChqe1NIQeedekbfVnx5ScOGswELTL9MDZKOdC3kX5M/fzM4xPzYbddx3lu+q2tbGNIWbx4kS+PiTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k+5/sxK9luVb+ALrziSeEnc69ItI5wr3wcZStfhn4QO7R3yrh8Ig9PSm5XcF?=
 =?us-ascii?Q?7s90utALAXANDJtFi1b6NdMUM73+a8lacmuCoORP6OzLVpx61Ub+SrBkIkfL?=
 =?us-ascii?Q?uSLcJOO0zHvH7fqG6P2pPe16K8NCwS5Cwu6EBSuve5EsP5q3oqqqAVCIoHC6?=
 =?us-ascii?Q?OYbrofYnTsiKH2Z+OHeJ6TrB25bWbhECvObNo3N7pOi5QsGmPQ2AiPODOePs?=
 =?us-ascii?Q?Cpoum4hbWi+uYT+YehA0QDG89qyvLltHG5dMZqIdcANzSfwN5J+v8FjX4z6c?=
 =?us-ascii?Q?pZ0b6a0wNlDjPSmy36EMGW3VK0leUyBkIY1u4Zf0n8JunL8lBbOrRVDCrQWi?=
 =?us-ascii?Q?WmMX76WSqzgNeUmPrRvTNl8yUwFVTso5jZCHZGF+9lNO5hG5nRcO7KXgtUS6?=
 =?us-ascii?Q?iexjfHJktXV3/I4A1QLfcg1exTTd7UaHzFjzO7emJMPYU9zgI72YIhmgpnJi?=
 =?us-ascii?Q?zF7z8i8pfpQJQGn31QZALd3M9PZRau74JAw+tjQUhjjI0Z1meQHEKozxzw32?=
 =?us-ascii?Q?1/sC3xuFPdMERd/6AiH+iRgTsriBJsBVJNGx1jMrfEeLcfoSV/imk8cBUSSe?=
 =?us-ascii?Q?9xJeovti3waHHe9B/vEGVi36jJh1Qynt3Nr1HWozIV7dAem0++oMRLGIJAFQ?=
 =?us-ascii?Q?PAO7Pwvm/vSs8sD1OJU+3SAgpFayU2/AX64gZ6aLKl5OPqGmxpUsatree4f1?=
 =?us-ascii?Q?9fMcq0q468ddLiSE76eM5sY6ReHiVDZXtVn/UCtOAuQhQqQrRg/b7A8gdXEr?=
 =?us-ascii?Q?zNStcjEGYbNPDHT3M5vyZDA6acu1/ogn9SyZDHF6zDUSjqSPR/B1eAdOXvWH?=
 =?us-ascii?Q?Dikhy1NN6SFPlZTrNJ+khwK3Gq43CFWUcCdlDQfJfqjCYjC7aU1eKikTgvNq?=
 =?us-ascii?Q?nvHlheQL21WyPx5r2OJigmrv5B/VKhD1jXleiFimAJ8Q7JRP9YLiXsYUz4wT?=
 =?us-ascii?Q?SXIz2PLe9b6tiUtk6eik8qPswNt+3+hfsLxcGQYQN05zNSPM4WvzC0TKcDDy?=
 =?us-ascii?Q?Fg0k5yfCofSEKvwRRNtzq/EgUAHy9mWD3EG/RxjAELFSpRF5iiG9Q2T2plCa?=
 =?us-ascii?Q?oBk6l77fuwaJVNiBJF4FSBj3y58PvTyLliNR2grcz7q2jekMjjok/fLiW0MU?=
 =?us-ascii?Q?F4sKgEVbutOpATsIGRUVoKIa9gNbbQqfSYs+kwS4f5TsCiSrMKumzatHo6lk?=
 =?us-ascii?Q?UtsJQ29D3ArrX2pN/E4gNK0KMIIxOBDtCwIq/IBq9IsP89a7qkdR07wG45Jb?=
 =?us-ascii?Q?pPkwt3IJbE64gIUMqI6GzK1SbXsjteTF0ZbmbiV29zzr04I7b5HIaFC/FZtc?=
 =?us-ascii?Q?OkNUi88hwOuLjeDGGSLtMOpZRPXvIBy7wSOpfdSpzIRzZ2gidJJ/LrGqeKdT?=
 =?us-ascii?Q?hE0MkDuAFSxFdSb0bNRIzlZBmdMVY9xc7pQkn/1esRclhgEHfnkkZxHoApnQ?=
 =?us-ascii?Q?k1we6VoNt3EjIkEnw/+9SWCQKmJBPpWZpRyMFGshKZ2nEXvpes3P5MZUuuMD?=
 =?us-ascii?Q?kxLcQsuv6Ce3ryjftY5jd6x2YfrF0cF4WW3uIfEjnzOtLzMhB88JmBUzQOPZ?=
 =?us-ascii?Q?W8rJoEU7E3KXJlwmscKBOVsyyTa1li3/ZTA6/nDsKFaG3KjHUO0IsCuLv/UW?=
 =?us-ascii?Q?K2zXlb0W0bncfLVSR7tCkGvK+UxikZ7tx0hJkg8kgwgrPahsSk9Nu7Rqh5s7?=
 =?us-ascii?Q?pr8MKZcELpInoh1mWJLJIbxm0JkP1nNmGybEd9m0lMuDJhjp4BJTz2XN8SrQ?=
 =?us-ascii?Q?URjAbcGjUJH3sl1vF8MIPDrVvi+YQa4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad8f12c-aff1-4cf3-35d9-08da2cbf74d6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:23.8792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6sYNvXQnS0eRWfdU2fTgBb6EzNyWpknZw+Md/eCpmfPPRynkV6MIVpVZ8r9yfk8oMRzdXAMy8n+uGzoc09KRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

This commit removes the redundant check and removes the unused cqe parameter
of skb_from_cqe handlers.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h     |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c  |  6 ------
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h  |  1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c  | 16 ++++++++--------
 4 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 50818081bdc0..b90902db7819 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -648,8 +648,8 @@ typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe_mpwrq)(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 			       u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 typedef struct sk_buff *
-(*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
-			 struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt);
+(*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
+			 u32 cqe_bcnt);
 typedef bool (*mlx5e_fp_post_rx_wqes)(struct mlx5e_rq *rq);
 typedef void (*mlx5e_fp_dealloc_wqe)(struct mlx5e_rq*, u16);
 typedef void (*mlx5e_fp_shampo_dealloc_hd)(struct mlx5e_rq*, u16, u16, bool);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 021da085e603..9a1553598a7c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -80,7 +80,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 }
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
-					      struct mlx5_cqe64 *cqe,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt)
 {
@@ -99,11 +98,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	net_prefetch(xdp->data);
 
-	if (unlikely(get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)) {
-		rq->stats->wqe_err++;
-		return NULL;
-	}
-
 	prog = rcu_dereference(rq->xdp_prog);
 	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp)))
 		return NULL; /* page/packet was consumed by XDP */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 7f88ccf67fdd..a8cfab4a393c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -15,7 +15,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    u32 head_offset,
 						    u32 page_idx);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
-					      struct mlx5_cqe64 *cqe,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a5f6fd16b665..2dea9e4649a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1521,8 +1521,8 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 }
 
 static struct sk_buff *
-mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
-			  struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
+mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
+			  u32 cqe_bcnt)
 {
 	struct mlx5e_dma_info *di = wi->di;
 	u16 rx_headroom = rq->buff.headroom;
@@ -1565,8 +1565,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 }
 
 static struct sk_buff *
-mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
-			     struct mlx5e_wqe_frag_info *wi, u32 cqe_bcnt)
+mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
+			     u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
 	struct mlx5e_wqe_frag_info *head_wi = wi;
@@ -1709,7 +1709,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
-			      rq, cqe, wi, cqe_bcnt);
+			      rq, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -1762,7 +1762,7 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
-			      rq, cqe, wi, cqe_bcnt);
+			      rq, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -2361,7 +2361,7 @@ static void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
-			      rq, cqe, wi, cqe_bcnt);
+			      rq, wi, cqe_bcnt);
 	if (!skb)
 		goto wq_free_wqe;
 
@@ -2453,7 +2453,7 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 		goto free_wqe;
 	}
 
-	skb = mlx5e_skb_from_cqe_nonlinear(rq, cqe, wi, cqe_bcnt);
+	skb = mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe_bcnt);
 	if (!skb)
 		goto free_wqe;
 
-- 
2.35.1

