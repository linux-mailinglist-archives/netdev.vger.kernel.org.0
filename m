Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B57519726
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344812AbiEDGGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344796AbiEDGGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:06:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4F31BE83
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCMiZiv8vhkYkBspSDC8MmsvV2u+dZpTj6acpyqEPTz4/6F3BwP7EB0ksZhzfAOCJM+VIcOcr0JFGb02tcDBFI4NqtLBF91uw1RwwRfcwZrFVRFdmcIb6f8upLPeqBuc9xRKxIB8dZf/7XvBcQei73BuSUaowK/q02WPoHoxtnAs41aT4+yjUgLt5TgyjcBbMuvjkVQGCb/L6OMxNTH4LBN7RuhwL1B1mZehZv6uXOU64/14AAxIP0Ui3wJ7Yuw13LErCK7/fTwEvJUB6YWH3WSgueKcCCypQuABIYoykxDaW1RLBkDNvoJQtvgqCkG8C/q8nzWHaD0+Ct3b6v9SPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=If0o/+pIPwhXFA+J2FEkh4piSv+m4UFoz2LXkHzqhmk=;
 b=lwEWBLP9QeJCxBDya0NyYZDDKnTrFmSR+IyKUGLkENk1X32ahzD+L2gf002rYeP1q2PTwnbRYQN9wfHQl3yK2ELeAoJsZU7X3vmySIX7ObONS547Ev5a3MRd04Je2dLAyZrnZk/YmkE5GpZ89Sv+ZfUlSrXKYvzBUhSmAKjpduQQkjEyR03OgUOQplJcEswVFoUopi8V/Vfv9mgRczpEdAW6KutWKte54S4F9fcRFoZvmAvdaduXbrxJF4B3tPqO24wlwonpBuqx+5Ruo+fKxW3Huf8bdA0lt0grp1awNOXhILEuWskhNdSw8KVgzvMNE3ZsfumBijQBH5Iuhq/HDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=If0o/+pIPwhXFA+J2FEkh4piSv+m4UFoz2LXkHzqhmk=;
 b=iIfUbIERGUVE04dRJ8kFr+5nZwMGdfiAvOBhuDn8TQSubV9DyzQEDl0eawUQQ6sespBE97UyL4Z9JXXhbw/ycAtTxcUlY3/UviIyFSd9Xkh4ZOQ2GvGM6k3ccdKr/c3iEOvTbvjYvJho3taYuwyEGCDtV/4yl0W3wiZCyKeVzcDgl2TgpePGdNfOSMxyKVOXpgnbgT1iJATQugA/s1fM37uUmBVLVn85zxfJTyoCJgce3r/P3uQJ4fIvMwV9J/jty+1GffvdTnvdl3CYM2fTCeDDdSxLmyiZ/upNJOOQvumYeAf9j65KIJtJJi2lytAUQLyTrdBrw67eCNlZtIP5Jg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:03 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:03 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/17] net/mlx5: Remove useless validity check
