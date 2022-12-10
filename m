Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0367A648F51
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLJO6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiLJO6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:58:07 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351D71A224
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:58:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6elELlbleUrlL6xGjV5onMJUp7RnvdIVc7SN2fyyxYtUXO95AC5OPFQLfmxZZNmGqAMtS6i3w+8pbg9cFQo/GoTtxv70qk4m8678IEyqkm/iJF6LoiFC66AOIeB9fGnC1uIoq3Y3SvkOODba/eMOZO7rGSA9i1gR0LKkXjhK3ggOMhNbAga8qriBTDwRy2Q4GBFul2dSpZ8E4e8u96l7JfSq6sahfyNLmV2HaWeQhyiKhbWdVnILsQqKWN5xYHaPIbIuz1WPXio8Z3bVktLqJrDfEy1TP3MZoG6fu9vmWkMtrzio8xP/Sn4QSVK9xXVPzxR5cv+x3DAI9sG4PHlLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UdVK9p1VBhRyQALpImydJ0b7WZxGQ2JlhU7sflf2JM=;
 b=HXwi9iPsxvFo7uS9TxnXsSihzR+7CHoI6q9TMjZZ2cRfPz3WOZPqPW8QazAsy4W7k59S4MV1izNj9MFtusbrCBR6ly5KgC4ZNRK6RdHpdKvpMcrDL7Y4+bFvtvcW3X+7IVfdv130gW9HM+Ck/1vsqLMfXyHIL33jKFjdagMg7zVTPpkxcvDajootEzabzVBP1lb+yM38wvK235jxoS6Fq6HO/V8oi8Jmy86NIexg6sh5AsH/GPLyw0sNWOs3GhkX2CkAsVEUxhoaFUI9s0bob/niluhd8LjncX1+34oEuVVP76xQPkL7YTgJgjCa+lSgPCFeR2S9BI0QGnH8hngC3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UdVK9p1VBhRyQALpImydJ0b7WZxGQ2JlhU7sflf2JM=;
 b=R9z9LgoFNXMGncD8RZVT7vQjE5bYSUmMyeMYwhM+wwnW3o6IllTbMxcBmf+sXPW4oJmfzprzg6mYN4xXCrObhCt8GXqVJJLKQc30QnjYlYHYzqvasiV9vXIiFXTQXa2mQ/eoPKQhz1B+Si3lZ+IcOsy9GOKC8oUA9mY+/Jr/c5Y7EdPEBgJdrn0XaunaeEfwfFPM1nxwbUCZjbS+8EJ4+wXm45zKs6qji5S7pe1wP5sKZwDmCnOs6GKutqWR4KGIY228DQrlH6ICDtWLM72ddk4Eu02w/LD1n3JwUrsy69BBlwjd5TIwcp3B43Usg0oYrkNFZq9rDgPzIoJPVQwt7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:58:05 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:58:05 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 07/14] bridge: mcast: Add a flag for user installed source entries
