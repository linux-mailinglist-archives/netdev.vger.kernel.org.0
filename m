Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDD467D148
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbjAZQYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbjAZQYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:24:54 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB66B746
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:24:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMVhybnWJ8xBBygfJg5/noLUudxeeXCWgZshjW2VccdWne5LHRTxUiT1j0Aj3SqNmeKZFMXebo5Vfs3YV8BP03hLdfIGc0AHS5loONoGDUsw6UyOHtNZs0x0nwKHV8qC55F9gTKWuK7/YsIZqo+zy6guPkz+g/9KqxEsdyLb3C3VCoZD7UC5VCwy5JIIKe8EX/309YUaPajrjtE7rHS30lVHWzcG22SOXxbtbbVeNkm1WEaumMQfX01pU9fB0fvwhRWFT/XOcmaW5BhlmWPTl2mD87jCEQYGGDTAl9DEuU35mAIL1sTSqG01os3VCZYKKCWIcBHsU53hDyxHDml7hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knAAhViDfNDVIgIo6yS0shaDL9jkepiMpMhFEPjDsfk=;
 b=bKU+sZQbYmVjoeFEJ8AFB8T37QNb/eGiwNlQqaogzmBziGa260MdZHFS5svgVvY/pV7c4CijwSb95q38PQilSS/jTRBphpinUTboATnsfvSkkAfx3sVQMxy0/Z+gBKMnaCMmJn34AR2d70ueufi0QjHnM9ean7H3ye54ax1utkaKTcZWyJs+K0j4lrwmTnJD0hujjsClGHise7MpoFjAMMiBmmS4aBjS5GYGpV83DSQJ5bP+wXmTwuhoVaXWPGJapSsbFqtIf2w6C5Uqr2Jad5W062glqWyTQ87or6Ro4aiI91T1U/7D2TIz4EoYM/96HuQQs8/jJ5MX68y+F58moQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knAAhViDfNDVIgIo6yS0shaDL9jkepiMpMhFEPjDsfk=;
 b=qs9pgt0iJUF1jrhd/Avkpaw9rPxZZtw/in+IMUmz60YTGkIOW1EKpOwDW5grnpvu+lcevvrGpFqMZnoKKlOUIF8/+f63O6lIdPJTTzD0NBD/LazDUJZPzfrDrBkjKrxCxts1nVomKwQFn3zjqatXzdgfMU+rgK9Rh/puiHNgQpmFUGXCfAk4AjVRIYk0MCrIhyjZyNvoU2OhFj335dIeTM28lN+qb1oX0UMHVXHMlyWkrCYOHHshdffTEBmvM3pE4euQudH8Xm9b9CwzHwfwGzC4g29KjwRm1yUG6swjBbkWn5y5XrJHzJFPklZtzHhHXI07Bf92l6miqw+Bx7YMcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CY5PR12MB6180.namprd12.prod.outlook.com (2603:10b6:930:23::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 16:23:27 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:23:27 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 16/25] net/mlx5e: Refactor doorbell function to allow avoiding a completion
