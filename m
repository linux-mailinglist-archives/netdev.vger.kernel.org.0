Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40474FF9DB
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbiDMPVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235799AbiDMPVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:21:06 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8892ED47
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPgT/44ArygPoJLBiT6E3AGH+D2kpRJjtBSxQNEOyba30bgKi37sBV9M9jsS42O6ka4aT0t1NwhZKaLpVzMMo80fmqCj5c/WOtmf3/H36TIjGl8yw7GXqHx7JOm3snenjqAezDImtOix1OAHuVllJAovsv+FTB6T15u88XEeCGgCkcTi3eRKF2yZp4q087U5BWuexT8qJyz0OBMnwmyWUcIsGrWqQxnz8w8dI2mk/OTYQn1RYt7DkqrCz5kZjQMTu5AOFf3lEhDVsGECumGwM+HyxxAt/6DwIZWI/+xWxxQ69jlgqUsE+TXQ2NtALnQ0w5eSTQvUaqxuTfiidAxeSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SCLLaGAnEIsrffHO6tPiUmVlYRDL7OR7P6QtNNuEuQ=;
 b=CVIsHdBtOHnMxsmlhJbA/OlY+aXNh5JFrKHOdjW14uASxqrt/Ob4S2qP+xNYtrcBA6nSRi9U0P4+YNfSY6WR9MmfsG6YLFVmLigzx6eutVt8TWQdAI9IIbhd6m7Gkwmzp67lEnpEqqFSE880opd6/xRiPl/zGheBMH+o6uKPhs4q2VgH9UEaJRilCa/oGiGptaVbrFzfqKMw58s3yDNsLx9GtxBr8xvGVhwzCAQ7eEZk117XkoU/83WwkMhY2UMWjGY9vg+jXBuP06iR3oQPMpOIhCe3sHPjGqg6xQKZrBtu7KmcvTbNv4yrJlUWe9J4MJbOzIoeugxyM1WRH7TTRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SCLLaGAnEIsrffHO6tPiUmVlYRDL7OR7P6QtNNuEuQ=;
 b=BRaVNdPclhfLzyvnVlP7I9srGrYKEnRXCuWQHfUpaS9wFWvMRGLOL42AGz0KJAhETCcdRuqz+WTvaWFtoigKwC2cnOv26wHp9+YDI6Ue6ENMlvoD/EiwvwMROEyMOAyIN2vO7izEwFsdVH5PKlESUAO2knGnTmE/Zh7KNUiqg+C5V4nd9VSNmdKALF1MnKOZ2/nSSIKCZKDKCSJSeE0Yoh12Xop47Uzcneg4QkvHGbcN8k9zz6M2igh9rdOJpG00B+XK27CHbRy8RMWBiEucDV53w5dVPi3ctIFKpQvR8cQQIDGvDZBdolqmRrIn1U7IEluAIbHX3lZeOPHGl+YqFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3279.namprd12.prod.outlook.com (2603:10b6:208:105::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 15:18:29 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/9] mlxsw: core: Move port module events enablement to a separate function
Date:   Wed, 13 Apr 2022 18:17:27 +0300
Message-Id: <20220413151733.2738867-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0020.eurprd08.prod.outlook.com
 (2603:10a6:803:104::33) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a1a3be5-c9e4-4b2c-979f-08da1d60dd15
