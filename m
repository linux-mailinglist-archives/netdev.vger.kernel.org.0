Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692125197C9
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343557AbiEDHHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345218AbiEDHHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:14 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0487322BEE
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzE0gDp+P1MA92FjusiV7zyHuhSNy5aqnEJZTtuYpnLhM9IvKVuxitnycVR3h7yr4g1F1kGrHeJXjv0IiltfwRcARB215pqEW8+F7HQYG7Sc1bXLx+HMl2GbbiKD/ypBY39OQWZOfOgS0AxZ1nuiSVNdpzbFwMsgvX2sTmWGjoUCB6tue0N1Gm9h79KvhDgl+5dlCcAG1iasmNKz8WNrC2UY5gIGzSCYJF+btO12WSlJOK4bLP/Qb/GMESP/dklA/bMqRJNOczncmsKUV7EkbFCbh27IsEGwVoTNsDbUm/Qz09XTMfDoEUk8G3XqcqvQz3gCkYsdQDsvA6dyIZuVvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8GJYyDZ9srV2tBcOHZWfxf20z+oCik05HywJrHSfro=;
 b=LaZu+t1WmUp760MtzgFPGh1crquP29fCjGMrK1qzZDpjQOCdjLuQAca1Pj6Zue/0BCV3e09Y/LRaUVLo/wu3zK4le+frCL1KEM+VbHM6uZxmoJek3CVtZcYS0/q+CXIR+aECjMkxRuSv/u9R6040NI+0zNI4TEf62e29WpZlGYZA85DSiwwbwYYRwxxQIELHBVhCIv1i79eNnkC1sGpXyz4crRXqt+SXcXsXD4qxYvUjXyhAG3rkK3yu/LN7v79OBuLNErvN1GSbX+/okT+LKkxyxJJVIvB48miJHaBthfBig/+L9YmOlpduL+rk0YgljcV2k8im7nXSWxr8pgHcLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8GJYyDZ9srV2tBcOHZWfxf20z+oCik05HywJrHSfro=;
 b=q+cMomvfguIXBAaKkuSzlRGeKEwyTJNOd/zx624eNzDqBpTmOpnjy80yY0/BMDXC9jBkWi4W1hroSdldByeM//Ui8PjthjUo7nuWnbimpUCzx1ZM1dzN6qxPxxdAFyA3XrfGPq19QUQ8Ewucvup7vfTXMfCBUyrTOa6QcX3t/0u7oR90tdQkniXAswRsYlH2KfSb5GkovGBlOKtfkTjvUE5bErY6zhn0D8hyvzh12bM4R/XGi7av7oKZ6kcroMLOQg7K1P4L7Q/UFZbOg+HMLR1+2o/RPxelZwRWkBhtJyScDOufYziC789OUnsyNHlMMZq2DwHZBuTOvrEhoBNQyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:27 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:27 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 13/15] net/mlx5: Fix deadlock in sync reset flow
