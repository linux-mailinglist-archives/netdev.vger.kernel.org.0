Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DB3605C25
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 12:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbiJTKWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 06:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiJTKVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 06:21:08 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCB41DB89C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 03:20:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IcWyvNzL6rRkyHUh0MqfFM/QoWYoHSGiKU2DKXPzDG0t35VSGf0xYo1Q60SX6A6F/Kqf06A4FRspFdrIm/JwZOHoZr9Pa+CJxtyJ5JQpTyDGSA6NpaYNPw0RmwhDv+OXimu58L6acmC2otGKPOWvXxwdmlk9dLc8AIjYgB2OTa611LJe/x7ymAfw5piK3x40+EAsKSNDay8G4EcBR0rbcOXtym6AEgDzIQVDqhwIDddmX6b0E/22tzSc0ckdh6ZjOhGl2NgbxqU3/sK7IRP1ro1MvGb50NYUM0q4hCbeEgbAIlWFMeWPTXoHJKkMizUqEvOxEFWAG3Smrv/lCHh3RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84pUeUQf2I8nzHWv/zV1XEKN6qXTsF35P7Bf3dJWMCw=;
 b=SFCR/h7zUp/wMKkfVSnE8NSX84Pbg/vADyZJQx1q92/6zS2E0SqM9n2XYqRBSlPxAWUKnlLj7XzDnf4tsWzU4XZaTn7f9r27oYWSFmFFC1bqG0s2HBl9WLnBKz5KS/H6/c3mnH/nlakslFiIJHszS+s0wrH4GfLbWQzX8FkSUnfLs0CBgI/uoGAZuFWqi5HKfmasYAvaMAAPJPOZGj2LzboVhCBr1/AkS3lCbd1F8j4vrw1z4yfIn3emRPJU7G5/9y/gPFUNbCK1Ekr0ASwZYUIZ81PBn3BzB4SagoYsQgkmIdTGdE/qqWpTyFKPeft2DZFtKOaFRNwHlWiENkrggQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84pUeUQf2I8nzHWv/zV1XEKN6qXTsF35P7Bf3dJWMCw=;
 b=U/TPrKY/cg/NwRRgLLPWg33im2a14WKNvRgmda+e1g3Y9LbPGn49EqiB6gdnXN0L7tYp/UD7D0T0MMBKC7UrM6dpfXDycCF9jvZ0nZSzwq/XO1+2WCnxKenaAH9fToKjwEze8yEuxDRXB/OinhOpgpfeP+JPJjp7IHVu4YXr6GMaHkz30xs5qmnZrqPwYysOM7IvJnmK60aLYM8kLPM9GqNy6LB1vPbTjpVU9b+vXT78ifRqsNg730oz4nIoGCApklM9FC3Bt3UTrzxMEp8UBrHsIscXt67qPELZzkJaJBRRRl7Equb/PWRR2+5e3ob9sE/1Nl1VJjMQtVVw2MD9tw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Thu, 20 Oct
 2022 10:20:17 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 10:20:16 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v6 15/23] net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
