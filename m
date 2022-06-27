Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D1B55E0A2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiF0HIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbiF0HIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:08:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FA55FAC
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:08:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kliV8QVGLWw1wtwOy0MJY1jyscAmkZa3B+ru2fJH4a+5+FIVFJun4jKNpnknlfwoBnUQyV1UbnnIuUh6igOLPxWftupB48BT4UYnHHPjHPjVRK3MHrgbvqyE8Nffzu/H1Qn6a8eYxhCdmVnukJvXVr4tCmwwiU2AHygFicsgTxX1K/IMSIHrB0LMI+EdM1H084SP9S7uVlgz5jU3PbFbdrX3jdbAWybJcDR1I7/R2GOjVTmr5gERg1g87SFaSu22DwtEcHvz4f3lD3g/e7DsM+j8InFd3Wv8lpko5hWokbPS/VQ13J5CW6eBR77c/5PPN4XwvnY1f1zci1+Gw182jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttOxS3jrfSLitubt5oIDnDn+fGYMGbpypNX5vlLuOgY=;
 b=L4vCkMAgLM7kTC4Ug0cptHpuKyJCa2ZkDPAWKvmk28hNU7mkC7BJRX5XXJyYBuHp0eNNj771i0Qgp8sM/i7qtKdOj7EcajsCeDQHhHGu6+8qXwnkIyVO+BJtovfsb8kpcFoO7Nsv65zb1tOoEt9mjXrng47sjaf8fhE0IsnXnHJts7sqwG+/BTGNCVl55t26IBbADsezAx3+gyLWqtlc19aXT3dAnuUU2BPIPlq/uHgdPabBonEsQ+xrku5TLUS6POWWqB0YV8wpQiAUTQBaPEmU/lW5yzOScXYB4l8nWdjoyH+NLBM121xEuj3W0C54L2L3wP4tkAd+/MJZ1Tzuyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttOxS3jrfSLitubt5oIDnDn+fGYMGbpypNX5vlLuOgY=;
 b=AAfhAqQPD32/PAl/Y5mW4czkz6q82rZbAxIr3R/ixe0yOadeTdOu+kvzR+c2XzWwtaa4Rbrg703NPOcCuvtOFyEdfMsy6PHFcwM6AuPoHblCEqlTbgGAmgrnLPLZlCcB14ZHdcJH29pkNmBcEq3CoJA/1nfqTt54terzTxeA6AsX6kQ/rsu9iDYK/5xIYTKRtO0inZyuahKEf/Cd35rJErXLERm7bb9zGeLKLf6pT2RvulbUOuSK7esDGTjZNVowz0PEB3qkzUol1rMzgZ2qxBlgDQCPg3uNq7t44jerFWDVtQAwMTOc+wtxacnRvKR49+djfKr9Onp5Swv8Hqs8kA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:08:01 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:08:01 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/13] mlxsw: spectrum: Initialize PGT table
