Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4AE6472EB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLHP3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiLHP3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:29:14 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50E575BEB
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:29:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=of5s1aXiJqZyChqdSDKcNsEYb0slCa4gjmxGNCXqgfYknp69W+vfwFRB+MigXRW+JbqHO2nl21zFrwwFgrjK8uuxbzdJOx4+HKkrhPHP7heweIv6/gZuiYaONjKOK9pGDMlVo3I+7T9z/EzWRCGlU8MwIg6Vl6tS34x2ImQlIkPPzZEzinM0JUhWtbWYzKVEw8rLEh+5VZAXPXX9I6bZJOH7m/kcahouPRgkzaDov9BnRdDQak+9a1JRDgd1urXz5GLN+j8Yf2SUXUkvyPyRn7ld4J/xJB9lcZHzP09PDhigomYt+1aLG9qmnatMeXWxglpSPD1l1QdH1g4QLfin5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vt01ult55jiY/aW4CW7jYZYpC9g6yzzc0A72kco8tHw=;
 b=HIm6/l678MsTIjb/zVhp9HQI1AI2bA6VwPGn0w157H1a0OLkusR4jhBCTvwMuE3h9h/p9XbS75LZ9fU3C7BA99cmmbN1xkXS1bdfz4H/8qsuMdl9N1ktZa7jcXChWY9/qbypQlz2Wkkpv+FvxyLe1xJUYr8CNiccMJ7UdN+S0Js5avxiGSKzhjBMCMM9ov53AJqMF9l0h3j/Ty/mL+fOcz/FtjFZa5dgRYBhKmnUhMuN3Lr+zQUkanadREdLymddfgVp7RPYmSjpZlyFg1IpjI9bmRmIOu5Okt4vT3ZGSWILte98bFaphjRWX7OKgWxaWsFcB7PtQE4dHC7R67Tocg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vt01ult55jiY/aW4CW7jYZYpC9g6yzzc0A72kco8tHw=;
 b=MVqxfc0DHT8doK23yCDKjGl4LVmJM3tm2qp/9xJTaoWWs4x9drPVJB0aJANrvkZHqifkLyvjq2LWHK23IuRRdDnAG50bMeBMNknN/3NaUUDEByQhBebMPjS0UbOUOBNH13iwicKtOZoIJzRS/FuGsCUlSc1+4Cf5Y6ERm5sU/azy2Tkf6k6R11aYJCklsu0gZk9uPGKuFzI0en8XsLdXeYTa9ok6EX5iS1eM/YeNJ0sO8D7rM6+1bDdv78fJ0oGZ0BliQwhgErLJI5RzrQtd5Fu5pblJ4959gdim5s+VpSjVwiXrmHUfakB+Vx9kHAEK5zIzQimPT/V6N+Lz/helMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6787.namprd12.prod.outlook.com (2603:10b6:510:1ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 15:29:11 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:29:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/14] bridge: mcast: Split (*, G) and (S, G) addition into different functions
