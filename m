Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9938B60CE56
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbiJYOFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbiJYOEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:04:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C29B19C23E
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl0t5qv5131qS8xcCAu0Pj5FcjXXqPkB6RrZiLQqNWXXbmGJJjPNKTVW6lHMN21eAuS//klNyWeLlGZYW3vQ4+PyCUJ/dOaHbtCWx++x8SoNsNitT2Jmf9QmGHfuPxISIhj/UQT9IqnubbB5Wl50HZZMUqC4Pl+Fcf0yus/EyDqGGsGrPPAri0fQHkWAaTA4cGj8rzt6537RLCBoDGEcuZIkIfwvyPOTMmUZAXn60LyWmR9mzvoYhxAC8JnjsXBNqAjsPM5mS54Jlo4n2m2tebnt8luvHIUafIG9abWKObh++xKrxgzsyKWZ4uGRjPeXsyaC9b4OW5QJ1mPUuuxIQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84pUeUQf2I8nzHWv/zV1XEKN6qXTsF35P7Bf3dJWMCw=;
 b=lO+YKFyMpdgvts0G13floUZCFfE2FY89pPkHNvp1uxYc25fOyXf86Pu82j9+xXA13NOmMdc9M/wwE2UPTkWV5fyMmb7GtcPvSn4cUdqCtV7c4k3e+iLm0blBkf0Hq5jaCeK028EQNEQXzjsIHnn9BPcsoSLqzUQhW9J75YINpRAJzF+OkN3ExeAjlC1w6SRbhHtGHAQi03vaE3ORuZuDJYktomlNSaOoNJH/Ee8+Ajkxy/LFWyVTczA+NSB44bo7X2nZoE+B4/7NoUIEoFLnenpzIBzY4PLyIWsfGyuOeGGXcPOxy95JBxp1Q8OA21Kin6fb7PcOyapH8tkywt6MTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84pUeUQf2I8nzHWv/zV1XEKN6qXTsF35P7Bf3dJWMCw=;
 b=AYNOnaEzH0W79/lPeWZLL2H5kpci/S8RaoC1o5UOfEvugzoTAhOCPJnI192KC/V6Bhm27DmEQ3CZrGI0SpCAGLcylo5hGjql+N9mwIhX43NqtGy0ArKzAajGD+6lJ+txB7RUYXuj0oIsKbNYEffAJdjBKkfkayMcTDSTLJn27hnOxscCW6zgvHuFfAPUls7EqQ896a+wIlOi5nKw+UOHaIjMW0UvmhJ0faLGvtPLmMD6aALRXZ5m4JDps4zheUGgrY+IlQMgb5moeKzf5GwSY2wpWREx0JbqGrmO6EagJElfZNolaf00bpX3NrgeIHZUTlKAXReKlFF98iyBzrmOEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:01:33 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:01:33 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 15/23] net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