Date:   Tue,  3 May 2022 23:02:20 -0700
Message-Id: <20220504060231.668674-7-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::11) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f614b3b1-ea96-437b-34d0-08da2d93c027
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00062192A66A820888FBB9D6B3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pSsM1UrlKuN5cRrM4l2PeC3IGkcx495+x+5VKYvFf0lBPZ8wOeI6WvavP/ROJGyl8TRT5ntV87ww381lHpfjPgu7r+0hRoMvWJqFllVIIVIBAaueV/RbzHy6bD4w38gcifhKKk7QnIZ0NlIGsMaA1WaMx/Gta42Z044wRZSl+zcg1lZvoJzc588JfdQxwLqkHbpf/rCQBroow2Jzx8IYA7lufS64QOHIVAbhRza+270ErFjoG91mpGrWFRz6gX358U/TbFEI2yas2+RmT6Y0jJ1u3bb1sTP05Ct/en1qg2ZCH4jifQ3DLR0Y3eKG6QNz6Qw65OTtvLpdze74P9nVCsB583MZiz9b/Or6hq0R7B5z2Y/A2+SGnk09BatCizxEgvvxZYWzeUlAwL6w76ad3xIydDI68mX+Tooacc/RI2K6nfZiYVeXmqMPeXgaM7ijdMxEzQhxLX1U0/+ln5BcMrWjgv17faY7/P1l9CNUwg1nbzcmkTb/f/M9wwpgT59+M1YeK7IQcFHg6VrgcEdYjSOrXg6OUlA610uR9xOERAMgb70240peEYpW7YhgJ42rsZOYHi6VYNHhadW5yCRazjqpH/OIZ4xfVBaVNZdWy8hEpie1WJRaWbjga0gYP7rfRhO5cLfUGuE0BL3QPEuhAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(83380400001)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HU3OoZ2gOy4HEs6Uj/VOHCQ2XNXZRlJADN0xHHks+93aSPeKkkOV+YiiW7fB?=
 =?us-ascii?Q?iRK4cT42F6ePhIP3hqVCB7qKlyJIJ+wP8e2qCFnD1D+tubowyxsI4P3Pbjmy?=
 =?us-ascii?Q?IeXA3sZTmLzU/mFLbkRcQuYuecuSTnBGEjlu+Um/SNlk6t5hNGfkI85Egm8p?=
 =?us-ascii?Q?Xa7nVDcDbepB6ntzSSu8W4fHTCAGRS/ZV4CT9/74tArUPCmZfnPMKqVm5LBx?=
 =?us-ascii?Q?qC4p9QhJs59bfl/NCrnzSC4dpj+PxWsrjrn6iWirbbxEy7+OzNnN8o1X5waX?=
 =?us-ascii?Q?0KTK65eWfSgqWshEqeKjqV8mWnrhfexWubc16Q4+Es7j2+ALeO+Cv+aYRsbf?=
 =?us-ascii?Q?3h8UEgTP2vqFOwwSOKRPhmt+1DO7engtNJUl55YL9AeLNrEcftPgx7otcu2I?=
 =?us-ascii?Q?rShdGpDG3QvwhCvHHv/IVF0fTBivGiwN81gDwXF2JMHVqbnAP4aVcBWurAzK?=
 =?us-ascii?Q?0Eq9MU8A1xJBRwuJypzuGh+L5dbMA9V4koORJqkVcyWEzN3/hfK332SuBKpZ?=
 =?us-ascii?Q?7owvO+KDJu+Yt9hWMRV/Hy9/3/X309spYVO85snTBNNarsD/Y8WfajdIRLZ4?=
 =?us-ascii?Q?Zm5fQyYj/kBwlLy1hz2A17lc8oEJT4Ia1RSUTew7aWq4sgnb8/sgWeTugB7/?=
 =?us-ascii?Q?47LglV1Q6nwQjPJEsYuK+N/UlF3z4l7V/uEcyrWaojA0GjTQ2/tExOOurCFg?=
 =?us-ascii?Q?zXOs2Q9wWPttqekMguhKSXPlDz0tN0Cnk7wjG6uwiJVIkzjRvNnkdR0Sf02Y?=
 =?us-ascii?Q?G302D0BOVLMRG/846E26LSCgqQDk1NE5kyjthPxx0psbFH5bt0u7SFb9dHmo?=
 =?us-ascii?Q?f20RtjTuqLH6a9hIghMjlC0TUtBxSqPvWRDgKRJhUK72k5JpHf/ek3YEsfoo?=
 =?us-ascii?Q?UJLHdDXPRrQ3iwitye5YXdrTOl2+jtPBYpQLp/N27UekGIIy4UbO3X+20P5Q?=
 =?us-ascii?Q?TJI38lVd/Z23OqQQ2SfNUxagAb+scM0TRDOnc0UIPOVwucLNpaIB5hk7fjmP?=
 =?us-ascii?Q?u/VPx9p7Vm+zGDEhB//PRSYtjbyCsEhE3R01HAkb4JK/GsbQek9hC0NICJxg?=
 =?us-ascii?Q?K+Uk4wATpJz7i6x0gkMtymjBchF86B2joMAhLRyKQgpNPPYGm2xX9r7VlY/V?=
 =?us-ascii?Q?PTHl23n9x6pXbr9oig433Wxfr1Ahz0p6Mqo4uL9YD+TOecbJ090x75rL5Ds5?=
 =?us-ascii?Q?AESyMJb8RUYjHxTAugR88xSLJjELdMIVEzokLAf8k06OjXeVJgOOQAothP7n?=
 =?us-ascii?Q?b6B07aWnq9viAK0RZNPYs2Wycl0wzQ60hS2SaHMnaurgXizy4EEgSgjsOGB9?=
 =?us-ascii?Q?d6EurOVUePn3P07GltuSuT2EbBI36/bD6FSMxBMmnQKaq5kKTFCWL/mLrbqM?=
 =?us-ascii?Q?LT1J5oxKmlVZk59y6lOSPC2NYQ2D44lue/7ROz1MJDAY0NTsPlXJkHZLrpoQ?=
 =?us-ascii?Q?6ESPA4GlNAHYh1n1YmKnyKfMqXBwWChY+P28ueR6yPsSNt3dOrnVvwyLV9Er?=
 =?us-ascii?Q?ZDq3n2GtujdvqplSGTymRmewnbQdiJoEAErJJnbojHWOmR7OamzTPfQLNq+0?=
 =?us-ascii?Q?+ZkRCZKJM97/DqWOEXL3Td63mELiszb3tVCkvsrLhmSI2t7i6b++wOXRVBZn?=
 =?us-ascii?Q?/CkDgiOorbl3UwTXi/mClHYUPv9LxbrrUA5XPHc+8DrALkDrqu5VgAGkBukT?=
 =?us-ascii?Q?s3UyKhRjKY3tmo0hqLydFMhuutpxld+l0LaF1d+hshvE+tzTjl4TGZJq/9cv?=
 =?us-ascii?Q?ri1IRk/6QMn774eylnaSJOX5ZtbcWnU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f614b3b1-ea96-437b-34d0-08da2d93c027
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:03.5302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8sPst+oNAmTn/BgRtC/Mf+kNul0KcSrK03u6bY0zLnGD2qsM1if4HhQoMT0EF/gFRcFYqmUTPU7H09OB/LHxhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