Date:   Mon, 27 Jun 2022 10:06:19 +0300
Message-Id: <20220627070621.648499-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ac05f68-7f4f-49a5-a4c1-08da580bc604
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4TiHxuRt8ftPTbzuJSDcbHnO347I44bWNBCW8LpwJKz+42U/MrN2YGIIp1AziMC6NscFwUij/W775614HV/cvl4C/QZVppY1NHF5DCrUT1lesL+T98JoQyv6mqgrvmzAm1+PZ7ZCkOTArcaZeKYp7d3cAMFRzZTREuo2EQ3WE+w2z27Rcex2u0NvzFqo8D8wD8v3ZoHeklc8pXpz3ymmnfNPjUDvOg8qcBQPIPvqsF0zKazDf5774Kc1F9DnbxXJ0mgU5HsooJzSJlSK+LZr/WnvjSzmh0TWiDGbCv7NQm8nSTlfWHA6tDCq/WXp8xGBnEpqTi/RX8NaFkQayc3bMfnubECM5oMnx/IzpIcKWdnOuevREPDl43rEDrOXcB34UNTmW4XsNVlhnzWoOwMzfzuJ51eFExIMrGav9qMjrRgHD3xj0/FZUjoN3FEXfTS8/YO4OKsD8ZpzyFqgYeeBBMS7mfY7TPgGNiHUvwFDzPqq951CnULDSJ53DykNda0OT5bAatU/tQV9ZHjMZrlf9zpNoYsbOWmEtq+5lSiKCHJ96fgdbxGs0N58DslYa/LdvRAPC1zXcizQV0AMSqblceLnQF2EJ9U69adAODOGO3EMSWP01zy1OIJFobe1vRZDdJIVy7R2OV3+uz6JzrOZ/hLR3aSoWLgM48LiwYy/Tq8xEuNTvzgPo/HZeN+2rYMCDjpENbsW2US2X07R+N99w9y9i5AwvpFUDprnN+ijbay9SqhBgH3AbcymKbYXEGt8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xs9SHS6Ld+geGhHeQDmrB4v/75t64Vr6JrxsBN+zoMtq/E3eQ9einRvyAcfj?=
 =?us-ascii?Q?IBAKUrnMfsd0nSuhEFscnsPy9dzGAKr70teTAZRUKTgwQOi+mk0e6WPxxzxQ?=
 =?us-ascii?Q?gofhH34DLO/nLf/i47daIvqc+SXoZGixOqCeKXpLR0iagO0EDDQLZqBiak6e?=
 =?us-ascii?Q?jXAQ8jYP/QisOg3rm/trs/3z8Vw6+k6n4YXpXPsRC81rZAqitQ1JXEiCiyh/?=
 =?us-ascii?Q?jgROkQdfYcZwLn6gXVACTdvjpRXoFJAcDdTAGcZgDQen4ukP/8vCCzrA+44G?=
 =?us-ascii?Q?X0PPPG2c/q4orXhFeJ9XRPgizcMHooFguNucspd/bwHZmFNjyldHkZT4eMW5?=
 =?us-ascii?Q?0uHQjNjph9rK3ghZqh0LsjIMwynLSBds8yrfMttaMxXTsghjv/Ck/2gvdVwE?=
 =?us-ascii?Q?Xa1t36BWn9H6E8egGUDm9bK4PAqJvqpZn4+MnADcJyMe6uBuSsgWcMcjtLsI?=
 =?us-ascii?Q?Ma+GIaeCYMlOepKxI4XYrgaLgJajYHS1oLfUqZUqPne2/V0vPCOyUDwyilZg?=
 =?us-ascii?Q?I2xpi91Lk91q6Ey7xkE/9In4tsuBDKcQNB0wipNQb9cjVE5AoDCGl74dC4er?=
 =?us-ascii?Q?kSwp/Y6rsFoYc8H46Pl48whEYQGdp1uDE5xIvr2a/jFaTkDyfqvMIb0XowMq?=
 =?us-ascii?Q?2kb+g1ycSNXLWHc7PdgqDKbVBUFC+6/3C2onJ/VZ5f+6Kx8xLBLoKtLlxmnz?=
 =?us-ascii?Q?7Bsy9K9RcsiopfNQptB8Tcq4iBNILN2oRXACLMcLzeMoqVXdiTZXJNX5K2Jo?=
 =?us-ascii?Q?6cu232KrHa5QOdE8IaSW6r4Ygk2yda2yI3U3VP/XTeowZFnipq4axZuSURN1?=
 =?us-ascii?Q?rHUu2nMgLw22wO1rPHv+unSYnxAC3JJ+wRS3iY1r0CLJ2QzLCN9SB97XS2Fv?=
 =?us-ascii?Q?EiMMTd97M+ZpRupJEygQCF9yh5by6C3JdpQEXc27oDS7lefk9ys8g6nlZTV6?=
 =?us-ascii?Q?RsHaf3fjzK2nDoE+9X3I6xJ61nC38BfKoi2fxuOOLLYNMrSy0sOSlxNkD8dO?=
 =?us-ascii?Q?xV6j5zvSDAE3VYKX5yX/MjwuNtkw4h6hoLAOraRzJGxoKhl+G9G7vBhqyUgs?=
 =?us-ascii?Q?sVUcmvpA55sAyWz3CbCYQyvEmKNBz4PhXyw63B9bwOfG0og8CiAxnqYVN4FK?=
 =?us-ascii?Q?/Zr9ppiZ8KtVbMBAExxGvQhIwA5U07qtq+9bxgV0r6zGeRoSJf3pYKq3lanp?=
 =?us-ascii?Q?pAWcgDn3uvdJTRim39ti2ymvDIJWP5dZoSus6gnNk88KdSJIgScsif65YxJ1?=
 =?us-ascii?Q?2f0oRHoHi54PjYFAvuU2BO+X/W1xWRa5YkKoC9vbbj4+i/eI8SJ6CfjPHzkE?=
 =?us-ascii?Q?dDWwaMP8QMk2erAT7zgT5EvhDqEXWB3aI100tZcdW1D74zySYMusDNANMfXd?=
 =?us-ascii?Q?I+ktEaA/HFXfKX+WpGeVFskaBU99MJvkmXxrKlSiXy6VUH0fV7pylL3JX7JN?=
 =?us-ascii?Q?a8vJ/TOR6RtZvEcC8/Hvn/vAqhhcYdpX8smiRV+JU4dB2HlitUD/xplN+uWy?=
 =?us-ascii?Q?4HYq2NsmWOfEjkxDiTVpy6cXWqdNcnHd7ZtQ0+OSdcYTcC/r7352vFjBrG0W?=
 =?us-ascii?Q?8ctXN/dOLIMsD3J2nCd2KwSgFORhraWQ1w2CXzdk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac05f68-7f4f-49a5-a4c1-08da580bc604
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:08:01.8455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NyNE775lGRCYrys31kNw5wvpbpZNHKe3+w+Dsxvq2rXf/X+ifIpwadTv8nVBABMvCkgBKH9K7GqQ1JA14ojoRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Initialize PGT table as part of mlxsw_sp_init(). This table will be used
first in the next patch by FID code to set flooding entries, and later by
MDB code to add multicast entries.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b128f900d0fe..ff94cd9d872f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3010,6 +3010,12 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		return err;
 	}
 
+	err = mlxsw_sp_pgt_init(mlxsw_sp);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize PGT\n");
+		goto err_pgt_init;
+	}
+
 	err = mlxsw_sp_fids_init(mlxsw_sp);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize FIDs\n");
@@ -3202,6 +3208,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 err_policers_init:
 	mlxsw_sp_fids_fini(mlxsw_sp);
 err_fids_init:
+	mlxsw_sp_pgt_fini(mlxsw_sp);
+err_pgt_init:
 	mlxsw_sp_kvdl_fini(mlxsw_sp);
 	mlxsw_sp_parsing_fini(mlxsw_sp);
 	return err;
@@ -3370,6 +3378,7 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_traps_fini(mlxsw_sp);
 	mlxsw_sp_policers_fini(mlxsw_sp);
 	mlxsw_sp_fids_fini(mlxsw_sp);
+	mlxsw_sp_pgt_fini(mlxsw_sp);
 	mlxsw_sp_kvdl_fini(mlxsw_sp);
 	mlxsw_sp_parsing_fini(mlxsw_sp);
 }
-- 
2.36.1

