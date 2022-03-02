Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D1B4CAA52
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240132AbiCBQeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242758AbiCBQeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:34:06 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03905FF2A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:33:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF+6mp0y3MHw5e2GAfbmraRav4bWcWdxiLioK/4PDQPakyhsqpV2lmVRlNnq95FAuWm/6iUHNHTeg7+3PAxWnmLaMm3rONeJRlW89UZ7zgVBn7ew6NlbL7usPri3TzNk2aLlzd8AdZ+PtROjz1Mf+t/Vd3gqV385GVMVMlZX4VUmDO04vfMaQSV2A8VjKCBgZ+TMo1cRgmhELJd5oy1KrkIBZ/vhF35UvwL45tyNisocYE0OUL2fbdpbZlklMXDH+Qr9aDeuDaum7EGBrBeAnpAecqPjTCPZWJ/liCUpFxXh2GeiPOkEyopPDMIyn6+r9xS5N0MQ043HB4GKArFBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=We5xE4gOZ1xGGBwPHj5nybSkjFWbTzilh011wifo59M=;
 b=PFsfy9eOuPrj5KgreaH70Ju/M/jJz5881Ah/vsz0BEK47Vp9IoQrOa32tsuMtn1fIScoVyLbbZf3Z+9u1ub5FU17zWTc7WijLz6WHVINRdZJW5ofEueczxPEfn2y7uZNVHYoUTHSx+TpVsHj+epoZg0LRsGgu0PTBb0NAOmSkYcD1pfpTBF2FEqEYTNZ/TlEHy6qxPgcyiD3CofrJ1p4W8sIWi0E31g6MjyUkZqPtHjf0cM2lWv8n38bETPum2jaogMbzmoluKK3smbaV24N5oZz+knAjWK/31Q8fhbWF9nH6ONC9C1beo2GC+MfV6UuZny3yKvwJ6I660waQcV/Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=We5xE4gOZ1xGGBwPHj5nybSkjFWbTzilh011wifo59M=;
 b=dsJt7+afsIb35OXdc1CP4qdaJSZ8iTTpfocByS3okFKrwlfUgEk07hbxryU0dvGqI6Z8zgibkNRihr2fVUhDX7nMFhieFJjuaEI9h91n6buW7QRP84b9KayRbnTiKEKUoO2U72PXNBcQf/MK/8DxbcOv78x/NX+1X2fO3frGIPvOqK8fBh9s31NGPPzGe8oRRXSzztdkbLpTqLVrvDrkv6y+pssEcRq7OJMn3UD3P1Lv4NiyckFsjp9yDVRsdwf5LEJIiwG4u1ei88v25Y6F4prBOI7aGfWx5kn8SQpRlM3npuZWmWTRDAbP0lTfEARRlo6glqda+9klQhcDUkvDNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Wed, 2 Mar
 2022 16:33:19 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:33:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 13/14] mlxsw: Add support for IFLA_OFFLOAD_XSTATS_L3_STATS
