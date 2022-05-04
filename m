Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9C95197C5
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 09:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345190AbiEDHGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 03:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345183AbiEDHGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 03:06:53 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDFB220CD
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 00:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6tbNpP5WHiQhzcxG/l22ZwHoCXwDwbuq1EA87CGcNYuLtsrEGqmxwVltxLUd2MwH4QjHs9QPgUf5eScyIc3zobGETDeBt4a9h9GynRY972TlLLScS36OHFv26o57ymhZDXEJD7h/1Bj91aT3Lh7NFx/zEiQbc+AGKJJYvE0etRUO1RUvnnjQSea0HCttOQ5UPbHM85Sk/zERFHybsgAn9Wygq1yhSNlwBqP98InbSBaxhxWoBuvjiBN7mXjNtl+wf196l7UunUYMV3cJ5LAuj+kAgYUAc5AXWBMWVJLqqgzNx8nfdd6pOlPgjOWJUYgUDk/AiZdnwVOti5WPNV90g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kF+zOs76jJFDiq9RZimGNCi/FYh9J52eN3WBofgb0Kw=;
 b=TRdOG6dUyS76Nx3jKA+2B37DIfTssmnAah59aBgT7FOm6GqQPAeYTkDEKulM6RIthvurofiFxx/KOmFQYYhtxJcStiiLvkK79I41bklXpeSKVDzgcxzTpqhhg+mlePLATIzSKUQEcni73aWgYYDmHV8d+tHIANp9R8RoNW4NuwI0prXNXxihLyfrmFzl/r/qR8wfwImDxgFMjOLk18UqjQfZLyEM/a1yU8ICbiROV+5l6uH6+VDqmpLmNXDzlY6euRRDQ4kPgOEnI9udalI68IDHIa2BZd/0vyDxpzLSTJQcMf7/lkiQEeuF2SMnO5hNvbmMfgzSo9TVdYgWE8IkBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kF+zOs76jJFDiq9RZimGNCi/FYh9J52eN3WBofgb0Kw=;
 b=Ske0W5wqrzzLXy+naDC2caHlJUua8/MV7bZOWWML0z16EQf3dhydOiWzFwnJkuJ5tilJ2gRw4J1PUxnR26G7676uBgw1KtncMCn8mHaEvyzJZGOUCAdUAkA+mwzUtES2Ny+1Y/OdCdxTcX3fuB2aceUTzMrtYHtGlWoNZ745kWwMet4/vNfZ3CuRCfspXpDiTCMYZEaT5VGdsQCg+zRRgfXc0hvSZwofeVwHxL4oISbSmFvhWBj0/ILVtpiGiS84W0Kuh3VQQRySE6xWSEv01n7umKrOJ0NouikJ0HwW9PLpwfYq9GomIQmOIylomZpL7xH9Ve5lVYtZ5ZbYth8R0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.28; Wed, 4 May
 2022 07:03:14 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 07:03:14 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/15] net/mlx5: Fix slab-out-of-bounds while reading resource dump menu
