Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6217B4FF9D8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiDMPUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiDMPUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:20:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0420C252AE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aCgG+ZeH+80vIcx4y09meI4UHxxWmCDajlGBIUDE4pytmV0BuKlbDVx8wVhiA+Ysw2/P2wq5xRCl4KVGStm0hwX75xJRXPwPz2Er3TUJbL11naicpbEU3cvH3VR+0+LwMQJxJ/ydbaOubl4IrWSU9j77xgdN0u5DKKdt20wxAUklAB4NFlDuoMSUsSN3S9Ao49rkhnO3IqIuVZHkm0S5jYRHtyn6/EkbOKX0R+RhnIoQUj/bePrbQ9QgSh9EGLGpbPib8n972HpY8J6m8NIO0tRKlELujpsObad0FE4XPj3elzJGXU3HkKarhM2ZiaQd81v53n+MaTS/Gv2Ot+KYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39C+ETEiIdY2n7bjKdwz8FqoQDrH2o35ENkJwZg0yaQ=;
 b=Ml74jZwloJmIbfkGGwhGHdlhvvm5EVFcAqOSJLqMlYaFugAUhnbqUcopOOneP6V/m446ojiVWvVb3Y88koZ/L6ykjRj0yojOPFWBtrUrlHYtMUxzutbdgB6YNptOeU/d9eha38MbwJxack0OVXBvbhhsV8nuSp5qZWYcYDQCyQ+BPqbrgMKUcECKlWNXTauZ/OOV4rarka4TK8f1XMB1fK84DLM+AXuW63Iu/P0Uh9nYjVQBw3tJ4/eFGiLa3ewuk2xSJm8UHJ9lqyjtpMOoRwVjbR0soteXk7A73NrI9a65MPLCWqllN85R+DECt/qdwxwu8MmQ+MyGJeDQKugXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39C+ETEiIdY2n7bjKdwz8FqoQDrH2o35ENkJwZg0yaQ=;
 b=FwZzj+2VB0cJ1YEAkYKKb/3Qs3CE0X/pUFNJCH3+VmCcCaJw9ohq7QE9OJ2usZf/KJKvbj2zwmq1I9dWdHMN91sMSY203J6YZEhX+IEaye/nFJ1Wj4OKWXVLRovw1U5t8wxjj/aPKPRBRx96iTaVl6UGq1z4uHYOjWoPpH70iN5KZzONRd9Q0VuoUvkX+Vi1C0CGGUlF5ibOr44Vie/YYW9alcrgMS1KeIIeIJgwcB8D5Y6WikCUwdH2y78uYPCnCoMhDQ1uqHp9xIMYgy12Yo6sgbOHKbRji3gOqgnWhKzoHK9aGJTWlshme+bAppxKXnJ9a65Li0toGRjO65ICIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 15:18:15 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/9] mlxsw: core: Extend interfaces for cable info access with slot argument
