Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D7151972D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344856AbiEDGHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344823AbiEDGHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:07:08 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2408A1C913
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYGdpurq3R+LfZA+yKDwtyTINLAZ7z/kOl38lJCgRD1iZDzfSbUWbnaDtGaI5iy6QkbDfaHbCtsfGDRRh2wMJ8fasjVz7WXH2mo6O/+VOnt8o3qCT97Dx3Qrk3kOguVdYHcslxwmQSSDksAnxSw7vHQZqAcdXHda7z01UFRwMbQq2QbrpkvZmUbOYHosbCAputqfGZX/EL82g3xjFisgyBK9jomo5uliYoIpcBX6qEIrtav9dqhFnYNsUflNqY04JbhEHSIfrhzxDL12GbFF4iAWJJfn26nkOIZjHBa6RblCf3M/upq3TBSHp1VzFnJuAXCDBW2jvBf7s12UWZMjnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQA9TfdySAKpdDd5Hv4h+qtgb6AlxuxJfNWI02NwsDQ=;
 b=PKSWwq7hEqb3u4IQjS++ePhqFMEqmKIgwOUQdOKyBRWFV0TqBTdic+M+l7opIPZfZ6HiJYH1RSsTwboUc11GlWQKPY3XT90NvwDeawnLIRAj0rLNe3QSiAxxkVVnSRNHLsSpJ+qeCRQtJdx2EUd29ulJlJXs3owzO/UmaMfBoaaYooHW3xHnAyGhM0lLOZEAUiD6shMJtqGU0ZXl0yDCpQeg0eWx4ermiIS8QGP2tPf4oDfKA+3rETi5tBOlhNZBwlF58TqtOBYmbXi+Md9KuL5FxsRmBoaeo2yT9lkqlvrtZhebStAzZpmhFoGg562ZEc4JHC25exD2mli7su93cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQA9TfdySAKpdDd5Hv4h+qtgb6AlxuxJfNWI02NwsDQ=;
 b=PcDG61x8nngeLeYxczoBoesWzSYP8CEoYo/QIfEErXqEO7Nyywm5deNgoP9mEAMhwS/te9nB/TmHztX4d+05m/9uILnpZRucFON1xUCCEF+FdVhlIPChxfCpIX8vlMXbpzswDY72eRiDMzp6nFOJveZKGI0fJ6rhHrJVbeQhnLf2t4OIGcbGyJ4GBZN54w8Kmf2r3EMhop+12XRKPNaZ7lqj0n3QM1xx17s53bAVeHpZcV75xOCarVL2oKOJrehxDcPiQf0Yw7BQt2bigoZnE4n/MEnjXDi16vihqDODVidJrJ+qGcRw03GdQC5/SGzit5FOMObTqqdmDdUrUMKFXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR1201MB0006.namprd12.prod.outlook.com (2603:10b6:903:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Wed, 4 May
 2022 06:03:11 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 06:03:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/17] net/mlx5: Don't advertise IPsec netdev support for non-IPsec device
