Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7DFA4FBF87
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347338AbiDKOuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347484AbiDKOuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:50:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C7A22299
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQZpUut8cnGrUpcg6QDEssJw9FPJUKsKtpGam/zCxsHeVFsx70QdnvIWn3v5CekSeE1Z44QHS/nm7I8JyT+BbKzIhx05nHelsNYY+9E7n+28Thy23zVAlmfHflSUrCvy5BZ/ZPI+9L0IZ8HbFvL/ZmEj92BvgxmQPuqi0CXAUuSvj2xcZaQWyT9eo4SXDIoIaYiGkoZCYf/9TdPeYx8X3dFu5ze7LZtwaRdvRVb3HhKAEj45pVzWlkMS+jT93pSCAhQj9B4bWH6R5Arg+XaL1macCFcgWjfA735ehnaSjM6zlvGzWVe5KKJEggn8mIsLwou41F3i9DNNMsqPd01rdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EW+bRhSALEwzV3eGO/uU/tVWngJXZKtt4SoIKQGpJW0=;
 b=i6e7+jb5heJUOTDB+Dem52uScX5zoWx31nwh1eQVO3woMg0DCYSc2TrJcwnmHZdKtDO0pANdPzKs54M2MBqb9ilytmGHDr9iSYU5/ny3K8H6n4OAU5jcqGcqrLBOVmSlqr+Dohzbk2CJh2LPwo+KB58T1Ozy/oJZxswDPSBgFPsFc7hG1OFMKmyX2ibFgMOsZUOwUHnpL5KYtdS0uC5ugc+U6iQlQCp2QoCVFGMQmCK8I3F9YmbMLRlJHCTNuSfbDyWw5rOveSaYjGVsj4j+n9VjDmLq9tElLKi490ptCQ9+hFE539XBPUfuzi7EbBYVEIGDjA/dbBDDUxnJeEPamQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW+bRhSALEwzV3eGO/uU/tVWngJXZKtt4SoIKQGpJW0=;
 b=Iz8ZRxoc4kvCumdVZCIZ8vMp7Hr01K5uiCzl1KyD9V0YaM5yTXkBXL8CBUKepzxivNVHDrl1rDSJta3lUhxUgAIkWBYkPQtw3rbaXrm2czfMsqjOuyr3Hf0qPisDSprS1E9BNsLqbF8jAh+5MB2GXLskjElMaC5z5HHQSYYSsUDKOrfAadVo59f1H214NjnX/UWeo8bAJAIySjAtbxtKP7tYkgsyZ5Go6pH91XF6C6Nz7aGowVHYDgXiyCO+YNrLYQDCXeKAdHCo8uqeWtv0I4wlUuRhxZM7wh1MxTVZzAKYyYaGGJ1xaojtEs0UGwXhzHqvv9DEAwMYbeMANSWSsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BN9PR12MB5067.namprd12.prod.outlook.com (2603:10b6:408:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:48:07 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:48:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] mlxsw: core_env: Pass slot index during PMAOS register write call
