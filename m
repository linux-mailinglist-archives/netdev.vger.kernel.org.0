Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1909A60CE5C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiJYOGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbiJYOFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:05:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3930D1AFABB
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:02:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHhic0B4qHjsix8Rye0GEFPPipB/XIe7AAF7ja9uUF7QPGv7sgbwjALarf/u33Xh9iPyPVB40pyCn7MiwbYHDdoBUa/i5igzaAOpNZgkcC930wGjN0LeKMteucCA32myC46BcLwrizC3f6KtwRjv8vABAUHRG7OmfEfkfPkMCFgm7H1/D9vFV5ITJ09J7w4J2GWrn55MCy3kQVcasfbdI6wci19AZAZvv6bVX9EP9//EoC+nax7LmuiiFTekcojGLQyyqHG9Dohp0QLbhKTuXaso7M9DbooO1acLaWqk0nnF5BdvG+PKji6jgr1VM3Jp7OTJziD0wLpotzeR860bdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahHEq2ORP8EwpISTXVaShJ8JnrK7bR1z2nNMdqIRmKs=;
 b=haGuf2b982zoayb4dOoX/lwf3u0e1h+J26b9EbB0fKbYATvyB0yRdmWmKrcAQmRV0wgpgd2L3re+XKPoft8pFao199c1d6c6O+imHJYxE0t4q2hGq+/DU3zLFn2ukyhT0Rut88Wtut7Teq8olAU02sBfRQakO7qt1bNZRas2RdD8WR8bm2+RTQOeLy1cPNT9hjVDnUFbJuPlsP/WVJvh55gOpqsOBzR2OOMtyaUNLo2nq9EDDqZPwhdFzpTrftUbRfvzhFbZicJGvdzS2J/A4zxGkLbm/552BCMOPJktDYoUSsA/SbR8mJejcsWfc7A6VcHXHQykkNXDYjc2NDKT6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahHEq2ORP8EwpISTXVaShJ8JnrK7bR1z2nNMdqIRmKs=;
 b=nPSr26/agUahmmaATXvHFJZZOAFD8NV78OUEpr8D9y4AN1NYNtP7T/NsJDwi1BqnLAFX0uvN1o/QULIuQAnQfhnsWmaPkmln7J/2Fh9lQN+8kXm++BuyR+yAc/6Iiv5ETrZ5iV1siUwn7JbNrDomK0rFw8LH6K3vEnu/qPgNWu8ANl45OV0a9qjI1wV0bEbpTdVjHAsDkfMWOTy6bEwYwWdsfL/W81h2QLzfHrIHvOw+/5jHjF3MP3KAVrhVQs3WToYX5mkPfu0Oh7AF5GsHqL0UCuS8+BMhlPpv4R/PgCrQNEPX7GUTMokk0CzXbk4NtnlfrL4m1xBh+fFeVU3/1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4588.namprd12.prod.outlook.com (2603:10b6:303:2e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:02:11 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:02:11 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 21/23] net/mlx5e: NVMEoTCP, async ddp invalidation
