Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0136899C5
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbjBCNbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbjBCNbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:31:05 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4888D9DC95
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:30:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjbI3taaNv6+wVpellEX6x0fu17hPcrHYglS2McZATaj7EXGncAOkwR8MJLTgnYnqaO8awx6CFd2M3ia18O9DJ6aTB+YWkTgGPOeJK7rXi8BDOGoxILQVEtPQ9LyOy4Fzr6EuvM/6UCAzbHnk9qTDlQ6Iy4Jwu8vQ4AZHa1Bu4Bfe2oNOgrNs5/bzpVQ966FEEt29Jrbhv1yUyS38REHAH1qjvU6Rj5UE0NoZ7k8ss1PCUHia6Gdm51JbfGEKGuvIrMqKy8pYejTYWY/p4NM5c9UCgjO5FkjA34zwzOAM37AMjrXNF6CJYlFXRGKJn86y4Hjil0LCjLrmNbbP3Eh1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OV8KmX6Su6tvPv9+V/mbQzcgWjgrjQXmIj2QdZkUjJ0=;
 b=IdT+1Kp0AAZm44HPpUSNF+FFf0E/1hquwLI1J5arUdAU/eiELQfCGKlsZYfbqfalosbojk04xdDdUSYwpniJq+FlNxRkVcpuPFulfAqzNfKgeWiRO4g2C0cQbyXU21racvzgBo8sUFDKkYSEU+cQDzE3BcDiXwCc9J6h31q115hcZfE6urSz+JbehuektVaFZgzT0l/U+Rpc3gldLH1CsK0dGhvoqw03wawd85TkIL5vYSHHrjCBXOVkJkDIMogoFykDbSJMuUQCPeDnF5/9REPbcUwwb8u/ISWCkFakHWejzP3yRLx64/u3pI2Sa9fv352l3A4zxfImBZFU9xymnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OV8KmX6Su6tvPv9+V/mbQzcgWjgrjQXmIj2QdZkUjJ0=;
 b=DKn3cNfZaK9F05uuO76Db0Nwvl4FoBsCiV1aUoOqRZ0lYi+RjdyhUAwNPZRd2VAkko1H9IbFoY/gjcl3IwrAGS0tjAixfB5RQvxVzHf9f9B7tIGYcJfMBSyqENF9VgQoPkNu6kIfYJd0btDYr8X39+kjJLy0gwI8Ke/dIzhajtScAkIp5Yoix+aZlNwKApU+y2fTidGOlPu+wS8U702PeFobaugKcc2niYiuaVwLW8aJ9nQM4CWTmADTPH4ZIXMszRO9+/vDTRCSjnOuCEUN/1BW0WsIodq3V/Wgrv6lYnFPOU4jPM0VA22hHmnCaU9kwQAlOv/PrQARQ1jwgc06/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:29:15 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:29:15 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 17/25] net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
