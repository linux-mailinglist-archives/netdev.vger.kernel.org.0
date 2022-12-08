Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D202C647302
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiLHPah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiLHPaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:30:07 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2071.outbound.protection.outlook.com [40.107.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4A17DA73
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:29:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdSjIqKFuRKyoiEjSmPVzdulwrtsijOhM+hbwuWUgKL9zJttYD6s2zb+/SuLl22JyOs5JN2+UTBV25WykeDAEgqtgvJmSJTjFo9LIQui9Qyqppx9ZN7eGqDLrz33OxHvq8ZiMuX4acBQITh4/5PCzUa8kgw0O5GRR66m67JKfMpFsv79FNbEO872uvV09K/eIXkLg3dgo5GSY2tDektSzTpJixByr2kvP2OAblA8MsMAjb69fDGUgmstnvzMwW+mfhryyoIitRDrMZL8IKKwtnz0hmHS6qjWOq9lOh8OlIxczIP6MLaQrzbE6fvAx42fnT9iuI8mXEEK72Ce4o+4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jMfAlXe8vULAdku8vXtTSWvRV7w9CPQoCwRB5XuwB0=;
 b=iK4QKGNTwRZdttCdW+t3RuTmi3oyo5wYTauUKu/mnnlTGpsomCtv7ZEkeNU8o4QYQTBrkmaXhrReybyli3atDY3bUDOV2BooyiUsomIFpLav88A9/QDS4uXKi8IaWzIlvG/4gcjeUWSsCz+TIU0u6ImaBLP1WGwa+PYxc/bIbYL/oEGRphkd6KVKG0lgSmWiSt+EU4wTbgFkOjrSOLCOpHA7rmQNWT+zO1+jqr1K9Yl5Pmu4w6LtU3F4ycyAEzBodUnW7kUpe7QY+zLFuNH2IjAgxLaMuDEOjmXz8uva7xVyOlZ/gUCuiuZGjYiyk5b8gC2YrIP4W+7CEgIi3fbofQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jMfAlXe8vULAdku8vXtTSWvRV7w9CPQoCwRB5XuwB0=;
 b=Zl9sC6Bamh30DOnLWj+gTmk4M/zRjwOJ/oJrXmtSh/ggljAzN40X7tXuCki7jKVolw1KqVLDQso9vOFXyR4Y/5sMUt9oL5CD4FZ7wL5o8WDwMofHhZtZYRLLdMo/XzJVjWHNBKOEU/PmjKjvcFb7bthk2MBS7jAkly/hvsT1bI5Lg6ho3xxGaT1GhZ7ZktlqYko3jkMPRViqF00tuF6eHocj3xWYXkclBp0w63vDIOXPgvjc9mDkR7+7pXTWNHxbbIBJA/0kURG+bnCVDis3+ueOaSnDZJOioevY7Nk76mc5C9DHBT6omJa/ZLeqWrk17pUJHXoJSlKFqrfkSqIv4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA0PR12MB8207.namprd12.prod.outlook.com (2603:10b6:208:401::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Thu, 8 Dec
 2022 15:29:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:29:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/14] bridge: mcast: Add support for (*, G) with a source list and filter mode
Date:   Thu,  8 Dec 2022 17:28:34 +0200
Message-Id: <20221208152839.1016350-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::23) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA0PR12MB8207:EE_
X-MS-Office365-Filtering-Correlation-Id: 79ae8b78-ec95-4d47-c4c6-08dad9311074
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HngDaoiY/c/c9JjiuTstcj0A204s23YV7d+xsRfn/CUlf4kYHAqAZvpGDSy/LT+xO8QyIH2MdZd2XU6j/cpEgVXu14dt23ELD9KR54m5PUVmrGV2/n5lH79P6Zry2avSXjIUd+srxh/442BHvtIT7ADHsnZal7QXQtatwkx7G92JR/SPC0hwptnTU8sbSjQJUOUc4iHRtd/yBkPAlHKANaHWMjvmmyGjdc91UBHiv6897spKWK+rvABUJVK6kwqkkdopKpBiSYfOx8b6HjFNVXF470f2+PRXJ31amkTHW8OtjZhdC/ujNh22xc3XGkcmrmHEtcr8TH0dVjgzyCPrBFbrnkLPz4isPqiohduLeqSTSin2fnle/PAbuZ2pb8mxZRXgoM0hz6JwMyQroLMwhaZ/PX8hcPD90gRrkHypVF/yxiamveCqXcR1obs8apSzDHAbb1slZHur0hylFj50GPKGTM9TkWNnvDNXbvLK4h/npEZzNZluH6IYYy1yMIS9sK4jFc0RLRcNzAxwp+4BiUtrRLmSswYvq70OmVRv38eFoxXvNnDQvRY0ZQ/7MwwPKsVe9JA0mKacTv2Ryd72v4oKp474QGaBYFzYA2m8rq2RBrgnK99reHzy2Yc/y9JDk+iZtLO0jtQ4KiBh4VdERA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(39860400002)(376002)(346002)(451199015)(2906002)(83380400001)(41300700001)(36756003)(1076003)(186003)(86362001)(5660300002)(38100700002)(8936002)(6666004)(316002)(6486002)(6512007)(478600001)(26005)(66476007)(2616005)(6506007)(107886003)(4326008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ch/QW9w/mLRZwGBHNS1Ipxfyuc7OuiCXDJGwuAqup8+gc6+B2OUmecjeLvsP?=
 =?us-ascii?Q?cgSu45412KNrkX2d2QAgs52IdbEP8HrUODMFkvlt21rAZKME7QOgUVGPchBp?=
 =?us-ascii?Q?jtNFt6JHe64dXLNqxzAifLzMqnG1atOyixPrABqhteWdcTZShYExxMqL5Lhh?=
 =?us-ascii?Q?KxuXg/z1hgZ6PSckSC7ZEcnrJD1YMhmpfNNRHcL5/uqRWCnlqi4OvjqER20w?=
 =?us-ascii?Q?N79U2Sw7L5uFHXuAfNtn9gNidod4G+gmvDdqPZRe+7iuuukvDxZQJR6j4HPU?=
 =?us-ascii?Q?Vpxo3qsIzYlYswL/tqvhEY1tNTtdvMrx9NuTbF2BYH+CTVAJ/pK/FRCnkPhE?=
 =?us-ascii?Q?xkPGDGCqN4NXlQyPZurZjzaei0cnxPsNChzPpkK5tgErJ7oDEBtmtCdJh0q8?=
 =?us-ascii?Q?TGA13b/1/nWi/8Y3GSuFwQlPpoaeRx/x/OBP1UiYvkBThalZKbdzFQ9glAEm?=
 =?us-ascii?Q?suaSUvk51cTSokwZO456VnfAPU4IbvddM147Z5SquIlEAJDxuCWmFFqfCDbv?=
 =?us-ascii?Q?MbspFN/PiaeWSk/4+4J8DxUHjfgifYiEH/v3DarbARVFr1HRIlKOC823tuCH?=
 =?us-ascii?Q?0oxDiDvWIqD/Z5MGXlIuYkJYjmWD3lKQufbpPWPt8EaTJgyDwi3VPQv3i1dD?=
 =?us-ascii?Q?SPRjsz5BggXa2sSR5dQ0w18KEIY+p/h432fS9wjijwwldspgIco71Ln4ugmC?=
 =?us-ascii?Q?UznkqF9xAxHkH83HDQbdrwf0SnPALC9XX+xJcCYvD4wUS9yKWPZq0ojYkTsc?=
 =?us-ascii?Q?+AapcGwCnnZNAxDuU1YbjRxbSistMrRTFt6z3U2XQm8lHVFz33INB4fVSR8X?=
 =?us-ascii?Q?OBjKb4pu6zpz8XxMQU/1Q+Rk26Fdlnhuj2MYqMsHBZOab5VzkaJbI2heFf5S?=
 =?us-ascii?Q?hgklexTIfutgLMli6aS9CoweVyj+8YjbP1cO5b1VsltErKmjQ7Lovxi1pG4o?=
 =?us-ascii?Q?mvnJ46A0qUWN2U9DM0wRiPOQjMHQnUn+vbeFJ5DjtbbC2CbdlRvkA/aX1NtX?=
 =?us-ascii?Q?2Rbhbt8T6A+ElGgoxNjaaQ83pHKL92iYv3X+z3WUwunHGCzq4oteYUMYbXB1?=
 =?us-ascii?Q?ViJZrRc7V5mLDUb/LhYKXI9A0CAT9YFBEAUkb7amyl15bcvuKru3QvI1oaYG?=
 =?us-ascii?Q?mCo0sNTrLXfpo17/2V8cyGh6Kj1OVDP/ySy+aF45vkr7owKD5duyhDf70kZD?=
 =?us-ascii?Q?0SSKZ8CpVU78nxcP8Pfu7P+UzlRS8jjBYvZfskzpD6/VuFhxqvG8KsO623OY?=
 =?us-ascii?Q?qp41fk3sKCzL2eybm8/LomF7nc8wIdKATujXV1+fhv1j8zldaDrYd/oLRNAK?=
 =?us-ascii?Q?rFIiq1bPcOxCRqhATKel9ObORfg1148UUvQJcr7AAXRR0NvpH06Qi0uFIAK6?=
 =?us-ascii?Q?ekqOmqwGNrxcqV6tMLJLSz+lyZ1bnUzSh6INXwArImL7vnWn+cN9J/kTaJBa?=
 =?us-ascii?Q?86+4eCmKBCPnpkJ2E8zpQBZl/U/M5BFDbQZNBjMJoLsqfM0N5sqaiUzkwg7A?=
 =?us-ascii?Q?VzyB59EJ39pDtuK6EXc0W1L7yi9yt5ZTq3rFXjU9zbWVHGYZq/gF3VCtcKqp?=
 =?us-ascii?Q?LIXanzWygWye4JZKH81DTt2gR10pHumIa8aTTygt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79ae8b78-ec95-4d47-c4c6-08dad9311074
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:29:58.1884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zt8o5Xx9mprAs0cjcVBJjRbN2TuhR4+iHvmWWSOn7G6Xm6GDGy5Aj7mZbzopiBKY15TQgqiI5NgQXQpd5sHZnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8207
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

