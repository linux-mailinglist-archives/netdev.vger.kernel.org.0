Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED955CCAB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiF0HIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbiF0HIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:08:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3BC8265E
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:08:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBCFb5T0jIEIbLvsn499l/ekWypdUo/EuGua+nbSZuCaXRfJNgvApgAGygY4siBZ8Za/qQ7FrxCssMqNjDxlAwnZulaDc+adI84H2LweeKsHtIukg/+jci+vj8uAbN/4aWCVAeKyf1/aLHEfCpqpJaDGpL/wOPGFcXpZS9LMyxn+GFq4dJjPjwqyokFoXH850k4AWLJQbk2/i0GWWTFDrk/ZAfzHmfSvgXlQaTZyGsF5evWY3EQNU9XxNfABwBAM3KlufOsruGmSO5ARxsHPfl9pZf/l4SkRFmiJW3m+CSH41bNqBW2OSoHodYdmt5+q6UphUOQiG7JdnisSVPp5bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8WyNdEZd3RuAz+0A5TNp/TT5SIrgsR6wum7oKvaF0U=;
 b=UShx0QZy2XfurKQzZhtwzuAYJR3PfNUGSb3R+358PpBnqkwVGPq6YUz+WszQKUn04tv2iwpV/JVs6d8MWmLoHUeDpTYxbP2waKEi5Dhh3gTqmNFK+tViAu2682sqNKKiIn2xiArUqU9niltxx2m3tpi1OLYzkPMNRyFK0K3nMjTjW9QHVvk8sNhthWMXpYM/m2MtilZaPkdvYVm++zRNE6Q9RisO4Tpr8fEevgmVIyF2O20iJtX4FmetL0F1zPqNIvyF2COYz4wLInbkWSjUT5Y+s9YHnKwaHe7rWmh6/vYjBPfNEVmmtOR794uYvi3SyOnT47IR5qs/4UmeYy1k+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8WyNdEZd3RuAz+0A5TNp/TT5SIrgsR6wum7oKvaF0U=;
 b=EgL2OniHYkM9KevpWIw4VvtIVDsra/tTbrGt/a4sah0VLg2LDxmWDIvCh+yeL6oyazqCK8LrUbseWQJKc+FkiJ3+BINq1O837O1Hva82G/y9NhmwvKg6rDkWTsio9MW1XMWPI2tAmKpCKzVS7tS4XHNfXTP1MbgVH8xllbf0BG8mEZDKrutpfbmvueQ0f7Gp49Lf9a/fpiKY4dLMihULtqOvZOm7Jo4etpKf1eHc02AZmA8k/+JVf1/vQFiNbMhUmaVgH3r4Mq5vUXw2Yq867nj0RgNAQt6FEU6koK68B9yStF8L9G3EulXj/wxE+czJOCAenAFoj7gy6jc0MTf0CA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:08:12 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:08:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/13] mlxsw: spectrum_fid: Configure flooding entries using PGT APIs
