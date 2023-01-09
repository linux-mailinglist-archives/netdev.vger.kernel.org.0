Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01FB66273D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbjAINga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbjAINfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:35:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADCB392CB
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQP3ppeKw4OmUksBLysmWSYo3WigwulhqYWCvVk9Iqem9CPgTvPycZEPfeqTrf+1VmxVoinUii7CGUt50ocrZz+hEVUE1nLcsT8svawftmVkbHYGClfh9MgS2jhpNs+tcK7OpS6rgGzEJSfvExm5wXBMOAtt9nwzAtgUlz/L23rAVx8xLKSmkvoYdzwkv7VHomZyMGBuVUnXUghIWqFbKbL3F+NQGf5PR/Wjg6nJhwpDhTGf29ChgGUCPd9dhyBHDliFTEb1XLz+6FmtYCN9rsfe23OyHJ0IpWP9m+emRDhyzJxME0ewlD1oYknYglrWFr1Bi1P5VrCAL8QpjnkZ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YxBpOA8eGPyyXPw7HrfSdP+qPZboGJvICHt7djzBOag=;
 b=Dj/NFnIe2Hc5sNW5pnhwsjoJsvGdPn4dmSeshb/c8C8yACywhmryGAPMGDKfzPvqvPBDWSRJOXec/egj2rlpfcrF4esVenKalAc9wbTnR5g+EaH6Ckal2GRookR2JkHqSsXQlL9Zcq0wjZH4UCwCTubFw6vK/DgcuM/Sy+iXqpiGAsXooUSBshU4sjFa7+bK5x8ZJLuHFvU4QONigaRO42UtBSt+Bg8essHl7xtTjSIctmjaMTLE/TJTqU1rWW8TxxxS0j0m7/AwJspCZ1LXS9FF0OBWLiDhWX2kZRe0V/UFmxXb82CjgZeKOmM6rPoU+/nubSEmsUMGUi14D64wLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YxBpOA8eGPyyXPw7HrfSdP+qPZboGJvICHt7djzBOag=;
 b=TjXxdmEbrv0mheBODCoVRwpsVEC0PIyiSpHa91yne8qzGbNkbcVa3kzl85EeA/O8rTt2XfmHPlqMGWWU2Go2ultSSeYjA7dvYZCfs3DuxU/u4iwmR1rj9eoEdl2dGb0D2XauPKNyBjfOafntSVqDXIOx2bQO7RhC+ApRqEQTwIiaEN/7UR0nW0c2GA6S9+qzEloVqhqxus0rWjhyOSwJnbwZugJJH8HxDug/Ebt/2VSWm2QbFz6KeHJKdqX53NQ70bAgCvDkZv+lYshnuqw/d852vql/q0RKS730zZzJkDt6HxQ6k1SradazbI8aApYBRfKGPVsBcucaR0XNd/6Agg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MN2PR12MB4285.namprd12.prod.outlook.com (2603:10b6:208:1d7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:33:57 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:33:57 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 23/25] net/mlx5e: NVMEoTCP, async ddp invalidation
