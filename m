Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A72520D6E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbiEJGCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiEJGCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:02:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E842802C1
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSCYvhSdJ/ZpYlTLmcywB/fs3u9wx6qMh8DQAELhltRcKa7zm5tbAoJxBjKt2j7jP6QD0wQh97/JjC2yyAWOHdPSHSoN1HS+gQxnvf0S0Ndc2weSDCRH0eUiQHbDvTzPzR/PBetkjNCusn32gMOlo3kwegVVa5bJcWaf9yDDrVjceDhu/scnsz74papdUlST/34k8xw9ZvpFlezqZ+VA7obvCGABZR0HyXQKWA1CR/5+NC+NMvXGLxvARH5/eUGeUR5aHOtUtqOiI+s8sH5HE0AX8Trx/pZLsv7srahQIhAHs6JVa6yAgHVHhn7TK2Rj4q0GjXz5HdSWf2zaJxaewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jw84ye+AzNtEBK4kfcLqo7Amo2JSqBzSO+Ps5bYvseQ=;
 b=dMHNmMUJZJ8fb0AsDSiZTTaCKqSykqculFR7QLFLJgMJ1yh+O++zRdbE63deNdaWdrgfChmexrZP3hYBt5gvHEX26+s4ps89UMfqmlcVChAF78oLovVeL5IGGnR5YOrSX5qYLW0PbDfm/jRf93HGw/+GtTMrRXw1EF9mRN20RypoCY3jxnBN0oIqIVcLyGJWLwxbpIUpfwK2MW8OiGqkl8cDm6IYrRoZLtglEMWFKtJ39ACW0r7mv4W2EEa8aUZlINy3ZSm2xbLR2NE0Ma/Rf8M41Ip9ka4x2RCUtEvsc59ZTgaH5s3vUAjydS5f8eSnLZwPS4euK9HmwQ+belnnkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw84ye+AzNtEBK4kfcLqo7Amo2JSqBzSO+Ps5bYvseQ=;
 b=bI7DsSEYjVW+IXab44Clz73p5CEgoAb1MTr4rhg9uBjQm3DPY16wsUpWKwpFV/z0qGXVLbf/FR4euNOwzY0seqx+8a8v1CBrWigaA8V5u6q5d0BCKeYWGq9ptrPkwTw7YzFY6jOvYwlfSfWGO0xvZZmr3U/ALOMMMXFRQXZG5FIYa1+DVS0mTWxACheERFIQJcibjmtcUZzGziXS9PlgMmsMJY8RY9QeBrePl5Ko4wVd1UAduu+P5np6embXKaWZOFbfvadqQ+Y4a1+TcIpBhIau+gzOiY41wnzk0tfYSEhN9oJq3XAlpL3rbPh5zYl+8HrbnUQzcEgRvLARfxRIlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:10 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:10 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: Lag, support single FDB only on 2 ports