Date:   Wed,  4 May 2022 00:02:54 -0700
Message-Id: <20220504070256.694458-14-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0034.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::47) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab6b7df1-ded7-4b9f-562a-08da2d9c301a
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4503A0D0FA6F38F8E997D5CBB3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fa4u2l8yjdIJTPvwqJWnHvWulKk1w0oeGpp7u5GsL266YSmD2uLiPt3UCnctf1V2AtpZgzu5RUZHOwnZrfCnopnRCeiTUEa4bjC9NkJrj9m6tmcmTDljtHDqqK9DvTpE6d2OLC2eLMOC1dPJRIpynBASxjwV6/RdNiPolr7+lHO9M1vkT5wqabXLS22ymMhQINeklzsTFtN/YfPYQ+UcvN6+yxQUpg0M5I7HeOXUkHtrCspSs666nEVu6MwpPxTjOloziPgeNiEb0Py04Q2mkfE70cCQTmKdP0iniT6iQuMqDrJdInpu65BZVjxBDSxdOf+gFBH+xcUvdOpTlymZR/WsnKUbnTjDgFtW7MjXz2YSeAB1F2Lip5U4/2eGEJwIWFC8lxvzH1VWrCPlahvGA8q/u7BVcqEYgdzxHtcIJsGfqPhQ1pPyYxV2ofXUh9wOfisRVCQ8JPHoz1kNxOC7EMgKfPBtLA90wofT1divbTUP6U5bbIMe2aQrez64jW4wWZTTTIHG3ZDTppWRcjDCtQ2c2op04kS+WVqBUNYFclOEaeYizgrfsixPXjlTknwraiNxkuwwueTK897oiSc83jziTusNVvmxKzb+zKVhV+xDzYF93Uc26bCTaKcVjOsd8fmLZFzDfi9bB0Kg1F6sLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AprMDriIj8t624hTiHTV4YZ81ELv9AAbHHMIMK2sak3Kbg62GkHxVNhjAFBM?=
 =?us-ascii?Q?X/1VKgI4k7ro5+22+MVBDvYLUSGvU1mfAQNb9BWfsy4BYIrxdazbjGg6tMaB?=
 =?us-ascii?Q?MC/RYDC2jU/Pbe1Cnq/VvbKwzkQFxXBuE64aKv41zgfVN47HYObaN37ggv+A?=
 =?us-ascii?Q?G8TiHa3gboEQD4fmcA36M9vQAnSiUowMhyWJPslZcqKl7BqBRhFyPGtmq2lw?=
 =?us-ascii?Q?pK1Skg6ANdAf506Sr4aQ2Sj2tPUG6WcEZ9ZNCZv3X+dOKYAU+77BkDmZn+Vc?=
 =?us-ascii?Q?pYuMsQVusNhEUX/3QIlkwPcKzEAsZLD9gGN//+6hCksaRaaUKJuH32ZmEQVP?=
 =?us-ascii?Q?oZloMo5vYwJdnQCYSnNFVQJkl6vYcbD9lU4nqsMku6JwSHDRjNyZb6GCD8xn?=
 =?us-ascii?Q?Sp74HOskseM7RD1V5rMMquqdyu3rRRzL+EnjsBeTMen2IzWAAyTCLMACOaUF?=
 =?us-ascii?Q?Xc+nCSagFwqy87jYE1a4Q5x83anTRf/cAAfktDSNIE47ojIsRMQxC34cwnky?=
 =?us-ascii?Q?ew09RFGXpOVxYuG3GXNAg34GSDBi3g8KF60j0US5HfaYjPVcbHGqItH75GV+?=
 =?us-ascii?Q?g3vcH9Gb1Lo9zjjTWYgU6UMMj2tc2l1LVXeRKLdW8jfRH/dnNWDNnvRU/zqY?=
 =?us-ascii?Q?NCuKB3CjF6Rw8IPY1lEINhL2dNdJh7m+85im+YQ1oBaHVr4bM1Zf5qqbGN3M?=
 =?us-ascii?Q?x2ljgyjX0l5jz0+Q7jOSuCgNTCUpNL5RgasHHeTpbcHxa+4XfmubOT2OBEkq?=
 =?us-ascii?Q?1YhIxBlcSOXqaThwUvO9jQtcr7JIMsbHZrO8W4WAtvrOWmSOcXAS+UPlcyXu?=
 =?us-ascii?Q?vVlF5FdejzodySUuBgsKope3DbBDtF5agZjODjX62esfsarbEIL51Jq6jSX3?=
 =?us-ascii?Q?3lKkrTyqwjRxF1rNNkJDGHZold2ILqBP/9WXditEpJtN1+RnyTBqCDhJGV9c?=
 =?us-ascii?Q?SK5BXXvzF9VYeXC/G4MRceZzWeXDRDNJQBn7Qc2qtPkVebtaJYlfidl2Sqrd?=
 =?us-ascii?Q?8MlQVf+povgKhZS/cDENHc1NN2gFna7pfwzddjF6EqchFQLikG+iNYkPeg6I?=
 =?us-ascii?Q?ByrSk3rCQGuoT7af/49xN7/XjuLck7p+VOdZUIAFU6KqAHCXp7Cu7BCp2tBr?=
 =?us-ascii?Q?KLwdEdwVzvNwv670RtNTfF9Qha0zvPmeq0kObevu82DqzL4c7Nq1BHu/t/O0?=
 =?us-ascii?Q?DXLZF/MK+rhezwFi/CkS895wwmZpdTR0aU4WHMwBxJu2MoKPFYkhlPGSNEqg?=
 =?us-ascii?Q?D3EXvcT/8lgrvwPWCLI3VvxexLXbibzg8IJM5HqLW/g/xhKFsUNZQyqZbNoL?=
 =?us-ascii?Q?ZcD6PM6X1tATjGSNqgFR84bXXghJaPOdeXcIksOZLdo0kD2eU0sOMIEQAuyM?=
 =?us-ascii?Q?mVEKaLDxLkUJA+ej8v8BAaBxk+Mjz3zqm7hMgNCYifS2hCt8rydslUUDyLSj?=
 =?us-ascii?Q?Bh0Wiin/3iq0swcuq9qOn1bTiuDN4fnfhre6LVQqSlHm1/FMHjKCyBVefHAr?=
 =?us-ascii?Q?bFz+AKjgUhhL070eRmv60AW51Mk5293nQMJOaoaglLOe4NhbkP1MmIrn3K6r?=
 =?us-ascii?Q?JGJ43FZ/Mtwk7zchvzBoIG4ptwP/AF1wBqWtRgkLB/zS2qXzCXM38o3zgbUd?=
 =?us-ascii?Q?NCMeA46bFqZTEXTKan0pQfxWHy4QxaQFpg65hUU80SoYkhVCdr1gIHDSBRbe?=
 =?us-ascii?Q?yqEHh3vN3Gmb+5Adi6KPTH+moLlM1IxNUNIqhF5zmrMnmwS9Iu2FlTaVcS2P?=
 =?us-ascii?Q?tLc7IBbZTYInArnzit8ChfzQjLXBPDPH2JrWijfeIEpot1S7fqmN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6b7df1-ded7-4b9f-562a-08da2d9c301a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:27.2932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwuqbvHjblLSSqO0ibRcDNTNRgrXKrpDHJxOXu2UTZzTfnJHe2tO1qSsln530rgMxwiDmLz7ei1CkBqoR8N8/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