Date:   Mon, 11 Apr 2022 17:46:56 +0300
Message-Id: <20220411144657.2655752-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0101.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::16) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61572d4d-07af-4cb2-1196-08da1bca4a6d
X-MS-TrafficTypeDiagnostic: BN9PR12MB5067:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB50670FB7CA72307CC0B278A5B2EA9@BN9PR12MB5067.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CpmeBN/XqIfnUY8nc2jdWUldEorzPHx3Z/26CyauQ9KN6T6k57zqMBMZw89DrGTOnqucdyB5fQ3V6EGl+oxqtjDTXLCPXMeYxNqmINR/8dhUTL/isF1VSWwI0KT849viuP9Dc4XIp4VCzIzdwSK5ZpdIsCiMLRv+FPqUqz4blGyO8AF1qpsVHuf/B6qTbbGtQ+np6/jdNFZD/3ipYErsJOD+plniaelgYT7BrpKQ+GiY8KG7tmdYSLHyeKETpOjeAURnlBYD7rDFsfc8A78e+VJiVX7d7lHsPgtCiX2cxVd0Y6ulapIlEI9g01qUEZzNCejjTakc7s3ntLNEMmGgbvhuGciebuNuV8d6iuvTKaHjP+bsIWG1nRHhxF+uUYXjWvbH27o5H4mF1eF6eE1uyLLg6SSR4twnC86nh4Nr3lCzz7RARdW7A414Mh2YPFx/zO+SS9cplfogmbb7cLThGRFJs5l1nON65A1uXp2lzNIkg0FJiG4YB4q5Go3ZCcMVbftM/0GPFmHhLy3aM/wdz4zDsR0maGZ8LY/y00Nt2Y61fpBo74fkEgbZyresaH1Lq7BMJFzy5C7gSDK6n+dDZwRt14uqhcwf8rrjXUQDNBOet8UNuJnlmf6mSPr8QoAU60YjKSrD4rijT/IRKYjkEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38100700002)(316002)(6512007)(6666004)(6506007)(186003)(26005)(1076003)(6916009)(6486002)(508600001)(5660300002)(2616005)(8936002)(2906002)(36756003)(4326008)(86362001)(8676002)(66946007)(66476007)(107886003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iJaTmeW9x1DwTEwvre7y+mXkRYctibnFRZIm6C1+lGQmPiYpRMcp9+BDDnlu?=
 =?us-ascii?Q?NRUHPwC4EMxw3hgxxtgm5VaMLMnLnUfjbs/EV2yMqaSaOfhcj9ZE/r6FV8Rp?=
 =?us-ascii?Q?bqPr1sBv2UW5P4jkgz95bEVIl6zDED9yYvtofUvyC63FhEH4i1k6Qcsdc8u+?=
 =?us-ascii?Q?ZY8KGU4EiPR0czTMCmR1JDIHle088bckulRJoGXCxE0Jbqay/VIXfoAakXyk?=
 =?us-ascii?Q?zgKsHQWnddgtaDhLUN47NP/SHa5Jz8fm+sRtLS0yReTbzL1C/1jmq5XUS2u+?=
 =?us-ascii?Q?jaSeGZ18x/MSGcAboxkY+LBKKjyWRoKtG4J5CzOEV8YOYtjALyej6r1FN9TV?=
 =?us-ascii?Q?A+SYV8+ndUp4wAYoGz/Ey4kJ9GZumdLAYlSU8SarlNLMHRY9DEKonPTSVPq3?=
 =?us-ascii?Q?kapyp4NWSHuuFFxlY6HICZSfiYyVzXMAVLBy9JIBMb0FphoQQGwANzzQj+Vs?=
 =?us-ascii?Q?B6eLoQDO3uawmvdaR5E+GKPjIy5gmM92FVLK5vd7XcuRBJ8JRDS0hiim9OJN?=
 =?us-ascii?Q?oE4pDnDFIPgoxP8fAqUmZV6zY4CdlFVw8O1oqJgqeVYUsv31qmzUXxlqQ7y1?=
 =?us-ascii?Q?i1fahwPYAcCf9lzxK+JM3+gKpceI2rpZix7W2F5XqaJfLld3hOvKLd1Qfi5M?=
 =?us-ascii?Q?cgQjeFIN0VOor4yHmaSnNva8L2tjOltP4x4gqzgbhqlM8+wHZCKzgCUFB7z2?=
 =?us-ascii?Q?i/nt5eQa6Nl3IHgvmem6fwqe0JZ9utVZ40NHAtfutWdCEX/yxeOJAuFvyRAf?=
 =?us-ascii?Q?1VBZWpc+LotQsk1k9PwZMLwU8tj7ZShXYCC75Zi5WR/YfDUVDLm7RqewqKLh?=
 =?us-ascii?Q?8QFmwFRmTV7BhD4IclQiCf6RwogqhriA0QJEcvoxjRcf1hAUVdtMA8stS+LZ?=
 =?us-ascii?Q?GKJ1wIaOPPUSE0W+cKRTSe3K4t2PJTk+utnk92aa74NSj/198ENZpxpvHGHk?=
 =?us-ascii?Q?ySeGMO4Y/QdjnCr2+I9FCKUju+Yli2+zDbYVAn0PfEy4gM+xxwp7xDDDDumr?=
 =?us-ascii?Q?eGGzAoqbaNjYtDzTNWBJUd1y/x/YCKY5hrUNkuuoVMvH8VqVJOfo7vhpBFGB?=
 =?us-ascii?Q?ykQONvOYHJSb/qvQh/rJcU+VK3DPzcEBmQ/akiL0Az3v6Auia1zdNwiE5y75?=
 =?us-ascii?Q?lN92zjNQiVCOb1C8KN2niic3uoH5ZDBIXkFxliSaanFY4bfVRS6d8h3QQcVL?=
 =?us-ascii?Q?Ow0xiFrcPTWUJaEjbMtHKgv97bRNVVGxNfXU8oZwGJAaGp7tjMq2JBaThzgS?=
 =?us-ascii?Q?TtIgvxIakJ1O7fFC6FzWLXpK40lENT1YXU+XYxxKS61Sy18tTDocjGzR6mWI?=
 =?us-ascii?Q?SA/QJZQuVa6JaVVi1Tex9Mju4QEbAANYmKj2m+/7qhYCX8VEo4WB0PV5JvsN?=
 =?us-ascii?Q?EYtLn6q34oCAZOnJmFz4nArC36sG0gkrz63GUojS4MYXJQ2qqFZJPFFyu6oH?=
 =?us-ascii?Q?hZb+xy+JZdkr5hO+JOFROwM3UKC5l7OxzAt5YSK8h/vi6zU8A8MKevBEmYsD?=
 =?us-ascii?Q?s19BdXG5ORQHggoizTcGQ0WrSYCXrDuWN0BzC2QkK3+8+y8RHQ5eEaA2YKBH?=
 =?us-ascii?Q?va8+Z2hzU8AT8PZmX1Hoad33npfZR2B0n0sfzXbXhbeMRjYCpjpl2jqNB5z0?=
 =?us-ascii?Q?py6lFOOjiYXVu95h0dN3Lh2jXE5ZG7y4Uvt6LpptzffdD63CO2FuKO8UEzfg?=
 =?us-ascii?Q?sMn+RObVdeI69nN1IvMjJ/0Elzp+Wnd8Oxk63D0/g56sP8qQaOqsOPStuUrQ?=
 =?us-ascii?Q?as+/9Q31bA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61572d4d-07af-4cb2-1196-08da1bca4a6d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:48:07.3145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcuEWZY8m3fWMdj/9hkoyvAzmFHUCLdAtRtFOmUYECfgKcbZZK0t7oVHSQ4dQBlR0LhIXcB/OWgN9EJnQZ/PrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5067
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

Pass the slot index down to PMAOS pack helper alongside with the module.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 6 +++---
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 8b4205c098d2..f1bb243dfb8c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -448,7 +448,7 @@ static int mlxsw_env_module_reset(struct mlxsw_core *mlxsw_core, u8 module)
 {
 	char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-	mlxsw_reg_pmaos_pack(pmaos_pl, module);
+	mlxsw_reg_pmaos_pack(pmaos_pl, 0, module);
 	mlxsw_reg_pmaos_rst_set(pmaos_pl, true);
 
 	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(pmaos), pmaos_pl);
@@ -548,7 +548,7 @@ static int mlxsw_env_module_enable_set(struct mlxsw_core *mlxsw_core,
 	enum mlxsw_reg_pmaos_admin_status admin_status;
 	char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-	mlxsw_reg_pmaos_pack(pmaos_pl, module);
+	mlxsw_reg_pmaos_pack(pmaos_pl, 0, module);
 	admin_status = enable ? MLXSW_REG_PMAOS_ADMIN_STATUS_ENABLED :
 				MLXSW_REG_PMAOS_ADMIN_STATUS_DISABLED;
 	mlxsw_reg_pmaos_admin_status_set(pmaos_pl, admin_status);
@@ -931,7 +931,7 @@ mlxsw_env_module_oper_state_event_enable(struct mlxsw_core *mlxsw_core)
 	for (i = 0; i < mlxsw_core_env(mlxsw_core)->module_count; i++) {
 		char pmaos_pl[MLXSW_REG_PMAOS_LEN];
 
-		mlxsw_reg_pmaos_pack(pmaos_pl, i);
+		mlxsw_reg_pmaos_pack(pmaos_pl, 0, i);
 		mlxsw_reg_pmaos_e_set(pmaos_pl,
 				      MLXSW_REG_PMAOS_E_GENERATE_EVENT);
 		mlxsw_reg_pmaos_ee_set(pmaos_pl, true);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f0c90e66aa32..03ef975a37e4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5769,9 +5769,10 @@ enum mlxsw_reg_pmaos_e {
  */
 MLXSW_ITEM32(reg, pmaos, e, 0x04, 0, 2);
 
-static inline void mlxsw_reg_pmaos_pack(char *payload, u8 module)
+static inline void mlxsw_reg_pmaos_pack(char *payload, u8 slot_index, u8 module)
 {
 	MLXSW_REG_ZERO(pmaos, payload);
+	mlxsw_reg_pmaos_slot_index_set(payload, slot_index);
 	mlxsw_reg_pmaos_module_set(payload, module);
 }
 
-- 
2.33.1

