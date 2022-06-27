Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9167155DE15
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiF0HH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbiF0HHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0355FBE
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XFrhneDjZBJ2BIWks5jBL9h+LTP+uj0HPig+ykDiWP3Gov6MB/Wd1N5LOCWBurKA/7h1g+mCUMhhRdKms8EpFRsd9FH+TIOb3lOhBpNbTnJ2UO85AzBbYoCg+Lf7AuKr/cen0fygqdjAiIGupABd4h1oTeHhIev8NVGOhCmE0zLYGdWo/s2Ubny+RN9Nz6olapmb8IB18HO5uE3VelvFz4iy+3FERVn9D/wC1TmrtgO+lSbERbrNeeEhiJFyoFCWVHu7wVkdrFTL/vGlyWgFP6Nn81UGCqqqcslub++WJf1+HeyYU8s20FQGeODEYSgBm3aTe3uNP94avto6knFnyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSbFNxCRuZFDG9S/7p3+kx7SeQkRLGeyIZlFhcM0lZc=;
 b=RNBYLFcZ77rlWJCIDbXbSaeJjNXicacImhgGt9t8EtJ+miebieJI8JBfSi/tOcvrRZFWF6cSmh6C80FxpHH20az+My4pvzYFMFOKdA1odT5bV5dQYYpOVEHohM5jLjp+nCUwaxuIDvgG02p8EivrWGEMQ6O0Ek7kFAh9QgxzW8JlesjfbGo/yvKebtS+KdjvZ81Hwi3n/gCJxy1wbxBf2tT/hjEzf56+J70UuMiUO8OneBromGlY5iUELGhq4W8/HZUcWOwfhjSBrbT2/odCzvey4MayRsePM2wqK4LYTpfG1098QoSALy0Ppiq28ldYkD8r0mOO0yUlPpdP5+p9NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSbFNxCRuZFDG9S/7p3+kx7SeQkRLGeyIZlFhcM0lZc=;
 b=NMFx0Ej3/GO6ZErjtvJjDdgThVrYtObO1bEWqzYHnEHsR61mgURRfFyuXzDWV9E1bJCsyNvkI6gE4adru9ZL8mh2HZnBJ8/TTX2qagm4xAswhiiWzSjnWuejgA+yYGO1Lx8f+gW50cs83xHG0O+CkMJioWtsREGIBbQ6S6n4HzBRhasV9SxHas8WKxapGfujOgZqGIYEu+hqQd3DqqPu7fyxfdt/xU8JCHbhCpOH3HiNhm5iirlKX7a0UR6p8z7DbQ5dH93jZ9Fc9+wGknvniQn77Q5JSF3qquvJqlkjOaUmFbVw7l6mmjtURgvAZ0kIID0a2RUz4UhZoEeQfc595w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/13] mlxsw: Add an indication of SMPE index validity for PGT table
