Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3EA66E273
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjAQPkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbjAQPij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:38:39 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92084347D
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:37:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYIIn7mSd166svUIShlBJmFosiqN5m/6wkk6y8w1mNyd5YDEcjyaBub1LVw+b2IizlYo0xM7+Iy+gZXGMuGkujTXRWPloTWoTUYQGvDUq+MIzhuP0eGz2MAdsd7TCzqCs0TJtOmppwu+5eAPBhipybpq876WggqSlCZqyHtqDWXLEmLO92olVWHqB2Furt8gwGeTVeyP3n1A8P9CTjfz4g1u1k72zQPqNlDWJScBKXoB7NEJT9AXgHF972wuv267m/ln8ZrK+VwbNpzMfasNKID4mFwhZQHIipbVq+JWpQJ2hZsHIl+kWlEw6EVj4+Npm7e7DeM4T9jae46TmS02mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4dxqBiAvSTIJXUS+rrgj5qdUxPKgNQoSreVgV4aro0I=;
 b=Z2VBC2bDl4SKYsqGgPYfHla7Q1TGaWaFyDu4N7qxUZ15dISbjb4DqyoiZpn77+42D4VOxwTq1Fm2KmyYjiSO14eY5nf/4tzRqY+0M1kDibJsmCPgj7+nbG+txgW9ifLRdCaQEEnmxHEeoiAAKUSLxVgiG1bGgA03UT0LAjYVpNGwmL3k8+N1SGnSAlLyiE9lIvLeM/ODWuMHo/KxoWKsPaE1C/ltNreAH7qjErI7BnfblqRNwghxDWn0wo8g9dAr4bDiXg3xfr/rf+ScWhgWv0UQifIgvrZsj5YmkjMLeobVRKxAGXCEGNBzMaD4WusfL/Ta552hmuyfHrrXSduBsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dxqBiAvSTIJXUS+rrgj5qdUxPKgNQoSreVgV4aro0I=;
 b=GlPJ0qspbq0/S89QNVbosGbgEUJJFmMgOASBVwNIKGyk5Jha8+ViuDLLTQIvGJQKZROhZlPeuGu2g/y3A+pAxkFs1g6lqVatzW5Q4Agvo2MdtyWK9m2Snwk01yg6nZBOF5bYWQ7VwnxY3d9jpcR+zzfrLtZkOogedDNPWt4Dnl4ueYrKKvEb7FVi75n7lcIrr1r1TxAnUQZ1qvFwpe9xxiztzMSJUD86WKKfP7Q83PcspfI41lULy2iOvR0XfMCSvBl7j4fVyxUwsSIHPxowPU19dqCrSS4uNWpD31BaY5+aa2FiMUv+x9SLr82OdXne32ZVvOAPM7tvaHpjPPMn4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH7PR12MB8177.namprd12.prod.outlook.com (2603:10b6:510:2b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 15:37:47 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%8]) with mapi id 15.20.6002.013; Tue, 17 Jan 2023
 15:37:46 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v9 17/25] net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