Date:   Wed, 13 Apr 2022 18:17:25 +0300
Message-Id: <20220413151733.2738867-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0163.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::20) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cdfd604-2d78-4433-560f-08da1d60d502
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB52383134374F8B101996EC2DB2EC9@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Rs34qFPS213Awl287RRM3NWJpHngTyZMGmNo6n+PBLWBy0hg5dzT1OY1rffXyiyEVObfT4svR6KM26U8CcGA2/gmYeDrA3cczFCW5gIWRP2mWlMEnChzctOzOABQ34Z9t7CmyLtRPbLDTHJ/YL2i1noZfLcPb6Ckj00tnEIxZTCGPEa9oFPMEAMkPbsjDvWHDrg5RdpX7h9iVErDb3yIvhGQOI7DOY6QM9Kvf1Ex/xVotY+qHWNvindgy+nuwb5uPK3T3OYHdgymqqiVySGMOPzkjIDB246+NMcwp66EbX/JTU7a5Eu7/axEe06iqXLUmpb8VaOW3BNv9xYrXgpK/1R9K58+Vga745rLMM0orX1/e6p9DJl7F6UQEXCsaa0/f8R+gkkjamN/WXf3fbwobPYg1bNZlGDZsfdkIgKQ2vg2o6H6otyz+aSQZKTAOcnLLhR0KxA1oeU8BDvHBpxsOT8yvtqUtfhkS+pO0GhqSLGvBsqQ1YufDO+p1sgaCV+UqHdw3/H+uz16zU3etECHckBCJpLmH73qCgsADZOvPuN4MIIeCvhc/ktxMWW3XaIjNLFhBlPr+5oejqywdr8diYBINRhCoece9Vb4tGKCN+NWWtm2ZjjafcaA/DkHbPJGpolQpKWzX6VRZ/19AunDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(4326008)(1076003)(316002)(107886003)(38100700002)(6512007)(36756003)(5660300002)(30864003)(83380400001)(186003)(26005)(2906002)(6666004)(8676002)(86362001)(6506007)(2616005)(6486002)(66476007)(6916009)(66556008)(8936002)(66946007)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cANyhNDf1rGfPGh0FkxePB/kK77PFrrVdcq9Y+DoJZofQOk4Fyv49y5Kio/b?=
 =?us-ascii?Q?amchivGxM8k1VrY32VghRQKQSi9+axpAPm8pF52R5X37G97Bks58Ptb+EALy?=
 =?us-ascii?Q?8E2q3csJNEnzrzTwtMLSO7ckMwWFH3BumkD98fwP5l6Cm9YR0qJGxAPnx/0E?=
 =?us-ascii?Q?d8gMmCSiVWIiD4Okb3uKpYXHSpaMTxbKN+YGiP2tfgAXRD0b6ARtNGovvOZf?=
 =?us-ascii?Q?M/XwuvCz6RP8NWagZrynOlAmWL1Ki6Jkt7/2rwUIdSRHAJLT876w4WeV3xsR?=
 =?us-ascii?Q?G9GA7WJszdQmc0YE87iHRCIXSRBXv5vJm+KHJgXx+UxdB1jLuWR8XPs8YT/Q?=
 =?us-ascii?Q?iZFqRBcJgCPjGeRYnVrb3gDSyagPowc5eXWVc0Y+J9Tzmp8cN9Ge1j6FFVkE?=
 =?us-ascii?Q?xtOk0XXPcKBozORnh7W1pGEvHLTVmiLsUxH8u7VCngwE0dY3juKqaM1+3mIQ?=
 =?us-ascii?Q?daBXkut9XHblc2TeDd6aalPl6ND3dxntNBhWbUhKgagqY+xZDkM6WwIpF9BP?=
 =?us-ascii?Q?ODquu7iP/HjRhru9DGxh79ctRR0QBnhh0oOi5/v6uCDP6yVBJ9XpVnsEjf5X?=
 =?us-ascii?Q?50p3kUvRMvct9+BbjKsjsd/+lxwJjFVRtIw1pRqo0GaUBd2NoCfaydMo8upE?=
 =?us-ascii?Q?Dyc/yXOhUwJ2kZTEEa6Qj7cxpEeLmYvAZlQrd2oZouegU9uzVprcLTiknhEY?=
 =?us-ascii?Q?RxupP9gqx9JShYchXl74CepEGV5nC9ATtJAPaLfku2qBmFNYZgYUn3w3QIcu?=
 =?us-ascii?Q?8VffVNBvm5R27lgfqpLxUzwGO46EbUoGvnybNDSNBTbUDOCAtHRp2aZIp7bt?=
 =?us-ascii?Q?ZgvhCXQ8TIHSUsS7038Hl95TeNe2wftfShoR6t76mNCkImjH+NgaQQpN3Dvw?=
 =?us-ascii?Q?NKrRwhOuGFvjV/DmBKCb+BXDCk4+2Lf7RLRI14unkTxMlltBQRvfoUZC2xri?=
 =?us-ascii?Q?cPowuHbtdAC0CZJBtzN2mowvFY6Qpn+J4PWQV6+Wuu8UjiEzSpOG0g9k0+nC?=
 =?us-ascii?Q?3LBRlEEVM6sgYh6UxuiLDD/C4nvKSy9ARRsq8rdQMShqnhoa4ZBQnA5EM1z7?=
 =?us-ascii?Q?45KdPqg3QTIHvlP2eSVcZgMu5Du7vCF0U/1RxL3PEmCr7tCnokoYqPZg3E8i?=
 =?us-ascii?Q?WZvIyzGB49lr0SblOq1BP9Q7V0Pf5yrB8+s62eB1GQ5xD8rsMbPvpqMGLOyZ?=
 =?us-ascii?Q?Ml57r0+Q/04Sx+jdXgjlJyPxG3PTwKkRmed85FzXD88WVHevLBuefyBEVQY8?=
 =?us-ascii?Q?4HCzgYtBjuW7g7L2rhyic1q7V02J1NfXLdktYwaAOT3dG31j3S//UOlpEX9X?=
 =?us-ascii?Q?E2CrU32hq6ZTbEZ15AS0v8/HvpkbMgGX05HJQ2wp/Fsu+QuFypgVV2GOonpS?=
 =?us-ascii?Q?6fehOvsbShCooXGotuuWW0X/ocl8g/qnpkEp2iieyxJXKKQJTIyMvSTGzQqZ?=
 =?us-ascii?Q?NaQRTMJfx9FzGYQGy0Zuhv/1E4PNxQ9zvKWfeHIQq/voouDqzqeSS+jr7KW3?=
 =?us-ascii?Q?QExlweLa0iKdy+g+Vd+0YAH4+ETYNnUsyTPN1Kknjv0xWpWUFFO+FpgMPAZG?=
 =?us-ascii?Q?BGn66Zw9W56LCPr8bKKdBeTW9G3h9MtkgJJYcg66qMMryqbv7GpHiaSK17rq?=
 =?us-ascii?Q?+NVZPa9/hJKSvANkiewfIhPL3oxAYHfP9qX70Jdug5DS6zDXQ09M7domNbem?=
 =?us-ascii?Q?ON6crpQieQsP1uO2f2+Oz99zQREufTwY0D4YswTT9WV1UpcZoAd+H5Q3wAso?=
 =?us-ascii?Q?Zjg/p9d/RA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cdfd604-2d78-4433-560f-08da1d60d502
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:15.7393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzF+UyoUik8lL7sROZJcvyt5G94L20HGUH+Dq35owbnqCwLfBV1RZ7FI6V1Ffy7pV+Go/jPUv+NjYyBkMd/RDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
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

Extend all cable info APIs with 'slot_index' argument.

For main board, slot will always be set to zero and these APIs will work
as before. If reading cable information is required from cages located
on line cards, slot should be set to the physical slot number, where
line card is located in modular systems.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 198 +++++++++++-------
 .../net/ethernet/mellanox/mlxsw/core_env.h    |  43 ++--
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  10 +-
 .../ethernet/mellanox/mlxsw/core_thermal.c    |   4 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c |  24 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  21 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         |  18 +-
 7 files changed, 184 insertions(+), 134 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index f1bb243dfb8c..95fbfb1ca421 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -28,7 +28,8 @@ struct mlxsw_env {
 	struct mlxsw_env_module_info module_info[];
 };
 
-static int __mlxsw_env_validate_module_type(struct mlxsw_core *core, u8 module)
+static int __mlxsw_env_validate_module_type(struct mlxsw_core *core,
+					    u8 slot_index, u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(core);
 	int err;
@@ -44,33 +45,35 @@ static int __mlxsw_env_validate_module_type(struct mlxsw_core *core, u8 module)
 	return err;
 }
 
-static int mlxsw_env_validate_module_type(struct mlxsw_core *core, u8 module)
+static int mlxsw_env_validate_module_type(struct mlxsw_core *core,
+					  u8 slot_index, u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(core);
 	int err;
 
 	mutex_lock(&mlxsw_env->module_info_lock);
-	err = __mlxsw_env_validate_module_type(core, module);
+	err = __mlxsw_env_validate_module_type(core, slot_index, module);
 	mutex_unlock(&mlxsw_env->module_info_lock);
 
 	return err;
 }
 
 static int
-mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id, bool *qsfp,
-			       bool *cmis)
+mlxsw_env_validate_cable_ident(struct mlxsw_core *core, u8 slot_index, int id,
+			       bool *qsfp, bool *cmis)
 {
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
 	char *eeprom_tmp;
 	u8 ident;
 	int err;
 
-	err = mlxsw_env_validate_module_type(core, id);
+	err = mlxsw_env_validate_module_type(core, slot_index, id);
 	if (err)
 		return err;
 
-	mlxsw_reg_mcia_pack(mcia_pl, 0, id, 0, MLXSW_REG_MCIA_PAGE0_LO_OFF, 0,
-			    1, MLXSW_REG_MCIA_I2C_ADDR_LOW);
+	mlxsw_reg_mcia_pack(mcia_pl, slot_index, id, 0,
+			    MLXSW_REG_MCIA_PAGE0_LO_OFF, 0, 1,
+			    MLXSW_REG_MCIA_I2C_ADDR_LOW);
 	err = mlxsw_reg_query(core, MLXSW_REG(mcia), mcia_pl);
 	if (err)
 		return err;
@@ -99,8 +102,8 @@ mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id, bool *qsfp,
 }
 
 static int
-mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
-			      u16 offset, u16 size, void *data,
+mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			      int module, u16 offset, u16 size, void *data,
 			      bool qsfp, unsigned int *p_read_size)
 {
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
@@ -145,7 +148,7 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 		}
 	}
 
-	mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0, page, offset, size,
+	mlxsw_reg_mcia_pack(mcia_pl, slot_index, module, 0, page, offset, size,
 			    i2c_addr);
 
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcia), mcia_pl);
@@ -163,8 +166,9 @@ mlxsw_env_query_module_eeprom(struct mlxsw_core *mlxsw_core, int module,
 	return 0;
 }
 
