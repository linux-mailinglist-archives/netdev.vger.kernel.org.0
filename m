Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9EBB6899C7
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjBCNbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232931AbjBCNbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:31:31 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2045.outbound.protection.outlook.com [40.107.101.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFB356ED8
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:31:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/xBXKN5Svkx5jcmFzCVxUErFYH6P8SoeFCqYryBvrqSMjT7CCLfcX5UxiSQ07ogdxBrJ80Cc4iMm1dpZgn/ehxvr/SJh6a4FxBdKyV3TJhWAutMrov84LvjGMYS+hWkgnQQTpkk2Rr2OG/SLFciV8pP9QSnqBg1iqBNTZ8/3W40WYDCLr4qxya505DrNrUhA0fnGTvI161are1uZYdK53vGtvZvifOyOvISiVr4b1VftwRIROjE8SeAP3pZfKspMvIDUnKf7TZv2rF2G9IE/1YtD+5oLJqRArUmDu9aJHhgzyM3q4uiQ4cdy0eDct7cnF9qcielHK7/XQqEgxzT/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOXFX2hzWP8WohaKXqdxrePl9t+/u1L3xWYLBL/oj24=;
 b=m1CSM92h9Qd/j3in9Cr4V2GWhvm3NjuDsBh/hpXYVhMzZYBqMlOwpw1C6Z7zUeaSv8oOLxbwOPrdVIIZkK/HkEPneek5xvqqMaRFxDsmkGG2j03ovadIld0bc6a5qAe3a/C6sRNqhVHCU1YJuuQyC+C/61FwBTIfDbjcIZYu1j7LmC5F1MqFic+eNqulLahSFJlcyWqkxghA9/P3KXs/at2AVW0KEMHIrzw8566lffsS6YFaZVFpQtyNyz7NZk/zX7JTxKLUNE199uy7wlsKuQpIUAtWn1z7tZ+ZA7y5txxuX/l85y8v/43aA1UaxcBrmuUVZB9W9Ee5pmT3hO0BeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOXFX2hzWP8WohaKXqdxrePl9t+/u1L3xWYLBL/oj24=;
 b=LFEshJKcV+aiWhJqv6b2txQm/hstJRVIUxDgeeaZMVvST3wcABwc4PuPxs9BM3/oXIjbR8gR+SekxEo4er53gkVlV9iyZtDfLdG13RiHEzfxm4XuJSJfeW4CB4lTGmNvfbFYVXq8xvhC0w+SLG5czHF+uDYYSf1RvQNVX9G46vtUdYMtHJDOQ2n/CwBpE5WdPLuwsJkwlGn2Su6+AK64nHWQxhTR3jkDPZ7td38YQtSHJ+X8A+za0DJ6WOtYRGtr1CYtarO4xPHqowYW+TkiB0K/ocWDm3HIqrSb6gHBTJyvGzMWcHpF1NurDwMSJEPV7BhLeygormDD6yBMZJRgmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 13:29:51 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:29:51 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 23/25] net/mlx5e: NVMEoTCP, async ddp invalidation
