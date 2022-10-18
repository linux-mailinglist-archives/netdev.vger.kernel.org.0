Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FDE602B3E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiJRMHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiJRMHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:07:12 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CE883058
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jy89Cg5UDP3W23lTYPlIWr3u60tfiQS+qafdMn3cjbP08TMswY5M/1IOUQOAs3VEvOpt5Wd28digR4CVmRhU2S0Is829++1KeoWj1cBfgzqJyyWg81iniQUEA8b67NU9IfJ5kHJE6qAIzvV6qyl2gicOyhRtIRKk6Reo/+awQg/ZwDz/sSuRiSsQLlYLAgN66ISLynLHXrgw5cGQckEj5KFAancT9bdRurx6b3FUCSClfT750Aatiy0hWljvIXlcHj7zVcN8we95hcjQHSgVjFu2EEOIm86Uy6bYUdtJPD5LeZIAVnqYt2Qhn/HD5qDThXhBMDPsAzC0yMHQBFgjNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ETmXry3f+7bWBnHi7TJsQfqt3JBJsRP1p6vLGxiN1E=;
 b=DVfGglWvCczbsLJO12Y2qS2fuWXN8gRH7EbuOfPO2teJKjboAMC4XommQRvgUSIP/jnlvpaqEEfQsb6wAjd7Sgr4o2CNNpPQaySdEmJkosFjNkgPt8NrtD8wV3cmkJtRlKbnRW/d41G0WDCg9EyR/zx/PZ1hpwQ6t9zZHLpnJIEhqvRDIrjxou5fK6zsH9PnIdvVvyWobrzbnIUBquAREKZiYja9uggKRQwCkoBzNPZsH0qqg4cGaRx4atAnm7DTSn97UD0nrZzrfXAe9dgA2W/9bhYsBXpOoFkVzMRKTYDrWgPcBHhYreh7lp9KHtlnoaD5oXEQUaLss2zee496bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ETmXry3f+7bWBnHi7TJsQfqt3JBJsRP1p6vLGxiN1E=;
 b=M2j2ad2ulfsBt0qo1MBK0X5fUMmWbfOkk/PhNjXKRGfM3wE32n8mY1PMFkOGpVNuZilGxKhX8aHtkVz4kSlHhRyBHgnTmt9FDwxxb7Z75HdqFrdCTs89P6JiuYKoljvnlz7j6Q+uHPAYSr5g5dLPaBoEDE06krblleOF4Cg0x5r2NvYrmMSTEm45BwUtfkk1Rglmj3n98zegLL3TvELtG7PTDMwQY0XCtIBJ5GMS4vpnmr40k48PXH7kHh0A3V7jMWSjxM68nX7rHckIGPCuSO+x8Jo/0YsjhzJnik4dgE7w+X2pguRBkVh4QnT5P6ICoWeRX+7mKpAXkOuJ4BAQyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 12:06:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:06:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 08/19] bridge: mcast: Remove redundant function arguments