Date:   Tue, 17 Jan 2023 17:35:27 +0200
Message-Id: <20230117153535.1945554-18-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230117153535.1945554-1-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH7PR12MB8177:EE_
X-MS-Office365-Filtering-Correlation-Id: 601f06d5-7a84-4626-5a20-08daf8a0c846
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0aktN5icEJYeqpqsCpfJ1cNnI0xEj+bcpsLJlHBgX6h0ApduqEJeple+01GXbv3AzW0QxVu5fPFK8GzHfrQy05WYsWvi64XJr6694llxHtI5Mi7WPFc7QpHapCDqoAK62UaW1GWv2Qo93voYajZjFEVslgiS2CR4rGdB4babmclVOjN0KpBmg6ChQWUF5oOkmy44hCY2JScUNkcOygJShRfyWMut1Hg023p8m5tAzctjvbBB6S0k8m2eGv9310DtNrH9XO8AMxO3jBi6+tKzR/YyNlzFEurfmtdFa474gjzCDJCXzjHq6yH9t/GW+2SbJcNEgOylvoIwgqVdiyZ1xQrLVV5aLT9HU/UUQO2VW8RUZCg7mBRsSshUuFcYxiD09XOuMgt+ZQ+Z5aAP6uDVjL4DZ8rga5dL9AfilznCHPRqp5C3HMQktFhGtlztHJYnF3G11mDyiaQs+N/aeB9hcENA0N/FDFb0yDAtwumQ6Qa3rZ0Rn2Qxc/qaadEZbcMl0/hDhQ+5pInOC9jdWFKYuPY7DCgVPnliR289hnoeCGt9PhKjkKXLwkjo6WjWvyMrjIhN5MA55pVL5PPDCasiWoK066KtiRnjId1pUifL4Xv198l0i3BrUzPbRY2pKRS+qKOfC4OXM9pB1EFxe3dw7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(1076003)(186003)(6512007)(26005)(2906002)(86362001)(8676002)(66946007)(66476007)(8936002)(6486002)(66556008)(6506007)(38100700002)(6666004)(478600001)(36756003)(107886003)(5660300002)(54906003)(316002)(2616005)(41300700001)(4326008)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Wv665g4XvPyJolndAC0GJnQPs5Q1K99NG+gkrvfExQB43Lf+jQlqGrA3k6F?=
 =?us-ascii?Q?20GcOhhh8CplVCkccERDGUiMPlRWeicZ1hbIIrHE2sIJqoWR8x5AC3jNILXq?=
 =?us-ascii?Q?suIh2tdv+Mnzh7xsKKly1U+P+dqAvq7UP8TwtUxh9BDinTcQ7f9L3CA6lt5z?=
 =?us-ascii?Q?9lOMtTjlhoRlKproFWOqluuMJBOBByaLaTbjVMRQvnkAqt6wSt4Gwmb9wO23?=
 =?us-ascii?Q?EQ3DnPTLFWIkBRjEkf9S6u0QaVOgs9QRg55kyzoeAqwam2LinO7d/N2qrGrR?=
 =?us-ascii?Q?qfO1lNev/eQEYUswfrWcoxr7pv7BEjDnX9lF1AYkm0TqdfMmwv1Me1jJf3cV?=
 =?us-ascii?Q?VMbtpn+Bw8tiJxnhf1rUmztEsZlbD92JXVRi0Gr2reS8sQKMEZrnjGzgI1vc?=
 =?us-ascii?Q?vVbJFKQfjn0sZ7cWgs89OxDY4Q5ROTUrxkwZF9S/NB0J+SYROa3BSWIaa2ir?=
 =?us-ascii?Q?KsRAveM5SDikVBdmRdm/E8uZNTHTCuzPqzerSZ2iwea6pfiPYUFr/MLoV9NI?=
 =?us-ascii?Q?Xc2uiJ8xpF7BLrg5pr9zkW8wZ5SHpy8Aw+SORraGtig+fuEINIpdw39Hx1HL?=
 =?us-ascii?Q?1wpUx3nIC8uodimogrzTY9894NjG2oYzgsa3WOSsX+T2aOT1CdwiKeYOzBcv?=
 =?us-ascii?Q?atAqmIJPPm+Zq28RN1ju3hNVaXWvOrxvzFO7RN6nGhQ86MCOysyJsJw/88Sc?=
 =?us-ascii?Q?U9vwqlUwMOpQ4mQlDexvQG/MpeFkJRbPYx0Q84dgokBaJSSizKmexGPA1Y9y?=
 =?us-ascii?Q?prOEE4U/G9JlE2uK74BSvD3xiwcMg4CS6O6I3dvW6mvYFjnCS9KfcsXzbDZ4?=
 =?us-ascii?Q?+Qk4U9L5gYqULALrQ5HZ8PwS8ynkDs4CbQJMBYe2vurza1dOxSHQxKvLWjXw?=
 =?us-ascii?Q?xB7j+aqh4LAzGJdYLob7FfQuoR39oh89uVR9xCnqkIZwj7lQaNNxsSvnkZAZ?=
 =?us-ascii?Q?zQWKOMHUp1xJAuuwdz4SzxsYsHf83XnOj9ooWhyZ1C8oFsF+A8qMZzSYO7Wc?=
 =?us-ascii?Q?Cyl/gjjgf19WoZJ21y8IHmIP/y6/62lfPXPnRnAEUvnJOh2LIN/aDj6H/KXV?=
 =?us-ascii?Q?ABqrVJI9J+RFd0ykaBcYK0GiIZFEmXBtCUMlV68AM+x8Fpt0NB1J4IP7wsg5?=
 =?us-ascii?Q?Zj/ldhaUwwUhiYu/SXS0igo5PdMw/kdRhK2SAwBw/4cna+mkYGOxJBQn+6BL?=
 =?us-ascii?Q?GteqUOkrPjEbEaADYJ0i3MDzgGNMpELJLc0fIoKQtTHDPEcKWrIp4qKsNj+5?=
 =?us-ascii?Q?wi3EKsbij1xjEQ0DxbdBQDFUivKrAVidrORQCv9b02LIxfUKYIwyq0+ivYge?=
 =?us-ascii?Q?oksRoZOQ8Zx4h3a2rUp1mlhUwT+g733/lzbmYxDNEIjMU3eh8/uGjSWbVcgv?=
 =?us-ascii?Q?5+YtGlSZHkGkBaKFgw8H9xGJ1kabcI0bcUmMj6pW1jLhhV+GbnjDrWaxN2yU?=
 =?us-ascii?Q?7XvGVfjbAMe32jp6MVxiBeUxecoPMjUaGsakALCQJQ+v3VmHnMD/VqQCcmIT?=
 =?us-ascii?Q?09SOkCg2ekRkI42FPX68iGjPQdj4Zrv4hu32eBlUMPhPTZ+s08EooBnfG4iv?=
 =?us-ascii?Q?TZxCDTFjkXSobBtGtHO9RF3NbeX6tGPwoHSJ4yMh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 601f06d5-7a84-4626-5a20-08daf8a0c846
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 15:37:46.7199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tO6GTf2f770U1kyTN59xzroULyfkTD3cpiDI38YHfaj8KFjjf3jtYNyeuEQfHvQfgvis/HFnad7DfwAaeDhN4A==
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
index f34e758a2f1f..bfe540a4d588 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -286,6 +286,12 @@ int mlx5_query_hca_caps(struct mlx5_core_dev *dev)
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
index b50b15dbf3c1..8b13b0326fc1 100644
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
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_MACSEC = 0x1f,
 	MLX5_CAP_GENERAL_2 = 0x20,
