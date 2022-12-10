Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D71648F5C
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLJO7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLJO6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:58:41 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162B01A831
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:58:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEGv8iWHje+a7c1SbwtfFhUy9ML7cGayYDdk1u8h1M24s24Bs060Y5Z1KSr+obzUMQxXxNl65Ltulroq3ZZmtdGBGLzUdZRiBXxbu/ejZmkwlJbk6ov7h++DoAkrKA1leTRxU/9mBgV2G0xLh3492syVxvUfKyi6yYOWvfWep9+GT+1vGZG4crWRum56rvU5Cp6MFlRgqqENfbSISyP/6DaEua7GIijxyv9d8DVPRP3BC8YARuqALOHW0tTEyg+r/X4CINnHT+NU4h7zsA4WkMxmhSNTZX5P6HuHYsU+lGAryobIli9p1zXh94o633wZsWmdA3SJLAhsEbdIDHI8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9MKmMm0AJpZBp3RQtjob1AbqKhdrwCzF1aqPGmhskSc=;
 b=FjQp3c3b0oTN7KiaIWChl6B+hch962Bjtrgj3t91BV8f9G9FU9CSGPJis2McAwL9EirzOkTegj4gibtBbDdKYZhEb0+qhP4otHLW3uYN6rbMDuh4+8fzx5AAgCmXYy9XHOSHL1n4OKE+s7L4XoT7DPNuiukfXalj47fYJOqD65lZxYuH8RSU5X7rwXLPra5Qz5th6jX4byxol4ZaQFPdgBw54F/IZihXTMDQ2bIQmN97tg1DmiX56Bgl9JPnnyOkFG/FhJr/nKz627Q+yZaODYOPWaDQcU2Cl8Qo148yYpPgVFQhCTMLIgRL7CiWdIqA+znULKAV4ZAnECzLf7yLaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9MKmMm0AJpZBp3RQtjob1AbqKhdrwCzF1aqPGmhskSc=;
 b=T8g0Kc5UIKfBVFo6WL6lcRqJUKPPXjGG3IMUskXMBGdLW5LzixSVqZ37JTTZJaK1sTU9pQMIkpbTxsb8olPqM4c4V9USWvX4dYy8ombRdk7v4oDm9EilGAynUwJova78arMM8yAFYhVxZt02GJcPFhiUYyP1xM9dinC+6omTeiofDWdqdGL0Q5wRUbO/IMMKcBTSeG6rt/mdUEl03gOEWE9g+bixFo4H3o3oi9S+0GxHwaGpYOXF0paEc53ToOjNfuKTLs+2jDP+FbySOf2DNO0bffBpQexaEo2Uap/aFuqvfquLhvYayHmnXWrlm7DsMrwvdWaw7bjGsxzOxe7Sog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:58:38 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:58:38 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 12/14] bridge: mcast: Support replacement of MDB port group entries
