Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD7060CE59
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiJYOGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbiJYOFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:05:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDF11A0FBF
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPxc1mbakvCDrO6g5oKBVSI3cK/unIy86485q8z/qS+r1G7k8vtlniBOOMipDlGTnMlYhEzkwCABziA/j76ufYfIGMZr/jTOL+Z+SZbp37H/xkW4MFiS/rhdrQ08mBM1p+sjS1pnPLAl7vzprA4/u85Oq/3J2GBzCMqD9uSlCRM0sZDKRxAcodbPA/Jgvq0G+IDmBoEp/2+GSyaYNd3YQKeMqQ1CRex/pEvJheXOtq5QqsHwJu6WFhAlcUFWKGATb/0hYfYnjT/V7f+ERAmaxhlV0XfOsSomH/euOMNe5F4boV/d3TgYUM1lBuc8eIXkPKpIo91pnmHbDCkfvSHYgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jhC/kGdD6nL58eOr7jzxOtxX8rn98H/u+r8FiUfQrbc=;
 b=mIWxZC7vuoGY59DEK+hiZ35ex4hHofvD4U/i5PKlrU48uQyGa45ESGwqowU1eIbEt1UbHVdpJMNyrtyAM5DsZYwX7K7505H5+tulrLkIOGEK9FW2V5evAimrawenW+r16/Jx2v22Vcl13VwcmP7VWt6yh95qEPvrGU/aA8Axl3hgfxPhTz0HWDiP+3KaBcrI/AAhur8t7k9lEPhy/zS2uMjqY9gUdtoo3XHlc2V0RtftWKLfg1s0BPACXvEUA8aCwOx8lVOSCgsGf4MBJw5JHx06rCcY0zB2DuIu4FOKEPV5R2HMp3ocmwmQYopB6/7ARSbjMZzIhyy+aeq0p/Fllw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhC/kGdD6nL58eOr7jzxOtxX8rn98H/u+r8FiUfQrbc=;
 b=iEGQl3bgPd2G6vYt0j7C04+9dzuH9a9SekKPWWzn+7D12tWYQukndD9uQYqXqQ+ZG18Pdz056Nz8JLPMuDOLbRZIE9jpNKOOdltWNc88h6CSY/lMOpTYHcZgzJSAnfadH1HJBJVYUrD1PXi89LmcSdoBSTei/MuhG/QCVdIpOkJ8QR2W1w2pMr7o0QJLFifZejKP8i8xr3Bw/i1aMTpkzi+RMg/4nRG+BKeDiJp70tBheV891CZ9UjXKcH4rPx18SQnn01xEO3VUXAedyTM9itx7n0ad8jiiFDEv1KTGeofLHbX/2vQrT0XKjYJ07vFWTQJ4f5a3Cu3cVMjADOktdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:01:53 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:01:53 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 18/23] net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
