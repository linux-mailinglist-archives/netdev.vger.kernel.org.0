Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8E15197C7
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345198AbiEDHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345228AbiEDHHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:14 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F127022BC7
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L65N/jPB5peCZNUlC35lFF01KFKBGGJWS0/uOrweQnzUK0DbozlILiEWHhUMC2gF8wut3yrkVFu4jVCg+HoZAXAY0jvzg6Kg+r0ZERtrJyXZHTul9ZOQlwbEfug/ujQaUhZ6t6/nTCOoKgTbYn8KD8QMh6QVXToFeb9zOSfCqBX385Hv6SjvuKH8hBPXlMltsiQCkI2cr5v3e2SuDYXfchcS/APLxKlhDVp95cNG7Gnj2CbDeB9E9K0h50/y0YZrpUgYksEDynqBJBmjiolJaYDe2PvjKgppEmv8mNgMY4jyZmWAXGud8VKJ0hveXZej5/JCRyb48A/bXsZN/Zk/1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nNJtJv4VOqoVsJHzeiy6g/xg1R28lSeEDuDaJmY5nq0=;
 b=FIR3kMeEVXZ9YmE2Mflbdw+ulyocQ4+Ac/QwZDkp33OQ8rL6OgqRTdg1J4xhhLaC1sA3LvT9sCKBZQHS6n6K8/FSL2Z83IC8WV9lPo91fE9sEjc2y3VK9NxleDBxVqOfwBuT2VzU8c9HTS0rqNOfxDYXe+g8L+ZJE5Jj46CFBYEwowveu0dLGDKZFFM5x7fQqvbMomiDn6rMt8CG7zvMp9z+jpuxDaJHvWmfwbr+k4CcdL308ZHVzcHJDT2C/fXIzOAg/GMpP0b39rexCDsS2JSLyotYYGfSb3HiBlBXpUZjaWVHo5mdh1Konn053t5m7ghiwtyOmcsa3nAG0GYr1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNJtJv4VOqoVsJHzeiy6g/xg1R28lSeEDuDaJmY5nq0=;
 b=cwgXBna7XpCBZ8BQ7bZxfSqCFi0TnodDqBf+2A5PHxnPXExaBlmwzLczArj2c5zS1o/FroxLgMiy5jFDUplxwAW26jQIhGX89xDMxjGtLU41X+SkdMS+Bc9kIPxk+V9xZfwnQP1+0fAjIZvxsh+CNN+E3RW4g44+YgHXcW8jnC1VByK4UDkLXZcsysU4OM5OI6cEhP6kKeRnz+a+7cjQrCfBew+s6JoHDh4AVTUbDObKA/n2+SxtiLsJXJwcNWoaGRJGLT4ooDDj3+o9B0U4CcTtARq658fAVOPz3iH98gMzJpzmzXMMZmFZdZQrvot0Qa543kZKaWKQKBaax1thIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:28 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:28 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 14/15] net/mlx5: Avoid double clear or set of sync reset requested
