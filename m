Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383E551EC28
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiEHIN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiEHIN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:13:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A118E090
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlFVWS/9bGNQ+N4ZxkSRa9GiJg/mSqtexEoL+DBI7aJgpiKyz4ZQ+vEmHNfmsXmryhQ84zQGDDSwyTGZLXNE5srwugguchC7hXYqbLs5Ies3fufW+PgamL9DXvSTAnJnyGG5uv5laagVEQ44hqDLRBV8PVOz1Whmk+BRO3eWX2i5NDvXuWbfiiRcaYKpq3ATNyVEna17qS3gB/Qu5tVmuarHiu2AjPOcbZk7zJuN9kZ+EOK6SgYTDqclfIxvh3hS/vGQ8eq0Sd7a8Kr2Kds/42zBDcwPqp7IMAa1OW6/27sCAtD4wzLZTFWoi92u7aLTTo73NAGFoMpZYnUoGY/l5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUePPW9ZQOiMfsCIFs+ikGppUCQS1dhk9A6xn8j5b7Y=;
 b=fcd2zYpGHsehgTTqWZ0H5BVfxMR/o9uVrMLFntfdN6pJHbBvIlsyhXl22so9fmdGeclcZurFUA/G8FTbZHmaPSseYiId7ejCKNhSdZGWKD0RQDke71Hk1VsI9Zu7vyhKJJpwdL2CTniiEAOwqf/Hn7aVxiKdDjM5xZLTHwLT9OHV9u0suvKFwqBltKQAvTbCy4rVye/77CTOvy1c0DfGHbvElMyihHLZkFsQga76YBvmxEj3aRltWQtlvZtu/c7wDGV+/XMx2h+ukQJTf4pE/1LYEJZITgTbNERJjRquGUv5R/opsgYM5L57+EleeoWQfvf3rCUGUEru2xz7uX51zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUePPW9ZQOiMfsCIFs+ikGppUCQS1dhk9A6xn8j5b7Y=;
 b=B9jaOwFnZWCRr9FCr4OqqE79LaKDYaGIUyQmqdwtQrYlvLUjCotaRE0hKk2X77HmZIKvRsaWS1dJInLzjnVjTRuppZPzyAhswBVFRG7EmgV8KFEx+dq310qIM7hrj0xRc/rMAFf5iGZYIKF7wQ+I1gAr7MrQkBlXGyUwHxxBXdH3CCTDSLG5jBwe+8IeFwvUqznh8sbxxDUTnRwPUOPtNZBIpHUd7VowMLR1q5Bz/LYGsBe1JsRkbdT3c3snBpOvYEdYw8k/Gs1GkBgPf7VxOHRGH6twvrOu62PuJOX0nOaOPQ5a6VvqYHeo779Vz1YVvrqesaXL26vPc6qjLb4LRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:34 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/10] mlxsw: spectrum: Update a comment
