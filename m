Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9DE647309
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiLHPbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiLHPaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:30:23 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2041.outbound.protection.outlook.com [40.107.101.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9114675BCE
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:30:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7qodJh+1CthwB8/8bm87PKgZyrjWQ2GRSfGC4hx70ph178YP+eyfCICXHscMD2/rleIyU+LB7vTXbnLq/cxl4vHNQoSi+W5/eOZkKwEDITRsXPkFmlwZuTFihree5qhgzErPbcKlj8ZP8H7CLYIESfMLHBqxR5GO6qQnJc5K1P5dK/aKhlxyCfXkpRFeUCq3Ph4q7Mo3Bjl2RYJuZ1fJfqiMS/sU5K8zvCgCZ5mlYVSRN7tfCNALYeEVpBjdsdnjkgVJNBWjyuvbUvPSxVMp89/A9Iblv1LFWkP+aLfcIIjDsYvbMH46E0zop//HLAI7hIpCs9FU/DhWbpHfCrKKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4soViMJUb22F2vazP9wlvyc2PLRw0/kLOnzMWY0GrJA=;
 b=LyWDgA37IJm5U3vyh1zCkyN1zzMsC5pAkWGtqWfJYuELZbrJSOLB8+sRUSL1Vcdtkv30GW5emxJ7kkG4WjfFsCm0Fiqkg4/XbPntD2rHPkoO2NYuEldjssA1vdpcMtQaYeKyhZU/vmB9RjlFwPZMBa0gpicSGpRCBwJuiCMV/SdFwJ2qYdCMXstQds2MjdzT2NPH8ywo5RxQp/ti6iZFnve3/dVRjvpU6wrEhnz1vADyKjLALRagw5Pu4fr0V/RDZH67Y/bnvLapwn/A42X4TxxZFRpLYwMXaW/kxjO3XnmxI8E2/DoK67DOWp2ZvGSAD7FJukGd2FX6wpv3LoMtnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4soViMJUb22F2vazP9wlvyc2PLRw0/kLOnzMWY0GrJA=;
 b=hGBaRyGo6FfD2FkwM65FLee2e3Tv4viau/4RD+4Lp6RpHCtPpbfIcsCZR8hgw6Gsv2IIee0ya8FJZDRp3vkl3KYJNcwUZZZ7r+oMYQxq9iABhbaWVhEhnbbPeLh286pjXkR7SQHhDUwCyNLgpI+PcoqyN1kkE5w6Ni2NVzQlaABqRoTLUg9IHlg1tzI6I5OS4OlbXKJ2NctempMosUZ+fLuwI//pF5K7rovFCGoOpppRidsLAxEMj3JZ+VlfpVXJPU11v6bSOF5Miv8BHWTNcO62inzI25q3AHEPcIXxYA0p61MBfV7xgFHYvvtMM4PrZu9BUIfihc4uat0SSbaT8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5370.namprd12.prod.outlook.com (2603:10b6:610:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 15:30:20 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:30:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/14] bridge: mcast: Support replacement of MDB port group entries
Date:   Thu,  8 Dec 2022 17:28:37 +0200
Message-Id: <20221208152839.1016350-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0043.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::6) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: ff5bb8cc-450a-4f37-ac32-08dad9311d33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P37+4rkFvLrAwXL2i7D074+dOXg95dONnK+G7D8kjxCYJ31DoGTLTkn7/UlwhP3cig8pP8GUzCL93dOWyB0+7Pwc9fOACKU2mekgh+vJgfUiW41B2COZgpjtnibwdJqXHtR8o0yKchXmsZblPWQjkBPiImxM1aMjvSyGQcH74B371HNP29pOF9asfb1r4SnNQ4sVg1RzLJ4vJ7S9UnstB+Jojc/LlyzGdcjc1eBBDgqlrG0kHotjK56Qt77uHxHHA8gW6dhOuSt5c9pyfb9VzIR9JoHvKRgxongwfAc0hyQa2D/SvavV1AmjDo6rbvOTcpEmKMhhbb7vHvqhLxH2ZHZPNWZjo59KiNwj7TptOHLlCCJ7pFI3EpZu/4heqVOxjKjwmKg78LEdlxcOhIIZ+J4bCFDHFocU9kuZVVzglIvqRnCkmGKVoq7TwzRvdKSJq7jzFJfpc9staFxsXDLuyFqJrkH+sQUYYL97prsFFvBUrwjgtP3q1eQ3pgtcjyy3TiKcb192qSOiIlJe4UVwabD7KUEGBUO1bb2CmVZzyQE0AcckjZdT2T9ML9feZQstqmLUI3G6SNBtxZLJTRBLh+bjVmYPrUlGo/cWSruLjgi1VeHgwOVASm2H2SCuPZSeG2mdkkJDZitxFCDXUYzGvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(36756003)(86362001)(41300700001)(8936002)(66476007)(66946007)(4326008)(2906002)(66556008)(8676002)(38100700002)(83380400001)(107886003)(2616005)(316002)(478600001)(6486002)(1076003)(6666004)(6512007)(5660300002)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YXgU75Bx4tgOW0QInmxq8wgnhC+P2DesoJjCQ2fWQ04lu+GS6SBGSTcan3T4?=
 =?us-ascii?Q?nwgx3bnaxyZDxe6d1sPywBOjAbfkFb3w5lAH2uieLJ/gm9QLALBVP41Cz+no?=
 =?us-ascii?Q?FMa80O9K7N2+lDNYaw2aKwQ2dbJkLi6cjr5NDZu0X3L/Atvyt/3S0Um+0Xz3?=
 =?us-ascii?Q?/JZRLqiWE7onYSTguyU8A7tnsHXh/H6DYqkkh3KrGmHOKjQUJZE8896MPxKu?=
 =?us-ascii?Q?RGgfz9ISe2vsmhtzM3KP3HN2JG67T+Uk5vxj62qVdQzKGb6GOse6SVR3kQoR?=
 =?us-ascii?Q?Xo9hH3bTidQQzlkngwrfdEVlKKPjEN5HrTFlhL9Zd9eJjVJFdsp9KMwk21Vv?=
 =?us-ascii?Q?kyzwifxl4qBjGCROr3LvUwpiinORo0W7hLS6pNxuG0nnEp7MlQWkxqj2+OXa?=
 =?us-ascii?Q?tGw4JUskdW1rlCl0tYziOwfEsjN+WrefJd681LVxgu1YrSOpvJGCjdrlYdZM?=
 =?us-ascii?Q?zUEbyII1tOGPZa7cqV+5v4GEXXnRVvvic8Z+MDnDEuWTrwv1bHcdeeEJWtTi?=
 =?us-ascii?Q?RAyOCWqm2F5L9s772+dTnrpS4dz+6d+URrfXKVM4o6jf8OyCYBlus+Jy15iw?=
 =?us-ascii?Q?xe9Y/AqMRhtYec9aoMrigFifCaVSl23Hda+u7Cu+cggIJnqidEpgbxqUPWrU?=
 =?us-ascii?Q?ULF2PzWID2JH6c2hQoz4Zk2XvB4s9HbcjAiR08o57vK7SO256nNEHgshIwvA?=
 =?us-ascii?Q?riIeB/uQKkWUfW9prc3Rdukf4nJblv/t1KYG3x/duzmgn0LariBYt1Wb7Khf?=
 =?us-ascii?Q?Mu0RE7i97lmAelvR0ht8B6+LCVeeTn0AJ3wK5Natx23qBkH22DwRQTTbPDIZ?=
 =?us-ascii?Q?6ba9BQNPC8yYLeswsx9e4VJy9x2998m9+hfQFTPpdUYN6T5hKDuy7usk1O/9?=
 =?us-ascii?Q?9DKvVx9s3+doFAJ3xr/x1l9jiFvB52V1jWPR6SEcDKKAMWNc+h2m3+e55xAC?=
 =?us-ascii?Q?yEHY2QvNmd+5FUNBaSc5Wlew3cmEpAz2rA+wvmbdoktcDNg3JbDrnKxj9sXO?=
 =?us-ascii?Q?SjucIIMpYGfDNGbfbROA10+lDezaguRwol+Laq1uJGWmP9pOU7TnjR9D0ohG?=
 =?us-ascii?Q?wvpptIDk2MTgTlVDXFofKgk0LotJQmE40wBFfxCM5tfRNT7J0HLmh6TZasoY?=
 =?us-ascii?Q?n30/fV3I2CDEsBobupAnVDVVprlFCtzNw4UR7L31/GFuOxGQx75b4IX0JqDw?=
 =?us-ascii?Q?NHGRcfk33+IoXfbb4/CeRtwAkQhkADOAoYzpZdXa1pH6uO/SjHGCAy/thj87?=
 =?us-ascii?Q?YPn0esnoBqa/HoLLcP+oc3FFjyUGsUHcoqDQ0h0jNOGgIo/QfB3GzfnWXA+s?=
 =?us-ascii?Q?xpkfT2rB80L3lYwsLUK3gIzTC9BrYfgnml/K51ZsvPpquGAFX+49b1CI6wI0?=
 =?us-ascii?Q?Y92dl8t1KLnInhGPxOdNbAa8PDk9aZNl8DtFg0dDiVWf9W0KR5ZOKDGy/so/?=
 =?us-ascii?Q?HY1VfbwJE7QLr/Y9vlkTh3cruEnReJSevs4lwzdkjJK88XNe2Sz1NmsCVw7t?=
 =?us-ascii?Q?Ui0xdHRg/m40Pvg3I/exDL8cJlivWjNODQpPvyNVIlNt7SYL6TfXrUkn5gcR?=
 =?us-ascii?Q?HPzR5Xh1PpRjTioyXTXHia5eMehIzV4TJw0PyomY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff5bb8cc-450a-4f37-ac32-08dad9311d33
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:30:19.6177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCFgsqnlXx+Vu6vMIuz37lGU2N5J4ekpO9nn6goW1pvadykaqUyMIscSU9LWLbAPHkzaVwl7tc8qcg64yfsCHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5370
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
 net/bridge/br_mdb.c     | 103 ++++++++++++++++++++++++++++++++++++++--
 net/bridge/br_private.h |   1 +
 2 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 72d4e53193e5..98d899427c03 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -802,6 +802,28 @@ __br_mdb_choose_context(struct net_bridge *br,
 	return brmctx;
 }
 
