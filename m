Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE5550711B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353696AbiDSO6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 10:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353639AbiDSO57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 10:57:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9AB22521
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 07:55:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V4+g0/m2/Ecj+UQO2SGkfWePGbGiRzRf67+qd17WLS/XEOzytNf1JZtZ65t34LCQvf9faNKVWlK8xd1leoS/+zehf85cEKWRIav5Oa2X4lL2sRS9kIRurigLZEr4Nrwp7KgGmdPnPJteHvVv6xl0Q5KE84SVjipdVxwn+C6B5tU6hzOPv47bGJ1GbJl02+HG31mZFaW5cvfpagSdvpAzwPx6BROZCDikyCO7OdZ+u6x4hIQArjSOCXIcrf1at6z7P+UUDzeqvVi0fMHwBN862uSJSBDs5dTSge4DpkGsOgZx8wrUSXHDuFOYE0Ls/LBFR5gF9JOpl4S9klAP+UClGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuQpOqFfZ1mE3+MiAjpqKm2iL417tDv5io2oJBWwC7s=;
 b=M4E8rmjmPX+u6MYDNemJJb92XqmR7l713cNUr3iLGErUQPOfIV8sT5XuBke10yRKa/LYBgxc+NvU4ForFDo0x6oSXyhlK+U7YdMcB9mStJzaWSMu+d/c4nLkcGFngeW1Hj1qofMXLC7TllV4Bel9pMRr82C2/XB8vR9AgCIXkrtD3mFj9Vc5heBlBm9hj22PJU5uBFGf1AfnYDffhkSNX/V+804YQkatUWYtrjKg0yn5tGk9WPJMBMom2UEMACyDyiV+5tCSImWqPsEjV7NnNfPgqQTv3aj3X06NeimjfXu0xxOCLvjn4U57CtmWZ9rdDh8cBHbsdkblHeRzaTGraw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuQpOqFfZ1mE3+MiAjpqKm2iL417tDv5io2oJBWwC7s=;
 b=OwQXZMf8hP2WJYJnfsR1bVJDeD8Wq7is4UK7tfw9LzYoy5W4JJpIKGP4oUBC/8gUuv415xKJIEonSVpSA5xBimrVRkmIVCX3wm0udqAgBi/EHufadde8BAlTTI8QjK2eKLKYc+W6vGjcFzT4XTwxXXlhbmaiPH8qPNNEfeADTLfOD6xbUYdJ0AzwJweyhLxhEYbd833OVN+BOjsFScW3Km7crnUfyXg8Io2kY3YgC3pjtIP8rZhD8qdutMZ4vauC8mXZSUDSPWaDw27d1OVTzslkMP6zOF6Tats/Rr08hzqV/UuOsHB2N85s/s5bIg6iFIuWEfagn7pgPjQ/HRvJvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10)
 by MWHPR12MB1216.namprd12.prod.outlook.com (2603:10b6:300:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Tue, 19 Apr
 2022 14:55:14 +0000
Received: from MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d]) by MW3PR12MB4347.namprd12.prod.outlook.com
 ([fe80::9196:55b8:5355:f64d%2]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 14:55:14 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: core_linecards: Introduce ops for linecards status change tracking
Date:   Tue, 19 Apr 2022 17:54:26 +0300
Message-Id: <20220419145431.2991382-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220419145431.2991382-1-idosch@nvidia.com>
References: <20220419145431.2991382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0215.eurprd07.prod.outlook.com
 (2603:10a6:802:58::18) To MW3PR12MB4347.namprd12.prod.outlook.com
 (2603:10b6:303:2e::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e589d91-4613-4961-0350-08da22149c02
X-MS-TrafficTypeDiagnostic: MWHPR12MB1216:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1216E2D59A0ABC8B0273E587B2F29@MWHPR12MB1216.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fBlYGcM3qOQT1e0pe9KB8HFU6lZayDJHehSP0uAKPMTjOCK/PXth4VvGyA78p/a+BW8SeRih2FD+rhuGos+fjU3bJWshoufQryiYGy/rbe8kNPfNyj1IYkWcyacOoCvQnoNsB/aR94wLY44KtwRbTa+rxUl+ZQI1eRvP0NkNbCQNnDXVFvSqcR1rOYK7RF1yltn+nMmchBrU0puDk4iUZAAVlhlK/QP5HNltoEBztCiQ+4TeGpwrgZeMurNIdbb+gOjOxYBRUlo13dbfJjuGXMfVm7kpPDNAwJN3byMI+8Y61kK2OTp3OAWAqrAbk7OXpybehkUH3oZKb47/6scEEMvfJ7d4hvUKioB3kVu6KPu8y18VXEKfM/6GaTexL1f/EX+4iJsGj3yNutr3Q+smMoIswo5GWrTE0ff6zOvuJKK5sFl4IA0vZy/2xJrGtgO3XBKQSFg/fkp9Mt386gr3Hem+QN0qoG6QMOIaJXFW2VamNyYHWrz0aLpYwz41t1hifVMKtZvuT5tmPiU7UKZqaeMSA7Tw4xJ8SXQ6gcXK9FSKoCNT3kfmAUiEL66HTWnL2mp2DAMY2fgn1TJbchlSo32Szi+alXrpmwDpKAuCfvkGsG3s0m5A52zgovLO+gkRv8BPOKKzSUUZXDsfGnugBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4347.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(66476007)(8936002)(6486002)(66556008)(6666004)(2906002)(6506007)(6512007)(316002)(86362001)(2616005)(5660300002)(36756003)(1076003)(8676002)(4326008)(38100700002)(83380400001)(6916009)(107886003)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5e2nO3+fKN0Y+x9vFibXpvspQUGBvwm+w3ip8JeHDx8J0Lru5HCuCdhuyJIh?=
 =?us-ascii?Q?U0gPX+u+SsESUnHKbhxzmCOiu5fekpkojsYRbJOx+cXVjNvoijcC9Uh0iZkq?=
 =?us-ascii?Q?g/hn2DINOct/JYXJbqoyFBbQxasI4GJsZccz+N+jCZNZwNzXN9xd2u4DDRkd?=
 =?us-ascii?Q?aTsbNwGfTPQSWJdJxtNJgIzXLEKo588mc953HYvqr2NiV5MlUlw7smsE0qQt?=
 =?us-ascii?Q?acwbxpdrGRGaBBJc70nA65Dpz2/G83NOrrhK7MxjhCyLM2hFCRueB4+fRXGx?=
 =?us-ascii?Q?9XzvyXTdxchRRvHk++2UQECpCBy0Q2kAByuPl46eFQ5HFG6ej+dLv1Cm5zGU?=
 =?us-ascii?Q?ykYwKuNYgDTZQMTEnRVi4EnoeeyVPUTkEeabAmkCkNfH9oRL5/3FC8/7hBwC?=
 =?us-ascii?Q?v1uHES8kA6G6zP2KOLHMIdmY/BqOYLZnd0twBKRlp+ZA6K+ankOi3g6fdWDC?=
 =?us-ascii?Q?z8VNePbipHpWdQCcLmkcYa/x8BgsS/afI/3aqhG9aH42dfk9eBkSBz2aabNz?=
 =?us-ascii?Q?evUU5F/LcwDZKdR6ClamfCML5Wj0WsTnYdV/FfkY8Eird2Ggb8ldjhrz5fvQ?=
 =?us-ascii?Q?zlJgXIRmOOnW9Nzjzf5J/WemwxoR1AkD93//v8Emj9cDQ0hDrnmxUweMEE4z?=
 =?us-ascii?Q?qg0CnktCH7kCUIxJ+f8PES59DBUOtYlAc6cFtBuKostHozNi6PMYr11MsfuP?=
 =?us-ascii?Q?pRcs6hLB0tugANQ2nB0t1ravIy6BM8R049TL4c6+4Uo8Q/BSEiEZVTJa419t?=
 =?us-ascii?Q?jTf8cO5uTsgfi5hI2nq5cW2Lj2MMDsRq9VvLUPdtyYk3HoVcPZaE3u6tT1og?=
 =?us-ascii?Q?aZ5ve1y4O8ffsx2b6GI/8ETKsA1AGffFzBMPA6EjiyoCOR7ILhg2gnxF7V5m?=
 =?us-ascii?Q?XuCv/Twm2u+D8u4524FH5z86ZDqe2TwQETwjy2dHAECEulUBdAoQR6Lo01ZL?=
 =?us-ascii?Q?bVe+uvSAnm2aPhWTSH4Z8FGG0LuYWkfNnM8ptAYegClOjFOvs6fghWE1SIS+?=
 =?us-ascii?Q?LqHruksv7MzpBLzR2LYC4W9OV0K0Apc1WT4FnbxTugffxpCuRvlQffjy6zxU?=
 =?us-ascii?Q?9g6jLX5m8Qr3u57gr+ofCv9rHnZVC+I50zO9R16Pep8hDgjLkqQnsIwlNz2X?=
 =?us-ascii?Q?wOEYJcBS0esJBv8iRl1E8uYHZ8zHnaDyjxf504eyNztrP15FWj/VcrycMETX?=
 =?us-ascii?Q?L/h8WtQ/VRqBP7DEME/RIWezl1pAwJDlSC6tpXil9YYxi8obb6n3S3VIQtiG?=
 =?us-ascii?Q?Y2AKKqF6xLFmUHjLayyD/EqV5B1LtQnwYp8i5NFbgh70iVR9YcCuSFLbIDvu?=
 =?us-ascii?Q?uOjn6OhQRmrTjWChQVABR3s57CEY+7INSjzI1BXmaDGHXVv8b7CHb1dV1/33?=
 =?us-ascii?Q?wJJgh+M53T9Rd9iJ1/yHO35nMsAS5IdM+w1eGrsHGgDVrs/GWFTtGf5yyqXb?=
 =?us-ascii?Q?4jSikwShbJgw6iAeQQBSemftNmj7XKkd2rOfZN4sRKmANrVvgg2MFGZayGzn?=
 =?us-ascii?Q?9PfdEV0eJDmA8M+cpztyDbcETs84G75bjr8p5W2ufCyyK2O35h/huhQXW4bY?=
 =?us-ascii?Q?WN5XWMHw0iSQOGU57+yehfPzKYpLnpWL0BntVHCSIBCW8Ua4AVXmmxbYqrHd?=
 =?us-ascii?Q?667OZD3NROYDDIujvqJa+SI2QDPKsuSr+aD9e4iF5EZun54/D7uj3aURz/Ut?=
 =?us-ascii?Q?ZwoQhRY0+BTRwIHUsLn2Su2xmbfLD13bgqhRu9pCEK4LYafXGoZHL1y7AbIO?=
 =?us-ascii?Q?1qQJ99mQJQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e589d91-4613-4961-0350-08da22149c02
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4347.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 14:55:14.0133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loigrt4ptkydweL38SXB2w3lpk/z15T+dlGZcGqORdyaBdK10bNIoY/NkCojOghhk2wjn12Tzgwgc2XSnuNHWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1216
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce an infrastructure allowing users to register a set
of operations which are to be called whenever a line card gets
active/inactive.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  17 +++
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 137 ++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 850fff51b79f..c2a891287047 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -590,6 +590,8 @@ struct mlxsw_linecards {
 	const struct mlxsw_bus_info *bus_info;
 	u8 count;
 	struct mlxsw_linecard_types_info *types_info;
+	struct list_head event_ops_list;
+	struct mutex event_ops_list_lock; /* Locks accesses to event ops list */
 	struct mlxsw_linecard linecards[];
 };
 
@@ -603,4 +605,19 @@ int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 			 const struct mlxsw_bus_info *bus_info);
 void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core);
 
