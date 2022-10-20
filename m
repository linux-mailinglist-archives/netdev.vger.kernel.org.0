Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240FD605C2D
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiJTKXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJTKVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:21:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8D327FCC
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kieK0uHGMSn/GG4rox7fJGuEX3TGfPLPmYacjmOxFmQg5AKt0oIgbm8+NjQljImH4VjGN4NsW8lWQvOps9cgCb6RgwL+cly+OfFxADW7PFciFI51qclwLbbl+cT7Ep8G4fnDEMUTsA0bEeRCNModEmWhnLb7EiL1lG08pxpGB4pWpimZzS7Tw1tSCnQH4idrZKvamLhMheohO6tM7tvKUkMYL2SlRBstCT+MmaQvLN6Li3mKm+CWvq2TDmvUAJo+dgp3AC/KkJECBMSvyZWGVE9C//swi8//MLCHHx4HdmDrc5GzZ9PoCD4fB/LxSHKS428nKA/BBdqvACJYB64yAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYW++YBSIEw2bV4avQDH9R09nGOF0DxDIEPLF0qC004=;
 b=C4zdATUZhYCiyD/PgQxqAFN/42bJaqHkkF0uLujl58KoxM+SZ3OJWUNjmlBHxUiZVXwJ25AI7vu78OejVJAPidCn1RDDrTG9I1BVZNR56pRsl89GdT/vDSOEFuSy8VMWEWlnyesiL/bbMkwJ3TGnLXaC5wh+r1ZXC/0xzqDaa8RQVcNPVsVI9FsPysPtJ+7zmxbHR4zbnOtWbtvjKmnKCWmaaWgsmufRGQYlCmopua3/02mAUq/7V5pUdb1e4rTytd/g737p4PFB30P2FbCiBI7csgnMXWiYTmp4+UssdJUGKzYohUX/kzSYDVM1cc37yU1CGBu8P9POlK20sW8iyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cYW++YBSIEw2bV4avQDH9R09nGOF0DxDIEPLF0qC004=;
 b=G5E0nyqtMPltKOq22yplhNtxuzNQieWszBfAu1qNSLySB1fNxP4ezfZm9x3MoXayFt4P135eZwrftpXM1Mp6eeqpABYsSqNhuKsocBQDtbO+f/SNY3UG7JjcAXKtvEWvHOSF7QOdxSLizDvHmHEIJqI+nWObcbN31RhxDgoP+gmwv3KLeYHBOjJFF4UoPwxklnkeQmBED+eIlPKBx2H53yjcCxykPb0ZusLmqaThMeMhW1ZkB6NrEnAa9O8LRA5I11VBNaUn85NQcmjuM87FjwHn6+wc76PM7YGJMjr88TExTk3vIMCjVjDSjivA97Kv6aAmjIHKSpvoyzbliDvojQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.35; Thu, 20 Oct
 2022 10:20:49 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:48 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 21/23] net/mlx5e: NVMEoTCP, async ddp invalidation