All callers build xfrm attributes with help of mlx5e_ipsec_build_accel_xfrm_attrs()
function that ensure validity of attributes. There is no need to recheck
them again.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/en_accel/ipsec_offload.c        | 44 -------------------
 include/linux/mlx5/accel.h                    | 10 -----
 2 files changed, 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index bbfb6643ed80..9d2932cf12f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -62,55 +62,11 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
-static int
-mlx5_ipsec_offload_esp_validate_xfrm_attrs(struct mlx5_core_dev *mdev,
-					   const struct mlx5_accel_esp_xfrm_attrs *attrs)
-{
-	if (attrs->replay_type != MLX5_ACCEL_ESP_REPLAY_NONE) {
-		mlx5_core_err(mdev, "Cannot offload xfrm states with anti replay (replay_type = %d)\n",
-			      attrs->replay_type);
-		return -EOPNOTSUPP;
-	}
-
-	if (attrs->keymat_type != MLX5_ACCEL_ESP_KEYMAT_AES_GCM) {
-		mlx5_core_err(mdev, "Only aes gcm keymat is supported (keymat_type = %d)\n",
-			      attrs->keymat_type);
-		return -EOPNOTSUPP;
-	}
-
-	if (attrs->keymat.aes_gcm.iv_algo !=
-	    MLX5_ACCEL_ESP_AES_GCM_IV_ALGO_SEQ) {
-		mlx5_core_err(mdev, "Only iv sequence algo is supported (iv_algo = %d)\n",
-			      attrs->keymat.aes_gcm.iv_algo);
-		return -EOPNOTSUPP;
-	}
-
-	if (attrs->keymat.aes_gcm.key_len != 128 &&
-	    attrs->keymat.aes_gcm.key_len != 256) {
-		mlx5_core_err(mdev, "Cannot offload xfrm states with key length other than 128/256 bit (key length = %d)\n",
-			      attrs->keymat.aes_gcm.key_len);
-		return -EOPNOTSUPP;
-	}
-
-	if ((attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) &&
-	    !MLX5_CAP_IPSEC(mdev, ipsec_esn)) {
-		mlx5_core_err(mdev, "Cannot offload xfrm states with ESN triggered\n");
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
 static struct mlx5_accel_esp_xfrm *
 mlx5_ipsec_offload_esp_create_xfrm(struct mlx5_core_dev *mdev,
 				   const struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct mlx5_ipsec_esp_xfrm *mxfrm;
-	int err = 0;
-
-	err = mlx5_ipsec_offload_esp_validate_xfrm_attrs(mdev, attrs);
-	if (err)
-		return ERR_PTR(err);
 
 	mxfrm = kzalloc(sizeof(*mxfrm), GFP_KERNEL);
 	if (!mxfrm)
diff --git a/include/linux/mlx5/accel.h b/include/linux/mlx5/accel.h
index a2720ebbb9fd..9c511d466e55 100644
--- a/include/linux/mlx5/accel.h
+++ b/include/linux/mlx5/accel.h
@@ -36,10 +36,6 @@
 
 #include <linux/mlx5/driver.h>
 
-enum mlx5_accel_esp_aes_gcm_keymat_iv_algo {
-	MLX5_ACCEL_ESP_AES_GCM_IV_ALGO_SEQ,
-};
-
 enum mlx5_accel_esp_flags {
 	MLX5_ACCEL_ESP_FLAGS_TUNNEL            = 0,    /* Default */
 	MLX5_ACCEL_ESP_FLAGS_TRANSPORT         = 1UL << 0,
@@ -57,14 +53,9 @@ enum mlx5_accel_esp_keymats {
 	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
 };
 
-enum mlx5_accel_esp_replay {
-	MLX5_ACCEL_ESP_REPLAY_NONE,
-	MLX5_ACCEL_ESP_REPLAY_BMP,
-};
 
 struct aes_gcm_keymat {
 	u64   seq_iv;
-	enum mlx5_accel_esp_aes_gcm_keymat_iv_algo iv_algo;
 
 	u32   salt;
 	u32   icv_len;
@@ -81,7 +72,6 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u32   tfc_pad;
 	u32   flags;
 	u32   sa_handle;
-	enum mlx5_accel_esp_replay replay_type;
 	union {
 		struct {
 			u32 size;
-- 
2.35.1

