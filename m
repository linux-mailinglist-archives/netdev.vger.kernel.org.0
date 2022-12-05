Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766396423BD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiLEHnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiLEHn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:43:28 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76C414085
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:43:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jp7qc/jAftjBCZ53oLttzr1NPB00fA9S2EJww6eHu0mwS54XRqH4I44k7PJkmI8cVdaTHR0EUbZLnXXC17tCkSUR74I9FtBt0nffxpZba1As3u7qPmDgnbxxehsEZbETuKRPl+/vucVMPR24Sfd07p/BiPEkxNf60WKVM/0OKwfBAGc3122zUCaK0wOCSkvmJzzlLODCCQCC3JDGclBh8yv7ulEqdMZPRFtszhXALvSH1VMR78ItZYr+MmMeeQLrDv3+1I7hvYKcsaHEY3FxitTypK/VTchRl6VeRap7bNHnuzr7/sTOMixlDW8F/xwReZZCMAzICiFhkZEKE0ATTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMpP8zlpQO87u26lPL/PG2QO4xyXn4+JrImwc8Loh4w=;
 b=mulV290i6a0O0NhJRsoXuqWG6bsa7Mp9shKYgp5rqQxbEWfNB1jIiVH2xcFBQkRrQT9tS7rqoNSaOxo5kPwNcnNNBlKLHursPAbWwimGDNRjQRcbNe7IkYSmG54lMXcVSu+5NeTj9U0KFqknNDgWUHY2OHhpwkiFDwyNol4JpIDwL2MU+DljvUaNXoJ783SiUehvE6O/NxFFYt1fTMqbm/qlCiJsumA/0Ck10CI5dHfgenjI5W3AkLy42OHv1OGPVcxFJhmO/zWvwvz7liaJ9ZgGZKhMg0eUqj0CWatfdJw//MkKv6YSylXglcclweOXURpV214U7W2lpDwzT4UnTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMpP8zlpQO87u26lPL/PG2QO4xyXn4+JrImwc8Loh4w=;
 b=eik/9BkQJmZSs19Ckd4talOAYcOjVyS98swrPLUkuhxYk+rOg6MhmzIAiU0n+UDqYPl/Ng/zVMU4I+f10kiO1K+98AgAI3H7x+y1fIJO5qt9fsVOEkKuSUehz+TF/QcwmP1t42Wbs/3KROnF2ykzYocVbMwh8jmQTqaU6SMmzlz4Sz8ZNSMAoL8JxL6hqm9bNS/PHD8lIxStmNoLD6BDkmX+NZRjFvBG8gj5b90PhYi19FNGyIrbh0wo4zqndONEWigrtGSFf3YTuPS2eVYnhksCN+n+8Vfokue28CsB2ZyqVRIy17GPr3nkRbU8LluSV+lQkYwMvU4maMNVJHVq6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by SJ1PR12MB6265.namprd12.prod.outlook.com (2603:10b6:a03:458::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 07:43:23 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::193d:487e:890f:a91d%4]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 07:43:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] bridge: mcast: Centralize netlink attribute parsing
