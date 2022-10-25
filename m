Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2699660CE55
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiJYOFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 10:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiJYOEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 10:04:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF1E19C06D
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 07:01:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsZnND7n4XV8qXPEaSjIZnwRqgK+ETxkaEz/n9Fx2tJOsmCvITbJwZTrqBbGgv7gxIQ+k6dp118IUdZjLCRLuAJd/sEhXZ+j5iHAzfaMaYbaXFeQx4iFFO7iZbAjn63pHeWHay2BbPZLoRrt5a13hPqkagCWNtFVDypdj7WOfrelD3qSXUCqn/kDXNSvD9kT1MzHRxpSGNhvAXDMwIix0CVr5NMn4tkIC1JRyFMal/Y22ZBzblWQ2KwWj6w1iy6jAAuC7Qo7YOx8NUA5oCeMQD8GLrm7TwsQBhVzEh0SsdVM2lfmUh4R4EaHTTbNakTrARFNprWHgkdfwySz++o1SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PfcX2zgT1CSyH1NWo+o80pvZyWKbGNaMs6fnkBT1rBA=;
 b=Lv8kK9dcCWCyiyf8t1NuAAl5KSHLZfi7PMxAErUVoFxKDpiRsM7p+gxi87J80RwAMhjMFXrMsTzEuyc9ffktyZ5thSptwe4u++3OLWUPLxRkqYdUZdN4jqC9Rfs5Yw7oszgK8vdlyg/sQ6NnLJ0wUzPxiBr//CFpI1EO1993LNPAY++H3xSP0nYA9ee8khfgLq9GGWaWJ0iShHYAZgwS594+qvQxONJkyAppBe3Pnd/KTW2kfIkLAbjKE3KfglXfjuZ9nbiT3s3i2fzyAnbyqlDOUrThY8S2sGDVBM9iZytXYWMbCYYCB1ZXYozz11Pv7hEcFXVp32PGdL5B5JIckQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfcX2zgT1CSyH1NWo+o80pvZyWKbGNaMs6fnkBT1rBA=;
 b=svJnTbtrV2MXKFdgepMgdMhm6hmw4PouCuDXbFD1gjj/VqIa1+wvHOb3w+5WfN6c/I6QMyaQHF+5QhwaJEBZRf/K16nGAAmyCP9dEuo3TWbSAhC7Stwrp19yMFqguWW7U5mepMlfQk8rDjjqb3pxdukIn+LYWDxZt3+941AwUaKzQtmJ2ljVjF32O3G1QkGxhyMeV7ZVgWILKmcOpX4I6EOTfUlWfpYjMikBOYX08J3eShTQRcZPomKkhBGkSM+kNotSriTNDaJEiOlC5k46aI0I7AcQ8XDhpY/7KEiEQushBUofqbue1Im6WIwtkJDS9wF3WfjBfqrfzMkVYXOWeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5279.namprd12.prod.outlook.com (2603:10b6:5:39f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 14:01:27 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6713:a338:b6aa:871%3]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 14:01:27 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, saeedm@nvidia.com,
        tariqt@nvidia.com, leon@kernel.org, linux-nvme@lists.infradead.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com
Cc:     smalin@nvidia.com, aaptel@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com, aurelien.aptel@gmail.com,
        malin1024@gmail.com
