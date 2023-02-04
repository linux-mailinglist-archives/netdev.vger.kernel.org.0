Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B906468AB92
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjBDRN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjBDRN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:13:57 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E0C3345A
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:13:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvqm3zqTIE5i3S2TTRyXlngr7YJrVLgn+RUZFl7rB5EVPy+vn40xjj8x3UAX5XHuN5JGDVEEGqxRfxj5C/zWTMrDQod/IFwvHlv7UHKouFeeA70HokhyN2sfnh2O0TGuHmGyKtug7ftldi/BDBkCL9ccQ+CBxoXNXXUmd/933gyDz/EBB/cKhCHbBOBgIwN4doeNTva5saOgdLpd6qZPcuNweC6pq98iGCEAQpuY6oI8kaA9w7hCiwTPx14Ies+RbNQrNAK1sgSKTOBtqIIWiYfO3hxNHHf+paxs+iY+9YEXB8CP3pk7tcO8jX9UxG6ipuBqT4jQ1yd6GxqZgDndUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=886fnpq+IvsanNM1sSgN71E2LKYdIG2xDXhWO2Cui5k=;
 b=TWSZm50f9rExncDEMJxBaU4mLcHwg5ps06AGslQ12dSUtjBuR8lEPRF18ppLFdJO5Aa6SuYMr3YI3musNbbzDwBLM80rUNSC6qiSuH14BieRGa0ISMga5opfrdWp8LHzncTDkRZ3PzsIvxUqgUzyB0X30U+r10hUt8mHTK8Kij/fBjjxioOIn3Bb4YBFCU0ksGcQL/KSAK/OztoTsNiK0wGoa2+V8rLL+g5OcRrtyR+7eVh27mwM8jmjC9dLekOsxoJosX7/ygoLNPtVWwr3mIwgF7BYTm8MjkHUmrRYJZAQPgxmM9VmSjGixuXB4k77kqywLee5eiIbzP2Ec3S0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=886fnpq+IvsanNM1sSgN71E2LKYdIG2xDXhWO2Cui5k=;
 b=OqCzO2EUHuTJmZQIEpECtloRkG1s3hbkTkuKhFDXratuJwoeZAhUgpDnO+5r98ctl98/psj58qbG0jAaJ6X5Jru3KH+eF5/XIRyRZVraJ5E7Dl5sr6mHhbb5uoyf4YZDlU5WrLgGFSJ90T7kUND7sx3V2CR97/2AwUe6nKCLQYOXvxlzt8PSRhfxaLpOTnUgFbEZogLgdOxOUdmejEz9PeQdb8uKMij/r8ovmJleVA82ATIbjgSWYr0j+y3FzOml8CkOcF95krp13IIhOsAdm+ubSiVS6x4PbvXz0yiAxBV9HTwHOIuvlGrBUs+bdN3KkzRWsMX43rt5Si5bgen+SA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:56 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:56 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 11/13] vxlan: mdb: Add an internal flag to indicate MDB usage
