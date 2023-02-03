Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAE86899BB
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjBCNaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjBCNaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:30:05 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F9AA0022
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:29:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkKQGK+m34strvNazznljEbWmxjqIhglYcgYhWTaexr8JuXMa2t6fOI4MtmXMTpgTJ3i2+rV0t5fjDg8fPbCwTU3UMSvaeC6UfJJNUPvhH/hsaMiTtG5SypjAAlVNBA5BMNSSZBFeiGqY69jgNeMYeft5H7h+oVwXJ7eikpAwKvQb2bAyTbt29A+1kJzcK6ikcNhb5qQICEwokwHkgRAwLUW0UBT4U3pKxbVdhZwnabLK8ciIRcJ+loZsxKtJvc2cp5DOtaHFk32EUVqQHDMnTZ+VxTlL8rlcZNvXhNZdf+hMFjq0whgZkBq/J2Ys/kvaMD/lhrSmO0SrYNpXwUjdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZShbLT1nkELVnUDy0KBZCG97NNC9dw3T07up4Iph3QM=;
 b=TDVaTHJ1gvl8hGpeBvzipvRfxk/3tc1ih87suaypCwy5lrBsK79h6ng1n1VgOPIMS/On8U0a1LwTNR4tuGBPDWmANUqCttJiE1QA48sRBQdF/oesrBMmrSX0aTM0Zj5wY85U0o4yolTzJHISdQgq0WBwglwLPZyt9G7vJOtcB1rtnbsrmcUB1j9ELqHXcyyw4QLV/bmSd0hfzejPOUa4AI0WXUaGCv5EMx9hSwO6J1kym/k6E8DiuSuXly9cMMdcNNBf0pXXfrxi28Pmi59Xc9YB5/RAVpY6X3+mSUAURTOY0z0qNbwewM0GUEbDuVOfPioVH4rzxbkcI3LsJEZQpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZShbLT1nkELVnUDy0KBZCG97NNC9dw3T07up4Iph3QM=;
 b=NfeDN3G1ORF8bRt9Lmt44A/8TpN2P4VZzqb3iC6bMLz+iw4UOKQ2beaEXHI7lC1PgujXvJjVpxUutuoTcW4GdO9nIIgi/hgNv2Yg3jjpSxBw0y5Hy2aGUjQct3R6tWfgaBVjkvYrxw18eGaRgBnrzxRMVBs+ZK4oSnQkEtRFcYBYEIXQqfDeuWRCriMoL8qxdOirOrIj1mzp2hCYCBR3mV+Iqi1enuYDALUiuwe30mpFwyVmMFa9ra6flDfmlpnlbtECMFnkrEf6UXvXw7L8tDGRrfM1Jfx5rDRNhGSzmt2ynKmoINEpJOToO1bisn+wUxra3TOgVxA24SDno8DHRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:29:33 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:29:33 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 20/25] net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
