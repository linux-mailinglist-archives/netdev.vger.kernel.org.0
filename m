Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC29A602B3A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiJRMHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiJRMG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:06:58 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2088.outbound.protection.outlook.com [40.107.100.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067BB9A9D3
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:06:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfqPTzxUt1bkMVBAZsIbXa/jhQND71tZhx2sHGWbwTxIRQcsfgwUc8EOdL0XrGD4CnHK5bPcYctq/Fzs9ollqYwRJ0slidMcd4MFhOGvJURsMd0fALI2f72NdFUA9HSudlZ3ONApG2TCdxxwbNu+zZSSEX10ZQ1st1edPohwOeuFA6UTfuS+8cqBoyx7RmhFaJkMVpZrVrS1HvRs/nKACwYYqE3/UfjX2R2/21a+FMVwFiI3OtoEdE4E8qWpqCmEm1FAT/VSqKO2qOu1oPWGrlBh0WqGeq+KP+URFpX9BCXuI5GOw9WZU5YNxCbxFisAAmjgWmfCeAwX5hSPQbU+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RAJY2CjoYY05o8YbqzrUXnRhRr9qjw5s82Fb6RBkow=;
 b=Ch+GIwPdKTfgaY4m3hoX4XLqd40skV+8fKMrZ9lK/Mond4IvTsBRM7S8dQCcMeRZvCRWRXqWkG9LavhugCeeuXF6FdpurWUJPnb6fnZLsNUtO48tU0WQzDGRmF9QbTClLK99oL0CarBwIKHpxN+I8mZn8Vatx2+1QQI2WoenJtqSfx0dMk3G9hjGr3krvOt4KmEYLW6SAkk19sQLAqSZo+V4B/lDLo32w6qgcJLWsogrg981lMoX9Tv2z08oDZfaYv9zVuCT3YFyvFsqxnwesHBRcaf6Yf06UK/TVE0Kc9T21VVqR0ekrrIXTpd+PjR0+9gscKaE4ptakMlaQgwDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RAJY2CjoYY05o8YbqzrUXnRhRr9qjw5s82Fb6RBkow=;
 b=H90f3bk8PnqTIiDyztv1/2S8pASZVA50UmdgwUwj0xTKwsVyh5IYnMPgp5ozwDyLksv3zSBf1qsZQLirGjFI7bm/9skZunDXY8BwYY4rXvljbdWChikhlRsDH6cPHM2PnyVTUh/FQuKsSpIZxZ0mfE3IzpBCtm0nne3FNjdwC7onOUduWkikqUCUL6yhrO0EZ/JU8lyeyalbMd3sWp42IsMU+ZoYweFdLaItpyNOuvVatoFD9ppPnoDAraKFq6SqftVyArlbWQb43PL15QeRAwZffvx56HDmmTsO1X9q2J1jyWdeTwjDjPS2Lcq3UA5rCaTqRiy71pFZXqyyZLWGJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 12:05:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:05:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 06/19] bridge: mcast: Remove br_mdb_parse()