Date:   Wed,  4 May 2022 00:02:43 -0700
Message-Id: <20220504070256.694458-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220504070256.694458-1-saeedm@nvidia.com>
References: <20220504070256.694458-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::27) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0278b6e5-dce3-41db-f526-08da2d9c283a
X-MS-TrafficTypeDiagnostic: PH7PR12MB6586:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB6586AF67F229CC8C85F7E111B3C39@PH7PR12MB6586.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aUZfOZe2X+BVVOGy1hcJ1HRnZVqbVbXDGQCGXEjD04an/DigIwOx0dZfbYDWjvBRtgb+0zbGHHaJD/nJpIimlYT9NxBkUxZbJwAE/KaYSx5VyDteFCpa/24Hk+VeeOTMg85SezlMjPxzV3HV5iesiHUvImnHnNnp+/Y6ItjLjQqyrf0e70oUtsVlrNF06I8J+fr8RVDxbAHmVItaDfgcyfU0kw3nW8IESuKkCJOIe6nXQneHu4mJiV3x+RjUZAw2TgRoldcMle5QbnbE0PdseZ95V+k7ZGYnrhsGwuPcsdkPbPdYrhAgVb3aSRvR0SUF6FrMlUnfE/8PzNr1vE+1g3JlAaMY8qlSeyDb4y+Tuqs2v5PD+kEts+a59Lsa7sotLO7YVsBZSbmiwuRReKmLXqOjorW426eD4EDn6Celt6BTXFtTMlqksINYUCBgZulSMCcY5fqHkZM4ubysuvuUgp4V/6ZBHBdO3WVSBiyYeNpSYweoua/wqRohji6boH1GlVjYvmdi9PIFkO5xBfhD2mcZfEXOAdCludz0xcrsdAirrJUEBCEsp2u9dbrzXhJ9iWKJ43T2eVvhnfYjZ25McvhUcf9aK2S3D/yzGmV2+kS/eNERg3M5hPuNYJ2wROE+/aCg02phODGmGH5rA/Tkdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(83380400001)(36756003)(1076003)(107886003)(186003)(66556008)(66946007)(4326008)(66476007)(8676002)(2616005)(2906002)(8936002)(6512007)(6486002)(38100700002)(5660300002)(110136005)(54906003)(6506007)(508600001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?63YO+9yiSwSjf5TCRGhpYN8rFAazNB7kiPWBg9jl6gO7VUJlJqAfiywdiix2?=
 =?us-ascii?Q?ObFv9vpR1M6V8FlD+itlMggjvPerXKAOKfc9oN0KxLPzfSGWTMFs7ca615Of?=
 =?us-ascii?Q?dSpiYfV5US1Xa1/cfKAlF5oKrQe6uXNaWbbdsWWxK6A7/4gB2JiXRKKQr5UL?=
 =?us-ascii?Q?2cmIy4U7ClkWrPfZtOnAoVU6RIhnU6i3Eh0uviaD+8um6ZgKwcmnLEjje5YF?=
 =?us-ascii?Q?mwlCXKgxtMf4AEVN4QWBGMCIQXKdqxxSREekMIrqVheCzawrtA59B1Mf6oXK?=
 =?us-ascii?Q?gDnyHgZjzwOE1eXvaZUZkXSezefBE4hS+0sAfV2SWmTXSk726Z7Yjs8OcyUd?=
 =?us-ascii?Q?3vAaYVZnIyvWA1H5OE4t/8Zl4Tdy8IdPgwUt+Zz3DhWRurd1A6huZd4PV8sD?=
 =?us-ascii?Q?a1SUb8g62OKbz7llg9aTiwDu31S2rJJE73etDDS7rBUaR6MuilbLHIf0VhEl?=
 =?us-ascii?Q?tZtq+0MdeC8h7JidMThtOwpnKrribuqsLDJeLNuFeU59SMrTI750VTebSizo?=
 =?us-ascii?Q?icS9Ws+w424sZqqhQfPzbK8zNKssmhxmH/uvQ6P5Nk+Y6Q7PgquJyRQgz6QP?=
 =?us-ascii?Q?Fzy5r1Cu68k/B5dVwY7hGK/KTrt7xk2GuYmVLyJ8estKvNn1H38t9ZmpNNgI?=
 =?us-ascii?Q?jxDRqqLTiL313r1/MxFXcyyCabojEW8AI7O2iJo3d2499EJu4r06AsiCn69e?=
 =?us-ascii?Q?ZeYezRUjTiGloHiCIP5okFGhKQhl9lDwH/W3Gf+Y017WztAKigCpXddSgnTP?=
 =?us-ascii?Q?lkwRWZeNy6GJzbtQ30+UDG34++2YCzr8eqm2XOjIcRAZcpNTMC6tvEKPgLhd?=
 =?us-ascii?Q?wHr5kwHH5+ufm/G4MD9dyA0HXPY3PiWhHoPKvgmeU4v6xbOOgTjgbf5np64D?=
 =?us-ascii?Q?ZTbuIXbYpqrdgXyuHwczTc/Mj9VDwucP3A2rDEPc4sPz2SVpMzPW1l0fjwIT?=
 =?us-ascii?Q?r4qWg3l9YiDTrSUR72dv1tBkWsI9zsXA90any25dOVXPSzf9HdtZ1GCw2bQ1?=
 =?us-ascii?Q?9xeZi/WgFngPlCVlMiRWINhKgq3hj3PxJLjBIQk4Eu6YfnRB+xQm2ZMKX7tr?=
 =?us-ascii?Q?kQtyCqCW4xAo13Kg7ntGVz1JZGrD/BWt4YM4vMgnmtnzQptN/X8W64Q9/mHZ?=
 =?us-ascii?Q?TTJnr8LPrfarPWg6UgOajwqo2HCMP5WrV/zHJeP1DdJbBBaG4BEd1ynVeypT?=
 =?us-ascii?Q?IU1rqadz5T+ohpPlCBbjpiav1ZGvLqOgeQ7h2AQCkZDA9cfim40GSDtGSu/Y?=
 =?us-ascii?Q?h7VLpiMyI0uSYxa2DjvKXBYFR04KXreoFi1MKe4EIQf+wueMbFJTW4EG37cp?=
 =?us-ascii?Q?9nbPFxZAN1TGKUDTMR91Z1vmzn3sOCvn8s3o3dVDih9y7zeVdssAGrP+3WbI?=
 =?us-ascii?Q?s8bMR33+oHqq87qlavan/kq78HmtebCd4WwL391Q+kjaG7yGzl7if8ZcPV7m?=
 =?us-ascii?Q?EUsIkvcctPu1D9aV4iu6uEmiMeEJukvq7EFipnGwqHD61KE9xoDiK+lY3gbL?=
 =?us-ascii?Q?YZ7pmAM0GcZS4CnPegdc9R9sphm7MZbrWC7xyIbN3f4xRrTpwQIFMg3bm7l7?=
 =?us-ascii?Q?zGuO/OUpDZWsCkgWTh9+18R/9kxUd+tj0YOa/ZHdyMUB9H6bBpZcAUSKq/V2?=
 =?us-ascii?Q?ar0jLBN+uYVQSXCIvsHZPI/ehPZWvlQycmDdheMGuuKpYucyEhZPgmlmhgvR?=
 =?us-ascii?Q?CLuRisbSchEj9bBXLvbQm7rD8FvFz/yU5ZRmHlL4rwbvdxFMblIHeC3FA01/?=
 =?us-ascii?Q?cQBlWxSg8kfk9cFsRbV/rxi8Ty5f0CpEINfGgFeFjseL+GjzP74k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0278b6e5-dce3-41db-f526-08da2d9c283a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 07:03:14.0853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8fItC+4a6eU8AYzqrh1ZIRLeFzRXnEfFAl7L4qX9xI9avwc3IdnVqNnLolUC+m9tx1Qmg4mBOMxPfG9bMLjLqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Resource dump menu may span over more than a single page, support it.
Otherwise, menu read may result in a memory access violation: reading
outside of the allocated page.
Note that page format of the first menu page contains menu headers while
the proceeding menu pages contain only records.

The KASAN logs are as follows:
BUG: KASAN: slab-out-of-bounds in strcmp+0x9b/0xb0
Read of size 1 at addr ffff88812b2e1fd0 by task systemd-udevd/496

CPU: 5 PID: 496 Comm: systemd-udevd Tainted: G    B  5.16.0_for_upstream_debug_2022_01_10_23_12 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x57/0x7d
 print_address_description.constprop.0+0x1f/0x140
 ? strcmp+0x9b/0xb0
 ? strcmp+0x9b/0xb0
 kasan_report.cold+0x83/0xdf
 ? strcmp+0x9b/0xb0
 strcmp+0x9b/0xb0
 mlx5_rsc_dump_init+0x4ab/0x780 [mlx5_core]
 ? mlx5_rsc_dump_destroy+0x80/0x80 [mlx5_core]
 ? lockdep_hardirqs_on_prepare+0x286/0x400
 ? raw_spin_unlock_irqrestore+0x47/0x50
 ? aomic_notifier_chain_register+0x32/0x40
 mlx5_load+0x104/0x2e0 [mlx5_core]
 mlx5_init_one+0x41b/0x610 [mlx5_core]
 ....
The buggy address belongs to the object at ffff88812b2e0000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 4048 bytes to the right of
 4096-byte region [ffff88812b2e0000, ffff88812b2e1000)
The buggy address belongs to the page:
page:000000009d69807a refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88812b2e6000 pfn:0x12b2e0
head:000000009d69807a order:3 compound_mapcount:0 compound_pincount:0
flags: 0x8000000000010200(slab|head|zone=2)
raw: 8000000000010200 0000000000000000 dead000000000001 ffff888100043040
raw: ffff88812b2e6000 0000000080040000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88812b2e1e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88812b2e1f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88812b2e1f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                 ^
 ffff88812b2e2000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88812b2e2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Fixes: 12206b17235a ("net/mlx5: Add support for resource dump")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/diag/rsc_dump.c        | 31 +++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index 538adab6878b..c5b560a8b026 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -31,6 +31,7 @@ static const char *const mlx5_rsc_sgmt_name[] = {
 struct mlx5_rsc_dump {
 	u32 pdn;
 	u32 mkey;
+	u32 number_of_menu_items;
 	u16 fw_segment_type[MLX5_SGMT_TYPE_NUM];
 };
 
@@ -50,21 +51,37 @@ static int mlx5_rsc_dump_sgmt_get_by_name(char *name)
 	return -EINVAL;
 }
 
-static void mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, struct page *page)
+#define MLX5_RSC_DUMP_MENU_HEADER_SIZE (MLX5_ST_SZ_BYTES(resource_dump_info_segment) + \
+					MLX5_ST_SZ_BYTES(resource_dump_command_segment) + \
+					MLX5_ST_SZ_BYTES(resource_dump_menu_segment))
+
+static int mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, struct page *page,
+					int read_size, int start_idx)
 {
 	void *data = page_address(page);
 	enum mlx5_sgmt_type sgmt_idx;
 	int num_of_items;
 	char *sgmt_name;
 	void *member;
+	int size = 0;
 	void *menu;
 	int i;
 
-	menu = MLX5_ADDR_OF(menu_resource_dump_response, data, menu);
-	num_of_items = MLX5_GET(resource_dump_menu_segment, menu, num_of_records);
+	if (!start_idx) {
+		menu = MLX5_ADDR_OF(menu_resource_dump_response, data, menu);
+		rsc_dump->number_of_menu_items = MLX5_GET(resource_dump_menu_segment, menu,
+							  num_of_records);
+		size = MLX5_RSC_DUMP_MENU_HEADER_SIZE;
+		data += size;
+	}
+	num_of_items = rsc_dump->number_of_menu_items;
+
+	for (i = 0; start_idx + i < num_of_items; i++) {
+		size += MLX5_ST_SZ_BYTES(resource_dump_menu_record);
+		if (size >= read_size)
+			return start_idx + i;
 
-	for (i = 0; i < num_of_items; i++) {
-		member = MLX5_ADDR_OF(resource_dump_menu_segment, menu, record[i]);
+		member = data + MLX5_ST_SZ_BYTES(resource_dump_menu_record) * i;
 		sgmt_name =  MLX5_ADDR_OF(resource_dump_menu_record, member, segment_name);
 		sgmt_idx = mlx5_rsc_dump_sgmt_get_by_name(sgmt_name);
 		if (sgmt_idx == -EINVAL)
@@ -72,6 +89,7 @@ static void mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, struct
 		rsc_dump->fw_segment_type[sgmt_idx] = MLX5_GET(resource_dump_menu_record,
 							       member, segment_type);
 	}
+	return 0;
 }
 
 static int mlx5_rsc_dump_trigger(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
@@ -168,6 +186,7 @@ static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
 	struct mlx5_rsc_dump_cmd *cmd = NULL;
 	struct mlx5_rsc_key key = {};
 	struct page *page;
+	int start_idx = 0;
 	int size;
 	int err;
 
@@ -189,7 +208,7 @@ static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
 		if (err < 0)
 			goto destroy_cmd;
 
-		mlx5_rsc_dump_read_menu_sgmt(dev->rsc_dump, page);
+		start_idx = mlx5_rsc_dump_read_menu_sgmt(dev->rsc_dump, page, size, start_idx);
 
 	} while (err > 0);
 
-- 
2.35.1

