Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8373504CD1
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 08:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbiDRGsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 02:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbiDRGrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 02:47:39 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B528A626B
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 23:44:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6s23fFEyUpi7bdMMgvOdO8KxnGJcuVGKXZ9UeKcSg6JfL6LHX51IVZPprCEHwXu2OtFseYqjnLVwxUXNOh4JXSgWyFmJa1sRwFkudQxUXxhvY2vZ6Y7mg7RqHMQgAYJdHE2BJXaYeEtK5APfFVhIqEjQEw3yyRoQAJ7hK8HNSyhUvkPIlDNDpQdqfSUW4y8vqKVDlNQcUlFNL79LuYtjAhFGtsvarkl5do7kPEoDBZHBp+KchWfQ3tCyHMVDi6dN3j6aYIwFO+lYhBuSycX8v0D33DDUgYACwAtiJ9MPHv3ETgD8kIaagWjBvpUmz9k8vR4jNCJr55AO2seQ9svIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QD2Vpjey8kW5hVEJPIWkofWsKoga7dtgRTO0J12tYYs=;
 b=XAmRqhNKnJVCtFREpPx19E4i9u0uzaldGuUY+LdSfJ65TZ9rkgwGRmiAHsFMFydLWpIYRbVlkAJHSiyuPTYAQcw+iMbqhuztHbv6QWCChclscbhWya9ciVn5i/DxsulBI94tHDIbNkP/xCOTHgY2oxTQ5DHhUz3OxRL4re/o345uy1f3gdKR6UC8I0TYKyts/QkC0m60onDLI2aydnFbh0xAfv41PZYrnNNy7N7E1ilwpQkdCZaRDdkYtblqSZqDBu9zR6LMwEU3uzED4Eq6estUP9wAXNzl5GlqFTqQ+xlYRBpc3Zp89r/BwaAQhDWXnszNyfMQDBAqmFehRvyulQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QD2Vpjey8kW5hVEJPIWkofWsKoga7dtgRTO0J12tYYs=;
 b=ZX5vpndqmrmxcoMUR5n+oOLkxKNDFiR8PNZrHSgOn685gYc7ceHxeJ96anUmleE1yfVLaVEx6FET/pf+mvax+C1eYCWSPwAjPFEV7US9y+kx6/oU5OPQS9aC7pj03/JDek/Xq77VWwQaRYteLaUaPy521cmYpB4hH83aG/8ZX6duoVnGMRxaWVk0D0ShQI4uJswVYtPH7M2qBpFIF4w6GaZLnf+hvycnIshzWX+RElwGhNcIUzdpvohPxx2orrsrfeSHGeMtmENE8H5q4slXv0ugSNlv0jJF3bK7vx11uy9+QR3vyESEe8AeCz14XYgh7sFcH2r/ymQtnDjR/lmFhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3664.namprd12.prod.outlook.com (2603:10b6:208:159::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:44:56 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%6]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:44:56 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, vadimp@nvidia.com, petrm@nvidia.com,
        andrew@lunn.ch, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 16/17] mlxsw: spectrum: Add port to linecard mapping