-int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
-					 int off, int *temp)
+int
+mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, u8 slot_index,
+				     int module, int off, int *temp)
 {
 	unsigned int module_temp, module_crit, module_emerg;
 	union {
@@ -178,8 +182,9 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	int page;
 	int err;
 
-	mlxsw_reg_mtmp_pack(mtmp_pl, 0, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
-			    false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, slot_index,
+			    MLXSW_REG_MTMP_MODULE_INDEX_MIN + module, false,
+			    false);
 	err = mlxsw_reg_query(core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
 		return err;
@@ -208,7 +213,8 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	 */
 
 	/* Validate module identifier value. */
-	err = mlxsw_env_validate_cable_ident(core, module, &qsfp, &cmis);
+	err = mlxsw_env_validate_cable_ident(core, slot_index, module, &qsfp,
+					     &cmis);
 	if (err)
 		return err;
 
@@ -220,12 +226,12 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 			page = MLXSW_REG_MCIA_TH_PAGE_CMIS_NUM;
 		else
 			page = MLXSW_REG_MCIA_TH_PAGE_NUM;
-		mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0, page,
+		mlxsw_reg_mcia_pack(mcia_pl, slot_index, module, 0, page,
 				    MLXSW_REG_MCIA_TH_PAGE_OFF + off,
 				    MLXSW_REG_MCIA_TH_ITEM_SIZE,
 				    MLXSW_REG_MCIA_I2C_ADDR_LOW);
 	} else {
-		mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0,
+		mlxsw_reg_mcia_pack(mcia_pl, slot_index, module, 0,
 				    MLXSW_REG_MCIA_PAGE0_LO,
 				    off, MLXSW_REG_MCIA_TH_ITEM_SIZE,
 				    MLXSW_REG_MCIA_I2C_ADDR_HIGH);
@@ -243,8 +249,8 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 }
 
 int mlxsw_env_get_module_info(struct net_device *netdev,
-			      struct mlxsw_core *mlxsw_core, int module,
-			      struct ethtool_modinfo *modinfo)
+			      struct mlxsw_core *mlxsw_core, u8 slot_index,
+			      int module, struct ethtool_modinfo *modinfo)
 {
 	u8 module_info[MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE];
 	u16 offset = MLXSW_REG_MCIA_EEPROM_MODULE_INFO_SIZE;
@@ -252,15 +258,16 @@ int mlxsw_env_get_module_info(struct net_device *netdev,
 	unsigned int read_size;
 	int err;
 
-	err = mlxsw_env_validate_module_type(mlxsw_core, module);
+	err = mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		netdev_err(netdev,
 			   "EEPROM is not equipped on port module type");
 		return err;
 	}
 
-	err = mlxsw_env_query_module_eeprom(mlxsw_core, module, 0, offset,
-					    module_info, false, &read_size);
+	err = mlxsw_env_query_module_eeprom(mlxsw_core, slot_index, module, 0,
+					    offset, module_info, false,
+					    &read_size);
 	if (err)
 		return err;
 
@@ -289,9 +296,10 @@ int mlxsw_env_get_module_info(struct net_device *netdev,
 		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_SFP:
 		/* Verify if transceiver provides diagnostic monitoring page */
-		err = mlxsw_env_query_module_eeprom(mlxsw_core, module,
-						    SFP_DIAGMON, 1, &diag_mon,
-						    false, &read_size);
+		err = mlxsw_env_query_module_eeprom(mlxsw_core, slot_index,
+						    module, SFP_DIAGMON, 1,
+						    &diag_mon, false,
+						    &read_size);
 		if (err)
 			return err;
 
@@ -330,8 +338,9 @@ int mlxsw_env_get_module_info(struct net_device *netdev,
 EXPORT_SYMBOL(mlxsw_env_get_module_info);
 
 int mlxsw_env_get_module_eeprom(struct net_device *netdev,
-				struct mlxsw_core *mlxsw_core, int module,
-				struct ethtool_eeprom *ee, u8 *data)
+				struct mlxsw_core *mlxsw_core, u8 slot_index,
+				int module, struct ethtool_eeprom *ee,
+				u8 *data)
 {
 	int offset = ee->offset;
 	unsigned int read_size;
@@ -344,12 +353,14 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 
 	memset(data, 0, ee->len);
 	/* Validate module identifier value. */
-	err = mlxsw_env_validate_cable_ident(mlxsw_core, module, &qsfp, &cmis);
+	err = mlxsw_env_validate_cable_ident(mlxsw_core, slot_index, module,
+					     &qsfp, &cmis);
 	if (err)
 		return err;
 
 	while (i < ee->len) {
-		err = mlxsw_env_query_module_eeprom(mlxsw_core, module, offset,
+		err = mlxsw_env_query_module_eeprom(mlxsw_core, slot_index,
+						    module, offset,
 						    ee->len - i, data + i,
 						    qsfp, &read_size);
 		if (err) {
@@ -395,7 +406,8 @@ static int mlxsw_env_mcia_status_process(const char *mcia_pl,
 }
 
 int
-mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
+mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core,
+				    u8 slot_index, u8 module,
 				    const struct ethtool_module_eeprom *page,
 				    struct netlink_ext_ack *extack)
 {
@@ -403,7 +415,7 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 	u16 device_addr;
 	int err;
 
-	err = mlxsw_env_validate_module_type(mlxsw_core, module);
+	err = mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "EEPROM is not equipped on port module type");
 		return err;
@@ -420,7 +432,7 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 		size = min_t(u8, page->length - bytes_read,
 			     MLXSW_REG_MCIA_EEPROM_SIZE);
 
-		mlxsw_reg_mcia_pack(mcia_pl, 0, module, 0, page->page,
+		mlxsw_reg_mcia_pack(mcia_pl, slot_index, module, 0, page->page,
 				    device_addr + bytes_read, size,
 				    page->i2c_address);
 		mlxsw_reg_mcia_bank_number_set(mcia_pl, page->bank);
@@ -444,18 +456,20 @@ mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
 }
 EXPORT_SYMBOL(mlxsw_env_get_module_eeprom_by_page);
 
-static int mlxsw_env_module_reset(struct mlxsw_core *mlxsw_core, u8 module)
+static int mlxsw_env_module_reset(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				  u8 module)
 {
 	char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-	mlxsw_reg_pmaos_pack(pmaos_pl, 0, module);
+	mlxsw_reg_pmaos_pack(pmaos_pl, slot_index, module);
 	mlxsw_reg_pmaos_rst_set(pmaos_pl, true);
 
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
 }
 
 int mlxsw_env_reset_module(struct net_device *netdev,
-			   struct mlxsw_core *mlxsw_core, u8 module, u32 *flags)
+			   struct mlxsw_core *mlxsw_core, u8 slot_index,
+			   u8 module, u32 *flags)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	u32 req = *flags;
@@ -467,7 +481,7 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 
 	mutex_lock(&mlxsw_env->module_info_lock);
 
-	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
+	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		netdev_err(netdev, "Reset module is not supported on port module type\n");
 		goto out;
@@ -486,7 +500,7 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 		goto out;
 	}
 
-	err = mlxsw_env_module_reset(mlxsw_core, module);
+	err = mlxsw_env_module_reset(mlxsw_core, slot_index, module);
 	if (err) {
 		netdev_err(netdev, "Failed to reset module\n");
 		goto out;
@@ -501,7 +515,8 @@ int mlxsw_env_reset_module(struct net_device *netdev,
 EXPORT_SYMBOL(mlxsw_env_reset_module);
 
 int
-mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				u8 module,
 				struct ethtool_module_power_mode_params *params,
 				struct netlink_ext_ack *extack)
 {
@@ -512,7 +527,7 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 
 	mutex_lock(&mlxsw_env->module_info_lock);
 
-	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
+	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Power mode is not supported on port module type");
 		goto out;
@@ -520,7 +535,7 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 
 	params->policy = mlxsw_env->module_info[module].power_mode_policy;
 
-	mlxsw_reg_mcion_pack(mcion_pl, 0, module);
+	mlxsw_reg_mcion_pack(mcion_pl, slot_index, module);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcion), mcion_pl);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to retrieve module's power mode");
@@ -543,12 +558,12 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 EXPORT_SYMBOL(mlxsw_env_get_module_power_mode);
 
 static int mlxsw_env_module_enable_set(struct mlxsw_core *mlxsw_core,
-				       u8 module, bool enable)
+				       u8 slot_index, u8 module, bool enable)
 {
 	enum mlxsw_reg_pmaos_admin_status admin_status;
 	char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-	mlxsw_reg_pmaos_pack(pmaos_pl, 0, module);
+	mlxsw_reg_pmaos_pack(pmaos_pl, slot_index, module);
 	admin_status = enable ? MLXSW_REG_PMAOS_ADMIN_STATUS_ENABLED :
 				MLXSW_REG_PMAOS_ADMIN_STATUS_DISABLED;
 	mlxsw_reg_pmaos_admin_status_set(pmaos_pl, admin_status);
@@ -558,12 +573,13 @@ static int mlxsw_env_module_enable_set(struct mlxsw_core *mlxsw_core,
 }
 
 static int mlxsw_env_module_low_power_set(struct mlxsw_core *mlxsw_core,
-					  u8 module, bool low_power)
+					  u8 slot_index, u8 module,
+					  bool low_power)
 {
 	u16 eeprom_override_mask, eeprom_override;
 	char pmmp_pl[MLXSW_REG_PMMP_LEN];
 
-	mlxsw_reg_pmmp_pack(pmmp_pl, 0, module);
+	mlxsw_reg_pmmp_pack(pmmp_pl, slot_index, module);
 	mlxsw_reg_pmmp_sticky_set(pmmp_pl, true);
 	/* Mask all the bits except low power mode. */
 	eeprom_override_mask = ~MLXSW_REG_PMMP_EEPROM_OVERRIDE_LOW_POWER_MASK;
@@ -576,24 +592,26 @@ static int mlxsw_env_module_low_power_set(struct mlxsw_core *mlxsw_core,
 }
 
 static int __mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core,
-					     u8 module, bool low_power,
+					     u8 slot_index, u8 module,
+					     bool low_power,
 					     struct netlink_ext_ack *extack)
 {
 	int err;
 
-	err = mlxsw_env_module_enable_set(mlxsw_core, module, false);
+	err = mlxsw_env_module_enable_set(mlxsw_core, slot_index, module, false);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to disable module");
 		return err;
 	}
 
-	err = mlxsw_env_module_low_power_set(mlxsw_core, module, low_power);
+	err = mlxsw_env_module_low_power_set(mlxsw_core, slot_index, module,
+					     low_power);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to set module's power mode");
 		goto err_module_low_power_set;
 	}
 
-	err = mlxsw_env_module_enable_set(mlxsw_core, module, true);
+	err = mlxsw_env_module_enable_set(mlxsw_core, slot_index, module, true);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to enable module");
 		goto err_module_enable_set;
@@ -602,14 +620,16 @@ static int __mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core,
 	return 0;
 
 err_module_enable_set:
-	mlxsw_env_module_low_power_set(mlxsw_core, module, !low_power);
+	mlxsw_env_module_low_power_set(mlxsw_core, slot_index, module,
+				       !low_power);
 err_module_low_power_set:
-	mlxsw_env_module_enable_set(mlxsw_core, module, true);
+	mlxsw_env_module_enable_set(mlxsw_core, slot_index, module, true);
 	return err;
 }
 
 int
-mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				u8 module,
 				enum ethtool_module_power_mode_policy policy,
 				struct netlink_ext_ack *extack)
 {
@@ -625,7 +645,7 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 
 	mutex_lock(&mlxsw_env->module_info_lock);
 
-	err = __mlxsw_env_validate_module_type(mlxsw_core, module);
+	err = __mlxsw_env_validate_module_type(mlxsw_core, slot_index, module);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Power mode set is not supported on port module type");
@@ -640,8 +660,8 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 		goto out_set_policy;
 
 	low_power = policy == ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO;
-	err = __mlxsw_env_set_module_power_mode(mlxsw_core, module, low_power,
-						extack);
+	err = __mlxsw_env_set_module_power_mode(mlxsw_core, slot_index, module,
+						low_power, extack);
 	if (err)
 		goto out;
 
@@ -654,14 +674,14 @@ mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 EXPORT_SYMBOL(mlxsw_env_set_module_power_mode);
 
 static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
-					    u8 module,
+					    u8 slot_index, u8 module,
 					    bool *p_has_temp_sensor)
 {
 	char mtbr_pl[MLXSW_REG_MTBR_LEN];
 	u16 temp;
 	int err;
 
-	mlxsw_reg_mtbr_pack(mtbr_pl, 0,
+	mlxsw_reg_mtbr_pack(mtbr_pl, slot_index,
 			    MLXSW_REG_MTBR_BASE_MODULE_INDEX + module, 1);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mtbr), mtbr_pl);
 	if (err)
