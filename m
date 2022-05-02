Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB49516C80
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 10:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383891AbiEBIyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 04:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383922AbiEBIxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 04:53:54 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BBA113A
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 01:50:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hI6iisJ6LSENRgDir3+It+5Csj8eWplNusqSDEWHha4qFl/24LKr6uJLccJTxtAf5rO4zIchNSbB7fl+zv6rNXOahi86LlQaGLwHo0sgZnbcAFlecFoFPqyJE29jH/1Sk0/ttJG8TEHMdbK4FRDF1Z9zYfsoRFpgEdLIePeYahJSBsYTXjSe0sS4STooTMYhPL0A74eE0lIBFeffJ+OrvCWAzrvYFLi0AhAVx4Zv4e6kqKLmo+h1ZJH3hk0wCP9FT/CVBPmNsKhemzRTkGYfM9gtWTahN2LXqrvPxFO+9r6ahr+4OXGNV+w7rhVkrhT+QnkUuAJwfrrgjfHj1w4jXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwZ6yTExTFrb6v5mOuSE1XFeubM1MX3myhEoDOI8Jt0=;
 b=U1X8XHeKgrurHZFn2SdoYaor/BG/VSbh6EsA8WM2Jkpjp5OhdgB0KZWl6a88dHczuyOCph0NeFQxwxvAhX0rQgr0naQJ1RR6crqvp1zALA7iDvhu8fTZc9cP8igiONz84i+LI7zMdICp5p+YxRL2ipAmTki7MbOWUwPImQuqzm9tJGPsCNw8ORq+I9h7GLoL16NUZzZtNpyJykkwlRfVIEdl7w0DO8PL1ovO5qqH+YNrHkifhLhx6xrs4FZgkmDB1fCLacPleVeCQZUgjE5KxdqlLlsEjCHFm+TUlDFNVChfI7aD05G56b9ipKUJtEgzkEQuyvf7Kof++JCOmqb5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwZ6yTExTFrb6v5mOuSE1XFeubM1MX3myhEoDOI8Jt0=;
 b=XpBP1DP/LAmsgN8215SniXcyOBfTpr0TGF//MbuL64g6DIeEZkCSAOFpOdBD1puuTYRw5mKfLrWeM12r9+ZHl7zkIOezS5mN4V8Rmis2UBUOXcRkiiV/UOIQvHeJXwjEMlCJVMNbJpDYrI8ztQ4dcGEEf1t+3BBbaNbNGtS61UdQppMgeSrMP6ApY/dfMgEuZv81KFRkeaQgYERkoDUgWjNI0O69aVzXNruvV9tjrHohpJqc6lW52DU/2kwIh24usKarwG1UjREKXzI+Ub2hayZnjuqUWxuqvNjv9PxIdaE8tA7RXkqkISVmRuADTd3ZggU1Ly0USJhchb5um/ZglQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 2 May
 2022 08:50:23 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5206.024; Mon, 2 May 2022
 08:50:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/4] mlxsw: Configure descriptor buffers
