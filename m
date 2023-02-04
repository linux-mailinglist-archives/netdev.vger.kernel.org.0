Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F2B68AB82
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjBDRMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBDRM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:12:27 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415EF3250E
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:12:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoRwRQBFzjvBnBGQ1nlg/wOxukhldX0R4wKhMgnM5QCPzi7CtkOxnTsaeoSZdi2apWdzmal/+2vvThe7EUAty5UWv7wiLBKgJLTCwkabKyTAjm6xmnb7emSxjRdnmWvZXM6HPeVjRfcEPbC2VGeqt3MPtCB5XxAbS/6eLN+w8tha8Bp221y0V7049RP7GYlraEuGo9KylC9XgOMMp6i1bffZRtJHrEuXVkH+Ru8Js8r/BdTvauwCMqOBk6mzsFXuAE/wox916uJHoDTus/O9me53O+g4dbAgVGQWBpCkKL+WxrPTavO5sX1Av+trMe78EDWLMuXfZtoyDWfR9HZrOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dITE0nCpbZDklb5l3vSuD6whwHROlN3eE9YbIk7Rfps=;
 b=LXIk7y5HBHEBJkTa5lpxHP7tIt+sWFJv6mKZLVvUT67VftnJ/xmZPKMnNx26BSi5eDDRc6ySKfi0gq3EAtsyLmkSfDMfP7upLr4vdkkNjTco4O8WQgLqExwJEaTTdVoaUQsMf3+ruux5nA1GivYSGlr3MCmSv86jPGc0liexGk42E7pSFxzupNdihgobUS7Rif6bjjabi3FGz/EYLZQsj5j6+t4KWVL7peqn6n9U22HOPMT4P8aI+fHg0RvYYIG9pt81S+y82TPcOzR6kIC8Uxa8k4+wq1FDX81LcDnl3F92zabDT32X0j+qj5PymYeJ499d9vri1to98sPDPvy4BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dITE0nCpbZDklb5l3vSuD6whwHROlN3eE9YbIk7Rfps=;
 b=HFAszDSJjFh57KxogK1F4MfAvUkXjHQYkpkJ/uNZeap7WDDRWo618WzHdsqLk/sJyzj8p9iR0cAv470ijqk4QTk5exeZlabQK5sZBlnLGupDQBMLZhbzNC4RpJ2SPjSVcFzauFY8lYTWEox+YuHQn2425jfIk4Qawuxmyo4ABdB8+TylW13Yz41rMqmzM+3L/Plf91w0rwdclCyavIqMAKkEa6+IF2zVBhdJJorvM6dCrGTgP4Zu3w8eZBvCjmwzNvpxQcCqxZDS82stO5zRUzZujfVwOEYrZAQKqxcwlIVm3c/kOoto3P2RHBv3aJFPP61vDrfHXXOEPQQ+GAMDwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA3PR12MB7997.namprd12.prod.outlook.com (2603:10b6:806:307::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 05/13] bridge: mcast: Implement MDB net device operations