Date:   Thu, 20 Oct 2022 13:18:36 +0300
Message-Id: <20221020101838.2712846-22-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0127.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::13) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b5ff897-88e0-4084-e4d1-08dab284c20f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZmWbnKun5Ovo0onlo+0GnKixD5VSUXuJNgSRtY5/8mXCUPpX5VnO8uY1ExCm8WBsCsQiLzcrOs/cA2lWcLAqm7RSmweRzz3PN7wMSg2Tlue8hXypdY9N3e5rc6qJYboWEPKM2AvMMFQucKsFpS+EiewcE8jbZH5P+HWqrDC5kOC0+iwHcF/uBgPUDoVxeHCnLNg74ebBLXpyctpuJUjMJRmaUZW1vzmT+v3oR3Ya5d/t+u1R6w0t5Nwj7XulKlMXMsRGudVjwmOiYh3pnw0TOEaBufoqUqRrq5UAXBiCZ7t49HLBilEhnb+TBgxds84d5eo+P3kfm6R15net01QclSxYusVNnSV39gix1/EMGV+W7irYyFTkFkiDCpIPs4f3cW2md4g49Y/AJOlPfv8AXIH+B7sNzfEDxvx1yDvVJdQasJkRdeaVPl5qov2UXmAgUa2y2YqOdmGsCvXO3BthA8UIAZhsy9nQfnrb7zqTVN/yIHp4O/izPj23esHQLfY+uBD1x/aRlckco8z5DQn2agLk2w0CUxuu6yWo7G+gPzbBp1GDso4YSr/grkEmhXbk3GOLVmf5yM/k+AOXLTODgbmJAm980Eyd1gqYhNa9ZcHqPhdKLPlWS6Fts/Es5cjiHqiuTWFj+8vp31WRw7wkZ+MvMgkCHHRdufvANt7uW74Y8UPXvjeqZcy4Fl/wsi5moXmmYpqbCccuOUwc9YGEkoUtIiFNh8t+ddR3KAPtlWxFEAvtUxuq67mnyzvh4OA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(36756003)(83380400001)(186003)(86362001)(1076003)(2616005)(38100700002)(921005)(8936002)(6636002)(7416002)(66476007)(5660300002)(316002)(4326008)(8676002)(66946007)(41300700001)(6666004)(478600001)(66556008)(6512007)(26005)(6506007)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9y54knp9Mo+iqDHZURhp7dV7Ilj1cm8USHBavKwG9j9KNlQCCKVJTbAI3PFJ?=
 =?us-ascii?Q?YptZsScBMCQt3V/SSms5rQlxkKSOcGdU/87X8MiCqi+8RKzHQr0+jF3HlEdg?=
 =?us-ascii?Q?b1LqQdJqN4tICMSGCqlW7C3YW/Ew4g44/tWrb77s+jC5qUXismdd1+RqlKDv?=
 =?us-ascii?Q?d6koyTpoHT1hE6ra8pD5wOviONZjABIe50EulqTkgOh+U75ZQtKade7NKd7H?=
 =?us-ascii?Q?3Gv+pV7K1FIld4ukthuP2Oo9DjaW2lA0ztLFujq1J7kUfKDFjVor3IejoxpM?=
 =?us-ascii?Q?/7F5eFXY9iTup6LnRa5JeXlSb3mn2mHAyBQCd5nQS3Wr8tdToGInPaYcgglx?=
 =?us-ascii?Q?N8BmC0x2cJCluKhbE7V3pMFRTMFwUy/F6PAt0Uk2ie5P94tP/cNEpHM0JAhm?=
 =?us-ascii?Q?vhRctbkTrn+SQ/2hVeH/Pp4QNUe4qP6gTJFAb14bHbGe6x8HgcFNF6w8rIBa?=
 =?us-ascii?Q?BhBK1AJ32CjfkaBNvenjvGk2Ho11hlepqqhxf2vslO57cDcNxETin/ZH4X9m?=
 =?us-ascii?Q?KQHIniwXwzoqMaZhSh7wppA6OWFZoweZJIwAqAfa9S7Q4IhkMh2sykGVtZfW?=
 =?us-ascii?Q?MpUeK7fRrq0x423JblGgwUEaGqCK4Wy9AmrlUjyddntFOrjDaZadf+O79LDV?=
 =?us-ascii?Q?ii+alyqLUVOPCGiyReblEModBRjj/KD7jlgrvzLPTOLYjO3+YQXJWKMefipi?=
 =?us-ascii?Q?BpKWo8zwwm09HiUdobm+AiC3kjT6dhHfdfx/6/IJkD3O2hECnGDEj8rndWT5?=
 =?us-ascii?Q?wxk8fihzOrq2t5nxNbd0msN0nZb0eUH7NHdWWfM+6EuQ/BmP9pX5kxhpxGN3?=
 =?us-ascii?Q?Yb2L4h6Qvusv4sHNDTUwlK0AeZNPpURN3bT/9wkEFLObiSbhs6t4lFbPTTtz?=
 =?us-ascii?Q?f6heuElg0NmF/l+wzgfkpJVNUwsBleey1HJ8yzz6dJqIw0ol6Cwyhpuq0AGB?=
 =?us-ascii?Q?VQPTeRPYP/YLnfDCuf6/fT3bSeg/8IQA6GvPs304TMZkcdJYtzNGF48o7Th7?=
 =?us-ascii?Q?7Mun18cBjNBiqer//lHLomaSkdUx1KmlV22WtJTF0x8qIboGveAAUaDU7f3I?=
 =?us-ascii?Q?DNof1B4IisuRN3aIWg4CUG5VoFLKhigXLPS7Wat2Vz0vtWUaW4qsD6LTlYry?=
 =?us-ascii?Q?KFwZUrs/0H4r7gOZxoAZfoo/IdJLBXQmbKxLQ60FIabm8bjunrPsgI7U9/xB?=
 =?us-ascii?Q?JDrwnskiy7dVUSxa7/porclnxaQu+3uigTNee+EV4nCcLwkLP7NkrWfCpmXA?=
 =?us-ascii?Q?eCyqSGVk3kFJXby253j4OQkjC1alrN9lRWM6A7VLU6fudTe+jTOJVUT5L0y3?=
 =?us-ascii?Q?qjfxOfL+zXhOs25r6yYc4E2e0eGTgFQAC80FLJELuGFTNMPdsjNYTyYYtxHL?=
 =?us-ascii?Q?sL5RuWGFJ3XtNyYJwSEte3BPIy4p0HWkovXw+Y8yhvWsKAfkp5vsTc02e7NG?=
 =?us-ascii?Q?K8+2usBXMHd837iwhq3gX9d2AtlVkIO0tj8zHq3LP8qwRu51iu4NEFzuJhzv?=
 =?us-ascii?Q?4OFKT+1Tb6KMuorZR+F1Yz4gUW/XxBNwImHiM6yzJ5fA7kjARp+Jl0upXqh3?=
 =?us-ascii?Q?5wou5bafR8uY2YPkCa2AuIA3KM2g8h0vUpYQrz82?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b5ff897-88e0-4084-e4d1-08dab284c20f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:48.9001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P9ZqFsMFfwJv0MQHxwiw0BV2MRCA59MAYKpMSM3PqlnEGKLVAK7lzboI6wU+KznZVaRGM/gGjvx4eJuimsvWvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 156ca6219356..8fb749ce545d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -140,10 +140,11 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe
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
@@ -156,6 +157,13 @@ build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe
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
@@ -257,8 +265,8 @@ build_nvmeotcp_static_params(struct mlx5e_nvmeotcp_queue *queue,
 
 static void
 mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
-		       struct mlx5e_icosq *sq, u32 wqebbs, u16 pi,
-		       enum wqe_type type)
+		       struct mlx5e_icosq *sq, u32 wqebbs,
+		       u16 pi, u16 ccid, enum wqe_type type)
 {
 	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
 
@@ -270,6 +278,10 @@ mlx5e_nvmeotcp_fill_wi(struct mlx5e_nvmeotcp_queue *nvmeotcp_queue,
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
@@ -288,7 +300,7 @@ mlx5e_nvmeotcp_rx_post_static_params_wqe(struct mlx5e_nvmeotcp_queue *queue, u32
 	wqebbs = MLX5E_TRANSPORT_SET_STATIC_PARAMS_WQEBBS;
 	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
 	wqe = MLX5E_TRANSPORT_FETCH_SET_STATIC_PARAMS_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqebbs, pi, BSF_UMR);
+	mlx5e_nvmeotcp_fill_wi(NULL, sq, wqebbs, pi, 0, BSF_UMR);
 	build_nvmeotcp_static_params(queue, wqe, resync_seq, queue->crc_rx);
 	sq->pc += wqebbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
@@ -305,7 +317,7 @@ mlx5e_nvmeotcp_rx_post_progress_params_wqe(struct mlx5e_nvmeotcp_queue *queue, u
 	wqebbs = MLX5E_NVMEOTCP_PROGRESS_PARAMS_WQEBBS;
 	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_PROGRESS_PARAMS_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, SET_PSV_UMR);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, 0, SET_PSV_UMR);
 	build_nvmeotcp_progress_params(queue, wqe, seq);
 	sq->pc += wqebbs;
 	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
@@ -328,7 +340,7 @@ post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
 	wqebbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
 	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
 	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
-	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, wqe_type);
+	mlx5e_nvmeotcp_fill_wi(queue, sq, wqebbs, pi, ccid, wqe_type);
 	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, klm_offset,
 			       klm_length, wqe_type);
 	sq->pc += wqebbs;
@@ -343,7 +355,10 @@ mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, enum wqe_type wq
 	struct mlx5e_icosq *sq = &queue->sq;
 	u32 klm_offset = 0, wqes, i;
 
-	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+	if (wqe_type == KLM_INV_UMR)
+		wqes = 1;
+	else
+		wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
 
 	spin_lock_bh(&queue->sq_lock);
 
@@ -843,12 +858,44 @@ void mlx5e_nvmeotcp_ctx_complete(struct mlx5e_icosq_wqe_info *wi)
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
index 02073624e0d6..8c812e5dcf04 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -108,6 +108,7 @@ void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv);
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