Subject: [PATCH v7 14/23] net/mlx5e: Refactor doorbell function to allow avoiding a completion
Date:   Tue, 25 Oct 2022 16:59:49 +0300
Message-Id: <20221025135958.6242-15-aaptel@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: e443071a-98e9-4962-5212-08dab6916929
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1hLCnDYJpPKvDsyRmEta0LGdecHSuuX+o1Lc8m+vppLz5eIyM6+hC5nikwe2WUjWDHMKesec5/RRX0viqNon2YHUJavmjFyfq9/rgnQfINQbv/WTIYiyiwXvht08QpG7dwerPzELZDGON9I2QjopnbCSBrK6TnbhHT6vU4+KA4aNnmdO1zKKtognVG7HTmvyKbYF6DHIFYIi06nO/hqc8J+XifH2HNLuzhb/zeuvPX1It+vgQCOSiScgtkofxSSsgJDTheQ+SGPPDZr8I0SJuciZl8quqlWRPFs1usSz4u0N2ZEN7Nw5KFIp32Y4l1YZGufzrbJQ32o1ydGeROXyb5jsAfcbqQ4HUhzjiSvrG6sKdQueEd6rJxiE71JaT7VNBSa+jIjtBZdCfao/vGBSIgtk84nmy7brdvlu15mOBu3ays7hpGTEw9Vi04KVHFy3Nt/sCswp0KOCbRCM+G5ME449uHXd5HnH5kjA5pO76ntB6MS119J7FVESSkxVPNUId/Q5sGguC5SgE4FRQqohDZyPT2zhOzdqvygKdOss7WRoCLU9DNtPvZEEJ490R8Sjxai8LDLNIsUIKBJVTtFlni79wS5oA3tPI4WNRkOS1xkbE278OI5XKm0lOHTCAktApe+rAS5ucgDtC7uAHUz5J9l+XugfyOTy45/iV5oNG2yIc5XUHAgjEuA4odL1phJR438q05yyoyscaIogqakN36kTuue6ZnY+YR3iHSvorp5dHqRRKp8VQ7LCXJpygnKH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(478600001)(6636002)(921005)(6666004)(316002)(6486002)(6506007)(2906002)(36756003)(66556008)(4326008)(8676002)(66946007)(66476007)(6512007)(186003)(41300700001)(86362001)(26005)(38100700002)(1076003)(2616005)(83380400001)(8936002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vIFMCIKrIjXFlhEvAuUy1d8AnkyrGJFrSemB8gR1Ehz8ZU8V5KSeXkRv+tfE?=
 =?us-ascii?Q?91XuYQaBXwswXMXztF7DA2/sXb6Z0ws3V+KtXLpN+GrsbAwLGNMazKNuOtzr?=
 =?us-ascii?Q?Z9j/HX6Ke2cxnpbu7lvpWwVbyCIR9uGqxMpbWepe8OaSjiGxokxubgP8pMYK?=
 =?us-ascii?Q?uRVJdbxRWNwbjla5o/CEtl/BwsRoVnrh8/lgQHCJgzvW4iQYrALut+Tm4Lj8?=
 =?us-ascii?Q?kP1qPrRyGdAyfeKXOKXMNoXfQsMtlkPSbSGideycZ+2ujTwC1w++B0NS6IZP?=
 =?us-ascii?Q?rRjwpZuq25aizuMNSa9wkS+HjVt7TyD2Hb924se2XzwCQQzcKm8ckuZHJNJ6?=
 =?us-ascii?Q?uVkFOtqhS5xMxc8auUX7Yo7es8VM87fGbMzXTLp2Mv5u4plosUJhkehgNq85?=
 =?us-ascii?Q?QdRDqa98tls5F9INZzEfeJh7MVi6Ybnav2sEyc6/GMNoTkJ3P/F7OzH/I2k+?=
 =?us-ascii?Q?qmzKAEzeN/2KVkBK0RYbDko4L2z2cv+zpw0EAXS4mUC2U4AeJcJETwZmxf8e?=
 =?us-ascii?Q?psRNTTOcoH5xHL9K8qmcIix5ZhO+reqHsFX8XhDUH4KHYS/mri9iyb5Azf0p?=
 =?us-ascii?Q?QZgaeZErCKwgtpUTrhqwGeRUYXPWjVNLV6T8N8b6ZYYHFSK2jsbVV6ZZtNia?=
 =?us-ascii?Q?eyzcdtsZCr32xRvi7v5SkkFLq6MPER6wB8saOUH58BhGvDyt8uCeXgKp8FRs?=
 =?us-ascii?Q?SkKSQ3jyijUCN5E8lqymVQnQmz/+GPorpH6b4zJLEYAykRxe4WL7rjngjS8b?=
 =?us-ascii?Q?IEXzvbW2noLntOz9ikU6EM62iFz1bU3Lr+nSGGmK1NZIc+GgdTvmkcCdcP/P?=
 =?us-ascii?Q?LNIosiuccJaFgUwB80nbC9ibvOQQf7hsYIYpx4sClkwcoks6M58RQ6m8TMy0?=
 =?us-ascii?Q?V7FCoh3CCW9vaHa/fQ2YnoAkZgaVORKgQpb80peTb6XCktp6yfGXpAuGFfKL?=
 =?us-ascii?Q?QugIESMWXAWR7p3cumOWYRPk6mTjXc7iXWgkWbyBRIezs5poDet3g+IruAfx?=
 =?us-ascii?Q?nAkm4PHfs1twdCLpCZeTzMBCo6krop6hsbGmaoa/dDIhiyWFYMpVlIcc4waN?=
 =?us-ascii?Q?ZifhEYgSU1Jjoz+a9X8tcTCDZrR8Wos43W1VCIDQOuwUN8qpdU9GFDbfv9nL?=
 =?us-ascii?Q?Xr6R5RQnM1QDtsr4VE+/oUPz+xvfO56U8+D1iMx8ORy3D/RF/YeB7vuelUSl?=
 =?us-ascii?Q?JIMoEp++iFpOlyMXiJpav1U8pNxNz+bKiExbrNLW1XPrMLc0OxjSk0xauPkV?=
 =?us-ascii?Q?bvD0qmpFwK0jfolAB4PsHuA71wofRpjAD56Nw9zWcOY3NfdWlYmvQ4vbobob?=
 =?us-ascii?Q?aQU+t9Q0osacaWs+csLCKoc7d7KFI6NjhT6eMVEVGlq7RZsaFfb0Cw/5kHPH?=
 =?us-ascii?Q?Jqx2C5BmG0QWZnYr5mY4rotun3sFS18IUohPvOuCf5e72c36bwFR71OD44xV?=
 =?us-ascii?Q?UAFX/AjjXeM4uJZzfudYMcMSTZ7r2OVL6JgjaAvhkb7SlMZ6/KX7OSCB6kVV?=
 =?us-ascii?Q?6N77BiF5Jz81+EY+f2xRGPQ8PhmDVchB+tEUxCt7Osyu2jxUkZGYQ0AOxXvI?=
 =?us-ascii?Q?IeuxaSUBLcyHvTaySlh5nSwQW7xvlpSmRo77vn5/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e443071a-98e9-4962-5212-08dab6916929
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 14:01:27.8267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Fm2t2/SnnURIxhu/RoIyt5jqyCKPjXjNgsb2c4X1wu3xyo6Q9vhBv7rO+y7coiy6tKjcrAhhDOsR62zV4uMnA==
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

From: Or Gerlitz <ogerlitz@nvidia.com>

Currently the doorbell function always asks for completion to be generated.

Refactor things such that all existing call sites are untouched and no
branching is added. This is done using inner function which can be invoked
directly in cases completion is not desired (as done in downstream patch).

No functional change here.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 30c456bfc1c8..101b7630b046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -211,10 +211,10 @@ static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
 }
 
 static inline void
-mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
-		struct mlx5_wqe_ctrl_seg *ctrl)
+__mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
+		  struct mlx5_wqe_ctrl_seg *ctrl, u8 cq_update)
 {
-	ctrl->fm_ce_se |= MLX5_WQE_CTRL_CQ_UPDATE;
+	ctrl->fm_ce_se |= cq_update;
 	/* ensure wqe is visible to device before updating doorbell record */
 	dma_wmb();
 
@@ -228,6 +228,13 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
 	mlx5_write64((__be32 *)ctrl, uar_map);
 }
 
+static inline void
+mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
+		struct mlx5_wqe_ctrl_seg *ctrl)
+{
+	__mlx5e_notify_hw(wq, pc, uar_map, ctrl, MLX5_WQE_CTRL_CQ_UPDATE);
+}
+
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
 {
 	struct mlx5_core_cq *mcq;
-- 
2.31.1

