Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F56D67D16A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjAZQ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjAZQ0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:26:04 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25C76E439
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:25:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T1z4H/+Aa3YP1GK59OtDXNWvACQQOsLlftZxjwwUI9UOG46nDmbmYe9cE7gSN6uiqFR1ItORbbvA5UxbBxMTfMPXuRNCr8+5zKlnypzU+eJPp90aIi9ETIADg9B9Csa4ted+/Rr5U2519wgoQ3a01Bjd/jspFrBmPwFW6IFSpIlqkFQC4mCfIYH1nzHpEcQhjgHavT3IvpN2N6LYFQzxPuXFiZXFL79xGtaCZstVLejjInrQhDZfCyk41vSXUgtGpSs4bHpg5apBaHeqnsxtQb//LnFeWK4QlrwZUIgE8GTX+H+Dv9IDTF/+18B1aApLyBWQfwBx8XWEHbNpSfcr+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4kb8q3l7NWX7j0GI+PPfsh8aSZIJRSU7/ytjYxZcso=;
 b=FkyMD8njJJmFqHUNL1eL0R9SVG7eRDfBSxVbzNU5ccEPbeET7kGVSquR1ayZG0lOBsSkd2LNv3lVeNy32e3/v5SiBliR81ulk+Y5xihiNPILPef6Yrpvv1/UzCe1kpvMGQxUNO9ZUsqeaGLyL6x5BJGWoXMRwnVP3W5nRC/AYzH6vbRsRrnUrTeRJPJ5B/SH+v5TY3Fsc47d9E9hdVWSBuSQfbYEYFhCtQJ1n7jIcmT9jb2nYE4YaT1xFBOqBMO0fupOgq+goTqlH2sF4RQ7Pveg0GJqb29OOGKOVoCMyQtvGMN/FJvAYWXnH5e4scC/0NUL/oWD/2r7MSwLvTO1Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4kb8q3l7NWX7j0GI+PPfsh8aSZIJRSU7/ytjYxZcso=;
 b=snad7Va4+Nrkorf5d7/boxYFYMRNQpUN1ucOgRG6Wic8X1JbVBZk0UrAPUjnfETS5igXWXEhUCOjEjuHg3i7ilCD0LaLk/Xt8c0XOPEO2EcpvbSnV5zbbbgP/hLcAF0+1Ut0fX0RSFMTkHA7spzpMVe7o8dfCsh6MVXGTMSPR+sTKSjJOGhMzLknR9sP+PxjIiDfJWOzqg3CtaHYpS5CXcwKpCgY7NRrRDIMe2/y+LjUPFamzcFKihTVvxWKAwbqLSEV4kgA1RI/p6e7WTEiQTt85GeGHTuyaVQiZccw1ZRupx8O5k8xQMdPA5jpFQXPnp7X1yGUIUwvYukM0GR7aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:24:08 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:24:08 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 23/25] net/mlx5e: NVMEoTCP, async ddp invalidation