Date:   Sat,  4 Feb 2023 19:07:59 +0200
Message-Id: <20230204170801.3897900-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0117.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::46) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 57735ccb-484c-49aa-0380-08db06d30f11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rkzLGdAUaSpEQ3XUGaxjVEbViw7nQ8O+2Hte21qu29wehTrbdlo21ocEZLoycYPTwHfIiUpcLDfZ6ax4wnR3heutqRCfITLsyOjMw9wGScZNfQB5ablhWxtkQkhBlb33W61JpMCYw2zS+jRsjMvH9VskRx6dAgHx4tcnkyS1yGrh5Og/uqfADstvua06U+Fm9mYb4aF5yjiFP/nqHdAeYWtCDtVfPQ91FiOTgFK8rOOWIoBb6NgR15zNHcWqNme4PXDaAy2i2I7B8Ywz/o8RlsGQO3ves+Evy28jstsDu8MB6RKyI7PBTIBV9tOxGHWP0dI0mXzrtWCUdRYfkaiUNjoreWUF60ok1Fs/DCdWmE2q+PSGcgXW0CK+fSScZkEfLU11rRnA8AIlG/1IOx8nkvZiXML8rK6nnHSvhieJhYidQXdV0YtGuGqnmVGoMJ2nvdE5XuF7mr65HyB8ODTg+jd//kF+MUk0NJEp/+lGMmGzYy5/MWuqRwzOPS4bpZKGCH/mDZWvNQMMHo0qOUl0N6fEuMuOxXyzcL7tZc5jiTxtaLwagCPaaE7m1lOW03MUCcKqItK0jgi7uc0n1R48rVp49xl8DP5+FdjNwI1KH66fbTsKlxhdLYFv1jMp1cdLQYKsaVYpaZE22wT693c8EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8936002)(36756003)(5660300002)(107886003)(1076003)(316002)(6506007)(478600001)(38100700002)(6486002)(66476007)(4326008)(8676002)(66946007)(2616005)(83380400001)(66556008)(41300700001)(86362001)(186003)(2906002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dN5FDzvRd7jL5OQol5z1328LZPonhS4QseRAwRoozjsUIrd5DLUNogbTyNVu?=
 =?us-ascii?Q?s3xMqUZcxD/b7/JMwSf496wdK6fWk92A5y2kB/JViCZ4pGwDw/oSNVr8UW1F?=
 =?us-ascii?Q?IbG0WmCpPnQacPgCPL37WyQ2D1ieo90o+HFAAO0TRT7CQR1bd3X3Q03orgCL?=
 =?us-ascii?Q?HUvnpnKuBqUBfNMg41FC36LjM97OOYhZ78tINwuf2ma7zm7CQiZcVu1KOByk?=
 =?us-ascii?Q?whIMNJodQ0RRFe8ZvE00IXDtjXgs8rwlJTAOf0ekZGICRAOJYn1qiRn+YfZx?=
 =?us-ascii?Q?aSRMu7bIYvdVc+EKxjTEs05eDKRaRPUKAdTKNqPtVg7d90fP2FBRz2Ayj/FL?=
 =?us-ascii?Q?e9FPXdEE5rG4LLRBH20bHF99fDI24d1H88f9HMtV9AzhsPk1qlQmZvhpqcXD?=
 =?us-ascii?Q?CQlpSmQF9MmCEX0kcHbn0UhCRSH0BAl5yFgbba22VEYIt1q0Q0HxyBH2dg6K?=
 =?us-ascii?Q?BtxtfXxz6HN577HUJ1JfeuxUR+cHZ3iVL7xXH4dTUhVR0d9V9Q34XdiHpYAh?=
 =?us-ascii?Q?OnGxxWq5UssEFT4OAMv9/zjPLUaqMaZgpawBN2HBLaxr29VjAE75J5prj1gR?=
 =?us-ascii?Q?8TyMQOiLm3x2CuyjzJtT3BCVG180zQQQwCsQnd5LEjRd5ge1dTtnYdFR/1MG?=
 =?us-ascii?Q?E4Xl2sw6xEfaHBfxWYjmwwGXhMO5wIA2dWyTYdQQaQvAUOvMopjd78vwN9MN?=
 =?us-ascii?Q?+3guPozjq4z4ns/Fbkvs/vtbK3hKBo4CowIAdGsxjAtIdWJmUlRVDuy9c3dQ?=
 =?us-ascii?Q?UkVhHMnFQxSS0tEM/ZEPftdFVDryYI5g5PukuDPtlbk+ITBCGyLQH4UoENuZ?=
 =?us-ascii?Q?qN8H+JJqx2HKDpiOrzchf37KJPhLxjwUOU68NlgDRC2trwvmEj6PDah0o+Ro?=
 =?us-ascii?Q?H00Pm2C3cWl4a+FQqxItgXPCpNkdo19vQA1mzbIARHkWn3D1LXnISJM8eX+q?=
 =?us-ascii?Q?3wDmfV524H8CnsLPuOJrENXTGIRSy1dKOT4V0qWC7aOnx/+F6RqRVUAgelX7?=
 =?us-ascii?Q?v+wXc6YcHF1bHvkOVOljZhJSBhIt0Iwd4sDWtlfyWiegLkcx4T9AjTjZJ5AV?=
 =?us-ascii?Q?AqeNEcgE1VhlhXPgd0hZoJejtAqitZNWMV7ziptDhCAKSkEKU3i0LLHkUMOB?=
 =?us-ascii?Q?JgxhBddw4jtCn6zkBQYKyc8qRARyTb23+B9c6/f1edAG5D5sZXF0DRLes22v?=
 =?us-ascii?Q?5nX0K4ZqGmWzy3PHOIEpRD0e/4Sl2l7qGkqTwuGOsWWQE4qWLbyYZoDKuUqi?=
 =?us-ascii?Q?gGzrH1yaIAljL8IUO4FA2kqCzP0K8Z2NsuSsH1ViyqKYFBpkWG5WWDCCtf9/?=
 =?us-ascii?Q?KAdQqVq+wDyg5JiCpxqTnM1WorzJrrvdUDjv1dOyP6D/+sC8AUcB43qqbOzX?=
 =?us-ascii?Q?AtKE+ESHPZdsEeiHHDDIi0ft5tMKX7M7AKgzbBcnwMrKEiGOuB2W8VQxnrKc?=
 =?us-ascii?Q?d0a9yMQDVzKWTK16CfrJDkIqOKPazOG6ToLN3q8ecdQMsb/itdp3rAwLK1Mi?=
 =?us-ascii?Q?XLo3NIeYegInCBS6kOZRNHSymO+9XhoemjpHVq7L8KamAQ1j607SSfSLx/Bb?=
 =?us-ascii?Q?cx01hP1ckcJT0kksGQ8+LR7ecUE575c+BKznX6L2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57735ccb-484c-49aa-0380-08db06d30f11
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:56.6040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGH9rGoaPfZ9DECj6u0+4a9rAstHUqORegIOQ0l1mCsxh8W/qF3e44u9KeJL6FNtD8+dsOcntX0DdmuKpr6C4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an internal flag to indicate whether MDB entries are configured or
not. Set the flag after installing the first MDB entry and clear it
before deleting the last one.

