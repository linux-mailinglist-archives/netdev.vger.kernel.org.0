Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4734057F3E8
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 10:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiGXIFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 04:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239774AbiGXIFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 04:05:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5749C11C0B
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 01:05:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jfy1XgoXX0FFF1wiyWdfjAzypmEiTKN8LPrGMFncAjug9J2c59q8G+MyZGcqiVqpmec2nB9BQk66eDrzu4+KlqQjCNwPvUTMm/lInxKlpKZrp+wzK6WGQ7Fau//Oi0W+P3tt1JI22HIw6I8y9fsLCF7OycfL7bkxBZw/nDDcHcy2BRtTalNM5uAmnaKKrGD7M1MSLrcBwlyEI26KCO3RjcOjIPHj8/nGyHXR17sWHldmhqr5eIEUblxQcpHf+npJhL3v35gOZFhboWCzp9lqO4yKibdScLmlmjA9aI0Zvz4VHWAj7uA25xaVd/SJ78oiOmTA52U+06ay3AHNuIC+aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PuEk8wjR3ubARC4fqYAqEZ/3Gc9B8WKfDTOE2vWI+ok=;
 b=YHg60ITilDoC740/vB5Zxys/stHKomu6UJltipMkno6sp4ZpMz9KBZEgNRyYwzT+QDnzXhpP2toPza1KNjQrOOvj1AWcliOC3p9cS5Od5muH1BmbXgWCuCW1bR0st9wNYhoKbE49yc7mnzjgv03E/huBpCMvMRMpZH2QxUxGOAQKrCiPvbxzfjDiGk71N2guGNBoaCcwm+64x5/RUhEal0bzfbBn5df0l/iVStmtexxO+eDBJsfN98Qp6+7AGaxqSn8stHbT4pE2Zq7wCO7aYWHB72bHO63fKm7VmeCHZkscSSzJpXwljChUNtjSp9YQunoVk7ufA1BY90J1CWhH7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PuEk8wjR3ubARC4fqYAqEZ/3Gc9B8WKfDTOE2vWI+ok=;
 b=r4N1529+WIsLwB8bpL9dm4p40TXlwdFQ/KfkME86s/7T31HhZa59u7AmhOgfK7Y3oY0TZ/Ms8vvNoL2/VEozIQkYbQxPn+bhxsuhWkxtAVUIZUBQaWoYZXkYikZ1JG7+fZCsY1HSZhCFgEOIOeRlaYq4yxBHNOtK5ao6+u5fD9xjc+1zOAzewd6pVGUL2wjH289GA8u+472Xwl0egNzOUG+u6VBYZOlA/Ocu2ZzImqTnE4Tpnaw7mUE0QrttiOzlNaVLbUehVZ1hgO4Vr6YJhwc6L3XdGEHIioSJB1ntCHl2FrMQFkU8u3JvArDTczjzocUu6v/8xM/7Walh3imCow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR12MB1915.namprd12.prod.outlook.com (2603:10b6:3:10c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Sun, 24 Jul
 2022 08:05:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5458.020; Sun, 24 Jul 2022
 08:05:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        danieller@nvidia.com, richardcochran@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/15] mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_state' per ASIC