Date:   Sat, 10 Dec 2022 16:56:26 +0200
Message-Id: <20221210145633.1328511-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0094.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: dedff852-bd14-417b-b6c9-08dadabef112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GME/YjC8PbPEbqDpIDhPkgaY1Sy9BFHkFGZzhSWbpNLeyrajFLzxpSTLQKbxLsToZ9XPgqvZcMjEmPpo96vK0+nUYjy1qqU5zGkpYkkT1Ntwpk7/qEwnn6SFsR5FONWUq0CypnG2i+W/MfXZcocEHr2hlBcl8c54axC5OCoAstEO/0DSzAC1KmgF4NFah/fbxGY2J32V3x80Sk5SrZ0eBs+KC7Nl7p9mD1KevOsQiUMd66EOMXf248nVuwSohxFzTi/tJ415ejBO2Biezovox+kYfZbsq405TOLJWH4kjhrcaVmfqaRST/WPLbT56n01L3DE6mp8N4et7wodkjzEoDUd2lL7owEnBLzNwRnwYbE2NwwlXDx4IxE15dX5iMK6EaigZOUoouc+W2P2KiIR5y62657RsFpdvzIJmkhnbMdll3vK3yaDfPvtDyfpYX4mXMhFp0vQu2ty+rRIb6htppODSlxZjD2dCvtZkhyLtPLEEKnJJjGOofGIfOFW3wCHn7M1QQVmUsmoI3l2A093+bIbvw+wYmheWjaN7KhAiDZVbAO5k5ltvz0KdRYhnKscSMHrTOrkq/59V9H4HdEwtf6nTEbj3FJ90URK0hbEY4RaJMBI9BSCSHuvMP6vWqtVcps36QuyEZr1nqWYOA+Nrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IAWLdszd14rEoMnwy9T5G/tH2Itt4z3UUJSImKoIrzLCrVfzGHS3kupKvy21?=
 =?us-ascii?Q?Kaizi0tVcbt/cvmljWis8E6fpn1HqsYrpHt50n0lLBVT+9a2nci58Y/MzYEw?=
 =?us-ascii?Q?CAInTR2dKyWqtlTgQvMdD14BplN+YQSbwRWOXXEe2rPxuyX0wlgTA3OZa/BK?=
 =?us-ascii?Q?McHp9ViPA5dJEeoY/QzXIgqdvsracgipu1Yp7KutAwyounmdau4hXo8cNEMP?=
 =?us-ascii?Q?mzflUEneqaUBbhNB3kz9igVK8uBGwR9SON7zgAPLIX2hifa5/GfzslLf2Iad?=
 =?us-ascii?Q?R9sMDAhEABaHgvtfVuQhoWBx7bgI6clWKg9Xq2SiV681szEQFRLhQfPN3X/X?=
 =?us-ascii?Q?ZUkiLu6IZ7m3usGEYAVL1UK+rGupIrF2KLSNyDkOtfnYBEaSVHJkLxmeaq8s?=
 =?us-ascii?Q?TMU+VzAGhycGh8Zbv+30l17W5WWZRmGgDiz/6j7ln9q42RLgI/cT+h5FHmlk?=
 =?us-ascii?Q?NyTPR0SVIQ2SwzGGAMfNlXXZ7Pyg26Iz3FZ6boLN48f/DJ1Gv6lBahDPYP73?=
 =?us-ascii?Q?yI5prs1tbu6fny/1W0XFLxbnlH+4xdvtDlKkt0rY8UFZv1EMNMEsCFDwQsGP?=
 =?us-ascii?Q?I/k1UcPeuPFSd9mVrZkrjSKeUAl3EIP8jQkNyGnhY14iVgIDpJfxmGF7VvLe?=
 =?us-ascii?Q?hYiXyQjAKWOFcs4SkyrsfujnTwzwITEZyUmU2AfQ2IucWBhxjRDiYqLHmME4?=
 =?us-ascii?Q?HushfAMbmK1ee/6onFK311FGR6eC0KQvcSLB22uOJKK4x8vV+BBV8vMCc/mB?=
 =?us-ascii?Q?zIQbs1c42wfKv7IyRSfX6e9k/UcOiP7YpFoaq21+VYXd+Pdd3LX9kLylIJTt?=
 =?us-ascii?Q?u9Y41evc3FpUE/ctBQRadxPq52GsaUFdp7nGLcK/stXKrZll8CjtpVJPY4Yo?=
 =?us-ascii?Q?SH7c/a3bKdLM4XupvDiAAxL2i7bSSZ2YgLINOCcsSH7x9TinYc6IZ8QG2wZ/?=
 =?us-ascii?Q?QXDRR59UaKmhKDQZqcYVh6ATxNOlKzhgxx/zrfm9BSjAkl9HmtAKh60czudv?=
 =?us-ascii?Q?3s/fguBIzfBF41Js+jBYDph4yUJ2wh5bOqCNY6W4CsiZnlNOh3xRWtQuDFzn?=
 =?us-ascii?Q?7KJh6vOi4OVhdObaBATNfDSDQJFIeBcv2etzlGhLzo/t5Q0Ur4DPnkyEczUE?=
 =?us-ascii?Q?UbArXDbIpXr9QH94Xh+vVpsCt2LwUBhe5Jofg5mmSlwbvBg79zyUnkSONrWd?=
 =?us-ascii?Q?egJzwx2jmblanaf7EqIM9ss+//AEin2aqCxSiMOiXafrFB7zVzmYNCHEtzh8?=
 =?us-ascii?Q?Sxyxua8/rlvBeGnJPNoWw6uuEIGMINMXU7W9+KCPTWU+MmZ34Kbl4iH2o8Ef?=
 =?us-ascii?Q?VsZszuaJPuVSjIKAG6kr6YdaD2phpQu2mMI1azcS/XAk4igJSqxlRZoNwGU9?=
 =?us-ascii?Q?xGaDC5SPRbaE72Bz5u6fyWeF3uRb73nArMoPaHmV3uvvTW5PqQ4sUuLQEd14?=
 =?us-ascii?Q?99O/gnl+B36Kx9/bQf+VaRE3z6VrhcAM3BCN6R9v2ig68FNBipa4f9rc1seP?=
 =?us-ascii?Q?c8wZq4wr7fZPxHr+uYS+EQ7huS/v4NanJjDMJulF2Y4+rMTQGv0tIv3yDvGb?=
 =?us-ascii?Q?3nVantiXoipJEUYyipRg3kaAPGaA/BWaQiI/lnai?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedff852-bd14-417b-b6c9-08dadabef112
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:58:05.1085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eL8FtrSLcIlqTIygDAZLAJTUgy3R0YR7f69UoiwqqP85QMv5vhrRoQAysPx0wbq1zr8MK5i1/IGbFeWvcm7L3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few places where the bridge driver differentiates between
(S, G) entries installed by the kernel (in response to Membership
Reports) and those installed by user space. One of them is when deleting
an (S, G) entry corresponding to a source entry that is being deleted.