Date:   Mon, 18 Apr 2022 09:42:40 +0300
Message-Id: <20220418064241.2925668-17-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220418064241.2925668-1-idosch@nvidia.com>
References: <20220418064241.2925668-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0297.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29d1807d-8e90-4d68-e4d9-08da2106f35d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3664:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB36646732B3A69929EC613FADB2F39@MN2PR12MB3664.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SxUm6kwr2z19EfkjGHNa4wWpNjezqQNUQwyWeNF8avaROZEaudveDQVxnrvVKdBlrtUwjmxx52exryoIBLi3EUqMHNZV2sWDq0KN8X3yCyOsNOmsD8bVo/uI1uuuHA+Ci29oCeHSvgd/oid+m3dhNakHcn6L23WSk6luDeMhbibaL07mqlC8+B/ZLA1smUH+Z8XvNBpAHbIcs689wqvXdKIZX5QnnWqIWv7xyNLl679rGLXu889NZFuPBlhavp+pQJMwwS/BvBe7iGobkoTGuitLV1SfllmjtG9NvLWjEwT0ZGPsHfuQEKX9Cj0gUHBapkGpz5e5Xq4qo08iMN47A74J6XvkS1SV371EIHrE35vFmTZRc0GOqS41DV9nOEGYxJTVYg/f0d3RdO1j1DYFwkaBlVmfk/5iXWM/NdA+U/a6Ap0E4VAMH3q6pnffYwudWzC7quggSoprJoGoM4rVC6d2dUduLV5kwjMyi68mOuCPu051VxjUJmfIaLG9ay4drRtfZH7DsWJe9bUHIiH+qUb2UJ//N3iRgSaqXTG5/nZannJjX3wAmkLaINnKO1DBkkUwIasqrVS2sQgv53BKXdRgsAKHRPMLjAvRrMbj/7g2r30mnnw+qBwFxO9X3qGHdbdPGhXnBXFJE0OpCj8PMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(107886003)(66556008)(316002)(4326008)(8676002)(508600001)(8936002)(6486002)(66476007)(5660300002)(6512007)(186003)(66946007)(38100700002)(86362001)(26005)(83380400001)(36756003)(2616005)(6666004)(2906002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V8ajz2U1TR3ISGQVA8FllO/oUR3T0JXCYH5BAwomVQVhb4v+Kste9aM/GOCV?=
 =?us-ascii?Q?RZ7D+bCVFuEsFZsQ8NHnSorx6EHRCEsev2RmKdDWaW0anHvLLaExfdxWuReq?=
 =?us-ascii?Q?shg9Pm+mRW//VXmJ8d6EQYYQZIAdsQaTIHXkb5C7yoA6RvzZ7kNYWaZ+qqNL?=
 =?us-ascii?Q?+Dcff+A2+8w/heUumhg14aVIxfWU2P3jm8ViZ5wyFboeicIMb5CGZ3TdWIFx?=
 =?us-ascii?Q?acA6yyGuG4e8itSYgsunwstIiJVT3/ZyxaQxeLXZeUpaCjorDvmdXLwQVoRC?=
 =?us-ascii?Q?MmYza9tLKrzALG5rbMzmUKO3YzjY8fHuSlxb4UFNTlnkPOASnVQxdq+4L9dw?=
 =?us-ascii?Q?qCE4EhJoyQMXXqfXVJBa5JwAdvb/nDWJFjb8ksxqdxlgIwRfMld5IwcnafWR?=
 =?us-ascii?Q?fa3WEMUIZJdohCQ6NCJUJa+R+Zk5oTj9lWsneAgG2tFQ0t42MY+JTfjkirpb?=
 =?us-ascii?Q?YXW6jRfyKoP7RjKLWvwXRBEoO7NQvEubAwqCxSSR64z/49iK2yauu0/Z4gEw?=
 =?us-ascii?Q?yyvUitBfI8WE1k2YrXXaR0cDngQNHH3NlDIFVzlW5kNmWtV5oE9IXcupY6Qs?=
 =?us-ascii?Q?5Jrp27rxXmKtmLGy8Ll81jfE2STPMdDd+Lbq0pIiFnp6rGnwh40ucTvo9ZbD?=
 =?us-ascii?Q?AbOFwMONh9QIuVgG8mnySdt1pltbRcHZvgaxxqTMyGwPNa3xZBFYRQfZPKvh?=
 =?us-ascii?Q?aWHneNEo4e+PJHJ5Tvi7BaM3T5O2SoYlZSBi+qD1Hznqr2mkcDCekur9NVoI?=
 =?us-ascii?Q?icTjD8L/Ep+tlGYlLLEzvUoqcdwTFI2Wb8a95Nr/bWJcj1/nIDGLh4LypdIy?=
 =?us-ascii?Q?9STsL+Zh+FQPqohnXXOe276yDTvQkRTEqSVsFWrRB5RzbIL674uLRctcdSMp?=
 =?us-ascii?Q?5Jd1NyZOvNvyk3nOBmVc9RwWI4olKKQgLshgPpamJa3etI6eA/V1GhlXrt1T?=
 =?us-ascii?Q?v1ObdS/ZQUGoBY8OLsfBgssnieGU0PJGrPIDRzrXi1UieGjMTEhOHT0v4MQS?=
 =?us-ascii?Q?5Cs93ZxjIpRg5b/8ad4IFFs3unDocUywLR2hZpsXkvt6SBRAJNywHhk+jW9y?=
 =?us-ascii?Q?j9/DMPvjgjhVazFxyTSdvNSIOnosFfORC9T3HqNxr5OYX2aYuA+k/T2xvCxp?=
 =?us-ascii?Q?DkP6Ss1Ik9a/rP5aLWgRnHHt0v3X88ipKVVl6bKxh0TI1b8NnMnAouqKLNTu?=
 =?us-ascii?Q?rWSGcYVkkA+rxga9uaiV9j+hth0FSr1aQmTLB44XrKnsKBililk9z5JmHckg?=
 =?us-ascii?Q?BdRzZh4rk/MSR+H8p/S/0C19W75vHJwNYAN4JWB//+m333DUGgPQ8k8Shajy?=
 =?us-ascii?Q?KMTw7u19TbWE/fmMZBrqhOQsX9pkUX7NH+t/TmB6lhXmzAjs0IQacSLIEEfK?=
 =?us-ascii?Q?Hc0FZr+7JuCr2mqzsYguC6UP0DO79lbKWO1dgmei3enwz30eamg7Vqi/y2sK?=
 =?us-ascii?Q?40XOh0kERkq/Js5AFvjHKbYOceFTHBpOLNFBTmS+d7NU+rR2c+/AaXF3NK8b?=
 =?us-ascii?Q?oMGUmnca/1NZzVTUK12AXUhS2l3zq1EAeYBl3YQ1LSPQw+mGJmausuNfB0/g?=
 =?us-ascii?Q?vPhn51EcaA+XsypO7GiSL/wABKbrq6d6JWbzgWcZzwxI1y+MGt7dqbL5FL06?=
 =?us-ascii?Q?37lF2z7swh3GHOglvlGA5g5ssN/2+VirOTLmIbYHks+nbimVaOoqkTSzfIZA?=
 =?us-ascii?Q?fjrr0Ho9RAyguOM476hh7LHpvJMYZKi2vzFGqhpMKrIKxfjBIA0jEox5jihU?=
 =?us-ascii?Q?f+iKRTj4Tw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29d1807d-8e90-4d68-e4d9-08da2106f35d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:44:56.5070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdQ8up/LnV9yrGs/c+jmvMiO5m/YgdC+oIaiJqNqTb8gMUbcIAsOIFXg26hMspyLWLjRZCfSKeRed+63LEi9LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3664
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