Date:   Sun, 24 Jul 2022 11:03:26 +0300
Message-Id: <20220724080329.2613617-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
References: <20220724080329.2613617-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::16) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17f3a626-977e-414b-42f2-08da6d4b460f
X-MS-TrafficTypeDiagnostic: DM5PR12MB1915:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bnq4pKzwelupvxVqeEf2i3Nqyz1QH5CdzL3fqxEf0CmsnDAl6KfSdD/C9eNg6keE1E4D39ZXpnXyOTz+RJFZ34BJMcZTGbYlGfBjrboqMWC7SaRpcUH/6JZYquVIsBltK+bcK1tkGkVlOtoFDxXqDO6Zomo8yFwG5mp1HnECe1ksopdTKvIRg1mw7mI53PTTaAX8xw858xYFxTnvp8/P5Ct8K4+erfr1uFKpJmCcv0h405o8NcGdu8QpumPrxpcgFAEEE+RzEuIbqCfHuXve0R4UjL66zjYjmjfyLWnr0DdtIhHARx3ehH2UajEsYtEOxmYSwGCe02dD3ONEXFGvTbR5pPG0rNy4u9DZf01RfyBhEw/YMDEGnBCi7dkuCyy0Rv7nXy/xdlkChkYEmXFuDhEHFB181kPU/VKh12QeGFaCCLfaY3Z3mT9HRHPKDyCUU6uSfeHu0woECgGWSZFSsKO5LzQbQ8hbbUm+UiVYiVxNBG0tzhvn4J/FBqtAJ7Z8+tM+Ydm9+D8AQQB4fcl500HiYrEKUPmP/KoDfOteCELHTe9m4xl5og5WinZ9rkQG4KUuGl1jbHLp5xKQ2J2cPH77lzfrASS8iZc9vRJVeisvAuDILVm8kXYYEPq2L6/35+93RF1zzv1PDH0MTWtvJDFsOpiSSd+9YmAesLKwaSLCxHIKcbg8idLF03LXszgWP3t31nvnYPSZ35w2fgV2v1On/aXB9o42oewYKshuY4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(316002)(36756003)(86362001)(478600001)(38100700002)(6486002)(6506007)(6916009)(6666004)(2906002)(83380400001)(6512007)(8676002)(107886003)(186003)(66946007)(66556008)(4326008)(26005)(66476007)(8936002)(5660300002)(1076003)(2616005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+nxaw0xpq/k4XXtqpgTW2IeKkUyKhLQdQTKG7PkIiu4iZTxbgG+K2cSDwAnI?=
 =?us-ascii?Q?Pkl7eqPqjJ4aTPDg0WKV4y6lv44MY8qkl7Piuy7NWHW+L/TmFI1iATnM50N8?=
 =?us-ascii?Q?ZJr/uBdvPAF9AexOHNwo1eUqjXWRjKLbailRw48bCybSch0WlWGZUraTy0yv?=
 =?us-ascii?Q?pqXG9ZJ4DTFJgLdVnxonjccTW+SfTwCAb0pIbpOCqt8q9puEvUAQ9LU9ebjL?=
 =?us-ascii?Q?nx+uJH4y7C/WBffja5gjbQYfVLmV/kCEKVRDrWgmMY6Hmvb9TRtYs3X4nL1Y?=
 =?us-ascii?Q?wpX4bPMG5g/elrNCs7oF5Y6JXF4PmthOGXZOGjLA4uxgHDri4VvyBPOzet7o?=
 =?us-ascii?Q?gt/LTN+S87YAaXGlwx9zBmzq5Q3bNF3pWr3kqZdfzdIr4Gl3JDnZlb1nHuu7?=
 =?us-ascii?Q?TbRhyX4WGlF8UBRgHXgmWH2aJAvLR0Cajdn1jqKkTpPUQYFr3i5Q39eQwC6J?=
 =?us-ascii?Q?KuR0VtFiinNkhGku80Y3kJ7hgRd6MyeH7+uNdiyKG8Xgo8fs1QyFebRCk1yD?=
 =?us-ascii?Q?RQy/GhieG5ReKFbBFpNwaA2tTqd6OeLdyE+ssU1kh7ElvB7qmRfWZt/ZciIV?=
 =?us-ascii?Q?dEwsUrTjAFK4kVwUzyGO7w9VcgNc/BKaOZefGBD4U02oc0w1tqimziVtenKb?=
 =?us-ascii?Q?zcfIczWf7z0I8SwiMbODKrzTyPgi7MGaVeEFZvIWFjEccautrKW0QbY0Hads?=
 =?us-ascii?Q?cgqXzWQL7pcaoUV+VAar30QesatxwxSHUqLOvvMTnaJkdHpZm3mwOJg9HmCR?=
 =?us-ascii?Q?FvAIIe6ePGTLGwycj0fii6/Ixyh8jtu/F3omQ+L3mnw8+lWzLe+TmbAOSMMm?=
 =?us-ascii?Q?ceHr2gOjvypBfOz+ghu8g7eiUCB1k+biDI6c4ju87WC/VCjktsoS1J3/IRCe?=
 =?us-ascii?Q?kQ03gAny4U8VEbYQ+WkhSX39PiYMt5hqv5AuH1QTK2W3q5yJxYBHJzrU+pOc?=
 =?us-ascii?Q?xLvQgGVVWbkCBgX6kvdcd3uGCk5T9Y3hgXUCks8ru5wWkMQIazscmvW7cQnk?=
 =?us-ascii?Q?IYXDCqJTSTD5X+z56gFofs+4fYzeFQbocmFCTq5fCufGQ8fC55urtc2PmMTb?=
 =?us-ascii?Q?/aDtWmNjIhj+JKHwJDznlbKMe5LenlO2dRb1nEJMoXG0DDoNiIEbn52ZHEJk?=
 =?us-ascii?Q?FU8tJYLD5BEgTfD1ueFME3ihb5jPyidF32b8QQM4nAemDxM/IcKgOdbiKDue?=
 =?us-ascii?Q?XReTzT7UTXIa6EbOqaSTTjC0sE7gWDl+GS9zzC9eCgXaVEJ2ssBY3MuE6ger?=
 =?us-ascii?Q?p9QRUu7gi5VS8Qq5S1h1Epn2ufJn4r1a5Y0kefULQ8pJdA1WU7Rb9O+6qQwM?=
 =?us-ascii?Q?wrwTUmlNaH7MUPI+J1osvwbY/JrKgcM/FSvjCYViaBpYo5v1XzI43/pTqfJ/?=
 =?us-ascii?Q?ac/v+MJnpmyovUVqEXxwR3tsJNpccZpqbmCbDBJ2rc+JqRnXsdMAyN9RO6hv?=
 =?us-ascii?Q?M55GG4F1e+OzaKEM4EtoHoJmzDQOU/QJjuNsAeCnB9gJwkj2/YpsdIdqSqou?=
 =?us-ascii?Q?Ntccg90Uqa0kaSK6Yl842VuiPAdUBR+7ko07Plkz5Ot3dSmTAbpYsA8AVNtE?=
 =?us-ascii?Q?+In4EK4/QtYnRrGfYnvlxEO5AEwG19jSwp183RHO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f3a626-977e-414b-42f2-08da6d4b460f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2022 08:05:29.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j/IQBrvck7UMp4vGUMUtn+Q8Xuvkas2iONOC4a3GG2imfvH6z+aWquCAQWH14CMpnm2hBpKUfichkCgVWQuw2g==
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

Currently, there is one shared structure that holds the required
structures and details for PTP. Most of the existing fields are relevant
only for Spectrum-1 (hash table, lock for hash table, delayed work, and
more). Rename the structure to be specific for Spectrum-1 and align the
existing code. Add a common structure which includes
'struct mlxsw_sp *mlxsw_sp' and will be returned from ptp_init()
operation, as the definition is shared between all ASICs' operations.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 51 +++++++++++++------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
index eab3d63ad2ac..c5ceb4326074 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
@@ -29,6 +29,10 @@
 
 struct mlxsw_sp_ptp_state {
 	struct mlxsw_sp *mlxsw_sp;
+};
+
+struct mlxsw_sp1_ptp_state {
+	struct mlxsw_sp_ptp_state common;
 	struct rhltable unmatched_ht;
 	spinlock_t unmatched_lock; /* protects the HT */
 	struct delayed_work ht_gc_dw;
@@ -70,6 +74,13 @@ struct mlxsw_sp_ptp_clock {
 	struct delayed_work overflow_work;
 };
 
+static struct mlxsw_sp1_ptp_state *
+mlxsw_sp1_ptp_state(struct mlxsw_sp *mlxsw_sp)
+{
+	return container_of(mlxsw_sp->ptp_state, struct mlxsw_sp1_ptp_state,
+			    common);
+}
+
 static u64 __mlxsw_sp1_ptp_read_frc(struct mlxsw_sp_ptp_clock *clock,
 				    struct ptp_system_timestamp *sts)
 {
@@ -347,7 +358,7 @@ mlxsw_sp1_ptp_unmatched_save(struct mlxsw_sp *mlxsw_sp,
 			     u64 timestamp)
 {
 	int cycles = MLXSW_SP1_PTP_HT_GC_TIMEOUT / MLXSW_SP1_PTP_HT_GC_INTERVAL;
-	struct mlxsw_sp_ptp_state *ptp_state = mlxsw_sp->ptp_state;
+	struct mlxsw_sp1_ptp_state *ptp_state = mlxsw_sp1_ptp_state(mlxsw_sp);
 	struct mlxsw_sp1_ptp_unmatched *unmatched;
 	int err;
 
@@ -358,7 +369,7 @@ mlxsw_sp1_ptp_unmatched_save(struct mlxsw_sp *mlxsw_sp,
 	unmatched->key = key;
 	unmatched->skb = skb;
 	unmatched->timestamp = timestamp;
-	unmatched->gc_cycle = mlxsw_sp->ptp_state->gc_cycle + cycles;
+	unmatched->gc_cycle = ptp_state->gc_cycle + cycles;
 
 	err = rhltable_insert(&ptp_state->unmatched_ht, &unmatched->ht_node,
 			      mlxsw_sp1_ptp_unmatched_ht_params);
@@ -372,11 +383,12 @@ static struct mlxsw_sp1_ptp_unmatched *
 mlxsw_sp1_ptp_unmatched_lookup(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp1_ptp_key key, int *p_length)
 {
+	struct mlxsw_sp1_ptp_state *ptp_state = mlxsw_sp1_ptp_state(mlxsw_sp);
 	struct mlxsw_sp1_ptp_unmatched *unmatched, *last = NULL;
 	struct rhlist_head *tmp, *list;
 	int length = 0;
 
-	list = rhltable_lookup(&mlxsw_sp->ptp_state->unmatched_ht, &key,
+	list = rhltable_lookup(&ptp_state->unmatched_ht, &key,
 			       mlxsw_sp1_ptp_unmatched_ht_params);
 	rhl_for_each_entry_rcu(unmatched, tmp, list, ht_node) {
 		last = unmatched;
@@ -391,7 +403,9 @@ static int
 mlxsw_sp1_ptp_unmatched_remove(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp1_ptp_unmatched *unmatched)
 {
-	return rhltable_remove(&mlxsw_sp->ptp_state->unmatched_ht,
+	struct mlxsw_sp1_ptp_state *ptp_state = mlxsw_sp1_ptp_state(mlxsw_sp);
+
+	return rhltable_remove(&ptp_state->unmatched_ht,
 			       &unmatched->ht_node,
 			       mlxsw_sp1_ptp_unmatched_ht_params);
 }
@@ -480,13 +494,14 @@ static void mlxsw_sp1_ptp_got_piece(struct mlxsw_sp *mlxsw_sp,
 				    struct mlxsw_sp1_ptp_key key,
 				    struct sk_buff *skb, u64 timestamp)
 {
+	struct mlxsw_sp1_ptp_state *ptp_state = mlxsw_sp1_ptp_state(mlxsw_sp);
 	struct mlxsw_sp1_ptp_unmatched *unmatched;
 	int length;
 	int err;
 
 	rcu_read_lock();
 
-	spin_lock(&mlxsw_sp->ptp_state->unmatched_lock);
+	spin_lock(&ptp_state->unmatched_lock);
 
 	unmatched = mlxsw_sp1_ptp_unmatched_lookup(mlxsw_sp, key, &length);
 	if (skb && unmatched && unmatched->timestamp) {
@@ -514,7 +529,7 @@ static void mlxsw_sp1_ptp_got_piece(struct mlxsw_sp *mlxsw_sp,
 		WARN_ON_ONCE(err);
 	}
 
-	spin_unlock(&mlxsw_sp->ptp_state->unmatched_lock);
+	spin_unlock(&ptp_state->unmatched_lock);
 
 	if (unmatched)
 		mlxsw_sp1_ptp_unmatched_finish(mlxsw_sp, unmatched);
@@ -610,9 +625,10 @@ void mlxsw_sp1_ptp_transmitted(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void
-mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp_ptp_state *ptp_state,
+mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp1_ptp_state *ptp_state,
 			    struct mlxsw_sp1_ptp_unmatched *unmatched)
 {
+	struct mlxsw_sp *mlxsw_sp = ptp_state->common.mlxsw_sp;
 	struct mlxsw_sp_ptp_port_dir_stats *stats;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	int err;
@@ -635,7 +651,7 @@ mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp_ptp_state *ptp_state,
 		/* The packet was matched with timestamp during the walk. */
 		goto out;
 
-	mlxsw_sp_port = ptp_state->mlxsw_sp->ports[unmatched->key.local_port];
+	mlxsw_sp_port = mlxsw_sp->ports[unmatched->key.local_port];
 	if (mlxsw_sp_port) {
 		stats = unmatched->key.ingress ?
 			&mlxsw_sp_port->ptp.stats.rx_gcd :
@@ -652,7 +668,7 @@ mlxsw_sp1_ptp_ht_gc_collect(struct mlxsw_sp_ptp_state *ptp_state,
 	 * netif_receive_skb(), in process context, is seen elsewhere in the
 	 * kernel, notably in pktgen.
 	 */
-	mlxsw_sp1_ptp_unmatched_finish(ptp_state->mlxsw_sp, unmatched);
+	mlxsw_sp1_ptp_unmatched_finish(mlxsw_sp, unmatched);
 
 out:
 	local_bh_enable();
@@ -662,12 +678,12 @@ static void mlxsw_sp1_ptp_ht_gc(struct work_struct *work)
 {
 	struct delayed_work *dwork = to_delayed_work(work);
 	struct mlxsw_sp1_ptp_unmatched *unmatched;
-	struct mlxsw_sp_ptp_state *ptp_state;
+	struct mlxsw_sp1_ptp_state *ptp_state;
 	struct rhashtable_iter iter;
 	u32 gc_cycle;
 	void *obj;
 
-	ptp_state = container_of(dwork, struct mlxsw_sp_ptp_state, ht_gc_dw);
+	ptp_state = container_of(dwork, struct mlxsw_sp1_ptp_state, ht_gc_dw);
 	gc_cycle = ptp_state->gc_cycle++;
 
 	rhltable_walk_enter(&ptp_state->unmatched_ht, &iter);
@@ -808,7 +824,7 @@ static int mlxsw_sp1_ptp_shaper_params_set(struct mlxsw_sp *mlxsw_sp)
 
 struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 {
-	struct mlxsw_sp_ptp_state *ptp_state;
+	struct mlxsw_sp1_ptp_state *ptp_state;
 	u16 message_type;
 	int err;
 
@@ -819,7 +835,7 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	ptp_state = kzalloc(sizeof(*ptp_state), GFP_KERNEL);
 	if (!ptp_state)
 		return ERR_PTR(-ENOMEM);
-	ptp_state->mlxsw_sp = mlxsw_sp;
+	ptp_state->common.mlxsw_sp = mlxsw_sp;
 
 	spin_lock_init(&ptp_state->unmatched_lock);
 
@@ -852,7 +868,7 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	INIT_DELAYED_WORK(&ptp_state->ht_gc_dw, mlxsw_sp1_ptp_ht_gc);
 	mlxsw_core_schedule_dw(&ptp_state->ht_gc_dw,
 			       MLXSW_SP1_PTP_HT_GC_INTERVAL);
-	return ptp_state;
+	return &ptp_state->common;
 
 err_fifo_clr:
 	mlxsw_sp_ptp_mtptpt_set(mlxsw_sp, MLXSW_REG_MTPTPT_TRAP_ID_PTP1, 0);
@@ -865,9 +881,12 @@ struct mlxsw_sp_ptp_state *mlxsw_sp1_ptp_init(struct mlxsw_sp *mlxsw_sp)
 	return ERR_PTR(err);
 }
 
-void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state)
+void mlxsw_sp1_ptp_fini(struct mlxsw_sp_ptp_state *ptp_state_common)
 {
-	struct mlxsw_sp *mlxsw_sp = ptp_state->mlxsw_sp;
+	struct mlxsw_sp *mlxsw_sp = ptp_state_common->mlxsw_sp;
+	struct mlxsw_sp1_ptp_state *ptp_state;
+
+	ptp_state = mlxsw_sp1_ptp_state(mlxsw_sp);
 
 	cancel_delayed_work_sync(&ptp_state->ht_gc_dw);
 	mlxsw_sp1_ptp_mtpppc_set(mlxsw_sp, 0, 0);
-- 
2.36.1