While user space cannot currently add a source entry to a (*, G), it can
add an (S, G) entry that later corresponds to a source entry created by
the reception of a Membership Report. If this source entry is later
deleted because its source timer expired or because the (*, G) entry is
being deleted, the bridge driver will not delete the corresponding (S,
G) entry if it was added by user space as permanent.

This is going to be a problem when the ability to install a (*, G) with
a source list is exposed to user space. In this case, when user space
installs the (*, G) as permanent, then all the (S, G) entries
corresponding to its source list will also be installed as permanent.
When user space deletes the (*, G), all the source entries will be
deleted and the expectation is that the corresponding (S, G) entries
will be deleted as well.

Solve this by introducing a new source entry flag denoting that the
entry was installed by user space. When the entry is deleted, delete the
corresponding (S, G) entry even if it was installed by user space as
permanent, as the flag tells us that it was installed in response to the
source entry being created.

The flag will be set in a subsequent patch where source entries are
created in response to user requests.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_multicast.c | 3 ++-
 net/bridge/br_private.h   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 8432b4ea7f28..48170bd3785e 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -552,7 +552,8 @@ static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src,
 			continue;
 
 		if (p->rt_protocol != RTPROT_KERNEL &&
-		    (p->flags & MDB_PG_FLAGS_PERMANENT))
+		    (p->flags & MDB_PG_FLAGS_PERMANENT) &&
+		    !(src->flags & BR_SGRP_F_USER_ADDED))
 			break;
 
 		if (fastleave)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index a3db99d79a3d..74f17b56c9eb 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -300,6 +300,7 @@ struct net_bridge_fdb_flush_desc {
 #define BR_SGRP_F_DELETE	BIT(0)
 #define BR_SGRP_F_SEND		BIT(1)
 #define BR_SGRP_F_INSTALLED	BIT(2)
+#define BR_SGRP_F_USER_ADDED	BIT(3)
 
 struct net_bridge_mcast_gc {
 	struct hlist_node		gc_node;
-- 
2.37.3

