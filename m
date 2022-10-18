Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5D602B4C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJRMJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiJRMIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:08:50 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5161BBEAFB
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:08:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8ig9+dIpjTolMjBEmVZmHhPRDqdv9H8/Yhh6ES5QlIdRS/QNUISmJCpgJpmgKuJzzbTRkb2NwHYloJs93HTfdn4fcCrBDqTN/MwhmNR6mpN6L2sxOiHmAPzRV8sLE92h4wqa0QUfBIHiq2nbV63inzjqCv0K0WCCW890HLT18sDv3AeOGvko3lEXmhBc37HdS7yKmnjJPdb609JMAx7GMQzMuVf06v/AM3i1ROOdTOpZg1Ab4xvsS7o3n17d0tTy1WNdNY92/xuBerbj0did5L04UDEjqCywcZUKgekc0n05NzhZt8Ief6VfqfgtbHgJPH8gCmUHvFq4ndzF7mipA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/fkwh202eXgpsxIjCf8XrnU2/86UOeQGTa0oGgKb+tI=;
 b=QXqyglBU5BFbXiaNkB5289YCpWEqwq8EpfOuHqEauvgnE93E0xUCEzm6XqT3ZbCoFlbz5LMNp6rmF2kSxNqgtdFlXqTDelWRkZa1ysyhaxdtZZiOe9t8pHxv4loKgBma3p0U4aaqZs+PGBh9kqrhhxS8zXkb2Ig6GKe4sCx//bsQRZzycI6GO+D66OGDv7TgwkJUTbKap/Zgk1PIyP6hc3I7hqtdhRZ/JchHpaE0wf0L/HEilxyTQ89H1iPG8p339VOTYsZX4guNX0kUUxiaeDG3l5ZdIRjwpQ4Gi9F+OzkC2mGnIhPtDftdkHB7TPo7qytUQhRldt7D0VWh54KFUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fkwh202eXgpsxIjCf8XrnU2/86UOeQGTa0oGgKb+tI=;
 b=RzbD2gerKyYtKxnxypBPO3N5iTkk4gU+1wXSo/4iB9Z/CwFgm2Vytn4zK8S6it8qJjJQHfOtzdAAzSYGSjXY3jXQwZ8HeLQWdO9lqfeJOiZGd36uLTeRMWuqa6chp/i3jPbI6aEgo321qDgttUdgb1TwRIhzrOxnJtCsqEmRFXAg20UVSGo1TuQRo3lNs0OYgRHSmH2/WZn+rIdUj3JQdg0pPA04XfaGhkaqQ+/iXliubSdDabQiYgulxHZyVMrid5pC4vTIVen8uGcRK6LWALD83f2PWBtGrzvMbDWG4HObFl2RiiwnFPQ46ZSTP9tSXzs8DzghzrX3l7zrkp9pPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 12:07:27 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:07:26 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 19/19] bridge: mcast: Support replacement of MDB port group entries