Date:   Tue, 18 Oct 2022 15:04:09 +0300
Message-Id: <20221018120420.561846-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0089.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bb28dfb-a402-4f6b-43ff-08dab101207c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJJD3HGapVSeO5Vq74Tn0MgnV4LlXmgY8InrH68rBI5nHHLfwT0htXHgvY9bLrcCNkKZ2qqPkxNa1KDiiH3tZMd0rr7/+ophpJHjOeOjG0Vj+Jvmuac8XMShVqejQ16OzbuPxJLe6ExLngHpBhO8oZUCrQHN5JJbOHd9gh6O5m/nWX5Qn74SP6ZulA/drRt1JKMJrC3td9MwU9nDwQL7f3AuB4igADyz/qOMX5jVqaCpmI7T0/MQg5pBGwGZL5xxm4o+cJV55J9FPr2GDP5JCiMy4NxcfUww2AeTq4s1XklwL4ug38rTMm4Nzau2/+3pg3tmtNID+f0KNZD4lW1uVm6lP+KKChZLaIV2s+/DPAE3CzJfuUlXyLLB6Pf+oRtL0WgGjTvxpYjzqtRhHrmzIHyF+PGxfCfGkt6ze15GnVSDk+MhmHJpw3cxzJCa9KDWKsEYnPnhSTqheouYXxY66O4j9S/P4ddUXcg54x0r/bsg7Cdb1dhDCN2F3Z5kTjczx3o7yoO8Fktfnxp2FR7e/oclV0sTXyfuluhz9R114EdqRofVzKA3Z8NKbjd3sUTREx9gB97/ZBGZbcgpJ3UqWPaIH0+Zx54Ol6ZnwIKN4/AvDmF5IZEg8Fhl6r54JIdl2JlHJrakaH6gMTYGblm+JTidmV5Rq2ph519FAKXTmYF00+/2YhViL+a0MaJVkoO3MifNCHCXfWXHD/RzzWFjBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(1076003)(186003)(5660300002)(107886003)(2616005)(6506007)(26005)(6512007)(478600001)(83380400001)(2906002)(6486002)(316002)(66946007)(66556008)(8676002)(66476007)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oT3Nmp1gXVAirWrQUcewydc0rVnY0UdlVVmUdRUXRCbjTrsvSjLElgG7ohf4?=
 =?us-ascii?Q?DZ0BP6wXjy331UcXnIglTq73vhJHWow1OFyDlfZexmBEIVcYydQ99WZ8FNcc?=
 =?us-ascii?Q?dATkf7Cc0MYWYmdyhZYs7n2uRwI4ZZn1bp44SMFjsCZZVxZfKLEx3COMSBQf?=
 =?us-ascii?Q?5AnYkAUJSdNJmPptITO877xs959XZRttYtnoU1vSLjkiBou6tJAWHZEokMI3?=
 =?us-ascii?Q?3iRvVcXUdeNMQSFeJRHcDRaUvtmRCQqop7BPPKCDJ3gIysxLHTIkYDVgWdnf?=
 =?us-ascii?Q?GNz0G4h2xoU302YLEazx2SF9r5D63OKs0g99ad7FiQdDPkg7TBRNz6nY4GMw?=
 =?us-ascii?Q?/0j1/iinkdyfmyHjLk77N3tW9+jXvpfkBcJJysUuNduB4MT3fyOFf3cs2I4w?=
 =?us-ascii?Q?028MAh3Iq74wly7qNbRZJFReD//EUblugPPAiBtmLAacuS5Xir8Oanj6l4jK?=
 =?us-ascii?Q?mfBF+M4pXKkuD2dWf4SCxiR3c6Ct2jGXaqYruYbA6d6QAbzkKFOHcW2wDHla?=
 =?us-ascii?Q?w0+J5xHX3tzQlZg10+Fcqb0C2kfvZCAt/guzTkL920mFGkmaMfo4/g0y37Xb?=
 =?us-ascii?Q?TuGek9NwKKI/9wgxe1dZ1ZsHXOHul9YmfqCu2ajXAg+4g+cb3y6mITy0GUfh?=
 =?us-ascii?Q?/nLZcvkHisVRDkga48OVdkcSnQl8Lc2YHr6uTBOkaNS8cRkCvbJNk+g6ghn+?=
 =?us-ascii?Q?s8GnZ1Wr2caB+tV1xlAYfC0EROCfQj9yPxCJ095k6avJoqdf4fs2NYJhBfcv?=
 =?us-ascii?Q?NsxzjE7WsXizvguG+83J0EA/lPAESTRQinZEgDHZiqPqt1GEQOSljYl8R/8W?=
 =?us-ascii?Q?QuL2YPUXqICayIposzsILJVop9Fbt9gKk8Uv+2nrrgPXrM4EzreOfAoLSnrh?=
 =?us-ascii?Q?ZcWlDO+JOe5rPRd1Ge/2Kt+nJF72ne1z9l+jN0a+fpl05Eqkd/jPRleQX0Yk?=
 =?us-ascii?Q?NkjjNRJFQPOUoZV6nxN4tbM0fdaYtCylkLfmaP0X7LRtnKtAXtVhIiak6R2R?=
 =?us-ascii?Q?dkDO9C1KXlZL/Pu3Hb9fxGxJ5wzRYoz9Yik/ZarcXYm4Gv0/DmmjKYUKigDh?=
 =?us-ascii?Q?HJjqBdiK9I0zkGhvMVegw/wskRBZXWV20urSzfF1XcamOfHxdyh72UnqE1Hw?=
 =?us-ascii?Q?DKZoHnayCI+gOHqtf0M1ueCywGb5PHbgdwUI521o3Z1269GobIS6tR/vdMRV?=
 =?us-ascii?Q?jL8srgEFZ+pcOwltfMtSXYgeNlr3JA2sEMaFZp5+hC882XMhWk4JFu6ZKIrg?=
 =?us-ascii?Q?hi64/N8qSLra80xZigWW3L2E/vgjxuQyVRTZb62fiSWYKMC2B6hFdgee+Cxq?=
 =?us-ascii?Q?n9AkgkxOZIuuQ35zxLaeNV5s2veZi/b8Lt8n8sWPJXanO61lZA760Ny9Ga/d?=
 =?us-ascii?Q?rEd8TuW8ct9PuI6LSLc5LoaNYWYUqhbRDdTyUEMKDisSEiRB/c6gPszoeEw9?=
 =?us-ascii?Q?NbDp8JxUN5OQgBH7hwyEk88+rdXUg+keIMbMQn4LLSLNX606f12m527OSWLT?=
 =?us-ascii?Q?Akwm4Kl7I55IiD69SDkuTrKqqK/EZkMDUP54huS6IEzmMNSbRSlIB1ttMHNF?=
 =?us-ascii?Q?W4wUYpteg5H8zTb/L4T4v62tIQuHrwnN6dnfpKZR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb28dfb-a402-4f6b-43ff-08dab101207c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:06:02.7413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dm5mMl/3uECpxWkvrtov+nu/X8VIc7tM2pQWw7pF2veRVpX4An7/hm7PxJGtpDjH/bOtk2kdYbW1omaCNVEpEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the first three arguments and instead extract them from the MDB
configuration structure.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index aa5faccf09f8..850a04177c91 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -786,13 +786,14 @@ __br_mdb_choose_context(struct net_bridge *br,
 	return brmctx;
 }
 
-static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
-			    struct br_mdb_entry *entry,
-			    struct br_mdb_config *cfg,
+static int br_mdb_add_group(struct br_mdb_config *cfg,
 			    struct netlink_ext_ack *extack)
 {
 	struct net_bridge_mdb_entry *mp, *star_mp;
 	struct net_bridge_port_group __rcu **pp;
+	struct br_mdb_entry *entry = cfg->entry;
+	struct net_bridge_port *port = cfg->p;
+	struct net_bridge *br = cfg->br;
 	struct net_bridge_port_group *p;
 	struct net_bridge_mcast *brmctx;
 	struct br_ip group = cfg->group;
@@ -879,7 +880,7 @@ static int __br_mdb_add(struct br_mdb_config *cfg,
 	int ret;
 
 	spin_lock_bh(&cfg->br->multicast_lock);
-	ret = br_mdb_add_group(cfg->br, cfg->p, cfg->entry, cfg, extack);
+	ret = br_mdb_add_group(cfg, extack);
 	spin_unlock_bh(&cfg->br->multicast_lock);
 
 	return ret;
-- 
2.37.3

