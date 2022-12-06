Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734EA6441B1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbiLFK71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiLFK7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:59:01 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA4323156
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:58:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEsXlnlibm27j571aPJd/pXfBZybTmdl4O3WgCOY6+9LxzvmyhjWi9Qaq1Iaf32fZpkRUhu/iS59D2q9Vawb4FgDTWpz/ZKxcXCqYO3eQ+/LUhEola2l5vRPNfhG+j1Mbo42le5RccofEPMiZUb5mnG0RgEeGHEXHMAgp1eHAiKabTEIfEdN1//ryGH3EJ2Q+vQXRUIpsM3qLspdIbvht3XOqZhp45PnIfVuYiXhfsr8ImA6lI++zM8f5DaHIsPrIOKG7N1Uz0hE/RYgtobk0jLutT870emgL2BQ8o8+ZxrQ1dz94VULh5NidZQ4AXg/b31wiPGTGcAYw+V3R7QnRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2WL7m/8ONJG969UU9V/sIbFR4k6LPwn/Nv7iM09AZg=;
 b=QTr5Vo/DHqvQ2bDidV6ni/ofCNJKJGkJ2nqLmsbuOqnBhOYJDbpXowZqz47feWKXdSVkkptImwpyM4um6iJ1znifPI46UGit5lZ/YfC9zfCOs1FbOqn/C+qNHDlEAzPzG0u9QTp/DuieGoFGdvvUiqaq5sKihwe5c5THXFqwrxKQIiR4jDpJ3xnAPQq/M2hM5P9hlsW/rvsu5vQ1DrEUAjoIHCdKhyb9PEW52+pAiH+gX/h2B5IiOrIo6RInLVxoNarmJ6O6e9ZxLp8Zueh6FGkDBiQf6aQNpdGn9GDhmchcPWgVVr2weGUokino89rlIO57CtZ2zLmgFE2gZ0+yZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2WL7m/8ONJG969UU9V/sIbFR4k6LPwn/Nv7iM09AZg=;
 b=S7UnT85H5R5QvEgk0Yndi4uBq2XptzRHYXH8kxqXieZUHdaA9K3+4T3XZyp/hu6tArT4cevaVvjtduIn1T8x6Fxbp8fj8/skTGAAI99zk66ppoA3L0hspBRdI4YUDgcGaqtrfiTAuDqYrRK4kMLrjMa4lwO5n6GM5JHtYaw4Bn4yxjvC/MT6fjFnGKVRGtwHB+cwaTOUn7gClg9vR9vs354Wg19tz6uqwLRAVl6Wq3jKJyA0XxZ2VJsWxi2pAwc+gIkLI7/GS5MEldlWih00JfDRFc/nio5GKAApwEsvv/kCpQ41UVRQcw6NtpHbV0uYKcll2e7wrikV0dKECWhNlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5131.namprd12.prod.outlook.com (2603:10b6:408:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 10:58:56 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:58:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 3/9] bridge: mcast: Use MDB configuration structure where possible