Date:   Sun,  8 May 2022 11:08:20 +0300
Message-Id: <20220508080823.32154-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0097.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::13) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d1cd32f2-eb0f-4fff-fa59-08da30ca160e
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6096D51135BD762DDE8A7D95B2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDpzxhZut09lJ0pSm7K/LEo+B2wx1DVXjfX6SIkT1yvpP7XK6Xo5sOeh26+d+LUOFhX2lyhHLVLkjut0mp21DeDjP099BKivJcHyenisDksByZ7oe5JcKpEi8v5HO2w34HztKkwfsaE3ghDfLYXPQ9OKd3/uXLVo+N6nZrhfdNUGsAz85t41B52Gb18nstUKDwuxp0fMGqanF52DTjDUsAeDgA47P6w40Wv1KPHv0OZkwKFi7JY14Wm8KOB7GwGqeDcgBgA61IulB/trn8atMcWmqcHr3X9w0/y54XlcQyRlnhxQNGYJfyvvCIDb9askolH5HgLbZHGkqp+51IWkw2V3GQzkatLYs8GLtjG/yIPeRm8tMM2PfEnH1M5frjyv6NTb4M2YqBN8Q91WB1hlLpfGzpadJvOoD6GjOsfHJXs5eu4OabvEk/KtEaTHbIYDsHzWmIm6y6F3qD8xzLGxmFV7yDyGq5+EX/kLrZAnc1K2nf/naKb9lX49GEvToDiYPgrfGML6QaWL7OMNoPdrbIyyaIx6ZJa4leLXm7zpiQFEcIRk7mO5USwOn4MLZeQoFP8jkD1xubb3/aZCyD6y2QxNDglG8XmxAEqAljAP1ZXnhdr1aWEnzlIo5IF2pj/vXhEQ9X3j/qezw6WUJ3VdJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(15650500001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f8X+Im8GAZZDBy9SsZVVtVPWwjb7tJsrQJ+dWiKUpEaj3Zl+vwwh2+OuEzFs?=
 =?us-ascii?Q?MOyDOiNl7VY4cI6zUyoNDJVfHQz7xheWsJDDTKZsLzqyEXU1mbg3/bKDWk3a?=
 =?us-ascii?Q?XkrT/RV5qUfrYjiEMjwqMSKqWKX1E/NX2aIqizfbbpk+tPRmyBSAIeIUptAq?=
 =?us-ascii?Q?IgJ3RoUnmGnh8dMCBIlbJ46H3UTyVMthIe4wdyHAVDwW9GpKKVtkiJxDocAZ?=
 =?us-ascii?Q?Bein435Fuca0I0gkiv8bGWRfW2VrmQtEs9PgLSXrW7c8MzqYBnLCWL4Xnyx1?=
 =?us-ascii?Q?QH5EAr+exiMTIcNM6wa194lgZGhT5JuHVij1JYNwozIWWwukey4ThZgAVn0J?=
 =?us-ascii?Q?sAR5f2wxeXmVv15fk/rHzz6sOfE+22LQMWAc4B24W+hPnQdZIbM+6lCQk7Lz?=
 =?us-ascii?Q?OLmFXbN20Vy2C64IpwikD6PQFLkmKI/xA2nsoB72OzWQK3xabLQGi0x+Kk2Y?=
 =?us-ascii?Q?hK2KEOuKpiUxA+9V8POV755s3DkV3FvjS5Q5gEmYxC6HWn7Y7HZ0lMPylt8m?=
 =?us-ascii?Q?9h+sH3vwlYI6xf88KoyavnqY7OJWk2/3B8oaOQy0S82BHTr2Rcoj4amwZshk?=
 =?us-ascii?Q?1x+skFAq7RoxnC2T8K92zMXYsR75EtD4vGR4v+Be+7zYbpIly0wx17Sw41OK?=
 =?us-ascii?Q?aZ9HT6Y0c/a+I2YsM9+gjSZ0fNdHRZUOB5WN9FJoLXWuelBIRY+lmLdQ46kO?=
 =?us-ascii?Q?OzlbNABbl3JlnZu+nwQ2pxt/amwwiPzKF8N5eXWx2omPpqrnyPt/3rjN0Yp2?=
 =?us-ascii?Q?btKAVstmg+HN7JkGLj2UdyBNya6Pr/OoxXqFA2SKUrhyMg8+Of9QEEk5KVIS?=
 =?us-ascii?Q?h3b2HWmGSZAVoA5EN41Gwgb4aLqRGD7x3e52SVA/yZC2QAHdfDvXuRy8jVS+?=
 =?us-ascii?Q?smUOdywelal/TITUU+ocBba04y9e1evev5MaHIK5hJ99fvE0UPorx00JRB0E?=
 =?us-ascii?Q?e2sZ8nAVsIAuRqENSx5AP8xM8u8Pw/wsuan7YbAnpBnyLUJrXXS49C+yGu/N?=
 =?us-ascii?Q?ghDwpfCVl0U4lA5kmJi9D00V/kOlxHrCMShApU5CXvTZUOHndi0VutLfbQp7?=
 =?us-ascii?Q?lmrtuiNp2Bj3KRq1YRseYZuR/TKLAfVX/vDY/KOc/yX5yXpeJMMNHS5zod3G?=
 =?us-ascii?Q?Gx5WAaVJvTtaD4LxoY9KmkUp6d01JC6v2mJuEOjUr3nJnuv98A/aZlyKebsL?=
 =?us-ascii?Q?OmwPg+x1D+2KxwI6nXDinQZ2ZyM7MnomGHASor69+lJbNd0KZX22TQKsnp8F?=
 =?us-ascii?Q?1r2GxXP0TJW18AMsfRTe73QfjGQ0HvyIT7UsuycgtIVNvAIGl8wGxbxNvppH?=
 =?us-ascii?Q?fpRfEdaK5jlD4qQv1oanis0xOVUM6OoeCw7iCqdI6LpJH/nZWhSsFeLljb80?=
 =?us-ascii?Q?MAxezvdt0kJqQjQbrp4EcG70uJgQCbZ1/ObPjg9fL2uEo5NpE8gm/0k6+qqb?=
 =?us-ascii?Q?nuhu0UNzEGMAjUkL+fV/3h6Wg7f5+S62rt69Lr6jmr3CirXsUEqPjcNeN4n/?=
 =?us-ascii?Q?tgicQQbPwBieGzIj1fWQnzJWphZaDarsgDaDxzAamB5A3zeoupBiC7vjN9aM?=
 =?us-ascii?Q?K2Tyjeow0Lk7Gf5azmfixkSZJsT31yVNK1gK3KnuxqdgNc9+17+x1fl24Yb4?=
 =?us-ascii?Q?ydHepiXHyOQBuV/Y5nvRuXdM9M6ss768kVWww3Y5u4haw2c/Cgm8roqKR1n1?=
 =?us-ascii?Q?Dd3HXpneIeBqjjlcGi+9dZARbJS1eb/4CNfXlerQ9VfXauUgvFLomuqoLzEd?=
 =?us-ascii?Q?5B1C8GyXFw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1cd32f2-eb0f-4fff-fa59-08da30ca160e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:34.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GilaPLXunXzs83Vdx/QRoIUtDbS+He11A9LW3xhBT4pu5bhRds/D5cPNJWkPBrS1K60YAKqhOZrxiD3R4ifxaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The position of netdevice notifier registration no longer depends on the
router initialization, because the event handler no longer dispatches to
the router code. Update the comment at the registration to that effect.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5ced3df92aab..cafd206e8d7e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3122,9 +3122,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		}
 	}
 
-	/* Initialize netdevice notifier after router and SPAN is initialized,
-	 * so that the event handler can use router structures and call SPAN
-	 * respin.
+	/* Initialize netdevice notifier after SPAN is initialized, so that the
+	 * event handler can call SPAN respin.
 	 */
 	mlxsw_sp->netdevice_nb.notifier_call = mlxsw_sp_netdevice_event;
 	err = register_netdevice_notifier_net(mlxsw_sp_net(mlxsw_sp),
-- 
2.35.1

