Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEDB6BB429
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjCONOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCONOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:14:20 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4782F3C04
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:14:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9goAGuPGh6oCnEcgYs4uHGIWiehd4T6DiqmJy6xI33P+lUhxGE9SZWalDrDXZEQw2DZdBH/udjjexYztYjwwE0FRNIh6SvBUUEVDL27fcnCvC0lar+yRxPeHvtPP+p2m0vHWsfs7xQ+XbCyoCC4LmGfjzZT0H8J1+p0GshM8/yTg/xrCdIiBpUgl49TwvFyyLzNUy1+CdbsatpjwFL5gpW+Fn/OpSId68O/8vcLIz58GfXP3i8RiA5EpAvMARHkHmq4DXQkstU0hUxGGFLDLBHGJVI45IqC35pf+Hzhplb9AuAv7gz8UddBsvDSgggL5oZimOlhQSbByFmwPw/Zxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8/xIsJQcK6FnzRGvR0iwZ17paaEg8VJtJjA1su2xHI=;
 b=VIIGe5h5cW8QYNUXsvlSnXI9BdlruwSD3ZIwDqFHXUVpV7q8zkXIVRSWgzP/rr2HA5cNugYfN3vF9/pL47ssIFTIpY5o0ADRkoUT4X7xNRf5yl07+Z+X2ed85oHD3p7g0Gl5Yx+6w67ZnFcUlZhPxa8RzdMyDDDQoPOHeIPZ8gKB0w7sRu5LDymLlMhp9nL+nrBcTbAcqEFjSt1E+RFWDDn8LjAHnLm5TZtcwqz8TQH9XnfEOPFQbp7HHw6SyWZrrXD9slMSmy5WVqtJ1FFHnBRWQx/ZCRTVoIS96LQD4fjGKUd21UFkwULPrXyS2jCZY/TlqjPGKSBSFwkg6biicg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M8/xIsJQcK6FnzRGvR0iwZ17paaEg8VJtJjA1su2xHI=;
 b=TZaxjykQxadUOt2s7leF0sTa277pcwiw/Cw2klxY9liy3tZsD0ldQuay3EMXlviC27aisbuCneVZoi+xDg2laObEUg36yXiFYtx9D2NxZvmVCpGDbUh6JO42nZqFS5fHyS6P9kQVp3Fy8Lu3OFeoCV7h4g+VTMJkBea37icvmi9PEv92XCI/iwpbHOXqmw7tl31oMYYLVZ3KXVjr65/SkrZkMw0zgD9/TSLMueNXmwJG9HL2omwDcCxbSI8CQGp1l2xdnNjusQy1TvJ+PCHYbWeU95FmPRGgo0iclRT1CgDJh10oIQBLWMo/L/QO/C841iMBXlAuVR0c97XlgwMZQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.29; Wed, 15 Mar 2023 13:13:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:13:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 08/11] vxlan: mdb: Add an internal flag to indicate MDB usage