Date:   Mon,  5 Dec 2022 09:42:44 +0200
Message-Id: <20221205074251.4049275-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205074251.4049275-1-idosch@nvidia.com>
References: <20221205074251.4049275-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0252.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::18) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6163:EE_|SJ1PR12MB6265:EE_
X-MS-Office365-Filtering-Correlation-Id: 81ab1797-3aac-497b-c832-08dad69462de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /TvDKCC+lRLoCa911AiL9r6z4WJEWqwvMr41rjtmth2VOvHExmNpN+ENwXCgw/EPKkLxnihCnTA/HSHQ9uFQMBHXxfP3GB1IPsO2xnyRoqtZrVcGEjnIV8pmjo1/mfiCv4mpyDynj5slI6URlmaTrpPr6daIjA5Tm7At4SwJzwrhncMvWj4xzdzsl6BGWOWTe54ig90cMsxTMyn3BhnoEtvCsWb3xSSbl1YLTxzWte+EQS0reJ0eeUu7ahrgDjp+YdW1/Af2vQ2/3kgAAv1DE0knEF3pgEouRMxfRbiq1oNKG2aBUQW7eOAWgCJ7bzrS2CxxzWshTNcHcYdHddNXyDmYqsDvicz/vOOSC1JI3XbkASzcottdefB8LZdbvYMJqESBqLEft8kK4hXYweYrcjrQ3Q226ntYIpEkoHDzL6a8wr6e5w1lKkEkl5whDtS7/rNC827nfyteRPj4NfdaZZD5F0flSB4+PcZOuNTEJwXXJXjiYPD2KxeqgHPtjM4IrnSOh3y5AHf0rNXcHtVUp5FuDdXkSf/sokolRa8k2C6232sO3UCAQljCru8Hb7GhvTCiDiqirM7/OIZx1HYrcG0HshjOFwvzSV4h6V+Gt+BhS/5OZBNItBPG4a3kCFERuzGEMQaUYzdgD4+XmsfR0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(451199015)(2616005)(1076003)(86362001)(2906002)(6506007)(5660300002)(186003)(6666004)(107886003)(316002)(6486002)(38100700002)(36756003)(8936002)(26005)(478600001)(6512007)(41300700001)(83380400001)(8676002)(4326008)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tEkJ2dZr5ICKoByrYUW6jfzY3PZiEJSmWhpEWQ376gymgRramg59PQ+y2450?=
 =?us-ascii?Q?vsoyay/gj62CfQ5g7Hv94vPG0YgmH+H6fxBo1FFzffwBu6JtfnrXaliOarBs?=
 =?us-ascii?Q?Be0TXnitpPM5z2xsQUyElmGwOqmuegImpmtVhGX1TtzzT745kN0rSRReTdq9?=
 =?us-ascii?Q?YhjXML2nR8MQBzLjsPDquk8fdvQp4l67buw0BIyioBuxZnjVxnmAcU60Ydw4?=
 =?us-ascii?Q?5NvStyafwcjWcm7ra/etCZazFZAartHZtgTTfxAy+jATMEtKg/vuChomDyOT?=
 =?us-ascii?Q?BD4adIhfa/zSTpAMWcVilaztXRyuPy+S+DhH5VkeiTX8Bnl9/s1HkUjyTvC2?=
 =?us-ascii?Q?X2gYFZfK4YTUL1HCi0BD/t7SKXlqJ1hqqvSf1B99pPkCBKSEwwXg4hfRHNWQ?=
 =?us-ascii?Q?j4YaDlQlK9Y8Z06Mmgf+BJqe8x3duteShjrOyYRYzoIRosfeSkLZCXQw4IBV?=
 =?us-ascii?Q?vgtS426eU6EBnJBr5nScfVKOz0A0RmETekamCnddAOa8acP3V49G6VJHeAJF?=
 =?us-ascii?Q?AeCSxkswz2nx9Cv6GPEKwE+lGmSIft8ADSiVgZZIp35/F5F0aM+ZbIM5iRkt?=
 =?us-ascii?Q?CwToU5jJHxdupzvUu4HyukstnSU8sCe37lU9QcKJZF18a2B/469Jxh5KUVXE?=
 =?us-ascii?Q?dgqQ9nWkmByBuluThfZXhHnXTFWcJOVX//yLQhqlc4Sr6ZfqLNfATKWZoUXj?=
 =?us-ascii?Q?Q7vIMxP5WzHhUVS3K09/GMDVVF+rGtOxlLVAsdcZ6cCdotagrIujglNYsM0P?=
 =?us-ascii?Q?jQSpTtxHlDALwsugNXhTzCuNLeMcLd0RJpybtBtLXs+V6Q9QB7oN2XpebMro?=
 =?us-ascii?Q?nUE6axitAndURfTIu/cfsm51JW8FfGx2xSxIXAyXxmEo8YvhyRe42kLYYkde?=
 =?us-ascii?Q?aEBfNoB9e03dnjEilIXXku+e6OiNWeFuDDjTCYJDcISeYi2fY+z7jaaxm58S?=
 =?us-ascii?Q?w0Ndpssw2nx3LteymPC2vYHeugNZk4KDustqML02kocAMLIZGdHJkd6sKhjm?=
 =?us-ascii?Q?89jHaV9IBVKQB2M2mte7ZzVsmnGgBWOIONFezJHCIguyC+7MbixGZM9XzJyI?=
 =?us-ascii?Q?UmHaCpjU7h5neuUu8MVKGFABeEJcGrhjba9giB/lZ5QxnljI1buQJ7opjyEh?=
 =?us-ascii?Q?WevK7wglF6+Gy+eH9dITBaw36k5Pwg2OznHZ+jNdMBIgXGaZz8gwvxmOiton?=
 =?us-ascii?Q?ORGdK585TTB3R8Lvq3reogIf2rlDG+mGFAu31gFzezSUt+xh9QPdlTCB/8Fy?=
 =?us-ascii?Q?yo5YmsWlLYNnCeLVUIWK38M+Jpgn/K2DzB0rOWoyUNA2RCq24FRRThdDVnAR?=
 =?us-ascii?Q?K6DJMpuyvitfRKV7QRJTH69SM7WW6LV8bqeQSYpP1r/kiXHExRcGaUyHONdy?=
 =?us-ascii?Q?rQuCGU9pyxwXFc+VdPgOQij1t/WObMYdDN2l+xNyx0qfZxBjy8mbM9AevJi8?=
 =?us-ascii?Q?17JPKwam2RMzIQF5B/adXm0QgIBDQZs/r2qJuROA84PWU9Txz2s/hpgclPwM?=
 =?us-ascii?Q?2ucB/wB54qiCxEymO2ZBEYEkm4Q9AnoTqSbF0hhxGUKuu553/dTROwHK/fUc?=
 =?us-ascii?Q?/FI8A8ngv6Yt5lnct79nUp6Sy7RVtfMaBVHtyPMW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ab1797-3aac-497b-c832-08dad69462de
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 07:43:22.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6E1scrAYlxRbDfjQc4zKsIhCEiZ8DpL3k0dhMIgXS3qMopytGKDlvfftwsiTpfydw+3KipeHjoFh3Hl4JNLhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6265
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Netlink attributes are currently passed deep in the MDB creation call
chain, making it difficult to add new attributes. In addition, some
validity checks are performed under the multicast lock although they can
be performed before it is ever acquired.