Date:   Mon,  9 Jan 2023 15:31:14 +0200
Message-Id: <20230109133116.20801-24-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::23) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MN2PR12MB4285:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bb20557-f0c1-4a58-2657-08daf246290f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7oD5cJIHFJEfCobswnK9LoNHUjNemiYkdU5cFkmqXbr6yh7cfF/7smP+Bu3p7rnIM2/DN/jL9+5ISAA295xzbMv3WQJZazAgKWYMp+0ogs1jnIg/K78CY0A0xqUdMsQEi4mHNzCjok3oT1A7gDX7xItAF1Y1Omml+s4d0LEtcVq2uxXdlb6tar1F9CNhbCr4AUdbYvPrvvip9mZM7ZNoVwfhaV9udiPpOPoQxYoZwc2w0VSfvDiyIXZZQW8sCgJGNVJvilg6BZjd4mvVmXe8QulKNkY2Hl+dy3jC1kn5x11bpxe6o3LlHG9/FTEFKKUjtosStmUA8F7/KsoEKMaJRCu6Ffu1J1jaCkD8yEu5wDqqm3sYs9c59rrZPIf4G0Zy6nZhGYW2UWow0txJMHRDWdKq95pbJbhC7lw6hS2u5ii/W3kjK7dV1MiwD26GjMVn8gUGo4+BpICIUYn7b3eLaJwBQx636m52owJ5R1o+8+nvp6NmJCkrw3hfW/IimOzQrq3Gy8DEaQ6kZ9otbF7qCTfjM3LtYbHixitT17c9iLTzWRZfgPYAtj1q2xZ0r0lSAYfUuT5ifTGfc0ELsShrwwvXBxBswZ1wV80EWVHHodWobPJvDzHtX0pnN/4y2AAX4OUTgTZg2kXgXA/KvTcLlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(7416002)(66476007)(66556008)(4326008)(8676002)(316002)(66946007)(54906003)(186003)(26005)(6512007)(2616005)(1076003)(38100700002)(83380400001)(86362001)(36756003)(107886003)(478600001)(6486002)(6506007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EypIG+kM5TqI8yqo/kN+hmHu692wke/72+3cWp11+YvGp5zFYypRDF7zoq4A?=
 =?us-ascii?Q?R7LGCPYOCoWDCB1XOqHlTfwRK3L1mIGaN67L7CZzw4Iu70jsMy435OrW/y2S?=
 =?us-ascii?Q?QhDQkVGAlX6pYVJB+L0fnCdGd7UFqJAViMDSiaJlpqnqK8cI/MNEfSmlADSS?=
 =?us-ascii?Q?fnGxk6xuTQ1Jog36Rs2rac3oiG/hq/ekH6tiJeSYgoFlovWxvkRXmDCEnW9s?=
 =?us-ascii?Q?pc9VfG74i5YqMPq8we+9E5cpOqbVfjQSzvjZIJfYKeWoRSWGT7lx4W+PtROq?=
 =?us-ascii?Q?b7SzRWtwhpoPpQ7ivZozS9h3W1XYJj/8ZieQefOADSxG2Ue/iSeL1zXkaHHj?=
 =?us-ascii?Q?b1MiP2OKJ6bMpdOmXmsLnaj70XgfsdF94x6lwWONPgC5CDiGOh4+9Nqrvffe?=
 =?us-ascii?Q?ra9git9ASBqpjhwXuJZJwiBoegtbzhUDRE0oOqOOI9bOkQFsGeEA56nRjVmI?=
 =?us-ascii?Q?6NPFxbIaCE4MR4yRLJt5Hb6uyHJmSSpbiSZ4ov2CpziM875w+ywOe+5qnN2P?=
 =?us-ascii?Q?tjijKARKlNWPY5CW4sDGmCyEq08sbkW9eAYkA6qpsVykJ8zhKXTrOA/tIZxB?=
 =?us-ascii?Q?PgLx+jgDV3+/DbclweyU0NfUkc6Br8SAtD89gxx/yyxkN9bk2Kt+wp+BQceL?=
 =?us-ascii?Q?EychnrIuFpuQbsWXfazOt9x7Skhfyb1n4M/gVIqODnnSYwy3cJxq2deOzVHh?=
 =?us-ascii?Q?2ESkR6WaFsrMwABWtV3vgKdj2hQbPjNwjmGnhyXDz3EYsUSs20OO504K/God?=
 =?us-ascii?Q?LDDOh0fhCoh5hcPCNQeP25RwdbwLbtmZl9g6AZcNjCulEixmI6lO++0Eo7ws?=
 =?us-ascii?Q?Wg549JSGMZcogrSTTnIwQpg9ES3O+vPLVPOKfbjZ6lCeZH/b7/hXE1DDnHca?=
 =?us-ascii?Q?IMnqhmy8EawMBb/e3fJSCTmmNYibK2ZvoLGVnCBDB8uDXat2UxoeHnL3tkWj?=
 =?us-ascii?Q?CeAOrWyPdkv+VmrQeGKmTP+WSTAxAolezoIA/U5gMNYI1f58SfDc12TOQSKZ?=
 =?us-ascii?Q?92oYXQjcsWfLvSDyVQp662I71kXjB4pfs+dD3NHPURiLbiVfhECdhDVGUonP?=
 =?us-ascii?Q?ePEMWdHIds3fMdT8yBWd1KE5sE66SCEgQZEKysdV8Y4PXIKYJll1qbHeBJwH?=
 =?us-ascii?Q?zuQs7l2byR9U/ytv9h16sQxTOHmiQLVTHg9qtk9JhxSHyhrB2tOry3NuqBVC?=
 =?us-ascii?Q?PD4bTkspNQ2PJeL7Q170WQaJ8VDrlLnDVtYlyqcbPCEA36PSaFi7loZqbDxm?=
 =?us-ascii?Q?TtwpHMO27jDaP15NzN3vSIUSj9QVPLqfOgtTkTlAbhPxYm7ZnHGiQUSamkbM?=
 =?us-ascii?Q?B6sJB37slw9OrUX1hw/JU9mb8kqbmzegOiQzLh3RpgtpW85Flt+kDQk77EO8?=
 =?us-ascii?Q?Kn8EA+RUYmPm9qCH7UdnqkCi1Rsbgs1VoVf8JvKx8Oj1j4JXICy7iXtRKdtt?=
 =?us-ascii?Q?XfIR5zdv7R19a3GduDdyZWPJeBygmEyJtzEz68LOcdddkn8CG59DZivGIn2Q?=
 =?us-ascii?Q?boleENWYC7dqvmJtZvWcjRILZuACqG6JSyIE55jmGH+hCEycLsvJCqqDm66t?=
 =?us-ascii?Q?fZQRQnbKV24ndJUXp79VdBUIJguXVv6TlKVNmf2o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb20557-f0c1-4a58-2657-08daf246290f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:33:57.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4dJ1XoVrjg3BUGoTBjtVbfsQT88rCCsYuszt4AF2ejDk+NcDRis5/YVsfwoi3ezVrUDmDzRs8RqPEEbXFdHhWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4285
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

After the ULP consumed the buffers of the offloaded request, it calls the
ddp_teardown op to release the NIC mapping for them and allow the NIC to
reuse the HW contexts associated with offloading this IO. We do a
fast/async un-mapping via UMR WQE. In this case, the ULP does holds off
with completing the request towards the upper/application layers until the
HW unmapping is done.

When the corresponding CQE is received, a notification is done via the
the teardown_done ddp callback advertised by the ULP in the ddp context.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 ++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 66 ++++++++++++++++---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  6 ++
 4 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 971265280e55..c6952ff4c7ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -52,6 +52,7 @@ enum mlx5e_icosq_wqe_type {
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP,
+	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP_INVALIDATE,
 	MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP,
 #endif
 };
@@ -212,6 +213,9 @@ struct mlx5e_icosq_wqe_info {
 		struct {
 			struct mlx5e_nvmeotcp_queue *queue;
 		} nvmeotcp_q;
+		struct {
+			struct mlx5e_nvmeotcp_queue_entry *entry;
+		} nvmeotcp_qe;
 #endif
 	};
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 3f1c0e7682c3..b440ed10c373 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -142,10 +142,11 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe
 		       u16 ccid, int klm_entries, u32 klm_offset, u32 len,
 		       enum wqe_type klm_type)
 {
-	u32 id = (klm_type == KLM_UMR) ? queue->ccid_table[ccid].klm_mkey :
-		 (mlx5e_tir_get_tirn(&queue->tir) << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
-	u8 opc_mod = (klm_type == KLM_UMR) ? MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR :
-		MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS;
+	u32 id = (klm_type == BSF_KLM_UMR) ?
+		 (mlx5e_tir_get_tirn(&queue->tir) << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT) :
+		 queue->ccid_table[ccid].klm_mkey;
+	u8 opc_mod = (klm_type == BSF_KLM_UMR) ? MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS :
+		     MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR;
 	u32 ds_cnt = MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
 	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
 	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
@@ -158,6 +159,13 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe
 	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) | ds_cnt);
 	cseg->general_id = cpu_to_be32(id);
 