Date:   Tue, 25 Oct 2022 16:59:53 +0300
Message-Id: <20221025135958.6242-19-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9P194CA0009.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:46d::19) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5279:EE_
X-MS-Office365-Filtering-Correlation-Id: cfacbbf5-f6ac-42dd-58e3-08dab6917833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2GxCsJir902TKYOWg1pedKpoedUtgdW93ShP6jAVA5Z12XzfqZr7drS13DcbVqaJ/w20wutuHrMtn4It/Vp1FgOap1iJzIP9mfqKlGzb/Z6CFFp76q1ERAIYPxyk+NsQErMjTo72Vp4WWZYF/LyCUOE+14B8SBByEO0EgQFpn2GsO9lYeW7PFQkzhvZrHK5W7QQ1brUMJGYnSDfeZm76/3h9nB2GDVzxaspQwhe8Mx+6Ud3OZh0fAFC+WMqYDSsKeVvDIRVtjbWEMKmYekymDj6JZD4kzonJ8oLcZgs3tD0sytIzwrE6MPL2/uQxxFOdYIomJcoqVeExIxeH6T4CQEI/C0L2SjtAFaU+ndsxPQ7UxFz08asP2gy6CHcCCgV4pJwrgTghAgfikiJ9MflmV2oRTDJebnl4TowAl1x5DGGwcTIS9J7trHc1jOCNhP3BhJ87U3XWdIgZCKm0X7jMnS179ixlAr+Gf0uHRVd9rZ8CvRMiIAbO4opUzbW5HKyfx+vwsyjWT0UI6NLorIzw5Dye05pcMPzAmo5NFxXw/FcStzuvGYLv0rKgXx/afZwGZ92FG3QftvESMb42ThQ5XCj2d++abYNEpqVHiX0jG54OEOq98b9QQuTKGN+eESHcENHLLJLPs4JvWs8OJSGIpeXn5hWwxi5krBzbUShpJd1dyFivPpOSfLmi8jzxFB9pmbW6Ohy3pqesKMQ413gADmMWEjGgFpAHvbxxjO3WPpDb6XQzSmOCNzFbNEd5UJKy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6636002)(921005)(316002)(6486002)(6506007)(2906002)(36756003)(66556008)(4326008)(8676002)(66946007)(66476007)(6512007)(186003)(41300700001)(86362001)(26005)(38100700002)(1076003)(2616005)(83380400001)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AvU6iCfT3wJhZTjiJ+MTZQlwdCTnrLgN+HGXuMl22C0CkSXLpOqw4chQFI7B?=
 =?us-ascii?Q?BScerb++f2NaDII3UuePUcH/UcUGDIHHLvgefc3qRevcFuZ3O+q85IK6vUJD?=
 =?us-ascii?Q?Hgb3DEP8Fzwx634hEiIllglNB8UslbMMgVsN5ObuF1qPQmZG0+YPQzvR5SZf?=
 =?us-ascii?Q?hkc+X/SEtlQu4yCxjEvksiAKqRpuuzV2QGJ5UhyozeTivCipmGld6SdACS16?=
 =?us-ascii?Q?ELs5jf5ibRXE9j82ISVK3i4T+mq/r2/C01nWwCbeV8mNsm7IPeAughWlGhgj?=
 =?us-ascii?Q?+BRRbMJPmDC1BZRPpEdHXX2ADtg/nc0mp6vHzIwE/LFlfp34Lr3EKC6Ca4/n?=
 =?us-ascii?Q?/VApRWhI3OhE2kTl9V0W3kVimK/zQKoht2q7w7O+z1QAi7Of/Hoag/8EXEif?=
 =?us-ascii?Q?vGxNaAeWN34ONEF5Ltp7/PhtzU6NireYy/Un8ekUYJlvEQihWPNJ3vzeO9hl?=
 =?us-ascii?Q?N388OjDrbVJ5qx8OCKNcUpfy6AgF9UG103us91NmPn0s3kUJYxv8HmR8o4gv?=
 =?us-ascii?Q?2vCrLNHgrVo2Q+3BcCmD1hFsPwZmm4rwPnrRrK2u1yG9Do0bFrtSTGHNiiDq?=
 =?us-ascii?Q?WPZ1cks31mR9O589Bs0+HviXbayr+Un2ikrJi4j6Fbcscp2ZoL2Qiu1SUgLb?=
 =?us-ascii?Q?u7N5zWlzEZElt+F6Pr7uiEzsJDaLXmyQaOBi/KKLrtzKlU3qHHW/q30yJN1T?=
 =?us-ascii?Q?KIzQcsMOMoAq2OvPnZca4xmUky/i9yFvB1djNcauFB+a2BD41B9zO/gnTurp?=
 =?us-ascii?Q?2mnyq6FgH9k+CwtaG9WnjhEC3mQunZGHCk4oCOwfe8c+HW0ucbsobnyo14cl?=
 =?us-ascii?Q?Hpw4i772bqzhQsjSdGylg2QnrMNNzNKq9wF6NcpJHCYD0p6vKQyIb0wD9mfd?=
 =?us-ascii?Q?pg43zt/1X2qgMncstPzdELpi1p2zVl+yfH0sFewDbuzQ9VFipnKcschU5EBP?=
 =?us-ascii?Q?iS5H5mCiw0OlI+mJoxZjMAnpEii+Qj+si3F0NWKeuuggtCHb6oYWzltlqkK8?=
 =?us-ascii?Q?fGUPavhuToAXum9nLx6kxRv8S+V0eIFoXobboJvTKWwbM60PoWiQateaxUEu?=
 =?us-ascii?Q?xE1fsa+Qdt9p+6BPd6aRIIq6Rw8SYrst9ojp3XV/sWEjAQ+Ih4vR18D+SFo8?=
 =?us-ascii?Q?4d1TGKS32wmhB9ZRnFjebJ84Z8PGekiPhJzg9LV8LAyb68ekafL3QLBgiYMH?=
 =?us-ascii?Q?iKNxa79jKoFmCgalxJOxn9yoWuUZTp26ch+6IC69y+jh7s79P3iIzrWz8qB6?=
 =?us-ascii?Q?x8naDAsIJOEmEvnYCj2YCc7wpv70yLPYjtHAZEn5HfBJ5bxUNP8OssDbaqEo?=
 =?us-ascii?Q?w0+fwaFHYN+ZccDZ8lfuQ4xM/ayrPbtjnkCeugH6R+zOafi4WHebDiytJoHi?=
 =?us-ascii?Q?5IkGPIvRsBrqn71UIldmNJmfCd/ta7fu0Pqovhvc6JkoyifrvQzr/WFRoJ21?=
 =?us-ascii?Q?dlOjTZY/kcFRAGjtyxrCrM5pm/V9B/64PmhzyPniVZOeOYXYvfyQe3HU/Ubv?=
 =?us-ascii?Q?wwLh6Ouc0mD9l3Dm7snvi/cg560IjUpb+1udtOCA89VZ5jkeYsjZv1iLQ5so?=
 =?us-ascii?Q?axtV0ladgQm0SN7aQbJbruT29rT3NOsLJgf8i1JL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfacbbf5-f6ac-42dd-58e3-08dab6917833
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:01:53.2302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CJt+qiR3uwNEVjBHWtrHR3gddFvAYU/V7OV40O35meV9/Me/KIAJPOm/OcFqcdq8xb8Pr9k0v0J3H6r0kEurTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5279
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

