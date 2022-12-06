Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510FC6441A8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiLFK7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiLFK6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:58:44 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F052228C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:58:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bl+krcfwEhjiUcWfzpqvP7MPC7h+8ydbseVakV4aiX3WzRYCmDzaGw+uHc6FYrA79O6JBd9hY4VNDU6iKL8NMmN3x/wQ3BtO75UUkMq4PGebT2WlBk+VrYCiOjf3sZ182kV4B/7oQuwT4a9VMYKtxYFAujusC5n52Odbvc09DBhTWYNhU4EnKP9mfXg7nVzip4CNNZKv2gcDUo7smGxNqC8ePPs2Lo2xnO1YMdnrVrYDaX5+8dhvRuUAFebpn7xK9dsIMQLo+oacjspbHyKCnjZmgAX6/0umAW7DiaImAWLXO//Oner9yLbu9xUR0VlH/lRdldX5w41M6V+LsmK2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhzMinsOnZIvpFDMO8yvvMa57KGkV5CNRbqbQ+fgRsY=;
 b=kPCGWYaVeQlWfGFMII+g5/9kZG9bBj4au0IERrZW9o7IZ/iCYem1VNOfvEOXSxGYPbN1+mFUbUenGA33MQmccca4Rpzn2D/d0YTkJl95rQOG0VLr/vu2ROQZHdZjlsVTESQSgv2P+Vel+0YYu2ECQ9vU7BVM/VPnho1toofQUi9WhhNy4zEhkXEmd7GMOban1TkJk2rK2etU0yiVHMY/M3gLwWA4CfHCM+X+AQzFRcuPC8gPUj1Ihrz0SMxCYSEpgsaY3aoveleSM68oWtC68xE9iNbhU5b3C1t2Uea0GSJWQ3y4EYyKO2Vx/G7egdDb3sm0jxR+48iI2YX43pAGHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhzMinsOnZIvpFDMO8yvvMa57KGkV5CNRbqbQ+fgRsY=;
 b=fE8FaS+zZvwAi+9vBXMQtY3ow60gh+Gb2RMTkbOCvWLSLTCFVQ/tQ7VRa4NGB9SRs/NkNJhZHLZBidYZ4kd13p2gus8ZdvRya/JluZWKrXYb8jMU4Hbk86kfI7Uxp0/u42mULUB6KZu9k9jKyE7ZNOy14Hryk6VU6+slEaA+QsjKULX9aVpK8mliN5BbjQg5fqGZxegZ1b7Mn3OOIaBcVUNj3RApbeJCSKo7c1r/rvthRQT7WlHVurkyIETNjVOj6jzrQz0MgO5HG5ezVVFJGTVllUPb+hIJr6H1n58HcJFD8G6wNdteJqn2X/bWVDpaPybSq4947JkjSgBQ7PcR2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB7100.namprd12.prod.outlook.com (2603:10b6:930:60::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 10:58:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:58:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 1/9] bridge: mcast: Centralize netlink attribute parsing
