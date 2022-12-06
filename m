Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E3B6441BE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiLFLAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234744AbiLFK7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:59:43 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1818F24F22
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:59:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJ/7kGqoiuXLP9+DwNnf/dMOnEJ+AI3CCpyiy5dMro/Y2BNH2JpBLh4U1QY8GPmUXWbzi7Q5LNJOQwtlOkFJV7szWX5b7z/6lThQqwEWm4/+fRLdnwbgoZYyzhZEdRWHw0dPq3HBOoZng9rMxnmydET2s5DG2GUWC6Kijj+0Z5vF35wA/mYnwMebPl1b4pcCyEw+ZM9QX8d+v+QC0zPJ2OpF0MDcbRGW450PsXU/piQYxdCz9QsErRewYsfLiQkQl+vfcbwGBkm3ICeBB+9M90g35bHsFwKbGsHeb71PX50uG62QvRNffucbwRKZsHg/dbRKC8JyACBObVWBfCnjjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uB8JxsTiF9rS8GVOnoXsC8O6XcScnXhYRzE64mek0nw=;
 b=HMV4oMGYmikubiir85W3CwQKLNclkVTGTqZC0QzkJNZxP5sWIeeY+Lq1Bv67CyTKhdKLExRIy9zT9qWIGpPx1xhJtdirjmThHN1rpjbBFyuoAKM0yqLBft++mWC5xUdFdPmGbixua0FM8I4I7rdl3aGeHE35mjVIjcpEWsn3Q9KGYQBoC6FPhBIZFhSHseWlPUFqeuT2jxg+HchUTlmqkbF15vDmKFQGmbJ3KhedYJbUBnY4JZMRrlBvu3N44qI89JqXEejhgiq6R9WLl5WO/mEyI7gdXCrpCicmlDh+WWnW9EPO0HaTFEPqNMTjG65FpAIQ9IFy68uLxPObsNUUEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uB8JxsTiF9rS8GVOnoXsC8O6XcScnXhYRzE64mek0nw=;
 b=uR72CqeEADcziYqdsu2vn65wPzXWVkKwhpB9QsY1yVdPLkj/e1ku4Qg12xu/RqxS0cEKoXHhdzNLanipBTWueRKa65WShRBUL6Ut696y7MJyE61AWE+Wbj4qJaqISdNJwFYR4FYfIdPXYpbOJ++8hI0jl3KC9KWKhY4qPHfxAJePEi8PSqUHMFf9wLsQSfeQzONTFBwuu4mfBq/0JnlxgTlKoKGztNG3IuRm3inK3G/IcdroMrk/EWcVBPqqh7OoEVOFggBIDprAiw11dTwgCJxVBafO/1sUhlMy2lca+V02JBDp45I16V4sBFIZ6M0j2ncrTeJ6+tVHz8Khwo1ihw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5131.namprd12.prod.outlook.com (2603:10b6:408:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 10:59:17 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:59:17 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 6/9] bridge: mcast: Remove br_mdb_parse()
