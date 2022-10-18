Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E6E602B49
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiJRMIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiJRMIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:08:01 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D737780F44
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:07:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZS+wEdAU2fh0WH+iM61VfADuQI7WjhxUSeN6DiCi+qk0G1d2JVdT94pBWh3QRNcI4eDuxBcstTj/C6jmh4nhfnO6aXht2TK/fSe2uCvfF+hVtk7ju1YzCYatpO6rPuGQhodAAkNbzTciRf9sxntym2CJ4sDDjWSkRhH0Khr6Zx7T/4nZM1fmAztzjuUvpMCNyDZmLV2D6TcNlweOIo5ea2VyqTbh2bts7LFFv9Y7eAWGCzeIODIQOMxa/VF59khwgMQmuziWzImXp/i8SyUFxdsoOsO1+gRPc4s843+uhtYqIh+aue6gdqK6a8xh1VfbBB8jcU9x2NwLQa1qvva4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mk166414OYTnh30cMgdsgifjVP5OsqPSiKYrTmvtCOo=;
 b=J+HnLH/03iWwI+R+VTIzHOnJvrIcb4daSTsgNp1xouFA0+rX2cbQ5JcWzanu8HQKtUGEQIICbEqpT9mgBUysjijtJdFKwZJlcdd1KUy6yOH6GGKNHVvKrfN7p6FVMwLDAm3e5jwwq0yMRPshdUfkAlw/7yOm+7pycYgDxMIyMAuq1qqsVAxbc2wcYO54VzS4hofZ9M0N8H5/sjgyM2g958J/TWopEQFsCOC4TfdAsxjwZsRVa94NakKcNQITtajPaMcQ23Qw8hjd+Lgk02FH9sr5IQ8VrJcDNWqxTcRb/jnEXsT34CooAAMS+5PGXxD009k7M6lvEHMhXDUOAV36Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mk166414OYTnh30cMgdsgifjVP5OsqPSiKYrTmvtCOo=;
 b=SBNc/9+708NFCvWCj2PgAKnu3TlWbSZkGBoQYLjseHrlcT2gcqtfvUrtwZvhECVn9/XMhYNqdKTsZYvnpbNCNDvACDhbs7ij91t2V5sPtoXIla4SR3mTP1lg69E5XpuvEHv8sq0TJBqX/l0k9zJuisw0TD1Fz6p/WdZQlvyU6ju7HJSMoN4MBx2IcKMi4NjuGKGTbFnqiu5lvMs/kjTAjvLFpGxk2tHhOVGxIMAjmPGJzd+741cbEMUB6uOzx8V+pIls0A6vnzvk8Sf2mPfSdSQ/g6vTVBAZ/cclZgfid8OnEVnj2SH6P70oXAnZS6fQqO1Da1m3KJFbw+u4T0H/OA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 12:07:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:07:00 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 16/19] bridge: mcast: Add support for (*, G) with a source list and filter mode