Date:   Thu,  8 Dec 2022 17:28:27 +0200
Message-Id: <20221208152839.1016350-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0136.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6787:EE_
X-MS-Office365-Filtering-Correlation-Id: 61187ac7-664e-4c62-a8c5-08dad930f46e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZTygKpAyUWkYUPeUc6FGO61T1WO0seS+a81EHQcIkDFwuuKG2zWQh2wExRQ2kuAA6NBl2UJmxAd6I4FIBeTmlNcNeTDPEfa8rYTQQIJgavsPWAwE4fvCfueAliLHnVe7a9dbMwFf7xzNNQuuxaVe8nmT08mw1td6Gz2hBqRcyDiPECyqJHPW2DheDErJRIIhUJBDKzfQniSpPhAfJH9zULmykYmuxyOb0Qj99EngTLhR9JHTOIzEs0KA8k6qG/Hs6zWkEv71YArVjuCkB0DPirQL/saJ827QKi/lblqi/HQs3mSOkxVQaSvXd3zTo008CDLvv0GFKve2A+gnr5NTl+rOIX+kwb7lpaYARDms5uDGaSb/5+rgg9fQAhYvMT/3ul2nwMymwWPaH0/6WcWZQM+/CyJ/i8XRXaYB8lPF8Zs5jGcbNHN37Ks1BDfSd4MoNk2Hpq+qpw/hL2QRJ+mu8wE/t6ll4TxV32sLsmslB+TwAuk1+q9/AJWO7Jok5+dItjK7nE8oHxLpQKuCxfpFcoNBt2NhKLZEbVuO2rGo7HqqTTO35Y2618SdKD1J+xNR2yvsDmmfaoEJNo57bscIPDadfeDcQzpT7yhWGlgF7ULPs7zcKfX2WjHbyl7v1EX/0GHkgFXukEKlysvepF3aw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(451199015)(38100700002)(36756003)(86362001)(186003)(2616005)(1076003)(6506007)(107886003)(26005)(6512007)(6486002)(478600001)(6666004)(2906002)(66476007)(5660300002)(8936002)(66556008)(66946007)(4326008)(8676002)(316002)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ppqMZ5J3bW/LM1/3uMDS8s8FYKCHvQwY1wzJyItL1aeuj3sRXpTp5SOFKLB5?=
 =?us-ascii?Q?6fskT5Csf4NOM5xL1fjAvbRFBqcILMM5KSnKAObRqUQ1wusDJ1LZaGa0ZJWz?=
 =?us-ascii?Q?e6fKk+7KRyWOjCQ/k0H6In5E8dsdlJRnKTMr0z54FeiOm4zhXjCXHORQglCY?=
 =?us-ascii?Q?KNH4F/acsEvBaM1h+SnHCnKX8OK95OZsUYIEIl0ZYbeA9dcPUNq9Vyo5/zi8?=
 =?us-ascii?Q?Gwty/vnWBx5kwAQ4kzavg/zvbmzBp0j6Sf88/Dwc7pDPyzukqrsvCxkn+nKk?=
 =?us-ascii?Q?ibMLYgc4nPjxk7Dd2vu15/RDe6Sdm8CDPD6N5GzM6nNN2IKXOnN45omom4Ql?=
 =?us-ascii?Q?S57wTE4LfNxKmOM/CKZckPGAkcJphlyymb1OKwSsLLJjkWq62d4r4boMQW3u?=
 =?us-ascii?Q?5Mfn15Ax2J0QptodBB55OI81f9aW4Pp0KdB+wapLmJqiaA0fE/5wd8bKewDM?=
 =?us-ascii?Q?VYEF+N+czHxSwLjfPrnJjNKF4j4RB6ZjM4ypYJiDzecHCfSDrW+jjc9xmO+P?=
 =?us-ascii?Q?AAycW72QOoE7siXhRwyNOGAdkoGijDoW6a65TAQX8iT8XhJPDTVP+40QYHKI?=
 =?us-ascii?Q?ycDit9gCbnUCiTI3uPvcDUZeFUClBmU0Eq+7u36DM0oqkI/LSWH/7KWoAPn9?=
 =?us-ascii?Q?LgAL07xTapAVYZuEiZeR9iUngCnqGi4czHtJDzWPGov9P6xymGAKogDsDyva?=
 =?us-ascii?Q?GIs6lJhIFYCBohNkruZbd39RFNGMWSkEioy7U7vsaMbEU/anaIOeJw0GGwfC?=
 =?us-ascii?Q?uudn6YXM/cTpZ3XShCCkpspaAVj5zQ43fg4OjWC7LwpQsetwB6YilPg+dgH6?=
 =?us-ascii?Q?ExC+QHgqY56nS7H3Cnv4rR7Zf1f9JTHdqvmdRRSnn08hWmqgXTZquMpWTwwZ?=
 =?us-ascii?Q?+2NC0fDB0HaK1qA9GoZtB4+EpWws2GT+4ccZg4HPMr8AFo8nLLHA+9qbVfzf?=
 =?us-ascii?Q?Dg92nndYWuaIdqiLyiTcCVxSGufr+13G7c89mZA5+fbxA2HqcEOdDOab29ns?=
 =?us-ascii?Q?7PBdvGXvZCYB7D87Ven4KbR/7kYu3ZsrXgzsDrtjXTIHMo1w40PIz5jQijdc?=
 =?us-ascii?Q?e556s1DU0+wOdvVQdl8IkrMb1bEUa395AeREc5HZswKNwPyN8LhzRCuXXG3r?=
 =?us-ascii?Q?64qs1brpSGAK1G+01s49GtSF4/zxbMWX8fxo3JxnEbs/lM+e+CEhJUikKhOf?=
 =?us-ascii?Q?U2P9nApWiqdib5yz6s6HDic85J/hPjQ197HS41CF0F2zfhvlLLEflsMcl+FT?=
 =?us-ascii?Q?tAmnvlgQcdWOkGt1k7XvNf8rpn8qN34r9fjsQeP8vLbJ3pTw+PtpPUq5Oz9h?=
 =?us-ascii?Q?lManojBid/IBsFiQCQ8VaMyRbH5TPN06IkRcLwFUAVRc3KFeMQrbdedSIgsp?=
 =?us-ascii?Q?q79OAqPMDpQJ6DLdc8HrKxCh5XRiVTaojUswVaEQswUxbIrRV7nwP5OhSsON?=
 =?us-ascii?Q?0d2JuNmT6ZhuDrTE2y0HwiB4swfKCYWfg3PsP+SMpHPsULabiFeXI16MJ0qT?=
 =?us-ascii?Q?+I/sGb+j+NkQiVdfBsEYgPLhS4kn5JelIjYLtfITBHifFlLGJa4OUdAiinXA?=
 =?us-ascii?Q?9KdKNZ18OsLvj03PgroHNYaxYKhLEnAOjxFNgxBp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61187ac7-664e-4c62-a8c5-08dad930f46e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:29:11.1084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /hGGIehjcAXn4Fr2znU6PCOuJTsLvyTjBFuFXLApjSnIgPGaEZLrjyowfqcs9GuRe4wC33SG/gbGpoEvFsChfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6787
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the bridge is using IGMP version 3 or MLD version 2, it handles the
addition of (*, G) and (S, G) entries differently.

