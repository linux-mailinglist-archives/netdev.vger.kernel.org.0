Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEAD46E58D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhLIJcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:32:13 -0500
Received: from mail-bn8nam08on2090.outbound.protection.outlook.com ([40.107.100.90]:64096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236162AbhLIJcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 04:32:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hteAAtfB32Bhp3xbnKOx4pM80NVr9K0pv4r1crgtTbPJkSyig2C92/lbSg1IrNJEvu/OULw37txOKSlkb+6I4JgQL+ABJU1qXwiJcae1eyOPjWB704fvCTaj98HbDBOZkt2Eht9EKoEc5nJIkpmDg4HjWZDTxFsGIbRiUhUFLxROq/jkFhSXXghhbNPCOB8K7WrbcEoXSGddzOmMDkfNKOSaeRMBZo8DIwT7CNIXQgtYMrvqc9jDUQSRt1pCwPk/joZ/z/Ijby5uY54ymyAFsHgK5D0SfTEjZToxrZZ2U0fu9xW8/X3OkiyGTqdCySPzbSOTRtMdhv0zafnBN2aOAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYAphJeIrZbS+0EUgqska3nODFPf1MagZQ7IFbPquT4=;
 b=KDCtgNtIhQ8qIy733ArdItyJXSWkf6CC8kBH7SWxY7QqPDuMbLAhV/wcgjrOgvCGX5pCNSZZ/TgqxGfyxCni2V836TZVuqHulPLScWC9nHIxMcyjj2fTmLk7v4InTJkVWGWwbpXSP9D05yAeWiFGl24dhA+VxDy/sFTtBvAVAmQF1m4IAvM7jlXQKkJyzSTUzYIvl6oUu5HWg/OgFIs1sh7nxFtXha8L87TwFe9D1YfFX5FMqrcbQGwFqRDPbVZepjJKRJRSCW0Ntf7PLHI/CTtVR9p15BPxll3WixHmi+tVIkDcWE8YGkaLypu1rz1OEvzqmZKJY4No4QBCcACFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYAphJeIrZbS+0EUgqska3nODFPf1MagZQ7IFbPquT4=;
 b=Iw/Q1zfpR+USp7SytkcuT1M2B6NaxmN9R5RlxD6v4ZyjoKHaTCYJ8i2jHBHVjyE6gt+6AHbiJY/IRceQ15oUYSVXJw7X7YIO5ANBODKW3xa9TBgDiYATVEAzrRej8wOY4wc3Yx5kIXeg/pZsG5K6C9AfHbUzLKxoZH5YiA4wcU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5494.namprd13.prod.outlook.com (2603:10b6:510:128::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10; Thu, 9 Dec
 2021 09:28:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4778.012; Thu, 9 Dec 2021
 09:28:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v6 net-next 03/12] flow_offload: add index to flow_action_entry structure
Date:   Thu,  9 Dec 2021 10:27:57 +0100
Message-Id: <20211209092806.12336-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211209092806.12336-1-simon.horman@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b14cf0b-3456-4007-d54d-08d9baf64531
X-MS-TrafficTypeDiagnostic: PH0PR13MB5494:EE_
X-Microsoft-Antispam-PRVS: <PH0PR13MB5494F05BC63F3188C963373EE8709@PH0PR13MB5494.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:64;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmh9CpMJdDIL1S/eXXI00gucTkhyBZkcEr+9iL593vWI+ir/ycZLZRo5i50QyhDIL4MwWKXoy0lxUoaIDtaAWsfklCAAp5zxnpcXdofZ/zgqkNYxyujcvdClMrDzdtqg8Xq3N0ZNjJt02b1pV5abneqPxBzBMZ3WphThk55gyms+dNeG6qHsHbgTJPZPtH3lu7Yt3ChfJ2OqRRaXDVDL1ZKpv50nl0dA5eT7Doz2/f2QahFluiMe2jVTjDuuun0NmjJkI4omQn6TJHRlO98IHQq6moSmkBxS/3oPjrPfGPvUsm3C3KGdRu8ZvHVC6pbmTMwbpeviQFlc502gvPTHRCd84QZwjAuel1kNSRM0INO99sJbpPboi/dDLzgvt8o374WUaYFxVCaEeo4HnwunCMl+xs4yziOdBKnDI70EYGAa8VMV8vu3zU2S14zjkHXS2yNrJi3+LKtW02MT2FOfYleil517+NTYdHRhW/dfN5Ns7M31IhuZynJvzCv6p4Fk57e/vS9FHVpXU+hRSBz/Lj79LDkzlsm1SdXvYSOQKdugU33joFAmPW6NIOQgDQjGGwdQSY5Z2zoh/c/jHMkgwc1nXwvfW3kj3emkeIUmQywAoRjPDwvdggkXQUuWUaqRvMEOEfL6OcOC4kkFvLmd2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(346002)(136003)(376002)(366004)(6666004)(6512007)(44832011)(38100700002)(6916009)(66556008)(86362001)(52116002)(316002)(1076003)(6506007)(8936002)(8676002)(4326008)(36756003)(2906002)(6486002)(5660300002)(186003)(66476007)(2616005)(83380400001)(508600001)(54906003)(66946007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hPPcPkkSqOD/ndLpZAajinDAuFp9QJqFNoaVuUNoz321JocRFvvEVYrTOagR?=
 =?us-ascii?Q?spHEFT2V3+s7Wn4jUqamYCxynOtDZgptwSyT1ovE5xH5rc7XoqoVbwjZtZGK?=
 =?us-ascii?Q?Ob3Hp14YXlaYqCxm6eMC+hA5oLCTWMldyVILrcMuCUt+3nTQF8CT/L6lXd1S?=
 =?us-ascii?Q?Sxd+ISg5B9jJZNT6KGcoUL/nEajGk+yxvLAoXNhip7aXaJy9wyrpgrZPtgBf?=
 =?us-ascii?Q?0Lf3R6eGBmM9+J6lT3df5gm4otoERHs/T181CoxvpihZ7sRNZHtqfHsxu5PP?=
 =?us-ascii?Q?ETp0+O7aZWgNKkkpChf2AySGHvO+hJovXX50IxZTz/GchbTPgj7IV10+XXNO?=
 =?us-ascii?Q?OyE/jmA4Cqmm2+BKuNp7ue/wR8FGaSX4qHjgZ6cT2XAbDM6vE1NFspRxunbX?=
 =?us-ascii?Q?r9VTLfsheYGgrT9YhAPFLf2EkILMkdJEkft5HFulyCy18U1JwS4BrrxTjrAc?=
 =?us-ascii?Q?2l+mHqImiDf0DKN5UQnsl1ij5wYIrfsz39ud6+f8jwSDi534Ijmci48JEC05?=
 =?us-ascii?Q?x4QCMNaC2WvXgcwkk+lFdP5Y+ZVOHIbU3aHsMQxgh/J6WRqTUkC1fNdBe55P?=
 =?us-ascii?Q?ce7acckI31KmY06gDLAX2GBN2V4RPl7+uDfJtAI/DfCUxUTMYb6DqN0poIzD?=
 =?us-ascii?Q?y11ZoI1sKyXzjgw8MLPxX6rE53ooURzVv6en0yHVEmtK0JOtrrE19OsNXJ56?=
 =?us-ascii?Q?7rr+hK8oQGGO9XSP5c9amZT/9nObj/Wu88I4sjMJoe/5052tO+j3w3fvPb1v?=
 =?us-ascii?Q?ZCPrH07x2xoXODI4tmFu8ZBLthnyflgQUXAAFhOxX/ChXPrsC+weCoH2qDbO?=
 =?us-ascii?Q?AfSJSjSoFxH4hnquxy1rFyj8UTKsR895YxeCLNNMaFWNcS4l0bqk8+DFRpVv?=
 =?us-ascii?Q?Uznb7zXwkq1Ql3+4w0r3+JGRYP+dV8cLV8VHvuoTOOR6kL0wfxxO66+/apyU?=
 =?us-ascii?Q?m/PuDcZZmuXJIPN9nfNoGFfOkHC5ApewJ8le0tk2RrNKGacrsCCkwrcs4rxU?=
 =?us-ascii?Q?XqfJmK9I/XYABn79r1xS5OvECCoshOpyWC7UqDWIZ/JSAcIoMXBO4oljiv8b?=
 =?us-ascii?Q?iK05fLDFm1Y5wTyuVLUuH7wp5pPoUXT/uWx32mljzoq5XRCAQc0A+P9pR3Qr?=
 =?us-ascii?Q?EcbNCHeeWq9Y36pniRW1aaexMmlqemiWoEt7U+FIEjpsptfd6C2JkVebbasg?=
 =?us-ascii?Q?tq0ZtD6MCzW7I6Yr6bzXgP3UhY9h1wO0ZtOJVv+OCBhS3TQhoV9Je4FA/QJp?=
 =?us-ascii?Q?Vel4AvAuaeuGEwSe16DAMAFoX9hYy9/+3dmXOB6ihw3mplcY8N7TO6vK4YNl?=
 =?us-ascii?Q?m8IQ6QAN9nlXV5sh30YHX3YpJP68n1BwgEPDfOTrz3ItW6MmjtrmAjPtruYM?=
 =?us-ascii?Q?OfhnFo+9Dzn5YoarimLWCYNmjDbUhov7SkZdJySi9XR1K52QBTg253OOVuf9?=
 =?us-ascii?Q?aEx2c1xTdp6Jy3C7pMdcxNDGKjCPi5FZ7WELUEgh9+Xq155bDzPYQTNrpQOV?=
 =?us-ascii?Q?qzyWqwwRp7tIB1JsxoirVXdckG7+1KVOT4cX0q32x40SpDDXuMa63R15RKdX?=
 =?us-ascii?Q?asmqz+T47qzehdjOQDDddogc7RFn3ZfzEv1LAHnDkqk9blqBbfQ/AQQa3nfL?=
 =?us-ascii?Q?Ej3bYOsT0KFduEpxlZ6DT7t5WJH+qfetqOineJTY5eGm4+sKsIQ37NeI+a9M?=
 =?us-ascii?Q?CMhVno+4U4mlYlq3HRjsxFYRHlcj+b9odI//rfMufQ4+LL8fiSq3teeAbczo?=
 =?us-ascii?Q?iXlA3SYImFbjTKyuJuFux798GT9Tho8=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b14cf0b-3456-4007-d54d-08d9baf64531
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 09:28:33.7889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQ8iWg0jm5z82NAnA4Zb06pzWQeztSmQBIDWQTWSW2zKvl7Zb4IZBycWWnG3s+Tl1XrnbQCsokhMFXYu7729dc4EFfJi2U+t4D5n6fhd2uI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5494
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
index 110d6c403bdd..8d9a8f386b1b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1745,7 +1745,7 @@ static void vsc9959_psfp_sfi_table_del(struct ocelot *ocelot, u32 index)
 static void vsc9959_psfp_parse_gate(const struct flow_action_entry *entry,
 				    struct felix_stream_gate *sgi)
 {
-	sgi->index = entry->gate.index;
+	sgi->index = entry->index;
 	sgi->ipv_valid = (entry->gate.prio < 0) ? 0 : 1;
 	sgi->init_ipv = (sgi->ipv_valid) ? entry->gate.prio : 0;
 	sgi->basetime = entry->gate.basetime;
@@ -1947,7 +1947,7 @@ static int vsc9959_psfp_filter_add(struct ocelot *ocelot, int port,
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

