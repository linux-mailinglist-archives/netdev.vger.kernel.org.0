Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1BC602B47
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiJRMIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJRMHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:07:39 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B60857EB
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:07:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWlMOX56brP0i5X4c4Mj1tDztnbJWZvPlffkNawHP2aNkAIcaYvgwfGDaggrlHgunDkcy3xtkUOFO3ZHyT08pXCGylpAty2fGFFAa7cWJZsxRtGXHvVhLgX2/jk0L4yLLIjHu5cYhjcCXI7+vHg3U91H99EMCHL9sj7kKQjSbRcsPYhGUa8Ayzas1Vg6FNMfGpft5l/W0PMEUp2IfhPCC5t1GtdR+mju7AraRGW8IUErE+YxBeX6YxnPPLdyLv4owtHiQE225Tt2AWuuKBcGcbfyHzgjxHmWjMEyWRS6aau8Bohgi8E0dDo8nT7TONEKVFkfJ3/BYrmKEHVnXTSu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bw0x6A29rVN4MmRG2Zk75Y6JYHE1k0KH0Ii7wacLrk=;
 b=WnC4hglu5kRVyI7aXXVCoyel5hSK8UugcWbkuLe13TOa1+51aqY5xWGMefag2Ah+1iUNJ73IvigHn2KModFJ12PICWic+ZibLz8qdH5L8GGaAWWNePKUyGzxNDC8ay1rdQOoz+ezsR07y42V8iw+8jZsFVN+JXtpJ7qUDkR8kmrT5/AwpHBOpz8Y63JIZbdTC+mB5syHN6wuSM6L4kxDrnN4BRmDpwENcxC3Yu17arSnnTmWZGYDRaB4vhzxzZDAi/qQLF8FNkSQh5rWJ1DH41MPyQOdlQVGvDZPSb9VcBozPDIaXhzMM8Gr2ldGdXB/nJfkKvGInAShaTd0P9HAlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bw0x6A29rVN4MmRG2Zk75Y6JYHE1k0KH0Ii7wacLrk=;
 b=o64g0pWF6E+6AvLHy2X2IF4XVuZqj5TT8wk68NXn/iWlnY9w/rdfPb2ko2vaiPewyUN2MBJA04PhI8K5xtN5O0qvQL0sIpvUi5D+FhrrdOp5UwYY7ie6DFjd8McvpT/i5EypRxCxeLMRyhCpg/KqFKjegGrrvEqpDKzju3rFPTeian93DbqwbvbUh/qEF87L1TzbkQXgchLXHohbJHXc75VbIvHLZxO2Mto0XVybwa8a5REOJRjwCM2HwriQIlefzRDNPKDCVwaNS/I8mS5+Ni9BJt5CgAL66n6Qo5Jbu0I50Bgb6nL0Umequd4tTBa5rgtPFMwG3Fmbc9FbqPEI2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 12:06:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:06:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 15/19] bridge: mcast: Avoid arming group timer when (S, G) corresponds to a source
