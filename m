Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48D06602B31
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJRMGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiJRMG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:06:29 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2078.outbound.protection.outlook.com [40.107.95.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51714857CD
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:06:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmHTV2nFUy/QwZZlqmhLVwODNwRABta9ndCpK4D3zEuQUXwAtn6SWN9mElcvj01oMQkMGZCha27usDwv1ITj2C3VlFvA7TNCYybkZyHKQ+WtGZ5vthlV7bXeWxkAdYevpPgpEqFszyqXIFNiU6Dk/6f7jLimvfO0a86itAGdRPFpcnBMgCdR6pJlEfTKtm44V0qtoau5ebEOW+lGsiCzwS1B3x4cW2xJTq1hxwBc/R7EkVk4mWKf9NL7+II93M8V+KHaTxaov1NU1hRaT04Kfn1SP5AUI0G8J7gVtfdYB5Jo/+vXzMioVStwqJ+WgxJN52Z7WBUEBavN/bVNEzoSLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LS08SDBcm0E5A1mjwUl70ufffCswPuEUR1XQdVrmOHQ=;
 b=Rt5snNyozBBtg0y43KqwofHqkXAp/mu2704Y6bOOIqUUTuoAekrT4X6vO6ffwWHrvo2HUkXGpiBIWC3TkVxquUT0YcLnsUudTAJ7IKyAJNuSjCJv2h4aPPJ6SIn6/+k35CeTmOqLHz9gnxks6X5DZnRpesTKCDXZpsM0hu339t/rfsh71WSDeg9JtkOBgOGGbKZ6i2tFkWceWuwZBl4RRCTLQLv3btWQUjL/k9ajGHX0pn/KjyBG58ErDAS5unuKlR/7jz4hmBIuqFZYk+LTk+syUhPRNpkgH0G/s6utUyvrVdvUNr5EPDq5LblIMbfT3FrBPks3CnLkOByO6FM3xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LS08SDBcm0E5A1mjwUl70ufffCswPuEUR1XQdVrmOHQ=;
 b=nfO/Fe/Mfhrg73SGt3gjh6sWcNNODOoIqk/jx+xmd2MbbWqidTVC/oyCWPsLdvvoTVRI85ThlBjW8K5UPaYVdlKXsNAkI2As9ds8/5zt8LLGaxp2yCA/vkGyA8l79tCQG9+EF4Ff+1YRe2Z+7KEDnw2kn3tW9DKY1hvoVVMdYpmvD60ic5h6TLfTWLuFNuhQRy23ggX5IYBGY3SsSmi7DjkOqSpvMbVAolwOUduqjjaEEh6gLHwtNTlRYbEDb3H5usc7Ijn1To4pq/OCG8ldJdKMD2N5eT5vl59Eh+xDbaXw6B11+Iv+PXRzb3zM9R9d8Ii2SgYzMdX2jFcnZfWvBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 12:05:10 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:05:10 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 01/19] bridge: mcast: Centralize netlink attribute parsing