As a first step towards solving these issues, parse the RTM_{NEW,DEL}MDB
messages into a configuration structure, relieving other functions from
the need to handle raw netlink attributes.

Subsequent patches will convert the MDB code to use this configuration
structure.

This is consistent with how other rtnetlink objects are handled, such as
routes and nexthops.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c     | 120 ++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h |   7 +++
 2 files changed, 127 insertions(+)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 321be94c445a..c53050e47a0f 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -974,6 +974,116 @@ static int __br_mdb_add(struct net *net, struct net_bridge *br,
 	return ret;
 }
 
+static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
+				    struct br_mdb_config *cfg,
+				    struct netlink_ext_ack *extack)
+{
+	struct nlattr *mdb_attrs[MDBE_ATTR_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(mdb_attrs, MDBE_ATTR_MAX, set_attrs,
+			       br_mdbe_attrs_pol, extack);
+	if (err)
+		return err;
+
+	if (mdb_attrs[MDBE_ATTR_SOURCE] &&
+	    !is_valid_mdb_source(mdb_attrs[MDBE_ATTR_SOURCE],
+				 cfg->entry->addr.proto, extack))
+		return -EINVAL;
+
+	__mdb_entry_to_br_ip(cfg->entry, &cfg->group, mdb_attrs);
+
+	return 0;
+}
+
+static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
+			      struct nlmsghdr *nlh, struct br_mdb_config *cfg,
+			      struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBA_SET_ENTRY_MAX + 1];
+	struct br_port_msg *bpm;
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
+				     MDBA_SET_ENTRY_MAX, NULL, extack);
+	if (err)
+		return err;
+
+	memset(cfg, 0, sizeof(*cfg));
+
+	bpm = nlmsg_data(nlh);
+	if (!bpm->ifindex) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid bridge ifindex");
+		return -EINVAL;
+	}
+
+	dev = __dev_get_by_index(net, bpm->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG_MOD(extack, "Bridge device doesn't exist");
+		return -ENODEV;
+	}
+
+	if (!netif_is_bridge_master(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge");
+		return -EOPNOTSUPP;
+	}
+
+	cfg->br = netdev_priv(dev);
+
+	if (!netif_running(cfg->br->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Bridge device is not running");
+		return -EINVAL;
+	}
+
+	if (!br_opt_get(cfg->br, BROPT_MULTICAST_ENABLED)) {
+		NL_SET_ERR_MSG_MOD(extack, "Bridge's multicast processing is disabled");
+		return -EINVAL;
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY)) {
+		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY attribute");
+		return -EINVAL;
+	}
+	if (nla_len(tb[MDBA_SET_ENTRY]) != sizeof(struct br_mdb_entry)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
+		return -EINVAL;
+	}
+
+	cfg->entry = nla_data(tb[MDBA_SET_ENTRY]);
+	if (!is_valid_mdb_entry(cfg->entry, extack))
+		return -EINVAL;
+
+	if (cfg->entry->ifindex != cfg->br->dev->ifindex) {
+		struct net_device *pdev;
+
+		pdev = __dev_get_by_index(net, cfg->entry->ifindex);
+		if (!pdev) {
+			NL_SET_ERR_MSG_MOD(extack, "Port net device doesn't exist");
+			return -ENODEV;
+		}
+
+		cfg->p = br_port_get_rtnl(pdev);
+		if (!cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "Net device is not a bridge port");
+			return -EINVAL;
+		}
+
+		if (cfg->p->br != cfg->br) {
+			NL_SET_ERR_MSG_MOD(extack, "Port belongs to a different bridge device");
+			return -EINVAL;
+		}
+	}
+
+	if (tb[MDBA_SET_ENTRY_ATTRS])
+		return br_mdb_config_attrs_init(tb[MDBA_SET_ENTRY_ATTRS], cfg,
+						extack);
+	else
+		__mdb_entry_to_br_ip(cfg->entry, &cfg->group, NULL);
+
+	return 0;
+}
+
 static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		      struct netlink_ext_ack *extack)
 {
@@ -984,9 +1094,14 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_device *dev, *pdev;
 	struct br_mdb_entry *entry;
 	struct net_bridge_vlan *v;
+	struct br_mdb_config cfg;
 	struct net_bridge *br;
 	int err;
 
+	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
+	if (err)
+		return err;
+
 	err = br_mdb_parse(skb, nlh, &dev, &entry, mdb_attrs, extack);
 	if (err < 0)
 		return err;
@@ -1101,9 +1216,14 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_device *dev, *pdev;
 	struct br_mdb_entry *entry;
 	struct net_bridge_vlan *v;
+	struct br_mdb_config cfg;
 	struct net_bridge *br;
 	int err;
 
+	err = br_mdb_config_init(net, skb, nlh, &cfg, extack);
+	if (err)
+		return err;
+
 	err = br_mdb_parse(skb, nlh, &dev, &entry, mdb_attrs, extack);
 	if (err < 0)
 		return err;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4c4fda930068..0a09f10966dc 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -92,6 +92,13 @@ struct bridge_mcast_stats {
 	struct br_mcast_stats mstats;
 	struct u64_stats_sync syncp;
 };
+
+struct br_mdb_config {
+	struct net_bridge		*br;
+	struct net_bridge_port		*p;
+	struct br_mdb_entry		*entry;
+	struct br_ip			group;
+};
 #endif
 
 /* net_bridge_mcast_port must be always defined due to forwarding stubs */
-- 
2.37.3

