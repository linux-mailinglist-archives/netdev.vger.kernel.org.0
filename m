Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05186486757
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240969AbiAFQH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:07:29 -0500
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:12352
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240966AbiAFQH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2vmFs/rxACIdSvV/Ls3oo2nfHJF6nWGML7RSObQUfiGrpxKOSy5H3YDM79GR7AMoqmWvLOAwZThIWF7VDeYRxAdy54JOg5bNk3jpON7c7iZHT7/otI7Mc/u1MTmmaQCtrhMUsEx/A95v4UI6Ix/mt0Y8IQwdw3mNNWQnoSaa6keexQ5ySIDyPoD1RqagXEsUo6oDCXPR8sM7b4PmN89/90SNwwhKK/5VNKXWcoTPdz5KxGwrtTPNkH5/0oU8SniS2m8HOml4GsP3F/C4nBZVHaeRStHqrKZ6Tlc9UB4bLV3e+D5qtlvRFaJ/ZV+3lGXZeG7ZUZVDeb6H7tKwSIUOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tkJDIhuS/iCCNTR/zf5IbAFpdtEslz5lCN5y/ffu3fY=;
 b=AIcxRRWBqpHFzULR+EauogpUM9FqQYXKkMjSycdRdu3mj7KJx0GXrB40L9lOq27byDrfaU6SD1GLADvohAb+5AoaQlLiEMwncic35UflQEMb2uw4xShy3o95prZqWZoGKzoQ8S6fPUF22ELUmdGjg3JlDjDsdMeCRPPnQroUVCETUavGn3oAbMNCHmuJRrbwXxho2dilRjsicORD9GRHR7/JGpo8pFQgcEpVCb68BzzGHpxHoaIVAHm26iqdQHQqfFYWaug9jkTonCKa5IaXP9E8xUqKicQlQLLp103emmwu5ZtpFfmebqGI7NmECUhj2qyrZCgRa16md39FfN2JUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tkJDIhuS/iCCNTR/zf5IbAFpdtEslz5lCN5y/ffu3fY=;
 b=al5tuqln+fWmBRQL9y88+zUIgKk41LOHvqxuNFOcoORR3kfvRVYxVsv0TOb43h3nTuorJnok5sSuA8u9lVSKNeOiDHMlPwfuc/4e4SkMIYVjFP9VylnBCMRzXIGbu5HcSsu0myh6WLiN/0xnnYi9C/lgMvByk/X4PVAEjsZ3fU8Cz2nOq8SaxN92mJ5ViKCwZQBnuqfLFBjv3IeDzzHa2fbBee5CtM4ZHW8kLRBfshVKoUO3iBeJQgJ1I18Em1Z0aW1DQ558xuoS1pEOp2U3XIlSfzqAk6+R5Pzqw50XrMDArXeDeLuhVvV7OCmBKbvxNZYdO+tlaSLNRP+vcXjVcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:27 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:27 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: spectrum_acl_bloom_filter: Reorder functions to make the code more aesthetic