Date:   Tue, 25 Oct 2022 16:59:56 +0300
Message-Id: <20221025135958.6242-22-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR01CA0041.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: 169c8230-e503-4aff-c145-08dab6918328
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w61jemnG/qk+4Y0G7y794nl53w5nfbU1AyGXJw2eqFb5/113VmJzRhEV6uTMSSCuORTN7PDY+reQnf7h7B1RlGAAILt9/M74/SvqnhIkAEE+8/GvvNYI7hwuPmIzZMCXjABOTdodE/8+l1Q2H9NxkROfSI11S75EVXlbGCmexT6+yGDUzM2gIi3DTnUKCgl9B7PShTW4oK1p+tCjf1T9XmF7tOEp+H11rvHYailr7syLK9ExyLTXqjA+fIGoSEbLTLur3MmcYXylDrt8LjYVAnLK2XT7vzjuZM8H1hC+cLinhWsE/Gv85kWze6zWXtAe+VnzH5ASFkc/ksd89i4q3R+eP34e981/KV3RuDDQwi1q21u667KxqrnDxvYylzahWU/E4yigGUBoFcf8W61BCYuTJ6+ryjSiwpQuZytpdHz3zfPGRHydtabvkMakFPOKKZZZqkugBxIbHfSwhZpUlQ26dwOtL3rG6mCTi9+hWeNS/Jtf4N/VkV2cSaEOLExiHUIx+WZ+g5xSNZTUZk7jbEKLB5yrbTqc+zlVzOlOFg2EHg/dCyMRWjRx3tFmReyqMhkKIHHye3jt0rTfcIQUHqiL8X3Wot4aRMwHezBDJBudOitqIdiuQyIX6xKAceUNGY9LCWmTNSBFU29TjJogwmIr2zG3vPsts16rijzfv+8oNv2MQK9Om9p4Rz5sZ3oClluej46CiAx2cjomfrADZqhqkASFfsj3BX0Q9hy1Rzyx0dG6YQ5/WQ/DtasjIVlu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(8936002)(83380400001)(38100700002)(6486002)(86362001)(4326008)(41300700001)(6506007)(6512007)(66556008)(5660300002)(6636002)(316002)(478600001)(8676002)(26005)(66946007)(1076003)(921005)(186003)(66476007)(7416002)(2616005)(6666004)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1U9leEIvrJfVZ3bqrUT2Np8AghJEv9fTAC0vm/9eSTfO1lQApm5W2uXCwYGR?=
 =?us-ascii?Q?Ldhe9dB/xqo5bQ/8ANrIY7ZWIp+5xYmSWCQu1LotvVkVm74sGfgGPGoG5nka?=
 =?us-ascii?Q?nI6ZsnnauS/QnmcN8BLwWxmYkq9pzgWWnf+cYUsiI4vs+G0HydJccM/y09e6?=
 =?us-ascii?Q?jhibmps5B9L+ABy9+XNicNv22Z8JfN/1OpgIIEeJfLI7Gpbb+sH5EyNQ1GaI?=
 =?us-ascii?Q?LSZF2t56uW/4Y8NsQGa4R206WXH3K2hh5Z+Zbq/6xHpuGgFMUyAP0azPonIO?=
 =?us-ascii?Q?kEFa/GiuT3miigbP6hRh8V7KW2D9QRaHORPPqQLnBCz/ArUHEvTEiyYkxp7A?=
 =?us-ascii?Q?WtJ5CCjL93VQEYFywsJX/Vf5f3nZnVXsF3nnfb9vmhLFFwlB5dSz0KrkBqOY?=
 =?us-ascii?Q?ajHK3fSjEgtsuXGtCkdEb9zp3gT+QZbh8i0088cA/seIdmkpAssPounzJrDX?=
 =?us-ascii?Q?9e6lUmcAlTibwndW0DxixGXM1koXCa7uN0bCa54pFKoxNHBUpT9lyx1y+5vJ?=
 =?us-ascii?Q?0XAV+4SoTK/FFz9ngRyX/oxY5e1l/JLxAqJ5zivfPYgb3xC+sZ4gQ75Zd/6i?=
 =?us-ascii?Q?yFe883/hF8Pmq0I/yrlXi9reNZy/MJ/hF35/+2L7KDHdWJ6Vn7b0MppCW3Y8?=
 =?us-ascii?Q?+mkyiYioQM+ZQ5gCLExTnxSbdiyxbnd/QcYNND/T/NWQ3EB7E/7a8jWfE8Ji?=
 =?us-ascii?Q?L1VfSG1AX80xD0wSZ5Uz5CB9fjqS+mtm2BvQEr46yggAC/js83SbLfOvife5?=
 =?us-ascii?Q?ReJcMj/tq6BemVK19Qzlc/MX3UbM/RinthETmUPhtYiIdLN4PoGokcmuB6/L?=
 =?us-ascii?Q?SfH/ajzFMk44H47tOZR5EzzbYZS0vFsnth5NmzasSbrYxZfxlX1qG8tYu7OS?=
 =?us-ascii?Q?suOq3xtGnkFa8MYanu6lo4h+sKSSTaesD110Af8CWgPmKyHuzlReK+9e7QQT?=
 =?us-ascii?Q?c6PaSAXn/SpfFIy+Zy3d7fqC3iqgb+ogmZjC1Q7/9IS+BS5EJAWPKZ0GM3mF?=
 =?us-ascii?Q?7ythUrsQoEqMoqobpM3CxKXlDRjlgSuCtLnINjB5ZRTsiN5NrInD4wJyH1Ed?=
 =?us-ascii?Q?0yR6MMiNJ60AXsjA7exHnFPc/8LQ8Ku8TdB3BZ2jZXXjvdn5KCR+abl6+vst?=
 =?us-ascii?Q?9xehAYXLoq08jIdUrRiOOAt2u3elHaLwbI3bMe0tSnZNvQfhdso4Iw7/2R+i?=
 =?us-ascii?Q?Li3qi7etaukZrjPc19mxBV6YOAoEjnYV8URKUoEtNWxdKG0KQWa93EaBI9oP?=
 =?us-ascii?Q?vcNqqnzQal/GFthpBwUf0d2gGncq8ny2/nKtVBZeWw5Q6/Qwbyu5F6Zk3GFp?=
 =?us-ascii?Q?9P+BTaC8eZlVLizRUQPmkkY8gy3towBi+XdGxz86106MvY+ZwVg2PsRPNNJx?=
 =?us-ascii?Q?yU6iVf7CfKycJsghzCufznhuTpMRydXVAvv7JPT4DKpfVQGBIw6mrTqMAIyd?=
 =?us-ascii?Q?qfKaOQVvaktrklvVeDQqtUyC9DAxg3T3n0EA+eZoncve4MMmAbheM6NYY4Aa?=
 =?us-ascii?Q?MR0WPvY2K3T+eaGHNwiX5LuNQEPmqYPlsK/pj1qvyPJ89L8jR+Rvfarj+icm?=
 =?us-ascii?Q?7lVs1RdZdQLIGiCELeffi6Ei7IidfgVZ2l9Yrg7K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169c8230-e503-4aff-c145-08dab6918328
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:02:11.5064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XM/FOrxeae5zzVIWu3yzbV/kHYaB8y49yoDgcqAQPyY+toW6f61DEaE4PJaX4g+7axyyj0MQ3q7SLxTIURUACg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4588
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 67 ++++++++++++++++---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  6 ++
 4 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index caab4cbf49f4..df2b407138b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -31,6 +31,7 @@ enum mlx5e_icosq_wqe_type {
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
 	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP,
+	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP_INVALIDATE,
 	MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP,
 #endif
 };
@@ -185,6 +186,9 @@ struct mlx5e_icosq_wqe_info {
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
index 79d0c7e9dc64..ba3913ebeabe 100644
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
 	u32 ds_cnt = MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT));
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
 
@@ -845,12 +860,44 @@ void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi)
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
 static int
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
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index e2d13b3006e0..a4d83640f9d9 100644
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
index f307dc793570..5a4fc792d486 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -828,6 +828,9 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 			break;
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
+		case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP_INVALIDATE:
+			mlx5e_nvmeotcp_ddp_inv_done(wi);
+			break;
 		case MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP:
 			mlx5e_nvmeotcp_ctx_complete(wi);
 			break;
@@ -933,6 +936,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
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

