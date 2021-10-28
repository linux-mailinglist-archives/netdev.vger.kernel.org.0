Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498AB43DFBD
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 13:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhJ1LJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 07:09:36 -0400
Received: from mail-dm6nam10on2099.outbound.protection.outlook.com ([40.107.93.99]:59585
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230122AbhJ1LJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 07:09:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUE00h7lIlZzjxLl7qLYJjetYYwfs1rL7tdBoSCfUS7sTdpdrdyNJXEOFRDH3qkWvxdBnfuKok462tQoWeiLNHSJ3lDsDoOz8lvneI5U+2Lb9XLG2sXkqWGnHtJJ5GtLeRpSKMMMmkLZmgbFiDQ0LL7A5+/jeNbv6zwH4an9kEdqJy/oUKljJo4ABAwnrA0iOG5ltGJ5diyG40c3ez6mQ8/zvmiFM1ZhhUq3hIPlq8zbln69LjmPXtDrC9qAgqbOlX0Dji9l4bX4KK3FUa4au3BRijqE3CD85yu4BQqwIsyh/RCUKILtCTiGp4MYSKA+4nzy/ky8bpHggyPVdnY+2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RL3jsd86yh7cTszKZmgqOIgBeWvug0WTIIC967M9t+U=;
 b=RGpwK9UkoF8W2ZLSN3o0iYPF5sBZWNAgL2LXSzS+6cKG0/BDlb2d4FXJ1Xt3OcJoPcORFrCx7bCtFCwybDn7NzdH5Yz0dBahymFLQUXsk9Y7XjIDq4kL56XKmkY1LFR0xuAtOFieFb7N8GXUfkK+uH3S7d+J1YrePsTVFaPuEnEXiI675cb6lmM9av3tMoh0RxB9e6Gc0bM3J4OOcDtwXL4PmE1JqEUWcV2KOR3etM/tGykOzV4F5CgK7mV5MXsHEMEhRiK+ErOXTPw62VhYlIVz8bLjxnm+KXm+4Uiza/T7OdEi2LIrG5ZMaR5E1c0TjEA1jyiA/AJu7W+Ibnq5/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL3jsd86yh7cTszKZmgqOIgBeWvug0WTIIC967M9t+U=;
 b=Qr4AS+iDdQcQdEBnUExdcfDmasgY4aaQhpU5clkHbWjbTRGUK+42wrQQ/xxtBAkMrlvs4/VBoBWTb1NcV+zm7BwVJBqx/NwFpntbopXjOyVO1eY2tWow3fGEoRlzD7TTMKzVI7TKPAcfV7WGLbPyTQdq1I7MD2fYuN2AwCgyo+g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5764.namprd13.prod.outlook.com (2603:10b6:510:11b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 28 Oct
 2021 11:07:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4669.005; Thu, 28 Oct 2021
 11:07:08 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v3 2/8] flow_offload: reject to offload tc actions in offload drivers
Date:   Thu, 28 Oct 2021 13:06:40 +0200
Message-Id: <20211028110646.13791-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211028110646.13791-1-simon.horman@corigine.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR03CA0040.eurprd03.prod.outlook.com (2603:10a6:208::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 11:07:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d85c85fd-c6ac-4f08-3d2a-08d99a031589
X-MS-TrafficTypeDiagnostic: PH0PR13MB5764:
X-Microsoft-Antispam-PRVS: <PH0PR13MB57643689C2435A8931B17C7AE8869@PH0PR13MB5764.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dzf7Xut4kRM5mUnYVhQHo2L7T3+rgsdlffZcRr1dnw2nVJ61L7fdy2wyhg0U6PUYJMHEWaihRi3Ffq35ip4EuDqTZvYf3EQdqJN+9BlziGzisoU6s4RwXWh5TE21vAsu82V0r3Y77mla1UaPEtD2EWtCWAvaCxWGATogWkW3pkPKhalKZJtcVcAQQ9ghiANMJohJwW6+VbIqtIUyOgxJY8kv6n92oL2lZ1nbexQlP2TiTLk+zEZmLrdy0q1Hnw9pZu0Sw853HlwVbYBGwELAByKZ3ZvzN1fUP7JZ4UYLpj4pv9TjVCAZbilFwk52hCSwx7+iapNKWQk6h22jPLjaafg6eEI6UjlM3xz7iB0FXorH+Xg3CTg+7RNAUltJC0QFCMvwhiFZWmi9flc4XQ7fNKyd3R3KhxkbKJrRksk9L+fnOC4elW6vwbcxAF+xnAu8l/HPUtqZp3ThpfxWjIGbiqlZ/2HUKopojDfEVlUOfkIUVJBJ3qNY6cNib4sU3rbBPvhmxwdy/rah+lK/EA08fZLmfAEjLBS/e1yUxOreQAYiAfiqLwoe73UF8AirYjhFoOFx45yWe2utdXQNNUSkdrPeAr3hXD/4WghsCg74uQ2Xv9L/IQrJdVfBpD56wjSKNHwX0To4xZGYryCbeerujA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(136003)(366004)(376002)(346002)(6916009)(6486002)(83380400001)(6506007)(4326008)(5660300002)(1076003)(6666004)(86362001)(52116002)(44832011)(186003)(36756003)(8676002)(508600001)(38100700002)(107886003)(316002)(66556008)(66946007)(54906003)(6512007)(66476007)(2906002)(8936002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uqTxCfnYD4mZiI6IOonTR3eQR9e1/Mu0zf6VdgaNtsX8SGE3apIIaxHOO8Hz?=
 =?us-ascii?Q?1PluRww2JGWPj6x4tAAE23bEpOuL+ImMTsa9FXfPRZbN8PD4neX2BcsiE4Bu?=
 =?us-ascii?Q?a4+guXlZZ00W4+vL2TgPKRqhQuBuldC545SaYZjxzKnqFSTz8OgaxgERbux0?=
 =?us-ascii?Q?ecccYR0dCunobBX6r+PsR1YNmijF5aAiXR5uYjdVNBKks2qoLW42Nw/Xe9gA?=
 =?us-ascii?Q?OF6x8BrFWmbTARJzJbzQ1bJE1fZ04syzleSHltZxDtWFaI79NXvGLzSqfJX3?=
 =?us-ascii?Q?zKo7iulnpqcHMB0J/Q57B4krFrBin4hdQQt08FXW+5crTGwVy9SlNLGzXGyu?=
 =?us-ascii?Q?PBXIJoO0hoBgYuXpubOZLBfO2mWmCMqvyQClnxQ+dxDX7mFhFdexx8qWCJKO?=
 =?us-ascii?Q?Gssg0xNcM5sF8oWzr1pncrGg3leX6bKTM4VSVM4s2g3T44OQDgtwi4AtEkem?=
 =?us-ascii?Q?xRiED8IufkqzInVm7rGQ29yxrMxUYEn999vy6A8sBjUqnzfiFQLieGKmHY9f?=
 =?us-ascii?Q?wA4XHwDqlzaURDAWdYGjZewmlmnkOatM/IxjKgGKY9HzyCuBYGlGXHpZC1Ej?=
 =?us-ascii?Q?gUmOTMYU8XTEOGQr+I5uLq6X/fiHBE//VyD6YoPBWOBrm86X2mr6Gyd8dKfh?=
 =?us-ascii?Q?qXv7ZQY2xIQ5Ekt61PqXFuGOcHuYecq47uEyacweFMRHs/10NrUhAlD8InwN?=
 =?us-ascii?Q?vrZ1deTZxNp05Y2UtHCrQcakj7Er5kYALjjfPl4y1fj759PrgPjfUkxLJIyj?=
 =?us-ascii?Q?FMZ+T91Pf8Ffo3VAxtTNaCHtNatXQIRa4B9C1ZDnp0GhQnfIxRcyM8qpyUaT?=
 =?us-ascii?Q?yX8DmItlrErSU8dMhEhunDwkghHHhJ+R4Cus7NN/iIxleTcY6/y7MMGNUyjy?=
 =?us-ascii?Q?SXanUO22h7vB7bXODhMsFLXQnFYb462hj6v47o/QPnJi4if2euR8PuSsePe9?=
 =?us-ascii?Q?6Xx9XdgegF4BByA87SQJH73bzL/yDmPJ0BzPCF9lm6KYSaf9DZPCqNJyd2+w?=
 =?us-ascii?Q?MzHbEgXCKEgYMdFeaW5PILAIF0i4bpIWoNLKSKAFxejUbv8p5rR4GNRR7e/M?=
 =?us-ascii?Q?Qxiq4ISk99kDiQkH3w1/l5AYQTXj7I1wsJYmAevvTQQloMQmSyL+nKvgQWdK?=
 =?us-ascii?Q?OVvkOrNyx1EBwtQdFciK3WycNTEBDVMdwtXiePPLmgMTC75a1nwKMdZWHR3C?=
 =?us-ascii?Q?krR+hSk4iC+77Za8EoXq/p4+1WuqbqUi09a0gscKGspKLwa8Wv7THYEgec86?=
 =?us-ascii?Q?TzdMoJdi2G0n0nVTbcPrtT56gGZFrlXHLZNf3XASOhPdas1rAQVzrbsoL9hc?=
 =?us-ascii?Q?z4uGG3CXD5qjAF5wxR8SzYBbooQKbL0dGrsGrdtMPZojpwZrCo7yTbXQNiEn?=
 =?us-ascii?Q?YkWWwySQZMxt4dZxQuFymIu5Fx6S2l0/ZjeSukXaF9dtb2/18Hcsh7VGr4TE?=
 =?us-ascii?Q?1kTUWh8jMGxIeUk5v0tg0OCCYvE8tJKvdupMj1xbV1i4ZtJOzZx96V1uMysC?=
 =?us-ascii?Q?x9E8nix6Q3aVDI/y4Qh5UGt4qnvkin6k6JX4IQQOuRFv04gH4ZegVK1haKG6?=
 =?us-ascii?Q?SNAQfYNRwtpzuuYIwehFrMcqPs35AaoyaNKIsnkROCCwia45/Tly/42JE6fI?=
 =?us-ascii?Q?hIc4Y+Uo1dvTY0j8CtLFfUEdefO2zCJ6+mrMd3uvlCMAh1UVScK6bbgs5vPA?=
 =?us-ascii?Q?nBpfsA5xvI3MzWeUiTpGXD/DGy0woP0+LftYcZDBunX2fdZn4RmavNAFVRzv?=
 =?us-ascii?Q?XoQ+wLx/ZG8zyRqkTxmUfeiB7cb1Kac=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d85c85fd-c6ac-4f08-3d2a-08d99a031589
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 11:07:08.7407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mELIMWbqhfZj5sw2jQmb+Escturp1JWYzLBobdODipG7Na2OQy1qwBVP8eKFeTuNzc+DC/YFATj9fvPG5PrMowZduPhzBlU58bLpXS2K8lE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

A follow-up patch will allow users to offload tc actions independent of
classifier in the software datapath.

In preparation for this, teach all drivers that support offload of the flow
tables to reject such configuration as currently none of them support it.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 3 +++
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index e6a4a768b10b..8c9bab932478 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1962,7 +1962,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
-	if (!bnxt_is_netdev_indr_offload(netdev))
+	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 398c6761eeb3..5e69357df295 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -497,6 +497,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 64c0ef57ad42..17190fe17a82 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1867,6 +1867,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
-- 
2.20.1

