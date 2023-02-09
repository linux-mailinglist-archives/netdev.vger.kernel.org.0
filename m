Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA3F690121
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjBIHVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBIHVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:21:30 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835E73C06
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 23:21:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGfdp4Ryl2rxLCWOxeaVNfJJd0J9szSpy/WAsjoHEBNjgffViJn6KSrDSi7bXPGMun+BMHtYP1AL1BaOVBkkVUXdb+2VwPhEFSJ0y1vfphWppK1VgGE5Qs67DDjlG2uRpBpbxTD+p0hogXuUqZAYbEEuSzM2h0uOgxcb+bzNwktEfUxlrJTO6rO/bYmZFxUA0Bd2CZstLfJUyNwQrzpFQMRgnQjbjF6Zl3pjWOK/uo9BC8J1ClluRk4LA110Pph7/gzAHn2zQrAKB652k4AooQZuANlLqgUVoWpiG3P/sk6zQQA/tE40wGBXs7hqGTL6T5S7KnRnPMeIitiivL4OUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MSdRyowfkz64UV5rptMDYknkdbhAubmzsGyfZQhTjc=;
 b=OyZx12Hz6sDvzXYG5xBF94zqwEXiG/Cm4HFb47ORuuJfIGDceF/dTxZxsof00NljmNvWbpmu8n+TqVpKaQ8MulS7QhwCNe3Wnxk+cY4jAB1+ZY4gD0rZ/uTsg+rCaur/C7ls01KCnpM7M0HBstT8pkqI+BijwRaTRr2kMA29aEbWwgabjlMrsWBI4oej4c3BewON9VvE/GV8V9ZFGHeOrsvNU1zcWnn+SyU/4RJDDYAvrhuC0a8pvSxhkLxrh5fcFxdBaee3s3kKZ3aZ9pdAkIsvi0ItYhUxlWSrKULsFbP7sjgrt1xnUIB5I8mK53saASACoRuitMKOo8ijO3BTag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MSdRyowfkz64UV5rptMDYknkdbhAubmzsGyfZQhTjc=;
 b=X5gW7BrGW/1gZMJLhH+AenkL4DG7Gh4A7TVvM2QFeG1kLx6xYvYfsw9yzR4lEaw0WOCBzoN9t/viPt2b6bcCCJUrewIxGad0crBYuUp7fCXbAtwUc2WbcSIZ85q2lIdShptwKb6htD0hXND2Odz6P4kMpfTd7OG1TtwyroopWKiFHd3Lz21Dtr6Cws2cglO1D0SyVrcd0nb79IqEGtSYguzXDVJC8abAeJ8oM/1z02R0gE3nne67puwYU7M1WDym4d7jcXsbLbI1hueHnzoThc5AQ4ZCY6gsd6eRkvyykXPW59z2Io61SY9KSRHpIJNVWeD/C/dtxALrM7ZoMcgqmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY8PR12MB7755.namprd12.prod.outlook.com (2603:10b6:930:87::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 07:19:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.035; Thu, 9 Feb 2023
 07:19:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/4] bridge: mcast: Move validation to a policy