Date:   Tue,  6 Dec 2022 12:58:06 +0200
Message-Id: <20221206105809.363767-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0076.eurprd04.prod.outlook.com
 (2603:10a6:802:2::47) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d1fd7de-3d16-4a3f-878c-08dad778eb73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nl9vRIEBmUu7jWun2e14cN1bweC3yEvh7zuZBg/oFk608f9dSMNgmDK7x769F8JgXjQNfCFVJQLalxaxtXeli9+YxZ7HkyL+GzLIm953qyI9ExRH+pISDN6ktoGHikMVN35GHzjnDdQJEnLfK3azX2uNyL0KQajaw6GOKf5IvB9Q5jA8D8ETnNQ+D5894JMs5y2i2NCpmBGNjJJPzazj+I3MgT7Oe9oW5HUMLJPIqP6IsfrwcKtF43hwcRWvOls4+3mtoFbsTIfKqeEpiDKfe7QsKv2v8fJELvXWEos/vX5Ub7bJ5pIHEacQr9gUK3Q0i9RE8ld9q2BOZ+Y8uDt/gA7VH60WJL6klL2MnUW0+p4dzMBEfq8ZPxMg5VbLGnBWY2AkVkFptaWfWRKNIekuWYMdet07EL72tNIDzjekOt4zQnrIw8j5DpsKzwd8vM0kALmIOu0caDRQabejMWEjUznUjANYc+wMof7tpXxvxn3hc+M1ugvgUlWwqZwkLv49xJPKvd8VVGsfpoSjl03HlwnsrP04WuLXAwgl16YrM160NpE9YUvHVZqJPVawgnCZcIqsLs2tHeAXSQr6GX5CIcR/qNXQRGIQnJkRGBH8GlQqHhe7QQSUXk/2jdOX88pVXN5n7INOE0VdlKmE1UKeZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36756003)(86362001)(38100700002)(6486002)(478600001)(6506007)(6512007)(26005)(186003)(107886003)(8676002)(6666004)(5660300002)(4326008)(2906002)(316002)(66556008)(41300700001)(8936002)(66476007)(66946007)(1076003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X8zzrrfGtF/hMZQk7/pcLlI73oOJN86L4hXMGjszT8jLUTL0BNH23BeR2uGO?=
 =?us-ascii?Q?61HUaDDj9iJaX8O2dRIfEtjCJgq2g/RgRB8n7ugIOqS74DoDqWBaoJOuYaV+?=
 =?us-ascii?Q?rCRw5eKj0Fcis3cVt1djRb1Md/uYvG/V+s/CdVOpg/JMMN7MOj4l1sL3TPNT?=
 =?us-ascii?Q?J3CBTRwFUv2PC7R3ahdE6g/DK0tmMK83VdRlIdgugFlhHX95S5kypAA6ZBUG?=
 =?us-ascii?Q?yDsSNJEvMPCkQR5UfDORhd9LwXYBT+WquZik/4GrCzfhIUz1c7XtA+DOQfbe?=
 =?us-ascii?Q?ogfGdQ+g4yFTH/c88BYfPfBTZjoYA3wBNpN0Rz9aUFF9YkfabmpfTawwd0mF?=
 =?us-ascii?Q?t68EKK43unjwD27eOjjqqN7/3q0JIuv/tiZNQCmGg5/He1ujpBZK0/UPZGt0?=
 =?us-ascii?Q?tbMYNxpUumicxZq9/DM8U5/e8PY6DHetwWLkttcfVajqiK1iB4aW/mfiAtLn?=
 =?us-ascii?Q?pyZ4YpUnsp1n2acA6oSA4QYwYjAwRj25j03i2UpKHFxVpWy/pAb6LL65/Vu2?=
 =?us-ascii?Q?wKzD0u20lIhsx86ApBs8DugkDTf247xRr2HRPythZ1dPzhR/Uezrn8ubUUlB?=
 =?us-ascii?Q?hulsdrCNp+XR64KYH9xFDUhAuFw664lQvXAUQdy+D3NNq/UFwsPUiWKuvN01?=
 =?us-ascii?Q?XZhDc2ePekU2cxlu2DYVBHwj3iJx4iIIiHpcsWp6hjlAyb1SPS7nrgohrdxr?=
 =?us-ascii?Q?ZLDEgXNYx8w7TvXW5Gq7cVIHEV6NA7pvRFVYs3ZG/ki7HFQuhaNpdJPyF/kB?=
 =?us-ascii?Q?+b7jtfFSEKfs71ivAw8yHVG+7tVhFMGETHWPEukIH36yLShoxrbvZu7TzjRV?=
 =?us-ascii?Q?Kz1nV9eR0KpVeTiCPChd+E+jwyHsXDzWD8SiJCAn+PhB+gdhS9IbKXyxd4jC?=
 =?us-ascii?Q?NqGLMgkTXZg6L9yF1X2sRaDNhjsQVuhZvaDdzbh2e4uUwvHmeNhHkA+wLMqP?=
 =?us-ascii?Q?eSyhKMPt93/1+Yercfc9GGD3HlEI0tmcBSifWHgjJzT8o0vbWEnmUiaZUPV2?=
 =?us-ascii?Q?+yhdajNFjA6traa51DNdmwWuPajRFevrccuKl+8VX77d61yyel2l3I3yYqDD?=
 =?us-ascii?Q?fpfW79TH1AAJ77H/b4m1l1FQIk8Kta/R3ZgdFUbMum6DJMozNOPHRvusfq7B?=
 =?us-ascii?Q?9xSAfN7G5fE05nfMmae5+scweLHBYCxzOoIHPcT9LsBV9l0C169XlKMHa1V7?=
 =?us-ascii?Q?z1eOhxQqzKDf5b/QMTCGvP9SWrCL7GbUhXRPu9xsjG5WMBrKwvtggE0EGjDA?=
 =?us-ascii?Q?c0vTvJJTaYd8YsxLbONQEJYzv2fhoJilj/dpmjW/+1l62VjSAwFxnDOj6Bq6?=
 =?us-ascii?Q?FpsLPBgFvf7qhePX3uuQKJsAew+qRgOPZM6xXXfdrEqEbiKiky4XL7QMsMgN?=
 =?us-ascii?Q?7tQ+vC6utANaUSV915LQaOIyOejphUhbl2fKd0YQ6oHE+yK858I1MyTmnJaP?=
 =?us-ascii?Q?84KbCes2cQ4qjbkGw8o46edJOyDIzQMXhtJ90psIDx6+7jX974ww1JFH9x8j?=
 =?us-ascii?Q?OeVvyC4e/EW0yuv5yv4j1w9Wgcwz1+64mrQbEL/jm77I4YJkZ5WDYqPuVIpD?=
 =?us-ascii?Q?+ImUQ0vVeGDhePk35Q9GuTCx6F+4tKvhPkT5OLb/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d1fd7de-3d16-4a3f-878c-08dad778eb73
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:59:17.3391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pAHaHjOkd01WztSAGC9GkC8bvLKSmErkoi71Bb1WSAjKb4QvkDsVunnt08c8ebvxKE6qZtwfWzmJqmXHCriO5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5131
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 93 +++------------------------------------------
 1 file changed, 5 insertions(+), 88 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index b459886af675..d0e018628f5d 100644
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
 
 static int __br_mdb_add(const struct br_mdb_config *cfg,
-			struct nlattr **mdb_attrs,
 			struct netlink_ext_ack *extack)
 {
 	int ret;
@@ -1084,23 +1016,16 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
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
 
 	err = br_mdb_config_init(net, nlh, &cfg, extack);
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
 
-static int __br_mdb_del(const struct br_mdb_config *cfg,
-			struct nlattr **mdb_attrs)
+static int __br_mdb_del(const struct br_mdb_config *cfg)
 {
 	struct br_mdb_entry *entry = cfg->entry;
 	struct net_bridge *br = cfg->br;
@@ -1174,23 +1098,16 @@ static int __br_mdb_del(const struct br_mdb_config *cfg,
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
 
 	err = br_mdb_config_init(net, nlh, &cfg, extack);
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