+static int br_mdb_replace_group_sg(const struct br_mdb_config *cfg,
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
 static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 			       struct net_bridge_mdb_entry *mp,
 			       struct net_bridge_mcast *brmctx,
@@ -816,8 +838,12 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
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
@@ -883,6 +909,7 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
 	sg_cfg.src_entry = true;
 	sg_cfg.filter_mode = MCAST_INCLUDE;
 	sg_cfg.rt_protocol = cfg->rt_protocol;
+	sg_cfg.nlflags = cfg->nlflags;
 	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
 }
 
@@ -903,7 +930,7 @@ static int br_mdb_add_group_src(const struct br_mdb_config *cfg,
 			NL_SET_ERR_MSG_MOD(extack, "Failed to add new source entry");
 			return -ENOSPC;
 		}
-	} else {
+	} else if (!(cfg->nlflags & NLM_F_REPLACE)) {
 		NL_SET_ERR_MSG_MOD(extack, "Source entry already exists");
 		return -EEXIST;
 	}
@@ -961,6 +988,67 @@ static int br_mdb_add_group_srcs(const struct br_mdb_config *cfg,
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
@@ -976,8 +1064,12 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
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
@@ -1223,6 +1315,7 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->filter_mode = MCAST_EXCLUDE;
 	cfg->rt_protocol = RTPROT_STATIC;
+	cfg->nlflags = nlh->nlmsg_flags;
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cdc9e040f1f6..2473add41e16 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -107,6 +107,7 @@ struct br_mdb_config {
 	struct br_mdb_src_entry		*src_entries;
 	int				num_src_entries;
 	u8				rt_protocol;
+	u32				nlflags;
 };
 #endif
 
-- 
2.37.3