When a new (S, G) port group entry is added, all the (*, G) EXCLUDE
ports need to be added to the port group of the new entry. Similarly,
when a new (*, G) EXCLUDE port group entry is added, the port needs to
be added to the port group of all the matching (S, G) entries.

Subsequent patches will create more differences between both entry
types. Namely, filter mode and source list can only be specified for (*,
G) entries.

Given the current and future differences between both entry types,
handle the addition of each entry type in a different function, thereby
avoiding the creation of one complex function.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 145 +++++++++++++++++++++++++++++---------------
 1 file changed, 96 insertions(+), 49 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 2b6921dbdc02..e3bd2122d559 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -786,21 +786,107 @@ __br_mdb_choose_context(struct net_bridge *br,
 	return brmctx;
 }
 
+static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
+			       struct net_bridge_mdb_entry *mp,
+			       struct net_bridge_mcast *brmctx,
+			       unsigned char flags,
+			       struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_port_group *p;
+	unsigned long now = jiffies;
+
+	for (pp = &mp->ports;
+	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
+	     pp = &p->next) {
+		if (p->key.port == cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "(S, G) group is already joined by port");
+			return -EEXIST;
+		}
+		if ((unsigned long)p->key.port < (unsigned long)cfg->p)
+			break;
+	}
+
+	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
+					MCAST_INCLUDE, RTPROT_STATIC);
+	if (unlikely(!p)) {
+		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
+		return -ENOMEM;
+	}
+	rcu_assign_pointer(*pp, p);
+	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+		mod_timer(&p->timer,
+			  now + brmctx->multicast_membership_interval);
+	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
+
+	/* All of (*, G) EXCLUDE ports need to be added to the new (S, G) for
+	 * proper replication.
+	 */
+	if (br_multicast_should_handle_mode(brmctx, cfg->group.proto)) {
+		struct net_bridge_mdb_entry *star_mp;
+		struct br_ip star_group;
+
+		star_group = p->key.addr;
+		memset(&star_group.src, 0, sizeof(star_group.src));
+		star_mp = br_mdb_ip_get(cfg->br, &star_group);
+		if (star_mp)
+			br_multicast_sg_add_exclude_ports(star_mp, p);
+	}
+
+	return 0;
+}
+
+static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
+				   struct net_bridge_mdb_entry *mp,
+				   struct net_bridge_mcast *brmctx,
+				   unsigned char flags,
+				   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_port_group *p;
+	unsigned long now = jiffies;
+
+	for (pp = &mp->ports;
+	     (p = mlock_dereference(*pp, cfg->br)) != NULL;
+	     pp = &p->next) {
+		if (p->key.port == cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "(*, G) group is already joined by port");
+			return -EEXIST;
+		}
+		if ((unsigned long)p->key.port < (unsigned long)cfg->p)
+			break;
+	}
+
+	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
+					MCAST_EXCLUDE, RTPROT_STATIC);
+	if (unlikely(!p)) {
+		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
+		return -ENOMEM;
+	}
+	rcu_assign_pointer(*pp, p);
+	if (!(flags & MDB_PG_FLAGS_PERMANENT))
+		mod_timer(&p->timer,
+			  now + brmctx->multicast_membership_interval);
+	br_mdb_notify(cfg->br->dev, mp, p, RTM_NEWMDB);
+	/* If we are adding a new EXCLUDE port group (*, G), it needs to be
+	 * also added to all (S, G) entries for proper replication.
+	 */
+	if (br_multicast_should_handle_mode(brmctx, cfg->group.proto))
+		br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
+
+	return 0;
+}
+
 static int br_mdb_add_group(const struct br_mdb_config *cfg,
 			    struct netlink_ext_ack *extack)
 {
-	struct net_bridge_mdb_entry *mp, *star_mp;
-	struct net_bridge_port_group __rcu **pp;
 	struct br_mdb_entry *entry = cfg->entry;
 	struct net_bridge_port *port = cfg->p;
+	struct net_bridge_mdb_entry *mp;
 	struct net_bridge *br = cfg->br;
-	struct net_bridge_port_group *p;
 	struct net_bridge_mcast *brmctx;
 	struct br_ip group = cfg->group;
-	unsigned long now = jiffies;
 	unsigned char flags = 0;
-	struct br_ip star_group;
-	u8 filter_mode;
 
 	brmctx = __br_mdb_choose_context(br, entry, extack);
 	if (!brmctx)
@@ -823,52 +909,13 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
 		return 0;
 	}
 
