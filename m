Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4885A9A01
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbiIAOVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiIAOVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:21:02 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AFE41D35;
        Thu,  1 Sep 2022 07:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzzzBDcPNMfi5VGvJeusidb7bepykYArYAXIPI233EaL4RbFTFHgOYLyV3y4x0ILY8fzB7HnzlTWvc1LQhQGzBfzesQEEhiFUz1re97lLW1yA1mQRtkWAhi5qJGi7dxREUMD/3rBEbkcdCzr9v7TQNtQoFRM2NRkJVJczYm8E2aafxmOpBdJnDjK9Qi8UqLsQR2Kt7q2c1UjzB1Msfo0N+Q8HkrcCHKCLE3RH9Uhp3o1GULsDjoo17nrHmWQeO75cjYIElv2+Mi5tAn4rsHgXG5c0aqUDbGuV/AWUf2vN0X3zNiq+2F4PPjRIndc75AZUbTePnDhPosZMm8QwZSh2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Ldn7BcH4Fc4o6NLHshrDaZYqiE1GryuyqNfaP2v+tQ=;
 b=Fb61O1+MeLrBamNwC7tK4trcrNtAIFfSM5FUWjOcq1j9MmBPJ7XDlzrvZRqyV++IMndod0cnvWpJOHaOSJCm9JPtZw1ZNPw2Mn1N9X15Tj4PV2aKOopG9cxOtR7uescXpb5vC5FhFaCqHFrGgQ061qSTbLm2qTF/0Pb1xs+J4LJoinDlmiAd8UsYHscHxgXZ1n1tpZJhFZD5tmaCfU4qYfkToTsJjGqR5o30WgO9vWV0QxESG+ZaOm44yUo1ueytJVxg5HirscsWF/7w3LsZh0/XQ2DSxMerecU10qQ8genLaKlDAlIPrA103WOhQJLwqeEJ1TJDcxxmwR3u8Q3hfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ldn7BcH4Fc4o6NLHshrDaZYqiE1GryuyqNfaP2v+tQ=;
 b=pxLcvQFJlhu0V+OBYgLCE7vja8H2kmMRdVoeupKpK9l/jbYZ8Nz9phvw5nwmZE6vW4ZVW0T61OaJagGO7HPQ/Z0ngCz/7MTOep7Jl/reomsr2vrkWkUyZco32zn9fhXU8w8T+pE0y6YCTqEOkboq8z+0gp8ykBBTeerk+KyWYcLNLgP+R7P+lyGBLXbC1hCJ5cApVsFmjqbKbnx2gqIIafDowx5iMsE0l2crlpchqVY3hSDfpHlaaSdbbFUne5L1rxPc0qAfHBXAAa2NuK63WSfaukmJ9KcW8EXM3U5DpesJ9HvvmLffaW0U79PgvpaFJVyDvoDRAPqWFRdA1QrQuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by IA1PR12MB6041.namprd12.prod.outlook.com (2603:10b6:208:3d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Thu, 1 Sep
 2022 14:20:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Thu, 1 Sep 2022
 14:20:58 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        dri-devel@lists.freedesktop.org, Leon Romanovsky <leon@kernel.org>,
        linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc:     Kamal Heib <kamalheib1@gmail.com>,
        Mohammad Kabat <mohammadkab@nvidia.com>
Subject: [PATCH 4/4] RDMA/mlx5: Enable ATS support for MRs and umems
Date:   Thu,  1 Sep 2022 11:20:56 -0300
Message-Id: <4-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
In-Reply-To: <0-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98e81480-a7f3-4b36-c5d3-08da8c25300d
X-MS-TrafficTypeDiagnostic: IA1PR12MB6041:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2XjB1Vb6mgSsjXuPyIquXbqc2YtrnGtu1V/byME1PLJM599L1edw8l0T6TLuzlIPTvpuQ5+BVz8lq5GdqkF3dT0rZMhQicgg3cNcqez3SvfRF9v5KoG+dW7BVwIBog+PYMo1+o83Fhbr7TMEQfscniFurhEOGgpfEwCHTxTERGAiNOEv8uTSZo5zIB5o3ozQTSnC9uBx4xIEqsn7l/3xGrUBwxcdzmPkE0WnkoD1xgKV5UVGzf9Q6t4B7qCDlldp7dlsKVKkSDRghuXFsUzOMNl0Pqz7TnMv+VFU7SlwMoLBprdVMLGHTz7p141exvJtYeo39Z6gMKBDHvAYqqop/pEmz+92mIXVL7+qiTkWOnZLD4GKT8lpeFEg6JCRjW3dW7yyM9YRG2Nv8CEkQ8i3faEUGRjlpTWvSZ9PQVhIAwYsBzGEodc8Q43miHbpX6wK3H0RPrXzSWLYDf3p3XLjTSUoOFKO0RfgVd8/6dhnYp46iK8cvdtK7eET7kP+gFlh8asRutew+edCSkLm+1wtQrIZgFl3aaZWrQJTYSfx501Pd+XQO6nFlpRVSOdp3sMLzcjp26f8HT+cQ+dzx45OdsmmseXt8WLTmj/17fte80mg3oTgTS5cK4fLZtDEAnWxqOhsAiiZZqtEIEdZYF8vUYYvLYJ7HV5HoHASHzmdvBW3Z4YMoE36Y1AsieVr2UaYg8EIgVZG5kwjyZWt+RSPky727HBqC3gNuxqfaCfD+IcWWY8LlxXp2ThxA6Z0vVDG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(6512007)(2616005)(107886003)(26005)(2906002)(38100700002)(6506007)(83380400001)(186003)(4326008)(66556008)(110136005)(8676002)(6486002)(66476007)(54906003)(66946007)(8936002)(316002)(41300700001)(5660300002)(36756003)(86362001)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X72JPHBzAwSalejS6P0B+j4HymKeRtfD+mfUxzwebzUGQ+MpxS3eh4Lt5ZkN?=
 =?us-ascii?Q?DilqxdyY2erBGt7wD0rZ/KzFvjezT72ClF5fRftyJopgRP9InoNCWnieIRJj?=
 =?us-ascii?Q?y9gFKeDldsmYoqyotpUYgLgMcy3G3iiPToYkObiWbwa2SVYNg94PO9hmuQMY?=
 =?us-ascii?Q?ruLMc2R9aQuVrkkiTgkssBQJ7ehRQVRJks09f/EZ8JCtGl1TPM2Vb6VuUl02?=
 =?us-ascii?Q?xYFwKngJfPn6sNV5BLtiMMXvzQB6eTdKZAC9I6fp4rhpOyRv29QNFYWsKKDZ?=
 =?us-ascii?Q?rUiiC+b0v4MGN3dXkx7SZxjmjfCKN37eLdNpQXvbGrhfTP5V0UVhwr+TBz/j?=
 =?us-ascii?Q?0oXaoTujCvf9eCSdt+EHbt1dlKEYy7UgwovcEZgJZ1g/YZUKzA26Ho3kvdh/?=
 =?us-ascii?Q?FKpnI6JixJpQuL5RqtSL00/6DjJgrm52Rm5xqR/t98OVaOo5VbHphmoqKtMf?=
 =?us-ascii?Q?GsG7swpQ8h/FZCHs2xd835/hfDMDkXGraQNDT1Rl65PZobc7F588IEgrN/A1?=
 =?us-ascii?Q?7/xWfzJNKyDzGcIYE6AgjKBuvhv4QvH6lGiBXQcSybFK3kW+77FylnGjgn4M?=
 =?us-ascii?Q?Km3AV206A4/AHBgvX/mqaCTW147eHNVYfs3J64gEKMEnPWxB2ijss4Jlhy6W?=
 =?us-ascii?Q?N7DorshdTrzQ/BvkB3TtlbhRX3qjPDL5qPcgBqSTIWAQpA07K3TBaNWczXf4?=
 =?us-ascii?Q?K+Xkt0D6hm5csbeY2Id1eUEwzGowes+8+nLTlKsPOrVK0BkSXbeGFskaDzXR?=
 =?us-ascii?Q?JyiXzZjrkn0TfV3/X489ELdSx+8REj0VE1DHr7f0cKVfzwQRon8RUurPKwaM?=
 =?us-ascii?Q?hA9i6b1uhzVTQTGKwGjRm0bQz1pwQMrFJvEzWJ5vyw3Y7HBGkSQtYGp2crL8?=
 =?us-ascii?Q?yEU2R5VejcEOX/gHY/Y51PHhPWU3u2OMhClWFa3oPg7qzhqrAY6N6LmpciCq?=
 =?us-ascii?Q?d9w594wIq2R5aebolEuaOldsT9AmC9QOMEOaoxCZBsj3B9sBUrIBKJICJWro?=
 =?us-ascii?Q?pJncjDY4Y0jIcSy5gVgoPkR8EU3eHW3LtJ/kZojNGn1u78Gq7OENtsFJawzt?=
 =?us-ascii?Q?oj6XVNI49jmjiMlZsS6Lmv0quemirZ++mY6k5CPquEYqFievv4gfaLAgUyY6?=
 =?us-ascii?Q?TXj2kDmZs/HNAgkOBnHIdnujyhaan3UFDcJ6/2iq5/IAQTkyXBCHXFG1gKro?=
 =?us-ascii?Q?B+I96vjVYg+2IkGxllpHIQ+3gc7s+/qkmwVIbFoKisE4291cHBqRALI4PBfX?=
 =?us-ascii?Q?vl7+3xvYoRHIOLR4Pzx7ntiEJJikPT0IBEC92/jIbLglIrAxcqB87AZdgATB?=
 =?us-ascii?Q?bPq+ncFLDDJjc2rn5hylcP3HdTY4Q0VXoJd1R8DrzwcWxoxypKJbzgiJrsVs?=
 =?us-ascii?Q?fpV8RjbtlVF1jqMy/BnRl5g9NzfwFsC45sYZMwRPa9eOZ20JHimQi+lfU80c?=
 =?us-ascii?Q?We9ROhYXzLhAftZd2SO+drRiC8iwyTjCyfVZEGNhfViouxk3tlmRGEW3lTzo?=
 =?us-ascii?Q?a+JDdm76hLRbijA8xxkyUv0NUzaRiLbwD4/aDmDteJc5gE7ueINhkw+FJAe3?=
 =?us-ascii?Q?yPoz6fjepfpi67UyZned51mGqvpgnwyJ7u+Khd5m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e81480-a7f3-4b36-c5d3-08da8c25300d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 14:20:57.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6H7cld3vBDck1/Y4kymq3qaWLmIZ/6tmtnJC5D74eRUZ9WrbE/gjG08szHhsdzke
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6041
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For mlx5 if ATS is enabled in the PCI config then the device will use ATS
requests for only certain DMA operations. This has to be opted in by the
SW side based on the mkey or umem settings.

ATS slows down the PCI performance, so it should only be set in cases when
it is needed. All of these cases revolve around optimizing PCI P2P
transfers and avoiding bad cases where the bus just doesn't work.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c    | 37 ++++++++++++++++------------
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 36 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mr.c      |  5 +++-
 3 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 291e73d7928276..c900977e6ccdb7 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2158,26 +2158,17 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_SUBSCRIBE_EVENT)(
 
 static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
 			 struct uverbs_attr_bundle *attrs,
-			 struct devx_umem *obj)
+			 struct devx_umem *obj, u32 access_flags)
 {
 	u64 addr;
 	size_t size;
-	u32 access;
 	int err;
 
 	if (uverbs_copy_from(&addr, attrs, MLX5_IB_ATTR_DEVX_UMEM_REG_ADDR) ||
 	    uverbs_copy_from(&size, attrs, MLX5_IB_ATTR_DEVX_UMEM_REG_LEN))
 		return -EFAULT;
 
-	err = uverbs_get_flags32(&access, attrs,
-				 MLX5_IB_ATTR_DEVX_UMEM_REG_ACCESS,
-				 IB_ACCESS_LOCAL_WRITE |
-				 IB_ACCESS_REMOTE_WRITE |
-				 IB_ACCESS_REMOTE_READ);
-	if (err)
-		return err;
-
-	err = ib_check_mr_access(&dev->ib_dev, access);
+	err = ib_check_mr_access(&dev->ib_dev, access_flags);
 	if (err)
 		return err;
 
@@ -2191,12 +2182,12 @@ static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
 			return -EFAULT;
 
 		umem_dmabuf = ib_umem_dmabuf_get_pinned(
-			&dev->ib_dev, addr, size, dmabuf_fd, access);
+			&dev->ib_dev, addr, size, dmabuf_fd, access_flags);
 		if (IS_ERR(umem_dmabuf))
 			return PTR_ERR(umem_dmabuf);
 		obj->umem = &umem_dmabuf->umem;
 	} else {
-		obj->umem = ib_umem_get(&dev->ib_dev, addr, size, access);
+		obj->umem = ib_umem_get(&dev->ib_dev, addr, size, access_flags);
 		if (IS_ERR(obj->umem))
 			return PTR_ERR(obj->umem);
 	}