Date:   Thu,  6 Jan 2022 18:06:47 +0200
Message-Id: <20220106160652.821176-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
References: <20220106160652.821176-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0021.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::33) To DM5PR12MB1641.namprd12.prod.outlook.com
 (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1872f7c3-1a4d-403e-528d-08d9d12ea280
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058B634791ED0E4D83B6773B24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4lJiXtNKRLtoIs147WFwOh4V6wJcquiROoHclauktj7cgDL0Dx+tfJiTJhGKVFeAWaKWMovoZ6i5a264CAW+xWjECYtwgjtu8qFCW7Ozg6eFXwGPIBWWeqmi/KAthsBSgyRS89/wADdeDRHqHkM00/DfQ4ZPASxs1Hq4ceImkFSBj9zztzFG0myarEkuozvkf74ffFGVEsxk2JDOgOreYXqADeVRyPizS2/Ns7TK1JrTPsxGIFOlAOGpAl+N9kxM/vQcZRIBDTuU3GYkEYv9HMR3C1Yg16prLyZsi4RurwZE0bEw9UdHvWrd0t3scYFDeNQ+/a6b2o+lG2KzEz6eXFbXGyGzYqGIoFT+YOYL8v8Isbb71ueTZNZg1W8WSsaxX/ntOEYT91dPEWLz3rCyJmd+OnmDf24yLyHJMFQI2xHDG4J0GNu89lBFylidqk0Ned/EoNRIFobZgyJByf9Lbo6rt55dIXWOzIKSRPvYPVI+RBQQ/F2+b9JwVV/DDcTFyOj6+XpGnSBc4v9Yuo4A7Hss0fZa8+QquWme788JArWUimJWOgesTb93+Uh836HPk7pE0C5aGpNI0c0lmDjyH5G0p9snWSydw26jG5ok+VynUtzgLLk6AaJwWLnCGyhBItAEpI44xWodaFa8ddTFtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(4326008)(26005)(38100700002)(8676002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CQGk7KhTBADbI2/CaC0atMHZtHPKmh5nv6+DFj+jWkMtIAa1K6iq5qPVCXd3?=
 =?us-ascii?Q?8tPdNeSCRbIrjWLQrxViWM7uXneI7p7xt3b5yqK8l13oeTQ4fm7xXDlxt9wc?=
 =?us-ascii?Q?DEY6K9jeksM7eL4row55JUULjsNXq01xgesQrenJ2kXklQYtSgbep2h9qvCW?=
 =?us-ascii?Q?etwsBzFEnGA98Ilh2qUHlKEY0sLUPYcxBHjOz2xEGM03rgig7w9nRC1XfGpF?=
 =?us-ascii?Q?T5DvH2lAdRjKKqLt3EPc5QPHord+tUivq3v+l/ldiVIQ+ZFdhiFkb2WQ9HFv?=
 =?us-ascii?Q?q44/sTSPPFT1MiNU1BPJqzrYSNkz3dmYCpm38zCTxGPBGmRc2Z0NNSqZQDRa?=
 =?us-ascii?Q?ChmjQmjPnnKHDi2EEysPJqsqmDmUA1y37JHinVa0Fd7Km/BlNcWxZrAiFFju?=
 =?us-ascii?Q?ABugIfkDE5CBwDdLCRVysp24iR7FgLayfbs3KRn8d+X1hE38XQ+eWvPlgmIQ?=
 =?us-ascii?Q?ASZJ9uGiNZ1zriNuHJnx4WjoeSBRE1h8ErNX1RHT/SR95t2lCHodGtPDAQG2?=
 =?us-ascii?Q?1+RRN8KC+GZz726ENeHuJA0vMdFrd4m2NIE51Rbt52N3tvN+Z3CXOIvyRwrC?=
 =?us-ascii?Q?JpYEynJWsr5z6Z4deQLZOmiRIjeiX24zsE644gsMj3pdH1c8n+kVeG72Xut/?=
 =?us-ascii?Q?0G8XLK0TNAtSn4SCDeqvOdFcMJkd2j54vJbdRONf8OZncDjYJWVNJ9tVJKO3?=
 =?us-ascii?Q?KEJtX6rBuL7sXUq1yJ1ATFeXNN0DjQL/CPiAeynRXUjVDrDJNgXsHNtbquWU?=
 =?us-ascii?Q?bG9qD7m+co2eJhR83r1tqVjyvB3M0tP+9xYx6vKp3Pm/tNlG5GMsJIsuxcX6?=
 =?us-ascii?Q?WqTZE4UoHjpOO2kQGX4XFuviH6HbbYulfkx/MbJoBJCzR1Jzg7NSIARkY7yj?=
 =?us-ascii?Q?nugsr6ObVkOToDyrdkK3ocbxLO0Scz7/4CbWIE95PWK04SlQizNz5QD9fhmr?=
 =?us-ascii?Q?uw7E2eIrhuG5iDqK9qxstPGEBPBElLrNGXN/uGDW60OmpBqQ4nLv8u5PlkEt?=
 =?us-ascii?Q?tUDlXUgpZ2qx7iIBS8yuTZTgfxPEM8h/0Vyjog6eXVg+0TrEAhymUMKxWkw8?=
 =?us-ascii?Q?kudVl1WQrID7mSDoCRVSo1rPg0IOHG1OJ99F3H/gAQzfefi4C2QlIvmxD7wO?=
 =?us-ascii?Q?F24XWEQy1HXFoj+wM/BkhfcQKTcLwUhkTly2CJLL2NDis2zx80hsTExoLcjn?=
 =?us-ascii?Q?9NySD95MdqCdzTreDGHCL20DDOnayNfQwwjZDi6/2Tu4HZSe3IkuM4sIYNPq?=
 =?us-ascii?Q?YY4NHKe63cI72pNbhs3lG16/M6XuHzVqx25Oh5ZYE40xagdy7zyVCKt/6J4M?=
 =?us-ascii?Q?E2ljj2yoMX/B0w6ZtyLJ0DGuTkmSEitPGNEw6Jw7owrlF3T90eyeJVrB7la5?=
 =?us-ascii?Q?BwnQpe/1/7at5nGATaK3o8BLb81a7Iuf2X1GK9s451p4vCJOp/W890oCxjlz?=
 =?us-ascii?Q?ojvvbKMITdVrsJS5U3jkPfi0lR52wTRm9XJh8Nk+EHHqJ6F1qllIq+NZzNKq?=
 =?us-ascii?Q?50jkNuUN8srd22jEclsOuwsKRNAZGhnijQY54q7zWNrv4d+mTmK63xIPD5go?=
 =?us-ascii?Q?T0zUn1lPy2lXLHoKmur6ckfs3LnfbrZwbsiU8wv+tfo0dFZa0JnmLWMht4dn?=
 =?us-ascii?Q?TizktyUmuPr5e2v9gEtM9ns=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1872f7c3-1a4d-403e-528d-08d9d12ea280
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:27.5905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vmt7p3cLJxG2VqYsWCcnAuFIm99Ldlcoootn3YgXRlfQ2KcyQ/fzXCp0W3zHpMTLF9nxTUx5haKvFp6R/2fJ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, mlxsw_sp_acl_bf_rule_count_index_get() is implemented before
mlxsw_sp_acl_bf_index_get() but is used after it.

Adding a new function for Spectrum-4 would make them further apart still.
Fix by moving them around.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_acl_bloom_filter.c   | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index dbd3bebf11ec..732c261f83cf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -142,14 +142,6 @@ mlxsw_sp_acl_bf_key_encode(struct mlxsw_sp_acl_atcam_region *aregion,
 	*len = chunk_count * MLXSW_BLOOM_KEY_CHUNK_BYTES;
 }
 
-static unsigned int
-mlxsw_sp_acl_bf_rule_count_index_get(struct mlxsw_sp_acl_bf *bf,
-				     unsigned int erp_bank,
-				     unsigned int bf_index)
-{
-	return erp_bank * bf->bank_size + bf_index;
-}
-
 static unsigned int
 mlxsw_sp_acl_bf_index_get(struct mlxsw_sp_acl_bf *bf,
 			  struct mlxsw_sp_acl_atcam_region *aregion,
@@ -162,6 +154,14 @@ mlxsw_sp_acl_bf_index_get(struct mlxsw_sp_acl_bf *bf,
 	return mlxsw_sp_acl_bf_crc(bf_key, bf_size);
 }
 
+static unsigned int
+mlxsw_sp_acl_bf_rule_count_index_get(struct mlxsw_sp_acl_bf *bf,
+				     unsigned int erp_bank,
+				     unsigned int bf_index)
+{
+	return erp_bank * bf->bank_size + bf_index;
+}
+
 int
 mlxsw_sp_acl_bf_entry_add(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_acl_bf *bf,
-- 
2.33.1

