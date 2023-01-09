Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EE866272E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbjAINeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbjAINdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:33:17 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF891E3DE
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:33:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3lKGYqggjJeISv8/6aIgp7RKAZuU+hdIDczHcmWt2kDAXNL+OeQ1nJSq6soLwCuY4vG78lWMqlnytBDashVCZJPx35y9+X7zq5TX7KdKD9JYpmiDBkxjVLUUpZjc5iAFWXmD2eqhpyTWeOhC6ZtNU9owjKxZLVdaWCGYSrZJ0xA6C9R4zNH9GAQDnibi48rNvQqGOzSQLIdQqamIXNZ+u3ly83DrZmWknslEjK2aUCrtTznShXPOkci8alslaTeEDWy/tGWu2WZZzhT5722W5mE6CLvTFmyFrcKElBOlzdL3VZPlq462yRznQYAqaATtTJ3J7vPpsEdEz7pvVMbQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMTmGjRCBCv4TtycYgnX3Kb8G1T1NlMIsB3gm1s1NyA=;
 b=e6E8ryqjVgV0qmXv6Amzqxv15eqaWZdHSF8i4Y3uDeEMEAD3dR3NHZb+AWV9Y4MpMGEjf/yafq4MVRVL1c2myWGuS7qHLjOhtDBuW19d8rzu6E5ZCrZEyhB+Z5QNEbATM5Zczbx4tevWxfLGlCX8rUNt0XboRnkieEgtrNhNSIF6mRoK8QYjx8J1+NgefOov0APyhsURNFQ0sPjp8J48qqfFBxpbDVnNRjFAZujtwaLtu/LX0DL4SNJRxFKxWi8KnG05LLcjSKYK9ep/j4eY+uzYolID9vZhOSxFLzWgTlxdL2BM2qY27xd5EaM9y+clivdm2r8714nFUa/ZQpMVnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMTmGjRCBCv4TtycYgnX3Kb8G1T1NlMIsB3gm1s1NyA=;
 b=gQqj3aS0Fuq5GRGPvxuwH1gp0qgQJM3X+pbQx412NnWSjfBPfNJCVc/8byWP6P54cnrb5+eosEJwrqwHkMq5jMVmqrJfciHgTsM26/kG5ZpCyZnQhk1BYbhwvb4pQ6Ltw6LXR513SfSRK3zvxWPbzaa3n45x88X7M2XE/2rmTYRQzx574wug+UNHcdfCqp1p6D/pXK2y31NkBLRuy1Vl+PoOmD3VJcgd9f/U4nsmEdkLy+yd8D9qG+mGZk7HXKTJhY44coC8iiEAozdeHA0IB4WiW6nbUwfpdRF1zn4fOrcp0PkglyXBN3H2VPLGVkT9MCVpCTOjAMGP+o3dlKVcHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:33:14 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:33:14 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Ben Ben-Ishay <benishay@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v8 17/25] net/mlx5: Add NVMEoTCP caps, HW bits, 128B CQE and enumerations
