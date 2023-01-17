Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7EA66E27E
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjAQPl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbjAQPkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:40:45 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F90442DD2
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:38:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/yOx7D4/QI0/7+ehkMd+f/ome5pFnED1ESAzML0RykNZHozWcDHL2CrgYl5qnNHvB+lHZkfnc7N+2sulC6sg6oO7vcXB8XXM7hRqVBobHyPv6lE04fazKthAVnWfD7a4PKqlT7p+A6/9Gq8estt9DIQMVRgbLPoZKQqzOJyN727qZMc1087e0WBuE4ZyiO71i2mR0N+D7UGiI9uPNoHJf8nP5rdlRtDO+7sfD2WUXe2u47IL3wfoRbGtsq8HTbCEQtoeyqMUKKXAAEhHlhmhPGlCk/Qcady/APdbKJO5SJyP9atyZgT3oIvKR21UpyuHX9yfsTMwvWMunqtHnDDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODVIxJ2nHyBRVemM3yyjUQU3i/Tyj2PE9U+WMdeafv4=;
 b=cYBrbU+wp5gU1vaj23qNliDeJ7UirPfAtwgiJ7hemkZRs+rEi0XbrOLPSmtCdJuAaaBGfwq+9RrsT3EFN9qTjmTNpBQhQzkgsQ+IwL4+lfe9X610Wz/p9V3zt6BFd0ejZNj36zGh1FTOLh/ifXBOVtoPjBaZ2hucAvruh1oPdJ/SRidbNHH9X/LcriW/c582ZIFlbjORA+ezuPmPAVasdLNXJQ0qxKo+CpAm3r5OgrNCNMEY90i4mr+tQ/iUwcZ5w192L5I47ksxa6NaJQ00C4yPE9fYd/Z5ZxDBQglHdefMLkmTep5EmGVVem0G0AxI4+qpONZdNboQaAdcZLMMaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODVIxJ2nHyBRVemM3yyjUQU3i/Tyj2PE9U+WMdeafv4=;
 b=ZiES0O8ZiPyDZTwzE6SVH+XXNdg8TVEfIGLTx1XD+8HoUFy7Kj1j5NZT2WGvOEPa0UYzTQarBfL20pn+Jb7hfP4roxnfv7VBVsEs/sy4TVKTR4GReyeN76QJc/rlRUjwVyo/EOn/OscKXArHAD4ljhcWQzuGhzhdnQq/65+ruM/aI4gble7YQ5Bcq1QU/TS3+mF13f/6GrGzCnaaB3wptIfpmLIfOzM31d2r88tJgGazWbPW3K0yh8iyUuMLBSl7QL5r9PLlqtaoUCIEX3gkdXiJ+Qgls00G1qkU56ndTIlKsNaWbEDRM49J74+1KonTix82SyBzbXq6J1j4QBW8hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:38:24 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:38:24 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 23/25] net/mlx5e: NVMEoTCP, async ddp invalidation
