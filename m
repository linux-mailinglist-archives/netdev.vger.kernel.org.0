Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD064BFFFF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbiBVRSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiBVRSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:53 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2058.outbound.protection.outlook.com [40.107.220.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B4F16C4F2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLSKjPQ1d6uUr2cxmOOd9s6/eWx5z6F90JXhvc5KmLLtBsN588nkqdXr8pHd3/6E0hc3FeuqM1iBiHy0Tfv8OnRlBv1uCttsbOiRjGSl/QQGVRc/OdjrD2GwZ9pIkJE7tI7KBa7nCzodSlr6D+M2WQ0pecBohumuT/tGPVcVXkdkhS7YfT5KqX1QlJumSWfh6RNmc05C5hRI3BoBpnPMrfDnhFvu9KiZd9iTB1xvh0abfDvjCtIeX365rxlD/ucdhJiDRnm2tCum3/IMBIwaJrVPK6jNnTTtZ9aZCapaetPtwlREdPU84Eg5PE1vms1/VSe0rhQgNJ87yJIn6g2ZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfzvhn1dbGCkwpzAv0J9NAjpntEZKF3lRdRqJrEpyCY=;
 b=GmMqHb8I4PfgQ/UeuhQxl5bdFitaJDdDiIHDU8b51dMaHkhNVYpgc3Gn2c9qVao1bwzOTZnmEIogSVzQp35v2wAr2UiZJR3ckL7HvAePkZzvSgkTru5/z+8UtIkaksJUeiODRSKcYgRUjkrzKU6Yplg+nj5AH/E51tYE9oPEntKUSfTTPnwkDk8P5z/auOLmSyFLlr6d3UJxSs4psBbfpyDWMBgAuYXkF54kv/tEPFrng2hUWmSWqQOpWYes5pz/dgSy7cabGL62KhdAl0WEgcGdgljOX8yXr5lo8ui/MHzBz/xTK7ftTCLNwPRlxLEKgvNZcSexeKKWFhw2hCo5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lfzvhn1dbGCkwpzAv0J9NAjpntEZKF3lRdRqJrEpyCY=;
 b=TzGFGMdAUGU7ZaTL+cxBiK2CK2c5moVIVk/l69U3h3iOFsKHb68kCtNMDvqWvF4aUJsrZpU66KfvLUidXGXAuScQf5w7aYgZK37gYH/TalvdODVpGtV/7mD9D2HilSL7hGbAL1b+Gw0TbSR48wpSBvd2Qth68+jiaZ7aw8csaF8xzWVoodYYX2dNuvhlCv6YJtjPAIihlX/Hgw6HOzMx7Xhan7LJrB4hsQ9ZDvT9Byx+fWB2hjkl4Zi3PsTR8Xm6dH0o+XLkcDPytLVz0T/3qD/z2KmV2E+W/UtoYOn22nZv+3mb5PkjXkx5Nz1nUijpIBOMzK1bstWxxdHx2q+fOg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:25 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/12] mlxsw: core: Remove unnecessary asserts
