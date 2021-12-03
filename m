Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD2346774E
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 13:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244320AbhLCM2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 07:28:34 -0500
Received: from mail-co1nam11on2097.outbound.protection.outlook.com ([40.107.220.97]:50502
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244247AbhLCM2c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 07:28:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFmKYKzWxFbom+cVBgcJkgqOUpERUE1Nz/opbQBzsINNCgD0JOiOkmVJpzRFJXPQdmfOuymTI7uCrafHP8RIisY1Osq7HOFng+cB3CxPpoR7hxfJzjJ7PnFFPZWxBf0oYq3lcCKWrqYcF1rA2mrIw0szp3zUHNi9ncipcvy2kjqFlzrXJ4L1OtMoLHcdmvSKRK/RV/Df5hzLDy86nq0bo4/XIr8gGBQqk0sN3baeQCdBX31PpmrYoFotF9NRTLgvFRGGugyFPcv4x4c0h2YxZx2vo9uUCwu/divBLE4uBvaBxJbeWGS1QOzQmYDWfpLw/MCQOHlssA+XvmVIrbkm+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OimqGES5noFBcMrC0mua++CoK1sjjWPHvy6v/bW4KQg=;
 b=XJ+8T9KrS4Mt2DqC+8lmeD9pVzb88OSVmOO7sR314veQ+kdPDjxNZgKFsimsOUsdqu83Y0Ex+AP/6Bm4DasLzjPjb9dADy1UBFwbwtosPFWKy/D+giMXwd4zitLVqCXh5n/AqLm1FZ7ySOV5h8EekGH/vkOJOfon0b88vVX0sPdxO16A9trqtGL4S2hWQ3ES5PB0tLgkli/GpItH7LDfkvGnOdfO+7ExoOlE1jFFeySx7Lyf7nbLVJ8brgVZoF6CyHM7xQTY/DdETTHB+L2M/TGb1fhTvrQnvyw07EnUE40WiNLLVzG/Bbzcbuh7U3qsPBVeSWFlshDqQdQZNrJU+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OimqGES5noFBcMrC0mua++CoK1sjjWPHvy6v/bW4KQg=;
 b=BBbVi5AZsN2bi+Ft5donvFBmIDKtW+AvxJ6OJo213DAoz2agUQI8bNuqBF0DPJvSFy8UzYXKaezKhuvyHLpbMkuUNrxQ/A1U6jidfDQyGVVkm87NT2fRB9aTv5NSffqKPcZz2PNm1lHNJQfYATf+ElboGG3nDjmEXGjEml+zY34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5283.namprd13.prod.outlook.com (2603:10b6:510:f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 3 Dec
 2021 12:25:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4755.015; Fri, 3 Dec 2021
 12:25:07 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 03/12] flow_offload: add index to flow_action_entry structure
Date:   Fri,  3 Dec 2021 13:24:35 +0100
Message-Id: <20211203122444.11756-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211203122444.11756-1-simon.horman@corigine.com>
References: <20211203122444.11756-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0059.eurprd03.prod.outlook.com
 (2603:10a6:207:5::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM3PR03CA0059.eurprd03.prod.outlook.com (2603:10a6:207:5::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend Transport; Fri, 3 Dec 2021 12:25:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22857225-4c95-4ee2-df49-08d9b657f0f6
X-MS-TrafficTypeDiagnostic: PH0PR13MB5283:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB52838C39297200EA74855176E86A9@PH0PR13MB5283.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:64;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: acGcVOyEcrosctiWjc1RhN/HzPvHqSfvCkrRg512FpNSzO5JtsuJoAuD8Q549d9m+5BktYEt16Zh/RBPyg0XdZ7HWU+U9F3WxPDDFZsANipcz7GPirUhTme3qJ9x9eE2VRn9Iczy7VVRKY+9hptXwMRC2Y0G302QtR4G/rugviXnVr1avggP0+a5MEmKFj3dsSzTZcFQD9qNSvxyPvQ9OQfdNW6890Y3UhWw9MLDkkjdC0Giim2zj1u9DlqeFvSCV2v5mu5cIrqfCfJF8i6P/FTpCiIdfNMxjPA5t+MsJYzSGOMbN4SnzUzbjZBuBcBRxlP+4FtSqfwZ19KuEhZx7VodR1rSYxqbWTmbWK3cx2eoVBA0qhhE/QyanIfJSHHgNbDxkbcDHqdJ0n/rP6x91Yxae1EocKJfFsPTtvwQjEQf62Uo+83SHOYaPLTBEj5eD+aFnsOtYOitcIc+PLvnblBieuFIcLToeZ5YHGX/f/VkuYvhaJtEmUIuBQ0FxRlkJmoLtsyR9iiPv89m4JW4m8bWJJEAhVurSJXPAXKgsx+RiZn+rvmEiIa+F1J97modE4xvJrgUdP/aliqUMjxytpH0ftSN565fvv+b1QDWM1O2G+mO8f8IElVZVBi/L/waqnaI+mB52gnj3zKHdHBTkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(346002)(376002)(136003)(396003)(86362001)(52116002)(36756003)(44832011)(508600001)(186003)(83380400001)(6666004)(6486002)(66946007)(6916009)(5660300002)(316002)(2616005)(66476007)(8676002)(6506007)(8936002)(107886003)(2906002)(6512007)(54906003)(38100700002)(1076003)(4326008)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RCAYLLyXiYdpg0Q3rKE/FG9yH8lKdIQHDC8vgQyLQy7CuaQzVB7Wr2fIrJiF?=
 =?us-ascii?Q?owI0iBwcCjCc+isqIlKpvNWqSSazHwdfVLsdhvA2IWWCLND2OHSg2oOX+Qmb?=
 =?us-ascii?Q?HKPp8GeG0axUhXiiPzVP123nY/+RarSGs+gp4dOSlfAA3ZqENtNlnPeekI8U?=
 =?us-ascii?Q?MGsbqmk7DXKtf6hEYGz7FbNRaQsyTYEXBOiTwuDujPF54WryFSn4rkB3o7HZ?=
 =?us-ascii?Q?idcnfoIop/UMwf4HALaH3eaXo2xdqyDjGydnkSB/xsuXLrrdGjEc0bkInwbi?=
 =?us-ascii?Q?kmhaK5ZYSlIBd9QovwXDuY2BEquAwOgdgcadc7Ai3700Sp3DPZbHfaXuWMBk?=
 =?us-ascii?Q?k0fRkKJRAr0MQYQyj5cNre6wrUbMBkm92mk4psIg2zlDD3yhz/MtstjvPSY9?=
 =?us-ascii?Q?dOhsdi29gBgLC8/ZrYy634Sh7Ibey73lhUmEm7bUsF4bg3Fo1phg3cYHNNLa?=
 =?us-ascii?Q?FQ5OqFPb8secZckBow9cnAxHpDqCNEtdwc9CxwWVi2MsY+I7jyYcMaNHyMtr?=
 =?us-ascii?Q?lKm/vIiCg75cWvqwuymlk7ybov90zl9h7LBHJo7ZM39LvOW5zVJ4rx8+hJUs?=
 =?us-ascii?Q?ZT1nP5GX/zpIKQfFCoFIVYv2HEXgqNqRwMogLxkkdUdBWQxxcmAYHqbZjcPu?=
 =?us-ascii?Q?tLjTNsgwvQtw9tPRGz0iXSjvKPWGtcQOwRXRUq9EEeYRU4SHvWLVAU+cP8my?=
 =?us-ascii?Q?LSCZMP53fUA1G1u/GAGuTIj2ZDPZ+5OVXTk1MxzPLJBCP11xQK6W/cUqZ3Wq?=
 =?us-ascii?Q?KWuVJXPP6ktrNN+fYsnR1aLS25B50t0fA/PY8H8FC3HvO07jOkIib9MyP+Rx?=
 =?us-ascii?Q?4mKdvqLQDyL/rVisWavdYh0jgH0iFmhqQoqE//1i8akMSAxpcc1o73/lMKvA?=
 =?us-ascii?Q?ScgkQh5MN2fL+CBsW627/Gfg7Dbn6D1YfVoSVVfJSCuvZZYM2uplwGv0kbOt?=
 =?us-ascii?Q?D2VM3XA+pCKZ0TpcrusSabWNUUC2g+ZfQtEVWeV65k/3VhPlxe1ZfYipHDCZ?=
 =?us-ascii?Q?AvjT2Oiwk2zXBzt2uppyvHyvzPs4GaxtoHRJgA47RGp2FCYvHLLN+fjNnI6v?=
 =?us-ascii?Q?BJpaf1rDWPTR7EUqHV57vW+gIgg2JY0ihYLn5xbmRBex3OLH1SdDhsJBw3Wv?=
 =?us-ascii?Q?CUqeXK1OO2pfCRYVm/KPgVql7xAfT38/KSCwWhLtf4Z8ePzZxEt9F9uqd8mJ?=
 =?us-ascii?Q?29gAW/CbMMX4wAmiXBG47ZOk1nRMbSnGnZ1DjLeZ5ZYm8eADSz4po0DWGtxJ?=
 =?us-ascii?Q?gRhzF6N5JLuodubDJxFJKqER69oHcA2M3ymZ9iOaMJEtplvHSC9zRxHJ+A3X?=
 =?us-ascii?Q?YxhhLkLCkewQw/+JHq/2BS6JO+GWlxc68W58YIpsftB19wF0QWRB1WGSpD2Z?=
 =?us-ascii?Q?+nOx1oEjBNdaCSwimrfbocAiDf3GDk+9UThF+i2HPkWzVpXmwNz7Dvo3sjbV?=
 =?us-ascii?Q?a+1k85Gg1XrWeM6eUr7I2a1kRNOj3rQsTJfzICt/fvyYdOUy+dcIES3pw5fA?=
 =?us-ascii?Q?6J8b7Ar8c1QZ/+0+SADMDdxYhaNjaQTiukd8/idG9sEbuq2oTtyNlmCTPY2l?=
 =?us-ascii?Q?63eD7dxM+NNRVEEMbz50uMFDIU8CYZ0m6yD/2q/eTTRx3ifEcGhohextH43X?=
 =?us-ascii?Q?cC+gorrlULH+EfNXzrsbwjcZL2pZhIoCBcCgNBn3R7y9lNe9oiPLAhwdNtoC?=
 =?us-ascii?Q?nK1BwWVnUuarubdhcUQD1Kz2B5m6FCZc5HgWFbwqXWRSerGPnmIYWvw0d97g?=
 =?us-ascii?Q?mBGrjGIMpg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22857225-4c95-4ee2-df49-08d9b657f0f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 12:25:07.3235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTOqriN6uDgYFxdEDdbg0KfdEX/LTgcM9gIiub/S9EbMp6Z7aaN7Er2mWR9mpzGOBVb1bVYOdTELLv4Ip7yLPwPet3fj8PSVS6TjrgiUm8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5283
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add index to flow_action_entry structure and delete index from police and
gate child structure.

We make this change to offload tc action for driver to identify a tc
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c                | 4 ++--
 drivers/net/dsa/sja1105/sja1105_flower.c              | 2 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c      | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c             | 2 +-
 include/net/flow_offload.h                            | 3 +--
 include/net/tc_act/tc_gate.h                          | 5 -----
 net/sched/cls_api.c                                   | 3 +--
 8 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9add86eda7e3..2dc29423d850 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1746,7 +1746,7 @@ static void vsc9959_psfp_sfi_table_del(struct ocelot *ocelot, u32 index)
 static void vsc9959_psfp_parse_gate(const struct flow_action_entry *entry,
 				    struct felix_stream_gate *sgi)
 {
-	sgi->index = entry->gate.index;
+	sgi->index = entry->index;
 	sgi->ipv_valid = (entry->gate.prio < 0) ? 0 : 1;
 	sgi->init_ipv = (sgi->ipv_valid) ? entry->gate.prio : 0;
 	sgi->basetime = entry->gate.basetime;
@@ -1948,7 +1948,7 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
 			kfree(sgi);
 			break;
 		case FLOW_ACTION_POLICE:
-			index = a->police.index + VSC9959_PSFP_POLICER_BASE;
+			index = a->index + VSC9959_PSFP_POLICER_BASE;
 			if (index > VSC9959_PSFP_POLICER_MAX) {
 				ret = -EINVAL;
 				goto err;
diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 72b9b39b0989..ff0b48d48576 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -379,7 +379,7 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			vl_rule = true;
 
 			rc = sja1105_vl_gate(priv, port, extack, cookie,
-					     &key, act->gate.index,
+					     &key, act->index,
 					     act->gate.prio,
 					     act->gate.basetime,
 					     act->gate.cycletime,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 0536d2c76fbc..04a81bba14b2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1182,7 +1182,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	/* parsing gate action */
-	if (entryg->gate.index >= priv->psfp_cap.max_psfp_gate) {
+	if (entryg->index >= priv->psfp_cap.max_psfp_gate) {
 		NL_SET_ERR_MSG_MOD(extack, "No Stream Gate resource!");
 		err = -ENOSPC;
 		goto free_filter;
@@ -1202,7 +1202,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 	}
 
 	refcount_set(&sgi->refcount, 1);
-	sgi->index = entryg->gate.index;
+	sgi->index = entryg->index;
 	sgi->init_ipv = entryg->gate.prio;
 	sgi->basetime = entryg->gate.basetime;
 	sgi->cycletime = entryg->gate.cycletime;
@@ -1244,7 +1244,7 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 			refcount_set(&fmi->refcount, 1);
 			fmi->cir = entryp->police.rate_bytes_ps;
 			fmi->cbs = entryp->police.burst;
-			fmi->index = entryp->police.index;
+			fmi->index = entryp->index;
 			filter->flags |= ENETC_PSFP_FLAGS_FMI;
 			filter->fmi_index = fmi->index;
 			sfi->meter_id = fmi->index;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index be3791ca6069..06c006a8b9b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -203,7 +203,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 			 */
 			burst = roundup_pow_of_two(act->police.burst);
 			err = mlxsw_sp_acl_rulei_act_police(mlxsw_sp, rulei,
-							    act->police.index,
+							    act->index,
 							    act->police.rate_bytes_ps,
 							    burst, extack);
 			if (err)
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 58fce173f95b..5e0d379a7261 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -303,7 +303,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			}
 			filter->action.police_ena = true;
 
-			pol_ix = a->police.index + ocelot->vcap_pol.base;
+			pol_ix = a->index + ocelot->vcap_pol.base;
 			pol_max = ocelot->vcap_pol.max;
 
 			if (ocelot->vcap_pol.max2 && pol_ix > pol_max) {
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3961461d9c8b..f6970213497a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -197,6 +197,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	u32				index;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -232,7 +233,6 @@ struct flow_action_entry {
 			bool			truncate;
 		} sample;
 		struct {				/* FLOW_ACTION_POLICE */
-			u32			index;
 			u32			burst;
 			u64			rate_bytes_ps;
 			u64			burst_pkt;
@@ -267,7 +267,6 @@ struct flow_action_entry {
 			u8		ttl;
 		} mpls_mangle;
 		struct {
-			u32		index;
 			s32		prio;
 			u64		basetime;
 			u64		cycletime;
diff --git a/include/net/tc_act/tc_gate.h b/include/net/tc_act/tc_gate.h
index 8bc6be81a7ad..c8fa11ebb397 100644
--- a/include/net/tc_act/tc_gate.h
+++ b/include/net/tc_act/tc_gate.h
@@ -60,11 +60,6 @@ static inline bool is_tcf_gate(const struct tc_action *a)
 	return false;
 }
 
-static inline u32 tcf_gate_index(const struct tc_action *a)
-{
-	return a->tcfa_index;
-}
-
 static inline s32 tcf_gate_prio(const struct tc_action *a)
 {
 	s32 tcfg_prio;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..d9d6ff0bf361 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3568,6 +3568,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			goto err_out_locked;
 
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
+		entry->index = act->tcfa_index;
 
 		if (is_tcf_gact_ok(act)) {
 			entry->id = FLOW_ACTION_ACCEPT;
@@ -3659,7 +3660,6 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.rate_pkt_ps =
 				tcf_police_rate_pkt_ps(act);
 			entry->police.mtu = tcf_police_tcfp_mtu(act);
-			entry->police.index = act->tcfa_index;
 		} else if (is_tcf_ct(act)) {
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
@@ -3697,7 +3697,6 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->priority = tcf_skbedit_priority(act);
 		} else if (is_tcf_gate(act)) {
 			entry->id = FLOW_ACTION_GATE;
-			entry->gate.index = tcf_gate_index(act);
 			entry->gate.prio = tcf_gate_prio(act);
 			entry->gate.basetime = tcf_gate_basetime(act);
 			entry->gate.cycletime = tcf_gate_cycletime(act);
-- 
2.20.1

