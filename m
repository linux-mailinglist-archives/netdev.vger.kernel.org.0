Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADED5520D6D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbiEJGCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236907AbiEJGCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF5B266F34
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzaJzghTZe5eb+4Z7Bk5HaoUsaSr2SFYGNpEkfyHk0VwIgJoZ8rX8p4SfQuI15w8k79daUhwSVTMUexVhbK4hxddUyJElqVWDrDnFK0dGKoD9RncqTo05DLPbjMAVP2fwl8NZ3GUkcnO1+2+clBzxKoU0WqNfo6kBvAwd6DVMfBX6rFuIp0jpkGgGR8Q4i+sSXUka/94S77xdn16++scFbZEbgsPVNMTmqzig4ezThTQ25adHdhbWNrv3VEXNa3mUX1QpwyQ0mLv/7oZyLDH5FMCiiOcDWfPvXh5TJVBmCY5mSkae/mlRSfY3kikYfkcl0QlMZD7cg5b+zj2/6+0cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ec88Et5msL/uJJLrGwM4PHw/zPlZ4RuLtWIYJ6XM6sg=;
 b=EoycEui95YComvDRIicM9JcRLR120N1LYheDnyV+8ssFCABibzZ2drRyEgfqERU1KMAxZh6QVFJACdMci8Ug1q2zl7M4uM4A+qSHyFrExGLIJu9Z57WFjgtYRFnsOjVguO7ywAPpPAXGmnME72WDm8jmxi/qjICIVDKciS1W/rz55KBxlhPQnd2FxDYy5eAmmz3O3JZOo+xqXlG8VE2EPYJs39rc1SJeQCaCy8Dog1bxKJyUK75249Ya2yj3j7aUYFu7dtRRIpHreTHyGjXUMucyItkGIPd65WPzIidV/xphXZhmGsV0HqMvmdrJdxKJ/VgMDoi++kRgDwrmn7HEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ec88Et5msL/uJJLrGwM4PHw/zPlZ4RuLtWIYJ6XM6sg=;
 b=gujmJCN1Je//OiS3W4zedCmbVvi3mX4O8JP9w8Pajyial9iPBcZFCyGcAxXo0BiY6/575W8MbMaz5WZ5U5Q0nPECqvTk1OSMINJy2uNFLH+f41Y1dH2MEtyv21X8jH4VNPgDHY9s5Mt3HFICWJ4VKmF546SZLs296ZFNJ7Ch/oRALvMsMnuCjULVOoSEmgRPPOApNNJ+fjdul5AyEDr+4wkfA3DM/brNaED5BRkLC7iZIGExk88fIDmDLQBbSP9MdvdP+2BGfUJPADBnalMZdY/XR0fAoxK6GrMIAQW5yrX8T1w5WLJljelzl88NOUTk8J07QJiVSrFiwKurXA7+BQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:08 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:08 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Lag, store number of ports inside lag object