Date:   Wed,  4 May 2022 00:02:55 -0700
Message-Id: <20220504070256.694458-15-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16fca368-f783-4a37-3e3f-08da2d9c30ba
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4503312723710058D94D1BAAB3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yn2aYQy1xmYQiNOmqyKVIrl8fgguv5udepUxyV7RFcw3DkaDn9VcUheG2PCkicFlYDUeZ3g1yeH2V+oLknHxdE2z4OkXXAfio/R6TKj/l5TVSStKqTZUN4RVEwBONNexIWHW2MnhNnkJTuIGeZsycwuPOMDmLPm7BjcM9apeNT6xH8MIHoANBOmbPgz8Yj8PtUkES+SWxgCXM5MqfpL4TmUtssRRKH4W7orsn8RbGDGYRO7aQiEhTlcV/9HImxoo3hhRRxIL3fNfmGkSvWGCzq05VRJaSAU6g8bZdOt+RAiKF+6IB6LtvhtfxFfDWFTym7HOoONzO/S/4x8uCTq/DCy+niY6PDSBYQj+EibTrd1lMkZde6llZL/4PkVPnQB2V6y6DaJymDXeHCO3J+sFpa3mwgqu6hlS7Y5UyFnltJs5eUBP07JsBvDZrRacST8mbokUOvqcMPVLBQOpIdmerKiXsV0ONuXyRJFyqqO61MXzo6fhSyCil/wuBxGNVcwVSTGX2ggWz2LsaDEcBG2aCbIJGlSux7Yd7oq+v5ycj9a1xlkfyOtDmJ37TKNG9kAaT8VILlV/fat/8Ova+w3/YkEiOzuhuBGM75wtTpW5cjDyha80Wa8lzWtqNjTdlfmZnFdRh9Isif7+jzXmgRgydA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S2ziZvv264Ks+7ASA+egHI2saS+MfR5UuinTdsJV+WxQJJkEhNlJ5Vp5fX4t?=
 =?us-ascii?Q?5G/9srN6OBtV3Y0fTJWjDN2zpxLlaUIkvCUyuSCVxc9R4v+oAzHNlGVmZocz?=
 =?us-ascii?Q?Sb21c4utrvkyVERMsaLl3kILMhstpDTryJK6+jcHnlcEa84vlK7xsF6HTopN?=
 =?us-ascii?Q?Gs3b61yXyESIFIvVPVlEGqCCl9isE7Ud4tnjpDi1WTiH8yg8Pl3PK0V7itjt?=
 =?us-ascii?Q?hBIWWLmYjdfI9J8NyTrLZVEZK2KXGV1FuhcAajgiRVQyHaM9rrDhXFfR3PQ2?=
 =?us-ascii?Q?hPt8PAMaeIwdLTx/R1sOyE+dGFGpRqxDGAGMhlmshBS/6D09RwL0rZtizK8D?=
 =?us-ascii?Q?LIKrwCVqwkcXmcyq2yb7ptws8iExwJFstWDavfCTni1oqHPWSMRgelKRXx2s?=
 =?us-ascii?Q?UVIqC1pxM3wesNxvB+mnf960z3VwJxok3KWfLgngqfcz7S2QIUUvjG8hJxW6?=
 =?us-ascii?Q?AiAjiqUE4UjgGRCERVlmVuETEOQe+4Nc5wMxJ2BA7azqnfkFNQaqNkEy/lVx?=
 =?us-ascii?Q?HJHgc91YDGouS8CU0mDT+MvTlfu67fCKK9A/bTPlIcLP/TAkyHj4qH/ToLkr?=
 =?us-ascii?Q?eKFeyBccdDKM7JcZoBDfWm4xjacVmrlEID6TPRQYjg9YF5aPG3dczeqlxVsX?=
 =?us-ascii?Q?Jt/AHUAz4IOphDJ/muJBHJ7dcsc8rFlYgPhOloReUUU0DXcXqiHHVQ7eXnEM?=
 =?us-ascii?Q?L9d84QTk+fjUnLdobcXEhkatUA8KpV+RjKAgC4/XQt+h5KQSj3XY+0NE24QL?=
 =?us-ascii?Q?EnsJU+21DH2ZB5Xg1kRWAz+yB6DUsp2cz5SuKLo++0Ia/kwic2u0uAmJXdJ4?=
 =?us-ascii?Q?O9FsC+KBdrlMf8HviCvdZQ2KQ9azeYt+FyjmRTgzcos60Wm9J2AWlmZ5JA9M?=
 =?us-ascii?Q?N53VmWtZ4OkzoJTUQ/TYqg8nf1apiY+/I+dkoMDUmtXSZ7ZKZjdnEb8IytJG?=
 =?us-ascii?Q?pbnIRipjDUsuRR/wR/IlWLHrsb+Y9nCYrwE8foN2WUaT3oPOxzoAILLpI6FF?=
 =?us-ascii?Q?X5TdFO/Pibdbndrx7Bin0ttWtxtRHAEe6L60TcIMDGPtRXjY90AYeggg0SCc?=
 =?us-ascii?Q?ZjRuOH2fz7T2Xe3lk+BvWETtxSsswjWVqyauWhPgZVAYFbCmTcXPmzxSWvcq?=
 =?us-ascii?Q?5BQQAnBRqwsA7/OF5cW8s7IMkBZycIVs0SVZtQr8elEDeaUK/Uqde17b4o2A?=
 =?us-ascii?Q?VBUKZ36XY6a4B/JimhAExMIK+4xtwvhFTSDAjzyBlbzpP0KwhFyiTh4/TP41?=
 =?us-ascii?Q?oBZBkC3+TCYrhQKFAO//L+pZpCkHFkHmUij3OQuvuvxj6/EbyCFWg+7b2MLi?=
 =?us-ascii?Q?XznfJDKYp4TTxGpHzYCx+W7uJ5x+3oYIqJpsOc9lF0mGgHu0OzJPYaiRAkU6?=
 =?us-ascii?Q?QX1DywZFe8sNT8yF9ounURFuoanwNodQgZUsXhu9Khk5UEKXuceucfs3DQdA?=
 =?us-ascii?Q?xuupUAvBJvQhijR8vyJJExmMZKk8Bv3/zMU77464SteXQORtvBzC/hQtuIDx?=
 =?us-ascii?Q?3MPVJxETud2p4wo6OdWbUvrl4ebb5AlhYNUCnA5eYi3C+YzzF1IFng7IObmg?=
 =?us-ascii?Q?hhlVW/rf+Xja1e4noBaaIXpGvnzd1CMs8kgpYgVpJsb2IeAL5b73Apfq4Zzn?=
 =?us-ascii?Q?2eY5RZLoqKvEwdOBjEYtn7CeqvcfWnyjdfSAW1RZpAT9GUPzaA7Y0T0FCSXV?=
 =?us-ascii?Q?iSBDWI3N7lLZoIca0ioLbQT34bVKrL0rTRO9D6cRCT6omp/9k6mqO08Wl6wM?=
 =?us-ascii?Q?BJmOsiaHB8jpa1WeXD73LxVFTcJlZrKWJRpPiwq1hGDhxtIzG3Rv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fca368-f783-4a37-3e3f-08da2d9c30ba
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:28.3412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3v7H1ybLHR1xbAFOl6DC6FYcVPztQj0cNBkNo65NHV9lCzpBtn1QjsXw9ZVBbhX+yQIdoSkTaP6SCRYsH7l6Tg==
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