Date:   Tue, 18 Oct 2022 15:04:02 +0300
Message-Id: <20221018120420.561846-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:802:2::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|LV2PR12MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f0a2106-45d9-463d-380d-08dab101015b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0L/NBwpC4d2lJps6IpUOHN2/iso5P+7f7oOjt5rhKmMPm/38I3uo9+Qtnhx7LQSSH2+gJQafoWmA/n+w1Lc0fYYmpsyfzYusUIeDEJKfIleW2IBmIp+V67Yw6YBqkdXLHSuZB7net5QNU5XnGeayE8soB70SjQs55peuBQbp9AFG29FzlBRzp8CS8lnYbj2Ae7W/+n7zImF7V3q5Bit1FsazW16AG0663VKLfaKLu+mdao4KxZ0QHnt0H9Z9/e0L8lZWu6P3f4+xeJuTiPMd9XWClGqdEp5gPIC8lpMvH/+EVCZpv1r1LNcsRwWgTFjjOE++isw+F3HI5NuBodeXUKXpUttKQjgRIBxFM4oRUTE2q0596Wn1z5UlXuYPuT3Ld2WBRXvdVJvmt1+dgOyrqObN0psCkXOVRIe8dNNXmYMI2we3Tphm0EYlSA6b/7/dHN5sjQQMTVxSXHfDvCcB1cqdfsF+mALK4VmFEWzX71PuhgxggdxDVKI2pQO9xlqoZ+zvkCduF0K5mXefxQ+eY+Nijq/jgg9LXpJCdnk1LMcAQaRqcx08Mw9Iw/VPgUQHTOacRnAGqXEP+mVKfFeaUDKAFqmo35suasqZ1Nx6wFQHGGCPo+9OEtW2VZ+wHZYM40MX4WVkwtt3g4LyUjddzKTExqW7ad1uCCV6OdFESGFJKNRV2GpVNmxl5edHSoIU+9LOpDo2ER/mGDWSalZAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(38100700002)(6486002)(478600001)(26005)(6506007)(186003)(1076003)(2906002)(36756003)(41300700001)(2616005)(316002)(66946007)(66556008)(66476007)(86362001)(4326008)(107886003)(6666004)(8676002)(5660300002)(8936002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RGfVtGSJ/Xq3bSBnGz7V/7Ca6KcsJ3rLMq50nuNDa7pQylT8LPLi0DeaiaeW?=
 =?us-ascii?Q?Gm2lD9GTNMReEOj4P4DngiE1sDacNiwlKSQojs+JhKZ5ot1kopI39ounprjr?=
 =?us-ascii?Q?3R3Vws+gkkJdI0d7OkhkK2h/YI1v4QrXPWiM8qcdDgtT6wNKZtQukPfutGv5?=
 =?us-ascii?Q?Rdl1GkLsVUY1MiKYHROD27PbCgJcCXjVUBEEaVNmI98M3LACoMyAB01MTlUo?=
 =?us-ascii?Q?Bz1qTGION4y+1w+U2KHyRtJhRFSJLg0E56BOQtooLFwJQK9jxg1+tBZ6Wtxi?=
 =?us-ascii?Q?Z77Sc80oSYWFXZ8mloPjjzt7WUyQhyPFVNy3ZkI4w0IHf/CvNBwbYFmNL0lI?=
 =?us-ascii?Q?VIOGiQln8BvD16exhZwJQzCfMtDEsjEj4VMWQQ71U2lINUsfNsu93FNvfEPt?=
 =?us-ascii?Q?+lLlKJDG7TWXWOcAstsI3vFsQs+5dn10xzi5BdFplCqzN3kpCLEd0Suwd6xY?=
 =?us-ascii?Q?W7oDUvirXc6KDhxbg3HrDrE13h+RtT5deonKGtsldHbvHYvfLDgXdkFpIXAU?=
 =?us-ascii?Q?2mAzjKkTmC8BypHXKc+c5gkR4jDvU3P+ZV/cgnuPfXnq0hzwPq6YQTSDWntg?=
 =?us-ascii?Q?FQEqReBITgX0zNQso8kK2OR5pSbuh6n7Sy/+5kHyHpuF1ZaWfHljeDrtseJi?=
 =?us-ascii?Q?fNtepUcchvV3Ook9swJ+1GSRyDDz9pSN8UMwjiaKqqeNhdlKRO0UqnxkwMSx?=
 =?us-ascii?Q?urQIwaVfUfWQ52CS+Uy5ASwM+Qv1avNWQQ3mv4kSyBR5G+RtQdERnJGCx3qt?=
 =?us-ascii?Q?0FSuKYHcgFQhopv3EsHxRmHNOpuX82vFh+eW2Q8/QbYr0neRUaZFk5zaaP9A?=
 =?us-ascii?Q?oATpl/zgl1aU60paJ8IzFRXxISGOvXdOGAsU5O/BttlHPxekEYzft20Lqles?=
 =?us-ascii?Q?W0vSD15eOWCyeoqkw1b7jaDaX89FZoNIh+1J2mNoxT/tFMko6tLaPbD3AobG?=
 =?us-ascii?Q?RCkj2pj3WhhX7rvjFe0dwshRzVpOv+ITG9VnRfgzVyzXjU4D6FTZHjmw2ncC?=
 =?us-ascii?Q?+yGT2+NWC7aMzTbx6O3YiobZIJ4LBcB9b3iDpA5cjpwhmwLzMu47hFDwhvuZ?=
 =?us-ascii?Q?7WzbymwbVgMqKiz36diuFvicq6teRxnAYgCBf2Jf60Xn0TtBdl/VPiSxfOfc?=
 =?us-ascii?Q?lhfgXaFrWSEOFELUnOOn3HhOYJrvzFWGmfYUwmMCehxEvuR9E44t1XKb4Uor?=
 =?us-ascii?Q?wHhW/9GytZykUVLcnbYmpm3IX8SisIJQZAAG6PDggX6TO1YjNJX3fP/ix5Su?=
 =?us-ascii?Q?j56Mokom6Wgu3cyIrXuhigjFn+dzQv0Y7UH8gBky0cs3NQF9up11mW80I/08?=
 =?us-ascii?Q?o6nx1yROeHWYyUcjVa2xjRbyPKIA/Nkt0CBVfCqE4KIAqTZFERTWf4iUylIh?=
 =?us-ascii?Q?319heU5MREHgrbmHY9feFh0vG4jIm0TMGKvF6ts6FFvi7AohTSXg288MY0Dc?=
 =?us-ascii?Q?vC7DIZUVDx+AJEdCY7+GzdKTPqLCRJP6ziO0DeSJ3C/1DBQNrhXvS/6e6com?=
 =?us-ascii?Q?nUUHjKaIWMwXd6el+skDAtRJUwpomvj/UXrl5K26Kjqok2WIG2+UOjwF/oIH?=
 =?us-ascii?Q?yvrlcW30zMmX+6BCneE4jzivZmojjWUdV8KFcc0b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0a2106-45d9-463d-380d-08dab101015b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:05:10.3903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MU37CChATBCXUXIe9G0AbEgs3+HKR5l1+9FJ5UgfoG6rRRRtV3A1ZvmRAhO7AJZ4zzmT7JCyBLNAgHUHW+23A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5869
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 06e5f6faa431..278a18e88e42 100644
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