Date:   Thu, 20 Oct 2022 13:18:30 +0300
Message-Id: <20221020101838.2712846-16-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221020101838.2712846-1-aaptel@nvidia.com>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0264.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::15) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5133:EE_
X-MS-Office365-Filtering-Correlation-Id: 7951f820-97a8-4e51-4863-08dab284af07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NDeaAtnCdyXddJy7orY3+CvnKKxU1+Q1gYHqcHKpeqNpPgjE4dO4bPZSMnsqWnk3j8GG4IhMnrEVKIY0Kv2ULKEgxJNeA9JAkX8+PKINcvzx+To6N/9gnp2f0jrha0WF3yG/tg+QDgIfffsoxyg96lGv7ChpunJ5+bFH636tBv6vM9NAuUgON1mDCxCK7iSAStwv/0YvdKfrFF89u7gnl5IVLM+oprc7xdF8dsWq1FAxhlEJ7jVquAEkhGVarU/4v0KHwHllGpMbR9oDWBLesRJUihVTvq8LLNmKA3RTCSyJs0YdoNTMuskH2tQL+LWE30SScXE/dBYBLaIyrV3/VD/YIefeTFHJ4v29RT5VdQRpbiob4+kgRVtGQtz1YgUBSv/SDqgecV8leTegpvgdz29T/ehSZ3heWeCMBNeZ8ICjypYRsusKjJd+iwyW4lYGuBA/FWwcvtzd3VUi3gFXW5ekx8YaPNqgP8IxHt4SODNUenG1hdcCmXIeYhFb4SvZGcSnhWz47tLIyw9cqZLyqgBtkF/40K6YLylsyWR6UYeCi0gVtejXZgc6Wr9OK0B9E0duNcVCL1c1JSoCg+FU26Dj1/Gn/wr2LmNvV2gBymRiT2HsEqf2XaliLYTAz5z4AS1/QipNDenVGWyBVdzu3mGdWYtPcFVIl+ZKQvjJGAxn8mSJQiWCodKad/+iizrIFwzm37IwGsZ+zh25X+9FUNJ0vs1/DTta+Z1fpiYmd3PqnebDq0xU4LWzPzU3XPtn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(6506007)(6512007)(26005)(4326008)(86362001)(2906002)(921005)(8936002)(7416002)(5660300002)(36756003)(41300700001)(66476007)(8676002)(66556008)(38100700002)(83380400001)(66946007)(316002)(6486002)(6636002)(186003)(2616005)(1076003)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JPrzKk8J4544E3J6931TOvmyBgYE5gmP2wkHhfn2jqxpUD0JH26lGIZ10ZdP?=
 =?us-ascii?Q?yYhrVxTtzM/2jSrAb38oRgm21Z9WAchjJx1oyP3e0ZvEAtgc3pLslQfzNjDB?=
 =?us-ascii?Q?j2otsc8rgN4WBjSieigKrUaz3CZV+2r68RiYgrOoFY2hMRBtsVWJ5pNg4731?=
 =?us-ascii?Q?BrubSOod0WuEOLRgrngiYWXXeqzM510XAbWyheQn1F+/ztf5vPnEutTuPEG3?=
 =?us-ascii?Q?EFmY6NaYX1kool2JJ4Mr/XDmCwJYlZ2ndMfaf58Hz/mVjW5vA4oI3JbupqIH?=
 =?us-ascii?Q?mN8iVUzQETyinkzY+LmsgV6HrBInf63C4GklMOCTlhC3uEBc7LKy1gtqzIUH?=
 =?us-ascii?Q?OPiV0wlLAVaXYfFz7cNBAQOxKGZW6JoyddFE8v7Gm7kAymCtAgRyBgHvhzKw?=
 =?us-ascii?Q?7trsanjbJcyY5IBR7EZm3ZXWuekPh0omxR3fePJnW8futflJy57bqZV7bjuF?=
 =?us-ascii?Q?J6ucdYb/1Llk+1QJ75qjVTTLNQrgC3eqH/w/CTJw9/XgdLlGX3TPZSyuAF0C?=
 =?us-ascii?Q?wO/0xy421X4FIJSQ8oYg8kNqR+uu9qy1EbFcrvara6TePk3AGg44CbvFTtJM?=
 =?us-ascii?Q?ivMoZRIeoA5LQuFREJydlXUsH1dx6vgsJmVp0eRZUHRmBSxkOqsCeOjKDyvn?=
 =?us-ascii?Q?74DDXylO3R/ixtOymIc3vnXb/k7wvet1ukbLpBViZzqlRsXFM1bP6E1R29oA?=
 =?us-ascii?Q?9KdGLKic//P7wXElC+snTAaVqP7wUymwHY0sUUjFON/cUY2GT6ckoPF85URd?=
 =?us-ascii?Q?S3WumNWrEAdIbtqpd0K36X3YMVuala3xr4zCbrfIy4kdcHD5ESXMNTyzA3a7?=
 =?us-ascii?Q?oz2PJ87PXJaLlHOSJmLMEY03qGsD2AmJxZzGID4XABYMOtKF4QhnfxDdXix7?=
 =?us-ascii?Q?ZNbIV4pWjLl8tGRbQc1DsejFmVbibUDDftftItilquVxz3kKZhSp/930CZ07?=
 =?us-ascii?Q?oFGW7B6jjYszzcm8+D0VoMY1P+1Tv09yMbeh5FeXtUzFqpbZzt2crAPF5VgL?=
 =?us-ascii?Q?WazeVlcnwu1ljCc1U6R7dLbF06fEBfmdM21RP9+eI95BJU0rqxJWw+GHhH5z?=
 =?us-ascii?Q?c8IIuCvty5e0NURDx9q+uRQ6HidofTwDu2X6hfbNoBcD9m38XIWoEge2HXOo?=
 =?us-ascii?Q?/pfLQWrybMmwu1Bd9OserthdVKMXQX6s/95r9W4TurgyFuOaAo4T1x/7gnMB?=
 =?us-ascii?Q?3DTTCa0/4HuJ9utOj/oSUwGch7gt2MgriMTTGTUCrUyfAcTjO8m5Bwcf8lez?=
 =?us-ascii?Q?TdCWAB7nkfPDwzrFObffP3zIhj7VMxCVegw6iX6UMow5nk6jRwI0H3QPyxRQ?=
 =?us-ascii?Q?tnWRz8MQfq2Nc29Fj1KH/lF5FPBxUevzt9bbN5Zr0ZT5XrsI6Vu93xVCed/P?=
 =?us-ascii?Q?QOZjaLmVKDGduwvcO40iMH85JqC/hLmgITaCLBFQUye3iLvN9fxpqKol21dE?=
 =?us-ascii?Q?d88yVYg2iR4gEtZMG3ugVG95jk1zksFcX9U4wlAIKRxjtnvmRy7FY3CXkBE9?=
 =?us-ascii?Q?hf2xqahK0XIFe6Yn+lpFYsF1pyiX+YlqtiomO4YFWwnRYuCHm/wAR6wuWch1?=
 =?us-ascii?Q?cB1DH4BxhkdA5baUbLumJ3Bs8NdAkYlJ7ywvC7A3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7951f820-97a8-4e51-4863-08dab284af07
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 10:20:16.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRTIOLilIdaLMX3HfCPpUT+shjeK3r7aj3mFW8zLC98LysToHYQz0+R6e1VsUJXhkZzE2e/+4Rqt1O2QUP2Wiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
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
index 9daf024fdd0c..9e1c2ab495df 100644
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
@@ -788,7 +789,11 @@ struct mlx5_err_cqe {
 
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
@@ -837,6 +842,19 @@ struct mlx5_cqe64 {
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
@@ -872,6 +890,28 @@ enum {
 
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
@@ -1194,6 +1234,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_DEV_NVMEOTCP = 0x19,
 	MLX5_CAP_DEV_SHAMPO = 0x1d,
 	MLX5_CAP_MACSEC = 0x1f,
 	MLX5_CAP_GENERAL_2 = 0x20,
@@ -1456,6 +1497,14 @@ enum mlx5_qcam_feature_groups {
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
index 283a4e5c283b..aaceeac1265f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1442,7 +1442,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
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
@@ -3332,7 +3334,20 @@ struct mlx5_ifc_shampo_cap_bits {
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
 
@@ -3356,6 +3371,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
 	struct mlx5_ifc_shampo_cap_bits shampo_cap;
 	struct mlx5_ifc_macsec_cap_bits macsec_cap;
+	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3602,7 +3618,9 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         disp_type[0x4];
 	u8         tls_en[0x1];
-	u8         reserved_at_25[0x1b];
+	u8         nvmeotcp_zero_copy_en[0x1];
+	u8         nvmeotcp_crc_en[0x1];
+	u8         reserved_at_27[0x19];
 
 	u8         reserved_at_40[0x40];
 
@@ -3633,7 +3651,8 @@ struct mlx5_ifc_tirc_bits {
 
 	struct mlx5_ifc_rx_hash_field_select_bits rx_hash_field_selector_inner;
 
-	u8         reserved_at_2c0[0x4c0];
+	u8         nvmeotcp_tag_buffer_table_id[0x20];
+	u8         reserved_at_2e0[0x4a0];
 };
 
 enum {
@@ -11548,6 +11567,7 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT_ULL(0x21),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
@@ -11555,6 +11575,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 	MLX5_GENERAL_OBJECT_TYPES_MACSEC = 0x27,
 };
@@ -11806,6 +11827,20 @@ struct mlx5_ifc_query_sampler_obj_out_bits {
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
@@ -11819,6 +11854,13 @@ enum {
 
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
@@ -11841,7 +11883,20 @@ struct mlx5_ifc_transport_static_params_bits {
 	u8         reserved_at_100[0x8];
 	u8         dek_index[0x18];
 
-	u8         reserved_at_120[0xe0];
+	u8         reserved_at_120[0x14];
+
+	u8         const1[0x1];
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
@@ -12077,4 +12132,15 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
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

