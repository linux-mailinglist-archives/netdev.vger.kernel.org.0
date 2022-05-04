Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF105197CF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345196AbiEDHHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345201AbiEDHHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:07:13 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2081.outbound.protection.outlook.com [40.107.100.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0488C22BC5
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eultzezZ4geMmuYNXyMy7SUPPXhRTU6rxc18JX76EivvNQNmWTEnneaxFqcZzpjTWVz59I8zWYQR7TFAsnBAlcFCVPSO72EcKR9QBxPI+5fWSjLl+gOGrVzH29ZqZJTWe6zc8xBOcJPWjEamQykpS4Y26diaudFOWnux4U+qFOINNsgq1OKtgkmXf3q6AGVY76h88Hnu9C2D8YpICd2sEXflE8fGZVhLF9tcAyzU3Dxa5zL+JjEh4IXwJQ/OV4eQ08t8yh5ZImILEqgQC6+BGLO7GxoYJUEeQ6ur0QRcsJs3DZDt3vqTOtwxo3AX82lytGvgmoLko2HwX1I8O6yOHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIBa4OykewUnocQGtywJW8uZ7LWs6C+SeT4LAhyrZ4U=;
 b=WUolIs1ZymgFo+MM/lcjpzv24SACqn74Hb1Z9HkXf+oce0u13dr+cElOC4baX6OrSLJHi41FPI8TmETgqp6XJmg59GVdt85Zg2SwIu/BKXm1acSH4Kt2dzecz2lUtD3OEBd6d2tnsugkIaODX02AJfaL14swRMRSRKbQaeuONj6zlrOuZUxe6T7ycRgavrjKE141xtQARXIQ3IGH5UhywW81LxkiUGCDfH36bCxjOWaTJZW6trjdeUZ4C0Kz/acgUm31WGT7/NIPBYAjWsmBkqBFdIK4PeXAs8iKQcNiStrMsrkHFQ7opJirOfXVGpkO+zTX2OPfutehN5Yp2tOtsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIBa4OykewUnocQGtywJW8uZ7LWs6C+SeT4LAhyrZ4U=;
 b=alqif9TO2T9iZoktPY5EzO6zYis57iueUJmP94s3lQHrV3ukYEYZp0r24K+0kFVdZaicF7enDaXWuXiDTmruC7JbLTZmTWRsUxPgBxEsVkscN0FLiUAKdhxuB4hG2/uYmgyEQtwM+f616jLlcZx3cgBDgNCTG0Spx2MTnCM/FDY07ksZ6d9VS/h1fiVo2efSJeVDobZUxZh4aQXJq97kuL5B0+ZFeYcOX2pScqod1u18I9u3hRLRrDg0hcUIADGn0M9L8732bugrn8IKdAiwXGb+DvzjeBi8E3uBTe1xKILoEqHwwYvdov1odeCvYDOz3/irEoCZhlS/JUXGsRFGQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 07:03:23 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:23 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/15] net/mlx5e: CT: Fix queued up restore put() executing after relevant ft release
