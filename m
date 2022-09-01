Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04115A9A08
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 16:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234601AbiIAOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiIAOVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 10:21:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC99419A0;
        Thu,  1 Sep 2022 07:21:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5tbApyaECetOsLuBxZYmayjz0xSYDjBbWNtw016PGnobXegOkdpO0ngdN5pf9RqoTviepjQLoyTcF93fHCKMtaamz4plDE7UmaQ19OEOsw7TU+bxP7s/Px/KT/RHJD79L0NEGsbFLb9V1RamEdjj8DgOPYKYpNn8uBsOYiR/MH2TWJMaCHEMTk3n2YWzlvixlQDoBAhi1g4pMcVpc8Kiv/PH2Qaka22y+aXu44vgwt8NskfdT/vWhM7AVRT0SrhF/IMPHry4D89lYT5nTx1sZehybtdACH7PgQLsrsNXbGnzuYcWLLc6T1g83OnVUxjyUzEn0LTTDqj3qw9P/sAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWT5g/0ubjMdjjud63JCmVADsQoTILLj1AtF/TxuYy0=;
 b=Pal8oJwtncEhzWW6LqV8XomMRjLQVXAYyB502KymR4O4meUFq3TX22kaN0IA4IP+NvidCI72g3O73a0PQqrN/+TV4bg9JexB1aY1j2NLBNQ8JS4eeRQhDD6Ajb+xpzq6TeQ4cVoyFeqrb+4LEe5CDCeDvOhuyRo9FxXx+G6klUT4ETnZ+GckE3yPYCZwytd6i5XyNR8HvF7LRjuKhWXDBmug2Mr4jqOhNEuoYx1m7w4SUPkTFWxrueXNaatsZji2TNKCRF1qccBJ3Q9xwFRP1mhR3ZeJjs1XC+MAAaxcrmsbJ2215qdv09deQlBOJi1GNMxWisyOCza+7Pb4M206Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWT5g/0ubjMdjjud63JCmVADsQoTILLj1AtF/TxuYy0=;
 b=rJRKUx/oVnsFHmhgjWQI2DhI41O1+ogltyDsCpwce0xfPwrW+0UDjNCMgm0Njt3Lrzbl7cF2qVZEU3jCkD2GERt8992Pm1zI56z9JG3IGH+hoZwgS/hyKb0/C1MNtyFX3J5g8xHEaf2C3iJNcqcebBaAMCcmAuRK35Y0GvqqFvYSmQb2N0pzNzcxhCNzocyn7vFIQwNkeqU759bHDOKKKidl/OKlVkX0ykwBnHpqc7Lg/2G15lOLN8TO5JH7m13QxYZL0naa1ktmXYO3vwmgZz8GiCcqtTJooJ1xKaKeViUIoxWwDbRLvQIBtg0UKHe9khGVUkDlmYNWD9xLu1QGxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB5000.namprd12.prod.outlook.com (2603:10b6:a03:1d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 1 Sep
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
Subject: [PATCH 3/4] RDMA/mlx5: Add support for dmabuf to devx umem
Date:   Thu,  1 Sep 2022 11:20:55 -0300
Message-Id: <3-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
In-Reply-To: <0-v1-bd147097458e+ede-umem_dmabuf_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:335::6) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 147bd910-42ed-4492-60c5-08da8c25302a
X-MS-TrafficTypeDiagnostic: BY5PR12MB5000:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z+09MsS3nqOVvrJ8ALEfz/eCUWrTis5gYMj7e5GPU1wFD2qqqnJwFrN5Pwh7pSPTCT4YZoE2+Fo8k+QhPhOAw3bBImpek63/aFc09DlRxW6r0H5CJimzhh7bzfaMIqjgshGPh/bzgu9KWXkmhktsKqbk7YqeCjJJsnP0s7cKFXCkKOSoWBIGsHUkKx9YP64eNwBWo9w8iIhcbBoh0LwBnNHMwGYvIo4cdmC45Qmb7RWN+3Bhthr3mGVZ9x5OuJiNXvUfykehfqmKU3p0foRBLbg8tWuB40ssEEwFs9jOyzij9Y3gr4d0o6MCLRxI8xiH7BfuXe/A7W/XW0JfJaeQE6w2sgHu0ex6uc9xs94I1Y2qpTos0IgYJNYd7ovHXRz8plpG7Ru91kkeYLhAbIu/ArPHadHU27mUxm66+7+EkOiwMICS1sXkwOZcR0Hx7dgc8MuqE7XgaQKlh8oIDeDw5AAfWjG3j0aJtIXcm8C9BGbiAkL0puTYRbHCYkgdkjOoqGBboF8aPQrDbFhQguBkqHEWXzZH5VWZ1z1GPbUS1uvMTQxtN7ukS9lHaRHSE0VWK4xbvt36HtE9gZT2oUFkBhntkgcvlTGt5K2vAFXaHTbdVeVaprkzILSlalUSc8OI9BSTrRzHj5Vc6yvNf3VpU2RSN8TnI+vV/O85NGS+ezPWog0iYfMvCOpN4V4tm9fs0OWFp/C+VtW1N6d6lxl3osXejhHsk5UWn/ZCe5ZQ0DsjhTJMX4kMtBMtYtct3vCu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(6512007)(66946007)(4326008)(5660300002)(66476007)(6666004)(6506007)(478600001)(107886003)(8676002)(66556008)(6486002)(8936002)(86362001)(41300700001)(83380400001)(2906002)(2616005)(26005)(38100700002)(186003)(316002)(36756003)(110136005)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x6dXc0wVw7ppooyxGAXnR90j/mLxcjgTVjGXGbcdGGtFC+IO+z2gucv3/kwP?=
 =?us-ascii?Q?4WBt3RQZXOzeNBpdIxg6wY0KWQHt9gVkDVhB1EQMGnFuZbVXNdB1lWEmEv74?=
 =?us-ascii?Q?v/pN8qSPn/Cd4q2Ko60gTeaSTVgLVTx/Kabx/t3Xv7GgpRGhy1mG2rkUQLkN?=
 =?us-ascii?Q?1RpHTHQNeiPREKsbeUGDkDMkLwR1nUWx+wsCvm8r35yFldNeQD8FOEm5Lmi6?=
 =?us-ascii?Q?D2jwUCrcHiITwKcnqyEeIE5MgmpcO79ZSJDpIsPCzWleNdMF8fLOot4+xzxm?=
 =?us-ascii?Q?K2fEZb4/f/98hLA+v/gQgHJd49ATIrVkch3tq05BnFVi3JoKAWG1a0Hak60J?=
 =?us-ascii?Q?8ZewKgXPvGutRn0EFV7PVxCAeZWxHKCMhg7bIJpElHtdF5krPsB9G1XSq/gr?=
 =?us-ascii?Q?nOXCzM2xtr019N1HkGfmP0Cc1pkLka0duF9PzyFX6XxO0umiG4Lw9/708JrD?=
 =?us-ascii?Q?N2OoQcpDgZOege+CyYTnWsPEnANsgQZRuTNuItcAkMjJdFEi+aO/BY0SBY0J?=
 =?us-ascii?Q?A+mHdmPHnJCUkBf0dG5BUGCshCrsQUtl5XPH5u7PQuAuGT9T3Hbsw+DJBpxF?=
 =?us-ascii?Q?i97iwynXkdrvA/Ao7HpMy3NXxDi0z3ocY9PqMTNjRr0g8f1SpuUwaZgPh8wL?=
 =?us-ascii?Q?CtDqkXYRdwPqvBaNm5hq9/1B6EciJj91yTUENGIyLIl1gVOlMEpgAlaCvHvc?=
 =?us-ascii?Q?2vu0Deg/qopjsMpRsmdqbqnDGC2cI2M8FT2WHwaPq895SdkhyBtvDn7Wgpmc?=
 =?us-ascii?Q?BuTAbX4TYsulUf6dXxzv5TWBxpYO4EWdRFWGglbuntxjFKx5CU+sU+ABmgv+?=
 =?us-ascii?Q?I0Al8/7uogw9LeqFxEZ4qZC0TX2kA8KhcEKw9knrjxpVUxAo9m3pJtXcybHE?=
 =?us-ascii?Q?RaAWmLTPS82W5Y91lZyhc8UPuElV/Y4RxhB3V4dcmBVQMeCdti6lwcIRL0Nh?=
 =?us-ascii?Q?lbIlYu6yEevQYlqy9OLu91j55MpDJIEadc/zLT0rv6KnMo5yHgh3mt55rc/S?=
 =?us-ascii?Q?ikOF1puF8h8W6G3w32rBqdzQ5UUiokndEqFL/IrT0QRlCBkleEi+7DxMFmvQ?=
 =?us-ascii?Q?3l6z4g/DWTPop29Cw6nGdQnIpTqhtEQ8MApCqqlls+fJ6YbFpkNamAu1j3tz?=
 =?us-ascii?Q?eoIh9Jou6fXIEorR4L80jdWlPCZ2WcG9hd8/Co5IEuUchWDRTkRYbAMgto1V?=
 =?us-ascii?Q?SPlvk+fD4Ms2mpB3KBQ3FNX1O6x8v5xBGaMNOYbInoZpcW6yzmsDOTxVBL5P?=
 =?us-ascii?Q?VLNDa91Z8RNSAcquEsGvPIvejsMIJSTlGFqhddrRAcNqhYZCYLVGjs5BrRKc?=
 =?us-ascii?Q?y8BmbbR545J4aMuYQIiB5RrhVQK/1ioyOeLLm8QwLeuasLZE46wrB2VuQSw3?=
 =?us-ascii?Q?t+9pvkkKfgJ5sBsxiBvmjMsirGqCtyLoSucXuA6MSqtI3c/mxt2s1TDNHt4Q?=
 =?us-ascii?Q?fvGB+a+Ag7g6apsothD7PZGkctKYNV6nnq5XQBlLo+iMHUakASomSbQB257S?=
 =?us-ascii?Q?0QBQkUsAiJApsZkxdY/PMCIwGL8KIJ0vGsSa8mVE7H2QhVa5bfwhRDhJSUja?=
 =?us-ascii?Q?/yPF/tSUh+5ciYaeB0Ri1fxhhp/z9PJOLM8Vmf7/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147bd910-42ed-4492-60c5-08da8c25302a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 14:20:57.7046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIZlG+iQqfBzkvtWFOLpWw6rQThS4EMk4hdwKJg7EO6Rp0EuZQbZjsyMaj6RmdLR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5000
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is modeled after the similar EFA enablement in commit
66f4817b5712 ("RDMA/efa: Add support for dmabuf memory regions").

