Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547F757F3EA
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiGXIFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239779AbiGXIFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB1F13CC6
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZKQVcxGLbDFUSwqvFmTh7uLVOOLlkXxu0mXXvqM8tOKdKxLLZx1clk90ZjHEzDdpCqmnprfRtXKbhYbFQacQiq0tJS9ERYyEpVflRfP5/xn6chXMyoWkNTU/BMyOiGT+c4OqcGBXSr7xhH/VWxi7s6jaP8bH0YLOnpuLeCpzoOVf2oyRqgb3kMPVtDsuBMrp5dWwfGUZx7EzuHaDRzIvPAEK2iKJ+uMh3DOXVe7SinRZ0h02TqVl2E8cAA9C28cVPFiOh6CvFsOT+UWOxLtFYnvlOcPhDHaQRbZmbZ9cnE5uyA1Qgtt63uHP7KnNZ58egz89Evh6jOOmjNKjYQvTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLQjoPRFDMvQkcmVbDZUR0AUA5TCILhv8AIQ82ZPcqw=;
 b=DFMpu/O/BBRI9Q9T9JAGVWIEd9ysVP0sHhLNf6VZeGRpz2PU3z1CWNyMCpgMhEFAmEzSL7PL7rXb5dtbHDmtQLA3bldKNgQk5URlHRjcOT+dHKm32GzHDXg7r0FBjRWPX7wKjEepB5c+fD45emx6yjou8jHINBBJwHce26i1TgK1bmE8uwwjX8HshlR4z/6sdUl81YOP3Y+kRWWgrCFXfpyKjfHP1yDM6OSGinaY2XvrG9P+zICXw0sBli0BFjnTRF/HYHDJTl3wLJWBIAuve1iHHYRmAbi7qqczNyLRRpzpzf1EYhx0bE2RQMp6zDaA4v02svf9SB/jvl55A02MxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLQjoPRFDMvQkcmVbDZUR0AUA5TCILhv8AIQ82ZPcqw=;
 b=X0bNWo4hpbUedLC5KJPXhDQEAiup8EOQ4wbpywRGM3I2r+MOjgJHWkTUKZQiP1yKEqbfUr8Qpuo9MYNNfjgqp8MBLRlXc5B/VRti1yyWS/CApbPWqFmu9xkniWpVA8gsA4EYxkr2FcKmRjV5gbdDyWC9ozRUNvApFsoyms5RQ/7h7mH2YigIn54LtKDlpiQQ5r6EA5SXmaFcYHLMgJ09ZDMrCl+2BGN81gmCM306OoxkXZFIH2XlsrnU1laksysGHhVa0LIVquJQhk7uC8o4/cNuX6OgmG2C9t6OxLF/StlAijs+ldveSrHbcWp/AEBzZv8TowmeAQqMq13F2Jr69A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1915.namprd12.prod.outlook.com (2603:10b6:3:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Sun, 24 Jul
 2022 08:05:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:41 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/15] mlxsw: spectrum_ptp: Rename mlxsw_sp_ptp_get_message_types()