Date:   Wed,  4 May 2022 00:02:51 -0700
Message-Id: <20220504070256.694458-11-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::18) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d15e8399-a0e1-4fef-c26e-08da2d9c2de2
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4503DD034F94680F0659CBB4B3C39@MN2PR12MB4503.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rj4zPwtSRiajuu5KY/jucVRTSEf1RKjuQQsxaQnX825laeiFngqSWJWJEMU04mWTcVyN3ie9NGzMbkfoBMShykd/sC1RMB9C3p6TUmAXaJsxlw4wTH5p0rcYjlY2YKqkdWFE4dbjs2a5ncHRqMgpEBJRb8qaasMsIxtpWrH3kjuwox+6dZCHPthk517HCQyWu2Ews5RwkoFFo20uYAKBg64R5HiRfJgs7ShmnViaQ7khv7PbDvm7GSzNJ3VlL1mwfreoikXhKyOpHLpAjX6A/93mrlftHyUL1IuDPSXKjawGzFt3hRKlBcZYjps4yaXQjKunLEBic2N9TsdC6RZIwsc8b8Y6h+Ph55xwY378fZAiH+vozaetJ+Vvi1HPvHuMOTcCvDUqdZF3o/jON6kfMNCZev335eNBhF2I1NB0Z9YzfJMeZFpmjgmI8MjWUym8y7giI9g5TBpOlXPJyRK7tRnUTpaKERdUDI+XDMS6Vg8Af4tvmzsd/OYKETBLCEgc5qlrFebKK+PLUNADVwfppmvya+1K+AjDHDm0GRoOstp9kfAfRmPh2WifCjD/KR6HuMPSaZkjlSGleQU+TLs3qaX0jx68Ktmep9TiKxOj4tWgITjJNOAE8p1nFwiP7WeI6A/hc0lr9VPr58hiqGM+MA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(107886003)(6506007)(2906002)(36756003)(8676002)(508600001)(6486002)(38100700002)(66946007)(4326008)(6512007)(66556008)(66476007)(86362001)(8936002)(316002)(5660300002)(186003)(54906003)(1076003)(110136005)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N26mnG6QCivrY/FIdNQlKM9i4++ZyjnCQjz0OkgUTPwrqrtvu3WcIGnFH1du?=
 =?us-ascii?Q?XoMsdt4S9qnXieR4OaHecjT62yh9lkP3JDwtt2fu/YaEBvUAsa0JXW2Nm2Og?=
 =?us-ascii?Q?t8leVT1SlJT0DLTBcLjA2Nz/MhqCaUcmhtZdnqTD7uOl1Ms3D04voN5RgbLZ?=
 =?us-ascii?Q?Mjuu/xlNfAs+/TcJDlWkPGmbDuoUZJJQepGdZ2tTzzMuHEnkPCHEAGLoC5d9?=
 =?us-ascii?Q?voiRAlCOyEIJEwRVSCMeB5yvyVhECXh0J2++7cyLQupOIBNtInaWZiXCzhna?=
 =?us-ascii?Q?r+XxJMopKxT97+EKuK5Su02krQZDVtv4PH7fdZ0DXemG77vpMbm38MVG9r4t?=
 =?us-ascii?Q?rNPxgVmf0nTd9O2PkjIIZwHBxl6vV2CsVIjZUHitE3hPHrX56MpDMEsQUmvT?=
 =?us-ascii?Q?fFKzsUqFNulw3skY0M0pBk+IVrfOUmFgIkZPSiDp35GTsmHhfVNFns6K5P7y?=
 =?us-ascii?Q?o6Qw38tHnz0EqiZCD72WiiKNLQTG+0BXeDCGRdqfyedWdfOIOqp0+uYl8opN?=
 =?us-ascii?Q?kf53rZoggLA7pNsZ02I22WLkE/S+86+Cis4Owd9h+xDvZdSzbyhq0GJHiUSg?=
 =?us-ascii?Q?jtmI+9mIJaCuY9RQjwfQJmeiJWSKm3VmousVOWCXWNvNtfgbzA/eujNmP8pk?=
 =?us-ascii?Q?j04GucuK0ykRMPmcHYy/WQxWMTWcoIUNQuLYxlXs9MqfW757apuW8JGqI4Rn?=
 =?us-ascii?Q?U35ahbwkdQf5hHcnbSQ2nBuDPN50g9rgTSHvvR2NbrYS7zukP+vz2NKlDaSU?=
 =?us-ascii?Q?XSGJcdHqkaeT/IqaIO2DMXgq63QDpq1YGS2DgR6iFfYb2LfUoMt6WzrAOrbs?=
 =?us-ascii?Q?+c4hI8aKzcHMijr9t402H016LEKg1DHAwNO7tScTY1BTQb+Qo3y5uqUgvdQ+?=
 =?us-ascii?Q?Jx1tqecRcNXuEOH4ZzgBCALhWmJYt/5nEuPM8bXw6YppTbhmUYo1tuFPZ3Bi?=
 =?us-ascii?Q?SD+XimlSXsTEpqcoHZ430/vuPwWKoFG6GyyAAIunelMfpLZd13gcj8+9ZLjt?=
 =?us-ascii?Q?9ipd7EC/7aHc1P8uggqXI9CoLEYIw24s8U/OKIds7AM9XIXhRmc5ec+cpQ4h?=
 =?us-ascii?Q?TquWwoZbCso9jB4QSA+WnUjSk8l2AHe1bi1RhiAwQH/fP+I6MjL0YpbDoGH/?=
 =?us-ascii?Q?/45r3pptNAuAP6GjBGclDbthHYSXxcNDeSC3buJAWAZf660oBp8sWOqX8kvf?=
 =?us-ascii?Q?t/OMOByKHn0mYOsLunHlSsuAB1afNT+SA6CRLBSB7NBEGNZftWIj0cCAX0lJ?=
 =?us-ascii?Q?Oa4LivrTOIUYGU3Lf9RkMEu4xiaczYdHMyak1OteVbDTDQrdqBnscItbps5O?=
 =?us-ascii?Q?njOMF5ZmEit6bFT8suzPpSMajZwvFmj+c6KPKshKngvEDzIkuW3KUFd9lSWZ?=
 =?us-ascii?Q?EnUo22hSUdG/+wwWBl+a27TolhVaQJoGM4V+ZSeKYcz/OmJMNdslJSU2BbFM?=
 =?us-ascii?Q?VrD0xtOdUOUfJqIW1qGdhzYM1UIl+Hs8EkG6m/Qhf57V3QdmWzKxg+ufXr3g?=
 =?us-ascii?Q?cbsjp17dfKLr4E13xSWoSnw4SUYhWBvbAWqBGjdku/3rorvmw85PWAQ1LSiA?=
 =?us-ascii?Q?hiS0eW4BaO+k1nldMr++uJSvY/vHYkw2F+uAp771V7n4Iv1rSEuRruM8eNEM?=
 =?us-ascii?Q?EkTFlI4KHRApuBS2sMzMJpjr4fTBzpd/voNan18H3DLlhCosk0BR8VZj4SvR?=
 =?us-ascii?Q?jjj+ayQHurk0L9ZTDafg17tnjS6oR2gCtokq+g+FpEudf+e8DP9PbbWD1EaG?=
 =?us-ascii?Q?zBGB0PELMywVNW3M3x4APMtQAGwEgkBX8LurM6c3j5hct3t8Jnuf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d15e8399-a0e1-4fef-c26e-08da2d9c2de2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:23.5736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0F6ksQ2kreBBMwK5zoM0ACzWYltc8uhT7QP+gWMGCDrd+wUlIgCwpS2omc0w67KfkB99InD2+SW8zgLTIPu/Q==
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

From: Paul Blakey <paulb@nvidia.com>

__mlx5_tc_ct_entry_put() queues release of tuple related to some ct FT,
if that is the last reference to that tuple, the actual deletion of
the tuple can happen after the FT is already destroyed and freed.

Flush the used workqueue before destroying the ct FT.

Fixes: a2173131526d ("net/mlx5e: CT: manage the lifetime of the ct entry object")
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 73a1e0a4818d..ab4b0f3ee2a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1741,6 +1741,8 @@ mlx5_tc_ct_flush_ft_entry(void *ptr, void *arg)
 static void
 mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 {
+	struct mlx5e_priv *priv;
+
 	if (!refcount_dec_and_test(&ft->refcount))
 		return;
 
@@ -1750,6 +1752,8 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
 	rhashtable_free_and_destroy(&ft->ct_entries_ht,
 				    mlx5_tc_ct_flush_ft_entry,
 				    ct_priv);
+	priv = netdev_priv(ct_priv->netdev);
+	flush_workqueue(priv->wq);
 	mlx5_tc_ct_free_pre_ct_tables(ft);
 	mapping_remove(ct_priv->zone_mapping, ft->zone_restore_id);
 	kfree(ft);
-- 
2.35.1