Like EFA there is no support for revocation so we simply call the
ib_umem_dmabuf_get_pinned() to obtain a umem instead of the normal
ib_umem_get().  Everything else stays the same.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/hw/mlx5/devx.c        | 24 +++++++++++++++++++++---
 include/uapi/rdma/mlx5_user_ioctl_cmds.h |  1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 2a2a9e9afc9dad..291e73d7928276 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2181,9 +2181,25 @@ static int devx_umem_get(struct mlx5_ib_dev *dev, struct ib_ucontext *ucontext,
 	if (err)
 		return err;
 
-	obj->umem = ib_umem_get(&dev->ib_dev, addr, size, access);
-	if (IS_ERR(obj->umem))
-		return PTR_ERR(obj->umem);
+	if (uverbs_attr_is_valid(attrs, MLX5_IB_ATTR_DEVX_UMEM_REG_DMABUF_FD)) {
+		struct ib_umem_dmabuf *umem_dmabuf;
+		int dmabuf_fd;
+
+		err = uverbs_get_raw_fd(&dmabuf_fd, attrs,
+					MLX5_IB_ATTR_DEVX_UMEM_REG_DMABUF_FD);
+		if (err)
+			return -EFAULT;
+
+		umem_dmabuf = ib_umem_dmabuf_get_pinned(
+			&dev->ib_dev, addr, size, dmabuf_fd, access);
+		if (IS_ERR(umem_dmabuf))
+			return PTR_ERR(umem_dmabuf);
+		obj->umem = &umem_dmabuf->umem;
+	} else {
+		obj->umem = ib_umem_get(&dev->ib_dev, addr, size, access);
+		if (IS_ERR(obj->umem))
+			return PTR_ERR(obj->umem);
+	}
 	return 0;
 }
 