+	if (!klm_entries) { /* this is invalidate */
+		ucseg->mkey_mask = cpu_to_be64(MLX5_MKEY_MASK_FREE);
+		ucseg->flags = MLX5_UMR_INLINE;
+		mkc->status = MLX5_MKEY_STATUS_FREE;
+		return;
+	}
+
 	if (klm_type == KLM_UMR && !klm_offset) {
 		ucseg->mkey_mask = cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
 					       MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
@@ -259,8 +267,8 @@ build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
 
 static void
 mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
-		       struct mlx5e_icosq *sq, u32 wqebbs, u16 pi,
-		       enum wqe_type type)
+		       struct mlx5e_icosq *sq, u32 wqebbs,
+		       u16 pi, u16 ccid, enum wqe_type type)
 {
 	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
 
@@ -272,6 +280,10 @@ mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
 		wi->wqe_type = MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP;
 		wi->nvmeotcp_q.queue = nvmeotcp_queue;
 		break;
+	case KLM_INV_UMR:
+		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVMEOTCP_INVALIDATE;
+		wi->nvmeotcp_qe.entry = &nvmeotcp_queue->ccid_table[ccid];
+		break;
 	default:
 		/* cases where no further action is required upon completion, such as ddp setup */
 		wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVMEOTCP;
@@ -290,7 +302,7 @@ mlx5e_nvmeotcp_rx_post_static_params_wqe(struct mlx5e_nvmeotcp_queue *queue, u32
 	wqebbs = MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS;
 	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
 	wqe = MLX5E_TRANSPORT_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqebbs, pi, BSF_UMR);
+	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqebbs, pi, 0, BSF_UMR);
 	build_nvmeotcp_static_params(queue, wqe, resync_seq, queue->crc_rx);
 	sq->pc += wqebbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