+typedef void mlxsw_linecards_event_op_t(struct mlxsw_core *mlxsw_core,
+					u8 slot_index, void *priv);
+
+struct mlxsw_linecards_event_ops {
+	mlxsw_linecards_event_op_t *got_active;
+	mlxsw_linecards_event_op_t *got_inactive;
+};
+
+int mlxsw_linecards_event_ops_register(struct mlxsw_core *mlxsw_core,
+				       struct mlxsw_linecards_event_ops *ops,
+				       void *priv);
+void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
+					  struct mlxsw_linecards_event_ops *ops,
+					  void *priv);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 1d50bfe67156..90e487cc2e2a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -95,6 +95,137 @@ static void mlxsw_linecard_provision_fail(struct mlxsw_linecard *linecard)
 	devlink_linecard_provision_fail(linecard->devlink_linecard);
 }
 
+struct mlxsw_linecards_event_ops_item {
+	struct list_head list;
+	const struct mlxsw_linecards_event_ops *event_ops;
+	void *priv;
+};
+
+static void
+mlxsw_linecard_event_op_call(struct mlxsw_linecard *linecard,
+			     mlxsw_linecards_event_op_t *op, void *priv)
+{
+	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
+
+	if (!op)
+		return;
+	op(mlxsw_core, linecard->slot_index, priv);
+}
+
+static void
+mlxsw_linecard_active_ops_call(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_linecards *linecards = linecard->linecards;
+	struct mlxsw_linecards_event_ops_item *item;
+
+	mutex_lock(&linecards->event_ops_list_lock);
+	list_for_each_entry(item, &linecards->event_ops_list, list)
+		mlxsw_linecard_event_op_call(linecard,
+					     item->event_ops->got_active,
+					     item->priv);
+	mutex_unlock(&linecards->event_ops_list_lock);
+}
+
+static void
+mlxsw_linecard_inactive_ops_call(struct mlxsw_linecard *linecard)
+{
+	struct mlxsw_linecards *linecards = linecard->linecards;
+	struct mlxsw_linecards_event_ops_item *item;
+
+	mutex_lock(&linecards->event_ops_list_lock);
+	list_for_each_entry(item, &linecards->event_ops_list, list)
+		mlxsw_linecard_event_op_call(linecard,
+					     item->event_ops->got_inactive,
+					     item->priv);
+	mutex_unlock(&linecards->event_ops_list_lock);
+}
+
+static void
+mlxsw_linecards_event_ops_register_call(struct mlxsw_linecards *linecards,
+					const struct mlxsw_linecards_event_ops_item *item)
+{
+	struct mlxsw_linecard *linecard;
+	int i;
+
+	for (i = 0; i < linecards->count; i++) {
+		linecard = mlxsw_linecard_get(linecards, i + 1);
+		mutex_lock(&linecard->lock);
+		if (linecard->active)
+			mlxsw_linecard_event_op_call(linecard,
+						     item->event_ops->got_active,
+						     item->priv);
+		mutex_unlock(&linecard->lock);
+	}
+}
+
+static void
+mlxsw_linecards_event_ops_unregister_call(struct mlxsw_linecards *linecards,
+					  const struct mlxsw_linecards_event_ops_item *item)
+{
+	struct mlxsw_linecard *linecard;
+	int i;
+
+	for (i = 0; i < linecards->count; i++) {
+		linecard = mlxsw_linecard_get(linecards, i + 1);
+		mutex_lock(&linecard->lock);
+		if (linecard->active)
+			mlxsw_linecard_event_op_call(linecard,
+						     item->event_ops->got_inactive,
+						     item->priv);
+		mutex_unlock(&linecard->lock);
+	}
+}
+
+int mlxsw_linecards_event_ops_register(struct mlxsw_core *mlxsw_core,
+				       struct mlxsw_linecards_event_ops *ops,
+				       void *priv)
+{
+	struct mlxsw_linecards *linecards = mlxsw_core_linecards(mlxsw_core);
+	struct mlxsw_linecards_event_ops_item *item;
+
+	if (!linecards)
+		return 0;
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item)
+		return -ENOMEM;
+	item->event_ops = ops;
+	item->priv = priv;
+
+	mutex_lock(&linecards->event_ops_list_lock);
+	list_add_tail(&item->list, &linecards->event_ops_list);
+	mutex_unlock(&linecards->event_ops_list_lock);
+	mlxsw_linecards_event_ops_register_call(linecards, item);
+	return 0;
+}
+EXPORT_SYMBOL(mlxsw_linecards_event_ops_register);
+
+void mlxsw_linecards_event_ops_unregister(struct mlxsw_core *mlxsw_core,
+					  struct mlxsw_linecards_event_ops *ops,
+					  void *priv)
+{
+	struct mlxsw_linecards *linecards = mlxsw_core_linecards(mlxsw_core);
+	struct mlxsw_linecards_event_ops_item *item, *tmp;
+	bool found = false;
+
+	if (!linecards)
+		return;
+	mutex_lock(&linecards->event_ops_list_lock);
+	list_for_each_entry_safe(item, tmp, &linecards->event_ops_list, list) {
+		if (item->event_ops == ops && item->priv == priv) {
+			list_del(&item->list);
+			found = true;
+			break;
+		}
+	}
+	mutex_unlock(&linecards->event_ops_list_lock);
+
+	if (!found)
+		return;
+	mlxsw_linecards_event_ops_unregister_call(linecards, item);
+	kfree(item);
+}
+EXPORT_SYMBOL(mlxsw_linecards_event_ops_unregister);
+
 static int
 mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
 			     u16 hw_revision, u16 ini_version)