Date:   Thu, 26 Jan 2023 18:21:27 +0200
Message-Id: <20230126162136.13003-17-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a4::13) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CY5PR12MB6180:EE_
X-MS-Office365-Filtering-Correlation-Id: 68156038-5daf-45f9-b1e7-08daffb9a762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X5KX9cWqE7190GFIO/gIoA6HK+v0oeAp8dHbHsclbf2er7gdU64Wxgq4vb2gcwygwmBeglIIZLxyRik0z0WLKedrGTSkb2LSkV2/podzbRO2RHFOUAZjIE7t4Z+aIlTLVPOFIKBLBVJ59Zwxr2xaxT4kUm6f4z8JKOrW5DXHMkUxvwl47zf0PKSrpEFYNqQOChNz1fg7JZlxJ4pXIXdqjt25rEcuWc9he6eQyBdDjs7WF+f8waH/0OYWXiOKnRkcXUFOQXJ/YpPSlNzW0IdIWP94ixA1fvMAPQYRjWPhV8fmwN1uWM0zi6GGFQ9ODuMcwW0SvkdOlCMe/UpiBJBN3baj1sACjXwa4ExC6PJEUobstbI/5SbHdbw2YCvqv/OCjPlGvj46UTOUXZyzAQb6cvAtcH70HUH4vB8h9bh14vU5VaV1s9rur9zBIBuhl5fzSybOIKWIoKFg6+uIhZNKsxRZljINPZHZikrK2G9gMhdbyZSBGk1/OTy7iTG/DrRupGQdyOSZrNTHxZN6D+SGYjHt6M6PysZ7ogCqPMIvwiZFRr+LJZQtwDjudW3F7rVSlkzjFYG+AEUKJIbUIWFbDSZPH97Ba8C8GdKnRRVFYSfSSH1aJgse0p1N+ubdQgnpf9BPr0E8UluWIqwJO29wqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199018)(36756003)(8676002)(316002)(478600001)(107886003)(1076003)(6506007)(6486002)(5660300002)(7416002)(66946007)(2906002)(4326008)(66556008)(66476007)(8936002)(41300700001)(38100700002)(6512007)(26005)(2616005)(83380400001)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HhdXInTeQqzV1FyVYNuAlhWKlSZIqagSAPoCSVRICHhFfLIV7MIxUnGzc6mv?=
 =?us-ascii?Q?72XDfHHFTxliuznsIZhq6tJXN0RMcD3eiAm/GLBMT4NlbBtaypK7+dpJC6zU?=
 =?us-ascii?Q?xe/g0gkNBgqu4YRJxLRqi4Azo71SZIJ0VvU4Kj5ZOiD+OWpRSWwmfeoKQ50V?=
 =?us-ascii?Q?Bo+Tv0A5fkj1vASaezcENOVM3mnKEwFTtDz2FwzJ+G0+qjDHlw9aNmJN8nCs?=
 =?us-ascii?Q?46CwzYongraYbXD+RjCmci+WQBAoWdOrMsEQLlJE0Pqg7jwnlHhl3OJXkKYy?=
 =?us-ascii?Q?CVf2WEPfhI2yU5qXjz5n3fMwkbImoocMEOPjT7yEqt/2uTCT+xMJFloaNcox?=
 =?us-ascii?Q?mfWlWTpCyctxoAix/Oea3G5smNU58/4t8LXvSDg3dqesNRKYuAojy12/QyNR?=
 =?us-ascii?Q?pSOYNPsrqxLAcvXhPNnetzUrJ0Mzy3Zos5qhu5984pIjoQ1B1lxp1Ey3cLI4?=
 =?us-ascii?Q?dFa9IMnNlJTtjQ/tz3kWLLcGr0Mv9WAxcoiqqd2r4Vh18ZpiCJMua5YOYV1j?=
 =?us-ascii?Q?kPkKRILl1NNZlnmourC2dSYRP1/Bkl1kk6AG9bMmNwZFeIsKFWn2cbcYF7dJ?=
 =?us-ascii?Q?sDzUPFGLwjRxD7C2VibPBOykLg2fhXYP9VUtI7PXOUeCbiiaorDs0Q/yDyMq?=
 =?us-ascii?Q?NC71pxJGH/aNaqhiDPwOwqrkNvk4EVx+dklBKccKrKuVWn3Uf2jc1RTEAxaJ?=
 =?us-ascii?Q?TpV0C9k41Ih08JeM9cfEhdV0sITIXBarVWWXG4JPBX4h8L7U0PNaf/0iAvG+?=
 =?us-ascii?Q?ug1YADNPtWDpANHaLV+3nF/Q9tF6W9OIhkFBbdHFKlS/VT6fTc4lS9/ZZIHL?=
 =?us-ascii?Q?u5ItaIX/rDTUFLAFoKqmjD3uIKOdOoyWV4RvduGOdV08zbYQWmxOEo+HUBL+?=
 =?us-ascii?Q?YjsBeQr4YoNFjBxWMWhU5HPb0WYty+LuXt8cdZEUYx5cldmzA+PikmDam/qC?=
 =?us-ascii?Q?6QPcj8mFZu4AwsAc/N6+SG+AstM81H/MjKAA/qCHg/b1E2u71jMD7qz/l+B5?=
 =?us-ascii?Q?+Jm7wXLEIwxsEWNIOlCyDbfJUw8Q0NFmAWZkZmlZZMO14JTB+XbeNWjZIpSd?=
 =?us-ascii?Q?GfvYIr2afbS27wAd16yxYgRgjuFGoGx+ALgUH98KJPQiHOnqpGZJ472ytrLq?=
 =?us-ascii?Q?3K5MPQnAJD06CHgAx7WslICdf3tsL80g1hoRJG8PPxL6xq9gr5N3vbwGHwa/?=
 =?us-ascii?Q?2jTJSlSH8g9DEz0B6dvUa0R9GRQJwoJKFWaUAUV0XtgpHN6/XvdnBFjnqP7M?=
 =?us-ascii?Q?/pEeiHJsDwTD/tuNO4T/5ezqSPtf7DGiuc9/Bl4/3BcqA+o60ygYfD3mLdD1?=
 =?us-ascii?Q?SkenpS3AlJKoAFMV0rciWnXnTZ83dmmR2hOZvpRgA1l26KhhWnwhVL6CPlW5?=
 =?us-ascii?Q?IADl+lWUMKuWUVDlwmbUAl5aXaxTN0q14BwvW6zP4P56/3njwaELdS2vrOMS?=
 =?us-ascii?Q?Ge/mY6wQvcab2hbM1PLy4rP3qFibzIFK+pr31VSSkOKDTtVVpnRvEuSVSqe6?=
 =?us-ascii?Q?abLI6kysR/ThKWQvK0TIjYfRl277cY2p5tAl8kwhUf1YDnEhs07pe2M+0jgC?=
 =?us-ascii?Q?55e0movVs7Pitk9MVJ2K3s1gTJO8BSKOCt2+24Tg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68156038-5daf-45f9-b1e7-08daffb9a762
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:23:27.0048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pqR9VZHdjrosgeNcibXIPpHGhMce6FnNUB240aIDYrWXgeGdTAoXdFXm89mudk6XUtsUOstV+P0BuFsB+r5jA==
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
index 1d66b858db00..3c1782d58feb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -238,10 +238,10 @@ static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
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
 
@@ -255,6 +255,13 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
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