@@ -2833,6 +2849,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 	UVERBS_ATTR_PTR_IN(MLX5_IB_ATTR_DEVX_UMEM_REG_LEN,
 			   UVERBS_ATTR_TYPE(u64),
 			   UA_MANDATORY),
+	UVERBS_ATTR_RAW_FD(MLX5_IB_ATTR_DEVX_UMEM_REG_DMABUF_FD,
+			   UA_OPTIONAL),
 	UVERBS_ATTR_FLAGS_IN(MLX5_IB_ATTR_DEVX_UMEM_REG_ACCESS,
 			     enum ib_access_flags),
 	UVERBS_ATTR_CONST_IN(MLX5_IB_ATTR_DEVX_UMEM_REG_PGSZ_BITMAP,
diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
index 3bee490eb5857f..595edad03dfe54 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -174,6 +174,7 @@ enum mlx5_ib_devx_umem_reg_attrs {
 	MLX5_IB_ATTR_DEVX_UMEM_REG_ACCESS,
 	MLX5_IB_ATTR_DEVX_UMEM_REG_OUT_ID,
 	MLX5_IB_ATTR_DEVX_UMEM_REG_PGSZ_BITMAP,
+	MLX5_IB_ATTR_DEVX_UMEM_REG_DMABUF_FD,
 };
 
 enum mlx5_ib_devx_umem_dereg_attrs {
-- 
2.37.2