Date:   Fri,  3 Feb 2023 15:27:03 +0200
Message-Id: <20230203132705.627232-24-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::15) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: df5babf4-85ce-4a35-9138-08db05eaba9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7HXLN6x1KxckotlmXxlpEL/nqxSE6u/Mg16G2b37ECpwPJ0ISiEAISsRZ8CwdN2z95lD9z8M0Tm5gYt3vVWASOqmlsOtgNG58PVhUjZ9+dXwdWYR5sM47Ezne37KLB/n/FEraGdoWN3b9BN6L2Bpl2yKTPrRueCbiISJ8mKo2J4qTdQcXGmOcNmOP392QdWkH+ReAB8MCCDLVLth5BRQ7jcAokzLWeoD9slBAV0Gos0XZjtsw7m69LnjqEfIEYCCAkreK3uerNT0jgxt16W5a5DKPpQzYK1kSE+73TgSwxDB7+Po/H7nj/BFGnDRZfPAiZR/JdVffLZ+HRSr3JIjiUM75CmGQYL6bZ+SgugNcjponYrcbnFr5eU0pC7wjwWqkTiVE/i+ANZjUJ9MlTSbm1C1awf1yjR/8sZmoBdFd2nIbXoNHISrcxkKiA2xH7InSH5no3lwqc2WUJkne+ebmtR0leDAi+l1j95mhu4tw82NQAnhPsvoX/kO24o+TI0bw4vHCkSpxFAkLzGgrQEBWO8LKfGjpTuewYa5+tow9vKEOWbaoFmnTZiayprEQJ3Lly7pf4kMwcDqqD/qucZHlEX1hRFR99OZ0Nhj6nf9rQO2cbX5J5zTm4vjFcBr/6Cep7InDHBFD2ReB2Vm7Y1hng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199018)(2906002)(36756003)(83380400001)(2616005)(316002)(6666004)(107886003)(6486002)(186003)(478600001)(8936002)(8676002)(66556008)(66946007)(6506007)(66476007)(6512007)(26005)(5660300002)(41300700001)(7416002)(1076003)(86362001)(4326008)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pLM82vsCgYb4OWrKV6WToZxN/pyl/A3sbwaewDsUgDgBIzRSQXPMYC0vdkM7?=
 =?us-ascii?Q?dffLHXcDkytaTKsyLAcO1/PqvwRqP6IRHNwk91bWxMmMLCIrhqNLptmVDsvV?=
 =?us-ascii?Q?GerGKaayIi2lT++9mXxGNgshEpB5B8N2SN+VssQZpZ6sHiPqin15QtPyzWmC?=
 =?us-ascii?Q?5za0J0hEy6z66zy/A6m9L1hFWPynVbqHzNDMBeiIVkvshi3oZyKEp2De8DMG?=
 =?us-ascii?Q?4GLCWmiqesgAFRq8TOKfK1sok2FVptbSVr9uCoDvOzQpY37txkgvKwerysIZ?=
 =?us-ascii?Q?EvhtJRHQ+IlAf/Im5sM15c4q8D2TjJeYyiJ++mKopdm000Ty+SJlAoB3hzla?=
 =?us-ascii?Q?JNdwsrL9b7Gw/KXjfHqtU0/HyPoPbVYuBFTHATWAvdGydt4rk36St62qvpV4?=
 =?us-ascii?Q?h055pmZzmdK7l2PApKVF7wjieeC4XBlGo3OwOOfJY0ooQOJ4cb4KJEUchrjW?=
 =?us-ascii?Q?hX4PTynhZafMT/J+KimgfK97mgJMlsbcARar4SQEXMEHAyjcp+bRlZQgQbkE?=
 =?us-ascii?Q?h9dL1Qw37by84qLQ/LOHI7mGEeqhjLL/ABHb5YRlEC7R2RSJ+v1TvcvzhbYJ?=
 =?us-ascii?Q?x77DdDDmrKBj+aweSU40TIKzCLtWFQBL1mHXn7sHv03i1TV9vIcDfebHGRcf?=
 =?us-ascii?Q?xXffv2UUawgSpwfmiGvm3YRLtT2W72KSDVmVTrOk/6Yzy2h4IH2c73z3Gry+?=
 =?us-ascii?Q?fVpkFgd6EVDJgScZB81rmpKHDFnLTe7EhflQI7aictBEL9KaK+hz7sG1coQs?=
 =?us-ascii?Q?6Z2lVPFXdTcJWws5tqHt647kKZRZNNHEv0FlN4smXXW5e/3+Kpc1IZVJ8q/6?=
 =?us-ascii?Q?fL6tDZMkYztHlZY+k4PVYsITCVi1DQ3JSmIg2cLZIAEDRQgsdVkerQzBKZ6k?=
 =?us-ascii?Q?LsM+lCvYA4KP0VbMOf3nKOEgYVmuDK4nz1FVDb9VWch/6rBoeWAcBm8G7c+Y?=
 =?us-ascii?Q?+n/siRLJZrxmH1HUBvFBODygCn86hdd+rpa+PNbHgtwC3C/PUcjyEhBTyENT?=
 =?us-ascii?Q?fBqbh8AVJR4r33xhpRcHUv/iT9KIi+KB28Akigd5K4ZV/fEqz5Ak62lHZ1gW?=
 =?us-ascii?Q?P7Jr8o8enuEL4vXq2Yy6Qpiy//7D2VgVv9MW7mF0QhqVwcypSEp71zm6JcmZ?=
 =?us-ascii?Q?g1753E0aif+iiuWu70wyhclK3gOlBsWTLnfii224+A7XNFnG/PCR03ffCAP4?=
 =?us-ascii?Q?lgQSMXhQ22rM51rnagD8v+Id/0OQCwSAgd3eF6XEPTAAj8rJDImcGVoMOG6d?=
 =?us-ascii?Q?3CgxkMd+J8IJdLXCloKBZFzBYB/th/aXZPsxp3eB1DrKzYY6yAE7i/6VmtEx?=
 =?us-ascii?Q?fc1pyrRcvfEm8qplp5nUReNnyb4S2l402y5dFpL0hHcf5z/U2pvdBEjhDgZV?=
 =?us-ascii?Q?u1n7gm2FNNmZWfqJHoKvYgkwhDQCkV2tcYAG0Dlg9duA4exA4/YnWHDSfYpu?=
 =?us-ascii?Q?uQdnYkKMt/X9BLFxAQOdHkq9ScWfkVHnO22rendDt2KX6PxuQYktziZ81Sc0?=
 =?us-ascii?Q?nIa+K73+H8CDZkrHU1MslWw8Bz7Fb3N4QMXX/iUbacIJE9RZWl5WGBsbj2sL?=
 =?us-ascii?Q?/YI/6m3/MylU7A02xDlA9Ead6/h+phAaHy/Zq7sk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df5babf4-85ce-4a35-9138-08db05eaba9a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:29:51.6734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HRmwKvGP3SYBHxd02Xr4LPaOpRsCjpoPSsZt4J0qhew5oVyDDOThunngfcHEbmew0A47SE4SmyaZ8lRrjVZ4ow==
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
index 31e240610e48..0bec8c535dc4 100644
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
@@ -217,6 +218,9 @@ struct mlx5e_icosq_wqe_info {
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
index 2b9d69254ead..3fb082cfc632 100644
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
index 253aa3f59f20..71f73cd5d36e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -888,6 +888,9 @@ void mlx5e_free_icosq_descs(struct mlx5e_icosq *sq)
 			break;
 #endif
 #ifdef CONFIG_MLX5_EN_NVMEOTCP
+		case MLX5E_ICOSQ_WQE_UMR_NVMEOTCP_INVALIDATE:
+			mlx5e_nvmeotcp_ddp_inv_done(wi);
+			break;
 		case MLX5E_ICOSQ_WQE_SET_PSV_NVMEOTCP:
 			mlx5e_nvmeotcp_ctx_complete(wi);
 			break;
@@ -993,6 +996,9 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
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

