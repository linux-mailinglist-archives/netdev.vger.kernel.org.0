Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95DEB6E0AEC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 12:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjDMKAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 06:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjDMJ74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:59:56 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FA465BC
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:59:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhYEzccgpFWMUL+mDSlY7cW2Jnx4+uA/o6Hm+yztR9yGpu6Yy9ZvBtS+u48B6Oth40r8BWwFtMUMZJOPBjUeLqP7gwyVNOyiC3bsUmCu1UnuDnxOy8msaHPyHsZdUkwcY0tVnxh3fKviXWCcjTUS3uWpNqkwgU3BVSlQ6yHZrM+3TKoF60CbS5+ktARZFSWLX4FgJSUnjn/CFCWclMKydZlf/dv0xyKgKgodg0opmN4smsqBTz+Y1rFSxjGHtHbq7G1tal9/BNG44UsSlqsncBHBX8xf0dRsZ7dQuTCcxWKNsJVlVsVc6ZgJQ1PDey9ap5ac2SBu0y1gPBbK+3tfdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OocpeD0UomI/FlyahJq/PTTUvQlSvlpAuA6QQ1oKXlo=;
 b=YIAst5eLo2sTjIdgBqDJKUUU4H+WSRvj/T80N6XxSTfB7DY7C6jw8dBmNmZQXDdoYxwnxzhNl/AwYdhyBCJ4Ok0faPAP5EjS5PYWkrbo7/NJnOLZnMXTfwommS1AjrlETc0jclX+OCiqDZGCxuMScsW40gcxZikjzODqEhYGQPFI6RPxstdbN8KjXDbiEzIqkLeIAghoNGQfzifa6dTVSpl2wWX+/hwRmzmnEZbgei6Hm8x+ZnxearhH9d3v4RNt3bum10X9+saFzE6hZe2uSOzIlAuPA/zMuuioVazWoqtNJTkFLgcc+3R2zd0gSowpzLZZlqc6rA25OHRx8A9V5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OocpeD0UomI/FlyahJq/PTTUvQlSvlpAuA6QQ1oKXlo=;
 b=hjfE86leb4fR2D/5++bDZF7lP5Qc7zGgjOjjabEYmhOJ4/PziQTTLBF0uf0twhZubKpXevO2rNMBtxkn/1W8ASvOKIqtk0AZhhn3X+MzOng8VAirKkcY0Xpdvzed5YC8m/EQZMEttehRPrGrE3M4wgXo/qskBicn/Ku5YZY3Xm+1rGjxka8tg49TTYBOshaKTe/EL61OhooOiJbS/oWSCAeDXRe5CRqc+adKEFwBq5h+Z2ap67MUUeeBou85QUOpI5gdY8cXtwk1VLQcCfyf45abhUz66iNtXkuMtQP6RhfMjRXxSYUtViqfgffpFHGFV8tSJkNp9ttsYHXCDSytvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5274.namprd12.prod.outlook.com (2603:10b6:408:11f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 09:59:53 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 09:59:53 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 7/9] bridge: vlan: Allow setting VLAN neighbor suppression state