-	for (pp = &mp->ports;
-	     (p = mlock_dereference(*pp, br)) != NULL;
-	     pp = &p->next) {
-		if (p->key.port == port) {
-			NL_SET_ERR_MSG_MOD(extack, "Group is already joined by port");
-			return -EEXIST;
-		}
-		if ((unsigned long)p->key.port < (unsigned long)port)
-			break;
-	}
-
-	filter_mode = br_multicast_is_star_g(&group) ? MCAST_EXCLUDE :
-						       MCAST_INCLUDE;
-
 	if (entry->state == MDB_PERMANENT)
 		flags |= MDB_PG_FLAGS_PERMANENT;
 
-	p = br_multicast_new_port_group(port, &group, *pp, flags, NULL,
-					filter_mode, RTPROT_STATIC);
-	if (unlikely(!p)) {
-		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new port group");
-		return -ENOMEM;
-	}
-	rcu_assign_pointer(*pp, p);
-	if (entry->state == MDB_TEMPORARY)
-		mod_timer(&p->timer,
-			  now + brmctx->multicast_membership_interval);
-	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
-	/* if we are adding a new EXCLUDE port group (*,G) it needs to be also
-	 * added to all S,G entries for proper replication, if we are adding
-	 * a new INCLUDE port (S,G) then all of *,G EXCLUDE ports need to be
-	 * added to it for proper replication
-	 */
-	if (br_multicast_should_handle_mode(brmctx, group.proto)) {
-		if (br_multicast_is_star_g(&group)) {
-			br_multicast_star_g_handle_mode(p, filter_mode);
-		} else {
-			star_group = p->key.addr;
-			memset(&star_group.src, 0, sizeof(star_group.src));
-			star_mp = br_mdb_ip_get(br, &star_group);
-			if (star_mp)
-				br_multicast_sg_add_exclude_ports(star_mp, p);
-		}
-	}
-
-	return 0;
+	if (br_multicast_is_star_g(&group))
+		return br_mdb_add_group_star_g(cfg, mp, brmctx, flags, extack);
+	else
+		return br_mdb_add_group_sg(cfg, mp, brmctx, flags, extack);
 }
 
 static int __br_mdb_add(const struct br_mdb_config *cfg,
-- 
2.37.3