Date:   Fri,  3 Feb 2023 15:26:57 +0200
Message-Id: <20230203132705.627232-18-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e770a72-8461-4ead-37c9-08db05eaa4ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRY70p6znk/skEvnq6EmpFBTE9hGQcV50DLomeO3QofBXbvh3L1m/3aFQugDjQgrmB9RMfvRY2iDWO4s9Pi6sk++BB6NKqveDrxU4GE2V2sgC1gkwOzogVvRFsGGQRylt8s0TNaJyz07TwvcUoK/AYD0YvMyw87UEXg2DkguaEACs6PrlhzIbmaORUK6nBUONFJtAFXzIrrEk5/lM4PM6vY6WR/bOrkwr6rYXlw//8ca+nrrlqzMuz+bBu3ff78BqOabtYTwFtyJ5bkufhe5K+xw7M+FARj3iEBxiQoWIBcGpbF9SpjIDlapq8wqPTcJXrkBpbia8AJY7EsGgAXzhUPMkiAoAQFBMnG4YLc6fRpk+q/YlZEIw1aW65gJxroGvfbQxmStvQOZAFNyhKC4oIbaaYrsm3byFGhu3R0TrvDTbkP7lXzb7Xic7fXsAevsiWIPwSSokJD4VqS1fgzLHtPHRt3jHkizZzjsBR+w63y0PLlbmdmRZNPRFRtUtE4lVXNfO7bLm3iv7qlQJ2rPCFZsvBKNHOrxBJIbSc4sp1fOqaaoPRYzNtyZSnUnzVGK1gtknrUBkRDdNmFt5kHMZqvOuBMJ/I9BIRwm/jLYi/6Pf9QKavRVBsFrLQZ9YOef3+g3ML0CokfLC53A4LNybQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(186003)(6512007)(38100700002)(1076003)(6506007)(83380400001)(36756003)(2906002)(26005)(7416002)(478600001)(6666004)(6486002)(107886003)(86362001)(41300700001)(66476007)(66556008)(8676002)(2616005)(316002)(4326008)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TDXhzgELyt4c8iytKyRQwaJB3z//0t4ZzxijvXflFPaYQ2omMkbixe3g4Fk/?=
 =?us-ascii?Q?MJFsiELWPv5jOlaWsp0uQMkNo5VTmbrtGzdpwXel7fIjHyQsLiGs/2axhm+0?=
 =?us-ascii?Q?Ew5XHkP3w+0lmtgBEiGP7p79gIWbHXi4Fhf6iGi0q+yM14EeKw0LyXKZEHJ1?=
 =?us-ascii?Q?X69FhUkSEB/yMiLKNiJSrcN5FbkqDRWyWRR685gIoZ8G0xNkPclXtrK8EelK?=
 =?us-ascii?Q?U5C9YYzX+JsB+yU/eV2WJ6GlpY/xyydjzmcKazkvA9g4ahwVjhJotbkUiT6G?=
 =?us-ascii?Q?wfJEPEtpXmcdyG+K5npUtLV9TrSXa6BvquuZMuU0O8bWM1QVJjH+xMD6T6ws?=
 =?us-ascii?Q?8Ud+Y1OERDrxPkF8i9EYZwdWozb9cw/LTDK2axW0kS4mV2FTgno3XEjqM9tu?=
 =?us-ascii?Q?QyFiVMm6EfzoFQ0SMcSXNYLFF+KJ5LONInwnbGz20QnVRRZsKgFW6xMa3/ly?=
 =?us-ascii?Q?YQEon/bNj06e86NaRuLNI28coMep9SuWILSLZ9IX/u0kAnN+GAb/ibXOumAY?=
 =?us-ascii?Q?oEWomf4C+PIWpujj7zNATw4MhD2ejQ3MPj5FL2xH4LigxL8N4VW05m6RhK8X?=
 =?us-ascii?Q?B1981gKnBI0fE6mWPSSWaYtvGkBCqx83InHfZyTb9PHnlWWI6Dv6qZP+bEvc?=
 =?us-ascii?Q?q7fl+4AICPCpyFKC0kx/7HiJLUBz+Y8hAuPjtdrTi0HTQ+KYLdibcCGNwJWS?=
 =?us-ascii?Q?zl75nWAqqQFqRjsykP04r13L+FnDkAM184votdxkqTAV7zu3yiSBDMgNYTSd?=
 =?us-ascii?Q?NycAXGQLcktne2sPCyOe0e71826u7a7NgqkRXylIlWUoDKWhkHMHIoTAvqJl?=
 =?us-ascii?Q?r1MWAcRv1PxaydfGju6AUiIAM37T3mTYBjG5WfDCuligKMdKVL0jHni/GwIU?=
 =?us-ascii?Q?MdIMOn8knQEEZM8TcXgRvEdV0pzLpMIpu4OVyRefV9u0Ra6W/tjEzta+cuFR?=
 =?us-ascii?Q?KqVYAp80H0ajHgymHVNUePdiuMm0o3T8dLlBWuHC4lzA915xTXpj62ttNklH?=
 =?us-ascii?Q?avx2hyjz2C0HfFo8gI8jt1R4uHE72sUMa8I0cAvo3sU+2Ey6zdMWwMp1mLRk?=
 =?us-ascii?Q?RvksvS+GI2onwydQe1O351W7Q+1Er+fpJWV7rowsV5GCGUeq/ZRkowbnaMR3?=
 =?us-ascii?Q?WFRHHzpfk63+7k9pJuHVm4+tHabsAvufQWFmPv+rRw7gb3M20rFCmjAuHa/2?=
 =?us-ascii?Q?uj5nWi0SxSNK/AKV59b1eJ3scCZgo7hOtxSqjYheGZNpsp8bTDp7877UbtHw?=
 =?us-ascii?Q?QmFM9s0fwv5qZlzApyI0QbjyAWZfH8wj7XYeRIKxFOrBQIvjbHtcVoFdrTJx?=
 =?us-ascii?Q?sGfbv4XYOlIEC78zQhlIotyIM484Q0NfViDwceu4y0QZf1CB1CDFuE9I74oX?=
 =?us-ascii?Q?4pYTitExWibC3ROy93t6tdROoI9v8h4lWC4hwqzq2YobJPFcEZQCgimZb2Mb?=
 =?us-ascii?Q?/pfrnmZ71vbGph9r6LK6ze8n82QsiTA2d2Jll5l+YvEJYdymq9Cc6P2oED7o?=
 =?us-ascii?Q?xHLSXolROU57qAeZBLIMfGhKIQn9a2DRrMTsmjR+yaof80ikuBFVxRzqj20C?=
 =?us-ascii?Q?JceJvRkTh0atulzbuxQa2yC7R9dgztO3aeEggyVJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e770a72-8461-4ead-37c9-08db05eaa4ed
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:29:15.1958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /8AtTxbUUr4RZLPeHsUTWIKnduOWal4AARc1ZRCsV+1htH2RG/lLnQvY/X1mpGNAVb0PTsQPPSo4IiMat9GWCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
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