Double clear of reset requested state can lead to NULL pointer as it
will try to delete the timer twice. This can happen for example on a
race between abort from FW and pci error or reset. Avoid such case using
test_and_clear_bit() to verify only one time reset requested state clear
flow. Similarly use test_and_set_bit() to verify only one time reset
requested state set flow.

Fixes: 7dd6df329d4c ("net/mlx5: Handle sync reset abort event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index ec18d4ccbc11..ca1aba845dd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -162,14 +162,19 @@ static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
 	del_timer_sync(&fw_reset->timer);
 }
 
-static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)
+static int mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
+	if (!test_and_clear_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags)) {
+		mlx5_core_warn(dev, "Reset request was already cleared\n");
+		return -EALREADY;
+	}
+
 	mlx5_stop_sync_reset_poll(dev);
-	clear_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags);
 	if (poll_health)
 		mlx5_start_health_poll(dev);
+	return 0;
 }
 
 static void mlx5_sync_reset_reload_work(struct work_struct *work)
@@ -229,13 +234,17 @@ static int mlx5_fw_reset_set_reset_sync_nack(struct mlx5_core_dev *dev)
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 2, false);
 }
 
-static void mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
+static int mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
+	if (test_and_set_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags)) {
+		mlx5_core_warn(dev, "Reset request was already set\n");
+		return -EALREADY;
+	}
 	mlx5_stop_health_poll(dev, true);
-	set_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags);
 	mlx5_start_sync_reset_poll(dev);
+	return 0;
 }
 
 static void mlx5_fw_live_patch_event(struct work_struct *work)
@@ -264,7 +273,9 @@ static void mlx5_sync_reset_request_event(struct work_struct *work)
 			       err ? "Failed" : "Sent");
 		return;
 	}
-	mlx5_sync_reset_set_reset_requested(dev);
+	if (mlx5_sync_reset_set_reset_requested(dev))
+		return;
+
 	err = mlx5_fw_reset_set_reset_sync_ack(dev);
 	if (err)
 		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack Failed. Error code: %d\n", err);
@@ -362,7 +373,8 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	struct mlx5_core_dev *dev = fw_reset->dev;
 	int err;
 
-	mlx5_sync_reset_clear_reset_requested(dev, false);
+	if (mlx5_sync_reset_clear_reset_requested(dev, false))
+		return;
 
 	mlx5_core_warn(dev, "Sync Reset now. Device is going to reset.\n");
 
@@ -391,10 +403,8 @@ static void mlx5_sync_reset_abort_event(struct work_struct *work)
 						      reset_abort_work);
 	struct mlx5_core_dev *dev = fw_reset->dev;
 
-	if (!test_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags))
+	if (mlx5_sync_reset_clear_reset_requested(dev, true))
 		return;
-
-	mlx5_sync_reset_clear_reset_requested(dev, true);
 	mlx5_core_warn(dev, "PCI Sync FW Update Reset Aborted.\n");
 }
 
-- 
2.35.1

