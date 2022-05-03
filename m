Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4422517CB0
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbiECEr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiECErL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:11 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B003E5C3
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcEji94irQyybHIpFw8lMt5o2MrGYRWzmfqMHBCLgWRC7yjGpLgZcPVgdGh0r2slzEe29s0q25HXJSL17nJqPV+Y9HkJ+renFB0NG/nHkUtokNHpfTsbw4iLjXYZ2JTCZ0QsnzZWAQTs1BlOzuX5/efSQxrIcgL6P5z5YB5cQ51J0l7rKWymkgBN67FJIo4HDMKNm3t6R7M6QwNG8UqZ7/FzUGTV9Lb8P32wc23gsV0TZJ7eYZncghRjLGmEKnDEgJs5cy4og4/rABgZe2swso+FsCxLsxVMAqc4hDOCDy0xWkysb7grhJR3F6MlzImowGOv+StS1tLoZn/0FJy17Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2p3LF2KM6uysl2Ve1Na8w8GlYQ+jK4QC7x1dwQ6pi7o=;
 b=fBxrU7JcBkWd+sYdRhD3UZraVzdKGJyI7jPVTN7qR/OTcAxRIglQIvBZcA4/d6JhIbEWWPQzZyCjlncwMFpWChKEognM4wQeSeZvcmffQzJs8O60xliLnVcTWaGYBveqUz191UwwwSfYEuzLco8hMYD0DqPsm/rWFu1/fvynKclxLwarWHiULAPdsviA66Lc+vZovZDF49jUUpRdYzLa3BAwRU0cYVwXNJIUo1wlzYSrhzhTZxBb2wn+wI9TmTE0kDlYHxBr6fcbh44mHw8tjPp9m5CCy136h4zWwDBGDeoS0u5LRs2eT3qNTRLFygaMe1pcTw5mBjTHqbmq0sv6gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2p3LF2KM6uysl2Ve1Na8w8GlYQ+jK4QC7x1dwQ6pi7o=;
 b=QaegZeuOCDkiI8RkYYKRLit+5zRcCE0pYEV7Cd7uqRJ+3UfBQK6HGonYEq3RaY54XG1RJ/z57NeyLHwG9LsJ0zctNof+Kb/CNxY3R75v8as/HTCr9TQzgy93ufpUwVxUMoshR17K9tTtOo0/6nX7ZIjlSJMVtA4VvWpVKczXTF5qFRp2cX23f58P1C7FhMoDs407vX+6+cQGYtjJbhFWJor0hpwpIwgkZzwssfAUsYjf68YT4e3DMz6ol06+UrA5DwAphzDzVE41LhNYfXrMEaZcjLxpF+hTRs2Z0CXINldKy4YOMvRsfMaS1ctxEm99eJr5HvSZ897cxlBIMDmf/g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:36 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:36 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: fs, an FTE should have no dests when deleted
