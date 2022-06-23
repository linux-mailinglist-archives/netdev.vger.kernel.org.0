Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2990D5573C9
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiFWHUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiFWHT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:19:58 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2073.outbound.protection.outlook.com [40.107.96.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154A745AFD
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Utp7vVBXeDc1CV//IPete8jY4okSme2/zC3sp8hnTKtM694SwcBVqblS6CTI5CiNfmyjbzA8CYVl5laiDmc3TxixwvPMKwUxankKpG4OwS9yRPIX+TFtI83c7cpeCUSRBw3m1lzWYZEgrU3rmHXntlZrcZ2z8ZaW7o4hxHQy3PWJ0qeO+V8JilVyPCKL8Jqpb7RI+XU0813oMZgVLGlcYKYhgGGHRn8FaVqPJNMiTYCYpQMW/GC3jh7bAlPJSW9yHdwuXMgWehV6F9PSGWV8+AIcLn1sx/5N/FKlLuCW71UPsBabZfz0++kC1MXt5e+qF4CT511h22pHSqt1vPsCpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tozpYG+zfHiG72vgqSEVDvyzRVqxGY1HJux2jIvcqnw=;
 b=A+/+GFbXlEUbqYwd2zUgn0jRqJC/liD/pFYxsNb5AkKv5s6KSfGSEB8s5Dh229viovRi2cmLQhgAM2f0qa516Qfq7r+LAWn0chPFYbYqKgieu0V/44fgs+LmKByovpJgQyQ15N3lO9XqXt7UcWmQUleIXPyHoWvbK41ZiqWfKWSiPQ8c/hDMFM4qJyIpZuZ1GWGB8QHtI31LGJlT9IPmNfNThF5d6Y90VGrQ/T03pxNbtl9WYOoPl+otHO44zmiTt368dKhBNOBYhyRhJNhYjAm3GKULocq5PhkmQeTkfuD8qFUI90SfpIirOD6Jcr5OIxM4jNoO6Balz8R5eNY5+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tozpYG+zfHiG72vgqSEVDvyzRVqxGY1HJux2jIvcqnw=;
 b=tGd8k38QVN3GO29Hc2dljIuxu8ulZ+w1Z5r7/ECfwLUPHofGSUTzEb+aJAlTSGDImVKNE7LzgBHwDPRAsGaYfj7xlYlTcj6M7iKXUcNNqSvLOdph0TPaGWBnEJkjiFiPYnnbt/YUNRQksuEQ5BKPLxr/AjGdd6qm0zJT3swHD5uA5dkz04SgavNy02q24ehP6+Wzhq3TU91LTAwFqW9RgZOJ85ecBVUd1klBuABrv7sioWduSAod19LozcfRwFmsrBw7ZsLuNVTMl2xY2X3x0aWA52pVmSth6hDk4G6awRsaqe3TLkDVJp9stzpETDFJMNPMq7hlG4AG/ulnfpF9pQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by SA0PR12MB4414.namprd12.prod.outlook.com (2603:10b6:806:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 07:19:51 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: spectrum: Use different arrays of FID families per-ASIC type
Date:   Thu, 23 Jun 2022 10:17:35 +0300
Message-Id: <20220623071737.318238-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0066.eurprd09.prod.outlook.com
 (2603:10a6:802:28::34) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44297622-4a46-4735-1b52-08da54e8c354
X-MS-TrafficTypeDiagnostic: SA0PR12MB4414:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB44145B2DB584C90EFFCA9C32B2B59@SA0PR12MB4414.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f04aFkY8iJHx1ZA57A2FmXNAm7FoIpHweDRN9BGn3QNZfSTxerwDzaVPGN8d8wNg5BF7zGkXG05Ni5gH9xlVV3l1qzjqoyIoMOoWmkdNcSsuF/HvkQW85bqybdGzCJALstWIE6Win0h0XvFk0cRDoO89MrFK97kSnd8wb8YWgEo+DkNny2hZKaExR6EcFss7BtNHTRIXKgV/Ci/CV0Euo/HfJqVWIIth7Uy4ol2aQhJ6ZL4uQAqtSnPKwoesBnf4MMkZovso8sY3hK0WHsfZYDTKxzAjmRRNLJWpQ/HxmQ4x6dBDE0x2K5YghmfXGJJt0YtmafQ+/vkZVjp6T3dzWAkf0ThsTm34ORaef0r0xy7Bls65BkxHaANuUnqIBPOjE8sAR+HzX+c9HdW562uV0gqj45CfZ7cmrqzjHBl/O/zKkgcwWvfSHkQ07tBrjakRLN4HKXEDys9DM+ATzdKd4IjHA4/Norh/GnvlLPfoeDDn/EuvSmfm22BWn39kyc5xNEJmY5PSxgd/MyXuWWBPRE14MWmNgjPmYiD1p0iLuL7gUnlXylGyphGWGW2cFBOybLQZmX8gl6Fh/QDwdfLzgeUj0vrrbDFVptYzviavinj9/9o4YBwgsZXyBkcfODvkH5rvJqfgoed542OJFFr+8Dje9udt+qVlPd1q+lxAkScVOs6KlEoVMFngb/dQjdbFiKKvzaRUhn6peDZqvauVlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(66574015)(86362001)(83380400001)(2616005)(107886003)(8676002)(66556008)(4326008)(66476007)(66946007)(8936002)(1076003)(38100700002)(186003)(5660300002)(2906002)(26005)(6506007)(6512007)(316002)(6486002)(6916009)(478600001)(36756003)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OG/2uD7dAtmXfsLTVwt+lUYOAnoR/Je3u66Djcs4U6HLCN9LO2f9ngtUUuvq?=
 =?us-ascii?Q?kAYIcuOba+qCx4TJKxAtA8wR1heutUC9aGMEEUPndMzGKXHYSSRq9Rbe4/Hf?=
 =?us-ascii?Q?GmbEFqh/3mItLWx6rZUZ82DzgPicRifZDuvg2Lj/aYffAnYCgRf0RC35iCVa?=
 =?us-ascii?Q?tHNRL23iyPwNZYlhDg58L5kIppQKQQwRuIlz26wvSc0+mh1B32KMiueSddAD?=
 =?us-ascii?Q?r7MdxIXRyKThqR05sfOJTEV0QnAltLTSAmeeNJAxFIbgvvf1BfMoabPFGXuZ?=
 =?us-ascii?Q?SjUH9G8EspLQUR5Lh0UW7pLSSfVlmx3L7Vbrpi1QkPR5SixDTO8QqqsJGLwh?=
 =?us-ascii?Q?iDk9+tcBd9xnRbK+4/NqMV8eYYu2xjfw4CD4yFnPqjVsiWUIhWqKvcJ6oPDQ?=
 =?us-ascii?Q?z7JUihj7OZmujHayVNUX1yt7QT3iBtYizhUXebUW7P5weoFjT8WKlT5PP89W?=
 =?us-ascii?Q?38L6dT6wOlWuZuxyx6qGeys8oc5y5zj0u3oaO2bcOiEReF0CSuNyxHK5SQlm?=
 =?us-ascii?Q?9b5iqhumnhJy8e7NSg6uXM3O/U/X1PMl6YKxHzEk32+uMY1tiPqAMgcm3y/r?=
 =?us-ascii?Q?zpedjUaOwtCLKk4DiPWcv7m5dSuKg1PL2Ztf+8DJtrlJAEDU/3bUvgoi9MJh?=
 =?us-ascii?Q?jQeavEa0k1tg9P4jYLp7CeUrmV0TBYNJxZr/waEJun4cQPFSaLrtLbh2OMg6?=
 =?us-ascii?Q?tzvcEbB4zXfFNE6bhzYA6nxQcij/HeQyRIBH5nPDkr1uZzuDOBqsJPf7nqvu?=
 =?us-ascii?Q?IXgos79pO0w897AYS/lD+ZxroPrzbovxwNzYPMjwepbFPKRSxT93SGmXzB8e?=
 =?us-ascii?Q?KiaOyzgzynX34hfPvKMcY2a23TEx9oT7v8sd16vTdlW5sgPI+iDi6RCuAvC1?=
 =?us-ascii?Q?z4NyWLpbQ16KZi3XX0fC9J5vVz0OVSnX+CGaFlMyxuUnEgd64sZmoqkhZDoz?=
 =?us-ascii?Q?Pj+Ukb95jMR7KdqMTGaqPD8UaTBvYJkEsOjBmZYdKov4oDK+eBvqsiMZIkXs?=
 =?us-ascii?Q?WNm1q2O2PDtxhtkN46J+sQKtFE3XyYtGedT/Efuaw4/N1tL48q4Nomm3a8A/?=
 =?us-ascii?Q?BvfUu2GXJKgc3R/szsO8v+Ih45w+qdXNjQ9W61Nc/LycEn2urWwc5hsA0vS2?=
 =?us-ascii?Q?CsK2M8SI5egAq7hJg3IYh8K7L5K6MXRFC09hWMs8QkS4KArv/eJH+JuvvjXk?=
 =?us-ascii?Q?PxHQMKMQMKGjfrrI1TWC20pGARLGs56IgeAYF7dLYVnZ92XsW8EZlZi7t8dW?=
 =?us-ascii?Q?UHp4HFFJsd4rXxOybT+9QRm1bmpnSdOpYZumZXH8INEIrXqQIEgHJuYMopAD?=
 =?us-ascii?Q?7Xth1S9DxSitt9lUzhn3n18qZS4xUJZHR0TscuqxTRPhzpw01FilncV27mnI?=
 =?us-ascii?Q?sEHmLJ0Ad2PLaEw1JsiNd+yLDGRPXJsNrCeGPPsVlyE6LVa1G18NzVr9UaZk?=
 =?us-ascii?Q?UyGmRgYBND1n8+EsQoNvzyBAouob8HxJmU6ytXMkoxJuWp2xx1tgo3izfFVd?=
 =?us-ascii?Q?CR13I0TmPoW332zqZ+RjohNFF6DP2gVvTBtvobaXGo4fUjMUXkypB/gR2Sqn?=
 =?us-ascii?Q?XLI2/GOlZG1K0Pv9szTEg0sg5S30AH6GOjaXHwETzYXeBX3TkJjt2dDkShcT?=
 =?us-ascii?Q?8gIAkBa2LAGzvXbbkYb9fuLemNk2xQteUsfdr18nB9k7262g1Hg7Bpb17V+5?=
 =?us-ascii?Q?uLSwyZVPOJGM6Z1+d2uijcXXWh6zdz+hoyjbWrF1dm4MC348zdnElBmOIpOP?=
 =?us-ascii?Q?DrotwSM1bQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44297622-4a46-4735-1b52-08da54e8c354
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:51.4436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 090RvRUTtojkcY0p87f9Zn67UWjjsJtj0+3NuB7SoyXnypu1fjdOmDMr+YpxaayNYZWIb4o92/6X4w4KXTP0sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4414
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Egress VID for layer 2 multicast is determined from two tables, the MPE
and PGT tables. The MPE table is a two dimensional table indexed by local
port and SMPE index, which should be thought of as a FID index.

In Spectrum-1 the SMPE index is derived from the PGT entry, whereas in
Spectrum-2 and newer ASICs the SMPE index is a FID attribute configured
via the SFMR register.

The validity of the SMPE index in SFMR is influenced from two factors:
1. FID family. SMPE index is reserved for rFIDs, as their flooding is
   handled by firmware.
2. ASIC generation. SMPE index is always reserved for Spectrum-1.

As such, the validity of the SMPE index should be an attribute of the FID
family and have different arrays of FID families per-ASIC type.

As a preparation for SMPE index configuration, create separate arrays of
FID families for different ASICs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |  4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 11 +++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f21c28123ad1..e58acd397edf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3232,6 +3232,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->router_ops = &mlxsw_sp1_router_ops;
 	mlxsw_sp->listeners = mlxsw_sp1_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
+	mlxsw_sp->fid_family_arr = mlxsw_sp1_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -3264,6 +3265,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
 	mlxsw_sp->listeners = mlxsw_sp2_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
+	mlxsw_sp->fid_family_arr = mlxsw_sp2_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -3296,6 +3298,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
 	mlxsw_sp->listeners = mlxsw_sp2_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
+	mlxsw_sp->fid_family_arr = mlxsw_sp2_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
@@ -3328,6 +3331,7 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->router_ops = &mlxsw_sp2_router_ops;
 	mlxsw_sp->listeners = mlxsw_sp2_listener;
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
+	mlxsw_sp->fid_family_arr = mlxsw_sp2_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP4;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8c647ab0b218..acb52f6aa97d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -211,6 +211,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_mall_ops *mall_ops;
 	const struct mlxsw_sp_router_ops *router_ops;
 	const struct mlxsw_listener *listeners;
+	const struct mlxsw_sp_fid_family **fid_family_arr;
 	size_t listeners_count;
 	u32 lowest_shaper_bs;
 	struct rhashtable ipv6_addr_ht;
@@ -1286,6 +1287,9 @@ void mlxsw_sp_port_fids_fini(struct mlxsw_sp_port *mlxsw_sp_port);
 int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_fids_fini(struct mlxsw_sp *mlxsw_sp);
 
+extern const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[];
+extern const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[];
+
 /* spectrum_mr.c */
 enum mlxsw_sp_mr_route_prio {
 	MLXSW_SP_MR_ROUTE_PRIO_SG,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 27bd55efa94c..1f8832f86327 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -969,7 +969,14 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 };
 
-static const struct mlxsw_sp_fid_family *mlxsw_sp_fid_family_arr[] = {
+const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
+	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp_fid_8021q_emu_family,
+	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
+	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
+	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
+};
+
+const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp_fid_8021q_emu_family,
 	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
@@ -1238,7 +1245,7 @@ int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp)
 
 	for (i = 0; i < MLXSW_SP_FID_TYPE_MAX; i++) {
 		err = mlxsw_sp_fid_family_register(mlxsw_sp,
-						   mlxsw_sp_fid_family_arr[i]);
+						   mlxsw_sp->fid_family_arr[i]);
 
 		if (err)
 			goto err_fid_ops_register;
-- 
2.36.1