Add the necessary infrastructure for NVMEoTCP offload:
- Create mlx5_cqe128 structure for NVMEoTCP offload.
  The new structure consist from the regular mlx5_cqe64 +
  NVMEoTCP data information for offloaded packets.
- Add nvmetcp field to mlx5_cqe64, this field define the type
  of the data that the additional NVMEoTCP part represents.
- Add nvmeotcp_zero_copy_en + nvmeotcp_crc_en bit
  to the TIR, for identify NVMEoTCP offload flow
  and tag_buffer_id that will be used by the
  connected nvmeotcp_queues.
- Add new capability to HCA_CAP that represents the
  NVMEoTCP offload ability.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c |  6 ++
 include/linux/mlx5/device.h                  | 51 +++++++++++++-
 include/linux/mlx5/mlx5_ifc.h                | 74 ++++++++++++++++++--
 include/linux/mlx5/qp.h                      |  1 +
 4 files changed, 127 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 7bb7be01225a..5f87f5c82485 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -292,6 +292,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
 			return err;
 	}
 
+	if (MLX5_CAP_GEN(dev, nvmeotcp)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_DEV_NVMEOTCP);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 9e1671506067..0a6127e82112 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -263,6 +263,7 @@ enum {
 enum {
 	MLX5_MKEY_MASK_LEN		= 1ull << 0,
 	MLX5_MKEY_MASK_PAGE_SIZE	= 1ull << 1,
+	MLX5_MKEY_MASK_XLT_OCT_SIZE     = 1ull << 2,
 	MLX5_MKEY_MASK_START_ADDR	= 1ull << 6,
 	MLX5_MKEY_MASK_PD		= 1ull << 7,
 	MLX5_MKEY_MASK_EN_RINVAL	= 1ull << 8,
@@ -787,7 +788,11 @@ struct mlx5_err_cqe {
 
 struct mlx5_cqe64 {
 	u8		tls_outer_l3_tunneled;
-	u8		rsvd0;
+	u8		rsvd16bit:4;
+	u8		nvmeotcp_zc:1;
+	u8		nvmeotcp_ddgst:1;
+	u8		nvmeotcp_resync:1;
+	u8		rsvd23bit:1;
 	__be16		wqe_id;
 	union {
 		struct {
@@ -836,6 +841,19 @@ struct mlx5_cqe64 {
 	u8		op_own;
 };
 
+struct mlx5e_cqe128 {
+	__be16 cclen;
+	__be16 hlen;
+	union {
+		__be32 resync_tcp_sn;
+		__be32 ccoff;
+	};
+	__be16 ccid;
+	__be16 rsvd8;
+	u8 rsvd12[52];
+	struct mlx5_cqe64 cqe64;
+};
+
 struct mlx5_mini_cqe8 {
 	union {
 		__be32 rx_hash_result;
@@ -871,6 +889,28 @@ enum {
 
 #define MLX5_MINI_CQE_ARRAY_SIZE 8
 
+static inline bool cqe_is_nvmeotcp_resync(struct mlx5_cqe64 *cqe)
+{
+	return cqe->nvmeotcp_resync;
+}
+
+static inline bool cqe_is_nvmeotcp_crcvalid(struct mlx5_cqe64 *cqe)
+{
+	return cqe->nvmeotcp_ddgst;
+}
+
+static inline bool cqe_is_nvmeotcp_zc(struct mlx5_cqe64 *cqe)
+{
+	return cqe->nvmeotcp_zc;
+}
+
+/* check if cqe is zc or crc or resync */
+static inline bool cqe_is_nvmeotcp(struct mlx5_cqe64 *cqe)
+{
+	return cqe_is_nvmeotcp_zc(cqe) || cqe_is_nvmeotcp_crcvalid(cqe) ||
+	       cqe_is_nvmeotcp_resync(cqe);
+}
+
 static inline u8 mlx5_get_cqe_format(struct mlx5_cqe64 *cqe)
 {
 	return (cqe->op_own >> 2) & 0x3;
@@ -1204,6 +1244,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_DEV_NVMEOTCP = 0x19,
 	MLX5_CAP_CRYPTO = 0x1a,
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_MACSEC = 0x1f,
@@ -1470,6 +1511,14 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_MACSEC(mdev, cap)\
 	MLX5_GET(macsec_cap, (mdev)->caps.hca[MLX5_CAP_MACSEC]->cur, cap)
 
+#define MLX5_CAP_DEV_NVMEOTCP(mdev, cap)\
+	MLX5_GET(nvmeotcp_cap, \
+		 (mdev)->caps.hca[MLX5_CAP_DEV_NVMEOTCP]->cur, cap)
+
+#define MLX5_CAP64_DEV_NVMEOTCP(mdev, cap)\
+	MLX5_GET64(nvmeotcp_cap, \
+		   (mdev)->caps.hca[MLX5_CAP_DEV_NVMEOTCP]->cur, cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 170df4fd60de..e28124ebbaba 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1474,7 +1474,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         event_cap[0x1];
 	u8         reserved_at_91[0x2];
 	u8         isolate_vl_tc_new[0x1];
-	u8         reserved_at_94[0x4];
+	u8         reserved_at_94[0x2];
+	u8         nvmeotcp[0x1];
+	u8         reserved_at_97[0x1];
 	u8         prio_tag_required[0x1];
 	u8         reserved_at_99[0x2];
 	u8         log_max_qp[0x5];
@@ -3373,7 +3375,20 @@ struct mlx5_ifc_shampo_cap_bits {
 	u8    reserved_at_20[0x3];
 	u8    shampo_max_log_headers_entry_size[0x5];
 	u8    reserved_at_28[0x18];
+	u8    reserved_at_40[0x7c0];
+};
+
+struct mlx5_ifc_nvmeotcp_cap_bits {
+	u8    zerocopy[0x1];
+	u8    crc_rx[0x1];
+	u8    crc_tx[0x1];
+	u8    reserved_at_3[0x15];
+	u8    version[0x8];
 
+	u8    reserved_at_20[0x13];
+	u8    log_max_nvmeotcp_tag_buffer_table[0x5];
+	u8    reserved_at_38[0x3];
+	u8    log_max_nvmeotcp_tag_buffer_size[0x5];
 	u8    reserved_at_40[0x7c0];
 };
 
@@ -3422,6 +3437,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	struct mlx5_ifc_macsec_cap_bits macsec_cap;
 	struct mlx5_ifc_crypto_cap_bits crypto_cap;
+	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3668,7 +3684,9 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         disp_type[0x4];
 	u8         tls_en[0x1];
-	u8         reserved_at_25[0x1b];
+	u8         nvmeotcp_zero_copy_en[0x1];
+	u8         nvmeotcp_crc_en[0x1];
+	u8         reserved_at_27[0x19];
 
 	u8         reserved_at_40[0x40];
 
@@ -3699,7 +3717,8 @@ struct mlx5_ifc_tirc_bits {
 
 	struct mlx5_ifc_rx_hash_field_select_bits rx_hash_field_selector_inner;
 
-	u8         reserved_at_2c0[0x4c0];
+	u8         nvmeotcp_tag_buffer_table_id[0x20];
+	u8         reserved_at_2e0[0x4a0];
 };
 
 enum {
@@ -11757,6 +11776,7 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT_ULL(0x21),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
@@ -11764,6 +11784,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 	MLX5_GENERAL_OBJECT_TYPES_MACSEC = 0x27,
 	MLX5_GENERAL_OBJECT_TYPES_INT_KEK = 0x47,
@@ -12129,6 +12150,20 @@ struct mlx5_ifc_query_sampler_obj_out_bits {
 	struct mlx5_ifc_sampler_obj_bits sampler_object;
 };
 
+struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits {
+	u8    modify_field_select[0x40];
+
+	u8    reserved_at_40[0x20];
+
+	u8    reserved_at_60[0x1b];
+	u8    log_tag_buffer_table_size[0x5];
+};
+
+struct mlx5_ifc_create_nvmeotcp_tag_buf_table_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits nvmeotcp_tag_buf_table_obj;
+};
+
 enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128 = 0x0,
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256 = 0x1,
@@ -12142,6 +12177,13 @@ enum {
 
 enum {
 	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_TLS               = 0x1,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP           = 0x2,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP_WITH_TLS  = 0x3,
+};
+
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR  = 0x0,
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_TARGET     = 0x1,
 };
 
 struct mlx5_ifc_transport_static_params_bits {
@@ -12164,7 +12206,20 @@ struct mlx5_ifc_transport_static_params_bits {
 	u8         reserved_at_100[0x8];
 	u8         dek_index[0x18];
 
-	u8         reserved_at_120[0xe0];
+	u8         reserved_at_120[0x14];
+
+	u8         cccid_ttag[0x1];
+	u8         ti[0x1];
+	u8         zero_copy_en[0x1];
+	u8         ddgst_offload_en[0x1];
+	u8         hdgst_offload_en[0x1];
+	u8         ddgst_en[0x1];
+	u8         hddgst_en[0x1];
+	u8         pda[0x5];
+
+	u8         nvme_resync_tcp_sn[0x20];
+
+	u8         reserved_at_160[0xa0];
 };
 
 struct mlx5_ifc_tls_progress_params_bits {
@@ -12403,4 +12458,15 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
 	struct mlx5_ifc_page_track_bits obj_context;
 };
 
+struct mlx5_ifc_nvmeotcp_progress_params_bits {
+	u8    next_pdu_tcp_sn[0x20];
+
+	u8    hw_resync_tcp_sn[0x20];
+
+	u8    pdu_tracker_state[0x2];
+	u8    offloading_state[0x2];
+	u8    reserved_at_44[0xc];
+	u8    cccid_ttag[0x10];
+};
+
 #endif /* MLX5_IFC_H */
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 4657d5c54abe..bda53b241d71 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -227,6 +227,7 @@ struct mlx5_wqe_ctrl_seg {
 #define MLX5_WQE_CTRL_OPCODE_MASK 0xff
 #define MLX5_WQE_CTRL_WQE_INDEX_MASK 0x00ffff00
 #define MLX5_WQE_CTRL_WQE_INDEX_SHIFT 8
+#define MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT 8
 
 enum {
 	MLX5_ETH_WQE_L3_INNER_CSUM      = 1 << 4,
-- 
2.31.1