Date:   Tue, 25 Oct 2022 16:59:50 +0300
Message-Id: <20221025135958.6242-16-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221025135958.6242-1-aaptel@nvidia.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0075.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::10) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5279:EE_
X-MS-Office365-Filtering-Correlation-Id: bea4f8b5-0364-4fe7-cf36-08dab6916c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I/8j5xrogQ8bI2Lg5OqVqyCrOLztjLMM6AqptWFdsMxdgR7sNOE2HOeEGK08lIxkMeqRiuUGv+fnmv8BIcLMzyj7H6E8ZdTfopX10uYJcTKQ3hotaONpdC3GNBY05d+kRxOYUyDz6xMJG1voN8JnL/heFOfzY1SUrjHp3OGSLfGeZ3VpsVHGxUYFEWHK35YF/OdcP0HtIRxkArT2Ww0Nzx4BH6Ndk5656bQp6SOfbxGT7QrVvG4WTTut/ZGEXZQCToAaFSbaQIdwhciMNQwxBJa0sx6jQ0KKGJpqaB5FBHtpFGPNrOREmzzV6pUk+YovOoZIiHCPqPsD0HeWVFuGzWW3irtCzmpP8IxB8ulf13e8cKOydWuCJTkzcQnljEGUQBljlkQHeQx2LjTgyRTwlMcx2X7uoOivFGus0RAi/jGYfr4kurmR8o8E3oHShkGgTvtJv/SMq29Vts+Y9YYeo9gGPdEg4Np7wL6uENge8FtkpVaOKTTgJevF3jE57J8f4CqQqfJmB9nJJZ0WBJaW1Q7OvgXIn6JRoX5kwJ6127JqFOdKlZf+bHxdZgL957CQve41xM6m0/D93ob8M0KjoD4qikkg4qkByTSggWjB6mj0gnDpZ84oA1H7y3VqWvFFPest5gH7TKohxr/92EhP2K20/z7yKX6Zv7XODrdIY1b1V7QNl/q0tXz6qDHaoVC+JjRol50P+YYjMoNdMqKawjrFukmwq1X/EkgOw9CbiWQTAfrNzaltiT2mctIDR4bz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6636002)(921005)(6666004)(316002)(6486002)(6506007)(2906002)(36756003)(66556008)(4326008)(8676002)(66946007)(66476007)(6512007)(186003)(41300700001)(86362001)(26005)(38100700002)(1076003)(2616005)(83380400001)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fWWYV8kJs3gsmJ2hFxNAeJKRqm31kY/l6sG2bGBGeixknv0tXtmmHOyhdZZU?=
 =?us-ascii?Q?sRYCGWEbUGV1AuYluCKSZHBz4YJQsiq4YDtu3VeC9qb4yhuZT27IJ3IRquB5?=
 =?us-ascii?Q?a219zyluTDrYTD8eC+AzfdBI8UfaXN1/U4byUIvbx/n8uZy/C9CPFvsrde2R?=
 =?us-ascii?Q?0RtBwAZAuOc/cmZcHiZbnEKctV4WgpSKUYWLOlpBAHrjL0nljqd6qCA1T0fv?=
 =?us-ascii?Q?AvaMHky5+4jEyqYZfiwJNObxzEPAslhx9OdWpIvJySvySqWJ300IH3HxFAlr?=
 =?us-ascii?Q?dif/pT+AbsdPH6wf/Sr6ZndtmqBuRXsC6g7F818awe2TDX06RpBv9hNE+ekt?=
 =?us-ascii?Q?+kugRnfIpXGSFIbaMJVCbyPdD6IOXmQSzvSJWzuKvkg7vBINqgGbi9XAjmkW?=
 =?us-ascii?Q?tqs8mrlKJ06zsC5ZC17enVMq1EdRFL567YCRD2uO9nSFLzUWQyzeUBOFTydf?=
 =?us-ascii?Q?ZQtY65LiaZ8h5jAHLmMOQ1STiHHnLApwdUdgKi0A2d6hkj8mxbmRu2dHTSfs?=
 =?us-ascii?Q?IbPZbnzBIBWgaTpOcxVTgyDJz7v/YrTt1ykYksfhrNudkhTE40Vwt/8hVLBo?=
 =?us-ascii?Q?FIXf45M0BvZyNO97Ynyzg5ZliwL3p7rY6oFmm2QcRfqvmj/h2dxnq9VJFNQa?=
 =?us-ascii?Q?VPcmHyriB7uhOqdRj/xMff2ublfvZafvPbrZZzQ+X3H+2TOowIzb6QDf41eT?=
 =?us-ascii?Q?/Vqlq9neYtI/bLvoTfwx2M+r5iF+ogIuKR3uVd/DpZJmvK5BX8OZo8xSE5Fz?=
 =?us-ascii?Q?ls+z5X5adU4F/wOUAqEbWMfs7vRDPBEwnc34La7bxaTjGd02BFok8r0lUhvd?=
 =?us-ascii?Q?jEZmaXEMhuR+qIp/eNz1+3lnm2SN9SegNPUCEhHBiKMwuZ6EZRCCmNp2Xett?=
 =?us-ascii?Q?T3zvv7N675RYjpKK7KG5mpVraa08WaJSAHSbsW5nU4cxtbOeMCA335yCKu9U?=
 =?us-ascii?Q?sl+9Gwd4S8RgYSdU5cdFC+roNBUBq8ZJi5sAgaCaWTx8NjjBr6cZqyYwhTXE?=
 =?us-ascii?Q?j4GUXm/gh9vpdgM8jPH3NlIBQ4E1FcHu3LVmm7SjVq5uyqS50+S16b9Riycg?=
 =?us-ascii?Q?iZhUbQ6eOeQY/gxybVkIiUJR0uroBnpJHXo5t1Ivxcw/o49ZVktXBMX+ujP7?=
 =?us-ascii?Q?Ho8602LQu/AiGlOPk8svl4xSd86rVL+dkoRr4ER7DyFnztl6SmnHShI7Icmg?=
 =?us-ascii?Q?DHqPQfQASeMz8g0MS9OB9wANKhhHCGFH6/W4FhEIcYPWbGExmBT9QEzBnRbE?=
 =?us-ascii?Q?yreCqP8YWL7QkJZ8Ap0q6TX4cmFKjjBWIk8BZLTev9DkzTf6/vj53TIAZqXp?=
 =?us-ascii?Q?1pdXGGBJ3OqRH7uwYBBfaEH25DA6KisfMKQ9TIWGqNT0AdTmEfAtmKJHXqPp?=
 =?us-ascii?Q?hAqFoa3zulV0bLtCWvy+T61XMb6qOwyuIKq/DSs1mHDplmyMTdI0343xtELV?=
 =?us-ascii?Q?lr9NqVQ2ByqYxraE8QnYJqOjkGLEhHCxr1NcnSovgythcxVxpjssku891+1S?=
 =?us-ascii?Q?3nM6nXd0sxf7Sjb9H1EC4dT9GcA7IBvLEAkdR7I36bFJI4CwfWQ+JYvskJSM?=
 =?us-ascii?Q?uZotgihb68Q7ROow2RbPJhwD1mZTW4NQaAytQ3vI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bea4f8b5-0364-4fe7-cf36-08dab6916c99
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:01:33.5972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BqjOpD4mkE7kFGsjECP4x6lwXUnqepycxw2EhIYp48FzAujFtrIrf3HKKXAYLATI2pDBvEQLzKjsxcjGomQIyg==
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

