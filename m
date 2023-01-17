Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06FBD66E278
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbjAQPle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232850AbjAQPkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:40:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3955F442D8
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:38:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9eTYAda8EPUPRqlN8zNqek3NkpI1/sw2UxhjW+oyqRbkrmcsW+cF6GN9m8QThG/uEgac4TNLuF/D247cUt8MxJhFfPIAjiAeZHx73GFUOLjBN9h/0qYzS5MxwehkXvscIbX5uzI3DRXSShiQuCl1Y5sWrrYWRVol209yPHe7cAoonjegnOngdD3c9juChJ0YnFi0zPtxyTu0NZ31O4pJievS1EhxrQp4m6rsVcTdtSF1RR1wIrG8IttlhkYjRMGTBy/kuHru8q2NG9mxQpH2XMZ4esn1rvMAjF0j61tBMotRINcn7AotPlmwfSUrzNkaeAkxyeAvNDFm823LB5wPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OqVT7qVgxRdzlCI6fPqdfmPJ3ssRzf1/SmNG2G5xpAY=;
 b=dTDKOOzMagR28DYexlqbYyp4D3qakFZBDH81IZs4+v4XcAYmyOARt+bSKMyoniMHwNojhWarO6I8hhluXSbFHggF3KWXDal82jaOPKNYqhc5cMB6KglyWWFrRCB8TlsdFGgGwtJw/qlA0MvA6ejcwdu3kGhxJ17xiOSChQrDhcYrQACbcSDhQsLVo+chDb9GVuCOCbu96btvMItZX+uP+OaJ7zQUB5eS38iID/Y2WoX5+EcSqzzbuNq4iwVt9/h2Cpp0uTd/Dxo5wjurNn0S7Isgdpfu296bpKXGcmxp3AYGkblfleE80CQqJuVmhOUoJgHQkQVOLNMYqdhcR/7Erg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OqVT7qVgxRdzlCI6fPqdfmPJ3ssRzf1/SmNG2G5xpAY=;
 b=Kyn5rOsa+5o7DxKYD64Yi8qHk6CsJjjITi3nf5aY2aWJb6jutrDhdWpFvKGHONXOZnEoachBSguoT8oMN6mr3GrkCytakO5rIWAEbcWmaRcumv2vMea7TUwFVIgXXuGLJLz2QdmCwRwIrUJpb4SKkI5vEIXxwHw+BYchKhI5JPrJl0C8FUdVtm19c5aIls5so8/t4OsVjFbzkEPk+y+Ppi/Cgw5VCEUxyLe6/xjoPap5MrOxUv/Tt7a7V77B/C/TjgsNtA3vV/4lxfBZ212vzJW9BgohHf+2XdOYOWSWot3ssHcsSQz5s6tJmIWK8qecADumlqYJnz97VUxciymhUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:38:05 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:38:05 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 20/25] net/mlx5e: NVMEoTCP, use KLM UMRs for buffer registration