Date:   Tue, 22 Feb 2022 19:16:59 +0200
Message-Id: <20220222171703.499645-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:803:64::29) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f812da20-48fc-4d2c-65be-08d9f627558f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4262BC468C03C3DAA4B8CD91B23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUmM2b6GxWSrRXQDXK489krG+nd1ATI2stcnZfwZiAXzGupkn71YAhjnGUxT/CC4RysMBFfkfmPQo6rkW9M5Y18E9sZvfFDum86srKzEjk0D84AaV2O0M7gcfRV1luWtfOzWkA1hE1ZSjr1XEZyJRT+HMMfhsNRCuw7QSPKxXvRjLyaAduB7VhN9RZSs6DGpJ+ACi5AVVS4jQfZ9e7kUfnxhtuE1AoCS/e5h5iDmfA9mT/mJO199z4poRtrEvR5WEWj/QNgteqkCeycBljBZT4mNMEwAxJFYP7Zy+IzYwjcfVLUk4C2Zm4HfIIBlTkl6jiM/dMhZQFitBMribOBX/FTGR46OE/yn8YgjqY1sggFJRlL3P4Ib+9vgmDQVV5A/p9ZsjEy2tmo2bNqdu4kdHL0bVlsyfwudHaTkd395v2iekch0mtVAV+GOxx1pNQfMmOqNJuv/kzm83xGxRM0ef3d+t3LvqjMIr9qmBAFLrmZlt1KbIMFVEZKWpn3V2hDRRY1Z38Jv9gzVMBxHxtnKPQblHqztToZwYdryMAinHtIl/kS8vibSc1LngATVsHGjI8PZvIoEn1Se1aUcJMKJm7S/R8t/EZ6vMFtITX3Wmc+0Tv+SOh4yv3w9Zebde1DmUli9TkEAwrqQiYcoTwZIyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KVnI1g1iswnrlCTKvcMGkCcIG953q8WvEGuNi/vxI9ch8RUOu7vgG7nUf7WY?=
 =?us-ascii?Q?T5/vRNoH7JgTcGMbxwr+SU0SLKlIgN0I+4hPUclOCeXh9TO6hDD0TO2SKcdP?=
 =?us-ascii?Q?X9ioTPCUc7nDayeggzp8qBDkK64hwYQPsYLDvvjCdsg9buCYyFRoBhGR13yA?=
 =?us-ascii?Q?HPfwytkj/9RFyud56LcvnDaWh57k3HrND2PhBnW+QlymREkd4EIyydR0jV0t?=
 =?us-ascii?Q?Flg1m7Stm+wuV5uk4TEKG+UZv2/lNko76ehAOdzVDMAFihMGGdE9QR4IQURo?=
 =?us-ascii?Q?DqNS848J9ZflSi4JOZmW9BsOvqQAwyjuXyCsldEyZKdpuBmgDf5RG2CLXigz?=
 =?us-ascii?Q?S/r3clIwgBKTrxtf5KCFdLSZbZsMl0Q86nQkPXmSGHyeArD7qj074ToLf+yD?=
 =?us-ascii?Q?hWSznVzh3tPHj3NwIUg2rLjL0RqbQqOU8ZXfwuHJ6gA30oUx51b0yJT5momX?=
 =?us-ascii?Q?AMl+RTGVlBjdiqbW0g9RpAJz2lNzrx9aGrUubz310t4a9O2VqzTk2syyJx1s?=
 =?us-ascii?Q?syTP+Xa8ZtfrwwKIKyG9wo5zz2k67d2IA/YqxOAcVzIQSlLIr/aeZ6BaOfMW?=
 =?us-ascii?Q?Ie0UCZTocFWmInqtk39liEtiSgkw8i/+cm7YEDbI9qGb+js0OnawFTIBq9lb?=
 =?us-ascii?Q?tQywSsn0b/8c2+p4qHRF/dSXkpGkDX9UF4sD1iN9ZCdBKf+enWzrJdJSsRHo?=
 =?us-ascii?Q?VDgKG2IJtK0AT8Eut350fbJRIad7LSvVoN1PmgRFlr6CKG+dB0/4uClm7ex/?=
 =?us-ascii?Q?SzPrXLNEbaNvQGyx+S3Z602DyYMMSjaLvu/jg9rUM5j1/yVLZxWMwoZU5Ipd?=
 =?us-ascii?Q?Y+qmgJzlNN8VON7hl9ZJMLchen2qh5xGYf4Bd4EjYTlds7wWdm/pxsFZePr0?=
 =?us-ascii?Q?0UNPenDR9qst1koHN/YII1UWXIGxrKZoaRS3VDywfq/WDkWa07ILZM6pD8Yz?=
 =?us-ascii?Q?TUr0R8GMqYStNPFpUaJK6a9RNl9ULUI5M8X9q2hZb5xM7Dx/K+Q/+f1Mllhf?=
 =?us-ascii?Q?qqmQXqxPmcOy0v1pZxOp+z97cC3E7r/jVH5GfX6w8Xn8H6x2+rox8A+FpUNw?=
 =?us-ascii?Q?3vKxwNk+SZt+2g0bO2sPCs1YAmAWFSk1+3p3PtBEb9NaEj2tGMRWki9yW0Vd?=
 =?us-ascii?Q?DfMPb5b6CipnNwLXhdJJqNhEOPUeVURnsvzEHfn5X+01Gwa6vsM7Jfi2Pk6w?=
 =?us-ascii?Q?jJKT7dSy0qSZV1LiTWMNR2QrMIqB0UE9OnqjOPF9RPpLS+LmrCIE9Td65b8f?=
 =?us-ascii?Q?F5tSsqP418JB79mxPo90nx75bTP37ha/PifxU28yc+zE70aPIsS4akQ2ZQEH?=
 =?us-ascii?Q?FGH1+9edauLPPN1zBj9qRycwt31HIV4kTjKyAgWKoOM/bACe7DMitRc8JS72?=
 =?us-ascii?Q?+sxjZQDr/bGPYLuQNz9OOy05ZjY4rN/yyXjps7mLJfB3nkoyv7iDumVCpNFL?=
 =?us-ascii?Q?1zsBY71XBeczomQ+7e88+1Dv3Fa/56lZZ3qqkmwdSMY8X8UP1npV00AamgbS?=
 =?us-ascii?Q?+sHPwUp6scUe7ABwIHyKYBhQ0RQONBSOD5a55AssdyeSdlJRPm2mif2O8TBY?=
 =?us-ascii?Q?eVmoAkpvwEAlwtcmaLOvv9+0TftbQToDy991vO/mYhgQzcaIcVfflJm8M8zG?=
 =?us-ascii?Q?adBkjHC5cHsg0UDjYPesJqQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f812da20-48fc-4d2c-65be-08d9f627558f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:25.1766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSX69iE/y2C/iXW64multhTjMJNZ+AKv8BmgRcYTw0ybms2CWyc6EjYV3IO3bPqsFKuiKLauraos17ragZFbDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
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

