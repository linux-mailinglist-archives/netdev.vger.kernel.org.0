Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA816899C0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjBCNbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjBCNax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:30:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27317A0E96
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 05:30:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2b9GWda/2lHNb6Ke7m+xVbnjkJs+BPti3w2vVmzGTIwdPenpLDadU0r0h0XFhjznxnm1eFk10UqfHv0EmcOI72BiNEExa+EmtHG08MB7ioK5/HCeW2gqIAepktTFNZh6umVKiPkh+v+vGoAkf+YXSBfqlW9J8ZEfHR2Gt9+tR9oqLwPIHEYEN/x9cerCh0qvUCbQS7wkAeIcNUaYJnapv/9TMtGjJILG0NGVPDMXMqWWhW0u+tna7ts2mw2pENh43uw2gCgg/PGv5MStRYs9UKUzSzacSwMPlAa2uuo1+VPtdz3crVN8611PbHf6j+haIjH2YTIdUIjKSaPpozBpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/Hi4/D8f4Vy+rOokNSx3pMlHTuX9HP9iTOZ5ZFRWFQ=;
 b=RqoNo9EVIixTH1zVN3WSSNiUztTlEkrxNE6w+KebpympE5JWijCKRvfcqmeGDsV0QZEJ7PmCaNB3N/EPlv/ibsE0nx+YHnLogdJseBAMTf3hR6FtCGb6wRb0xVhYALvBG8qrVuXcwiBA/lEeRJHhi+z7z3Prer6qeeU9Zz25QFlgg7W0JgveJqFgUxY7vmaN4LkkCTAcGZBcU/sRM7hWAEEWofJfsYriCBV8EWbcczyPC2oDsKf/+K5m2evRWtilZ5hEm9r1NkeRkuplTm+VnTgG6Hilxzt/lMc1gnDhRdlMMaPtEq+YFXCjTY/s7JK+0+jmn5yBzH/cOLAK1cDyYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/Hi4/D8f4Vy+rOokNSx3pMlHTuX9HP9iTOZ5ZFRWFQ=;
 b=oQVvoemNi2bJgbtKMkurutcEeWjdEGYT1OX0mx4Y76a3wm+HtGGE0IxF+esYSOMwUiCiZcJxChpQY37PfLuWEzTeM6JnQBhmbIpsWayssG5yHNNTCCZAcr/gFd9P1DrWYeQQuiAs6JuICF2FOMKbLlC7hVXdg8H7mwZ6xirYWOp1QZO1mkMeudy6rztwVo4nfzgmkUXuksh3N6l6h/5Zqfn6556WxSE1bPhNdtVc8fYplgCXtIZqd0PCRKwHTlyoAbjluTKJAYFs/ofNkVPk96HUqnurZ8c9zmEKW/IkoUbeFUQ2ZtZHGR9l/S6MQacaAfZ7NdbnKV3xsmd099WMUQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 13:29:09 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 13:29:09 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v11 16/25] net/mlx5e: Refactor doorbell function to allow avoiding a completion
