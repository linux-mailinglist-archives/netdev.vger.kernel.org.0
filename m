Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3D14FF9D9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiDMPUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiDMPUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:20:46 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850262D1CE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2ykqT9Uur0IXB4AVEnkJUC4R5lNtS56JBbrm/PCuRtBm0GmcRgMvWC861sCQKeT77CsGVsTgNx1KBPDCwO1eLCB5n0W14McgSRqlSwWuAkcjFO+a0gwj0+ERWdgtE+AlpC0CtlHGGZEJXOi8LtcBFOicfTMeYJnJDARjEuwr2oX7FZnsd4dUOg+/xP/y+1AkIz2j7C0XlRyXowe9NXzuH5ULa0EHZfeBVxfAebl6yHUA7OFB1igtFX7YXqqqY5McM5GLYe7FSYwM2hi+KOIocM/fwc/viPqi/z2NCCbEod3TQ0cQcJPSK9BBzbSsFmDi3QbL5FpXafq1jWcBb6ZhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PClBECFP6l1UjENJpU6yq+zhq2XbsMAJSw+2fk3U8ks=;
 b=ONR3VmtmijVcKT9Ym9B8Y3IP2Bu4X71Zp116yWD1VRBIuD7du0qF9gkhgjiwOt3ph4TXhN/Abo0p0KAdRjf36HVSzJeXBRQOjA7JAYGIjReG+TCOdcU+y3MA0GDXAYRME/3ChGhSY0+NId32iqWEnHhkW67HBrzUN5yPZviT8EuRbHYlYJIZR3PmwOWNX5o0++LZO72CepK4mxsEV2u4GYZdEOk46+GBBXO0oHzGlXuY/cLHU4deOPCkf/z7lwVjuMOGI4+cnPnGvoL788AHvAauVADEWncFvaZFqLx5nT6XP7Q0OIYYXCASVeEbAkhWTx9FgLoTwbFpx6nQ/ZMewg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PClBECFP6l1UjENJpU6yq+zhq2XbsMAJSw+2fk3U8ks=;
 b=qBRXW4UgxvZJEIy7S70ekMHyKpBXnQhcCATKr1XCKEXdDhxnTsyLVlz/nSRpHiA0BxGBoz29B/yBceUD9+Jh21sUnD8RUHYl/vemsPZNOwUpblmFLXwLMtdKEQH0AjhU5Ij7W/345nZvXjc3DlPemTPiwzE8gQJkiiWlvXjNgGN7x8K8TQ/cwe06ew5Q7hSvDVXzO1EhlPCm8o9aTrpzwLFFOM8jIarEQ7nqwKBf5/s23efqI+HxByKNkosk/IiwUc+rbgU0xJrKqrcNa1t+9PsuLctUwEi4K4bVGfzZNmFpZtQJiNxIgDiKo5A8+z1ZowSxeKFMSFPb9mhs84Z7fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BYAPR12MB4616.namprd12.prod.outlook.com (2603:10b6:a03:a2::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 15:18:22 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:22 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/9] mlxsw: core: Extend port module data structures for line cards