Date:   Mon,  2 May 2022 11:49:24 +0300
Message-Id: <20220502084926.365268-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220502084926.365268-1-idosch@nvidia.com>
References: <20220502084926.365268-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0243.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::14) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de74be3c-5b77-4763-18ed-08da2c18cb9a
X-MS-TrafficTypeDiagnostic: DS7PR12MB5912:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5912AA711597F9375DEF760DB2C19@DS7PR12MB5912.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qm+YUvfIZJMAJwnbNd7zax/HbgXLL9qygzE3pVbzrUKxbdZ0rQFpjf81o4SgLriKX6f5XEvXyR7euVzJ5vt9hlueDZg2B3fZFr6H0Um7xtSBMgHLiGt2mVwileGwnWzOTcJvcOkY2IG/IKAz3zbz+yRfLB6GbgqUpguSSoMBt5Y4uuiAKYZFZ9GHnoZclmnynyQpN6SCsNMhYvjPARbpuLvF1y3cvK73LJ6Bqrd4ZuncRAcfgXUw++Q1t4RHWUwVQY2RbXW+VhvFLag02HAnfx9D9YwpntMohOZF2vbhuv/TqQZYUqJBgkYy4ggo68ivKm5G0N2LiOwnyqUtquQX2nq1Wr2X7UW2dszAqpL4oHUZUqFlB5UweCiFNJwreec652y97hqLRfOEzhxPk66FLqk2adezKygHhc+6NJZRsoDwb1etDFExH34Gn+fYgPg+eTaQ4u4GFbzIB6oaL4ieVzvx4s3TscEg+NRyQliACx2oRPZRS6qnxqC+HdeBacb3Cw7Zn73X7owFtcClqarOuIjgSd8wiW4f8ygIPVqdZUVVNyogccPBz2JnzzC7mCRXCxAnlnBdP05sQuE3jh6s7GMHUztWih5gLrXLv4yIpD90/HP2zdZmADTOHknLgy00vh22ow1veDEDUN//Afsf2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(6506007)(66476007)(6916009)(316002)(5660300002)(86362001)(66946007)(8936002)(508600001)(8676002)(6486002)(4326008)(26005)(66556008)(83380400001)(36756003)(2616005)(2906002)(186003)(107886003)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u7c6+pY5R38SrTN1pGvIDVkMebkUs4LCQ7F1zMXZhZTQupBDSUPArScvqgky?=
 =?us-ascii?Q?5HEInFLZp7MV6nmdiXc7/T3XInaPDtCyLT6UOHn9f0G1V7u+cXypR6u79eAV?=
 =?us-ascii?Q?s+CZchiCjRoOAUW0NvsNrsaVWET2lrr9EYnp1dmwzvjKVEF92kAR3zwrJz8v?=
 =?us-ascii?Q?0xfIrgzTLqYE8YVLrIBzH/hFGp77msoEh/xjGC6WdvmdPG7qPcfKzUTv2NS+?=
 =?us-ascii?Q?8IO71xGhP8KcqPZWqb8jnjy3PMz/JEIe9DaJIG/X3ug0ri5dW76Xa2qyxKvg?=
 =?us-ascii?Q?Wx1sUt8wrifYC/BowRLR556JrCOBcbvxZx3+Bcmqgr4zm7SABEUrpPLDQpau?=
 =?us-ascii?Q?VxhajUywY3SJJ6T0X7D5WTHJTA6o5oD2A1st/CHkvs5xb8nRqoprbYp6T6TC?=
 =?us-ascii?Q?HZa2J4YnaKWq/jAsliaa5sRdJv6jow7GwdQAs1dVx0e0U+AEaAcZD7oZhTYR?=
 =?us-ascii?Q?NscLlKhADbaX89HEEX4lvGQ1J55ySJwq01B1ORAA5UGq5fJ1xurmuLkJkqK6?=
 =?us-ascii?Q?t568KHpjinDRTuOsCFf5uq9qzlFjnUm7MVmw8324XVU5T09iOQeZ6fwgAM6/?=
 =?us-ascii?Q?tZF4QS32F3blk23hcYv1BwPrlJsAYaZVZCfz+rpBluovnQ+8fW0mydchW87c?=
 =?us-ascii?Q?N+uc5FgyBwsY/3l6VEPnaMWC+1uH7AtGfcY2Oz/B+LCC2Yl74Ks5K3QnO38u?=
 =?us-ascii?Q?QGS6ICxxK+KOHc3HMI+J6deZHe/WT5pM9O8a1L+1i0s9B05msHSieFuvYjxJ?=
 =?us-ascii?Q?H9NFyfAYjJuU5GHF4JjpCe+HSXPWfNb2t7yVr8Tn6NltBmoAvdaPAwjkoHgh?=
 =?us-ascii?Q?Av9x4UA6LhcIuk96gIm4Ou5127lbZKWLK0l44vqIr1FvJHdPGKaZTBZl7ltc?=
 =?us-ascii?Q?m2/1gZBNJC/0buaQNcYhEa1MuJIsA8mcos6r8lEn7pIZ+U7FxoP3g37vHsU3?=
 =?us-ascii?Q?NibB+x6Pqn2plYsmIaXGj+USMo3Nju8VdTQQNjcngNKuh1+4vwiLWKCl+B5s?=
 =?us-ascii?Q?XXaih66JPJ6Fo+h8gAK7SEjt7FZVrxBmDSwEZvxHTFREWvgusUo7AGxBPuI/?=
 =?us-ascii?Q?c5K+KY6BRFJwxq5yHcdDf6g3r3XKLXX9f2UiYHxIKazClv9O8xMe5ax8D7QD?=
 =?us-ascii?Q?BCAPRnxnQQAHH1GZp3r5rrE9YNS4gx0inRCZJmmaLoTESBFwLmizCExljfx0?=
 =?us-ascii?Q?qV79KcfqVYK54b9shsY/BUe57ig+NkKcLxgwP3vNmJHqiHdwWicBz/jP0kIV?=
 =?us-ascii?Q?iIgIQYSQ3Rp/gxSZ51hg7Tan0qRidxP7FN3HjTBdlgvU9lFdAY5FCCnI9utK?=
 =?us-ascii?Q?hN1v4mPUeMMBcaWk1Mrg5vVfbQu/F+SDXWSj84JargXbRADRS5PVBCKS4dbW?=
 =?us-ascii?Q?h9zVtrFDkEI2PUHU19h2KkVw5BcJ2EMKdAVD3XwNIgF/scwFoFN/LTOmbBBb?=
 =?us-ascii?Q?/pZj/yWE6eK43+UB0gUbo99knbsaKhWwexxY40ixxMpeNtH+NRN1lOnbzHii?=
 =?us-ascii?Q?zv8NSWdl8ITQgvE75oKHjXsPlOZeawmg41EjJok/dnq9n4ICksmXcaX0GMGN?=
 =?us-ascii?Q?eMDt2lMFSVdgUUV1wEJC/29VUHZfJzB8tE0ahohHRGAAzz5G05RO+n8EDLUu?=
 =?us-ascii?Q?MYrAdAESWLgGVjo+lftuN3pF5atsEtB/KNGWvpaTtrPDLjeAMFXpI7hZYTAk?=
 =?us-ascii?Q?pe4ZdLpGllu465agU1+pAUkagDEFioIsJBdbqQxN8er5SEf5cr9V+CpKOVA6?=
 =?us-ascii?Q?T/NnwnrfTg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de74be3c-5b77-4763-18ed-08da2c18cb9a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 08:50:23.4150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77pX3ECs3uzBi32kmY4SULbdFGZBjc7MdJFjT/wxo5qk7hAsd4zAPa4nvAs/lbBKcsGLtPQ4Wl5DAWQpnPsokw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Spectrum machines have two resources related to keeping packets in an