Date:   Mon, 27 Jun 2022 10:06:21 +0300
Message-Id: <20220627070621.648499-14-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0033.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::21)
 To CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e639b21-5433-43f7-c4e7-08da580bcc61
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EEd9DukByXenxZgvEFF4CGyjMgNKMziwgyw4xdtmr/0BG3sM32FLE2P3zy8FEOQVNDszB8rc9IAJubzQzDFaxeu/B5dQ6KAsPslCBWloiVE6krADIqJFNaQ1xwdH7F0jHmGqdqVJxEz40eCzfbk4UJqwEHrENZDl3dN/7/9uUq6iu0kVUFKmQYwLM4f4qxEZV662ueSXbXqWIyv69VhSUAGTeFHPCpmTOc8IYqLGRE1b4GkkI97LKQ5E/tkJz3SvBRFB0IblTjLJAKyk5oR5UrklMTwOF7/62QaCiBKnKlH+hYZ5BqGo3OxnxxcIUIaAkaxE6g9Z3K6v/uiUmNYLyKTGOKyQ+5HpOs/w8yVEwsc+hlAT8oBPG3w1J3YlMsrVgBeAsuUzE1Oq0gABRw1ZXOjvxwGSGQWHm/eS8euBIC1VDfQd1718GJv7hUu4n+la0Ky+sI66AxiOyalk9aprXmxo1n5jOuNMUtAezE36BDcWrGbfnvWMqR+fYRCNT88Vb3YZFM2qd3rUxgnsR1u0WrqzjlEogr6py6kgSoIGKvtzovwGYbJEiTdf3uK/GwTSsBhQXWTEwGCqHig17vnS0tbHHiaknQ3gDpL+XGg+QkH1k0rLHBB3kmM0bCe2fecCZFLjFjoTb5Abzn8chkUEmSHs6Eq8vWKQ3OrteyBvDqO7HjP/6VYA8BdFbjcCUO+bIfzo/N8RUmDXsFH5Aj1LyKObNTw+oAXA+fPFxUPeHX85aH8DxppyTT3qltG+kyI5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aQRDjY+A/A6laKoTj6miE/09T/LEBH2eMzleS+2cPoyB5dKv+y/ynZ5KsyUe?=
 =?us-ascii?Q?d88lMioBEOqH7ihXp3bV/69NEQsXoql4COH7wcXFucF+vBzCeUW5ZWNpr72t?=
 =?us-ascii?Q?g04ulTvn7KBHMA+3U4RSGB4V1bp7PY3P66PfVPiMouDpEARw9RIkZav6MutW?=
 =?us-ascii?Q?Qo6v2tOjViWR0n4UG/BdJZIfj0iDNAQHkdE2Dx49WM/DXzlqXsv303/dKzXs?=
 =?us-ascii?Q?YS8QqvPiG0ILC/ZeLEM/Cbnlu1HKLMesMGqhZDatsLDqNNBmFesh0VY489p/?=
 =?us-ascii?Q?zmcFKy/GBOFnUD0hIVYZxUZqeMfEM+dT4U/TA/NG/DCvsbubKGFYupDEurkO?=
 =?us-ascii?Q?5Q2hf1kG8t0BYU4UuIEJh7g/puTNSNFE0YMqoFC2Ig82dY7D6ipnUPSIFGek?=
 =?us-ascii?Q?MSWPe/vK3AWJ6YilBY3lyJxbcOFFgJRJFd0upnA16wHNxoN4bmffx4rZOo1T?=
 =?us-ascii?Q?nqCk2kYXCn3P5921cb3JZZ032qosVXt1VGmpmuq/Ql9LDLPk8yVgiZKLW0ed?=
 =?us-ascii?Q?vZXwNpZr8WNvlqVMDLIPEeJTBAqmmqVZN41VlrBlOWPCSVd7sSssNf2ReFLZ?=
 =?us-ascii?Q?5rWV0hOr0BCDuNIvndO1huOfeGBHFmnMDX+MEb4HF/Gg7EFI1REgwYOIfk0m?=
 =?us-ascii?Q?JFE6uduxzjdLCjzlF4LcmhF7fobiD5//06uLhvB/e8AIFZZbRAgINae5bG2x?=
 =?us-ascii?Q?fTOfgB1G0NmlFrWtdCbM5BiHzpotbqc3NK/jZOGUMeRTeNhaZ2m2PNZSb5b9?=
 =?us-ascii?Q?2/uFGZ2Y3zWq5HzdiKKfvgTLWC6c8kJvsfg0kC6GVfKvzJK6aI/xQlzlTKQ2?=
 =?us-ascii?Q?vrwhtFkMAQm+tOKLdjMnukoym5pk8ZVZkgKMCQeteqt40xL7HtAgDIusbWIS?=
 =?us-ascii?Q?BvOG0fEl/uX4QR6hv0JyB6C8dqM36HtK3eT0r/bm24bfMsOEtMirt9MUREat?=
 =?us-ascii?Q?jC6pETDR4xK4RDG6TgfjkRqXa+tCqpJHh26dpCRpdnqFGIZL6SpH6cU4KVKi?=
 =?us-ascii?Q?8Q+PTtX784CnoK50JR5VtMr+TCQ9Ogeo0t68SnzSFtCxkcYOv5saDCVLrlDW?=
 =?us-ascii?Q?va+UNV8OHUskGvsmTTVWK4cIG8IGUqJdz4pMEhIKDKty7Yp0OWFxKPMCmSN6?=
 =?us-ascii?Q?Iq+jLCGCBscHp7zjIDG+qVrVY4uKBuS40Drskt8ipoQVr54AlgVtzvrW1E5P?=
 =?us-ascii?Q?uTr50NZeL8yvBAl2MqqcGhtveA+HeqYug0FbhTyKBIqc+MSh/CXnQui9Ei/9?=
 =?us-ascii?Q?OexlRiJebBAJdlyPECjyVTLVV7mIDFQGCtKKSix8wGbTUcJEItK38HmKdRkT?=
 =?us-ascii?Q?E/9WJheAQxJ/aMSXwjU6ZBENPiwm1OqdpbWlbZU5cBibr6Z8yLVXt0GTZKLH?=
 =?us-ascii?Q?xaJTvIZJBLeDjCATFoArXTxhWOxJd2ON4Y6GXQASMmMKp7or+NtvnVDTfvsd?=
 =?us-ascii?Q?aCnIx+9oWE3VaDQDdSSKpovr6TR1af5Q3nJHniHU2FH6G15pttr1mCzda9nN?=
 =?us-ascii?Q?oCkK3juhhD2NE3raKZjTGT8mtlTx09HOFtBEqOg/Ux05sR20b9HR0o4EMY1q?=
 =?us-ascii?Q?8ADulDEWap3ee2QYRDiITWj/vEZZhyRVkBAnID9K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e639b21-5433-43f7-c4e7-08da580bcc61
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:08:12.4128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1fCz8z354VrTkYxj42aPrtylbYNEq0/MxRf3U7zJZTO5tVqHNtfX0JdHxp/vdAmh5qxpw1PGbBby75k6BLIqg==
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