Date:   Mon, 27 Jun 2022 10:06:16 +0300
Message-Id: <20220627070621.648499-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0470.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::7) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5cf98fa-aee8-4edb-b0d9-08da580bbcfa
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IiQL9Gilw7ap9PIZ4ZkB/5bvOeG8JuJ7xL88IcS0cA8bfXsNFWilTi3xCSuAC53OicOsfRPIA6+aSxww1mu+CUU9RO3V3/xuri09yfS5lD8ET5bigUvXW3OfThIaX3LRMVlU+LyX1o7mlD3pW179rMK3US0x1K3v73sXeEqslfwjh2x9XWwJowUT+TNyAUoE9nFzTN6Qchu4hZsLfle21Afj44jYTrrpVrQOXCM0P+P9aDCEG0o8ZonrGeztLrgPrEGDFGivWAujH4WXHXmxbQLiXr1GRuJ9UjTWO7BuG+aYK3fJv5B20Recqel/VYbruvVjO4z+aVXZyujNj2Vj3DcHLPbPIIoa0PqGNPsUxt9R0WBbkoGQh9kQvHZAfU1mX03s/YwiG4gkLbi4mROvqkHYwz11RCWFp6Caa3UfF707S2q47/O/buBzaC9CHuChkck9lDUbp6a8SQ7TF9ZHRt/0yA0QdyNO56GYqoCtP3YVxQyTxzZttBndLGY0RXJflwpngqbacE1aGwrkzOVR/Me337gxm9n/0LiwfU2SOqcuWlgWXeKbgGLTY3KfuCeYWi81d+YTZQQr5so/0ynSI/cMc/g6lZoDKQ/ShPFBz4buiJyDm0GQLoiPhaJds9OyiEsUUf+veGy+Gguj5bud5tDmZWP2V43kAlSLLoH/bpqzRzotRkAo0wdeFcs2cgLW6y8/9r7dMGnhKPVcRFl4cW/aMyhGITmC36JTsf2F3jY7v5vkhFKBToYUpDpIVhX4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FgxvoxMTsdDc+Orw2zPorywaMImwTtlEHwVK8hmTMW/pTLVHCKoHW83IaBVn?=
 =?us-ascii?Q?JoeeQxmK/7uaHI9aU+dtSjVHbWPn88J4yq/mN+SdgZiuAJi/rOwDNi04bwSg?=
 =?us-ascii?Q?h67a6eR5acV+v3NZ2/dBh+8U6VVH6zj9g6n0ijyI8aYA01zqcli85Y053xV7?=
 =?us-ascii?Q?qxTHNwHZwMJMyXkG8JNHDsaCH/lK8kqBhnzcAAPTawZXyBF/3ge2L0FR6t58?=
 =?us-ascii?Q?Jd971mQrKhFBbSaHkpuMk1CjJH9x0wIbuhz5V8RS7hi3YT7+nIRDX204UO+0?=
 =?us-ascii?Q?gRdP9pF3UShwROU17rkoWPy4KkxzCBxhAEB526Htz7IrPKX5gjf79qkOEpCf?=
 =?us-ascii?Q?Ur0fi61IXV6pdA9bgEutWMUSkQMLJofFOnguVvu40L6uMDt8Vgf+LX54vPCm?=
 =?us-ascii?Q?kajUiW3NhTYktIEcztkYgttFwlfJ79p7OIIivVJWy/EloSSz5DpfZYNNHqPP?=
 =?us-ascii?Q?5XupfE9CsmhCgx5UOooyGtehW29+WP0V++U7d9gkLGeT39JCX0ZUFM4jCBur?=
 =?us-ascii?Q?/NPhCO42NQzvRjP9cBOtdVG0/vDEjyLla/dLr9/jpFou74vFYn1XmiWNTEou?=
 =?us-ascii?Q?kx1MqWNsoNNdl04C+sJs17i5PywVNVJQ29JWZQSHJSeRkbuDJktvNA/EeN/g?=
 =?us-ascii?Q?9ihMaVhvwY9dYtbqohCFAjb1HQU3X25s/3v9SlyH/S2csdsHrvu3aswwWc3q?=
 =?us-ascii?Q?mJTF2hng1saRsOkppSWRQYOswEDCuw9wWEnB2a3jnyl83QPOfNTqD+YiTpFY?=
 =?us-ascii?Q?C2sxJPmJr/TrCtBTJRIyrYgZ78vpOehHnHYZNOAPY0rhzlIIfRABAGS/d/5l?=
 =?us-ascii?Q?lhtlwBpuxFHiLlfZ89RmGVjfRM6CNM/aFLcp6ES9gIhWCgQXZWjNDXG+FIeB?=
 =?us-ascii?Q?n/+sROl8op63nEj8pfavFB5wjolPWlrvIqZeqMUNcYhnn7SYqZtJ27ZhjrYE?=
 =?us-ascii?Q?U52BnVPgEB3/KpBuf+tTqc3gHVxO9iziSuVIy+aCZMBO3IolyYy+3qmPSQ2I?=
 =?us-ascii?Q?N/uhPIG5fququftrz7uYhsWQYzf0K7HQ93G0zBUmtEsN+chuY/WZFdp7zaY/?=
 =?us-ascii?Q?jqJwu84DUY8LDcR0Z1cXL4RKQy920XfHy95a/TIM03CWrsbYux+w/CZitQ+F?=
 =?us-ascii?Q?uG2PYrJvLNuiw+BR1RrluuRielTSnqg6ljaR+HdFeEik0cpEdcMrgHmlw8lI?=
 =?us-ascii?Q?WOn/kyaw/5KZaei1l+Y5UPY1e5o3FEsYY+AMIiavlfknpGtPAPljya5yRfWN?=
 =?us-ascii?Q?Tmr2XyHpiOmZheudIiTJ8kuhtvDPXVWftVYCZzvU+FLpuFkK9t7hrZPc4ZBh?=
 =?us-ascii?Q?Y+5olnITK6AApB5yb/bvzD6OHXcRBmu/dCc1xqaDH7CQVXAkY06VXnHjjWo+?=
 =?us-ascii?Q?k/7dQFzPoa2kse+DTtWxfB4MgFWHRrAR3xBsBChROuzjkvMICFa3JB3iTzlJ?=
 =?us-ascii?Q?R6qbGF2j0If2RNqSjWex6TAClgn65OGi48ecM2BBivuFEDYUpyK2yk8cRD5e?=
 =?us-ascii?Q?NL58e8wxJSx6FXAq1K5C577MwnlT1LtGBOKv7nu839GtQ4JrC+Uba7i2wp6q?=
 =?us-ascii?Q?eZn7CtH+VojT8vXheDoZl2gRuCtmRl32uvX9NRil?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5cf98fa-aee8-4edb-b0d9-08da580bbcfa
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:46.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqkdfAP/tf8IFTm8Gzo+k1hd/q07C9XEWVESMGsqIr+ZA6CM3sMSA2oK+/zb21AXeFEieGo0U/Y0T/P0NVMBoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In Spectrum-1, the index into the MPE table - called switch multicast to
port egress VID (SMPE) - is derived from the PGT entry, whereas in
Spectrum-2 and later ASICs it is derived from the FID.