Date:   Tue, 18 Oct 2022 15:04:17 +0300
Message-Id: <20221018120420.561846-17-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0040.eurprd09.prod.outlook.com
 (2603:10a6:802:1::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: b7d0ba66-3ccc-4fc3-c9b8-08dab1014303
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0jU1Q5aMoSUXJV6rDJd17/X+rBOK6shEBhN5x8CpXnnMTQ8f09c1aBjbwSLgLIXkz+2TvqiGO8T/9ls5i19ZTjdtLz3/Bes8F/fEB4D+Y8gKYmd6L7drueD4qbP64b8hMSyZUdccKwWfEbdf//pmjXMJkwQKi1x58EgSsguZ0naDVQY2w+BLUzFyhry0Y1xJcapNeZS2z5OotPsuxthhWiAlgFd7rUwLr1HVYXA22y49AF5yfEXddD0cmASQY3OLu1b73GgtXjZsFax5amgIHtHLLhTdcwlgsDvfZ9moNyLLUVuU+OC8Ffkgdd+En2C5/fwT4Rw1GD9ykJMw6L9kcsEMYmy0878eKfwN22AKq9GTAvhLJ1kGedg+DTA1hJgAAQAQ7RShPlqQLQSJmdV3PucWPVjwzbK6B45RyqzFb0fEq/ZBlt/eij5woC92wgZfbYtmx75TrScCx5I0tk1YAbNO63P2D863w8d+Kf+bbygFUwRsDV5c3j2GNSy6MhYdowdEk579pymJUul4cGfOCXLOudnAnVC5TQ/gaijLQG8+ozhxwz6P1qnG1ov9/R/LQQgw3RC5HpL47CgvSyM3baC5Uik/B+iC1hByZTmCjyzNcC9Slug7kkgObGretjjxFEcY1qQuSP+8BdO93cRMpyi68ejlFYj6gK3jKq+CUFLeYHBx7mxlBMAPidGNkvqyaJqs5iVij1ztZDeeXrbWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(36756003)(2906002)(8936002)(86362001)(4326008)(5660300002)(107886003)(6512007)(6666004)(26005)(41300700001)(186003)(2616005)(1076003)(478600001)(8676002)(6486002)(66946007)(83380400001)(66476007)(66556008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ODhSDOWsfvczvCgNLS/ZkbU1yDhuDmUh5LXdAyyKDpxS163fyS/v8y3y+n5t?=
 =?us-ascii?Q?s8fkxu6lj5wNNCtFBMbuFc383ZlGwcH0gywcgKXPDiJIhhCiFrrdiV51lH9H?=
 =?us-ascii?Q?8PcaXaFOX3k9E0+8msyMFfHj8R3IHiacIAWDerGkylKwGLy12GaslwZUKyd9?=
 =?us-ascii?Q?h2U4y3fgEq9+72o6UhtrfEVaATH2cwDmzollj9KPpRSq5XmYG5hJGl04tJXF?=
 =?us-ascii?Q?9PW7dFe/SrJltRMKT452nFAFuxzfuI7BD4DdJBXuaNqN5NNdIOyVoQHMYs9T?=
 =?us-ascii?Q?PN65YvLqa5xcLcyUJ7gBTCGKdWz2udIFvjkE2iuvpsWZ/Rb9l+mdF6o1faHe?=
 =?us-ascii?Q?3XCoTg18V/94GvEPfLbcnWjKQg9HarDM0xhCrYXtqkrOX/VV2FBgkPgelyRo?=
 =?us-ascii?Q?6PjVzfVynzdtMB7gChQ5NBKQopr/Y1ZrA41Z0/szu0sdsVsQZSLo72xHX849?=
 =?us-ascii?Q?KOzmbQdOFq+6oJjEhzTm8mwipcjK8yuFDHc0LAEuRdY9jtaYp+xog1003p4a?=
 =?us-ascii?Q?clSknQ9s4rFdSQZQ+Heh5APKXzKUDJI3/0fvKe3YR1AtBrL5Qa08qiiKdpgY?=
 =?us-ascii?Q?2TgMdjGwFcI0CNNLefZcc/0hy+tt8FpKwORX4X54hZAGT/Ziqbtni1c9jXSm?=
 =?us-ascii?Q?PKH0Gru24liZlWGREgO0CQJ8dr6por2kKlPz0BkwfRG54irE2rFBTd96TXMX?=
 =?us-ascii?Q?CU1Im6pFf+iUNHlfN8mBTpC9H8obSoR+jgDsT6yAGy0eB+cUYjH1mmcEIqqE?=
 =?us-ascii?Q?884Ih6z7wQrfpUoJMHI4gA16rmfit6uc4elRcZjeuGwkReaLVoNz/lLbT7TL?=
 =?us-ascii?Q?r/D0ZIqor8gy1qT5sPjK+pAbFXWdZ5nAga2fc/SQPjGP6j26Xz6lU8gcNIu3?=
 =?us-ascii?Q?NOURcOUufKjdc/VMxTAiK04xSQTjMrxSQxxMnkKtX8TwO116mwpy8BHuAT6F?=
 =?us-ascii?Q?OQmg2q0pKse1PTkQn6M0HknLu0h5nTveYwYUHxsPdkEjlpdii/Xqj3HuHFj3?=
 =?us-ascii?Q?xvI890KIlLjF3E+PMgtiV7l4HpQ8F0iI7P9YN1IhM1auO+BtUilIYsOtu3L8?=
 =?us-ascii?Q?NG/Am0EyZqjcCjtBs51rehLPMgVQcvbpq7owVjbcxkobo+Thgq+EIb5Q6pjM?=
 =?us-ascii?Q?5tfshk9S+ZQfXaNXwWKlGHPVZfogLliMkYdhp5e5nN9IzUCi7CDvuFEAe/rz?=
 =?us-ascii?Q?RHj/ECcSBN0fvuG6n3iEbQ1tgAxDbqahM9hzF98Ixj8Cogz65F8jLOVjilYR?=
 =?us-ascii?Q?GHpdihveQCUR18+Z3TmohVyhZW7byXgXalmusoxw8JtAbYTYZjCLANHTDxJ/?=
 =?us-ascii?Q?iw14/bcBjqpJ2eynwhNdDPDktxrKm1o0qbcX3nTsDtgMwDwQPP2jWArDumHg?=
 =?us-ascii?Q?icjwOedXTtnnSE66kOMnrRi4hIMpWDTnByyAoJ3TD1tbwV7cI4ZniDfpPP8Z?=
 =?us-ascii?Q?mGkLjLKJfEu35GtkSP96/5eq434TirO6l+68iK7nOq77RGb4SIQFQi6jrc7+?=
 =?us-ascii?Q?n72Z+EtNO4CSkWo5KKNAUHTRsfE6YmaRUFTgHtlUNrKNm0ZTw5a38mKYz6mB?=
 =?us-ascii?Q?MBVQ7WDMPSh6n5jN5LaFpW5RBySoDxqCcEAOA1d1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7d0ba66-3ccc-4fc3-c9b8-08dab1014303
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:07:00.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cw/LLcKUcpgxuvjGr06euxGsxK/DN9zNwJcKFrCT1IJbbV/ojvEsVZyhRh1jlTX8XZxtHbClzlmpsCAybODPgQ==
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

In preparation for allowing user space to add (*, G) entries with a
source list and associated filter mode, add the necessary plumbing to
handle such requests.

Extend the MDB configuration structure with a currently empty source
list and filter mode that is currently hard coded to EXCLUDE.

Add the source entries and the corresponding (S, G) entries before
making the new (*, G) port group entry visible to the data path.

Handle the creation of each source entry in a similar fashion to how it
is created from the data path in response to received Membership
Reports: Create the source entry, arm the source timer (if needed), add
a corresponding (S, G) forwarding entry and finally mark the source
entry as installed (by user space).

Add the (S, G) entry by populating an MDB configuration structure and
calling br_mdb_add_group_sg() as if a new entry is created by user
space, with the sole difference that the 'src_entry' field is set to
make sure that the group timer of such entries is never armed.

Note that it is not currently possible to add more than 32 source
entries to a port group entry. If this proves to be a problem we can
either increase 'PG_SRC_ENT_LIMIT' or avoid forcing a limit on entries
created by user space. For example, by adding a new argument to
br_multicast_new_group_src().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c     | 130 +++++++++++++++++++++++++++++++++++++++-
 net/bridge/br_private.h |   7 +++
 2 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 2804da7b0aa1..8fc8816a76bf 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -836,6 +836,115 @@ static int br_mdb_add_group_sg(struct br_mdb_config *cfg,
 	return 0;
 }
 
+static int br_mdb_add_group_src_fwd(struct br_mdb_config *cfg,
+				    struct br_ip *src_ip,
+				    struct net_bridge_mcast *brmctx,
+				    struct netlink_ext_ack *extack)
+{
+	struct net_bridge_mdb_entry *sgmp;
+	struct br_mdb_config sg_cfg;
+	struct br_ip sg_ip;
+	u8 flags = 0;
+
+	sg_ip = cfg->group;
+	sg_ip.src = src_ip->src;
+	sgmp = br_multicast_new_group(cfg->br, &sg_ip);
+	if (IS_ERR(sgmp)) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to add (S, G) MDB entry");
+		return PTR_ERR(sgmp);
+	}
+
+	if (cfg->entry->state == MDB_PERMANENT)
+		flags |= MDB_PG_FLAGS_PERMANENT;
+	if (cfg->filter_mode == MCAST_EXCLUDE)
+		flags |= MDB_PG_FLAGS_BLOCKED;
+
+	memset(&sg_cfg, 0, sizeof(sg_cfg));
+	INIT_LIST_HEAD(&sg_cfg.src_list);
+	sg_cfg.br = cfg->br;
+	sg_cfg.p = cfg->p;
+	sg_cfg.entry = cfg->entry;
+	sg_cfg.group = sg_ip;
+	sg_cfg.src_entry = true;
+	sg_cfg.filter_mode = MCAST_INCLUDE;
+	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
+}
+
+static int br_mdb_add_group_src(struct br_mdb_config *cfg,
+				struct net_bridge_port_group *pg,
+				struct net_bridge_mcast *brmctx,
+				struct br_mdb_src_entry *src,
+				struct netlink_ext_ack *extack)
+{
+	struct net_bridge_group_src *ent;
+	unsigned long now = jiffies;
+	int err;
+
+	ent = br_multicast_find_group_src(pg, &src->addr);
+	if (!ent) {
+		ent = br_multicast_new_group_src(pg, &src->addr);
+		if (!ent) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to add new source entry");
+			return -ENOSPC;
+		}
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Source entry already exists");
+		return -EEXIST;
+	}
+
+	if (cfg->filter_mode == MCAST_INCLUDE &&
+	    cfg->entry->state == MDB_TEMPORARY)
+		mod_timer(&ent->timer, now + br_multicast_gmi(brmctx));
+	else
+		del_timer(&ent->timer);
+
+	/* Install a (S, G) forwarding entry for the source. */
+	err = br_mdb_add_group_src_fwd(cfg, &src->addr, brmctx, extack);
+	if (err)
+		goto err_del_sg;
+
+	ent->flags = BR_SGRP_F_INSTALLED | BR_SGRP_F_USER_ADDED;
+
+	return 0;
+
+err_del_sg:
+	br_multicast_del_group_src(ent, false);
+	return err;
+}
+
+static void br_mdb_del_group_src(struct net_bridge_port_group *pg,
+				 struct br_mdb_src_entry *src)
+{
+	struct net_bridge_group_src *ent;
+
+	ent = br_multicast_find_group_src(pg, &src->addr);
+	if (WARN_ON_ONCE(!ent))
+		return;
+	br_multicast_del_group_src(ent, false);
+}
+
+static int br_mdb_add_group_srcs(struct br_mdb_config *cfg,
+				 struct net_bridge_port_group *pg,
+				 struct net_bridge_mcast *brmctx,
+				 struct netlink_ext_ack *extack)
+{
+	struct br_mdb_src_entry *src;
+	int err;
+
+	list_for_each_entry(src, &cfg->src_list, list) {
+		err = br_mdb_add_group_src(cfg, pg, brmctx, src, extack);
+		if (err)
+			goto err_del_group_srcs;
+	}
+
+	return 0;
+
+err_del_group_srcs:
+	list_for_each_entry_continue_reverse(src, &cfg->src_list, list)
+		br_mdb_del_group_src(pg, src);
+	return err;
+}
+
 static int br_mdb_add_group_star_g(struct br_mdb_config *cfg,
 				   struct net_bridge_mdb_entry *mp,
 				   struct net_bridge_mcast *brmctx,
@@ -845,6 +954,7 @@ static int br_mdb_add_group_star_g(struct br_mdb_config *cfg,
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p;
 	unsigned long now = jiffies;
+	int err;
 
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
@@ -858,23 +968,35 @@ static int br_mdb_add_group_star_g(struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					MCAST_EXCLUDE, RTPROT_STATIC);
+					cfg->filter_mode, RTPROT_STATIC);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
 		return -ENOMEM;
 	}