NVMEoTCP offload uses buffer registration for ddp operation.
Every request comprises from SG list that might consist from elements
with multiple combination sizes, thus the appropriate way to perform
buffer registration is with KLM UMRs.

UMR stands for user-mode memory registration, it is a mechanism to alter
address translation properties of MKEY by posting WorkQueueElement
aka WQE on send queue.

MKEY stands for memory key, MKEY are used to describe a region in memory
that can be later used by HW.

KLM stands for {Key, Length, MemVa}, KLM_MKEY is indirect MKEY that
enables to map multiple memory spaces with different sizes in unified MKEY.
KLM UMR is a UMR that use to update a KLM_MKEY.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |   3 +
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 123 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_utils.h       |  25 ++++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +
 4 files changed, 155 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 101b7630b046..8e437d98565a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -29,6 +29,9 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
 	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP,
+#endif
 };
 
 /* General */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index b00dc46c7c3c..30c0a50f5dac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/idr.h>
 #include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_utils.h"
 #include "en_accel/fs_tcp.h"
 #include "en/txrx.h"
 
@@ -19,6 +20,120 @@ static const struct rhashtable_params rhash_queues = {
 	.max_size = MAX_NUM_NVMEOTCP_QUEUES,
 };
 
+static void
+fill_nvmeotcp_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe, u16 ccid,
+		      u32 klm_entries, u16 klm_offset)
+{
+	struct scatterlist *sgl_mkey;
+	u32 lkey, i;
+
+	lkey = queue->priv->mdev->mlx5e_res.hw_objs.mkey;
+	for (i = 0; i < klm_entries; i++) {
+		sgl_mkey = &queue->ccid_table[ccid].sgl[i + klm_offset];
+		wqe->inline_klms[i].bcount = cpu_to_be32(sg_dma_len(sgl_mkey));
+		wqe->inline_klms[i].key = cpu_to_be32(lkey);
+		wqe->inline_klms[i].va = cpu_to_be64(sgl_mkey->dma_address);
+	}
+
+	for (; i < ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT); i++) {
+		wqe->inline_klms[i].bcount = 0;
+		wqe->inline_klms[i].key = 0;
+		wqe->inline_klms[i].va = 0;
+	}
+}
+
+static void
+build_nvmeotcp_klm_umr(struct mlx5e_nvmeotcp_queue *queue, struct mlx5e_umr_wqe *wqe,
+		       u16 ccid, int klm_entries, u32 klm_offset, u32 len,
+		       enum wqe_type klm_type)
+{
+	u32 id = (klm_type == KLM_UMR) ? queue->ccid_table[ccid].klm_mkey :
+		 (mlx5e_tir_get_tirn(&queue->tir) << MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT);
+	u8 opc_mod = (klm_type == KLM_UMR) ? MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR :
+		MLX5_OPC_MOD_TRANSPORT_TIR_STATIC_PARAMS;
+	u32 ds_cnt = MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT));
+	struct mlx5_wqe_umr_ctrl_seg *ucseg = &wqe->uctrl;
+	struct mlx5_wqe_ctrl_seg *cseg = &wqe->ctrl;
+	struct mlx5_mkey_seg *mkc = &wqe->mkc;
+	u32 sqn = queue->sq.sqn;
+	u16 pc = queue->sq.pc;
+
+	cseg->opmod_idx_opcode = cpu_to_be32((pc << MLX5_WQE_CTRL_WQE_INDEX_SHIFT) |
+					     MLX5_OPCODE_UMR | (opc_mod) << 24);
+	cseg->qpn_ds = cpu_to_be32((sqn << MLX5_WQE_CTRL_QPN_SHIFT) | ds_cnt);
+	cseg->general_id = cpu_to_be32(id);
+
+	if (klm_type == KLM_UMR && !klm_offset) {
+		ucseg->mkey_mask = cpu_to_be64(MLX5_MKEY_MASK_XLT_OCT_SIZE |
+					       MLX5_MKEY_MASK_LEN | MLX5_MKEY_MASK_FREE);
+		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, MLX5_UMR_KLM_ALIGNMENT));
+		mkc->len = cpu_to_be64(queue->ccid_table[ccid].size);
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, MLX5_UMR_KLM_ALIGNMENT));
+	ucseg->xlt_offset = cpu_to_be16(klm_offset);
+	fill_nvmeotcp_klm_wqe(queue, wqe, ccid, klm_entries, klm_offset);
+}
+
+static void
+mlx5e_nvmeotcp_fill_wi(struct mlx5e_icosq *sq, u32 wqebbs, u16 pi)
+{
+	struct mlx5e_icosq_wqe_info *wi = &sq->db.wqe_info[pi];
+
+	memset(wi, 0, sizeof(*wi));
+
+	wi->num_wqebbs = wqebbs;
+	wi->wqe_type = MLX5E_ICOSQ_WQE_UMR_NVMEOTCP;
+}
+
+static u32
+post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue,
+	     enum wqe_type wqe_type,
+	     u16 ccid,
+	     u32 klm_length,
+	     u32 klm_offset)
+{
+	struct mlx5e_icosq *sq = &queue->sq;
+	u32 wqebbs, cur_klm_entries;
+	struct mlx5e_umr_wqe *wqe;
+	u16 pi, wqe_sz;
+
+	cur_klm_entries = min_t(int, queue->max_klms_per_wqe, klm_length - klm_offset);
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(ALIGN(cur_klm_entries, MLX5_UMR_KLM_ALIGNMENT));
+	wqebbs = DIV_ROUND_UP(wqe_sz, MLX5_SEND_WQE_BB);
+	pi = mlx5e_icosq_get_next_pi(sq, wqebbs);
+	wqe = MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi);
+	mlx5e_nvmeotcp_fill_wi(sq, wqebbs, pi);
+	build_nvmeotcp_klm_umr(queue, wqe, ccid, cur_klm_entries, klm_offset,
+			       klm_length, wqe_type);
+	sq->pc += wqebbs;
+	sq->doorbell_cseg = &wqe->ctrl;
+	return cur_klm_entries;
+}
+
+static void
+mlx5e_nvmeotcp_post_klm_wqe(struct mlx5e_nvmeotcp_queue *queue, enum wqe_type wqe_type,
+			    u16 ccid, u32 klm_length)
+{
+	struct mlx5e_icosq *sq = &queue->sq;
+	u32 klm_offset = 0, wqes, i;
+
+	wqes = DIV_ROUND_UP(klm_length, queue->max_klms_per_wqe);
+
+	spin_lock_bh(&queue->sq_lock);
+
+	for (i = 0; i < wqes; i++)
+		klm_offset += post_klm_wqe(queue, wqe_type, ccid, klm_length, klm_offset);
+
+	if (wqe_type == KLM_UMR) /* not asking for completion on ddp_setup UMRs */
+		__mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg, 0);
+	else
+		mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, sq->doorbell_cseg);
+
+	spin_unlock_bh(&queue->sq_lock);
+}
+
 static int
 mlx5e_nvmeotcp_offload_limits(struct net_device *netdev,
 			      struct ulp_ddp_limits *ulp_limits)