@@ -682,13 +702,15 @@ static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
-static int mlxsw_env_temp_event_set(struct mlxsw_core *mlxsw_core,
-				    u16 sensor_index, bool enable)
+static int
+mlxsw_env_temp_event_set(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			 u16 sensor_index, bool enable)
 {
 	char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
 	enum mlxsw_reg_mtmp_tee tee;
 	int err, threshold_hi;
 
+	mlxsw_reg_mtmp_slot_index_set(mtmp_pl, slot_index);
 	mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, sensor_index);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
@@ -696,6 +718,7 @@ static int mlxsw_env_temp_event_set(struct mlxsw_core *mlxsw_core,
 
 	if (enable) {
 		err = mlxsw_env_module_temp_thresholds_get(mlxsw_core,
+							   slot_index,
 							   sensor_index -
 							   MLXSW_REG_MTMP_MODULE_INDEX_MIN,
 							   SFP_TEMP_HIGH_WARN,
@@ -722,14 +745,15 @@ static int mlxsw_env_temp_event_set(struct mlxsw_core *mlxsw_core,
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(mtmp), mtmp_pl);
 }
 
-static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core)
+static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core,
+					      u8 slot_index)
 {
 	int i, err, sensor_index;
 	bool has_temp_sensor;
 
 	for (i = 0; i < mlxsw_core_env(mlxsw_core)->module_count; i++) {
-		err = mlxsw_env_module_has_temp_sensor(mlxsw_core, i,
-						       &has_temp_sensor);
+		err = mlxsw_env_module_has_temp_sensor(mlxsw_core, slot_index,
+						       i, &has_temp_sensor);
 		if (err)
 			return err;
 
@@ -737,7 +761,8 @@ static int mlxsw_env_module_temp_event_enable(struct mlxsw_core *mlxsw_core)
 			continue;
 
 		sensor_index = i + MLXSW_REG_MTMP_MODULE_INDEX_MIN;
-		err = mlxsw_env_temp_event_set(mlxsw_core, sensor_index, true);
+		err = mlxsw_env_temp_event_set(mlxsw_core, slot_index,
+					       sensor_index, true);
 		if (err)
 			return err;
 	}
@@ -838,6 +863,7 @@ static void mlxsw_env_temp_warn_event_unregister(struct mlxsw_env *mlxsw_env)
 
 struct mlxsw_env_module_plug_unplug_event {
 	struct mlxsw_env *mlxsw_env;
+	u8 slot_index;
 	u8 module;
 	struct work_struct work;
 };
@@ -858,7 +884,9 @@ static void mlxsw_env_pmpe_event_work(struct work_struct *work)
 	mlxsw_env->module_info[event->module].is_overheat = false;
 	mutex_unlock(&mlxsw_env->module_info_lock);
 
-	err = mlxsw_env_module_has_temp_sensor(mlxsw_env->core, event->module,
+	err = mlxsw_env_module_has_temp_sensor(mlxsw_env->core,
+					       event->slot_index,
+					       event->module,
 					       &has_temp_sensor);
 	/* Do not disable events on modules without sensors or faulty sensors
 	 * because FW returns errors.
@@ -870,7 +898,8 @@ static void mlxsw_env_pmpe_event_work(struct work_struct *work)
 		goto out;
 
 	sensor_index = event->module + MLXSW_REG_MTMP_MODULE_INDEX_MIN;
-	mlxsw_env_temp_event_set(mlxsw_env->core, sensor_index, true);
+	mlxsw_env_temp_event_set(mlxsw_env->core, event->slot_index,
+				 sensor_index, true);
 
 out:
 	kfree(event);
@@ -897,6 +926,7 @@ mlxsw_env_pmpe_listener_func(const struct mlxsw_reg_info *reg, char *pmpe_pl,
 		return;
 
 	event->mlxsw_env = mlxsw_env;
+	event->slot_index = 0;
 	event->module = module;
 	INIT_WORK(&event->work, mlxsw_env_pmpe_event_work);
 	mlxsw_core_schedule_work(&event->work);
@@ -924,14 +954,15 @@ mlxsw_env_module_plug_event_unregister(struct mlxsw_env *mlxsw_env)
 }
 
 static int
-mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core)
+mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core,
+					 u8 slot_index)
 {
 	int i, err;
 
 	for (i = 0; i < mlxsw_core_env(mlxsw_core)->module_count; i++) {
 		char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-		mlxsw_reg_pmaos_pack(pmaos_pl, 0, i);
+		mlxsw_reg_pmaos_pack(pmaos_pl, slot_index, i);
 		mlxsw_reg_pmaos_e_set(pmaos_pl,
 				      MLXSW_REG_PMAOS_E_GENERATE_EVENT);
 		mlxsw_reg_pmaos_ee_set(pmaos_pl, true);
@@ -943,8 +974,8 @@ mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core)
 }
 
 int
-mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
-				      u64 *p_counter)
+mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				      u8 module, u64 *p_counter)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
@@ -956,7 +987,8 @@ mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
 }
 EXPORT_SYMBOL(mlxsw_env_module_overheat_counter_get);
 
-void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 module)
+void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			       u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
@@ -966,7 +998,8 @@ void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 module)
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_map);
 
-void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 module)
+void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				 u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
@@ -976,7 +1009,8 @@ void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 module)
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_unmap);
 
-int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module)
+int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			     u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int err = 0;
@@ -993,8 +1027,8 @@ int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module)
 	/* Transition to high power mode following first port using the module
 	 * being put administratively up.
 	 */
-	err = __mlxsw_env_set_module_power_mode(mlxsw_core, module, false,
-						NULL);
+	err = __mlxsw_env_set_module_power_mode(mlxsw_core, slot_index, module,
+						false, NULL);
 	if (err)
 		goto out_unlock;
 
@@ -1006,7 +1040,8 @@ int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module)
 }
 EXPORT_SYMBOL(mlxsw_env_module_port_up);
 