Therefore, in Spectrum-1, the SMPE index needs to be programmed as part of
the PGT entry via SMID register, while it is reserved for Spectrum-2 and
later ASICs.

Add 'pgt_smpe_index_valid' boolean as part of 'struct mlxsw_sp' and set
it to true for Spectrum-1 and to false for the later ASICs. Add
'smpe_index_valid' as part of 'struct mlxsw_sp_pgt' and set it according
to the value in 'struct mlxsw_sp' as part of PGT initialization.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     | 4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     | 1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 6b17fa9ab9c7..b128f900d0fe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3235,6 +3235,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
 	mlxsw_sp->fid_family_arr = mlxsw_sp1_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1;
+	mlxsw_sp->pgt_smpe_index_valid = true;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
@@ -3268,6 +3269,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
 	mlxsw_sp->fid_family_arr = mlxsw_sp2_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
+	mlxsw_sp->pgt_smpe_index_valid = false;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
@@ -3301,6 +3303,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
 	mlxsw_sp->fid_family_arr = mlxsw_sp2_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
+	mlxsw_sp->pgt_smpe_index_valid = false;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
@@ -3334,6 +3337,7 @@ static int mlxsw_sp4_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp2_listener);
 	mlxsw_sp->fid_family_arr = mlxsw_sp2_fid_family_arr;
 	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP4;
+	mlxsw_sp->pgt_smpe_index_valid = false;
 
 	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index b42b23d09ab2..600089364575 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -219,6 +219,7 @@ struct mlxsw_sp {
 	struct mutex ipv6_addr_ht_lock; /* Protects ipv6_addr_ht */
 	bool ubridge;
 	struct mlxsw_sp_pgt *pgt;
+	bool pgt_smpe_index_valid;
 };
 
 struct mlxsw_sp_ptp_ops {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
index 27db277bc906..0fc29d486efc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
@@ -11,6 +11,7 @@ struct mlxsw_sp_pgt {
 	struct idr pgt_idr;
 	u16 end_index; /* Exclusive. */
 	struct mutex lock; /* Protects PGT. */
+	bool smpe_index_valid;
 };
 
 int mlxsw_sp_pgt_mid_alloc(struct mlxsw_sp *mlxsw_sp, u16 *p_mid)
@@ -107,6 +108,7 @@ int mlxsw_sp_pgt_init(struct mlxsw_sp *mlxsw_sp)
 	idr_init(&pgt->pgt_idr);
 	pgt->end_index = MLXSW_CORE_RES_GET(mlxsw_sp->core, PGT_SIZE);
 	mutex_init(&pgt->lock);
+	pgt->smpe_index_valid = mlxsw_sp->pgt_smpe_index_valid;
 	mlxsw_sp->pgt = pgt;
 	return 0;
 }
-- 
2.36.1