Date:   Tue, 18 Oct 2022 15:04:20 +0300
Message-Id: <20221018120420.561846-20-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0219.eurprd07.prod.outlook.com
 (2603:10a6:802:58::22) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: c31e96ff-1221-44e6-e0c6-08dab10152b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTdRU5Ss9QlYDtijjUo/3wPQonBtdwKZ8auJtZbl6TofrWqFTMlAlCMbC23OK487Vj56KwIspyfLwffnMYsYleLRftu5ZwPzgGNc0Aud+x851i+vh1chEB0OulMp3Dopu0vxpnYOjhL9k3kdo1Knt39GOmy/7sApZict183EMVB003WdLV6KLAa2RTVU/QqsLWvxPechuY2Ht/LyqMTV5xAGh7vHLZBQOOH+kAB/ls8HKh/ryPWaiHaEnubi/AffV9FD9v7HAcNJeQyzNMSzkU61P7uPhZ+XphO+9mDUaP9K2ZHdp/yxWP3VlY9nQE5kiNyl5GRbnwJIXOLs7a6ScHOYXvJ7vrQqrttUFwxcxUTidzNwatlR//mAyQ9AX9/YvkpHFZidT8BIjKMw57RpPw8UmORlJ2fCrDxVOAMDHx+7XPQuvQJm2aywZ5mMAoUg0G74Y4AeuKJHLSIT3Ki98mBIqB1XR+9imr7Pw7Y4DitBPkVqcB7burT/L1jY7A/8k5y04XadQUbaJ9pVNXf64t1COm3c4/2crRiNv7V9UVfManqqTiQ9AhGQagjaYKq0+Kh8yleCYF6QZgsxzvqZfFOPQlG/5QtAomOB3e1g4iB/HAEAdhhix2AJoETHSG4Nf9FEAbXJUWhw+tqp2hUcWF0LTxPmx5ZqLxP+Hq9bbsigM38aVX1OVApVBzyI9mStU7E0xPvABm0TRM8fIrjkAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(36756003)(2906002)(8936002)(86362001)(4326008)(5660300002)(107886003)(6512007)(6666004)(26005)(41300700001)(186003)(2616005)(1076003)(478600001)(8676002)(6486002)(66946007)(83380400001)(66476007)(66556008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CLcfj/iGQ92g4+BtSbYXj4qgXj7nifjZuBmLjGfMUAsiiOVxfYtYm/T2D+Pp?=
 =?us-ascii?Q?TBgYfv6T81wqfg6iV0xyEVsjQx7t2j0mqFE70uo48zQniEO+oo4kZm6FcdkD?=
 =?us-ascii?Q?bKISyjm3PRGH89QQQhOXSZHEd7yQYwuQtcu84hwHdUHHyfCdIFzAaDf3t5Ut?=
 =?us-ascii?Q?w7Z/64WPtlnJ/Jw4iPRplIHfvqi27fyNtuxqILVXRy93m6WnpqdOMcVCmXjX?=
 =?us-ascii?Q?KqoLvxAwxngKqrCiNFXYeHQEBQoD5uhnV2xCt1iAzd2bLApjHGLvBCFyDrFO?=
 =?us-ascii?Q?6rKe9v0QKQLMAv0CQL05rmbV0QokHPCD02mM4ODx/LiDcPjMLPgRq71DCst9?=
 =?us-ascii?Q?PQBrW1b0+p6UvyqH68BOMWRdS8yBpVkZuqp6C6r48dYINUpSu5axCBamtR2L?=
 =?us-ascii?Q?z7lfDn5Dj8vnpCi7xg5ssKO4IXk2CU1f3Q+o3pnfZCSqIysitc+NZQjL/r8V?=
 =?us-ascii?Q?tBDMGnHU0FNkRzWC7jES1+IDCA9yqK1fO6gslhyxH8zDl3IkcOOYF1wQknMG?=
 =?us-ascii?Q?aTXTQRjexyGMEJyAAMCAZwgsrt4uBO3gKFAPhG3H+GEgMG4RFdOpeEQRAbl9?=
 =?us-ascii?Q?i3eUD1xBbjlu7D++Fk+y6jKVtEclqmPQ6zzIpuRAPUJAxRQ7Mx5EBWl/1wFu?=
 =?us-ascii?Q?A4QdCpziSQOcRlWzVx2yCNVawPsrFUSySMSOJlzXmXvLxiHqNbHMRrdAM+wl?=
 =?us-ascii?Q?JgrwkRN/4L8ygDmaSQWfHpDVo4Op9dOEu1sijGmUnv2LE9zHZgbK/L6Z8/YW?=
 =?us-ascii?Q?VyGjvSGMC37ufAbsCRyZRfEMTZDKqkmHf681OQ79sy58MP0C/6eFIobeW2Dg?=
 =?us-ascii?Q?uI7XhiZxPBcTxYWJIavjH7CuHXs0EXHj/FRpG1uDLKx4LxaRkQjX67GEZyFd?=
 =?us-ascii?Q?poFVvtNCzEv3Gj9xlQM2EYuMvFjhXo/uKKlOTz5aG7BHzZ1ZCqUz3VM9/VG6?=
 =?us-ascii?Q?+pCd/3hcYg2JV76EW5dMVaJwJR64J3wdMgLgI+JbV5zWCVznaj+M4YL+bRzS?=
 =?us-ascii?Q?govyF+m8v0VKZ/zSfFwdQcFATj6pp2HgG3QRD8YruIv+xWbkv7pcFy5gAtry?=
 =?us-ascii?Q?7zZkfm0FUGiKtZGNs0GWn/c7qMWSVeDzF4rjC53uB5ZKIPwTDCBNveRtpnIm?=
 =?us-ascii?Q?lZE6vrifznHdO/dTBbXkUpvoGsi74Hr1sQ5K1dR3cKhb1+M8yQGWfJ30+yYk?=
 =?us-ascii?Q?qR1V2rc+2BkYPysTdgGprwvCsOMMC6xmmUWa6+VDJgTAuNKspKMhbomZMWc9?=
 =?us-ascii?Q?kFNVGepAh7pyEn2uFMAE+Jh/l/m+crwz85z1uA2F5WXtl+A0z6UijW5BfqLt?=
 =?us-ascii?Q?M7dN7mJcBhHIvuYjlb/eolWM5E8wh1uch9hn1h3Msg0nf/JN5akehq+wJzbz?=
 =?us-ascii?Q?VhjEJsJ4z9fxrIRWVvwP06RfXxjcXGhAHlXhYzbozJCCWlfvScXgkyQtDhje?=
 =?us-ascii?Q?atSd8/NRJ6kHXA/do8AKlNMrcRofZxNC+M4cUzWarPzXxguqSIHlNWQnFYQC?=
 =?us-ascii?Q?9+flYQPO7gQamP869eJOTdV2DFf9Fo3UGKCbBOAvbpxg95MTW+c4mtxEx8NO?=
 =?us-ascii?Q?vWl08m4kPb/VHDWExUKeZEfVzLIcTL4oHo1AgtUI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c31e96ff-1221-44e6-e0c6-08dab10152b5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:07:26.8958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8IH8qFv3xkLvJ1lWHwcn0EkkW5rdIUxMt0ePiRV7AfK6QY3ozXBfHeOy+7481v+xyMRYmVv0Z0seeoxJxF/jQ==
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