@@ -1466,6 +1507,14 @@ enum mlx5_qcam_feature_groups {
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
index 72f0020fc448..403496e1485d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1449,7 +1449,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
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
@@ -3347,7 +3349,20 @@ struct mlx5_ifc_shampo_cap_bits {
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
 
@@ -3371,6 +3386,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	struct mlx5_ifc_macsec_cap_bits macsec_cap;
+	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3617,7 +3633,9 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         disp_type[0x4];
 	u8         tls_en[0x1];
-	u8         reserved_at_25[0x1b];
+	u8         nvmeotcp_zero_copy_en[0x1];
+	u8         nvmeotcp_crc_en[0x1];
+	u8         reserved_at_27[0x19];
 
 	u8         reserved_at_40[0x40];
 
@@ -3648,7 +3666,8 @@ struct mlx5_ifc_tirc_bits {
 
 	struct mlx5_ifc_rx_hash_field_select_bits rx_hash_field_selector_inner;
 
-	u8         reserved_at_2c0[0x4c0];
+	u8         nvmeotcp_tag_buffer_table_id[0x20];
+	u8         reserved_at_2e0[0x4a0];
 };
 
 enum {
@@ -11691,6 +11710,7 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT_ULL(0x21),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
@@ -11698,6 +11718,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 	MLX5_GENERAL_OBJECT_TYPES_MACSEC = 0x27,
 };
@@ -11988,6 +12009,20 @@ struct mlx5_ifc_query_sampler_obj_out_bits {
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
@@ -12001,6 +12036,13 @@ enum {
 
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
@@ -12023,7 +12065,20 @@ struct mlx5_ifc_transport_static_params_bits {
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
@@ -12262,4 +12317,15 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
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