Date:   Thu, 13 Apr 2023 12:58:28 +0300
Message-Id: <20230413095830.2182382-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
References: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MRXP264CA0021.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::33) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5274:EE_
X-MS-Office365-Filtering-Correlation-Id: b0d57c05-0f29-4973-a2ba-08db3c05d3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t2tw9mzqT0k+edYeLBgb/Px5JYHpP6YWJZGXI1/FmDGDKkKVcwGZ/cjUlXIEEniqqBlqFoXVggzRO4YvHTu918lhUtBgBV5CjwBHzjpApolvSqPiGRlF2zGcJT+PQ6+Jks1fMBsL8XsnC8GDWkEenBn4wA8wqcSYKBBm/VTFflZeUyAQeelCi+Oc+AZrvF/slvIW/ToZRXKoNAMo0rB/xUv4m3+IrLqzGXAScQz+OZY6s2lQr2C5kmBNIAS6YaRSL3LbiTUrBOf4Kanpbsy1KtwC66ctCmSBN7e67BSdg/Yq9nCDK8c9/rmQkQkQB50C3IFAHZeJGMhYR3f/L2Cn9t1jd8cePbZ1+VIj569JcibFnetj5yYTia3RT3okjOA/SaXTIGfFXoZd9DAmhYgrYHJaYi15/euqhokLnFRHP3yCLFpmnim0B8w4sbx7igEliPUrEoFvILqBW/8tp9zwyW3mddnuEQoCFdFksr98KUVP1+WyCnw9GHuHQoTBD4pipz3u5w5d8MUiBARU4BJxYB67jzUfddKgfCKwgYW/y3vHPwFI4zIA4J5ydcn69ByI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199021)(1076003)(4326008)(66946007)(66476007)(66556008)(6506007)(6512007)(36756003)(107886003)(26005)(2906002)(6666004)(6486002)(2616005)(83380400001)(66574015)(186003)(86362001)(5660300002)(8936002)(8676002)(38100700002)(478600001)(41300700001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2IC2txsCkvcGSr2CzO4BrRtnWOaw+/2rcWHEyEfUsAcbx88Pd7WhepL6n//p?=
 =?us-ascii?Q?pBx51fqNg70NBFNKZCVra6SglowHQuLYV+hGxYeluh3XN7Ee6pnQKM0dF4uM?=
 =?us-ascii?Q?X+eLkHGn/QQlS6Z+3XW/TZdY9La8rHy2FDxbDa/lyvIUm7yFwCHY8JkQU9PC?=
 =?us-ascii?Q?2Nz9lklmaAUtphisVyOXU194NwO8xoPHQPKIZKcAQ+SjJ30mZvB+5QfwJgfA?=
 =?us-ascii?Q?5u1exAVqX7/EIebMtHQ11U0zVTp23iwgQMbbFzM2XP+lpPyGB+yoggNTzWiv?=
 =?us-ascii?Q?v5ZZBsnd0qaf2zr0W0mPdyP/8lHdWVCffufeK8ujgB/KsgwXEuweO2Ziy0/b?=
 =?us-ascii?Q?hTa9mFWxNsOxgxjoq7VM1VzWCSQHG5KTWPgWSasD/CENjtbTC20s5BiAKpHX?=
 =?us-ascii?Q?B1A5eaoda81yhytHTMbPqyfXNal11XfMJenN16za458T9lHMytXD8HC1BlUS?=
 =?us-ascii?Q?v3gm1BYqIKEWs1oEmZ/8RQ5ZGitGGGYzS+b82C4pIPpTIOQz/ZsZRfZS7h6D?=
 =?us-ascii?Q?f/mqY+lCk6x9BcU7i4ldE5sLzArb/wdwQ2CHIMDbXgLfAvj6q0WP7mrMHqTZ?=
 =?us-ascii?Q?AMnkml6LQoGK+rpZuZ9cWuq1uNBSVXg47tpkDZP1pr5PAWGQrjQjNRVY+VZs?=
 =?us-ascii?Q?q8TUUV82mNY4T5jqFS4d1jN6HvPX+3l+KnEVFAQtWRHXXzMHT/gaQXY58hSy?=
 =?us-ascii?Q?x3wpUbK8Kki3TKyWecvP/E4hwwwghD2z+HTphwPpnqxsjgVrT3BB5VnSY9YU?=
 =?us-ascii?Q?+lS4AHUV9OmcKroX/SXNidExB/MpIMUS2aPVvSjNBAf6u0gyTCOHQSTlnDo5?=
 =?us-ascii?Q?g/VlfbIhG3zbNEdFJcEXmGwt3zI8NaTMuGLhn+n+hicX8C+OTeAX2cDfbVZv?=
 =?us-ascii?Q?ckr8ij7jp/lnqvnNuumlWWNzdRUpHs4uf6uCnmbPC3ugrwKw+autKnlvGCAH?=
 =?us-ascii?Q?LeTz7GmVVf/FO+rbeqIAppEhwePjfxQAGJlVES01fbJedvwfisB4Zf4/4TLG?=
 =?us-ascii?Q?DBUx7D37e3TZ3cV9lCJIOa20uT3mjAmrERyB0MFQRILeT+OeCrJT30KPJL6h?=
 =?us-ascii?Q?osOxRzl1FgEmY6L3qGxFX0ZSPnd439ojXczR1qmtQY7+MC/T8Kg3nebkQyU6?=
 =?us-ascii?Q?+kyNZsWx4CsyVH6c+dcTi0D0KDhIBY8JTbHqjCeyB1ZSss+h3XadC7wEKsrW?=
 =?us-ascii?Q?jeWwKQ7ChcYKdyHdiQLDbYGQBqPSJ1qoAaMn3+LkTW7V4OKVAb/2MO+F4Wqe?=
 =?us-ascii?Q?SNqjy9Q9yrTRp9MelA7VYEDEzApMq4vPwZJmxdpWn42e/cZk5e+Uc5GvBypc?=
 =?us-ascii?Q?Lz09ga18dvJSkpoyw2AGFz6G5BGJzIcthmDnvV9dXbUTQt2GbCBIohXlLOdX?=
 =?us-ascii?Q?WNBp9m9iXBdNwBLZxJsBZ3/NJUzsSkLFNUlV0IK8X24F/2fu9XbroiKWO+ZR?=
 =?us-ascii?Q?JXbK4y+q16yqwL5HAz9QpHpVe+/0DbwlixMz9nhRbCCQRqxoNmwLb/55AnTg?=
 =?us-ascii?Q?lnOrbyh00uIAaBWrpmlrIPuMcgF75Ki77REjivurMQkyWdmu4NHzDpNXm8DE?=
 =?us-ascii?Q?MU5U1Sgl3bhQ8VzwwG9EsRZur2lH6K6nV2XAdcQb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0d57c05-0f29-4973-a2ba-08db3c05d3e9
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 09:59:53.2293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqcbgn1NJ4qaJWDP3PKZGn6SRM8xnbobp9MHDwtN4/Kcb3Q/86Vkbu+q7y6Rsqf7LjXBv+bTLpLHmYBVvx23iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5274
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new VLAN attribute that allows user space to set the neighbor
suppression state of the port VLAN. Example:

 # bridge -d -j -p vlan show dev swp1 vid 10 | jq '.[]["vlans"][]["neigh_suppress"]'
 false
 # bridge vlan set vid 10 dev swp1 neigh_suppress on
 # bridge -d -j -p vlan show dev swp1 vid 10 | jq '.[]["vlans"][]["neigh_suppress"]'
 true
 # bridge vlan set vid 10 dev swp1 neigh_suppress off
 # bridge -d -j -p vlan show dev swp1 vid 10 | jq '.[]["vlans"][]["neigh_suppress"]'
 false

 # bridge vlan set vid 10 dev br0 neigh_suppress on
 Error: bridge: Can't set neigh_suppress for non-port vlans.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_vlan.c           |  1 +
 net/bridge/br_vlan_options.c   | 20 +++++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index c9d624f528c5..f95326fce6bb 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -525,6 +525,7 @@ enum {
 	BRIDGE_VLANDB_ENTRY_MCAST_ROUTER,
 	BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS,
 	BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS,
+	BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS,
 	__BRIDGE_VLANDB_ENTRY_MAX,
 };
 #define BRIDGE_VLANDB_ENTRY_MAX (__BRIDGE_VLANDB_ENTRY_MAX - 1)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 8a3dbc09ba38..15f44d026e75 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2134,6 +2134,7 @@ static const struct nla_policy br_vlan_db_policy[BRIDGE_VLANDB_ENTRY_MAX + 1] =
 	[BRIDGE_VLANDB_ENTRY_MCAST_ROUTER]	= { .type = NLA_U8 },
 	[BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS]	= { .type = NLA_REJECT },
 	[BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS]	= { .type = NLA_U32 },
+	[BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS]	= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static int br_vlan_rtm_process_one(struct net_device *dev,
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index e378c2f3a9e2..8fa89b04ee94 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -52,7 +52,9 @@ bool br_vlan_opts_fill(struct sk_buff *skb, const struct net_bridge_vlan *v,
 		       const struct net_bridge_port *p)
 {
 	if (nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_STATE, br_vlan_get_state(v)) ||
-	    !__vlan_tun_put(skb, v))
+	    !__vlan_tun_put(skb, v) ||
+	    nla_put_u8(skb, BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS,
+		       !!(v->priv_flags & BR_VLFLAG_NEIGH_SUPPRESS_ENABLED)))
 		return false;
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
@@ -80,6 +82,7 @@ size_t br_vlan_opts_nl_size(void)
 	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_N_GROUPS */
 	       + nla_total_size(sizeof(u32)) /* BRIDGE_VLANDB_ENTRY_MCAST_MAX_GROUPS */
 #endif
+	       + nla_total_size(sizeof(u8)) /* BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS */
 	       + 0;
 }
 
@@ -239,6 +242,21 @@ static int br_vlan_process_one_opts(const struct net_bridge *br,
 	}
 #endif
 
+	if (tb[BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS]) {
+		bool enabled = v->priv_flags & BR_VLFLAG_NEIGH_SUPPRESS_ENABLED;
+		bool val = nla_get_u8(tb[BRIDGE_VLANDB_ENTRY_NEIGH_SUPPRESS]);
+
+		if (!p) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't set neigh_suppress for non-port vlans");
+			return -EINVAL;
+		}
+
+		if (val != enabled) {
+			v->priv_flags ^= BR_VLFLAG_NEIGH_SUPPRESS_ENABLED;
+			*changed = true;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.37.3

