Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C1B64730A
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbiLHPa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiLHPaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:30:15 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2040.outbound.protection.outlook.com [40.107.101.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A990D78691
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:30:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PCEToS4rZl7BKG6/o6udh5t/bssbbiP9mvSffJrrV6KxeVZqACzeP4t01cOkcwc4mlhrdMEsIMY3/cq9v9xUrTLtTKolTyI7sgg/wrl09EYxpihE3quxIxfKImUy6x/oRYgq68SdvQqym6G/h8UoII1lXuDyoN5j2j0kuzenTvAQHaeJE6l3ym4630J4V3g9S5HUibvkvOgr5m/GTentRT5/NX/tGXp5KV/tPTILFIB0QIBWbk04QyipeftYNsMkv/F6bNWAs0lrXczIvhfkPWGXcPIlPLUc71hl8srk7m+yVIo4ze7WN2hdSwSMDiDIIczcR322YcSaF/K2S82vWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9o/bF6xuTdH6T3TYMYoUxE4lUviYjclDl822kTUzak=;
 b=EC8Op3hwF5TuXbDZUIcpTL6hkthVd0sZXanxc2Jb0SMPNqedcdwK1oaDNdVI8fLe36/UV0JaqlyqBhy2KIt4a7hP/Nb+uTplW1t7HnueIfzNKv62juyVq90mWNO43dq7urIH72m/xkM8xD76lRUeB554WXCi0GCu+1z8Qry771v9OthS0J7sZCfK9CJOhXCQcefDnTeUKRnaa9ebifnVX5814Z2QRlV2PHK6iXHqpfJXq97D1B7+0r9LY5ZbNxa/OaO1YPxddOsN4haLodLAzjVXBuIKwxqcZwc+IJ0hz9IlBHpaVaOqEiZmdBrHowjRlyJgXeFbrU6t1xUiy5zjKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9o/bF6xuTdH6T3TYMYoUxE4lUviYjclDl822kTUzak=;
 b=fBZE7WZFS4WYMZTPz8e2UcgJ3vbMCDjpi1HKPpyS15K25I0a3bMu++3FyG3g5QPvuek2pu7Yhhi74EyeSDGfBQMKKPJgWI5ohYoZ/a07/Y1hULcC0c0q7MYnGujJIWEJl7oIjVfm0kAatn+1L+dsxI+yknDzgfOEo5MkNwx4yBOjaHLDf6P2zOcPoStKnvbgKMUh7F5Se+qg59aRRluAjelcAaki9rtttqnyvDmX+yQqkEj5m+aRg2/I93QT/GKY8rFxEYGMeX31Dvenj6S7DOwS2FFkSM/NICIHvmAc0m5NM9YFqQGEmvE7CAZDt0CDhCjCREW8++k57LCcJ1F5ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5370.namprd12.prod.outlook.com (2603:10b6:610:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 15:30:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 15:30:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/14] bridge: mcast: Allow user space to specify MDB entry routing protocol
Date:   Thu,  8 Dec 2022 17:28:36 +0200
Message-Id: <20221208152839.1016350-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221208152839.1016350-1-idosch@nvidia.com>
References: <20221208152839.1016350-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0026.eurprd07.prod.outlook.com
 (2603:10a6:800:90::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d685b2-db5c-44d3-0a2b-08dad931195d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7M9fyOyagwe8Hse2vfAg8e5OmMg+nkn584X2InzYCgF+ktA/nwD05S8QlMWyUDkLYX9Vyq7ZZ/ravZzGLVaa9rpKhQMyQCm5V+5AXu9hjzCHB0Qugpj5OiJT9sqW48xjqt+doqUcD5CuvquGl6PrhiJ2Czt+7uveTpwDufmN6FvcrhvMBbCSnVJH30JN9fBCKj837qLuNwoQi2FE1kj+8fz6I6nqEZy7OAW4fxmaPJq8tDHn46dCdLfJlFYOaBcUUXlK+dkqgNOSce9LPItYNPf1FL/mishSEs1j1a4hzEaS2AJ8Z4iI928M3fZdvzKHYumbD5GfqApaGBmPN02Yu43nRIbYKPgjSX9PdUN759R7D/c2orSje1sq9EaIOM/Fj2/Geoh1QkID21WN2TZLNeYRdo0z+yFSPna3CPtlSG3NkM/f7UA6bgDG6DI1bKhYBMt4l0fu6XIZDiQ9Fg2x7oc0bCxBEhow7MW+exRBrA5PQcVpuUzDsjRsPBR+lAmNcY4K2MkS7jxMfpZ5BQGZaNJQk3UkzzCpGEOMv2cWkFuek08+zXXBgixtjy7YnCEpAAqIG1LGdCsKvoXfWcg6aAYUmUuRSrjto7GSEltJsaj1LY1QeljYlLnFnfF2jnVznZkDw/S3AK5JxBikMr47g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(36756003)(86362001)(41300700001)(8936002)(66476007)(66946007)(4326008)(2906002)(66556008)(8676002)(38100700002)(83380400001)(107886003)(2616005)(316002)(478600001)(6486002)(1076003)(6666004)(6512007)(5660300002)(6506007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hL9AhsqCjzrQmvgS301vmOA3I/ssP95IhzPBaJBuslaWt7clUc/qAI33YMDf?=
 =?us-ascii?Q?C1+2XeaY6bUwsr1F55fS9eVtosf6T+L9NSstYSSlvxR3AmUw5xQYtHtaLr1J?=
 =?us-ascii?Q?8p6QMNJ5fsDA08ukeJ/Opi1tMclxl7i/a8yX9e8gQo5hi5rldsAU5ob86apn?=
 =?us-ascii?Q?d3uxpPjli7YUEq7WjWuhXDPpuG+mFATXgrITzydk2/4lPJ+FTuZlMwSQ9NiB?=
 =?us-ascii?Q?ZdpQ25g5gVFVmeRkhE3hlpFAt5ye6rN4lwry4HP1fmczkYyYgNuKUASBWJAc?=
 =?us-ascii?Q?lLFUWOXxv105HGaHhq5M8l9JpdwJKa9CKIj0oWiY9DdnmtaZ5SXnGTHrcGhA?=
 =?us-ascii?Q?W+nOGwDo/LZdlQXkWgQSGuqPY2ANU3Wy6wLCxmOrSYCKHhgqkEX3xw3cWVdS?=
 =?us-ascii?Q?+hCwMve/M7+EYqHzpaHLy2kUpXgN/LE3LFsvwFBC65Dg6MYL/9L30cLLQAHH?=
 =?us-ascii?Q?B6RI/XuoYP0vjke9PBUvu/tQyDpPU+zXzlymazL9XEwp1+VefnSlkH9Uf05B?=
 =?us-ascii?Q?hzm7WHUJR4a1gWRrs1vDb8RQ7ThAhV4++Q7GkS7uZZsSgOchvCOzlY4RN1Zm?=
 =?us-ascii?Q?3MX3qwyYhEYMTx4BlepgT8IDYioJjujlVFZidDD7XpFVUFzBz4nJQrRTiuku?=
 =?us-ascii?Q?TCRsAt/A51FHUJ+mGFM9KYnrcLIw4jwcXkuwaEUKP+TLnHQz35qdDYKD++gU?=
 =?us-ascii?Q?xy9XNz02T55zDuHj406cfDPUz73eHvCOaGmSgM90GoUJp/cYKGefI4w+51zz?=
 =?us-ascii?Q?W9OAzSVt0IPP7iQw8HzCNlGLliSvAgw4262kN3dSobK4o42UUBqvVZjX1cSs?=
 =?us-ascii?Q?crrult0cTNfuw4ckdGs2oRE4QQfOmbNyaEoUtTODRJ6FfOK0E8yyr0Ttbi+M?=
 =?us-ascii?Q?A0v7XpM63ahqbwHPxSzKlfd2VAZYm9+LBpvsJhe1jrzlFXPNGXvRUCDCV0s8?=
 =?us-ascii?Q?r6rrnbj/gwNswccgjNHYVISHWjmtgt/N7OPgcOD8jdBsORQ4pboPrP+Hzxf9?=
 =?us-ascii?Q?8K9yBOoV7WkGT8qcxp3H4CXcXDPV5inKlxBkLnqGB5BLN+7RIDsMOX4vNhmY?=
 =?us-ascii?Q?y2mG0ZZs3qIXOtmmO4/dFsS3uqKPzhR02MxYSCy+ZVD+2qYWCZ6l+NVxKH1J?=
 =?us-ascii?Q?pcN6gFVIJXY1xTbE9/QrlaP1Hx9cKaA7LlXziL9C94W5Cy2n1fUPeiS+eUdC?=
 =?us-ascii?Q?z96f8bDNLkIm/1oc9i9aI2tyBKfzjhFhS2Nh6cJ3z6o52+FLIYva93IFd8UC?=
 =?us-ascii?Q?RwEjfQp05d31QBJE9OIDCKxqlfzYRHqHCC0z8AgQzXsKWY5bzudxMjH1+FBN?=
 =?us-ascii?Q?1veU8JpwXwJmMkLG/fOn2LKbDEzVAoPQTtcBW8DSEIMUSxh++E4exfufxQR1?=
 =?us-ascii?Q?5p+YSL2oLikThYNjk5/VaN6roRfqe4a3KFh7IwrjanyEkVOiwK5VCi9jSKC8?=
 =?us-ascii?Q?RkbZQJryP45Q9mOT3j7/cBThgTTpDOX5RWaCi90L2JzR4u6Gr3RZBlGchVNb?=
 =?us-ascii?Q?b1WAHaQeuNWnwANszd4IlKuVCFaahpAUiJvdJH2gYImfHqZtOGo0totuADGs?=
 =?us-ascii?Q?ETHAbh9WVnqbdhGnTUOYhPyvYD/C5HWerRGdIXT2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d685b2-db5c-44d3-0a2b-08dad931195d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 15:30:13.2260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bthkLPrugq0xdajcRlH+oWagenLReZbMgFNmmvftF0g2Lo8XmPxNoRrE1ulrg1YdvgrQB9480ROdvQFgsliI+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5370
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the 'MDBE_ATTR_RTPORT' attribute to allow user space to specify the
routing protocol of the MDB port group entry. Enforce a minimum value of
'RTPROT_STATIC' to prevent user space from using protocol values that
should only be set by the kernel (e.g., 'RTPROT_KERNEL'). Maintain
backward compatibility by defaulting to 'RTPROT_STATIC'.

The protocol is already visible to user space in RTM_NEWMDB responses
and notifications via the 'MDBA_MDB_EATTR_RTPROT' attribute.

The routing protocol allows a routing daemon to distinguish between
entries configured by it and those configured by the administrator. Once
MDB flush is supported, the protocol can be used as a criterion
according to which the flush is performed.

Examples:

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto kernel
 Error: integer out of range.

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto static

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent proto zebra

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.2 permanent source_list 198.51.100.1,198.51.100.2 filter_mode include proto 250

 # bridge -d mdb show
 dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.2 permanent filter_mode include proto 250
 dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.1 permanent filter_mode include proto 250
 dev br0 port dummy10 grp 239.1.1.2 permanent filter_mode include source_list 198.51.100.2/0.00,198.51.100.1/0.00 proto 250
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude proto static

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    v1:
    * Reject protocol for host entries.

 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mdb.c            | 15 +++++++++++++--
 net/bridge/br_private.h        |  1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 0d9fe73fc48c..d9de241d90f9 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -725,6 +725,7 @@ enum {
 	MDBE_ATTR_SOURCE,
 	MDBE_ATTR_SRC_LIST,
 	MDBE_ATTR_GROUP_MODE,
+	MDBE_ATTR_RTPROT,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 61d46b0a31b6..72d4e53193e5 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -682,6 +682,7 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_GROUP_MODE] = NLA_POLICY_RANGE(NLA_U8, MCAST_EXCLUDE,
 						  MCAST_INCLUDE),
 	[MDBE_ATTR_SRC_LIST] = NLA_POLICY_NESTED(br_mdbe_src_list_pol),
+	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
 };
 
 static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
@@ -823,7 +824,7 @@ static int br_mdb_add_group_sg(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					MCAST_INCLUDE, RTPROT_STATIC);
+					MCAST_INCLUDE, cfg->rt_protocol);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
 		return -ENOMEM;
@@ -881,6 +882,7 @@ static int br_mdb_add_group_src_fwd(const struct br_mdb_config *cfg,
 	sg_cfg.group = sg_ip;
 	sg_cfg.src_entry = true;
 	sg_cfg.filter_mode = MCAST_INCLUDE;
+	sg_cfg.rt_protocol = cfg->rt_protocol;
 	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
 }
 
@@ -982,7 +984,7 @@ static int br_mdb_add_group_star_g(const struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					cfg->filter_mode, RTPROT_STATIC);
+					cfg->filter_mode, cfg->rt_protocol);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
 		return -ENOMEM;
@@ -1193,6 +1195,14 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 		return -EINVAL;
 	}
 
+	if (mdb_attrs[MDBE_ATTR_RTPROT]) {
+		if (!cfg->p) {
+			NL_SET_ERR_MSG_MOD(extack, "Protocol cannot be set for host groups");
+			return -EINVAL;
+		}
+		cfg->rt_protocol = nla_get_u8(mdb_attrs[MDBE_ATTR_RTPROT]);
+	}
+
 	return 0;
 }
 
@@ -1212,6 +1222,7 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->filter_mode = MCAST_EXCLUDE;
+	cfg->rt_protocol = RTPROT_STATIC;
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 368f5f6fa42b..cdc9e040f1f6 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -106,6 +106,7 @@ struct br_mdb_config {
 	u8				filter_mode;
 	struct br_mdb_src_entry		*src_entries;
 	int				num_src_entries;
+	u8				rt_protocol;
 };
 #endif
 
-- 
2.37.3