Date:   Wed,  2 Mar 2022 18:31:27 +0200
Message-Id: <20220302163128.218798-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0082.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::35) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a013942-2e1e-48ed-0b2c-08d9fc6a5bf1
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3208444E74940701852926BCB2039@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WowaH7EYmybw+llnk21TDp83Lhjt4cP0VZi/vUezZFbnrGMg0yK+0mAYBmMsChiVQdcZ6ZKIp5hI5NtS7UWeVCgT5lakpEJK/5uHY5gMZYJQ2cgw5lmUuRtH4QjT1rZ2gLN4044ZnBx1OIb5y2B6MyxRVOgOblYtkZc8pipreL1LDy5D5FpsIU1BKleaga9TKzt90kZ9RO5v6EonRUwLu03wZcTIyyv1r4p2bv0sbRwIwHM6/NC8HB8Pu82PAuLV9cTbvVXbFMxEwR0bDyGfGccKMWGXwnevK9uZhHJBOv+co1RFjzndgEPOvQY1KAcateKmcr7BsdUAWZf7WUWYCAQvFQa2rSIhrV6p3GpdMtv/wbxMnEgWfVvVQdXPnk510mZoxBP6Y5KKTlnmDgvrom7c4liNUTQy0QiMuLZ6XT+vfUNAjoyZh5sXNoXwTxhOWEz4pnR5hS78GWF8x01ueSCbxZNH0z75H8dmjGlJ+HBwnlJgF1bZNxmzc8zpgfu+GIMRiHDWUspDamsE4JSMSusotB5ZLjt+g7HEBACm1xLwWr5AWWAZFeqZvtwdloBgjmCcKR/ISYF6FG9TtPmCPSOWDThQwFl8jYdSmI/XQg3GuU8wxYg2H7pEurhPcHfBK2EV3bLEYv3sbuPjh0ckew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(8936002)(66574015)(6512007)(107886003)(4326008)(66946007)(66476007)(38100700002)(66556008)(2616005)(2906002)(86362001)(5660300002)(8676002)(26005)(83380400001)(186003)(6666004)(36756003)(6486002)(508600001)(316002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dl/7tX9bbsTfOAL6qCGImjjQcIk/4RQnr9qITyPbC+PtsfS0fEeSNHDFrV/b?=
 =?us-ascii?Q?BnCl/zbv+RDc2efXnXe0rXZyjzcB+32wfVAniBaGsQJxznEpIkSZ5rF8qfs8?=
 =?us-ascii?Q?3BP1JvKTMyq5EhcSC3YR/8p+dwxu86iHgcFJlw0YyWlIhtMyy+3nbCtaVz2d?=
 =?us-ascii?Q?GyQVnwM63/WYVhFw52mX8XGf2VdK8IxXVWNKauDjKpGFa1hw4pGAThxxSCRA?=
 =?us-ascii?Q?+VAqWDa9eM9jSIwNeQmOuL7QG00qrdCsHUMPpGKqIkt9a+pXjBoCHPvcqxNn?=
 =?us-ascii?Q?ZkvDDqt/Qz2jPlm0MAsG2CHdaDrsg8lNxSs87nK53RV2Ee1eC4UcO62RVr+1?=
 =?us-ascii?Q?/Gl/uD6pMxOKTRdHiPWa8/Kpvz/3mZSbBjtUgPOZVD7s8Ss5eCLhmcwzSOd7?=
 =?us-ascii?Q?Qf9m0s5NjA/iGoabZ3+e/8l8O3hgV8ByOtLPZsbDT6QQuW7QOt8f6T5APS+U?=
 =?us-ascii?Q?NEGicQ/1VU2yIkMuYUc0PDczIgzufJPfQnhTNqTTJjaSnvePySQRvZw6+fb7?=
 =?us-ascii?Q?c8N+57VTEBRjanONdAdadgPH0RuWErrFe0Es1+krcJYJsee9Vl8xXVc/PA3w?=
 =?us-ascii?Q?N/IpY4gaMX+QlWMtiLGW+Pzfn+iw59jExpomCo3aQalAiBG39RvcEt+MV9kR?=
 =?us-ascii?Q?W1r423vuHkJbJX3OCqkChlTNTcyaTtw5z7Ecr3OzRWxFFeq6n622+Edm7OlU?=
 =?us-ascii?Q?XEEIKUM7KXY8trVYifiON7Cvb/XjA2XxJC00mIrqnPswAfdK/CqZyA5WSNCw?=
 =?us-ascii?Q?fX/0UHyWNtS22trt6Vwx7b04dYkKFUDoA0mcqnL4kCCXkTIBPHVG5qRv+Qa0?=
 =?us-ascii?Q?L+A+duuY5ZhEX9Y88e9OojO5tFo/tKS9n1BSU1cFBE36S4Bymavza/zjIrkL?=
 =?us-ascii?Q?RtJThKn7PXezKdmnBAK81+JDOUfKgelMDQlze5d1+/wLKbWkfrsKZhcxj6Vm?=
 =?us-ascii?Q?9HDLy7TWzM+UzH5XTxAI7idbA7WVTp6rsfceJQH09iS0EoRCeOl39m6CCsXG?=
 =?us-ascii?Q?5y7HhZTyIAzkLbeiwUs1PSmR4xlWsUh3SRTog9b+PGtB0pu5MJC4N5jlcUHl?=
 =?us-ascii?Q?IlwEuSnYKID15vSvlz4wUyr3n+pYQPxx64mLtjvipubWpLFKXoDdKQQAR2hb?=
 =?us-ascii?Q?KzmNPtBLF+BtKCRzYprtU3HZvKgBn/oBg/KK1uWo6ayza3hfcV2WYcLoJtN+?=
 =?us-ascii?Q?mKTqkoFuR9uxGNflyEyCfvemUkfBxArzGvV6nMbdpjDTSslSTrDHASJdvEdI?=
 =?us-ascii?Q?pCuNzKJN9fHMV4m/PkRQtu4ucny/73Hig5REjvPuMrMGutUyXPocZXQrbiM0?=
 =?us-ascii?Q?0lnZFpWSdTlMpZ+vz8cOIDdcsdUuvYQiqUtrNGB7LMA1pKT6rHFK8o0O4ben?=
 =?us-ascii?Q?wxN8tZ1S2xXK+lki04IvGPUTaF4pPGZ0BFNIqqGKkAByJ51uflNOkLd6d6ez?=
 =?us-ascii?Q?T6zz+oO0YNzwg1H8wXDmcfqFkHLo32Bm6RWavtxil0QfbtaUgX8cHBkdvleR?=
 =?us-ascii?Q?fD7rL3R9IjCMH9ekx7GjHFMDD+883IX1u3X3t0iuVPgs0v/O/eGzbWJrfBWf?=
 =?us-ascii?Q?nNvTzcIqsCW7TexzYCrUUHZeUbnZcTE9bT0ragxLNNXGCZmFp9Gy76TlTYDF?=
 =?us-ascii?Q?LBVVAR5nBxBEI5l3rdwJuuI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a013942-2e1e-48ed-0b2c-08d9fc6a5bf1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:33:18.9829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPHDCUEPovmMvV3z1R/iyNAmxdHRNeWufCwJziwoL4y1SJbM0ssJGSnog23ZjSSUHd6El20IW9XX6J8QMU5Rzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3208
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Spectrum machines support L3 stats by binding a counter to a RIF, a
hardware object representing a router interface. Recognize the netdevice
notifier events, NETDEV_OFFLOAD_XSTATS_*, to support enablement,
disablement, and reporting back to core.

As a netdevice gains a RIF, if L3 stats are enabled, install the counters,
and ping the core so that a userspace notification can be emitted.

Similarly, as a netdevice loses a RIF, push the as-yet-unreported
statistics to the core, so that they are not lost, and ping the core to
emit userspace notification.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   4 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 291 +++++++++++++++++-
 2 files changed, 293 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 10f32deea158..7b7b17183d10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4829,6 +4829,10 @@ static bool mlxsw_sp_netdevice_event_is_router(unsigned long event)
 	case NETDEV_PRE_CHANGEADDR:
 	case NETDEV_CHANGEADDR:
 	case NETDEV_CHANGEMTU:
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
 		return true;
 	default:
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2b21fea3b37d..79deb19e3a19 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -225,6 +225,64 @@ int mlxsw_sp_rif_counter_value_get(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+struct mlxsw_sp_rif_counter_set_basic {
+	u64 good_unicast_packets;
+	u64 good_multicast_packets;
+	u64 good_broadcast_packets;
+	u64 good_unicast_bytes;
+	u64 good_multicast_bytes;
+	u64 good_broadcast_bytes;
+	u64 error_packets;
+	u64 discard_packets;
+	u64 error_bytes;
+	u64 discard_bytes;
+};
+
+static int
+mlxsw_sp_rif_counter_fetch_clear(struct mlxsw_sp_rif *rif,
+				 enum mlxsw_sp_rif_counter_dir dir,
+				 struct mlxsw_sp_rif_counter_set_basic *set)
+{
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	char ricnt_pl[MLXSW_REG_RICNT_LEN];
+	unsigned int *p_counter_index;
+	int err;
+
+	if (!mlxsw_sp_rif_counter_valid_get(rif, dir))
+		return -EINVAL;
+
+	p_counter_index = mlxsw_sp_rif_p_counter_get(rif, dir);
+	if (!p_counter_index)
+		return -EINVAL;
+
+	mlxsw_reg_ricnt_pack(ricnt_pl, *p_counter_index,
+			     MLXSW_REG_RICNT_OPCODE_CLEAR);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ricnt), ricnt_pl);
+	if (err)
+		return err;
+
+	if (!set)
+		return 0;
+
+#define MLXSW_SP_RIF_COUNTER_EXTRACT(NAME)				\
+		(set->NAME = mlxsw_reg_ricnt_ ## NAME ## _get(ricnt_pl))
+
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_unicast_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_multicast_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_broadcast_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_unicast_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_multicast_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(good_broadcast_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(error_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(discard_packets);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(error_bytes);
+	MLXSW_SP_RIF_COUNTER_EXTRACT(discard_bytes);
+
+#undef MLXSW_SP_RIF_COUNTER_EXTRACT
+
+	return 0;
+}
+
 static int mlxsw_sp_rif_counter_clear(struct mlxsw_sp *mlxsw_sp,
 				      unsigned int counter_index)
 {
@@ -242,9 +300,13 @@ int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp_rif *rif,
 	unsigned int *p_counter_index;
 	int err;
 
+	if (mlxsw_sp_rif_counter_valid_get(rif, dir))
+		return 0;
+
 	p_counter_index = mlxsw_sp_rif_p_counter_get(rif, dir);
 	if (!p_counter_index)
 		return -EINVAL;
+
 	err = mlxsw_sp_counter_alloc(mlxsw_sp, MLXSW_SP_COUNTER_SUB_POOL_RIF,
 				     p_counter_index);
 	if (err)
@@ -8146,6 +8208,166 @@ u16 mlxsw_sp_ipip_lb_ul_rif_id(const struct mlxsw_sp_rif_ipip_lb *lb_rif)
 	return lb_rif->ul_rif_id;
 }
 
+static bool
+mlxsw_sp_router_port_l3_stats_enabled(struct mlxsw_sp_rif *rif)
+{
+	return mlxsw_sp_rif_counter_valid_get(rif,
+					      MLXSW_SP_RIF_COUNTER_EGRESS) &&
+	       mlxsw_sp_rif_counter_valid_get(rif,
+					      MLXSW_SP_RIF_COUNTER_INGRESS);
+}
+
+static int
+mlxsw_sp_router_port_l3_stats_enable(struct mlxsw_sp_rif *rif)
+{
+	int err;
+
+	err = mlxsw_sp_rif_counter_alloc(rif, MLXSW_SP_RIF_COUNTER_INGRESS);
+	if (err)
+		return err;
+
+	/* Clear stale data. */
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_INGRESS,
+					       NULL);
+	if (err)
+		goto err_clear_ingress;
+
+	err = mlxsw_sp_rif_counter_alloc(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	if (err)
+		goto err_alloc_egress;
+
+	/* Clear stale data. */
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_EGRESS,
+					       NULL);
+	if (err)
+		goto err_clear_egress;
+
+	return 0;
+
+err_clear_egress:
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+err_alloc_egress:
+err_clear_ingress:
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_INGRESS);
+	return err;
+}
+
+static void
+mlxsw_sp_router_port_l3_stats_disable(struct mlxsw_sp_rif *rif)
+{
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_INGRESS);
+}
+
+static void
+mlxsw_sp_router_port_l3_stats_report_used(struct mlxsw_sp_rif *rif,
+					  struct netdev_notifier_offload_xstats_info *info)
+{
+	if (!mlxsw_sp_router_port_l3_stats_enabled(rif))
+		return;
+	netdev_offload_xstats_report_used(info->report_used);
+}
+
+static int
+mlxsw_sp_router_port_l3_stats_fetch(struct mlxsw_sp_rif *rif,
+				    struct rtnl_hw_stats64 *p_stats)
+{
+	struct mlxsw_sp_rif_counter_set_basic ingress;
+	struct mlxsw_sp_rif_counter_set_basic egress;
+	int err;
+
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_INGRESS,
+					       &ingress);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_rif_counter_fetch_clear(rif,
+					       MLXSW_SP_RIF_COUNTER_EGRESS,
+					       &egress);
+	if (err)
+		return err;
+
+#define MLXSW_SP_ROUTER_ALL_GOOD(SET, SFX)		\
+		((SET.good_unicast_ ## SFX) +		\
+		 (SET.good_multicast_ ## SFX) +		\
+		 (SET.good_broadcast_ ## SFX))
+
+	p_stats->rx_packets = MLXSW_SP_ROUTER_ALL_GOOD(ingress, packets);
+	p_stats->tx_packets = MLXSW_SP_ROUTER_ALL_GOOD(egress, packets);
+	p_stats->rx_bytes = MLXSW_SP_ROUTER_ALL_GOOD(ingress, bytes);
+	p_stats->tx_bytes = MLXSW_SP_ROUTER_ALL_GOOD(egress, bytes);
+	p_stats->rx_errors = ingress.error_packets;
+	p_stats->tx_errors = egress.error_packets;
+	p_stats->rx_dropped = ingress.discard_packets;
+	p_stats->tx_dropped = egress.discard_packets;
+	p_stats->multicast = ingress.good_multicast_packets +
+			     ingress.good_broadcast_packets;
+
+#undef MLXSW_SP_ROUTER_ALL_GOOD
+
+	return 0;
+}
+
+static int
+mlxsw_sp_router_port_l3_stats_report_delta(struct mlxsw_sp_rif *rif,
+					   struct netdev_notifier_offload_xstats_info *info)
+{
+	struct rtnl_hw_stats64 stats = {};
+	int err;
+
+	if (!mlxsw_sp_router_port_l3_stats_enabled(rif))
+		return 0;
+
+	err = mlxsw_sp_router_port_l3_stats_fetch(rif, &stats);
+	if (err)
+		return err;
+
+	netdev_offload_xstats_report_delta(info->report_delta, &stats);
+	return 0;
+}
+
+struct mlxsw_sp_router_hwstats_notify_work {
+	struct work_struct work;
+	struct net_device *dev;
+};
+
+static void mlxsw_sp_router_hwstats_notify_work(struct work_struct *work)
+{
+	struct mlxsw_sp_router_hwstats_notify_work *hws_work =
+		container_of(work, struct mlxsw_sp_router_hwstats_notify_work,
+			     work);
+
+	rtnl_lock();
+	rtnl_offload_xstats_notify(hws_work->dev);
+	rtnl_unlock();
+	dev_put(hws_work->dev);
+	kfree(hws_work);
+}
+
+static void
+mlxsw_sp_router_hwstats_notify_schedule(struct net_device *dev)
+{
+	struct mlxsw_sp_router_hwstats_notify_work *hws_work;
+
+	/* To collect notification payload, the core ends up sending another
+	 * notifier block message, which would deadlock on the attempt to
+	 * acquire the router lock again. Just postpone the notification until
+	 * later.
+	 */
+
+	hws_work = kzalloc(sizeof(*hws_work), GFP_KERNEL);
+	if (!hws_work)
+		return;
+
+	INIT_WORK(&hws_work->work, mlxsw_sp_router_hwstats_notify_work);
+	dev_hold(dev);
+	hws_work->dev = dev;
+	mlxsw_core_schedule_work(&hws_work->work);
+}
+
 int mlxsw_sp_rif_dev_ifindex(const struct mlxsw_sp_rif *rif)
 {
 	return rif->dev->ifindex;
@@ -8156,6 +8378,16 @@ const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
 	return rif->dev;
 }
 
+static void mlxsw_sp_rif_push_l3_stats(struct mlxsw_sp_rif *rif)
+{
+	struct rtnl_hw_stats64 stats = {};
+
+	if (!mlxsw_sp_router_port_l3_stats_fetch(rif, &stats))
+		netdev_offload_xstats_push_delta(rif->dev,
+						 NETDEV_OFFLOAD_XSTATS_TYPE_L3,
+						 &stats);
+}
+
 static struct mlxsw_sp_rif *
 mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 		    const struct mlxsw_sp_rif_params *params,
@@ -8216,10 +8448,19 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 			goto err_mr_rif_add;
 	}
 
-	mlxsw_sp_rif_counters_alloc(rif);
+	if (netdev_offload_xstats_enabled(rif->dev,
+					  NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
+		err = mlxsw_sp_router_port_l3_stats_enable(rif);
+		if (err)
+			goto err_stats_enable;
+		mlxsw_sp_router_hwstats_notify_schedule(rif->dev);
+	} else {
+		mlxsw_sp_rif_counters_alloc(rif);
+	}
 
 	return rif;
 
+err_stats_enable:
 err_mr_rif_add:
 	for (i--; i >= 0; i--)
 		mlxsw_sp_mr_rif_del(vr->mr_table[i], rif);
@@ -8249,7 +8490,15 @@ static void mlxsw_sp_rif_destroy(struct mlxsw_sp_rif *rif)
 	mlxsw_sp_router_rif_gone_sync(mlxsw_sp, rif);
 	vr = &mlxsw_sp->router->vrs[rif->vr_id];
 
-	mlxsw_sp_rif_counters_free(rif);
+	if (netdev_offload_xstats_enabled(rif->dev,
+					  NETDEV_OFFLOAD_XSTATS_TYPE_L3)) {
+		mlxsw_sp_rif_push_l3_stats(rif);
+		mlxsw_sp_router_port_l3_stats_disable(rif);
+		mlxsw_sp_router_hwstats_notify_schedule(rif->dev);
+	} else {
+		mlxsw_sp_rif_counters_free(rif);
+	}
+
 	for (i = 0; i < MLXSW_SP_L3_PROTO_MAX; i++)
 		mlxsw_sp_mr_rif_del(vr->mr_table[i], rif);
 	ops->deconfigure(rif);
@@ -9126,6 +9375,35 @@ static int mlxsw_sp_router_port_pre_changeaddr_event(struct mlxsw_sp_rif *rif,
 	return -ENOBUFS;
 }
 
+static int
+mlxsw_sp_router_port_offload_xstats_cmd(struct mlxsw_sp_rif *rif,
+					unsigned long event,
+					struct netdev_notifier_offload_xstats_info *info)
+{
+	switch (info->type) {
+	case NETDEV_OFFLOAD_XSTATS_TYPE_L3:
+		break;
+	default:
+		return 0;
+	}
+
+	switch (event) {
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+		return mlxsw_sp_router_port_l3_stats_enable(rif);
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+		mlxsw_sp_router_port_l3_stats_disable(rif);
+		return 0;
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+		mlxsw_sp_router_port_l3_stats_report_used(rif, info);
+		return 0;
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
+		return mlxsw_sp_router_port_l3_stats_report_delta(rif, info);
+	}
+
+	WARN_ON_ONCE(1);
+	return 0;
+}
+
 int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 					 unsigned long event, void *ptr)
 {
@@ -9151,6 +9429,15 @@ int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 	case NETDEV_PRE_CHANGEADDR:
 		err = mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
 		break;
+	case NETDEV_OFFLOAD_XSTATS_ENABLE:
+	case NETDEV_OFFLOAD_XSTATS_DISABLE:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_USED:
+	case NETDEV_OFFLOAD_XSTATS_REPORT_DELTA:
+		err = mlxsw_sp_router_port_offload_xstats_cmd(rif, event, ptr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
 
 out:
-- 
2.33.1