Date:   Wed, 13 Apr 2022 18:17:26 +0300
Message-Id: <20220413151733.2738867-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0048.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::37) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb39e88d-a2f3-4077-470e-08da1d60d8f3
X-MS-TrafficTypeDiagnostic: BYAPR12MB4616:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4616900566E333A3C5579703B2EC9@BYAPR12MB4616.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oAgNgZI/7CMmkynGvru9kb0BbE4wRTYe3B4FbFdxwtIe0ZzwLTRd8OnMHXcl0jrlwGK+aLfdwHLggyeTM9mKx+jvjBjGTgkrI+/N7TAQBI7UpE1reqstszsadLzVcoq585Kpz3SpUStEQAFqPgyLBoiZHaoR6/cO3HgkLr9X7upRGaTNfuDWmRA9VLDR7xML2xyS8aOsLldFMCCTX1Eb8KGdRSQuVRzGi+5tTDRlkSxxeUYCt5CXhIPcLZLxsalSOpmhn16sD3ehGoKa7YmJjsq+CsfzPeoKOAyXNxQN0D7c3QYfQSHstC6MVsEcGV5BPKl/E5ZvxgbDIAsF0PWysao4fclCheIzw1rKOlcoAaN+UBtDImVvBNsFPKrn6TZp/cRhxgoYiG7QGSXH/HqUOKtXEFCkKarP6Q3QG/q49LpkL+FfT9pJNJ9yB+pu3Qo/k+QrkCVP8AoMfcpjtkHZaxmQycsBlLYizHnVIddW2LFChw422m5BeaTpUqXb4lh/dR7xeECr0dWZoWw87LhDHj8t8JAGh3NZNYwvivs0JANo1gtFw41gpPAP0abYGK7oFA+U3C7H5JtsotDj+y4tyIPipXbrfoEn25D0mElsGjpyyJ+CUvy0Y5NW8UoZq1lI4BOafP0W8lF5dYZcwVOrbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8936002)(5660300002)(30864003)(1076003)(66946007)(2906002)(36756003)(6512007)(26005)(8676002)(186003)(4326008)(66476007)(66556008)(86362001)(6486002)(6916009)(6506007)(83380400001)(2616005)(107886003)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0+lT25miKByNpGP9hKQ81/n28bCWmRVZ4FumH4TxNkhj+gSTAHOUlamLTXYH?=
 =?us-ascii?Q?lQBXllmCNZ05RucowhdraGc9pSEZch3i+hnYuZdgw8lffIfCT8JtiHc0g++B?=
 =?us-ascii?Q?POmHMjWYtOZa2gMBd/YBOqikK4+vq4Y2ckcRatiQ96O9FWMJckZQy3KkA18D?=
 =?us-ascii?Q?VERR5evX2DIfxY9gClfWD5IgkqSU6W7Dw968D3Hpo5SIOOdhYAPJYqoxVDPQ?=
 =?us-ascii?Q?4wTB/8aQ6T74QhjbQCdYd35DcLd91fb3PxtM1pT2xN8K6IBaFTWjsx3aToZX?=
 =?us-ascii?Q?OH1LTnLkWmDf1TzH5m0oJEmWM/l1NYXYunFqSuIT4Z01i1t44kyFV4L8xgEv?=
 =?us-ascii?Q?PKwNrNheaMTPpf9Kw5kw8UkklZQt2byWBZ3eF+C+Kgcu1KmLnfBbqLxQPkn9?=
 =?us-ascii?Q?wRRPaEdlyfU52xnQsDawu9iwBSINVX7QJnK/KKaD0oSTPYaJEQshQJXlvzvV?=
 =?us-ascii?Q?FpWkk6cnzK6/UAGEdU7hm19CVDPMcbskW0O5QolYTDXyV131kOTBCjEGsn7s?=
 =?us-ascii?Q?aH1yRlwHxym1apupzzLKninJmvhkf8Wo3he89rdi5CzIq+GlRr5xy7YrH7DT?=
 =?us-ascii?Q?Sp/Wr2wQ5K8xUgdh4WtkL+WqoYpSFLAv4J3IKcEedBwXiKzt0Bglu3V6oXPg?=
 =?us-ascii?Q?353ws9eTrLFh5agSda2eybH7faWNBCHN5tWzWV/ooK9HJhiDyowroOOkVd+L?=
 =?us-ascii?Q?tw9JajK4rTAcWLwGAv4oeaXV0UC+uQtqow+T6rR6GMUX8KoLUK9xIBMbktAH?=
 =?us-ascii?Q?4VKc8ehYopuqBbt5opQd0JT7UDWD70QvSuGbDnRq6oUkkWaOZ0+CqE7adjCw?=
 =?us-ascii?Q?ASY2/TYzjZndK6zgJq1WitkZljzSwbtBuYxcEYxyhfw1NrBjOGvSu8AVsIIg?=
 =?us-ascii?Q?GCzpzLUow8oeM6J3k2/46ST1qtxVdxMUB56dOKAPzs7EQztgLh1CadP3jSoB?=
 =?us-ascii?Q?dD87IPxZtWW9D/4P+61oYn6Ux3h9doiurtqoyTssM0nTMnosuee66pegp4eY?=
 =?us-ascii?Q?gW2/OL29AXF8oRSuVy+V5Ckq6yr7loIlYd4iRBbLxdjlLtq5PqcOxB9CONxN?=
 =?us-ascii?Q?YeG9RL31y3MiSfYGQIysyq+JohKG87mDVgGMibTsiR+2wjRI2VdjUbCkwLrS?=
 =?us-ascii?Q?Hr/W/veJFrh5wC4nl8zofvGrpznm+8yb0OuQN9A10+67VcxzKoG/0I/ROKWA?=
 =?us-ascii?Q?hpebakj3Yv8TrHG+/B0sxjH1tQHjRfaqVC1BQTkh+cmECXAAvsXYNSTudumH?=
 =?us-ascii?Q?HEvUignzhFNuaIEh3nN8kUCrBojER5Oak/auGCCbLLqo/MZ52T+ZQo2liKIe?=
 =?us-ascii?Q?HoPSpAykr3kx7XrcL9rg4h3cAaf3xi8m+HKPv3WfRBLFP5qjZijWFd29OpQA?=
 =?us-ascii?Q?teluZKQsYU1wJYJqOuxOBRiDmdr2RIwIwwNlkk504YHgN1705bIPIEnBHTmY?=
 =?us-ascii?Q?uE1qPHZmib5pcx+r8Gr2VEvhNHpEHyZ+7DzLbnYM2XaKULAo9s4yUd8iZ8Jw?=
 =?us-ascii?Q?WiFlgtEzNqbmc5lahmEnwVCvBP1h96xuPq9MzlQrJFWbf6tmOs9jRzlDvyix?=
 =?us-ascii?Q?qeADmSb1T2M47wFQpCA6harqIN+czGTdOOgQRK4onlDFS5RpZXtRVS6B+5fd?=
 =?us-ascii?Q?HB23evmem/Nc7hX5mZGEKoWhd+Jnb0B5bg8+XnJ27XeFrlDw8nQb3/+hUCQZ?=
 =?us-ascii?Q?njbh5cUmrqMihTHxqQ29sTSLvstzeEemgySvPXiKkylwWJ+7d9VzfEY8GrqE?=
 =?us-ascii?Q?V8cfkbFmUg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb39e88d-a2f3-4077-470e-08da1d60d8f3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:22.2421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vg4DqOaz3Q/Xk/Ij3irZaR+rcqN2IC5tMxKDsh8XrTVcULVKoZv5dzvdBeFUMI5cugKo5/yNBMTdFClvfSZ2sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4616
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

