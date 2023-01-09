Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEC166272C
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 14:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236849AbjAINeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 08:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237054AbjAINdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 08:33:12 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC34E271A0
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 05:33:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWos0gApkbFhOC9u0FPENmludfjdehXib5pW1SDAfwMT+ssWEdaE9r+sxs5V3visYlWT5VzbwY4uL9i32+CbW9rVQvNQ237XlNnINT7H6orn8onHkkZ/HFEtQX3dg5YFn7SZx7m30I/DeFUoI0dxCCUoM9UFi6wwcYUEjMD9LA9C5QlzSSjn/4g28hOQ97V8U/out6JatlDnJUN0ca48mMm+SVi/DOrYkDhUypTiE9XPv/c/rTsZuax1d1JfzF6i0YlOrIBsXihpfmKJ48HLebrbSpQ1c0CxGoVuJvsugC/mdrfCmoJoP7FcgfJ0dCs1aDia0nt+hQmRLsIyYSrWrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzHGuklrol7s3+JBvut22Mhwr3AvA8YrfT5UAUgnXRk=;
 b=Eg43RgSA+Ct5q6wkD93dtfyaRWiG44anw83coMyHuFy8fxrjhQvy1lNCqRkrY1PEVW8pbPapH91/ZTlKnh+2GFg0c2LWq/6KeaaGSgmudyFQL/qasT1ctO7W7UIJNp7HtjOcfJmXRel2Sb2Y3FMCVqlqDHwv8kARqWARAkF0g3CWGU6xjOx0Btt1sNkvMnsgG6bMa0nnCVWX//JuMWj0LvYKuBZAhnLw/ZpW8uJL5qYgeUrPKe8yrCh6DgYd5j5GUQekPTVlifA374cO5fybvbYFNkmQFQHN96vUyp2f8fqYVQjjrqXCC8EDk3JiW5ryfPubOipS1AWjtQbj8Gl60Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzHGuklrol7s3+JBvut22Mhwr3AvA8YrfT5UAUgnXRk=;
 b=fn57CLSWAOdeY5ba8SIogbDdkWAw9u8TCxwMLQYBvHLrrAZf2YRm/vVXPlper3rJmCgqUvowSdVZ99JeHZwV0UPoOjPsrbSarKmwguW1dL1gGgJp0dGIT5axdGKikimu3/YY8viG2f6xnA5f7eSIU7X7RhJJW6rKv35hWTzzu3wY2sSg7KZSQ2/qmUjid0AG6//QqHbkvRuaG8z+DJmUPRbQVYk8VMaL17nLDHBytDNlIgOueTSdSAFVEb4/lsKbSnUhiNoOgDRFYIAffJaD5qdw7ujXttlwiKPCp3FNMjZkgNRq7gkvuQjjQ4sfV+xRHPeYhNFaZDeUHFlQ1I0jYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by DM4PR12MB5056.namprd12.prod.outlook.com (2603:10b6:5:38b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:33:08 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::6d66:a4bb:4018:3c70%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:33:08 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Or Gerlitz <ogerlitz@nvidia.com>,
        Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, yorayz@nvidia.com,
        borisp@nvidia.com