Now that user space can specify additional attributes of port group
entries such as filter mode and source list, it makes sense to allow
user space to atomically modify these attributes by replacing entries
instead of forcing user space to delete the entries and add them back.

Replace MDB port group entries when the 'NLM_F_REPLACE' flag is
specified in the netlink message header.

When a (*, G) entry is replaced, update the following attributes: Source
list, state, filter mode, protocol and flags. If the entry is temporary
and in EXCLUDE mode, reset the group timer to the group membership
interval. If the entry is temporary and in INCLUDE mode, reset the
source timers of associated sources to the group membership interval.

Examples:

 # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.2 filter_mode include
 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.2 permanent filter_mode include proto static     0.00
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto static     0.00
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode include source_list 192.0.2.2/0.00,192.0.2.1/0.00 proto static     0.00

 # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 permanent source_list 192.0.2.1,192.0.2.3 filter_mode exclude proto zebra
 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 permanent filter_mode include proto zebra  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra  blocked    0.00
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude source_list 192.0.2.3/0.00,192.0.2.1/0.00 proto zebra     0.00

 # bridge mdb replace dev br0 port dummy10 grp 239.1.1.1 temp source_list 192.0.2.4,192.0.2.3 filter_mode include proto bgp
 # bridge -d -s mdb show
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.4 temp filter_mode include proto bgp     0.00
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.3 temp filter_mode include proto bgp     0.00
 dev br0 port dummy10 grp 239.1.1.1 temp filter_mode include source_list 192.0.2.4/259.44,192.0.2.3/259.44 proto bgp     0.00

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c     | 103 ++++++++++++++++++++++++++++++++++++++--
 net/bridge/br_private.h |   1 +
 2 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7ee6d383ad07..b0c506a3e09e 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -802,6 +802,28 @@ __br_mdb_choose_context(struct net_bridge *br,
 	return brmctx;
 }
 