Date:   Fri,  3 Feb 2023 15:27:00 +0200
Message-Id: <20230203132705.627232-21-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::21) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 27b4e2ec-8d47-415a-4d30-08db05eaaf9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9PPlfV/7e+yQwmO8admxLHtjqTKUyONDS7q+9ED5SRqGGr77EBggOHWlLzDXQC52W275sVnfYvbHRicFzOYb4hD/S1kmfWTaJUVziKrPzyPqrkS6m3XBu5Oht0IOHk/YdfvYW+6oK/0Pq22S1NIS9E3Ro+NWgB3hykAme9b1lsk37krI4zt6Xv4Y/0KyoFMM6ZegwAwido85VQaPSgKYrjXBxB28wgJ3Vu/xXG/2B2Ml/8ZCwRfSximyUYGPjr2LP041Bd5Wx/WAHmowyR/XQSeKvExKPwKbRQ0nXlBdJpt8ArkJIpWZNhhBHFl9x0t7pOdc2dyETaBLyyiGfNKt7Xc9A5Tt0Y9epr4Ul3iguo0XHiTJuG6Iiv7lyYl0LcMgKB2k92OV6Pmb/HdtHYMOWRY+z0UtGolGFMzk7MjPg1gX4dmfnapSQqLBYa7/3cMye3dzxAfIgMegosdq8tfrVCReOXiPRRgec50VvI/dlabNXvsXGMHoILLZfG+c2bfeZWQKya2yzWoT8DiKdK89CUlDGHmAYbXLeUxu7VeE492atVDnJJ5jgdjX63i6tdXBESR9nwjL449HhqUn4q5WSgX3VRULopIKPc+uNqbPnwXJUK9daBQ3ywWAxXGAzCq4CP7Do0eI5Qtbj4MtL1Pvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9gWmKpLleLTfz2m+ixeR8yD8oQJ7OzubTCI5cUG5ghCfub1kIQRkgBJe45R?=
 =?us-ascii?Q?MjX9gKf45D69GcdF970N42C2Yh6bdo+nAkWciLQAroOb8jKWTYvI9wGpd9v6?=
 =?us-ascii?Q?a3E1QZNhsF1ikA1HrpVWOChSfqwAuxXaeyv//1zV+KRWLDfw+8fZ7RKL8jgD?=
 =?us-ascii?Q?L0PglC+X4bvTlCfWywDnLpieRFIDjd4s7w8+8JjbsLG5AT7N9MW/FpN83+oB?=
 =?us-ascii?Q?3go+tOIV1rycNBIcraM4OrY6nM3M+kZA43SNftHO12ZwUnWe/h1m8XfXkbLD?=
 =?us-ascii?Q?nkReiMoDLHGj0BC1lXtAgmmQIDtv27eHw5vKrzAxklSoSRKf3HhclzIzn0jZ?=
 =?us-ascii?Q?2tWxi/I94UzbAhcUwzmkTtYVcuCYOmleUw7mR8LpS8lu8CU0REOtq3MQA3AQ?=
 =?us-ascii?Q?sEtJT4Hf5iUoMN8JTAsOZoZxBQwzYSGVTXmWtEM42B0GJvlC8edl7qND+SZ7?=
 =?us-ascii?Q?uscu9/AAmizjWRYbfluOomFiF9wxatETsOsNnVr1w12+M4pHxrGN592BgTKV?=
 =?us-ascii?Q?WQyYnWOcb7PiO9hW1iREF4TcFLE6ksqRkHwXhkQjhJM8FNJYV+qlLTn/VVdd?=
 =?us-ascii?Q?og2FIzZbEB1DJQ2FbsvKRDZHXfqbNVej93+AXOhP8krygPzhS7FzInAbvuUc?=
 =?us-ascii?Q?Zi/huJ58A8L8YFZrPtwUo4qh/8FxjZvn/PzUb5an6zaZApPHBLhMSAv83FYs?=
 =?us-ascii?Q?H/IEw7mHXBASjMKeIBX6U7/B7db4fSn1Kj3ABO/UtUsaSxvE+VXcblvQ2WkB?=
 =?us-ascii?Q?WM6kXexyQEhkpUnGs0FCfe8H0YJ6QvI4xOOtU5rkx+KFzxtp+ETnBfPqGjc7?=
 =?us-ascii?Q?stfTPLY5Tqux9tLskzdcrdbPXgBilt2eZbwBis4+3ZT0AkzIIzlPAB0ovcYA?=
 =?us-ascii?Q?ekh/bS86u0G/Jr+1ZYusGDlZp+mLvgYFYZKLoQp+VYyuc9sm3liRrdq43tt/?=
 =?us-ascii?Q?KfqI4g9s+LZQBpJkcj3qrraGj35lXjmmL229DgYo9wC/AbpniB+h87pcYbID?=
 =?us-ascii?Q?E2S2WBfo8DiunW5Ogx0zWPWeH643vYa8DLL8d72/Wnam9J646g8QGtJ3Zrrc?=
 =?us-ascii?Q?lCu06ANQgiI7GmM6hVtlMh5RAU0XHmVOoknW8F3BNAK/jl9PV7wAC61feeT4?=
 =?us-ascii?Q?NOkwrXy3IIHsbOJOatgucfQ1RxYJar5knr++T++oDg94GsGI8Zu8QqV9+Jro?=
 =?us-ascii?Q?PgsIdkLRW0rAstBPRcgPkRyzEST9Eax4s9gp2/Vpw74bKZvm8EirZywlbAVp?=
 =?us-ascii?Q?3bmes2bUcOnInByyzlc4IaGIy2sbFu2R9S7m91TG5y5RddsBgY+/5YtozSuA?=
 =?us-ascii?Q?aPAqUUJMtXSb4edWfGSjqLQx3z39qzMdRtOr4XgiVPCQs53cbl9qB8tvEud8?=
 =?us-ascii?Q?/MR8BfW6rsp3E4RiZ180H0DAcBveeUCzcoJw2swoWIr+FLs8AuxN0x5A4I53?=
 =?us-ascii?Q?b4u21xi6jD4FV38g0OBqnvgdK8FO14SniAVNr1+U06hEeA8zHPf63YJvL+AY?=
 =?us-ascii?Q?hfZWLpsqFtyHTGm7icJhzqKcWEOiTn4AV0LUOey3FGWrA6okdtzt9tFSTXWy?=
 =?us-ascii?Q?6FpemwfixxDy3uOiUIha6CLwdFVeACwIiJUmQ1Rm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b4e2ec-8d47-415a-4d30-08db05eaaf9c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:29:33.1049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XzfUnhhIacFEzC+NB3QMTuuo9cNFoEDCLbZq+GRMs3lqUNfFw2YQCZZBgVQsAhSmeYcwlMN1EjQxcDM6nMzObA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577
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
index 37217e4cc118..58be28376ca5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -50,6 +50,9 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_SET_PSV_TLS,
 	MLX5E_ICOSQ_WQE_GET_PSV_TLS,
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	MLX5E_ICOSQ_WQE_UMR_NVMEOTCP,
+#endif
 };
 
 /* General */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 9ddee04a1327..0fba80b1bb4c 100644
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
+	for (; i < ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT); i++) {
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
+	u32 ds_cnt = MLX5E_KLM_UMR_DS_CNT(ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
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
+		mkc->xlt_oct_size = cpu_to_be32(ALIGN(len, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
+		mkc->len = cpu_to_be64(queue->ccid_table[ccid].size);
+	}
+
+	ucseg->flags = MLX5_UMR_INLINE | MLX5_UMR_TRANSLATION_OFFSET_EN;
+	ucseg->xlt_octowords = cpu_to_be16(ALIGN(klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
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
+	wqe_sz = MLX5E_KLM_UMR_WQE_SZ(ALIGN(cur_klm_entries, MLX5_UMR_KLM_NUM_ENTRIES_ALIGNMENT));
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
 			      struct ulp_ddp_limits *limits)
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
index 000000000000..6ef92679c5d0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_utils.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. */
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
index d3fc3724a39f..3ae2c3f09476 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -981,6 +981,10 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
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