For each port get slot_index using PMLP register. For ports residing
on a linecard, identify it with the linecard by setting mapping
using devlink_port_linecard_set() helper. Use linecard slot index for
PMTDB register queries.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    | 28 ++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  6 ++-
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 13 ++++++
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  9 ++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 44 ++++++++++++++-----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 37 +++++++++-------
 8 files changed, 107 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 9b5c2c60b9aa..0e92dd91eca4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -48,6 +48,7 @@ struct mlxsw_core_port {
 	struct devlink_port devlink_port;
 	void *port_driver_priv;
 	u16 local_port;
+	struct mlxsw_linecard *linecard;
 };
 
 void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port)
@@ -2975,7 +2976,7 @@ EXPORT_SYMBOL(mlxsw_core_res_get);
 
 static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 				  enum devlink_port_flavour flavour,
-				  u32 port_number, bool split,
+				  u8 slot_index, u32 port_number, bool split,
 				  u32 split_port_subnumber,
 				  bool splittable, u32 lanes,
 				  const unsigned char *switch_id,
@@ -2998,6 +2999,15 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 	attrs.switch_id.id_len = switch_id_len;
 	mlxsw_core_port->local_port = local_port;
 	devlink_port_attrs_set(devlink_port, &attrs);
+	if (slot_index) {
+		struct mlxsw_linecard *linecard;
+
+		linecard = mlxsw_linecard_get(mlxsw_core->linecards,
+					      slot_index);
+		mlxsw_core_port->linecard = linecard;
+		devlink_port_linecard_set(devlink_port,
+					  linecard->devlink_linecard);
+	}
 	err = devl_port_register(devlink, devlink_port, local_port);
 	if (err)
 		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