Date:   Thu, 26 Jan 2023 18:21:34 +0200
Message-Id: <20230126162136.13003-24-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: 6886a1f8-571f-4d22-e034-08daffb9c023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJipAeIpaAJ7WxFSmfP5GaZPKEVG6RLBYDFHPKRxo7evWN6BZ4OkgfXYI1KcJB4ATz+Zm46ybHNsVKt8JIO7PG8qKlHmtSrRVcwjYg6RQCjxhqdXhqZOu+UnXhyXckJtyFX2jLYqbeJtZKFuV6Sn3SSkOF/QsiUKrydpPvyQqjTmN06qhcrV74ouHn4iEz5KYtrgIlFAtVUCTj9tApqMl9q2/MTjwaNOtuaNWjroSDii8CGi1sYFl9gHxzByjagiRv9W1aa9usoUG8bafEGG2KHWtCVcxW+h2T+mTL9/HJ/MfyE991v8kmauxVrRphyVsjUXuUnd5apu6giWOt4ikPp/5Tdb85KqxW4S7hbUQKaFYj/N+iyRyKkYVMq1++/GqHQ2gfoC10FYDGMu7C38HXYzyhX2exqbTnsjPWfssJvVQtnCNLtixY6087pmYs8s3f5AIUQvlieElZvQPm4jtUfaDARGIyxpeVxKUq7cD3J8WUR2hFftBYu7WdqtMdkaxDr2WEq+aizm161qLoTwq3nR3V1cr79OVpVn6e6gUldF/8kwEuIV4FMCQpocLh5W2t3CfyzBl6aKhf82VQ4UE/GXazOkmXN4Av4uDkJgpM95qRHEraAwlloPo45ohBNxTSYtpfA5v5YWZ6ROMD3ulQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WFMr8zB2fDM+L03Ob/T7ic2BFtN7vW/Xq3bpQ1bGRCkQorSOEsvdYckuRCTG?=
 =?us-ascii?Q?F4NOpjt0zj2+RjH1BpY2eLo6gCSvCdMCy4pXtvgq0UFKgjCozsYcq6XM7t5d?=
 =?us-ascii?Q?IPkmmcgvzgE29V/Ro2KOnkdSveP7+w62dSm5n/avQK7mHTIhwiTncXsuAHqn?=
 =?us-ascii?Q?klL+3+QpFTE4rFbza/PZ4bpla/hkZBQ5f62VnRv2MbFSviOB0BXdXaY3P2Op?=
 =?us-ascii?Q?LilSeyU5LCUM70vhYP5N5cG/364DwgB+ncm6e0yuMKedNlXlEETdggC9iwCz?=
 =?us-ascii?Q?A3Q1DokBsIQ690cydtvcsyWK1B0FagArFsCz7hBlD63M0jWUu+8JEO9iFdSv?=
 =?us-ascii?Q?5zj5S8g23FMrPCBieAe54Nqi3FktW5oD5kyTCnC06Of0xdOlyR2wJJhcFnRB?=
 =?us-ascii?Q?aaVx7booKdQl6QvzBjCAPOA5/6qX/haHBaSHSSK7Tb13JtOxruHNg3BydEH/?=
 =?us-ascii?Q?WLGhaPj3WRzlZa9z93/jqR4Dq5khA+XfmANpcT0crqJe3FgOllxEtwqCx9/c?=
 =?us-ascii?Q?8P96NzicxQt1w9XmDBm7uAG0Y4dPYdNqAQ+fgSQMKTfgtSM2mvqu8eNoPlm4?=
 =?us-ascii?Q?B5UUJWaJEdihvHodfZj+BH3gn3SCIHrbgcEXBxOtdrWtiq7kLo4hddA9l8lx?=
 =?us-ascii?Q?O4iEQbFp0r0rvvkOIUNiZzKvJ7CE+66deqxvRLHsh/6r7Ykz/nwn7+Xa3YuK?=
 =?us-ascii?Q?Gf+g0yWTQpRXuvrw5O+R++jsAd9/LPg6RV2+/cORbmVL8Fdj8u6dhvRXdL6N?=
 =?us-ascii?Q?BEtL1UgXzEqB1Ey9WJeRX2D6Stgjb2BUxypdxzh5Sj2Wvftl1wClXTYE5R7x?=
 =?us-ascii?Q?IXh9FB8MWujko1RfsWROwAqGPZMeG0VXtDACZiKCA1nhXWFrW4upzOVTF3O3?=
 =?us-ascii?Q?6BAlh2lNSVOWuX1CFSEMjVIVPY0SgwSHEOQ3A9YoLNpKqWCxp2+clAaekjTT?=
 =?us-ascii?Q?yyrxjvzi9eA72ZNUF1Y0wCExEdOpfYIOCIGd59BqWJ9tcwEuUkB6VVgTn6gb?=
 =?us-ascii?Q?tEEFqfFj7Dsza6lbXoIaYONuFiYgM+eVWbnF8Dvp6PaHYnkvsinbgS9gG8RL?=
 =?us-ascii?Q?+i/sevIQ/w9qoX9km92CO8VSQM97YiiPnOc8FRkBw+qY/AdV6lSdpWEuAtUf?=
 =?us-ascii?Q?CeZQQmA08w5xuonc7VBfeB7e/ldfHIptq7WdhiDp+uFOTK6/2ctLhdZ5w4pB?=
 =?us-ascii?Q?0zgrBs4+2v2Re2QkA6xRZ7TgWCRqLybLI5DzHObfCWsEL0xHG2FHpr0rEVg5?=
 =?us-ascii?Q?p9Kzh/QC+OQ9LCsR7B4+PI/hY542mKSFauGbqne2/LaN15Y0Sk3T1C83ntXk?=
 =?us-ascii?Q?JN4FHc4oBKbCHlJ0tjbPM1usynCsphySLA/DCKSxI29e+kMi+OcE8y9xXze1?=
 =?us-ascii?Q?3GsSBHlf/RAbzwn/N5geThKk02pwgfkAh1EeycdmMUp0EpLMlU4LwdTDhwXA?=
 =?us-ascii?Q?HNwj8aJyqIU8KbSbjBTdG2GwoSZ+zHQ7I+R2cyUQZPlUIkg6St0Kk2kTQ1E9?=
 =?us-ascii?Q?dxhDq7dTxXToaavHasNL31P+vpuE48x5ZnFx5E4kA3OrerkiDT9b/Vu/ekQj?=
 =?us-ascii?Q?TLBUs3Dt1st8yrIHrcyQy6+f4k7wlMimueByKALd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6886a1f8-571f-4d22-e034-08daffb9c023
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:24:08.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3TvdWVHoLM8FLXwHoNTM4P2Cx9hieVcOzjKSwD0Qxzft8ShMkAq5NDebnD/5aZCWMRm/7eAUul1mxfJDAoUcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
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
index eb5b9822190b..31ca6e2f912a 100644
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
index e7c2cf83fd20..68f2e94a015a 100644
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