Date:   Tue, 18 Oct 2022 15:04:07 +0300
Message-Id: <20221018120420.561846-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0248.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 01390a48-6792-4846-203a-08dab101179d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NaimGCSI3yqvpfUodpDXunqaLRR8ESIwQwCXUOGlcvhccafBi0PWCWZyJlT+qxA/M1hfjRdwsk6Rr8QRUppsP5CdFYDp9254jJ1lXB6cZMgTwuucs4a6QdE1QgIx9qeMGQbUJdDPw82GNd6D3uYP/FMbfpZOxp/IRkdV97OqcEHu0+xyaUvf8LNmBqJN2ugul+fKO59ozxtxekEMgQNK3OE3WBYQmi/t1w8Ly4P3KTvZW7XQBOgg8JjCpEpD5gJQIQf5FHT7LdEQXHvSm5I1H+C4qooWAMEsJX1vxy69pt5Biax5hWp/YSEGEro87fhqe1FoBLvC/fV9aUZficmKmVZSIIOhPDl9qLS+EyN3TCI/32Q9AtMAIPiAfXiiSDaS8nspPSS2JqZir/KXi9ft+NWTqrxYt2n6/Ba9K7KsEL78JnrkRK2Ya5nOpRfmE7xOY4Ncz59zIPcPg+8RpVeKY6X6GxzCPzvtYKKW4lqRJjzaLpnY0pMmYowLIB7zZ6JLqQiOa742SaUOf+O00u/lULy93ygSd1F2HtqpCARFjhLk4O3DAkQj0ZAyoNE8HkzoGvy515cniAFR+aIGBikhiEssqLk3NVnwxCn1alnHS+daB0Pa05eOlTAjpWTNkA/GrtHgqgFB7Yw+czoH23WcFMef5B9Hku5of9durQxw/VOEYuBwEJqxn7JA+Ak3Ye/GEIZuFj0bVynMoVEW7hpWSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(1076003)(186003)(5660300002)(107886003)(2616005)(6506007)(6666004)(26005)(6512007)(478600001)(83380400001)(2906002)(6486002)(316002)(66946007)(66556008)(8676002)(66476007)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?snXAtytoyxHo1VPlD7Ej86OBfpqPLkge3zjyKLxOXcKN2aSHp2Sjk6TMsZ4o?=
 =?us-ascii?Q?PYWfRTSPg3eAAJVQHWjFbMUgXs3cXoQpgs4UWKf33KRRM6frI72fM8EekZ5y?=
 =?us-ascii?Q?A8hUCdLfr7xyhqtbG8ZrC7mp7oapaDWKABvlXf/Iu9qcCwhHtKmgq8WDujXm?=
 =?us-ascii?Q?uz7pwB05XqzODdoPTMN9xhWAktJVpg41bVUTPcT3f/ir1i84GF+VEtQ8HCCJ?=
 =?us-ascii?Q?wP8mkhxdIzDWTkrGJaux9PkN/m5wRw/AeUyfoEUhUto91Dh3N8C3iDWxz488?=
 =?us-ascii?Q?PJ3G+LTdeCdya5oqB61ZVVzX2FGbnUSGBDWFv7mGXLNux+INWy4huhATcJV+?=
 =?us-ascii?Q?f5a64N8tYfTYB7rNaI81my1oewus7NLCB/ENRQSXX5HCmLw/ILXVE9mhWLKJ?=
 =?us-ascii?Q?bLOSWvmiZuax/nsjJjVVERQrWyBR8475AX1Qp68K+PBajsUKvIJnUvSH85yo?=
 =?us-ascii?Q?eXlwwCf4T2yk5eHmced5YHaRznkfonJftDJ2nc1wqycmAU1mPfXUD599MN9r?=
 =?us-ascii?Q?7Oi/WEv7QYWrkYXttVg2mVEUXVb3bmfPs8jtBnMAZ7X/OqpQC6iixKzvHnLJ?=
 =?us-ascii?Q?L1rU9GUFPGKPzHu7rvJxGbBW6H+GvFz39OdfhGNRGZ5OGpm+dWKSf39OsWqe?=
 =?us-ascii?Q?09KBdqhHYdMqXEfFwQvlTOi0gz1pmBbaLSj9FzvnZ4rDKvNL29KIb127h8im?=
 =?us-ascii?Q?FDNoBdI0UkMRpp73wLFzdWsBApizrOd+IfcaScvGWUTRlszq/xjqhX+wXS8s?=
 =?us-ascii?Q?rp0aiDnts0zPihUCwDv5UB9LJtJ/xbblC6+xy4bSn/Z4rO0d02MM3rGGEk1C?=
 =?us-ascii?Q?d2w8jf1nWJFEsjUqLmtWnOBjfpFkKxe+ZOQTgpQik8chaiQuobnXkxiFnATy?=
 =?us-ascii?Q?xN95zwapazP0EOipc9mTxKwpaRwXeJzD/UfFbxe5nCzNzBVzTczK0vQxhc2I?=
 =?us-ascii?Q?bKXadp0PVfIvccWAFllxlNqHzok/t3+rshPD5zAYRRbVfFZXcraU8DnJhSPn?=
 =?us-ascii?Q?O9jsCH4hNX9mYIJbic2MkVcRN/UH803x6QwZE6YH33sqL4Ov1d1YwTiX9X1p?=
 =?us-ascii?Q?vS2n88/WmsXMrMTKvAy/5RMO9XsqdtSxJtORGJUOS3D2K+9VrE7ypYc+xkyN?=
 =?us-ascii?Q?R6gdAqYUNPoEFkv9QmVNwvqe/SYjJ+TP+Mma2adyRLY/LaJtTCu/pojBrze5?=
 =?us-ascii?Q?d5ng6NCQh4FXBfX+bikGbw2fodGcvaqDpgR+qTkPM+CME5TVwmBn7iNtcThA?=
 =?us-ascii?Q?QkjmP+J+BHJ3JT8D3n781K/kBeOxaF+2JKu2Lae26h6ONmJyuJCDEW9Rkvcj?=
 =?us-ascii?Q?9mdHZfRnmAnEyZ7V29bBIX6sGs4WJRB1UkWi/FoaMFyxObnLBXopCUa4XT8I?=
 =?us-ascii?Q?NiEo+xMX3Ai512uONL7soepJxj4mozcyqIjsoZre7eolRSxcIM72rdVeAFGw?=
 =?us-ascii?Q?rrDFZvOM1jlCwLUnN5tc2OKPl8LltCn1fWZBr6BNgTcbbQ1rImm87BeiaHQ/?=
 =?us-ascii?Q?VdxVr2j2IMr5msRcW01XLoUU9dOdf4/wiX9T+i7jhzeFjUPFeCYa0LaGfY5h?=
 =?us-ascii?Q?y5AV8YjwN+6UNefJWRFEvbmu3J02ipkP1u/CHU8u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01390a48-6792-4846-203a-08dab101179d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:05:47.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S0bXb543jrXJ+3AiL1yhkHHBo4WYwZBNDRUI7M44xEffkK5TIJXydf0oPGfupcqx8WQ65qFaMk047uV6aoPNTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parsing of the netlink messages and the validity checks are now