Date:   Tue, 17 Jan 2023 17:35:30 +0200
Message-Id: <20230117153535.1945554-21-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0130.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::19) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: 353118de-29bf-438e-5d2d-08daf8a0d336
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVnO5f5YXdN/m+lMrorWES4YCCFqvfuPFOqoMrhLTf0VxXSHTzIHm99tRKdyWQZGQn9bYnz5Xa2v9H2y3yGAcnI2f3x0Wl6G99PqJOcOjyWHD/ZS4TNqLj66Kxu+M0esus6sy2vKu7Zh8RR6Ktgoh+NVhfrDOjtP4bGfDU42Xil7Qx7wYR23Hf1BzhTruZz9Avdx9QMFMHjQSCi4UciAEh4PAS5k2ujHzwI22vVy/nrvOnhOjzW9+dMEWpU6WQNF3g8AaAdNX0HnGKHFau0sA52H5EJ/17pZjAigSdU1YHr1E13Av79t6NZTXYN6C6HYrcvX3198XI48wkgFGWVhbEhVoBMc/YIEUtaByq+zqk/+D9BS6w++gSl1UEpjjk4Akroh7G0K4lHNfbuQo5W8bpA3zROfi3PPwlmzC0a63J8C18nnKK8zFKD0+VFUULNaQ5SQVMtYstc7Hy3alsVboq4T0JrjTAquCgiJ4c60Rky84HviZUrJHZ0VdcrYenHkRMW+sELVq7wPcndW/w5Lof3eYgg+kMgKBI2HYxnG3Xg0ZY4SDn7Td4OdEvGzwVax431wI5+QUsDPkLBy6gSVAXCT0+BMhQQfR+ZuGTQ4rJGqYTmhP6McittN6SXNWivWUhcz14QA8gP+/mYcK+8rYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(54906003)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RvVZG6hOLZ6/9OPI7+TKPXs8cmrn51yJNdC9syDk9dIZVAyZjTG/Y3d7oyfZ?=
 =?us-ascii?Q?V/Zm5cO/rAx4aiSu3c3WATiEwo66TLL55w6jPHqGKIRn41RILVDCp+5bGKXS?=
 =?us-ascii?Q?wRGpb3GzVh6xrJLS44KWbrenid99AP7T93nGUO/9Rp5wH5qyOqdpv/RVG5XD?=
 =?us-ascii?Q?d0jcCcUKq78SPTr6EMBE7gHvrQEzR2dxWYrdTkjQLNQFv/U4GshIhVuoxePi?=
 =?us-ascii?Q?JRXXYBEfsYrneLC9lMzcRL0qxjZQ/RxYnZ4x9vE9POMAk0scGJZo1wzf7d6U?=
 =?us-ascii?Q?Bxu0WXJQxt5r/jRTWTl4VmQcqmdUEReudaL4+83eysjt6IIsugQEPFOFg312?=
 =?us-ascii?Q?PUUB4wwravPuMagYS5BHUi1CNSMsDelQeMr7MtUUYVoDDTJXBHb8ot4yA20x?=
 =?us-ascii?Q?wWG7HR0LIuk9nVbtGYEkF7sOlnfn/C6nzhotq8fumSupupdFigDm3vtAHUgj?=
 =?us-ascii?Q?PfCyFnfbg3dtv0WZGAImhLhaoJlTy1KnUpOu8fdtdOrFCJi9zYwE+IabKULA?=
 =?us-ascii?Q?WPXA4hlK5WMCwPcfXk36LXnkc3BetRJqu2X7e3mXKZzOI37zdSOtYNH9nz7h?=
 =?us-ascii?Q?3XlEUUn1exg90s0M05jz++nPdNaHFr3gTFpoo1LpVS+FHAmCmg8e7M3Z/3gu?=
 =?us-ascii?Q?+pHRLrNWw3ScppcFwwK/mP99pzKVBDQsfCX9gFRoXD5BEHHduZD43KEBvdJS?=
 =?us-ascii?Q?yWjexElNHoFNNDxtp9NIqq26aovU/RI0em86T8U4PUgQUGNnaiZ/QIi54FPX?=
 =?us-ascii?Q?dZDVfF1E0xItcURxJYUHrR9MRVEpJahJnIKPLOYjowKe4xCsKt0Ua4VHkvTR?=
 =?us-ascii?Q?pOaWEKuzGeUZDmLm/CFWoiFS6nfkBt3HF7KaV8gZTTVXYScEcY2fkK3L/VPM?=
 =?us-ascii?Q?+VfwZdhLiX0pjzvxcHChbQwRvpyguebLIe6codrMxlatW+Yo4GpoWUIdhRfo?=
 =?us-ascii?Q?heyAnO5bryVwGvt2pvrl0+Ey8ei82V64otW+L+2q0JAUJN6FJ7PryMQq0XOS?=
 =?us-ascii?Q?Vx35J2GQufuG3mrRDHLYC6zsYLQpJoPDr9g13L/Vv2aKSuV24cQR5t7AN8r6?=
 =?us-ascii?Q?aznG27y9NjbuyckZzlSOTit1y4iqhLeb/6ke0pvGqkGl7wd5Hy8MwIPfMvdR?=
 =?us-ascii?Q?cz8JPpCHDqvhgfTpW438JP+pvGLyxQbJyxC0/N2inzTe/Bxx2Mg/qogH8pb9?=
 =?us-ascii?Q?sAlkS9FfL+NrScCUFWyJ7FLtAwoVGydga8o4AOorJZvw//zJ7djsHDRGbRMm?=
 =?us-ascii?Q?EPI35aT3RwuM7/YuCMzq3F7GrA3APOYnxOIXg/2Hhs9k/H+VmszOkZfGgf6P?=
 =?us-ascii?Q?qeV5066/st1v7xeIUqjPZVnfGRBN+YAVCQwp8PB0DgCzfx65FJNJ4N3Qrdo0?=
 =?us-ascii?Q?BHF9DX2d8r9Mhzepii4ESMT2cp93rcgGi+n/oxtPDNigfBS/liRqGlmn7ixQ?=
 =?us-ascii?Q?40aXLI1xY9PEBFTHjEPqdRCHgvEKS5ibBl4YWs6kU1j+hwPKBVZDpBS8AX74?=
 =?us-ascii?Q?0FyegbPQY3V9NvPE4kZbBxh2GLYaQ5Oma6YL9XEGL2twV4O8lQku++P/SM9q?=
 =?us-ascii?Q?H+RszW5sHlFq6+1w8PhmK6nkGYH2EDBEEbxiec2n?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 353118de-29bf-438e-5d2d-08daf8a0d336
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:38:05.0076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LaknDUDDI7H1Gfe/xxqqe0zXo2V495m3hQqZjaQFq+vRA7Qe8v+7oTO11qP2OEgBSmEQJfcM7rIxyaWkRXy7UQ==
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
index a690a90a4c9c..2781d9eaf4b5 100644
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
index 5462df75fff6..1eb782596681 100644
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
index 51167f000383..02aa16f5eb57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -984,6 +984,10 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq, int budget)
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