Date:   Tue, 18 Oct 2022 15:04:16 +0300
Message-Id: <20221018120420.561846-16-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0010.eurprd05.prod.outlook.com
 (2603:10a6:800:92::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: e32dc786-aeab-45cb-37ff-08dab1013eef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpUbrjwnbJT7P25NxIlXHpopE7w0B2pgcRj3vzdvZIqtZdf5pkWbuD1BvvWkYOwA6ZKkDnDnKkKdwxZwW92wAVku67docFHAZltOSB45CGGBwXX3b1WXotl640/i7qHD8FKUAHZZfpIpjZPJL6SLyK33dG4I0GVnGP+hXGYPpesWMzt44PhwwhDh4ZSU7PAo3ex9U/jWHKtTtn8EzX4hg6QJoKhkL8ENVcoO0IyB6EygxQd7zXqfvGXt8GwaUEeLUJyWIrc5eExy8e/Bkc0tBz3QHupbEr9ubCrSQrnTyOPnHEKIoa/rT0KqaOaYLAvRQaGvLES46kl+9E7xYCp+F7Pxbc5pNCa/wh2eB+avvdYS6BhtHFh37Fkgts0uZJfYldmCP9CzCNYI8m8PjwRHEk4i9ySbYMMLQlV0Bqy4dNhvV6yHgbUankbi1Kz8X80sYBGlioH7zpPaf9+r/zIVtpbzKf3oYdREecsofB64S8oRioFcMRgu2TrVIsDnXZsE46kTge/KwTdwOelAn5QZi3v8ACbvBfLaAvn6h0sh/zYdKEbbU2qlNtvpq+9F+lOyCh4/nqXosuIF0pjo4v3pdDzBpfL3lHY6Wbkqy1F/aBb9iXUIw0A+n91NxsxKMXaLCq/VX8LmPVP13nZOWzeMi08eZnCNsU0zHzXWTV17WX55pU5cB1QdiJSyKtUNP+7u66rdHgQfbZ0n41/yCTmFdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(36756003)(2906002)(8936002)(86362001)(4326008)(5660300002)(107886003)(6512007)(6666004)(26005)(41300700001)(186003)(2616005)(1076003)(478600001)(8676002)(6486002)(66946007)(83380400001)(66476007)(66556008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mtXnXC25uMRyPeSo+txhaNIOUeRSpz8GczL8xZRh3DpqcGPSDJNxfULfHBO/?=
 =?us-ascii?Q?0c3y8R9+R3oEZLbjf5XZJrScLIN6FpnmxhGVfJuPgGfMPuyheeTmeyc8ST2t?=
 =?us-ascii?Q?URcScITcr6vVeaJ7tXlCRrjC9oKMKplTxGs9LdiWCTWtMYVLUMf+FnwGN8ev?=
 =?us-ascii?Q?uwXaRHy4rljRe1eV6IDRccDWW2bM8GMs4UqWRtaD0UREx+5QMsh66M9dpbcL?=
 =?us-ascii?Q?YD8IfcZXDVN1W4X+25ngTWsERrF9IKFaYmbJONUdclAuRM7VZfINmknKLpfF?=
 =?us-ascii?Q?bqTfJU/2nk4Tb7N5KVLdFoBg0MOG8Vsjd2iUWi/ktj9vxMo8xQqUIuiMEmfZ?=
 =?us-ascii?Q?sa5vDRwp+k9Xe5T+S0eCP2xt8RH+JSZcIkqnY7206zwRBE/p7XRmdMAKgTD0?=
 =?us-ascii?Q?KzifHdtEcZPXBe5zGYx6YLX+LzgkaykjRY5WyvNonHkrcfvCrv5XhUviH5/t?=
 =?us-ascii?Q?TJknRNW7F3oJafrlRrbi9yjhK0pjXhilshPh52MH0Lr6eSOBFq8j/MhbrR36?=
 =?us-ascii?Q?lUWe3joawsHvZh4ompcNXN6AzYEXBohI4Ch97J4IrlM4XySSGXzL+J3iF7ku?=
 =?us-ascii?Q?8YiAEMwX1pUr7XL+aUrIwUS3C00AxW3Z24cF4/BoAPp+sKXE8jtPrF7xC2mT?=
 =?us-ascii?Q?ZARTzf2Cg7q3dIiuPQ3SBp64yJ8V6JloMwd00ttkfdg5mEtAo2NW640XLlPp?=
 =?us-ascii?Q?ZY6jZVUpjSWN1dJI+lPMGMpaD5jZSqo5DDLJs+UffZz/OmvmSX0wAacygZzA?=
 =?us-ascii?Q?JKtkqNCUCxDu6KXKP7lhiDH7PxvgJkN/Hz7nrItGxaz0kulz56+k5DrO5A2w?=
 =?us-ascii?Q?SxwB9GG5sU/ph937YoqWXz5ydMBvxyLQlYdsrvV++y11sdt+yks/gXHofTDC?=
 =?us-ascii?Q?MNkhHG9dhBuMu3wmMAmlAssddomjb0TeKmTXeGdfYn6fe5bhW+rXtvK/V6Xe?=
 =?us-ascii?Q?oZvd9d5C52qVqjDgP1MiuSkNQOKzsSbV4uosxuq/p1ORxHj1jiVJQNym31eL?=
 =?us-ascii?Q?PF0ki9Olp5w5ZQxQtQ934j8aKbsZm+0hVMDqeqqGR4/ppfAm1vcpK2tcqJm3?=
 =?us-ascii?Q?2CWfwyAwbhjRrvMV0DFiw1u8C7v5HV9M/uOZ4CMik83PU2hgjmvsH8hn1mvc?=
 =?us-ascii?Q?fyzPtuEGcov2jCRjPzzjZqFNfAnQg11Z6zSMFcELo4BoRaZbVpZtSSJjz9m0?=
 =?us-ascii?Q?8zaiFap4Xq5insIqhxtdnqofXI5xawSUYOQGLGrQd7vqpG2z8UqUAQX5/E25?=
 =?us-ascii?Q?4uWN25n+geoquk4EbCTz0Okbm6MwUxI42djl6+usnf5v3v1xvyAcEnKy4iFe?=
 =?us-ascii?Q?YGMtLskaxv1eYosBWDEw6Pjuq567oF5Ey0B9lrx3SZP9/anhA7t/efnEBzK+?=
 =?us-ascii?Q?Ym3mr4eZ8qAbKq7Rcd78ZPysTU/bgg7MfLFyOfLGWv5RQ1rIIIfg+xJA4gUn?=
 =?us-ascii?Q?B4krpH84vt5D6w+trPWRxMoNTvmlwMBzgQ3dtNpQlnymQ/wu973PbAlJNGRD?=
 =?us-ascii?Q?Lci00jPzbqkUavr6BRUdQjHv7jyTV4RRCemf2EffoBOx6PkaY1dv23U+ja4F?=
 =?us-ascii?Q?jb7269I72ltpxwJ39v77Adgedoi3Ewc06EDxjoii?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e32dc786-aeab-45cb-37ff-08dab1013eef
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:06:53.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ScUkC5zfvd/LWi45ybBA7ujMwPWOhCp2a6A/0KJJFHeRBI2/kIBF4KkT8da6UaSROp7tBRr5HsH9yxBMY8FVwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

User space will soon be able to install a (*, G) with a source list,
prompting the creation of a (S, G) entry for each source.

In this case, the group timer of the (S, G) entry should never be set.

Solve this by adding a new field to the MDB configuration structure that
denotes whether the (S, G) corresponds to a source or not.

The field will be set in a subsequent patch where br_mdb_add_group_sg()
is called in order to create a (S, G) entry for each user provided
source.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c     | 2 +-
 net/bridge/br_private.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 157ba4e765c1..2804da7b0aa1 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -814,7 +814,7 @@ static int br_mdb_add_group_sg(struct br_mdb_config *cfg,
 		return -ENOMEM;
 	}
 	rcu_assign_pointer(*pp, p);
-	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
 		mod_timer(&p->timer,
 			  now + brmctx->multicast_membership_interval);
 	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 6879d2e1128f..1bd6eebad002 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -98,6 +98,7 @@ struct br_mdb_config {
 	struct net_bridge_port		*p;
 	struct br_mdb_entry		*entry;
 	struct br_ip			group;
+	bool				src_entry;
 };
 #endif
 
-- 
2.37.3