The sync reset flow can lead to the following deadlock when
poll_sync_reset() is called by timer softirq and waiting on
del_timer_sync() for the same timer. Fix that by moving the part of the
flow that waits for the timer to reset_reload_work.

It fixes the following kernel Trace:
RIP: 0010:del_timer_sync+0x32/0x40
...
Call Trace:
 <IRQ>
 mlx5_sync_reset_clear_reset_requested+0x26/0x50 [mlx5_core]
 poll_sync_reset.cold+0x36/0x52 [mlx5_core]
 call_timer_fn+0x32/0x130
 __run_timers.part.0+0x180/0x280
 ? tick_sched_handle+0x33/0x60
 ? tick_sched_timer+0x3d/0x80
 ? ktime_get+0x3e/0xa0
 run_timer_softirq+0x2a/0x50
 __do_softirq+0xe1/0x2d6
 ? hrtimer_interrupt+0x136/0x220
 irq_exit+0xae/0xb0
 smp_apic_timer_interrupt+0x7b/0x140
 apic_timer_interrupt+0xf/0x20
 </IRQ>

Fixes: 3c5193a87b0f ("net/mlx5: Use del_timer_sync in fw reset flow of halting poll")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 4aa22dce9b77..ec18d4ccbc11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -155,22 +155,6 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	}
 }
 
-static void mlx5_sync_reset_reload_work(struct work_struct *work)
-{
-	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
-						      reset_reload_work);
-	struct mlx5_core_dev *dev = fw_reset->dev;
-	int err;
-
-	mlx5_enter_error_state(dev, true);
-	mlx5_unload_one(dev);
-	err = mlx5_health_wait_pci_up(dev);
-	if (err)
-		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
-	fw_reset->ret = err;
-	mlx5_fw_reset_complete_reload(dev);
-}
-
 static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
@@ -188,6 +172,23 @@ static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, boo
 		mlx5_start_health_poll(dev);
 }
 
+static void mlx5_sync_reset_reload_work(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_reload_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+	int err;
+
+	mlx5_sync_reset_clear_reset_requested(dev, false);
+	mlx5_enter_error_state(dev, true);
+	mlx5_unload_one(dev);
+	err = mlx5_health_wait_pci_up(dev);
+	if (err)
+		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
+	fw_reset->ret = err;
+	mlx5_fw_reset_complete_reload(dev);
+}
+
 #define MLX5_RESET_POLL_INTERVAL	(HZ / 10)
 static void poll_sync_reset(struct timer_list *t)
 {
@@ -202,7 +203,6 @@ static void poll_sync_reset(struct timer_list *t)
 
 	if (fatal_error) {
 		mlx5_core_warn(dev, "Got Device Reset\n");
-		mlx5_sync_reset_clear_reset_requested(dev, false);
 		queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
 		return;
 	}
-- 
2.35.1