The port module core is tasked with module operations such as setting
power mode policy and reset. The per-module information is currently
stored in one large array suited for non-modular systems where only the
main board is present (i.e., slot index 0).

As a preparation for line cards support, allocate a per line card array
according to the queried number of slots in the system. For each line
card, allocate a module array according to the queried maximum number of
modules per-slot.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 242 ++++++++++++------
 1 file changed, 169 insertions(+), 73 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 95fbfb1ca421..9adaa8978d68 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -21,20 +21,36 @@ struct mlxsw_env_module_info {
 	enum mlxsw_reg_pmtm_module_type type;
 };
 
-struct mlxsw_env {
-	struct mlxsw_core *core;
+struct mlxsw_env_line_card {
 	u8 module_count;
-	struct mutex module_info_lock; /* Protects 'module_info'. */
 	struct mlxsw_env_module_info module_info[];
 };
 
+struct mlxsw_env {
+	struct mlxsw_core *core;
+	u8 max_module_count; /* Maximum number of modules per-slot. */
+	u8 num_of_slots; /* Including the main board. */
+	struct mutex line_cards_lock; /* Protects line cards. */
+	struct mlxsw_env_line_card *line_cards[];
+};
+
+static struct
+mlxsw_env_module_info *mlxsw_env_module_info_get(struct mlxsw_core *mlxsw_core,
+						 u8 slot_index, u8 module)
+{
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+
+	return &mlxsw_env->line_cards[slot_index]->module_info[module];
+}
+
 static int __mlxsw_env_validate_module_type(struct mlxsw_core *core,
 					    u8 slot_index, u8 module)
 {
-	struct mlxsw_env *mlxsw_env = mlxsw_core_env(core);
+	struct mlxsw_env_module_info *module_info;
 	int err;
 
-	switch (mlxsw_env->module_info[module].type) {
+	module_info = mlxsw_env_module_info_get(core, slot_index, module);
+	switch (module_info->type) {
 	case MLXSW_REG_PMTM_MODULE_TYPE_TWISTED_PAIR:
 		err = -EINVAL;
 		break;
@@ -51,9 +67,9 @@ static int mlxsw_env_validate_module_type(struct mlxsw_core *core,
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(core);
 	int err;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
 	err = __mlxsw_env_validate_module_type(core, slot_index, module);
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 
 	return err;
 }
@@ -472,6 +488,7 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 			   u8 module, u32 *flags)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 	u32 req = *flags;
 	int err;
 
@@ -479,7 +496,7 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 	    !(req & (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT)))
 		return 0;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
 
 	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
@@ -487,13 +504,14 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 		goto out;
 	}
 
-	if (mlxsw_env->module_info[module].num_ports_up) {
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	if (module_info->num_ports_up) {
 		netdev_err(netdev, "Cannot reset module when ports using it are administratively up\n");
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (mlxsw_env->module_info[module].num_ports_mapped > 1 &&
+	if (module_info->num_ports_mapped > 1 &&
 	    !(req & (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT))) {
 		netdev_err(netdev, "Cannot reset module without \"phy-shared\" flag when shared by multiple ports\n");
 		err = -EINVAL;
@@ -509,7 +527,7 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 	*flags &= ~(ETH_RESET_PHY | (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT));
 
 out:
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 	return err;
 }
 EXPORT_SYMBOL(mlxsw_env_reset_module);
@@ -521,11 +539,12 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 				struct netlink_ext_ack *extack)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 	char mcion_pl[MLXSW_REG_MCION_LEN];
 	u32 status_bits;
 	int err;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
 
 	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
@@ -533,7 +552,8 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 		goto out;
 	}
 
-	params->policy = mlxsw_env->module_info[module].power_mode_policy;
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	params->policy = module_info->power_mode_policy;
 
 	mlxsw_reg_mcion_pack(mcion_pl, slot_index, module);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcion), mcion_pl);