Date:   Sat,  4 Feb 2023 19:07:53 +0200
Message-Id: <20230204170801.3897900-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0092.eurprd04.prod.outlook.com
 (2603:10a6:803:64::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA3PR12MB7997:EE_
X-MS-Office365-Filtering-Correlation-Id: 5afa9290-3dad-49a8-ae81-08db06d2f56b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LkZbW8OrT6gHe9BO2HDtzfKziU4HZ6Ug1Il8E3/ObZaDMe736aQmp9lzGG17QJipXl8VyNiBC1P2Mv0ANpWbfTjz741L76QMyZheViDjjXLguc+H67TGk3YeIgdKGbYmTVsClv/1w2bDZM1AMdTX/LgDAML0sfquXPMtnt3MZn1SjpkPNGsHDvXXXJffP2k412ITOHfxy+tPR+TfZq5iqF8vi6Ulo5wr2qF6Mk/qJsORToW8gSvH7gB15wT/UrHouSQfAxJGumv4GNsHriunFvh1sG93pSaKd/eEBPtUJHsI6SoM2IHcsUNw3e1qhxalDRTCC8BQ0lBr1YtTVMwi0fIVBBpcsH+kzPgnTq5gjmT9gD/D6zyJ92piDZ2ue9mUa7Cb28D/VkbVS+WfZn852JFudOT6WrM5lQSBIFJDmeY6cGz38LY7RzQcM/+Gd2G5ERmteHdjYuSjsDxkYparhDalbWsI59YH47UzfIWvODPNeO3hIpLhvxPjeIk0uT3HDwOr5RbLNF48WunIe/k+NQR67WEbZVJpiYO994rSsmVWblEpxTqN56h1medDi3qzBii+57ZcnmPaozUF5Bi+NP/M6NzyiKoW78tumYVtKtmPXVJPzbkpJjMyc1NzRVFXwBOjQt9bSE4RW2sV/jKKaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(8676002)(41300700001)(66556008)(316002)(66946007)(36756003)(66476007)(6486002)(1076003)(26005)(186003)(478600001)(6506007)(6512007)(4326008)(6666004)(107886003)(38100700002)(2906002)(86362001)(8936002)(5660300002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WI9qMUwqXsYPMr24AeUjmdqBDG+JVdVAGquXSu+tv4kp/QplwwUWt/NA/FzC?=
 =?us-ascii?Q?rwvUDC+wuzI7PkATa2rlnSMT787Cw2AeFmz6dfOKNEkNTz/O6MUedYlYMWbU?=
 =?us-ascii?Q?lhVVzmgDQ3nGbNJuQxhYjNruGQnKmScKKL9oiqYzj41rPgh8yvLh8kDjGckV?=
 =?us-ascii?Q?V5MH44KNNQ9nKpSC9Kj6WXXHAhkOOus8adfgtS1kYRDwDJM1/xIS9JUSLOqJ?=
 =?us-ascii?Q?BFqp1E7XhmzhO3TYhGqgbBlzQyxRuN2/uUuoRkRl6vr8s12+nyxokNzOtxyr?=
 =?us-ascii?Q?s+wUGnPEuGlQZH4YwsgRCKxScSGtvuByzaG2AfOBL49Is2XY5rmQtbUUwVVT?=
 =?us-ascii?Q?dEGi0O6t7G+HECfva+knXL6spNdYu5DV6qRjTXQBBvgotIxKnGAoYBuh4Nm6?=
 =?us-ascii?Q?Fxtypajydbdyfwushoq8CQIiqmLxl4jxR0e+Fpsk89HjmkR7o9xjPgmddlAs?=
 =?us-ascii?Q?1mQjdJfZlhCBHLk9fh9vs2zjMQQb7gXpty0foUDo/fADtcPajTbL1dqByNHV?=
 =?us-ascii?Q?QALeLqBEJz5Qj/DQqbEPJ3NexfUBNf7noDjGuHUEPsDYw3sJbNc59KHNhdLK?=
 =?us-ascii?Q?M10jq82L6LgKsq6GG6ImKfZ0gN71fhaROsPAHv9oDqZy1GmE5e5AKc8JsrS9?=
 =?us-ascii?Q?LhsF+aNt1btWxHXh0Fdk0cW0vDWD6xTpaLruoBNs8u61/NrEVIOK+0nT0zqw?=
 =?us-ascii?Q?CU8wcdGz7MmBbz9wLybdKJh2CEi/srMlNMUyw54GItrQWx0xJtNVdZC668/r?=
 =?us-ascii?Q?mmYrIJUztCU/NbRCh469nPIpr98yu/fqEG5ynBEHjpyIYmtMUhehs9N+Vs0M?=
 =?us-ascii?Q?d+kC9QaVzUYn1PGDXmyEUwTtLV/c6sm51jv5dleO2Ns7Ocz9CM0LvGThcYRY?=
 =?us-ascii?Q?QoXa0gJN9JWRoWjHa6tPJsBZlWsSdatiz2+jZHC1OG2u1iBiJNmONkL1qVDS?=
 =?us-ascii?Q?jtVvo7oJUpg2uqqUXZohuIjFOzScwj73F/joLoG5sqM9IBxCGQo7pjTzPcOM?=
 =?us-ascii?Q?D9lcfykJ5n9ajePHh03aRIp0A3lDpfC2RQ6gEuyXOSDLgamngpHkerKYYOjY?=
 =?us-ascii?Q?nc/aSz34HgZGeuVbyhHfGc5sdw7cJ5zQWxSkFjZRkAM+2G+c6+CJyjtV34gz?=
 =?us-ascii?Q?xQYBbb/8cxilCd6wEkYYLK2vXPMQAoU5hxMxgng7hNa6QS0Bic5kl6tuCIYo?=
 =?us-ascii?Q?uwYyKXCdwuHxTzouGAOMx3LnTPvoG8W3sHHYu4+x5HuhnmDf3vCKJXSjHcUk?=
 =?us-ascii?Q?+KY4VFCIjuprE7lBGfXAavFPUua8w2yffRre/xPTNhMWM1HqRtz8Wq4B6pId?=
 =?us-ascii?Q?VcoIF0/jnTgmNGuY1k7YU/aaG55H6Qzoz+dlzm3GimPIeGqV0QHTwhIv7sgX?=
 =?us-ascii?Q?4VB6EJDnw5/SDEbajwXbA1u4btkEOhmcfEJlNA54U1PufH4xfphDakanLp72?=
 =?us-ascii?Q?CEE+vFkJ0em9ELRW3X3Nl+B5EPkz2DvafvMhtFwY5+P9FrDuAdrc42e5VsOf?=
 =?us-ascii?Q?BYMsLlEVi7n9J3v0Qp26xjUef7Vbh/zdVqTCNrePqVEjD/1/+viB+mcV6xM9?=
 =?us-ascii?Q?A+09C0rFiau4gEiXo1ZfwjBzsFDdEm0/1BR7VBOJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5afa9290-3dad-49a8-ae81-08db06d2f56b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:13.5148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EeFJG2kzAVoCw4UF30kvQI6Mj1G+I1nM5yP1MLfI4M+qph4HN+v/dn1HI4+7cGkvJcnWCZPziQ5u/D8GBz/8Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7997
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the previously added MDB net device operations in the bridge
driver so that they could be invoked by core rtnetlink code in the next
patch.

The operations are identical to the existing br_mdb_{dump,add,del}
functions. The '_new' suffix will be removed in the next patch. The
functions are re-implemented in this patch to make the conversion in the
next patch easier to review.

Add dummy implementations when 'CONFIG_BRIDGE_IGMP_SNOOPING' is
disabled, so that an error will be returned to user space when it is
trying to add or delete an MDB entry. This is consistent with existing
behavior where the bridge driver does not even register rtnetlink
handlers for RTM_{NEW,DEL,GET}MDB messages when this Kconfig option is
disabled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_device.c  |   3 +
 net/bridge/br_mdb.c     | 124 ++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h |  25 ++++++++
 3 files changed, 152 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index b82906fc999a..85fa4d73bb53 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -468,6 +468,9 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
 	.ndo_fdb_dump		 = br_fdb_dump,
 	.ndo_fdb_get		 = br_fdb_get,
+	.ndo_mdb_add		 = br_mdb_add_new,
+	.ndo_mdb_del		 = br_mdb_del_new,
+	.ndo_mdb_dump		 = br_mdb_dump_new,
 	.ndo_bridge_getlink	 = br_getlink,
 	.ndo_bridge_setlink	 = br_setlink,
 	.ndo_bridge_dellink	 = br_dellink,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index b1ece209cfca..3359ac63c739 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -458,6 +458,39 @@ static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+		    struct netlink_callback *cb)
+{
+	struct net_bridge *br = netdev_priv(dev);
+	struct br_port_msg *bpm;
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+			cb->nlh->nlmsg_seq, RTM_GETMDB, sizeof(*bpm),
+			NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	bpm = nlmsg_data(nlh);
+	memset(bpm, 0, sizeof(*bpm));
+	bpm->ifindex = dev->ifindex;
+
+	rcu_read_lock();
+
+	err = br_mdb_fill_info(skb, cb, dev);
+	if (err)
+		goto out;
+	err = br_rports_fill_info(skb, &br->multicast_ctx);
+	if (err)
+		goto out;
+
+out:
+	rcu_read_unlock();
+	nlmsg_end(skb, nlh);
+	return err;
+}
+
 static int nlmsg_populate_mdb_fill(struct sk_buff *skb,
 				   struct net_device *dev,
 				   struct net_bridge_mdb_entry *mp,
@@ -1462,6 +1495,65 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct br_mdb_config cfg = {};
+	struct net_bridge_vlan *v;
+	int err;
+
+	/* Configuration structure will be initialized here. */
+
+	err = -EINVAL;
+	/* host join errors which can happen before creating the group */
+	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
+		/* don't allow any flags for host-joined IP groups */
+		if (cfg.entry->state) {
+			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
+			goto out;
+		}
+		if (!br_multicast_is_star_g(&cfg.group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
+			goto out;
+		}
+	}
+
+	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		goto out;
+	}
+
+	if (cfg.p) {
+		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
+			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
+			goto out;
+		}
+		vg = nbp_vlan_group(cfg.p);
+	} else {
+		vg = br_vlan_group(cfg.br);
+	}
+
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * install mdb entry on all vlans configured on the port.
+	 */
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
+		list_for_each_entry(v, &vg->vlan_list, vlist) {
+			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
+			err = __br_mdb_add(&cfg, extack);
+			if (err)
+				break;
+		}
+	} else {
+		err = __br_mdb_add(&cfg, extack);
+	}
+
+out:
+	br_mdb_config_fini(&cfg);
+	return err;
+}
+
 static int __br_mdb_del(const struct br_mdb_config *cfg)
 {
 	struct br_mdb_entry *entry = cfg->entry;
@@ -1538,6 +1630,38 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+		   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct br_mdb_config cfg = {};
+	struct net_bridge_vlan *v;
+	int err = 0;
+
+	/* Configuration structure will be initialized here. */
+
+	if (cfg.p)
+		vg = nbp_vlan_group(cfg.p);
+	else
+		vg = br_vlan_group(cfg.br);
+
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * delete mdb entry on all vlans configured on the port.
+	 */
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
+		list_for_each_entry(v, &vg->vlan_list, vlist) {
+			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
+			err = __br_mdb_del(&cfg);
+		}
+	} else {
+		err = __br_mdb_del(&cfg);
+	}
+
+	br_mdb_config_fini(&cfg);
+	return err;
+}
+
 void br_mdb_init(void)
 {
 	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETMDB, NULL, br_mdb_dump, 0);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 15ef7fd508ee..91dba4792469 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -974,6 +974,12 @@ void br_multicast_uninit_stats(struct net_bridge *br);
 void br_multicast_get_stats(const struct net_bridge *br,
 			    const struct net_bridge_port *p,
 			    struct br_mcast_stats *dest);
+int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		   struct netlink_ext_ack *extack);
+int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+		   struct netlink_ext_ack *extack);
+int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+		    struct netlink_callback *cb);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
@@ -1367,6 +1373,25 @@ static inline bool br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 	return false;
 }
 
+static inline int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[],
+				 u16 nlmsg_flags,
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	return 0;
+}
+
 static inline void br_mdb_init(void)
 {
 }
-- 
2.37.3