+
+	err = br_mdb_add_group_srcs(cfg, p, brmctx, extack);
+	if (err)
+		goto err_del_port_group;
+
 	rcu_assign_pointer(*pp, p);
-	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+	if (!(flags & MDB_PG_FLAGS_PERMANENT) &&
+	    cfg->filter_mode == MCAST_EXCLUDE)
 		mod_timer(&p->timer,
 			  now + brmctx->multicast_membership_interval);
 	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
 	/* If we are adding a new EXCLUDE port group (*, G), it needs to be
 	 * also added to all (S, G) entries for proper replication.
 	 */
-	if (br_multicast_should_handle_mode(brmctx, cfg->group.proto))
+	if (br_multicast_should_handle_mode(brmctx, cfg->group.proto) &&
+	    cfg->filter_mode == MCAST_EXCLUDE)
 		br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
 
 	return 0;
+
+err_del_port_group:
+	hlist_del_init(&p->mglist);
+	kfree(p);
+	return err;
 }
 
 static int br_mdb_add_group(struct br_mdb_config *cfg,
@@ -967,6 +1089,8 @@ static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
 		return err;
 
 	memset(cfg, 0, sizeof(*cfg));
+	cfg->filter_mode = MCAST_EXCLUDE;
+	INIT_LIST_HEAD(&cfg->src_list);
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1bd6eebad002..0189fce6f3b7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -93,12 +93,19 @@ struct bridge_mcast_stats {
 	struct u64_stats_sync syncp;
 };
 
+struct br_mdb_src_entry {
+	struct list_head		list;
+	struct br_ip			addr;
+};
+
 struct br_mdb_config {
 	struct net_bridge		*br;
 	struct net_bridge_port		*p;
 	struct br_mdb_entry		*entry;
 	struct br_ip			group;
 	bool				src_entry;
+	u8				filter_mode;
+	struct list_head		src_list;
 };
 #endif
 
-- 
2.37.3

