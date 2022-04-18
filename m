Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E9B504CDD
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbiDRGrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbiDRGrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:11 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2083.outbound.protection.outlook.com [40.107.100.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1883C19002
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSj3BPUcl9aQYezPWdlZ/DlpfhVIryaYU0H6y+QHOXmJK97BjD5dwt34zf0ULWB2qko+NAwINwBu+CpXbBG2JkhXFOAcJ3Rbzvi9kNJEBZH/kOpdaCXdafY0y11VCspfGAWyAdD6cGCT1IRMxzbmv6zlDnsXONdqsK16WrSLbH8OLU4BswIzRoEyMW7Sr78pGcdjf1XpYIDblPMEUDqZp24hezE5F+5+BZFcJe38nZ633qfhy2dWKLYlFOyfmfXq+7PyrgFGil+cLoLVf54MlO6//wtPpuQVjP0xSeF6X3ydOnVr70WGJ4I0iQroITG+QVtytfLpeF1OL17O4lyzDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBOTwVEcpyLK2TsK1FFPzIEC61cnikcClOu+m+h6hog=;
 b=Kj31pAB/aLEOKTHUQWjB+J7G6E3DarozNPKsjDcGT6ppwPPlAl6uAg915+yxnhCCcIGPvtEwScUJfBl4PMb/m0Dr5uTVNa+KJ5evCWdoTMkNNtpIgFlRGwHTroTnj0XWlYVQRJfosrb68NSBUTPw3ftme7ze5D/bCzNamsPQx4xtabgQfnzllo7K3eb4JqwnErZ7l9diBqY8UkcekpeLNKDbbegt2ReGttoBiUiNM4bnwoh3c2pBIj6eIjUTIIruYL19WgJ3AZUxz5d+mmTd+8/SqqKoeh5GVmzXqqqn0QMCLPSd6CFI+5XvZU1KvqHydDYReaJwxLC3XSNvaufC7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBOTwVEcpyLK2TsK1FFPzIEC61cnikcClOu+m+h6hog=;
 b=ksOp3FSfLMCMKZVR9m/e73JHGvf44T14bX+RbHlIT9CZq9Cl8kkNEAhlrHflaB4xpEQs1Rp4/Iq/twDGmoZnRI+l3MqxDt69jCNuypOe27L9Lmfua8MsJbqG+UDqYk7Ff5YZg5EgXsH5eeVZVAamT/143hXzKJJZHgGOjlaHhlVvwViXadHsCTuBQYeyiPQmRbnWacvqP4elMSAwLSP/vYp4QubtuZxvGkr//h9KlbEvCQnmBgWqNgC1yUHb4zW8gnTZX7kH02gcmGPrgsr6DYncHE6jCUa2k/O1nC2k1ud3OYOFY8ueCRPH+l/q2EwwiGCwyFLVz5flmGwUiQvaWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:31 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:31 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/17] mlxsw: reg: Add Management Binary Code Transfer Register
Date:   Mon, 18 Apr 2022 09:42:36 +0300
Message-Id: <20220418064241.2925668-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0332.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::13) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1cfe445-ea23-4181-d6a3-08da2106e48a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3664443FCE8140F28618FF10B2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 97YIdGLFuw0EupFylS1NhFnQIcQyYs0WoM7xS7HZwtX9GuUdX64fLNP3ELbl+NwG3BPs9wCDH1YVKyVglez5h/8dbfCZC5fdfiXXdUAAgWYrTxVedGErspN19MDg4pPstQblPvgQXYv1nvNPjruQ7PbdSJwfJkeMzwaZeWYPTP2sms038Fm9GcWfvc2I6p9hITkI1Tzxc5wn8y+lXspgyim01iNJp+tTM8pf5uZYNe4iqLZfH/Alzs/RPhEOaN9E9rnVlIsTBR6PgmknZEeI55aeJ2Wk7rCNjnN3rZBBZwXLvH6qWb2xtIFqabYUELQ3K8d4pmCuShxEGvmSkThjlVa5lfKyJClIs8CWG8gU8zBT4FpfO+WGeqt0F3LY7T4ybiZ7LcMuAL6+g0BTDNtGUZDq9deRP9fEw+1yJV1YqgqfLsnaKfRb5FS4ZGTYDa5kSeipLM+j34QAyGapGYpicRVhOkzlUee6Oa5jQ50bC0VMyhVC5MTikj7LF4B5daF0G8nFUEyVRowjzERozGDrHEehugylG+2drKA4sYfEY/hIyRTRjO/30K3pzTUejI2ajrVDjw6S9paloiJxlukgzrIzG1wSBn53KqaJqWX2URFsRS6W/FyDF+ZzeDZNCnHTZgMoNQYinPeN0evHFziDnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ReYE5qWOW5s5K6oAczo2cYSNHe7+9BLU6+eu7dukZWboUDbdYjIpW2M/W6j7?=
 =?us-ascii?Q?Xy4d1CjumuGtwYnA/mJh2L78lul+7hKr+UezglYxGaHqg8G4tEzuSHFBM3BL?=
 =?us-ascii?Q?I3EW5eserHKNCYsC9ydGNMFeyMZkv9yn6n0weIznTQQrxhJXiSOLV5gUQW3W?=
 =?us-ascii?Q?xHM6yNQZxg/QMZ4OSCaFADiHdLalI36MjFwT1kZE9pgfetp7G8dnAyU6mFPb?=
 =?us-ascii?Q?bWWIeBlYpFr0U69Wjh7fhDA89HoLs0bW4rHuoPFYhZDeerhs96/S5+jSz4n5?=
 =?us-ascii?Q?20eKj9S/FOwXujgnZOlMHMaSYxR4aeXUJRnnv6mPTewYIhXIPvYuPQFhUsr1?=
 =?us-ascii?Q?vtbymtHNjt7rl+hTdY9bx5Hk2CtMDn8SRU4fdXulyI/qc4plkezUytV6QwNK?=
 =?us-ascii?Q?SXcUHhi6fHVxx3dPhutpYM2SRf26hTzPx7kBNmY8ZxAJzVKTSfnda71Mx41o?=
 =?us-ascii?Q?H4TzaBuyOVy0Ob9APGgIiqn4J/kyJcYp0HzjQYdFD2jzf2y8yQBEVB6HZCze?=
 =?us-ascii?Q?/wFeW2MW02MuWJIL2BHj/JMA3AFha3W2gpdx/HY+0MxprMeoWexNm+R5/0w1?=
 =?us-ascii?Q?qcPJrCUKFLkk29JonqC7zH8MNvip9ExrAFJEvoPyCK0bGP3ZfblRbk0NmtG2?=
 =?us-ascii?Q?WI8wq1ZzpDrPzJ9xisRx2WAQE7wz2AW1j1NkNaGm/rfLfRad/HNfJhdE/hG3?=
 =?us-ascii?Q?1zhV4UiwywmJsxPGUE9kiyg2QkbCA0fFdB4WGXIcVuxemDilZk+x08UlrLp/?=
 =?us-ascii?Q?3BaZfaEZ8NRNMiJ4nm8pxyX0MaaaPmntbQZe+9PhfpD6HaaMc4igLT6r30qz?=
 =?us-ascii?Q?6owaoF+19ngcrcF17QVEmyiY9p8/h7fLTdnS6ROtx/TR+hWBaycaOf+nt/sN?=
 =?us-ascii?Q?iFnm40DTEaGMf3/XvILLgzajyzWqtFUbyBm688zU5Yqz2HDS6HzGHYRhELXl?=
 =?us-ascii?Q?8PqQZPk1xED2eZVUzMm+lKS0ZlzvNEx/5QdE6gypMI7BAaWztsyuLMUorgFv?=
 =?us-ascii?Q?RMv9ix+b7pBTJz+xn638p2MynHfGCWF0RBDMg/GGEx2BP5vTHyU5WGxJeRLQ?=
 =?us-ascii?Q?KCQggIbf/sP/K5UxtF8X4vHlDOBNIM6RQIvBX6Iz4nDuGVaZqut+yo38k9pe?=
 =?us-ascii?Q?gjXvT3svUUDM4n9yIK7yA84EucSqXwS7S+7sI4sV27CV03S3sfi0Pty1ajUc?=
 =?us-ascii?Q?VQ7cfxcWtIesRRWn7dNG00CvMwGRNRErOVX9MFDzSyjGDR2kpHqF8wZTM5EU?=
 =?us-ascii?Q?KKVUBax4pkPpzTIuiwrhFc0tAtpja7BoSSw4awx+fY+4CRStJch+Z60RuKjd?=
 =?us-ascii?Q?PrVOtfnz71ZBDDfnrgsrpKNwz+1JEylFl22Aq+GvvRdLsJ2eWNvx/yyKHm+f?=
 =?us-ascii?Q?HEXq2RB8zrKtMtAJXKhCEgiB5O7wHaM7gzcgPWxe5Kpu7Woug40vNpbdsFEi?=
 =?us-ascii?Q?ayUETL8EOOtSPrAM66ohH3VqHJ9/5yfO/HEN5FOUCmJOtmAeTaGFPD9lEOOp?=
 =?us-ascii?Q?Ihk5z4BjayIdzpzbknlS9uBCJJcAuksBKm2yIoyFSwcMZSvia5/GrwNBXgK4?=
 =?us-ascii?Q?6OrFZFWzLDehXAzLMvoBOnsYHvHBfmYjH+K5KdSDF3iyiHw1nte84YYaOjd/?=
 =?us-ascii?Q?ckABrtRWuw9ybvVwrUpk0H8y3Kr5ouifA3Xd5Pk93P/KaNJWw/sBvzcXQAjq?=
 =?us-ascii?Q?Ei6mIERsk32oYa9p4PICOHSbnLSZ76GWPe66l4ToS+HfMuvcJd+id6MiInVP?=
 =?us-ascii?Q?uk2gEavg+g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cfe445-ea23-4181-d6a3-08da2106e48a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:31.5264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sq0qDl6v2Inoc333tfVknt90D36X/thzUxwBhygYH/uV14k+Nz566+3YO/4xe6OGvsuXlVt9emPJMyH4xvGCIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The MBCT register allows to transfer binary INI codes from the host to