Date:   Sat, 10 Dec 2022 16:56:31 +0200
Message-Id: <20221210145633.1328511-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0008.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 19ecb761-7ffb-43f9-f037-08dadabf04c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oiKNBy9mXd1p/JdxCUgqHsj0BmFoBKhAjqYje5UEfvRa2CLJOWi8skED8lvEF26a1ngkhA5LT2r22+bg44Rq13SHvF+a01COrNytdwz3hMFXxuyGw60soStiw4vIqOmCEhcf6pnAJ42N5Bl5aRklcDQDGKUHH38u1PItUwBhnbPQ6lT09P8NKj+PqS5KFQL5eHjvXYh7FhT3mtZ2qNnSfaywoRbXXdpHt0hqeXYbQBA31kfhnM249k2mDjekIumrorRQWTJIMuTYCksYEkmFNFKQOhwA0uJqdRiWv7bjgHsbqddrsF6a1WJWpZkgo/qRnhjXf7xR+ZaRe1cIlEv759sVc6fh/elW15xRWFeDcEu4w3dnhNFVqPdqMPR6jB5/8ERyaI98r5JXRcpOZ+WpvMhiPpPF09NcNvdRqHejzTRk2zuxGJKiNSX1MCo4qs34tw/yt5n6QnF49wOanKAI3sjWAFWKiP2mVurFe73wGhvDraLlG3q85buxVPc/Cn82FGL4OsAiysF2USsJpMI76rZDQzO03aWTTjaukUNzhNG7wm8rQECPddQNoXIaS02W1DZIgNi5Qm/AG0CY0iw0VB+1tVOgjXDDRO8K0fNqb1955lB+j52r8iqqtVjEp7Ep44+bcUjy8fPJDWvf6TDqmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(83380400001)(1076003)(2616005)(6486002)(26005)(6512007)(186003)(478600001)(6666004)(107886003)(6506007)(316002)(41300700001)(4326008)(8676002)(8936002)(5660300002)(2906002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S8FE103Mu7L+99VG5KL6V2cOq2/D+bPAb82ayrxZ0szgcMZN7+88GZhqn2RQ?=
 =?us-ascii?Q?hOc92ybdZ3Vh/QVPMFwWLTFUJByVN7crH++eFCLBHNeQ+hM8fvrcuyqOyUzs?=
 =?us-ascii?Q?xWSz1MN06V4Omzs4B6rtYIVCfca/0vsYbYMFgFIdX533FUly0nEOztmwLRhl?=
 =?us-ascii?Q?jnOqxN+7Pbs+l4daQGxGH0t8dCkSnhXvWEjzCuDAgYAZpj2lBnpAVN7Cqs95?=
 =?us-ascii?Q?Wf7s/q1109emVavh1s7VhSXFE+eZIRRg2d4XOk52CdMwKHzy4f+j0WxuAEg3?=
 =?us-ascii?Q?98VKi81toLuEMenD/FNS8vi9fL7cLk25j1K4OTsr1t3IljuPxIjCOWK6Gw7w?=
 =?us-ascii?Q?1X8TBq9Xp1VLSuhBgeu1EHzvbLfJHKtHGpAYXi9wQmrsHQDaDe0piZkq9YMu?=
 =?us-ascii?Q?PUs5BjNBa650X/Gn2foryXt3ddizfRaSe1VW4B83ekcLrOCJcQkf03zQeEi6?=
 =?us-ascii?Q?7Eqqp8G46g0av+fJ10jpKMrI7/Ufwa4SNr4ZbrZJIf9vLGRjVYCA2XbSqBDP?=
 =?us-ascii?Q?cb1hfeyJuiHOc0oX29CIp+bRux8nbNjiwXBiDchn2muncwFyKbLma6aiBkp2?=
 =?us-ascii?Q?ooSfiYg0AweCwSOZLE5Y21OZqM/PIKybEE2b937BQE3E51luJKGYPCHdHJDy?=
 =?us-ascii?Q?soI13Wosujbi8VGpJmmtfv7YoBL6OElFo5A+8Cl+gaCjYLUQhiKE0kvxI2Tr?=
 =?us-ascii?Q?sbLUfkEyKtSjmpxKhVcdrvXX0DGXEpjMCQLQW6ej22rnF8v6hIrMPj8Ykpw3?=
 =?us-ascii?Q?+MvNOtlZ2teu368arno0N53Yuejgde7Jkjuw5P1BQpGfG4sr72Zqh7cKmI7/?=
 =?us-ascii?Q?yM0Uq1pyvzXn+QoeCm04lZzkc8aZPktGocvEzVvho3TYWhjKFyonJZp8VPTl?=
 =?us-ascii?Q?D+/EcK4IrxznWBw1OK/ROghTxkffi6tK0aSwEqUoKipyZ0t00uLvLPiZCuTu?=
 =?us-ascii?Q?X+nydwCS8mjub5QIXXLxBCOd9iXX+btYtmSILwkmiA79XAZgH2fiNnQ77tnb?=
 =?us-ascii?Q?B90ou1buIEtKpI2jfN+jpyg8urAgRRYUIf3QnreDtx7e7l0b49peN4AJXK8j?=
 =?us-ascii?Q?JyXSqgZkRa1t3NLC7t0aXd+9FVxB8G/EsYcKn8xWuQkTOAy10uv8GB560ZuM?=
 =?us-ascii?Q?zmt5qjfO1QAwoI4JvSiKdekW1EXyEma4o2IW7Eq1I55RJS6HPBtVeSIFX2Xy?=
 =?us-ascii?Q?QCoYg/xG811SxfXlDbYyPwZu2WA7wwMuHq0EQBaRlI4P91eWSk1/fhKax0iI?=
 =?us-ascii?Q?1Eao4/Zwrw0V/dCmm1NvKhqGHA9SezqyODqoqhhqICzvq70KVYWwHC1/IsNk?=
 =?us-ascii?Q?GwfLw34Ned38+b/Z+sSiLIcHm0UQol94du8ERxQAGhfGGdf7i4LzFh5WrNKE?=
 =?us-ascii?Q?dBX9ixHrNqPnKF+D2noZOM69qFg/c/+hkk7960Flv7N7dINIu3oVgiQJRCdB?=
 =?us-ascii?Q?2oWecOJJzReM3cfrfm8MlyAWvsnfcVPPu5e3d20pCxRskdE/Z5E9USudJYAF?=
 =?us-ascii?Q?mVT7/eN9WxFxcwwOvG0vRd50la5zZh9gCDOSqaz8vnFL0vU6QAtPBFatywqN?=
 =?us-ascii?Q?w1Qes6BCfcb+fJWDajIOIuVqfTjwRmz5My3i0+No?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19ecb761-7ffb-43f9-f037-08dadabf04c6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:58:38.2288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWmmggqUVhIzOiAW/Ggy2ddoF47ai8Sv9JxGe8Yp1Lrevus89vr5P6+MUy1Cxy/VhcQsifebODiOJWXeAi3GVg==
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

Notes:
    v2:
    * Remove extack from br_mdb_replace_group_sg().
    * Change 'nlflags' to u16 and move it after 'filter_mode' to pack the
      structure.

 net/bridge/br_mdb.c     | 102 ++++++++++++++++++++++++++++++++++++++--
 net/bridge/br_private.h |   1 +
 2 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 72d4e53193e5..00e5743647b0 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -802,6 +802,27 @@ __br_mdb_choose_context(struct net_bridge *br,
 	return brmctx;
 }
 
+static int br_mdb_replace_group_sg(const struct br_mdb_config *cfg,
+				   struct net_bridge_mdb_entry *mp,
+				   struct net_bridge_port_group *pg,
+				   struct net_bridge_mcast *brmctx,
+				   unsigned char flags)
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
 static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 			       struct net_bridge_mdb_entry *mp,
 			       struct net_bridge_mcast *brmctx,
@@ -816,8 +837,12 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
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
+						       flags);
 		}
 		if ((unsigned long)p->key.port < (unsigned long)cfg->p)
 			break;
