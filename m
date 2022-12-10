Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BCE648F52
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLJO6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiLJO6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:58:14 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3C7183AE
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:58:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzvPbWWYcUcCp83N/tRRro+BKoDxK5MFIpZlkS9pv2KZ8nU9MdGTp3VkAlPYfBeNmZYb+PZ18VtVy7kgj8zLgOKBdzCjr8RkK19+wtQcATqKO2blf+TF8lnxmcGZEeJBxTCPjj5oJ5TBYVmGq1GCXPagNpkb7esxkaAZB4wbiGhswdbb8AE/I/AGenhiu+uvb3wcg04dik8mucMBDuK1rJeop7BhxAKxUjZr7MQ6WdDjUk5O/hZweSng6/vaz90B/br5t/W6Gq/vFLP/9opU4l/3kxCG3HGK1FVVYsk1NLowh0K/YGqhwFiAkQMhVgQ84TCF4CQQ0FZVcU3RCYDPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYgRQjJod9sxq0dZSHBMevA+JFjKhO4R5dJtsuTAAB0=;
 b=e24fOPWaRN8xM43dKWRlYbkvLszDa7Iz/6E3pMD1ibcLAoslfB26Gin9qBHNoywyipDCKVTNc+hWyCyiKV76zxbx+juO9bNnzTkxoRbaOTA6rS+rG5s7L6xBcAZZWUrqc9Nqhtg491qzSRb91A6jyUvs+RQAY7Fb0arfe6ZcOYlIFMgiwTHb8QmszLuIXGSAj8EugVn5QWwUoptjwL61+W2+YtnjwUj/p9Bz3ieJCk8xVqbhLsh8oojWvX8Fm6ty235CoTiBH8Ap/1KeCC0Te6ZOdeh1hRUD9gxOlKrM5HuYY1cu0L7eLCLpU7GlYqda2WuRq6ZWJY0IhgT/y3A6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYgRQjJod9sxq0dZSHBMevA+JFjKhO4R5dJtsuTAAB0=;
 b=dbSJD9N0aNmUxeclCQi2MDCDc0Leq9ZvtsCQHe0wUYAYHqe4hUADbHVPezHFm6qGcHrJ3ZHoE05fCOqMfF/a15sOTzqk4+GIBsE5ZUzb2sf7EJglEcTQzjV4KhVxxkw6ga2I8ErlHdb6+lKI/bLMPvsrW7ACbiZpjKCSbYuK1b6q1q2sMURqF2RrPxHWb2Vosa/V1Qt/mdymhyCTKdtA/EFFGHLncMMVMCzdawXHtBvrHdMh86S3A7/AAs/tw7JwOe6XgQdPX+Shi9UETtE/IziLwd3pggCiSGLwkM1IKQc6s2swgeopw5Nm0FEEb+yuxKo+byyFjrfC0Yc8CxzdPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:58:12 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:58:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 08/14] bridge: mcast: Avoid arming group timer when (S, G) corresponds to a source