@@ -3015,7 +3025,7 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u16 local_port
 }
 
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
-			 u32 port_number, bool split,
+			 u8 slot_index, u32 port_number, bool split,
 			 u32 split_port_subnumber,
 			 bool splittable, u32 lanes,
 			 const unsigned char *switch_id,
@@ -3024,7 +3034,7 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
 	int err;
 
 	err = __mlxsw_core_port_init(mlxsw_core, local_port,
-				     DEVLINK_PORT_FLAVOUR_PHYSICAL,
+				     DEVLINK_PORT_FLAVOUR_PHYSICAL, slot_index,
 				     port_number, split, split_port_subnumber,
 				     splittable, lanes,
 				     switch_id, switch_id_len);
@@ -3055,7 +3065,7 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 
 	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
 				     DEVLINK_PORT_FLAVOUR_CPU,
-				     0, false, 0, false, 0,
+				     0, 0, false, 0, false, 0,
 				     switch_id, switch_id_len);
 	if (err)
 		return err;
@@ -3131,6 +3141,16 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_port_devlink_port_get);
 
+struct mlxsw_linecard *
+mlxsw_core_port_linecard_get(struct mlxsw_core *mlxsw_core,
+			     u16 local_port)
+{
+	struct mlxsw_core_port *mlxsw_core_port =
+					&mlxsw_core->ports[local_port];
+
+	return mlxsw_core_port->linecard;
+}
+
 bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port)
 {
 	const struct mlxsw_bus_info *bus_info = mlxsw_core->bus_info;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 865252e97e14..850fff51b79f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -236,7 +236,8 @@ void mlxsw_core_lag_mapping_clear(struct mlxsw_core *mlxsw_core,
 
 void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port);
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u16 local_port,
-			 u32 port_number, bool split, u32 split_port_subnumber,
+			 u8 slot_index, u32 port_number, bool split,
+			 u32 split_port_subnumber,
 			 bool splittable, u32 lanes,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
@@ -257,6 +258,9 @@ enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u16 local_port);
+struct mlxsw_linecard *
+mlxsw_core_port_linecard_get(struct mlxsw_core *mlxsw_core,
+			     u16 local_port);
 bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u16 local_port);
 void mlxsw_core_ports_remove_selected(struct mlxsw_core *mlxsw_core,
 				      bool (*selector)(void *priv,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 49dfec14da75..1d50bfe67156 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -481,6 +481,15 @@ mlxsw_linecard_ini_in_use_wait(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
+static bool mlxsw_linecard_port_selector(void *priv, u16 local_port)
+{
+	struct mlxsw_linecard *linecard = priv;
+	struct mlxsw_core *mlxsw_core;
+
+	mlxsw_core = linecard->linecards->mlxsw_core;
+	return linecard == mlxsw_core_port_linecard_get(mlxsw_core, local_port);
+}
+
 static int mlxsw_linecard_provision(struct devlink_linecard *devlink_linecard,
 				    void *priv, const char *type,
 				    const void *type_priv,
@@ -531,6 +540,10 @@ static int mlxsw_linecard_unprovision(struct devlink_linecard *devlink_linecard,
 
 	mlxsw_core = linecard->linecards->mlxsw_core;
 
+	mlxsw_core_ports_remove_selected(mlxsw_core,
+					 mlxsw_linecard_port_selector,
+					 linecard);
+
 	err = mlxsw_linecard_ini_in_use_wait(mlxsw_core, linecard, extack);
 	if (err)
 		goto err_out;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index ee1cb1b81669..d9660d4cce96 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -223,7 +223,7 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u16 local_port, u8 module)
 	struct net_device *dev;
 	int err;
 
-	err = mlxsw_core_port_init(mlxsw_m->core, local_port,
+	err = mlxsw_core_port_init(mlxsw_m->core, local_port, 0,
 				   module + 1, false, 0, false,
 				   0, mlxsw_m->base_mac,
 				   sizeof(mlxsw_m->base_mac));
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e41451028478..23589d3b160a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -4325,6 +4325,15 @@ MLXSW_ITEM32(reg, pmlp, width, 0x00, 0, 8);
  */
 MLXSW_ITEM32_INDEXED(reg, pmlp, module, 0x04, 0, 8, 0x04, 0x00, false);
 
+/* reg_pmlp_slot_index
+ * Module number.
+ * Slot_index
+ * Slot_index = 0 represent the onboard (motherboard).
+ * In case of non-modular system only slot_index = 0 is available.
+ * Access: RW
+ */
+MLXSW_ITEM32_INDEXED(reg, pmlp, slot_index, 0x04, 8, 4, 0x04, 0x00, false);
+
 /* reg_pmlp_tx_lane
  * Tx Lane. When rxtx field is cleared, this field is used for Rx as well.
  * Access: RW
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index c3b9e244e888..ac6348e2ff1f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -492,11 +492,13 @@ mlxsw_sp_port_module_info_parse(struct mlxsw_sp *mlxsw_sp,
 {
 	bool separate_rxtx;
 	u8 first_lane;
+	u8 slot_index;
 	u8 module;
 	u8 width;
 	int i;
 
 	module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
+	slot_index = mlxsw_reg_pmlp_slot_index_get(pmlp_pl, 0);
 	width = mlxsw_reg_pmlp_width_get(pmlp_pl);
 	separate_rxtx = mlxsw_reg_pmlp_rxtx_get(pmlp_pl);
 	first_lane = mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, 0);
@@ -513,6 +515,11 @@ mlxsw_sp_port_module_info_parse(struct mlxsw_sp *mlxsw_sp,
 				local_port);
 			return -EINVAL;
 		}
+		if (mlxsw_reg_pmlp_slot_index_get(pmlp_pl, i) != slot_index) {
+			dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unsupported module config: contains multiple slot indexes\n",
+				local_port);
+			return -EINVAL;
+		}
 		if (separate_rxtx &&
 		    mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, i) !=
 		    mlxsw_reg_pmlp_rx_lane_get(pmlp_pl, i)) {
@@ -528,6 +535,7 @@ mlxsw_sp_port_module_info_parse(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	port_mapping->module = module;
+	port_mapping->slot_index = slot_index;
 	port_mapping->width = width;
 	port_mapping->module_width = width;
 	port_mapping->lane = mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, 0);
@@ -556,11 +564,14 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	int i, err;
 
-	mlxsw_env_module_port_map(mlxsw_sp->core, 0, port_mapping->module);
+	mlxsw_env_module_port_map(mlxsw_sp->core, port_mapping->slot_index,
+				  port_mapping->module);
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, port_mapping->width);
 	for (i = 0; i < port_mapping->width; i++) {
+		mlxsw_reg_pmlp_slot_index_set(pmlp_pl, i,
+					      port_mapping->slot_index);
 		mlxsw_reg_pmlp_module_set(pmlp_pl, i, port_mapping->module);
 		mlxsw_reg_pmlp_tx_lane_set(pmlp_pl, i, port_mapping->lane + i); /* Rx & Tx */
 	}
@@ -571,7 +582,8 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	return 0;
 
 err_pmlp_write:
-	mlxsw_env_module_port_unmap(mlxsw_sp->core, 0, port_mapping->module);
+	mlxsw_env_module_port_unmap(mlxsw_sp->core, port_mapping->slot_index,
+				    port_mapping->module);
 	return err;
 }
 
@@ -592,7 +604,8 @@ static int mlxsw_sp_port_open(struct net_device *dev)
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	int err;
 
-	err = mlxsw_env_module_port_up(mlxsw_sp->core, 0,
+	err = mlxsw_env_module_port_up(mlxsw_sp->core,
+				       mlxsw_sp_port->mapping.slot_index,
 				       mlxsw_sp_port->mapping.module);
 	if (err)
 		return err;
@@ -603,7 +616,8 @@ static int mlxsw_sp_port_open(struct net_device *dev)
 	return 0;
 
 err_port_admin_status_set:
-	mlxsw_env_module_port_down(mlxsw_sp->core, 0,
+	mlxsw_env_module_port_down(mlxsw_sp->core,
+				   mlxsw_sp_port->mapping.slot_index,
 				   mlxsw_sp_port->mapping.module);
 	return err;
 }
@@ -615,7 +629,8 @@ static int mlxsw_sp_port_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
-	mlxsw_env_module_port_down(mlxsw_sp->core, 0,
+	mlxsw_env_module_port_down(mlxsw_sp->core,
+				   mlxsw_sp_port->mapping.slot_index,
 				   mlxsw_sp_port->mapping.module);
 	return 0;
 }
@@ -1462,12 +1477,13 @@ static int mlxsw_sp_port_tc_mc_mode_set(struct mlxsw_sp_port *mlxsw_sp_port,
 static int mlxsw_sp_port_overheat_init_val_set(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
 	u8 module = mlxsw_sp_port->mapping.module;
 	u64 overheat_counter;
 	int err;
 
-	err = mlxsw_env_module_overheat_counter_get(mlxsw_sp->core, 0, module,
-						    &overheat_counter);
+	err = mlxsw_env_module_overheat_counter_get(mlxsw_sp->core, slot_index,
+						    module, &overheat_counter);
 	if (err)
 		return err;
 
@@ -1542,7 +1558,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	}
 
 	splittable = lanes > 1 && !split;
-	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
+	err = mlxsw_core_port_init(mlxsw_sp->core, local_port, slot_index,
 				   port_number, split, split_port_subnumber,
 				   splittable, lanes, mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
@@ -1792,7 +1808,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
 			       MLXSW_PORT_SWID_DISABLED_PORT);
 err_port_swid_set:
-	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, 0,
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port,
+				   port_mapping->slot_index,
 				   port_mapping->module);
 	return err;
 }
@@ -1800,6 +1817,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[local_port];
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
 	u8 module = mlxsw_sp_port->mapping.module;
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
@@ -1822,7 +1840,7 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
 	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
 			       MLXSW_PORT_SWID_DISABLED_PORT);
-	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, 0, module);
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, slot_index, module);
 }
 
 static int mlxsw_sp_cpu_port_create(struct mlxsw_sp *mlxsw_sp)
