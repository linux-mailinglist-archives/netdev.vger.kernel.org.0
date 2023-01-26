Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7547067D149
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbjAZQY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjAZQYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:24:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DAB9005
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:24:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/pGLwCgbBrAaUqz1tck7b+uzCU84Jobhm7TxtI2DT9vxVcxlg0T2tQMGitwn3NYYTNn/D+kvD/B2ETdfLZWYMMnH6lZvyGCBOvYOZcmEIdN8ggoYPl31u4508HcQ6yVCHf2AUljVfR9kEZnVjPZFFsfWNyYc2YmZRGUwuyi40oKrrsjp3eqoWCQm8x5CoSQl8NazE3cK+02LJezKpe9JGGFUd0MfvxzsyqFyNComHyiAWGanWpyXVG9+/wEFusXKhNbiLBDB/QZPmFlUkRu6IV/XYlvYGiCHGsMre7tt5393Y/3IidsYfTZ/9iADbqWxHjWqaYDmDomSFof62ovYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmC59952O+41rOuhFaIa1Dy0cDuJGcWWgFKYzClmYJM=;
 b=C4y4RhKvSKutHXemrSnipoRfhRsAIdHsYxGq68grxvJcSC3aRcK2c37/z7ZbUTL2nIzp8dP/dg0YaBRVF+1OqygULhspmuBerj4a40UERmu2hVvRC+dLpgd76+rr1YL+PeDTZ9Vn7q+cg3CbrG6Ar0gSJfO6eG2gaSlXe/gKrtv0j7SvJ9ZYgGrTUZ1LPZLsmV6Rz1A6X2aXGakjk+ixSoaU0zQisU67j3MMYXbis8CPpqDNQUSW8Y+BHmMdTnx/s5LwzWFuxzOpTdbfq3Ws6434y4aA98UTgDRTBNdaqUGUXmMErkxVWy2vtY3+xzYRf4gtOp+IX6FKdaqmrRmfDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmC59952O+41rOuhFaIa1Dy0cDuJGcWWgFKYzClmYJM=;
 b=ZL0qUY9+Ax6aeHaoMRPcq1DxKfd+532ID2MA8skHLTtmsv3xZ/r8A6QfkHluqPgxkgOf8aRYPTI7iLkKEeYFBQBWzuaWdoVGXiY/eduHmzUIzuEoi5prPZpU/+q2Eme16KmonnO30l67o5BbTua8UBr3IipV/377HPdMW1fFsMZG6hsiugFJ5JYgIcMICF/ZUf8htyZTN5+al5kK+zBr9C6BzpFBmwxjBXZ+1yYFuBOGzThrPHsEMcXjNuTS/Wdt9fn8NxrSwuCalC6FlCFquVwW1IXYYoxf4gwMzIckA3biLg2ia1FlC+UFNFkTFnZC148nylS6IirCXbfBtLMKLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CY5PR12MB6180.namprd12.prod.outlook.com (2603:10b6:930:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:23:33 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:23:33 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 17/25] net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