Date:   Tue,  3 May 2022 23:02:26 -0700
Message-Id: <20220504060231.668674-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504060231.668674-1-saeedm@nvidia.com>
References: <20220504060231.668674-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:a03:217::25) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 859af107-0ad1-4243-abcc-08da2d93c4fa
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0006:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00068465D99A0A96C8351D3DB3C39@CY4PR1201MB0006.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBdDFuKJHXUnLx8XmNWQYPw6O7cX+K3AsGo4IHtpeWI1aHkMTD7bdDCZj89dADh7MN1nqgWakmbHKIlFQ4YmvNaTK8g/f2EoY/hYqAw5wED4d8i0m7DuCPziN6BNmmnfMSiCD72GAMKI6y4QcHcAong+dOfk7GmgAtElhH/wZoHu59iSkaDiv4P6FdQAOs189fNO8LPhMhdoT/+0jtc3SF9Ai7AoEKfhj0IpG6pRBlA8tDcxoFr9/o+nROLUaqeCv4ocqp2s3YzY6THjtOfssIvCmo1AxufCwMsPRA28HoPDg+NTScIMpSWpwhplVIGEHunO0YVDZD9D2eZACaK66dQXbdPyYSHydGdkasYqdVNvaDw+tgpyopdR4SHHYnbC4UHolqmVbUgTkE9BlHwKUqQbs2r3MvrNyvXSxwFKAO7Vm7rv+JsvxgS6TF5TTxJgaHwMdUM22Dj1AyroWGmh9JfsVNrF7/vCXNbqzlN5SbaAQJrPLAhhv07DxNLA3SUmw2boGNGH/y+2Npn6gJ/tZ4LRJP8r0TwDgR8VKOdJehdwjXt/WKvHgMA107LI4QX4K9VAzmk80zghK+ZqEqf+T9i4SP46g349Vts+XK7i6+TN2fCDHkl96K3ZDl2MR/5umdrG3Lm+pPG7R/yzfgHvOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(107886003)(2906002)(54906003)(8936002)(110136005)(86362001)(316002)(66946007)(6512007)(6506007)(8676002)(66556008)(66476007)(6666004)(508600001)(4326008)(186003)(1076003)(2616005)(5660300002)(38100700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?435VoZWVXFdYqhlysMlf9dcVQvLBZg9tr9TQh5MN+5ejQG+23t+lvtIfwdOw?=
 =?us-ascii?Q?PD03rVTEeXOXyi2frP9npmf3H7E8l0lgNdLOdtULbyUPIQljBSzSBiFeoIpy?=
 =?us-ascii?Q?AQHb6yqirjXNfq1p0BD8K4nNEPvX9MVT5ykfV0rgPxgM4gLdMGdLcsptTY2b?=
 =?us-ascii?Q?0F7cNLUp8RO/Cbtjvarg9SMPWWfAqFv8mBDSfKypF+LXD27o0P6jfmYs5hiS?=
 =?us-ascii?Q?pPvkHz/F7w64Wut4myt0uougZo694LxdIrjRb8PCa/ClET0u0HJzbKHIgPZ/?=
 =?us-ascii?Q?szEONk0giq7XKBu80G0srguy2Mf9NBbmvZMcf6k3hoTAsHFC0Q3uOm5cPH/H?=
 =?us-ascii?Q?5YkA9Poy3PZFzSKDd8dI97icDlx0/7XgkheAp5oKalUuoh5RP6gAp44Nui3u?=
 =?us-ascii?Q?EZkaXzMiWasgULV4rS/PkC7K7go+DGX2pfepKt6yc6yXl5w6VdhjvOh4byr6?=
 =?us-ascii?Q?0IffIsT1noGV/kopIwA47XQImPUZIiVjmMx8gLmWFXDHGUpve3uC1ccY2DIS?=
 =?us-ascii?Q?AYp7cw/a14hJPOibolESnqqMI0KXO9D/KP4ya1G0SNx9p/FrUCDt2pxthxWW?=
 =?us-ascii?Q?F6WvGxi4k5cx4+QwhTKdqKhN5IOvONtNf0WPeqkHE4c4F1HiTHEkamppV0Ch?=
 =?us-ascii?Q?/IFEib4o5AFVR7vKIkBENR/Nc09c7GaHOigC7QFJe+hkjCODoHNNN/T/XG/R?=
 =?us-ascii?Q?1tIb9tK728OGu2KROQMm2kvtMv4NAGpAxjq5/nHtLzs+zEw1socsxwJXuYhs?=
 =?us-ascii?Q?7dryoYfjBYXUYWXuJJjqUq5CODJFtGDM62IL0+gpDQXOZGLXBP8cU5iQw7eL?=
 =?us-ascii?Q?EPv6tqQ0viD6M40h5G0qvD1Xj/gCk+YQTuR6sFZPVbBe7zmJOvUJhGxfeZ3p?=
 =?us-ascii?Q?W0bOAc1F9xsFAByw/bTYyLJCEIYE20ZMDFD++RG57/C0U+6S6wh2zyvFu/dy?=
 =?us-ascii?Q?CACXJxPzqqLLa1C4uqz4SjXydAYxRETqd448MRgmaS/M8kED5oUNApkqxdf+?=
 =?us-ascii?Q?s4sUqMx2LimvgSDgyf2m3V4OWfDi40DVx57HSUuTwuEFE+uN/axa1LmXLw42?=
 =?us-ascii?Q?iBVHl7L8PSnVoh4Eb+p9z87VG1aFwTEM7SG7xdgWBldRiMX5cJLlZr4xILeH?=
 =?us-ascii?Q?EqHit4UHmYDoFMV5lznkRte1lEuTp4ib5Klzl7F9JdO67j69KKIpk0K5ZFzV?=
 =?us-ascii?Q?OOLxhlnES80briEnzvCqQL36z63QNWsm3P86xLZOW7sgyGaJMj9XQ23v9zxs?=
 =?us-ascii?Q?3a8a7weazrHuT3qnsN7a6EVSQM6hA33rCNrPlIqKR6cP/Kg+JDeUF11YL3R8?=
 =?us-ascii?Q?uyje/Gm9J9W9bv1mVfGnCO7T15QxlzYSDfXsuppWbTFna2JV5DdGqRA7Evxv?=
 =?us-ascii?Q?GuhG0jkMni6t1O5UAYGglbkI2wfmNoDBGbrO3luNyqB/tXyupNF4SyKzROC4?=
 =?us-ascii?Q?xCH0xerwJVOPzKBgaiIBgjUQF6tC4bHj+xe10/CUglNE0mb1+rGHOfWCqIj5?=
 =?us-ascii?Q?yHQhVHUMExGCWcVO9d3Ga9v2lQZHl7h7Fu9aZdg9G0pcMv3kWqDtHpBQoatT?=
 =?us-ascii?Q?rUANrV2xhUyLk0h8LKeuSQzLhVJdumqXFTV0sQZWMjf1hSrZlXCVQEOge9Rg?=
 =?us-ascii?Q?wwYEbMYBZMciunA/F0Trk7U57A2+ab76cl5EWN3DfhQH95YmjF4E6TsdiK6T?=
 =?us-ascii?Q?KsM6GLb/AxkcvQvEknFhqDG0b/XD25bTOkycA6pqG5sCX8XEublyAKn8w+jR?=
 =?us-ascii?Q?xFZTDP8PuuQVu7UXFYoALKiKaKCVeRHMiEP4nxyZ0p3m3npb8+7v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 859af107-0ad1-4243-abcc-08da2d93c4fa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 06:03:11.5800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qv0NuFHFr4HNUeQT34l/vDP1KmJ4EEk7W4BqTev7uUzbSfaG64sK6wrQRtcsRi9rPhqhrgaDQN5VuNmQtML4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0006
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Device that lacks proper IPsec capabilities won't pass mlx5e_ipsec_init()
later, so no need to advertise HW netdev offload support for something that
isn't going to work anyway.

Fixes: 8ad893e516a7 ("net/mlx5e: Remove dependency in IPsec initialization flows")
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 81c9831ad286..28729b1cc6e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -454,6 +454,9 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct net_device *netdev = priv->netdev;
 
+	if (!mlx5_ipsec_device_caps(mdev))
+		return;
+
 	if (!(mlx5_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
 	    !MLX5_CAP_ETH(mdev, swp)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
-- 
2.35.1