-void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module)
+void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				u8 module)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
@@ -1024,7 +1059,8 @@ void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module)
 	/* Transition to low power mode following last port using the module
 	 * being put administratively down.
 	 */
-	__mlxsw_env_set_module_power_mode(mlxsw_core, module, true, NULL);
+	__mlxsw_env_set_module_power_mode(mlxsw_core, slot_index, module, true,
+					  NULL);
 
 out_unlock:
 	mutex_unlock(&mlxsw_env->module_info_lock);
@@ -1032,7 +1068,7 @@ void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module)
 EXPORT_SYMBOL(mlxsw_env_module_port_down);
 
 static int
-mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core)
+mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core, u8 slot_index)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 	int i;
@@ -1041,7 +1077,7 @@ mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core)
 		char pmtm_pl[MLXSW_REG_PMTM_LEN];
 		int err;
 
-		mlxsw_reg_pmtm_pack(pmtm_pl, 0, i);
+		mlxsw_reg_pmtm_pack(pmtm_pl, slot_index, i);
 		err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(pmtm), pmtm_pl);
 		if (err)
 			return err;
@@ -1091,15 +1127,15 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	if (err)
 		goto err_module_plug_event_register;
 
-	err = mlxsw_env_module_oper_state_event_enable(mlxsw_core);
+	err = mlxsw_env_module_oper_state_event_enable(mlxsw_core, 0);
 	if (err)
 		goto err_oper_state_event_enable;
 
-	err = mlxsw_env_module_temp_event_enable(mlxsw_core);
+	err = mlxsw_env_module_temp_event_enable(mlxsw_core, 0);
 	if (err)
 		goto err_temp_event_enable;
 
-	err = mlxsw_env_module_type_set(mlxsw_core);
+	err = mlxsw_env_module_type_set(mlxsw_core, 0);
 	if (err)
 		goto err_type_set;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.h b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
index ec6564e5d2ee..6b494c64a4d7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.h
@@ -9,47 +9,56 @@
 struct ethtool_modinfo;
 struct ethtool_eeprom;
 
-int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
-					 int off, int *temp);
+int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core,
+					 u8 slot_index, int module, int off,
+					 int *temp);
 
 int mlxsw_env_get_module_info(struct net_device *netdev,
-			      struct mlxsw_core *mlxsw_core, int module,
-			      struct ethtool_modinfo *modinfo);
+			      struct mlxsw_core *mlxsw_core, u8 slot_index,
+			      int module, struct ethtool_modinfo *modinfo);
 
 int mlxsw_env_get_module_eeprom(struct net_device *netdev,
-				struct mlxsw_core *mlxsw_core, int module,
-				struct ethtool_eeprom *ee, u8 *data);
+				struct mlxsw_core *mlxsw_core, u8 slot_index,
+				int module, struct ethtool_eeprom *ee,
+				u8 *data);
 
 int
-mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core, u8 module,
+mlxsw_env_get_module_eeprom_by_page(struct mlxsw_core *mlxsw_core,
+				    u8 slot_index, u8 module,
 				    const struct ethtool_module_eeprom *page,
 				    struct netlink_ext_ack *extack);
 
 int mlxsw_env_reset_module(struct net_device *netdev,
-			   struct mlxsw_core *mlxsw_core, u8 module,
-			   u32 *flags);
+			   struct mlxsw_core *mlxsw_core, u8 slot_index,
+			   u8 module, u32 *flags);
 
 int
-mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				u8 module,
 				struct ethtool_module_power_mode_params *params,
 				struct netlink_ext_ack *extack);
 
 int
-mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
+mlxsw_env_set_module_power_mode(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				u8 module,
 				enum ethtool_module_power_mode_policy policy,
 				struct netlink_ext_ack *extack);
 
 int
-mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 module,
-				      u64 *p_counter);
+mlxsw_env_module_overheat_counter_get(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				      u8 module, u64 *p_counter);
 
-void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 module);
+void mlxsw_env_module_port_map(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			       u8 module);
 
-void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 module);
+void mlxsw_env_module_port_unmap(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				 u8 module);
 
-int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 module);
+int mlxsw_env_module_port_up(struct mlxsw_core *mlxsw_core, u8 slot_index,
+			     u8 module);
 
-void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 module);
+void mlxsw_env_module_port_down(struct mlxsw_core *mlxsw_core, u8 slot_index,
+				u8 module);
 
 int mlxsw_env_init(struct mlxsw_core *core, struct mlxsw_env **p_env);
 void mlxsw_env_fini(struct mlxsw_env *env);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 2bc4c4556895..5df54a5bf292 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -311,8 +311,9 @@ static int mlxsw_hwmon_module_temp_critical_get(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
-	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, module,
-						   SFP_TEMP_HIGH_WARN, p_temp);
+	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, 0,
+						   module, SFP_TEMP_HIGH_WARN,
+						   p_temp);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature thresholds\n");
 		return err;