internal buffer: bytes (allocated in cell-sized units) for packet payload,
and descriptors, for keeping metadata. Currently, mlxsw only configures the
bytes part of the resource management.

Spectrum switches permit a full parallel configuration for the descriptor
resources, including port-pool and port-TC-pool quotas. By default, these
are all configured to use pool 14, with an infinite quota. The ingress pool
14 is then infinite in size.

However, egress pool 14 has finite size by default. The size is chip
dependent, but always much lower than what the chip actually permits. As a
result, we can easily construct workloads that exhaust the configured
descriptor limit.

Fix the issue by configuring the egress descriptor pool to be infinite in
size as well. This will maintain the configuration philosophy of the
default configuration, but will unlock all chip resources to be usable.

In the code, include both the configuration of ingress and ingress, mostly
for clarity.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_buffers.c         | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 98f26f596e30..c68fc8f7ca99 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -202,6 +202,21 @@ static int mlxsw_sp_sb_pr_write(struct mlxsw_sp *mlxsw_sp, u16 pool_index,
 	return 0;
 }
 
+static int mlxsw_sp_sb_pr_desc_write(struct mlxsw_sp *mlxsw_sp,
+				     enum mlxsw_reg_sbxx_dir dir,
+				     enum mlxsw_reg_sbpr_mode mode,
+				     u32 size, bool infi_size)
+{
+	char sbpr_pl[MLXSW_REG_SBPR_LEN];
+
+	/* The FW default descriptor buffer configuration uses only pool 14 for
+	 * descriptors.
+	 */
+	mlxsw_reg_sbpr_pack(sbpr_pl, 14, dir, mode, size, infi_size);
+	mlxsw_reg_sbpr_desc_set(sbpr_pl, true);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sbpr), sbpr_pl);
+}
+
 static int mlxsw_sp_sb_cm_write(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 				u8 pg_buff, u32 min_buff, u32 max_buff,
 				bool infi_max, u16 pool_index)
@@ -775,6 +790,17 @@ static int mlxsw_sp_sb_prs_init(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			return err;
 	}
+
+	err = mlxsw_sp_sb_pr_desc_write(mlxsw_sp, MLXSW_REG_SBXX_DIR_INGRESS,
+					MLXSW_REG_SBPR_MODE_DYNAMIC, 0, true);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_sb_pr_desc_write(mlxsw_sp, MLXSW_REG_SBXX_DIR_EGRESS,
+					MLXSW_REG_SBPR_MODE_DYNAMIC, 0, true);
+	if (err)
+		return err;
+
 	return 0;
 }
 
-- 
2.35.1