@@ -883,6 +908,7 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
 	sg_cfg.src_entry = true;
 	sg_cfg.filter_mode = MCAST_INCLUDE;
 	sg_cfg.rt_protocol = cfg->rt_protocol;
+	sg_cfg.nlflags = cfg->nlflags;
 	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
 }
 
@@ -903,7 +929,7 @@ static int br_mdb_add_group_src(const struct br_mdb_config *cfg,
 			NL_SET_ERR_MSG_MOD(extack, "Failed to add new source entry");
 			return -ENOSPC;
 		}
-	} else {
+	} else if (!(cfg->nlflags & NLM_F_REPLACE)) {
 		NL_SET_ERR_MSG_MOD(extack, "Source entry already exists");
 		return -EEXIST;
 	}
@@ -961,6 +987,67 @@ static int br_mdb_add_group_srcs(const struct br_mdb_config *cfg,
 	return err;
 }
 
+static int br_mdb_replace_group_srcs(const struct br_mdb_config *cfg,
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
+static int br_mdb_replace_group_star_g(const struct br_mdb_config *cfg,
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
 static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 				   struct net_bridge_mdb_entry *mp,
 				   struct net_bridge_mcast *brmctx,
@@ -976,8 +1063,12 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
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
@@ -1223,6 +1314,7 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->filter_mode = MCAST_EXCLUDE;
 	cfg->rt_protocol = RTPROT_STATIC;
+	cfg->nlflags = nlh->nlmsg_flags;
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cdc9e040f1f6..15ef7fd508ee 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -104,6 +104,7 @@ struct br_mdb_config {
 	struct br_ip			group;
 	bool				src_entry;
 	u8				filter_mode;
+	u16				nlflags;
 	struct br_mdb_src_entry		*src_entries;
 	int				num_src_entries;
 	u8				rt_protocol;
-- 
2.37.3