Date:   Tue, 17 Jan 2023 17:35:33 +0200
Message-Id: <20230117153535.1945554-24-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0068.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::19) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: 6348176f-614b-49b3-2c12-08daf8a0de62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsOQ7BBFBlApbWjzHCvI1tHwQIe5C2u7Z5+boFrxddj1VI6RaeZNS8f/G6M0g4Nv9D438JTflKtXjX30EfHuK7sUaMM2UoHlQOxnlhnnUXueChQIrfrmK5Ai5mnJXuinHm1zT97r4BELbvP9UUCh9IoNINcWRl4QS+320W4NPpy9VFykB76Al0njba2FUpkEQWWB5W5GpNX9GJpSCjPuqcG0vyNNNxIzU533R1g6cjxfIVLMqs57qfsJgB/vG4s2tgXtubdb+jrXkAqc1D8rFXFoqY4n/98iR4R1gGm6FXNDB0gow6/1oPUPJfGp51hqEaLn/bJyN9XvI0zYOZMdkGksWOu6X2T2c5yJ+A90PaSToQfD5IGbjnvr/6gPT4v43UQA2XDMNxmgnCfSKwiK6XP99yPcZEAzR3SSav9ywGpExHMWyE2+lkMcfC8Tdw4SwNTVnrFoWzu/JAVqQ4ddzmA1LuC9I/qwCCOA0DwNUnulTndwO0KEy8wf+VRAhjweWe8+bAXHWCAYkbg1jrZwVPqch4Xc2cTAXxmQNLkO4tmNVI6NZ2vAMI0Dp+ZL99W7zf6uPZgD5RnVRQAw9AK7cloDcI5OjTvgvUhW0l27QZSBewo6tvmMXhC9hm8APjWtPdEVyR8xyF6iE1KtEMSAKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(54906003)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lTrUYu1+0TsSkUePvi4HAJ8pN9vFoh/o5i5yn4G+yRiuEg/fZJEyqPhkF1dP?=
 =?us-ascii?Q?9iIFK/RwmKGjPXQur7+iyB35N4lcy2+Kl7QjrLnc0zJ2hPsI10MZ+/cL/lI4?=
 =?us-ascii?Q?GQZjyecpvizzEzJADiIzepXSDINrJLsSTYxn1QwYu/1OD5qYhBFeZapYx+Lq?=
 =?us-ascii?Q?tb/5k0ktRfEjPQXyGYer0CBD+dJWIBMDBZiXrSrIYqGo1mJmjgbCkpGUcDzK?=
 =?us-ascii?Q?HZZqLTJGx6A6moD5VfEbxpf8YunRDvYB6SuNYghHDUQ8bBnLFOfOR5Bh9vU3?=
 =?us-ascii?Q?N0Ybsx4BNy+7jG1QRZFFPHb/scOcvmknFPedtaZGCUHNSgyqfSlxbw2+pKfU?=
 =?us-ascii?Q?URnuFb9HyDpcV3ywLJAA1QlrSOdhey3D9xRSroBOcPyEa6MUZAj6t7kicpPp?=
 =?us-ascii?Q?IN1UeSOSh33wDr5dTxr8DYSiUorl2HKjWSBJEjOx5AvAiCio5IodXslSNJL6?=
 =?us-ascii?Q?EsXzSooLWzBvpVqH6s+PQum0Pz4lIXlqZTCsAiB2iLictAl4Ck1WZz17S4cb?=
 =?us-ascii?Q?dS6ehUqxi9KT+WYJvekk//RF/xoIAzStEGGp3YBIeLWFBPTK2PGZI+7CoAXy?=
 =?us-ascii?Q?v4aYoK68InQawOCT49OaoJinROwHlOzUo4c09hA1sOxyt2x44JZJHEnNFR8m?=
 =?us-ascii?Q?rSG+1OR813P6rEldanyWMeEzDzUfNipseiqF7RZkNg+EODQ1Z7T720675nuE?=
 =?us-ascii?Q?Va46t5udrBH1BYqklJZmXAOqO8CY1mJk/nb2aqzbmRSuoaR2Nge3CffKJMmS?=
 =?us-ascii?Q?RAKOMBCG/k5ZhioKPMpja7rP71DazvuwWzlHP4vAp4y8TN8BhtWOwNdkNKIu?=
 =?us-ascii?Q?l7lXPGEvnRSBygJVv6w3MjvfjBmfrhqA6pGn4etuQS+dgjG/aIXQwq7jAOY0?=
 =?us-ascii?Q?fD9/lBHOcGnYWwsVD4App5no9FHJCfCSA0m5xIpmhCVGdW0HDJTnC7trIHkh?=
 =?us-ascii?Q?xUutmJMEtu0iOOIaWFOCvbPPPSMSsArkcIu9Yfd2kTywym/O8LWcjI5Gs9zw?=
 =?us-ascii?Q?B3nXyFqhup2DPkAemBl5s+ZVKUdt4KHSI39FAqTvb4ve3HDe4B3Ev9yW1/KV?=
 =?us-ascii?Q?I/rx6pJ6JgBc08aojHQb4Di7eNxL6IpsElyBKbYFJK148IZ44Fy9SgIT7kk1?=
 =?us-ascii?Q?6Y61YflqNzHJguoEQ9OZZ0OZuDrCphMhYhAiGd1GbpWNSkShLuQ4h63A6N7n?=
 =?us-ascii?Q?1EoXFTc9XQiZqaWJmDmAq/UG8i9Q/PtfeOGEr/qTzQIYX9Omh9qnnudjhThk?=
 =?us-ascii?Q?K0BkDyFSpj0quzK4tnZrocllKuwQ9Si4T/pk4I41z7v0IL/iarT094jo5utn?=
 =?us-ascii?Q?oWJzrZta14rGrHjDMb0TKh8d2k7zqSKgvGYESSBRlyPm05Jdml6qg1isUK09?=
 =?us-ascii?Q?l7zS6oCUOsgqNxusuK6AgRdRkiNrJmDR+UahKN/b35IWkB/OlGQ4U68aAiUb?=
 =?us-ascii?Q?mxbCXFqIkifQoOr608K/4EnReO88aHnB074wVbwLcfp90QIIU2GRml/4tRg/?=
 =?us-ascii?Q?dYbQjB05wOuJL5OUAcrIIDlJyxT+MJkFzt4WPhwZH3F7i1oOACOZWKL1N1dH?=
 =?us-ascii?Q?jA+mR2lO6DPeUFKlqh3yov6KtFdA98jd5/1sAMX2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6348176f-614b-49b3-2c12-08daf8a0de62
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:38:23.7652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LSwO45iCBoHD17pzDGdyCmT665V1c2+dMsLGXr3ki2a9uK8n2Q+xtjfv/JNimmxqecRKgPGTGtxAmIcseYpJDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8177
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
index 7c7be7cb9701..47f3b53ed78e 100644
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
index 3ae2b35155a8..9b9c3603a00b 100644
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