@@ -2194,7 +2212,8 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u16 local_port,
 		return -EINVAL;
 	}
 
-	mlxsw_reg_pmtdb_pack(pmtdb_pl, 0, mlxsw_sp_port->mapping.module,
+	mlxsw_reg_pmtdb_pack(pmtdb_pl, mlxsw_sp_port->mapping.slot_index,
+			     mlxsw_sp_port->mapping.module,
 			     mlxsw_sp_port->mapping.module_width / count,
 			     count);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtdb), pmtdb_pl);
@@ -2259,7 +2278,8 @@ static int mlxsw_sp_port_unsplit(struct mlxsw_core *mlxsw_core, u16 local_port,
 	count = mlxsw_sp_port->mapping.module_width /
 		mlxsw_sp_port->mapping.width;
 
-	mlxsw_reg_pmtdb_pack(pmtdb_pl, 0, mlxsw_sp_port->mapping.module,
+	mlxsw_reg_pmtdb_pack(pmtdb_pl, mlxsw_sp_port->mapping.slot_index,
+			     mlxsw_sp_port->mapping.module,
 			     mlxsw_sp_port->mapping.module_width / count,
 			     count);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtdb), pmtdb_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 928c3a63b6b6..2ad29ae1c640 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -145,6 +145,7 @@ struct mlxsw_sp_mall_entry;
 
 struct mlxsw_sp_port_mapping {
 	u8 module;
+	u8 slot_index;
 	u8 width; /* Number of lanes used by the port */
 	u8 module_width; /* Number of lanes in the module (static) */
 	u8 lane;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index f72c26ce0391..915dffb85a1c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -568,14 +568,14 @@ struct mlxsw_sp_port_stats {
 static u64
 mlxsw_sp_port_get_transceiver_overheat_stats(struct mlxsw_sp_port *mlxsw_sp_port)
 {
-	struct mlxsw_sp_port_mapping port_mapping = mlxsw_sp_port->mapping;
 	struct mlxsw_core *mlxsw_core = mlxsw_sp_port->mlxsw_sp->core;
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
+	u8 module = mlxsw_sp_port->mapping.module;
 	u64 stats;
 	int err;
 
-	err = mlxsw_env_module_overheat_counter_get(mlxsw_core, 0,
-						    port_mapping.module,
-						    &stats);
+	err = mlxsw_env_module_overheat_counter_get(mlxsw_core, slot_index,
+						    module, &stats);
 	if (err)
 		return mlxsw_sp_port->module_overheat_initial_val;
 
@@ -1035,7 +1035,8 @@ static int mlxsw_sp_get_module_info(struct net_device *netdev,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
-	return mlxsw_env_get_module_info(netdev, mlxsw_sp->core, 0,
+	return mlxsw_env_get_module_info(netdev, mlxsw_sp->core,
+					 mlxsw_sp_port->mapping.slot_index,
 					 mlxsw_sp_port->mapping.module,
 					 modinfo);
 }
@@ -1045,10 +1046,11 @@ static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
+	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core, 0,
-					   mlxsw_sp_port->mapping.module, ee,
-					   data);
+	return mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core, slot_index,
+					   module, ee, data);
 }
 
 static int
@@ -1058,10 +1060,11 @@ mlxsw_sp_get_module_eeprom_by_page(struct net_device *dev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_get_module_eeprom_by_page(mlxsw_sp->core, 0, module,
-						   page, extack);
+	return mlxsw_env_get_module_eeprom_by_page(mlxsw_sp->core, slot_index,
+						   module, page, extack);
 }
 
 static int
@@ -1202,9 +1205,11 @@ static int mlxsw_sp_reset(struct net_device *dev, u32 *flags)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_reset_module(dev, mlxsw_sp->core, 0, module, flags);
+	return mlxsw_env_reset_module(dev, mlxsw_sp->core, slot_index,
+				      module, flags);
 }
 
 static int
@@ -1214,10 +1219,11 @@ mlxsw_sp_get_module_power_mode(struct net_device *dev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_get_module_power_mode(mlxsw_sp->core, 0, module,
-					       params, extack);
+	return mlxsw_env_get_module_power_mode(mlxsw_sp->core, slot_index,
+					       module, params, extack);
 }
 
 static int
@@ -1227,10 +1233,11 @@ mlxsw_sp_set_module_power_mode(struct net_device *dev,
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	u8 slot_index = mlxsw_sp_port->mapping.slot_index;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_set_module_power_mode(mlxsw_sp->core, 0, module,
-					       params->policy, extack);
+	return mlxsw_env_set_module_power_mode(mlxsw_sp->core, slot_index,
+					       module, params->policy, extack);
 }
 
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
-- 
2.33.1