Date:   Thu, 26 Jan 2023 18:21:28 +0200
Message-Id: <20230126162136.13003-18-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::14) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: ce7ed2ec-46da-4ea9-5e2f-08daffb9aaeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oZPWuh6bl2lMZqD42Otabew8Q7OM5Omi7zXYct2MGJNwap2wTnE9uGgtDvi0wLXrNZjOtK4K1H/n+c8S+vZklx5xS26pI0x/xUjgd/DlTZXHZqdvU1aXqvCCw3UX3fDiISKNZjv2FlwvMgTHsY0s52Gfee13tycqQjeAX99ragRpzhF+UBkJgFNfjxp9fH2LQ9z+gG6RD9UplpH5A2LF/q1o6xKp2rk/kJnUYHVpGSOnRh1jC6pT65HyYUPJvtxUViS8g0vvXndn6EaBn9a4kXTbMFk3+f5aPWxgH1NGLUMblPb9k8jWHylwHEHeOi4ZbmQi+w7Aq1D427QrIO2dJPyNF6qxj8gS8cvxZfe0aDx3jQTFQycvj/kaoazDxskzgYU9hX/P1B/45RaIrsrwQh15llY1d4XkzDx79xton7sFqdDe9u93ToSESfF0cKYbaKckTRVZycHtf3hugU4iSdoRPVI5p9SAAfvd+TRVU/mAl6UMc9J4y3nbILos/gXlpQQHH+748689tZUFayCfs8+v5fgXhQQyUXP830pqOmKcX8937fpocQ0tLeksz2q/ibiSfP+7vsb/kKakVXD99kejpCk6jioknxCRHlqV84oG1lJoq8nwBxhPI2LiAv4kdFAQyYWVgAZWXOFszxEH2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199018)(36756003)(8676002)(316002)(478600001)(6666004)(107886003)(1076003)(6506007)(6486002)(5660300002)(7416002)(66946007)(2906002)(4326008)(66556008)(66476007)(8936002)(41300700001)(38100700002)(6512007)(26005)(2616005)(83380400001)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NVhb0OyB/1KB8nXZKIx8XWo0Lc84OfkSt03OLLvBhQxTtFhB+tpMzuDxABwS?=
 =?us-ascii?Q?rGRggL9x+CopDa41SJ3IEUPCantrN8vGLifNH4aUa12U8yZ5Ih3yqY5obx8/?=
 =?us-ascii?Q?FJvR2KkjKs2bQGqSV6chIEErkDH35kUemZaylXSB3X5YzNbdfgggC60P9W9P?=
 =?us-ascii?Q?8iUhHOzTZoPoAgrYPnx/GIO0H1OtZcZO93d0Cchi+xDSLKtqbZfmsLrydWB7?=
 =?us-ascii?Q?/b730NZc5nPjeiUTgb/MQJWK8i+UDrSHYq8K43an7l9G4/HduVo/A1qDxaQv?=
 =?us-ascii?Q?RP6mdBik+TuaVHUkOdCuJtkNExPbgKi2BmHwdM33S8NyiItD12Ij7mEZuHUd?=
 =?us-ascii?Q?X/iPZQZkPLnuGcFjfM4S1uHnONiWGdSxnqkcsrMcNyrG47/wsnS+iAyo1Vj8?=
 =?us-ascii?Q?3TDbKTS1l1euWnzQrXGU+4nHvUgqPHQsOJ0jLnDBUDHH8ax2oA/dJ3FjsJzs?=
 =?us-ascii?Q?N4xMHC6l8YwEgI5kV6oGA6UDC9OjgZJvjwBjxgDbnIGpa2OJ2SrrkLMZUIvS?=
 =?us-ascii?Q?ESxVjLPykdgcS+hhbn/jts3cVnojKckl74LB+oQJ0frvcBTLoyBtpPJmswWM?=
 =?us-ascii?Q?jVyW5pX+5zDRFUJBibVpgdhiEe7Bj8Pp62FEvQyYwQ9C6hKpHnyjxH585MmR?=
 =?us-ascii?Q?6cCPTwiy25XNVgj5sJo4o1bKi1B+C3r3TkS0/ws/cSItc32MhuL8G9+J6MWm?=
 =?us-ascii?Q?EzFeBkaPhq40BV541Cql4BwMGV95H8I39elmqIo1B0hjncbhso4TWQHq8CZ7?=
 =?us-ascii?Q?xQWHYWSHvga4VcjNoCf4nOXalXgL2aTqK9bq6Nl12lj5RvFglcKPxBB3Kvgm?=
 =?us-ascii?Q?rNST48QeUwTT9ivDjrWa9VbxCFsa07wrZlJ/N4j0Z7Zo+v/Qhr17UWLT237b?=
 =?us-ascii?Q?Cu0poJK+1LgJrhvhTD/qkoW55tYlKJSSGTDsNrlrNx1RE3pttx52Lf21vZ4r?=
 =?us-ascii?Q?AcfEYVDbRq5qiCos65JWj8VfyVglqx7b/g/PIWyzsCKXfc0gH256BavlcU01?=
 =?us-ascii?Q?GK6NrVFrZ5QbwK03Xvk9dmQdfU4DA0KhYj3nYH7FLa1Ag0GZefOy0GKSqLJu?=
 =?us-ascii?Q?3MfdZqNCZyQuJvC6BGqlhv6Brd0r/295/JZRSG0Oj6rFdqyryvrnct6zsjmq?=
 =?us-ascii?Q?stXnnapfM+703PwxT88ov/4NwBbx0Knscfyz2Irb4gTY0SA75hpytg5YCGDd?=
 =?us-ascii?Q?nLYw/HZ483HbIKzxpVP1rB7veL0xTq09Q+gsjws8Y4fkyBIqDzCQaTfCIO5a?=
 =?us-ascii?Q?hQGHGIsaDnqX6xZFY3UtUcVEQ7JpeYoaTgkEW4x5vM3hRyQ79ObPA33T94Iy?=
 =?us-ascii?Q?B3f0Sh79AjNde+FbbzfgTrQRkM0XxCuxcJpnRhoYK/xje5d3cj33mrsjJzqx?=
 =?us-ascii?Q?pzPw+5LgGOHx70cZe6sMzrWVFF9rNm5yaVfuFyo4AWwTvO5nNwhKIh8vigFZ?=
 =?us-ascii?Q?RDnBtUkyvjsjlDiBh5d1CEFIY1+QmUxOFkDWQRnwXTJ8cR8oppKkEKH76EP6?=
 =?us-ascii?Q?oj83l9PL3O+6BdcYcnQftrlwOXBVbVDSPWHrrBRw8Vly3dD0SEZhHSSFI+BV?=
 =?us-ascii?Q?DJVpc236YHHKfY8Hw/ST1F8ESPHkah9mu7ViYjuM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce7ed2ec-46da-4ea9-5e2f-08daffb9aaeb
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:23:32.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvrZRb6vGIXotSSWwAIB378faSaC0i9eRZ/cqoSCEgvNc3yTGnrrRPAcjHbozgC6+ExRf4+GvVKoX16FAxxrbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6180
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
index 33e09dcb2b1a..19b19a4a5764 100644
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
@@ -11693,6 +11712,7 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT_ULL(0x21),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
@@ -11700,6 +11720,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 	MLX5_GENERAL_OBJECT_TYPES_MACSEC = 0x27,
 };
@@ -11990,6 +12011,20 @@ struct mlx5_ifc_query_sampler_obj_out_bits {
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
@@ -12003,6 +12038,13 @@ enum {
 
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
@@ -12025,7 +12067,20 @@ struct mlx5_ifc_transport_static_params_bits {
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
@@ -12264,4 +12319,15 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
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