@@ -45,6 +160,14 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 			 struct sock *sk,
 			 struct ulp_ddp_io *ddp)
 {
+	struct mlx5e_nvmeotcp_queue *queue;
+
+	queue = container_of(ulp_ddp_get_ctx(sk),
+			     struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+
+	/* Placeholder - map_sg and initializing the count */
+
+	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
new file mode 100644
index 000000000000..c7b176577167
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. */
+#ifndef __MLX5E_NVMEOTCP_UTILS_H__
+#define __MLX5E_NVMEOTCP_UTILS_H__
+
+#include "en.h"
+
+#define MLX5E_NVMEOTCP_FETCH_KLM_WQE(sq, pi) \
+	((struct mlx5e_umr_wqe *)\
+	 mlx5e_fetch_wqe(&(sq)->wq, pi, sizeof(struct mlx5e_umr_wqe)))
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_NVMEOTCP_TIR_PROGRESS_PARAMS 0x4
+
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_TIR_PARAMS 0x2
+#define MLX5_CTRL_SEGMENT_OPC_MOD_UMR_UMR 0x0
+
+enum wqe_type {
+	KLM_UMR,
+	BSF_KLM_UMR,
+	SET_PSV_UMR,
+	BSF_UMR,
+	KLM_INV_UMR,
+};
+
+#endif /* __MLX5E_NVMEOTCP_UTILS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 261802579791..039eeb3b3e45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -921,6 +921,10 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
 			case MLX5E_ICOSQ_WQE_GET_PSV_TLS:
 				mlx5e_ktls_handle_get_psv_completion(wi, sq);
 				break;
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+			case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP:
+				break;
 #endif
 			default:
 				netdev_WARN_ONCE(cq->netdev,
-- 
2.31.1