Date:   Mon,  9 Jan 2023 15:31:08 +0200
Message-Id: <20230109133116.20801-18-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0533.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::18) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: b0c9bf5f-77dd-4215-18e4-08daf2460f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glSiqjLqBDgIdNgtLKky8JdSaFbPnTfe4tzR8AEnTVNDoTNxSCm0hKfItMyNKhW2a6UrP7xA8TDX4gMtHnwZYNJtZc+wQ4O2tp/ki7KOTcstbV1oUYYwlFuFMGFdItd7mcX+0j14xl80DkgYV21A260dre4gGHDa5hsfoVlvlKZp66OnYiwgVaK5CuFvsaAoGc5EoUzlf7BuHsTNW0mTfbhaCUlORhlGf2wl/pf20yN7DMJaD8fAS/nR2pIsYNOH/8rfVAFcHtI8ZC5oJcX3jm64DyuLlJhV59+4lte8im5R8gX0vPQZgQoyCq9bcPIsUU7YRkvLF4N/7AZlz8HfbbWUjFbyESb/bm3HJl41KgxeBwTmMXvig7y3ojhEVsDVIeORN+upRKkcj9cOxHH5VA1BnBcwQyWczX497XkveSAU5Pzan4XAQXnXjPF1NIaCPk3U1s7t9RVriIoeSNxsFYs8UUXhWy5uUt+Vo/+vNciid0g/xdS0lSm5rt4p/dOpMho35us0sTErefzq/tHpU14crljVMEDZLDDW0eaUEBbKuAtaWUlvaCy7lFyiNGBMT01yvb1C2e7UCOLJiIB59UEEdwGhC3ZOxyqu3qcF1RijcX/+RmMtkE5EsMPFwavJqmqtiphjwWeBa8PvoqwLeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(54906003)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(6666004)(107886003)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YNJLsCOZqKTcdQ7534R2cFtIhuEFkK/CmZtHewxPBw9CAONWeecbOirXmGQ3?=
 =?us-ascii?Q?UBLPqB+kM8CRxTE7HVz8sGEm9re+jLSluYXhUjAPMlz+ftEhBt750AaqzXqq?=
 =?us-ascii?Q?avhmof6joDd496vCsowPr93oJjPpdY0CvAoXsIpNX5jwWkOFZ3DCVrFzdU5j?=
 =?us-ascii?Q?7qnyXqNa/X92JNu6ils01kAatFrvW3EJtjtBRANUrrxVMpUqGoMXwBbpJDf5?=
 =?us-ascii?Q?EMXCCN/CLAV+3zb+pfQwrCh4Nr8VILaMUCOf6IPporS6F5UhV/x5Dcg92Xuc?=
 =?us-ascii?Q?WQyi9XkUKVuqFpNUY4b9y/kFcf2VM1LmeDApq3OeaNGG7ZpTsOTNu/O2Ywuj?=
 =?us-ascii?Q?vaRipfJSCdE6XCrqcQyrE7FMcijXPcIOjSBwdXGfCUv9F48oETAPcDCyzcP3?=
 =?us-ascii?Q?/Lj4Q0Nsko/KHHhG9ZMdNq5ExkeAYDjhWbPziQvR3LJ62cARmx8heJImALxc?=
 =?us-ascii?Q?wFma7rvU1ctUyLY3ciBCdzhFhBpXFMHnckO0I895vbJOz/5vOarVmEQ+0QSh?=
 =?us-ascii?Q?DYtgNIX39fIsh05ZLiADddySHJ7F+H2YQr7ChS9X86DnXCFcYrRsqam7K4lR?=
 =?us-ascii?Q?hnF60XOr1YOgaAH2X2bF+US/dfGA3G5/adGBc+sA8RB7KvymWH0ZDP8SI22h?=
 =?us-ascii?Q?yqU6BAnFeGAkwA7QRkuQW3Q2YKkDi51o/Da9Pw6f5QxgIlS2VKEX2YT1/DkG?=
 =?us-ascii?Q?tR70hfid7hU3SCUltuj0qiWNDnsFPmS2FVy/iVg1jrTRQfws5UCv2D3talz7?=
 =?us-ascii?Q?ujtyUbF7uQirPGeqVWFYgXt/OylutuLmkG1XRC+GlJtgtJLfE4eMxw/a4lqI?=
 =?us-ascii?Q?i2r+C7qJHTRQEix6vJKFZ8Udg3wXkYnXOip6rQ3roKU9lFqeSumdYk3Q5DZD?=
 =?us-ascii?Q?+T0ERSqejHVwvd0iZ0Jeg4MvN7C7rSK+6E0bIZqTsXHSfzk9W0vjGUBqLI+/?=
 =?us-ascii?Q?BTBfK5ImdUaFPlkd/pcASgXgTBT7B1Cjkxd77tw0sMi8c9aTt3X9KrUAjVW2?=
 =?us-ascii?Q?LvKYg2IpIcGiG0HwvyMH7eS0LiaJd2UYWtqxgZ3Mh9fMFiGrOl8d7VVX/xSC?=
 =?us-ascii?Q?4WUFrU4a3P40Cw0e/HgTytdj+pZX6mEOqhUm146bWjIClflG3OjzwDIcfv22?=
 =?us-ascii?Q?wsCDJogWtdhVckd6gX5QROEE0d9CeV34HUKIILETIPrIDvshKSmG8ZuANu8D?=
 =?us-ascii?Q?OosgaVR8x1LS3JcpLTzIOn1XfU5O5bfY27yf7wUEQHFFj/RfU/zwXncxQ4sf?=
 =?us-ascii?Q?SazOZOSSUS5pmG4B3jEJTjqriCGwRcZhKKPXYEYpND8sq0+SrTSbbuRfUaSZ?=
 =?us-ascii?Q?J3xoLJhbOsmv6kdWUR32OIObPKfag32LixmqDoi+2XzCjcAagtZQo95sEUFS?=
 =?us-ascii?Q?e6tYeYR3fswp18v79sKD5EUf7oECB6FmgMU5+qWDmWpfKOJBPELxxKvaW+wk?=
 =?us-ascii?Q?f3DhcmCQet6nBVDh7JkQAJOxa8qRL0bY810VPk1uJa5LM32lhqEGJ2KxY6AE?=
 =?us-ascii?Q?I97zZ/s5YKBlIzv6kqxyb29vtAw214mOXxQWqNX2GlwrxFT3QP14rNeN2VSx?=
 =?us-ascii?Q?7jxlzSQ8HOXYN6wNSqfzqCy3gRxrYZqf4GM5PHh3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0c9bf5f-77dd-4215-18e4-08daf2460f37
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:33:14.3872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NDV+vgWWU0tPTL8k1kXFvehrdGIC3AwldjFfa5fKqBwzrosCjAs8gau17r/1uQyxYqAzY88ak6/L7xCo9bRMeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5056
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
index bbe5b0f233c4..69d35c591c55 100644
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
@@ -11630,6 +11649,7 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT_ULL(0x21),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = BIT_ULL(0x24),
 };
 
@@ -11637,6 +11657,7 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21,
 	MLX5_GENERAL_OBJECT_TYPES_FLOW_METER_ASO = 0x24,
 	MLX5_GENERAL_OBJECT_TYPES_MACSEC = 0x27,
 };
@@ -11927,6 +11948,20 @@ struct mlx5_ifc_query_sampler_obj_out_bits {
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
@@ -11940,6 +11975,13 @@ enum {
 
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
@@ -11962,7 +12004,20 @@ struct mlx5_ifc_transport_static_params_bits {
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
@@ -12201,4 +12256,15 @@ struct mlx5_ifc_modify_page_track_obj_in_bits {
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