the management FW by transferring it by chunks of maximum 1KB.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 122 ++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 31a91de61537..e41451028478 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11492,6 +11492,127 @@ mlxsw_reg_mgpir_unpack(char *payload, u8 *num_of_devices,
 		*num_of_slots = mlxsw_reg_mgpir_num_of_slots_get(payload);
 }
 
+/* MBCT - Management Binary Code Transfer Register
+ * -----------------------------------------------
+ * This register allows to transfer binary codes from the host to
+ * the management FW by transferring it by chunks of maximum 1KB.
+ */
+#define MLXSW_REG_MBCT_ID 0x9120
+#define MLXSW_REG_MBCT_LEN 0x420
+
+MLXSW_REG_DEFINE(mbct, MLXSW_REG_MBCT_ID, MLXSW_REG_MBCT_LEN);
+
+/* reg_mbct_slot_index
+ * Slot index. 0 is reserved.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mbct, slot_index, 0x00, 0, 4);
+
+/* reg_mbct_data_size
+ * Actual data field size in bytes for the current data transfer.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mbct, data_size, 0x04, 0, 11);
+
+enum mlxsw_reg_mbct_op {
+	MLXSW_REG_MBCT_OP_ERASE_INI_IMAGE = 1,
+	MLXSW_REG_MBCT_OP_DATA_TRANSFER, /* Download */
+	MLXSW_REG_MBCT_OP_ACTIVATE,
+	MLXSW_REG_MBCT_OP_CLEAR_ERRORS = 6,
+	MLXSW_REG_MBCT_OP_QUERY_STATUS,
+};
+
+/* reg_mbct_op
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mbct, op, 0x08, 28, 4);
+
+/* reg_mbct_last
+ * Indicates that the current data field is the last chunk of the INI.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mbct, last, 0x08, 26, 1);
+
+/* reg_mbct_oee
+ * Opcode Event Enable. When set a BCTOE event will be sent once the opcode
+ * was executed and the fsm_state has changed.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mbct, oee, 0x08, 25, 1);
+
+enum mlxsw_reg_mbct_status {
+	/* Partial data transfer completed successfully and ready for next
+	 * data transfer.
+	 */
+	MLXSW_REG_MBCT_STATUS_PART_DATA = 2,
+	MLXSW_REG_MBCT_STATUS_LAST_DATA,
+	MLXSW_REG_MBCT_STATUS_ERASE_COMPLETE,
+	/* Error - trying to erase INI while it being used. */
+	MLXSW_REG_MBCT_STATUS_ERROR_INI_IN_USE,
+	/* Last data transfer completed, applying magic pattern. */
+	MLXSW_REG_MBCT_STATUS_ERASE_FAILED = 7,
+	MLXSW_REG_MBCT_STATUS_INI_ERROR,
+	MLXSW_REG_MBCT_STATUS_ACTIVATION_FAILED,
+	MLXSW_REG_MBCT_STATUS_ILLEGAL_OPERATION = 11,
+};
+
+/* reg_mbct_status
+ * Status.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mbct, status, 0x0C, 24, 5);
+
+enum mlxsw_reg_mbct_fsm_state {
+	MLXSW_REG_MBCT_FSM_STATE_INI_IN_USE = 5,
+	MLXSW_REG_MBCT_FSM_STATE_ERROR,
+};
+
+/* reg_mbct_fsm_state
+ * FSM state.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mbct, fsm_state,  0x0C, 16, 4);
+
+#define MLXSW_REG_MBCT_DATA_LEN 1024
+
+/* reg_mbct_data
+ * Up to 1KB of data.
+ * Access: WO
+ */
+MLXSW_ITEM_BUF(reg, mbct, data, 0x20, MLXSW_REG_MBCT_DATA_LEN);
+
+static inline void mlxsw_reg_mbct_pack(char *payload, u8 slot_index,
+				       enum mlxsw_reg_mbct_op op, bool oee)
+{
+	MLXSW_REG_ZERO(mbct, payload);
+	mlxsw_reg_mbct_slot_index_set(payload, slot_index);
+	mlxsw_reg_mbct_op_set(payload, op);
+	mlxsw_reg_mbct_oee_set(payload, oee);
+}
+
+static inline void mlxsw_reg_mbct_dt_pack(char *payload,
+					  u16 data_size, bool last,
+					  const char *data)
+{
+	if (WARN_ON(data_size > MLXSW_REG_MBCT_DATA_LEN))
+		return;
+	mlxsw_reg_mbct_data_size_set(payload, data_size);
+	mlxsw_reg_mbct_last_set(payload, last);
+	mlxsw_reg_mbct_data_memcpy_to(payload, data);
+}
+
+static inline void
+mlxsw_reg_mbct_unpack(const char *payload, u8 *p_slot_index,
+		      enum mlxsw_reg_mbct_status *p_status,
+		      enum mlxsw_reg_mbct_fsm_state *p_fsm_state)
+{
+	if (p_slot_index)
+		*p_slot_index = mlxsw_reg_mbct_slot_index_get(payload);
+	*p_status = mlxsw_reg_mbct_status_get(payload);
+	if (p_fsm_state)
+		*p_fsm_state = mlxsw_reg_mbct_fsm_state_get(payload);
+}
+
 /* MDDQ - Management DownStream Device Query Register
  * --------------------------------------------------
  * This register allows to query the DownStream device properties. The desired
@@ -12990,6 +13111,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mtptpt),
 	MLXSW_REG(mfgd),
 	MLXSW_REG(mgpir),
+	MLXSW_REG(mbct),
 	MLXSW_REG(mddq),
 	MLXSW_REG(mddc),
 	MLXSW_REG(mfde),
-- 
2.33.1