Date:   Sat, 10 Dec 2022 16:56:27 +0200
Message-Id: <20221210145633.1328511-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0257.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 7729b3f6-e161-441a-70df-08dadabef581
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fFP/x5XFNwYJpLDYWUmO9rJ+8Kktzd9DhYYf432RRHalKt3I8+zeAJjPJd0tZ6Axto78J21ChRQDuf9wRw42YqJz9tBRjGE9eV7vC8OW5QH0/+3FA9yiEKXRI8FzQapO3480Qm+jl94s/+e0gkX9KedYyEPWFqatJPFCKYONm7b6rJMSzju4a+skgYTfflSr611wpidJ6CXII06E/7nRyGGixxcJsGUqFj29TUGL5KVRKyLga4tlFno4H6LL8yuaLWJRCbZTMqZYsp8Bgf+ZjTrQ+gBNk+ZBmnn2mISLI4D0/nVyGP6XkjF7Hn+vSNXZtSuRUoWsBE7LkROsGNYSDh7OblDepOFXlAwCaVaZTZbwRLxlsBn7YneF5GGsBP9Y734nV4QxmxaBOJujxAfjVrzh/gWypRd19SsLGOC9E1lDt5pBnYAxhT0cNlLILfafucZ3C3XTpjA4hnD4GkKfaIlijFO1OPIsJ7uuN18mKGQGTZMwrKK/CsA7aDLrEfDvNe8w2TLES7nJVuZ9R9Obci0nL+5RMA4SG/PQzd3F/tanPNvMHapllVE18fQECaX+/T9CnwWM66YDmObsG2WTdAo162m8CjKDRVp10VA4YUoe+mhnH6WEzwbgGpxvx4J5DL07PqCtg1TBZhbSfiiGkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cHJVBo8royIJKyvJm1e4+0VuAYHfuO62dR7wBaCyCOYx9WjscJCNsdrDJVV3?=
 =?us-ascii?Q?JJcCqexEEDXXb+VC2adYAvqkhIRgQoSWntTlMoxyzkVWT3Yjwih2xWzvF8OC?=
 =?us-ascii?Q?SsuBq8DNHTm/jzDz1w89HcgIgEI0JrzHLQ0Vn8wlxlhvDG8/D/7b4RP/RWz2?=
 =?us-ascii?Q?jw5AxI7Zvb+OSeG37vcGwaq+0w9sgA23YxIWLlu3Ol7rYZXPj9jfBY7Pk7tR?=
 =?us-ascii?Q?7Xw/3TT/CvaG09x+Ub/CIeyi6AG6nnLYC+qmM/ogpnO0JMdan25N7X8VIoaW?=
 =?us-ascii?Q?RQK3Kom8Z8UkrCOcqgsvNbIEuYJpiwwny+nbB+VAzD8jAh/Bt9PeS10zdCYm?=
 =?us-ascii?Q?IgJcEY9UYDHm+LaQezcdMs4z3s6w+Xkd6JMPlopBH9+wc2++3v3UC5nhGU2Z?=
 =?us-ascii?Q?d+78gI2oCoWeFzgsbYXFZBJ2WAFCw5tTG4PuAi3BJNI0NMN+QHj678nV7E88?=
 =?us-ascii?Q?Pn3ZuteNlq3rsxHZ/mExCQO6Cwrr/NUzR5hbkMaXkB5esZXW2Wj1o72jvvY6?=
 =?us-ascii?Q?teAHw5j0P66J2xLpeJEwLIlw7kRGetZ4f09HYDRYUTzJ15Jq2taCeV0jFgJu?=
 =?us-ascii?Q?XtvZ6PtFjeWt0nTKEEgxAemmu7mxxnrMCmdOmypgBaOL7eNV7b8Tk7G9d8Sg?=
 =?us-ascii?Q?dvDXkYQxglOYo11ahb96SwR37LqJkcWZ4v/L5hIShEMsaDcY6wW9xfqFIMbl?=
 =?us-ascii?Q?3o9r5gDaoGht10k0tMkWrupU+L2jTOvPlJvKjSRSH+Hb8hHdqt326l4JEsYk?=
 =?us-ascii?Q?Fzxy1RvdPUuqmni0DE4iRFiB9Oi6LKZyhHWGnQxU7loy0af7KWZzQVT2rEu9?=
 =?us-ascii?Q?i0Kf/5ON9n9uTawjvGzui3Fkv5gItwK9dZ0b47iIpxzB5v0I6Tl3at7+jET0?=
 =?us-ascii?Q?9ejW4MpJ5TD1JEoD2y8nyUc5/7EIGwuYd0kg6tuBVgV5YaRqVktVV9FhFW6I?=
 =?us-ascii?Q?5rhb3LI3WesDQ5y6oEGYLiMNqLBzDqYeT7M3XY4cpb87uqkROmIa5tyDxLBI?=
 =?us-ascii?Q?fdBrqXmIiTfVZuhGXB/FdgYVIKsBt7YGFVqghxAxzWEaO+hGK6nllu+QDodk?=
 =?us-ascii?Q?AA2/pzl2sx9qw3esk1esmaoDDqIEoTLT4qE3YC2TyUqrGnt9I36Dqj4idhuO?=
 =?us-ascii?Q?MZJn5AgenRcDKbNNRQAZagL5pvDEkxE5tHAcPgh2QoNraeKYf22/4EkSe9qY?=
 =?us-ascii?Q?VHJm7TaurUsb1u1vS3SvtzpGUGvEYzLjDNFsMI1rccIstCcxi3MfuHvRrCXb?=
 =?us-ascii?Q?y5BuEylFbv8k55o6FyYWXxgYsAhlnsLXrJbtkq353MaLluHfT8Z/tZJJENfj?=
 =?us-ascii?Q?TX7d/BUZjFu40UdWkzX9sU9Y70/vl7dZo3QqMvvVeUXGzrbptA5XGv/LuKe2?=
 =?us-ascii?Q?Mh32JQnoZvSgvidmXsPg+KlqOew0MHV/oIlPMS+kwhR0DsfcPBDhhsIGB6x3?=
 =?us-ascii?Q?EShtEAGBkTLOv+e/94xlQFs+kgEcN4zEyXvqBoxDbRLulQF4U7DjXiczBmLl?=
 =?us-ascii?Q?0BtXuch3qVP0L6BBurVmyt5Zge2cQ/gUQHEsJR5w060DLchPV4SHnjpcbg6m?=
 =?us-ascii?Q?LCUvX3vU/9RE0Z3dF7hmCvpQlYYF20zcNHz9Iy2c?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7729b3f6-e161-441a-70df-08dadabef581
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:58:12.5138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rql8DWedhYr3393R3TNXwuc2jTKgtHBA/Hne7mSKvCCe1iISD9yhtQ+aX44dwJKfplFnAl5Qg2cljKex/ilOFQ==
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

User space will soon be able to install a (*, G) with a source list,
prompting the creation of a (S, G) entry for each source.

In this case, the group timer of the (S, G) entry should never be set.

Solve this by adding a new field to the MDB configuration structure that
denotes whether the (S, G) corresponds to a source or not.

The field will be set in a subsequent patch where br_mdb_add_group_sg()
is called in order to create a (S, G) entry for each user provided
source.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c     | 2 +-
 net/bridge/br_private.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 95780652cdbf..7cda9d1c5c93 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -814,7 +814,7 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 		return -ENOMEM;
 	}
 	rcu_assign_pointer(*pp, p);
-	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
 		mod_timer(&p->timer,
 			  now + brmctx->multicast_membership_interval);
 	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 74f17b56c9eb..e98bfe3c02e1 100644
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

