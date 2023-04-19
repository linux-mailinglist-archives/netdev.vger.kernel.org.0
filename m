Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26ED76E7E69
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 17:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbjDSPgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 11:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbjDSPgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 11:36:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E5A5FD2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 08:36:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEqvQsdH7wtjacT5hAWTYvn/NteS7GGVnuF/vyDHdI2J++JwfZOlqgt81ynR2I8LTtz7d/KyefPS7xg1WDjWf4puMS1ZWMdcSA3Xz2RV6irKIgPhuwggpxIb0dagraFKFI+gjABx47FLj2EpFbiK3xO7DqiMShHfQFLoAxC5rRM5+yd6CJ9d4PyTaTi/bf2mX3wXJRZN0E8/J9Df19621Ps5vgzIE6TKmddCBdB55kNOs7KyYggLPDanbdyGvmPcABiBlXOGuZjaP+/ILGGx9LR5oNf+7X7+TAvV4qvvADSKVqFX9b7fJxOE/xqrezNO5/Ij8GLpqUFe4jzyqFW9Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NmUQ6d6kxYpKJ4DxH+0kxjZ7sAECfUUkXSJAlzBBjXQ=;
 b=dxvUpkhSkOCyuEACYa5GqkGKg1UHWI4/58v4TSs44OYRwDZO33tLRByvzvPUyAycprPFA/IWMXLW/gT9AZ49E8MGucaOdMPki9O/BvmTcgGHgLkPi5mQ+pg0j8dlkjqb0oqajzKfE5O1Kuxlm+9NePrn3k9nMWu23pJpYisbupMI4JFU2gLpAtbZDu63L2mR6bQOSk1a1wi3/A9j64HRlRGK9KvX7cOkC/lfI/qdOn0gCC4FXUfn8MnYr2ucLng/JPdOCVHGUcTVa/YmKl5pN6rc4u7olNLf/NCHs3QdFsjrkvInQE23z5HYd/8KDHDWYyP7VtROU8Jj8dPxFMKDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmUQ6d6kxYpKJ4DxH+0kxjZ7sAECfUUkXSJAlzBBjXQ=;
 b=ppgFdrPEsMeCuIxNpQEQv406wZHIWnDhrsxxf6AgmQYz4Z1TOo5WGD1IYA12GgHb+DZChKkskdWLEIA4hBSFWCY07sFwn7Xqi5/KOhxWPxNymDpwkDf+SHBbtbZloNNTyk3jfsUm14NZZFG4DumIPQ+DJ2DaTAUAvWlkJPbtWmiCtwwqf5uaOr3F0FlMn6cp4nr2F8I418teCArY6I/jJAV45UBlLWXSa9puctsYeT0dcnXY0BwxjzWRihQ9f95fKy0P4E3o2L1QatDKCdKXwnTYkT0sP2NsFsuH7zXy7aEQHFfPpJSWUbVaO6+151/eG/GTyvohWEkhXbOP+96V7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB7623.namprd12.prod.outlook.com (2603:10b6:8:108::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 15:36:29 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 15:36:29 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 7/9] bridge: vlan: Allow setting VLAN neighbor suppression state