@@ -163,12 +294,14 @@ static int mlxsw_linecard_ready_clear(struct mlxsw_linecard *linecard)
 
 static void mlxsw_linecard_active_set(struct mlxsw_linecard *linecard)
 {
+	mlxsw_linecard_active_ops_call(linecard);
 	linecard->active = true;
 	devlink_linecard_activate(linecard->devlink_linecard);
 }
 
 static void mlxsw_linecard_active_clear(struct mlxsw_linecard *linecard)
 {
+	mlxsw_linecard_inactive_ops_call(linecard);
 	linecard->active = false;
 	devlink_linecard_deactivate(linecard->devlink_linecard);
 }
@@ -954,6 +1087,8 @@ int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 	linecards->count = slot_count;
 	linecards->mlxsw_core = mlxsw_core;
 	linecards->bus_info = bus_info;
+	INIT_LIST_HEAD(&linecards->event_ops_list);
+	mutex_init(&linecards->event_ops_list_lock);
 
 	err = mlxsw_linecard_types_init(mlxsw_core, linecards);
 	if (err)
@@ -1001,5 +1136,7 @@ void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core)
 				    ARRAY_SIZE(mlxsw_linecard_listener),
 				    mlxsw_core);
 	mlxsw_linecard_types_fini(linecards);
+	mutex_destroy(&linecards->event_ops_list_lock);
+	WARN_ON(!list_empty(&linecards->event_ops_list));
 	vfree(linecards);
 }
-- 
2.33.1