@@ -2238,7 +2229,8 @@ static unsigned int devx_umem_find_best_pgsize(struct ib_umem *umem,
 static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 				   struct uverbs_attr_bundle *attrs,
 				   struct devx_umem *obj,
-				   struct devx_umem_reg_cmd *cmd)
+				   struct devx_umem_reg_cmd *cmd,
+				   int access)
 {
 	unsigned long pgsz_bitmap;
 	unsigned int page_size;
@@ -2287,6 +2279,9 @@ static int devx_umem_reg_cmd_alloc(struct mlx5_ib_dev *dev,
 	MLX5_SET(umem, umem, page_offset,
 		 ib_umem_dma_offset(obj->umem, page_size));
 
+	if (mlx5_umem_needs_ats(dev, obj->umem, access))
+		MLX5_SET(umem, umem, ats, 1);
+
 	mlx5_ib_populate_pas(obj->umem, page_size, mtt,
 			     (obj->umem->writable ? MLX5_IB_MTT_WRITE : 0) |
 				     MLX5_IB_MTT_READ);
@@ -2304,20 +2299,30 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_DEVX_UMEM_REG)(
 	struct mlx5_ib_ucontext *c = rdma_udata_to_drv_context(
 		&attrs->driver_udata, struct mlx5_ib_ucontext, ibucontext);
 	struct mlx5_ib_dev *dev = to_mdev(c->ibucontext.device);
+	int access_flags;
 	int err;
 
 	if (!c->devx_uid)
 		return -EINVAL;
 
+	err = uverbs_get_flags32(&access_flags, attrs,
+				 MLX5_IB_ATTR_DEVX_UMEM_REG_ACCESS,
+				 IB_ACCESS_LOCAL_WRITE |
+				 IB_ACCESS_REMOTE_WRITE |
+				 IB_ACCESS_REMOTE_READ |
+				 IB_ACCESS_RELAXED_ORDERING);
+	if (err)
+		return err;
+
 	obj = kzalloc(sizeof(struct devx_umem), GFP_KERNEL);
 	if (!obj)
 		return -ENOMEM;
 
-	err = devx_umem_get(dev, &c->ibucontext, attrs, obj);
+	err = devx_umem_get(dev, &c->ibucontext, attrs, obj, access_flags);
 	if (err)
 		goto err_obj_free;
 
-	err = devx_umem_reg_cmd_alloc(dev, attrs, obj, &cmd);
+	err = devx_umem_reg_cmd_alloc(dev, attrs, obj, &cmd, access_flags);
 	if (err)
 		goto err_umem_release;
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2e2ad391838583..7e2c4a3782209d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1550,4 +1550,40 @@ static inline bool rt_supported(int ts_cap)
 	return ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_REAL_TIME ||
 	       ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
 }
+
+/*
+ * PCI Peer to Peer is a trainwreck. If no switch is present then things
+ * sometimes work, depending on the pci_distance_p2p logic for excluding broken
+ * root complexes. However if a switch is present in the path, then things get
+ * really ugly depending on how the switch is setup. This table assumes that the
+ * root complex is strict and is validating that all req/reps are matches
+ * perfectly - so any scenario where it sees only half the transaction is a
+ * failure.
+ *
+ * CR/RR/DT  ATS RO P2P
+ * 00X       X   X  OK
+ * 010       X   X  fails (request is routed to root but root never sees comp)
+ * 011       0   X  fails (request is routed to root but root never sees comp)
+ * 011       1   X  OK
+ * 10X       X   1  OK
+ * 101       X   0  fails (completion is routed to root but root didn't see req)
+ * 110       X   0  SLOW
+ * 111       0   0  SLOW
+ * 111       1   0  fails (completion is routed to root but root didn't see req)
+ * 111       1   1  OK
+ *
+ * Unfortunately we cannot reliably know if a switch is present or what the
+ * CR/RR/DT ACS settings are, as in a VM that is all hidden. Assume that
+ * CR/RR/DT is 111 if the ATS cap is enabled and follow the last three rows.
+ *
+ * For now assume if the umem is a dma_buf then it is P2P.
+ */
+static inline bool mlx5_umem_needs_ats(struct mlx5_ib_dev *dev,
+				       struct ib_umem *umem, int access_flags)
+{
+	if (!MLX5_CAP_GEN(dev->mdev, ats) || !umem->is_dmabuf)
+		return false;
+	return access_flags & IB_ACCESS_RELAXED_ORDERING;
+}
+
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 129d531bd01bc8..7fd3adea370290 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -937,7 +937,8 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 	 * cache then synchronously create an uncached one.
 	 */
 	if (!ent || ent->limit == 0 ||
-	    !mlx5r_umr_can_reconfig(dev, 0, access_flags)) {
+	    !mlx5r_umr_can_reconfig(dev, 0, access_flags) ||
+	    mlx5_umem_needs_ats(dev, umem, access_flags)) {
 		mutex_lock(&dev->slow_path_mutex);
 		mr = reg_create(pd, umem, iova, access_flags, page_size, false);
 		mutex_unlock(&dev->slow_path_mutex);
@@ -1018,6 +1019,8 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_octo_len(iova, umem->length, mr->page_shift));
 	MLX5_SET(mkc, mkc, log_page_size, mr->page_shift);
+	if (mlx5_umem_needs_ats(dev, umem, access_flags))
+		MLX5_SET(mkc, mkc, ma_translation_mode, 1);
 	if (populate) {
 		MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
 			 get_octo_len(iova, umem->length, mr->page_shift));
-- 
2.37.2

