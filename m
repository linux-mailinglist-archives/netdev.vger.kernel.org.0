Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FF2648F55
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiLJO6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiLJO6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:58:22 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2060.outbound.protection.outlook.com [40.107.212.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562ED165AD
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:58:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgmHm+vj8eDlCfEh1bL9MZXleVo8oyyJZEtiM7QudS4iPtGGrnUjbEs1dFJKYOSA9coNghkx4d1CnCxWoMhHVhKA4i7Sob/X8O+dOeK3cy7iD4xXYNmuI62IYlIApYp5ORL5yghbb3Yh5cNwD49FhmkiPztD8ouVCtABvDZ1ZtKMs00x6qMnNzH12Jp/yvMCyM6AATNTkdSuX+Xmbp0efUuJY4Sxowf1h1ec7bSMDcBfceJgRP+Tele+zirBssTWOBeV903C1qgnfEEXGshlp4ZwdURm1pJNTUMQtWHzYJhjLWj+9KRiFkvf7KQbAX86A7qBJxaiDSozoxL7hfmnyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZJ8CCbsl/gjhK+QFImDzWN5UiqPInCf2cah5MNbM7E=;
 b=mjkrF7sqGZpWUdNXV0YVru7BgjiRzK7C3IZ9EG+VAmSb/qqegaz+iCMRmH2phpyVWqj65OeguhLY+dFUjdBg0msdvle+zYM7KYeOP0D801vyt5OgAyl/cs0jI/vZK8Jv7XOBzxZ0GG/0VczAcHLOlBCmIwZSIxh8C+5/hZRjGgrshPJeNTwXgOki69dDIX+wfYEPaOti340PembBROzkSrpErsFZbhCjeWa7wFEnYguxIwq4Oo3DOwac8/lkEhR5aQg+5UQo9A7F1MnAdFYL7cCOye1RRo1AjiuFMgabJGupMGaaSVGhaVBmYkxUDs/K8MHbpn4Do1O4QWMAgm0Olw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZJ8CCbsl/gjhK+QFImDzWN5UiqPInCf2cah5MNbM7E=;
 b=NpH6z57z3ZgOW0KdU9dEBpgJMxgIHQSvx5+/wye6IF8YaW/l5YCWu3doUmc+f4GooHwWblM+Z0AS5a9j+YevNHN9lkoP4ZdbJ5nlM91SkeJvI7jc68v6yk28TkWziaxR40tlGr2JNjxK/AEcZx2En+MZNmYrr52XjKA9FEDAYUEOScINA0h+QOSl0KcGcDoo9dWvEFnsXFDEGLglsRQ9d/h97P/6LqdesA00GaJ5dLIzp6CJQiShyAsYDiq6ADNII1DcDZ9GDdDHG1/hNqukKojm5nqlYba6D4VFgu3V1gc1hPsXyrSEUTCYtndt4rlOsQusDGM5MQ7yHArgnjVFrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:58:18 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:58:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 09/14] bridge: mcast: Add support for (*, G) with a source list and filter mode