X-MS-TrafficTypeDiagnostic: MN2PR12MB3279:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB32796CC8481C297DE288A62FB2EC9@MN2PR12MB3279.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dUXup8DWa4kNdUFizTY1yraKJXjlLznSqdgWkFKTnsaOLPY46OxOm0zG95twC90SGNfdM17sdGhKr8dU9KAm1uj+gjQg36w0X49+Xv5CoGn8Z3Ku1KWrPKqe/awGyBTLH/UbpUPBxZQfnIPP5t1MD0L9cz5+IUF7H0UzjjF8T6hW56KDRzgqK07YlfnyGm/ZwkZ46a8KmLvxVfJ/9Ll7dsitf3s9i3tiPPtLNr/vVtHHaj/gpIy28GgFIXo+7b2r3wLVsHrahOl6QIlWM46egAPnPefOAyfE0GMjtg+iqjS62su0cN2EOdGMDwjpyKSVfYeCCEgPxzfjmOjBH5NjUCbTjHWdjFRRq+TbtvjbuPU+yTLN4DmHBFVUTC/V/nkvYSdcpuuCS9mdftK1LBYfOysj3EYkQTGgXBOnaeISvQ/OocEeysNX9rvVnQkRJ+dBzOrtfr12CcwXJT+Dm646pZxv90i32tVjphkWzmIhIUj2YqgBw47wIAJ9IhTntAC3udLRhjcySl1VXURDl1rnOb1Iw0jHKbJfhAxCi8WY0y8D7QNFjeb1IQGjvHiNQJBk+2v8lZt/FrgVjJNRTVis5XTt3hyQWeNdJQKklPkVXle59+A2m1vGtfUSnerCZe2C2C3UbJuBwHvQdsfagnkDmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8936002)(508600001)(186003)(26005)(107886003)(1076003)(2906002)(38100700002)(83380400001)(86362001)(36756003)(6506007)(2616005)(66476007)(66556008)(4326008)(8676002)(6916009)(6512007)(316002)(6486002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I4I6IwHPOdBGnT32CsTFW3HM+rjugKVt4lAZJTg4j9N/U2UKYMkPH9qNrIb8?=
 =?us-ascii?Q?A0C8MOsKtojl1HOKwI8OAyhhp/VxoYqswok0RInhutna1lFy8viXH3KPEf8K?=
 =?us-ascii?Q?0I6c+p1dZsRWyDK70lTnntdM6g8iQeutuh1shRiLj/Ebhwl1WXCiMzqOOnxf?=
 =?us-ascii?Q?lUWwtrU7AjiXwXLoCGDYxqcM1Dsct9xx1kqgtSQ9H3n/cPeo1mSQgT7NgqSv?=
 =?us-ascii?Q?Y/Qc2pwZtZ2kEpWtMT/BfUd9y6ABdzSYI5IAONK3UORwSpI8eLoUklyyOc8+?=
 =?us-ascii?Q?MGBk4S6KPQwul+LD+Xo+5/dMawySri4LBXVzxgYtnUAIU81yisSrSPVOOTpt?=
 =?us-ascii?Q?ZFIENgmT4RRg5cUynD6AVi89pPrOISQ0QVh00VziITgJuYscsMmn5ZXcSdwk?=
 =?us-ascii?Q?eMF6gfZOVSuditAfaiqzkxK0j/Ng5ZhoM6uZeKPuKg4+ZwIqOuEbQ6ORMDAU?=
 =?us-ascii?Q?Q6LM94asc5PmDCHxclKSTYrM3om0TOsXZ2mztHPvGwIWknK9jiJs94t35+SQ?=
 =?us-ascii?Q?sF9INlntmsFq0UKeizjqlNXDOy4xDLZIghNK14ePBv0fGiQQtaqeP86/edCV?=
 =?us-ascii?Q?GtMHKCrhjYKRFlaqgDk4nOSP1ONaBJaPJVGm4PuKqpX29c82zQDDa8LvGr/V?=
 =?us-ascii?Q?dqoTCApOUOhXPngHV9BJrCkdrBKQ//bOc7+AOZbl07TZKI3nPmI1U6lKKesC?=
 =?us-ascii?Q?IYnDoH++/DnJbDEb4xsSOUGeMSiDnE2ueFWKuWjy7G6QRcM+GyIxBv9Bte89?=
 =?us-ascii?Q?aneGH3dMpJ42UjO3CrGq5sM6t7N406IRlOJNAC3X9/L0PedSXjAS4UFlA/JB?=
 =?us-ascii?Q?ei+m9j+gUrRGq8G0aQ9zrR7nWb5AfWIIeetWAultbdRAZDKi59W/Gi3GkSP5?=
 =?us-ascii?Q?414aS5XOh53e5jBgef+hZ07CtRhK9Ex1oJuDP0LtUEoJeniA+z36biqUD2DC?=
 =?us-ascii?Q?wuFSxpWkvPmJvC8e3KtwOCFyPUOTKOaADElXeuIoXVZljiqo/kST+SjZ5z+b?=
 =?us-ascii?Q?aGk6BJR6ZX6YqHAjNLH2aMaKLNWobwsMPyfB8LKsgyZVDU/XzWx1b43XJkbY?=
 =?us-ascii?Q?+g5L51tcOVH8RBXD39rltoCRCp+q2GeEK7emiWNu03lSjrs6BR0vkxkUtkuF?=
 =?us-ascii?Q?cYQrZfY520lka1kS2scFKK9hMMuO0MmB2aRiPx8F/vjy98WDowYFgLl4rAYE?=
 =?us-ascii?Q?fbbdHn1iy5Cn67Abt+K+5ztGWSFlYDK6KA2PgaE0YE5boD7/Pn3IJ19odnEA?=
 =?us-ascii?Q?pnGrFw+BOPgIUQJvXW/Y+PsvR9sWu1Pv9McvlTHckLAiOx/WyYF1CafNLvgt?=
 =?us-ascii?Q?i99/vGRA4PGLCACdiwkxhBAGdjPcKHIhktuR6D9xB3ozDCC7WBukXTW/I5Rt?=
 =?us-ascii?Q?5LgC6GzP4a0JQhfoHHtu47nrq4nQ4ViBXJu3y8EHNBiMWsP2Sz2gDILeLid3?=
 =?us-ascii?Q?4TuF6rBgpZyFCicqrttYW04zePbrjW0As1KTN70yc5NpWbeh5mGFJSnla5gJ?=
 =?us-ascii?Q?a+ob81A068/9yGiENm1uCLl4v8ZRlLTGBoYkSvATWLfVc1fsqL964SPb/le9?=
 =?us-ascii?Q?Eq0P8DoQhLU/pdQX5D5pvvZy+p0PvpXq7rRela7d4suuOmEN3NWqniYMWFH4?=
 =?us-ascii?Q?UhAkjpLBw/o+mOJRjDZjLUQr+KEd6xvaHuBfOf2TY05J+NBaS7nFYBUaOyu6?=
 =?us-ascii?Q?VP61HV3iOIGJzbdb628042cPSWmEjO8sEqBCvzfSgEvqxMgSJ0BGuEdey9SF?=
 =?us-ascii?Q?wMo3jmgmpg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1a3be5-c9e4-4b2c-979f-08da1d60dd15
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:29.0685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kp94A9eBOKA7SNKW/79cjHHlidZtZgb3PhlMEHHu1jP9nhjCdrNVEev6DYWAiGlD63IjK4HfZetyhH3Ag8seZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3279
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

Use a separate function for enablement of port module events such
plug/unplug and temperature threshold crossing. The motivation is to
reuse the function for line cards.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 9adaa8978d68..b3b8a9015cd6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -1148,6 +1148,28 @@ static void mlxsw_env_line_cards_free(struct mlxsw_env *env)
 		kfree(env->line_cards[i]);
 }
 