The flag will be consulted by the data path which will only perform an
MDB lookup if the flag is set, thereby keeping the MDB overhead to a
minimum when the MDB is not used.

Another option would have been to use a static key, but it is global and
not per-device, unlike the current approach.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/vxlan/vxlan_mdb.c | 7 +++++++
 include/net/vxlan.h           | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index 079741da2599..72c922064c02 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1207,6 +1207,9 @@ vxlan_mdb_entry_get(struct vxlan_dev *vxlan,
 	if (err)
 		goto err_free_entry;
 
+	if (hlist_is_singular_node(&mdb_entry->mdb_node, &vxlan->mdb_list))
+		vxlan->cfg.flags |= VXLAN_F_MDB;
+
 	return mdb_entry;
 
 err_free_entry:
@@ -1221,6 +1224,9 @@ static void vxlan_mdb_entry_put(struct vxlan_dev *vxlan,
 	if (!list_empty(&mdb_entry->remotes))
 		return;
 
+	if (hlist_is_singular_node(&mdb_entry->mdb_node, &vxlan->mdb_list))
+		vxlan->cfg.flags &= ~VXLAN_F_MDB;
+
 	rhashtable_remove_fast(&vxlan->mdb_tbl, &mdb_entry->rhnode,
 			       vxlan_mdb_rht_params);
 	hlist_del(&mdb_entry->mdb_node);
@@ -1358,6 +1364,7 @@ int vxlan_mdb_init(struct vxlan_dev *vxlan)
 void vxlan_mdb_fini(struct vxlan_dev *vxlan)
 {
 	vxlan_mdb_entries_flush(vxlan);
+	WARN_ON_ONCE(vxlan->cfg.flags & VXLAN_F_MDB);
 	rhashtable_free_and_destroy(&vxlan->mdb_tbl, vxlan_mdb_check_empty,
 				    NULL);
 }
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 110b703d8978..b7b2e9abfb37 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -327,6 +327,7 @@ struct vxlan_dev {
 #define VXLAN_F_IPV6_LINKLOCAL		0x8000
 #define VXLAN_F_TTL_INHERIT		0x10000
 #define VXLAN_F_VNIFILTER               0x20000
+#define VXLAN_F_MDB			0x40000
 
 /* Flags that are used in the receive path. These flags must match in
  * order for a socket to be shareable
-- 
2.37.3