Date:   Thu,  9 Feb 2023 09:18:51 +0200
Message-Id: <20230209071852.613102-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230209071852.613102-1-idosch@nvidia.com>
References: <20230209071852.613102-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0248.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY8PR12MB7755:EE_
X-MS-Office365-Filtering-Correlation-Id: d1caac1b-d298-4c81-64bd-08db0a6e09b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtQzuHj+2UqHE+SDsBNS88TTvYZGR8Auu6+Fk+M6VKykb01UkIgutR/7bP3mcPd4iBAlZL3FNYx6VO9YqVfkBW9vQfa9Q2cuLjKxdlIUbbuYEICQzQTjXP0gkN2L8+Li54VM933/VDcVRvTAA5t9DNkQLIm94WpQIEbAJEH1yLTEX2P3i8e1R1I6NU36g8qN9niLyNLWMdQzG1hVqBX04Kp4kjtDWkP412i6d0f0AQhPSiFLE3WAWY73R//nd1UBE0ffRPXps6v5pHXjFHuiXoYxNi9hUXrlaBSbQTmRr1J8dvQ6/J4E9irKzkyurfmqotIkbo6v+sh+0lvS8gt62jCzrVVyEVrTXMpNyNh2b0eFlzQgLCDAy+H+hMsB06UTmcmS5d9ilLnd9IT3wIusMHu6PhzPdNzKezpbJHakL27OYpfrhQH9tg92TqPheetrmkF067UJ+3gSahoH6KvAYmK5E9X9eokr/TBCe2OciQKfyAo2OK5VRdDpA/f6ft1ob/OMHHXYWmD/0yESJxvB+ZTwH4fqiRZQQMYhL7rXJGj0kn1ooS09shRIGcqEfAs2SajD7KTL6eKHPXUImZ3JxKkcsYK+iQ572svQyBg2+ZeFKnlSTIjdttBqpd/LlkT+N1dcx+oUHFyr62a1tttxcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(451199018)(6512007)(2906002)(186003)(6506007)(1076003)(26005)(36756003)(107886003)(5660300002)(478600001)(6486002)(8936002)(41300700001)(2616005)(8676002)(66946007)(4326008)(66476007)(83380400001)(66556008)(86362001)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rnGhdm5IoxKH9SyYnZRZwtaLErs3trOgzvWyn/hIEAeNpkEhxbKDhLGJNU2F?=
 =?us-ascii?Q?6pN8BiK8jU4p5hLBaernzA1Ukz9VkLZOOM2eDMgvALS0+i3rrd9LtCZR2535?=
 =?us-ascii?Q?wE7fv+lNPG6HyQv+rNVFNEoq3KFmm7QwO6M6s2x8RUgphkzkvbocPTHI0spN?=
 =?us-ascii?Q?EQJ4NiyxGMQbSsyaVx99vlQBnSyGZ7Z2MrC/78PWXGJ4Jmbq804tAYYhlMYT?=
 =?us-ascii?Q?WWRiSc1j6wvH5mA6tnBHWwfOzr7uRBDzXuwuiWVStB0A+WqpR4o0sDKHlgz9?=
 =?us-ascii?Q?B2rV8bqxIcnEv5Xj5Pyef9BKz1Xbk8PYJUh366+WyGb8Qbf6ENgOoDjwbPKe?=
 =?us-ascii?Q?7OSK3ocieNrMLJUPA2cWhGLRcLcmBe+KmIxnKYaZSWBGEX6KLThbP2T+5sTe?=
 =?us-ascii?Q?7l1wg/U9Km0fjpkDA3Y/PpeWWOYeJaGigliMxuH3aAKdJnvFEpBIBW5nrykn?=
 =?us-ascii?Q?1iZKzLtQQIxL1urrhofnrbNutdRS+jT9Ketls5nxgs8hTQqho+iQ7aW5aMzr?=
 =?us-ascii?Q?r4bvHnbVXNjCs628kcfZrZmXUsfwDXc9G472gLVWu8la7ftRFgsSmCZyom9c?=
 =?us-ascii?Q?3jplS0gFHjcPyz2b1ZKbaGvHwIj1dCET95YoVxkHzGPx65zCXwIlCzzmPG5t?=
 =?us-ascii?Q?47gOO0rnTrPnjxPAZ9r5+ZfMaGFk/C9UdDhlPQABQMpScJnPbY6P991Y/Qkr?=
 =?us-ascii?Q?qJiAisQn14H8yLUZLxYSNtXeHJYuTRa7cJrEDmnUn42j0uHCp2rX+3IDc86v?=
 =?us-ascii?Q?d5gLxkLK7kI6YKq2zelZmDpP3C5LtwLQJzk4PWSNHGv7d4pWYCarql5vw8vP?=
 =?us-ascii?Q?aZTN8BUvoEhaN4qHf5aiPuLFlL7Xo9UVn9KfImqh/iL/4QOZtq7/0vZDTTEP?=
 =?us-ascii?Q?ZfxvEynruQyAmTW3yDSyR3HucWTzPOyL4dB8druxI7sAyVHtBAtdWd3smBKB?=
 =?us-ascii?Q?dx3R5J1COOqRVe9mFnBfyZfo6Jd8G6zzZP4BPh9r2c+Zfp4NWY6gYJpn1mPZ?=
 =?us-ascii?Q?LWqYMBaIe8cgpiabX4P7vGnZShvFTYkSbJe5y34wa0XTJQmfrtTHEIWHkPsv?=
 =?us-ascii?Q?E688SF62c4d3R1NPWd/V6qmRkIzgoWHJmD0Z88nLxSWO1KIKkjXo/OcKP9Tz?=
 =?us-ascii?Q?GVoGcFHOVPCQBzbciIq11TL0+TFKYDFDSba6FfbyKndN94up7FyZ9mQ6fxCP?=
 =?us-ascii?Q?xhNdVF7kPHXxdIn1WRtEZIWeKvzPWMrfgB9wPFwwae/cu9b9u1Gkm/pYT/C+?=
 =?us-ascii?Q?5wwyjmhbsVUE7RvIBH+2UTL2QA0cf+O9sBN7KGlA4FpUJjXYPOMxaSmJNT/S?=
 =?us-ascii?Q?kIGjECi7d+2WSbBPCdqS8yjwQH+KDi2J2GwrznZcexRQ1S19Bq+RQrJEmK+3?=
 =?us-ascii?Q?l2w4p1po13IDYVJ9WpulTfOwuQjD27uROVqzpwHCkGtsHhNvXunrvun6GSYU?=
 =?us-ascii?Q?rtFUhNKOUVXnWRd725E6yZvEgcyADEA2hkJYNk+iRHem2BaRdhPxDbI2ugCg?=
 =?us-ascii?Q?x6+SxjTdpusoO3c0oXDjc4xGSsvZpuLuhK7YpWb00Nl8HboRsT0zKAV/nybU?=
 =?us-ascii?Q?NOeFk3Ur3N7CBCogHlnQBfvaeqRER7n4ZtddngAe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1caac1b-d298-4c81-64bd-08db0a6e09b4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 07:19:52.9648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BlfZeNCSamZTEll8Wrtaqx5OxI/qd+ZCNqfGDOoWzl5docpslyoOCXW4SUerUS9vOjf6zltF+RJhQLZjJqM8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7755
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future patches are going to move parts of the bridge MDB code to the
common rtnetlink code in preparation for VXLAN MDB support. To
facilitate code sharing between both drivers, move the validation of the
top level attributes in RTM_{NEW,DEL}MDB messages to a policy that will
eventually be moved to the rtnetlink code.

