Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5C26423C8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiLEHoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiLEHnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:43:55 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A91214D00
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:43:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luixcjMmCEdH4SbCINBvyZAwg5LupnzMBeRgvx/DUYYs/lRet0MDU+Sio7J/DEzmJtZWGgRQRFc6tqBW3bHnR9tcBvmEXCc1DTXSxyxsPaY4GgjTuS+VSBUQdWEhn7ILalqmN47RxOrf0RwfqvpOZ1wbWkP4Hwlt7b9cwssdVftCKDlk7+M0oPNKG/kIm9S8mK7JKHjvbmo6W8sp/gnOM9HwHVhgrUkXmMyLWrj9aSljOd43hFMWA7vKtoFAyZicPYI29RmDtfDUrtvGaIWCbdIX4u/Ati0JcPxpk4qAA+D+mnYNofS/lSb+lruAUmWxgZJJomWpVQj/IyMUiKHcPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RAJY2CjoYY05o8YbqzrUXnRhRr9qjw5s82Fb6RBkow=;
 b=LZvZuB2Mkz8UWWq4S96swuweIBnfzs92lv5Sl+MTsOneafad4xSa0L1fFW/v2G0wV5pUAbtoLm9abGS3FWITsERRAUpeq9JSiT1fYgqSKK0z7TaMj5g18AHl9nx5ENL2jyL5K8FEZdQhVplx0nNNWeZWhQcsks5UneAbWuc5qlMTwEp9cREdzCanzcHvVoGx9xiQz0LxCQXP9BdHZ5apl+U3wUYk4tkBfsnXcYc4CEH9PLa5PDEJvTKu7vNNpsC2uAnkcPEEmLYSxRlVGE3ELoXADHIXYenh0ylF0mw5Rt2RQFEfp17AsCEJA3+aZssTUGYbsgH2OceO9IrDEe22Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RAJY2CjoYY05o8YbqzrUXnRhRr9qjw5s82Fb6RBkow=;
 b=IYbWt7FX7qC/U3nNPROdVezjtAW2FKx2WxtaiGV7QRvuReD7Em6HqzDezSMAiJerrMvMImD97Z77iYpyIoqc552dSlAFbJJ/dBeg8Tr1DCPHlGL7iQxIDv8n02DjiZHN7O1QY8SP42w7GE7Ey3oguufllXRs2h0lsR5IPoOUp2Ifd0Y03ZWQKSo8b5nr0nIfXBEZ33AJfupvFW90KPNTz1dSBk4K/zOWIlYuagskSyhwy/l+XkCxRj3iDHHb6Z8UhVjG2eTcA9Tv5Pul4pIMKxHjBPZxj69ZkZZ/M8Iah4R+1s4se5clvmgy/nqYOWwcyfeQdWBrhF5JLeCygOUJ4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by PH0PR12MB5607.namprd12.prod.outlook.com (2603:10b6:510:142::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 07:43:49 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:49 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] bridge: mcast: Remove br_mdb_parse()