Date:   Sun, 24 Jul 2022 11:03:28 +0300
Message-Id: <20220724080329.2613617-15-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0638.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4a12a36-b867-4e89-dec2-08da6d4b4d25
X-MS-TrafficTypeDiagnostic: DM5PR12MB1915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pgrlN1p8cbvvoMYOJd4b1rsu2/olMiNlWwV/GVWNMyle1cYDlrliTX2xY3pFZ1fxObQeJzwp6WvkFL/fZKE3w5iIrQzaQc9xUwQta/CSmdF4iJCjSsOUnDTsQuTyWaNqhbjIdcM8HUuYtJkrdGvQBQwAm5RpNt31DS2KdxX3uqW4kHPynMjcXM4ANY+1m5SuBZL4eSr9iBvgKavuMjqcNJVv7k55bk7MJzs9E6Ti8q9pc0pJth+/qn8R2dyn2vXidA+qpGGaYHIP0EMsy64fjTITxdpkomXgXVVUl3b051viXgLtzMks312x+iEEmtjYdGgd1GBtc+Hvj/qgFsCJ86OSjHZLk86nNbF4ffOtpcbViLlXmAGKp2dUJk1u1F7KGFg5H4qodKFg3t9AAkH2Tp8OeK+Rlcz7fvevZr5agnNblykHm1vUMg/Yx0ICKq7oRzOdYtq07o3xUlNThvgsHKKBtbQFqj0ZsXMkmTgxkWfU477KEQ5bit58XbINWzWMa/LEuoke0+K/icR5VDhFIvhDuJTfOvQzBqf6eC9r5nJRAgsIDmiyw/4eV8K6pgkach6wVSoj82qfUezho7r2U3MQMBwHk2+DGJRNTnn4n6SYNJLzFOGRC0iz7AVrgKRUtTtFfCOSiXu21l72A86+OScI2dT3tz8Lzi7N+jjFqyGYeqfl1KAncUqRCp0UjNViURUbagQC/XZo6wwhPra0H2Rt9EGH6HiUUgM+94rMb7MiZhNsy1DNQTyC81zHrhpqs8se3pudJ2zq9oemPTSFPBUZiSL/dcMWfwbnnbP6Yw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(316002)(36756003)(86362001)(478600001)(38100700002)(6486002)(6506007)(6916009)(6666004)(2906002)(83380400001)(6512007)(8676002)(107886003)(186003)(66946007)(66556008)(4326008)(26005)(66476007)(8936002)(5660300002)(1076003)(2616005)(41300700001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mbmaTNs32CMuRk7IlE2DwRkoDpBkN1f63MF99JBl2yKev111rNsL/WWAiqVM?=
 =?us-ascii?Q?E4T0/YaU8JOnA/3RWEDCzDgT8mPJTSHQtVRaiNrCyJ1nEcS0a6AEE9oARbuk?=
 =?us-ascii?Q?5rC2j1NPL9HgjtdFEK2dOend0xnFXEmWea4HwX8G2MoHjBJ8RqHtbMbeld8z?=
 =?us-ascii?Q?5tEL7AatGo+zahpEXjshElgN3eM/zUAb7jaElGPwU/YRWYCsAThbp+NmVtpi?=
 =?us-ascii?Q?0WqG9RI+CbmKu3/EkPENl+ZhJ7NlZbFuYRn2tLC4mngIWtOxVT5HBV1ZLUF1?=
 =?us-ascii?Q?4ADGLwzXFntUXUKNAiZle32M5zP4YwbOF6XuLSz/PUhFm/FV8ZQzcTmOlNKN?=
 =?us-ascii?Q?xvj+ZdTcUbdaRp3Par1yqzUWa59GfucERHNbR67JFv9W0pqZ2v4xBrbNaAuW?=
 =?us-ascii?Q?P7f4KVBpc2bWf5ELRyY4/Of3Fa0lCKM1iWu8hPU+IHgIZvg+EZ/zoknlTr4y?=
 =?us-ascii?Q?1JD6GsHSp4uvuGxDf/Sjuqpsc1GcoJ72WCy3atZlBqmDe7SvcP5iFzcpn/gN?=
 =?us-ascii?Q?Yp2MyfDg0LOD9oWWuMtV+U/MX6kYd8g8APEVT6fgo/yRMPKMzNPTDjDwZ8yc?=
 =?us-ascii?Q?HoL5Ig6CZwQ+Fn8wpyLLcULQJUWuNeF9RE6xkBhJfhv3M0iH7bxoXzvDzcmh?=
 =?us-ascii?Q?qS5sqkRxFhVjC6qIlF+xsgc43NEaOx827oxZiTj1BjHc4YNd0L3q661AQfXL?=
 =?us-ascii?Q?aLv4oSqDv6PIAdBEZBz4//8iqhhESK3JKgLYQ7xdcmOn163jRNKDPyJ/ZJEp?=
 =?us-ascii?Q?zSzpXgJHW9dmulb1ZauyVgHQJQF4lO0jA2WrJnstW36alVhK4CzOlSWElIEb?=
 =?us-ascii?Q?xqRMxx/nZx2B9bAGL6i3ykdaNFSuVPipZ30LC5E1QY2Uo5yuprVjP+3I/JhI?=
 =?us-ascii?Q?7m6BRv7zKeZ/EQ3D5ZvxACY+ch1f9NOHgG+o9e+Z/7mxcAZ05NIIGb5PyzLN?=
 =?us-ascii?Q?22Ibrr+H2MU4nAI0wWBgrl46mxFwyeV1IfqQYS1PHk7bAwqrjEjPXD+bt3fk?=
 =?us-ascii?Q?oUYeVwBI6mX1ZRC0RhuF62HyMCrb6ZrNMy9gFpWbfGSyRBDiJ+M+InHFR27q?=
 =?us-ascii?Q?0HSLFovVNnXg7CtcM2zVpxDvA8MuRKrdCYPntaUmjSa8mgqwCUGBz9nY5o8l?=
 =?us-ascii?Q?X2PkeZ3yUyI5Jq8jRS6ZWLrpTYwDY5GVEB9vCawFD061MuuAwT+yYrF7cWSx?=
 =?us-ascii?Q?CEKm01viZ7JEMGeF58uhfQM0hQ2KUwLfD2N8ZfM9VmGGzMPM71e8d/K7gYlh?=
 =?us-ascii?Q?ZVoyPBP5hzlFRNjGJaN+/7ai/o8dsgotfllwgLvlzs35Ghd2DxwkMSt2y2pS?=
 =?us-ascii?Q?Qkw1TjCN260V0fnuV/+dnRs+egZbk3pMoANQUTZHLx5GsvmuVYkqUiHZ3YRA?=
 =?us-ascii?Q?/2GI4t2T0cnhpT4UKm1aX6YCfFODXSIo/S4wv48FJRl5/uJkpc+R5mrhBfft?=
 =?us-ascii?Q?MoMf/MV9pXkrDTE/dgEL35iRsyB0UH3q/iwu8k8UOa+L+DLPplvQDiW62pdJ?=
 =?us-ascii?Q?ZdehuwGXpSxBFkQ9mhTayFDPG2GbZ1qD37NST2gSNe3LrJ47K5YD7Wgm7wS1?=
 =?us-ascii?Q?kCQAyjnpMZkJmjzitWOuewr/igexAZJgj94dIYbZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a12a36-b867-4e89-dec2-08da6d4b4d25
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:41.1742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NyA0tquyRFzz8/XhqMFg3OJiz40qHdfk9LtFwYUnVfI7L1IOF65SB+61PQxHKVv6SfPpPteDwSKN/Y4o/MrF9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1915
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Spectrum-1 and Spectrum-2 differ in their time stamping capabilities.
The former can be configured to time stamp only a subset of received PTP
events (e.g., only Sync), whereas the latter will time stamp all PTP
events or none.

In preparation for Spectrum-2 PTP support, rename the function that
parses the hardware time stamping configuration upon %SIOCSHWTSTAMP to
be Spectrum-1 specific.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index 99611dcc5474..4df97ddbf5b9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -918,9 +918,10 @@ int mlxsw_sp1_ptp_hwtstamp_get(struct mlxsw_sp_port *mlxsw_sp_port,
 	return 0;
 }
 
-static int mlxsw_sp_ptp_get_message_types(const struct hwtstamp_config *config,
-					  u16 *p_ing_types, u16 *p_egr_types,
-					  enum hwtstamp_rx_filters *p_rx_filter)
+static int
+mlxsw_sp1_ptp_get_message_types(const struct hwtstamp_config *config,
+				u16 *p_ing_types, u16 *p_egr_types,
+				enum hwtstamp_rx_filters *p_rx_filter)
 {
 	enum hwtstamp_rx_filters rx_filter = config->rx_filter;
 	enum hwtstamp_tx_types tx_type = config->tx_type;
@@ -1081,8 +1082,8 @@ int mlxsw_sp1_ptp_hwtstamp_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	u16 egr_types;
 	int err;
 
-	err = mlxsw_sp_ptp_get_message_types(config, &ing_types, &egr_types,
-					     &rx_filter);
+	err = mlxsw_sp1_ptp_get_message_types(config, &ing_types, &egr_types,
+					      &rx_filter);
 	if (err)
 		return err;
 
-- 
2.36.1