Date:   Tue,  6 Dec 2022 12:58:01 +0200
Message-Id: <20221206105809.363767-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0033.eurprd07.prod.outlook.com
 (2603:10a6:800:90::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: 381a5683-41ab-487e-5b6d-08dad778d649
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qQKPLDl7T7XaNhrO/2AS22ctBV2V2YTLQSyrArVcm1c/8RYgZ0potZlcfWJrdT4xtsgjzr0vlFbnLnh5fmEUp1P9b0/p2+54JE7jmxsMALMUwPDZLRgvKwdbNo6qDGRjDSbs5DK0EDGOWGzFg/y0RFkz9/IJWquT86E7OYG08cXCyA3p11j/OwNgOTXdfOd/25FgTOB+NbVMzXTKYEVgiL7/OGb2XGYAzfhPJGYyhC69ttnkcshKgoI6AJ2JgUWVTWTB5TgUppTvZZHS7O7EI/npB0///JaJvLiyGQJBM87nD5jBW/zP6aRQZ9vQalPb/U1rWWQQZ5m35IOvmSGnBl96Ez8cXcwN0tgfx6wRFw3+6u8oEWqqe9ww6yoR/xj1ZiUDLcQ+Nh6/jFQI2zJ+qg2fqrSCdLFu7MuiBey1zIgWPmp4sRJMMvCcpDRUSjG4yYWMu88d/28mwGymRAw5YbIxcuHuHjBYJKhw+TGGQztdEwaFmq6WPPwKwkiWWfEUMPhIme8st317SM93PWiXc37PwnQ80lnosw/74SR7vdESJf81yOVSkoutSeBuBOabLdSXd2Mqidd4gHqhZsSD/NEtEAf8oA51xGrT0CncscseCidEFxhhTFiG2bymVdKgnTPoCNTGp521uR1ZiaWNDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199015)(1076003)(83380400001)(186003)(26005)(6512007)(2616005)(6506007)(6666004)(107886003)(66476007)(478600001)(38100700002)(6486002)(41300700001)(2906002)(316002)(66556008)(66946007)(8676002)(4326008)(8936002)(36756003)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?APgu/i56kM8/WIR+cMS5QKOZwjspfXj6g6H4Pf3tsl4IZJh/2rX6F0d+n14D?=
 =?us-ascii?Q?Svk41LAgXLxThjG6Th3tkGGemICADC0i+deOS2KDoNVRcBcABLZe2uAB29vV?=
 =?us-ascii?Q?UkthGuMysM7/Rm9nBc2dUtVHAkdf1b1o0iKy2mGJ3lPnYovdCUjTb8ICYBE/?=
 =?us-ascii?Q?ZV8U5HEOG97nr8EJLHygUqeBhRbW+DHy+/cpfWWUsHVKc4mLvtP/Ul0m+JvX?=
 =?us-ascii?Q?Cb1xZhH2/jFiA130jYe3pQXf6hHBILAmSrQhgVjyvNbd+FnhE7qB8ns5Wja/?=
 =?us-ascii?Q?eXPTX7mFhjTK5qLSSikXrcG0YXU8K4hsimgnt0avx26rg2RE8vWoIN/SMkUr?=
 =?us-ascii?Q?EZ/HDQ/i2vN2QUsVV0Nl2htppap0g+zyUOniB+qz1PWt0VfTiubR6v0Qf239?=
 =?us-ascii?Q?5pGzSK5qlD/2vtNyQ1/hknWuCd40lRFV7aBbOBGyed6O4e80wRyIl6E35IZ2?=
 =?us-ascii?Q?1oTMAlB4bagrMrQgWBF7ebwMDtrP7KLN3iXTSnmh8oO0O4zvo0OjHvdRt5Su?=
 =?us-ascii?Q?9nrQsiP6xVa6NC5OOzsNi5FicsjTsl9TzOmAX4VVw7z+IBzK9b8SJpIVC0ir?=
 =?us-ascii?Q?G/oOIqVtZpHZwYIweWLt4WrFZ7/bXDV7XCAZ/NABM/lt3jWdlHo2nLFtoBQi?=
 =?us-ascii?Q?weXe/YX0dMAjfyBvaVMEZWQ/l2bK/xHXiIXDEZoqMPtq41iyTEzTpWTCeJ2C?=
 =?us-ascii?Q?YGkHIzOQNHS7VNzhaGU8zdySpzlVk/AVFBnarwro178/mWHVv8NI4OJ5Zkhf?=
 =?us-ascii?Q?eYQ8owieNpYdXZb8/Jdb3a+gpfRkXtkvODW55n9apVkv3t+8+EVXjVcau5XP?=
 =?us-ascii?Q?UuJSLGLm5ynsv10jMhpcTAelBRkD9cqq43i64pFAk5FfQCJwo2O4fwD0txH+?=
 =?us-ascii?Q?87iGKtgwndJKLF379I4GEVABZ/hGbDlTEZa25TFVRFiknQDwH4OQ3zcAfEct?=
 =?us-ascii?Q?XdX8dPpDUhh5jXYKo8T9sTSAGkaeIaqbPzklvE7hQI0y22i0djvWccEObgwZ?=
 =?us-ascii?Q?05P3BbWob3Jzu7pwEyUH5IWgNMT4yF/wBDJMB4MXqtW5qPip6xjkmu33v5Zo?=
 =?us-ascii?Q?wG91V8evzMMbzWxwKi9KmioK7BjvWJh55g/EHBkJ+fwzVfwZAW7hL9dcMp4T?=
 =?us-ascii?Q?j4J9B8sefYhdxVKW2eApzUt5MxVPvCT7uvJNRI+yhFqvgym5CykPbd1eyeQW?=
 =?us-ascii?Q?+jBnSVozroxl5n9uh2+c4QEmmxvidKHafUlGc+5SvSyX4GJkB9tMSQw/xxQY?=
 =?us-ascii?Q?GF43YomxBItlCN7kiZemRHYGE/B+FU2pDdLj1QtszsmMcJivygUv1ChSP5JL?=
 =?us-ascii?Q?nfRCMlVnz0ATS1rSzhm55wsobhK9znTYorOxqGYXSgQ0ob5XrK4UNEB1cwLR?=
 =?us-ascii?Q?Zf8B8GvBMMJAx7ry6rgMcNm3/hiIg7yzbDaJGqngu+Ni5ttWTedd1a1ocu+e?=
 =?us-ascii?Q?z9Lk8UwHTj6l9E/Zf6LSYxfe7Tt+ax/reZWNlJJG7vLOwvZNUy+KHOJi1RQX?=
 =?us-ascii?Q?9TUhFDoN7XuSHm1xV+pQ8JjZMmxZtrZW5Zby4wTEve9rNdCRpSMxIkmj6Q8r?=
 =?us-ascii?Q?28mEiIO17ENQj4vblo8kF/Do0+dsIo+Qk5iSTVfZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 381a5683-41ab-487e-5b6d-08dad778d649
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:58:41.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PavCYhmKsJY1P9ZRqQAEkLPngzndGqsaXVE6SpAExGT3AMdxBRQhtDKrLR9eLQUza/dDqrW8pVFY5NguKIACMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7100
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Notes:
    v2:
    * Remove 'skb' argument from br_mdb_config_init()
    * Mark 'nlh' argument as 'const'.

 net/bridge/br_mdb.c     | 120 ++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h |   7 +++
 2 files changed, 127 insertions(+)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 321be94c445a..bd3a7d881d52 100644
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
+static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
+			      struct br_mdb_config *cfg,
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
 
+	err = br_mdb_config_init(net, nlh, &cfg, extack);
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
 
+	err = br_mdb_config_init(net, nlh, &cfg, extack);
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