Date:   Wed, 15 Mar 2023 15:11:52 +0200
Message-Id: <20230315131155.4071175-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0045.eurprd07.prod.outlook.com
 (2603:10a6:800:90::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: c56d8c35-5914-44ac-dc77-08db25572035
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Jj6wEv9wK1PXOM2rTNE8WOO2Rr7tKZxV0mfvSuF0x2QYNvMpBZ3W0RBkCMPsvtqKjf3nNJPUunoaJPq0MZ82DUiZ7VDQvph6P1z/KxbKtauMknstkhjs2nLFfJs3M26FrvAoTe7GIJ3mg8LMnkho+uRM5Ft1WAgAdhHNxwyDB04rEEuEb0cAvwwLw2h7eC/fqo4Bv9o1jUJ8qgqIZv2eOAV/wm19F+BmTtmJbo8KzIEpd6Jt4fk76g1UUc0n6vk9bVO5dODYgX6K5q+lF/cdudeUaxWmGueyK4xJyqAKelWDN/PINusBF1iTNPXmxIdV6DiqaBDI6tM8eLzGzvdG9KpLkBQFXejF4MW7hoZMUHd4Aho/simbO0lxVDqa+WAj/61q0CWjO2QkbJafxwI9ahDcBtn+8TM45IDXCh5EHdxE7tfcVh8h+zAaK8qtTuGzxcA2pW5tkD7NfJJ0rXLRVXIlPe2gBjYYrSa86WrPyQiG7uCOrdFQOkPzGvxt0Idg4LOfL6io2yRsX7ujmnQ4eJpb6QziYzDqUWAyR95UQSUfhyj8fpTrIKqG0Dfnbk7K+EdfNBOpiplSG2s1pGDWfIDcGIlM4W2AN+WBhIyx1tfG75OMX5MLyZudB/kzixAQYeLn07c+efIC0MdPf/f8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199018)(86362001)(36756003)(38100700002)(2906002)(8936002)(5660300002)(41300700001)(4326008)(2616005)(1076003)(6512007)(186003)(6506007)(83380400001)(26005)(316002)(66476007)(8676002)(66946007)(66556008)(107886003)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4ZjexlqPmbxEh/huVvsv7mQgucn2Kbp6Myazwb2zaamZnmBlW3HvFeSSz9+n?=
 =?us-ascii?Q?uF9Eg68u58aYYbU3d6Mm1piALZqjnasJpyTVrZ8QML3KZSBen2vyoTQrY05p?=
 =?us-ascii?Q?D6tFKUb0FC/TGIZlpVj7CIqjVjyeMgMKjARetcxmzAUjM4Msv7YpAqlwvGIJ?=
 =?us-ascii?Q?EVHYsJV/guVTq9I2Cb543S/UGAodBOkA8UK1nDl5W8LjGY8NmmP9v3bv0KlE?=
 =?us-ascii?Q?xoxxPrUQiCHXePEmLvBFsQARU1QJC49cy/KpmjO0X0U9TldPeV2TxJvd1q1T?=
 =?us-ascii?Q?w9TBUyE0uahbQotqO6yzrnbavX5FMz0VB+78ljTX9iA4MyV0raYQBXrc6IPI?=
 =?us-ascii?Q?Hu/spVhJ9AGCE2vcGQBUyClUjP6QCqD81YlJu44rtWJT8IsZeiyo/ybCqm9m?=
 =?us-ascii?Q?S7tizhJDZNBXrBr4MJijJp+ao6GrppcX68hj5ZpZkcDEoB1N1f/ntVQEDD2L?=
 =?us-ascii?Q?VgW64CA9QnEH9d73ZgQDZ8LR+gpfglAICnpR+AvidULyfEvauBPOpWfkmbaL?=
 =?us-ascii?Q?2G454LUjUvHNvnY3u2Br8zHOHpGXYEhi1zda4NMuu2NhUuSma1PBnc5bGTQD?=
 =?us-ascii?Q?CjXNmyBdLmtzrLg6d9QLajza/YsTb8qnfvGMjV3R8cxTAjk0NgKdM8Jedi6b?=
 =?us-ascii?Q?xNWaVHYoNODVrx+mgZp/qvLbDl2DG1gySiYuZjRpxi9OFuZVtvXA1ZN8bYYz?=
 =?us-ascii?Q?J1+2sdDzQ2mx4k0fuM5H5oWFiHJvQu/Qyh+ZqpYPSY0Rdvl36NrqFb4WxPJO?=
 =?us-ascii?Q?XzLwXIBkbaXFRbyU0SDM4jGw6jhujW6p2VKzj/VNX8eAxMvJiDGgzcYtvXp/?=
 =?us-ascii?Q?KPH1St22N7nvUGulqBR2pgtVezuqheKCMB15Op0S9T1/EgyMPuIUVrANDQl5?=
 =?us-ascii?Q?vRvCviAYSOUnXo3DJDxA42WXYz4RTQLopmOib6ADHdpa07HjAw8DYI26+sy9?=
 =?us-ascii?Q?7lg4S+nqPp04XUILo7/oqNjgOZ8qXqydZByv8Ez3Uh72jPubG3ZHlGi5hhDv?=
 =?us-ascii?Q?KKyPajXQkSwceiQlT1aqAeOIE1PCfBcbeIKQJMHx+Guu+w4W6+RdOyzT8Eoy?=
 =?us-ascii?Q?I9nBlYIlHqA2h2u8Ccl6cSqXGMJRzQb8C9kWT42UlmtjiicaRM6JaQSZXtJM?=
 =?us-ascii?Q?e/bSDmhujOPjrqeMdlf0gieIx5AcjWgP/rbSNpbsnhdjWNPeErmj0VVI5IO/?=
 =?us-ascii?Q?QEIdX0C8bOWIXM6BwdbDc/XVLx1/Znp7SRSBnmzlEqsEHkRHFy3tmRDJRORn?=
 =?us-ascii?Q?TdLLAeQ9xt5N8AqRUZonPvXspP7pjaWEPvntoYqYhSD7nc67KPBcxqxCsrX7?=
 =?us-ascii?Q?Qac5BdTLDJZ1xStvb4f8i2sp57WKS0QC9GmvkGuaI5GtfX29ViWVPxohnWie?=
 =?us-ascii?Q?/kbugbY8ZaCggkYW2fEmFnirSbM2Jlc8v/OC6u9ChNsfF3ej/H5qAKBn6qGU?=
 =?us-ascii?Q?egTA4o/PohYEXOCwYjCsisqNeI/23WubObMdxgbsS767FPKJkVW+deJH91gW?=
 =?us-ascii?Q?CHSwEgKnP0HuWaYMQP6FM6lEqqYhqDqrvANey/EUmM5Z/7QlCsBnGJzTPlRs?=
 =?us-ascii?Q?JRydtSRZfNUiHZlXQy3JLmQxp+j8c7GvHWu7x0PS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c56d8c35-5914-44ac-dc77-08db25572035
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:13:53.7246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmU/h6xcAhWwsloKOT8T83ClkaicdxVmqqjHx7vYZMNWdfXBHzPUCCG4tHvzIs15FFFxp8C4n3fDcrcMUm/JiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 drivers/net/vxlan/vxlan_mdb.c | 7 +++++++
 include/net/vxlan.h           | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index 129692b3663f..b32b1fb4a74a 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1185,6 +1185,9 @@ vxlan_mdb_entry_get(struct vxlan_dev *vxlan,
 	if (err)
 		goto err_free_entry;
 
+	if (hlist_is_singular_node(&mdb_entry->mdb_node, &vxlan->mdb_list))
+		vxlan->cfg.flags |= VXLAN_F_MDB;
+
 	return mdb_entry;
 
 err_free_entry:
@@ -1199,6 +1202,9 @@ static void vxlan_mdb_entry_put(struct vxlan_dev *vxlan,
 	if (!list_empty(&mdb_entry->remotes))
 		return;
 
+	if (hlist_is_singular_node(&mdb_entry->mdb_node, &vxlan->mdb_list))
+		vxlan->cfg.flags &= ~VXLAN_F_MDB;
+
 	rhashtable_remove_fast(&vxlan->mdb_tbl, &mdb_entry->rhnode,
 			       vxlan_mdb_rht_params);
 	hlist_del(&mdb_entry->mdb_node);
@@ -1336,6 +1342,7 @@ int vxlan_mdb_init(struct vxlan_dev *vxlan)
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