@@ -307,7 +319,7 @@ mlx5e_nvmeotcp_rx_post_progress_params_wqe(struct mlx5e_nvmeotcp_queue *queue, u
 	wqebbs = MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS;
 	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, SET_PSV_UMR);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, 0, SET_PSV_UMR);
 	build_nvmeotcp_progress_params(queue, wqe, seq);
 	sq->pc += wqebbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
@@ -330,7 +342,7 @@ post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	wqebbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
 	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, wqe_type);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, ccid, wqe_type);
 	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, klm_offset,
 			       klm_length, wqe_type);
 	sq->pc += wqebbs;
@@ -345,7 +357,10 @@ mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, enum wqe_type wq
 	struct mlx5e_icosq *sq = &queue->sq;
 	u32 klm_offset = 0, wqes, i;
 
-	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+	if (wqe_type == KLM_INV_UMR)
+		wqes = 1;
+	else
+		wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
 
 	spin_lock_bh(&queue->sq_lock);
 
@@ -842,12 +857,43 @@ void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi)
 	complete(&queue->static_params_done);
 }
 
+void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi)
+{
+	struct mlx5e_nvmeotcp_queue_entry *q_entry = wi->nvmeotcp_qe.entry;
+	struct mlx5e_nvmeotcp_queue *queue = q_entry->queue;
+	struct mlx5_core_dev *mdev = queue->priv->mdev;
+	struct ulp_ddp_io *ddp = q_entry->ddp;
+	const struct ulp_ddp_ulp_ops *ulp_ops;
+
+	dma_unmap_sg(mdev->device, ddp->sg_table.sgl,
+		     q_entry->sgl_length, DMA_FROM_DEVICE);
+
+	q_entry->sgl_length = 0;
+
+	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
+	if (ulp_ops && ulp_ops->ddp_teardown_done)
+		ulp_ops->ddp_teardown_done(q_entry->ddp_ctx);
+}
+
 static void
 mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 			    struct sock *sk,
 			    struct ulp_ddp_io *ddp,
 			    void *ddp_ctx)
 {
+	struct mlx5e_nvmeotcp_queue_entry *q_entry;
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	q_entry  = &queue->ccid_table[ddp->command_id];
+	WARN_ONCE(q_entry->sgl_length == 0,
+		  "Invalidation of empty sgl (CID 0x%x, queue 0x%x)\n",
+		  ddp->command_id, queue->id);
+
+	q_entry->ddp_ctx = ddp_ctx;
+	q_entry->queue = queue;
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_INV_UMR, ddp->command_id, 0);
 }
 
 static void
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index 555f3ed7e2e2..a5cfd9e31be7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -109,6 +109,7 @@ void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
 struct mlx5e_nvmeotcp_queue *
 mlx5e_nvmeotcp_get_queue(struct mlx5e_nvmeotcp *nvmeotcp, int id);
 void mlx5e_nvmeotcp_put_queue(struct mlx5e_nvmeotcp_queue *queue);
+void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
 void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi);
 static inline void mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv) {}
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 74b45c94d1cb..1b3660d05350 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -891,6 +891,9 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 			break;
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
+		case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP_INVALIDATE:
+			mlx5e_nvmeotcp_ddp_inv_done(wi);
+			break;
 		case MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP:
 			mlx5e_nvmeotcp_ctx_complete(wi);
 			break;
@@ -996,6 +999,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 			case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP:
 				break;
+			case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP_INVALIDATE:
+				mlx5e_nvmeotcp_ddp_inv_done(wi);
+				break;
 			case MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP:
 				mlx5e_nvmeotcp_ctx_complete(wi);
 				break;
-- 
2.31.1