Date:   Sat, 10 Dec 2022 16:56:28 +0200
Message-Id: <20221210145633.1328511-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0199.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 45456392-095d-4f29-5af6-08dadabef8df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdnKtezTGHbILGYYU7pe2VZF1/cb9MfM6y2ftffYpmXzRJ2IkWY7V5s/FmfStP58lHP6zJdjpHdCGOfjzDsiR3gSYlXTiIozr11uqGeC5YyHyV1FlErdg4ReT++FXFakK2H/to4LG7d9Bauz7vLYOD3ulr2TOBWxRcPpIHCCzB9YanRGWLwKRB3FVu7eKBUdJst75LVXa+NGlEQ34VeBPIKYDDJNARqSFlnVUcgkxYOtvt8WAHVIXsu8rirWkVD2yahlothM+mjD437zykS4OqZ85wP7HJEZK5IlsNQ4r9B7xaYBFSlDOoxKyEWzUyv+ilTkxtaBlUYMHQwMSRI37Y71pdK6+SCAScS7L6wyNkISjmxQb7TwEY5xhV4q/689wnKGyRJPURHsGoA85e6eG9nJR6Pp/rsiEcTwwnTuQqUbqr7gUouBQ68dzGf6yYZXcRWgDHzNfI+ckhpRnDvMiJViIqucT+X+bQZtcBXrkHxeo3tQXf/yzmYLGdtAhtA38s2FddKEutVNcSZqZm9mH9YivvonAZX9H52ZujQ0I9GTldD8mJd4zPWRGO5x1KSeDG63cGoNk7025hFiu7OXYd9gCe9FK5Uvvfun100P1FTOUqOGfsmwdIcm5iAXCOsQTyGCY7I3oF2GHRsbHlO9yA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?luu61DTeQ2frBLym5WwtIGb+pGnE2Wjvndsifslzgc3UyJQ55RiL+6wZZzFG?=
 =?us-ascii?Q?ovpFguTim22YGtElAIUyWCQJNxTN+9Dm/I3tj8k1GGr5BChJOQD02be/2Bn9?=
 =?us-ascii?Q?m1/Tbv5mkFUsXoPCWG+bOzKoZnuVGRC8fWREKA1Ji0nVhsK7A1DHagNqd0PX?=
 =?us-ascii?Q?1TxH1ltY4mRnT4tbyb/f8r+Zv6a/peOI/UslXMxPnoHN4gL8TzdwjW1a5JUX?=
 =?us-ascii?Q?2CEgFfRsSnV1VCrpmrhiiGBJITaC+wEVSxu1cVgmXAO37tyM7IwvCkuCViNo?=
 =?us-ascii?Q?bTOWfH8J0Ao/hS1kIX/8uNG3xMICplNBsZkOyA6w6Mom2t0DgQhzbuyTvHxh?=
 =?us-ascii?Q?RUK2MrWGYMcf1Q0wI030NS6unl4JPc8aH24OzZsXJ1bxt7KCqrPGSMwD43W5?=
 =?us-ascii?Q?osFdKW7oKfVpNUmqjgsBaKnL+PUuvZw4r82ubJs39b2u/nH8cNa0LjuopKEa?=
 =?us-ascii?Q?BUC2Qzrb35kL4D19xvoVQ6Rw3pDKSZecaVEx7Lc9nPzUZqmwOaI3OHciyj8D?=
 =?us-ascii?Q?/m9q0Eney2m+vOHyVyU8Zgd0/3t1krfXfQlMhvddZUFLwT1qMpYpALphkaT7?=
 =?us-ascii?Q?2UxVWbaTS2SRN6Sy/ZppE6Si1sUIPaIqB0Ol7Trir8TdGOf4ED+NzqTHJALX?=
 =?us-ascii?Q?NJuVMep/1Epkg47RQvILJ7czhD8GaTBLAPAwKL8z/VN9P23zO4TVEUXlSFZc?=
 =?us-ascii?Q?IMavRhJ8oJmu6lMomT06tMbc3NVdkZO6QElvwd0lsbQ835RSbi7yvi9Q6Db7?=
 =?us-ascii?Q?uhiq+aTqrcUWTpcWm72YajeYppyiFBq3DMFUydiyIcx0MPU3YgUkmIbprrER?=
 =?us-ascii?Q?s+Kb0mn4HTkJ704A8iVKxGpv0ZZc2KrYMZaQHvqYDZVBMn7baYB3zYz62Nd+?=
 =?us-ascii?Q?CzSp7T5S4/sZ/9/LhSTIzJwAsZBserc58h35aX/7kGPeyxHo4ARFbt8I9+SY?=
 =?us-ascii?Q?8VYZMpa0vNgcCHkVR90qyXIVv4hx8Hyd9gy51w/rywtTVPaWJV6zgzgIZBvM?=
 =?us-ascii?Q?5a3zESUus4LzvLmS/OJ0eA+FtQwVQbom5fP14aB6zPmgN3nH8Ov+A9pDDjIN?=
 =?us-ascii?Q?5fLEFnIEvv+tG11d0L0cQJ9RYzMLcnDCnDD9suuacCtMZLEtIHIssQRpVAZE?=
 =?us-ascii?Q?5KwTOJS/ShbvaCl9wVmybTaR9iYGkmRLfqlTTwQCXs2utYIXNpPjpDauediY?=
 =?us-ascii?Q?8K3b4DzxW4gwMRYnEssGCgm7aBsJWdKTzZS6Nk9NazdEce414h4YM0YbeNtq?=
 =?us-ascii?Q?4UGsPZI/dvN/SYDSVT4rq5lFykEmHyJxm2ke8rl1crgX9C6pbSfsC+t1Ywts?=
 =?us-ascii?Q?+Ld8qSf7VvpoBSBqZGVRVl3zvembD7KR8LG3je2Ie5KtPSs2I9t9L9lREd19?=
 =?us-ascii?Q?EIGtcGrMx4l/JEunx1YeAIVKrP5oLOPk11HdAfFF3MLPWJSfS0lnhdECnpGb?=
 =?us-ascii?Q?y5H/fShMZHECGIizZsVr8WfJjQcd2KUukQvtpubLRWOVKEPpQbEohWCQmKKv?=
 =?us-ascii?Q?sVJpmXkP+ZMwKnavIuI+iezw5qTLbZTbIGaJh+eRQQO7U+eHYCKS49NEzhn/?=
 =?us-ascii?Q?Pp3ZopDxzV7FXRWYvy75c+pXIwtRd0vZrm3k5Tei?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45456392-095d-4f29-5af6-08dadabef8df
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:58:18.2405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1i98StnHwLy41bWgvNWIHg9nykVt9ey79GnpSdJJJiIbU6az4AlqIH10PEMotD51pG0xV7vF5ZvpdW3yITgMw==
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