+static int
+mlxsw_env_module_event_enable(struct mlxsw_env *mlxsw_env, u8 slot_index)
+{
+	int err;
+
+	err = mlxsw_env_module_oper_state_event_enable(mlxsw_env->core,
+						       slot_index);
+	if (err)
+		return err;
+
+	err = mlxsw_env_module_temp_event_enable(mlxsw_env->core, slot_index);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static void
+mlxsw_env_module_event_disable(struct mlxsw_env *mlxsw_env, u8 slot_index)
+{
+}
+
 static int
 mlxsw_env_module_type_set(struct mlxsw_core *mlxsw_core, u8 slot_index)
 {
@@ -1220,13 +1242,13 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	 * is to be set after line card is activated.
 	 */
 	env->line_cards[0]->module_count = num_of_slots ? 0 : module_count;
-	err = mlxsw_env_module_oper_state_event_enable(mlxsw_core, 0);
-	if (err)
-		goto err_oper_state_event_enable;
-
-	err = mlxsw_env_module_temp_event_enable(mlxsw_core, 0);
+	/* Enable events only for main board. Line card events are to be
+	 * configured only after line card is activated. Before that, access to
+	 * modules on line cards is not allowed.
+	 */
+	err = mlxsw_env_module_event_enable(env, 0);
 	if (err)
-		goto err_temp_event_enable;
+		goto err_mlxsw_env_module_event_enable;
 
 	err = mlxsw_env_module_type_set(mlxsw_core, 0);
 	if (err)
@@ -1235,8 +1257,8 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 	return 0;
 
 err_type_set:
-err_temp_event_enable:
-err_oper_state_event_enable:
+	mlxsw_env_module_event_disable(env, 0);
+err_mlxsw_env_module_event_enable:
 	mlxsw_env_module_plug_event_unregister(env);
 err_module_plug_event_register:
 	mlxsw_env_temp_warn_event_unregister(env);
@@ -1250,6 +1272,7 @@ int mlxsw_env_init(struct mlxsw_core *mlxsw_core, struct mlxsw_env **p_env)
 
 void mlxsw_env_fini(struct mlxsw_env *env)
 {
+	mlxsw_env_module_event_disable(env, 0);
 	mlxsw_env_module_plug_event_unregister(env);
 	/* Make sure there is no more event work scheduled. */
 	mlxsw_core_flush_owq();
-- 
2.33.1