Date:   Mon,  5 Dec 2022 09:42:49 +0200
Message-Id: <20221205074251.4049275-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
References: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0199.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::16) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|PH0PR12MB5607:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d6b0809-ba9a-4a99-7415-08dad694727c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqulTcwvcSEZ5loauKLznQUSxk/vKKUnQIWDF6VpuZzd9TX22oUPuK85zGoJVQ5dLzbzA8cSpmm8A1OzyDCOJbKT/AaLaE4l+4B1T/bNucdt+Q3b0UzezJoq4TDakSXA31ITVxWvGdpdU51e4uL/C3ewhgSM6x+iWv+mr2JZ28UOVRzcsiCnn2Rr+jGrn5IMs7H1R3NG3W5rFMXQuZh/FI2jqyC2FBFcFuONyIdOIThUWYTV4sxEGjSJj16PzQv73qWVZ41R6KAJPrgDS1JaMk0IKBpHNr5oNzvywguGQTRpHREvS/FAtboV2oR/XyUbWuk9ATsbwbp8rXqZtKzyURhLz09gRoMn6K4pYfkjfZWyaaYKt7WqY27Oy/WBGku3IHQE/zPoTrIVfT098rFC/FeJoeghDLpWTf7vdHsHbiw7kjBwz6hMuHnvZe+MJNk68DjNXsrS9f5Vlmzs+X+q159uGW09qlLVz1NaR7CdMiPdxz3hkaXBQt0t6jScfhLDPGkB8WD3QyjC0VVREOgOkmREC50CpjZSXBo404DO0917KwjTuYcQ2I1SqAEoTIYu4iObcnSuUvoo30NAC8PH2qGyzYx5PM0SfQwLPj6s8xAKsJgFsQIzJ7+Yu83t6vDvGBEphDaSnXhHQOh24F9TtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36756003)(38100700002)(86362001)(5660300002)(2906002)(41300700001)(8936002)(4326008)(83380400001)(66476007)(66946007)(66556008)(478600001)(6486002)(316002)(2616005)(8676002)(107886003)(1076003)(186003)(6506007)(26005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?juWhlYrI6971Rcx41f3aQybBKvbo4ql/MlS5MPbqZk6rdXh+f7axbX+Y+ccg?=
 =?us-ascii?Q?L/it8q8RhvPmb9r5oxk33HC8IDsjD5opvLyiTWnlvFPKKMyn5JeSjXE99XIg?=
 =?us-ascii?Q?4ejZsMCdKlIQ4dOupbl63/OQVFiiksCnjQX7y1i4NsY6o6x+3+n8jVL2Kmt/?=
 =?us-ascii?Q?ydiAxPkFrHthM13nfz+2KrxNRt5vHb0vNMjJ86GRsIUvfDoTCkXJ/3WKLXXO?=
 =?us-ascii?Q?ByK5Za5eY436UguXavWW2THOct/uEkm4qg4u5QpHV1ALw2QdHD5VMWKl09RY?=
 =?us-ascii?Q?ZhlrmcL8xRxWwlAzawzd1GDDg8QDqLwGveJfnmAsf4vxvkDq6NoulMpqTL8x?=
 =?us-ascii?Q?KAYmIitt2qdqVPYA3UkSecjV5TA7qmgyLBgJ3YctSrU9liOxVUM9jLHRB8tv?=
 =?us-ascii?Q?ywMkRgKFaFlCl/XLwQo4cnuy7mj0eFDKlIDH1glifMjeXvRplWje3lINH9g/?=
 =?us-ascii?Q?U/J3IJR0wxPn/J1a71Uh9FyopyZts5x69CO+sWU9Tt68w2imjYoaXFkkKiPD?=
 =?us-ascii?Q?r51IuQ0In1OHH6m3ofnycEstgVkbVaiUR5T4lGjokyD72EuSSSiR0/TcT1z/?=
 =?us-ascii?Q?X7l9Vt7JU+JKgYslZk5zMhRIr2SR+StmdkAYNzanF7qy6lZII60nR98HESYI?=
 =?us-ascii?Q?g210LvoAiFyZf3xDLm3qTsCNOmbrmTYOLTmAQQRKJSI9GlqghUUjExhbgR+C?=
 =?us-ascii?Q?lzie2RHz1TqE3jAGZ4d66MWH1Oyn9d/LcV+bdk5GyZ6SCQqDPTH7M6fIvayw?=
 =?us-ascii?Q?pVN4MXVv/i1065HBjzw+wj9FuhLbc9o2/3peI7Jbbr8Hg3JjCNjFcbQfQFUS?=
 =?us-ascii?Q?+Rw43hRQXw+2yFbQmOgZw3BZUsS81V0u141r9gn/ZVxIt3DKpujeeYqgaWGL?=
 =?us-ascii?Q?ZXrS/nF/VHYgUhxTM24t7ocoPJCLAsY7ldv3b9uGHEGJ/uCKEgaeSrrpk7Mt?=
 =?us-ascii?Q?Hl6f9ed/+t0EwdtfW2NBO2kLWpfsFqGa2xZjb7/P0nknNUmqboN4exeXjZwU?=
 =?us-ascii?Q?BLQkjMKebBgm7BX6DHGKWSaNA84sD6/D61i5ryWxDOMIUfhIgDX1ythiFK0Z?=
 =?us-ascii?Q?axCymCMYBM5zShrwz6dKAVN5Rn1rbBIiQcj/TeJ4WQCllgAjrDz/h8yUQU5l?=
 =?us-ascii?Q?p62qOFZ7xyaZkjvwwrQjWXZE5kDf9zlmuIxOig2SvhywKrkwCm3pMjDwsj6v?=
 =?us-ascii?Q?Bt47yveZzt3CImkeYVqI6fVYZAVJ7LdfL0dPSr9gqNWwriADRjjdXvoQgMjf?=
 =?us-ascii?Q?2tFeqliMzsZtfrthJOUwFG3SU2L8QB6rMdPm5I06wqEUcwEhOOW8j1K2ZkNr?=
 =?us-ascii?Q?VteSQ/DUJO3daCJtZ+cneqa9TEpk9v5JOnDMIfFfYibMymfbb/BFYWHWDgZ2?=
 =?us-ascii?Q?GEZ4mjMfdXtPj1V1dZTHNmDwD/UeUnr85CBpwD+JeIKjKmKuxdcDxqD7d1hg?=
 =?us-ascii?Q?CGah5eENumdf0RCPhrztEQiBXF4i8C1ToiZR8Dwx0lVKWAoaXWyyumfd1Ei4?=
 =?us-ascii?Q?PRPr+XCJJ4Yz/zyv3vfpeAAEAq2Uo+8jrrtls+4pLTUkTfcZyH0tEwx2DXby?=
 =?us-ascii?Q?ghWhjqYrt7me/1uICCjEfbfuUTuDBsOn/jDEuhYL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d6b0809-ba9a-4a99-7415-08dad694727c
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:49.1702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /aQzKi/A6gJ2RhJTUV4qqocqmjJGjXeXGtWhtO9wSSrluXVfcApjPeqMuyO8+BmGLvRAZyKMFqODNrV9DILrqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5607
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

