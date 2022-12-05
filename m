Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA8EB6423C9
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbiLEHoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbiLEHn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:43:58 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FF112761
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:43:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbVTTZMwVE+BC6BDGvPTezAyV1vCizNSXZKEKkpXEXPlSTyUaREtC7PMEB6yylZAMwzSlpijc715p1YpqA0drRQC2MtEt9/ojPWPejAIngNnKo7c3OlNGuRKlb9lUypHAAy6yJ2OZoBi5rwb6kxFZ0JM0jY16YaliB8FPo+XYBSXGyXV+KB+BmNSoKY+I9mLqSyBOzjc55mzCZmQtHl/CHPXdgHX03Va4RyLVkNjZEWbmWfwDs0NuwLZ8xTsA3ysgF0kF+Vg0fR7//NqIzKC9eEv0hNMohbj4rGAL4vxZWTD/oBsDTCImFaigRYbSXwYi8xlQGF8ciIa4V5Kjs2MqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GfMsVv6H7/hWq1qWkAPKSCxsToaIVqZEZ1kBwsImrQ=;
 b=UtppfDXnUf20XjLPjAYVHbg1H4jlmELVO1BrLgoLF8If9DaQORodKSUlI1+IjqIarOHqRgOhQoKSZAzbgXkLbhqlQjar43SjNAIbhiNtPQ1yeCclAme41hWbdDDgDt8KMirjNRn2MeXLWh66l3iEKXY1t8eGy4pMgOd9qKgY1/1rXHLkAdUwbdoP45Ox+fnWZT9R1k6VbFgthyYY3nj+zhJXFA++IjRFQ9/6Ew9fjCoF608ZI9pe1STnXKCeS3bqHSH8lq7THWXnhvXFBYsSaB4uGdCv7Kv7eRIPw++yTh2f/5/q7PKWWueET1izA8AlpfZTxJLhBAwF7tHnMQXrFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GfMsVv6H7/hWq1qWkAPKSCxsToaIVqZEZ1kBwsImrQ=;
 b=PhYRMTQovditbP548tRdVDJzY2e8EfqMG4uh6SqYYJIvBwSvJ13gXMtW4cj7IBSGdssDSrzkYDpc3vzxRKdw75Vkp/IHc4Jhbuxs6+ZvefYGo4pRVsa3psv+zZS1oHXUbDEQqy9D9szTBU+fv0JfbtkTnx1yTr22u8sTlYtBBfKTWvlcguEoI2NpwDOEsFm2+Zt4xyhz4NdS117u9CwpXwiHaQHJbN60elA5RnaZAKlz6n8gn4Dbfz6h7jQ88I6ja0KG4NEPsZ39ZvKwOAQ+NlhBghg1QqRaek3zlwtgEPeBbjkyOoNsarMms6GFC0nSL2nYAUFxIwmRyZLwUubtdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 07:43:54 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/8] bridge: mcast: Move checks out of critical section