Use 'NLA_NESTED' for 'MDBA_SET_ENTRY_ATTRS' instead of
NLA_POLICY_NESTED() as this attribute is going to be validated using
different policies in the underlying drivers.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 96f36febfb30..25c48d81a597 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -683,51 +683,58 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
 };
 
-static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
-			       struct netlink_ext_ack *extack)
+static int validate_mdb_entry(const struct nlattr *attr,
+			      struct netlink_ext_ack *extack)
 {
+	struct br_mdb_entry *entry = nla_data(attr);
+
+	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
+		return -EINVAL;
+	}
+
 	if (entry->ifindex == 0) {
 		NL_SET_ERR_MSG_MOD(extack, "Zero entry ifindex is not allowed");
-		return false;
+		return -EINVAL;
 	}
 
 	if (entry->addr.proto == htons(ETH_P_IP)) {
 		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
 			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is not multicast");
-			return false;
+			return -EINVAL;
 		}
 		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
 			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is local multicast");
-			return false;
+			return -EINVAL;
 		}
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
 		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6)) {
 			NL_SET_ERR_MSG_MOD(extack, "IPv6 entry group address is link-local all nodes");
-			return false;
+			return -EINVAL;
 		}
 #endif
 	} else if (entry->addr.proto == 0) {
 		/* L2 mdb */
 		if (!is_multicast_ether_addr(entry->addr.u.mac_addr)) {
 			NL_SET_ERR_MSG_MOD(extack, "L2 entry group is not multicast");
-			return false;
+			return -EINVAL;
 		}
 	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unknown entry protocol");
-		return false;
+		return -EINVAL;
 	}
 
 	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY) {
 		NL_SET_ERR_MSG_MOD(extack, "Unknown entry state");
-		return false;
+		return -EINVAL;
 	}
 	if (entry->vid >= VLAN_VID_MASK) {
 		NL_SET_ERR_MSG_MOD(extack, "Invalid entry VLAN id");
-		return false;
+		return -EINVAL;
 	}
 
-	return true;
+	return 0;
 }
 
 static bool is_valid_mdb_source(struct nlattr *attr, __be16 proto,
@@ -1292,6 +1299,14 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 	return 0;
 }
 
+static const struct nla_policy mdba_policy[MDBA_SET_ENTRY_MAX + 1] = {
+	[MDBA_SET_ENTRY_UNSPEC] = { .strict_start_type = MDBA_SET_ENTRY_ATTRS + 1 },
+	[MDBA_SET_ENTRY] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+						  validate_mdb_entry,
+						  sizeof(struct br_mdb_entry)),
+	[MDBA_SET_ENTRY_ATTRS] = { .type = NLA_NESTED },
+};
+
 static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 			      struct br_mdb_config *cfg,
 			      struct netlink_ext_ack *extack)
@@ -1302,7 +1317,7 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 	int err;
 
 	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
-				     MDBA_SET_ENTRY_MAX, NULL, extack);
+				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
 	if (err)
 		return err;
 
@@ -1344,14 +1359,8 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY attribute");
 		return -EINVAL;
 	}
-	if (nla_len(tb[MDBA_SET_ENTRY]) != sizeof(struct br_mdb_entry)) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
-		return -EINVAL;
-	}
 
 	cfg->entry = nla_data(tb[MDBA_SET_ENTRY]);
-	if (!is_valid_mdb_entry(cfg->entry, extack))
-		return -EINVAL;
 
 	if (cfg->entry->ifindex != cfg->br->dev->ifindex) {
 		struct net_device *pdev;
-- 
2.37.3