Date:   Mon,  2 May 2022 21:42:09 -0700
Message-Id: <20220503044209.622171-16-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::33) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 579fbe8c-6ae5-42ac-8cd5-08da2cbf7c51
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322448DB64D97B6E7D9EBCAB3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYmNkCfCcjUttVBkSMc+TFA8TfXOlAREsjmpxBCefl4gkX53EOhxLOlcF56p4DmMNYr/y6kPlbpv20dScgT8H4buIaSOKcu525kRMnmrluPxCPcoq8VvbknvO+sD7kDh5D+zjRetG0F3ZJxO5Gq3MWCJicm6USLD7RCoAAV2guJXgbEoQYVdyo7knwvLXmFZ9xkL4Wo3Wq9ur2rsEFNVqMvrwi8ANcsH9p/rnBLM2PrKNYwBp+0TejLhgcBOuitnwlZUQ3o14oK4TudUEJn5NhGqz4KecyJwWkxQF3RFQCMuvAaXX0nbJ27Pzgd0Zysa+FNrElGecr0yM90hQeMTbxc/zF8+kU0eA6leY1PkdTtKHq1wwEQ9x/Jj+dhBfo8CNqS0Q6ifCPrtBcHiTr95N/9N9COI3NBTOakHIxAYkz0dkhfB6x7QYbzXE9thTY3pX5oondpvgyEBWOrX1QbTeLCA4eSTbiU+CgtRsai3j1P7LPvkyWfNVYdKn7SvnVzCfwuFQXu/M35gH7ujNcGVkzghZ4U002eg5wn9o2jalP02SWOAZj1WFNkEdKb6xwdxRv8gCUL1vW5WFdQh5T3dJvxCk0nqmDM5AMXDuA7fbJL5AWILCbXDBdhe1RKS4ZIumo3Vc2OgxaubmTEWXDbsIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(4744005)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d7rtz7EijRm5f45ltg2cKXVjDi8oFeD+cihAPXRsBzPJcrKPdUdxBVyXteMo?=
 =?us-ascii?Q?BzV9WZhYIuAyRy3QtwZc/DDpcsenV/GCmCQx5FkJJBNASj2AxnCTHRKN3GaA?=
 =?us-ascii?Q?NjkD9reXkUODDDwuutIWlHvemwzTz9T1CkIV78smrRxJpQhDDcoJr5RHK8V/?=
 =?us-ascii?Q?e1mdQoPgXAwZqrwzxkbNGYEzF+IMFdIIAux1DjnbE9wKgnTEsb21pR3FzIeS?=
 =?us-ascii?Q?2kZLW3T5seDyrgCgbzYlwc7HTWBlgPM/TUsuocpRwX2hxe7x7M3AdyRBOMRP?=
 =?us-ascii?Q?YK92S3S67QUu7phVzgo39ocjLJj4V57lhNm77Rp5bDfca0xQ2x2cJIA8MX2d?=
 =?us-ascii?Q?9AENNlmralsjcNpJN+NLo1noC2jUOj+IgkNRhFQY3z5zHA2haY/WtMTd6Wsz?=
 =?us-ascii?Q?rZfZ3hx7NGKsGKvbnHb5sW264bima2tTzNxabZQiG6doO+yBGNrJUoooWt3v?=
 =?us-ascii?Q?t6p81vIXx2cBxIH3lU9k3fcGdHHXoR/KIbBYhmyBsJ1uH992zZnKbbnmA/Ot?=
 =?us-ascii?Q?mp3o59Fn7eHlkpnn/2eWYXp9joRDftVXVJkRwbwFPMOVSN87HQGQaxyJCSQh?=
 =?us-ascii?Q?v+tVS7o0VCgykub4MgeVlTnpGgUYymgpOXLEkNVVRewnZgya0klgBQZXuA6r?=
 =?us-ascii?Q?ktPKBY7Dbdk/cZFdRKaQard2dwWYsbGIKsVa5FFCCVji1Al1d3AYsidCjeZ3?=
 =?us-ascii?Q?kCocN9dp9XoistiPdnMo8W5d0PhtJUW1uXGcnkWZMQiswoS2X46/eO9/9eqT?=
 =?us-ascii?Q?+m0/NIXGts2rD/QEjAuAZ8BmG9h6Fb9RXdho/50dO+SDrFSNmlzg1PNdwGNb?=
 =?us-ascii?Q?SwnXZBQFpWHSP1uTpljJ0Vl2bBDcMNVA4JMqm5nHH0+JDpGLIXY89h0xbJ7/?=
 =?us-ascii?Q?pjgrG1l5ewpo2fAhIQ4z5p6J8cXQzJzsMU3OlxXw56I1lqYtlBysHsz8PoCf?=
 =?us-ascii?Q?WpiiyjfpkfXC8szP6SRzkgRYY5TWr04sIerGGEynYNS4gkGJu6l0JvP0FSaW?=
 =?us-ascii?Q?7Yj2JH3aMZ02j7Sh31FWBHT3mCrRlrTnJEnXFpoQ2qnSHxPBdaDl3t8nziuu?=
 =?us-ascii?Q?QFU5rW2wVv3NJSJCIHgU8JU6LuK9qfkPxZ+xTTSmJJzBCSQmB8Pm74qhU8/2?=
 =?us-ascii?Q?dvYMkdEMM5vsGR1DEYjCbZIHPmiKA5CgZA9TVxpoCJO5A6JkYI6hDBDiW74t?=
 =?us-ascii?Q?0alqZpl7MXY1X1P+ArRkTD0PV9o1gcumqwJZCdqEu7G5UQC23n719I9Heimb?=
 =?us-ascii?Q?PzF4MteKgEolJokPKMpDwaLHc9lHRTaemlLkt56sJPRP6DzLKyVcXzJH/RgX?=
 =?us-ascii?Q?3JkofPtyPwNcNIQt4X7kg2D4Gh1pyxmKdIGjpHtlTRhOGhb4nj3HWAgWNRIL?=
 =?us-ascii?Q?uXLrRzGbHtrenZ5obd82BCQjL1oAksB/DRSrwtOCTZz/w9v149D4isBYjiqR?=
 =?us-ascii?Q?L3h/ABgXlRZKWKaXjkfJP3NsjK17l61ukgilunLohJsd7LxHzVEDeD3kt4ws?=
 =?us-ascii?Q?lADK3sldHC3DhSpkGRMRHDtTiR2ArgaKa5BvzadBdcVmfjsAQlLL1+L/pQM+?=
 =?us-ascii?Q?UQRj2hLCQOeChxxeFyOY2X3DeAo+BbEIi9pxtA8SDwqtS35CyHUKmKmjJbzJ?=
 =?us-ascii?Q?oBslpKe8T+zKRrWX3/+wR283MHSCHpzyR/PzJOpZ7OIbqddPaqy7UWTznOKD?=
 =?us-ascii?Q?8vYeNmRcl6OEyBxOOX7hRtX4SozTuw3yf+qmolddikhya+QNTPf1vrAwfMjs?=
 =?us-ascii?Q?51Bn4w+yCOkVRVVaCOaB2+s9C1Jahzq9qeXwNnVcsnLVfqhkVxY6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 579fbe8c-6ae5-42ac-8cd5-08da2cbf7c51
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:36.4016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FChzjleMPOOHkkI5R/U3pQzOXGhKI1XylVPUCzUOXJZqL0fwNmfL/1GvYcP569VWEwsiB09MNiF9+H7g7yYXRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

When deleting an FTE it should have no dests, which means
fte->dests_size should be 0. Add a WARN_ON() to catch bugs
where the proper tracking wasn't done.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d512445c7627..fb8175672478 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -605,6 +605,7 @@ static void del_hw_fte(struct fs_node *node)
 	fs_get_obj(ft, fg->node.parent);
 
 	trace_mlx5_fs_del_fte(fte);
+	WARN_ON(fte->dests_size);
 	dev = get_dev(&ft->node);
 	root = find_root(&ft->node);
 	if (node->active) {
-- 
2.35.1