Remove unnecessary asserts for module index validation. Leave only one
that is actually necessary in mlxsw_env_pmpe_listener_func() where the
module index is directly read from the firmware event.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 24 -------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 6ea4bf87be0b..5809ebf35535 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -462,9 +462,6 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 	    !(req & (ETH_RESET_PHY << ETH_RESET_SHARED_SHIFT)))
 		return 0;
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return -EINVAL;
-
 	mutex_lock(&mlxsw_env->module_info_lock);
 
 	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
@@ -510,9 +507,6 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 	u32 status_bits;
 	int err;
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return -EINVAL;
-
 	mutex_lock(&mlxsw_env->module_info_lock);
 
 	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
@@ -620,9 +614,6 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 	bool low_power;
 	int err = 0;
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return -EINVAL;
-
 	if (policy != ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH &&
 	    policy != ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported power mode policy");
@@ -966,9 +957,6 @@ mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return -EINVAL;
-
 	mutex_lock(&mlxsw_env->module_info_lock);
 	*p_counter = mlxsw_env->module_info[module].module_overheat_counter;
 	mutex_unlock(&mlxsw_env->module_info_lock);
@@ -981,9 +969,6 @@ void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return;
-
 	mutex_lock(&mlxsw_env->module_info_lock);
 	mlxsw_env->module_info[module].num_ports_mapped++;
 	mutex_unlock(&mlxsw_env->module_info_lock);
@@ -994,9 +979,6 @@ void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return;
-
 	mutex_lock(&mlxsw_env->module_info_lock);
 	mlxsw_env->module_info[module].num_ports_mapped--;
 	mutex_unlock(&mlxsw_env->module_info_lock);
@@ -1008,9 +990,6 @@ int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module)
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int err = 0;
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return -EINVAL;
-
 	mutex_lock(&mlxsw_env->module_info_lock);
 
 	if (mlxsw_env->module_info[module].power_mode_policy !=
@@ -1040,9 +1019,6 @@ void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
-	if (WARN_ON_ONCE(module >= mlxsw_env->module_count))
-		return;
-
 	mutex_lock(&mlxsw_env->module_info_lock);
 
 	mlxsw_env->module_info[module].num_ports_up--;
-- 
2.33.1