Date:   Wed, 19 Apr 2023 18:34:58 +0300
Message-Id: <20230419153500.2655036-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230419153500.2655036-1-idosch@nvidia.com>
References: <20230419153500.2655036-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0182.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::39) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB7623:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb433a5-b357-4642-9ebd-08db40ebd86b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /m0ap03qA83zkZVLtoRUC+bV0pSe+xUvM2w4ux7JloRB7G9kaKZj18m57L3IvQoItRkCr67NaQzgXNO4RFXn4y9AHQ8BB7tzxXQ9p8AoxoRQUiHIW6khpTxfGGChWdTL5b//j/z3DRG9kgwSkfnpvR9pIHPiIWGDZ3reMNmTq/vn0T/8PBj7cLiu9rRrRabU9qVwexWcC0CkcZp8qP3OAm2I7mV93cCLCdPJ6szMN5MG15VjicTcQGg98PFEVXQHQ1bnLvDCuKL3MpwG0Y2gG53yd97TegxRB/Yj+HYPoDoBcMU9p4vmRA8lq8MLc1tl9IlVWNGxyRhacHXUJFa/sRCY5OfNOJ8W50fry3OAXk3LRtFiRJsgIC7hh12G5KAlQIHmvE6/XjTZwX0YDZI5WWISAXq1fj0ES6jMv/1P+kszEDqRRqpcJF8AHtVlkPwFf7gF8rxR1KO4UsaL6NHTPchK7mE6GZKD1FjJMxclob0gbOEzLEvgpbnIM0mnwAZ+uKg0HFJvTv8ZlRVmiJtMjpsgl4U/9Uaxxg0D78AI3+ocoHKE6A8iK2A+NtJP+dA1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(2906002)(8936002)(38100700002)(8676002)(5660300002)(36756003)(41300700001)(86362001)(6486002)(6666004)(107886003)(6512007)(6506007)(1076003)(26005)(478600001)(2616005)(83380400001)(66574015)(186003)(316002)(66946007)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sPH12w1MwgYH1rrxbHuL7aVmzgyuXA/xY6qzU/fP426Uf8EahN2gCdEt5tb7?=
 =?us-ascii?Q?CLepSYKzwR0aOOe5nqnvGaYJ2gO/e8yQ5tS6n40amzxKZpMZVayRXn+d9Kub?=
 =?us-ascii?Q?Ce4OTrlh4TihZZxkCnuAxDP1ORo22YwMcDIyoqpMH+B80NX3Bl0C3bhQuu2d?=
 =?us-ascii?Q?5yem7pUNMhXzNXQb/JFzu1Zc/tC4RFkjq4LWUVw0xVtIu+umVoQuhv3GXsTU?=
 =?us-ascii?Q?e6DHg2sA5lbRm6jBWyfc58WcqaY6ia5XrBjcd6IaPAfHe8WBdyJSk/bZt1vI?=
 =?us-ascii?Q?UUEVRnthB+2d7OVP9ylACxwzZ6kBJAtFqGJQEpC0a769pJn182qIc/evrGAQ?=
 =?us-ascii?Q?UCDptS+ZkFJ1us9F3AWuvxB2xfTdk8DVxkWLCsRSZ7b61nMuPW/NcAHCCVq9?=
 =?us-ascii?Q?9YzdTSW8FrdoC69qOAUREpNu42A3U+itvqELrCXaqlm7exzigpkMaZsJim/B?=
 =?us-ascii?Q?9K6QvaaQMo4HqbyBi6/n109xgvUuAIr3gAUPiznRcBt1ogEO3yWLSuTUNEtL?=
 =?us-ascii?Q?q9rVzcX+nh+jD56wBLJfawFUutYui96x0a1Iegd9aX3G+pofoCDeKj2cvRII?=
 =?us-ascii?Q?C3XeVEY9ux+VrWvTrXL9KGhkN0CZVYD3719JWowYfk3VXjmRMoAnS2jDi5aW?=
 =?us-ascii?Q?oOgxaCpejTy+KL2sODNgAzbEDQvqKa/Uq5hBgDPl0wTqYCVBdoXgAZHdQm9k?=
 =?us-ascii?Q?A4RBwIRRN1vnw+JDUOE4B78xK65mvH3uoPOWxhhisNdzcykjLPKrjxmnVEKC?=
 =?us-ascii?Q?dwDKyW856O2wVx+GgoG6tJ/KL5iIjQ8y6JirwpIxfjGKPLf2DDbYyveDLKAZ?=
 =?us-ascii?Q?hGaWAasAYjRtcJ0H2W8Y2yPw8ooTY+/aj2z3Fx8Jg/rvM1PYR8deAlf8DsPP?=
 =?us-ascii?Q?7O/gG693MwfYLI+oa+qPhcvvEpQqgYV7J02DXZYJS8H5A0dg4ukiUDNxNP3p?=
 =?us-ascii?Q?vhNigklmisTuPmGL4LkI+o0DxpEAZ7X9yGJyJDQgrvD4F2xomXib8xweHZVy?=
 =?us-ascii?Q?qQ+MrVpg8ilL+Hw5L8ZsM9ORAbzm+FZ5iResoSAfOjTciv0M68pnayyN9SKI?=
 =?us-ascii?Q?BrJavSYnKowbjrfin4M+XmRSi2bnnTvotU7sQtdCjqK3USdZFBNSRKc9hKjV?=
 =?us-ascii?Q?6DucRhpuEBCk/PneIU7WomX/mZaFV5KzxuL1J5nv6gNkcm/Jr4rnf1HgL4pp?=
 =?us-ascii?Q?EpwO08u3Jk5G58QJVQRqYE2JjLA7qp0DB9I0rzMtJxjdp37mxauALZJz2FE7?=
 =?us-ascii?Q?yXII2hFpgrAb7XA9M13yozANqxmL64Z2vsmZAp/2nXEPfigRFaRziZnLUZXs?=
 =?us-ascii?Q?Bdqm8QykL8wf61ejT87vYQry2owfgU6YEi/U9T4a7MZ6PJ2fvI2rbmxWM32R?=
 =?us-ascii?Q?y/oRtsZlSZ4Jz0f8hG7FcaQe2VoS+GwMKcPVPvm1gZ5FsONuggY37/gIbaOB?=
 =?us-ascii?Q?puVHHb2LiNUNsWtGFMg2GYM8JXbhbyTpoHjy/2C5nXsgrHj6wu+GQQYRH3vs?=
 =?us-ascii?Q?2wKh0oTnSp3MHzJTmpteTcd3VbVmVmCfABGFyelVZd2M1za/rPwt8e82JvMn?=
 =?us-ascii?Q?aJAVCzx/hz68GuQNMZkkhZzg3D+y8UaJguConlad?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb433a5-b357-4642-9ebd-08db40ebd86b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 15:36:29.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Or3Vdp7EtNeuPMIhGI1v4SIQYIdybQ5YWyTpD/lXH4838/IZr8QrVOr4ZQzRINkycjgttxYK9ysOSvX5pxAdPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7623
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
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