performed in br_mdb_config_init() so we can remove br_mdb_parse().

This finally allows us to stop passing netlink attributes deep in the
MDB control path and only use the MDB configuration structure.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 93 +++------------------------------------------
 1 file changed, 5 insertions(+), 88 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index cb4fd27f118f..67b6bc7272d3 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -754,73 +754,6 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 					      sizeof(struct in6_addr)),
 };
 
-static int br_mdb_parse(struct sk_buff *skb, struct nlmsghdr *nlh,
-			struct net_device **pdev, struct br_mdb_entry **pentry,
-			struct nlattr **mdb_attrs, struct netlink_ext_ack *extack)
-{
-	struct net *net = sock_net(skb->sk);
-	struct br_mdb_entry *entry;
-	struct br_port_msg *bpm;
-	struct nlattr *tb[MDBA_SET_ENTRY_MAX+1];
-	struct net_device *dev;
-	int err;
-
-	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
-				     MDBA_SET_ENTRY_MAX, NULL, NULL);
-	if (err < 0)
-		return err;
-
-	bpm = nlmsg_data(nlh);
-	if (bpm->ifindex == 0) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid bridge ifindex");
-		return -EINVAL;
-	}
-
-	dev = __dev_get_by_index(net, bpm->ifindex);
-	if (dev == NULL) {
-		NL_SET_ERR_MSG_MOD(extack, "Bridge device doesn't exist");
-		return -ENODEV;
-	}
-
-	if (!netif_is_bridge_master(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge");
-		return -EOPNOTSUPP;
-	}
-
-	*pdev = dev;
-
-	if (!tb[MDBA_SET_ENTRY]) {
-		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY attribute");
-		return -EINVAL;
-	}
-	if (nla_len(tb[MDBA_SET_ENTRY]) != sizeof(struct br_mdb_entry)) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
-		return -EINVAL;
-	}
-
-	entry = nla_data(tb[MDBA_SET_ENTRY]);
-	if (!is_valid_mdb_entry(entry, extack))
-		return -EINVAL;
-	*pentry = entry;
-
-	if (tb[MDBA_SET_ENTRY_ATTRS]) {
-		err = nla_parse_nested(mdb_attrs, MDBE_ATTR_MAX,
-				       tb[MDBA_SET_ENTRY_ATTRS],
-				       br_mdbe_attrs_pol, extack);
-		if (err)
-			return err;
-		if (mdb_attrs[MDBE_ATTR_SOURCE] &&
-		    !is_valid_mdb_source(mdb_attrs[MDBE_ATTR_SOURCE],
-					 entry->addr.proto, extack))
-			return -EINVAL;
-	} else {
-		memset(mdb_attrs, 0,
-		       sizeof(struct nlattr *) * (MDBE_ATTR_MAX + 1));
-	}
-
-	return 0;
-}
-
 static struct net_bridge_mcast *
 __br_mdb_choose_context(struct net_bridge *br,
 			const struct br_mdb_entry *entry,
@@ -959,7 +892,6 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 }
 
 static int __br_mdb_add(struct br_mdb_config *cfg,
-			struct nlattr **mdb_attrs,
 			struct netlink_ext_ack *extack)
 {
 	int ret;
@@ -1084,23 +1016,16 @@ static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
 static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
-	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
-	struct br_mdb_entry *entry;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
-	struct net_device *dev;
 	int err;
 
 	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
 	if (err)
 		return err;
 
-	err = br_mdb_parse(skb, nlh, &dev, &entry, mdb_attrs, extack);
-	if (err < 0)
-		return err;
-
 	if (cfg.p) {
 		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
@@ -1118,19 +1043,18 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			cfg.entry->vid = v->vid;
 			cfg.group.vid = v->vid;
-			err = __br_mdb_add(&cfg, mdb_attrs, extack);
+			err = __br_mdb_add(&cfg, extack);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(&cfg, mdb_attrs, extack);
+		err = __br_mdb_add(&cfg, extack);
 	}
 
 	return err;
 }
 
-static int __br_mdb_del(struct br_mdb_config *cfg,
-			struct nlattr **mdb_attrs)
+static int __br_mdb_del(struct br_mdb_config *cfg)
 {
 	struct br_mdb_entry *entry = cfg->entry;
 	struct net_bridge *br = cfg->br;
@@ -1174,23 +1098,16 @@ static int __br_mdb_del(struct br_mdb_config *cfg,
 static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
-	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
 	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
-	struct br_mdb_entry *entry;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
-	struct net_device *dev;
 	int err;
 
 	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
 	if (err)
 		return err;
 
-	err = br_mdb_parse(skb, nlh, &dev, &entry, mdb_attrs, extack);
-	if (err < 0)
-		return err;
-
 	if (cfg.p)
 		vg = nbp_vlan_group(cfg.p);
 	else
@@ -1203,10 +1120,10 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
 			cfg.entry->vid = v->vid;
 			cfg.group.vid = v->vid;
-			err = __br_mdb_del(&cfg, mdb_attrs);
+			err = __br_mdb_del(&cfg);
 		}
 	} else {
-		err = __br_mdb_del(&cfg, mdb_attrs);
+		err = __br_mdb_del(&cfg);
 	}
 
 	return err;
-- 
2.37.3