Date:   Fri,  3 Feb 2023 15:26:56 +0200
Message-Id: <20230203132705.627232-17-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230203132705.627232-1-aaptel@nvidia.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|MW3PR12MB4476:EE_
X-MS-Office365-Filtering-Correlation-Id: 09663308-05f0-4fcc-62a7-08db05eaa154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehkcPsFCxWIsRWpZ0TEqeCqhtlI+4CxvbsDf1CTYsugrSZLOHCxifzh2/ma1A8wM6rIuDezdnW4xsHxj0vR0PT5TuJwRMlkbz5hJ+aT6WGXmjZ0U/uwT/CopfsyJjUQHhM0kGdU6qGpuhroCIcYtW1kANkn6RjLjUMo5k9UKl7/Q3mxXHXgaj+A2x8kqaSqns7elkkCUPKpeWtnVzyPqSurLE5pP22s0oVtcTKPff4P2NytWuJVIThnagn2e29QIyX8LMrk6YZVvEDJ9RuX2zWKlvvTHl5w8cudJAw1ky1xvh9W7aWSZl6C/K62X/Doo66fnfQHO1prZKLDQ7+Db209BNuaZQ/PPALZUSioTm8ohhpGaxJNIvt7ArVWTNLwnMBSvejvRqplB3WEPeS5H5l2ut41f8I4XAnEQv9DKX/2LNXB77GNqZw5cdHuJcJY/6uVvJTSM5vgZbjInEEKiJSh+xGe/0fY94746PHQ6oIyXT15qTbwTzWOpNcZXbZB8Jj6IZXOopt9TR4yzPdEjKLrFoEwdeSkWrC0oOpi2uClkji6gjUV7BXiJCmAl+YiyMiBoO6WUflAOgMWga4Z5HOV13kwjuvvozPRsKyscbph788PjBtlydxQOEWfb3PBPfj559m9C6/Yv7YtJaczdkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199018)(186003)(6512007)(38100700002)(1076003)(6506007)(83380400001)(36756003)(2906002)(26005)(7416002)(478600001)(6666004)(6486002)(107886003)(86362001)(41300700001)(66476007)(66556008)(8676002)(2616005)(316002)(4326008)(66946007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VuJZ6//VvOcVHW1SgsXslElxdoC0mAlGTuET/MU5+n77gw2wZX8AEcQSsfbp?=
 =?us-ascii?Q?JX+amq6wHhErTJQ+Fwu2dB/mAjB5+H3RI5tT0oJ3teOKiNd+vQzqQK0NOjCN?=
 =?us-ascii?Q?leSgNi2EXhbo6Pcs04sjyU2eA5P86OZ0LGwsvwQXC/7VppyU7HHCRf1sk4nu?=
 =?us-ascii?Q?SmrcTsaPAJXF1Nf6txyLAG1zv6T6X2FSI3nLn2ixJoEAxD8MwQoX+0Tmsa5d?=
 =?us-ascii?Q?F63eS0jHuw5g50Xfrq6MzG3tuUfop4UkSZD/9FJMynN0RsCl6Vg3T2sQi7TU?=
 =?us-ascii?Q?+AXsENl5inzvvzaflgZIQaDD3YLZ4UhEk6MFfJZvZ4WY2ef0BsFzo2Nh7BVK?=
 =?us-ascii?Q?1sdAns5BNAEMM0Rg8tQAk1uv1h+Wh7F+7lek2xYqmrUw4hiF5TWimZ7i7S/o?=
 =?us-ascii?Q?GIQlxbAl53CXvWTNvcbVXgflKDocrZ3xqZc2KnlhHsImmySEoxIr0dq3EqPG?=
 =?us-ascii?Q?p7JnD6vufF7NlHxdn+/Q5UbWmzz3GgZl54vAxqn5yav6qTrMTNJiRF1lPC5n?=
 =?us-ascii?Q?c/1aj9leArzF90+yPvmq0Fn17/3kgKx9Fas4p0RtVwHmdp4Z1uLLWh43Wsmz?=
 =?us-ascii?Q?RCjlfEAFSfcxQVedt2VbXMSdPYJNFHFb+IPxrnzbWX32yVVROm6bcS/F7eq6?=
 =?us-ascii?Q?h/OfpkgVOFJQ81+bn2JtTim2/z54nAmXZb17a6chLh//AXIwuolwoWp9PEvz?=
 =?us-ascii?Q?qNwx7P237Q18/kKvswG1ubL3OY2ZZ+iQwzxg8jC50O6vRlWPbJYLfwKgNrq3?=
 =?us-ascii?Q?o3vWFtJhID/8uON4Wa0A7/vgJ58kY52N3kSv8ZjG38Uc3GUov/IRA/inuNOu?=
 =?us-ascii?Q?/GQG0djaLGRp9t40RmA2l3QSbZ4+CxztFqLXJ0jncUNcSDCVmRfIpgdnY9a6?=
 =?us-ascii?Q?wgPMxM0+CdFo3/qSCWzgke3232kdyluGETW3Xw9WsCtYOTuMAstAwIVZ7cGp?=
 =?us-ascii?Q?EIxpRMpDuwmxxuZJIbDVGQU7P8EHyASv1py6Dljjv5ae1rpf9yLClIAXcZMa?=
 =?us-ascii?Q?q4o4u27gSsSCw328mTY3DidBfCOKo2Yw9NLLdnOfs5m15asMNM28yh9sdOVC?=
 =?us-ascii?Q?UDBvKHbZMS1Ssxzn3TkL/BsodqUvQGDgXD3F0Cjj7VmPh80JlzEMpdG7Coy9?=
 =?us-ascii?Q?MEIZRYN9DajyufPbqOiebsvwH7V9+Jrb7yyeoEoQknwGiiOYQLjSWyoMOUzK?=
 =?us-ascii?Q?da8G/VqVigwK6LAPVXNv0qwIsQT9t8Z7mMdCGv5S+0sF+BvU+/P3YNvCNmQm?=
 =?us-ascii?Q?wLR9VPYAddeSVxVu1Kq5qcxSL/ijdvWZUQNsbG2MfeWRPQG3J05EnIlXZrN4?=
 =?us-ascii?Q?u9SaY5ogBwoF/Kul2tfYRwn/OqvW62yMysD+pID43vGsh3Kx2gv0FjxwNt7L?=
 =?us-ascii?Q?pb5QHikeEzzmApA7a5/OSDH1kLXS9FmvIuWiaUav9tXcUvSvitKeEV0vUUAR?=
 =?us-ascii?Q?0R9zo+QKjzf8oXBwgMKOUjHB3SZOWM3MkoPwTR/nkA6MONtrkJFGjZh4cdEM?=
 =?us-ascii?Q?ghDorluPsI31WIuEzMq/34tEzbvFN7U+bGhnDKPst/4cRnU+5oZhtw3oU78c?=
 =?us-ascii?Q?47q/BIGSDHnNh1i2XzitQKfy7+nhPGNmkoDB5ik+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09663308-05f0-4fcc-62a7-08db05eaa154
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 13:29:09.1767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9H+yt0G2UQUHnZHk/XaYN9E5ZUTV1CdBYq09zxWObZal6DtPv5oRfv0hICNg87Sp9Mb/PStrzZ72tSU0g8G7Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
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
index 92a71d1a7605..37217e4cc118 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -243,10 +243,10 @@ static inline u16 mlx5e_icosq_get_next_pi(struct mlx5e_icosq *sq, u16 size)
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
 
@@ -260,6 +260,13 @@ mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc, void __iomem *uar_map,
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