@@ -552,7 +572,7 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 		params->mode = ETHTOOL_MODULE_POWER_MODE_HIGH;
 
 out:
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 	return err;
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_power_mode);
@@ -634,6 +654,7 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 				struct netlink_ext_ack *extack)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 	bool low_power;
 	int err = 0;
 
@@ -643,7 +664,7 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 		return -EOPNOTSUPP;
 	}
 
-	mutex_lock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
 
 	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
@@ -652,11 +673,12 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 		goto out;
 	}
 
-	if (mlxsw_env->module_info[module].power_mode_policy == policy)
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	if (module_info->power_mode_policy == policy)
 		goto out;
 
 	/* If any ports are up, we are already in high power mode. */
-	if (mlxsw_env->module_info[module].num_ports_up)
+	if (module_info->num_ports_up)
 		goto out_set_policy;
 
 	low_power = policy == ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO;
@@ -666,9 +688,9 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
 		goto out;
 
 out_set_policy:
-	mlxsw_env->module_info[module].power_mode_policy = policy;
+	module_info->power_mode_policy = policy;
 out:
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 	return err;
 }
 EXPORT_SYMBOL(mlxsw_env_set_module_power_mode);
@@ -748,10 +770,11 @@ mlxsw_env_temp_event_set(struct mlxsw_core *mlxsw_core, u8 slot_index,
 static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core,
 					      u8 slot_index)
 {
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int i, err, sensor_index;
 	bool has_temp_sensor;
 
-	for (i = 0; i < mlxsw_core_env(mlxsw_core)->module_count; i++) {
+	for (i = 0; i < mlxsw_env->line_cards[slot_index]->module_count; i++) {
 		err = mlxsw_env_module_has_temp_sensor(mlxsw_core, slot_index,
 						       i, &has_temp_sensor);
 		if (err)
@@ -779,6 +802,7 @@ struct mlxsw_env_module_temp_warn_event {
 static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 {
 	struct mlxsw_env_module_temp_warn_event *event;
+	struct mlxsw_env_module_info *module_info;
 	struct mlxsw_env *mlxsw_env;
 	int i, sensor_warning;
 	bool is_overheat;
@@ -787,7 +811,7 @@ static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 			     work);
 	mlxsw_env = event->mlxsw_env;
 
-	for (i = 0; i < mlxsw_env->module_count; i++) {
+	for (i = 0; i < mlxsw_env->max_module_count; i++) {
 		/* 64-127 of sensor_index are mapped to the port modules
 		 * sequentially (module 0 is mapped to sensor_index 64,
 		 * module 1 to sensor_index 65 and so on)
@@ -795,9 +819,10 @@ static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 		sensor_warning =
 			mlxsw_reg_mtwe_sensor_warning_get(event->mtwe_pl,
 							  i + MLXSW_REG_MTMP_MODULE_INDEX_MIN);
-		mutex_lock(&mlxsw_env->module_info_lock);
-		is_overheat =
-			mlxsw_env->module_info[i].is_overheat;
+		mutex_lock(&mlxsw_env->line_cards_lock);
+		/* MTWE only supports main board. */
+		module_info = mlxsw_env_module_info_get(mlxsw_env->core, 0, i);
+		is_overheat = module_info->is_overheat;
 
 		if ((is_overheat && sensor_warning) ||
 		    (!is_overheat && !sensor_warning)) {
@@ -805,21 +830,21 @@ static void mlxsw_env_mtwe_event_work(struct work_struct *work)
 			 * warning OR current state in "no warning" and MTWE
 			 * does not report warning.
 			 */
-			mutex_unlock(&mlxsw_env->module_info_lock);
+			mutex_unlock(&mlxsw_env->line_cards_lock);
 			continue;
 		} else if (is_overheat && !sensor_warning) {
 			/* MTWE reports "no warning", turn is_overheat off.
 			 */
-			mlxsw_env->module_info[i].is_overheat = false;
-			mutex_unlock(&mlxsw_env->module_info_lock);
+			module_info->is_overheat = false;
+			mutex_unlock(&mlxsw_env->line_cards_lock);
 		} else {
 			/* Current state is "no warning" and MTWE reports
 			 * "warning", increase the counter and turn is_overheat
 			 * on.
 			 */
-			mlxsw_env->module_info[i].is_overheat = true;
-			mlxsw_env->module_info[i].module_overheat_counter++;
-			mutex_unlock(&mlxsw_env->module_info_lock);
+			module_info->is_overheat = true;
+			module_info->module_overheat_counter++;
+			mutex_unlock(&mlxsw_env->line_cards_lock);
 		}
 	}
 
@@ -871,6 +896,7 @@ struct mlxsw_env_module_plug_unplug_event {
 static void mlxsw_env_pmpe_event_work(struct work_struct *work)
 {
 	struct mlxsw_env_module_plug_unplug_event *event;
+	struct mlxsw_env_module_info *module_info;
 	struct mlxsw_env *mlxsw_env;
 	bool has_temp_sensor;
 	u16 sensor_index;
@@ -880,9 +906,12 @@ static void mlxsw_env_pmpe_event_work(struct work_struct *work)
 			     work);
 	mlxsw_env = event->mlxsw_env;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
-	mlxsw_env->module_info[event->module].is_overheat = false;
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	module_info = mlxsw_env_module_info_get(mlxsw_env->core,
+						event->slot_index,
+						event->module);
+	module_info->is_overheat = false;
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 
 	err = mlxsw_env_module_has_temp_sensor(mlxsw_env->core,
 					       event->slot_index,
@@ -909,12 +938,14 @@ static void
 mlxsw_env_pmpe_listener_func(const struct mlxsw_reg_info *reg, char *pmpe_pl,
 			     void *priv)
 {
+	u8 slot_index = mlxsw_reg_pmpe_slot_index_get(pmpe_pl);
 	struct mlxsw_env_module_plug_unplug_event *event;
 	enum mlxsw_reg_pmpe_module_status module_status;
 	u8 module = mlxsw_reg_pmpe_module_get(pmpe_pl);
 	struct mlxsw_env *mlxsw_env = priv;
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
+	if (WARN_ON_ONCE(module >= mlxsw_env->max_module_count ||
+			 slot_index >= mlxsw_env->num_of_slots))
 		return;
 
 	module_status = mlxsw_reg_pmpe_module_status_get(pmpe_pl);
@@ -926,7 +957,7 @@ mlxsw_env_pmpe_listener_func(const struct mlxsw_reg_info *reg, char *pmpe_pl,
 		return;
 
 	event->mlxsw_env = mlxsw_env;
-	event->slot_index = 0;
+	event->slot_index = slot_index;
 	event->module = module;
 	INIT_WORK(&event->work, mlxsw_env_pmpe_event_work);
 	mlxsw_core_schedule_work(&event->work);
@@ -957,9 +988,10 @@ static int
 mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core,
 					 u8 slot_index)
 {
+	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int i, err;
 
-	for (i = 0; i < mlxsw_core_env(mlxsw_core)->module_count; i++) {
+	for (i = 0; i < mlxsw_env->line_cards[slot_index]->module_count; i++) {
 		char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
 		mlxsw_reg_pmaos_pack(pmaos_pl, slot_index, i);
@@ -978,10 +1010,12 @@ mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 slot_ind
 				      u8 module, u64 *p_counter)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
-	*p_counter = mlxsw_env->module_info[module].module_overheat_counter;
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	*p_counter = module_info->module_overheat_counter;
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 
 	return 0;
 }
@@ -991,10 +1025,12 @@ void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 slot_index,
 			       u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
-	mlxsw_env->module_info[module].num_ports_mapped++;
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	module_info->num_ports_mapped++;
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_map);
 
@@ -1002,10 +1038,12 @@ void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 slot_index,
 				 u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
-	mlxsw_env->module_info[module].num_ports_mapped--;
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	module_info->num_ports_mapped--;
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_unmap);
 
@@ -1013,15 +1051,17 @@ int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 slot_index,
 			     u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 	int err = 0;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
 
-	if (mlxsw_env->module_info[module].power_mode_policy !=
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	if (module_info->power_mode_policy !=
 	    ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO)
 		goto out_inc;
 
-	if (mlxsw_env->module_info[module].num_ports_up != 0)
+	if (module_info->num_ports_up != 0)
 		goto out_inc;
 
 	/* Transition to high power mode following first port using the module
@@ -1033,9 +1073,9 @@ int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 slot_index,
 		goto out_unlock;
 
 out_inc:
-	mlxsw_env->module_info[module].num_ports_up++;
+	module_info->num_ports_up++;
 out_unlock:
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 	return err;
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_up);
@@ -1044,16 +1084,18 @@ void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 slot_index,
 				u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
+	struct mlxsw_env_module_info *module_info;
 
-	mutex_lock(&mlxsw_env->module_info_lock);
+	mutex_lock(&mlxsw_env->line_cards_lock);
 
-	mlxsw_env->module_info[module].num_ports_up--;
+	module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index, module);
+	module_info->num_ports_up--;
 
-	if (mlxsw_env->module_info[module].power_mode_policy !=
+	if (module_info->power_mode_policy !=
 	    ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO)
 		goto out_unlock;
 
-	if (mlxsw_env->module_info[module].num_ports_up != 0)
+	if (module_info->num_ports_up != 0)
 		goto out_unlock;
 
 	/* Transition to low power mode following last port using the module
@@ -1063,17 +1105,57 @@ void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 slot_index,
 					  NULL);
 
 out_unlock:
-	mutex_unlock(&mlxsw_env->module_info_lock);
+	mutex_unlock(&mlxsw_env->line_cards_lock);
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_down);
 
+static int mlxsw_env_line_cards_alloc(struct mlxsw_env *env)
+{
+	struct mlxsw_env_module_info *module_info;
+	int i, j;
+
+	for (i = 0; i < env->num_of_slots; i++) {
+		env->line_cards[i] = kzalloc(struct_size(env->line_cards[i],
+							 module_info,
+							 env->max_module_count),
+							 GFP_KERNEL);
+		if (!env->line_cards[i])
+			goto kzalloc_err;
+
+		/* Firmware defaults to high power mode policy where modules
+		 * are transitioned to high power mode following plug-in.
+		 */
+		for (j = 0; j < env->max_module_count; j++) {
+			module_info = &env->line_cards[i]->module_info[j];
+			module_info->power_mode_policy =
+					ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH;
+		}
+	}
+
+	return 0;
+
+kzalloc_err:
+	for (i--; i >= 0; i--)
+		kfree(env->line_cards[i]);
+	return -ENOMEM;
+}
+
+static void mlxsw_env_line_cards_free(struct mlxsw_env *env)
+{
+	int i = env->num_of_slots;
+
+	for (i--; i >= 0; i--)
+		kfree(env->line_cards[i]);
+}
+
 static int
 mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core, u8 slot_index)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int i;
 
-	for (i = 0; i < mlxsw_env->module_count; i++) {
+	for (i = 0; i < mlxsw_env->line_cards[slot_index]->module_count; i++) {
+		struct mlxsw_env_module_info *module_info;
 		char pmtm_pl[MLXSW_REG_PMTM_LEN];
 		int err;
 
@@ -1082,8 +1164,9 @@ mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core, u8 slot_index)
 		if (err)
 			return err;
 
-		mlxsw_env->module_info[i].type =
-			mlxsw_reg_pmtm_module_type_get(pmtm_pl);
+		module_info = mlxsw_env_module_info_get(mlxsw_core, slot_index,
+							i);
+		module_info->type = mlxsw_reg_pmtm_module_type_get(pmtm_pl);
 	}
 
 	return 0;
@@ -1091,32 +1174,38 @@ mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core, u8 slot_index)
 
 int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 {
+	u8 module_count, num_of_slots, max_module_count;
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	struct mlxsw_env *env;
-	u8 module_count;
-	int i, err;
+	int err;
 
 	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
 
-	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, &module_count, NULL);
+	mlxsw_reg_mgpir_unpack(mgpir_pl, NULL, NULL, NULL, &module_count,
+			       &num_of_slots);
+	/* If the system is modular, get the maximum number of modules per-slot.
+	 * Otherwise, get the maximum number of modules on the main board.
+	 */
+	max_module_count = num_of_slots ?
+			   mlxsw_reg_mgpir_max_modules_per_slot_get(mgpir_pl) :
+			   module_count;
 
-	env = kzalloc(struct_size(env, module_info, module_count), GFP_KERNEL);
+	env = kzalloc(struct_size(env, line_cards, num_of_slots + 1),
+		      GFP_KERNEL);
 	if (!env)
 		return -ENOMEM;
 
-	/* Firmware defaults to high power mode policy where modules are
-	 * transitioned to high power mode following plug-in.
-	 */
-	for (i = 0; i < module_count; i++)
-		env->module_info[i].power_mode_policy =
-			ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH;
-
-	mutex_init(&env->module_info_lock);
 	env->core = mlxsw_core;
-	env->module_count = module_count;
+	env->num_of_slots = num_of_slots + 1;
+	env->max_module_count = max_module_count;
+	err = mlxsw_env_line_cards_alloc(env);
+	if (err)
+		goto err_mlxsw_env_line_cards_alloc;
+
+	mutex_init(&env->line_cards_lock);
 	*p_env = env;
 
 	err = mlxsw_env_temp_warn_event_register(mlxsw_core);
@@ -1127,6 +1216,10 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (err)
 		goto err_module_plug_event_register;
 
+	/* Set 'module_count' only for main board. Actual count for line card
+	 * is to be set after line card is activated.
+	 */
+	env->line_cards[0]->module_count = num_of_slots ? 0 : module_count;
 	err = mlxsw_env_module_oper_state_event_enable(mlxsw_core, 0);
 	if (err)
 		goto err_oper_state_event_enable;
@@ -1148,7 +1241,9 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 err_module_plug_event_register:
 	mlxsw_env_temp_warn_event_unregister(env);
 err_temp_warn_event_register:
-	mutex_destroy(&env->module_info_lock);
+	mutex_destroy(&env->line_cards_lock);
+	mlxsw_env_line_cards_free(env);
+err_mlxsw_env_line_cards_alloc:
 	kfree(env);
 	return err;
 }
@@ -1159,6 +1254,7 @@ void mlxsw_env_fini(struct mlxsw_env *env)
 	/* Make sure there is no more event work scheduled. */
 	mlxsw_core_flush_owq();
 	mlxsw_env_temp_warn_event_unregister(env);
-	mutex_destroy(&env->module_info_lock);
+	mutex_destroy(&env->line_cards_lock);
+	mlxsw_env_line_cards_free(env);
 	kfree(env);
 }
-- 
2.33.1