@@ -345,8 +346,9 @@ static int mlxsw_hwmon_module_temp_emergency_get(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
-	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, module,
-						   SFP_TEMP_HIGH_ALARM, p_temp);
+	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, 0,
+						   module, SFP_TEMP_HIGH_ALARM,
+						   p_temp);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature thresholds\n");
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index adb2820430b1..d64af27e5bac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -150,13 +150,13 @@ mlxsw_thermal_module_trips_update(struct device *dev, struct mlxsw_core *core,
 	 * EEPROM if we got valid thresholds from MTMP.
 	 */
 	if (!emerg_temp || !crit_temp) {
-		err = mlxsw_env_module_temp_thresholds_get(core, tz->module,
+		err = mlxsw_env_module_temp_thresholds_get(core, 0, tz->module,
 							   SFP_TEMP_HIGH_WARN,
 							   &crit_temp);
 		if (err)
 			return err;
 
-		err = mlxsw_env_module_temp_thresholds_get(core, tz->module,
+		err = mlxsw_env_module_temp_thresholds_get(core, 0, tz->module,
 							   SFP_TEMP_HIGH_ALARM,
 							   &emerg_temp);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 3bc012dafd08..eb906b73b4e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -59,7 +59,8 @@ static int mlxsw_m_port_open(struct net_device *dev)
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
 
-	return mlxsw_env_module_port_up(mlxsw_m->core, mlxsw_m_port->module);
+	return mlxsw_env_module_port_up(mlxsw_m->core, 0,
+					mlxsw_m_port->module);
 }
 
 static int mlxsw_m_port_stop(struct net_device *dev)
@@ -67,7 +68,7 @@ static int mlxsw_m_port_stop(struct net_device *dev)
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(dev);
 	struct mlxsw_m *mlxsw_m = mlxsw_m_port->mlxsw_m;
 
-	mlxsw_env_module_port_down(mlxsw_m->core, mlxsw_m_port->module);
+	mlxsw_env_module_port_down(mlxsw_m->core, 0, mlxsw_m_port->module);
 	return 0;
 }
 
@@ -110,7 +111,7 @@ static int mlxsw_m_get_module_info(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_info(netdev, core, mlxsw_m_port->module,
+	return mlxsw_env_get_module_info(netdev, core, 0, mlxsw_m_port->module,
 					 modinfo);
 }
 
@@ -121,8 +122,8 @@ mlxsw_m_get_module_eeprom(struct net_device *netdev, struct ethtool_eeprom *ee,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_eeprom(netdev, core, mlxsw_m_port->module,
-					   ee, data);
+	return mlxsw_env_get_module_eeprom(netdev, core, 0,
+					   mlxsw_m_port->module, ee, data);
 }
 
 static int
@@ -133,7 +134,8 @@ mlxsw_m_get_module_eeprom_by_page(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_eeprom_by_page(core, mlxsw_m_port->module,
+	return mlxsw_env_get_module_eeprom_by_page(core, 0,
+						   mlxsw_m_port->module,
 						   page, extack);
 }
 
@@ -142,7 +144,7 @@ static int mlxsw_m_reset(struct net_device *netdev, u32 *flags)
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_reset_module(netdev, core, mlxsw_m_port->module,
+	return mlxsw_env_reset_module(netdev, core, 0, mlxsw_m_port->module,
 				      flags);
 }
 
@@ -154,7 +156,7 @@ mlxsw_m_get_module_power_mode(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_get_module_power_mode(core, mlxsw_m_port->module,
+	return mlxsw_env_get_module_power_mode(core, 0, mlxsw_m_port->module,
 					       params, extack);
 }
 
@@ -166,7 +168,7 @@ mlxsw_m_set_module_power_mode(struct net_device *netdev,
 	struct mlxsw_m_port *mlxsw_m_port = netdev_priv(netdev);
 	struct mlxsw_core *core = mlxsw_m_port->mlxsw_m->core;
 
-	return mlxsw_env_set_module_power_mode(core, mlxsw_m_port->module,
+	return mlxsw_env_set_module_power_mode(core, 0, mlxsw_m_port->module,
 					       params->policy, extack);
 }
 
@@ -311,7 +313,7 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 
 	if (WARN_ON_ONCE(module >= max_ports))
 		return -EINVAL;
-	mlxsw_env_module_port_map(mlxsw_m->core, module);
+	mlxsw_env_module_port_map(mlxsw_m->core, 0, module);
 	mlxsw_m->module_to_port[module] = ++mlxsw_m->max_ports;
 
 	return 0;
@@ -320,7 +322,7 @@ static int mlxsw_m_port_module_map(struct mlxsw_m *mlxsw_m, u16 local_port,
 static void mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 module)
 {
 	mlxsw_m->module_to_port[module] = -1;
-	mlxsw_env_module_port_unmap(mlxsw_m->core, module);
+	mlxsw_env_module_port_unmap(mlxsw_m->core, 0, module);
 }
 
 static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 8eb05090ffec..684910ca7cf4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -539,7 +539,7 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 	int i, err;
 
-	mlxsw_env_module_port_map(mlxsw_sp->core, port_mapping->module);
+	mlxsw_env_module_port_map(mlxsw_sp->core, 0, port_mapping->module);
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, port_mapping->width);
@@ -554,19 +554,19 @@ mlxsw_sp_port_module_map(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	return 0;
 
 err_pmlp_write:
-	mlxsw_env_module_port_unmap(mlxsw_sp->core, port_mapping->module);
+	mlxsw_env_module_port_unmap(mlxsw_sp->core, 0, port_mapping->module);
 	return err;
 }
 
 static void mlxsw_sp_port_module_unmap(struct mlxsw_sp *mlxsw_sp, u16 local_port,
-				       u8 module)
+				       u8 slot_index, u8 module)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	mlxsw_reg_pmlp_width_set(pmlp_pl, 0);
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
-	mlxsw_env_module_port_unmap(mlxsw_sp->core, module);
+	mlxsw_env_module_port_unmap(mlxsw_sp->core, slot_index, module);
 }
 
 static int mlxsw_sp_port_open(struct net_device *dev)
@@ -575,7 +575,7 @@ static int mlxsw_sp_port_open(struct net_device *dev)
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	int err;
 
-	err = mlxsw_env_module_port_up(mlxsw_sp->core,
+	err = mlxsw_env_module_port_up(mlxsw_sp->core, 0,
 				       mlxsw_sp_port->mapping.module);
 	if (err)
 		return err;
@@ -586,7 +586,7 @@ static int mlxsw_sp_port_open(struct net_device *dev)
 	return 0;
 
 err_port_admin_status_set:
-	mlxsw_env_module_port_down(mlxsw_sp->core,
+	mlxsw_env_module_port_down(mlxsw_sp->core, 0,
 				   mlxsw_sp_port->mapping.module);
 	return err;
 }
@@ -598,7 +598,7 @@ static int mlxsw_sp_port_stop(struct net_device *dev)
 
 	netif_stop_queue(dev);
 	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
-	mlxsw_env_module_port_down(mlxsw_sp->core,
+	mlxsw_env_module_port_down(mlxsw_sp->core, 0,
 				   mlxsw_sp_port->mapping.module);
 	return 0;
 }
@@ -1449,7 +1449,7 @@ static int mlxsw_sp_port_overheat_init_val_set(struct mlxsw_sp_port *mlxsw_sp_po
 	u64 overheat_counter;
 	int err;
 
-	err = mlxsw_env_module_overheat_counter_get(mlxsw_sp->core, module,
+	err = mlxsw_env_module_overheat_counter_get(mlxsw_sp->core, 0, module,
 						    &overheat_counter);
 	if (err)
 		return err;
@@ -1775,7 +1775,8 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
 			       MLXSW_PORT_SWID_DISABLED_PORT);
 err_port_swid_set:
-	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, port_mapping->module);
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, 0,
+				   port_mapping->module);
 	return err;
 }
 
@@ -1804,7 +1805,7 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
 	mlxsw_sp_port_swid_set(mlxsw_sp, local_port,
 			       MLXSW_PORT_SWID_DISABLED_PORT);
-	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, module);
+	mlxsw_sp_port_module_unmap(mlxsw_sp, local_port, 0, module);
 }
 
 static int mlxsw_sp_cpu_port_create(struct mlxsw_sp *mlxsw_sp)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 8b5d7f83b9b0..f72c26ce0391 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -573,7 +573,7 @@ mlxsw_sp_port_get_transceiver_overheat_stats(struct mlxsw_sp_port *mlxsw_sp_port
 	u64 stats;
 	int err;
 
-	err = mlxsw_env_module_overheat_counter_get(mlxsw_core,
+	err = mlxsw_env_module_overheat_counter_get(mlxsw_core, 0,
 						    port_mapping.module,
 						    &stats);
 	if (err)
@@ -1035,7 +1035,7 @@ static int mlxsw_sp_get_module_info(struct net_device *netdev,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
-	return mlxsw_env_get_module_info(netdev, mlxsw_sp->core,
+	return mlxsw_env_get_module_info(netdev, mlxsw_sp->core, 0,
 					 mlxsw_sp_port->mapping.module,
 					 modinfo);
 }
@@ -1046,7 +1046,7 @@ static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
-	return mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core,
+	return mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core, 0,
 					   mlxsw_sp_port->mapping.module, ee,
 					   data);
 }
@@ -1060,8 +1060,8 @@ mlxsw_sp_get_module_eeprom_by_page(struct net_device *dev,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_get_module_eeprom_by_page(mlxsw_sp->core, module, page,
-						   extack);
+	return mlxsw_env_get_module_eeprom_by_page(mlxsw_sp->core, 0, module,
+						   page, extack);
 }
 
 static int
@@ -1204,7 +1204,7 @@ static int mlxsw_sp_reset(struct net_device *dev, u32 *flags)
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_reset_module(dev, mlxsw_sp->core, module, flags);
+	return mlxsw_env_reset_module(dev, mlxsw_sp->core, 0, module, flags);
 }
 
 static int
@@ -1216,8 +1216,8 @@ mlxsw_sp_get_module_power_mode(struct net_device *dev,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_get_module_power_mode(mlxsw_sp->core, module, params,
-					       extack);
+	return mlxsw_env_get_module_power_mode(mlxsw_sp->core, 0, module,
+					       params, extack);
 }
 
 static int
@@ -1229,7 +1229,7 @@ mlxsw_sp_set_module_power_mode(struct net_device *dev,
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	u8 module = mlxsw_sp_port->mapping.module;
 
-	return mlxsw_env_set_module_power_mode(mlxsw_sp->core, module,
+	return mlxsw_env_set_module_power_mode(mlxsw_sp->core, 0, module,
 					       params->policy, extack);
 }
 
-- 
2.33.1