In preparation for allowing user space to add (*, G) entries with a
source list and associated filter mode, add the necessary plumbing to
handle such requests.

Extend the MDB configuration structure with a currently empty source
array and filter mode that is currently hard coded to EXCLUDE.

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
created by user space.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---

Notes:
    v1:
    * Use an array instead of a list to store source entries.

 net/bridge/br_mdb.c     | 128 +++++++++++++++++++++++++++++++++++++++-
 net/bridge/br_private.h |   7 +++
 2 files changed, 132 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 7cda9d1c5c93..e9a4b7e247e7 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -836,6 +836,114 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 	return 0;
 }
 
+static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
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
+	sg_cfg.br = cfg->br;
+	sg_cfg.p = cfg->p;
+	sg_cfg.entry = cfg->entry;
+	sg_cfg.group = sg_ip;
+	sg_cfg.src_entry = true;
+	sg_cfg.filter_mode = MCAST_INCLUDE;
+	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
+}
+
+static int br_mdb_add_group_src(const struct br_mdb_config *cfg,
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
+	__br_multicast_del_group_src(ent);
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
+static int br_mdb_add_group_srcs(const struct br_mdb_config *cfg,
+				 struct net_bridge_port_group *pg,
+				 struct net_bridge_mcast *brmctx,
+				 struct netlink_ext_ack *extack)
+{
+	int i, err;
+
+	for (i = 0; i < cfg->num_src_entries; i++) {
+		err = br_mdb_add_group_src(cfg, pg, brmctx,
+					   &cfg->src_entries[i], extack);
+		if (err)
+			goto err_del_group_srcs;
+	}
+
+	return 0;
+
+err_del_group_srcs:
+	for (i--; i >= 0; i--)
+		br_mdb_del_group_src(pg, &cfg->src_entries[i]);
+	return err;
+}
+
 static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 				   struct net_bridge_mdb_entry *mp,
 				   struct net_bridge_mcast *brmctx,
@@ -845,6 +953,7 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p;
 	unsigned long now = jiffies;
+	int err;
 
 	for (pp = &mp->ports;
 	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
@@ -858,23 +967,35 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
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
 
 static int br_mdb_add_group(const struct br_mdb_config *cfg,
@@ -967,6 +1088,7 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 		return err;
 
 	memset(cfg, 0, sizeof(*cfg));
+	cfg->filter_mode = MCAST_EXCLUDE;
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e98bfe3c02e1..368f5f6fa42b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -93,12 +93,19 @@ struct bridge_mcast_stats {
 	struct u64_stats_sync syncp;
 };
 
+struct br_mdb_src_entry {
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
+	struct br_mdb_src_entry		*src_entries;
+	int				num_src_entries;
 };
 #endif
 
-- 
2.37.3