The PGT (Port Group Table) table maps an index to a bitmap of local ports
to which a packet needs to be replicated. This table is used for layer 2
multicast and flooding.

In the legacy model, software did not interact with PGT table directly.
Instead, it was accessed by firmware in response to registers such as SFTR
and SMID. In the new model, the SFTR register is deprecated and software
has full control over the PGT table using the SMID register.

Use the new PGT APIs to allocate entries for flooding as part of flood
tables initialization. Add mlxsw_sp_fid_flood_tables_fini() to free the
allocated indexes. In addition, use PGT APIs to add/remove ports from PGT
table. The existing code which configures the flood entries via SFTR2 will
be removed later.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 65 +++++++++++++++++--
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index d168e9f5c62d..160c5af5235d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -322,6 +322,12 @@ mlxsw_sp_fid_flood_table_lookup(const struct mlxsw_sp_fid *fid,
 	return NULL;
 }
 
+static u16
+mlxsw_sp_fid_family_num_fids(const struct mlxsw_sp_fid_family *fid_family)
+{
+	return fid_family->end_index - fid_family->start_index + 1;
+}
+
 static u16
 mlxsw_sp_fid_flood_table_mid(const struct mlxsw_sp_fid_family *fid_family,
 			     const struct mlxsw_sp_flood_table *flood_table,
@@ -329,7 +335,7 @@ mlxsw_sp_fid_flood_table_mid(const struct mlxsw_sp_fid_family *fid_family,
 {
 	u16 num_fids;
 
-	num_fids = fid_family->end_index - fid_family->start_index + 1;
+	num_fids = mlxsw_sp_fid_family_num_fids(fid_family);
 	return fid_family->pgt_base + num_fids * flood_table->table_index +
 	       fid_offset;
 }
@@ -342,6 +348,7 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 	const struct mlxsw_sp_fid_ops *ops = fid_family->ops;
 	const struct mlxsw_sp_flood_table *flood_table;
 	char *sftr2_pl;
+	u16 mid_index;
 	int err;
 
 	if (WARN_ON(!fid_family->flood_tables || !ops->flood_index))
@@ -351,6 +358,15 @@ int mlxsw_sp_fid_flood_set(struct mlxsw_sp_fid *fid,
 	if (!flood_table)
 		return -ESRCH;
 
+	if (fid_family->mlxsw_sp->ubridge) {
+		mid_index = mlxsw_sp_fid_flood_table_mid(fid_family,
+							 flood_table,
+							 fid->fid_offset);
+		return mlxsw_sp_pgt_entry_port_set(fid_family->mlxsw_sp,
+						   mid_index, fid->fid_index,
+						   local_port, member);
+	}
+
 	sftr2_pl = kmalloc(MLXSW_REG_SFTR2_LEN, GFP_KERNEL);
 	if (!sftr2_pl)
 		return -ENOMEM;
@@ -1169,17 +1185,20 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 			      const struct mlxsw_sp_flood_table *flood_table)
 {
 	enum mlxsw_sp_flood_type packet_type = flood_table->packet_type;
+	struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
+	u16 mid_base, num_fids, table_index;
 	const int *sfgc_packet_types;
-	u16 mid_base, table_index;
-	int i;
+	int err, i;
 
 	mid_base = mlxsw_sp_fid_flood_table_mid(fid_family, flood_table, 0);
+	num_fids = mlxsw_sp_fid_family_num_fids(fid_family);
+	err = mlxsw_sp_pgt_mid_alloc_range(mlxsw_sp, mid_base, num_fids);
+	if (err)
+		return err;
 
 	sfgc_packet_types = mlxsw_sp_packet_type_sfgc_types[packet_type];
 	for (i = 0; i < MLXSW_REG_SFGC_TYPE_MAX; i++) {
-		struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
 		char sfgc_pl[MLXSW_REG_SFGC_LEN];
-		int err;
 
 		if (!sfgc_packet_types[i])
 			continue;
@@ -1193,10 +1212,27 @@ mlxsw_sp_fid_flood_table_init(struct mlxsw_sp_fid_family *fid_family,
 
 		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfgc), sfgc_pl);
 		if (err)
-			return err;
+			goto err_reg_write;
 	}
 
 	return 0;
+
+err_reg_write:
+	mid_base = mlxsw_sp_fid_flood_table_mid(fid_family, flood_table, 0);
+	mlxsw_sp_pgt_mid_free_range(mlxsw_sp, mid_base, num_fids);
+	return err;
+}
+
+static void
+mlxsw_sp_fid_flood_table_fini(struct mlxsw_sp_fid_family *fid_family,
+			      const struct mlxsw_sp_flood_table *flood_table)
+{
+	struct mlxsw_sp *mlxsw_sp = fid_family->mlxsw_sp;
+	u16 num_fids, mid_base;
+
+	mid_base = mlxsw_sp_fid_flood_table_mid(fid_family, flood_table, 0);
+	num_fids = mlxsw_sp_fid_family_num_fids(fid_family);
+	mlxsw_sp_pgt_mid_free_range(mlxsw_sp, mid_base, num_fids);
 }
 
 static int
@@ -1217,6 +1253,19 @@ mlxsw_sp_fid_flood_tables_init(struct mlxsw_sp_fid_family *fid_family)
 	return 0;
 }
 
+static void
+mlxsw_sp_fid_flood_tables_fini(struct mlxsw_sp_fid_family *fid_family)
+{
+	int i;
+
+	for (i = 0; i < fid_family->nr_flood_tables; i++) {
+		const struct mlxsw_sp_flood_table *flood_table;
+
+		flood_table = &fid_family->flood_tables[i];
+		mlxsw_sp_fid_flood_table_fini(fid_family, flood_table);
+	}
+}
+
 static int mlxsw_sp_fid_family_register(struct mlxsw_sp *mlxsw_sp,
 					const struct mlxsw_sp_fid_family *tmpl)
 {
@@ -1258,6 +1307,10 @@ mlxsw_sp_fid_family_unregister(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_fid_family *fid_family)
 {
 	mlxsw_sp->fid_core->fid_family_arr[fid_family->type] = NULL;
+
+	if (fid_family->flood_tables)
+		mlxsw_sp_fid_flood_tables_fini(fid_family);
+
 	bitmap_free(fid_family->fids_bitmap);
 	WARN_ON_ONCE(!list_empty(&fid_family->fids_list));
 	kfree(fid_family);
-- 
2.36.1