Date:   Mon,  9 May 2022 22:57:36 -0700
Message-Id: <20220510055743.118828-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:a03:114::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d472f375-2fc0-4b14-59c3-08da324a0ef2
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB63839A10E0BE831F804C81B3B3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OfGc2Sibip+4zdRI2sdSsJRVojJKg/M4CxQ5+IABK1WpYkYt1GW4PtOlYVZNli7QTUfi0YZH90obgc6auZYEr8MaTeNH0aOYHZVvYvQ90oG1L+i6sKWmYd1OVGU/CwW2dlZL+5KnV/x4k215xOKUNhp4HsO5ATNbALMvt/RCmcCZz07EZvFk+4tDRrf/mtqT8veTfG20cwIz6KGtBAIuP/LdFxpiacLA3gG0toc+rbjjlyvApiWst2DVXDzHaXZjrNyitW7RyYbQEcKPL9DW7G5SSKBFim/TKifBn0ci4vIrfea1jZrbW6m9qOXYkmFOrTAPjCZ3gwq1xUnePpNt0s3NPyTuxTol0UoneuJoFrklYvwd/skWHA0o1qDCdHVWeUueN48cN3Lc852Vl08lB6AknZ/C7ZQaVA9DpCfTaEt8KmbvWT7ktiQrg1IP53+gZ4bmhQmlvaUDxvrMB0APsW3P2tKCCDWbTYw18EY1cN4y/K5zEQf67+saxL0ZLPXYfbvN8YUtCkSGzmW7FDFfLV4TgrXk+Mz2plecxFGclRzts2ksIk+lxa478wKl0BOVG1DoTqkjs7MP57Px2cm+mlovUCNuZdwLRtzE0TIS7dHB/gzMz0XDnq+cyjl3QUMa7QjOeJoxdPktkw0mo29BZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8oeMiAuisw/NK0nAXtGZH63bikVm2kM15Os9LGD1ScW3DT272YDoli1xnyt0?=
 =?us-ascii?Q?M/1Pn5NYYaPL0pPt6tNkNbYi3rpTfunde1lLiEHaLaJH7Ob6O20QNHl5hBbx?=
 =?us-ascii?Q?q1mU+AJAxLaLHLjUgCDWUXVocc/RP6lP5jbUjUC7gSvkGn2KOd6qTRLKwdt+?=
 =?us-ascii?Q?ZA1T8pzFTrmfmiAY+Q50zt5+0IL+HkD9xwiwzwYdGNasvKIEAzIkz0A6OoLc?=
 =?us-ascii?Q?iI/nmlHF1boe0ZkHFov6ULhBWZI/A+S+HXPRzsew4psWl4btP5ynvXQ3tEWF?=
 =?us-ascii?Q?u1znhktME8SOWT9J7O/qPbNf395oKk5AU5gpZcNDndj+Wc7EcYVw5bS1SJJm?=
 =?us-ascii?Q?WGpTanL74Hc5bEbnR9Fietf4X6dqhJ0vFStkMWiMO2AI08Hvvw2wDVB6kpto?=
 =?us-ascii?Q?OdBUDtCLl/AOkppmoFzslMLmHnyz28Y9kLRoQ0c3NPzp3bHzuJ+vz1MGCWm2?=
 =?us-ascii?Q?o5dtahPbIxjD480kJL4rB+3D4OmHm/KNZ4xaw1FNGJYc9i/TYFzAp0RXJa6u?=
 =?us-ascii?Q?I02pJ4baGlfApBjkNX/qyEbPrXnp0Q2Vm6wEJwW5hF20fTmGKcb1F6Atw+dO?=
 =?us-ascii?Q?QB6m0MT9/y5VE22kY7sI4tp7+EmPkiLltecIA6QCJ6RqO+GxcCi+k3x+j0Zp?=
 =?us-ascii?Q?kFb9CdSDZVVtP5sNFTrD11XkJtCpF1vLGYFkf55nDdZHJ4We2PrtN08nYXi1?=
 =?us-ascii?Q?2nHVEWMANn06TKSmES4/7408z5G80rQwVPz/XENthlpMn2v60ExsZUJNhrO0?=
 =?us-ascii?Q?RDzKZAd+dvwNTT1QVbW87FNbyoinEBPw/fZQrARCeslR1IRetlxFkkD3mTrQ?=
 =?us-ascii?Q?ZgHe/y1JigVNDdxx2xCD8q6nVHUzCgrq3FfGRrbFIt2dTQIP3fYPc9V8xUbR?=
 =?us-ascii?Q?Mxz+0qoo3KCsiI0xmIcygeili5naej9H/OYg75Gvp2gKKNHK2bXeVc4x4Da/?=
 =?us-ascii?Q?fYEdmXi7BcUTlrYAL1xe78FMC1cb56qsUapd/yo1EQg2xQTv3O2r9pp6JV6S?=
 =?us-ascii?Q?GDqijTgs/jrk73pvjgWjLR/zG8sj8Nmv58HObr/vXC8A/nQWT2KSv27KbdEX?=
 =?us-ascii?Q?AGfykAEtgz4kg+j37ipdJpC4BuUsZwVWhcCSXZ1jX3CsC3KOYzUPM0H+gxxG?=
 =?us-ascii?Q?MaTbrTptHJqq5Y641JjcWO7rlWJNhsi86vGrMav6tfQQto9bNG76Z4B/FVJY?=
 =?us-ascii?Q?0HViRdAe3GpvvUPzSh1z50zZIkpgHBUCdnNBU28QzTbVzQxb1t28BvaUaZZ7?=
 =?us-ascii?Q?z5/Kfw73KaJBHqI1IzrjQ/LMbVC/YqVVd/C+wI25Kf6hvoJ/7PGkbRLltlZy?=
 =?us-ascii?Q?saKWVndrN8UFwaKB9GN3mt7ZeFz0R+YNhFhxQE+zB3wVkAjyZ3h1uUUhqeZa?=
 =?us-ascii?Q?JAcpYxYW/DOzMNjEmqiIPIqfUgiEaYO85fhv3MxkmDFBxctDfGmyCeLeO2f3?=
 =?us-ascii?Q?YTUI5YZ5AsdaPyrB6IP6gcds3TVg1MonWfMHaPJZ7dkJWuiPZqnfYcVq8x0K?=
 =?us-ascii?Q?L3iWqJYuNQuv9uzCacmXioIwvY23VrlC1PRHbDhnZc56nMadTUpokgv+F2wz?=
 =?us-ascii?Q?cdiswFCkteLbFPmNL4bMzZHi/UIMEbw6lVtu3GoBOn6xBmn2VRN/BVx/qGKd?=
 =?us-ascii?Q?ssdcWxX5ZF588K65Qtdtqm+G6h0tZfZtAL4LijkSoErM6zeTmjCBrd/rkOc6?=
 =?us-ascii?Q?nNt3qhzHhe6ceCkEMXhXXq+ucSi6f0EHfZ2JNuaIRxjzBW+0T6yZ8c04dZiG?=
 =?us-ascii?Q?WdG+/JlLBTSM6G5OjUKxbLzyIPtC/ccffXwJRQ7viK/6XNMAckbf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d472f375-2fc0-4b14-59c3-08da324a0ef2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:08.7485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XY4R5foaMpJo7GsqNEEpuNQHxYZ2+5tYGf4ezHiklw5ZkT/eozLJypppVOnxPdbiHIdRnaWfPhBcP1Twf+8+kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Store the number of lag ports inside the lag object. Lag object is a single
shared object managing the lag state of multiple mlx5 devices on the same
physical HCA.

Downstream patches will allow hardware lag to be created over devices with
more than 2 ports.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 360cb1c4221e..deac240e6d78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -164,6 +164,7 @@ static struct mlx5_lag *mlx5_lag_dev_alloc(struct mlx5_core_dev *dev)
 	if (err)
 		mlx5_core_err(dev, "Failed to init multipath lag err=%d\n",
 			      err);
+	ldev->ports = MLX5_CAP_GEN(dev, num_lag_ports);
 
 	return ldev;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index 03a7ea07ce96..1c8fb3fada0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -45,6 +45,7 @@ struct lag_tracker {
  */
 struct mlx5_lag {
 	u8                        flags;
+	u8			  ports;
 	int			  mode_changes_in_progress;
 	bool			  shared_fdb;
 	u8                        v2p_map[MLX5_MAX_PORTS];
-- 
2.35.1