Date:   Tue,  6 Dec 2022 12:58:03 +0200
Message-Id: <20221206105809.363767-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0144.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::28) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f6c2558-8210-4c29-2865-08dad778de83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzYvOL7e4dyM5bQEL3jDfnpbux0yX1G8ceHLSN4JONyGGt99C6bhwDMQBp00qKVQeNaZ4d8FGsVl7I8JKeYZj1hKfluCjVTXlICjEe/wz0Vhlk29uxmdJXtgXq/1GA5FZF2Belkp0e1651JqS3CweNgFAQhiY6VIg4z81LR3QQeUUNlimjCNq+oSwNAfQxHYBTAEPYM5ivrqDyGkQq9Yntd8uI/stJqjhKxKJUtZxypoRTA2SOHNp+aMy1oi+DFIn7TEQRhml4FDtrsuPEafdtIdmgICldvsagW+04wM8nJyrHCvxyKtQqRkc7Glt8Bn8nQrdrbD6LIdFNUMhz2M0+NA/+O0gjHnDE480ToqrYgLeAL9a9nn1IpBBgujWi270bUQFa+o2NqiUkzZnZXO++JAykxXyHYcrheVTCVzkL3pAw7HkxwDg86RNyBb/ThkMrI01I8ipvaXemlmjTsYXGSZQg8X7aIJdeKllFaKbowdxkmauB99nXMTnEZrmikD8Ux8ZQbpYoH4eD3Hu0iLyTNPFl54S+iNc+X+VyZYYGH5Ma5exa3C2J5utcSHqlyETcOUdl6e7UNV4oxc9HwoZvvEXVL5zTavGVM9VRRVqevkaiqWhGGC6T5QvYXqnru22XlzORdBDIEQF04L/xIB+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36756003)(86362001)(38100700002)(6486002)(478600001)(6506007)(6512007)(26005)(186003)(107886003)(8676002)(6666004)(5660300002)(4326008)(2906002)(316002)(66556008)(41300700001)(8936002)(66476007)(66946007)(1076003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8jEAXBGDGRBL3Dko0VsPg9jIo3dfYmwXmIfAUTVOnaKs4LGZ7mU9UPlaoZzi?=
 =?us-ascii?Q?QMhFH/K9IPydX+j4STa1FYG6oFGfOcjKnEekPOX+0pcH4oikPvuRK8TrM4iv?=
 =?us-ascii?Q?MdA+O3/wje/4RwMRlmMoRAoTP5wc/x4g/uoMGoXyQVW+KqsuYTI2Wk2r62Ql?=
 =?us-ascii?Q?ONAoiYnfcsM4uHj+SdO/kmLHpDGsvzUArJPS7fRS4Qv/HMshd03Cg5Q0Ojwo?=
 =?us-ascii?Q?Elo48Uk2hxwZqNMbyc/8WCuY5X4MnsfmOKsjmLbCeiLj7VIVdvhfEopCb8EG?=
 =?us-ascii?Q?bjnLNiZJsMeXHP08TZXp/CwBoSlfhRjF150f7iEpdooZOX2gcZrHX++GJoD/?=
 =?us-ascii?Q?k1PbX0SmVq2wwKWi9/wOWhzJ3C5/1hSjEx3tUEW0xMxLDWWnGtnm/04mlYm6?=
 =?us-ascii?Q?XYEpRUCAH/jdBzqRs44D+ZcT1CBO0AoVM9yWFM+Wr6e1U7fvWRLbUdt0Di0z?=
 =?us-ascii?Q?sXniBxd4tXnO1vjgQJziuzTak57ExBmVmi1l29q+mLeZ8ahZhOqzwaLRIp+R?=
 =?us-ascii?Q?OBgvK2VhM4i3yC0la+r7WtIK/tb3kcrdKp0w2cYMXTAjTh37MjkF0+w+bjwz?=
 =?us-ascii?Q?JpYhEv+3pi9C69trER2BjDRSN6x8BUNkeQZp5fWVZX/AyHDv7RmZ46wSRf6U?=
 =?us-ascii?Q?Ma5wXizF4206BlQTaiY9SQqwT0kEY6frsTUgdzzhhKQZ+XRou59skb2IToq+?=
 =?us-ascii?Q?KVdhD/zrZoyWxHFgHL5nK1PT8eSfCpZBEeqgWZKbi4GBwUw+yS7jGULC1Tb6?=
 =?us-ascii?Q?9dmzTjciJ5+Z8rOAalT9i/irmopbyQE0UM8NlGMgW5vYuegb5hUmTq6nXmqT?=
 =?us-ascii?Q?IVWbQWNbCcgizBXj5rdWgkmgXGpoqOTLuHFHqLbLF2iCQyNqcdJbDKRPCiNt?=
 =?us-ascii?Q?kDMCqrWSz4NfNuPutc8V+7h0FVdGuJXgEJ8rkOBD3RyFmRp88/gdkFvccsE3?=
 =?us-ascii?Q?Xqw7+8X/6sJwrPSl8VcScdcLLbGeqPnUXhj85d3sx/BAAkpKZcbqGSCoe25E?=
 =?us-ascii?Q?2KJ3LWFQqvLfkR6n163y0TjLSZ/1C6FhlznBV3TcigXh2uvQxUjkscz4IREY?=
 =?us-ascii?Q?Z7s7kbSO8W2xGoubX8WA68nduVTk7PGjffYO7u1raEd3AWFmNyeq4MLj9Civ?=
 =?us-ascii?Q?4CPFxhIu0NJ6E51ulw3uOrMXvnisVR3xJbUJBdb+xy5Pcn4LLOSmOMISl1Pd?=
 =?us-ascii?Q?H2FAHcFtnougmmSmUcelwjzByt0CSRJ9jgKQK30yIVEJ77m86Pj+PGbPlIdP?=
 =?us-ascii?Q?ekV2jhnPSH/D+sJ/xqmNU4m0K2F0kU4AdywF/wV8pOsA7at38/ESRXrYchhv?=
 =?us-ascii?Q?LCmhpDvvztAnU6imSdckwH9uoBqbvNoReukZIhxpFN4I5fBnOvV89IeH7mip?=
 =?us-ascii?Q?eHdacI3dalD4jOXs4/4qiSSfrtEsKFHXtSGI+9L+NcJ/OLhAcWT+cbzQIa0n?=
 =?us-ascii?Q?UEH80N8Am9vlTwvDqoAHOeTL9W2wvJH4xAhF63np8utlTFrtAesR8/kGL7WS?=
 =?us-ascii?Q?sQ7SZ9xqsg9TR5X1YvH2JpuO80lX/TUuj6xwXRsR0oKanSdUpe9LFnG4KBp1?=
 =?us-ascii?Q?BIV5vXSGN2VZ137bmDm4YIu4ojwZKfN8hUrxlP6A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6c2558-8210-4c29-2865-08dad778de83
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:58:55.6937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mF+VRy0Z81s4RT+GguKfY20si5iqmeo4pnZfYLSXmnqbctLdVazQZFDbU4qiN1/Lul2CrjGGYwcf2TPV3UP79Q==
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

The MDB configuration structure (i.e., struct br_mdb_config) now
includes all the necessary information from the parsed RTM_{NEW,DEL}MDB
netlink messages, so use it.

This will later allow us to delete the calls to br_mdb_parse() from
br_mdb_add() and br_mdb_del().

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index c8d78e4ec94e..080516a3ee9c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1094,7 +1094,6 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	struct net_device *dev;
-	struct net_bridge *br;
 	int err;
 
 	err = br_mdb_config_init(net, nlh, &cfg, extack);
@@ -1105,30 +1104,30 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	br = netdev_priv(dev);
-
-	if (entry->ifindex != br->dev->ifindex) {
-		if (cfg.p->state == BR_STATE_DISABLED && entry->state != MDB_PERMANENT) {
+	if (cfg.p) {
+		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
 			return -EINVAL;
 		}
 		vg = nbp_vlan_group(cfg.p);
 	} else {
-		vg = br_vlan_group(br);
+		vg = br_vlan_group(cfg.br);
 	}
 
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * install mdb entry on all vlans configured on the port.
 	 */
-	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			entry->vid = v->vid;
-			err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
+			cfg.entry->vid = v->vid;
+			err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry,
+					   mdb_attrs, extack);
 			if (err)
 				break;
 		}
 	} else {
-		err = __br_mdb_add(net, br, cfg.p, entry, mdb_attrs, extack);
+		err = __br_mdb_add(net, cfg.br, cfg.p, cfg.entry, mdb_attrs,
+				   extack);
 	}
 
 	return err;
@@ -1186,7 +1185,6 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	struct net_device *dev;
-	struct net_bridge *br;
 	int err;
 
 	err = br_mdb_config_init(net, nlh, &cfg, extack);
@@ -1197,23 +1195,21 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err < 0)
 		return err;
 
-	br = netdev_priv(dev);
-
-	if (entry->ifindex != br->dev->ifindex)
+	if (cfg.p)
 		vg = nbp_vlan_group(cfg.p);
 	else
-		vg = br_vlan_group(br);
+		vg = br_vlan_group(cfg.br);
 
 	/* If vlan filtering is enabled and VLAN is not specified
 	 * delete mdb entry on all vlans configured on the port.
 	 */
-	if (br_vlan_enabled(br->dev) && vg && entry->vid == 0) {
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
 		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			entry->vid = v->vid;
-			err = __br_mdb_del(br, entry, mdb_attrs);
+			cfg.entry->vid = v->vid;
+			err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
 		}
 	} else {
-		err = __br_mdb_del(br, entry, mdb_attrs);
+		err = __br_mdb_del(cfg.br, cfg.entry, mdb_attrs);
 	}
 
 	return err;
-- 
2.37.3