+static int br_mdb_replace_group_sg(struct br_mdb_config *cfg,
+				   struct net_bridge_mdb_entry *mp,
+				   struct net_bridge_port_group *pg,
+				   struct net_bridge_mcast *brmctx,
+				   unsigned char flags,
+				   struct netlink_ext_ack *extack)
+{
+	unsigned long now = jiffies;
+
+	pg->flags = flags;
+	pg->rt_protocol = cfg->rt_protocol;
+	if (!(flags & MDB_PG_FLAGS_PERMANENT) && !cfg->src_entry)
+		mod_timer(&pg->timer,
+			  now + brmctx->multicast_membership_interval);
+	else
+		del_timer(&pg->timer);
+
+	br_mdb_notify(cfg->br->dev, mp, pg, RTM_NEWMDB);
+
+	return 0;
+}
+
 static int br_mdb_add_group_sg(struct br_mdb_config *cfg,
 			       struct net_bridge_mdb_entry *mp,
 			       struct net_bridge_mcast *brmctx,
@@ -816,8 +838,12 @@ static int br_mdb_add_group_sg(struct br_mdb_config *cfg,
 	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
 	     pp = &p->next) {
 		if (p->key.port == cfg->p) {
-			NL_SET_ERR_MSG_MOD(extack, "(S, G) group is already joined by port");
-			return -EEXIST;
+			if (!(cfg->nlflags & NLM_F_REPLACE)) {
+				NL_SET_ERR_MSG_MOD(extack, "(S, G) group is already joined by port");
+				return -EEXIST;
+			}
+			return br_mdb_replace_group_sg(cfg, mp, p, brmctx,
+						       flags, extack);
 		}
 		if ((unsigned long)p->key.port < (unsigned long)cfg->p)
 			break;
@@ -884,6 +910,7 @@ static int br_mdb_add_group_src_fwd(struct br_mdb_config *cfg,
 	sg_cfg.src_entry = true;
 	sg_cfg.filter_mode = MCAST_INCLUDE;
 	sg_cfg.rt_protocol = cfg->rt_protocol;
+	sg_cfg.nlflags = cfg->nlflags;
 	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
 }
 
@@ -904,7 +931,7 @@ static int br_mdb_add_group_src(struct br_mdb_config *cfg,
 			NL_SET_ERR_MSG_MOD(extack, "Failed to add new source entry");
 			return -ENOSPC;
 		}
-	} else {
+	} else if (!(cfg->nlflags & NLM_F_REPLACE)) {
 		NL_SET_ERR_MSG_MOD(extack, "Source entry already exists");
 		return -EEXIST;
 	}
@@ -962,6 +989,67 @@ static int br_mdb_add_group_srcs(struct br_mdb_config *cfg,
 	return err;
 }
 
+static int br_mdb_replace_group_srcs(struct br_mdb_config *cfg,
+				     struct net_bridge_port_group *pg,
+				     struct net_bridge_mcast *brmctx,
+				     struct netlink_ext_ack *extack)
+{
+	struct net_bridge_group_src *ent;
+	struct hlist_node *tmp;
+	int err;
+
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags |= BR_SGRP_F_DELETE;
+
+	err = br_mdb_add_group_srcs(cfg, pg, brmctx, extack);
+	if (err)
+		goto err_clear_delete;
+
+	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node) {
+		if (ent->flags & BR_SGRP_F_DELETE)
+			br_multicast_del_group_src(ent, false);
+	}
+
+	return 0;
+
+err_clear_delete:
+	hlist_for_each_entry(ent, &pg->src_list, node)
+		ent->flags &= ~BR_SGRP_F_DELETE;
+	return err;
+}
+
+static int br_mdb_replace_group_star_g(struct br_mdb_config *cfg,
+				       struct net_bridge_mdb_entry *mp,
+				       struct net_bridge_port_group *pg,
+				       struct net_bridge_mcast *brmctx,
+				       unsigned char flags,
+				       struct netlink_ext_ack *extack)
+{
+	unsigned long now = jiffies;
+	int err;
+
+	err = br_mdb_replace_group_srcs(cfg, pg, brmctx, extack);
+	if (err)
+		return err;
+
+	pg->flags = flags;
+	pg->filter_mode = cfg->filter_mode;
+	pg->rt_protocol = cfg->rt_protocol;
+	if (!(flags & MDB_PG_FLAGS_PERMANENT) &&
+	    cfg->filter_mode == MCAST_EXCLUDE)
+		mod_timer(&pg->timer,
+			  now + brmctx->multicast_membership_interval);
+	else
+		del_timer(&pg->timer);
+
+	br_mdb_notify(cfg->br->dev, mp, pg, RTM_NEWMDB);
+
+	if (br_multicast_should_handle_mode(brmctx, cfg->group.proto))
+		br_multicast_star_g_handle_mode(pg, cfg->filter_mode);
+
+	return 0;
+}
+
 static int br_mdb_add_group_star_g(struct br_mdb_config *cfg,
 				   struct net_bridge_mdb_entry *mp,
 				   struct net_bridge_mcast *brmctx,
@@ -977,8 +1065,12 @@ static int br_mdb_add_group_star_g(struct br_mdb_config *cfg,
 	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
 	     pp = &p->next) {
 		if (p->key.port == cfg->p) {
-			NL_SET_ERR_MSG_MOD(extack, "(*, G) group is already joined by port");
-			return -EEXIST;
+			if (!(cfg->nlflags & NLM_F_REPLACE)) {
+				NL_SET_ERR_MSG_MOD(extack, "(*, G) group is already joined by port");
+				return -EEXIST;
+			}
+			return br_mdb_replace_group_star_g(cfg, mp, p, brmctx,
+							   flags, extack);
 		}
 		if ((unsigned long)p->key.port < (unsigned long)cfg->p)
 			break;
@@ -1222,6 +1314,7 @@ static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
 	cfg->filter_mode = MCAST_EXCLUDE;
 	INIT_LIST_HEAD(&cfg->src_list);
 	cfg->rt_protocol = RTPROT_STATIC;
+	cfg->nlflags = nlh->nlmsg_flags;
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 73f0e98de33b..7831f01fa018 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -107,6 +107,7 @@ struct br_mdb_config {
 	u8				filter_mode;
 	u8				rt_protocol;
 	struct list_head		src_list;
+	u32				nlflags;
 };
 #endif
 
-- 
2.37.3