Date:   Mon,  5 Dec 2022 09:42:50 +0200
Message-Id: <20221205074251.4049275-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
References: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0665.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::16) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|PH0PR12MB5607:EE_
X-MS-Office365-Filtering-Correlation-Id: 35501c3e-c0e4-4e07-990f-08dad6947570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nt07XgihbKDemplfvr9wS3mcy0wEWqkdN4gnXrwh12QKmuSfj+6kYB8+oTepFMvijrQQy5P4Tm1rVYzQ2uO7wYhmjgSwLP0pKAxwxxw7T+xiIPuXDSqNl9EA1XZexcjzYhoOaN0sg5Cvi5cp0bPLfDXiJseGnUQl5PkyCtU3zq7L65ouroHthG0Fr16Ut/PipVL0rA5ZW3Zuc6kx07le+yLiW+KFkcQrYfeEg+5kN4gpHFNGfPp0g6isTUriZ4hT0Mq0V2xt9CL4PORneomObnqog/pSzt82ecTU3gR4tZ+Sr/nxF61E5MiQ7HTlclfzbYo0pYDhVN+HdeOyySwoDc3Qq5eRK841wYcccxKoDBtjzHkfa8h1vS9KMzmLp/HIw2sdXzGkEQETl/MGiYm3UG8jWdPWG5vCK50rBrUQPeQc/iWdXz4skk072AJ/FDTKKE8rim/TULyDo30cVyabcZ9xi4F4/KqhO9bdsY67CaUsl8+qVHLBlOOPx8twoG2Y9wsBQF2Y62s5I4K/xdPNt7+FGgs9h126ip5Mr6p5GcCzmw8acdhD0eLeS7+qu59Y6phsXnXSGp7wpbek/Z8NG9HTsRcPikguzrOu1zdzVsraai7vAZqtIljdO4mAycjk35dS+Bnpbl3qliUkgTjgrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36756003)(38100700002)(86362001)(5660300002)(2906002)(41300700001)(8936002)(4326008)(83380400001)(66476007)(66946007)(66556008)(478600001)(6486002)(316002)(2616005)(8676002)(6666004)(107886003)(1076003)(186003)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ftUODylGs56QBBkugPuGpby52ixzhR1UaTlkyf6/2z5bItDig6aWJQZ3MEF7?=
 =?us-ascii?Q?rjfQHqBczvAxMREsS0iy7K0D7Ylc5SnqT3SF2xLTGEN9fn81Q/Pon8iqe1/J?=
 =?us-ascii?Q?oFRAIIKTAcBGok04LjohFoXjpLeMuK6rFiq4tX9/O5kGn0xENZJkquTZ8mnM?=
 =?us-ascii?Q?T19YJ02VYmfO6iPtTYdbgX3+XJgYzkF7+gg6PyOMo/FMIzdYfb4FPL2941yn?=
 =?us-ascii?Q?SbTNnJkqJ6il5cyLmTwu23niliX9LpMwDpWnFdVKiRl70nHmvnruUz4hkR7Y?=
 =?us-ascii?Q?iXUGPjvwu4TGxo7Drl1DXDhOIY/giKB4HYxYljnERGiPHh6I/f4wD0XFKe5t?=
 =?us-ascii?Q?5j2s8C8I9KdM51c8SUW1p86QcMxxJqvzHd9sVANpPNI5nw0JLPzO45XYMHyp?=
 =?us-ascii?Q?KSrx5pVvmKzD/uZwjBxydRlAhDvOYkeZR52cYeUPrRvE25igzv3cbQsQ0iIk?=
 =?us-ascii?Q?j/8M4bWKeW2yDOCkiNa63kJ99fppBABTAvsgdU/TonZj1V/i4WVxX3H4HTnT?=
 =?us-ascii?Q?jhbL92z/T0A/z8s51DjIMVYb08Mp6KoBq/qHV0DuVfplI8rSe8wa7Pg2wHkW?=
 =?us-ascii?Q?X1ib2xmkWMDBls50OMOPEAUPlrlADgP2ZajXiiraiBVGKfW4dby/Qbk8d8Od?=
 =?us-ascii?Q?RPUFPH5xJKO3lix6kY7FSWv3+Iaj/OYEs63Fh15IerJ/IdsocD/xsX4VHnG7?=
 =?us-ascii?Q?doxg0SCUybGw/1QzpZfWgO348j9Omu6Mz4jS6TUMkZ4lEkwLvLU5kZS58vn7?=
 =?us-ascii?Q?CSbeNwOgq+OAbUasrRk0RnuoECdttQLMkTdslZH3MWtrPk6YOsKWVzeFgplc?=
 =?us-ascii?Q?4umA4y9D7e3KaNYZT9WvpwjVGbGRiGN3BhztEtfT15+37tpTOchK1gB9z/V1?=
 =?us-ascii?Q?qg8InX7rjIq1eDWMSD76BUoJq6dNTOzAaPC/eNjLh2G22c5Pe/F9it/y/YKA?=
 =?us-ascii?Q?g1RaOh824FxK1mC1QBt8SrvOtB1BxwlPqwZXW1VAoPcEPCj+9eMBw2dRqoFC?=
 =?us-ascii?Q?9N7W7Sr4iyk1EBIjc4Os1JOgpHIZxFZXOEr7vWRd5K5pnTAZy+nPoOoYlx76?=
 =?us-ascii?Q?r52/JLJL0FZcHiOEBTIq2eMskxUdvOl+OBQmj+N/IjuRHHYczvwHsSq8BcSL?=
 =?us-ascii?Q?tpqxS5dAUX0qWq/PytqQZ4djZw7gCxGNhz3so/ooWpla1pgPAsvHP9qMRrEF?=
 =?us-ascii?Q?EzZdGKTGbs6dDog7csAqcdgMYlIuoYtCagcMxVfr5vq/H8f/yZ10+If20wrO?=
 =?us-ascii?Q?w7N24NEO50j1/aB7VhO6cS3CFBjcP4sI2k1WXHnvxjzmRZr8bH26vmD4AIT5?=
 =?us-ascii?Q?dQNijTLzotUB7Zz3O4E085AXCjwcGAdYHg1nfCcMhc02ve9+xhsXAiNW6d8t?=
 =?us-ascii?Q?L8NoqPT9nM0h+zXlGLLCT99PwUhj6MN+9YM97u6HIO/zoDsxr3E0T3ayUfo1?=
 =?us-ascii?Q?NFX85YOp5iyQ9esBXaAlkEpoCWThyzafW803VfgjghXd1csvvhk7Bpy/UvdU?=
 =?us-ascii?Q?9aMGgVgEUae8L7CyrPIPa+hXd430LzWGpfACIswtvXTqYkILCIJ3wkrKdKj7?=
 =?us-ascii?Q?Z142xJtWM10wORP2GfYRrY7PIe8nb77j0yBzzWT6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35501c3e-c0e4-4e07-990f-08dad6947570
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:54.1414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZBBRiv1RaV+1VfcWas7veRssrkHudn0cJ4uWj6rf23krkLcHJpyb65BlmI2qGVyO6wa8zaae6JgYK5RK9X/3hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The checks only require information parsed from the RTM_NEWMDB netlink
message and do not rely on any state stored in the bridge driver.
Therefore, there is no need to perform the checks in the critical
section under the multicast lock.

Move the checks out of the critical section.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 67b6bc7272d3..aa5faccf09f8 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -805,24 +805,6 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	if (!brmctx)
 		return -EINVAL;
 
-	/* host join errors which can happen before creating the group */
-	if (!port && !br_group_is_l2(&group)) {
-		/* don't allow any flags for host-joined IP groups */
-		if (entry->state) {
-			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
-			return -EINVAL;
-		}
-		if (!br_multicast_is_star_g(&group)) {
-			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
-			return -EINVAL;
-		}
-	}
-
-	if (br_group_is_l2(&group) && entry->state != MDB_PERMANENT) {
-		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
-		return -EINVAL;
-	}
-
 	mp = br_multicast_new_group(br, &group);
 	if (IS_ERR(mp))
 		return PTR_ERR(mp);
@@ -1026,6 +1008,24 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
+	/* host join errors which can happen before creating the group */
+	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
+		/* don't allow any flags for host-joined IP groups */
+		if (cfg.entry->state) {
+			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
+			return -EINVAL;
+		}
+		if (!br_multicast_is_star_g(&cfg.group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
+			return -EINVAL;
+		}
+	}
+
+	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		return -EINVAL;
+	}
+
 	if (cfg.p) {
 		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
-- 
2.37.3