Date:   Mon,  9 May 2022 22:57:37 -0700
Message-Id: <20220510055743.118828-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0143.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::28) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21ac03c7-cacb-4e39-7890-08da324a0fc9
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB6383DF949CE1FD408BDB564FB3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cADeTaad4Ut1GvKaORuqrpJLgSLAVVfnf6V7izEfzdJuBpNztvYxB/0ZqKFCwRyHdsl1Q7h02VTYFNrD+/eytzmabiMb25Mg7gSM92oUJiWO2dLc73iv8DN3dwBSJipznIKhpBKe9G1gX/AguGRCM5KZRSpfs4xO0Mrmk36ZTpY+NvonLvnmIkpjcrxmdYIWoiDfgc0gc57IWtAhvWvA7tcFI4qSzKLclF+IZSaqArNmt1M19FGC9/PEcnGwBCqL3ynUCo+PEioFpxdd3Vwrdj0H1thZ24WN2E6xJPeAw0Ce2wIv5KHAAKbDbHj3e0TXZ+F7+PNHVVenk90E62VGbw3ONgT42gdXGhVBiWaRBr6FNkySuO6Z54soLky145vAP9h/eq0jKFC7XvBsy+dX4dMmmOojAhmfI7bm5BhuXp+5U1tdbr93MRztWhzMGPUQ/4Exn0VUIfKLPmUfcSg3SFaRV8wCNEgvAVuhRfKBZ7WyCUhuaRKMD6cvo/asXsPkXMCc1gYy8ion1Knn4s62tN1IAgfT/32fgNUY0DofKyN3t1tgQl1PjfVSFjSrb4YQMJEYXDjvdox4UyHxWLcu02N0vMbzmHBbuctqhbJmmPs98G2buqo8CBRnGsD3QYKHBS3kax1YzU/a6H5ti2lR+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CWtzEM/H5ywTzrlQvZr+y3X5kB3SrZdtP3D/7sAFkXjVW168lNlSu4aFSDU6?=
 =?us-ascii?Q?fZBKH1fjehcHvQ+cKHl2Ihv38vJ8WWFT5kKeZVNN1F3MFnh6+UhKIpXjDB1v?=
 =?us-ascii?Q?VvE47Ulm/D5xH4fcGoPjjLPST445CUcDOYHTEspCQonFdOOZIEVwkGGtAwT/?=
 =?us-ascii?Q?R/+wzjXIx2br0IneCak7Ex5VVki0zFDHiUzJIOSf9rwLfmhQGP6CU1ysC1KX?=
 =?us-ascii?Q?3yzm9l9fpF7KhuBxA6z3AvN5ynrRsuZHCIuaappCOiPK5Ie+5pefdqxvMwyx?=
 =?us-ascii?Q?PuZtjKtXwTU8FarcZ5cOck2qLxmwWtnHviwav4aiTLCd6dHxYUhZhXfG5PFB?=
 =?us-ascii?Q?nWe5Sv1b3zaGcKqRaUq8d89e2gQRc3e94E3zN+JXQ7G9Kd8HEzCimyNqEbLy?=
 =?us-ascii?Q?qPeH6Sd5bpX90DUwz0ZvBfbIzDyuN4EtUrsY3uY88fNwy+LcS6Ij1ZuDRzC+?=
 =?us-ascii?Q?9HrL1pJ3ebYxDEXoDsATeUlIKI0KbIns5MGQ91jnuF1QYYLTYAAT+LPhlMcP?=
 =?us-ascii?Q?GVGEC2p1Cr4GnkpXW0qrRktgOLa7AvWqAKCs9ASI7G/pcHLmgRLFQ6XB57CI?=
 =?us-ascii?Q?dxhPBeUxP8IXV/qzV4+N0T99O75tB+GcxW5oxnfIjQjHLiM+V0WFhddjRtEL?=
 =?us-ascii?Q?zD5F3WTFrUQO3afv81x5dY3/Ck81N+nE3DDZDGq1AzcU/T1vwhjh/q7Upvgq?=
 =?us-ascii?Q?auUaz+Euz2zkL1cgqWC+hhKFZ+Nnun3fC9xAKRHHlHpFJtetsn+6d9fu+AS5?=
 =?us-ascii?Q?cZc7NZemcGsb8Ej9A1VnO7a42UsTbYwFHGYj6MpMYb/tur5TsJtUkRtE5Pi1?=
 =?us-ascii?Q?Y8SsIfjc/0LN+obPbw4qSGf8X439EBJoyLWUm/VvhXzhgS2b4vWzxB8Ow4O7?=
 =?us-ascii?Q?VCOqaTi12P/cGt7fXIPEfyD1yUIDRyQRNUeeXEupWEyIaH7xfR2zVJx0CHsS?=
 =?us-ascii?Q?+RuZt7Q+bO0xzoBJpzsEvpnwysm6sG8xVzaLjd1ne7ZiXyaawSGj6YgjCdxx?=
 =?us-ascii?Q?Oqo5HAHNSErbR6fTzt3v03PeBhcChCvGoJQVeW9WDVYwEgOMLrwI4Ekpr/Vw?=
 =?us-ascii?Q?7V6dX/nB6alwsEG6y4AX/pMcLgtqr1epcnl6AWQM5ZfhYeLYTyVHymYO6qwj?=
 =?us-ascii?Q?xRFsXwoWET84vljGgddNqRuGd4SCeyvPeMpbQQhY99Mo1ovj2PdscRgeWJ6a?=
 =?us-ascii?Q?pEuPdV3mvSUl+iKJaExWPXUWsiSKkBFICVqK3qMqndaZwMhI3/H/g3o9GNdA?=
 =?us-ascii?Q?gZ39XCw5LPR6noWfxXVHBjX8wOAg58lEN2L0C08QJxolvyhn36F6/uF7URkS?=
 =?us-ascii?Q?ueBCW3OXcbw7TtcrhF3VIpe/OuWWb7RXJiXiDucrk91agRSSkJbLL4WK57nF?=
 =?us-ascii?Q?vl3FrYUI5W1DAehiKISSHvSaQMAg7ZjbGMZyD8Bv3WO56UnVtaRCLoAsFSbG?=
 =?us-ascii?Q?KrwNWvqcD3j69an74a6xm5AyQgdNwKWJm6VpQqfVhzT6oz9yNVAvLk9HnzYo?=
 =?us-ascii?Q?JP0cbdL0HKRzXVDODTQlDPA4HeJeAHk7hXeobzd0xH14qZlV60sQW+RtRtpi?=
 =?us-ascii?Q?8viRnVBXPJO9SisbCykxETaIfa56SDso9TxzrpeE7NRS6KNCkV8kXqsijyxS?=
 =?us-ascii?Q?0BjsCG/zEiCS1SbZtQpdoFXwSZzgysbX3r21C5iUX0ZFStqD1iOljujMmUTk?=
 =?us-ascii?Q?HZVichbZvN1PoDz6jZvoW19wQ6gpYxkUwQTwKd+fTxiwd3hcWmpH0NOxkmac?=
 =?us-ascii?Q?nGgMqGz/RYIKPTMN8iFoSaUmUpkbwfLoF55TmOyRgZzlXjhg7FMr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ac03c7-cacb-4e39-7890-08da324a0fc9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:10.1739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoSN5hW5XrfqaE3hkLLEx+szLsKxQpWffdsJ/L8ovSQ2XHW585nvrzTwT5Q5Qg7r+QXyEseEE4PNWkr+9ULoAg==
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

E-Switch currently doesn't support more than 2 E-Switch managers
being aggregated under a single hardware lag. Have specific checks
to disallow creating lag when the code doesn't support it.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index deac240e6d78..4678b50b7e18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -458,6 +458,7 @@ static int mlx5_deactivate_lag(struct mlx5_lag *ldev)
 	return 0;
 }
 
+#define MLX5_LAG_OFFLOADS_SUPPORTED_PORTS 2
 static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 {
 #ifdef CONFIG_MLX5_ESWITCH
@@ -470,6 +471,9 @@ static bool mlx5_lag_check_prereq(struct mlx5_lag *ldev)
 #ifdef CONFIG_MLX5_ESWITCH
 	mode = mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P1].dev);
 
+	if (mode == MLX5_ESWITCH_OFFLOADS && ldev->ports != MLX5_LAG_OFFLOADS_SUPPORTED_PORTS)
+		return false;
+
 	return (mode == MLX5_ESWITCH_NONE || mode == MLX5_ESWITCH_OFFLOADS) &&
 		(mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P1].dev) ==
 		 mlx5_eswitch_mode(ldev->pf[MLX5_LAG_P2].dev));
-- 
2.35.1