Subject: [PATCH v8 16/25] net/mlx5e: Refactor doorbell function to allow avoiding a completion
Date:   Mon,  9 Jan 2023 15:31:07 +0200
Message-Id: <20230109133116.20801-17-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230109133116.20801-1-aaptel@nvidia.com>
References: <20230109133116.20801-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0449.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::22) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|DM4PR12MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: d9886191-9bd1-45de-8f1e-08daf2460b73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /q1F2PBV2DK1WfOgmZ0Sj/+5UrIdXsmjK2KftG5QdtcTBVSyPxXHyMfwGkpLAn84eEm1whcVqEY7zLnxbhbaJwGPOZMRlhgSLb9eKLoEA6bs060v+7ZgvlEcnQuvVAp/R975NoemKbOM5ZXd2SxGF9d9K4Pfp1IrGfmNDtLl4HTFc0IguHBcL8bsVTuk9SFFXFKkN8qHHqNPgyLOzSHz5urHUaUB1I0/qjwP6wwCT9IkeutP+kqYeMksB1iIbMQtMP3KduBKz1MacijTzPBsjBQCMHDoXRvzFMU1mDpUHQLkcUqVv8/pJ3Tu36ZrZnvPB4sISDNV8sgoqAHPyyYxTlC1FJQib/lF2z8oRcRQwYhnQA/lrBLvowp9B+murVSBbrpjtYckTwAKJoo/DU8+VRsSmTcFWJ+mWGCeA2aePwhMtTiLisGKsebQYWLjVCOkN6dtPId/J4yc8/wg1egWuV2b2lUmIx0H23BX6C+iVIYOuoYkUTr70bYsezMpQzJcjO7eyn2h/kNdMueKCid5Xm+S9mQ/CMmH6hmN1NHJQYEuZYD43xDk+HovGiiHgPvztTmOA+gcPvxXbFasWru8p0RWoLeeR6Yj5X+vCFY6iQzrkYaFVVNFZuwfKC9Ttql6LwbjKej/uwijOu8ynT+qrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(451199015)(2906002)(83380400001)(54906003)(1076003)(2616005)(66476007)(7416002)(66556008)(5660300002)(66946007)(107886003)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W1vtstk/YpL/c/ns4Ol/5V5I7rbmqEPQAuheaJpQk7ehVEy5WtWQJqWPeoAz?=
 =?us-ascii?Q?NONJ5CrSfKQqeB3HiFneJZZj0Iix5zVBm5yB0ro9P7/nIylSkUcoFUir0Fsz?=
 =?us-ascii?Q?k0qZuuaq98dtnkdIQoR0p3bS3Uh12dlefqXcM7ExZEPYHvVA2c/Mdsg/7f8j?=
 =?us-ascii?Q?FMrmG13jtM3duR00hvn3vx9OHJEWqsaNjeg1tATq3niDFiOB6sY6qRtadZ4y?=
 =?us-ascii?Q?r3tFP6kC4OW9xzJtiS+BRny/QuHU7bb/T9Ap8csv7sFGRwGebV/tYDHLGYgY?=
 =?us-ascii?Q?H09IxmSB/+k0pBOmbPNc4P9y0rrvZVqXVgek4xEkUgwd2CxpN0Oa5VRnzsH7?=
 =?us-ascii?Q?1e6DBeLmHtyI8qyPstJRaZf6W08X70FBzIO4Bvl3hQn/Imk1uqn/2SqgoOb6?=
 =?us-ascii?Q?r9cOtiDhKl9ewSq6PG3VAjc3Ja9eMaQ/Mryo7EIGuWMwczlqUlBPnv1FJ1oe?=
 =?us-ascii?Q?yChEBXfb7BaDfOXPhF0l9DE0cR8jaAfTZEl0i07+3uaB2eSG84YN+Acr5fDR?=
 =?us-ascii?Q?cZwsEGtWi1du6i1Mb3oQvbpJJjIgXlXucwTiUlX7k7Ncpy5O0Ulh68qDuMtH?=
 =?us-ascii?Q?alYf+3ReQOv4bdZbFq5cEqnK72e8IOt8+YKVR5XEIsqlNarDLIfcE4c4l+2g?=
 =?us-ascii?Q?ecyX0MrtnUgNNJE4RRYjsyl3FngmtZjwDysB6R0zNOTo7N69sAvVVBCe0p/K?=
 =?us-ascii?Q?wSV0eo3UEw5SnoJTSR8/NaBdYixlZvPncEkyFIuNN5lhkGq7YxC232i+svLq?=
 =?us-ascii?Q?rpC6SO3IOPLLMLK71IM9g2+cELVQ5T8gGXTbzEPYnVb7+aLY18bbLLQri8y5?=
 =?us-ascii?Q?toI7SXZCPdA21I+Lz2V/oIF/bc1Mvo2F0KwsotR3cp3Zohhr6FneNqPvhMFg?=
 =?us-ascii?Q?MtVCLwKmqaN1Zy1cz6VOv+uVkNWy6F3GTcLpkMvuJNmJBKXzDgw3K0YGmvAc?=
 =?us-ascii?Q?iNLLvyNPiHPFZZCjWy9nPXGuDQ50yIS8lcSZSOsAuwvb/Gw6BTE6Jl/px2VB?=
 =?us-ascii?Q?nGexSGTisstBDuUsmoERzvkwR8gK0T80phK9uHznP5tg4sG0MeO5X/va+bMj?=
 =?us-ascii?Q?X+KUxmwj8MR6TV8vPO7nOgGkR8Ll8ySxkH+YM4Gs8pUDrKW7CTXgr/7aZh/o?=
 =?us-ascii?Q?+jzXLxigCJSoQqBr1nR7wXKU4Z/MBChy3WDSz0Tqa+PIgtfOJJnmjAMuk6EH?=
 =?us-ascii?Q?KOcjHCptKHhXzcTSmNW5IqjHLVqOBK6oajgRTkhrmdtCQqJJk/7HjxsuJEd8?=
 =?us-ascii?Q?suca2CYEm1Smx9W1xmX6gk0PtFSzvhOKsjdAYmh84Lta013O2N9jCttSMHRi?=
 =?us-ascii?Q?5wOaWAfXUo1ziuH/RuYum7xZXCBe6uFkicvsR/wAPCcWLkhnjVGGIzODPVbB?=
 =?us-ascii?Q?Inn2Jrwv8me5LrLvkq8bBuWDvgBL1jqYaOP0x2HCJXw44z9dzcMUuFt+7SIx?=
 =?us-ascii?Q?3GBOKoT7kVOg4Sd2TQlQwdtdoCOfHfIl+wq3rFiZR4av2I5+WTjrBKUL4GL7?=
 =?us-ascii?Q?lEU0VIdTfLrKgOPy6w3ruKXomNaMPBP3yD2X7ITeN0uZMxo5RBRJtdOY6x0l?=
 =?us-ascii?Q?UXyihS403SW7qOTXxa9tVK9k+APHeFUwE2u4G1Eb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9886191-9bd1-45de-8f1e-08daf2460b73
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:33:08.0726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/2Ln0bp//r4bjq8z3I4Zfqtu9zocg6mpFTZJMAGqyoO0OHZn76ZxuZcsBH0r5xRLD2b7OOaYoO5V3T//YOqYg==
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
index a7799cee9918..a690a90a4c9c 100644
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

